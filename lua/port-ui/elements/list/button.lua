local Renderer = portui.Elements.Renderer

local ELEMENT = {}

AccessorFunc(ELEMENT, "m_strText", "Text", FORCE_STRING)

function ELEMENT:PaintBackground(Width, Height)
	local WidthOffset = self:CalculatePixelsWidth(1)
	local HeightOffset = self:CalculatePixelsHeight(1)

	Width = Width - WidthOffset
	Height = Height - HeightOffset

	surface.SetDrawColor(0, 0, 0, 255)
	surface.DrawLine(0, 0, Width, 0)
	surface.DrawLine(Width, 0, Width, Height)
	surface.DrawLine(Width, Height, 0, Height)
	surface.DrawLine(0, Height, 0, 0)
end

function ELEMENT:PaintForeground(Width, Height)
	Renderer.SwapPortRect()
	do
		local X, Y = self:GetRelativePos()
		Width, Height = self:GetSize()

		surface.SetFont(self:GetFontName())
		surface.SetTextColor(255, 255, 255, 255)

		local Text = self:GetText()
		local TextWidth, TextHeight = surface.GetTextSize(Text)

		surface.SetTextPos(X + ((Width * 0.5) - (TextWidth * 0.5)), Y + ((Height * 0.5) - (TextHeight * 0.5))) -- Center the text
		surface.DrawText(Text)
	end
	Renderer.UnSwapPortRect()
end

portui.Elements.Register("Button", ELEMENT, "Base")
