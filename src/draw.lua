local ffi = require "ffi"
local imgui = require "cimgui"

require "fileview"
local fbg = require "libs.filebrowser"()

local show = ffi.new("bool[1]", true)
local show_about = ffi.new("bool[1]", false)

local files = {}
local curfile = 0
local opendialog = fbg.FileBrowser(nil,{key="loader",pattern="",
curr_dir=love.filesystem.getUserDirectory()},function(fname) 
    print("load ",fname)
    table.insert(files, #files+1, OpenFile(fname))
end)

local function drawAbout()
    if show_about[0] then
        imgui.SetNextWindowSize(imgui.ImVec2_Float(400, 200))
        if (imgui.Begin("About ASTView", show_about,
        imgui.love.WindowFlags("NoResize", "NoSavedSettings"))) then
            for _,v in ipairs({
                love.window.getTitle(),
                "Created by K. 'ashifolfi' J.",
                "",
                "Libraries used:",
                "- json.lua by rxi",
                "- cimgui-love by apicici"
            }) do
                imgui.Text(v)
            end

            imgui.SetCursorPosY(160)
            if imgui.Button("Close") then
                show_about[0] = ffi.cast("bool", false)
            end
        end
        imgui.End()
    end
end

return function()
    local imio = imgui.GetIO()
    local open_file = false
    -- fullscreen window of tabs for property files
    
    imgui.SetNextWindowSize(imgui.ImVec2_Float(imio.DisplaySize.x, imio.DisplaySize.y))
    imgui.SetNextWindowPos(imgui.ImVec2_Float(0, 0))
    if (imgui.Begin("propedit", show, 
    imgui.love.WindowFlags("MenuBar", "NoResize", "NoMove", "NoTitleBar", "NoSavedSettings", "NoBringToFrontOnFocus"))) then
        if imgui.BeginMenuBar() then
            if imgui.BeginMenu("File") then
                if imgui.MenuItem_Bool("Open") then
                    open_file = ffi.new("bool[1]", true)
                end
                imgui.Separator()
                if imgui.MenuItem_Bool("Close") then
                    table.remove(files, curfile)
                end
                if imgui.MenuItem_Bool("Close All") then
                    files = {}
                end
                imgui.Separator()
                imgui.Text("Recent Items")
                imgui.Separator()
                if imgui.MenuItem_Bool("Quit") then love.event.quit() end
                imgui.EndMenu()
            end
            if imgui.BeginMenu("Help") then
                if imgui.MenuItem_Bool("About ASTView") then
                    show_about[0] = ffi.cast("bool", true)
                end
                imgui.EndMenu()
            end

            imgui.TextColored(imgui.ImVec4_Float(0.6, 0.6, 0.6, 1), love.window.getTitle())

            imgui.EndMenuBar()
        end

        if (imgui.BeginTabBar("##filetabs")) then
            for k,v in ipairs(files) do
                if (FileView(v)) then
                    curfile = k
                end
            end

            imgui.EndTabBar()
        end

        if open_file then
            opendialog.open()
        end
        opendialog.draw()
        drawAbout()
    end
    imgui.End()
end