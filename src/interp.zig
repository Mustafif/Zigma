const std = @import("std");

pub fn linear_interp(x: f64, x1: f64, x2: f64, y1: f64, y2: f64) f64 {
    return y1 + (x - x1) * ((y2 - y1) / (x2 - x1));
}

pub const Points = struct {
    x: []f64,
    y: []f64,
};

pub fn lagrange(points: Points, x: f64) f64 {
    var result: f64 = 0.0;
    for (0..points.x.len) |i| {
        var term: f64 = points.y[i];
        for (0..points.x.len) |j| {
            if (j != i) {
                term *= (x - points.x[j]) / (points.x[i] - points.x[j]);
            }
        }
        result += term;
    }
    return result;
}