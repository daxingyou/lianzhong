--
-- Author: lte
-- Date: 2016-10-17 17:24:38
-- 分享信息

local ShareInfo = class("ShareInfo")


-- 类变量申明
ShareInfo.Bean = 
{
	message = "message", -- 系统消息部分
	content = "content",

	activeContent = "activeContent", -- 分享部分
	shareTitle = "shareTitle",
	sharePic = "sharePic",
	shareContent = "shareContent",
	jumpUrl = "jumpUrl",
	token = "token",

	shareToken = "shareToken",
	shareType = "shareType",
}

-- 方法体申明


-- 构造函数
function ShareInfo:ctor()
end


-- 必须有这个返回
return ShareInfo
