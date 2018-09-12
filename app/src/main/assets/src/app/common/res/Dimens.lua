--
-- Author: lte
-- Date: 2016-10-11 20:38:54
--

--[[
ZP_TextSize_17 = 17;
ZP_TextSize_30 = 30;
ZP_TextSize_80 = 80;
--]]

-- 类申明
-- local Dimens = class("Dimens", function ()
--     return display.newNode();
-- end)
local Dimens = class("Dimens")


-- 类变量申明

Dimens.TextSize_15 = 15;
Dimens.TextSize_17 = 17;
Dimens.TextSize_19 = 19;

Dimens.TextSize_16 = 16;
Dimens.TextSize_18 = 18;

Dimens.TextSize_20 = 20;
Dimens.TextSize_25 = 25;

Dimens.TextSize_30 = 30;
Dimens.TextSize_35 = 35;

Dimens.TextSize_40 = 40;
Dimens.TextSize_45 = 45;

Dimens.TextSize_50 = 50;
Dimens.TextSize_60 = 60;
Dimens.TextSize_70 = 70;
Dimens.TextSize_80 = 80;

-- 处理方法申明


-- 构造函数
function Dimens:ctor()
end

-- 必须有这个返回
return Dimens