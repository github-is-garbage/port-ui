local Renderer = portui.Elements.Renderer

local ELEMENT = {}

function ELEMENT:IsValid()
	return self.m_bValid
end

--[[
	Hooks
--]]

function ELEMENT:InternalInit()
	self.m_iX = 0
	self.m_iY = 0
	self.m_iWidth = 0
	self.m_iHeight = 0

	self.m_bVisible = true
	self.m_bValid = true

	self.m_Parent = nil
	self.m_Children = {}
end

function ELEMENT:Init()
	-- For override
end

function ELEMENT:Think() -- Called BEFORE painting
	-- For override
end

function ELEMENT:PaintBackground(Width, Height) -- Render relative to element space, clipped
	-- For override
	surface.SetDrawColor(255, 255, 255, 150)
	surface.DrawRect(0, 0, Width, Height)
end

function ELEMENT:PaintForeground(Width, Height) -- Render relative to element space, clipped
	-- For override
	local WidthOffset = self:CalculatePixelsWidth(1)
	local HeightOffset = self:CalculatePixelsHeight(1)

	Width = Width - WidthOffset
	Height = Height - HeightOffset

	surface.SetDrawColor(0, 0, 0, 255)
	surface.DrawLine(0, 0, Width, 0) -- DrawOutlinedRect has its right and bottom edges cut off inside viewports for some reason
	surface.DrawLine(Width, 0, Width, Height)
	surface.DrawLine(Width, Height, 0, Height)
	surface.DrawLine(0, Height, 0, 0)
end

function ELEMENT:PostRenderChildren(X, Y, Width, Height) -- Render relative to screen space, unclipped
	-- For override
end

function ELEMENT:OnLeftClick(MouseX, MouseY) -- MouseX and MouseY in element space
	-- For override
end

function ELEMENT:OnRightClick(MouseX, MouseY) -- MouseX and MouseY in element space
	-- For override
end

function ELEMENT:OnMiddleClick(MouseX, MouseY) -- MouseX and MouseY in element space
	-- For override
end

--[[
	Getters
--]]

function ELEMENT:CalculatePixelsWidth(Pixels) -- The viewport fucks with aspect ratio, make sure our pixels are actual pixels
	return math.Remap(Pixels, 0, self.m_iWidth, 0, Renderer.ScreenWidth)
end

function ELEMENT:CalculatePixelsHeight(Pixels)
	return math.Remap(Pixels, 0, self.m_iHeight, 0, Renderer.ScreenHeight)
end

function ELEMENT:GetX()
	return self.m_iX
end

function ELEMENT:GetY()
	return self.m_iY
end

function ELEMENT:GetPos()
	return self.m_iX, self.m_iY
end

function ELEMENT:GetRelativeX()
	if IsValid(self.m_Parent) then
		return self.m_Parent:GetRelativeX() + self.m_iX
	else
		return self.m_iX
	end
end

function ELEMENT:GetRelativeY()
	if IsValid(self.m_Parent) then
		return self.m_Parent:GetRelativeY() + self.m_iY
	else
		return self.m_iY
	end
end

function ELEMENT:GetRelativePos()
	return self:GetRelativeX(), self:GetRelativeY()
end

function ELEMENT:GetWidth()
	return self.m_iWidth
end

function ELEMENT:GetHeight()
	return self.m_iHeight
end

function ELEMENT:GetSize()
	return self.m_iWidth, self.m_iHeight
end

function ELEMENT:GetVisible()
	return self.m_bVisible
end

function ELEMENT:GetParent()
	return self.m_Parent
end

function ELEMENT:GetChildren()
	return self.m_Children
end

--[[
	Setters
--]]

function ELEMENT:SetX(X)
	self.m_iX = tonumber(X) or 0
	self.m_iX = math.Clamp(self.m_iX, 0, Renderer.ScreenWidth) -- DirectX refuses to render viewports at x or y < 0
end

function ELEMENT:SetY(Y)
	self.m_iY = tonumber(Y) or 0
	self.m_iY = math.Clamp(self.m_iY, 0, Renderer.ScreenHeight)
end

function ELEMENT:SetPos(X, Y)
	self:SetX(X)
	self:SetY(Y)
end

function ELEMENT:SetWidth(Width)
	self.m_iWidth = tonumber(Width) or 0
end

function ELEMENT:SetHeight(Height)
	self.m_iHeight = tonumber(Height) or 0
end

function ELEMENT:SetSize(Width, Height)
	self:SetWidth(Width)
	self:SetHeight(Height)
end

function ELEMENT:SetVisible(Visible)
	self.m_bVisible = tobool(Visible)
end

function ELEMENT:SetParent(Parent)
	if IsValid(self.m_Parent) then
		self.m_Parent:UnRegisterChild(self)
	end

	self.m_Parent = Parent or nil

	if IsValid(self.m_Parent) then
		self.m_Parent:RegisterChild(self)
	end
end

--[[
	Helpers
--]]

function ELEMENT:RegisterChild(Child)
	if not table.HasValue(self.m_Children, Child) then
		table.insert(self.m_Children, Child)
	end
end

function ELEMENT:UnRegisterChild(Child)
	local Index = table.KeyFromValue(self.m_Children, Child)

	if Index then
		table.remove(self.m_Children, Index)
	end
end

portui.Elements.Register("Base", ELEMENT)
