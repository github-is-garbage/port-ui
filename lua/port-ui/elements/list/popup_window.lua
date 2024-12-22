local WindowMeta = FindMetaTable("portui_Window")

local ELEMENT = {}

function ELEMENT:Init()
	WindowMeta.Init(self)

	self:SetPos(gui.MouseX(), gui.MouseY())

	hook.Add("port-ui:ElementLeftClicked", self, self.OnElementClicked)
	hook.Add("port-ui:ElementRightClicked", self, self.OnElementClicked)
	hook.Add("port-ui:ElementMiddleClicked", self, self.OnElementClicked)
end

function ELEMENT:OnElementClicked(ClickedElement)
	if ClickedElement == self then return end
	if ClickedElement:IsChildOf(self) then return end

	self:Remove()
end

portui.Elements.Register("PopupWindow", ELEMENT, "Window")
