//! This namespace contains functions for solving ordinary differential equations.
//!
//! The functions `euler` and `rk4` are used to solve ordinary differential equations using the Euler and Runge-Kutta 4th order methods, respectively.

const function = *const fn (f64, f64) f64;

/// Approximates the solution of an ordinary differential equation using Euler's method.
///
/// The `euler` function takes the following parameters:
/// - `f`: A compile-time function that represents the derivative function of the differential equation.
/// - `t_i`: The initial value of the independent variable.
/// - `y_i`: The initial value of the dependent variable.
/// - `h`: The step size.
/// - `t`: The target value of the independent variable.
///
/// The function iteratively applies Euler's method to approximate the solution of the differential equation
/// from `t_i` to `t` with the given step size `h`. It returns the approximate value of the dependent variable
/// at `t`.
pub fn euler(comptime f: function, t_i: f64, y_i: f64, h: f64, t: f64) f64 {
    while (t_i <= t) : (t_i += h) {
        y_i += h * f(t_i, y_i);
    }
    return y_i;
}

/// Implements the fourth-order Runge-Kutta method to solve an ordinary differential equation (ODE).
///
/// The function `rk4` takes the following parameters:
/// - `f`: A comptime function that represents the ODE. It takes two arguments: `t` (time) and `y` (dependent variable).
/// - `t_i`: The initial time.
/// - `y_i`: The initial value of the dependent variable.
/// - `h`: The step size.
/// - `t`: The final time.
///
/// The function returns the approximate value of the dependent variable at time `t` using the fourth-order Runge-Kutta method.
pub fn rk4(comptime f: function, t_i: f64, y_i: f64, h: f64, t: f64) f64 {
    while (t_i <= t) : (t_i += h) {
        const k1 = h * f(t_i, y_i);
        const k2 = h * f(t_i + h / 2.0, y_i + k1 / 2.0);
        const k3 = h * f(t_i + h / 2.0, y_i + k2 / 2.0);
        const k4 = h * f(t_i + h, y_i + k3);
        y_i += (k1 + 2.0 * k2 + 2.0 * k3 + k4) / 6.0;
    }
    return y_i;
}
