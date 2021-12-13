const std = @import("std");
const logger = std.log.scoped(.day01);

const real_data = @embedFile("../data/day01.txt");

pub fn main() !void {
    logger.info("Part one: {}", .{partOne(real_data)});
    logger.info("Part two: {}", .{partTwo(real_data)});
}

fn partOne(data: []const u8) !u64 {
    var iter = std.mem.tokenize(u8, data, "\n");

    var increase_count: u64 = 0;
    var previous_value: u64 = try std.fmt.parseInt(u64, iter.next().?, 10);

    while (iter.next()) |str| {
        const current_value = try std.fmt.parseInt(u64, str, 10);

        if (current_value > previous_value) {
            increase_count += 1;
        }

        previous_value = current_value;
    }

    return increase_count;
}

fn partTwo(data: []const u8) !u64 {
    var iter = std.mem.tokenize(u8, data, "\n");

    var first = try std.fmt.parseInt(u64, iter.next().?, 10);
    var second = try std.fmt.parseInt(u64, iter.next().?, 10);
    var third = try std.fmt.parseInt(u64, iter.next().?, 10);

    var last_sum = first + second + third;

    var increase_count: u64 = 0;

    while (iter.next()) |str| {
        first = second;
        second = third;
        third = try std.fmt.parseInt(u64, str, 10);

        const sum = first + second + third;

        if (sum > last_sum) {
            increase_count += 1;
        }

        last_sum = sum;
    }

    return increase_count;
}

test "part one works with explanation input" {
    const test_data =
        \\199
        \\200
        \\208
        \\210
        \\200
        \\207
        \\240
        \\269
        \\260
        \\263
    ;

    try std.testing.expectEqual(try partOne(test_data), 7);
}

test "part two works with explanation input" {
    const test_data =
        \\199
        \\200
        \\208
        \\210
        \\200
        \\207
        \\240
        \\269
        \\260
        \\263
    ;

    try std.testing.expectEqual(try partTwo(test_data), 5);
}
