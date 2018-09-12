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
    outRelease = CEnumUpd.Environment.outRelease, --todo 正式打包：=true 不出现 【=false 会控制一些临时按钮出现】

    -- 是否指定socket地址
    needPoint_Socket_ip_port = CEnumUpd.Environment.needPoint_Socket_ip_port, --todo 正式打包：=true 表示走服务器给值 【=false 就是写死值】

    -- 是否需要分多个文件记录用户信息
    toReleasePhone = CEnumUpd.Environment.toReleasePhone, --todo 正式打包：=true 正式发布到手机  【=false 记录文件是多个，根据token来区分记录】

    -- windows 或者 mac 系统测试，强行走那个模式
    window_mac_btn = CEnumUpd.Environment.window_mac_btn, -- =true 走游客 【=false  强行控制为token输入】

    -- android 或者 ios 系统测试，强行走那个模式
    android_ios_btn = CEnumUpd.Environment.android_ios_btn, -- =true 不启用不控制， false=强行控制为token输入
	
	-- http 请求响应日志
    needPrint_Log_Req = CEnumUpd.Environment.needPrint_Log_Req, --todo 正式打包：需要=true 不打印，=false 日志打印 【会控制日志打印】
    -- socket 请求响应日志
    needPrint_Log_SocketReq = CEnumUpd.Environment.needPrint_Log_SocketReq,
    -- 普通日志
    needPrint_Log_Info = CEnumUpd.Environment.needPrint_Log_Info,
     -- 屏幕上打印日志
    screenPrintLog = CEnumUpd.Environment.screenPrintLog,

    -- 回放走下载文件方式
    -- playBackGame = CEnumUpd.Environment.playBackGame, --todo 正式打包：需要=true 下载文件方式，=false 假数据方式 【】

    -- 是否需要走httpdns
    gotoHttpDNS = CEnumUpd.Environment.gotoHttpDNS, --todo 正式打包：需要=true 走httpdns，=false 不走 【】

    Current = CEnumUpd.Environment.Current, --todo 正式打包：需要=http 连接到正式后台服务器【=test 会走测试数据】

    gameCode = "wmq", -- 当前游戏类型是什么
}

-- 游戏版本信息  httpdns 106401
CEnum.AppVersion = {
	versionCode = CEnumUpd.AppVersion.versionCode,--"192",
	versionName = CEnumUpd.AppVersion.versionName,--"1.9.2",
	channelid = CEnumUpd.AppVersion.channelid,--"888888", -- 渠道号

	-- -- 扯胡子独有：
	-- gameAlias = "yzchz",  -- 游戏包名 别名，内部定义的别名 目前有 wmq yzchz
	-- 偎麻雀独有：
	gameAlias = CEnumUpd.AppVersion.gameAlias,--"wmq",  -- 游戏包名 别名，内部定义的别名 目前有 wmq yzchz
}



-- 环境类型
CEnum.EnvirType = {
	Http = "http", -- 正式连接服务器的
	Test = "test" -- 走测试假数据的方式
}
-- 游戏类型
CEnum.gameType = {
	mainHall = '', -- 大厅，不参与任何子游戏别名
	
	wmq = "wmq", -- 偎麻雀
	chz = "chz", -- 扯胡子
	pdk = "pdk", -- 跑得快
	hzmj = "hzmj", -- 麻将
}

-- 觅恋的微信secret：f0878a7abbc892f395e096e48d6570c0
-- 环境
CEnum.WX = {
	-- 快来扯胡子
	-- appid = "wx748514dca0934c34", -- 微信的appid
	-- secret = "15f854e55643b4534646bbcc6452c0ea", -- 微信的secret

	-- -- 快来偎麻雀
	-- appid = "wx3c911eb90f6faab1", -- 微信的appid
	-- secret = "a98a0855c7a8f9195d726022e286cdad", -- 微信的secret

	-- 偎麻雀
	appid = "wxa2cded7a99d394e3", -- 微信的appid
	secret = "28a4cfd58fb2ebbdde0b42141381ba75", -- 微信的secret

	grant_type = "authorization_code"
}



