local Renderer = portui.Elements.Renderer

local ELEMENT = {}

AccessorFunc(ELEMENT, "m_strFontName", "FontName", FORCE_STRING)
AccessorFunc(ELEMENT, "m_bLayingOut", "LayingOut", FORCE_BOOL)

function ELEMENT:IsValid()
	return self.m_bValid
end

function ELEMENT:Remove()
	self.m_bValid = false
	portui.Elements.UnStore(self)

	for ChildIndex = #self.m_Children, 1, -1 do
		self.m_Children[ChildIndex]:Remove()
		self.m_Children[ChildIndex] = nil
	end
end

--[[
	Hooks
--]]

function ELEMENT:InternalInit()
	self.m_iX = 0
	self.m_iY = 0
	self.m_iMinimumWidth = 0
	self.m_iMinimumHeight = 0
	self.m_iWidth = 0
	self.m_iHeight = 0

	self.m_bVisible = true
	self.m_bValid = true
	self.m_bInputEnabled = true
	self:SetFontName("BudgetLabel")

	self.m_Parent = nil
	self.m_Children = {}

	self.m_bHasDirtyLayout = true

	-- Docking stuff
	self.m_iDock = NODOCK

	self.m_iDockLeftOffset = 0
	self.m_iDockRightOffset = 0
	self.m_iDockTopOffset = 0
	self.m_iDockBottomOffset = 0

	self.m_iDockPaddingLeft = 0
	self.m_iDockPaddingRight = 0
	self.m_iDockPaddingTop = 0
	self.m_iDockPaddingBottom = 0

	self.m_iDockMarginLeft = 0
	self.m_iDockMarginRight = 0
	self.m_iDockMarginTop = 0
	self.m_iDockMarginBottom = 0
end

function ELEMENT:Init()
	-- For override
	self:SetDockPadding(4, 4, 4, 4)
end

function ELEMENT:Think() -- Called BEFORE painting
	-- For override
end

function ELEMENT:PaintBackground(RenderWidth, RenderHeight, Width, Height) -- Render relative to element space, clipped
	-- For override
	surface.SetDrawColor(255, 255, 255, 150)
	surface.DrawRect(0, 0, RenderWidth, RenderHeight)
end

function ELEMENT:PaintForeground(RenderWidth, RenderHeight, Width, Height) -- Render relative to element space, clipped
	-- For override
	local WidthOffset = self:CalculatePixelsWidth(1)
	local HeightOffset = self:CalculatePixelsHeight(1)

	RenderWidth = RenderWidth - WidthOffset
	RenderHeight = RenderHeight - HeightOffset

	surface.SetDrawColor(0, 0, 0, 255)
	surface.DrawLine(0, 0, RenderWidth, 0) -- DrawOutlinedRect has its right and bottom edges cut off inside viewports for some reason
	surface.DrawLine(RenderWidth, 0, RenderWidth, RenderHeight)
	surface.DrawLine(RenderWidth, RenderHeight, 0, RenderHeight)
	surface.DrawLine(0, RenderHeight, 0, 0)
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

function ELEMENT:OnPositionChanged(OldX, OldY, NewX, NewY)
	-- For override
end

function ELEMENT:OnSizeChanged(OldWidth, OldHeight, NewWidth, NewHeight)
	-- For override
end

