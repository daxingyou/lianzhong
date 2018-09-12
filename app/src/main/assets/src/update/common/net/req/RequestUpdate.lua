--
-- Author: lte
-- Date: 2016-10-17 20:13:07
--

-- 类申明
local RequestUpdate = class("RequestUpdate", RequestUpdBase)

-- httpdns
function RequestUpdate:getHttpDns(param, fun_back_data)
	-- URL
	--local url = Https.url.fromWXService_token -- self:getHttpUrl(Https.url.fromWXService_token)
	local url = 'http://203.107.1.1/'..CVarUpd._static.httpDnsAccountID..'/d' -- self:getHttpUrl(Https.url.fromWXService_token)

	-- 参数
	-- 假数据是：
	local testJsonTable = {
		host = "wmq.api.yuelaigame.com",
		ips = "106.14.76.100",
		ttl = 600,
		origin_ttl = 600,
	}
	-- 不用发起请求，直接返回结果的方式
 	--fun_back_data(testJsonTable)

	-- 发起请求
	self:HttpGet(fun_back_data, url, param, testJsonTable)
end

--升级接口
function RequestUpdate:getUpdateApp(param, fun_back_data)
	-- URL
	local url = self:getHttpUrl(HttpsUpd.url.getUpdateApp)

	-- 参数
	-- 假数据是：
	local testJsonTable = {
		status=0,
		msg=RequestUpdBase:getStrEncode("成功"),
		data={
			newVersion={
				versionCode=200,
				versionName="2.0.0",
				apkSize=20*1000*1000,
				upgradeType=2, --类型 1:强制,2:选择升级
				descript="好东西，赶紧升级吧\n1、优化了内容\n2、加入了新的玩法",
				-- apkDownloadUrl = RequestUpdBase:getStrEncode("http://baidu.com"),
			},
			versionSwitch = "open", -- open  close  苹果审核开关
			protocolSwitch = "open", -- open  close  用户协议开关

			hotVersion={
				versionCode=200,
				versionName="2.0.0",
				apkSize=20*1000*1000,
				upgradeType=2, --类型 1:强制,2:选择升级
				descript="好东西，赶紧升级吧\n1、优化了内容\n2、加入了新的玩法",
				-- resDownLoadUrl = RequestUpdBase:getStrEncode("http://112.74.106.254/game/hotupdate/wmq19211_20170330_win.txt"),
			},
		}
	}
	-- 不用发起请求，直接返回结果的方式
 	--fun_back_data(testJsonTable)

	-- 发起请求
	self:HttpPost(fun_back_data, url, param, testJsonTable)
end

--热更新接口
function RequestUpdate:getHotUpdate(param, fun_back_data)
	-- URL
	local url = self:getHttpUrl(HttpsUpd.url.getHotUpdate)

	-- 参数
	-- 假数据是：
	local testJsonTable = {
		status=0,
		msg=RequestUpdBase:getStrEncode("成功"),
		data={
			hotUpdateDataTxtUrl= RequestUpdBase:getStrEncode("http://112.74.106.254/game/hotupdate/hotUpdateData20170430_02.txt")
		}
	}
	-- 不用发起请求，直接返回结果的方式
 	--fun_back_data(testJsonTable)

	-- 发起请求
	self:HttpPost(fun_back_data, url, param, testJsonTable)
end 


-- 构造函数
function RequestUpdate:ctor()
end


-- 必须有这个返回
return RequestUpdate
