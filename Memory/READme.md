# 💾 Verilog Memory Design & Testbench

This project implements a **synchronous memory module** and its **comprehensive testbench** in **Verilog HDL**.  
It supports multiple test scenarios like single/multiple read-write operations, walking ones/zeros patterns, and backdoor memory access using external files.

---

## 🧠 Overview

The **Memory module** is a parameterized synchronous design supporting configurable `WIDTH` and `DEPTH`.  
The **Testbench** verifies the memory’s functionality through various automated testcases, ensuring correctness and robustness.

This design is written using standard Verilog syntax and verified using multiple scenarios to ensure reliable memory behavior under all test conditions.

---

## ⚙️ Features

✅ Parameterized design (`WIDTH`, `DEPTH`)  
✅ Synchronous Reset and Clock operation  
✅ Read/Write operations with valid/ready handshake  
✅ Automated testbench with reusable Verilog tasks  
✅ Supports front-door and back-door memory access  
✅ Walking Ones/Zeros data and address test patterns  
✅ Plusarg (`+testcase=<name>`) support for dynamic testcase selection  
✅ Compatible with Icarus Verilog, ModelSim, and QuestaSim  

---

## 🧩 Memory Module Description

**File:** `memory.v`

### Parameters:
| Parameter | Description | Default |
|------------|-------------|----------|
| WIDTH | Data width (bits) | 8 |
| DEPTH | Number of memory locations | 16 |
| ADDR | Address width (`log2(DEPTH)`) | calculated |

### I/O Ports:
| Port | Direction | Description |
|------|------------|-------------|
| clk_i | Input | Clock signal |
| rst_i | Input | Reset (active high) |
| wr_rd_i | Input | 1 → Write, 0 → Read |
| valid_i | Input | Indicates valid operation |
| addr_i | Input | Memory address |
| wdata_i | Input | Write data |
| rdata_o | Output | Read data |
| ready_o | Output | Indicates memory ready |

---

## 🧪 Testbench Description

**File:** `memory_tb.v`

The testbench verifies the memory functionality through a series of predefined testcases.  
It uses parameterized tasks and plusargs to select specific tests dynamically during simulation.

### Main Tasks:
- `reset_mem()` → Initializes memory and signals  
- `write_mem(start, end)` → Writes random data to memory  
- `read_mem(start, end)` → Reads data from memory  
- `mem_bd_write()` → Loads data from `data.hex` file  
- `mem_bd_read()` → Dumps memory contents to `output.bin`  
- `walking_ones()` / `walking_zeros()` → Data pattern tests  
- `walking_addr_ones()` / `walking_addr_zeros()` → Address pattern tests  

---

## 🧾 Supported Testcases

| Testcase Name | Description |
|----------------|-------------|
| `mem_1w_1r` | Single write and single read |
| `mem_5w_5r` | Five writes followed by five reads |
| `mem_1w` | Single write only |
| `mem_5w` | Five writes only |
| `mem_write` | Write entire memory |
| `mem_full_wr_rd` | Full write followed by full read |
| `mem_1/4_write_read` | Write/Read one-fourth of memory |
| `mem_half_write_read` | Write/Read half of memory |
| `mem_3/4_write_read` | Write/Read three-fourths of memory |
| `mem_3/4_wr_rd_only` | Partial memory write and read |
| `test_fd_write_fd_read` | Full front-door write/read |
| `test_bd_write_bd_read` | Full back-door write/read |
| `test_bd_write_fd_read` | Back-door write, front-door read |
| `test_fd_write_bd_read` | Front-door write, back-door read |
| `test_data_walking_ones` | Data walking ones pattern |
| `test_data_walking_zeros` | Data walking zeros pattern |
| `test_addr_walking_ones` | Address walking ones pattern |
| `test_addr_walking_zeros` | Address walking zeros pattern |

---

## ▶️ How to Run Simulation

Follow these steps in **ModelSim / QuestaSim** to compile and simulate the memory testbench:

```tcl
vlib work
vlog memory_tb.v
vsim top +testcase=test_data_walking_ones
add wave -position insertpoint sim:/top/dut/*
run -all
