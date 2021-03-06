local upload = require "resty.upload"
local common = require "common"

local chunk_size = 4096
local form, err = upload:new(chunk_size)
if not form then
    ngx.say("CODE: ", ngx.ERR, ", MSG: failed to new upload: ", err)
    return
end
local file

function get_filename(res)
    local filename = ngx.re.match(res,'(.+)filename="(.+)"(.*)')
    local ip = ngx.re.match(common.get_ip(),"[0-9]+.[0-9]+.[0-9]+.([0-9]+)")
    local path = ngx.var.store_dir
    local arg = ngx.req.get_uri_args()
    if arg["is_private"] == "1" then
        path = path .. ip[1] .. '/'
    end
    common.mkdir(path)
    if filename then
        --不同的ip存放的目录不同--
        return path .. filename[2]
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
            local file_name = get_filename(res[2])
            if file_name then
                file = io.open(file_name, "w+")
                if not file then
                    ngx.say("failed to open file ", file_name)
                    return
                end
            end
        end
    elseif typ == "body" then
        if file then
            file:write(res)
        end

    elseif typ == "part_end" then
        if file then
            file:close()
            file = nil
        end
    elseif typ == "eof" then
        ngx.say("upload success!")
        break
    else
        -- do nothing
    end
end
