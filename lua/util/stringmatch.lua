--
-- Created by IntelliJ IDEA.
-- User: lee_xin
-- Date: 17/7/24
-- Time: 上午10:59
-- To change this template use File | Settings | File Templates.
--
local sgmatch = string.gmatch
local stringv = "134abc445ABC@245"
local result =''
for v in sgmatch(stringv,'%d') do
    result =  result..v
end

local k,v1 =  sgmatch(stringv,'(%d)abc(%d)')

ngx.say(k..v1)
