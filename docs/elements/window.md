## Window
A Window that can be moved around and resized.

<details>
<summary>Functions</summary>


<details>
<summary>Getters</summary>

`string Element:GetTitle()` \
Returns the current title of the Button.

`bool Element:GetDraggable()` \
Returns whether or not the Window is draggable.

`bool Element:GetResizable()` \
Returns whether or not the Window is resizable.

`number Element:GetResizeTolerance()` \
Returns the tolerance from the edges of the Window that resizing can be triggered.

</details>

<br />

<details>
<summary>Setters</summary>

`void Element:SetTitle(string Text)` \
Sets the text of the Button.

`void Element:SetDraggable(bool Draggable)` \
Sets whether or not the Window is draggable.

`void Element:SetResizable(bool Resizable)` \
Sets whether or not the Window is resizable.

`void Element:SetResizeTolerance(number Tolerance)` \
Sets the tolerance from the edges of the Window that resizing can be triggered.

</details>

</details>

<br />
<hr />
<br />

<details>
<summary>Hooks</summary>

No additional hooks.

</details>

<br />
<hr />
<br />

<details>
<summary>Variables</summary>

*While you can modify these variables to bypass accessors, it may cause undesired behavior.*

`m_iTitleBarHeight`: The height of the Window's title bar. \
`m_bDraggable`: Whether or not the Window is draggable. \
`m_bResizable`: Whether or not the Window is resizable. \
`m_iResizeTolerance`: The tolerance from the edges of the Window that resizing can be triggered. \
`m_Title`: A reference to the Window's title Label. \
`m_CloseButton`: A reference to the Window's close Button.

</details>
