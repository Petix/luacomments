local comments = require("comments")

local str = [=[
--[[
[#section_Completing Completes] `rules` with `grammar` and then [#Applying applies] `captures`.     


`rules` can either be:
* a single pattern, which is taken to be the new initial rule, 
* a possibly incomplete LPeg grammar, as per [#function_complete complete], or 
* `nil`, which means no new rules are added.

`captures` can either be:
* a capture table, as per [#function_pipe pipe], or
* `nil`, which means no captures are applied.

**Parameters:**
* `grammar`: the old grammar. It stays unmodified.
* `rules`: optional, the new rules. 
* `captures`: optional, the final capture table.

**Returns:**
* `rules`, suitably augmented by `grammar` and `captures`.
--]]
]=]



local expectedT=
{
  
    short = "[#section_Completing Completes] `rules` with `grammar` and then [#Applying applies] `captures`.     ",
  
  
    long = [[`rules` can either be:
* a single pattern, which is taken to be the new initial rule, 
* a possibly incomplete LPeg grammar, as per [#function_complete complete], or 
* `nil`, which means no new rules are added.

`captures` can either be:
* a capture table, as per [#function_pipe pipe], or
* `nil`, which means no captures are applied.]]
  ,
  params={
    {
      text = ": the old grammar. It stays unmodified.",
      type = "param",
      var = "grammar"
    },
    {
      text = ": optional, the new rules. ",
      type = "param",
      var = "rules"
    },
    {
      text = ": optional, the final capture table.",
      type = "param",
      var = "captures"
    }
  },
 returns= {
    {
      text = ", suitably augmented by `grammar` and `captures`.",
      type = "return",
      var = "rules"
    }
  },
  style="leg",
  tag="comment"
}


function testparseLEG(comment,tab)
  local t,errno = comments.Parse(comment,"leg")
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

function unittest1()
  testparseLEG(str,expectedT)
end

unittest1()