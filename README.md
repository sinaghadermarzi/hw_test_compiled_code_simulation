# hw_test_compiled_code_simulation
compiled code simulation of a logical circuit

A gate-level netlist is turned into straight-line C++ code (one assignment per gate, in levelized order),
which is compiled together with a small driver and run against a set of input vectors.

## Files

- `Generate_CCX.m` - MATLAB function. Reads a netlist, levelizes it and writes `prop.h` (net labels, primary
  input indices and a `propagate()` function).
- `CC_main.cpp` - driver. Reads the input vectors, applies each one to the primary inputs, calls `propagate()`
  and writes every net value to `log.txt`.
- `gates.h` - gate primitives (`AND2`, `OR2`) used by `prop.h`.
- `prop.h` - the generated header for the example circuit in `NetList.txt` (checked in so the driver builds
  without MATLAB).
- `NetList.txt` - example netlist, one gate per line: `GATE in1 in2 out` (whitespace separated, the last
  column is the output net).
- `Vectors.txt` - example input vectors, one per line: `@<time> <bits>`, one bit per primary input, in the
  order listed in `PI[]` in `prop.h` (`x` or any other character is treated as unknown, -1).
- `Makefile` - builds the driver with `g++`.
- `CC_Simulate(VisualC++_Project)/` - the original Visual Studio 2010 project (with its build output). Its copy
  of `CC_main.cpp` reads `thefile.txt` instead of `vectors.txt`.

## Usage

The MATLAB m file contains a Generate_CCX function.
Invoking the function with a string argument containing the netlist file path will generate a "prop.h" file
for that circuit:

```matlab
Generate_CCX('NetList.txt')
```

Then compile and build "CC_main.cpp" with this new header file:

```sh
make            # g++ -std=c++11 -Wall -o cc_simulate CC_main.cpp
```

The resulting binary reads a vector file named `vectors.txt` (lowercase; the example file is `Vectors.txt`,
so copy or rename it on a case-sensitive file system) from the current directory and writes the simulated
net values for each input vector to `log.txt`:

```sh
make run        # copies Vectors.txt to vectors.txt if needed, then runs ./cc_simulate
```

The program waits for a key press before exiting.

## Caveats

- The checked-in `prop.h` differs from what `Generate_CCX.m` currently emits (the script writes `node_lbl`
  instead of `net_lbl`, prefixes `propagate` with `extern`, and does not declare `net[]`), so a freshly
  generated header needs the same small edits before `CC_main.cpp` compiles against it.
- Gate names in the netlist are used verbatim as C++ function names, so they must match the primitives in
  `gates.h` (`AND2`, `OR2`); the example netlist uses `AND`/`OR` and was adjusted by hand in `prop.h`.
- `propagate()` indexes nets 1..14 while `net[]` has 14 entries (`n_NET`), so `net[14]` is one past the end.
