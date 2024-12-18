local Renderer = portui.Elements.Renderer

local ELEMENT = {}

AccessorFunc(ELEMENT, "m_strText", "Text", FORCE_STRING)
AccessorFunc(ELEMENT, "m_bSelected", "Selected", FORCE_BOOL)
AccessorFunc(ELEMENT, "m_strGroupName", "GroupName", FORCE_STRING)

function ELEMENT:Init()
	self:SetGroupName(tostring({})) -- Random default group

	hook.Add("port-ui:RadioButtonGroupMemberChanged", self, self.OnGroupMemberChanged)
end

function ELEMENT:SetSelected(Selected)
	self.m_bSelected = tobool(Selected)

	if self:GetSelected() then
		self:OnSelected()
	else
		self:OnUnSelected()
	end

	hook.Run("port-ui:RadioButtonGroupMemberChanged", self, self.m_bSelected)
end

function ELEMENT:PaintBackground(RenderWidth, RenderHeight, Width, Height)
	Renderer.SwapPortRect()
	do
		local X, Y = self:GetRelativePos()
		local Radius = Height * 0.33

		surface.DrawCircle(X + Radius, Y + (Height * 0.5), Radius, 0, 0, 0, 255)

		if self:GetSelected() then
			-- Because polygons suck and can't have rendertargets in menu state
			surface.DrawCircle(X + Radius, Y + (Height * 0.5), Radius * 0.5, 0, 0, 0, 255)
		end
	end
	Renderer.UnSwapPortRect()
end

function ELEMENT:PaintForeground(RenderWidth, RenderHeight, Width, Height)
	Renderer.SwapPortRect()
	do
		local X, Y = self:GetRelativePos()
		local Radius = Height * 0.33

		surface.SetFont(self:GetFontName())
		surface.SetTextColor(255, 255, 255, 255)

		local Text = self:GetText()
		local _, TextHeight = surface.GetTextSize(Text)

		surface.SetTextPos(X + (Radius * 2) + 3, Y + ((Height * 0.5) - (TextHeight * 0.5)))
		surface.DrawText(Text)
	end
	Renderer.UnSwapPortRect()
end

function ELEMENT:OnSelected()
	-- For override
end

function ELEMENT:OnUnSelected()
	-- For override
end

function ELEMENT:OnLeftClick()
	if not self:GetSelected() then
		self:SetSelected(true)
	end
end

-- A radio button has just had its value changed, check if it's in our group
function ELEMENT:OnGroupMemberChanged(Element, Value)
	if Element == self then return end
	if Element:GetGroupName() ~= self:GetGroupName() then return end

	if self:GetSelected() then
		-- Manually run to avoid infinite back and forth
		self.m_bSelected = false
		self:OnUnSelected()
	end
end

portui.Elements.Register("RadioButton", ELEMENT, "Button")
