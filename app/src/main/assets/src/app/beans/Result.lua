--
-- Author: lte
-- Date: 2016-10-17 17:24:38
-- 回合信息

local Result = class("Result")


-- 类变量申明
Result.Bean = {
	rooms = "rooms",
	roomNo = "roomNo",
	startTime = 'startTime', -- 开始时间
	players = 'players', -- 玩家列表，Player对象

	rounds = "rounds",
	roundNo = 'roundNo', -- 回合编号
	settlePic = "settlePic", -- 结算截图地址  再拿具体的结果值，不需要截图

	playbacks = 'playbacks',  -- 游戏回放的字段
	playbacksUrl = 'playbacksUrl',  -- 游戏回放的字段  下载数据地址

	playIntroUrl = 'playIntroUrl', -- 玩法介绍下载地址
}

-- 方法体申明


-- 构造函数
function Result:ctor()
end


-- 必须有这个返回
return Result
