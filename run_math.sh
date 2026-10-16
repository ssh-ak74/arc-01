
#!/usr/bin/env bash
set -e

cd "$(dirname "$0")"

echo "================================"
echo "       ARC-01 CALCULATOR"
echo "================================"

read -r -p "Enter first number: " a
read -r -p "Operation (+ or -): " op
read -r -p "Enter second number: " b

# Validate integer input.
if [[ ! "$a" =~ ^-?[0-9]+$ || ! "$b" =~ ^-?[0-9]+$ ]]; then
    echo "Error: enter whole numbers."
    exit 1
fi

# Validate the requested operation.
if [[ "$op" != "+" && "$op" != "-" ]]; then
    echo "Error: operation must be + or -."
    exit 1
fi

# Parse decimal input, including leading zeros.
parse_decimal() {
    local n="$1"

    if [[ "$n" == -* ]]; then
        REPLY=$(( -(10#${n#-}) ))
    else
        REPLY=$(( 10#$n ))
    fi
}

parse_decimal "$a"
a=$REPLY

parse_decimal "$b"
b=$REPLY

# ADDI uses a signed 12-bit immediate.
if (( a < -2048 || a > 2047 ||
      b < -2048 || b > 2047 )); then
    echo "Error: numbers must be between -2048 and 2047."
    exit 1
fi

# Encode: ADDI rd, x0, immediate.
encode_addi() {
    local rd="$1"
    local value="$2"
    local imm=$(( value & 0xFFF ))

    printf '%08X\n' "$(( (imm << 20) | (rd << 7) | 0x13 ))"
}

mkdir -p programs

{
    # ADDI x1, x0, a
    encode_addi 1 "$a"

    # ADDI x2, x0, b
    encode_addi 2 "$b"

    # Execute ADD or SUB on ARC-01.
    if [[ "$op" == "+" ]]; then
        # ADD x3, x1, x2
        printf '%08X\n' $((0x002081B3))
    else
        # SUB x3, x1, x2
        printf '%08X\n' $((0x402081B3))
    fi
} > programs/math.hex

echo
echo "Machine code generated."
echo "Starting ARC-01 simulation..."
echo

iverilog -g2012 -o arc01_cpu_tb rtl/*.sv tb/arc01_cpu_tb.sv

output=$(vvp arc01_cpu_tb)
printf '%s\n' "$output"

result=$(printf '%s\n' "$output" |
    sed -n 's/^x3 = //p')

if [[ -z "$result" ]]; then
    echo "Error: could not read x3 from simulation."
    exit 1
fi

echo
echo "ARC-01 RESULT: $a $op $b = $result"
