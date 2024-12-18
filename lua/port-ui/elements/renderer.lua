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

Renderer.HoveredElement = nil

function Renderer.SwapPortRect() -- Flips the view port and scissor rect for proper clipped text rendering inside child elements
	Renderer.LastViewPortX, Renderer.LastViewPortY, Renderer.LastViewPortWidth, Renderer.LastViewPortHeight = render_GetViewPort()
	render_SetViewPort(0, 0, Renderer.ScreenWidth, Renderer.ScreenHeight)

	Renderer.LastScissorX, Renderer.LastScissorY, Renderer.LastScissorZ, Renderer.LastScissorW, Renderer.LastScissorState = render_GetScissorRect()

	local ScissorZ = Renderer.LastViewPortX + Renderer.LastViewPortWidth
	ScissorZ = math_Clamp(ScissorZ, Renderer.LastViewPortX, Renderer.TopViewPortX + Renderer.TopViewPortWidth)

	local ScissorW = Renderer.LastViewPortY + Renderer.LastViewPortHeight
	ScissorW = math_Clamp(ScissorW, Renderer.LastViewPortY, Renderer.TopViewPortY + Renderer.TopViewPortHeight)

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

	local ScreenWidth, ScreenHeight = Renderer.ScreenWidth, Renderer.ScreenHeight

	local ElementX, ElementY = Element:GetRelativePos()
	local ElementWidth, ElementHeight = Element:GetSize()

	if Renderer.MouseInBounds(ElementX, ElementY, ElementX + ElementWidth, ElementY + ElementWidth) then
		-- This is a bit of a bad way to get the hovered element because it means there can't be an :IsHovered function
		Renderer.HoveredElement = Element
	end

	local ViewPortX, ViewPortY = ElementX, ElementY
	local ViewPortWidth, ViewPortHeight = ElementWidth, ElementHeight

	local ScissorX, ScissorY = ViewPortX, ViewPortY
	local ScissorZ, ScissorW = ViewPortX + ViewPortWidth, ViewPortY + ViewPortHeight

	if IsChild then
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

	Element:PostRenderChildren(ElementX, ElementY, ElementWidth, ElementHeight)
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
	local HoveredElement = Renderer.HoveredElement
	if not IsValid(HoveredElement) then return end

	if Input.GetInputElement() then return end
	if input_IsKeyTrapping() then return end
	if dragndrop_IsDragging() then return end

	local ElementX, ElementY = HoveredElement:GetRelativePos()
	local RelativeMouseX = Renderer.MouseX - ElementX
	local RelativeMouseY = Renderer.MouseY - ElementY

	if Input.WasButtonJustPressed(MOUSE_LEFT) then
		HoveredElement:OnLeftClick(RelativeMouseX, RelativeMouseY)
	end

	if Input.WasButtonJustPressed(MOUSE_RIGHT) then
		HoveredElement:OnRightClick(RelativeMouseX, RelativeMouseY)
	end

	if Input.WasButtonJustPressed(MOUSE_MIDDLE) then
		HoveredElement:OnMiddleClick(RelativeMouseX, RelativeMouseY)
	end
end

function Renderer.RenderElements()
	Renderer.ScreenWidth = ScrW()
	Renderer.ScreenHeight = ScrH()
	Renderer.MouseX = gui_MouseX()
	Renderer.MouseY = gui_MouseY()
	Renderer.HoveredElement = nil

	Renderer.RenderTopElements()
	Renderer.HandleInput()
end

hook.Add("DrawOverlay", "port-ui:RenderElements", Renderer.RenderElements)