CEnum.musicStatus = {
	def_fill = "none", -- 默认牌的填充值
	on = "on",
	off = "off",
}

-- http或者socket连接 返回代号
CEnum.status = {
	def_fill = "-1", -- 默认牌的填充值
	success = 0,
	fail = -1,

	success_progress = -2, -- 过程

	NavBarH_def = 0, -- 默认没有虚拟按键
}

CEnum.voiceSetting = {	
	currSoundsVolume = "currSoundsVolume", -- 音效
	currMusicVolume = "currMusicVolume", -- 背景音乐

	currStopSounds = "currStopSounds", -- 音效
	currStopMusic = "currStopMusic", -- 背景音乐

	currStopVoice = "currStopVoice", -- 语音自动播放

	language = "language", -- 语言类型
}

-- 语言类型
CEnum.language = {
	ww = "ww", -- 常德话
	ax = "ax", -- 安乡话
}

CEnum.ZOrder = {	
	common_dialog = 999, -- 普通一级弹窗
	-- common_dialog_second = 999, -- 普通一级弹窗  紧随还可以来一下弹窗
	-- alert_dialog = 999, -- 提示，提醒的超级弹窗

	gameingView_RL = 9, -- 游戏页面中，下家和最后一家的布局
	gameingView_myself = 10, -- 游戏页面中，我的布局
	
	gameingView_myself_emoji = 49, -- 游戏页面中，我的布局  表情节点
	gameingView_myself_voice = 50, -- 游戏页面中，我的布局  录音

	gameingMirror_btn = 50, -- 游戏回放的控制按钮
}

CEnum.dlzType = {
	isStart = 1, -- 开局用1
	isRound = 2, -- 荒局，回合结束之后存在分溜子
	isRoom = 3, -- 荒局，房间结束之后存在分溜子
}

-- 牌类型
--[[ 
	一张牌一般由3部分组成 a n s1
	a,b,c 表示能不能动
	n,y,f,g 表示：常规，吃的阴影牌，提的盖住牌但是自己可见，提的盖住牌对方不可见
	s10，小写十
	b10，大写十
--]]
CEnum.cardType = {
	a = "a", -- 能拖能出
	b = "b", -- 能拖不能出
	c = "c", -- 不能拖不能出

	n = 'n', -- 正常牌 亮牌
	y = 'y', -- 阴影牌 吃的牌
	f = 'f', -- 背景牌 盖住的牌
}

-- 座位编号
CEnum.sex = {
	male = "male", -- 男
	female = "female", -- 女
}

-- 座位编号
CEnum.seatNo = {
	me = 0, -- 本人
	R = 1, -- 1=下一玩家（右手边） 
	L = -1, -- -1=最后一个玩家（左手边）

	init = -99, -- 假设初始值，默认值

	downOver = -199, -- 假设初始值，默认值
	playOver = -299, -- 假设初始值，默认值
}

-- 我的网络状态
CEnum.network = {
    WIFI = "wifi", -- wifi
    _3G = "3G", -- 3G
    NOT = "not", -- 无网络 
    ERROE = "error", -- 无网络
}

CEnum.shareTitle = {
	_1 = "一缺二", -- 共3个位置，剩下 2个空位
    _2 = "二缺一", -- 共3个位置，剩下 1个空位
}

CEnum.round = {
	round = "create_round",
    _8 = "8", -- 8局
    _16 = "16", -- 16局
}

CEnum.jiadi = {
	jiadi = "create_jiadi",
    yes = "y", -- 加底
    no = "n", -- 不加底

    yes_info = "加底",
}

CEnum.fanRule = {
	fanRule = "create_fanRule",
    fan = "fan", -- 翻醒
    gen = "gen", -- 跟醒

    fan_info = "翻醒", -- 翻醒
    gen_info = "跟醒", -- 跟醒
}

