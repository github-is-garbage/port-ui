portui.Elements = portui.Elements or {}
local Elements = portui.Elements

Elements.List = Elements.List or {} -- List of existing elements
Elements.KeyedList = Elements.KeyedList or {} -- List of existing elements keyed by type name
Elements.KeyedListSequential = Elements.KeyedListSequential or {} -- List of existing elements keyed by type name, sequential

Elements.Metas = Elements.Metas or {} -- Metatables for each element type

function Elements.Register(Name, Meta, BaseName)
	Name = tostring(Name)

	if not istable(Meta) then
		return error("Tried to register non-table meta ", Name)
	end

	if istable(Elements.Metas[Name]) then
		ErrorNoHaltWithStack("Overriding portui element ", Name)
	end

	if not Meta.__index then
		Meta.__index = Meta
	end

	if isstring(BaseName) then
		local BaseMeta = Elements.Metas[BaseName]

		if istable(BaseMeta) then
			setmetatable(Meta, BaseMeta)
		else
			return error("Tried to register ", Name, " to non-existent base ", BaseName)
		end
	end

	Elements.Metas[Name] = Meta
end

-- TODO: Check if element was already stored
function Elements.Store(Element)
	local TypeName = Element.m_strTypeName

	if not isstring(TypeName) then
		return error("Failed to store element with invalid type name! This should never happen!")
	end

	local ElementIndex = table.insert(Elements.List, Element)

	if not istable(Elements.KeyedList[TypeName]) then
		Elements.KeyedList[TypeName] = {}
	end

	if not istable(Elements.KeyedListSequential[TypeName]) then
		Elements.KeyedListSequential[TypeName] = {}
	end

	Elements.KeyedList[TypeName][ElementIndex] = Element
	table.insert(Elements.KeyedListSequential[TypeName], Element)
end

-- TODO: Error if element not found?
function Elements.UnStore(Element)
	local ElementIndex = 0

	for Index = 1, #Elements.List do
		if Elements.List[Index] == Element then
			ElementIndex = Index
			break
		end
	end

	if ElementIndex <= 0 then
		return error("Failed to UnStore element! This should never happen!")
	end

	local TypeName = Element.m_strTypeName

	assert(isstring(TypeName), "Failed to UnStore element with invalid type name! This should never happen!")
	assert(istable(Elements.KeyedList[TypeName]), "Failed to UnStore element with unkeyed type name! This should never happen!")
	assert(istable(Elements.KeyedListSequential[TypeName]), "Failed to UnStore element with unkeyed type name! This should never happen!")

	Elements.KeyedList[TypeName][ElementIndex] = nil
	local SequentialList = Elements.KeyedListSequential[TypeName]

	for Index = #SequentialList, 1, -1 do
		if SequentialList[Index] == Element then
			SequentialList[Index] = nil
			break
		end
	end
end

function Elements.Create(Name)
	Name = tostring(Name)
	local Meta = Elements.Metas[Name]

	if not istable(Meta) then
		return error("Tried to create non-existent element name ", Name)
	end

	local Element = setmetatable({}, Meta)

	Element.m_strTypeName = Name

	Element:InternalInit()
	Element:Init()

	Elements.Store(Element)

	return Element
end