function ELEMENT:LayoutChild(Child)
	local Dock = Child:GetDock()

	if Dock ~= NODOCK then
		local X, Y = Child:GetPos()
		local Width, Height = Child:GetSize()

		local ParentWidth, ParentHeight = self:GetSize()

		local PaddingLeft, PaddingRight, PaddingTop, PaddingBottom = self:GetDockPadding()
		local MarginLeft, MarginRight, MarginTop, MarginBottom = Child:GetDockMargin()

		local OffsetLeft, OffsetRight, OffsetTop, OffsetBottom = self:GetDockingOffset()

		-- Offset the offsets if we're not the first child to avoid reapplying edge padding
		if OffsetLeft > 0 then
			OffsetLeft = OffsetLeft - PaddingLeft
		end

		if OffsetRight > 0 then
			OffsetRight = OffsetRight - PaddingRight
		end

		if OffsetTop > 0 then
			OffsetTop = OffsetTop - PaddingTop
		end

		if OffsetBottom > 0 then
			OffsetBottom = OffsetBottom - PaddingBottom
		end

		-- Layout according to dock type
		if Dock == FILL then
			X = PaddingLeft + OffsetLeft + MarginLeft
			Y = PaddingTop + OffsetTop + MarginTop

			Width = ParentWidth - ((PaddingLeft + PaddingRight) + (OffsetLeft + OffsetRight) + (MarginLeft + MarginRight))
			Height = ParentHeight - ((PaddingTop + PaddingBottom) + (OffsetTop + OffsetBottom) + (MarginTop + MarginBottom))
		elseif Dock == LEFT then
			if Width <= 0 then
				Width = ParentWidth * 0.25
			end

			X = PaddingLeft + OffsetLeft + MarginLeft
			Y = PaddingTop + OffsetTop + MarginTop

			Height = ParentHeight - ((PaddingTop + PaddingBottom) + (OffsetTop + OffsetBottom) + (MarginTop + MarginBottom))

			OffsetLeft = OffsetLeft + Width + MarginRight
		elseif Dock == RIGHT then
			if Width <= 0 then
				Width = ParentWidth * 0.25
			end

			X = ParentWidth - ((PaddingRight + OffsetRight + MarginRight) + Width)
			Y = PaddingTop + OffsetTop + MarginTop

			Height = ParentHeight - ((PaddingTop + PaddingBottom) + (OffsetTop + OffsetBottom) + (MarginTop + MarginBottom))

			OffsetRight = OffsetRight + Width + MarginLeft
		elseif Dock == TOP then
			if Height <= 0 then
				Height = ParentHeight * 0.25
			end

			X = PaddingLeft + OffsetLeft + MarginLeft
			Y = PaddingTop + OffsetTop + MarginTop

			Width = ParentWidth - ((PaddingLeft + PaddingRight) + (OffsetLeft + OffsetRight) + (MarginLeft + MarginRight))

			OffsetTop = OffsetTop + Height + MarginBottom
		elseif Dock == BOTTOM then
			if Height <= 0 then
				Height = ParentHeight * 0.25
			end

			X = PaddingLeft + OffsetLeft + MarginLeft
			Y = ParentHeight - ((PaddingBottom + OffsetBottom + MarginTop) + Height)

			Width = ParentWidth - ((PaddingLeft + PaddingRight) + (OffsetLeft + OffsetRight) + (MarginLeft + MarginRight))

			OffsetBottom = OffsetBottom + Height + MarginTop
		end

		-- Remove the offset of the offsets
		if OffsetLeft > 0 then
			OffsetLeft = OffsetLeft + PaddingLeft
		end

		if OffsetRight > 0 then
			OffsetRight = OffsetRight + PaddingRight
		end

		if OffsetTop > 0 then
			OffsetTop = OffsetTop + PaddingTop
		end

		if OffsetBottom > 0 then
			OffsetBottom = OffsetBottom + PaddingBottom
		end

		-- Update everyone
		self:UpdateDockingOffset(OffsetLeft, OffsetRight, OffsetTop, OffsetBottom)

		Child:SetPos(X, Y)
		Child:SetSize(Width, Height)
	end

	Child:LayoutChildren()
end

function ELEMENT:LayoutChildren()
	self:UpdateDockingOffset(0, 0, 0, 0)

	for ChildIndex = 1, #self.m_Children do
		self:LayoutChild(self.m_Children[ChildIndex])
	end
end

function ELEMENT:DoInternalLayout()
	self:SetLayingOut(true)
	do
		if self.m_bHasDirtyLayout then
			self:LayoutChildren()
			-- local Dock = self.m_iDock

			-- if Dock ~= NODOCK then
			-- 	local Parent = self.m_Parent

			-- 	if IsValid(Parent) then
			-- 		if not Parent:GetHasDirtyLayout() then
			-- 			-- TODO: Look into this shit and find a better solution

			-- 			-- This fixes some docking issues with the offset stacking but
			-- 			-- it also causes issues with the docking "flickering"
			-- 			-- as well as some bad performance because everything lays out constantly :/
			-- 			-- Parent:InvalidateLayout()
			-- 			-- Parent:InvalidateChildren(true)
			-- 		end

			-- 		local X, Y = self.m_iX, self.m_iY
			-- 		local Width, Height = self.m_iWidth, self.m_iHeight

			-- 		local ParentWidth, ParentHeight = Parent:GetSize()
			-- 		local Left, Right, Top, Bottom = Parent:GetDockPadding()

			-- 		local OffsetLeft, OffsetRight, OffsetTop, OffsetBottom = Parent:GetDockingOffset()




			-- 	end
			-- end

			self.m_bHasDirtyLayout = false
		end

		self:PerformLayout(self:GetSize())
	end
	self:SetLayingOut(false)
