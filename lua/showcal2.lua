# import module
	--说明:当使用get方法时为查询缓存方法,当使用post方法时为更新缓存方法,为了获取post请求参数需要在location中写入: lua_need_request_body on;
    local redis = require("resty.rediscli-letpep")
    local request_method = ngx.var.request_method
    local args = nil
	local red = redis.new()
 	if "GET" == request_method then
		local rdskey =nil
		args  = ngx.req.get_uri_args()
		for key,val in pairs(args) do
                	if "key" == key  then
                		rdskey = val
			end	
		end
		local res, err = red:exec(
			function(red)
                        return red:hget("fkeyhash","lixin")
                        end
                        )
	ngx.log(ngx.ERR,"value:",res)
	end
local value = ngx.var.key
local result = ""
--file = io.input("/home/nginx/openresty/nginx/html/upload/"..value)
  --     repeat
    --            line = io.read()
      --         if nil == line then
        --              break
          --   end
--	result = result.."\r\n"..line
  --            until (false)
    --        io.close(file)
--		ngx.say(result)
