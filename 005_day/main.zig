const std = @import("std");

pub fn main() !void {
    const numbers = [_]i32{ 1, 2, 3, 4, 5 };

    var sum_numbers: i32 = 0;

    for (numbers) |num| {
        sum_numbers += num;
        std.debug.print("Now sum is {}\n", .{sum_numbers});
    }

    std.debug.print("Final sum is {}", .{sum_numbers});
}