end

function ELEMENT:PerformLayout(Width, Height)
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

function ELEMENT:GetMinimumWidth()
	return self.m_iMinimumWidth
end

function ELEMENT:GetMinimumHeight()
	return self.m_iMinimumHeight
end

function ELEMENT:GetMinimumSize()
	return self.m_iMinimumWidth, self.m_iMinimumHeight
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

function ELEMENT:GetHasInputEnabled()
	if IsValid(self.m_Parent) then
		if not self.m_Parent:GetHasInputEnabled() then
			return false
		end
	end

	return self.m_bInputEnabled
end

function ELEMENT:GetParent()
	return self.m_Parent
end

function ELEMENT:GetChildren()
	return self.m_Children
end

function ELEMENT:CalculateChildrenSize()
	local ChildrenWidth, ChildrenHeight = 0, 0

	for ChildIndex = 1, #self.m_Children do
		local Child = self.m_Children[ChildIndex]

		ChildrenWidth = math.max(ChildrenWidth, Child:GetX() + Child:GetWidth())
		ChildrenHeight = math.max(ChildrenHeight, Child:GetY() + Child:GetHeight())
	end

	return ChildrenWidth, ChildrenHeight
end

function ELEMENT:GetHasDirtyLayout()
	return self.m_bHasDirtyLayout
end

function ELEMENT:GetDock()
	return self.m_iDock
end

function ELEMENT:GetDockingOffset()
	return self.m_iDockLeftOffset, self.m_iDockRightOffset, self.m_iDockTopOffset, self.m_iDockBottomOffset
end

function ELEMENT:GetDockPadding()
	return self.m_iDockPaddingLeft, self.m_iDockPaddingRight, self.m_iDockPaddingTop, self.m_iDockPaddingBottom
end

function ELEMENT:GetDockMargin()
	return self.m_iDockMarginLeft, self.m_iDockMarginRight, self.m_iDockMarginTop, self.m_iDockMarginBottom
end

function ELEMENT:AddChild(Child, Dock)
	if isstring(Child) then
		Child = portui.Elements.Create(Child)
	end

	if not IsValid(Child) then
		error("Got invalid Element in :AddChild!")
		return
	end

	Child:SetDock(Dock)
	Child:SetParent(self)

	self:InvalidateLayout()

	return Child
end

function ELEMENT:IsChildOf(Element)
	local Parent = self:GetParent()

	if not IsValid(Parent) then
		return false
	end

	if Element == Parent then
		return true
	end

	return Parent:IsChildOf(Element)
end

--[[
	Setters
--]]

function ELEMENT:SetX(X)
	local OldX = self.m_iX

	self.m_iX = tonumber(X) or 0

	if OldX == self.m_iX then return end

	self:OnPositionChanged(OldX, self.m_iY, self.m_iX, self.m_iY)
end

function ELEMENT:SetY(Y)
	local OldY = self.m_iY

	self.m_iY = tonumber(Y) or 0

	if OldY == self.m_iY then return end

	self:OnPositionChanged(self.m_iX, OldY, self.m_iX, self.m_iY)
end

function ELEMENT:SetPos(X, Y)
	local OldX, OldY = self.m_iX, self.m_iY

	self.m_iX = tonumber(X) or 0
	self.m_iY = tonumber(Y) or 0

	if OldX == self.m_iX and OldY == self.m_iY then return end

	self:OnPositionChanged(OldX, OldY, self.m_iX, self.m_iY)
end

function ELEMENT:SetMinimumWidth(Width)
	self.m_iMinimumWidth = tonumber(Width) or 0

	self:SetWidth(self:GetWidth())
end

function ELEMENT:SetMinimumHeight(Height)
	self.m_iMinimumHeight = tonumber(Height) or 0

	self:SetHeight(self:GetHeight())
end

function ELEMENT:SetMinimumSize(Width, Height)
	self.m_iMinimumWidth = tonumber(Width) or 0
	self.m_iMinimumHeight = tonumber(Height) or 0

	self:SetSize(self:GetSize())
end

