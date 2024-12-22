local SliderMeta = FindMetaTable("portui_Slider")

local ELEMENT = {}

AccessorFunc(ELEMENT, "m_Color", "Color", FORCE_COLOR)

function ELEMENT:Init()
	SliderMeta.Init(self)
	self:SetVertical(true)
	self.m_Knob:SetVisible(false)

	self:SetColor(Color(255, 255, 255, 255))
	self:SetMaterial("../data/colors.png")
end

function ELEMENT:GetMaterial()
	return self.m_Material
end

function ELEMENT:SetMaterial(Path)
	self.m_Material = Material(Path)
end

function ELEMENT:GetBarColor()
	local Position = math.Remap(self:GetValue(), self:GetMinimumValue(), self:GetMaximumValue(), 0, self.m_Material:Height() - 1)

	return self.m_Material:GetColor(self.m_Material:Width() * 0.5, Position)
end

function ELEMENT:PaintBackground(RenderWidth, RenderHeight)
	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetMaterial(self:GetMaterial())
	surface.DrawTexturedRect(0, 0, RenderWidth, RenderHeight)
end

function ELEMENT:PaintForeground(RenderWidth, RenderHeight)
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

portui.Elements.Register("ColorBar", ELEMENT, "Slider")
