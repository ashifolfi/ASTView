local json = require "libs.json"

local function searchMethods(data)
    local types = {
        "CXXConstructorDecl",
        "CXXDestructorDecl",
        "FunctionDecl",
        "CXXMethodDecl"
    }

    local output = {}

    -- hell
    local function recurseSearch(tbl)
        for k,v in pairs(tbl) do
            if type(v) == "table" then
                if v.kind then
                    -- search through the type list for matching types
                    for _,kind in pairs(types) do
                        if v.kind == kind then
                            output[v.mangledName] = {
                                name = v.name,
                                kind = v.kind
                            }
                        end
                    end
                end

                recurseSearch(v)
            end
        end
    end

    recurseSearch(data)

    return output
end

function OpenFile(filename)
    local file = io.open(filename, "r")
    local fd = file:read("*all")
    file:close()
    local obj = {
        name = filename,
        data = json.decode(fd)
    }

    obj.methoddata = searchMethods(obj.data)

    return obj
end