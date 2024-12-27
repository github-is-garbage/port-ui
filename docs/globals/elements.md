## Elements
Things in the global `portui.Elements` table.

`table Elements.List` \
A sequential table containing all Elements. \
This is what is returned by `Elements.GetAll`.

`table Elements.KeyedList` \
A table of Elements keyed by type name and index in the `List`. \
This is used in `Elements.GetByTypeName`.

`table Elements.KeyedListSequential` \
A table of Elements keyed by type name sequentially.

`table Elements.GetAll()` \
Returns `Elements.List`.

`table Elements.GetByTypeName(string Name)` \
Returns `Elements.KeyedList[Name]`.

`void Elements.Register(string Name, table Metatable, string BaseName = "")` \
Registers a new Element metatable to be used in `Elements.Create`.

`void Elements.Store(Element Element)` \
Stores an Element into the `List`, `KeyedList` and `KeyedListSequential` tables.

`void Elements.UnStore(Element Element)` \
Removes an Element from the `List`, `KeyedList` and `KeyedListSequential` tables.

`Element Elements.Create(string Name)` \
Creates a new Element with the given type name.
