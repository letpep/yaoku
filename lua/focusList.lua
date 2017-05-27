# import module
	--说明:当使用get方法时为查询缓存方法,当使用post方法时为更新缓存方法,为了获取post请求参数需要在location中写入: lua_need_request_body on;
    local redis = require("resty.rediscli-letpep")
    local json = require("cjson")
    local request_method = ngx.var.request_method
	local showRdskey = "content_shows_set"
    local args = nil
    local res = nil
    local err = nil
    local output = {}
    local value = {}
    local outputinfo = {}
    local totalnum = 0
    local pageno = 1
    local pagecount =5
    local pagestart = 0 
    local pageend = 0 
    local rdskey = "content_shows_set"
    --table.insert(output,"cb")
	local red = redis.new()
 	if "GET" == request_method then
		args  = ngx.req.get_uri_args()
		for key,val in pairs(args) do
                	if "key" == key  then
                		rdskey = val
			elseif "pageno" == key then
				pageno = val
			end	
		end
		local rest, errt = red:exec(
                        function(red)
                return red:zcard(rdskey)
                end
                )
		totalnum = rest
		pagestart = (pageno-1)*pagecount 
		pageend = pagestart+pagecount-1
		 res, err = red:exec(
        		function(red)
        	return red:zrevrange(rdskey ,pagestart,pageend,withscores)
        	end
                )

	end
	local resc =  table.concat(res,"|")
	local resd = json.encode(res)
	for i, v in ipairs(res) do
		local rdskey =""..v
 		 local ress, errs = red:exec(
                        function(red)
                        return red:get(rdskey)
                        end
                        )
		local valueinner = json.decode(ress)
		--获取主题的浏览数
		local res, err = red:exec(
			function(red)
				return red:zscore(showRdskey,rdskey)
			end
		)
		valueinner["shows"] = ""..res
		table.insert(value,valueinner)
	end
	key = "value";
        outputinfo[key] = value
	outputinfo["totalnum"] = totalnum
	outputinfo["pageno"] = pageno
	outputinfo["pagecount"] = pagecount
        table.insert (output,json.encode(outputinfo))
        --table.insert (output,outputinfo)
	--table.insert (output,");")
	ngx.say(table.concat(output,""))
	
