portui.Elements.Input = portui.Elements.Input or {}
local Input = portui.Elements.Input

local BUTTON_CODE_NONE = BUTTON_CODE_NONE
local BUTTON_CODE_COUNT = BUTTON_CODE_COUNT
local input_IsButtonDown = input.IsButtonDown

Input.LastPressedButtons = Input.LastPressedButtons or {}
Input.CurrentlyPressedButtons = Input.CurrentlyPressedButtons or {}

function Input.IsButtonPressed(ButtonCode)
	return Input.CurrentlyPressedButtons[ButtonCode]
end

function Input.WasButtonPressed(ButtonCode)
	return Input.LastPressedButtons[ButtonCode]
end

function Input.WasButtonJustPressed(ButtonCode)
	return Input.IsButtonPressed(ButtonCode) and not Input.WasButtonPressed(ButtonCode)
end

function Input.CollectButtons()
	for ButtonCode = BUTTON_CODE_NONE, BUTTON_CODE_COUNT do
		Input.LastPressedButtons[ButtonCode] = Input.CurrentlyPressedButtons[ButtonCode]
		Input.CurrentlyPressedButtons[ButtonCode] = input_IsButtonDown(ButtonCode)
	end
end

function Input.StartGrabbingInput(Element)
	Input.m_InputFocus = Element
end

function Input.StopGrabbingInput()
	Input.m_InputFocus = nil
end

function Input.GetInputElement()
	return Input.m_InputFocus
end

function Input.ClickElement(Element, MouseX, MouseY)
	local ElementX, ElementY = Element:GetRelativePos()
	local RelativeMouseX = MouseX - ElementX
	local RelativeMouseY = MouseY - ElementY

	if Input.WasButtonJustPressed(MOUSE_LEFT) then
		Element:OnLeftClick(RelativeMouseX, RelativeMouseY)

		hook.Run("port-ui:ElementLeftClicked", Element, RelativeMouseX, RelativeMouseY)
	end

	if Input.WasButtonJustPressed(MOUSE_RIGHT) then
		Element:OnRightClick(RelativeMouseX, RelativeMouseY)

		hook.Run("port-ui:ElementRightClicked", Element, RelativeMouseX, RelativeMouseY)
	end

	if Input.WasButtonJustPressed(MOUSE_MIDDLE) then
		Element:OnMiddleClick(RelativeMouseX, RelativeMouseY)

		hook.Run("port-ui:ElementMiddleClicked", Element, RelativeMouseX, RelativeMouseY)
	end
end

hook.Add("DrawOverlay", "port-ui:CollectButtons", Input.CollectButtons)
