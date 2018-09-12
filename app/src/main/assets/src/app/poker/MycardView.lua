--[[
	我自己的牌
--]]
local MycardView = class("MycardView",CardListView)
MycardView.maxOffX = 70
MycardView.dragOffx = 50
function MycardView:ctor()
	MycardView.super.ctor(self,1,MycardView.dragOffx)
	self.preOutCardList_ = nil		-- 出牌前的牌哦
	self.dragCardList_ = nil		-- 当前拖拽牌
	self.dragCardData_ = nil		-- 拖拽牌值
	self:initCard()
	self.addCardAnimId_ = nil		-- 动画
end
function MycardView:initCard()
	local list = {0x01,0x02,0x03,0x04,0x05,0x06,0x07,0x08,0x09,0x0A,0x0B,0x0C,0x0D,0x11,0x12,0x13,0x14,0x15}
	self:setCard(list)
	self:clearAllCard()
	self.touchIsOpen_ = false
	self.isClicked_ = false
	self.isSeted_ = false --是否已经设置过牌
end
function MycardView:checkCardIsClicked(cardView,x,y)
	local isInLeftHalf,isInAll = false,false
	if cardView:getCascadeBoundingBox():containsPoint(cc.p(x, y)) then
		isInAll = true
		local xx,yy = cardView:getPosition()
		if ((xx - cardView.width/2) <x and (xx- cardView.width/2)+self.distance_ > x) then
			isInLeftHalf = true
		end
	else

	end
	return isInLeftHalf,isInAll
end
function MycardView:clearAllCard()
	self.isSeted_ = false
	MycardView.super.clearAllCard(self)
	self:clearDragCard()
	
end
function MycardView:dragSelectCard(target, x,y,isOver)
	local cardView = nil
	if x>=self.moveStartX_ then  -- 右拽
		for i=1,#self.curCardList_,1 do
			cardView = self.curCardList_[i]
			local xx,yy = cardView:getPosition()
			if target==cardView or((xx - cardView.width/2) <x and (xx- cardView.width/2)+self.distance_ > self.moveStartX_) then
				if isOver then
					if target==cardView or math.abs(self.moveStartX_-x)>2 then
						cardView:setSelect(not cardView.isSelect)
					end
				else
					cardView:setScolling(true)
				end
			else
				cardView:setScolling(false)
			end
		end
	else  -- 左拽
		for i=1,#self.curCardList_,1 do
			cardView = self.curCardList_[i]
			local xx,yy = cardView:getPosition()
			if target==cardView or((xx - cardView.width/2) < self.moveStartX_ and (xx - cardView.width/2)+self.distance_ > x) then
				if isOver then
					cardView:setSelect(not cardView.isSelect)
				else
					cardView:setScolling(true)
				end
			else
				cardView:setScolling(false)
			end
		end
	end
end
function MycardView:dealCards()
	for i=1,#self.listCard_ do
		self.listCard_[i]:hide()
	end
	-- for i=1,#self.listCard_ do
	-- 	local sprite = self.listCard_[i]
	-- 	transition.fadeIn(sprite, {time = 1,delay = i+0.1, onComplete= function()
			
	-- 	end
	-- })
	-- end
	self.index = 1
	self.maxIndex = #self.listCard_ 

	if self.maxIndex >= 1 then
		self.action_ = self:schedule(
			function ()
				if self.index > self.maxIndex then
					self:stopAction(self.action_)
					self.action_ = nil
				else
			        self.listCard_[self.index]:show()    
			        self.index =  self.index+1   
			    end 
	       	end,.1
	    )
	end
end
function MycardView:cardSelectEnded(target, x,y)
	-- 出牌判断
	if self.isDrag_ then
		self.dragCard_:pos(x,y)
		--执行出牌动作，无论咋样，先将扑克牌归位，一旦打出，会清掉选中的牌。
		--self.roomController:doUIControlAction(CEnumP.CLIENT_UI_ACTION.outCard)
		local value ;--= --
		if value then
			self.outCardControl:hide()
			self.dragCard_:pos(display.cx,display.cy-20)
			-- cardView:align(display.CENTER,display.cx,display.cy-20)
		else
			self.curCardList_ = self.preOutCardList_
			-- 出牌不合法 拖出来的选中
			self:rePositonCard()
			self:tipsBigCard(self.dragCardData_)
			self:clearDragCard()
		end
	else
		self:dragSelectCard(target,x,y,true)
		-- 测试
		--self:setLandlordFlag(self.model and self.model.isLandlord)
	end
	self.isDrag_ = false
end
function MycardView:clearDragCard()
	if self.dragCard_ then
		self.dragCard_:clearAllCard()
	end
	self.dragCardList_ = nil
	self.dragCardData_ = nil
	self.isSeted_ = false
