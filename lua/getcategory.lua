# import module
	--说明:当使用get方法时为查询缓存方法,当使用post方法时为更新缓存方法,为了获取post请求参数需要在location中写入: lua_need_request_body on;
    local redis = require("resty.rediscli-letpep")
    local json = require("cjson")
    local request_method = ngx.var.request_method
    local args = nil
    local res = nil
    local err = nil
    local output = {}
    local value = {}
    local outputinfo = {}
   -- table.insert(output,"cb")
	local red = redis.new()
 	if "GET" == request_method then
		res, err = red:exec(
        	function(red)
		return red:zrevrange("category" ,0,-1)
        	end
                )

	end
	for i, v in ipairs(res) do
		table.insert(value,v)
	end
	key = "value";
        outputinfo[key] = value
        table.insert (output,json.encode(outputinfo))
        --table.insert (output,");")
	ngx.say(table.concat(output,""))
	
