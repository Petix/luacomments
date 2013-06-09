
local re = require("re")
local common = require("comments.common")
---
-- Parse (standard)ldoc-style comments
-- @class module
-- @name comments.ldoc
-- @author Peter Kosa
-- @release 2013/04/04, Peter Kosa
-- @see luacomments/tests

module("comments.ldoc",package.seeall)


local typedtags = [[({:type:("tparam"):}/
                     {:type:("treturn"):}                     
                  )]]
local tagsWithName=[[ ({:type:("field"):} / 
                       {:type:("param"):}) ]]

local tags=[[ ( {:type:("author"):}/
                {:type:("copyright"):}/
                {:type:("release"):}/
                {:type:("return"):}/
                {:type:("see"):}/
                {:type:("usage"):}/
                {:type:("description")->"descr":}/
                {:type:("todo"):}/
                {:type:("fixme"):}
                )]]
local onewordtags=[[(
  {:type:("class"):}/
  {:type:("name"):}/
  {:type:("alias"):}/
  {:type:("section"):}/
  {:type:("type"):}/
  {:type:("module"):}/
  {:type:("script"):}/
  {:type:("table"):}
  )]]


---
--% LDoc-style comment parser, with re module grammar
--@ text (string) simple line comment
--: (table,nil) Return a table with parsed infos
function parse(text)

local rev = re.compile([[
    start <- ( typedtag/ tagwname/oneword / shortparam  / taged  / description  )             
    typedtag    <- (commentprefix "@"]].. typedtags ..[[ [%s]+ {:vartype:types:} s {:name:variable:} s {:text:.+:} ) ->{}                                      
    tagwname    <- (commentprefix "@"]].. tagsWithName ..[[" "+ {:name:variable:} " "+ {:text:.*:})  ->{}
    taged       <- (commentprefix "@"]].. tags ..[[" "+  {:text:.*:})                     ->{}
    oneword     <- (commentprefix "@"]].. onewordtags .. [[" "+ {:name:[^" "]+:} s!(.))      ->{}    
    description <- (commentprefix s {:text:.+:}{:type:""->"descr":})                         -> {}
   shortparam  <- (commentprefix (("@"{:vartype:shortparams:})/({:vartype:shortparams:}":")){:type:""->"tparam":} s {:name:variable:} s {:text:.+:})         ->{}

    types     <-  (  s typelist  s )     ->{}
    typelist  <-  basetypes (s  "|" s  basetypes )*

    shortparams <- ]].. common.ldoc_short_params ..[[ ->{}
    basetypes <- ]].. common.basetypes ..[[
    s           <- ' '*
    commentprefix           <- ('--'[-]* s)
    variable    <-]].. common.variable.. [[
    ]])

  local x = rev:match(text)
  if(x)then
      x.style="ldoc"
      x.tag="comment"
    return x
  else
    return nil,"Error: nothing parsed!"
  end


end
