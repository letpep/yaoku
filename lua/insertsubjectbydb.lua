
	local json = require "cjson"

    local res = ngx.location.capture('/postgres',
        { args = {sql = "insert into yaoku_subject(subject,url) values('测试数据tt','http:22')" } }
    )

    local status = res.status
    local body = json.decode(res.body)

    if status == 200 then
        status = true
    else
        status = false
    end
    ngx.say(status)
