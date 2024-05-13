const function = *const fn (f64) f64;

/// Performs Newton's method to find the root of a function.
///
/// Given a function `f`, its derivative `df`, an initial guess `x0`, a tolerance `tol`,
/// and a maximum number of iterations `max_iter`, this function iteratively applies
/// Newton's method to find the root of the function `f`.
///
/// # Parameters
/// - `f`: The function for which the root is to be found.
/// - `df`: The derivative of the function `f`.
/// - `x0`: The initial guess for the root.
/// - `tol`: The tolerance for convergence.
/// - `max_iter`: The maximum number of iterations allowed.
///
/// # Returns
/// The estimated root of the function `f`.
pub fn newton_method(comptime f: function, comptime df: function, x0: f64, tol: f64, max_iter: usize) f64 {
    var x = x0;
    for (0..max_iter) |_| {
        const fx = f(x);
        const dfx = df(x);

        if (@abs(dfx) < tol) return x;
        const x_new = x - fx / dfx;
        if (@abs(x_new - x) < tol) return x_new;
        x = x_new;
    }
    return x;
}
