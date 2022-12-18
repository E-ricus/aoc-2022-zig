const std = @import("std");
const print = std.debug.print;

// Day input
const day_content = @embedFile("inputs/day3.input");

pub fn run(allocator: std.mem.Allocator) !void {
    const rucks = try rucksacks(day_content, allocator);
    print("Rucksacks: {}\n", .{rucks});
    const badgs = try badges(day_content, allocator);
    print("Badges: {}\n", .{badgs});
}

fn rucksacks(content: []const u8, allocator: std.mem.Allocator) !usize {
    var lines = std.mem.split(u8, std.mem.trimRight(u8, content, "\n"), "\n");
    var sum: usize = 0;
    while (lines.next()) |line| {
        var items = std.AutoHashMap(u8, void).init(allocator);
        defer items.deinit();
        const mid = line.len / 2;
        const first = line[0..mid];
        const second = line[mid..];
        for (first) |c| {
            try items.put(c, {});
        }
        for (second) |c| {
            if (items.contains(c)) {
                sum += charToPrio(c);
                break;
            }
        }
    }
    return sum;
}

fn badges(content: []const u8, allocator: std.mem.Allocator) !usize {
    var lines = std.mem.split(u8, content, "\n");
    var sum: usize = 0;
    var ctrl: usize = 1;
    var items = std.AutoHashMap(u8, u8).init(allocator);
    defer items.deinit();

    while (lines.next()) |line| : (ctrl += 1) {
        for (line) |c| {
            const entry = try items.getOrPut(c);
            if (entry.found_existing and entry.value_ptr.* + 1 == ctrl) {
                entry.value_ptr.* += 1;
            } else if (!entry.found_existing) {
                entry.value_ptr.* = 1;
            }
        }

        if (ctrl < 3) continue;

        var iter_items = items.iterator();
        while (iter_items.next()) |entry| {
            if (entry.value_ptr.* == 3) {
                sum += charToPrio(entry.key_ptr.*);
                break;
            }
        }
        ctrl = 0;
        items.deinit();
        items = std.AutoHashMap(u8, u8).init(allocator);
    }
    return sum;
}

// Tranform the character to the priority
// 'a' = 1
// ..
// 'z' = 26
// 'A' = 27
fn charToPrio(c: u8) usize {
    if (c >= 97 and c <= 122) {
        return c - 'a' + 1;
    } else {
        return c - 'A' + 27;
    }
}

const test_content = @embedFile("inputs/day3.test");
const test_allocator = std.testing.allocator;

test "test rucksacks" {
    const rest = try rucksacks(test_content, test_allocator);
    try std.testing.expectEqual(@as(usize, 157), rest);
}

test "test badges" {
    const rest = try badges(test_content, test_allocator);
    try std.testing.expectEqual(@as(usize, 70), rest);
}
