--
-- Author: lte
-- Date: 2016-10-11 20:36:17
--

--[[
ZP_Status_normal = "normal";
ZP_Status_pressed = "pressed";
ZP_Status_disabled = "disabled";
--]]

-- 类申明
-- local EnStatus = class("EnStatus", function ()
--     return display.newNode();
-- end)
local EnStatus = class("EnStatus")


-- 类变量申明
EnStatus.normal = "normal";
EnStatus.pressed = "pressed";
EnStatus.disabled = "disabled";

EnStatus.clicked = "clicked"; -- 组件点击事件名称
EnStatus.began = "began"; -- touch 点击开始
EnStatus.moved = "moved"; -- touch 移动中
EnStatus.ended = "ended"; -- touch 结束

EnStatus.connected_succ = "connected_succ"; -- 连接成功
EnStatus.connected_fail = "connected_fail"; -- 连接失败
EnStatus.connected_close = "connected_close"; -- 连接即将关闭
EnStatus.connected_closed = "connected_closed"; -- 连接已经关闭
EnStatus.connected_receiveData = "connected_receiveData"; -- 连接接受到数据

-- 处理方法申明


-- 构造函数
function EnStatus:ctor()
end

-- 必须有这个返回
return EnStatus