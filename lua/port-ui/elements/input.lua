portui.Input = portui.Input or {}
local Input = portui.Input

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

hook.Add("DrawOverlay", "port-ui:CollectButtons", Input.CollectButtons)
