local Renderer = portui.Elements.Renderer

local ELEMENT = {}

AccessorFunc(ELEMENT, "m_Color", "Color", FORCE_COLOR)
AccessorFunc(ELEMENT, "m_ClickX", "ClickX", FORCE_NUMBER)
AccessorFunc(ELEMENT, "m_ClickY", "ClickY", FORCE_NUMBER)

function ELEMENT:Init()
	self.m_DragData = {}

	self.m_Color = Color(255, 255, 255, 255)
	self.m_BaseColor = Color(255, 255, 255, 255)

	self.m_matRight = Material("vgui/gradient-r")
	self.m_matDown = Material("vgui/gradient-d")
end

function ELEMENT:SetColor(RealColor)
	self.m_Color = RealColor

	self.m_BaseColor = HSVToColor(ColorToHSV(RealColor), 1, 1)

	local NewColor
	local X, Y = self:GetClickX(), self:GetClickY()

	if not X or not Y then
		self:SetClickX(0)
		self:SetClickY(0)

		NewColor = Color(RealColor.r, RealColor.g, RealColor.b, RealColor.a)
	else
		X = math.Remap(X, 0, self:GetWidth(), 0, 1)
		Y = math.Remap(Y, 0, self:GetHeight(), 0, 1)

		local Hue = ColorToHSV(self.m_BaseColor)
		local Saturation = 1 - X
		local Value = 1 - Y

		NewColor = HSVToColor(Hue, Saturation, Value)
	end

	self.m_Color.r = NewColor.r
	self.m_Color.g = NewColor.g
	self.m_Color.b = NewColor.b
end

function ELEMENT:OnValueChanged(NewColor)
	-- For override
end

function ELEMENT:UpdateColor(X, Y)
	self:SetClickX(X)
	self:SetClickY(Y)

	self:SetColor(self:GetColor())
end

function ELEMENT:Think()
	if portui.Elements.Input.GetInputElement() ~= self then
		return
	end

	if not input.IsMouseDown(MOUSE_LEFT) then
		portui.Elements.Input.StopGrabbingInput()
		return
	end

	local ClickX = (gui.MouseX() - self:GetRelativeX()) + self.m_DragData.MouseX
	ClickX = self.m_DragData.MouseX - ClickX
	ClickX = -ClickX

	local ClickY = (gui.MouseY() - self:GetRelativeY()) + self.m_DragData.MouseY
	ClickY = self.m_DragData.MouseY - ClickY
	ClickY = -ClickY

	ClickX = math.Clamp(ClickX, 0, self:GetWidth())
	ClickY = math.Clamp(ClickY, 0, self:GetHeight())

	self:UpdateColor(ClickX, ClickY)
	self:OnValueChanged(self:GetColor())
end

function ELEMENT:PaintBackground(RenderWidth, RenderHeight)
	surface.SetDrawColor(self.m_BaseColor)
	surface.DrawRect(0, 0, RenderWidth, RenderHeight)

	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetMaterial(self.m_matRight)
	surface.DrawTexturedRect(0, 0, RenderWidth, RenderHeight)

	surface.SetDrawColor(0, 0, 0, 255)
	surface.SetMaterial(self.m_matDown)
	surface.DrawTexturedRect(0, 0, RenderWidth, RenderHeight)
end

function ELEMENT:PaintForeground(RenderWidth, RenderHeight, Width, Height)
	local WidthOffset = self:CalculatePixelsWidth(1)
	local HeightOffset = self:CalculatePixelsHeight(1)

	RenderWidth = RenderWidth - WidthOffset
	RenderHeight = RenderHeight - HeightOffset

	surface.SetDrawColor(0, 0, 0, 255)
	surface.DrawLine(0, 0, RenderWidth, 0)
	surface.DrawLine(RenderWidth, 0, RenderWidth, RenderHeight)
	surface.DrawLine(RenderWidth, RenderHeight, 0, RenderHeight)
	surface.DrawLine(0, RenderHeight, 0, 0)

	local ClickX = self:CalculatePixelsWidth(self:GetClickX())
	local ClickY = self:CalculatePixelsHeight(self:GetClickY())

	surface.DrawLine(0, ClickY, RenderWidth, ClickY)
	surface.DrawLine(ClickX, 0, ClickX, RenderHeight)
end

function ELEMENT:OnLeftClick(MouseX, MouseY)
	self.m_DragData.MouseX = MouseX
	self.m_DragData.MouseY = MouseY

	portui.Elements.Input.StartGrabbingInput(self)
end

portui.Elements.Register("ColorCube", ELEMENT, "Base")
