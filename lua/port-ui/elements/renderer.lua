portui.Elements.Renderer = portui.Elements.Renderer or {}
local Renderer = portui.Elements.Renderer
local Input = portui.Elements.Input

local ScrW = ScrW
local ScrH = ScrH
local gui_MouseX = gui.MouseX
local gui_MouseY = gui.MouseY
local IsValid = IsValid
local xpcall = xpcall
local render_SetViewPort = render.SetViewPort
local render_GetViewPort = render.GetViewPort
local render_SetScissorRect = render.SetScissorRect
local render_GetScissorRect = render.GetScissorRect
local math_Clamp = math.Clamp
local math_min = math.min
local input_IsKeyTrapping = input.IsKeyTrapping
local dragndrop_IsDragging = dragndrop.IsDragging
local draw_NoTexture = draw.NoTexture

local portui_visualizelayout = portui.ConVars.portui_visualizelayout
local portui_visualizelayout_time = portui.ConVars.portui_visualizelayout_time

Renderer.Layouts = Renderer.Layouts or {}
Renderer.RegisteredLayouts = Renderer.RegisteredLayouts or {}

Renderer.ScreenWidth = ScrW()
Renderer.ScreenHeight = ScrH()

Renderer.TopViewPortX = 0
Renderer.TopViewPortY = 0
Renderer.TopViewPortWidth = ScrW()
Renderer.TopViewPortHeight = ScrH()

Renderer.LastViewPortX = 0
Renderer.LastViewPortY = 0
Renderer.LastViewPortWidth = ScrW()
Renderer.LastViewPortHeight = ScrH()

Renderer.LastScissorX = 0
Renderer.LastScissorY = 0
Renderer.LastScissorZ = ScrW()
Renderer.LastScissorW = ScrH()
Renderer.LastScissorState = false

Renderer.MouseX = 0
Renderer.MouseY = 0

Renderer.CurrentlyRenderingElement = nil
Renderer.HoveredElement = nil

function Renderer.SwapPortRect() -- Flips the view port and scissor rect for proper clipped text rendering inside child elements
	Renderer.LastViewPortX, Renderer.LastViewPortY, Renderer.LastViewPortWidth, Renderer.LastViewPortHeight = render_GetViewPort()
	render_SetViewPort(0, 0, Renderer.ScreenWidth, Renderer.ScreenHeight)

	Renderer.LastScissorX, Renderer.LastScissorY, Renderer.LastScissorZ, Renderer.LastScissorW, Renderer.LastScissorState = render_GetScissorRect()

	local ScissorZ = Renderer.LastViewPortX + Renderer.LastViewPortWidth
	ScissorZ = math_Clamp(ScissorZ, Renderer.LastViewPortX, Renderer.TopViewPortX + Renderer.TopViewPortWidth)

	local ScissorW = Renderer.LastViewPortY + Renderer.LastViewPortHeight
	ScissorW = math_Clamp(ScissorW, Renderer.LastViewPortY, Renderer.TopViewPortY + Renderer.TopViewPortHeight)

	if IsValid(Renderer.CurrentlyRenderingElement) then
		local Parent = Renderer.CurrentlyRenderingElement:GetParent()

		if IsValid(Parent) then
			-- Prevent escaping parent
			local ParentX, ParentY = Parent:GetRelativePos()
			local ParentWidth, ParentHeight = Parent:GetSize()

			ScissorZ = math_Clamp(ScissorZ, ParentX, ParentX + ParentWidth)
			ScissorW = math_Clamp(ScissorW, ParentY, ParentY + ParentHeight)
		end
	end

	render_SetScissorRect(Renderer.LastViewPortX, Renderer.LastViewPortY, ScissorZ, ScissorW, true)
end

function Renderer.UnSwapPortRect()
	render_SetViewPort(Renderer.LastViewPortX, Renderer.LastViewPortY, Renderer.LastViewPortWidth, Renderer.LastViewPortHeight)
	render_SetScissorRect(Renderer.LastScissorX, Renderer.LastScissorY, Renderer.LastScissorZ, Renderer.LastScissorW, Renderer.LastScissorState)
end

function Renderer.MouseInBounds(X1, Y1, X2, Y2)
	return Renderer.MouseX >= X1 and Renderer.MouseY >= Y1 and Renderer.MouseX <= X2 and Renderer.MouseY <= Y2
end

