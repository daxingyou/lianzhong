--
-- Author: lte
-- Date: 2016-10-11 18:35:16
-- 网络请求

--[[
ZP_Net_httpUrl = "http://yuanquan.api.iwoapp.com/";
--]]

-- 类申明
-- local Nets = class("Nets", function ()
--     return display.newNode();
-- end)
local Nets = class("Nets")


-- 类变量申明
--Nets.httpUrl = "";

-- 处理方法申明
function Nets:isNetOk()

	if Commons.osType == CEnum.osType.A or Commons.osType == CEnum.osType.I then 
		--local wifi = network.isLocalWiFiAvailable();
		--Commons:printLog_Info("wifi状态：",wifi)

		--local _3g = network.isInternetConnectionAvailable();
		--Commons:printLog_Info("3g状态：",_3g)

		--local name = network.isHostNameReachable("baidu.com11");
		--Commons:printLog_Info("主机名：", name)

		local connect_status = network.getInternetConnectionStatus();
		--Commons:printLog_Info("状态是：",connect_status)
		--Commons:printLog_Info("==：",cc.kCCNetworkStatusNotReachable)
		--Commons:printLog_Info("==：",cc.kCCNetworkStatusReachableViaWiFi)
		--Commons:printLog_Info("==：",cc.kCCNetworkStatusReachableViaWWAN)
		if connect_status == cc.kCCNetworkStatusNotReachable then
			Commons:printLog_Info("not net")
	        return CEnum.network.NOT
		elseif connect_status == cc.kCCNetworkStatusReachableViaWiFi then
			Commons:printLog_Info("Via WiFi")
	        return CEnum.network.WIFI
		elseif connect_status == cc.kCCNetworkStatusReachableViaWWAN then
			Commons:printLog_Info("Via 3G")
	        return CEnum.network._3G
		else
			Commons:printLog_Info("error")
	        return CEnum.network.ERROE
		end
	else
		return CEnum.network.WIFI
	end
end


-- 构造函数
function Nets:ctor()
end

-- 必须有这个返回
return Nets