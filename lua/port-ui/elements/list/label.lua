local Renderer = portui.Elements.Renderer

local ELEMENT = {}

AccessorFunc(ELEMENT, "m_strText", "Text", FORCE_STRING)

function ELEMENT:Init()
	self.m_DragData = {}
end

function ELEMENT:SetText(Text)
	self.m_strText = tostring(Text)

	surface.SetFont("BudgetLabel")
	self:SetSize(surface.GetTextSize(self.m_strText))
end

function ELEMENT:PaintBackground(Width, Height)

end

function ELEMENT:PaintForeground(Width, Height)
	Renderer.KillViewPort() -- Absolutely rapes text rendering, can't fix that
	do
		local X, Y = self:GetRelativePos()

		surface.SetFont("BudgetLabel")
		surface.SetTextColor(255, 255, 255, 255)
		surface.SetTextPos(X, Y)
		surface.DrawText(self:GetText())
	end
	Renderer.RestoreViewPort()
end

portui.Elements.Register("Label", ELEMENT, "Base")
