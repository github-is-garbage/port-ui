local Renderer = portui.Elements.Renderer

local ELEMENT = {}

AccessorFunc(ELEMENT, "m_strTitle", "Title", FORCE_STRING)
AccessorFunc(ELEMENT, "m_iTitleBarHeight", "TitleBarHeight", FORCE_NUMBER)
AccessorFunc(ELEMENT, "m_bDraggable", "Draggable", FORCE_BOOL)

function ELEMENT:Init()
	self.m_DragData = {}

	self:SetTitle("Window")
	self:SetTitleBarHeight(20)
	self:SetDraggable(true)

	self:SetDockPadding(4, 4, self:GetTitleBarHeight() + 4, 4)

	-- Close Button
	local ButtonBase = FindMetaTable("portui_Button")

	local CloseButton = portui.Elements.Create("Button")
	CloseButton:SetParent(self)
	CloseButton:SetText("X")
	CloseButton:SetSize(self:GetTitleBarHeight() * 0.8, self:GetTitleBarHeight() * 0.8)

	function CloseButton:PaintBackground(RenderWidth, RenderHeight)
		surface.SetDrawColor(255, 0, 0, 255)
		surface.DrawRect(0, 0, RenderWidth, RenderHeight)

		ButtonBase.PaintBackground(self, RenderWidth, RenderHeight, self:GetSize())
	end

	function CloseButton:OnLeftClick()
		if IsValid(self:GetParent()) then
			self:GetParent():Remove()
		end
	end

	self.m_CloseButton = CloseButton
end

function ELEMENT:Think()
	if portui.Elements.Input.GetInputElement() ~= self then
		return
	end

	if not input.IsMouseDown(MOUSE_LEFT) then
		portui.Elements.Input.StopGrabbingInput()
		return
	end

	local NewX = gui.MouseX() - self.m_DragData.MouseX
	local NewY = gui.MouseY() - self.m_DragData.MouseY

	NewX = math.Clamp(NewX, 0, Renderer.ScreenWidth)
	NewY = math.Clamp(NewY, 0, Renderer.ScreenHeight)

	self:SetX(NewX)
	self:SetY(NewY)
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

	-- Title
	Renderer.SwapPortRect() -- Absolutely rapes text rendering, can't fix that
	do
		local X, Y = self:GetRelativePos()

		surface.SetFont(self:GetFontName())
		surface.SetTextColor(255, 255, 255, 255)

		local Title = self:GetTitle()

		local _, TextHeight = surface.GetTextSize(Title)
		local TextOffset = (TitleBarHeight * 0.5) - (TextHeight * 0.5)

		surface.SetTextPos(X + TextOffset + 3, Y + TextOffset)
		surface.DrawText(Title)
	end
	Renderer.UnSwapPortRect()
end

function ELEMENT:OnLeftClick(MouseX, MouseY)
	if not self:GetDraggable() then return end
	if MouseY > self:GetTitleBarHeight() then return end

	self.m_DragData.MouseX = MouseX
	self.m_DragData.MouseY = MouseY

	portui.Elements.Input.StartGrabbingInput(self)
end

function ELEMENT:PerformLayout(Width, Height)
	if IsValid(self.m_CloseButton) then
		local TitleBarHeight = self:GetTitleBarHeight()
		local CloseButtonWidth, CloseButtonHeight = self.m_CloseButton:GetSize()

		self.m_CloseButton:SetY((TitleBarHeight * 0.5) - (CloseButtonHeight * 0.5))
		self.m_CloseButton:SetX(Width - CloseButtonWidth - self.m_CloseButton:GetY())
	end
end

portui.Elements.Register("Window", ELEMENT, "Base")
