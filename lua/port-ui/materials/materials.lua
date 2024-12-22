portui.Materials = portui.Materials or {}
local Materials = portui.Materials

-- TODO: Keep path folders
function Materials.TransferToData(Path)
	local Data = file.Read("materials/" .. Path, "GAME")

	if not isstring(Data) then
		return error("Failed to read non-existent material " .. Path)
	end

	if string.len(Data) < 1 then
		return error("Failed to read material " .. Path)
	end

	local FileName = string.GetFileFromFilename(Path)

	file.Write(FileName, Data)
end