CEnum.multRule = {
	multRule = "create_multRule",
    single = "single", -- single：单倍，double：双倍
    double = "double", -- single：单倍，double：双倍

    single_info = "单醒", -- single：单倍，double：双倍
    double_info = "双醒", -- single：单倍，double：双倍
}

CEnum.mtRule = {
	mtRule = "create_mtRule",
	laoMt = 'laoMt', -- 老名堂
	xz = 'xiaoZhuo',-- 小桌
	dz = 'daZhuo',-- 大桌
	quanMt = 'quanMt', -- 全名堂

	laoMt_info = '老名堂玩法', -- 老名堂
	xz_info = '小卓版玩法',-- 小桌
	dz_info = '大卓版玩法',-- 大桌
	quanMt_info = '全名堂玩法', -- 全名堂
}

-- 逗溜子的选择项
CEnum.isDlz = {
	noLz = -1,
	zeroLz = 0,
	isDlz = "create_isDlz",
	yes = "y", -- 开
    no = "n", -- 关

    yes_info = "逗溜子", -- 开
}
CEnum.dlzLevel = {
	dlzLevel = "create_dlzLevel",
	_1 = 1, -- 1：20/10/10，2：30/20/20，3：40/30/30，<=0 不显示
    _2 = 2,
    _3 = 3,

    _1_info = "庄闲20/10/10", -- 1：20/10/10，2：30/20/20，3：40/30/30，<=0 不显示
    _2_info = "庄闲30/20/20",
    _3_info = "庄闲40/30/30",
}
CEnum.flzUnit = {
	flzUnit = "create_flzUnit",
	_80 = 80, -- 80，100，200三个值，<=0不显示
    _100 = 100,
    _200 = 200,

    _80_info = "1登=80", -- 80，100，200三个值，<=0不显示
    _100_info = "1登=100",
    _200_info = "1登=200",
}

CEnum.userCard = {
	hand = "hand", -- 手上的牌
	mid_mo = "mid_mo", -- 中间摸到的牌
	mid_chu = "mid_chu", -- 中间打出的牌
	--mid = "mid", -- 中间的牌
	out = "out", -- 打出去的牌，没有人接住的牌
	peng = "peng", -- 自己碰，吃，偎到的牌
}

CEnum.netStatus = {
	online = "online", -- 在线
	offline = "offline", -- 离线
	
	--onlineName = "在线", -- 在线
	--offlineName = "离线", -- 离线
}

-- 用户角色
CEnum.role = {
	z = "z",-- 庄家
	x = "x", -- 闲家
}

-- 游戏中，解散房间的状态
CEnum.dissRoomStatus = {
	wait = "wait", -- 等待
	agreed = "agreed", -- 同意了
}

-- 游戏中，房间状态
CEnum.roomStatus = {
	created = "created", -- 已创建
	started = "started", -- 已开始
	ended = "ended", -- 已结束
	dissolved = "dissolved", -- 已解散
}

-- 游戏中，玩家是否需要准备
CEnum.playStatus = {
	wait = "wait", -- 等待准备
	ready = "ready", -- 已准备
	playing = "playing", -- 正在游戏
	ended = "ended", -- 回合结束
}

-- 游戏中  各种操作
CEnum.playOptions = {
	chi = "chi", -- 吃
	xiahuo = "xiahuo", -- 下火
	peng = "peng", -- 碰
	gang = "gang", -- 杠

	wei = "wei", -- 偎
	chouwei = "chouwei", -- 臭偎
	ti = "ti", -- 提
	ti8 = "ti8", -- 提8 2组4张
	pao = "pao", -- 跑
	pao8 = "pao8", -- 跑8 2组4张
	
	hu = "hu", -- 胡
	guo = "guo", -- 过

	jiang = "jiang", -- 将  回合结束的时候需要的显示

	wd = "wd", -- 王钓
	wc = "wc", -- 王闯

	twd = "twd", -- 听王钓
	twc = "twc", -- 听王闯
}

