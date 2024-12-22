local ELEMENT = {}

AccessorFunc(ELEMENT, "m_Color", "Color", FORCE_COLOR)

function ELEMENT:Init()
	self:SetColor(Color(255, 255, 255, 255))
end

function ELEMENT:PaintBackground(RenderWidth, RenderHeight)
	surface.SetDrawColor(self:GetColor())
	surface.DrawRect(0, 0, RenderWidth, RenderHeight)
end

portui.Elements.Register("Colorbox", ELEMENT, "Base")
