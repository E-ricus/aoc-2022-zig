const print = @import("std").debug.print;

const day1 = @import("day1.zig");

pub fn main() !void {
    try day1.run();
}

test {
    @import("std").testing.refAllDecls(@This());
}
