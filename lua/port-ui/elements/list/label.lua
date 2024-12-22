local Renderer = portui.Elements.Renderer

local ELEMENT = {}

AccessorFunc(ELEMENT, "m_strText", "Text", FORCE_STRING)

function ELEMENT:Init()
	self:SetText("Label")
end

function ELEMENT:SetText(Text)
	self.m_strText = tostring(Text)

	surface.SetFont(self:GetFontName())
	local TextWidth, TextHeight = surface.GetTextSize(self.m_strText)

	self:SetSize(TextWidth + 2, TextHeight + 2) -- Pixel edges that don't get counted for some reason
end

function ELEMENT:PaintBackground() end

function ELEMENT:PaintForeground()
	Renderer.SwapPortRect()
	do
		local X, Y = self:GetRelativePos()

		surface.SetFont(self:GetFontName())
		surface.SetTextColor(255, 255, 255, 255)
		surface.SetTextPos(X + 1, Y + 1)
		surface.DrawText(self:GetText())
	end
	Renderer.UnSwapPortRect()
end

portui.Elements.Register("Label", ELEMENT, "Base")
