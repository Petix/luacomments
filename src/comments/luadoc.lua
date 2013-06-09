
local re = require("re")
local common = require("comments.common")
---
-- Parse luadoc comments.
-- Work with aliases.
-- @class module
-- @name comments.luadoc
-- @author Peter Kosa
-- @release 2013/04/04, Peter Kosa



module("comments.luadoc",package.seeall)

--^ `get tags and aliases from aliases.lua via common.lua`
local tagsWithName="(" .. common.aliases.luadoc.param .. "/" .. common.aliases.luadoc.field .. ")"

local tags="(" .. common.aliases.luadoc.author .. "/" 
  .. common.aliases.luadoc.copyright .. "/" .. common.aliases.luadoc.release .. "/" .. common.aliases.luadoc.Return .. "/"
  .. common.aliases.luadoc.see .. "/" .. common.aliases.luadoc.usage .. "/" .. common.aliases.luadoc.description .. ")"

local onewordtags="("..common.aliases.luadoc.name .. "/".. common.aliases.luadoc.class ..")"
--v  end of alias block


---
--% Luadoc comment parser, with re module grammar.
--@ text (string) simple line comment
--: (table) Return a table with parsed infos

function parse(text)
local rev = re.compile([[
    start <- ( tagwname  / taged /oneword/   description )         
    tagwname    <- (commentprefix s* ]].. tagsWithName ..[[  {:name:variable:} s+ {:text:.*:})  ->{}
    taged       <- (commentprefix s* ]].. tags ..        [[  {:text:.*:})           ->{}
    oneword     <- (commentprefix s* ]].. onewordtags .. [[  {:name:[^" "]+:} s*!(.))      ->{}
    description <- (commentprefix [%-]* s* {:type:""->"descr":} {:text:.*:}) ->{}
    s           <- ("\t"/" ")
    commentprefix <- "--" !"["
    variable    <-]].. common.variable.. [[
    ]],{
    })
  local x = rev:match(text)

  if(x)then
    x.style="luadoc"
    x.tag="comment"
    return x
  else
    return nil,"Error: Nothing parsed!"
  end
end

