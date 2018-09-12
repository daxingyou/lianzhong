--[
-- Author: wh
-- Date: 2017-05-08 19:40:54
--	数据处理中心	
--
--]
require("framework.cc.utils.bit")
local RoomModel = class("RoomModel")

--客户端扑克牌 :

-- 方块 0x01,0x02,0x03,0x04,0x05,0x06,0x07,0x08,0x09,0x0A,0x0B,0x0C,0x0D
-- 方块  A     2    3   4    5    6    7     8   9    10   J     Q    K
--客户端 1     2    3   4    5    6    7     8   9    10   11    12   13
--服务器 1     2    3   4    5    6    7     8   9    10   11    12   13

-- 梅花 0x11,0x12,0x13,0x14,0x15,0x16,0x17,0x18,0x19,0x1A,0x1B,0x1C,0x1D
-- 梅花  A     2    3   4     5   6    7     8   9    10   J     Q    K
--客户端 17    18   19  20    21  22   23    24  25   26   27    28   29
--服务器 14    15   16  17    18  19   20    21  22   23   24    25   26

-- 红桃 0x21,0x22,0x23,0x24,0x25,0x26,0x27,0x28,0x29,0x2A,0x2B,0x2C,0x2D
-- 红桃  A     2    3   4     5   6    7     8   9    10   J     Q    K
--客户端 33    34   35  36    37  38   39    40  41   42   43    44   45 
--服务器 27    28   29  30    31  32   33    34  35   36   37    38   39

-- 黑桃 0x31,0x32,0x33,0x34,0x35,0x36,0x37,0x38,0x39,0x3A,0x3B,0x3C,0x3D
-- 黑桃  A     2    3   4     5   6    7     8   9    10   J    Q    K
--客户端 49    50   51  52    53  54   55    56  57   58   59   60   61       
--服务器 40    41   42  43    44  45   46    47  48   49   50   51   52




local CLIENT_CARDS_TABLE = {
	0x01,0x02,0x03,0x04,0x05,0x06,0x07,0x08,0x09,0x0A,0x0B,0x0C,0x0D,
	0x11,0x12,0x13,0x14,0x15,0x16,0x17,0x18,0x19,0x1A,0x1B,0x1C,0x1D,
	0x21,0x22,0x23,0x24,0x25,0x26,0x27,0x28,0x29,0x2A,0x2B,0x2C,0x2D,
	0x31,0x32,0x33,0x34,0x35,0x36,0x37,0x38,0x39,0x3A,0x3B,0x3C,0x3D,
}

function RoomModel:ctor(ctx )
	self.ctx_ = ctx
	self.roomInfo = {}
end

--获取房间信息
function RoomModel:getRoomInfo()
	return self.roomInfo
end

--获取自己的服务器座位号
function RoomModel:getMySeatId()
	return self.mySeatId
end

--获取自己的座位信息
function RoomModel:getSelfSeatData()
	return self.selfSeatData
end

--获取自己是否是房主
function RoomModel:isSelfOwner()
	return self.selfSeatData.owner
end

--获取玩家列表
function RoomModel:getPlayerList()
	return self.playerList
end

--获取自己手牌
function RoomModel:getMyHandCards()
	return self:getClientCardsByServer(self.myHandCards)
end

--获取是否自己出牌
function RoomModel:isMeOutCard()
	return self.selfSeatData.chu
end

--获取自己所有提示牌
function RoomModel:getTipCard()
	--如果自己出牌，并且是最后一手，则将自己手牌全部设置成提示牌
	-- print("**********************************全部牌提示上来", self.selfSeatData, self.selfSeatData.chu, self.selfSeatData.lastHand)
	if self and self.selfSeatData and self.selfSeatData.chu==true and self.selfSeatData.lastHand==true then
		-- print("**********************************全部牌提示上来  上来了")
		local result = {}
		table.insert(result, self.myHandCards)
		return result
	end

	-- 不是最后一手，按照正常提示逻辑来
	if self.roomInfo.newCircle == true then
		return self.myAffordList or {}
	else
		return self.affordList_ or {}
	end
end

--获取当前动作
function RoomModel:getAction()
	return self.currentAction_ or nil
end

--获取回合结束后结算信息
function RoomModel:getTableOverData()
	return self.tableGameOverData or nil
end

--获取房间结束后结算信息
function RoomModel:getRoomOverData()
	return self.roomGameOverData or nil
end

--牌转码
function RoomModel:getListForClient(list)
	return self:getClientCardsByServer(list)
end

--获取其他玩家的客户端座位号
function RoomModel:getOtherClientSeatId(serverId)

	local tt = (((0-self.mySeatId)+serverId+3)%3+1)
	if tt == 1 then
		return CEnumP.seatNo.me
	elseif tt == 2 then
		return CEnumP.seatNo.R
	else
		return CEnumP.seatNo.L
	end
	-- return (((0-self.mySeatId)+serverId+3)%3+1)
end

