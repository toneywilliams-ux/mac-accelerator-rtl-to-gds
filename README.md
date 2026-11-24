# 16-bit Signed MAC Accelerator — RTL to GDSII

## Project Overview

This project focuses on the RTL design, functional verification, synthesis, physical implementation, and analysis of a 16-bit signed Multiply-Accumulate (MAC) accelerator.

The multiplier architecture uses Radix-4 Booth encoding and a Carry-Save Adder (CSA) compression tree. Two MAC architectures are investigated: a conventional MAC and a two-stage pipelined MAC.

The physical implementation target is the SKY130HD standard-cell platform using the OpenROAD-flow-scripts (ORFS) toolchain.

## Design Specifications

| Parameter | Specification |
|---|---|
| Multiplier input width | 16 bits |
| Multiplier output width | 32 bits |
| Accumulator width | 64 bits |
| Multiplication algorithm | Radix-4 Booth |
| Partial-product reduction | CSA tree |
| MAC architectures | Conventional and pipelined |
| Target PDK | SKY130HD |
| Synthesis | Yosys |
| Physical design | OpenROAD |
| Static timing analysis | OpenSTA |

## Project Objectives

1. Develop a modular signed Radix-4 Booth multiplier.
2. Implement and verify a 64-bit signed MAC.
3. Develop a pipelined MAC architecture.
4. Perform functional verification using directed and randomized testbenches.
5. Synthesize the RTL using SKY130HD standard cells.
6. Complete floorplanning, placement, clock tree synthesis, and routing.
7. Analyze timing, area, and power.
8. Generate and inspect the final GDSII layout.
9. Document design decisions, debugging, and implementation results.

## Repository Structure

- `rtl/` — RTL source code.
- `verification/` — Testbenches, reference models, and test vectors.
- `constraints/` — Timing constraints.
- `physical_design/` — Physical implementation configuration and reports.
- `results/` — Synthesis and implementation results.
- `docs/` — Architecture and methodology documentation.
- `debug_logs/` — Debugging records.
- `scripts/` — Automation scripts.

## Development Status

| Stage | Status |
|---|---|
| 16-bit Booth multiplier | Functionally verified |
| Conventional 16-bit MAC | Functionally verified |
| Pipelined 16-bit MAC | Functionally verified |
| Docker environment | Configured |
| ORFS installation | In progress |
| SKY130HD implementation | Pending |
| RTL synthesis | Pending |
| Physical implementation | Pending |
| GDSII generation | Pending |
| PPA analysis | Pending |

## Documentation

Detailed architecture, verification methodology, debugging history, and physical implementation results will be maintained in `docs/`.

## Important Note

Physical-design metrics and final implementation results will be reported only after they have been generated and verified using the actual EDA flow.