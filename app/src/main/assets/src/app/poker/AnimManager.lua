-- Author: wh
-- Date: 2017-05-08 19:40:54
--动画管理器

local AnimManager = class("AnimManager")
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")

local ClockManager = import(".ClockManager")

local POKER_TYPE_RES = "img/poker/ani/"

function AnimManager:ctor()
    
end
function AnimManager:createNodes()

	if self.nodes_ and self.nodes_:getParent() then
		self.nodes_:removeFromParentAndCleanup(true)
		self.nodes_ = nil
	end
	--创建一个节点
	self.nodes_ = display.newNode()
		:addTo(self.ctx.scene)

	self.lamps_ = {}
	-- display.newSprite(PDKImgs.liandui_anim)
	-- :addTo(self.nodes_)
	-- :center()

end
function AnimManager:showClock(seatId,leftTime,totaltime)
    if not self.clockManager_ then
        self.clockManager_ = ClockManager.new(self.ctx)
    end
    --self.clockManager_:stopAll()
    self.clockManager_:play(seatId,leftTime)
end
function AnimManager:stopClock(seatId)
    if self.clockManager_ then
        self.clockManager_:hideClock(seatId)
    end
end

function AnimManager:stopAllClock()
	if self.clockManager_ then
		self.clockManager_:stopAll()
	end
end

--播放没有牌可以压住上家
function AnimManager:playNotCard()
	local sprite = display.newSprite(PDKImgs.not_over_cards_tip)
	:addTo(self.nodes_)
	:center()
	:setPositionY(display.cy - 250)

	transition.fadeIn(sprite, {time = 0.4 , onComplete= function()
			transition.fadeOut(sprite, {time = 0.9, onComplete = 
			function()
				sprite:removeFromParent()
			end})
		end
	})
end

--播放出牌不合法
function AnimManager:playOutCardError()
	local sprite = display.newSprite(PDKImgs.out_card_error)
	:addTo(self.nodes_)
	:center()
	:setPositionY(display.cy - 250)

	transition.fadeIn(sprite, {time = 0.4 , onComplete= function()
			transition.fadeOut(sprite, {time = 0.9, onComplete = 
			function()
				sprite:removeFromParent()
			end})
		end
	})
end

--播放报警动画
function AnimManager:playWarning(seatId)
	if self.lamps_[seatId] then
		return 
	end
	display.addSpriteFrames(PDKImgs.anim_cardWarning_plist, PDKImgs.anim_cardWarning_png) 
	local frames = display.newFrames("cardWarning%d.png", 1, 3)
	local animation = display.newAnimation(frames, 1 / 8)
	animSprite =  display.newSprite(animation[1])
	:addTo(self.nodes_)
	animSprite:playAnimationForever(animation, 0)

	if seatId==1 then
		animSprite:align(display.LEFT_BOTTOM,135,220)
	elseif seatId==2 then
		animSprite:align(display.RIGHT_TOP,display.width-120,display.height-200)
	elseif seatId==3 then
		animSprite:align(display.LEFT_TOP,120,display.height-200)
	end
	self.lamps_[seatId] = animSprite
end

--停止报警动画
function AnimManager:stopWarning()
	for k,v in pairs(self.lamps_) do
		v:removeFromParent()
		self.lamps_[k] = nil
	end
end

