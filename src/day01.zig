const name = @typeName(@This());

const std = @import("std");
const log = std.log;
const assert = std.debug.assert;

fn getLines(input: []const u8) std.mem.TokenIterator(u8, .any) {
    return std.mem.tokenizeAny(u8, input, "\r\n");
}

pub fn part1() void {
    const input = @embedFile("input/" ++ name ++ "_part1.txt");
    var lines = getLines(input);
    var sum: i32 = 0;

    while (lines.next()) |line| {
        var first: i32 = -1;
        var last: i32 = undefined;

        for (line) |char| {
            if (std.ascii.isDigit(char)) {
                last = @as(i32, @intCast(char)) - '0';
                if (first < 0) first = last;
            }
        }

        sum += 10 * first + last;
    }

    log.info(name ++ " part 1: {d}", .{sum});
}

pub fn part2() void {
    const input = @embedFile("input/" ++ name ++ "_part2.txt");

    var lines = getLines(input);
    var sum: usize = 0;

    while (lines.next()) |line| {
        var first_pos: usize = undefined;
        var last_pos: usize = undefined;

        // Init first and last digit to 0 is convenient because all valid digits are greater
        var last: usize = 0;
        var first: usize = 0;

        // Scan for actual digits as in part 1, but store positions too
        for (line, 0..) |char, pos| {
            if (std.ascii.isDigit(char)) {
                last_pos = pos;
                last = line[last_pos] - '0';

                if (first == 0) {
                    first_pos = pos;
                    first = last;
                }
            }
        }

        // Scan for the literal representation of each digit, finding every occurrence; occurence
        // index is stored if lower than first or greater than last. Since 'digits' is sorted,
        // 1-based indexing provides the actual value.
        const digits = [_][]const u8{
            "one", "two",   "three", "four", "five", //
            "six", "seven", "eight", "nine",
        };
        inline for (digits, 1..) |digit, value| {
            var offset: usize = 0;
            while (std.mem.indexOfPos(u8, line, offset, digit)) |pos| {
                if (first == 0 or pos < first_pos) {
                    first_pos = pos;
                    first = value;
                }

                if (last == 0 or pos > last_pos) {
                    last_pos = pos;
                    last = value;
                }

                offset = pos + digit.len;
            }
        }

        // Accumulate
        sum += 10 * first + last;
    }

    log.info(name ++ " part 2: {d}", .{sum});
}
