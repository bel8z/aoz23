const name = @typeName(@This());

const std = @import("std");
const testing = std.testing;
const assert = std.debug.assert;

const demo = @embedFile("input/" ++ name ++ "_demo.txt");

test "day03 part1" {
    try testing.expect(part1(demo) == 4361);
    // const input = @embedFile("input/" ++ name ++ ".txt");
    // const sum = part1(input, input_set);
    // try testing.expect(sum == 2776);
}

test "day03 part2" {}

fn getLines(input: []const u8) std.mem.TokenIterator(u8, .any) {
    return std.mem.tokenizeAny(u8, input, "\r\n");
}

fn part1(input: []const u8) u32 {
    _ = input;
    return 0;
}

fn part2(input: []const u8) u32 {
    _ = input;
    return 0;
}
