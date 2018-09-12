--
-- Author: lte
-- Date: 2016-11-07 23:48:34
-- 房间 结束 结果 信息

local RoomRecord = class("RoomRecord")


-- 类变量申明
RoomRecord.Bean = {
	user="user", -- 用户对象
	
	owner="owner", -- 是不是房主
	score = "score", -- 分数   有溜子分数之后，这个就是最后得分，即总分
	winner = "winner", 
	bigWinner = "bigWinner",
	huTimes = "huTimes",
	mtTimes = "mtTimes",

	flzScore = 'flzScore', -- 房间结束后 每位玩家分的溜子分数，-1=分不到
	-- gameScore = 'gameScore', -- 房间结束后 每位玩家打牌得到的分数
}


-- 方法体申明


-- 构造函数
function RoomRecord:ctor()
end


-- 必须有这个返回
return RoomRecord
