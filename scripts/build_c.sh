#!/usr/bin/env bash
set -euo pipefail

SRC="${1:-programs/first.c}"

if [[ ! -f "$SRC" ]]; then
    echo "ERROR: C source not found: $SRC"
    exit 1
fi

NAME="$(basename "${SRC%.c}")"
mkdir -p build

ELF="build/${NAME}.elf"
BIN="build/${NAME}.bin"
HEX="programs/${NAME}.hex"

echo "[1/3] Compiling $SRC..."

riscv32-unknown-elf-gcc \
    -march=rv32i \
    -mabi=ilp32 \
    -O2 \
    -ffreestanding \
    -fno-builtin \
    -nostdlib \
    -Wl,-Ttext=0x0 \
    -Wl,--entry=main \
    -Wl,--build-id=none \
    "$SRC" -o "$ELF"

echo "[2/3] Extracting machine code..."

riscv32-unknown-elf-objcopy \
    -O binary \
    --only-section=.text \
    "$ELF" "$BIN"

SIZE="$(wc -c < "$BIN")"

if (( SIZE == 0 || SIZE % 4 != 0 )); then
    echo "ERROR: .text size must be a nonzero multiple of 4 bytes."
    exit 1
fi

echo "[3/3] Generating $HEX..."

od -An -v -t x4 "$BIN" |
    awk '{for (i=1; i<=NF; i++) print toupper($i)}' > "$HEX"

echo
echo "BUILD PASS"
echo "ELF: $ELF"
echo "BIN: $BIN"
echo "HEX: $HEX"
echo
echo "Instructions:"
cat "$HEX"
