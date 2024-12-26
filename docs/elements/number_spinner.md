## NumberSpinner
An Element with a centered Label showing its value and Buttons on both ends to increase or decrease the value.

<details>
<summary>Functions</summary>


<details>
<summary>Getters</summary>

`number Element:GetValue()` \
Returns the current value of the Number Spinner.

`number Element:GetMinimumValue()` \
Returns the minimum value of the Number Spinner.

`number Element:GetMaximumValue()` \
Returns the maximum value of the Number Spinner.

`number Element:GetDecimalPoints()` \
Returns the amount of allowed decimal points on the Number Spinner's value.

`number Element:GetStep()` \
Returns the amount of change that will be applied for each increase/decrease.

</details>

<br />

<details>
<summary>Setters</summary>

`void Element:SetValue(number Value)` \
Sets the value of the Number Spinner. \
This will call `:OnValueChanged`.

`void Element:SetMinimumValue(number Value)` \
Sets the minimum value of the Number Spinner. \
This will call `:SetValue` with the Number Spinners's current value to ensure it's clamped. \
This will call `:OnValueChanged`.

`void Element:SetMaximumValue(number Value)` \
Sets the maximum value of the Number Spinner. \
This will call `:SetValue` with the Number Spinners's current value to ensure it's clamped. \
This will call `:OnValueChanged`.

`void Element:SetDecimalPoints(number Value)` \
Sets the value of the Number Spinner. \
This will call `:SetValue` with the Number Spinners's current value to ensure it's updated. \
This will call `:OnValueChanged`.

`void Element:SetStep(number Value)` \
Sets the amount of change that will be applied for each increase/decrease.

</details>

</details>

<br />
<hr />
<br />

<details>
<summary>Hooks</summary>

`void Element:OnValueChanged(number OldValue, number NewValue)` \
Calls when the check state of the Number Spinner changes.

</details>

<br />
<hr />
<br />

<details>
<summary>Variables</summary>

*While you can modify these variables to bypass accessors, it may cause undesired behavior.*

`m_flValue`: The current value of the Number Spinner. Will be displayed in the Label. \
`m_flMinimumValue`: The minimum value of the Number Spinner. \
`m_flMaximumValue`: The maximum value of the Number Spinner. \
`m_iDecimalPoints`: The number of decimal points on the Number Spinner's value. \
`m_flSteps`: The amount of change that will be applied for each increase/decrease.
`m_Decrease`: A reference to the increase Button's Element.
`m_Increase`: A reference to the decrease Button's Element.
`m_Label`: A reference to the Label Element.

</details>
