## Checkbox
A checkbox that displays the "✓" character when checked.

<details>
<summary>Functions</summary>


<details>
<summary>Getters</summary>

`bool Element:GetChecked()` \
Returns whether or not the Checkbox is checked.

</details>

<br />

<details>
<summary>Setters</summary>

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

`m_bChecked`: Whether or not the Checkbox is checked.

</details>
