---
-- Module for definition of tag aliases.
-- Current release works with luadoc tags.
--TODO add other styles
-- @class module
-- @name comments.aliases
-- @author Peter Kosa
-- @release 2013/04/04, Peter Kosa

module("comments.aliases",package.seeall)

--list of tags, user defined aliases
-- User defines own tags in user table.
local common=
{
	param 		    ={luadoc="@param"   , user={"@@","@p"}}
,	field 		    ={luadoc ="@field"  ,user={"@f","!@"}}
,	author 		    ={luadoc="@author"  ,user={}}
,	copyright     ={luadoc="@copyright", user={}}
,	release 	    ={luadoc="@release"  , user={}}
,	Return 	    	={luadoc="@return"   , user={"@returns","@ret"}}
,	see 		      ={luadoc="@see"      , user={}}
,	usage 		    ={luadoc="@usage"    , user={}}
,	description   ={luadoc="@description", user={}}
,	class 		    ={luadoc="@class"    , user={}}
,	name 		      ={luadoc="@name"     , user={}}
}

---
--% Function creates re grammar strings from standard tags and from its aliases.
--info if you want to add other style, you can do it similarly (or better :) 
--: aliases (table) table containing pieces of re grammar strings

function getaliases()
  local aliases={}
  local luadoc={}

  local paramalias=""
  local fieldalias=""
  local authoralias=""
  local copyrightalias=""
  local releasealias=""
  local returnalias=""
  local seealias=""
  local usagealias=""
  local descriptionalias=""
  local classalias=""
  local namealias=""

  for k,v in pairs(common.param.user) do
     paramalias = paramalias .. [[/("]] .. v .. [["s+)]]
  end
  paramalias = paramalias .. ')->"param":})'    
   
  for k,v in pairs(common.field.user) do
     fieldalias = fieldalias .. [[/("]] .. v .. [["s+)]]
  end
  fieldalias = fieldalias .. ')->"field":})'

  for k,v in pairs(common.author.user) do
     authoralias = authoralias .. [[/("]] .. v .. [["s+)]]
  end
  authoralias = authoralias .. ')->"author":})'

  for k,v in pairs(common.copyright.user) do
     copyrightalias = copyrightalias .. [[/("]] .. v .. [["s+)]]
  end
  copyrightalias = copyrightalias .. ')->"copyright":})'

  for k,v in pairs(common.release.user) do
     releasealias = releasealias .. [[/("]] .. v .. [["s+)]]
  end
  releasealias = releasealias .. ')->"release":})'

  for k,v in pairs(common.Return.user) do
     returnalias = returnalias .. [[/("]] .. v .. [["s+)]]
  end
  returnalias = returnalias .. ')->"return":})'

  for k,v in pairs(common.see.user) do
     seealias = seealias .. [[/("]] .. v .. [["s+)]]
  end
  seealias = seealias .. ')->"see":})'

  for k,v in pairs(common.usage.user) do
     usagealias = usagealias .. [[/("]] .. v .. [["s+)]]
  end
  usagealias = usagealias .. ')->"usage":})'

  for k,v in pairs(common.description.user) do
     descriptionalias = descriptionalias .. [[/("]] .. v .. [["s+)]]
  end
  descriptionalias = descriptionalias .. ')->"descr":})'

  for k,v in pairs(common.class.user) do
     classalias = classalias .. [[/("]] .. v .. [["s+)]]
  end
  classalias = classalias .. ')->"class":})'

  for k,v in pairs(common.name.user) do
     namealias = namealias .. [[/("]] .. v .. [["s+)]]
  end
  namealias = namealias .. ')->"name":})'

--^ `LUADOC` ********************


  local luadocparamalias=[[({:type:(("]] .. common.param.luadoc .. [["s+)]]   
  local luadocfieldalias=[[({:type:(("]] .. common.field.luadoc .. [["s+)]]
  local luadocauthoralias=[[({:type:(("]] .. common.author.luadoc .. [["s+)]]
  local luadoccopyrightalias=[[({:type:(("]] .. common.copyright.luadoc .. [["s+)]]
  local luadocreleasealias=[[({:type:(("]] .. common.release.luadoc .. [["s+)]]
  local luadocreturnalias=[[({:type:(("]] .. common.Return.luadoc .. [["s+)]]
  local luadocseealias=[[({:type:(("]] .. common.see.luadoc .. [["s+)]]
  local luadocusagealias=[[({:type:(("]] .. common.usage.luadoc .. [["s+)]]
  local luadocdescriptionalias = [[({:type:(("]] .. common.description.luadoc .. [["s+)]]
  local luadocclassalias=[[({:type:(("]] .. common.class.luadoc .. [["s+)]]
  local luadocnamealias=[[({:type:(("]] .. common.name.luadoc .. [["s+)]]
  
  
  luadoc.param=  luadocparamalias .. paramalias
  luadoc.field=  luadocfieldalias .. fieldalias
  luadoc.author=luadocauthoralias .. authoralias

  luadoc.copyright=luadoccopyrightalias .. copyrightalias 
  luadoc.release=luadocreleasealias .. releasealias
  luadoc.Return=luadocreturnalias .. returnalias
  luadoc.see=luadocseealias .. seealias
  luadoc.usage=luadocusagealias .. usagealias
  luadoc.description=luadocdescriptionalias ..descriptionalias
  luadoc.class=luadocclassalias .. classalias
  luadoc.name=luadocnamealias .. namealias



  aliases.luadoc= luadoc

--v LUADOC ***********************************

return aliases

end


