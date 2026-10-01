# ARC-01

ARC-01 is an open-source 32-bit RISC-V processor built from scratch in SystemVerilog.

## Goals

- RV32I compatible
- 32-bit architecture
- 32 general-purpose registers
- Synthesizable RTL
- Simulation-tested
- FPGA-ready
- Eventually ASIC-capable

## Architecture

ARC-01 is being developed from the hardware up:

1. ALU
2. Register file
3. Program counter
4. Instruction decoder
5. Control unit
6. Memory interface
7. CPU datapath
8. RV32I instruction support
9. Verification
10. FPGA implementation

## Repository

```text
rtl/    Hardware implementation
tb/     Simulation testbenches