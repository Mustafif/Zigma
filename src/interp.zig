const std = @import("std");

pub fn linear(x: f64, x1: f64, x2: f64, y1: f64, y2: f64) f64 {
    return y1 + (x - x1) * ((y2 - y1) / (x2 - x1));
}

pub const Points = struct {
    x: []f64,
    y: []f64,
};

pub const Poly = struct {
    points: Points,
    x: f64,
    const Self = @This();
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

    pub fn newton(self: Self) f64 {
        var result: f64 = self.points.y[0];
        var temp: f64 = 1.0;
        for (1..self.points.x.len) |i| {
            temp *= self.x - self.points.x[i - 1];
            result += temp * divided_diff(self.points, 0, i);
        }
        return result;
    }

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
