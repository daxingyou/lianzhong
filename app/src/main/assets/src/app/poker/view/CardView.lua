require("framework.cc.utils.bit")

local CardView = class("CardView",function()
    	return display.newNode()
    end
)
-- 方块 0x01,0x02,0x03,0x04,0x05,0x06,0x07,0x08,0x09,0x0A,0x0B,0x0C,0x0D
-- 方块  A     2    3   4     5   6    7     8   9     10  J     Q    K
-- 梅花 0x11,0x12,0x13,0x14,0x15,0x16,0x17,0x18,0x19,0x1A,0x1B,0x1C,0x1D
-- 梅花  A     2    3   4     5   6    7     8   9     10  J     Q    K
-- 红桃 0x21,0x22,0x23,0x24,0x25,0x26,0x27,0x28,0x29,0x2A,0x2B,0x2C,0x2D
-- 红桃  A     2    3   4     5   6    7     8   9     10  J     Q    K
-- 黑桃 0x31,0x32,0x33,0x34,0x35,0x36,0x37,0x38,0x39,0x3A,0x3B,0x3C,0x3D
-- 黑桃  A     2    3   4     5   6    7     8   9     10  J     Q    K
-- 小王  0x4E
-- 大王  0x4F
function CardView:ctor(type)
	type = type or 2
	cc(self)
        :addComponent("components.behavior.EventProtocol")
        :exportMethods()

	self.showType_ = 1 -- 显示类型  0 小牌（只显示1花色） 1为大牌（显示2花色）
	self.need2X_ = 0 -- 是否要显示大牌  1位双倍资源  0正常资源

	if type==1 then
		self.need2X_ = 1
	elseif type==3 then
		self.showType_ = 0
		self.need2X_ = 1
	elseif type==4 then
		self.showType_ = 0
	end

	if self.showType_==1 then
		self.resPre_ = PDKImgs.bigcard_respath
	else
		self.showType_ = 0
		self.resPre_ = PDKImgs.smallcard_smalls
	end

	if self.need2X_ == 1 then
		self.resFin_ = "@2x"
	else
		self.need2X_ = 0
		self.resFin_ = ""
	end

	-- 坐标倍数
	self.coordMul_ = 1
	if self.showType_==1 and self.need2X_ == 1 then
		self.coordMul_ = 2
	elseif self.showType_==1 and self.need2X_ == 0 then
		self.coordMul_ = 1
	elseif self.showType_==0 and self.need2X_ == 1 then
		self.coordMul_ = 0.8
	else
		self.coordMul_ = 0.4
	end

	-- values
	self.type_ = nil   -- 颜色  方块  梅花  红桃  黑桃
	self.preType_ = nil
	self.value_ = nil  -- 牌值  3,4,5,6,7,8,9,10,J,Q,K,A,2,小王,大王
	self.preValue_ = nil 
	self.cardValue_ = nil -- 牌逻辑值
	self.preCardValue_ = nil
	-- views 
	self.backView_ = nil  -- 背牌
	self.bgView_ = nil  -- 白色背景
	self.valueView_ = nil  -- 牌值显示A
	self.smallTypeView_ = nil -- 小花色显示
	self.bigTypeView_ = nil -- 大的花色
	self.characterView_ = nil -- 花牌  小王  大王
	self.flagLandlordView_ = nil -- 
	-- 屏幕适配 有更好的办法么?
	if not self.bgView_ then
		self.bgView_ = display.newSprite(self.resPre_..PDKImgs.pdkcard_bg..self.resFin_..PDKImgs.img_suff)
		self:addChild(self.bgView_)
		local size = self.bgView_:getContentSize()
		self.height = size.height
		self.width = size.width
		-- self:setContentSize(cc.size(self.width, self.height))
	end
	self.x_ = 0
	self.y_ = 0
