--
-- Author: wh
-- Date: 2017-04-18 18:41:34
-- 神一样的动画。
-- 类申明
local DealCardAnim = class("DealCardAnim",
	function()
		 return display.newNode()
	end
)

function DealCardAnim:ctor(cardNumAll)
	self.osWidth = Commons.osWidth
    self.osHeight = Commons.osHeight
    self.pop_window = display.newColorLayer(cc.c4b(0, 0, 0, 0))       -- 全透明底
    self.pop_window:setContentSize(self.osWidth, self.osHeight)             -- 设置Layer的大小,全屏出现
    self.pop_window:setTouchEnabled(true)
    self.pop_window:setTouchSwallowEnabled(true)  -- 吞噬下层的响应
    self.pop_window:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event) -- 点击此Layer时候输出信息,然后把自己销毁  
        --self:removeFromParent()
       return true
    end)
    self.pop_window:addTo(self)

    --self:performWithDelay(function()
        self:create(cardNumAll)
    --end, 1)
    -- if CVar._static.isIphone4 then
    --     self:create(19)
    -- elseif CVar._static.isIpad then
    --     self:create(16)
    -- else
    -- 	self:create(23)
    -- end
end

function DealCardAnim:create(cardNum)
	self.cardNum_ = cardNum
	local LEFT_POS = cc.p(200, display.cy+210)
	local RIGHT_POS = cc.p( Commons.osWidth-200, display.cy+210)  
	local SELF_POS = cc.p(240, 100)  -- 我的手牌坐标

	local SELF_CARDS = {}
	local LEFT_CARDS = {}
	local RIGHT_CARDS = {}


	local arr = {LEFT_POS,RIGHT_POS,SELF_POS}

	local card = Imgs.gameing_dcard_pallet_pai

	local delayTime = 0.0 --速度变化值
	local otherPokerMove = 0 -- 左右方玩家扑克牌Y偏移值
	for i=1, self.cardNum_ do
		otherPokerMove = otherPokerMove+1.5
		 for j = 1, 3 do 
		 	delayTime = delayTime+1
		 	local poker = display.newSprite(card)
				:addTo(self.pop_window)
				:pos(display.cx, display.cy+195)   -- 一副牌的显示位置
				-- :setVisible(false)

			if j == 3 then
			 	table.insert(SELF_CARDS,poker)
			 	-- transition.moveTo(poker, {time = .1,x = SELF_POS.x + 40*i, y = SELF_POS.y, delay = 0.05 * delayTime/2})
			 	local a = transition.moveTo(poker, {time = .1, x = SELF_POS.x +35*i, y = SELF_POS.y-otherPokerMove, delay = 0.05 * delayTime/2})
			 	local b = transition.fadeTo(poker, {opacity = 1, time = .1, delay = 0.05 * delayTime/2})
			 	cc.Sequence:create(a,b)
			end
			-- if j == 2 then
			--  	table.insert(RIGHT_CARDS,poker)
			--  	transition.moveTo(poker, {time = .1,x = RIGHT_POS.x , y = RIGHT_POS.y-otherPokerMove, delay = 0.05 * delayTime/2})
			-- end
			-- if j == 1 then
			-- 	table.insert(LEFT_CARDS,poker)
			-- 	transition.moveTo(poker, {time = .1,x = LEFT_POS.x , y = LEFT_POS.y-otherPokerMove, delay = 0.05 * delayTime/2})
			-- end
		 end
	end

	---[[
	--所有动画播放完毕，打完收工
	local delays = 0.01
	self:performWithDelay(function()

		--dump(SELF_CARDS,"SELF_CARDS")

		for i=1,#SELF_CARDS do
			delays = delays+0.01
			if i== #SELF_CARDS then
				transition.fadeTo(SELF_CARDS[i], {opacity = 0, time = delays,onComplete =
				function()
					self:removeFromParent()
					--这里还可以弄一个回调进来，方便桌子上的操作。
				end
				})
			else
		    	transition.fadeTo(SELF_CARDS[i], {opacity = 0, time = delays})
		    end
		    -- transition.fadeTo(LEFT_CARDS[i], {opacity = 0, time = delays})
		    -- transition.fadeTo(RIGHT_CARDS[i], {opacity = 0, time = delays})
		end 

		-- for i=1,#LEFT_CARDS do
		-- 	delays = delays+0.05
		-- 	if i== #LEFT_CARDS then
		-- 		transition.fadeTo(LEFT_CARDS[i], {opacity = 0, time = delays,onComplete =
		-- 		function()
		-- 			self:removeFromParent()
		-- 			--这里还可以弄一个回调进来，方便桌子上的操作。
		-- 		end
		-- 		})
		-- 	else
		--     	transition.fadeTo(LEFT_CARDS[i], {opacity = 0, time = delays})
		--     end
		--     -- transition.fadeTo(LEFT_CARDS[i], {opacity = 0, time = delays})
		--     transition.fadeTo(RIGHT_CARDS[i], {opacity = 0, time = delays})
		-- end     
    end, 0.05 * cardNum*3/2 + 0.2)
    --]]

    -- 发牌显示全部的时间：0.05*cardNum*3/2 + 0.1  假如20张 =0.05*20*3/2+0.1 =1.6秒    23张=1.825 19张=1.525 16张=1.3 
    -- 消失：延迟0.2秒来做消失
    -- 消失本身需要消耗：1.6[发牌时间]+0.2+cardNum*0.05  假如20张 =1.6+0.2+20*0.05 =2.8秒  23张=3.175 19张=2.675 16张=2.3
end

function DealCardAnim:onExit()

end

return DealCardAnim