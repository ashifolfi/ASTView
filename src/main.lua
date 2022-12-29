-- Make sure the shared library can be found through package.cpath before loading the module.
local lib_folder = string.format("libs/%s-%s", jit.os, jit.arch)
assert(
    love.filesystem.getRealDirectory(lib_folder),
    "The precompiled cimgui shared library is not available for your os/architecture. You can try compiling it yourself."
)
love.filesystem.remove(lib_folder)
love.filesystem.createDirectory(lib_folder)
for _, v in ipairs(love.filesystem.getDirectoryItems(lib_folder)) do
    local filename = string.format("%s/%s", lib_folder, v)
    assert(love.filesystem.write(filename, love.filesystem.read(filename)))
end
local extension = jit.os == "Windows" and "dll" or jit.os == "Linux" and "so" or jit.os == "OSX" and "dylib"
package.cpath = string.format("%s;%s/%s/?.%s", package.cpath, love.filesystem.getSaveDirectory(), lib_folder, extension)

local imgui = require "cimgui" -- cimgui is the folder containing the Lua module (the "src" folder in the github repository)

local draw = require "draw"

love.load = function()
    imgui.love.Init() -- or imgui.love.Init("RGBA32") or imgui.love.Init("Alpha8")
end

love.draw = function()
    draw()
    
    -- code to render imgui
    imgui.Render()
    imgui.love.RenderDrawLists()
end

love.update = function(dt)
    imgui.love.Update(dt)
    imgui.NewFrame()
end

love.mousemoved = function(x, y, ...)
    imgui.love.MouseMoved(x, y)
    if not imgui.love.GetWantCaptureMouse() then
        -- your code here
    end
end

love.mousepressed = function(x, y, button, ...)
    imgui.love.MousePressed(button)
    if not imgui.love.GetWantCaptureMouse() then
        -- your code here 
    end
end

love.mousereleased = function(x, y, button, ...)
    imgui.love.MouseReleased(button)
    if not imgui.love.GetWantCaptureMouse() then
        -- your code here 
    end
end

love.wheelmoved = function(x, y)
    imgui.love.WheelMoved(x, y)
    if not imgui.love.GetWantCaptureMouse() then
        -- your code here 
    end
end

love.keypressed = function(key, ...)
    imgui.love.KeyPressed(key)
    if not imgui.love.GetWantCaptureKeyboard() then
        -- your code here 
    end
end

love.keyreleased = function(key, ...)
    imgui.love.KeyReleased(key)
    if not imgui.love.GetWantCaptureKeyboard() then
        -- your code here 
    end
end

love.textinput = function(t)
    imgui.love.TextInput(t)
    if imgui.love.GetWantCaptureKeyboard() then
        -- your code here 
    end
end

love.quit = function()
    return imgui.love.Shutdown()
end

-- for gamepad support also add the following:

love.joystickadded = function(joystick)
    imgui.love.JoystickAdded(joystick)
    -- your code here 
end

love.joystickremoved = function(joystick)
    imgui.love.JoystickRemoved()
    -- your code here 
end

love.gamepadpressed = function(joystick, button)
    imgui.love.GamepadPressed(button)
    -- your code here 
end

love.gamepadreleased = function(joystick, button)
    imgui.love.GamepadReleased(button)
    -- your code here 
end

-- choose threshold for considering analog controllers active, defaults to 0 if unspecified
local threshold = 0.2 

love.gamepadaxis = function(joystick, axis, value)
    imgui.love.GamepadAxis(axis, value, threshold)
    -- your code here 
end

love.resize = function(w, h)
    local io = imgui.GetIO()
    io.DisplaySize.x, io.DisplaySize.y = w, h
end