end
-- 显示牌  cardValue：牌值  isLandlord：是否是地主
function CardView:setData(cardValue,isLandlord)
	self.cardValue_ = cardValue or self.cardValue_
	self.isLandlord_ = isLandlord or false
 -- bit.bnot(n) -- bitwise not (~n)
 -- bit.band(m, n) -- bitwise and (m & n)
 -- bit.bor(m, n) -- bitwise or (m | n)
 -- bit.bxor(m, n) -- bitwise xor (m ^ n)
 -- bit.brshift(n, bits) -- right shift (n >> bits)
 -- bit.blshift(n, bits) -- left shift (n << bits)
 -- bit.blogic_rshift(n, bits) -- logic right shift(zero fill >>>)
 	self.type_ = bit.brshift(self.cardValue_,4)
 	self.value_ = bit.band(self.cardValue_,0x0F)
 	self.sortValue_ = self.value_
 	if self.sortValue_<3 then
 		self.sortValue_ = self.sortValue_ + 13		--A  和   2
 	elseif self.sortValue_>13 then
		self.sortValue_ = self.sortValue_ + 15		--29是小王  30是大王
 	end
 	return self
end
function CardView:showBack()
	if self.bgView_ then
		self.bgView_:hide()
	end
	if not self.backView_ then
		self.backView_ = display.newSprite(self.resPre_..PDKImgs.pdkcard_bg_back..self.resFin_..PDKImgs.img_suff)
		self:addChild(self.backView_)
	end
	self.backView_:show()
	return self
end
function CardView:clearFront()
	if self.valueView_ then
		self.valueView_:removeFromParent()
		self.valueView_ = nil
	end
	if self.smallTypeView_ then
		self.smallTypeView_:removeFromParent()
		self.smallTypeView_ = nil
	end
	if self.bigTypeView_ then
		self.bigTypeView_:removeFromParent()
		self.bigTypeView_ = nil
	end
	if self.characterView_ then
		self.characterView_:removeFromParent()
		self.characterView_ = nil
	end
	if self.flagLandlordView_ then
		self.flagLandlordView_:removeFromParent()
		self.flagLandlordView_ = nil
	end
	if self.landlordView_ then
		self.landlordView_:removeFromParent()
		self.landlordView_ = nil
	end
