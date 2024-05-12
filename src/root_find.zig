const function = *const fn (f64) f64;

/// Performs the bisection method to find the root of a function within a given interval.
///
/// # Parameters
/// - `f`: The function for which the root is to be found. It should take a single `f64` argument and return an `f64` value.
/// - `a`: The lower bound of the interval.
/// - `b`: The upper bound of the interval.
/// - `tol`: The tolerance value for the root approximation.
///
/// # Returns
/// The approximate root of the function within the given interval.
pub fn bisection(f: function, a: f64, b: f64, tol: f64) f64 {
    var c: f64 = undefined;
    var arg_a: f64 = a;
    var arg_b: f64 = b;
    while ((arg_b - arg_a) > tol) {
        c = (arg_a + arg_b) / 2.0;
        if (f(c) == 0.0 or (arg_b - arg_a) / 2.0 < tol) {
            return c;
        } else if (f(arg_a) * f(c) < 0.0) {
            arg_b = c;
        } else {
            arg_a = c;
        }
    }
    return c;
}

/// Uses the secant method to find the root of a function within a given tolerance.
/// 
/// # Parameters
/// - `f`: The function for which to find the root.
/// - `a`: The lower bound of the interval.
/// - `b`: The upper bound of the interval.
/// - `tol`: The tolerance for the root approximation.
/// 
/// # Returns
/// The approximate root of the function within the given tolerance.
pub fn secant(f: function, a: f64, b: f64, tol: f64) f64 {
    var c: f64 = undefined;
    var arg_a: f64 = a;
    var arg_b: f64 = b;

    while (@abs(arg_b - arg_a) > tol) {
        c = arg_b - f(arg_b) * (arg_b - arg_a) / (f(arg_b) - f(arg_a));
        arg_a = arg_b;
        arg_b = c;
    }
    return c;
}