--播放牌型动画
function AnimManager:playPokerType(pokerType)
	if pokerType == CEnumP.POKER_TYPE.FEIJI then

	    display.addSpriteFrames(PDKImgs.anim_feiji_plist, PDKImgs.anim_feiji_png) 
	    local frames = display.newFrames("feiji_ani_%d.png", 1, 3)
	    local animation = display.newAnimation(frames, 1 / 8)
	    local animSprite = display.newSprite(animation[1])
	    :center()
	    :setPositionX(display.width)
	    :addTo(self.nodes_)
	    animSprite:playAnimationForever(animation, 0)
	    transition.moveTo(animSprite, {time = 1.5,x = -100, delay = 0, onComplete = function()
	    	animSprite:removeFromParent()
	    end})


	elseif pokerType == CEnumP.POKER_TYPE.LIANDUI then

		display.addSpriteFrames(PDKImgs.anim_liandui_plist, PDKImgs.anim_liandui_png) 
	    local frames = display.newFrames("liandui_%d.png", 1, 12)
	    local animation = display.newAnimation(frames, 1 / 12)
	    local animSprite = display.newSprite(animation[1])
	    :center()
	    :setPositionY(display.cy+50)
	    :addTo(self.nodes_)
	    animSprite:playAnimationOnce(animation, 0)
	
	elseif pokerType == CEnumP.POKER_TYPE.SHUNZI then
		
		display.addSpriteFrames(PDKImgs.anim_shunzi_plist, PDKImgs.anim_shunzi_png) 
	    local frames = display.newFrames("shunzi_ani_%d.png", 1, 8)
	    local animation = display.newAnimation(frames, 1 / 8)
	    local animSprite = display.newSprite(animation[1])
	    :center()
	    :setPositionY(display.cy+50)
	    :addTo(self.nodes_)
	    animSprite:playAnimationOnce(animation, 0)

	
	elseif pokerType == CEnumP.POKER_TYPE.BOMB then
		display.addSpriteFrames(PDKImgs.anim_bomb_plist, PDKImgs.anim_bomb_png) 
	    local frames = display.newFrames("missle_bomb%d.png", 1, 5)
	    local animation = display.newAnimation(frames, 1 / 5)
	    local animSprite = display.newSprite(animation[1])
	    :center()
	    :setPositionY(display.cy+50)
	    :addTo(self.nodes_)
	    animSprite:playAnimationOnce(animation, 0)

	end
end

function AnimManager:playWin()
	local model = self.ctx.model
	local resultData = model:getTableOverData()

	if resultData == nil or resultData == {} then

		return
	end
	-- local resultData = {
	-- 	{roundResult = true,seatNo = 0}
	-- }

	self.light = display.newSprite(PDKImgs.room_win_light):addTo(self.nodes_):center():hide()
	self.winTitle = display.newSprite(PDKImgs.room_win):addTo(self.nodes_):center():hide()
	for i=1,#resultData do
		if resultData[i].roundResult == true then
			self.light:show()
			self.winTitle:show()
			local tempSeatId = model:getOtherClientSeatId(resultData[i].seatNo)
			if tempSeatId==1 then
				self.light:pos(180,250)
				self.winTitle:pos(180,250)
			elseif tempSeatId==2 then
				self.light:pos(display.width-120,display.height-200)
				self.winTitle:pos(display.width-120,display.height-200)
			elseif tempSeatId==3 then
				self.light:pos(250,display.height-200)
				self.winTitle:pos(250,display.height-200)
			end
		end
	end
	--self.light:runAction(cc.RepeatForever:create(cc.RotateBy:create(100, 36000)))
	self.light:runAction(cc.RepeatForever:create(cc.RotateBy:create(4, 360*4)))
	self.action_ = self.nodes_:schedule(
	  function ()
		self.nodes_:stopAction(self.action_)
		self.action_ = nil
		self.light:stopAllActions()
		-- self.light:removeFromParent()
		-- self.winTitle:removeFromParent()
		-- self.light = nil
		-- self.winTitle = nil
	end,1)
end

function AnimManager:stopWin()
	if self.light and self.winTitle then
		self.light:stopAllActions()
		self.light:removeFromParent()
		self.winTitle:removeFromParent()
		self.light = nil
		self.winTitle = nil
	end
end

function AnimManager:playWinForPlayback()
	local model = self.ctx.model
	local resultData = model:getTableOverData()

	if resultData == nil or resultData == {} then
		return
	end

	self.light = display.newSprite(PDKImgs.room_win_light):addTo(self.nodes_):center()
	self.winTitle = display.newSprite(PDKImgs.room_win):addTo(self.nodes_):center()
	for i=1,#resultData do
		if resultData[i].roundResult == true then
			local tempSeatId = model:getOtherClientSeatId(resultData[i].seatNo)
			if tempSeatId==1 then
				self.light:pos(180+30,250)
				self.winTitle:pos(180+30,250)
			elseif tempSeatId==2 then
				self.light:pos(display.width-120-30,display.height-200)
				self.winTitle:pos(display.width-120-30,display.height-200)
			elseif tempSeatId==3 then
				self.light:pos(250+30,display.height-200)
				self.winTitle:pos(250+30,display.height-200)
			end
		end
	end
	
end

function AnimManager:dispose()
	self:stopAllClock()
	if self.clockManager_ then
		self.clockManager_:dispose()
	end
	if self.action_ and self.nodes_ then
		self.nodes_:stopAction(self.action_)
		self.action_ = nil
	end
	if self.light then
		self.light:stopAllActions()
		self.light:removeFromParent()
		self.light = nil
		self.winTitle:removeFromParent()
		self.winTitle = nil
	end
end

return AnimManager