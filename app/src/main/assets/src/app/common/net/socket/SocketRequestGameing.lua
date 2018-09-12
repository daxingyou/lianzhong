--
-- Author: lte
-- Date: 2016-10-29 11:03:32
--

local base = import(".SocketRequestBase")
local SocketRequestGameing = class("SocketRequestGameing", base)

-- 类变量申明

-- 类方法申明

--[[
-- 登录房间
	@param： _SocketMsg socket连接发送消息对象
	@param： token 用户编号
	@param： roomNo 房间号
--]]
function SocketRequestGameing:loginRoom(_lng, _lat)
	local cmd = Sockets.cmd.loginRoom
	local data = {
		lng=_lng,
		lat=_lat
	}

	self:UP(cmd, data)
end

--[[
-- 刷新房间数据
	@param： _SocketMsg socket连接发送消息对象
	@param： token 用户编号
	@param： roomNo 房间号
--]]
function SocketRequestGameing:refreshRoom()
	local cmd = Sockets.cmd.refreshRoom
	local data = {
	}

	self:UP(cmd, data)
end

--[[
-- 解散房间
	@param： _SocketMsg socket连接发送消息对象
	@param： token 用户编号
	@param： roomNo 房间号
--]]
function SocketRequestGameing:dissRoom()
	local cmd = Sockets.cmd.dissRoom
	local data = {
	}

	self:UP(cmd, data)
end

-- 玩家进入房间，自己点击返回大厅，需要告知服务器，是主动行为，不然离线不算
function SocketRequestGameing:gameing_BackHaLL()
	local cmd = Sockets.cmd.gameing_BackHaLL
	local data = {
	}

	self:UP(cmd, data)
end

--[[
-- 解散房间 是否确认
	@param： _SocketMsg socket连接发送消息对象
	@param： token 用户编号
	@param： roomNo 房间号

	@param： agree 是否同意
--]]
function SocketRequestGameing:dissRoom_confim(agree)
	local cmd = Sockets.cmd.dissRoom_confim
	local data = {
		agree=agree
	}

	self:UP(cmd, data)
end

--[[
-- 进入房间之后，就准备了
	@param： _SocketMsg socket连接发送消息对象
	@param： token 用户编号
	@param： roomNo 房间号
--]]
function SocketRequestGameing:gameing_Prepare()
	local cmd = Sockets.cmd.gameing_Prepare
	local data = {
	}

	self:UP(cmd, data)
end

--[[
-- 游戏开始后，出牌
	@param： _SocketMsg socket连接发送消息对象
	@param： token 用户编号
	@param： roomNo 房间号

	@param： card 出的牌，比如 ns3
--]]
function SocketRequestGameing:gameing_Chu(card)
	local cmd = Sockets.cmd.gameing_Chu
	local data = {
		card=card
	}

	self:UP(cmd, data)
end

--[[
-- 游戏开始后，吃牌  里面有下火牌
	@param： _SocketMsg socket连接发送消息对象
	@param： token 用户编号
	@param： roomNo 房间号

	@param： actionNo 动作编号
	@param： chiComb 吃的牌   以竖线分隔3张牌，类似：ns3|ns3|ns3
	@param： biComb1 第一次比牌  以竖线分隔3张牌，类似：ns3|ns3|ns3
	@param： biComb2 第2次比牌  最多2次比牌  以竖线分隔3张牌，类似：ns3|ns3|ns3
--]]
function SocketRequestGameing:gameing_Chi(actionNo, chiComb, biComb1, biComb2)
	local cmd = Sockets.cmd.gameing_Chi
	local data = {
		actionNo=actionNo,
		chiComb=chiComb,
		biComb1=biComb1,
		biComb2=biComb2
	}

	self:UP(cmd, data)
end

--[[
-- 游戏开始后，碰牌
	@param： _SocketMsg socket连接发送消息对象
	@param： token 用户编号
	@param： roomNo 房间号
	
	@param： actionNo 动作编号
--]]
function SocketRequestGameing:gameing_Peng(actionNo)
	local cmd = Sockets.cmd.gameing_Peng
	local data = {
		actionNo=actionNo
	}

	self:UP(cmd, data)
end

--[[
-- 游戏开始后，胡牌
	@param： _SocketMsg socket连接发送消息对象
	@param： token 用户编号
	@param： roomNo 房间号
	
	@param： actionNo 动作编号
--]]
function SocketRequestGameing:gameing_Hu(actionNo)
	local cmd = Sockets.cmd.gameing_Hu
	local data = {
		actionNo=actionNo
	}

	self:UP(cmd, data)
end

--[[
-- 游戏开始后，王闯 胡牌
	@param： _SocketMsg socket连接发送消息对象
	@param： token 用户编号
	@param： roomNo 房间号
	
	@param： actionNo 动作编号
--]]
function SocketRequestGameing:gameing_Wc(actionNo)
	local cmd = Sockets.cmd.gameing_Wc
	local data = {
		actionNo=actionNo
	}

	self:UP(cmd, data)
end

--[[
-- 游戏开始后，王钓 胡牌
	@param： _SocketMsg socket连接发送消息对象
	@param： token 用户编号
	@param： roomNo 房间号
	
	@param： actionNo 动作编号
--]]
function SocketRequestGameing:gameing_Wd(actionNo)
	local cmd = Sockets.cmd.gameing_Wd
	local data = {
		actionNo=actionNo
	}

	self:UP(cmd, data)
