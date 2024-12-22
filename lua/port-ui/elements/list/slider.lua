local Renderer = portui.Elements.Renderer

local ELEMENT = {}

AccessorFunc(ELEMENT, "m_flValue", "Value", FORCE_NUMBER)
AccessorFunc(ELEMENT, "m_iDecimalPoints", "DecimalPoints", FORCE_NUMBER)
AccessorFunc(ELEMENT, "m_flMinimumValue", "MinimumValue", FORCE_NUMBER)
AccessorFunc(ELEMENT, "m_flMaximumValue", "MaximumValue", FORCE_NUMBER)

function ELEMENT:Init()
	self.m_DragData = {}

	self:SetDecimalPoints(1)
	self:SetMinimumValue(0)
	self:SetMaximumValue(1)

	self:SetValue(0)
end

function ELEMENT:OnValueChanged(OldValue, NewValue)
	-- For override
end

function ELEMENT:SetValue(Value)
	Value = tonumber(Value) or 0

	local OldValue = self.m_flValue
	self.m_flValue = math.Clamp(math.Round(Value, self.m_iDecimalPoints), self.m_flMinimumValue, self.m_flMaximumValue)

	self:OnValueChanged(OldValue, self.m_flValue)
end

function ELEMENT:Think()
	if portui.Elements.Input.GetInputElement() ~= self then
		return
	end

	if not input.IsMouseDown(MOUSE_LEFT) then
		portui.Elements.Input.StopGrabbingInput()
		return
	end

	local ClickX = (gui.MouseX() - self:GetRelativeX()) + self.m_DragData.MouseX
	ClickX = self.m_DragData.MouseX - ClickX
	ClickX = -ClickX -- It's backwards for some reason

	local ValueX = math.Remap(ClickX, 0, self:GetWidth(), self.m_flMinimumValue, self.m_flMaximumValue)
	self:SetValue(ValueX)
end

function ELEMENT:PaintBackground() end

function ELEMENT:PaintForeground(RenderWidth, RenderHeight)
	local EdgeOffset = self:CalculatePixelsHeight(1)

	local ValuePercentage = math.Remap(self.m_flValue, self.m_flMinimumValue, self.m_flMaximumValue, 0, 1)
	local ValueX = RenderWidth * ValuePercentage

	ValueX = math.Clamp(ValueX, 0, RenderWidth - EdgeOffset)

	surface.SetDrawColor(0, 0, 0, 255)
	surface.DrawLine(ValueX, 0, ValueX, RenderHeight)
	surface.DrawLine(0, RenderHeight * 0.5, RenderWidth, RenderHeight * 0.5)
end

function ELEMENT:OnLeftClick(MouseX)
	self.m_DragData.MouseX = MouseX
	-- self.m_DragData.MouseY = MouseY -- TODO: Vertical sliders

	portui.Elements.Input.StartGrabbingInput(self)
end

portui.Elements.Register("Slider", ELEMENT, "Base")
