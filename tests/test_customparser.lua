local comments = require("comments")

local expectedTable={
	["--? Can someone explain this?"]={tag="comment",style="custom",type="question",text="Can someone explain this?"},
	["--TODO Fix this!"]={tag="comment",style="custom",type="todo",text="Fix this!"},
	["--bug Crash...."]={tag="comment",style="custom",type="bug",text="Crash...."},
	["--how How does this work?"]={tag="comment",style="custom",type="how",text="How does this work?"},
	["--info Some information..."]={tag="comment",style="custom",type="info",text="Some information..."},
	["--end of `while`"]={tag="comment",style="custom",type="endof",name="while"},
	["--+ Text +--"]={tag="comment",style="custom",type="sep1",text="Text"},
	["--== Text ==--"]={tag="comment",style="custom",type="sep2",text="Text"},
	["--<< Text >>--"]={tag="comment",style="custom",type="sep3",text="Text"},
	["--^ `block name` This sequence does something"]={tag="comment",style="custom",type="startblock",text="This sequence does something",block="block name"},
	["--v `block name` here ends the block"]={tag="comment",style="custom",type="endblock",text="here ends the block",block="block name"},
	["--v  here ends the block"]={tag="comment",style="custom",type="endblock",text="here ends the block"},
	["--> other comments"]={tag="comment",style="custom",type="other",text="other comments"}
}

function testparsecustom(comment,tab)
  local t,errno = comments.Parse(comment,"custom")
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
    else
      assert(parsed[k],"No entrie in parsed table with key <".. k ..">! Text was : "..comment)
      assert(expected[k],"No entrie in expected table with key <".. k ..">! Text was : "..comment)
       goDeep(parsed[k],expected[k],comment)
    end
   
  end
end

function unittest1()
  for k,v in pairs(expectedTable) do
	testparsecustom(k,v)
  end
end

unittest1()
