local Renderer = portui.Elements.Renderer

local ELEMENT = {}

AccessorFunc(ELEMENT, "m_strTitle", "Title", FORCE_STRING)

function ELEMENT:Init()
	self.m_DragData = {}

	self:SetTitle("Window")
end

function ELEMENT:Think()
	if portui.Elements.Input.GetInputElement() ~= self then
		return
	end

	if not input.IsMouseDown(MOUSE_LEFT) then
		portui.Elements.Input.StopGrabbingInput()
		return
	end

	self:SetX(gui.MouseX() - self.m_DragData.MouseX)
	self:SetY(gui.MouseY() - self.m_DragData.MouseY)
end

function ELEMENT:PaintBackground(Width, Height)
	surface.SetDrawColor(255, 255, 255, 150)
	surface.DrawRect(0, 0, Width, Height)
end

function ELEMENT:PaintForeground(Width, Height)
	local TitleBarHeight = self:CalculatePixelsHeight(12)

	surface.SetDrawColor(100, 100, 100, 255)
	surface.DrawRect(0, 0, Width, TitleBarHeight)

	surface.SetDrawColor(0, 0, 0, 255)
	surface.DrawLine(0, TitleBarHeight, Width, TitleBarHeight)

	-- Normal border
	local WidthOffset = self:CalculatePixelsWidth(1)
	local HeightOffset = self:CalculatePixelsHeight(1)

	Width = Width - WidthOffset
	Height = Height - HeightOffset

	surface.DrawLine(0, 0, Width, 0)
	surface.DrawLine(Width, 0, Width, Height)
	surface.DrawLine(Width, Height, 0, Height)
	surface.DrawLine(0, Height, 0, 0)

	-- Title
	Renderer.KillViewPort() -- Absolutely rapes text rendering, cant fix that
	do
		local X, Y = self:GetRelativePos()

		surface.SetFont("BudgetLabel")
		surface.SetTextColor(255, 255, 255, 255)
		surface.SetTextPos(X + 3, Y)
		surface.DrawText(self:GetTitle())
	end
	Renderer.RestoreViewPort()
end

function ELEMENT:OnLeftClick(MouseX, MouseY)
	if MouseY > 12 then return end

	self.m_DragData.MouseX = MouseX
	self.m_DragData.MouseY = MouseY

	portui.Elements.Input.StartGrabbingInput(self)
end

portui.Elements.Register("Window", ELEMENT, "Base")
