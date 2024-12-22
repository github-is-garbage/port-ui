local Renderer = portui.Elements.Renderer

local ELEMENT = {}

function ELEMENT:Init()
	self.m_Checkbox = self:AddChild("Checkbox", LEFT)

	function self.m_Checkbox:OnValueChanged(OldValue, NewValue)
		-- Passthrough
		self:GetParent():OnValueChanged(OldValue, NewValue)
	end

	self.m_Label = self:AddChild("Label", FILL)
	self.m_Label:SetText("Checkbox")
	self.m_Label:SetHasInputEnabled(false) -- Clickthrough to the container
end

function ELEMENT:PaintBackground() end
function ELEMENT:PaintForeground() end

function ELEMENT:OnValueChanged(OldValue, NewValue)
	-- For override
end

function ELEMENT:GetChecked()
	return self.m_Checkbox:GetChecked()
end

function ELEMENT:SetChecked(Checked)
	self.m_Checkbox:SetChecked(Checked)
end

function ELEMENT:SetText(Text)
	self.m_Label:SetText(Text)

	self:InvalidateLayout()
end

function ELEMENT:OnLeftClick()
	self:SetChecked(not self:GetChecked())
end

function ELEMENT:OnSizeChanged(OldWidth, OldHeight, NewWidth, NewHeight)
	self.m_Checkbox:SetSize(NewHeight, NewHeight)
end

portui.Elements.Register("LabeledCheckbox", ELEMENT, "Base")
