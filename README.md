# Port UI
Garry's Mod menu state surface based UI \
Using [render.SetViewPort](https://gmodwiki.com/render.SetViewPort) and [render.SetScissorRect](https://gmodwiki.com/render.SetScissorRect)

## Usage
1. Download the repository [here](https://github.com/github-is-garbage/port-ui/archive/refs/heads/main.zip)
2. Extract the ZIP file into `garrysmod/addons/port-ui`
3. Add the following line to your `garrysmod/lua/menu/menu.lua` file to load the script:

```lua
RunString(file.Read("addons/port-ui/lua/port-ui/init.lua", "GAME"), "addons/port-ui/lua/port-ui/init.lua")
```

4. Now you can access the `portui` global table and create elements like so:

```lua
local ExamplePanel = portui.Elements.Create("Base") -- Creates a basic panel
ExamplePanel:SetPos(10, 10)
ExamplePanel:SetSize(100, 100)
```
