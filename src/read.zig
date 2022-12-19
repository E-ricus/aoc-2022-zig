const std = @import("std");

pub fn readInputFile(allocator: std.mem.Allocator, comptime name: []const u8) ![]const u8 {
    const file = try std.fs.cwd().openFile("inputs/" ++ name, .{});
    defer file.close();
    const stat = try file.stat();
    const fileSize = stat.size;
    return try file.reader().readAllAlloc(allocator, fileSize);
}
