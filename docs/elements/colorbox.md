## Colorbox
A colored rectangle that opens a Color Picker when clicked.

<details>
<summary>Functions</summary>


<details>
<summary>Getters</summary>

`Color Element:GetColor()` \
Returns a reference to the Color object being used.

</details>

<br />

<details>
<summary>Setters</summary>

`void Element:SetColor(Color Color)` \
Sets the Color to be used. \
The color will be passed by reference and directly modified.

</details>

</details>

<br />
<hr />
<br />

<details>
<summary>Hooks</summary>

`void Element:OnValueChanged(Color OldValue, Color NewValue)` \
Calls when the Color of the Colorbox changes. \
`NewValue` is a reference to `m_Color`.

</details>

<br />
<hr />
<br />

<details>
<summary>Variables</summary>

*While you can modify these variables to bypass accessors, it may cause undesired behavior.*

`m_Color`: A reference to the Color object being used.

</details>
