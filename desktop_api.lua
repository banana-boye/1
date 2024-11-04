local pixelbox = require("pixelbox_lite")
local expect = require("cc.expect")
local box = pixelbox.new(term.current())
require("stringtools")()

--pixelbox setup
---@param position table
---@param size table
---@param color number
---@param fill boolean
---Create pixelbox rectangle using position and size
function box.canvas.rect(position, size, color, fill)
    local startingX, startingY = table.unpack(position)
    local endingX, endingY = table.unpack(size)
    endingX, endingY = startingX + endingX, startingY + endingY

    for y = startingY, endingY do
        for x = startingX, endingX do
            box.canvas[y][x] = color
        end
    end
end

--pixelbox setup
---@param position table
---@param radius number
---@param color number
---@param fill boolean
---Create pixelbox rectangle using position and size
function box.canvas.circle(position, radius, color, fill)
    local startingX, startingY = table.unpack(position)

    local function main(r)
        for deg = 1, 360 do
            box.canvas[math.floor(math.sin(deg)*r + startingY)][math.floor(math.cos(deg)*r + startingX)] = color
        end
    end
    main(radius)
    while fill and radius ~= 0 do
        radius = radius - 1
        main(radius)
    end
end

--api

---@class Desktop
local Desktop = {
    output = nil,
    size = {table.pack(term.current().getSize())[1]*2, table.pack(term.current().getSize())[2]*3},
    layers = {},
    background = {}
}
---@class Style
local Style = {
    backgroundColor = colors.white,
    borderColor = colors.white,
    borderThickness = 0,
    full = true
}


---@param layer number|nil
---@return number layer The layer index created
---Create a new layer
function Desktop.newLayer(self, layer)
    if not layer then
        table.insert(self.layers, {})
        return #self.layers
    else
        self.layers[layer] = {}
        return layer
    end
end

---@param layer number
---@param position table|nil
---@param size table|nil
---@param style Style|nil
---@param label string|number|nil
---@return number|string|nil
---Create a rectangle on the desktop on a given a layer
function Desktop.rectangle(self, layer, position, size, style, label)
    local layer = self.layers[layer]
    local label = (label and layer[label] == nil) and label or #layer+1
    layer[label] = {
        shape = "rect",
        position = position and position or {1,1},
        size = size and size or {1,1},
        style = style and style or Style
    }
    return label
end

---@param layer number
---@param position table|nil
---@param radius number|nil
---@param style Style|nil
---@param label string|number|nil
---@return number|string|nil
---Create a circle on the desktop on a given a layer
function Desktop.circle(self, layer, position, radius, style, label)
    local layer = self.layers[layer]
    local label = (label and layer[label] == nil) and label or #layer+1
    layer[label] = {
        shape = "circle",
        position = position and position or {1,1},
        radius = radius and radius or 5,
        style = style and style or Style
    }
    return label
end

---@param layer number
---@param position table|nil
---@param style Style|nil
---@param label string|number|nil
---@return number|string|nil
---Create a circle on the desktop on a given a layer
function Desktop.dot(self, layer, position, style, label)
    local layer = self.layers[layer]
    local label = (label and layer[label] == nil) and label or #layer+1
    layer[label] = {
        shape = "dot",
        position = position and position or {1,1},
        style = style and style or Style
    }
    return label
end

---@return string|number|nil, number|nil
---Get clicked object
function Desktop.getClicked(self)
    local _, button, x, y = os.pullEvent("mouse_click")
    for layer = #self.layers, 1, -1 do
        for label, object in pairs(self.layers[layer]) do
            if object.shape == "rect" then
                local startingX, startingY = table.unpack(object.position)
                local endingX, endingY = table.unpack(object.size)
                endingX, endingY = math.floor((startingX + endingX)/2+0.5), math.floor((startingY + endingY)/3+0.5)
                startingX, startingY = math.floor(startingX/2), math.floor(startingY/3)
                if x >= startingX and x <= endingX and y >= startingY and y <= endingY then
                    return label, button
                end
            end
        end
    end
    return nil, nil
end

---@param layer number|nil
---Render all objects
function Desktop.render(self, layer)
    local function renderLayer(lyr)
        for _, object in pairs(lyr) do
            if object.shape == "rect" then
                box.canvas.rect(object.position, object.size, object.style.backgroundColor, object.style.full)
            elseif object.shape == "circle" then
                box.canvas.circle(object.position, object.radius, object.style.backgroundColor, object.style.full)
            elseif object.shape == "dot" then
                box.canvas[object.position[2]][object.position[1]] = object.style.backgroundColor
            end
        end
    end

    if not layer then
        for _, layer in ipairs(self.layers) do
            renderLayer(layer)
        end
    else
        renderLayer(self.layers[layer])
    end

    box:render()
end

---Clear all objects
function Desktop.clear(self, layer)
    if layer then
        self.layers[layer] = {}
    else
        for layer, _ in pairs(self.layers) do
            self.layers[layer] = {}
        end
    end
end
local function deepCopy(original)
    local copy = {}
    for k, v in pairs(original) do
        if type(v) == "table" then
            copy[k] = deepCopy(v)  -- Recursively copy nested tables
        else
            copy[k] = v
        end
    end
    return copy
end
local StyleMetatable = {
    __call = function()
        return deepCopy(Style)
    end
}
setmetatable(Style, StyleMetatable)
local DesktopMetatable = {
    __call = function()
        return deepCopy(Desktop)
    end
}
setmetatable(Desktop, DesktopMetatable)

return {Desktop = Desktop, Style = Style}