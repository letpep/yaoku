
	local json = require "cjson"

    local res = ngx.location.capture('/postgres',
        { args = {sql = "SELECT * FROM yaoku_subject" } }
    )

    local status = res.status
    local body = json.decode(res.body)

    if status == 200 then
        status = true
    else
        status = false
    end
    ngx.say(json.encode(body))
