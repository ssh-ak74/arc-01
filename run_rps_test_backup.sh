#!/usr/bin/env bash

set -u
cd "$(dirname "$0")"

mkdir -p build programs

moves=(rock paper scissors)

echo
echo "================================"
echo "       ARC-01: RPS"
echo "================================"
echo

read -r -p "Your move (rock/paper/scissors): " move
move="${move,,}"

case "$move" in
    rock)     player=0 ;;
    paper)    player=1 ;;
    scissors) player=2 ;;
    *)
        echo "Invalid move. Type rock, paper, or scissors."
        exit 1
        ;;
esac

cpu=$((RANDOM % 3))

# ADDI x1,x0,player and ADDI x2,x0,cpu.
printf '%08X\n%08X\n' \
    "$(((player << 20) | 0x093))" \
    "$(((cpu << 20) | 0x113))" > programs/rps.hex

# Remaining instructions implement the game's decisions.
cat >> programs/rps.hex <<'PROGRAM'
02208E63
00008C63
00100213
02408063
02410A63
FFF00193
0300006F
00200213
02410263
FFF00193
0200006F
00000213
00410A63
FFF00193
0100006F
00000193
0080006F
00100193
00000013
PROGRAM

echo
echo "You chose: ${moves[$player]}"
echo "ARC-01's opponent chose: ${moves[$cpu]}"
echo

if ! iverilog -g2012 -s rps_tb -o build/rps_sim \
    rtl/*.sv tb/rps_tb.sv 2>build/rps_compile.log; then
    cat build/rps_compile.log
    echo "Compilation failed."
    exit 1
fi

if ! output=$(vvp build/rps_sim 2>&1); then
    echo "$output"
    echo "CPU simulation failed."
    exit 1
fi

echo "$output"

result=$(printf '%s\n' "$output" |
    sed -n 's/^RPS_RESULT=//p' | tail -n 1)

case "$result" in
    1)  echo "YOU WIN! ARC-01 declares you the winner." ;;
    0)  echo "DRAW! You both chose the same move." ;;
    -1) echo "ARC-01 WINS! Better luck next round." ;;
    *)
        echo "Could not read the CPU's result."
        exit 1
        ;;
esac
