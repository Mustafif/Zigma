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

// Rational interpolation will require numerical linear algebra
// Wait till MatrixAlgo is implemented, and will port the C code to Zig

/// Performs Akima interpolation to estimate the value of a function at a given point.
///
/// The Akima interpolation method is a piecewise cubic interpolation method that provides
/// a smooth estimate of a function based on a set of data points.
///
/// # Parameters
///
/// - `x`: An array of x-coordinates of the data points.
/// - `y`: An array of y-coordinates of the data points.
/// - `n`: The number of data points.
/// - `x_val`: The x-coordinate at which to estimate the function value.
/// - `alloc`: A pointer to the memory allocator to use for dynamic memory allocation.
///
/// # Returns
///
/// The estimated y value of the function at the given x-coordinate.
pub fn akima(x: []f64, y: []f64, n: usize, x_val: f64, alloc: *std.mem.Allocator) f64 {
    var h = alloc.alloc(f64, n - 1);
    var a = alloc.alloc(f64, n - 1);
    var b = alloc.alloc(f64, n - 1);
    var c = alloc.alloc(f64, n - 1);
    var d = alloc.alloc(f64, n - 1);

    defer {
        alloc.free(h);
        alloc.free(a);
        alloc.free(b);
        alloc.free(c);
        alloc.free(d);
    }

    for (0..n - 1) |i| {
        h[i] = x[i + 1] - x[i];
        a[i] = (y[i + 1] - y[i]) / h[i];
    }

    for (1..n - 1) |i| {
        b[i] = (3.0 * (a[i] - a[i - 1])) / (h[i] + h[i - 1]);
    }

    for (1..n - 1) |i| {
        c[i] = (2.0 * a[i - 1] + a[i]) / (h[i] + h[i - 1]);
        d[i] = (a[i] - a[i - 1]) / (h[i - 1] + h[i]);
    }

    var i: usize = 0;
    while (x_val > x[i + 1]) : (i += 1) {}

    const t = (x_val - x[i]) / h[i];
    const y_val = y[i] + t * (a[i] * t * (t * (b[i] * t - c[i]) - d[i]) + a[i]);

    return y_val;
}

// Need to figure out the Kernel function pointer
// /// The `GPR` struct represents a Gaussian Process Regression model.
// pub const GPR = struct {
//     /// The `X` field stores the training inputs.
//     X: []f64,
//     /// The `y` field stores the training targets.
//     y: []f64,
//     /// The `n` field stores the number of training samples.
//     n: usize,
//     /// The `kernel` field stores the kernel function.
//     kernel: *const fn (f64, f64, ...) f64,
//     /// The `alpha` field stores the hyperparameter.
//     alpha: f64,

//     const Self = @This();

//     /// Initializes a new instance of the `GPR` struct.
//     ///
//     /// # Parameters
//     ///
//     /// - `X`: The training inputs.
//     /// - `y`: The training targets.
//     /// - `n`: The number of training samples.
//     /// - `kernel`: The kernel function.
//     /// - `alpha`: The hyperparameter.
//     ///
//     /// # Returns
//     ///
//     /// A new instance of the `GPR` struct.
//     pub fn init(X: []f64, y: []f64, n: usize, comptime kernel: *const fn (f64, f64, ...) f64, alpha: f64) GPR {
//         return .{ .X = X, .y = y, .n = n, .kernel = kernel, .alpha = alpha };
//     }

//     /// Predicts the output for a given input.
//     ///
//     /// # Parameters
//     ///
//     /// - `self`: The `GPR` instance.
//     /// - `x`: The input value.
//     ///
//     /// # Returns
//     ///
//     /// The predicted output for the given input.
//     pub fn predict(self: Self, x: f64) f64 {
//         var k_star: f64 = 0.0;
//         var k_star_star: f64 = 0.0;

//         for (0..self.n) |i| {
//             k_star += self.kernel(x, self.X[i]) * self.y[i];
//             k_star_star += std.math.pow(f64, self.kernel(x, self.X[i]), 2.0);
//         }
//         return k_star / (k_star_star + self.alpha);
//     }
// };

pub const LeastSquares = struct {
    a: f64,
    b: f64,

    const Self = @This();

    pub fn approx(x: []f64, y: []f64) Self {
        var sum_x: f64 = 0.0;
        var sum_y: f64 = 0.0;
        var sum_xy: f64 = 0.0;
        var sum_x2: f64 = 0.0;
        const n: usize = x.len;

        for (0..n) |i| {
            sum_x += x[i];
            sum_y += y[i];
            sum_xy += x[i] * y[i];
            sum_x2 += x[i] * x[i];
        }

        const a = (n * sum_xy - sum_x * sum_y) / (n * sum_x2 - sum_x * sum_x);
        const b = (sum_y - a * sum_x) / n;
        return .{ .a = a, .b = b };
    }
};
