//! # Zigma
//! ## A Library for Numerical Methods in Zig.
//!
//! This library is designed to be used to advance the mathematical capabilities of
//! [MufiZ](https://github.com/Mustafif/MufiZ) and also to be used generally
//! in any Zig project that requires numerical methods. Thus most components of this library
//! is completely written in Zig, and can also have methods to accept raw C pointer types.
//!
//! Visit our [README](https://github.com/Mustafif/Zigma/blob/main/README.md) for more information about
//! current progress and future plans.

const std = @import("std");
const testing = std.testing;

pub const interpolation = @import("interp.zig");
pub const optimization = @import("optimization.zig");
pub const root_find = @import("root_find.zig");
pub const integration = @import("integration.zig");
pub const differentation = @import("differentation.zig");
pub const ode = @import("ode.zig");

/// Emits a todo message as an error log message.
pub fn todo(msg: []const u8, args: anytype) void {
    std.log.err(msg, args);
}

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

test "least squares" {
    var x = [_]f64{ 1.0, 2.0, 3.0 };
    var y = [_]f64{ 2.0, 4.0, 6.0 };
    const ls = interpolation.LeastSquares.approx(&x, &y);
    _ = ls;
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
