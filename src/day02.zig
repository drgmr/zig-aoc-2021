const std = @import("std");
const logger = std.log.scoped(.day02);

const real_data = @embedFile("../data/day02.txt");

pub fn main() !void {
    logger.info("Part one: {}", .{partOne(real_data)});
    logger.info("Part two: {}", .{partTwo(real_data)});
}

fn partOne(data: []const u8) !u64 {
    var lines = std.mem.tokenize(u8, data, "\n");

    var position: u64 = 0;
    var depth: u64 = 0;

    while (lines.next()) |line| {
        var parts = std.mem.split(u8, line, " ");

        const command = parts.next().?;
        const amount = try std.fmt.parseInt(u64, parts.next().?, 10);

        if (std.mem.eql(u8, command, "forward")) {
            position += amount;
        } else if (std.mem.eql(u8, command, "down")) {
            depth += amount;
        } else if (std.mem.eql(u8, command, "up")) {
            depth -= amount;
        } else unreachable;
    }

    return position * depth;
}

fn partTwo(data: []const u8) !u64 {
    var lines = std.mem.tokenize(u8, data, "\n");

    var position: u64 = 0;
    var depth: u64 = 0;
    var aim: u64 = 0;

    while (lines.next()) |line| {
        var parts = std.mem.split(u8, line, " ");

        const command = parts.next().?;
        const amount = try std.fmt.parseInt(u64, parts.next().?, 10);

        if (std.mem.eql(u8, command, "forward")) {
            position += amount;
            depth += aim * amount;
        } else if (std.mem.eql(u8, command, "down")) {
            aim += amount;
        } else if (std.mem.eql(u8, command, "up")) {
            aim -= amount;
        } else unreachable;
    }

    return position * depth;
}

test "part one works with explanation input" {
    const test_data =
        \\forward 5
        \\down 5
        \\forward 8
        \\up 3
        \\down 8
        \\forward 2
    ;

    try std.testing.expectEqual(try partOne(test_data), 150);
}

test "part two works with explanation input" {
    const test_data =
        \\forward 5
        \\down 5
        \\forward 8
        \\up 3
        \\down 8
        \\forward 2
    ;

    try std.testing.expectEqual(try partTwo(test_data), 900);
}
