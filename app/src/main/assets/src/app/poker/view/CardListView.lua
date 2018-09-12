local CardListView = class("CardListView",function()
    return display.newNode()
end)

CardListView.resPath = PDKImgs.bigcard_landlord_flag
--[[
	type: 类型   1：大牌  2：中牌   3：小牌  4：小小牌【默认为中牌】
	distance: 牌间距
	align: 1 左； 2 中； 3 右
	rowMax: 一行最多显示张数 默认50
--]]
function CardListView:ctor(type,distance,align,rowMax)
	self:setNodeEventEnabled(true)
	self.type_ = type or 2
	self.distance_ = distance or 50
	self.align_ = align or 2
	local tempCard = CardView.new(self.type_)
	self.cardWidth = tempCard.width
	self.cardHeight =  tempCard.height
	self.rowMax_ = rowMax or 50
end

function CardListView:setLandlordFlag(value)
	if self.type_~=1 and self.type_~=2 then return; end
	value = value or false
	if self.landlordView_ then
		self.landlordView_:removeFromParent()
	end
	if value==true or value==1 then
		if not self.landlordView_ then
			local str = ""
			if self.type_==1 then
				str = "@2x"
			end
			self.landlordView_ = display.newSprite(string.format(CardListView.resPath,str))
				:align(display.TOP_RIGHT)
			self.landlordView_:scale(0.5)
			self.landlordView_:retain()
		end
		local cardView = self.listCard_ and self.listCard_[#self.listCard_]
		if cardView then
			local x,y = cardView:getPosition()
			self.landlordView_:pos(x+cardView.width/2,y+cardView.height/2)
		end
		self.landlordView_:addTo(self)
	end
end

function CardListView:setCard(list)
	if not list or #list<1 then return end
	self:clearAllCard()
	self.listData_ = list
	self.listCard_ = {}
	-- 默认居中
	-- 布局 dragCardList
	local dragWidth = (#list-1)*self.distance_ + self.cardWidth
	if #list>self.rowMax_ then
		dragWidth = (self.rowMax_-1)*self.distance_ + self.cardWidth
	end
	local startX = (self.cardWidth - dragWidth)/2
	if self.align_==1 then
		startX = self.cardWidth/2
	elseif self.align_==3 then
		startX = -dragWidth + self.cardWidth/2
	end
	local cardView
	for k,v in ipairs(list) do
		cardView = CardView.new(self.type_)
		if v==0 then
			cardView:showBack()
		else
			cardView:showFront(v)
		end
		cardView:pos(startX+(k-1)*self.distance_,0)
		if k>self.rowMax_ then
			local iK = k%self.rowMax_
			local iY = math.floor(k/self.rowMax_)
			if iK==0 then --一排中最后一个
				iK = self.rowMax_
				iY = iY - 1
			end
			cardView:pos(startX+(iK-1)*self.distance_,-self.cardHeight*0.32*iY)
		end
		cardView:addTo(self)
		table.insert(self.listCard_,cardView)
	end
end

function CardListView:addCard(list)

end

function CardListView:clearCard(list)

end

function CardListView:clearAllCard()
	if self.landlordView_ then
		self.landlordView_:removeFromParent()
	end
	self.listData_ = nil
	if self.listCard_ then
		for k,cardView in pairs(self.listCard_) do
			cardView:removeFromParent()
		end
	end
	self.listCard_ = nil
end

function CardListView:onCleanup()
	if self.landlordView_ then
		self.landlordView_:release()
	end
end

return CardListView