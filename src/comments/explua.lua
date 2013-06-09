local re = require("re")
local common = require("comments.common")

---
-- Parse explua-style comments.
-- @class module
-- @name comments.explua
-- @author Peter Kosa
-- @release 2013/04/04, Peter Kosa
-- @see luacomments/tests

module("comments.explua",package.seeall)



local simplecommenttypes = [[(
  {:type: ((("by"/"b")s+) ) -> "author":}/
  {:type: ("$Id:"s+) -> "release":}/
  {:type: (("TODO"/"T")s+) -> "todo":}/
  {:type: ("%"s+) -> "descr":}/
  {:type: ("|"s+) -> "module":}/
  {:type: ("-"s+) -> "descr":}
  )]]
---
--% Function parse explua comments.
--- Extended version: you must write variable name of the returned thing
--@ text (string) string to parse
--@ extended (bool) true if you want to use extended version
--: (table) returns a table containing the parsed stuff, or nil end error message
function parse(text,extended)
	local x
	if(extended)then
	   x = re.compile( [[
	      start     <- (simple / return / param / table / tablefield)

	      simple    <- ( commentprefix  simplecommenttypes   tex  )          -> {}
	      return    <- ( commentprefix {:type: (":"s+) -> "return":}  '['? vari ']'? s+ {:vartype: types :} s+ tex) -> {}
	      param     <- ( commentprefix {:type: ("@"s+) -> "param":}   '['? vari ']'? s+ {:vartype: types? :} s* tex  )   -> {}
	      table     <- ( commentprefix {:type: ("&"s+) -> "table":}   vari s+ tex  )        -> {}
	      tablefield<- ( commentprefix {:type: ("."s+) -> "tablefield":}   {:table: variable :} s+ vari s+ tex  )        -> {}

	      types     <-  ( "(" s* typelist  s* ")" )     ->{}
	      typelist  <-  basetypes (s*  ("|"/",") s*  basetypes )*
	      simplecommenttypes <- ]].. simplecommenttypes ..[[
	      variable  <-  ]] .. common.variable .. [[
	      basetypes <-  ]] .. common.basetypes .. [[
	      text      <-  !"(" .+   -- !"(" to ensure that the 'types' pattern matches
	      s <- ("]].."\t"..[[" / " ")
	      commentprefix <-'--'
	      vari      <- {:var: variable :}
	      tex      <-{:text: text :}
	    ]]
	  )
	else
	x = re.compile( [[
	      start     <- (simple / return / param / table / tablefield)

	      simple    <- ( commentprefix  simplecommenttypes   tex  )          -> {}
	      return    <- ( commentprefix {:type: (":"s+) -> "return":}   {:vartype: types :} s+ tex  )  -> {}
	      param     <- ( commentprefix {:type: ("@"s+) -> "param":}   '['? vari ']'? s+ {:vartype: types? :} s* tex  )   -> {}
	      table     <- ( commentprefix {:type: ("&"s+) -> "table":}    vari s+ tex  )        -> {}
	      tablefield<- ( commentprefix {:type: ("."s+) -> "tablefield":}   {:table: variable :} s+ vari s+ tex  )        -> {}

	      types     <-  ( "(" s* typelist  s* ")" )     ->{}
	      typelist  <-  basetypes (s*  ("|"/",") s*  basetypes )*
	      simplecommenttypes <- ]].. simplecommenttypes ..[[
	      variable  <-  ]] .. common.variable .. [[
	      basetypes <-  ]] .. common.basetypes .. [[
	      text      <-  !"(" .+   -- !"(" to ensure that the 'types' pattern matches
	        s <- ("]].."\t"..[[" / " ")
	      commentprefix <-'--'
	      vari      <- {:var: variable :}
	      tex      <-{:text: text :}
	    ]]
	  )

	end
	x = x:match(text)
	if (x) then
		x.tag = "comment"
		x.style = "explua"
		return x
	else
		return nil, "Error: nothing parsed!"
	end
end
