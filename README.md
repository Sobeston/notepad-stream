# notepad-stream
```zig
const notepad = @import("notepad.zig");

pub fn main() !void {
    try notepad.init(std.heap.page_allocator).outStream().print("hello world!\n", .{});
}
```
