The MATLAB m file contains a Generate_CCX function
invoking function with a string argument containing netlist file path will generate "prop.h" file for that circuit
then you can compile and build "CC_main.cpp" with this new header file
the resulting binary will reads a vector file named "vectors.txt" and simulates the circuit net values for that input vectors in "log.txt" .

