-- Author: wh
-- Date: 2017-05-08 19:40:54
--玩家座位
local RoomSeat = class("RoomSeat",function()
    return display.newNode()
end)

local BG_WIDHT = 90
local BG_HEIGHT = 93

RoomSeat.CLICKED = "RoomSeat.CLICKED"

function RoomSeat:ctor(ctx, seatid)
	self.ctx = ctx
	-- self.headBg_ = display.newSprite(PDKImgs.room_head_bg)
	-- 	:addTo(self)

	local user_rights = ""
	if seatid and seatid == CEnumP.seatNo.me then -- 只要是自己 就去取这个权限
		local user = GameStateUserInfo:getData()
		user_rights = user[User.Bean.rights]
	end
	-- print("==222==================================================user_rights==", user_rights, seatid)

	cc.ui.UIPushButton.new({normal=PDKImgs.room_head_bg, pressed=PDKImgs.room_head_bg},{scale9 = false})
	 :addTo(self)
	 :onButtonClicked(function( ... )
	 		if self.user then
	 			
				local icon = RequestBase:getStrDecode(self.user.icon)
				local nick = RequestBase:getStrDecode(self.user.nickname)

	 			-- dump(self.ctx.model, "====11111111111====================================================")
	 			local mySeatNo = 0
	 			if self.ctx and self.ctx.model and self.ctx.model:getMySeatId() then
	 				mySeatNo = self.ctx.model:getMySeatId()
	 			end
	 			local currSeatNo = 0
	 			if self.data and self.data.seatNo then
	 				currSeatNo = self.data.seatNo
	 			end
	 			-- print("======================22222222222==================", mySeatNo, currSeatNo)

				-- CDAlertIP:popDialogBox(self.ctx.scene, icon, nick, self.user.account, self.user.ip, user_rights):addTo(CEnum.ZOrder.common_dialog)
				SupEmojiDialog.new(icon, nick, self.user.account, self.user.ip, user_rights, 
                        mySeatNo, currSeatNo):addTo(self.ctx.scene, CEnum.ZOrder.common_dialog)
			end
	end)
    --  :pos(90/2,92/2+3)
	

	-- 昵称
    self.nameTxt_ = display.newTTFLabel({
	        text = "thinker",
	        font = Fonts.Font_hkyt_w7,
	        size = Dimens.TextSize_20,
	        color = display.COLOR_WHITE,
	        align = cc.ui.TEXT_ALIGN_CENTER,
            valign = cc.ui.TEXT_VALIGN_CENTER,
	        dimensions = cc.size(120,25)
	    })
        :addTo(self)
	    :pos(0, -BG_HEIGHT/2-10)

	self.score_ = display.newTTFLabel({
	        text = "分数:10000",
	        font = Fonts.Font_hkyt_w7,
	        size = Dimens.TextSize_20,
	        --color = display.COLOR_WHITE,
	        color = Colors:_16ToRGB(Colors.gameing_score),
	        align = cc.ui.TEXT_ALIGN_CENTER,
            valign = cc.ui.TEXT_VALIGN_CENTER,
	        dimensions = cc.size(146,50)
	    })
        :addTo(self)
	    :align(display.LEFT_TOP, -146/2, -BG_HEIGHT/2-10)

	
	self.dealer_icon_ = display.newSprite(PDKImgs.dealer_icon)
		:addTo(self, 99)
		:pos(-90/2+50/2 -0, 93/2-50/2 -0)
		:hide()

	self.off_lineBtn_ = cc.ui.UIPushButton.new(Imgs.gameing_user_offile_R,{scale9=false})
        :addTo(self)
        :pos(-90/2+50-5,63)
        :setButtonEnabled(false)
        :setButtonLabel(EnStatus.disabled, cc.ui.UILabel.new({
            UILabelType = 2,
            text = "离线",
            font = Fonts.Font_hkyt_w7,
            size = Dimens.TextSize_20,
            color = Colors.gray,
            --color = Colors:_16ToRGB(Colors.gameing_roomNo),
            align = cc.ui.TEXT_ALIGN_CENTER,
            valign = cc.ui.TEXT_VALIGN_TOP,
         }))
       :hide()

    if seatid == CEnumP.seatNo.me then
    	self.off_lineBtn_:pos(-90/2+50-5,63)
    elseif seatid == CEnumP.seatNo.R then
    	self.off_lineBtn_:pos(-90/2+50-5 - 80,23)
    elseif seatid == CEnumP.seatNo.L then
    	self.off_lineBtn_:pos(-90/2+50-5+80,23)
    end
end

--设置显示数据
function RoomSeat:setData(data)
	self.data = data
	if self.data.user then
		self.user = self.data.user
	end
	self.nameTxt_:setString(RequestBase:getStrDecode(data.user.nickname))
	self.score_:setString("分数:"..data.score)
	 --头像
	local img = RequestBase:getStrDecode(data.user.icon)
	--防止重复加载同一图片路径的头像。
	if self.preImg == img then
		return
	end
	self.preImg = img

	if self.head_  then
		self.head_:removeFromParent()
		self.head_ = nil
	end

    self.head_ = NetSpriteImg.new(""..img, 72, 72) -- 78*78
        :addTo(self)
        :pos(0,3)
end

function RoomSeat:updateStatus(playerStatus)
	if playerStatus == "offline" then
		self.off_lineBtn_:show()
		VoiceDealUtil:playSound_other(Voices.file.gameing_sankai)
	else
		self.off_lineBtn_:hide()
	end
end

--设置分数
function RoomSeat:upDateScore(data)
	self.data = data
	self.score_:setString("分数:"..data.score)
end

--设置庄家
function RoomSeat:setDealer(isDealer)
	if isDealer then
		self.dealer_icon_:show()
	else
		self.dealer_icon_:hide()
	end
end

--显示牌
function RoomSeat:showCards(cardNum)
	local total = cardNum
	if self.cardsNode_ then
		self.cardsNode_:removeFromParent()
		self.cardsNode_ = nil
	end

	self.cardsNode_ = display.newNode()
	:addTo(self)
	:pos(0,-140)

	if cardNum<=0 then
		return
	end

	if cardNum>=10 then
		cardNum = 10
	end

	local index_y = 1
	for i=1,cardNum do
		index_y = i
		display.newSprite(PDKImgs.hand_cardNum_back)
		:addTo(self.cardsNode_)
		:pos(0,-(i*5))
	end

	local view,len = self:createLeftNum(total)

	view:addTo(self.cardsNode_)
	:pos(0,-index_y*5-5)

	if len>1 then
		view
		:pos(-10,-index_y*5-5)

	end
	
end
--隐藏牌
function RoomSeat:hideCards()
	if self.cardsNode_ then
		self.cardsNode_:removeFromParent()
		self.cardsNode_ = nil
	end
end

function RoomSeat:createLeftNum(num)
	local len = 1
	local view = display.newSprite()
    local _string = tostring(num)
    local _size = string.len(_string)
            for i=1,_size do
            	len = i
                local i_str = string.sub(_string, i, i)
                local img_i = PDKImgs.cardNum_shows..i_str..PDKImgs.img_suff
                cc.ui.UIImage.new(img_i,{scale9=false})
                    :addTo(view)
                    :align(display.CENTER, (i-1)*18, 0)
            end
    return view,len
end

function RoomSeat:onCleanup()
	
end

return RoomSeat