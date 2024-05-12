//! # Zigma
//! ## A Library for Numerical Methods in Zig.
//!
//! This library is designed to be used to advance the mathematical capabilities of
//! [MufiZ](https://github.com/Mustafif/MufiZ) and also to be used generally
//! in any Zig project that requires numerical methods. Thus most components of this library
//! is completely written in Zig, and can also have methods to accept raw C pointer types.
//!
//! Current progress:
//! 1. **Interpolation and Approximation:** (`interpolation` and `approx` namespace)
//!
//! - [X] Linear Interpolation
//! - [X] Polynomial Interpolation: (`interpolation.Poly`)
//!   - [X] Lagrange Interpolation
//!   - [X] Newton Interpolation
//! - [X] Spline Interpolation: (`interpolation.Spline`)
//!   - [X] Cubic Spline
//!   - [X] Quadratic Spline
//! - [ ] Least Square Approximation
//! - [ ] Chebyshev Approximation
//!
//! 2. **Optimization:** (`optimization` namespace)
//!
//! - [ ] Gradient Descent (for minimization and maximization)
//!   - [ ] Stochastic Gradient Descent
//!   - [ ] Mini-Batch Gradient Descent
//!   - [ ] Batch Gradient Descent
//!   - [ ] Momentum Gradient Descent
//!   - [ ] Nesterov Accelerated Gradient Descent
//! - [ ] Newton's Method (for minimization and root finding)
//!
//! 3. **Root Finding:** (`root_find` namespace)
//!
//! - [X] Bisection Method
//! - [X] Secant Method
//!
//! 4. **Numerical Integration:** (`integration` namespace)
//!
//! - [ ] Trapezoidal Rule
//! - [ ] Simpson's Rule
//!
//! 5. **Derivative Approximation:** (`differentation` namespace)
//!
//! - [ ] Forward Difference
//! - [ ] Backward Difference
//! - [ ] Central Difference
//!
//! 6. **Ordinary Differential Equation:** (`ode` namespace)
//!
//! - [ ] Euler's Method
//! - [ ] Runge-Kutta Method

const std = @import("std");
const testing = std.testing;

pub const interpolation = @import("interp.zig");
pub const optimization = @import("optimization.zig");
pub const root_find = @import("root_find.zig");
pub const integration = @import("integration.zig");
pub const differentation = @import("differentation.zig");
pub const ode = @import("ode.zig");
pub const approx = @import("approx.zig");

// we will contain all tests here
test "linear interpolation" {
    const x = interpolation.linear(4.0, 2.0, 6.0, 3.0, 9.0);
    try testing.expect(x == 6.0);
}

test "lagrange interpolation" {
    var x = [_]f64{ 1.0, 2.0, 3.0 };
    var y = [_]f64{ 2.0, 4.0, 6.0 };
    const points = interpolation.Points.init(&x, &y);
    const poly = interpolation.Poly{ .points = points, .x = 2.5 };
    const result = poly.lagrange();
    try testing.expect(result == 5.0);
}

test "newton interpolation" {
    var x = [_]f64{ 1.0, 2.0, 3.0 };
    var y = [_]f64{ 2.0, 4.0, 6.0 };
    const points = interpolation.Points.init(&x, &y);
    const poly = interpolation.Poly{ .points = points, .x = 2.5 };
    const result = poly.newton();
    try testing.expect(result == 5.0);
}

test "cubic spline interpolation" {
    var x = [_]f64{ 1.0, 2.0, 3.0 };
    var y = [_]f64{ 2.0, 4.0, 6.0 };
    const points = interpolation.Points.init(&x, &y);
    const spline = interpolation.Spline{ .points = points, .x = 2.5 };
    const result = spline.cubic();
    try testing.expect(std.math.round(result) == 5.0);
}

test "quadratic spline interpolation" {
    var x = [_]f64{ 1.0, 2.0, 3.0 };
    var y = [_]f64{ 2.0, 4.0, 6.0 };
    const points = interpolation.Points.init(&x, &y);
    const spline = interpolation.Spline{ .points = points, .x = 2.5 };
    const result = spline.quadratic();
    try testing.expect(result == 4.75);
}

fn f(x: f64) f64 {
    return x * x - 2.0;
}

test "bisection" {
    const a: f64 = 0.0;
    const b: f64 = 2.0;
    const tol: f64 = 1e-5;
    const root = root_find.bisection(f, a, b, tol);
    try testing.expect(@trunc(root) == 1);
}

test "secant" {
    const a: f64 = 0.0;
    const b: f64 = 2.0;
    const tol: f64 = 1e-5;
    const root = root_find.secant(f, a, b, tol);
    try testing.expect(@trunc(root) == 1);
}
