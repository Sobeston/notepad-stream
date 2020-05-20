const std = @import("std");
const win = std.os.windows;

extern "User32" fn FindWindowA(lpClassName: ?[*:0]const u8, lpWindowName: ?[*:0]const u8) callconv(.Stdcall) ?*c_void;
extern "User32" fn FindWindowExA(hWndParent: ?win.HANDLE, hWndChildAfter: ?win.HANDLE, lpszClass: ?[*:0]const u8, lpszWindow: ?[*:0]const u8) callconv(.Stdcall) ?*c_void;
extern "User32" fn SendMessageA(hWnd: ?win.HANDLE, msg: win.UINT, wParam: win.WPARAM, lParam: win.LPARAM) callconv(.Stdcall) win.LRESULT;

pub const errors = error{ NotepadNotFound, EditPanelNotFound };
pub const OutStream = std.io.OutStream(void, errors, write);

pub fn write(self: void, bytes: []const u8) errors!usize {
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
        @intToPtr(win.LPARAM, @ptrToInt(bytes.ptr)),
    );
    return bytes.len;
}

pub fn outStream() OutStream {
    return .{ .context = void{} };
}
