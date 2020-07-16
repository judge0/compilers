#include <gtest/gtest.h>

int add(int x, int y) {
    return x + y;
}

TEST(AdditionTest, NeutralElement) {
    EXPECT_EQ(1, add(1, 0));
    EXPECT_EQ(1, add(0, 1));
    EXPECT_EQ(0, add(0, 0));
}

TEST(AdditionTest, CommutativeProperty) {
    EXPECT_EQ(add(2, 3), add(3, 2));
}

int main(int argc, char **argv) {
    ::testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}