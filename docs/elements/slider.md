## Slider
A slider Element with a knob.

<details>
<summary>Functions</summary>


<details>
<summary>Getters</summary>

`number Element:GetValue()` \
Returns the current value of the Slider.

`number Element:GetMinimumValue()` \
Returns the minimum value of the Slider.

`number Element:GetMaximumValue()` \
Returns the maximum value of the Slider.

`number Element:GetDecimalPoints()` \
Returns the amount of allowed decimal points on the Slider's value.

`bool Element:GetVertical()` \
Returns whether or not the Slider is vertical. \
Up = lower value, Down = higher value.

</details>

<br />

<details>
<summary>Setters</summary>

`void Element:SetValue(number Value)` \
Sets the value of the Slider. \
This will call `:OnValueChanged`.

`void Element:SetMinimumValue(number Value)` \
Sets the minimum value of the Slider. \
This will call `:SetValue` with the Sliders's current value to ensure it's clamped. \
This will call `:OnValueChanged`.

`void Element:SetMaximumValue(number Value)` \
Sets the maximum value of the Slider. \
This will call `:SetValue` with the Sliders's current value to ensure it's clamped. \
This will call `:OnValueChanged`.

`void Element:SetDecimalPoints(number Value)` \
Sets the value of the Slider. \
This will call `:SetValue` with the Sliders's current value to ensure it's updated. \
This will call `:OnValueChanged`.

`void Element:SetVertical(bool Vertical)` \
Sets whether or not the Slider is vertical. \
Up = lower value, Down = higher value.

</details>

</details>

<br />
<hr />
<br />

<details>
<summary>Hooks</summary>

`void Element:OnValueChanged(number OldValue, number NewValue)` \
Calls when the value of the Slider changes.

</details>

<br />
<hr />
<br />

<details>
<summary>Variables</summary>

*While you can modify these variables to bypass accessors, it may cause undesired behavior.*

`m_DragData`: A table containing current dragging information when the Slider is being moved around.
`m_flValue`: The current value of the Slider. \
`m_flMinimumValue`: The minimum value of the Slider. \
`m_flMaximumValue`: The maximum value of the Slider. \
`m_iDecimalPoints`: The number of decimal points on the Slider's value. \
`m_bVertical`: Whether or not the Slider is vertical. \
`m_Knob`: A reference to the knob Button Element.

</details>
