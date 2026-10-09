# ARC-01

ARC-01 is an open-source 32-bit RISC-V processor built from scratch in SystemVerilog.

The project develops a processor from individual hardware components into an integrated, simulation-tested CPU.

## Goals

* RV32I-compatible processor
* 32-bit architecture with 32 general-purpose registers
* Synthesizable SystemVerilog RTL
* Simulation-based verification
* FPGA implementation
* Long-term ASIC exploration

## Architecture

ARC-01 consists of the following hardware components:

1. Arithmetic Logic Unit (ALU)
2. Register file
3. Program counter
4. Instruction memory
5. Instruction decoder
6. Control unit
7. Immediate generator
8. Data memory
9. CPU datapath

## Instruction Support

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

ARC-01 is tested using SystemVerilog testbenches at both component and CPU levels.

Verified components include:

* ALU
* Register file
* Program counter
* Instruction decoder
* Control unit
* Immediate generator
* Instruction memory
* Data memory

CPU-level tests cover arithmetic, logical and shift operations, signed and unsigned comparisons, conditional branches, jumps, load/store operations, and immediate instructions.

The CPU has also been tested with machine-code programs that perform calculations using register-based execution.

## Calculator Interface

ARC-01 includes a Bash-based terminal interface for entering integer values and running arithmetic programs on the simulated CPU.

The interface generates RISC-V machine code, launches the Icarus Verilog simulation, and displays the resulting register values.

Bash and other programming languages may be used for interfaces, tooling, automation, testing, and software support. The processor's hardware logic and instruction execution are implemented in SystemVerilog.

## Technology Stack

* SystemVerilog — processor hardware and datapath
* Icarus Verilog — compilation and simulation
* Bash — terminal interface and simulation automation
* Git and GitHub — version control and project hosting

## Repository Structure

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
├── programs/
│   └── math.hex
├── run_math.sh
├── README.md
└── LICENSE
```

## License

ARC-01 is open source under the MIT License.
