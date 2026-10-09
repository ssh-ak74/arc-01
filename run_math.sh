
#!/usr/bin/env bash
set -e

cd "$(dirname "$0")"

echo "================================"
echo "       ARC-01 CALCULATOR"
echo "================================"

read -r -p "Enter first number: " a
read -r -p "Enter second number: " b

# Validate integer input.
if [[ ! "$a" =~ ^-?[0-9]+$ || ! "$b" =~ ^-?[0-9]+$ ]]; then
    echo "Error: enter whole numbers."
    exit 1
fi

# Parse input as decimal, including leading zeros.
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
    encode_addi 1 "$a"
    encode_addi 2 "$b"
    # ADD x3, x1, x2
    printf '%08X\n' $((0x002081B3))
} > programs/math.hex

echo
echo "Machine code loaded. Starting ARC-01..."
echo

iverilog -g2012 -o arc01_cpu_tb rtl/*.sv tb/arc01_cpu_tb.sv

output=$(vvp arc01_cpu_tb)
printf '%s\n' "$output"

result=$(printf '%s\n' "$output" |
    sed -n 's/^x3 = //p')

if [[ -n "$result" ]]; then
    echo
    echo "ARC-01 RESULT: $a + $b = $result"
else
    echo "Could not read x3. Check the simulation output."
    exit 1
fi