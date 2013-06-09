

local re = require("re")

---
-- Module for lua comment parsing. 
--@class module
--@name comments
--@author Peter Kosa
-- @release 2013/04/04, Peter Kosa

module("comments",package.seeall)
local print  = print

local explua = require"comments.explua"		-- parser = "explua"
local luadoc = require"comments.luadoc"		-- parser = "luadoc"
local literate = require"comments.literate"	-- parser = "literate"
local custom = require"comments.custom"		-- parser = "custom"
local ldoc = require"comments.ldoc"			-- parser = "ldoc"
local leg = require"comments.leg"			-- parser = "leg"

local parsers={
	[1]=literate,
	[2]=leg,
	[3]=custom,
	[4]=explua,
	[5]=luadoc,
	[6]=ldoc,

}

---
--% The main parse funcion. Invokes the given parser, or tries all parsers until one succeed.
--@ text (string) multi or simple line comment
--@ parser (string,any) parser type or anything else
--@ extended (any) nil if don't want to use extended explua grammar
--: (table,nil) Return a table with parsed infos


function Parse(text,parser,extended)
	local result,errno

	if(parser=="explua")then
		return explua.parse(text,extended)
	elseif(parser=="luadoc")then
		return	luadoc.parse(text)
	elseif(parser=="literate")then
		return literate.parse(text)
	elseif(parser=="custom")then
		return custom.parse(text)
	elseif(parser=="ldoc")then
		return	ldoc.parse(text)
	elseif(parser=="leg")then
		return leg.parse(text)
	else
	
		for k,v in ipairs(parsers) do
			result,errno = v.parse(text,extended)
			if(result)then
				return result
			end
		end
	end
	return result,errno
end



