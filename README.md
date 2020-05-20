# notepad-stream
```zig
const notepad = @import("notepad.zig");

pub fn main() !void {
    try notepad.outStream().print("hello world!\n", .{});
}
```
