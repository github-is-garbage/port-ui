local Renderer = portui.Elements.Renderer

local ELEMENT = {}

function ELEMENT:Init()
	self.m_Checkbox = self:AddChild("Checkbox", LEFT)

	function self.m_Checkbox:OnValueChanged(OldValue, NewValue)
		-- Passthrough
		self:GetParent():OnValueChanged(OldValue, NewValue)
	end

	self.m_Label = self:AddChild("Label")
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
end

function ELEMENT:OnLeftClick()
	self:SetChecked(not self:GetChecked())
end

function ELEMENT:PerformLayout(Width, Height)
	self.m_Checkbox:SetSize(Height, Height)

	local _, LabelHeight = self.m_Label:GetSize()
	self.m_Label:SetPos(Height + 3, (Height * 0.5) - (LabelHeight * 0.5)) -- Center the label vertically offset from the checkbox

	self:SizeToChildren(true, false)
end

portui.Elements.Register("LabeledCheckbox", ELEMENT, "Base")
