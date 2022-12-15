const std = @import("std");
const print = std.debug.print;

// Day input
const day_content = @embedFile("inputs/day1.input");

pub fn run() !void {
    const max_cal = try maxCalories(day_content);
    print("Max calories: {}\n", .{max_cal});
    const sum_cal = try sumCalories(day_content);
    print("Sum calories: {}\n", .{sum_cal});
}

fn parseElfs(content: []const u8) ![]usize {
    const allocator = std.heap.page_allocator;

    var elfs = std.ArrayList(usize).init(allocator);
    defer elfs.deinit();
    var lines = std.mem.split(u8, content, "\n");
    var elf: usize = 0;
    while (lines.next()) |line| {
        if (line.len == 0) {
            try elfs.append(elf);
            elf = 0;
            continue;
        }
        elf += try std.fmt.parseInt(usize, line, 10);
    }
    return try elfs.toOwnedSlice();
}

fn maxCalories(content: []const u8) !usize {
    const elfs = try parseElfs(content);
    var max: usize = 0;
    for (elfs) |p| {
        if (p > max) max = p;
    }
    return max;
}

fn sumCalories(content: []const u8) !usize {
    var sum: usize = 0;
    const elfs = try parseElfs(content);
    std.sort.sort(usize, elfs, {}, std.sort.desc(usize));
    for (elfs[0..3]) |p| {
        sum += p;
    }
    return sum;
}

const test_content = @embedFile("inputs/day1.test");

test "test parseElfs" {
    const elfs = try parseElfs(test_content);
    try std.testing.expectEqual(@as(usize, 5), elfs.len);
    try std.testing.expectEqual(@as(usize, 6000), elfs[0]);
    try std.testing.expectEqual(@as(usize, 10000), elfs[4]);
}

test "test maxCalories" {
    const max = try maxCalories(test_content);
    try std.testing.expectEqual(@as(usize, 24000), max);
}

test "test sumCalories" {
    const sum = try sumCalories(test_content);
    try std.testing.expectEqual(@as(usize, 45000), sum);
}
