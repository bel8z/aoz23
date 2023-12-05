const std = @import("std");
const assert = std.debug.assert;

const day = @import("day01.zig");

pub fn main() void {
    innerMain() catch unreachable;
}

fn innerMain() !void {
    day.part1();
    day.part2();
}
