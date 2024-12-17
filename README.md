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
local ExamplePanel = portui.Elements.Create("Window")
ExamplePanel:SetPos(10, 10)
ExamplePanel:SetSize(100, 100)
```

Result:

![port-ui Window](./gitimg/window.png)

## Known Issues / Jank
- Due to this being made with View Ports, Elements rendered with a screen X or Y position off the screen bounds
will be clipped due to DirectX clipping, I'm unable to remedy this with DisableClipping so it'll just have to do for now

- Text rendering is weird inside Elements because of the View Ports due to how the View Ports mess with aspect ratio.
This has been remedied by the implementation of the `portui.Elements.Renderer.SwapPortRect()` and `portui.Elements.Renderer.UnSwapPortRect()` functions
