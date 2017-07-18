--
-- Created by IntelliJ IDEA.
-- User: lee_xin
-- Date: 17/7/18
-- Time: 下午3:26
-- To change this template use File | Settings | File Templates.
--
local template = require "resty.template"
-- Using template.new
local view = template.new "templateDemo.html"
view.message = "Hello, World!"
view:render()
-- Using template.render
template.render("view.html", { message = "Hello, World!" })

