local Renderer = portui.Elements.Renderer

local ELEMENT = {}

AccessorFunc(ELEMENT, "m_Color", "Color", FORCE_COLOR)

function ELEMENT:Init()
	self.m_DragData = {}

	self:SetColor(Color(255, 255, 255, 255))

	self.m_matRight = Material("vgui/gradient-r")
	self.m_matDown = Material("vgui/gradient-d")
end

function ELEMENT:SetColor(RealColor)
	self.m_Color = RealColor

	self.m_BaseColor = Color(RealColor.r, RealColor.g, RealColor.b, 255)
end

function ELEMENT:OnValueChanged(NewColor)
	-- For override
end

function ELEMENT:UpdateColor(X, Y)
	X = math.Remap(X, 0, self:GetWidth(), 0, 1)
	Y = math.Remap(Y, 0, self:GetHeight(), 0, 1)

	local Hue = ColorToHSV(self:GetColor())
	local Saturation = 1 - X
	local Value = 1 - Y

	local NewColor = HSVToColor(Hue, Saturation, Value)

	-- Don't update base color
	self.m_Color.r = NewColor.r
	self.m_Color.g = NewColor.g
	self.m_Color.b = NewColor.b
	self.m_Color.a = NewColor.a

	self:OnValueChanged(self:GetColor())
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

function ELEMENT:OnLeftClick(MouseX, MouseY)
	self.m_DragData.MouseX = MouseX
	self.m_DragData.MouseY = MouseY

	portui.Elements.Input.StartGrabbingInput(self)
end

portui.Elements.Register("ColorCube", ELEMENT, "Base")
