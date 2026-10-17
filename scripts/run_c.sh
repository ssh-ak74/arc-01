#!/usr/bin/env bash
set -euo pipefail

SRC="${1:-programs/first.c}"

./scripts/build_c.sh "$SRC"

iverilog -g2012 -o build/arc01_c_test \
  rtl/arc01.sv rtl/alu.sv rtl/regfile.sv rtl/pc.sv \
  rtl/decoder.sv rtl/control.sv rtl/immgen.sv \
  rtl/imem.sv rtl/memory.sv tb/arc01_c_tb.sv

vvp build/arc01_c_test
