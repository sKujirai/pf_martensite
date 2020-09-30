#include <iostream>
#include <string>
#include <Eigen/Core>


int main() {

    Eigen::Matrix3d A = Eigen::Matrix3d::Zero();

    A(0, 0) = 1.;
    A(2, 2) = 2.;

    std::cout << A << std::endl;

    return 0;
}
