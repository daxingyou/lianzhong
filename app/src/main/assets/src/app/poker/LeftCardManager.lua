-- Author: wh
-- Date: 2017-06-02 19:40:54
--剩余手牌管理器

local LeftCardManager = class("LeftCardManager")

function LeftCardManager:ctor(cardDis)
	self.cardDis_ = cardDis
end

function LeftCardManager:createNodes()
	if self.nodes_ and self.nodes_:getParent() then
		self.nodes_:removeFromParentAndCleanup(true)
		self.nodes_ = nil
	end
	self.nodes_ = display.newNode()
		:addTo(self.ctx.scene)
	--手牌
	self.cardList_ = {}
	local cardView = nil
	for i=1,3,1 do
		if i==1 then
			cardView = CardListView.new(2,self.cardDis_,2)
			cardView:align(display.CENTER,display.cx,display.cy-50)
		elseif i==2 then
			cardView = PDKOtherCardView.new(2,self.cardDis_,3, 6)
			cardView:align(display.RIGHT_TOP,display.width-30,display.height-270)
		else
			cardView = PDKOtherCardView.new(2,self.cardDis_,1, 6)
			cardView:align(display.LEFT_TOP,30,display.height-270)
		end
		cardView:addTo(self.nodes_)
		self.cardList_[i] = cardView
	end
	--底牌(系统随机抽掉的4张牌)
	self.baseCards = PDKOtherCardView.new(2,self.cardDis_,2)
		:addTo(self.nodes_)
	self.baseCards:align(display.CENTER,display.cx,display.height-210)

	--手牌(2个人玩的时候，第三家牌，系统默认去掉了)
	--右边展示
	self.otherHands1 = PDKOtherCardView.new(2,self.cardDis_,3, 6)
		:addTo(self.nodes_)

	--手牌(2个人玩的时候，第三家牌，系统默认去掉了)
	--左边展示
	self.otherHands2 = PDKOtherCardView.new(2,self.cardDis_,1, 6)
		:addTo(self.nodes_)

	self.leftText = display.newTTFLabel({
	        text = "剩余牌:",
	        font = Fonts.Font_hkyt_w9,
	        size = Dimens.TextSize_20,
	        color = display.COLOR_WHITE,
	        align = cc.ui.TEXT_ALIGN_CENTER,
            valign = cc.ui.TEXT_VALIGN_CENTER,
	        --dimensions = cc.size(120,25)
	    })
        :addTo(self.nodes_)
        :hide()
    self.randomText = display.newTTFLabel({
	        text = "随机抽牌:",
	        font = Fonts.Font_hkyt_w9,
	        size = Dimens.TextSize_20,
	        color = display.COLOR_WHITE,
	        align = cc.ui.TEXT_ALIGN_CENTER,
            valign = cc.ui.TEXT_VALIGN_CENTER,
	        --dimensions = cc.size(120,25)
	    })
        :addTo(self.nodes_)
        :align(display.CENTER,display.cx,display.height-140)
        :hide()
	
end

function LeftCardManager:init()
	-- if self.isSeted == true then

	-- 	return
	-- end
	-- self.isSeted = true
	-- local model = self.ctx.model
	-- local serverPlayerList = model:getPlayerList()
	-- for i=1,#serverPlayerList do
	-- 	local tempSeat = 	serverPlayerList[i]
	-- 	local tempSeatId = model:getOtherClientSeatId(serverPlayerList[i].seatNo)
	-- 	if tempSeatId ~= 1 then
	-- 		local cards = model:getClientCardsByServer(tempSeat.handCards)
	-- 		self:showCards(tempSeatId,cards)	
	-- 	end 
	-- end
end

--显示游戏打完之后 其他玩家剩余的牌
function LeftCardManager:showGameOverLeftCard()

	--玩家剩余扑克牌手牌
	local model = self.ctx.model
	local gameOverData = model:getTableOverData()
	if gameOverData == nil then return end
	for i=1,#gameOverData do
		local itemData  =  gameOverData[i]
		local seatId = model:getOtherClientSeatId(itemData.seatNo)
		local leftCards = model:getClientCardsByServer(itemData.holeCards)
		local cardView = self.cardList_[seatId]
		if cardView then
			cardView:setCard(leftCards)
			cardView:show()
		end
	end
	--系统随机抽出的4张牌
	local tempData = gameOverData[1]
	if tempData and tempData.randomCards then
		if #tempData.randomCards == 0 then return end
		local randomCards = model:getClientCardsByServer(tempData.randomCards)
		self.baseCards:setCard(randomCards)
		self.baseCards:show()
		self.baseCards:setBlack()
		self.randomText:show()
	end

	local diCards = tempData.diCards
	-- dump(diCards,"剩余牌:")
	-- dump(tempData.randomCards,"随机牌")
	if diCards == nil or #diCards == 0 then return end
	if #model:getPlayerList() > 2 then return end

	--2个人玩第三家被抽取后的手牌
	local playerList = model:getPlayerList()
	local diCardsSeatId = 0
	for i=1,#playerList do
		local tempSeatId = model:getOtherClientSeatId(playerList[i].seatNo)
		if tempSeatId ==  2 then
			diCardsSeatId = 3
		end
		if tempSeatId ==  3 then
			diCardsSeatId = 2
		end
	end

	if diCardsSeatId == 2 then
		self.otherHands1:align(display.RIGHT_TOP,display.width-30,display.height-100)
		self.otherHands1:setCard(
		model:getClientCardsByServer(diCards)
		)
		self.otherHands1:show()
		self.otherHands1:setBlack()
		self.leftText:show()
		self.leftText:align(display.RIGHT_TOP,display.width-30,display.height-20)
	elseif diCardsSeatId == 3 then
		self.otherHands2:align(display.LEFT_TOP,30,display.height-100)
		self.otherHands2:setCard(
		model:getClientCardsByServer(diCards)
		)
		self.otherHands2:show()
		self.otherHands2:setBlack()
		self.leftText:show()
		self.leftText:align(display.LEFT_TOP,30,display.height-20)
	end
	
	
end

-- function LeftCardManager:outCards(seatId,outCards)
-- 	local cardView = self.cardList_[seatId]
-- 	if cardView then
-- 		cardView:removeOutCard(outCards)
-- 	end
-- end

function LeftCardManager:hideOutCard(seatId)
	local cardView = self.cardList_[seatId]
	if cardView then
		cardView:hide()
	end
end
function LeftCardManager:hideAll()
	for k,v in ipairs(self.cardList_) do
		v:hide()
	end
end

function LeftCardManager:cleanAllCard()

	for k,v in ipairs(self.cardList_) do
		v:clearAllCard()
	end
	self.baseCards:clearAllCard()
	self.otherHands1:clearAllCard()
	self.otherHands2:clearAllCard()
	self.leftText:hide()
	self.randomText:hide()
end

function LeftCardManager:dispose()
	
	self:cleanAllCard()
end

return LeftCardManager