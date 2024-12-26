## LabeledCheckbox
A Checkbox with a Label docked beside it.

<details>
<summary>Functions</summary>


<details>
<summary>Getters</summary>

`string Element:GetText()` \
Returns the current text of the Label.

`bool Element:GetChecked()` \
Returns whether or not the Checkbox is checked.

</details>

<br />

<details>
<summary>Setters</summary>

`void Element:SetText(string Text)` \
Sets the text of the Label.

`void Element:SetChecked(bool Checked)` \
Sets if the Checkbox is checked or not. \
This will call `:OnValueChanged`.

</details>

</details>

<br />
<hr />
<br />

<details>
<summary>Hooks</summary>

`void Element:OnValueChanged(bool OldValue, bool NewValue)` \
Calls when the check state of the Checkbox changes.

</details>

<br />
<hr />
<br />

<details>
<summary>Variables</summary>

*While you can modify these variables to bypass accessors, it may cause undesired behavior.*

`m_strText`: The text that will be displayed in the Label. \
`m_bChecked`: Whether or not the Checkbox is checked. \
`m_Checkbox`: A reference to the Checkbox Element.
`m_Label`: A reference to the Label Element.

</details>
