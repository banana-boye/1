local desktop = require("desktop_api")
local width, height = term.getSize()
local screen, style = desktop.Desktop(), desktop.Style
term.setPaletteColor(colors.lightBlue, 0x355C7D)
term.setPaletteColor(colors.pink, 0x725A7A)
term.setPaletteColor(colors.brown, 0xC56C86)
term.setPaletteColor(colors.blue, 0xFF7582)

screen:newLayer()

local s = style()
s.backgroundColor = colors.lightBlue

screen:rectangle(1, {1,1}, {102,57}, s)

screen:newLayer(2)
local p = style()
p.backgroundColor = colors.pink
local l = 41
for y = 1, 57 do
    for x = 1, 102 do
        if x > l then
            screen:dot(2, {x,y}, p)
        end
    end
    l = l - 1
end

local b = style()
b.backgroundColor = colors.brown
local f = 76
for y = 1, 57 do
    for x = 1, 102 do
        if x > f then
            screen:dot(2, {x,y}, b)
        end
    end
    f = f - 1
end
local g = style()
g.backgroundColor = colors.blue
local c = 112
for y = 1, 57 do
    for x = 1, 102 do
        if x > c  then
            screen:dot(2, {x,y}, g)
        end
    end
    c = c - 1
end
screen:newLayer(3)

screen:rectangle(3, {1, 10}, {48,8}, g, "organize")

screen:rectangle(3, {1, 22}, {38,8}, b, "withdraw")

screen:rectangle(3, {1, 34}, {30,8}, s, "deposit")

screen:render()
term.setCursorPos(2, 5)
term.setBackgroundColor(colors.blue)
write("ORGANIZE INVENTORY")
term.setCursorPos(width-2, height)
write("1.3")

term.setCursorPos(2, 9)
term.setBackgroundColor(colors.brown)
write("WITHDRAW ITEMS")
term.setCursorPos(41,1)
write("THE ORION")
term.setCursorPos(41,2)
write("SI SYSTEM")

term.setCursorPos(2, 13)
term.setBackgroundColor(colors.lightBlue)
write("DEPOSIT ITEMS")

print(screen:getClicked())