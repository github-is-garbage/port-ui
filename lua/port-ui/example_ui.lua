local Window = portui.Elements.Create("Window")
Window:SetPos(10, 10)
Window:SetSize(720, 480)

-- Buttons
local ButtonA = Window:AddChild("Button")
ButtonA:SetPos(4, 24)
ButtonA:SetSize(100, 24)

function ButtonA:OnLeftClick()
	print("Hello Hello")
end

-- Radio Buttons
local RadioButtonA = Window:AddChild("RadioButton")
RadioButtonA:SetPos(4, 50)
RadioButtonA:SetSize(100, 20)
RadioButtonA:SetSelected(true)
RadioButtonA:SetText("Radio A")
RadioButtonA:SetGroupName("Example Radio Buttons")

function RadioButtonA:OnSelected()
	print("A Selected")
end

function RadioButtonA:OnUnSelected()
	print("A unselected")
end

local RadioButtonB = Window:AddChild("RadioButton")
RadioButtonB:SetPos(4, 70)
RadioButtonB:SetSize(100, 20)
RadioButtonB:SetText("Radio B")
RadioButtonB:SetGroupName("Example Radio Buttons")

-- Checkbox
local Checkbox = Window:AddChild("Checkbox")
Checkbox:SetPos(4, 90)
Checkbox:SetSize(20, 20)

function Checkbox:OnValueChanged(Old, New)
	print(Old, New)
end

-- Checkbox with a clickable label
local LabeledCheckbox = Window:AddChild("LabeledCheckbox")
LabeledCheckbox:SetPos(4, 120)
LabeledCheckbox:SetSize(120, 20)
LabeledCheckbox:SetText("Labeled Fella")

function LabeledCheckbox:OnValueChanged(Old, New)
	print(Old, New)
end

-- Sliders
local HSlider = Window:AddChild("Slider")
HSlider:SetPos(4, 150)
HSlider:SetSize(100, 20)
HSlider:SetMinimumValue(-1)
HSlider:SetDecimalPoints(2)

function HSlider:OnValueChanged(Old, New)
	print(Old, New)
end

local VSlider = Window:AddChild("Slider")
VSlider:SetVertical(true) -- Up = lower, Down = higher
VSlider:SetPos(4, 180)
VSlider:SetSize(20, 100)

function VSlider:OnValueChanged(Old, New)
	print(Old, New)
end

-- Spinner
local Spinner = Window:AddChild("NumberSpinner")
Spinner:SetPos(4, 290)
Spinner:SetSize(100, 20)
Spinner:SetMinimumValue(-1)
Spinner:SetDecimalPoints(2)
Spinner:SetStep(0.5)

function Spinner:OnValueChanged(Old, New)
	print(Old, New)
end

-- Colors
local ColorRef = Color(255, 0, 0, 255)

local Colorbox = Window:AddChild("Colorbox")
Colorbox:SetPos(4, 330)
Colorbox:SetSize(20, 20)
Colorbox:SetColor(ColorRef) -- Passed by reference, will modify the variable passed in
