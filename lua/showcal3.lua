# import module
	local redis = require("resty.rediscli-letpep")
	local json = require("cjson")
	local showRdskey = "content_shows_set"
	local contentkey = nil
	local fhashkey = "fkeyhash"
	local value = ngx.var.key
	local red = redis.new()
	local resf = nil
	local errf = nil
	ngx.log(ngx.ERR,"value",value)
	if value then
		resf, errf = red:exec(
                        function(red)
                      return red:hget(fhashkey,value)
			end
                        )
		ngx.log(ngx.ERR,"res",resf)
		if resf then 
			contentkey = resf
		end
	end
	ngx.log(ngx.ERR,"contentkey",contentkey)
	if contentkey then
		local res, err = red:exec(
                        function(red)
                     return  red:zincrby(showRdskey,1,contentkey)
                        end
                        )
		if not res then
			ngx.log(ngx.ERROR,"inc show counts ERROR content:",value)
		end
	end
	
