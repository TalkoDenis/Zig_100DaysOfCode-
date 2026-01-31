const std = @import("std");

// Pointers
fn swap(a: *u32, b: *u32) void {
    const temp = a.*;
    a.* = b.*;
    b.* = temp;
}

// Partitiof for QuickSort
fn partition(arr: [*]u32, low: isize, high: isize) isize {
    const pivot = arr[@intCast(high)];
    var i = low - 1;
    var j = low;

    while (j < high) : (j += 1) {
        if (arr[@intCast(j)] < pivot) {
            i += 1;
            swap(&arr[@intCast(i)], &arr[@intCast(j)]);
        }
    }
    swap(&arr[@intCast(i + 1)], &arr[@intCast(high)]);
    return i + 1;
}

// Quick Sort
fn quickSort(arr: [*]u32, low: isize, high: isize) void {
    if (low < high) {
        const pi = partition(arr, low, high);
        quickSort(arr, low, pi - 1);
        quickSort(arr, pi + 1, high);
    }
}

pub fn main() !void {
    const allocator = std.heap.page_allocator;
    const stdin = std.io.getStdIn().reader();
    const stdout = std.io.getStdOut().writer();

    var arr_ptr: [*]u32 = undefined;

    var arr_len: usize = 0;

    var arr_cap: usize = 0;

    var buffer: [1024]u8 = undefined;
    try stdout.print("Put numbers:\n", .{});
    while (try stdin.readUntilDelimiterOrEof(&buffer, '\n')) |line| {
        var it = std.mem.splitScalar(u8, line, ' ');

        while (it.next()) |chunk| {
            const trimmed = std.mem.trim(u8, chunk, "\r\t ");
            if (trimmed.len == 0) continue;

            const num = std.fmt.parseInt(u32, trimmed, 10) catch {
                try stdout.print("Ignored: '{s}' is not a number\n", .{trimmed});
                continue;
            };

            if (num == 0) continue;

            if (arr_len >= arr_cap) {
                const new_cap = if (arr_cap == 0) 16 else arr_cap * 2;

                const new_slice = try allocator.alloc(u32, new_cap);
                const new_ptr = new_slice.ptr;

                if (arr_cap > 0) {
                    @memcpy(new_ptr[0..arr_len], arr_ptr[0..arr_len]);

                    allocator.free(arr_ptr[0..arr_cap]);
                }

                arr_ptr = new_ptr;
                arr_cap = new_cap;

                try stdout.print("[debug] Realloc: {d} -> {d} items\n", .{ arr_len, arr_cap });
            }

            arr_ptr[arr_len] = num;
            arr_len += 1;
        }
    }

    if (arr_len > 0) {
        quickSort(arr_ptr, 0, @as(isize, @intCast(arr_len)) - 1);
    }

    try stdout.print("\nResult:\n", .{});
    var i: usize = 0;
    while (i < arr_len) : (i += 1) {
        try stdout.print("{d} ", .{arr_ptr[i]});
    }
    try stdout.print("\n", .{});

    if (arr_cap > 0) {
        allocator.free(arr_ptr[0..arr_cap]);
    }
}
