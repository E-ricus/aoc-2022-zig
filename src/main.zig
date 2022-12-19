const std = @import("std");
const print = std.debug.print;

const day1 = @import("day1.zig");
const day2 = @import("day2.zig");
const day3 = @import("day3.zig");
const day4 = @import("day4.zig");

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const alloc = arena.allocator();
    try day1.run(alloc);
    try day2.run(alloc);
    try day3.run(alloc);
    try day4.run(alloc);
}

test {
    @import("std").testing.refAllDecls(@This());
}
