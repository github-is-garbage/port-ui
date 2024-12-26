## RadioButton
A radio button that can be grouped with other radio buttons.

<details>
<summary>Functions</summary>


<details>
<summary>Getters</summary>

`string Element:GetText()` \
Returns the current text of the Radio Button.

`bool Element:GetSelected()` \
Returns whether or not this Radio Button is selected.

`string Element:GetGroupName()` \
Returns the current group name of the Radio Button. \
This is used to connect the Radio Button with other Radio Buttons.

</details>

<br />

<details>
<summary>Setters</summary>

`void Element:SetText(string Text)` \
Sets the text of the Radio Button.

`void Element:SetSelected(bool Selected)` \
Sets whether or not this Radio Button is selected. \
This will call `:OnSelected` or `:OnUnSelected` depending on the new state.

`void Element:SetGroupName(string GroupName)` \
Sets the group name of the Radio Button. \
This is used to connect the Radio Button with other Radio Buttons.

This will call the global hook `port-ui:RadioButtonGroupMemberChanged`.

</details>

</details>

<br />
<hr />
<br />

<details>
<summary>Hooks</summary>

`void Element:OnSelected()` \
Called when the Radio Button gets selected.

`void Element:OnUnSelected()` \
Called when the Radio Button gets unselected.

</details>

<br />
<hr />
<br />

<details>
<summary>Variables</summary>

*While you can modify these variables to bypass accessors, it may cause undesired behavior.*

`m_strText`: The text that will be displayed in the Radio Button. \
`m_bSelected`: Whether or not this Radio Button is selected. \
`m_strGroupName`: The group name of this Radio Button.

</details>
