local Renderer = portui.Elements.Renderer

local ELEMENT = {}

AccessorFunc(ELEMENT, "m_strTitle", "Title", FORCE_STRING)
AccessorFunc(ELEMENT, "m_bDraggable", "Draggable", FORCE_BOOL)

function ELEMENT:Init()
	self:SetDockPadding(4, 4, 16, 4)

	self.m_DragData = {}

	self:SetTitle("Window")
	self:SetDraggable(true)
end

function ELEMENT:Think()
	if portui.Elements.Input.GetInputElement() ~= self then
		return
	end

	if not input.IsMouseDown(MOUSE_LEFT) then
		portui.Elements.Input.StopGrabbingInput()
		return
	end

	local NewX = gui.MouseX() - self.m_DragData.MouseX
	local NewY = gui.MouseY() - self.m_DragData.MouseY

	NewX = math.Clamp(NewX, 0, Renderer.ScreenWidth)
	NewY = math.Clamp(NewY, 0, Renderer.ScreenHeight)

	self:SetX(NewX)
	self:SetY(NewY)
end

function ELEMENT:PaintForeground(RenderWidth, RenderHeight)
	local TitleBarHeight = self:CalculatePixelsHeight(12)

	surface.SetDrawColor(100, 100, 100, 255)
	surface.DrawRect(0, 0, RenderWidth, TitleBarHeight)

	surface.SetDrawColor(0, 0, 0, 255)
	surface.DrawLine(0, TitleBarHeight, RenderWidth, TitleBarHeight)

	-- Normal border
	local WidthOffset = self:CalculatePixelsWidth(1)
	local HeightOffset = self:CalculatePixelsHeight(1)

	RenderWidth = RenderWidth - WidthOffset
	RenderHeight = RenderHeight - HeightOffset

	surface.DrawLine(0, 0, RenderWidth, 0)
	surface.DrawLine(RenderWidth, 0, RenderWidth, RenderHeight)
	surface.DrawLine(RenderWidth, RenderHeight, 0, RenderHeight)
	surface.DrawLine(0, RenderHeight, 0, 0)

	-- Title
	Renderer.SwapPortRect() -- Absolutely rapes text rendering, can't fix that
	do
		local X, Y = self:GetRelativePos()

		surface.SetFont(self:GetFontName())
		surface.SetTextColor(255, 255, 255, 255)
		surface.SetTextPos(X + 3, Y)
		surface.DrawText(self:GetTitle())
	end
	Renderer.UnSwapPortRect()
end

function ELEMENT:OnLeftClick(MouseX, MouseY)
	if not self:GetDraggable() then return end
	if MouseY > 12 then return end

	self.m_DragData.MouseX = MouseX
	self.m_DragData.MouseY = MouseY

	portui.Elements.Input.StartGrabbingInput(self)
end

portui.Elements.Register("Window", ELEMENT, "Base")
