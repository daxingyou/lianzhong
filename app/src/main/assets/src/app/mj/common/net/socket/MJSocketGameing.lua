--
-- Author: luobinbin
-- Date: 2017-08-03 11:03:32
--

local base = import("app.common.net.socket.SocketRequestBase")
local MJSocketGameing = class("MJSocketGameing", base)


--[[
-- 游戏开始后， 出牌
	@param： _SocketMsg socket连接发送消息对象
	@param： token 用户编号
	@param： roomNo 房间号

	@param： cardId 出的牌，比如 22
--]]
function MJSocketGameing:gameing_Chu(card)
	local cmd = Sockets.cmd.gameing_Chu
	local data = {
		cardId=card
	}

	self:UP(cmd, data)
end

--[[
-- 游戏开始后，碰牌
	@param： _SocketMsg socket连接发送消息对象
	@param： token 用户编号
	@param： roomNo 房间号
	@param： actionNo 动作编号
	@param： cardId 杠牌id
--]]
function MJSocketGameing:gameing_Gang(actionNo, cardId)
	local cmd = Sockets.cmd.gameing_Gang
	local data = {
		actionNo=actionNo,
		cardId=cardId
	}

	self:UP(cmd, data)
end

--[[
-- 游戏开始后，发送超级表情
	@param： _SocketMsg socket连接发送消息对象
	@param： token 用户编号
	@param： roomNo 房间号
	@param： emotionCode 表情编号
	@param： targetSeatNo 目标座位号
--]]
function MJSocketGameing:gameing_SuperEmoji(emotionCode, targetSeatNo)
	local cmd = Sockets.cmd.gameing_SuperEmoji
	local data = {
		emotionCode=emotionCode,
		targetSeatNo=targetSeatNo
	}

	self:UP(cmd, data)
end

-- 构造函数
function MJSocketGameing:ctor()
end


function MJSocketGameing:onEnter()
end


function MJSocketGameing:onExit()
end

-- 必须有这个返回
return MJSocketGameing