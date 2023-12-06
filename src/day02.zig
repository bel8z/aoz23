const name = @typeName(@This());

const std = @import("std");
const testing = std.testing;
const assert = std.debug.assert;

const demo = @embedFile("input/" ++ name ++ "_demo.txt");

test "day02 part1" {
    const input_set = [3]u8{ 12, 13, 14 };

    try testing.expect(part1(demo, input_set) == 8);

    const input = @embedFile("input/" ++ name ++ ".txt");
    const sum = part1(input, input_set);
    try testing.expect(sum == 2776);
}

test "day02 part2" {
    try testing.expect(part2(demo) == 2286);

    const input = @embedFile("input/" ++ name ++ ".txt");
    const sum = part2(input);
    try testing.expect(sum == 68638);
}

fn getLines(input: []const u8) std.mem.TokenIterator(u8, .any) {
    return std.mem.tokenizeAny(u8, input, "\r\n");
}

fn part1(input: []const u8, input_set: [3]u8) u32 {
    var lines = getLines(input);
    var sum: u32 = 0; // Widen to 32 bits to avoid overflow

    outer: while (lines.next()) |line| {
        const game = Game.parse(line);

        for (game.set_list.constSlice()) |set| {
            for (set, input_set) |val, max| {
                if (val > max) {
                    // Game not possible, skip to next one
                    continue :outer;
                }
            }
        }

        // If we got here, game is valid
        sum += game.id;
    }

    return sum;
}

fn part2(input: []const u8) u32 {
    var lines = getLines(input);
    var sum: u32 = 0;

    while (lines.next()) |line| {
        const game = Game.parse(line);
        var max = [3]u32{ 0, 0, 0 }; // Widen to 32 bits for multiplication

        for (game.set_list.constSlice()) |set| {
            for (set, 0..) |val, index| {
                if (val > max[index]) {
                    max[index] = val;
                }
            }
        }

        const power = max[0] * max[1] * max[2];
        sum += power;
    }

    return sum;
}

const Game = struct {
    id: u8 = 0,
    set_list: std.BoundedArray([3]u8, 256) = .{},

    pub fn parse(line: []const u8) Game {
        // Find and parse game id
        var start = 1 + (std.mem.indexOfScalar(u8, line, ' ') orelse unreachable);
        var colon = std.mem.indexOfScalarPos(u8, line, start, ':') orelse unreachable;
        var game = Game{ .id = parseU8(line[start..colon]) };

        // Move cursor to first set
        start = colon + 1;

        // Process all sets, separated by semicolons
        var set_iter = std.mem.split(u8, line[start..], ";");
        while (set_iter.next()) |set_str| {
            // Add a set to the list
            var set = game.set_list.addOneAssumeCapacity();
            set.* = .{ 0, 0, 0 };
            // Parse each color count
            var count_iter = std.mem.split(u8, set_str, ",");
            while (count_iter.next()) |part| parseCount(part, set);
        }

        return game;
    }

    fn parseCount(str: []const u8, set: *[3]u8) void {
        // Each count starts with a space, followed by a number, a space, and the
        // name of the color
        assert(str[0] == ' ');

        const end = std.mem.indexOfScalarPos(u8, str, 1, ' ') orelse unreachable;
        const color = str[end + 1 ..];

        inline for (.{ "red", "green", "blue" }, 0..) |candidate, index| {
            if (std.mem.eql(u8, candidate, color)) {
                set[index] = parseU8(str[1..end]);
                break;
            }
        }
    }

    // Utility wrapper
    fn parseU8(str: []const u8) u8 {
        return std.fmt.parseInt(u8, str, 10) catch unreachable;
    }
};
