local arg = ngx.req.get_uri_args()
local params = {}
for k,v in pairs(arg) do
    params[k] = v
end


if (ngx.var.cookie_token ~= "123") then
    if (params["token"] == "123") then
        ngx.header['Set-Cookie'] = 'token=123; path=/; Expires=' .. ngx.cookie_time(ngx.time() + 60 * 30)
    else
        ngx.exit(ngx.HTTP_BAD_REQUEST)
    end
end
