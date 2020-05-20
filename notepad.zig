const std = @import("std");
const win = std.os.windows;

extern "User32" fn FindWindowA(lpClassName: ?[*:0]const u8, lpWindowName: ?[*:0]const u8) callconv(.Stdcall) ?*c_void;
extern "User32" fn FindWindowExA(hWndParent: ?win.HANDLE, hWndChildAfter: ?win.HANDLE, lpszClass: ?[*:0]const u8, lpszWindow: ?[*:0]const u8) callconv(.Stdcall) ?*c_void;
extern "User32" fn SendMessageA(hWnd: ?win.HANDLE, msg: win.UINT, wParam: win.WPARAM, lParam: ?[*:0]const u8) callconv(.Stdcall) win.LRESULT;

pub const errors = @typeInfo(@typeInfo(@TypeOf(write)).Fn.return_type.?).ErrorUnion.error_set;
pub const OutStream = std.io.OutStream(@This(), errors, write);

mem: *std.mem.Allocator,

pub fn init(allocator: *std.mem.Allocator) @This() {
    return .{ .mem = allocator };
}

pub fn write(self: @This(), bytes: []const u8) !usize {
    const buf = try self.mem.allocSentinel(u8, bytes.len, 0);
    std.mem.copy(u8, buf, bytes);
    defer self.mem.free(buf);

    const EM_REPLACESEL = 0xC2;
    _ = SendMessageA(
        FindWindowExA(
            FindWindowA(null, "Untitled - Notepad") orelse return error.NotepadNotFound,
            null,
            "EDIT",
            null,
        ) orelse return error.EditPanelNotFound,
        EM_REPLACESEL,
        1,
        buf.ptr,
    );
    return bytes.len;
}

pub fn outStream(self: @This()) OutStream {
    return .{ .context = self };
}
