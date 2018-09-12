--
-- Author: lte
-- Date: 2016-10-29 11:03:32
--

local base = import("app.common.net.socket.SocketRequestBase")
local PDKSocketGameing = class("PDKSocketGameing", base)


--[[
-- 游戏开始后， 出牌
	@param： _SocketMsg socket连接发送消息对象
	@param： token 用户编号
	@param： roomNo 房间号

	@param： card 出的牌，比如 ns3
--]]
function PDKSocketGameing:gameing_Chu(card)
	local cmd = Sockets.cmd.gameing_Chu
	local data = {
		cardIds=card
	}

	self:UP(cmd, data)
end

-- 构造函数
function PDKSocketGameing:ctor()
end


function PDKSocketGameing:onEnter()
end


function PDKSocketGameing:onExit()
end

-- 必须有这个返回
return PDKSocketGameing