function Renderer.RenderElement(Element, IsChild)
	if not Element:GetVisible() then
		return
	end

	Renderer.CurrentlyRenderingElement = Element

	if Element:GetHasDirtyLayout() then
		if portui_visualizelayout:GetBool() then
			Renderer.VisualizeLayout(Element)
		end

		Element:DoInternalLayout()
	end

	local ScreenWidth, ScreenHeight = Renderer.ScreenWidth, Renderer.ScreenHeight

	local ElementX, ElementY = Element:GetRelativePos()
	local ElementWidth, ElementHeight = Element:GetSize()

	if ElementWidth < 1 or ElementHeight < 1 then
		-- Can't see any of it
		return
	end

	local ViewPortX, ViewPortY = ElementX, ElementY
	local ViewPortWidth, ViewPortHeight = ElementWidth, ElementHeight

	local ScissorX, ScissorY = ViewPortX, ViewPortY
	local ScissorZ, ScissorW = ViewPortX + ViewPortWidth, ViewPortY + ViewPortHeight

	if IsChild then
		local Parent = Element:GetParent()

		local ParentX, ParentY = Parent:GetRelativePos()
		local ParentWidth, ParentHeight = Parent:GetSize()

		-- Make sure it's visible within the parent
		if ElementX + ElementWidth < 0 or ElementY + ElementHeight < 0 then return end
		if ElementX > ParentX + ParentWidth or ElementY > ParentY + ParentHeight then return end

		-- Clip everything to the topmost element's bounds
		local LastViewPortX, LastViewPortY, LastViewPortWidth, LastViewPortHeight = render_GetViewPort()

		ScissorX = math_Clamp(ScissorX, Renderer.TopViewPortX, Renderer.TopViewPortWidth)
		ScissorY = math_Clamp(ScissorY, Renderer.TopViewPortY, Renderer.TopViewPortHeight)

		ScissorZ = math_min(Renderer.TopViewPortX + Renderer.TopViewPortWidth, LastViewPortX + LastViewPortWidth)
		ScissorW = math_min(Renderer.TopViewPortY + Renderer.TopViewPortHeight, LastViewPortY + LastViewPortHeight)
	else
		Renderer.TopViewPortX = ViewPortX
		Renderer.TopViewPortY = ViewPortY
		Renderer.TopViewPortWidth = ViewPortWidth
		Renderer.TopViewPortHeight = ViewPortHeight
	end

	if Element:GetHasInputEnabled() and Renderer.MouseInBounds(ElementX, ElementY, ElementX + ElementWidth, ElementY + ElementHeight) then
		-- This is a bit of a bad way to get the hovered element because it means there can't be an :IsHovered function
		Renderer.HoveredElement = Element
	end

	draw_NoTexture()

	render_SetViewPort(ViewPortX, ViewPortY, ViewPortWidth, ViewPortHeight)
	do
		xpcall(Element.Think, ErrorNoHaltWithStack, Element)

		xpcall(Element.PaintBackground, ErrorNoHaltWithStack, Element, ScreenWidth, ScreenHeight, ElementWidth, ElementHeight)
		xpcall(Element.PaintForeground, ErrorNoHaltWithStack, Element, ScreenWidth, ScreenHeight, ElementWidth, ElementHeight)

		render_SetScissorRect(ScissorX, ScissorY, ScissorZ, ScissorW, true)
		do
			local Children = Element:GetChildren()

			for ChildIndex = 1, #Children do
				Renderer.RenderElement(Children[ChildIndex], true)

				-- Restore after rendering a child
				render_SetScissorRect(ScissorX, ScissorY, ScissorZ, ScissorW, true)
				render_SetViewPort(ViewPortX, ViewPortY, ViewPortWidth, ViewPortHeight)
			end
		end
		render_SetScissorRect(0, 0, 0, 0, false)
	end
	render_SetViewPort(0, 0, ScreenWidth, ScreenHeight)

	xpcall(Element.PostRenderChildren, ErrorNoHaltWithStack, Element, ElementX, ElementY, ElementWidth, ElementHeight)
end

function Renderer.RenderTopElements()
	local Elements = portui.Elements.List

	for Index = 1, #Elements do
		local Element = Elements[Index]

		if IsValid(Element:GetParent()) then
			continue
		end

		Renderer.RenderElement(Element)
	end
end

function Renderer.HandleInput()
	if not IsValid(Renderer.HoveredElement) then return end

	if Input.GetInputElement() then return end
	if input_IsKeyTrapping() then return end
	if dragndrop_IsDragging() then return end

	Input.ClickElement(Renderer.HoveredElement, Renderer.MouseX, Renderer.MouseY)
end

function Renderer.RenderElements()
	hook.Run("port-ui:PreRenderElements")

	Renderer.ScreenWidth = ScrW()
	Renderer.ScreenHeight = ScrH()
	Renderer.MouseX = gui_MouseX()
	Renderer.MouseY = gui_MouseY()
	Renderer.CurrentlyRenderingElement = nil
	Renderer.HoveredElement = nil

	Renderer.RenderTopElements()
	Renderer.HandleInput()

	hook.Run("port-ui:PostRenderElements")
end

function Renderer.VisualizeLayout(Element)
	if not Renderer.RegisteredLayouts[Element] then
		table.insert(Renderer.Layouts, {
			X = Element:GetRelativeX(),
			Y = Element:GetRelativeY(),
			Width = Element:GetWidth(),
			Height = Element:GetHeight(),

			Timestamp = SysTime(),
			Element = Element
		})

		Renderer.RegisteredLayouts[Element] = true -- Don't spam red squares
	end
end

function Renderer.RenderLayouts()
	local CurrentTime = SysTime()
	local Lifetime = portui_visualizelayout_time:GetFloat()

	local Removals = {} -- Since we don't loop backwards removals will be stored here

	for LayoutIndex = 1, #Renderer.Layouts do
		local Layout = Renderer.Layouts[LayoutIndex]

		surface.SetDrawColor(255, 0, 0, 50)
		surface.DrawRect(Layout.X, Layout.Y, Layout.Width, Layout.Height)

		surface.SetDrawColor(255, 0, 0, 255)
		surface.DrawOutlinedRect(Layout.X, Layout.Y, Layout.Width, Layout.Height)

		if CurrentTime - Layout.Timestamp >= Lifetime then
			Removals[#Removals + 1] = LayoutIndex
		end
	end

	for RemovalIndex = 1, #Removals do
		local LayoutIndex = Removals[RemovalIndex]
		local LayoutData = Renderer.Layouts[LayoutIndex]

		if LayoutData then
			Renderer.RegisteredLayouts[LayoutData.Element] = nil
		end

		table.remove(Renderer.Layouts, Removals[RemovalIndex])
	end
end

hook.Add("DrawOverlay", "port-ui:RenderElements", Renderer.RenderElements)
hook.Add("port-ui:PostRenderElements", "port-ui:RenderLayouts", Renderer.RenderLayouts)
