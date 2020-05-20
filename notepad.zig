const std = @import("std");
const win = std.os.windows;

extern "User32" fn FindWindowA(lpClassName: ?[*:0]const u8, lpWindowName: ?[*:0]const u8) callconv(.Stdcall) *c_void;
extern "User32" fn FindWindowExA(hWndParent: ?win.HANDLE, hWndChildAfter: ?win.HANDLE, lpszClass: ?[*:0]const u8, lpszWindow: ?[*:0]const u8) callconv(.Stdcall) *c_void;
extern "User32" fn SendMessageA(hWnd: ?win.HANDLE, msg: win.UINT, wParam: win.WPARAM, lParam: win.LPARAM) callconv(.Stdcall) win.LRESULT;

pub const NotepadOutStream = struct {
    pub const OutStream = std.io.OutStream(*@This(), error{}, write);

    pub fn init() @This() {
        return .{};
    }

    pub fn outStream(self: *@This()) OutStream {
        return .{ .context = self };
    }

    pub fn write(self: *@This(), bytes: []const u8) error{}!usize {
        const EM_REPLACESEL = 0xC2;
        _ = SendMessageA(
            FindWindowExA(FindWindowA(null, "Untitled - Notepad"), null, "EDIT", null),
            EM_REPLACESEL,
            1,
            @intToPtr(win.LPARAM, @ptrToInt(bytes.ptr)),
        );
        return bytes.len;
    }
};