--解析整个房间的数据
--很多命令协议数据结构相同
--走同一个解析
function RoomModel:parseAllRoomData(data)
	local gameData = data.data

	self.roomInfo.roomNo = tonumber(gameData.roomNo) -- 房间号
	self.roomInfo.rounds = tonumber(gameData.rounds) -- 总回合数量  总的局数
	self.roomInfo.playRound = tonumber(gameData.playRound) -- 当前第几局

	self.roomInfo.roundStart = gameData.roundStart -- 单局是否开始
	self.roomInfo.status= gameData.status -- 房间状态

	self.roomInfo.newCircle = gameData.newCircle -- 是否是新的一圈出牌

	self.roomInfo.playType = gameData.playType or nil -- 游戏玩法，是15张，还是16张，还是随机
	self.roomInfo.maxPlayer = gameData.num or 3 -- 最大游戏人数，其实还是num的值
	self.roomInfo.num = gameData.num or nil -- 游戏人数
	self.roomInfo.isDisplay = gameData.isDisplay or nil -- 是否显示余牌数量
	self.roomInfo.lastRule = gameData.lastRule or nil -- 最后一手牌，能否任意带
	self.roomInfo.birdRule = gameData.birdRule or nil -- 是否扎鸟
	self.roomInfo.payRule = gameData.payRule or nil -- 支付类型

	self.roomInfo.distanceType = gameData.distanceType -- 定位信息
	self.roomInfo.distanceDesc = gameData.distanceDesc -- 定位信息描述

	if gameData.players then
		self.playerList = gameData.players
	end

	for i=1,#self.playerList do
		if self.playerList[i].me == true then
			self.mySeatId = self.playerList[i].seatNo
			self.selfSeatData = self.playerList[i]
			if self.selfSeatData.handCards and #self.selfSeatData.handCards>0 then
				self.myHandCards = self.selfSeatData.handCards
			end
			self.affordList_ = self.selfSeatData.affordList
			if self.selfSeatData.myAffordList and #self.selfSeatData.myAffordList>0 then
				self.myAffordList = self.selfSeatData.myAffordList
			end

		end
		if self.playerList[i].action then
			self.currentAction_ = self.playerList[i].action
		end
	end

	-- 单局 结算信息
	if gameData.roundRecords then
		self.tableGameOverData = gameData.roundRecords
	end

	-- 房间 结算信息
	if gameData.roomRecords then
		self.roomGameOverData = gameData.roomRecords
	end

end

--解析自己登录房间
function RoomModel:parseLogin(data)
	self:parseAllRoomData(data)
end

--解析玩家登录
function RoomModel:parsePlayerLogin(data)
	self:parseAllRoomData(data)
end

--玩家准备
function RoomModel:parsePlayerReady(data)
	self:parseAllRoomData(data)
end

--游戏开始
function RoomModel:parseGameStart(data)
	self.myHandCards = {}
	self:parseAllRoomData(data)
end

--出牌
function RoomModel:parseOutCards(data)
	self:parseAllRoomData(data)
end

--过牌
function RoomModel:parsePass(data)
	self:parseAllRoomData(data)
end

--玩家登出 下线==离线而已
function RoomModel:parsePlayerLoginExit(data)
	local room = data--[User.Bean.room]
    local loginOutSeatId = room[Player.Bean.seatNo]
    -- print("---------------------------loginOutSeatId==", loginOutSeatId)
	for i=1,#self.playerList do
		local tempPlayer = self.playerList[i]
		if tempPlayer~=nil and tempPlayer.seatNo == loginOutSeatId then
			tempPlayer.netStatus = CEnum.netStatus.offline -- "offline"
		end
	end
end

--玩家离开房间 ==跑路
function RoomModel:parsePlayerLoginOut(data)
	local room = data--[User.Bean.room]
    local loginOutSeatId = room[Player.Bean.seatNo]
    -- print("---------------------------loginOutSeatId==", loginOutSeatId)
	for i=1,#self.playerList do
		local tempPlayer = self.playerList[i]
		if tempPlayer~=nil and tempPlayer.seatNo==loginOutSeatId then
			table.remove(self.playerList,i)
		end
	end
end

--回合结束
function RoomModel:praseTableOver(data)
	self:parseAllRoomData(data)
	local gameData = data.data
	--单局信息	
	self.tableGameOverData = gameData.roundRecords
	--整体结算信息
	self.roomGameOverData = gameData.roomRecords
end

--整个游戏结束
function RoomModel:praseRoomOver(data)
	self:parseAllRoomData(data)
end

--解散房间结果
function RoomModel:praseDissRoom(data)
	--成功与否
	local success = data.success
	--描述
	local descript = RequestBase:getStrDecode(data.descript)
	return success,descript
end

--ip检测结果
function RoomModel:praseIpCheckResult(data)
	--成功与否
	local success = data.success
	--描述
	local descript = data.descript
	return success,descript
end

--获取客户端扑克牌
--list 服务器牌
function RoomModel:getClientCardsByServer(list)
	if list == nil or #list == 0 then  return {} end
	local listTable = {}
	for i=1,#list do
		local card = list[i]
		table.insert(listTable, CLIENT_CARDS_TABLE[card.cardId])
	end
	return listTable
end

--将客户端扑克牌转化为服务器数据牌
--list 客户端牌
function RoomModel:getServerCardsByClient(list)
	local listTable = {}
	for i=1,#list do
		for k,v in pairs(CLIENT_CARDS_TABLE) do
			if v == list[i] then
				table.insert(listTable,k)
			end
		end
	end
	
	return listTable
end

--获取牌值(播放声音要的)
function RoomModel:getCardValue(logicValue)
	return bit.band(logicValue,0x0F)
end

--获取牌花色(暂时没用到，留个~~)
function RoomModel:getCardType(logicValue)
	return bit.brshift(logicValue,4)
end

-- 退出操作
function RoomModel:dispose()
	self.roomInfo = {}
	self.mySeatId = nil
	self.selfSeatData = nil
	self.playerList = nil
	self.myAffordList = nil
	self.affordList_ = nil
	self.currentAction_ = nil
	self.tableGameOverData = nil
	self.roomGameOverData = nil
end

return RoomModel