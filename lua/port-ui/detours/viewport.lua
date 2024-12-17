render.SetViewPort_Real = render.SetViewPort_Real or render.SetViewPort

local ViewPortX, ViewPortY = 0, 0
local ViewPortWidth, ViewPortHeight = ScrW(), ScrH()

function render.SetViewPort(X, Y, Width, Height)
	ViewPortX = X
	ViewPortY = Y
	ViewPortWidth = Width
	ViewPortHeight = Height

	render.SetViewPort_Real(X, Y, Width, Height)
end

function render.GetViewPort()
	return ViewPortX, ViewPortY, ViewPortWidth, ViewPortHeight
end
