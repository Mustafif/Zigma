//! This contains numerical methods for interpolation:
//! - Linear interpolation
//! - Lagrange interpolation
//! - Newton interpolation
//! - Cubic spline interpolation
//! - Quadratic spline interpolation

const std = @import("std");

/// Performs linear interpolation between two points.
///
/// Given two points (x1, y1) and (x2, y2), this function calculates the y-value
/// corresponding to a given x-value using linear interpolation.
///
/// # Parameters
/// - `x`: The x-value for which to calculate the interpolated y-value.
/// - `x1`: The x-value of the first point.
/// - `x2`: The x-value of the second point.
/// - `y1`: The y-value of the first point.
/// - `y2`: The y-value of the second point.
///
/// # Returns
/// The interpolated y-value corresponding to the given x-value.
pub fn linear(x: f64, x1: f64, x2: f64, y1: f64, y2: f64) f64 {
    return y1 + (x - x1) * ((y2 - y1) / (x2 - x1));
}

/// Represents a collection of points in a 2D space.
pub const Points = struct {
    x: []f64,
    y: []f64,

    /// Initializes a new instance of the Points struct with the given x and y arrays.
    ///
    /// # Parameters
    /// - `x`: An array of x-coordinates.
    /// - `y`: An array of y-coordinates.
    ///
    /// # Returns
    /// The initialized Points struct.
    pub fn init(x: []f64, y: []f64) Points {
        return .{ .x = x, .y = y };
    }

    /// Initializes a new instance of the Points struct with the given x and y arrays in raw C format.
    ///
    /// # Parameters
    /// - `x`: A pointer to an array of x-coordinates in raw C format.
    /// - `y`: A pointer to an array of y-coordinates in raw C format.
    ///
    /// # Returns
    /// The initialized Points struct.
    pub fn init_rawc(x: [*c]f64, y: [*c]f64) Points {
        const x_ptr: *[]f64 = @ptrCast(@alignCast(x));
        const y_ptr: *[]f64 = @ptrCast(@alignCast(y));
        return .{ .x = x_ptr.*, .y = y_ptr.* };
    }
};

/// The `Poly` struct represents a polynomial interpolation.
pub const Poly = struct {
    /// The `points` field stores the x and y coordinates of the points to be interpolated.
    points: Points,
    /// The `x` field represents the x-coordinate at which the polynomial is evaluated.
    x: f64,

    const Self = @This();

    /// The `lagrange` function calculates the polynomial interpolation using the Lagrange method.
    ///
    /// # Returns
    /// The interpolated value at `self.x`.
    pub fn lagrange(self: Self) f64 {
        var result: f64 = 0.0;
        for (0..self.points.x.len) |i| {
            var term: f64 = self.points.y[i];
            for (0..self.points.x.len) |j| {
                if (j != i) {
                    term *= (self.x - self.points.x[j]) / (self.points.x[i] - self.points.x[j]);
                }
            }
            result += term;
        }
        return result;
    }

    /// The `newton` function calculates the polynomial interpolation using the Newton method.
    ///
    /// # Returns
    /// The interpolated value at `self.x`.
    pub fn newton(self: Self) f64 {
        var result: f64 = self.points.y[0];
        var temp: f64 = 1.0;
        for (1..self.points.x.len) |i| {
            temp *= self.x - self.points.x[i - 1];
            result += temp * divided_diff(self.points, 0, i);
        }
        return result;
    }

    /// The `divided_diff` function calculates the divided difference of the given points.
    ///
    /// # Parameters
    /// - `points`: The points to calculate the divided difference for.
    /// - `start`: The starting index of the range.
    /// - `end`: The ending index of the range.
    ///
    /// # Returns
    /// The divided difference of the points in the specified range.
    fn divided_diff(points: Points, start: usize, end: usize) f64 {
        if (start == end) {
            return points.y[start];
        }
        return (divided_diff(points, start + 1, end) - divided_diff(points, start, end - 1)) / (points.x[end] - points.x[start]);
    }
};

pub const Spline = struct {
    points: Points,
    x: f64,
    const Self = @This();

    pub fn cubic(self: Self) f64 {
        var i: usize = undefined;
        var a: f64 = undefined;
        var b: f64 = undefined;
        var c: f64 = undefined;
        var d: f64 = undefined;
        var h: f64 = undefined;

        // Find the segment that contains x using binary search
        var left: usize = 0;
        var right = self.points.x.len - 1;
        while (left <= right) {
            const mid = left + @divExact(right - left, 2);
            if (self.x < self.points.x[mid]) {
                right = mid - 1;
            } else if (self.x > self.points.x[mid]) {
                left = mid + 1;
            } else {
                // x is exactly equal to a point's x coordinate
                return self.points.y[mid];
            }
        }
        i = left - 1;
        a = self.points.y[i];
        h = self.points.x[i + 1] - self.points.x[i];
        b = (self.points.y[i + 1] - self.points.y[i]) / h;
        c = ((self.points.y[i + 1] - self.points.y[i]) / (h * h)) * (self.points.x[i + 1] - self.x) - (self.points.y[i + 1] - self.points.y[i]) / h;
        d = ((self.points.y[i + 1] - self.points.y[i]) / (h * h * h)) * (self.points.x[i + 1] - self.x) * (self.points.x[i + 1] - self.x) - ((self.points.y[i + 1] - self.points.y[i]) / (h * h)) * (self.points.x[i + 1] - self.x) + (self.points.y[i + 1] - self.points.y[i]) / h;
        return a + b * (self.x - self.points.x[i]) + c * (self.x - self.points.x[i]) * (self.x - self.points.x[i]) + d * (self.x - self.points.x[i]) * (self.x - self.points.x[i]) * (self.x - self.points.x[i]);
    }

    pub fn quadratic(self: Self) f64 {
        var i: usize = undefined;
        var a: f64 = undefined;
        var b: f64 = undefined;
        var c: f64 = undefined;
        var h: f64 = undefined;

        // Find the segment that contains x using binary search
        var left: usize = 0;
        var right = self.points.x.len - 1;
        while (left <= right) {
            const mid = left + @divExact(right - left, 2);
            if (self.x < self.points.x[mid]) {
                right = mid - 1;
            } else if (self.x > self.points.x[mid]) {
                left = mid + 1;
            } else {
                // x is exactly equal to a point's x coordinate
                return self.points.y[mid];
            }
        }
        i = left - 1;
        a = self.points.y[i];
        h = self.points.x[i + 1] - self.points.x[i];
        b = (self.points.y[i + 1] - self.points.y[i]) / h;
        c = ((self.points.y[i + 1] - self.points.y[i]) / (h * h)) * (self.points.x[i + 1] - self.x) - (self.points.y[i + 1] - self.points.y[i]) / h;
        return a + b * (self.x - self.points.x[i]) + c * (self.x - self.points.x[i]) * (self.x - self.points.x[i]);
    }
};
