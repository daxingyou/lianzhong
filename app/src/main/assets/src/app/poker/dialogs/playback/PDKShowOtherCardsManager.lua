-- Author: wh
-- Date: 2017-06-02 19:40:54
--明牌管理器

local PDKShowOtherCardsManager = class("PDKShowOtherCardsManager")

function PDKShowOtherCardsManager:ctor(cardDis)
	self.cardDis_ = cardDis
end

function PDKShowOtherCardsManager:createNodes()
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
			cardView = PDKOtherCardView.new(2,self.cardDis_,6)
			cardView:align(display.CENTER,display.cx,display.cy-20)
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
end

function PDKShowOtherCardsManager:init()
	if self.isSeted == true then

		return
	end
	self.isSeted = true
	local model = self.ctx.model
	local serverPlayerList = model:getPlayerList()
	for i=1,#serverPlayerList do
		local tempSeat = 	serverPlayerList[i]
		local tempSeatId = model:getOtherClientSeatId(serverPlayerList[i].seatNo)
		if tempSeatId ~= 1 then
			local cards = model:getClientCardsByServer(tempSeat.handCards)
			self:showCards(tempSeatId,cards)	
		end 
	end
end

function PDKShowOtherCardsManager:showCards(seatId,cards)
	local cardView = self.cardList_[seatId]
	if cardView then
		cardView:setCard(cards)
		cardView:show()
	end
end

function PDKShowOtherCardsManager:outCards(seatId,outCards)
	local cardView = self.cardList_[seatId]
	if cardView then
		cardView:removeOutCard(outCards)
	end
end

function PDKShowOtherCardsManager:hideOutCard(seatId)
	local cardView = self.cardList_[seatId]
	if cardView then
		cardView:hide()
	end
end
function PDKShowOtherCardsManager:hideAll()
	for k,v in ipairs(self.cardList_) do
		v:hide()
	end
end

function PDKShowOtherCardsManager:cleanAllCard()

	for k,v in ipairs(self.cardList_) do
		v:clearAllCard()
	end
end

function PDKShowOtherCardsManager:dispose()
	self.isSeted= false
end

return PDKShowOtherCardsManager