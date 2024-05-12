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
    const points = interpolation.Points{ .x = &x, .y = &y };
    const poly = interpolation.Poly{ .points = points, .x = 2.5 };
    const result = poly.lagrange();
    try testing.expect(result == 5.0);
}

test "newton interpolation" {
    var x = [_]f64{ 1.0, 2.0, 3.0 };
    var y = [_]f64{ 2.0, 4.0, 6.0 };
    const points = interpolation.Points{ .x = &x, .y = &y };
    const poly = interpolation.Poly{ .points = points, .x = 2.5 };
    const result = poly.newton();
    try testing.expect(result == 5.0);
}

test "cubic spline interpolation" {
    var x = [_]f64{ 1.0, 2.0, 3.0 };
    var y = [_]f64{ 2.0, 4.0, 6.0 };
    const points = interpolation.Points{ .x = &x, .y = &y };
    const spline = interpolation.Spline{ .points = points, .x = 2.5 };
    const result = spline.cubic();
    try testing.expect(std.math.round(result) == 5.0);
}

test "quadratic spline interpolation" {
    var x = [_]f64{ 1.0, 2.0, 3.0 };
    var y = [_]f64{ 2.0, 4.0, 6.0 };
    const points = interpolation.Points{ .x = &x, .y = &y };
    const spline = interpolation.Spline{ .points = points, .x = 2.5 };
    const result = spline.quadratic();
    try testing.expect(result == 4.75);
}
