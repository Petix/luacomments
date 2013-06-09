local re = require("re")
local common = require("comments.common")

---
-- Parse comments of function definitions, example of it is in source code of leg.grammar module.
-- @class module
-- @name comments.leg
-- @author Peter Kosa
-- @release 2013/04/04, Peter Kosa
-- @see luacomments/tests

module("comments.leg",package.seeall)

---
--% Leg-like comment parser, with re module grammar
--@ text (string) multi line comment
--: (table,nil) Return a table with parsed infos


function parse(text)
 
  local x = re.compile( [==[
  start     <- (st)                               ->{}
  st        <- (s begin s between s close s) 
  between   <- (!close (short  long? {:params:param?:} {:returns:ret?:} ))  

  short     <- (s {:short:[^%nl]+:} s)                                    --prvy riadok -short description
  long      <- (s {:long:(!(param)!(ret)!(close).)+:} s)                  --ostatne riadky kym sa nenajde param alebo ret - long description

  param     <- (s'**'"Parameters:"   '**' s ((!(%nl%nl)& !ret )parameter )*  s) ->{}
  ret       <- (s'**'"Returns:"      '**' s ((!(%nl%nl) & !close) returns )*  s)   ->{}

  returns   <- (s [^`]* "`" {:var:variable:} "`"  {:text:(!(%nl).)+:} {:type:""->"return" :} )  ->{}
  parameter <- (s [^`]* "`" {:var:variable:} "`"  {:text:(!(%nl).)+:} {:type:""->"param" :} )  ->{}

  variable  <- ]==] .. common.variable .. [==[
  begin     <-('--[' {:trail: '='*:} '[')
  close     <- (s '--]' =trail ']')
  s         <- [%s]*
  ]==]
  )
  x=x:match(text)
  if(x)then
    x.tag="comment"
    x.style="leg"
    x.trail=nil
    return x
  else
  return nil,"Nothing parsed!"
  end
end

