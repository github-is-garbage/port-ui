local ELEMENT = {}

-- TODO: Fix bars and cube handles not initializing correctly
function ELEMENT:Init()
	self.m_matColors = Material("port-ui/colors.png")

	self.m_ColorCube = self:AddChild("ColorCube", LEFT)

	function self.m_ColorCube:OnValueChanged(NewColor)
		self:GetParent():UpdateColor(NewColor)
	end

	self.m_ColorBar = self:AddChild("ColorBar", RIGHT)
	self.m_ColorBar:SetWidth(20)
	self.m_ColorBar:SetDecimalPoints(0)
	self.m_ColorBar:SetMaximumValue(255)

	function self.m_ColorBar:OnValueChanged(OldValue, NewValue)
		local NewColor = self:GetBarColor()

		-- Keep our friends in sync
		self:GetParent().m_AlphaBar:SetColor(NewColor)
		self:GetParent().m_AlphaBar:UpdateColor(NewColor)
		self:GetParent().m_ColorCube:SetColor(NewColor)

		self:GetParent():UpdateColor(NewColor)
	end

	self.m_AlphaBar = self:AddChild("AlphaBar", RIGHT)
	self.m_AlphaBar:SetWidth(20)
	self.m_AlphaBar:SetDecimalPoints(0)
	self.m_AlphaBar:SetMaximumValue(255)

	function self.m_AlphaBar:OnValueChanged(OldValue, NewValue)
		local NewColor = self:GetParent():GetColor()

		self:GetParent().m_AlphaBar:SetColor(NewColor)
		self:GetParent().m_AlphaBar:UpdateColor(NewColor)
		self:GetParent().m_ColorCube:SetColor(NewColor)

		self:GetParent():UpdateColor(NewColor)
	end

	self.m_Color = Color(255, 255, 255, 255) -- Make sure the cube and bar is valid before calling
end

function ELEMENT:OnValueChanged(NewColor)
	-- For override
end

function ELEMENT:GetColor()
	return self.m_Color
end

function ELEMENT:SetColor(Color)
	self.m_Color = Color

	self.m_ColorCube:SetColor(self.m_Color)
	self.m_ColorBar:SetColor(self.m_Color)
	self.m_AlphaBar:SetColor(self.m_Color)

	self:OnValueChanged(self.m_Color)
end

function ELEMENT:UpdateColor(Color) -- Update by reference
	self.m_Color.r = Color.r
	self.m_Color.g = Color.g
	self.m_Color.b = Color.b
	self.m_Color.a = Color.a

	self:OnValueChanged(self.m_Color)
end

function ELEMENT:PaintBackground(RenderWidth, RenderHeight) end
function ELEMENT:PaintForeground(RenderWidth, RenderHeight) end

function ELEMENT:OnSizeChanged(OldWidth, OldHeight, NewWidth, NewHeight)
	self.m_ColorCube:SetSize(NewHeight, NewHeight)
end

portui.Elements.Register("ColorPicker", ELEMENT, "Base")
