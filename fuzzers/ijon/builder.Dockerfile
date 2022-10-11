# Copyright 2020 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

ARG parent_image
FROM $parent_image

RUN apt-get update -y && \
    # apt-get -y install llvm-6.0 clang-6.0
    apt-get -y install llvm-3.8 clang-3.8
RUN apt-get -y install make gcc cmake libstdc++-5-dev bison software-properties-common
RUN apt-get -y install libc++-dev libc++abi-dev 

RUN apt-get install -y zlib1g-dev \
    libarchive-dev \
    libglib2.0-dev \
    libpsl-dev \
    libbsd-dev

# ENV AFL_CONVERT_COMPARISON_TYPE=NONE
# ENV AFL_COVERAGE_TYPE=ORIGINAL
# ENV AFL_BUILD_TYPE=FUZZING
# ENV AFL_DICT_TYPE=NORMAL
    
# Download and compile AFL v2.56b.
# Set AFL_NO_X86 to skip flaky tests.

# ENV CC=clang-6.0 CXX=clang++-6.0 CFLAGS= CXXFLAGS= LLVM_CONFIG=llvm-config-6.0
ENV CC=clang-3.8
ENV CXX=clang++-3.8
ENV LLVM_CONFIG=llvm-config-3.8

RUN git clone https://github.com/RUB-SysSec/ijon.git /ijon && \
    cd /ijon && \
    git checkout 56ebfe34709dd93f5da7871624ce6eadacc3ae4c && \
    AFL_NO_X86=1 make

RUN cd /ijon/llvm_mode && \
    AFL_NO_X86=1 make && \
    cd /ijon

# Use afl_exitdriver.cpp from LLVM as our fuzzing library.
RUN apt-get install wget -y && \
    wget https://raw.githubusercontent.com/llvm/llvm-project/5feb80e748924606531ba28c97fe65145c65372e/compiler-rt/lib/fuzzer/afl/afl_driver.cpp -O /ijon/afl_driver.cpp && \
    # clang -Wno-pointer-sign -c /afl/llvm_mode/afl-llvm-rt.o.c -I/afl && \
    $CXX -stdlib=libc++ -std=c++11 -O2 -c /ijon/afl_driver.cpp

RUN ar r /libAFL.a *.o
