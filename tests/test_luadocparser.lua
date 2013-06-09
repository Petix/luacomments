local comments = require("comments")


local expectedTable = {
 ["--- Define special sequences of characters."]=				{tag="comment",style="luadoc",type="descr",text="Define special sequences of characters."}
,["-- For each pair (find, subs), the function will create a field named with"]={tag="comment",style="luadoc",type="descr",text="For each pair (find, subs), the function will create a field named with"}
,["-- find which has the value of subs."]=						{tag="comment",style="luadoc",type="descr",text="find which has the value of subs."}
,["-- It also creates an index for the table, according to the order of insertion."]=					{tag="comment",style="luadoc",type="descr",text="It also creates an index for the table, according to the order of insertion."}
,["-- @param subs The replacement pattern."]=					{tag="comment",style="luadoc",type="param",name="subs",text="The replacement pattern."}
,["-- @param find The pattern to find."]=						{tag="comment",style="luadoc",type="param",name="find",text="The pattern to find."}
,["-- @class table"]=											{tag="comment",style="luadoc",type="class",name="table"}
,["-- @name T1"]=												{tag="comment",style="luadoc",type="name",name="T1"}
,["-- @author This is the name of the author."]=				{tag="comment",style="luadoc",type="author",text="This is the name of the author."}
,["-- @copyright MIT license"]=									{tag="comment",style="luadoc",type="copyright",text="MIT license"}
,["-- @release release comment"]=								{tag="comment",style="luadoc",type="release",text="release comment"}
,["-- @return This function return a number."]=					{tag="comment",style="luadoc",type="return",text="This function return a number."}
,["-- @returns This function return a number."]=					{tag="comment",style="luadoc",type="return",text="This function return a number."}
,["-- @ret This function return a number."]=					{tag="comment",style="luadoc",type="return",text="This function return a number."}
,["-- @see See something interesting"]=							{tag="comment",style="luadoc",type="see",text="See something interesting"}
,["-- @usage Usage helpt text."]=								{tag="comment",style="luadoc",type="usage",text="Usage helpt text."}
,["-- @field f1 This is a table field."]=						{tag="comment",style="luadoc",type="field",text="This is a table field.",name="f1"}
,["-- @f f1 This is a table field."]=						{tag="comment",style="luadoc",type="field",text="This is a table field.",name="f1"}   --alias 
,["-- @description Define special sequences of characters."]=	{tag="comment",style="luadoc",type="descr",text="Define special sequences of characters."}
}


function testparseLuaDoc(comment,tab)
  local t,errno = comments.Parse(comment,"luadoc")
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
  for k,v in pairs(expectedTable) do
    testparseLuaDoc(k,v)
  end
end

unittest1()
