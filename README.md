# Star Battle Prolog Solver

[![Language](https://img.shields.io/badge/Language-SWI--Prolog-blue.svg)](https://www.swi-prolog.org/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

Automated solver for the **Star Battle** (also known as *Two Not Touch*) combinatorial logic puzzle, written in SWI-Prolog using declarative pattern matching, deductive heuristics, and constraint propagation.

Developed as part of the **Lógica para Programação (LP)** curriculum at **Instituto Superior Técnico (IST), Universidade de Lisboa**.

---

## Overview

Star Battle is a grid-based puzzle played on an $N \times N$ board divided into $N$ contiguous, irregularly shaped regions.

### Puzzle Rules
1. **Star Quota:** Exactly 2 stars (`e`) must be placed in each row, each column, and each irregular region.
2. **Non-Adjacency Constraint:** Stars cannot be adjacent to each other in any direction (orthogonal or diagonal). Every star must be completely isolated by non-star cells, represented as points (`p`).
3. **Representation:** Unassigned board cells are modeled as unbound Prolog logic variables. As deductions occur, variables are instantiated to either `e` (star) or `p` (point).

```text
+---+---+---+---+---+---+
| . | * | . | . | * | . |   <- Exactly 2 stars per row
+---+---+---+---+---+---+
| . | . | . | * | . | . |
+---+---+---+---+---+---+
| * | . | . | . | . | * |
+---+---+---+---+---+---+
   ^
   No two stars touch, even diagonally
```

---

## Architecture and Heuristics

The solver operates entirely through deterministic logic deduction, avoiding expensive brute-force search by iteratively applying sound constraint propagation rules until a fixed point is reached.

### 1. Deductive Heuristics (`fechaListaCoordenadas/2`)

For each coordinate group (row, column, or region):

| Heuristic | Condition | Action |
| :--- | :--- | :--- |
| **H1** (`h1/2`) | The group contains 2 stars (`NumEstrelas = 2`). | All remaining unassigned variables in the group are instantiated to points (`p`). |
| **H2** (`h2/2`) | The group contains 1 star and 1 unassigned variable (`NumEstrelas = 1`, `NumVars = 1`). | The variable is instantiated to a star (`e`), and points (`p`) are placed around all 8 surrounding neighbors. |
| **H3** (`h3/2`) | The group contains 0 stars and 2 unassigned variables (`NumEstrelas = 0`, `NumVars = 2`). | Both variables are instantiated to stars (`e`), and points (`p`) are placed around all their neighbors. |

### 2. Geometric Pattern Inference (`aplicaPadroes/2`)

The solver inspects contiguous unassigned variable sequences to detect forced placements:
- **Pattern I (`aplicaPadraoI/2`):** Identifies 3-cell linear segments $[C_1, C_2, C_3]$. To satisfy the 2-star quota without adjacent contact, stars must reside at the extremities ($C_1$ and $C_3$), forcing $C_2$ and all adjacent neighbors to become points (`p`).
- **Pattern T (`aplicaPadraoT/2`):** Identifies 4-cell contiguous formations and eliminates impossible configurations across intersecting boundaries.

### 3. Fixed-Point Convergence (`resolve/2`)

```text
+-------------------------------------------------------------+
|                       resolve(E, Tab)                       |
+-------------------------------------------------------------+
                              |
                              v
                  [Capture Current Variables]
                              |
                              v
                   [Apply Geometric Patterns]
                   (aplicaPadroes/2: I & T)
                              |
                              v
                  [Apply Deductive Closures]
                   (fecha/2: H1, H2, H3)
                              |
                              v
                     [Check Variable Delta]
                      /                  \
            Vars Changed?              Fixed Point Reached
                 |                               |
                 v                               v
         [Recurse resolve]                   [Terminate]
```

---

## Repository Structure

```text
star-battle-prolog/
├── src/
│   ├── projecto.pl          # Core solver logic, heuristics, and resolution loop
│   ├── codigoAuxiliar.pl    # Grid transposition, coordinate generators, and pattern T
│   └── puzzles.pl           # Test puzzle benchmarks (various grid sizes and regions)
├── tests/
│   └── test_solver.pl       # Automated unit test suite using PlUnit
├── Makefile                 # Test runner and REPL launcher
├── .gitignore
├── LICENSE                  # MIT License
└── README.md
```

---

## Getting Started

### Prerequisites

Install [SWI-Prolog](https://www.swi-prolog.org/):

```bash
# Ubuntu / Debian
sudo apt-get install swi-prolog

# macOS
brew install swi-prolog
```

### Running Tests

Execute the full PlUnit test suite:

```bash
make test
```

Or invoke SWI-Prolog directly:

```bash
cd src && swipl -l projecto.pl -g run_tests -t halt ../tests/test_solver.pl
```

### Interactive REPL

Start an interactive SWI-Prolog shell with all solver modules loaded:

```bash
make repl
```

To solve a sample puzzle interactively:

```prolog
?- regioes(9-2, E), inicial(9, Tab), resolve(E, Tab), visualiza(Tab).
```

---

## Known Limitations

* **Deterministic Deduction Boundary:** The resolution engine relies strictly on deterministic deductive closures (H1-H3) and geometric patterns (I and T); difficult puzzle configurations that require speculative branch guessing cannot be resolved if the deduction pipeline reaches a fixed point prematurely.
* **Fixed 2-Star Formulation:** Heuristic patterns are formulated specifically for 2-star requirements ($N \times N$ with 2 stars per row/column/region) and do not generalize directly to arbitrary $k$-star variations without rule reconfiguration.

---

## Credits

* **David Vasques** ([@DeastV](https://github.com/DeastV))
* Individual coursework developed for Lógica para Programação (LP) at Instituto Superior Técnico, Universidade de Lisboa. Auxiliary coordinate predicates (`src/codigoAuxiliar.pl`) and puzzle benchmarks (`src/puzzles.pl`) provided by the teaching staff.
