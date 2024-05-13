# Zigma
A Zig Library for Mathematical Numerical Method Techniques

> 📖 [zigma.mustafif.com](https://zigma.mustafif.com)

## Purpose

This library is designed to be used to advance the mathematical capabilities of [MufiZ](https://github.com/Mustafif/MufiZ) and also to be used generally in any Zig project that requires numerical methods. Thus most components of this library is completely written in Zig, and can also have methods to accept raw C pointer types.

## Algorithms

- **Interpolation and Approximation:**
  - [X] Linear Interpolation
  - [X] Polynomial Interpolation
    - [X] Lagrange Interpolation
    - [X] Newton Interpolation
  - [X] Spline Interpolation
    - [X] Cubic Spline
    - [X] Quadratic Spline
  - [ ] Rational Interpolation (requires MatrixAlgo)
  - [X] Akima Interpolation
  - [ ] Gaussian Process Regression
  - [X] Least Square Approximation
  - [ ] Chebyshev Approximation

- **Optimization:**
  - [ ] Gradient Descent (for minimization and maximization)
    - [ ] Stochastic Gradient Descent
    - [ ] Mini-Batch Gradient Descent
    - [ ] Batch Gradient Descent
    - [ ] Momentum Gradient Descent
    - [ ] Nesterov Accelerated Gradient Descent
  - [ ] Quasi-Newton Method
    - [ ] BFGS
    - [ ] L-BFGS
  - [X] Newton's Method (for minimization and root finding)

- **Root Finding:**
  - [X] Bisection Method
  - [X] Secant Method
  - [ ] Brent's Method
  - [ ] Inverse Quadratic Interpolation

- **Numerical Integration:**
  - [ ] Trapezoidal Rule
  - [ ] Simpson's Rule
  - [ ] Romberg Integration
  - [ ] Gaussian Quadrature

- **Derivative Approximation:**
  - [X] Forward Difference
  - [X] Backward Difference
  - [X] Central Difference

- **Ordinary Differential Equation:**
  - [X] Euler's Method
  - [X] Runge-Kutta Method (RK4)

- **Finance**
  - [ ] Black-Scholes Model
  - [ ] Binomial Option Pricing Model
  - [ ] Monte Carlo Simulation

We also hope to add data visualization tools in the future, if we can find a good way to do it in Zig.

## License

This project is licensed under the GPLv2 License - see the [LICENSE](LICENSE) file for details.

## Contributing

If you would like to contribute to this project, please feel free to fork this repository and submit a pull request. We would love to see more people contributing to this project!
