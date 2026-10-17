#!/usr/bin/env bash
set -u
cd "$(dirname "$0")"

mkdir -p build programs
moves=(rock paper scissors)

emit() {
    printf '%08X\n' "$1" >> programs/rps.hex
}

addi() {
    local rd=$1 rs=$2 imm=$3
    emit "$(( ((imm & 0xfff) << 20) | (rs << 15) | (rd << 7) | 0x13 ))"
}

beq() {
    local rs1=$1 rs2=$2 off=$3
    emit "$(( ((off >> 12 & 1) << 31) |
        ((off >> 5 & 0x3f) << 25) |
        (rs2 << 20) | (rs1 << 15) |
        ((off >> 1 & 0xf) << 8) |
        ((off >> 11 & 1) << 7) | 0x63 ))"
}

jal() {
    local rd=$1 off=$2
    emit "$(( ((off >> 20 & 1) << 31) |
        ((off >> 1 & 0x3ff) << 21) |
        ((off >> 11 & 1) << 20) |
        ((off >> 12 & 0xff) << 12) |
        (rd << 7) | 0x6f ))"
}

write_program() {
    local player=$1 cpu=$2
    : > programs/rps.hex

    addi 1 0 "$player"
    addi 2 0 "$cpu"
    beq 1 2 64
    addi 5 0 0
    beq 1 5 20
    addi 5 0 1
    beq 1 5 24
    addi 5 0 2
    beq 1 5 28
    addi 5 0 2
    beq 2 5 40
    jal 0 44
    addi 5 0 0
    beq 2 5 28
    jal 0 32
    addi 5 0 1
    beq 2 5 16
    jal 0 20
    addi 3 0 0
    jal 0 16
    addi 3 0 1
    jal 0 8
    addi 3 0 -1
    jal 0 0
}

if ! iverilog -g2012 -s rps_tb -o build/rps_sim \
    rtl/*.sv tb/rps_tb.sv 2>build/rps_compile.log; then
    cat build/rps_compile.log
    exit 1
fi

play_round() {
    local player=$1 cpu=$2 expected result output

    write_program "$player" "$cpu"

    if ! output=$(vvp build/rps_sim 2>&1); then
        echo "$output"
        return 1
    fi

    result=$(printf '%s\n' "$output" |
        sed -n 's/^RPS_RESULT=//p' | tail -n 1)

    if [[ "$player" == "$cpu" ]]; then
        expected=0
    elif (( (player - cpu + 3) % 3 == 1 )); then
        expected=1
    else
        expected=-1
    fi

    if [[ "$result" != "$expected" ]]; then
        echo "FAIL: ${moves[$player]} vs ${moves[$cpu]}"
        echo "Expected $expected, got ${result:-missing}"
        echo "$output"
        return 1
    fi

    echo "${moves[$player]} vs ${moves[$cpu]} -> $result"
}

case "${1:---play}" in
    --test)
        echo "Testing all 9 RPS matchups..."
        count=0
        for player in 0 1 2; do
            for cpu in 0 1 2; do
                if ! play_round "$player" "$cpu"; then
                    exit 1
                fi
                count=$((count + 1))
            done
        done
        echo
        echo "ALL $count MATCHUPS PASSED"
        ;;

    --play)
        read -r -p "Your move (rock/paper/scissors): " move
        move="${move,,}"

        case "$move" in
            rock) player=0 ;;
            paper) player=1 ;;
            scissors) player=2 ;;
            *) echo "Invalid move."; exit 1 ;;
        esac

        cpu=$((RANDOM % 3))
        echo "You: ${moves[$player]}"
        echo "ARC-01 opponent: ${moves[$cpu]}"

        if ! play_round "$player" "$cpu"; then
            exit 1
        fi

        case "$(( (player - cpu + 3) % 3 ))" in
            0) echo "DRAW!" ;;
            1) echo "YOU WIN!" ;;
            2) echo "ARC-01 WINS!" ;;
        esac
        ;;

    *)
        echo "Usage: ./run_rps.sh [--play|--test]"
        exit 2
        ;;
esac
