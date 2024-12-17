# Port UI
Garry's Mod menu state surface based UI \
Using [render.SetViewPort](https://gmodwiki.com/render.SetViewPort) and [render.SetScissorRect](https://gmodwiki.com/render.SetScissorRect)

## Usage
Add the following line to your `garrysmod/lua/menu/menu.lua` file to load the script:

```lua
RunString(file.Read("addons/port-ui/lua/port-ui/init.lua", "GAME"), "addons/port-ui/lua/port-ui/init.lua")
```

Now you can access the `portui` global table
