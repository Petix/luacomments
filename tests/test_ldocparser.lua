local comments = require("comments")


local expectedT = 
{
["--- descr text"]={tag="comment",style="ldoc",text="descr text",type="descr"},

["-- @alias M"]={tag="comment",style="ldoc",name="M",type="alias"},

["---  @fixme otherwise do what?"]={tag="comment",style="ldoc",text="otherwise do what?",type="fixme"},

["--- @todo also handle foo case"]={tag="comment",style="ldoc",text="also handle foo case",type="todo"},

["-- @param ...  var args!"]={tag="comment",style="ldoc",text="var args!",name="...",type="param"},  

["-- @usage adsaweass das "]={tag="comment",style="ldoc",text="adsaweass das ",type="usage"},

["-- @table stdvars"]={tag="comment",style="ldoc",name="stdvars",type="table"},

["-- @section file"]={tag="comment",style="ldoc",name="file",type="section"},

["-- @type File"]={tag="comment",style="ldoc",name="File",type="type"},

["-- @module mod1"]={tag="comment",style="ldoc",name="mod1",type="module"},

["-- @name restable"]={tag="comment",style="ldoc",name="restable",type="name"},

["-- @script modtest"]={tag="comment",style="ldoc",name="modtest",type="script"},

["-- @tparam string ...  var args!"]={tag="comment",style="ldoc",text="var args!",name="...",vartype={"string"},type="tparam"},

["-- @tparam string|number ...  var args!"]={tag="comment",style="ldoc",text="var args!",name="...",type="tparam",vartype={"string","number"}},

["-- @treturn string  varname text  var args!"]={tag="comment",style="ldoc",text="text  var args!",name="varname",vartype={"string"},type="treturn"},

["-- @string VAR  var args!"]={tag="comment",style="ldoc",text="var args!",name="VAR",vartype={"string"},type="tparam"},

["-- string: VAR  var args!"]={tag="comment",style="ldoc",text="var args!",name="VAR",vartype={"string"},type="tparam"}
}


function testparseLDoc(comment,tab)
  local t,errno = comments.Parse(comment,"ldoc")
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

function unittest1( )
	for k,v in pairs(expectedT) do
	  testparseLDoc(k,v)
	end
end

unittest1()