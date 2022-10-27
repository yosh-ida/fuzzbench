cd $SRC/deep_nest
$CXX $CXXFLAGS $SRC/deep_nest/main.cpp $FUZZER_LIB -o $OUT/deep_nest_fuzzer
cp -r /opt/seeds $OUT/