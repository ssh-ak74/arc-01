# ARC-01

ARC-01 is an open-source 32-bit RISC-V processor built from scratch in SystemVerilog.

The project is developed from the hardware up, starting with individual RTL components and gradually integrating them into a functional processor.

## Goals

* RV32I-compatible processor
* 32-bit architecture
* 32 general-purpose registers
* Synthesizable SystemVerilog RTL
* Simulation-tested
* FPGA-ready
* Eventually ASIC-capable

## Architecture

ARC-01 is built from the following hardware components:

1. ALU
2. Register file
3. Program counter
4. Instruction memory
5. Instruction decoder
6. Control unit
7. Immediate generator
8. Data memory
9. CPU datapath

## Current Progress

### Integer Operations

* ADD
* SUB
* AND
* OR
* XOR
* SLL
* SRL
* SRA
* SLT
* SLTU

### Immediate Operations

* ADDI
* SLTI
* SLTIU
* ANDI
* ORI
* XORI
* SLLI
* SRLI
* SRAI

### Branch Instructions

* BEQ
* BNE
* BLT
* BGE
* BLTU
* BGEU

### Control Flow

* JAL
* JALR

### Memory Operations

* LW
* SW

### Upper Immediate

* LUI
* AUIPC

## Verification

ARC-01 is verified using SystemVerilog simulation testbenches at both component and CPU levels.

Verified hardware components include:

* ALU
* Register file
* Program counter
* Instruction decoder
* Control unit
* Immediate generator
* Instruction memory
* Data memory

CPU-level verification currently covers:

* Arithmetic operations
* Logical operations
* Shift operations
* Signed comparisons
* Unsigned comparisons
* Conditional branches
* Jumps
* Load/store operations
* Upper-immediate operations
* Immediate ALU operations

## Repository

```text
arc-01/
├── rtl/
│   ├── alu.sv
│   ├── arc01.sv
│   ├── regfile.sv
│   ├── pc.sv
│   ├── decoder.sv
│   ├── control.sv
│   ├── immgen.sv
│   ├── memory.sv
│   └── imem.sv
│
├── tb/
│   ├── arc01_tb.sv
│   ├── regfile_tb.sv
│   ├── pc_tb.sv
│   ├── decoder_tb.sv
│   ├── control_tb.sv
│   ├── immgen_tb.sv
│   ├── memory_tb.sv
│   ├── arc01_cpu_tb.sv
│   └── imem_tb.sv
│
├── README.md
└── LICENSE
```

## Development

ARC-01 is currently developed and tested using:

* SystemVerilog
* Icarus Verilog
* Git
* GitHub

Each major hardware component has its own testbench, while CPU-level tests verify complete instruction execution through the processor datapath.

## Roadmap

The project will continue toward:

* Complete RV32I support
* Expanded verification
* Exception and interrupt handling
* UART and GPIO peripherals
* FPGA implementation
* Software support
* Performance testing
* Future ISA extensions
* Pipelined architecture
* ASIC exploration

## License

ARC-01 is open source under the MIT License.
