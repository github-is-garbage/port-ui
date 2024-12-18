local Renderer = portui.Elements.Renderer

local ELEMENT = {}

AccessorFunc(ELEMENT, "m_strText", "Text", FORCE_STRING)

function ELEMENT:PaintBackground(RenderWidth, RenderHeight)
	local WidthOffset = self:CalculatePixelsWidth(1)
	local HeightOffset = self:CalculatePixelsHeight(1)

	RenderWidth = RenderWidth - WidthOffset
	RenderHeight = RenderHeight - HeightOffset

	surface.SetDrawColor(0, 0, 0, 255)
	surface.DrawLine(0, 0, RenderWidth, 0)
	surface.DrawLine(RenderWidth, 0, RenderWidth, RenderHeight)
	surface.DrawLine(RenderWidth, RenderHeight, 0, RenderHeight)
	surface.DrawLine(0, RenderHeight, 0, 0)
end

function ELEMENT:PaintForeground(RenderWidth, RenderHeight, Width, Height)
	Renderer.SwapPortRect()
	do
		local X, Y = self:GetRelativePos()

		surface.SetFont(self:GetFontName())
		surface.SetTextColor(255, 255, 255, 255)

		local Text = self:GetText()
		local TextWidth, TextHeight = surface.GetTextSize(Text)

		local TextX = (Width * 0.5) - (TextWidth * 0.5)
		local TextY = (Height * 0.5) - (TextHeight * 0.5)

		surface.SetTextPos(X + TextX, Y + TextY)
		surface.DrawText(Text)
	end
	Renderer.UnSwapPortRect()
end

portui.Elements.Register("Button", ELEMENT, "Base")
