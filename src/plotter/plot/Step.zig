//! The Step plot

const std = @import("std");
const Allocator = std.mem.Allocator;

const SVG = @import("../svg/SVG.zig");
const RGB = @import("../svg/util/rgb.zig").RGB;
const Range = @import("../util/range.zig").Range;

const Plot = @import("Plot.zig");
const FigureInfo = @import("FigureInfo.zig");

const Step = @This();

/// The style of the step plot
pub const Style = struct {
    /// The title of the plot
    title: ?[]const u8 = null,
    /// The color of the line
    color: RGB = 0x0000FF,
    /// The width of the line
    width: f32 = 2.0,
};

/// The x-axis values of the step plot
x: ?[]const f32 = null,
/// The y-axis values of the step plot
y: []const f32,
/// The style of the step plot
style: Style = .{},

/// Returns the range of the x values of the step plot
fn getXRange(impl: *const anyopaque) Range(f32) {
    const self: *const Step = @ptrCast(@alignCast(impl));
    if (self.x) |x| {
        const min_max = std.mem.minMax(f32, x);
        return Range(f32) {
            .min = min_max.@"0",
            .max = min_max.@"1",
        };
    } else {
        return Range(f32) {
            .min = 0.0,
            .max = @floatFromInt(self.y.len - 1),
        };
    }
}

/// Returns the range of the y values of the step plot
fn getYRange(impl: *const anyopaque) Range(f32) {
    const self: *const Step = @ptrCast(@alignCast(impl));
    const min_max = std.mem.minMax(f32, self.y);
    return Range(f32) {
        .min = min_max.@"0",
        .max = min_max.@"1",
    };
}

/// Draws the step plot (converts to SVG)
fn draw(impl: *const anyopaque, allocator: Allocator, svg: *SVG, info: FigureInfo) !void {
    const self: *const Step = @ptrCast(@alignCast(impl));
    _ = allocator;

    if (self.x) |x_| {
        var previous: ?f32 = null;
        var previous_x: ?f32 = null;
        for(x_, self.y) |x, y| {
            if (!info.x_range.contains(x)) continue;
            if (!info.y_range.contains(y)) continue;

            if (previous == null) {
                previous = y;
                previous_x = x;
                continue; // Skipping the 1st iteration
            }

            if (y != previous.?) {
                const x1 = info.computeX(previous_x.?);
                const y1 = info.computeY(previous.?);
                const y2 = info.computeY(y);

                try svg.addLine(.{
                    .x1 = .{ .pixel = x1 },
                    .y1 = .{ .pixel = y1 },
                    .x2 = .{ .pixel = x1 },
                    .y2 = .{ .pixel = y2 },
                    .stroke = self.style.color,
                    .stroke_width = .{ .pixel = self.style.width },
                });
            }

            const x1 = info.computeX(previous_x.?);
            const y1 = info.computeY(y);
            const x2 = info.computeX(x);

            try svg.addLine(
                .{ 
                    .x1 = .{ .pixel = x1 }, 
                    .y1 = .{ .pixel = y1 }, 
                    .x2 = .{ .pixel = x2 }, 
                    .y2 = . { .pixel = y1 },
                    .stroke = self.style.color,
                    .stroke_width = . { .pixel = self.style.width },
                },
            );

            previous = y;
            previous_x = x;
        }
    } else {
        var previous: ?f32 = null;
        var previous_x: ?f32 = null;
        for (self.y, 0..) |y, x| {
            if (!info.x_range.contains(@floatFromInt(x))) continue;
            if (!info.y_range.contains(y)) continue;
            
            if (previous == null) {
                previous = y;
                previous_x = @floatFromInt(x);
                continue; // Skipping the 1st iteration
            }

            if (y != previous.?) {
                const x1 = info.computeX(previous_x.?);
                const y1 = info.computeY(previous.?);
                const y2 = info.computeY(y);

                try svg.addLine(.{
                    .x1 = .{ .pixel = x1 },
                    .y1 = .{ .pixel = y1 },
                    .x2 = .{ .pixel = x1 },
                    .y2 = .{ .pixel = y2 },
                    .stroke = self.style.color,
                    .stroke_width = .{ .pixel = self.style.width },
                });
            }

            const x1 = info.computeX(previous_x.?);
            const y1 = info.computeY(y);
            const x2 = info.computeX(@floatFromInt(x));

            try svg.addLine(
                .{ 
                    .x1 = .{ .pixel = x1 }, 
                    .y1 = .{ .pixel = y1 }, 
                    .x2 = .{ .pixel = x2 }, 
                    .y2 = . { .pixel = y1 },
                    .stroke = self.style.color,
                    .stroke_width = . { .pixel = self.style.width },
                },
            );

            previous = y;
            previous_x = @floatFromInt(x);
        }
    }
}

/// Convert the Step Plot to a Plot (its interface)
pub fn interface(self: *const Step) Plot {
    return Plot.init(
        @as(*const anyopaque, self),
        self.style.title,
        self.style.color,
        &getXRange,
        &getYRange,
        &draw
    );
}