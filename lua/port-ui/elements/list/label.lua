local Renderer = portui.Elements.Renderer

local ELEMENT = {}

AccessorFunc(ELEMENT, "m_strText", "Text", FORCE_STRING)

function ELEMENT:Init()
	self:SetText("Label")
end

function ELEMENT:SetText(Text)
	self.m_strText = tostring(Text)

	self:InvalidateLayout()
end

function ELEMENT:PaintBackground() end

function ELEMENT:PaintForeground()
	local Text = self:GetText()

	if string.len(Text) > 0 then
		Renderer.SwapPortRect()
		do
			local X, Y = self:GetRelativePos()

			surface.SetFont(self:GetFontName())
			surface.SetTextColor(255, 255, 255, 255)
			surface.SetTextPos(X + 1, Y + 1)
			surface.DrawText(Text)
		end
		Renderer.UnSwapPortRect()
	end
end

function ELEMENT:PerformLayout()
	surface.SetFont(self:GetFontName())
	local TextWidth, TextHeight = surface.GetTextSize(self.m_strText)

	self:SetSize(TextWidth + 2, TextHeight + 2) -- Pixel edges that don't get counted for some reason
end

portui.Elements.Register("Label", ELEMENT, "Base")
