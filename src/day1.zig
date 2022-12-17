const std = @import("std");
const print = std.debug.print;

// Day input
const day_content = @embedFile("inputs/day1.input");

pub fn run(allocator: std.mem.Allocator) !void {
    const max_cal = try maxCalories(day_content, allocator);
    print("Max calories: {}\n", .{max_cal});
    const sum_cal = try sumCalories(day_content, allocator);
    print("Sum calories: {}\n", .{sum_cal});
}

fn parseElfs(content: []const u8, allocator: std.mem.Allocator) ![]usize {
    var elfs = std.ArrayList(usize).init(allocator);
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

fn maxCalories(content: []const u8, allocator: std.mem.Allocator) !usize {
    const elfs = try parseElfs(content, allocator);
    defer allocator.free(elfs);
    return std.mem.max(usize, elfs);
}

fn sumCalories(content: []const u8, allocator: std.mem.Allocator) !usize {
    var sum: usize = 0;
    const elfs = try parseElfs(content, allocator);
    defer allocator.free(elfs);
    std.sort.sort(usize, elfs, {}, std.sort.desc(usize));
    for (elfs[0..3]) |p| {
        sum += p;
    }
    return sum;
}

const test_content = @embedFile("inputs/day1.test");

const test_allocator = std.testing.allocator;

test "test parseElfs" {
    const elfs = try parseElfs(test_content, test_allocator);
    defer test_allocator.free(elfs);
    try std.testing.expectEqual(@as(usize, 5), elfs.len);
    try std.testing.expectEqual(@as(usize, 6000), elfs[0]);
    try std.testing.expectEqual(@as(usize, 10000), elfs[4]);
}

test "test maxCalories" {
    const max = try maxCalories(test_content, test_allocator);
    try std.testing.expectEqual(@as(usize, 24000), max);
}

test "test sumCalories" {
    const sum = try sumCalories(test_content, test_allocator);
    try std.testing.expectEqual(@as(usize, 45000), sum);
}
