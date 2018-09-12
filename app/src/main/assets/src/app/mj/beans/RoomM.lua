--
-- Author: luobinbin
-- Date: 2017-07-18 17:17:58
-- 房间信息

local RoomM = class("RoomM")


-- 类变量申明
RoomM.Bean = {
	room = 'room', -- 房间自身对象

	roomNo = 'roomNo', -- 房间号
	rounds = 'rounds', -- 支持最大回合数

	potRule = 'potRule', -- 加底规则，y：加底，n：不加底
	fanRule = 'fanRule', -- 翻牌规则，fan：翻醒，gen：跟醒
	multRule = 'multRule', -- 加倍规则，single：单倍，double：双倍

	mtRule = 'mtRule', -- 名堂规则选择，laoMt=老名堂，xiaoZhuo=小桌，daZhuo=大桌

	isDlz = 'isDlz', -- 是否逗溜子
	dlzLevel = 'dlzLevel',
	flzUnit = 'flzUnit',
	surpDlzScore = 'surpDlzScore', -- 整个房间进行中的 累计溜子分数

	startTime = 'startTime', -- 开始时间
	status = 'status', -- 房间状态 created：已创建，started：已开始，ended：已结束，dissolved：已解散
	players = 'players', -- 玩家列表，Player对象

	playRound = "playRound", -- int	当前回合数
	playRoundNo = 'playRoundNo', -- 回合编号
	diCardsNum = "diCardsNum", -- int	当前回合底牌数量
	diCards = "diCards", -- 底牌列表

	huResult = "huResult", -- 谁胡了

	roundRecord = "roundRecords", -- int	回合结束时的结算战绩，每个元素为PlayerRoundRecord
	roomRecord = "roomRecords", -- int	房间结束时的结算战绩，每个元素为PlayerRoomRecord

	-- 解散房间对象包含的字段
	descript = "descript",
	overtime = "overtime",
	choose = "choose",
	playerChooses = "playerChooses",

	roomServerUrl = "roomServerUrl",-- String
	roomServerPort = "roomServerPort", -- int
	roomShareUrl = "roomShareUrl",-- String

	gameAlias = 'gameAlias', -- 游戏别名


	isShow = 'isShow', -- 是否弹窗提醒，y：提醒，n：不提醒
	popDesc = 'popDesc', -- 弹窗描述
	distanceType = "distanceType", -- 有定位之后的 类型描述，，0：绿，1：黄，2：红
	distanceDesc = "distanceDesc", -- 有定位之后的 具体的距离描述

	playerDistance = 'playerDistance', -- 定位的详细信息对象
}




-- 方法体申明


-- 构造函数
function RoomM:ctor()
end


-- 必须有这个返回
return RoomM