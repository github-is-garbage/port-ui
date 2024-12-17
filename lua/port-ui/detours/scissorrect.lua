render.SetScissorRect_Real = render.SetScissorRect_Real or render.SetScissorRect

local ScissorX, ScissorY = 0, 0
local ScissorZ, ScissorW = ScrW(), ScrH()
local ScissorState = false

function render.SetScissorRect(X, Y, Z, W, State)
	ScissorX = X
	ScissorY = Y
	ScissorZ = Z
	ScissorW = W
	ScissorState = State

	render.SetScissorRect_Real(X, Y, Z, W, State)
end

function render.GetScissorRect()
	return ScissorX, ScissorY, ScissorZ, ScissorW, ScissorState
end
