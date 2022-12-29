local imgui = require "cimgui"
local ffi = require "ffi"

local function drawTable(tbl)
    local function recurse(tbl)
        for k,v in pairs(tbl) do
            imgui.TableNextRow()
            imgui.TableNextColumn()
            if type(v) ~= "table" then
                imgui.Selectable_Bool(tostring(k))
                imgui.TableNextColumn()
                imgui.Selectable_Bool(tostring(v))
            else
                if (imgui.TreeNodeEx_Str(tostring(k), imgui.ImGuiTreeNodeFlags_SpanFullWidth)) then
                   recurse(v)
                   imgui.TreePop()
                end
                imgui.TableNextColumn()
            end
        end
    end

    if imgui.BeginTable("##tableview", 2, imgui.ImGuiTableFlags_RowBg) then
        imgui.TableSetupColumn("Key", ImGuiTableColumnFlags_NoHide)
        imgui.TableSetupColumn("Value", ImGuiTableColumnFlags_NoHide)
        imgui.TableHeadersRow()

        recurse(tbl)

        imgui.EndTable()
    end
end

function FileView(data)
    if (imgui.BeginTabItem(data.name)) then

        if (imgui.BeginTabBar("##viewtabs")) then
            if imgui.BeginTabItem("Raw JSON") then
                drawTable(data.data)
                imgui.EndTabItem()
            end
            if imgui.BeginTabItem("Methods") then
                drawTable(data.methoddata)
                imgui.EndTabItem()
            end

            imgui.EndTabBar()
        end
        
        imgui.EndTabItem()
    end
end