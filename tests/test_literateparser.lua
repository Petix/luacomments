local comments = require("comments")

function testparselp(comment,tab)
  local t,errno = comments.Parse(comment,"literate")
    assert(t,errno)
    goDeep(t,tab,comment)
    print("Test  was successful!")
end

--recursive
function goDeep(parsed,expected,comment)
  for k,v in pairs(expected) do
    if(type(v)~="table")then
    assert(parsed[k],"Key <".. k .. "> does not exist in parsed table. Text was : "..comment )
    assert(expected[k],"Key <".. k .. "> does not exist in expected table. Text was : "..comment)
    assert(parsed[k]==expected[k],"\nNot expected output at key <".. k .."> ! Parsed : '" .. parsed[k] .."' , expected: '" .. expected[k] .."' ! Text was : "..comment )
    --  print(k,expected[k],"********" ,parsed[k],i)
     -- print()
    else
      assert(parsed[k],"No entrie in parsed table with key <".. k ..">! Text was : "..comment)
      assert(expected[k],"No entrie in expected table with key <".. k ..">! Text was : "..comment)
       goDeep(parsed[k],expected[k],comment)
    end
 
  end

  for k,v in pairs(parsed) do
    if(type(v)~="table")then
    assert(parsed[k],"Key <".. k .. "> does not exist in parsed table. Text was : "..comment)
    assert(expected[k],"Key <".. k .. "> does not exist in expected table. Text was : "..comment)
    assert(parsed[k]==expected[k],"\nNot expected output at key <".. k .."> ! Parsed : '" .. parsed[k] .."' , expected: '" .. expected[k] .."' ! Text was : "..comment )
    --  print(k,expected[k],"********" ,parsed[k],i)
     -- print()
    else
      assert(parsed[k],"No entrie in parsed table with key <".. k ..">! Text was : "..comment)
      assert(expected[k],"No entrie in expected table with key <".. k ..">! Text was : "..comment)
       goDeep(parsed[k],expected[k],comment)
    end
   
  end
end
--*********************************TESTS***********************
--  *****test1*************markdown******************
local markdowntab = {
    type = "markdown",
    style="literate",
    text = [==[*italic*   **bold**
_italic_   __bold__
# Header 1 #

## Header 2 ##

###### Header 6

sdfa ![alt text](/path/img.jpg "Title"as fas sdf 


    An [example][id]. Then, anywhere
    else in the doc, define the link:

[id]: http://example.com/  "Title"

![alt text][id]

[id]: /url/to/img.jpg "Title"

Header 1
========

Header 2
]==],
    tag = "comment"
  }

local strmarkdown = [==[
--[[#
    *italic*   **bold**
    _italic_   __bold__
    # Header 1 #

    ## Header 2 ##

    ###### Header 6

    sdfa ![alt text](/path/img.jpg "Title"as fas sdf 


        An [example][id]. Then, anywhere
        else in the doc, define the link:

    [id]: http://example.com/  "Title"

    ![alt text][id]

    [id]: /url/to/img.jpg "Title"

    Header 1
    ========

    Header 2
--]]
]==]



--#########################################

-- ***************test2********literate******
local literatetab={
  tag="comment",
  style="literate",
  type="lp",
  text=[==[*italic* **bold** _italic_ __bold__ # Header 1 #
## Header 2 ##
###### Header 6
sdfa ![alt text](/path/img.jpg "Title"as fas sdf 
An [example][id]. Then, anywhere else in the doc, define the link:
[id]: http://example.com/ "Title"
![alt text][id]
[id]: /url/to/img.jpg "Title"
Header 1 ========
Header 2
]==]

}
local strliterate=[[
--[==[
*italic*   **bold**
_italic_   __bold__
# Header 1 #

## Header 2 ##

###### Header 6

sdfa ![alt text](/path/img.jpg "Title"as fas sdf 


An [example][id]. Then, anywhere
else in the doc, define the link:

  [id]: http://example.com/  "Title"

![alt text][id]

[id]: /url/to/img.jpg "Title"

Header 1
========

Header 2

--]==]
]]


-- ********************************* test3 simple line
local sim="--_ simple text"
local t ={tag="comment",style="literate",type="lp",text="simple text"}



function unittest1( )
  testparselp(strmarkdown,markdowntab)
end
function unittest2( )
  testparselp(strliterate,literatetab)
end
function unittest3( )
  testparselp(sim,t)
end

unittest1()
unittest2()
unittest3()