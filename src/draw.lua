local imgui = require "cimgui"
local ffi = require "ffi"

local imio = imgui.GetIO()

require "fileview"
local fbg = require "libs.filebrowser"(imgui)

local show = ffi.new("bool[1]", true)

local files = {}
local curfile = 0

local opendialog = fbg.FileBrowser(nil,{key="loader",pattern="",
curr_dir=love.filesystem.getUserDirectory()},function(fname) 
    print("load ",fname)
    table.insert(files, #files+1, OpenFile(fname))
end)

return function()
    local open_file = false
    -- fullscreen window of tabs for property files
    
    imgui.SetNextWindowSize(imgui.ImVec2_Float(imio.DisplaySize.x, imio.DisplaySize.y))
    imgui.SetNextWindowPos(imgui.ImVec2_Float(0, 0))
    if (imgui.Begin("propedit", show, 
    imgui.WindowFlags("MenuBar", "NoResize", "NoMove", "NoTitleBar", "NoSavedSettings"))) then
        if imgui.BeginMenuBar() then
            if imgui.BeginMenu("File") then
                if imgui.MenuItem_Bool("New") then
                    table.insert(files, #files+1, {name = "New File"..#files+1, data = {}})
                end
                imgui.Separator()
                if imgui.MenuItem_Bool("Open") then
                    open_file = true
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
            if imgui.BeginMenu("View") then
                imgui.EndMenu()
            end
            if imgui.BeginMenu("Help") then
                imgui.MenuItem_Bool("About ASTView")
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
    end
    imgui.End()
end