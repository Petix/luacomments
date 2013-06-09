local re = require('re')
---
-- Parse multi-line comments.
-- @class module
-- @name comments.literate
-- @author Peter Kosa
-- @release 2013/04/04, Peter Kosa
-- @see luacomments/tests

module("comments.literate",package.seeall)

---
--% Literate programming comment parser, with re module grammar.
--- Supported styles are  literate : "--[[....]]" and --_ , markdown: --[[#....]] 
--- If markdown, delete global padding before lines.
--@ text (string) multi or simple line comment
--: (table,nil) Return a table with parsed infos

function parse(text)

  if(string.find(text,"%s--%[=*%[[^#]"))then
    text = re.gsub(text," {[^%nl]} %nl {[^%nl]} ","%1 %2")        -- nahradit jeden znak newline s medzerou
    text = re.gsub(text,"%nl[%nl \t]+","\n")                      -- nahradit za sebou iduce znaky newline  jednym newline-om
                                                                  --? doplnit aj tabulatory???
    text = re.gsub(text,"[ \t]+"," ")                             -- nahradit lubovolny pocet za sebou iducich medzier jednou medzerou
  elseif(string.find(text,"%s--%[=*%[[#]"))then
      text = re.gsub(text,"[%s]+{'--]]'}","%1")
  end

  local x = re.compile( [==[
  start     <- (simpleline/markdown/literate)
  simpleline<-(s'--_'s{:text:.+:}{:tag:""->"comment":}{:type:""->"lp":} ) ->{}
  markdown  <- (s beginmark{:tag:""->"comment":}{:type:""->"markdown":} [^%nl]* [%nl]* {:text:between:}s close s) ->{}
  literate  <-(s begin{:tag:""->"comment":}{:type:""->"lp":} s{:text:between:}s close s) ->{}
  begin     <-('--[' {:trail:'='*:} '[')
  beginmark <-('--[' {:trail:'='*:} '[#')
  between   <- (!'%nl'!close.)+
  close     <- ('--]' =trail ']')
  s         <- (%s)*
  ]==]
  )
  x=x:match(text)
  if(x)then
--^ `delete global padding`
    if(x.type=="markdown")then
      local text=""
      local mini=""
      local first=1
      local act
      for r in string.gmatch(x.text,"[^\n]+")do
        act=r:match("^%s*")
        if(act)then
          if(first==1)then
            mini=act
            first=0
          elseif(string.len(mini) > string.len(act))then
            mini=act
          end
        end
      end
      for r in string.gmatch(x.text,"[^\n]*")do
        local afterdelete =r:gsub("^"..mini,"",1) 
        if(afterdelete:sub(-1) == "")then
          text=text .. "\n"
        else
          text=text .. r:gsub("^"..mini,"",1)
        end
      end
      x.text=text
    end
--v    
    x.trail=nil
    x.style="literate"
    return x
  else
    return nil,"Error: Nothing parsed!"
  end
end




