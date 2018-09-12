-- Author: wh
-- Date: 2017-05-08 19:40:54
--出牌管理器
local OutcardManager = class("OutcardManager")

function OutcardManager:ctor(cardDis)
	self.cardDis_ = cardDis
	-- self.cardList_[1]:setCard({0x03,0x03,0x03,0x03,0x03,0x03,0x03,0x03,0x03,0x03})
	-- self.cardList_[2]:setCard({0x04,0x04,0x04,0x04,0x04,0x04,0x04,0x04,0x04,0x04})
	-- self.cardList_[3]:setCard({0x05,0x05,0x05,0x05,0x05,0x05,0x05,0x05,0x05,0x05})
end

function OutcardManager:createNodes()
	if self.nodes_ and self.nodes_:getParent() then
		self.nodes_:removeFromParentAndCleanup(true)
		self.nodes_ = nil
	end
	self.nodes_ = display.newNode()
		:addTo(self.ctx.scene)
	self.cardList_ = {}
	local cardView = nil
	for i=1,3,1 do
		if i==1 then
			cardView = CardListView.new(2,self.cardDis_,2)
			cardView:align(display.CENTER,display.cx,display.cy-20)
		elseif i==2 then
			cardView = CardListView.new(2,self.cardDis_,3, 11)
			cardView:align(display.RIGHT_TOP,display.width-130,display.height-160)
		else
			cardView = CardListView.new(2,self.cardDis_,1, 11)
			cardView:align(display.LEFT_TOP,130,display.height-160)
		end
		cardView:addTo(self.nodes_)
		self.cardList_[i] = cardView
	end
end

function OutcardManager:showOutCard(seatId,cards)
	-- local model = self.ctx.model
	-- local serverPlayerList = model:getPlayerList()
	-- local dealerSeat = 0
	-- local seatPlayerData = nil
	-- for i=1,#serverPlayerList do	
	-- 	local tempSeatId = model:getOtherClientSeatId(serverPlayerList[i].seatNo)
	-- 	if serverPlayerList[i].action[1] == "chu"  then
	-- 		dealerSeat = tempSeatId
	-- 		seatPlayerData = serverPlayerList[i]
	-- 	end		 
	-- end
	
	local cardView = self.cardList_[seatId]
	if cardView then
		--local list = model:getListForClient(seatPlayerData.chuCards)
		cardView:setCard(cards)
		cardView:show()
		cardView:scale(1.2)
	end
end

function OutcardManager:showGameOverLeftCard()
	-- local cardView = nil
	-- local player = nil
	-- for i=1,3,1 do
	-- 	cardView = self.cardList_[i]
	-- 	player = self.model:getPlayByClientSeatId(i)
	-- 	if player and player.leftCards and #player.leftCards>0 then
	-- 		cardView:setCard(player.leftCards)
	-- 		cardView:show()
	-- 		cardView:setLandlordFlag(player.uid==self.model.landLorduid)
	-- 	else
	-- 		-- cardView:hide()
	-- 	end
	-- end
	-- local model = self.ctx.model
	-- local gameOverData = model:getTableOverData()
	-- for i=1,#gameOverData do
	-- 	local itemData  =  gameOverData[i]
	-- 	local seatId = model:getOtherClientSeatId(itemData.seatNo)
	-- 	local leftCards = model:getClientCardsByServer(itemData.holeCards)
	-- 	local cardView = self.cardList_[seatId]
	-- 	if cardView then
	-- 		cardView:setCard(leftCards)
	-- 		cardView:show()
	-- 		cardView:scale(1.2)
	-- 	end
	-- end
end

function OutcardManager:hideOutCard(seatId)
	local cardView = self.cardList_[seatId]
	if cardView then
		cardView:hide()
	end
end
function OutcardManager:hideAll()
	for k,v in ipairs(self.cardList_) do
		v:hide()
	end
end

function OutcardManager:dispose()

end

return OutcardManager