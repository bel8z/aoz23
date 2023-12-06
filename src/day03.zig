const name = @typeName(@This());

const std = @import("std");
const testing = std.testing;
const assert = std.debug.assert;

const demo = @embedFile("input/" ++ name ++ "_demo.txt");

test "day03 input processing" {
    const grid = Grid.init(demo);
    try testing.expectEqual(grid.size, Vec{ .x = 10, .y = 10 });

    try testing.expectEqual(grid.get(Vec{ .x = 2, .y = 0 }), '7');
    try testing.expectEqual(grid.get(Vec{ .x = 9, .y = 4 }), '.');
    try testing.expectEqual(grid.get(Vec{ .x = 0, .y = 9 }), '.');
    try testing.expectEqual(grid.get(Vec{ .x = 9, .y = 9 }), '.');
    try testing.expectEqual(grid.get(Vec{ .x = 3, .y = 9 }), '4');

    try testing.expect(grid.hasSymbolAdjacent(Vec{ .x = 2, .y = 0 }));
    try testing.expect(!grid.hasSymbolAdjacent(Vec{ .x = 1, .y = 0 }));
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
    _ = grid;
    return 0;
}

fn part2(input: []const u8) u32 {
    _ = input;
    return 0;
}

const Vec = struct {
    x: i32 = 0,
    y: i32 = 0,
};

const Digit = struct {
    pos: Vec = .{},
    len: u32 = 0,
    value: u32 = 0,
};

fn isSymbol(char: u8) bool {
    return !std.ascii.isDigit(char) and char != '.';
}

const Grid = struct {
    input: []const u8,
    size: Vec,

    const new_line = "\r\n";

    pub fn init(input: []const u8) Grid {
        return .{ .input = input, .size = measure(input) };
    }

    pub fn hasSymbolAdjacent(grid: *Grid, pos: Vec) bool {
        const offsets = [_]Vec{
            .{ .x = 1, .y = 0 },
            .{ .x = 1, .y = 1 },
            .{ .x = 0, .y = 1 },
            .{ .x = -1, .y = 1 },
            .{ .x = -1, .y = 0 },
            .{ .x = -1, .y = -1 },
            .{ .x = 0, .y = -1 },
            .{ .x = 1, .y = -1 },
        };

        for (offsets) |offset| {
            const cursor = Vec{ .x = pos.x + offset.x, .y = pos.y + offset.y };
            if (cursor.x < 0 or cursor.y < 0) continue;
            if (cursor.x >= grid.size.x or cursor.y >= grid.size.y) continue;

            if (isSymbol(grid.get(cursor))) return true;
        }

        return false;
    }

    pub fn get(grid: *Grid, pos: Vec) u8 {
        assert(grid.size.x > 0 and grid.size.y > 0);
        assert(pos.x >= 0 and pos.x < grid.size.x);
        assert(pos.y >= 0 and pos.y < grid.size.y);

        const nl: i32 = @intCast(new_line.len);
        const offset: usize = @intCast(pos.x + pos.y * (grid.size.x + nl));
        return grid.input[offset];
    }

    fn measure(input: []const u8) Vec {
        var start = std.mem.indexOf(u8, input, new_line) orelse unreachable;

        var size = Vec{
            .x = @intCast(start),
            .y = 2, // Account for first (just scanned) and last line (not terminated)
        };

        while (true) {
            start += new_line.len;

            if (std.mem.indexOfPos(u8, input, start, new_line)) |pos| {
                assert(pos - start == size.x);
                start = pos;
                size.y += 1;
            } else break;
        }

        assert(input[start..].len == size.x);

        return size;
    }
};
