local Renderer = portui.Elements.Renderer

local ELEMENT = {}

AccessorFunc(ELEMENT, "m_iTitleBarHeight", "TitleBarHeight", FORCE_NUMBER)
AccessorFunc(ELEMENT, "m_bDraggable", "Draggable", FORCE_BOOL)
AccessorFunc(ELEMENT, "m_bResizable", "Resizable", FORCE_BOOL)
AccessorFunc(ELEMENT, "m_iResizeTolerance", "ResizeTolerance", FORCE_NUMBER)

function ELEMENT:Init()
	self.m_DragData = {}

	self:SetTitleBarHeight(20)
	self:SetDraggable(true)
	self:SetResizable(true)
	self:SetResizeTolerance(10)

	self:SetMinimumSize(75, 75)
	self:SetDockPadding(4, 4, self:GetTitleBarHeight() + 4, 4)

	-- Title
	local Title = portui.Elements.Create("Label")
	Title:SetParent(self)
	Title:SetText("Window")
	Title:SetHasInputEnabled(false)

	self.m_Title = Title

	-- Close Button
	local ButtonBase = FindMetaTable("portui_Button")

	local CloseButton = portui.Elements.Create("Button")
	CloseButton:SetParent(self)
	CloseButton:SetText("X")
	CloseButton:SetSize(self:GetTitleBarHeight() * 0.8, self:GetTitleBarHeight() * 0.8)

	function CloseButton:PaintBackground(RenderWidth, RenderHeight, Width, Height)
		surface.SetDrawColor(255, 0, 0, 255)
		surface.DrawRect(0, 0, RenderWidth, RenderHeight)

		ButtonBase.PaintBackground(self, RenderWidth, RenderHeight, Width, Height)
	end

	function CloseButton:OnLeftClick()
		self:GetParent():Remove()
	end

	self.m_CloseButton = CloseButton
end

function ELEMENT:GetTitle()
	return self.m_Title:GetText()
end

function ELEMENT:SetTitle(Title)
	self.m_Title:SetText(Title)
end

function ELEMENT:Think()
	if portui.Elements.Input.GetInputElement() ~= self then
		return
	end

	if not input.IsMouseDown(MOUSE_LEFT) then
		portui.Elements.Input.StopGrabbingInput()
		return
	end

	if self.m_DragData.Dragging then
		local NewX = gui.MouseX() - self.m_DragData.MouseX
		local NewY = gui.MouseY() - self.m_DragData.MouseY

		NewX = math.Clamp(NewX, 0, Renderer.ScreenWidth)
		NewY = math.Clamp(NewY, 0, Renderer.ScreenHeight)

		self:SetX(NewX)
		self:SetY(NewY)
	else
		if self.m_DragData.SizeRight then
			self:SetWidth(gui.MouseX() - self.m_DragData.MouseX)
		end

		if self.m_DragData.SizeBottom then
			self:SetHeight(gui.MouseY() - self.m_DragData.MouseY)
		end
	end
end

function ELEMENT:PaintForeground(RenderWidth, RenderHeight)
	local TitleBarHeight = self:GetTitleBarHeight()
	local TitleBarRenderHeight = self:CalculatePixelsHeight(TitleBarHeight)

	surface.SetDrawColor(100, 100, 100, 255)
	surface.DrawRect(0, 0, RenderWidth, TitleBarRenderHeight)

	surface.SetDrawColor(0, 0, 0, 255)
	surface.DrawLine(0, TitleBarRenderHeight, RenderWidth, TitleBarRenderHeight)

	-- Normal border
	local WidthOffset = self:CalculatePixelsWidth(1)
	local HeightOffset = self:CalculatePixelsHeight(1)

	RenderWidth = RenderWidth - WidthOffset
	RenderHeight = RenderHeight - HeightOffset

	surface.DrawLine(0, 0, RenderWidth, 0)
	surface.DrawLine(RenderWidth, 0, RenderWidth, RenderHeight)
	surface.DrawLine(RenderWidth, RenderHeight, 0, RenderHeight)
	surface.DrawLine(0, RenderHeight, 0, 0)
end

function ELEMENT:OnLeftClick(MouseX, MouseY)
	if MouseY <= self:GetTitleBarHeight() then
		if self:GetDraggable() then
			self.m_DragData.Dragging = true

			self.m_DragData.MouseX = MouseX
			self.m_DragData.MouseY = MouseY

			portui.Elements.Input.StartGrabbingInput(self)
		end
	elseif self:GetResizable() then -- TODO: Resizing along left and top edges
		self.m_DragData.Dragging = false

		local Width, Height = self:GetSize()
		local ResizeTolerance = self:GetResizeTolerance()

		if MouseX >= Width - ResizeTolerance and MouseY >= Height - ResizeTolerance then -- Bottom right corner resizes both
			self.m_DragData.SizeRight = true
			self.m_DragData.SizeBottom = true
		else
			self.m_DragData.SizeRight = MouseX >= Width - ResizeTolerance
			self.m_DragData.SizeBottom = MouseY >= Height - ResizeTolerance
		end

		self.m_DragData.MouseX = gui.MouseX() - Width
		self.m_DragData.MouseY = gui.MouseY() - Height

		portui.Elements.Input.StartGrabbingInput(self)
	end
end

function ELEMENT:PerformLayout(Width, Height)
	local TitleBarHeight = self:GetTitleBarHeight()

	local TitleWidth, TitleHeight = self.m_Title:GetTextSize() -- Use text size because the panel may not have been laid out yet
	self.m_Title:SetY((TitleBarHeight * 0.5) - (TitleHeight * 0.5))
	self.m_Title:SetX(self.m_Title:GetY() + 3) -- Little bump over

	local CloseButtonWidth, CloseButtonHeight = self.m_CloseButton:GetSize()
	self.m_CloseButton:SetY((TitleBarHeight * 0.5) - (CloseButtonHeight * 0.5))
	self.m_CloseButton:SetX(Width - CloseButtonWidth - self.m_CloseButton:GetY())
end

portui.Elements.Register("Window", ELEMENT, "Base")
