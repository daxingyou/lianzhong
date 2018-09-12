--
-- Author: lte
-- Date: 2016-10-17 17:17:58
-- 带来信息

local Proxies = class("Proxies")


-- 类变量申明
Proxies.Bean = {
	proxies = 'proxies', -- 用户本身对象

	descript = 'descript', -- 名称
	proxyNo = 'proxyNo', -- 编号
}



-- 方法体申明


-- 构造函数
function Proxies:ctor()
end


-- 必须有这个返回
return Proxies