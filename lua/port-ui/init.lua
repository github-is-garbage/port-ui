portui = portui or {}

-- include is bad on menu state
function portui.CompileInclude(Path)
	if not file.Exists(Path, "GAME") then
		return
	end

	local Extension = string.GetExtensionFromFilename(Path)

	if Extension ~= "lua" then
		return
	end

	local ExtensionOffset = string.len(Extension) + 2 -- First character + .

	local ModuleName = string.GetFileFromFilename(Path)
	ModuleName = string.sub(ModuleName, 0, -ExtensionOffset)

	local ModuleContent = file.Read(Path, "GAME")
	local ModuleFunction = CompileString(ModuleContent, Path, false)

	if not isfunction(ModuleFunction) then
		ErrorNoHalt(ModuleFunction, "\n")

		return
	end

	ModuleFunction()
end

function portui.GetCurrentPath(Level)
	local Source = debug.getinfo(Level or 2)

	if not Source or not Source.short_src then
		return "[C]"
	end

	return string.GetPathFromFilename(Source.short_src)
end

function portui.RelativePathToFull(Path)
	local Stack = util.Stack()
	local RelativeBlocks = string.Split(Path, "/")

	for i = 1, #RelativeBlocks do
		local Block = RelativeBlocks[i]

		if string.len(Block) < 1 then continue end
		if Block == "." then continue end

		if Block == ".." then
			if Stack:Size() > 0 then
				Stack:Pop()
			end

			continue
		end

		Stack:Push(Block)
	end

	local FullBlocks = Stack:PopMulti(Stack:Size())
	FullBlocks = table.Reverse(FullBlocks)

	return table.concat(FullBlocks, "/")
end

function portui.GetRelativePath(Addition, Level)
	local Source = portui.GetCurrentPath(Level or 3)

	local RelativeBlocks = table.Add(string.Split(Source, "/"), string.Split(Addition, "/"))

	return portui.RelativePathToFull(table.concat(RelativeBlocks, "/"))
end

function portui.IncludeRelative(Addition)
	local Path = portui.GetRelativePath(Addition, 4)

	portui.CompileInclude(Path)
end

portui.IncludeRelative("includes.lua")
