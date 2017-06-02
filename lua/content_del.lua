
	--说明:当使用get方法时为查询缓存方法,当使用post方法时为更新缓存方法,为了获取post请求参数需要在location中写入: lua_need_request_body on;
    local redis = require("resty.rediscli-letpep")
	local json = require("cjson")
    local request_method = ngx.var.request_method
    local args = nil
	local cid = nil
	local red = redis.new()
	local rdskey = nil
 	if "GET" == request_method then
		args  = ngx.req.get_uri_args()
		for key,val in pairs(args) do
                	if "key" == key  then
                		rdskey = val
			end	
		end
		local res, err = red:exec(
			function(red)
                        return red:get(rdskey)
                        end
                        )
		local valueinner = json.decode(res)
		cid = valueinner["categoryid"]

	elseif "POST" == request_method then
		local rdsvalue = nil
		args=ngx.req.get_post_args()
		for key,val in pairs(args) do
                	if "key" == key then
                		rdskey = val
                	elseif "value" == key then
                		rdsvalue = val
                	end
        	end
		local res, err = red:exec(
                        function(red)
                       red:set(rdskey,rdsvalue)
                        end
                        )
		ngx.say(err)
	end
	--del
	local rdssetkey = "content_shows_set"
	local rdskeycontent = "contents"
	local res, err = red:exec(
	function(red)
		red:zrem(rdssetkey,rdskey)
		if cid then
			red:zrem(rdssetkey.."_"..cid,rdskey)
		end

	end
	)
	local resc, errc = red:exec(
	function(red)
		red:zrem(rdskeycontent,rdskey)
		if cid then
			red:zrem(rdskeycontent.."_"..cid,rdskey)
		end
	end
	)
--插入数据库
local res = ngx.location.capture('/postgres',
	{ args = {sql = "update yaoku_subject set enable =0 where subjectid = '"..rdskey.."';" } }
)

local status = res.status
	ngx.say(status)
