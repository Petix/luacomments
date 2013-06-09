local comments = require("comments")


local expectedTables= {
  ['--| Begins a module/file comment, e.g., "this file does *this*".']={  
    type = "module",
    style = "explua",
    text = 'Begins a module/file comment, e.g., "this file does *this*".',
    tag = "comment"
  },
["--by Pedro Miller Rabinovitch <miller@inf.puc-rio.br>"]={  
    type = "author",
    style = "explua",
    text = "Pedro Miller Rabinovitch <miller@inf.puc-rio.br>",
    tag = "comment"
  },
  ["--$Id: myfile.lua,v 1.12 2003/10/17 00:13:56 miller Exp $"]={  
    type = "release",
    style = "explua",
    text = 'myfile.lua,v 1.12 2003/10/17 00:13:56 miller Exp $',
    tag = "comment"
  },
  ["--TODO lots of stuff."]={  
    type = "todo",
    style = "explua",
    text = 'lots of stuff.',
    tag = "comment"
  },
  ["--% This is the purpose of the function, i.e., what it *does*."]={  
    type = "descr",
    style = "explua",
    text = 'This is the purpose of the function, i.e., what it *does*.',
    tag = "comment"
  },
  ["--- And this is the second line, which will concatenated to"]={  
    type = "descr",
    style = "explua",
    text = 'And this is the second line, which will concatenated to',
    tag = "comment"
  },
  ["--- the others."]={  
    type = "descr",
    style = "explua",
    text = 'the others.',
    tag = "comment"
  },
  ["--@ first (string|number|nil) Text of the first parameter"]={  
    type = "param",
    style = "explua",
    var="first",
    text = 'Text of the first parameter',
    vartype={
      [1]='string',
      [2]='number',
      [3]='nil',
    },
    tag = "comment"
  },
  ["--@ what (table,number,nil) The second parameter is the table used for an example"]={  
    type = "param",
    style = "explua",
    var="what",
    text = 'The second parameter is the table used for an example',
    vartype={
      [1]='table',
      [2]='number',
      [3]='nil',
    },
    tag = "comment"
  },
  ["--@ [...] (any) Optional parameters to the called whatever"]={  
    type = "param",
    style = "explua",
    var="...",
    text = 'Optional parameters to the called whatever',
    vartype={
      [1]='any'
    },
    tag = "comment"
  },
 [ "--: (number) Number of whatevers done or nil if an error occured"]={  
    type = "return",
    style = "explua",
    text = 'Number of whatevers done or nil if an error occured',
    vartype={
      [1]='number'
    },
    tag = "comment"
  },
  ["--& MyTable It stores some stuff"]={  
    type = "table",
    style = "explua",
    var="MyTable",
    text = 'It stores some stuff',
    tag = "comment"
  },
 ["--. MyTable MyKeyInMyTable a important field in my table"]={  
    type = "tablefield",
    style = "explua",
    table="MyTable",
    var="MyKeyInMyTable",
    text = 'a important field in my table',
    tag = "comment"
  },
}

local expectedTable_withExtendedReturn = {
["--: VARNAME (number) Number of whatevers done or nil if an error occured"]={    
    type = "return",
    style = "explua",
    var = "VARNAME",
    text = 'Number of whatevers done or nil if an error occured',
    vartype={
      [1]='number'
    },
    tag = "comment"
  }
}


function testparseExpLua(comment,tab,extended)
  local t,errno = comments.Parse(comment,"explua",extended)
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
  for k,v in pairs(expectedTables) do
    testparseExpLua(k,v)
  end
end

function unittest2()
  for k,v in pairs(expectedTable_withExtendedReturn) do
    testparseExpLua(k,v,true)
  end
end

unittest1()
unittest2()
