--
-- Author: lte
-- Date: 2016-10-17 20:13:07
--

-- 类申明
--local base = import(".RequestBase")
local RequestLogin = class("RequestLogin", RequestBase)

-- 类变量申明

-- 微信服务器获取 wx token
function RequestLogin:fromWXService_token(param, fun_back_data)
	-- URL
	local url = Https.url.fromWXService_token -- self:getHttpUrl(Https.url.fromWXService_token)

	-- 参数
	-- 假数据是：
	local testJsonTable = {
		access_token = "OezXcEiiBSKSxW0eoylIeHmHmlndyhMzxYDgLDJj5YP_e1FMxlMSPPCf6HnNo2JoT4KD8M",
		expires_in = 7200,
		refresh_token = "OezXcEiiBSKSxW0eoylIeHmHmlndyhMzxYDgLDJj5YP_e1FMxlMSPPCf6HnNo2JobjsPW",
		openid = "oLries2cdMfqFFTV4qnDRq",
		scope = "snsapi_userinfo",
		unionid = "oJ3T5sxyIi3nR7djlvENoE"
	}
	-- 不用发起请求，直接返回结果的方式
 	--fun_back_data(testJsonTable)

	-- 发起请求
	self:HttpGet(fun_back_data, url, param, testJsonTable)
end

--微信登录
function RequestLogin:getWXLogin(param, fun_back_data)
	-- URL
	local url = self:getHttpUrl(Https.url.getWXLogin)

	-- 参数
	-- 假数据是：
	local testJsonTable = {
		status=0,
		msg=RequestBase:new():getStrEncode("成功"),
		data={
			user={
				token="2000",
				account=6001001,
				icon=RequestBase:new():getStrEncode("http://wmq.res.apk.yuelaigame.com/icon/guest_boy.jpg"),
				nickname=RequestBase:getStrEncode("     我是谁      "),
				ip="192.168.100.100",
				sex="male",
				wallet={balance=200},
				rights={"transCard"},
				--room={roomNo=1000, status="created"},
				voiceSetting={musicVolume=10,soundVolume=20}
			},
			proxies = {
				{descript="wx客服1微信号：zhangsan", proxyNo="zhangsan"},
				{descript="wx客服2微信号：lisi", proxyNo="lisi"},
				{descript="wx客服3微信号：wangwu", proxyNo="wangwu"},
			},
			sysMsg="wx 永州扯胡子，全新上线，大家赶紧体验和邀请好友一起happy"
		}
	}
	-- 不用发起请求，直接返回结果的方式
 	--fun_back_data(testJsonTable)

	-- 发起请求
	self:HttpPost(fun_back_data, url, param, testJsonTable)
end

--游客登录
function RequestLogin:getGuestLogin(param, fun_back_data)
	-- URL
	local url = self:getHttpUrl(Https.url.getGuestLogin)

	-- 参数
	-- 假数据是：
	local testJsonTable = {
		status=0,
		msg=RequestBase:new():getStrEncode("成功"),
		data={
			user={
				token="2000",
				account=6001001,
				icon=RequestBase:new():getStrEncode("http://wmq.res.apk.yuelaigame.com/icon/guest_boy.jpg"),
				nickname=RequestBase:getStrEncode("     我是谁      "),
				ip="192.168.100.100",
				sex="male",
				wallet={balance=200},
				rights={"transCard"},
				--room={roomNo=1000, status="created"},
				voiceSetting={musicVolume=10,soundVolume=20}
			},
			proxies = {
				{descript="guest客服1微信号客服1微信号：zhangsan_zhangsan", proxyNo="zhangsan_zhangsan"},
				{descript="guest客服2微信号：lisi_lisi", proxyNo="lisi_lisi"},
				{descript="guest客服3微信号：wangwu_wangwu", proxyNo="wangwu_wangwu"},
			},
			sysMsg="游客登录 永州扯胡子，全新上线，大家赶紧体验和邀请好友一起happy"
		}
	}
	-- 不用发起请求，直接返回结果的方式
 	--fun_back_data(testJsonTable)

	-- 发起请求
	self:HttpPost(fun_back_data, url, param, testJsonTable)
end

--token登录
function RequestLogin:getLogin(param, fun_back_data)
	-- URL
	local url = self:getHttpUrl(Https.url.getLogin)

	-- 参数
	-- 假数据是：
	local testJsonTable = {
		status=0,
		msg=RequestBase:new():getStrEncode("成功"),
		data={
			user={
				token="2000",
				account=6001001,
				icon=RequestBase:new():getStrEncode("http://wmq.res.apk.yuelaigame.com/icon/guest_boy.jpg"), -- '/0',
				nickname=RequestBase:getStrEncode("我是谁你是好人吗"),
				ip="192.168.100.100",
				sex="male",
				wallet={balance=200},
				rights={"transCard", "selectOtherPlayback"},
				--room={roomNo=1000, status="created"},
				voiceSetting={musicVolume=10,soundVolume=20}
			},
			proxies = {
				{descript="login客服1微信号客服1微信号：zhangsan_zhangsan", proxyNo="zhangsan_zhangsan"},
				{descript="login客服2微信号：lisi_lisi", proxyNo="lisi_lisi"},
				{descript="login客服3微信号：wangwu_wangwu", proxyNo="wangwu_wangwu"},
			},
			sysMsg="login token 永州扯胡子，全新上线，大家赶紧体验和邀请好友一起happy"
		}
	}
	-- 不用发起请求，直接返回结果的方式
 	--fun_back_data(testJsonTable)

	-- 发起请求
	self:HttpPost(fun_back_data, url, param, testJsonTable)
end 

--升级接口
function RequestLogin:getUpdateApp(param, fun_back_data)
	-- URL
	local url = self:getHttpUrl(Https.url.getUpdateApp)

	-- 参数
	-- 假数据是：
	local testJsonTable = {
		status=0,
		msg=RequestBase:new():getStrEncode("成功"),
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
		}
	}
	-- 不用发起请求，直接返回结果的方式
 	--fun_back_data(testJsonTable)

	-- 发起请求
	self:HttpPost(fun_back_data, url, param, testJsonTable)
end

-- 构造函数
function RequestLogin:ctor()
    --Commons:printLog_Req("RequestLogin:ctor")
end


-- 必须有这个返回
return RequestLogin
