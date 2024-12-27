## Input
Things in the global `portui.Input` table.

`bool Input.IsButtonPressed(number ButtonCode)` \
Returns whether or not the given button is pressed on this frame. \
Uses [BUTTON_CODE](https://gmodwiki.com/Enums/BUTTON_CODE) enumerations.

`bool Input.WasButtonPressed(number ButtonCode)` \
Returns whether or not the given button was pressed on the previous frame. \
Uses [BUTTON_CODE](https://gmodwiki.com/Enums/BUTTON_CODE) enumerations.

`bool Input.WasButtonJustPressed(number ButtonCode)` \
Returns whether or not the given button was just pressed this frame and was not pressed on the previous frame. \
Uses [BUTTON_CODE](https://gmodwiki.com/Enums/BUTTON_CODE) enumerations.

`void Input.CollectButtons()` \
Collects all pressed buttons to be used in `IsButtonPressed`, `WasButtonPressed` and `WasButtonJustPressed`. \
This is automatically called every frame by the Input system.

`void Input.StartGrabbingInput(Element Element)` \
Begins sending inputs to the provided Element.

`void Input.StopGrabbingInput()` \
Stops sending inputs to Elements.

`Element Input.GetInputElement()` \
Returns the Element currently receiving inputs. \
`nil` if no Element is receiving input.

`void Input.ClickElement(Element Element, number MouseX, number MouseY)` \
Runs the `:OnLeftClick`, `:OnRightClick` and `:OnMiddleClick` hooks on Elements.
This is automatically called by the Render system after rendering has finished.
