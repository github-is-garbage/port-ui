local Renderer = portui.Elements.Renderer

local ELEMENT = {}

AccessorFunc(ELEMENT, "m_bChecked", "Checked", FORCE_BOOL)

function ELEMENT:OnValueChanged(OldValue, NewValue)
	-- For override
end

function ELEMENT:SetChecked(Checked)
	Checked = tobool(Checked)

	local OldValue = self.m_bChecked
	self.m_bChecked = Checked

	if OldValue == self.m_bChecked then return end

	self:OnValueChanged(OldValue, self.m_bChecked)
end

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
	if self:GetChecked() then
		Renderer.SwapPortRect()
		do
			local X, Y = self:GetRelativePos()

			surface.SetFont(self:GetFontName())
			surface.SetTextColor(255, 255, 255, 255)

			local Text = "✓"
			local TextWidth, TextHeight = surface.GetTextSize(Text)

			local TextX = (Width * 0.5) - (TextWidth * 0.5)
			local TextY = (Height * 0.5) - (TextHeight * 0.5)

			surface.SetTextPos(X + TextX, Y + TextY)
			surface.DrawText(Text)
		end
		Renderer.UnSwapPortRect()
	end
end

function ELEMENT:OnLeftClick()
	self:SetChecked(not self:GetChecked())
end

portui.Elements.Register("Checkbox", ELEMENT, "Base")