end
function CardView:showFront(cardValue,isLandlord)
	if cardValue or isLandlord then
		self:setData(cardValue or self.cardValue_,isLandlord)
	end
	if self.backView_ then
		self.backView_:hide()
	end
	self.bgView_:show()
	if self.cardValue_==self.preCardValue_ then
		return self
	end
	self:clearFront()
	if self.cardValue_==0x4E then 
		self.characterView_ = display.newSprite(self.resPre_..PDKImgs.pdkcard_smallJoker..self.resFin_..PDKImgs.img_suff)
			:pos(self.width/2,self.height/2)
			:addTo(self.bgView_)
	elseif self.cardValue_==0x4F then
		self.characterView_ = display.newSprite(self.resPre_..PDKImgs.pdkcard_bigJoker..self.resFin_..PDKImgs.img_suff)
			:pos(self.width/2,self.height/2)
			:addTo(self.bgView_)
	else
		local valuePre = ""  -- 牌值前缀
		local smallType = "" --小型花色前缀
		local bigType = ""  --大型花色前缀
		if self.type_==0 or self.type_==2 then  -- 红桃或者方块，都是红色的牌
			valuePre = PDKImgs.pdkcard_red
			if self.type_==0 then
				smallType = PDKImgs.pdkcard_squareSmall
				bigType = PDKImgs.pdkcard_squareBig
			else
				smallType = PDKImgs.pdkcard_heartsSmall
				bigType = PDKImgs.pdkcard_heartsBig
			end
			if self.showType_==1 then  -- 小牌角色显示不下
				if self.value_==11 then
					bigType = PDKImgs.pdkcard_redJ -- 花色图片特意去掉，不要
				elseif self.value_==12 then
					bigType = PDKImgs.pdkcard_redQ
				elseif self.value_==13 then
					bigType = PDKImgs.pdkcard_redK
				end
			end
		else -- 黑桃或者梅花，都是黑色的牌
			valuePre = PDKImgs.pdkcard_black
			if self.type_==1 then
				smallType = PDKImgs.pdkcard_plumSmall
				bigType = PDKImgs.pdkcard_plumBig
			else
				smallType = PDKImgs.pdkcard_spadesSmall
				bigType = PDKImgs.pdkcard_spadesBig
			end
			if self.showType_==1 then  -- 小牌角色显示不下
				if self.value_==11 then
					bigType = PDKImgs.pdkcard_blackJ -- 花色图片特意去掉，不要
				elseif self.value_==12 then
					bigType = PDKImgs.pdkcard_blackQ
				elseif self.value_==13 then
					bigType = PDKImgs.pdkcard_blackK
				end
			end
		end
		self.valueView_ = display.newSprite(self.resPre_.. valuePre .. self.value_ ..self.resFin_..PDKImgs.img_suff)
			:align(display.CENTER_TOP,15*self.coordMul_,self.height-5*self.coordMul_)
			:addTo(self.bgView_)
		local valueSize = self.valueView_:getContentSize()
		if self.showType_==1 then
			self.smallTypeView_ = display.newSprite(self.resPre_.. smallType ..self.resFin_..PDKImgs.img_suff)
				:align(display.CENTER_TOP,15*self.coordMul_,self.height- 7*self.coordMul_ - valueSize.height)
				:addTo(self.bgView_)
		end

		-- 花色图片特意去掉，不要，所以这里也需要特殊处理下
		-- if self.value_>10 and self.showType_==1 then
		-- 	self.characterView_ = display.newSprite(self.resPre_..bigType..self.resFin_..PDKImgs.img_suff)
		-- 		:pos(self.width/2,self.height/2)
		-- 		:addTo(self.bgView_)
		-- else
			local moveY_card = 25
			if self.need2X_ == 0 then
				moveY_card = 10
			end
			self.bigTypeView_ = display.newSprite(self.resPre_..bigType..self.resFin_..PDKImgs.img_suff)
				:align(display.BOTTOM_RIGHT, self.width-6*self.coordMul_ -6, 6*self.coordMul_ +moveY_card)
				:addTo(self.bgView_)
				:setScale(0.7)
		-- end
	end
	if (self.isLandlord_==true or self.isLandlord_==1) and self.showType_==1 then  -- 地主牌的标识
		self.landlordView_ = display.newSprite(self.resPre_..PDKImgs.pdkcard_landlord_flag..self.resFin_..PDKImgs.img_suff)
			:align(display.TOP_RIGHT,self.width,self.height)
			:addTo(self.bgView_)
		self.landlordView_:scale(0.5)
	end
	self.preCardValue_ = self.cardValue_
	self.preType_ = self.type_
	self.preValue_ = self.value_
	return self
end
function CardView:addEvent()
	self:setTouchEnabled(true)
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, handler(self, self.onTouch_))
end
function CardView:removeEvent()
	self:setTouchEnabled(false)
    self:removeAllNodeEventListeners()
    self:removeTouchEvent()
    self:unregisterScriptHandler()
end
function CardView:setNormalPos(x,y)
	self.x_ = x or 0
	self.y_ = y or 0
end
function CardView:setSelect(value)
	if value==nil then value = false end
	self.isSelect = value
	if self.isSelect then
		self:setPositionY((self.y_ or 0)+20)
	else
		self:setPositionY(self.y_ or 0)
	end
	self:setScolling(false)
end
function CardView:setScolling(value)
	if value then
		self.isDrag = true
		self.bgView_:setColor(cc.c3b(200,200,200))
	else
		self.isDrag = false
		self.bgView_:setColor(cc.c3b(255,255,255))
	end
end
function CardView:onTouch_(event)
	local name, x, y = event.name, event.x, event.y
    if name == "began" then
    	self:setScolling(true)
        self:dispatchEvent({name="CARD_SELECT_BEGAN", data={x = x, y = y, target = self}})
        return true
    end
    if name == "moved" then
        self:dispatchEvent({name="CARD_SELECT_MOVED", data={x = x, y = y, target = self}})
    else
        if name == "ended" then
        	self:dispatchEvent({name="CARD_SELECT_ENDED", data={x = x, y = y, target = self}})
    	end
    end
end
return CardView