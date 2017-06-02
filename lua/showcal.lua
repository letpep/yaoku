
	local redis = require("resty.rediscli-letpep")
	local json = require("cjson")
	local showRdskey = "content_shows_set"
	local showRdskey_cay = nil
	local contentkey = nil
	local cid =nil
	local fhashkey = "fkeyhash"
	local value = ngx.var.key
	local red = redis.new()
	local resf = nil
	local errf = nil
	if value then
		resf, errf = red:exec(
                        function(red)
                      return red:hget(fhashkey,value)
			end
                        )
		if resf then
			contentkey = resf
		end
	end
	if contentkey then
		local ress, errs = red:exec(
			function(red)
				return red:get(contentkey)
			end
		)
		local valueinner = json.decode(ress)
		cid = valueinner["categoryid"]
		if cid then
			showRdskey_cay = showRdskey.."_"..cid
		end
		local res, err = red:exec(
			function(red)
				return  red:zincrby(showRdskey_cay,1,contentkey)
			end
		)
		local res, err = red:exec(
                        function(red)
                     return  red:zincrby(showRdskey,1,contentkey)
                        end
                        )
		if not res then
			ngx.log(ngx.ERROR,"inc show counts ERROR content:",value)
		end
	end

