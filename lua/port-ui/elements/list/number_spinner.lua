local ELEMENT = {}

AccessorFunc(ELEMENT, "m_flValue", "Value", FORCE_NUMBER)
AccessorFunc(ELEMENT, "m_iDecimalPoints", "DecimalPoints", FORCE_NUMBER)
AccessorFunc(ELEMENT, "m_flMinimumValue", "MinimumValue", FORCE_NUMBER)
AccessorFunc(ELEMENT, "m_flMaximumValue", "MaximumValue", FORCE_NUMBER)
AccessorFunc(ELEMENT, "m_flSteps", "Step", FORCE_NUMBER)

function ELEMENT:Init()
	self:SetDecimalPoints(1)
	self:SetMinimumValue(0)
	self:SetMaximumValue(1)
	self:SetStep(0.1)

	self:SetValue(0)

	-- Decrease
	self.m_Decrease = self:AddChild("Button", LEFT)
	self.m_Decrease:SetText("-")
	self.m_Decrease:SetDockMargin(0, 4, 0, 0)

	function self.m_Decrease:OnLeftClick()
		local Parent = self:GetParent()
		Parent:SetValue(Parent:GetValue() - Parent:GetStep())
	end

	-- Increase
	self.m_Increase = self:AddChild("Button", RIGHT)
	self.m_Increase:SetText("+")

	function self.m_Increase:OnLeftClick()
		local Parent = self:GetParent()
		Parent:SetValue(Parent:GetValue() + Parent:GetStep())
	end

	-- Label
	self.m_Label = self:AddChild("Label", FILL)
	self.m_Label:SetText(self:GetValue())
end

function ELEMENT:OnValueChanged(OldValue, NewValue)
	-- For override
end

function ELEMENT:SetValue(Value)
	Value = tonumber(Value) or 0

	-- These values won't exist until after :Init has ran
	local DecimalPoints = self:GetDecimalPoints() or 0
	local Minimum = self:GetMinimumValue() or 0
	local Maximum = self:GetMaximumValue() or 0

	local OldValue = self.m_flValue
	self.m_flValue = math.Clamp(math.Round(Value, DecimalPoints), Minimum, Maximum)

	if self.m_flValue == OldValue then return end

	if IsValid(self.m_Label) then
		self.m_Label:SetText(tostring(self.m_flValue))
	end

	self:OnValueChanged(OldValue, self.m_flValue)
end

function ELEMENT:SetDecimalPoints(DecimalPoints)
	self.m_iDecimalPoints = tonumber(DecimalPoints) or 0

	self:SetValue(self:GetValue())
end

function ELEMENT:SetMinimumValue(Value)
	self.m_flMinimumValue = tonumber(Value) or 0

	self:SetValue(self:GetValue())
end

function ELEMENT:SetMaximumValue(Value)
	self.m_flMaximumValue = tonumber(Value) or 0

	self:SetValue(self:GetValue())
end

function ELEMENT:PaintBackground() end

function ELEMENT:OnSizeChanged(OldWidth, OldHeight, NewWidth, NewHeight)
	self.m_Decrease:SetSize(NewHeight, NewHeight)
	self.m_Increase:SetSize(NewHeight, NewHeight)
end

portui.Elements.Register("NumberSpinner", ELEMENT, "Base")
