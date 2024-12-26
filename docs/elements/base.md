## Base Element
This Element contains all basic functionality.
All functions, hooks and variables present in this Element are present in all other Elements.

<details>
<summary>Functions</summary>

`bool Element:IsValid()` \
Returns the value of `m_bValid`.

`void Element:Remove()` \
Invalidates the Element and destroys all children.

`number Element:CalculatePixelsWidth(number Pixels)` \
Converts Element pixels into screen pixels based off the width of the Element. \
Used during rendering to ensure proper sizes.

`number Element:CalculatePixelsHeight(number Pixels)` \
Converts Element pixels into screen pixels based off the height of the Element. \
Used during rendering to ensure proper sizes.

`Element Element:AddChild(string/Element Child, Dock = NODOCK)` \
Adds a child Element with the provided dock. \
If `Child` is a `string`, an Element with that type name will be created.

Returns the child created/passed in.

`bool Element:IsChildOf(Element Element)`\
Returns `true` if the Element is a child of the provided Element.

`void Element:InvalidateLayout()` \
Sets `m_bHasDirtyLayout` to `true` signaling for the Element to be layed out on the next frame.

`void Element:InvalidateChildren(bool Recursive)` \
Calls `:InvalidateLayout` on all child Elements.

If `Recursive` is `true`, it will call `:InvalidateLayout` on all children of children and so on.

`void Element:InvalidateParent(bool UpdateChildren)` \
Calls `:InvalidateLayout` on the parent Element.

If `UpdateChildren` is `true`, `:InvalidateChildren(true)` will be called on the parent as well.

`void Element:RegisterChild(Element Child)` \
Called when a child Element is added to place it into the `m_Children` table.

`void Element:UnRegisterChild(Element Child)` \
Called when a child Element is removed to take it out of the `m_Children` table.

<details>
<summary>Getters</summary>

`number Element:GetX()` \
Returns the current X position of the Element.

`number Element:GetY()` \
Returns the current Y position of the Element.

`number, number Element:GetPos()` \
Returns the current X and Y positions of the Element.

`number Element:GetRelativeX()` \
Returns the current X position of the Element relative to the parent. \
Represents where the Element is actually displayed on screen.

`number Element:GetRelativeY()` \
Returns the current Y position of the Element. \
Represents where the Element is actually displayed on screen.

`number, number Element:GetRelativePos()` \
Returns the current X and Y positions of the Element. \
Represents where the Element is actually displayed on screen.

`number Element:GetMinimumWidth()` \
Returns the minimum width of the Element.

`number Element:GetMinimumHeight()` \
Returns the minimum height of the Element.

`number Element:GetMinimumSize()` \
Returns the minimum width and height of the Element.

`number Element:GetWidth()` \
Returns the current width of the Element.

`number Element:GetHeight()` \
Returns the current height of the Element.

`number Element:GetSize()` \
Returns the current width and height of the Element.

`bool Element:GetVisible()` \
Returns if the Element is visible or not.

`bool Element:GetHasInputEnabled()` \
Returns if the Element has input enabled or not. \
If this returns `false`, the Element is unable to be clicked.

`Element Element:GetParent()` \
Returns a reference to the Element's parent Element. \
Returns `nil` if there is no parent.

`table Element:GetChildren() `\
Returns a table containing references to all the Element's children.

`number, number Element:CalculateChildrenSize()` \
Returns the width and height of the size taken up by the Element's children.

`bool Element:GetHasDirtyLayout()` \
Returns whether or not the Element has a dirty layout. \
If this is `true`, the Element will have `:DoInternalLayout` called on the next frame.

