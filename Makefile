CXX ?= g++
CXXFLAGS ?= -std=c++11 -Wall

cc_simulate: CC_main.cpp prop.h gates.h
	$(CXX) $(CXXFLAGS) -o $@ CC_main.cpp

# The binary reads vectors.txt (lowercase) from the working directory.
run: cc_simulate
	cp -n Vectors.txt vectors.txt 2>/dev/null || true
	./cc_simulate

clean:
	rm -f cc_simulate log.txt

.PHONY: run clean
