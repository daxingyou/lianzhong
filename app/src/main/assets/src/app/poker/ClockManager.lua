-- Author: wh
-- Date: 2017-05-08 19:40:54
--闹钟管理器
local ClockManager = class("ClockManager")

function ClockManager:ctor(ctx)
	self.ctx = ctx
	self.clock_ = nil
	self.ani = cc.Animation:create()
	self.ani:addSpriteFrameWithFile(PDKImgs.room_clock1)
	self.ani:addSpriteFrameWithFile(PDKImgs.room_clock2)
	self.ani:setDelayPerUnit(1/8)
	self.ani:retain() 
	self.animate = cc.Animate:create(self.ani)
	self.animate:retain()
	self.action = cc.RepeatForever:create(self.animate)
	self.action:retain()

	local sp = display.newNode()
	self.top_scheduler = sp:getScheduler();
    self.top_schedulerID = self.top_scheduler:scheduleScriptFunc(handler(self, self.onClockDown_), 1, false) 
end

-- local isLeft3second = false -- 是否有过一次低于3秒的闹钟告警声音
function ClockManager:onClockDown_()
	if self.clock_ then
		if self.clock_.isShowing then
			
			self.clock_.leftTime = self.clock_.leftTime - 1
			if self.clock_.leftTime <= 0 then
				self.clock_.leftTime = 0
			end
			self.clock_.numNode:removeAllChildren()
			local view,len = self:createLeftNum(self.clock_.leftTime)
				view:addTo(self.clock_.numNode)
				if len>1 then
					self.clock_.numNode:pos(18,50)
				else
					self.clock_.numNode:pos(28,50)
				end

			if self.clock_.leftTime<6 and not self.clock_.isPlaying then
				self.clock_.isPlaying = true
				self.clock_:runAction(self.action)

			end

			-- 响起告警声音
			-- if self.clock_.leftTime == 3 then
		 --        isLeft3second = true
		 --        VoiceDealUtil:playSound_other(VoicesM.file.timeup_alarm)
		 --    else
		 --        if isLeft3second then -- 有过一次低于3秒的闹钟告警声音
		 --            if self.clock_.leftTime > 3 then -- 如果大于三，说明又是新的开始，闹钟告警声音立马抢占停止
		 --                isLeft3second = false
		 --                VoiceDealUtil:playSound_other(VoicesM.file.empty_sound)
		 --            end
		 --        end
		 --    end
		end
	end
	return true
end
function ClockManager:play(seatId,leftTime,totaltime)
	if seatId<1 then return end
	if not self.clock_ then
		self.clock_ = display.newSprite(PDKImgs.room_clock)
		self.clock_.numNode = display.newNode()
		:addTo(self.clock_)
		:pos(28,50)
		self.clock_:addTo(self.ctx.scene.clockNode)
	end
	if seatId==1 then
		self.clock_:align(display.LEFT_BOTTOM,50+55,220+35)
	elseif seatId==2 then
		self.clock_:align(display.RIGHT_TOP,display.width-100,display.height-120)
	elseif seatId==3 then
		self.clock_:align(display.LEFT_TOP,100,display.height-120)
	end
	self.clock_.numNode:removeAllChildren()
	local view,len = self:createLeftNum(leftTime)
	view:addTo(self.clock_.numNode)
	if len>1 then
		self.clock_.numNode:pos(18,50)
	end
	--self.clock_:stopAllActions()
	self.clock_:show()
	self.clock_.leftTime = leftTime
	self.clock_:setTexture(PDKImgs.room_clock)
	self:stop()
	self.clock_.isShowing = true
end


function ClockManager:createLeftNum(num)
	local len = 1
	local view = display.newSprite()
    local _string = tostring(num)
    local gapX = 14

    if num < 10 then -- 个位数变成2位数字显示
    	_string = "0".._string
    	gapX = 20
    end

    local _size = string.len(_string)
    for i=1,_size do
    	len = i
        local i_str = string.sub(_string, i, i)
        local img_i = PDKImgs.timeNum_shows..i_str..PDKImgs.img_suff
        cc.ui.UIImage.new(img_i,{scale9=false})
            :addTo(view)
            :align(display.LEFT_TOP, (i-1)*gapX, 0)
    end
    
    return view,len
end

function ClockManager:stop()
	
	if self.clock_ then
		self.clock_:stopAllActions()
		self.clock_.isShowing = nil
		self.clock_.isPlaying = nil
	end
end

function ClockManager:stopAll()

	if self.clock_ then
		self:stop()
		self.clock_:hide()
	end
end

function ClockManager:hideClock()

	if self.clock_ then
		self.clock_:hide()
	end
end

function ClockManager:dispose()

	if self.top_scheduler and self.top_schedulerID then 
		self.top_scheduler:unscheduleScriptEntry(self.top_schedulerID)
	end
	self:stop()
	-- self.ani:release()
	-- self.animate:release()
	--self.action:release()
	if self.clock_ then
		self.clock_:removeFromParent()
		self.clock_ = nil
	end
end

return ClockManager