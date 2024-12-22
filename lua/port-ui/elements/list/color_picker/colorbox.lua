local ELEMENT = {}

AccessorFunc(ELEMENT, "m_Color", "Color", FORCE_COLOR)

function ELEMENT:Init()
	self:SetColor(Color(255, 255, 255, 255))
end

function ELEMENT:PaintBackground(RenderWidth, RenderHeight)
	surface.SetDrawColor(self:GetColor())
	surface.DrawRect(0, 0, RenderWidth, RenderHeight)
end

function ELEMENT:OnValueChanged(NewColor)
	-- For override
end

function ELEMENT:OnLeftClick()
	if IsValid(self.m_PopupWindow) then
		self.m_PopupWindow:Remove()
	end

	local PopupWindow = portui.Elements.Create("PopupWindow")
	PopupWindow:SetTitle("Choose Color")
	PopupWindow:SetSize(200, 172)
	self.m_PopupWindow = PopupWindow

	local ColorPicker = PopupWindow:AddChild("ColorPicker", FILL)
	ColorPicker:SetColor(self:GetColor())
	ColorPicker.m_ColorBox = self

	function ColorPicker:OnValueChanged(NewColor)
		if not IsValid(self.m_ColorBox) then return end

		self.m_ColorBox.m_Color.r = NewColor.r
		self.m_ColorBox.m_Color.g = NewColor.g
		self.m_ColorBox.m_Color.b = NewColor.b
		self.m_ColorBox.m_Color.a = NewColor.a

		self.m_ColorBox:OnValueChanged(self.m_ColorBox:GetColor())
	end
end

portui.Elements.Register("Colorbox", ELEMENT, "Base")
