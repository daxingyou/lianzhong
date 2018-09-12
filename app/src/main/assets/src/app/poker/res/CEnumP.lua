--
-- Author: lte
-- Date: 2016-10-10 12:26:49
-- 模拟枚举


-- 类申明
--local CEnum = class("CEnum", function ()
--    return display.newNode();
--end)
local CEnumP = class("CEnumP")

-- 客户端座位编号
CEnumP.seatNo = {
	me = 1, -- 本人
	R = 2, -- 1=下一玩家（右手边） 
	L = 3, -- -1=最后一个玩家（左手边）
}

--牌型动画
CEnumP.POKER_TYPE = {
	FEIJI = "feiji",
	LIANDUI = "liandui",
	SHUNZI = "shunzi",
	BOMB = "bomb",
}

--服务器牌型
CEnumP.serverCardType = {
	dan = "dan",
	dui = "dui",
	ddui = "ddui",
	shun = "shun",
	san = "san",
	sanA = "sanA",
	sanAB = "sanAB",
	feiji = "feiJi",
	zha = "zha",
}

--客户端UI操作
CEnumP.CLIENT_UI_ACTION = {
	ready = "ready",
	outCard = "outCard",
	cardTip = "cardTip",
    weChatInvite = "weChatInvite",
	weChatInviteTxt = "weChatInviteTxt",
}

CEnumP.shareTitle = {
    _1 = "一缺二", -- 共3个位置，剩下 2个空位
    _2 = "二缺一", -- 共3个位置，剩下 1个空位

    _3 = "一缺一", -- 共2个位置，剩下 1个空位
}

CEnumP.wf = {
	wf = "create_wf_pdk",
    _1 = "16", -- 1,
    _2 = "15", -- 2,
    _3 = "random",-- 3,

    _1info = "16张玩法", -- 桌面上是图片显示
    _2info = "15张玩法",
    _3info = "随机玩法",
}

CEnumP.round = {
	round = "create_round_pdk",
    _10 = 10,
    _20 = 20,
    _30 = 30,

    _10info = '10局',
    _20info = '20局',
    _30info = '30局',
}

CEnumP.person = {
	person = "create_person_pdk",
    _2 = 2,
    _3 = 3,

    _2info = '2人玩',
    _3info = '3人玩',
}

CEnumP.showCard = {
	showCard = "create_showCard_pdk",
    _1 = "y",--1,
    _2 = "n",--2,

    _1info = "显示牌",--1,
    _2info = "不显示牌",--2,
}

CEnumP.leftHand = {
	leftHand = "create_leftHand_pdk",
    _1 = "limit",--1,
    _2 = "nolimit",--2,

    _1info = "三张全带",--1,
    _2info = "三张任意带",--2,
}

CEnumP.zhaNiao = {
	zhaNiao = "create_zhaNiao_pdk",
    _1 = "n",-- 1,
    _2 = "y",--2,

    _1info = "不扎鸟",-- 1,
    _2info = "红桃10扎鸟",--2,
}

CEnumP.payType = {
	payType = "create_payType_pdk",
    _1 = "owner",-- 1,
    _2 = "aa",-- 2,

    _1info = "房主支付",-- 1,
    _2info = "AA支付",-- 2,
}

-- 构造函数
function CEnumP:ctor()
end

-- 必须有这个返回
return CEnumP