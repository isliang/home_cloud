local upload = require "resty.upload"

local chunk_size = 4096
local form, err = upload:new(chunk_size)
if not form then
    ngx.say("CODE: ", ngx.ERR, ", MSG: failed to new upload: ", err)
    return
end
local file

function get_file_name(res)
    local filename = ngx.re.match(res,'(.+)filename="(.+)"(.*)')
    if filename then
        return ngx.var.store_dir .. filename[2]
    end
end

while true do
    local typ, res, err = form:read()

    if not typ then
        ngx.say("failed to read: ", err)
        return
    end

    if typ == "header" then
        if res[1] == "Content-Disposition" then
            local file_name = get_file_name(res[2])
            if file_name then
                file = io.open(file_name, "w+")
                if not file then
                    ngx.say("failed to open file ", file_name)
                    return
                end
            else
                ngx.say("failed to parse filename")
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
