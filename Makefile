# See LICENSE.txt for license details.

CXX=arm-linux-gnueabihf-g++
CXX_FLAGS += -O3 -static -std=c++11 -g -fno-tree-vectorize
PAR_FLAG = -fopenmp 
SERIAL=1
PATH_TO_EXE=/data/zxf/benchmark/gap/gapbs/bin_g
#/data/zxf/benchmark/gap/gapbs/bin

ifneq (,$(findstring icpc,$(CXX)))
	PAR_FLAG = -openmp
endif

ifneq (,$(findstring sunCC,$(CXX)))
	CXX_FLAGS = -std=c++11 -xO3 -m64 -xtarget=native
	PAR_FLAG = -xopenmp
endif

ifneq ($(SERIAL), 1)
	CXX_FLAGS += $(PAR_FLAG)
endif

KERNELS = bc bfs cc cc_sv pr pr_spmv sssp tc
SUITE = $(KERNELS) converter

.PHONY: all
all: $(SUITE)

% : src/%.cc src/*.h
	$(CXX) $(CXX_FLAGS) $< -o ${PATH_TO_EXE}/$@

# Testing
include test/test.mk

# Benchmark Automation
include benchmark/bench.mk


.PHONY: clean
clean:
	rm -f $(SUITE) test/out/*
