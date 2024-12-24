local Window = portui.Elements.Create("Window")
Window:SetPos(10, 10)
Window:SetSize(720, 480)

-- Buttons
local ButtonA = Window:AddChild("Button", TOP)
ButtonA:SetHeight(24)

function ButtonA:OnLeftClick()
	print("Hello Hello")
end

-- Radio Buttons
local RadioButtonA = Window:AddChild("RadioButton", TOP)
RadioButtonA:SetHeight(20)
RadioButtonA:SetSelected(true)
RadioButtonA:SetText("Radio A")
RadioButtonA:SetGroupName("Example Radio Buttons")

function RadioButtonA:OnSelected()
	print("A Selected")
end

function RadioButtonA:OnUnSelected()
	print("A unselected")
end

local RadioButtonB = Window:AddChild("RadioButton", TOP)
RadioButtonB:SetHeight(20)
RadioButtonB:SetText("Radio B")
RadioButtonB:SetGroupName("Example Radio Buttons")

-- Checkbox
local Checkbox = Window:AddChild("Checkbox", TOP)
Checkbox:SetHeight(20)

function Checkbox:OnValueChanged(Old, New)
	print(Old, New)
end

-- Checkbox with a clickable label
local LabeledCheckbox = Window:AddChild("LabeledCheckbox", TOP)
LabeledCheckbox:SetHeight(20)
LabeledCheckbox:SetText("Labeled Fella")

function LabeledCheckbox:OnValueChanged(Old, New)
	print(Old, New)
end

-- Sliders
local HSlider = Window:AddChild("Slider", TOP)
HSlider:SetHeight(20)
HSlider:SetMinimumValue(-1)
HSlider:SetDecimalPoints(2)

function HSlider:OnValueChanged(Old, New)
	print(Old, New)
end

local VHolder = Window:AddChild("Base", TOP) -- VSliders don't dock to the top very nicely
VHolder:SetHeight(108)

local VSlider = VHolder:AddChild("Slider")
VSlider:SetVertical(true) -- Up = lower, Down = higher
VSlider:SetSize(20, 100)
VSlider:SetPos(4, 4)

function VSlider:OnValueChanged(Old, New)
	print(Old, New)
end

-- Spinner
local Spinner = Window:AddChild("NumberSpinner", TOP)
Spinner:SetHeight(20)
Spinner:SetMinimumValue(-1)
Spinner:SetDecimalPoints(2)
Spinner:SetStep(0.5)

function Spinner:OnValueChanged(Old, New)
	print(Old, New)
end

-- Colors
local ColorRef = Color(255, 0, 0, 255)

local Colorbox = Window:AddChild("Colorbox", TOP)
Colorbox:SetSize(20, 20)
Colorbox:SetColor(ColorRef) -- Passed by reference, will modify the variable passed in
