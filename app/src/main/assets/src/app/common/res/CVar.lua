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
	token = "", -- 当前用户的编号
	roomNo = "", -- 当前用户的房间编号
	roomStatus = "", -- 当前用户的房间状态

    mSocket = nil, -- socket对象
	-- gameing_fanRule = "", -- 当前游戏的规则
	-- gameing_multRule = "",
	-- gameing_jiadi = "",

	sysMsg = "", -- 首页的滚动通知栏内容

	soundVolumMax = 300, -- 扩大1000倍来算，比较容易把声音调整的很小

	--clickImMsg = -1, -- 是否点击过消息

	clockWiseTime = 15, -- 倒计时总共15秒  客户端写死
	
	clockVoiceTime = 100, -- 录音时间，总共多少下  10秒

	voiceWaitDownTable = {}, -- 录音等待下载的集合
	voiceWaitPlayTable = {}, -- 录音等待播放的集合

	handRows = 3, -- 手牌总共允许3行
	handCardNums = 12, -- 手牌总共允许12列
	objAddHeight = 20, -- 手牌高度额外增加的高度

	sCardWH = 95, -- 每张牌的宽高
	boxSize = cc.size(95, 95), -- 手牌的每张牌的宽高
	objSize = cc.size(95, 95+20), -- 手牌的每张牌的宽高  多加7个像素即可  【它比box外围区域大，就可以形成牌叠加的效果】

	sCardWH_RL = 36, -- 每张牌的宽高
	boxSize_RL = cc.size(36, 36), -- 手牌的每张牌的宽高
	objSize_RL = cc.size(36, 36+20), -- 手牌的每张牌的宽高  多加7个像素即可  【它比box外围区域大，就可以形成牌叠加的效果】

	appstoreSwitch = "none", -- open=显示  close=不显示  苹果审核开关，默认=none，什么按钮都没有，需要和服务器发生交互之后才有值
	protocolSwitch = "close", -- open=显示  close=不显示  用户协议开关，默认=close，不显示协议 【苹果审核开关优先控制，只要是游客模式，用户协议必定不出现】

	isIpad = false, -- 是不是ipad平板
	isIphone4 = false, -- 是不是iphone的手机
	NavBarH_Android = 0, -- android手机 如果有虚拟键的 高度多少

	currStopSounds_init = 'on', -- 音效
	currStopMusic_init = 'on', -- 背景音乐

	Lge = "",-- "113.55", -- 经度
	Lat = "",-- "22.55", -- 纬度

	isComeingData = 0, -- 是不是服务器来数据了，来一次就加1，看看手动移牌是不是超时
}


-- 构造函数
function CVar:ctor()
end

-- 必须有这个返回
return CVar