end
function MycardView:onTouch(event)
	--dump("fuckdandan","MycardView")
	if self.touchIsOpen_ and ((self.curCardList_ and #self.curCardList_>0) or (self.dragCardList_ and #self.dragCardList_>0)) then
		local name, x, y = event.name, event.x, event.y
		if name == "began" then
			local touchInTarget = self:getCascadeBoundingBox():containsPoint(cc.p(x, y))
			if touchInTarget then
				local lastInAllCard
				local cardView
				for i=1, #self.curCardList_,1 do
					cardView = self.curCardList_[i]
					local isInLeftHalf,isInAll = self:checkCardIsClicked(cardView,x,y)
					if isInLeftHalf then
						self.startTarget_ = cardView -- 开始处
						self.moveStartX_ = x -- 开始位置
						self.moveStartY_ = y
						self.isDrag_ = false -- 拖拽出牌
						self.isClicked_ = true -- 点击中了
						cardView:setScolling(true)
						return true
					elseif isInAll then
						lastInAllCard = cardView
					end
				end
				-- 选中的
				if lastInAllCard then
					self.startTarget_ = lastInAllCard -- 开始处
					self.moveStartX_ = x -- 开始位置
					self.moveStartY_ = y
					self.isDrag_ = false -- 拖拽出牌
					self.isClicked_ = true -- 点击中了
					lastInAllCard:setScolling(true)
					return true
				end
			else
				
			end
		end
		if name == "moved" then
			if self.isClicked_ and self.startTarget_ then
				if self.isDrag_ then -- 已经拖出区域
					self:dragingOutCard(self.startTarget_,x,y)
					return
				end
				if math.abs(self.startTarget_.y_ - y)>=self.startTarget_.height*2/3 then
					self.isDrag_ = true
				end
				if self.isDrag_ then
					self:dragingOutCard(self.startTarget_,x,y,true)
				else
					self:dragSelectCard(self.startTarget_,x,y)
				end
			end
		else
			if name == "ended" then
				if self.isClicked_ then
					self:cardSelectEnded(self.startTarget_,x,y)
				end
		    	self.isClicked_ = false
		    	self.isDrag_ = false
		    	self.startTarget_ = nil
		    end
	    end
	end
end
function MycardView:rePositonCard(reAdd)

	-- local gap = 230
	-- if CVar._static.isIphone4 then
 --        gap = 250
 --    elseif CVar._static.isIpad then
 --        gap = 200
 --    end
	-- local startX = self.cardWidth/2 + gap/2
	-- self.distance_ = ((display.width-gap) - self.cardWidth)/(#self.curCardList_ - 1)
	-- if self.distance_>MycardView.maxOffX then
	-- 	self.distance_ = MycardView.maxOffX
	-- 	startX = self.cardWidth/2+((display.width-gap) - (#self.curCardList_ - 1)*self.distance_ - self.cardWidth)/2 + gap/2
	-- end

	local startX = self.cardWidth/2 
	self.distance_ = ((display.width) - self.cardWidth)/(#self.curCardList_ - 1)
	if self.distance_>MycardView.maxOffX then
		self.distance_ = MycardView.maxOffX
		startX = self.cardWidth/2+((display.width) - (#self.curCardList_ - 1)*self.distance_ - self.cardWidth)/2 
	end
	local cardView = nil
	if self.dragCardList_ then
		for i=1,#self.dragCardList_,1 do
			cardView = self.dragCardList_[i]
			cardView:hide()
		end
	end
	for i=1,#self.curCardList_,1 do
		cardView = self.curCardList_[i]
		cardView:show()
		cardView:setPosition(startX+(i-1)*self.distance_,cardView.height/2)
		if reAdd then
			cardView:removeFromParent()
			cardView:addTo(self)
			if cardView.isSelect then
				cardView:setSelect(true)
			else
				cardView:setSelect(false)
			end
		else
			cardView:setSelect(false)
		end
	end
	-- 测试
	self:setLandlordFlag(self.model and self.model.isLandlord)
end
function MycardView:onCleanup()
	MycardView.super.onCleanup(self)
	if self.listCard_ then
		for i=1,#self.listCard_,1 do
			self.listCard_[i]:release()
		end
	end
end

-- 选中后移动
function MycardView:dragingOutCard(target,x,y,isFirstDrag)
	if isFirstDrag then
		self.preOutCardList_ = self.curCardList_
		local tempCardList = {}
		self.dragCardList_ = {}
		self.dragCardData_ = {}
		local cardView = nil
		for i=1,#self.curCardList_,1 do
			cardView = self.curCardList_[i]
			-- if cardView.isSelect or cardView.isDrag then
			-- 	table.insert(self.dragCardData_,cardView.cardValue_)
			-- 	table.insert(self.dragCardList_,cardView)
			-- else
				table.insert(tempCardList,cardView)
			--end
		end
		self.curCardList_ = tempCardList
		self:rePositonCard()
		self.dragCard_:setCard(self.dragCardData_)
		-- 测试
		self.dragCard_:setLandlordFlag(self.model and self.model.isLandlord)
	end
	self.dragCard_:pos(x,y)
end

function MycardView:setDragCard(dargCard)
	self.dragCard_ = dargCard
end

function MycardView:clearAllCard()
	self.listData_ = nil
	if self.landlordView_ and not tolua.isnull(self.landlordView_) then
		self.landlordView_:removeFromParent()
		self.landlordView_ = nil
	end
	if self.listCard_ then
		for k,cardView in pairs(self.listCard_) do
			if cardView and not tolua.isnull(cardView) then
				cardView:removeFromParent()
			end
		end
	end
end
function MycardView:setCard(list,anim)
	if not list or #list<1 then return end
	self.isSeted_ = true
	if not self.listCard_ then
		MycardView.super.setCard(self,list)
		for k,cardView in ipairs(self.listCard_) do
			cardView:setNormalPos(cardView.width/2,cardView.height/2)
			cardView:retain()
		end
	end
	
	-- 设置当前牌  需要重新布局
	self.curCardList_ = {}		-- 剩余牌
	local cardView = nil
	for i=1,#list,1 do
		cardView = self.listCard_[i]
		cardView:showFront(list[i])
		table.insert(self.curCardList_,cardView)
		if not cardView:getParent() then
			cardView:addTo(self)
		end
	end
	self:rePositonCard()
	self.touchIsOpen_ = true
end

function MycardView:setLandlordFlag(value)
	value = value or false
	if self.landlordView_ and not tolua.isnull(self.landlordView_) then
		self.landlordView_:removeFromParent()
		self.landlordView_ = nil
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

		local cardView = self.curCardList_ and self.curCardList_[#self.curCardList_]
		if cardView then
			local x,y = cardView:getPosition()
			self.landlordView_:pos(x+cardView.width/2,y+cardView.height/2)
			self.landlordView_:addTo(self)
		end
	end
end

function MycardView:sortHandCard()
	table.sort(self.curCardList_,
		function(a,b)
			if a.sortValue_>b.sortValue_ then
				return true
			elseif a.sortValue_==b.sortValue_ then
				if a.type_>b.type_ then
					return true
				end
			end
			return false
		end )
end
function MycardView:addCard(list)
	if not list or #list<1 then return end
	local addCardList = {}
	local cardView = nil
	for k,v in ipairs(list) do
		cardView = self.listCard_[#self.curCardList_+1]
		cardView:showFront(v)
		table.insert(self.curCardList_,cardView)
		table.insert(addCardList,cardView)
		if not cardView:getParent() then
			cardView:addTo(self)
		end
	end
	self:sortHandCard()
	self:rePositonCard(true)
	self.touchIsOpen_ = true
	-- 选中
	for k,v in ipairs(addCardList) do
		v:setSelect(true)
	end
	-- 动画
	self.sceneSchedulerPool:clear(self.addCardAnimId_)
	self.addCardAnimId_ = self.sceneSchedulerPool:delayCall(function()
			for k,v in ipairs(addCardList) do
				v:setSelect(false)
			end
			if self.model and self.model.isLandlord then
				self:setLandlordFlag(self.model.isLandlord)
			end
		end,1)
end
function MycardView:removeOutCard(list)
	if not list or #list<1 then return end
	self:clearDragCard()
	for k,v in ipairs(list) do
		for kk,vv in ipairs(self.curCardList_) do
			if vv.cardValue_==v then
				if vv:getParent() then
					vv:removeFromParent()
				end
				table.remove(self.curCardList_,kk)
				break
			end
		end
	end
	self:rePositonCard()
end
function MycardView:getWillOutCard()
	-- 返回拖拽的牌型
	if self.dragCardData_ and #self.dragCardData_>0 then
		return self.dragCardData_
	end
	local list = {}
	for k,v in ipairs(self.curCardList_) do
		if v.isSelect then
			table.insert(list,v.cardValue_)
		end
	end
	return list
end
function MycardView:tipsBigCard(list)
	if not list or #list<1 then return end
	local shouldSelect
	for kk,vv in ipairs(self.curCardList_) do
		shouldSelect = false
		for k,v in ipairs(list) do
			if vv.cardValue_==v then
				shouldSelect = true
				break
			end
		end
		vv:setSelect(shouldSelect)
	end
	if self.model and self.model.isLandlord then
		self:setLandlordFlag(self.model.isLandlord)
	end
end
function MycardView:isSeted()
	return self.isSeted_
end
function MycardView:setIsSeted(value)
	self.isSeted_ = value
end

function MycardView:doNotSelect()
	for kk,vv in ipairs(self.curCardList_) do
		vv:setSelect(false)
	end
	if self.model and self.model.isLandlord then
		self:setLandlordFlag(self.model.isLandlord)
	end
end
return MycardView
