local re = require("re")

---
-- Parse some types of custom comments.
-- @class module
-- @name comments.custom
-- @author Peter Kosa
-- @release 2013/04/04, Peter Kosa
-- @see luacomments/tests

module("comments.custom",package.seeall)


local simplecommenttypes = [[( 
  {:type: "?"s+ -> "question":}/ 
  {:type: "TODO"[:]?s+ -> "todo":}/ 
  {:type: "bug"s+ -> "bug":} /
  {:type: "how"s+ -> "how":}/ 
  {:type: "info"s+ -> "info":}/ 
  {:type: ">"s+ -> "other":}/
  {:type: "fixme"s+ -> "fixme":}
   
  )]]

local blockseps = [[
({:type:"--v"->"endblock":})/
({:type:"--^"->"startblock":})
]]       -- add new block separators

local separators  = [[ (
  ({:tag: "" -> "comment":}{:type:("--+"s*  )-> "sep1":} s* {:text:(.!"+--")+:} s* "+--")  /
  ({:tag: "" -> "comment":}{:type:("--=="s*  )-> "sep2":} s* {:text:(.!"==--")+:} s* "==--")  /
  ({:tag: "" -> "comment":}{:type:("--<<"s* )-> "sep3":} s* {:text:(.!">>--")+:} s* ">>--")  
    )
 ]]
 local endofwhat =[[ ("while")/("for")/("block")]]      -- add new things

---
--% Custom comment parser, with re module grammar
--@ text (string) simple line comment
--: (table,nil) Return a table with parsed infos
function parse(text)
  local x = re.compile( [[
    start     <- (simple / separator / endof / blocksep) 
    blocksep <- (blockseparators s* ("`"{:block:(!"`".)+:}"`")? s* {:text:.*:} )->{}
    endof     <- ("--"s* {:type:"end of"->"endof":} s* "`"{:name:endofwhat:}"`") ->{}
    separator <- ]] .. separators ..[[ ->{}
    simple    <- ( "--" s* simplecommenttypes  s* {:text: text :}  ) -> {}
    simplecommenttypes <- ]].. simplecommenttypes ..[[
    text      <-  .*   
    s <- ("]].."\t"..[[" / " ")
    endofwhat <- ]] .. endofwhat .. [[
    blockseparators <- ]].. blockseps ..[[
  ]]
  )
  x=x:match(text)
  if(x)then
    x.tag="comment"
    x.style="custom"
    return x
  else
    return nil,"Error: Nothing parsed!"
  end
end

