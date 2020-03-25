local arg = ngx.req.get_uri_args()
local token = "123"
if (ngx.var.cookie_token ~= token) then
    if (arg["token"] == token) then
        ngx.header['Set-Cookie'] = 'token=' .. token .. '; path=/; Expires=' .. ngx.cookie_time(ngx.time() + 60 * 30)
    else
        ngx.exit(ngx.HTTP_BAD_REQUEST)
    end
end