-- 游戏中  各种操作
CEnum.options = {
	mo = "mo", -- 摸
	chu = "chu", -- 出
	other = "other", -- 此时：既不是摸牌，也不是出牌，，可能是第一下 直接就是提牌或者偎牌，那这个时候，需要走过牌这个上行动作，直接根据谁出牌，就谁可以拖拽牌打出去
	other3 = "other3", --抢杠胡
}

-- 游戏中  各种操作
CEnum.optionsCard = {
	w0 = "w0", -- 王
}

-- 游戏中  各种操作
CEnum.mt = {
	hong = "hong", -- 红胡
	hongName = "红胡x2", -- 红胡

	dian = "dian", -- 点胡
	dianName = "点胡 x4", -- 点胡

	hei = "hei", -- 黑胡
	heiName = "黑胡", -- 黑胡

	wd = "wd", -- 王钓
	wdName = "王钓", -- 王钓

	wdw = "wdw", -- 王钓王
	wdwName = "王钓王", -- 王钓王

	wc = "wc", -- 王闯
	wcName = "王闯", -- 王闯

	mo = "mo", -- 自摸
	moName = "自摸", -- 自摸

	ping = "ping", -- 平胡
	pingName = "平胡",-- 平胡
}

-- 游戏中  各种操作
CEnum.pageView = {
	gameingOverPage = 100, -- 定义游戏页面
	--resultOverPage = 101, -- 定义战绩页面
	login_agreement_Page = 102, -- 来自用户使用协议界面

	gameingPhzPage = 200, -- 跑胡子的游戏界面
	gameingPdkPage = 201, -- 跑得快的游戏界面

	mirrorPdkPage = 202, -- 跑得快的回放页面
	gameingMJPage = 300, -- 麻将的游戏界面
}

CEnum.osType = {
	A = "android", -- 安卓平台
	I = "ios", -- ios平台
	W = "windows", -- windows平台
	M = "mac", -- mac本本平台
}

CEnum.appstoreSwitch = { 
	-- 默认=open，可以微信登录
	open = "open", -- 打开微信登录
	close = "close", -- 关闭微信登录
}

CEnum.shareType = { 
	wx = "wx", -- 微信好友
	wxCircle = "wxCircle", -- 微信朋友圈
}

CEnum.timeFormat = {
	ymdhms = "%Y%m%d%H%M%S",
}

CEnum.gameStatus = {
	xxg="xxg", --小相公
	normal="normal", --正常

	xxgName="小相公", --小相公
}

-- 用户权限
CEnum.userRightsType = {
	transCard="transCard", -- 转卡权限
	selectOtherPlayback="selectOtherPlayback", -- 查看回放权限
}



---------------------------------与平台相关的东西--------------------
-- 微信 登录
CEnum.WX_login = {
    _Class = "org/cocos2dx/lua/AppActivity",
	_Name = "goto_Login_weixin",
}
CEnum.WX_login_ios = {
    _Class = "MyWxSDK",
	_Name = "goto_Login_weixin",
}

-- 微信 分享战绩  图片方式
CEnum.WX_Share = {
    _Class = "org/cocos2dx/lua/AppActivity",
	_Name = "gotoShareWX_Img",
}
CEnum.WX_Share_ios = {
    _Class = "MyWxSDK",
	_Name = "gotoShareWX_Img",
}

-- -- 微信 邀请好友打牌  文字方式
-- CEnum.WXTxt_Share = {
--     _Class = "org/cocos2dx/lua/AppActivity",
-- 	_Name = "gotoShareWX_Txt",
-- }
-- CEnum.WXTxt_Share_ios = {
--     _Class = "MyWxSDK",
-- 	_Name = "gotoShareWX_Txt",
-- }

-- 微信 邀请好友  图文
CEnum.WX_Invite = {
    _Class = "org/cocos2dx/lua/AppActivity",
	_Name = "gotoShareWX",
}
CEnum.WX_Invite_ios = {
    _Class = "MyWxSDK",
	_Name = "gotoShareWX",
}