function ELEMENT:SetWidth(Width)
	local OldWidth = self.m_iWidth

	self.m_iWidth = math.max(tonumber(Width) or 0, self.m_iMinimumWidth)

	if OldWidth == self.m_iWidth then return end

	self:InvalidateLayout()
	self:OnSizeChanged(OldWidth, self.m_iHeight, self.m_iWidth, self.m_iHeight)
end

function ELEMENT:SetHeight(Height)
	local OldHeight = self.m_iHeight

	self.m_iHeight = math.max(tonumber(Height) or 0, self.m_iMinimumHeight)

	if OldHeight == self.m_iHeight then return end

	self:InvalidateLayout()
	self:OnSizeChanged(self.m_iWidth, OldHeight, self.m_iWidth, self.m_iHeight)
end

function ELEMENT:SetSize(Width, Height)
	local OldWidth, OldHeight = self.m_iWidth, self.m_iHeight

	self.m_iWidth = math.max(tonumber(Width) or 0, self.m_iMinimumWidth)
	self.m_iHeight = math.max(tonumber(Height) or 0, self.m_iMinimumHeight)

	if OldWidth == self.m_iWidth and OldHeight == self.m_iHeight then return end

	self:InvalidateLayout()
	self:OnSizeChanged(OldWidth, OldHeight, self.m_iWidth, self.m_iHeight)
end

function ELEMENT:SizeToChildren(SizeWidth, SizeHeight)
	local ChildrenWidth, ChildrenHeight = self:CalculateChildrenSize()

	if SizeWidth and SizeHeight then
		self:SetSize(ChildrenWidth, ChildrenHeight)
	else
		if SizeWidth then
			self:SetWidth(ChildrenWidth)
		elseif SizeHeight then
			self:SetHeight(ChildrenHeight)
		end
	end
end

function ELEMENT:SetVisible(Visible)
	self.m_bVisible = tobool(Visible)
end

function ELEMENT:SetHasInputEnabled(Enabled)
	self.m_bInputEnabled = tobool(Enabled)
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

function ELEMENT:InvalidateLayout()
	if not self.m_bHasDirtyLayout and not self:GetLayingOut() then
		self.m_bHasDirtyLayout = true
	end
end

function ELEMENT:InvalidateChildren(Recursive)
	for ChildIndex = 1, #self.m_Children do
		self.m_Children[ChildIndex]:InvalidateLayout()

		if Recursive then
			self.m_Children[ChildIndex]:InvalidateChildren(true)
		end
	end
end

function ELEMENT:InvalidateParent(UpdateChildren)
	if not IsValid(self.m_Parent) then return end

	self.m_Parent:InvalidateLayout()

	if UpdateChildren then
		self.m_Parent:InvalidateChildren(true)
	end
end

function ELEMENT:SetDock(Dock)
	Dock = tonumber(Dock) or NODOCK

	if Dock < NODOCK or Dock > BOTTOM then
		Dock = NODOCK
	end

	self.m_iDock = Dock

	self:InvalidateLayout()
end

function ELEMENT:UpdateDockingOffset(Left, Right, Top, Bottom)
	self.m_iDockLeftOffset = tonumber(Left) or 0
	self.m_iDockRightOffset = tonumber(Right) or 0
	self.m_iDockTopOffset = tonumber(Top) or 0
	self.m_iDockBottomOffset = tonumber(Bottom) or 0
end

function ELEMENT:SetDockPadding(Left, Right, Top, Bottom)
	self.m_iDockPaddingLeft = tonumber(Left) or 0
	self.m_iDockPaddingRight = tonumber(Right) or 0
	self.m_iDockPaddingTop = tonumber(Top) or 0
	self.m_iDockPaddingBottom = tonumber(Bottom) or 0
end

function ELEMENT:SetDockMargin(Left, Right, Top, Bottom)
	self.m_iDockMarginLeft = tonumber(Left) or 0
	self.m_iDockMarginRight = tonumber(Right) or 0
	self.m_iDockMarginTop = tonumber(Top) or 0
	self.m_iDockMarginBottom = tonumber(Bottom) or 0
end

--[[
	Helpers
--]]

function ELEMENT:RegisterChild(Child)
	if not table.HasValue(self.m_Children, Child) then
		table.insert(self.m_Children, Child)

		self:InvalidateLayout()
	end
end

function ELEMENT:UnRegisterChild(Child)
	local Index = table.KeyFromValue(self.m_Children, Child)

	if Index then
		table.remove(self.m_Children, Index)

		self:InvalidateLayout()
	end
end

portui.Elements.Register("Base", ELEMENT)
