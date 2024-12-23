local ExamplePanel = portui.Elements.Create("Window")
ExamplePanel:SetPos(10, 10)
ExamplePanel:SetSize(720, 480)

-- ExamplePanel:AddChild("Button", TOP):SetText("1!")
-- ExamplePanel:AddChild("Button", BOTTOM):SetText("2@")
-- ExamplePanel:AddChild("Button", LEFT):SetText("3#")
-- ExamplePanel:AddChild("Button", RIGHT):SetText("4$")
-- ExamplePanel:AddChild("Button", FILL):SetText("5%")

local Slider = portui.Elements.Create("Slider")
Slider:SetParent(ExamplePanel)
Slider:SetPos(4, 24)
Slider:SetDock(TOP)
Slider:SetSize(100, 20)
Slider:SetMinimumValue(-1)

function Slider:OnValueChanged(...)
	print(...)
end

local Checker = portui.Elements.Create("Checkbox")
Checker:SetParent(ExamplePanel)
Checker:SetSize(20, 20)
Checker:SetPos(4, 50)

function Checker:OnValueChanged(...)
	print(...)
end

local Checker2 = portui.Elements.Create("LabeledCheckbox")
Checker2:SetParent(ExamplePanel)
Checker2:SetSize(100, 20)
Checker2:SetPos(4, 80)

function Checker2:OnValueChanged(...)
	print(...)
end

local Spinner = portui.Elements.Create("NumberSpinner")
Spinner:SetParent(ExamplePanel)
Spinner:SetSize(100, 20)
Spinner:SetPos(4, 110)

function Spinner:OnValueChanged(...)
	print(...)
end

local TestColor = Color(255, 0, 0, 255)

local Colorbox = portui.Elements.Create("Colorbox")
Colorbox:SetParent(ExamplePanel)
Colorbox:SetSize(20, 20)
Colorbox:SetPos(4, 140)
Colorbox:SetColor(TestColor)

function Colorbox:OnValueChanged(...)
	print(...)
end

-- local ColorPicker = portui.Elements.Create("ColorPicker")
-- ColorPicker:SetParent(ExamplePanel)
-- ColorPicker:SetSize(150, 100)
-- ColorPicker:SetPos(4, 170)
-- ColorPicker:SetColor(TestColor)

local VSlider = portui.Elements.Create("Slider")
VSlider:SetVertical(true)
VSlider:SetParent(ExamplePanel)
VSlider:SetSize(20, 100)
VSlider:SetPos(4, 280)
VSlider:SetMinimumValue(-1)

function VSlider:OnValueChanged(...)
	print(...)
end

-- local Label = portui.Elements.Create("Label")
-- Label:SetPos(10, 20)
-- Label:SetText("Hello There")
-- Label:SetParent(ExamplePanel)
-- Label:SetDock(FILL)

-- local Button1 = portui.Elements.Create("Button")
-- Button1:SetPos(10, 50)
-- Button1:SetSize(100, 20)
-- Button1:SetText("1!")
-- Button1:SetParent(ExamplePanel)
-- --Button1:SetDock(TOP)

-- function Button1:OnLeftClick()
-- 	ExamplePanel:Remove()
-- end

-- --function Button1:PaintBackground() end

-- local Button2 = portui.Elements.Create("Button")
-- Button2:SetText("2@")
-- Button2:SetParent(ExamplePanel)
-- Button2:SetDock(BOTTOM)

-- --function Button2:PaintBackground() end

-- local Button3 = portui.Elements.Create("Button")
-- Button3:SetText("3#")
-- Button3:SetParent(ExamplePanel)
-- Button3:SetDock(LEFT)

-- --function Button3:PaintBackground() end

-- local Button4 = portui.Elements.Create("Button")
-- Button4:SetText("4$")
-- Button4:SetParent(ExamplePanel)
-- Button4:SetDock(RIGHT)

-- local Button5 = portui.Elements.Create("Button")
-- Button5:SetText("5%")
-- Button5:SetParent(ExamplePanel)
-- Button5:SetDock(FILL)

-- local RadioButtonA = portui.Elements.Create("RadioButton")
-- RadioButtonA:SetPos(10, 40)
-- RadioButtonA:SetSize(80, 20)
-- RadioButtonA:SetText("Radio A")
-- RadioButtonA:SetGroupName("Tester")
-- RadioButtonA:SetSelected(true)
-- RadioButtonA:SetParent(ExamplePanel)

-- function RadioButtonA:OnSelected()
-- 	print("A SELECTED")
-- end

-- function RadioButtonA:OnUnSelected()
-- 	print("A UNSELECTED")
-- end

-- local RadioButtonB = portui.Elements.Create("RadioButton")
-- RadioButtonB:SetPos(10, 60)
-- RadioButtonB:SetSize(80, 20)
-- RadioButtonB:SetText("Radio B")
-- RadioButtonB:SetGroupName("Tester")
-- RadioButtonB:SetParent(ExamplePanel)

-- function RadioButtonB:OnSelected()
-- 	print("B SELECTED")
-- end

-- function RadioButtonB:OnUnSelected()
-- 	print("B UNSELECTED")
-- end
