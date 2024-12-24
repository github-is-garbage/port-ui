local Renderer = portui.Elements.Renderer

local ELEMENT = {}

AccessorFunc(ELEMENT, "m_strText", "Text", FORCE_STRING)

function ELEMENT:Init()
	self:SetText("Label")
end

function ELEMENT:SetText(Text)
	Text = tostring(Text)
	if Text == self.m_strText then return end

	self.m_strText = Text

	self:InvalidateLayout()
end

function ELEMENT:GetTextSize()
	surface.SetFont(self:GetFontName())
	local TextWidth, TextHeight = surface.GetTextSize(self.m_strText)

	return TextWidth + 2, TextHeight + 2 -- Pixel edges that don't get counted for some reason
end

function ELEMENT:PaintBackground() end

function ELEMENT:PaintForeground(RenderWidth, RenderHeight, Width, Height)
	local Text = self:GetText()

	if string.len(Text) > 0 then
		Renderer.SwapPortRect()
		do
			local X, Y = self:GetRelativePos()

			surface.SetFont(self:GetFontName())
			surface.SetTextColor(255, 255, 255, 255)
			surface.SetTextPos(X + 1, Y + (Height * 0.15)) -- 0.15 because the Label's size is the text size
			surface.DrawText(Text)
		end
		Renderer.UnSwapPortRect()
	end
end

function ELEMENT:PerformLayout()
	if self:GetDock() == NODOCK then
		self:SetSize(self:GetTextSize())
	end
end

portui.Elements.Register("Label", ELEMENT, "Base")
