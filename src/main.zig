const std = @import("std");
const assert = std.debug.assert;

pub const day = @import("day01.zig");

pub fn main() void {
    innerMain() catch unreachable;
}

fn innerMain() !void {}

test {
    std.testing.log_level = .debug;
    std.log.info("Test started", .{});
    std.testing.refAllDecls(@This());
}
