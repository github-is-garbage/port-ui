local Renderer = portui.Elements.Renderer

local ELEMENT = {}

ELEMENT.KeyTranslations = {
	[KEY_SPACE] = " ",

	[KEY_PAD_0] = "0",
	[KEY_PAD_1] = "1",
	[KEY_PAD_2] = "2",
	[KEY_PAD_3] = "3",
	[KEY_PAD_4] = "4",
	[KEY_PAD_5] = "5",
	[KEY_PAD_6] = "6",
	[KEY_PAD_7] = "7",
	[KEY_PAD_9] = "9"
}

AccessorFunc(ELEMENT, "m_strText", "Text", FORCE_STRING)

function ELEMENT:Init()
	self:SetText("")

	hook.Add("port-ui:ElementLeftClicked", self, self.OnElementClicked)
	hook.Add("port-ui:ElementRightClicked", self, self.OnElementClicked)
	hook.Add("port-ui:ElementMiddleClicked", self, self.OnElementClicked)
end

function ELEMENT:OnValueChanged(OldValue, NewValue)
	-- For override
end

function ELEMENT:Think()
	if portui.Elements.Input.GetInputElement() ~= self then
		return
	end

	local PressedKey = input.CheckKeyTrapping()

	if not PressedKey then
		input.StartKeyTrapping()
		return
	end

	if PressedKey == KEY_ESCAPE or PressedKey > KEY_BACKSPACE then
		portui.Elements.Input.StopGrabbingInput()
		return
	end

	-- TODO: Capital letters
	local CurrentText = self:GetText()

	if PressedKey == KEY_BACKSPACE then
		self:SetText(string.Left(CurrentText, string.len(CurrentText) - 1))
	else
		local KeyText = self.KeyTranslations[PressedKey] or input.GetKeyName(PressedKey)

		self:SetText(CurrentText .. KeyText)
	end

	self:OnValueChanged(CurrentText, self:GetText())
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
	local Text = self:GetText()

	if string.len(Text) > 0 then
		Renderer.SwapPortRect()
		do
			local X, Y = self:GetRelativePos()

			surface.SetFont(self:GetFontName())
			surface.SetTextColor(255, 255, 255, 255)

			local TextWidth, TextHeight = surface.GetTextSize(Text)

			local TextY = (Height * 0.5) - (TextHeight * 0.5)

			if TextWidth >= Width * 0.95 then
				local CharacterSize = surface.GetTextSize("W")
				local WidthInCharacters = (Width * 0.95) / CharacterSize

				Text = string.sub(Text, -WidthInCharacters)
			end

			surface.SetTextPos(X + 3, Y + TextY)
			surface.DrawText(Text)
		end
		Renderer.UnSwapPortRect()
	end
end

function ELEMENT:OnLeftClick()
	input.StartKeyTrapping()

	portui.Elements.Input.StartGrabbingInput(self)
end

function ELEMENT:OnElementClicked(ClickedElement)
	if ClickedElement == self then return end
	if ClickedElement:IsChildOf(self) then return end

	portui.Elements.Input.StopGrabbingInput()
end

portui.Elements.Register("Textbox", ELEMENT, "Base")
