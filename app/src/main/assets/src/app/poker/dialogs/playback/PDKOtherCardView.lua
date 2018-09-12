--[[
	其他玩家的牌
--]]
local PDKOtherCardView = class("PDKOtherCardView",CardListView)
PDKOtherCardView.maxOffX = 70
PDKOtherCardView.dragOffx = 30
function PDKOtherCardView:ctor(type,distance,align,rowMax)
	PDKOtherCardView.super.ctor(self,type,distance,align,rowMax)
end
function PDKOtherCardView:removeOutCard(list)
	if not list or #list<1 then return end
	--self:clearDragCard()
	for k,v in ipairs(list) do
		for kk,vv in ipairs(self.listCard_) do
			if vv.cardValue_==v then
				if vv:getParent() then
					vv:removeFromParent()
				end
				table.remove(self.listCard_,kk)
				break
			end
		end
	end
	self:rePositonCard()
end

function PDKOtherCardView:rePositonCard()
	-- 默认居中
	-- 布局 dragCardList
	local list = self.listCard_
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
		cardView = self.listCard_[k]
		
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
		-- cardView:addTo(self)
		-- table.insert(self.listCard_,cardView)
	end
end

function PDKOtherCardView:setBlack()
	for k,v in pairs(self.listCard_) do
		v:setScolling(true)
	end
end

return PDKOtherCardView
