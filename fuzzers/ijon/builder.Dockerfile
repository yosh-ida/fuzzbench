ARG parent_image
FROM $parent_image

RUN apt-get update -y && \
    apt-get -y install llvm-6.0 \
    clang-6.0 llvm-6.0-dev llvm-6.0-tools \
    wget
RUN apt-get install -y \
    cmake-data build-essential curl libcap-dev \
    git cmake libncurses5-dev unzip libtcmalloc-minimal4 \
    libgoogle-perftools-dev bison flex libboost-all-dev \
    perl zlib1g-dev libsqlite3-dev doxygen

RUN git clone https://github.com/RUB-SysSec/ijon.git /ijon && \
    cd /ijon && \
    git checkout 56ebfe34709dd93f5da7871624ce6eadacc3ae4c && \
    AFL_NO_X86=1 LLVM_CONFIG=llvm-config-6.0 CC=clang-6.0 CXX=clang++-6.0 CFLAGS= CXXFLAGS= make

RUN cd /ijon/llvm_mode && \
    AFL_NO_X86=1 LLVM_CONFIG=llvm-config-6.0 CC=clang-6.0 CXX=g++ CFLAGS= CXXFLAGS= make && \
    cd /ijon

RUN wget https://raw.githubusercontent.com/llvm/llvm-project/5feb80e748924606531ba28c97fe65145c65372e/compiler-rt/lib/fuzzer/afl/afl_driver.cpp -O /ijon/afl_driver.cpp && \
    clang++-6.0 -stdlib=libc++ -std=c++11 -O2 -c /ijon/afl_driver.cpp

RUN ar r /libAFL.a *.o
