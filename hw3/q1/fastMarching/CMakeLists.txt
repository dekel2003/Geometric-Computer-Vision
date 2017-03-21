cmake_minimum_required(VERSION 3.6)
project(mex)

set(CMAKE_CXX_STANDARD 11)

set(SOURCE_FILES
        fheap/fib.cpp
        fheap/fib.h
        fheap/fibpriv.h
        fmm.cpp
        fmm.h
        fmm_mex.cpp)

add_executable(mex ${SOURCE_FILES})