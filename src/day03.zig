const std = @import("std");
const logger = std.log.scoped(.day03);

const real_data = @embedFile("../data/day03.txt");

pub fn main() !void {
    const digits = comptime digitsSize(real_data);

    logger.info("Part one: {}", .{partOne(digits, real_data)});
}

fn partOne(comptime digits: usize, data: []const u8) !u64 {
    var lines = std.mem.tokenize(u8, data, "\n");
    var counts: [digits]u64 = [_]u64{0} ** digits;
    var total_entries: u64 = 0;

    while (lines.next()) |line| {
        for (line) |char, index| {
            if (char == '1') {
                counts[index] += 1;
            }
        }

        total_entries += 1;
    }

    const ResultType = @Type(std.builtin.TypeInfo{
        .Int = .{
            .signedness = .unsigned,
            .bits = digits,
        },
    });

    const ShiftType = @Type(std.builtin.TypeInfo{
        .Int = .{
            .signedness = .unsigned,
            .bits = comptime maxShiftFor(digits),
        },
    });

    var gamma: ResultType = 0;

    for (counts) |value, index| {
        if (value > total_entries / 2) {
            gamma |= @intCast(ResultType, 1) << @intCast(ShiftType, index);
        }
    }

    gamma = @bitReverse(ResultType, gamma);

    const epsilon = ~gamma;

    return @intCast(u64, gamma) * @intCast(u64, epsilon);
}

/// This is kind of cheating, but let's pretend this would be a configurable value.
fn digitsSize(comptime source: []const u8) usize {
    var lines = std.mem.tokenize(u8, source, "\n");
    const sample = lines.next() orelse unreachable;

    return sample.len;
}

/// Please don't ask
fn maxShiftFor(digits: usize) usize {
    const value = std.math.log2(digits);

    if (value % 2 == 0) {
        return value;
    } else {
        return value + 1;
    }
}

test "part one works with explanation input" {
    const test_data =
        \\00100
        \\11110
        \\10110
        \\10111
        \\10101
        \\01111
        \\00111
        \\11100
        \\10000
        \\11001
        \\00010
        \\01010
    ;

    const digits = comptime digitsSize(test_data);

    try std.testing.expectEqual(try partOne(digits, test_data), 198);
}
