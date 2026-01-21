const std = @import("std");

pub fn main() void {
    const years: u16 = 35;
    const days: u16 = years * 365;
    std.debug.print("I have {d} years and {d} days\n", .{ years, days });
}
