const name = @typeName(@This());

const std = @import("std");
const testing = std.testing;
const assert = std.debug.assert;

const demo = @embedFile("input/" ++ name ++ "_demo.txt");

test "day03 input processing" {
    const grid = Grid.init(demo);
    try testing.expectEqual(grid.w, 10);
    try testing.expectEqual(grid.h, 10);

    try testing.expectEqualStrings(grid.row(1), "...*......");

    try testing.expect(grid.isPartNumber(2, 0));
    try testing.expect(!grid.isPartNumber(1, 0));
}

test "day03 part1" {
    try testing.expect(part1(demo) == 4361);

    // const input = @embedFile("input/" ++ name ++ ".txt");
    // const sum = part1(input, input_set);
    // try testing.expect(sum == 2776);
}

test "day03 part2" {}

fn part1(input: []const u8) u32 {
    const grid = Grid.init(input);
    var sum: u32 = 0;

    for (0..grid.h) |y| {
        const row = grid.row(y);

        var first_digit: ?usize = null;

        for (0..grid.w, row) |x, cell| {
            if (std.ascii.isDigit(cell)) {
                first_digit = x;
                break;
            }
        }

        // If digit not found on current row, skip to next row
        const x0 = first_digit orelse continue;

        var value: u32 = 0;
        var part_number = false;

        for (x0..grid.w, row[x0..grid.w]) |x, cell| {
            if (!part_number) part_number = grid.isPartNumber(x, y);

            if (!std.ascii.isDigit(cell)) {
                // Number terminated
                break;
            }

            value = value * 10 + cell - '0';
        }

        if (part_number) {
            std.log.debug("Value: {d}", .{value});
            sum += value;
        }
    }

    return sum;
}

fn part2(input: []const u8) u32 {
    _ = input;
    return 0;
}

const Grid = struct {
    input: []const u8,
    w: usize,
    h: usize,

    const new_line = "\r\n";

    pub fn init(input: []const u8) Grid {
        var start = std.mem.indexOf(u8, input, new_line) orelse unreachable;

        var grid = Grid{
            .input = input,
            .w = start,
            .h = 2, // Account for first (just scanned) and last line (not terminated)
        };

        while (true) {
            start += new_line.len;

            if (std.mem.indexOfPos(u8, input, start, new_line)) |pos| {
                assert(pos - start == grid.w);
                start = pos;
                grid.h += 1;
            } else break;
        }

        assert(input[start..].len == grid.w);

        return grid;
    }

    pub fn isPartNumber(grid: Grid, x: usize, y: usize) bool {
        const offsets = [_][2]i2{
            .{ 1, 0 },  .{ 1, 1 },   .{ 0, 1 },  .{ -1, 1 }, //
            .{ -1, 0 }, .{ -1, -1 }, .{ 0, -1 }, .{ 1, -1 },
        };

        inline for (offsets) |offset| {
            const nx = @as(isize, @intCast(x)) + offset[0];
            const ny = @as(isize, @intCast(y)) + offset[1];

            if (nx >= 0 and ny >= 0 and nx < grid.w and ny < grid.h) {
                const width: isize = @intCast(grid.w + new_line.len);
                const cell = grid.input[@intCast(nx + ny * width)];

                // If the ajacent cell is a symbol (excluding dots), the cell can be a part number
                if (!std.ascii.isDigit(cell) and cell != '.') return true;
            }
        }

        return false;
    }

    pub fn row(grid: Grid, n: usize) []const u8 {
        assert(grid.w > 0 and grid.h > 0);
        assert(n >= 0 and n < grid.h);

        const offset = n * (grid.w + new_line.len);
        return grid.input[offset..][0..grid.w];
    }
};
