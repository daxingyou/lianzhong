--
-- Author: lte
-- Date: 2016-10-11 18:32:47
-- 字体类

-- 类申明
-- local FontsUpd = class("FontsUpd", function ()
--     return display.newNode();
-- end)
local FontsUpd = class("FontsUpd")


FontsUpd.Font_hkyt_w9 = "fonts/huakangyt_w9.ttf" -- 华康圆体 w9
FontsUpd.Font_hkyt_w7 = "fonts/huakangyt_w7.ttf" -- 华康圆体 w7


-- 构造函数
function FontsUpd:ctor()
end

-- 必须有这个返回
return FontsUpd