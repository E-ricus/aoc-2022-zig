const std = @import("std");
const print = std.debug.print;

const read = @import("read.zig");

pub fn run(allocator: std.mem.Allocator) !void {
    const day_content = try read.readInputFile(allocator, "day4.input");
    defer allocator.free(day_content);
    const cont = try containedOrOverlaped(day_content, true);
    print("Groups contained: {d}\n", .{cont});
    const over = try containedOrOverlaped(day_content, false);
    print("Groups contained: {d}\n", .{over});
}

fn containedOrOverlaped(content: []const u8, contained: bool) !usize {
    var lines = std.mem.split(u8, std.mem.trimRight(u8, content, "\n"), "\n");
    var sum: usize = 0;
    while (lines.next()) |line| {
        var split = std.mem.split(u8, line, ",");
        var first = split.next().?;
        var second = split.next().?;
        if (try verify(first, second, contained)) {
            sum += 1;
        }
    }
    return sum;
}

fn verify(first: []const u8, second: []const u8, contained: bool) !bool {
    var split = std.mem.split(u8, first, "-");
    const startFirst = try std.fmt.parseInt(usize, split.next().?, 10);
    const finishFirst = try std.fmt.parseInt(usize, split.next().?, 10);
    split = std.mem.split(u8, second, "-");
    const startSecond = try std.fmt.parseInt(usize, split.next().?, 10);
    const finishSecond = try std.fmt.parseInt(usize, split.next().?, 10);
    if (contained) {
        if (startFirst >= startSecond and finishFirst <= finishSecond) {
            return true;
        }
        if (startSecond >= startFirst and finishSecond <= finishFirst) {
            return true;
        }
        return false;
    }
    if (startFirst >= startSecond and startFirst <= finishSecond) {
        return true;
    }
    if (finishFirst >= startSecond and finishFirst <= finishSecond) {
        return true;
    }
    if (startSecond >= startFirst and startSecond <= finishFirst) {
        return true;
    }
    if (finishSecond >= startFirst and finishSecond <= finishFirst) {
        return true;
    }
    return false;
}

const test_allocator = std.testing.allocator;

test "test verify contained" {
    var is_contained = try verify("2-8", "3-7", true);
    try std.testing.expect(is_contained);
    is_contained = try verify("6-6", "4-6", true);
    try std.testing.expect(is_contained);
    is_contained = try verify("2-4", "6-8", true);
    try std.testing.expect(!is_contained);
}

test "test verify overlaped" {
    var is_overlaped = try verify("5-7", "7-9", false);
    try std.testing.expect(is_overlaped);
    is_overlaped = try verify("6-6", "4-6", false);
    try std.testing.expect(is_overlaped);
    is_overlaped = try verify("2-3", "4-5", false);
    try std.testing.expect(!is_overlaped);
}

test "test contained" {
    const test_content = try read.readInputFile(test_allocator, "day4.test");
    defer test_allocator.free(test_content);
    const sum = try containedOrOverlaped(test_content, true);
    try std.testing.expectEqual(@as(usize, 2), sum);
}

test "test overlaped" {
    const test_content = try read.readInputFile(test_allocator, "day4.test");
    defer test_allocator.free(test_content);
    const sum = try containedOrOverlaped(test_content, false);
    try std.testing.expectEqual(@as(usize, 4), sum);
}
