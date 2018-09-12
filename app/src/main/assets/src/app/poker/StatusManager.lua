--[
--  Author wh
--  Date: 2017-05-08 19:40:54
--	玩家操作状态管理器
--]
local Status = import(".view.Status")

local StatusManager = class("StatusManager")

function StatusManager:ctor()
end

function StatusManager:createNodes()
	if self.nodes_ and self.nodes_:getParent() then
		self.nodes_:removeFromParentAndCleanup(true)
		self.nodes_ = nil
	end
	self.nodes_ = display.newNode()
		:addTo(self.ctx.scene)
	self.statusList_ = {}
	local status = nil
	local align = nil
	for i=1,3,1 do
		align = display.CENTER
		if i==2 then
			align = display.RIGHT_TOP
		elseif i==3 then
			align = display.LEFT_TOP
		end
		status = Status.new(align)
		status:addTo(self.nodes_)
		--status:scale(0.5)
		self.statusList_[i] = status
		if i==1 then
			status:align(align,display.cx,270)
		elseif i==2 then
			status:align(align,display.width-100-75,display.height-100-40)
		else
			status:align(align,175,display.height-100-40)
		end
	end
end

-- 准备
function StatusManager:dealReady()
	local model = self.ctx.model
	local serverPlayerList = model:getPlayerList()
	
	for i=1,#serverPlayerList do
		if serverPlayerList[i].playStatus == CEnum.playStatus.ready then
			local tempSeatId = model:getOtherClientSeatId(serverPlayerList[i].seatNo)
			local status = self.statusList_[tempSeatId]
			status.ready_:show()
			--transition.fadeIn(status.ready_, {time = .7})
			status.passout_:hide()
			--status.win_:hide()
			status:show()
		end
	end
end

--过牌
function StatusManager:dealPassOut()
	local model = self.ctx.model
	local serverPlayerList = model:getPlayerList()
	
	for i=1,#serverPlayerList do
		if serverPlayerList[i].action then
			if serverPlayerList[i].action.type == CEnum.playOptions.guo then
				local tempSeatId = model:getOtherClientSeatId(serverPlayerList[i].seatNo)
				local status = self.statusList_[tempSeatId]
				status.passout_:show()
				--transition.fadeIn(status.passout_, {time = 1.5})
				status.ready_:hide()
				status:show()
				--status.win_:hide()
			end
		end
	end
end

--赢
function StatusManager:dealWin()
	-- local model = self.ctx.model
	-- local resultData = model:getTableOverData()

	-- if resultData == nil or resultData == {} then

	-- 	return
	-- end
	
	-- for i=1,#resultData do
	-- 	if resultData[i].roundResult == true then
	-- 		local tempSeatId = model:getOtherClientSeatId(resultData[i].seatNo)
	-- 		local status = self.statusList_[tempSeatId]
	-- 		status.passout_:hide()
	-- 		status.ready_:hide()
	-- 		status:show()
	-- 		status.win_:show()
	-- 	end
	-- end
end

--玩家退出
function StatusManager:userLoginOut()
	--因为只会发生在游戏没有开始的时候，也有可能是在玩家准备状态
	--所以要先杀掉全部显示，再次刷新玩家准备状态。
	self:hideAll()
	self:dealReady()
end

-- 隐藏某个玩家状态
function StatusManager:hideStatus(seatId)
	local status = self.statusList_[seatId]
	if status then
		status:hide()
	end
end

-- 隐藏所有玩家状态
function StatusManager:hideAll()
	for k,v in ipairs(self.statusList_) do
		v:hide()
	end
end

function StatusManager:init()
	-- local model = self.model
	-- if model and model.playerList then
	-- 	for k,player in pairs(model.playerList) do
	-- 		if player and player.isReady==1 then
	-- 			local status = self.statusList_[model:getSeatIdByUid(player.uid)]
	-- 			if status then
	-- 				status:hideAll()
	-- 				status.ready_:show()
	-- 				status:show()
	-- 			end
	-- 		end
	-- 	end
	-- end
end

function StatusManager:dispose()
end

return StatusManager