--
-- Created by IntelliJ IDEA.
-- User: lee_xin
-- Date: 17/7/24
-- Time: 上午10:59
-- To change this template use File | Settings | File Templates.
--
local sgmatch = string.gmatch --返回迭代器
local smatch = string.match --返回具体串
local stringv = "134abc445ABC@245"
local result =''
for v in sgmatch(stringv,'%d') do
    result =  result..v
end

local k1,v1 =  smatch(stringv,'(%d*)%a*(%d*)')
result = result..k1
result = result..v1
ngx.say(result)
