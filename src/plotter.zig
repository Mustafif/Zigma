//! This is a fork of Github user  @Remy2701's [zigplotlib](https://github.com/Remy2701/zigplotlib)
//! This is a simple plotting library for Zig, which we we hope to expand and maintain ourself, but glad
//! to give credit to the original author for the initial work.

const std = @import("plotter/std");

// Plot Module
pub const Figure = @import("plotter/plot/Figure.zig");
pub const Plot = @import("plotter/plot/Plot.zig");
pub const Line = @import("plotter/plot/Line.zig");
pub const Area = @import("plotter/plot/Area.zig");
pub const Scatter = @import("plotter/plot/Scatter.zig");
pub const Step = @import("plotter/plot/Step.zig");
pub const Stem = @import("plotter/plot/Stem.zig");
pub const FigureInfo = @import("plotter/plot/FigureInfo.zig");

// Util Module
pub const Range = @import("plotter/util/range.zig").Range;
pub const polyshape = @import("plotter/util/polyshape.zig");

// SVG Module
const SVG = @import("plotter/svg/SVG.zig");
const length = @import("plotter/svg/util/length.zig");
const LengthPercent = length.LengthPercent;
const LengthPercentAuto = length.LengthPercentAuto;
pub const rgb = @import("plotter/svg/util/rgb.zig");
pub const RGB = rgb.RGB;

test "./plot Test" {
    std.testing.refAllDecls(FigureInfo);
    std.testing.refAllDecls(Figure);
}