`number Element:GetDock()` \
Returns the current docking state of the Element. \
Uses [DOCK](https://gmodwiki.com/Enums/DOCK) enumerations.

`number, number, number, number Element:GetDockingOffset()` \
Returns the left, right, top and bottom offsets of the Element's docking. \
Used during layout to position docked children.

`number, number, number, number Element:GetDockPadding()` \
Returns the left, right, top and bottom padding of the Element's dock. \
Used to offset Elements docked inside.

`number, number, number, number Element:GetDockMargin()` \
Returns the left, right, top and bottom margin of the Element's dock. \
Used to offset Elements docked beside it.

</details>

<br />

<details>
<summary>Setters</summary>

`void Element:SetX(number X)` \
Sets the X position of the Element. \
This will call `:OnPositionChanged`

`void Element:SetY(number Y)` \
Sets the Y position of the Element.\
This will call `:OnPositionChanged`

`void Element:SetPos(number X, number Y)` \
Sets the X and Y positions of the Element.\
This will call `:OnPositionChanged`

`void Element:SetMinimumWidth(number Width)` \
Sets the minimum width of the Element.
This will call `:SetWidth` with the Element's current width to ensure it's clamped. \
This will call `:OnSizeChanged`

`void Element:SetMinimumHeight(number Height)` \
Sets the minimum height of the Element.
This will call `:SetHeight` with the Element's current height to ensure it's clamped. \
This will call `:OnSizeChanged`

`void Element:SetMinimumSize(number Width, number Height)` \
Sets the minimum width and height of the Element.
This will call `:SetSize` with the Element's current size to ensure it's clamped. \
This will call `:OnSizeChanged`

`void Element:SetWidth(number Width)` \
Sets the width of the Element. \
This will call `:OnSizeChanged`

`void Element:SetHeight(number Height)` \
Sets the height of the Element. \
This will call `:OnSizeChanged`

`void Element:SetSize(number Width, number Height)` \
Sets the width and height of the Element. \
This will call `:OnSizeChanged`

`void Element:SizeToChildren(number Width, number Height)` \
Sizes the Element to the size of its children as calculated by `:CalculateChildrenSize`.

`void Element:SetVisible(bool Visible)` \
Sets if the Element is visible or not.

`void Element:SetHasInputEnabled(bool Enabled)` \
Sets if the Element has input enabled or not. \
If this is `false`, the Element is unable to be clicked.

`void Element:SetParent(Element Parent)` \
Sets the Element's parent. \
Set to `nil` to remove the parent.

`void Element:SetDock(number Dock)` \
Sets the docking state of the Element. \
Uses [DOCK](https://gmodwiki.com/Enums/DOCK) enumerations.

`void Element:UpdateDockingOffset(number Left, number Right, number Top, number Bottom)` \
Sets the left, right, top and bottom offsets of the Element's docking. \
Used during layout to position docked children.

`void Element:GetDockPadding(number Left, number Right, number Top, number Bottom)` \
Sets the left, right, top and bottom padding of the Element's dock. \
Used to offset Elements docked inside.

`void Element:GetDockMargin(number Left, number Right, number Top, number Bottom)` \
Sets the left, right, top and bottom margin of the Element's dock. \
Used to offset Elements docked beside it.

</details>

</details>

<br />
<hr />
<br />

<details>
<summary>Hooks</summary>

`void Element:InternalInit()` \
Used to setup all the necessary internal variables of the Element. \

**Do NOT override this function!!**

`void Element:Init()` \
Used to setup the Element with whatever variables you please.

`void Element:Think()` \
Called every frame the Element is visible just before rendering.

`void Element:PaintBackground(number RenderWidth, number RenderHeight, number Width, number Height)` \
Called every frame the Element is visible to draw the background, clipped to the Element's bounds. \
Drawing is relative to the Element's position, so X and Y at 0 is the top left corner of the Element.

When drawing, you'll want to use `RenderWidth` and `RenderHeight` to ensure what you're drawing is what you want.

`void Element:PaintForeground(number RenderWidth, number RenderHeight, number Width, number Height)` \
Called every frame the Element is visible to draw the foreground, clipped to the Element's bounds. \
Drawing is relative to the Element's position, so X and Y at 0 is the top left corner of the Element.

When drawing, you'll want to use `RenderWidth` and `RenderHeight` to ensure what you're drawing is what you want.

`void Element:PostRenderChildren(number X, number Y, number Width, number Height)` \
Called every frame the Element is visible after all children is visible, not clipped.

Draw calls will work normally here.

`void Element:OnLeftClick(number MouseX, number MouseY)` \
Called when the Element is left clicked. \
`MouseX` and `MouseY` are relative to the Element, not the screen.

`void Element:OnRightClick(number MouseX, number MouseY)` \
Called when the Element is right clicked. \
`MouseX` and `MouseY` are relative to the Element, not the screen.

`void Element:OnMiddleClick(number MouseX, number MouseY)` \
Called when the Element is middle clicked. \
`MouseX` and `MouseY` are relative to the Element, not the screen.

`void Element:OnPositionChanged(number OldX, number OldY, number NewX, number NewY)` \
Called when `:SetX`, `:SetY` or `:SetPos` is called.

`void Element:OnSizeChanged(number OldWidth, number OldHeight, number NewWidth, number NewHeight)` \
Called when `:SetMinimumWidth`, `:SetMinimumHeight`, `:SetMinimumSize`, `:SetWidth`, `:SetHeight` or `:SetSize` is called.

`void Element:LayoutChild(Element Child)` \
Called during layout to determine a docked child's position.

**Do NOT override this function!!**

`void Element:LayoutChildren()` \
Called during layout to layout all docked children.

**Do NOT override this function!!**

`void Element:DoInternalLayout()` \
Called when `:GetHasDirtyLayout` is `false` to layout the Element's children. \
Calls `:PerformLayout`.

**Do NOT override this function!!**

`void Element:PerformLayout(number Width, number Height)` \
Called after the Element has been layed out, allows modifying of layout.

</details>

<br />
<hr />
<br />

<details>
<summary>Variables</summary>

*While you can modify these variables to bypass accessors, it may cause undesired behavior.*

`m_iX`: The current X position of the Element. \
`m_iY`: The current Y postiion of the Element. \
`m_iMinimumWidth`: The minimum Width of the Element. \
`m_iMinimumHeight`: The minimum Height of the Element. \
`m_iWidth`: The current Width of the Element. \
`m_iHeight`: The current Height of the Element.

`m_bVisible`: The current visibility state of the Element. \
`m_bValid`: The current validity state of the Element. Set to `false` when `:Remove` is called. \
`m_bInputEnabled`: Whether or not the Element has input enabled. \
`m_strFontName`: The name of the font that will be used for text rendering.

`m_Parent`: A reference to the parent Element. `nil` if there is no parent. \
`m_Children`: A table containing references to all child Elements.

`m_bHasDirtyLayout`: Represents if the Element's layout is dirty.
If this is `true`, `:DoInternalLayout` will be called on the next frame. \
`m_iDock`: Represents the current docking the Element is using.
Uses [DOCK](https://gmodwiki.com/Enums/DOCK) enumerations. \

`m_iDockLeftOffset`: The offset from the left of the Element.
Used during layout to determine child positions. \
`m_iDockRightOffset`: The offset from the right of the Element.
Used during layout to determine child positions. \
`m_iDockTopOffset`: The offset from the top of the Element.
Used during layout to determine child positions. \
`m_iDockBottomOffset`: The offset from the bottom of the Element.
Used during layout to determine child positions.

`m_iDockPaddingLeft`: The inside left padding of the Element.
Used to offset Elements docked inside. \
`m_iDockPaddingRight`: The inside right padding of the Element.
Used to offset Elements docked inside. \
`m_iDockPaddingTop`: The inside top padding of the Element.
Used to offset Elements docked inside. \
`m_iDockPaddingBottom`: The inside bottom padding of the Element.
Used to offset Elements docked inside.

`m_iDockMarginLeft`: The inside left margin of the Element.
Used to offset Elements docked beside it. \
`m_iDockMarginRight`: The inside right margin of the Element.
Used to offset Elements docked beside it. \
`m_iDockMarginTop`: The inside top margin of the Element.
Used to offset Elements docked beside it. \
`m_iDockMarginBottom`: The inside bottom margin of the Element.
Used to offset Elements docked beside it.

</details>
