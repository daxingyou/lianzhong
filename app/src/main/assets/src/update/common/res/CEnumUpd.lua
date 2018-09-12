--
-- Author: lte
-- Date: 2016-10-10 12:26:49
-- 模拟枚举


-- 类申明
--local CEnum = class("CEnum", function ()
--    return display.newNode();
--end)
local CEnum = class("CEnum")

-- 环境
CEnum.Environment = 
{    
    outRelease = true, --todo 正式打包：=true 不出现 【=false 会控制一些临时按钮出现】

    -- 是否指定socket地址
    needPoint_Socket_ip_port = true, --todo 正式打包：=true 表示走服务器给值 【=false 就是写死值】

    -- 是否需要分多个文件记录用户信息
    toReleasePhone = false, --todo 正式打包：=true 正式发布到手机  【=false 记录文件是多个，根据token来区分记录】

    -- windows 或者 mac 系统测试，强行走那个模式
    window_mac_btn = false, -- =true 走游客 【=false  强行控制为token输入】

    -- android 或者 ios 系统测试，强行走那个模式
    android_ios_btn = true, -- =true 不启用不控制 【=false 强行控制为token输入】
	
	-- http 请求响应日志
    needPrint_Log_Req = false, --todo 正式打包：需要=true 不打印，=false 日志打印 【会控制日志打印】
    -- socket 请求响应日志
    needPrint_Log_SocketReq = false,
    -- 普通日志
    needPrint_Log_Info = true,
    -- 屏幕上打印日志
    screenPrintLog = true,

    -- 回放走下载文件方式
    -- playBackGame = true, --todo 正式打包：需要=true 下载文件方式，=false 假数据方式 【】

    -- 是否需要走httpdns
    gotoHttpDNS = false, --todo 正式打包：需要=true 走httpdns，=false 不走 【】

    Current = "http", --todo 正式打包：需要=http 连接到正式后台服务器【=test 会走测试数据】
}

CEnum.AppVersion = {
	versionCode = 200,
	versionName = "2.0.0",
	channelid = "888888", -- 渠道号

	-- -- 扯胡子独有：
	-- gameAlias = "yzchz",  -- 游戏包名 别名，内部定义的别名 目前有 wmq yzchz
	-- 偎麻雀独有：
	gameAlias = "",  -- 游戏包名 别名，内部定义的别名 目前有 wmq yzchz
}





-- 环境类型
CEnum.EnvirType = {
	Http = "http", -- 正式连接服务器的
	Test = "test" -- 走测试假数据的方式
}

-- android平台 升级
CEnum.UpdateApp = {
    _Class = "org/cocos2dx/lua/AppActivity",
	_Name = "gotoH5",
}
CEnum.UpdateApp_ios = {
    _Class = "MyWxSDK",
	_Name = "gotoH5",
}

-- http或者socket连接 返回代号
CEnum.status = {
	def_fill = "-1", -- 默认牌的填充值
	success = 0,
	fail = -1,

	success_progress = -2, -- 过程

	NavBarH_def = 0, -- 默认没有虚拟按键
}

CEnum.ZOrder = {	
	common_dialog = 999, -- 普通一级弹窗
	common_dialog_second = 999, -- 普通一级弹窗  紧随还可以来一下弹窗

	alert_dialog = 999, -- 提示，提醒的超级弹窗

	gameingView_myself = 10, -- 游戏页面中，我的布局
	gameingView_myself_emoji = 11, -- 游戏页面中，我的布局  表情节点

	gameingMirror_btn = 12, -- 游戏回放的控制按钮
}

CEnum.osType = {
	A = "android", -- 安卓平台
	I = "ios", -- ios平台
	W = "windows", -- windows平台
	M = "mac", -- mac本本平台
}

CEnum.UpdResType = {
	load = "load", -- lua文件需要加载
	unzip = "unzip", -- 图片，字体，声音文件需要下载和解压
}


-- 构造函数
function CEnum:ctor()
end

-- 必须有这个返回
return CEnum