end

--[[
-- 游戏开始后，听王闯 胡牌
	@param： _SocketMsg socket连接发送消息对象
	@param： token 用户编号
	@param： roomNo 房间号
	
	@param： actionNo 动作编号
--]]
function SocketRequestGameing:gameing_TWc(actionNo)
	local cmd = Sockets.cmd.gameing_TWc
	local data = {
		actionNo=actionNo
	}

	self:UP(cmd, data)
end

--[[
-- 游戏开始后，听王钓 胡牌
	@param： _SocketMsg socket连接发送消息对象
	@param： token 用户编号
	@param： roomNo 房间号
	
	@param： actionNo 动作编号
--]]
function SocketRequestGameing:gameing_TWd(actionNo)
	local cmd = Sockets.cmd.gameing_TWd
	local data = {
		actionNo=actionNo
	}

	self:UP(cmd, data)
end

--[[
-- 游戏开始后，过牌
	@param： _SocketMsg socket连接发送消息对象
	@param： token 用户编号
	@param： roomNo 房间号
	
	@param： actionNo 动作编号
--]]
function SocketRequestGameing:gameing_Guo(actionNo)
	local cmd = Sockets.cmd.gameing_Guo
	local data = {
		actionNo=actionNo
	}

	self:UP(cmd, data)
end

--[[
-- 游戏开始后，wei
	@param： _SocketMsg socket连接发送消息对象
	@param： token 用户编号
	@param： roomNo 房间号
	
	@param： actionNo 动作编号
--]]
function SocketRequestGameing:gameing_Wei(actionNo)
	local cmd = Sockets.cmd.gameing_Wei
	local data = {
		actionNo=actionNo
	}

	self:UP(cmd, data)
end

--[[
-- 游戏开始后，chouwei
	@param： _SocketMsg socket连接发送消息对象
	@param： token 用户编号
	@param： roomNo 房间号
	
	@param： actionNo 动作编号
--]]
function SocketRequestGameing:gameing_ChouWei(actionNo)
	local cmd = Sockets.cmd.gameing_ChouWei
	local data = {
		actionNo=actionNo
	}

	self:UP(cmd, data)
end

--[[
-- 游戏开始后，ti
	@param： _SocketMsg socket连接发送消息对象
	@param： token 用户编号
	@param： roomNo 房间号
	
	@param： actionNo 动作编号
--]]
function SocketRequestGameing:gameing_Ti(actionNo)
	local cmd = Sockets.cmd.gameing_Ti
	local data = {
		actionNo=actionNo
	}

	self:UP(cmd, data)
end

--[[
-- 游戏开始后，ti8
	@param： _SocketMsg socket连接发送消息对象
	@param： token 用户编号
	@param： roomNo 房间号
	
	@param： actionNo 动作编号
--]]
function SocketRequestGameing:gameing_Ti8(actionNo)
	local cmd = Sockets.cmd.gameing_Ti8
	local data = {
		actionNo=actionNo
	}

	self:UP(cmd, data)
end

--[[
-- 游戏开始后，pao
	@param： _SocketMsg socket连接发送消息对象
	@param： token 用户编号
	@param： roomNo 房间号
	
	@param： actionNo 动作编号
--]]
function SocketRequestGameing:gameing_Pao(actionNo)
	local cmd = Sockets.cmd.gameing_Pao
	local data = {
		actionNo=actionNo
	}

	self:UP(cmd, data)
end

--[[
-- 游戏开始后，pao
	@param： _SocketMsg socket连接发送消息对象
	@param： token 用户编号
	@param： roomNo 房间号
	
	@param： actionNo 动作编号
--]]
function SocketRequestGameing:gameing_Pao8(actionNo)
	local cmd = Sockets.cmd.gameing_Pao8
	local data = {
		actionNo=actionNo
	}

	self:UP(cmd, data)
end


-- 游戏中，发送表情
function SocketRequestGameing:gameing_SendEmoji(emotionCode)
	local cmd = Sockets.cmd.gameing_SendEmoji
	local data = {
		emotionCode=emotionCode
	}

	self:UP(cmd, data)
end

-- 游戏中，发送录音
function SocketRequestGameing:gameing_SendVoice(voiceUrl)
	local cmd = Sockets.cmd.gameing_SendVoice
	local data = {
		voiceUrl=voiceUrl
	}

	self:UP(cmd, data)
end

-- 游戏中，发送短语
function SocketRequestGameing:gameing_SendWords(code)
	local cmd = Sockets.cmd.gameing_SendWords
	local data = {
		wordsCode=code
	}

	self:UP(cmd, data)
end

-- 游戏中，心跳上行，客户端答复服务器
function SocketRequestGameing:gameing_Xintiao_up(systime)
	local cmd = Sockets.cmd.gameing_Xintiao_up
	local data = {
		systime = systime
	}

	self:UP(cmd, data)
end

-- 游戏中，心跳上行，客户端查找服务器
function SocketRequestGameing:gameing_Xintiao_send()
	local cmd = Sockets.cmd.gameing_Xintiao_send
	local data = {
		systime = os.date(CEnum.timeFormat.ymdhms) .. ""
	}

	self:UP(cmd, data)
end


-- 构造函数
function SocketRequestGameing:ctor()
end


function SocketRequestGameing:onEnter()
end


function SocketRequestGameing:onExit()
end

-- 必须有这个返回
return SocketRequestGameing