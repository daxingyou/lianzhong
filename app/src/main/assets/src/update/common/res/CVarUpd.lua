--
-- Author: lte
-- Date: 2016-10-10 12:26:49
-- 全局变量


-- 类申明
--local CVar = class("CVar", function ()
--    return display.newNode();
--end)
local CVar = class("CVar")


-- 环境
CVar._static = {

	-- token = "", -- 当前用户的编号

	appstoreSwitch = "none", -- open=显示  close=不显示  苹果审核开关，默认=none，什么按钮都没有，需要和服务器发生交互之后才有值
	protocolSwitch = "close", -- open=显示  close=不显示  用户协议开关，默认=close，不显示协议 【苹果审核开关优先控制，只要是游客模式，用户协议必定不出现】
	
	isIpad = false, -- 是不是ipad平板
	isIphone4 = false, -- 是不是iphone的手机
	NavBarH_Android = 0, -- android手机 如果有虚拟键的 高度多少

	hotUpdateDataDir = 'userUpdData/', -- 本地记录的热更新的目录
	hotUpdateDataResDir = 'userUpdData/res/', -- 本地记录的热更新的目录
	hotUpdateDataTxt = 'userUpdData/hotUpdateData.txt', -- 本地记录的热更新的文件

	hostIp = nil, -- 走了httpdns获取到的对应域名的ip地址
	httpDnsAccountID = '106401', -- 走httpdns的分配的id号
}


-- 构造函数
function CVar:ctor()
end

-- 必须有这个返回
return CVar