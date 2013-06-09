
local aliases = require("comments.aliases")

---
-- Commonly used pieces of re grammars.
-- @class module
-- @name comments.common
-- @author Peter Kosa
-- @release 2013/04/04, Peter Kosa

module("comments.common")


return
{
	variable = [[ [_a-zA-Z][a-zA-Z0-9_]* / "..." ]]		-- added possible variable name  "..."
,	basetypes = [[ ({"number"} / {"string"} / {"bool"} / {"function"} / {"table"} / {"nil"} / {"thread"} / {"any"})]]
,ldoc_short_params = [[ ({"number"} / {"string"} / {"bool"} / {"func"} / {"tab"} / {"int"} / {"thread"} )]]

--info ALIASY TAGOV :
,aliases=aliases.getaliases()
}
