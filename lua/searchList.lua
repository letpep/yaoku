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
local mysql = require("mysqlconn")
local pagecount =5
local pagestart = 0
local findkey =""
local value = {}
local outputinfo = {}
local output = {}
local db = mysql:new()
if "GET" == request_method then
    local rdskey =nil
    args  = ngx.req.get_uri_args()
    for key,val in pairs(args) do
        if "findkey" == key  then
            findkey = val
        elseif "pageno" == key then
            pageno = val
        elseif "pagecount" == key then
            pagecount = 5
        end
        end
end
local sqlall =  "SELECT count(1) as count FROM yaoku_subject where enable = 1 and subject like '%"..findkey.."%'"
pagestart = (pageno-1)*pagecount
local res, err, errno, sqlstate = db:query(sqlall)
local body = json.encode(res)
for i, v in ipairs(res) do
    totalnum = v["count"]
end
ngx.log(ngx.ERR,"allcount",totalnum)

if totalnum >0 then
    local sqlpage = "SELECT subject,url FROM yaoku_subject where enable = 1 and subject like '%"..findkey.."%' limit "..pagecount .." offset "..pagestart.." "
    local resp, err, errno, sqlstate = db:query(sqlpage)
    for i, v in ipairs(resp) do
        table.insert(value,v)
    end
end
outputinfo["value"] = value
outputinfo["totalnum"] = totalnum
outputinfo["pageno"] = pageno
outputinfo["pagecount"] = pagecount
table.insert (output,json.encode(outputinfo))
ngx.say(table.concat(output,""))

