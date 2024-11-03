local desktop = require("desktop_api")
local screen = desktop.Desktop

screen:newLayer()

screen:circle(1,{20,20}, 15)

screen:render()

os.pullEvent("key")