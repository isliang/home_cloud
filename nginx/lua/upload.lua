local upload = require "resty.upload"

local chunk_size = 4096
local form = upload:new(chunk_size)
local file

function get_file_name(res)
    for file_name in string.gmatch(res[2], 'filename="(.+)"') do
        return ngx.var.store_dir .. file_name
    end
end

while true do
    local typ, res, err = form:read()

    if not typ then
        ngx.say("failed to read: ", err)
        return
    end

    if typ == "header" then
        local file_name = get_file_name(res)
        if file_name then
            file = io.open(file_name, "w+")
            if not file then
                ngx.say("failed to open file ", file_name)
                return
            end
        end

    elseif typ == "body" then
        if file then
            file:write(res)
        end

    elseif typ == "part_end" then
        file:close()
        file = nil
    elseif typ == "eof" then
        ngx.say("upload success!")
        break
    else
        -- do nothing
    end
end
