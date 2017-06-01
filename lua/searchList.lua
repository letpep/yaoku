--
-- Created by IntelliJ IDEA.
-- User: lee_xin
-- Date: 17/6/1
-- Time: 下午6:01
-- To 支持分页搜索
--
local json = require("cjson")
local request_method = ngx.var.request_method
local totalnum = 0
local pageno = 1
local pagecount =5
local pagestart = 0
local findkey =""
local value = {}
local outputinfo = {}
local output = {}
if "GET" == request_method then
    local rdskey =nil
    args  = ngx.req.get_uri_args()
    for key,val in pairs(args) do
        if "findkey" == key  then
            findkey = val
        elseif "pageno" == key then
            pageno = val
        elseif "pagecount" == key then
            pagecount = val
        end
        end
end

pagestart = (pageno-1)*pagecount
local res = ngx.location.capture('/postgres',
    { args = {sql = "SELECT count(1) FROM yaoku_subject where subject like '%"..findkey.."%';" } }
)

local status = res.status
local body = json.decode(res.body)
for i, v in ipairs(body) do
    totalnum = v["count"]
end
if totalnum >0 then
local resc = ngx.location.capture('/postgres',
    { args = {sql = "SELECT subject,url FROM yaoku_subject where subject like '%"..findkey.."%' limit "..pagecount .." offset "..pagestart.." ;" } }
)
local bodyc = json.decode(resc.body)
for i, v in ipairs(bodyc) do
    table.insert(value,v)
end
end
outputinfo["value"] = value
outputinfo["totalnum"] = totalnum
outputinfo["pageno"] = pageno
outputinfo["pagecount"] = pagecount
table.insert (output,json.encode(outputinfo))
ngx.say(table.concat(output,""))

