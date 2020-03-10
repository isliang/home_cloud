local upload = require "resty.upload"

local chunk_size = 4096
local form, err = upload:new(chunk_size)
if not form then
    ngx.say("CODE: ", ngx.ERR, ", MSG: failed to new upload: ", err)
    return
end
local file

function get_ip()
    local ip = ngx.var.http_x_real_ip or ngx.var.http_x_forwarded_for or ngx.var.remote_addr or "0.0.0.0"
    return ip
end

function mkdir(path)
    local dir = io.open(path, "w+")
    if not dir then
        os.execute("mkdir " .. path)
    else
        dir:close()
    end
end

function get_filename(res)
    local filename = ngx.re.match(res,'(.+)filename="(.+)"(.*)')
    local path = ngx.var.store_dir .. ngx.md5(get_ip()) .. '/'
    mkdir(path)
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
