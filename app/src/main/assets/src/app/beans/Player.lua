--
-- Author: lte
-- Date: 2016-10-17 17:24:38
-- 玩家信息

local Player = class("Player")


-- 类变量申明
Player.Bean = {
	user = 'user', -- 用户基本信息，User对象

	owner = 'owner', -- boolean 是否是房主
	me = 'me', -- boolean 是否是本人
	isChupai = 'isChupai', -- boolean 是否是等待我出牌

	netStatus = "netStatus",--	String	网络状态 online：在线 offline：离线
	playStatus = "playStatus",--	String	网络状态 online：在线 offline：离线
	seatNo = "seatNo",   --int	座位编号
	role = "role",	--String	角色   z：庄家      x：闲家
	score = "score",	--int	当前玩家分数
	xi = "xi",	--int	当前玩家的显示胡息数
	indexNo = "indexNo",	--int	哪个位置高亮

	handCards = "handCards",	--Array	手牌，每个元素为Card对象
	chiCombs = "chiCombs",	--Array	吃、跑、碰的牌组合，每个元素为CardComb对象
	chuCards = "chuCards",	--Array	出过的牌，每个元素为Card对象
	chuCardIndexs = "chuCardIndexs", -- 出过的牌   自己打出来的是哪些
	gameStatus = "gameStatus", -- 小相公显示状态

	moCard = "moCard",	--Object	当前摸的牌，Card对象，为空代表不是我摸牌
	chuCard = "chuCard",	--Object	当前出的牌，Card对象，为空代表我没有出牌
	action = "action",	--Object	当前摸或者出牌的Card对象，为空代表我没有摸或者出牌
	card = "card",
	_type = "type",
	actionNo = "actionNo",

	options = "options",	--Array	玩家当前可以进行的操作，每个元素为枚举字符
	chiDemos = "chiDemos",	--Array	可以供吃牌的方案，每个元素CardComb对象  集合

	--currChiCard = "currChiCard", -- 当前出的那一张牌是什么，方便我去更新本地手牌信息
	currRemoveCards = "currRemoveCards", -- 当前出的那一张牌是什么，方便我去更新本地手牌信息
	changeCards = "changeCards", -- 牌的属性要变更，会出现不能挪动的新现象
	currChiCombs = "currChiCombs", -- 当前出的牌集合
	
	currOption = "currOption", -- 当前出牌的方案是
	chu = "chu",--是不是我出牌


	chiComb = "chiComb",-- 吃牌方案第一级  单个对象
	biDemos = "biDemos",-- 吃牌方案  第一级下火牌  集合
	biComb = "biComb",-- 吃牌方案  第一级下火牌  单个对象

	nextBiCombs = "nextBiCombs",-- 吃牌方案  第二级下火牌  集合

	cards = "cards",
	option = "option",

	code = "code", --表情代号
	voiceUrl = "voiceUrl", --录音地址

	dlzScore = 'dlzScore', -- 单个回合的溜子分数  每位玩家要逗的溜子分数

	-----------------------------麻将相关----------------------------------------
	gangDemos = "gangDemos", --Array 可以供杠，碰牌的方案，每个元素CardComb对象  集合
	tingCards = "tingCards", --Array 听牌列表
	currChiComb = "currChiComb", -- 当前吃，碰，杠对象，单个对象
	separate = "separate", --手牌最后一张是否要间距
	holdNum = "holdNum", --其他玩家手牌
}


-- 方法体申明


-- 构造函数
function ctor()
end


-- 必须有这个返回
return Player
