#include "gtest/gtest.h"
#include "test_cpp.cpp"
#include "test_f90.cpp"

int main(int argc, char **argv) {
    testing::InitGoogleTest(&argc, argv); 
    return RUN_ALL_TESTS();
}