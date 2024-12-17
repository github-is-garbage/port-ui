portui.Elements.Renderer = portui.Elements.Renderer or {}
local Renderer = portui.Elements.Renderer

Renderer.ScreenWidth = ScrW()
Renderer.ScreenHeight = ScrH()

Renderer.TopViewPortX = 0
Renderer.TopViewPortY = 0
Renderer.TopViewPortWidth = ScrW()
Renderer.TopViewPortHeight = ScrH()

function Renderer.RenderElement(Element, IsChild)
	if not Element:GetVisible() then
		return
	end

	local ScreenWidth, ScreenHeight = Renderer.ScreenWidth, Renderer.ScreenHeight

	local ElementX, ElementY = Element:GetRelativePos()
	local ElementWidth, ElementHeight = Element:GetSize()

	local ViewPortX, ViewPortY = ElementX, ElementY
	local ViewPortWidth, ViewPortHeight = ElementWidth, ElementHeight

	local ScissorX, ScissorY = ViewPortX, ViewPortY
	local ScissorZ, ScissorW = ViewPortX + ViewPortWidth, ViewPortY + ViewPortHeight

	if IsChild then
		local LastViewPortX, LastViewPortY, LastViewPortWidth, LastViewPortHeight = render.GetViewPort()

		ScissorX = math.Clamp(ScissorX, Renderer.TopViewPortX, Renderer.TopViewPortWidth)
		ScissorY = math.Clamp(ScissorY, Renderer.TopViewPortY, Renderer.TopViewPortHeight)

		ScissorZ = math.min(Renderer.TopViewPortX + Renderer.TopViewPortWidth, LastViewPortX + LastViewPortWidth)
		ScissorW = math.min(Renderer.TopViewPortY + Renderer.TopViewPortHeight, LastViewPortY + LastViewPortHeight)
	else
		Renderer.TopViewPortX = ViewPortX
		Renderer.TopViewPortY = ViewPortY
		Renderer.TopViewPortWidth = ViewPortWidth
		Renderer.TopViewPortHeight = ViewPortHeight
	end

	render.SetViewPort(ViewPortX, ViewPortY, ViewPortWidth, ViewPortHeight)
	do
		Element:PaintBackground(ScreenWidth, ScreenHeight)
		Element:PaintForeground(ScreenWidth, ScreenHeight)

		render.SetScissorRect(ScissorX, ScissorY, ScissorZ, ScissorW, true)
		do
			local Children = Element:GetChildren()

			for ChildIndex = 1, #Children do
				Renderer.RenderElement(Children[ChildIndex], true)
			end
		end
		render.SetScissorRect(0, 0, 0, 0, false)
	end
	render.SetViewPort(0, 0, ScreenWidth, ScreenHeight)

	Element:PostRenderChildren(ElementX, ElementY, ElementWidth, ElementHeight)
end

function Renderer.RenderElements()
	Renderer.ScreenWidth = ScrW()
	Renderer.ScreenHeight = ScrH()

	local Elements = portui.Elements.List

	for Index = 1, #Elements do
		local Element = Elements[Index]

		if IsValid(Element:GetParent()) then
			continue
		end

		Renderer.RenderElement(Element)
	end
end

hook.Add("DrawOverlay", "port-ui:RenderElements", Renderer.RenderElements)
