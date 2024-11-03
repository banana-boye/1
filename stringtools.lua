--[[
MIT License

Copyright (c) 2024 Orion

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]

local expect = require "cc.expect"
local expect, range = expect.expect, expect.range

local function fracture(str)
    local f = {}
    for i in string.gmatch(str, ".") do
        table.insert( f,i )
    end
    return f
end

local funcs = {
    fracture = fracture,
    wrap = function(str, end_x)
        expect(1, str, "string")
        expect(2, end_x, "number")

        local str = fracture(str)
        local new_str = {}
        local curr = ""
        local c = 1
    
        for index, char in pairs(str) do
            if c == end_x then
                curr = curr..char
                table.insert(new_str, curr)
                curr = ""
                c = 0
            else
                curr = curr..char
            end
            c = c + 1
        end
        table.insert(new_str, curr)
        return new_str
    end,
    loadingBar = function(progress, width, fill, empty)
        expect(1, progress, "number")
        range(progress, -1,1)
        expect(2, width, "number")
        expect(3, fill, "string", "nil")
        expect(4, empty, "string", "nil")
        fill = fill and fill or "\127"
        empty = empty and empty or " "
        local loading_bar = ""
        width = width - 2
        for i = 1, width do
            loading_bar = (progress * (width)) >= i and loading_bar..fill or loading_bar..empty
        end
        return "["..loading_bar.."]"
    end,
    count = function(str, char)
        expect(1, str, "string")
        expect(2, char, "string")
        local count = 0
        for i in string.gmatch(str,char) do
            count = count + 1
        end
        return count
    end,
    centerX = function(str, width)
        expect(1, str, "string")
        expect(2, width, "number")
        return math.floor((width-#str)/2)
    end,
    split = function(str, sep)
        expect(1, str, "string")
        expect(1, str, "string")
        if sep == nil then
            sep = "%s"
        end
        local t = {}
        for sr in string.gmatch(str, "([^"..sep.."]+)") do
            table.insert(t, sr)
        end
        return t
    end,
    replace = function(str, from, to)
        expect(1, str, "string")
        expect(2, from, "string")
        expect(3, to, "string")
        return str:gsub(from, to)
    end
}
local function add()
    for func_name, func in pairs(funcs) do
        string[func_name] = func
    end
end

return add