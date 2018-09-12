--
-- Author: lte
-- Date: 2016-11-07 11:21:03
-- 回合 结束 结果 信息

local RoundRecord = class("RoundRecord")


-- 类变量申明
RoundRecord.Bean = {
	user="user", -- 用户对象
	
	role="role", -- 是不是庄家
	me="me", -- 是不是本人
	owner="owner", -- 是不是房主
	hu = "hu", -- 是不是胡牌的人
	score = "score", -- 分数

	seatNo = 'seatNo', -- 位置编号
	holeCards = 'holeCards', -- 除了自己，，每个人的手牌

	xi = "xi", -- 息数
	sumXi = "sumXi", -- 总息
	deng = "deng", -- 等数

	fan = "fan", -- 番数
	fanRule = "fanRule", -- 类别
	fanCard = "fanCard", -- 胡之后翻出的那张牌  --胡牌的瞬间动作，显示的是实际翻出来的牌
	fanNum = "fanNum", -- 胡之后翻出的那张牌  计算的等数
	xingCard = "xingCard", -- 翻醒跟醒的那张牌，最后回合结果里面显示的，翻醒是+1的，跟醒就是本身那张牌

	huCard = "huCard", -- 胡的牌是什么
	wbMt = "wbMt", -- 王八名堂  单个

	mts = "mts", -- 名堂列表
	diCards = "diCards", -- 底牌列表
	cardCombs = "cardCombs", -- 胡牌组合

	flzScore = 'flzScore', -- 回合结束 每位玩家分的溜子分数，-1=分不到
	dlzScore = 'dlzScore', -- 单个回合的溜子分数  每位玩家要逗的溜子分数

	--mt = "mt", -- 名堂


	--------------麻将多加出来的-----------------------
	huType = 'huType', -- 胡的类型，区分是自模胡，还是炮胡，等等
}


-- 方法体申明


-- 构造函数
function RoundRecord:ctor()
end


-- 必须有这个返回
return RoundRecord
