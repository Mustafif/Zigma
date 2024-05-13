//! This namespace contains functions for numerical differentiation.
//!
//! Forward Difference:
//!
//! f'(x) = (f(x + h) - f(x)) / h
//!
//! Backward Difference:
//!
//! f'(x) = (f(x) - f(x - h)) / h
//!
//! Central Difference:
//!
//! f'(x) = (f(x + h) - f(x - h)) / (2 * h)
//!
//! Where f is a function of type f64 -> f64, x is the point at which to evaluate the derivative, and h is the step size.

const fx = *const fn (f64) f64;

/// Calculates the forward difference approximation of the derivative of a function.
///
/// Given a function `f`, a point `x`, and a step size `h`, this function approximates the derivative
/// of `f` at `x` using the forward difference method.
///
/// # Parameters
/// - `f`: The function to differentiate.
/// - `x`: The point at which to evaluate the derivative.
/// - `h`: The step size for the approximation.
///
/// # Returns
/// The approximate value of the derivative of `f` at `x`.
pub fn forward_diff(f: fx, x: f64, h: f64) f64 {
    return (f(x + h) - f(x)) / h;
}

/// Calculates the backward difference approximation of the derivative of a function.
///
/// Given a function `f`, a point `x`, and a step size `h`, this function approximates the derivative
/// of `f` at `x` using the backward difference formula.
///
/// # Parameters
/// - `f`: The function to differentiate.
/// - `x`: The point at which to evaluate the derivative.
/// - `h`: The step size for the approximation.
///
/// # Returns
/// The approximate value of the derivative of `f` at `x`.
pub fn backward_diff(f: fx, x: f64, h: f64) f64 {
    return (f(x) - f(x - h)) / h;
}

/// Calculates the central difference approximation of the derivative of a function.
///
/// Given a function `f`, a point `x`, and a step size `h`, this function approximates the derivative
/// of `f` at `x` using the central difference formula.
///
/// # Parameters
/// - `f`: The function to differentiate.
/// - `x`: The point at which to evaluate the derivative.
/// - `h`: The step size for the approximation.
///
/// # Returns
/// The approximate value of the derivative of `f` at `x`.
pub fn central_diff(f: fx, x: f64, h: f64) f64 {
    return (f(x + h) - f(x - h)) / (2.0 * h);
}
