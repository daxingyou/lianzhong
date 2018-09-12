--
-- Author: lte
-- Date: 2016-10-17 17:17:58
-- 用户信息

local UpdateApp = class("UpdateApp")


-- 类变量申明
UpdateApp.Bean = {
	newVersion = 'newVersion',

	versionCode = 'versionCode', -- 版本号 整型
	versionName = 'versionName', -- 版本号 字符型
	apkSize = 'apkSize', -- app大小
	upgradeType = 'upgradeType', -- 升级类型 1=强制升级 2=一般升级
	descript = 'descript', -- 描述
	apkDownloadUrl = 'apkDownloadUrl', -- app下载地址，有值就是需要升级

	versionSwitch = 'versionSwitch', -- open  close  苹果审核开关
	protocolSwitch = 'protocolSwitch', -- open  close  用户协议开关
}



-- 方法体申明


-- 构造函数
function UpdateApp:ctor()
end


-- 必须有这个返回
return UpdateApp