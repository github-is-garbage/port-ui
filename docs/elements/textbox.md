## Textbox
A textbox that can be typed in. \
Currently only supports lowercase letters and no special characters due to how key trapping works.

<details>
<summary>Functions</summary>


<details>
<summary>Getters</summary>

`string Element:GetText()` \
Returns the current text of the Textbox.

</details>

<br />

<details>
<summary>Setters</summary>

`void Element:SetText(string Text)` \
Sets the text of the Textbox.

</details>

</details>

<br />
<hr />
<br />

<details>
<summary>Hooks</summary>

`void Element:OnValueChanged(string OldValue, string NewValue)` \
Called when the text of the Textbox changes.

</details>

<br />
<hr />
<br />

<details>
<summary>Variables</summary>

*While you can modify these variables to bypass accessors, it may cause undesired behavior.*

`m_strText`: The text that will be displayed in the Textbox.

</details>
