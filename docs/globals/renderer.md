## Render
Things in the global `portui.Renderer` table.

`table Render.Layouts` \
A table containing layouts to be visualized. \
This is used when `portui_visualizelayout` is set to `true`.

`table Render.Layouts` \
A table containing layouts keyed by Element. \
This is used when `portui_visualizelayout` is set to `true`.

`number Renderer.ScreenWidth` \
Used to store the screen size to restore original screen state after rendering.

`number Renderer.ScreenHeight` \
Used to store the screen size to restore original screen state after rendering.

`number Renderer.ScreenHeight` \
Used to store the screen size to restore original screen state after rendering.

`number Renderer.TopViewPortX` \
Used to store the top most view port for clamping during child rendering.

`number Renderer.TopViewPortY` \
Used to store the top most view port for clamping during child rendering.

`number Renderer.TopViewPortWidth` \
Used to store the top most view port for clamping during child rendering.

`number Renderer.TopViewPortHeight` \
Used to store the top most view port for clamping during child rendering.

`number Renderer.LastViewPortX` \
Used to store the previous view port for clamping during child rendering.

`number Renderer.LastViewPortY` \
Used to store the previous view port for clamping during child rendering.

`number Renderer.LastViewPortWidth` \
Used to store the previous view port for clamping during child rendering.

`number Renderer.LastViewPortHeight` \
Used to store the previous view port for clamping during child rendering.

`number Renderer.LastScissorX` \
Used to store the previous scissor rect for clamping during child rendering.

`number Renderer.LastScissorY` \
Used to store the previous scissor rect for clamping during child rendering.

`number Renderer.LastScissorZ` \
Used to store the previous scissor rect for clamping during child rendering.

`number Renderer.LastScissorW` \
Used to store the previous scissor rect for clamping during child rendering.

`bool Renderer.LastScissorState` \
Used to store the previous scissor rect for clamping during child rendering.

`number Renderer.MouseX` \
Used to store the mouse position for clicking after rendering.

`number Renderer.MouseY` \
Used to store the mouse position for clicking after rendering.

`Element Renderer.CurrentlyRenderingElement` \
Used to store the Element that is currently being rendered. \
`nil` if there is no Element being rendered.

`Element Renderer.HoveredElement` \
Used to store the Element that is currently being hovered for clicking. \
`nil` if there is no Element being hovered.

`void Renderer.SwapPortRect()` \
Swaps the view port and scissor rect values to enable proper clipped text rendering inside Elements.

`void Renderer.UnSwapPortRect()` \
Reverts the view port and scissor rect swap made by `SwapPortRect`.

`bool Renderer.MouseInBounds(number X1, number Y1, number X2, number Y2)` \
Returns `true` if the cursor is within the given bounds.

`void Renderer.RenderElement(Element Element, bool IsChild)` \
Used to render an Element and all its children. \
This will call all respective render hooks on the Element.

`void Renderer.RenderTopElements()` \
Renders Elements with no parents. \
Their children and recursively rendered in `RenderElement`.

`void Renderer.HandleInput()` \
Calls `Input.ClickElement` on the current `HoveredElement`.

`void Renderer.RenderElements()` \
Sets up values and calls `port-ui:PreRenderElements` and `port-ui:PostRenderElements` global hooks and renders top elements.

`void Renderer.VisualizeLayout(Element Element)` \
Adds an Element to the `Renderer.Layouts` and `Renderer.RegisteredLayouts` tables to have its layout visualized. \
This is automatically called when `portui_visualizelayout` is true.

`void Renderer.RenderLayouts()` \
Renders all layouts in the `Renderer.Layouts` and `Renderer.RegisteredLayouts` tables. \
This is automatically called every frame.
