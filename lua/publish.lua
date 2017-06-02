
	--说明:当使用get方法时为查询缓存方法,当使用post方法时为更新缓存方法,为了获取post请求参数需要在location中写入: lua_need_request_body on;
    local redis = require("resty.rediscli-letpep")
    local json = require("cjson")
    local request_method = ngx.var.request_method
    local args = nil
    local rdskey = "contents"
	local rdskey_cay = nil
	local rdssetkey = "content_shows_set"
	local rdssetkey_cay =nil
    local subjectid="subject_"
    local subject = nil
	local cid =nil
    local url = ""
    local filename =nil
    local fhashkey = "fkeyhash"
	ngx.req.read_body()
        local data = ngx.req.get_body_data()
	local datat = json.decode(data)
	subject = datat["subject"]
	url = datat["lurl"]
	cid = datat ["categoryid"]
	if cid then
		rdskey_cay = rdskey.."_"..categoryid
		rdssetkey_cay = rdssetkey.."_"..categoryid
	end


	ngx.log(ngx.ERR,"categoryid:",categoryid)
	-- 字符串 split 分割
	 string.split = function(s, p)
	     local rt= {}
	         string.gsub(s, '[^'..p..']+', function(w) table.insert(rt, w) end )
	             return rt
	             end
              
	local red = redis.new()
	if "POST" == request_method then
		local args2  = ngx.req.get_uri_args()
		args=ngx.req.get_post_args()
		for key,val in pairs(args) do
                	if "subject" == key then
                		subject = val
                	elseif "lurl" == key then
                		url = val
                	end
        	end
		
	end
	--将url中的文件名拿出来hashmap存
	if url then
		 local kvurl = string.split(url, "/")
		 filename = kvurl[table.getn(kvurl)]	
	end
	--local date = os.date("%Y-%m-%d %X") 2017-06-01 13:48:55
	local date = os.date("%Y-%m-%d")
	local rdsscore = os.time()- 1495535000
	local subjectkey = subjectid..rdsscore
	local res, err = red:exec(
                        function(red)
                       red:zadd(rdskey,rdsscore,subjectkey)
                        end
                        )
	local resc, errc = red:exec(
		function(red)
			red:zadd(rdskey_cay,rdsscore,subjectkey)
		end
	)
	local value ={}
	value["subject"]=''..subject..''
	value["categoryid"]=''..cid..''
	value["url"] = '"'..url..'"'
	value["subjectid"] = '"'..subjectkey..'"'
	value["date"] = '"'..date..'"'
	local subjectvalue = json.encode(value)
	local res, err = red:exec(
                        function(red)
                       red:set(subjectkey,subjectvalue)
                        end
                        )
	if filename then
		local res, err = red:exec(
                        function(red)
                       red:hset(fhashkey,filename,subjectkey)
                        end
                        )
	end

			local res, err = red:exec(
                        function(red)
                       red:zadd(rdssetkey,0,subjectkey)
                        end
                        )
		local rescc, errcc = red:exec(
			function(red)
				red:zadd(rdssetkey_cay,0,subjectkey)
			end
		)

	local resultt = {}
	resultt["res"]="ok"
--插入数据库
local res = ngx.location.capture('/postgres',
	{ args = {sql = "insert into yaoku_subject(subject,url,subjectid,add_time,categoryid) values('"..subject.."','"..url.."','"..subjectkey.."',"..rdsscore..",'"..categoryid.."')" } }
)

local status = res.status
ngx.log(ngx.ERR,"status",status)
	ngx.say(json.encode(resultt))
