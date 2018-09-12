--
-- Author: lte
-- Date: 2016-10-11 18:32:47
-- 字体类

--[[
--ZP_Font = "fonts/arial.ttf"; -- 只是适合英文
ZP_Font = "fonts/Fonts.ttf"; -- 中文和英文都适合
--]]

-- 类申明
-- local Fonts = class("Fonts", function ()
--     return display.newNode();
-- end)
local Fonts = class("Fonts")


-- 类变量申明
--Fonts.Font = "fonts/arial.ttf"; -- 只是适合英文
--Fonts.Font = "fonts/Fonts.ttf"; -- 中文和英文都适合
Fonts.Font_hkyt_w9 = "fonts/huakangyt_w9.ttf"; -- 华康圆体 w9
Fonts.Font_hkyt_w7 = "fonts/huakangyt_w7.ttf"; -- 华康圆体 w7

-- 处理方法申明


-- 构造函数
function Fonts:ctor()
end

-- 必须有这个返回
return Fonts