-- 微信 分享活动  图文 外加 好友或者朋友圈选择
CEnum.WX_Share_Active = {
    _Class = "org/cocos2dx/lua/AppActivity",
	_Name = "gotoShareActive",
}
CEnum.WX_Share_Active_ios = {
    _Class = "MyWxSDK",
	_Name = "gotoShareActive",
}

-- android平台 复制
CEnum.CopyTxt = {
    _Class = "org/cocos2dx/lua/AppActivity",
	_Name = "gotoCopyContent",
}
CEnum.CopyTxt_ios = {
    _Class = "MyWxSDK",
	_Name = "gotoCopyContent",
}

-- android平台 可以粘贴的内容
CEnum.getCopyTxt = {
    _Class = "org/cocos2dx/lua/AppActivity",
	_Name = "getCopyContent",
}
CEnum.getCopyTxt_ios = {
    _Class = "MyWxSDK",
	_Name = "getCopyContent",
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

-- android平台 录音
CEnum.Dictate = {
    _Class = "org/cocos2dx/lua/AppActivity",
	_Name = "gotoDictate",
}
CEnum.Dictate_ios = {
    _Class = "MyWxSDK",
	_Name = "gotoDictate",
}

-- android平台 录音  停止
CEnum.DictateStop = {
    _Class = "org/cocos2dx/lua/AppActivity",
	_Name = "gotoDictateStop",
}
CEnum.DictateStop_ios = {
    _Class = "MyWxSDK",
	_Name = "gotoDictateStop",
}

-- android平台 录音  播放
CEnum.DictatePlay = {
    _Class = "org/cocos2dx/lua/AppActivity",
	_Name = "gotoDictatePlay",
}
CEnum.DictatePlay_ios = {
    _Class = "MyWxSDK",
	_Name = "gotoDictatePlay",
}

-- android平台 录音  播放
CEnum.DictatePlay_Me = {
    _Class = "org/cocos2dx/lua/AppActivity",
	_Name = "gotoDictatePlay_Me",
}
CEnum.DictatePlay_Me_ios = {
    _Class = "MyWxSDK",
	_Name = "gotoDictatePlay_Me",
}

-- 播放音效，ios独占，lua在android播放音效也出卡死的问题，所以走android的mediaPlayer播放
CEnum.SoundPlay = {
    _Class = "org/cocos2dx/lua/AppActivity",
	_Name = "gotoSoundPlay",
}
CEnum.SoundPlay_ios = {
    _Class = "MyWxSDK",
	_Name = "gotoSoundPlay",
}

-- 播放音效，ios独占，lua在android播放音效也出卡死的问题，所以走android的mediaPlayer播放
CEnum.WordsPlay = {
    _Class = "org/cocos2dx/lua/AppActivity",
	_Name = "gotoWordsPlay",
}
CEnum.WordsPlay_ios = {
    _Class = "MyWxSDK",
	_Name = "gotoWordsPlay",
}

-- 音效音量设置，ios独占，因为播放声音都是走各自系统的，所以控制音量也需要走各自系统的
CEnum.SoundVolume = {
    _Class = "org/cocos2dx/lua/AppActivity",
	_Name = "gotoSoundVolume",
}
CEnum.SoundVolume_ios = {
    _Class = "MyWxSDK",
	_Name = "gotoSoundVolume",
}

-- 退出系统 暂时不使用，会造成崩溃
-- CEnum.ExitOs_ios = {
--     _Class = "MyWxSDK",
-- 	_Name = "gotoExit",
-- }

-- android 获取虚拟按键的高度
CEnum.getNarBarHeight = {
    _Class = "org/cocos2dx/lua/AppActivity",
	_Name = "getNarBarHeight",
}

-- 定位 android
CEnum.LgeLat = {
    _Class = "org/cocos2dx/lua/AppActivity",
	_Name = "getLgeLat",
}
-- 定位 ios
CEnum.LgeLat_ios = {
    _Class = "MyWxSDK",
	_Name = "getLgeLat",
}
---------------------------------与平台相关的东西--------------------



-- 构造函数
function CEnum:ctor()
end

-- 必须有这个返回
return CEnum