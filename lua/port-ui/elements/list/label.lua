local Renderer = portui.Elements.Renderer

local ELEMENT = {}

AccessorFunc(ELEMENT, "m_strText", "Text", FORCE_STRING)

function ELEMENT:SetText(Text)
	self.m_strText = tostring(Text)

	surface.SetFont(self:GetFontName())
	self:SetSize(surface.GetTextSize(self.m_strText))
end

function ELEMENT:PaintBackground(Width, Height)

end

function ELEMENT:PaintForeground(Width, Height)
	Renderer.SwapPortRect() -- Absolutely rapes text rendering, can't fix that
	do
		local X, Y = self:GetRelativePos()

		surface.SetFont(self:GetFontName())
		surface.SetTextColor(255, 255, 255, 255)
		surface.SetTextPos(X, Y)
		surface.DrawText(self:GetText())
	end
	Renderer.UnSwapPortRect()
end

portui.Elements.Register("Label", ELEMENT, "Base")
