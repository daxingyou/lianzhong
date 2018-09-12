--
-- Author: lte
-- Date: 2016-10-17 17:24:38
-- 微信服务器返回的信息

local WX = class("WX")


-- 类变量申明
WX.Bean = {
	-- 微信服务器给到的
	access_token = "access_token",
	expires_in = "expires_in",
	refresh_token = "refresh_token-_tBu4P1_iqmA2Lt-8HRv6Y8QSNMLMO2DIGueVg",
	openid = "openid",
	scope = "scope",
	unionid = "unionid"
}

-- 方法体申明


-- 构造函数
function WX:ctor()
end


-- 必须有这个返回
return WX
