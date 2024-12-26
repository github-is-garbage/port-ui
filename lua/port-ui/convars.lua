portui.ConVars = portui.ConVars or {}
local ConVars = portui.ConVars

ConVars.portui_visualizelayout = CreateClientConVar("portui_visualizelayout", 0, false, false, "Renders red rectangles over Elements laying out", 0, 1)
ConVars.portui_visualizelayout_time = CreateClientConVar("portui_visualizelayout_time", 0.1, false, false, "How long a layout visual will stay on screen (seconds)", 0.1, 5)
