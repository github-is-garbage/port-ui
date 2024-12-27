## portui
Things in the global `portui` table.

`void portui.CompileInclude(string Path)` \
Runs `file.Read` and `CompileString` on the specified file path.

`string portui.GetCurrentPath(number Level = 2)` \
Gets the file path of the script at the given debug level.

`string portui.RelativePathToFull(string Path)` \
Converts a relative path (ex: `garrysmod/addons/../materials`) to a full path (ex: `garrysmod/materials`).

`string portui.GetRelativePath(string Addition, number Level = 3)` \
Turns a relative path from the current file into a full path using `portui.GetCurrentPath` and `portui.RelativePathToFull`.

`void portui.IncludeRelative(string Path)` \
Equivalent to `include` but with proper functionality with all files using the above listed functions.
