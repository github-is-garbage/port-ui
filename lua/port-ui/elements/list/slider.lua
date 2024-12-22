local ELEMENT = {}

AccessorFunc(ELEMENT, "m_flValue", "Value", FORCE_NUMBER)
AccessorFunc(ELEMENT, "m_iDecimalPoints", "DecimalPoints", FORCE_NUMBER)
AccessorFunc(ELEMENT, "m_flMinimumValue", "MinimumValue", FORCE_NUMBER)
AccessorFunc(ELEMENT, "m_flMaximumValue", "MaximumValue", FORCE_NUMBER)
AccessorFunc(ELEMENT, "m_bVertical", "Vertical", FORCE_BOOL)

function ELEMENT:Init()
	self.m_DragData = {}

	self:SetDecimalPoints(1)
	self:SetMinimumValue(0)
	self:SetMaximumValue(1)

	self:SetValue(0)
	self:SetVertical(false)

	-- Knob
	local Base = FindMetaTable("portui_Base")
	local ButtonBase = FindMetaTable("portui_Button")

	local Knob = portui.Elements.Create("Button")
	Knob:SetParent(self)
	Knob:SetText("")
	Knob:SetHasInputEnabled(false)

	function Knob:PaintBackground(RenderWidth, RenderHeight, Width, Height)
		Base.PaintBackground(self, RenderWidth, RenderHeight, Width, Height)
		ButtonBase.PaintBackground(self, RenderWidth, RenderHeight, Width, Height)
	end

	self.m_Knob = Knob
end

function ELEMENT:OnValueChanged(OldValue, NewValue)
	-- For override
end

function ELEMENT:SetValue(Value)
	Value = tonumber(Value) or 0

	local OldValue = self.m_flValue
	self.m_flValue = math.Clamp(math.Round(Value, self.m_iDecimalPoints), self.m_flMinimumValue, self.m_flMaximumValue)

	if self.m_flValue == OldValue then return end

	self:OnValueChanged(OldValue, self.m_flValue)

	self:InvalidateLayout()
end

function ELEMENT:Think()
	if portui.Elements.Input.GetInputElement() ~= self then
		return
	end

	if not input.IsMouseDown(MOUSE_LEFT) then
		portui.Elements.Input.StopGrabbingInput()
		return
	end

	local Vertical = self:GetVertical()

	local DragPos = Vertical and self.m_DragData.MouseY or self.m_DragData.MouseX
	local MousePos = Vertical and gui.MouseY() or gui.MouseX()
	local RelativePos = Vertical and self:GetRelativeY() or self:GetRelativeX()

	local ClickPos = (MousePos - RelativePos) + DragPos
	ClickPos = DragPos - ClickPos
	ClickPos = -ClickPos -- It's backwards for some reason

	local ValuePos = math.Remap(ClickPos, 0, Vertical and self:GetHeight() or self:GetWidth(), self.m_flMinimumValue, self.m_flMaximumValue)
	self:SetValue(ValuePos)
end

function ELEMENT:PaintBackground() end

function ELEMENT:PaintForeground(RenderWidth, RenderHeight)
	surface.SetDrawColor(0, 0, 0, 255)

	if self:GetVertical() then
		surface.DrawLine(RenderWidth * 0.5, 0, RenderWidth * 0.5, RenderHeight)
	else
		surface.DrawLine(0, RenderHeight * 0.5, RenderWidth, RenderHeight * 0.5)
	end
end

function ELEMENT:OnLeftClick(MouseX, MouseY)
	self.m_DragData.MouseX = MouseX
	self.m_DragData.MouseY = MouseY

	portui.Elements.Input.StartGrabbingInput(self)
end

function ELEMENT:PerformLayout(Width, Height)
	local Vertical = self:GetVertical()

	local ValuePercentage = math.Remap(self.m_flValue, self.m_flMinimumValue, self.m_flMaximumValue, 0, 1)

	local KnobWidth = Vertical and Width or (Height * 0.5)
	local KnobHeight = Vertical and (Width * 0.5) or Height
	local KnobBound = Vertical and Height or Width

	local ValuePos = (Vertical and Height or Width) * ValuePercentage
	ValuePos = math.Clamp(ValuePos, 0, KnobBound - (Vertical and KnobHeight or KnobWidth))

	self.m_Knob:SetSize(KnobWidth, KnobHeight)

	if Vertical then
		self.m_Knob:SetY(ValuePos)
	else
		self.m_Knob:SetX(ValuePos)
	end
end

portui.Elements.Register("Slider", ELEMENT, "Base")
