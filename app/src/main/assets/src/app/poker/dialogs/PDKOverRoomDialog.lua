--
-- Author: wh
-- Date: 2017-05-11 12:40:33
-- 跑得快游戏结束弹窗

-- 类申明
local PDKOverRoomDialog = class("PDKOverRoomDialog",
	function()
		return display.newNode()
	end
)

local osWidth = Commons.osWidth
local osHeight = Commons.osHeight

function PDKOverRoomDialog:ctor(resultData, callback)
	self.reusltData_ = resultData
	self.callback_ = callback

	-- local testURL = "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1496484409829&di=35fc4a7f2d2979798e4a2ab0e4a1e2ba&imgtype=0&src=http%3A%2F%2Fd.5857.com%2Fxgs_150428%2Fdesk_005.jpg"

	-- self.reusltData_ = {

	-- 	{user = {icon = testURL,nickname = "THINKER",account = "湖南",ip = "111.168.88.12"},
	-- 	 roundMaxScore = 100,
	-- 	 validBombCount = 10,
	-- 	 winCount = 10,
	-- 	 loseCount = 10,
	-- 	 score = 100,
	-- 	 bigWinner = true,
	-- 	},
	-- 	{user = {icon = testURL,nickname = "THINKER",account = "湖南",ip = "111.168.88.12"},
	-- 	 roundMaxScore = 100,
	-- 	 validBombCount = 10,
	-- 	 winCount = 10,
	-- 	 loseCount = 10,
	-- 	 score = 100,
	-- 	 bigWinner = true,
	-- 	},
	-- 	{user = {icon = testURL,nickname = "THINKER",account = "湖南",ip = "111.168.88.12"},
	-- 	 roundMaxScore = 100,
	-- 	 validBombCount = 10,
	-- 	 winCount = 10,
	-- 	 loseCount = 10,
	-- 	 score = 100,
	-- 	 bigWinner = true,
	-- 	}
	-- }

	self.pop_window = display.newColorLayer(cc.c4b(0, 0, 0, 100))       -- 半透明的黑色
    self.pop_window:setContentSize(osWidth, osHeight)             -- 设置Layer的大小,全屏出现
    self.pop_window:setTouchEnabled(true)
    self.pop_window:setTouchSwallowEnabled(true)  -- 吞噬下层的响应
    self.pop_window:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event) -- 点击此Layer时候输出信息,然后把自己销毁
        return true
    end)
    self.pop_window:addTo(self)


    self.alert_gaping_w = 0
    self.alert_gaping_h = 40


    -- 整个背景
	self.bg_ = display.newSprite(PDKImgs.game_over_bg)
		:addTo(self.pop_window)
		-- :center()
		-- :setContentSize(osWidth, osHeight -self.alert_gaping_h*2)
        :align(display.CENTER_BOTTOM, display.cx, 20)

	-- if CVar._static.isIphone4 then
 --        self.bg_:scale(.85)
 --    elseif CVar._static.isIpad then
 --        self.bg_:scale(.7)
 --    end
    local contentSize = self.bg_:getContentSize()


    -- title
    display.newSprite(PDKImgs.game_over_title_logo)
        :addTo(self.pop_window)
        -- :pos(display.cx, display.cy+392/2 -20)
        -- :addTo(self.bg_)
        :align(display.CENTER_TOP, display.cx, osHeight -self.alert_gaping_h+26)


    local moveX = 0
    if CVar._static.isIphone4 then
        moveX = -50
    elseif CVar._static.isIpad then
        moveX = -50
    end
    self.roomTxt = display.newTTFLabel({
	        text = "房号: "..CVar._static.roomNo,
	        font = Fonts.Font_hkyt_w7,
	        size = Dimens.TextSize_20,
	        color = Colors:_16ToRGB( Colors.round_nickname ),
	        align = cc.ui.TEXT_ALIGN_LEFT,
            valign = cc.ui.TEXT_VALIGN_CENTER,
	        --dimensions = cc.size(120,25)
	    })
        :addTo(self.pop_window)
        -- :align(display.CENTER)
        -- :pos(140, contentSize.height-80) 
        :align(display.CENTER_TOP, 140 +moveX, osHeight -self.alert_gaping_h -45 -15)

    if CVar._static.isIphone4 then
        moveX = -50
    elseif CVar._static.isIpad then
        moveX = -100
    end    
    local myDate = os.date("%Y-%m-%d %H:%M") --
    self.timeTxt = display.newTTFLabel({
	        text = myDate,
	        font = Fonts.Font_hkyt_w7,
	        size = Dimens.TextSize_20,
	        color = Colors:_16ToRGB( Colors.round_nickname ),	        
	        align = cc.ui.TEXT_ALIGN_LEFT,
            valign = cc.ui.TEXT_VALIGN_CENTER,
	        --dimensions = cc.size(120,25)
	    })
        :addTo(self.pop_window)
        -- :align(display.CENTER)
        -- :pos(contentSize.width-170, contentSize.height-80) 
        :align(display.CENTER_RIGHT, osWidth -140 -moveX, osHeight -self.alert_gaping_h -45 -25)
    

    -- 关闭按钮 = close弹窗
    -- local moveX = 0
    if CVar._static.isIphone4 then
        moveX = -100
    elseif CVar._static.isIpad then
        moveX = -160
    end
    cc.ui.UIPushButton.new({normal=PDKImgs.tableOver_over_close_btn, pressed=PDKImgs.tableOver_over_close_btn},{scale9=false})
        :onButtonClicked(function(e)
            VoiceDealUtil:playSound_other(Voices.file.ui_click)
            if self.callback_ then
            	self.callback_()
            end
            self:removeFromParent()
        end)
        -- :align(display.CENTER, contentSize.width, contentSize.height-30)
    	-- :addTo(self.bg_)
    	:align(display.CENTER_TOP, display.cx +contentSize.width/2.1 +moveX, osHeight -self.alert_gaping_h +30)
    	:addTo(self.pop_window)

    if #self.reusltData_ == 2 then
    	self:createItem(self.reusltData_[1]):addTo(self.bg_):pos(contentSize.width/2 -365-15 +100, contentSize.height/2 -30)
	    self:createItem(self.reusltData_[2]):addTo(self.bg_):pos(contentSize.width/2 +356+15 -100, contentSize.height/2 -30)
    else
	    self:createItem(self.reusltData_[1]):addTo(self.bg_):pos(contentSize.width/2 -356-15, contentSize.height/2 -30)
	    self:createItem(self.reusltData_[2]):addTo(self.bg_):pos(contentSize.width/2, contentSize.height/2 -30)
	    self:createItem(self.reusltData_[3]):addTo(self.bg_):pos(contentSize.width/2 +356+15, contentSize.height/2 -30)
	end

	-- 确定按钮 = 分享
    self.submitBtn = cc.ui.UIPushButton.new({normal=PDKImgs.share_game_btn_nor, pressed=PDKImgs.share_game_btn_pre},{scale9=false})
        :onButtonClicked(function(e)
            VoiceDealUtil:playSound_other(Voices.file.ui_click)
            self:myConfim()
            --self:removeFromParent()
        end)
        -- :align(display.CENTER, contentSize.width/2, display.cy-contentSize.height/2+ 65)
    	-- :addTo(self.bg_)
    	:align(display.CENTER_BOTTOM, display.cx, 35)
        :addTo(self.pop_window)
end

function PDKOverRoomDialog:createItem(data)
	--dump(data,"gameOverDataItem")

	if data == nil then return display.newNode() end

	local node = display.newNode()
	local node_w = 335
	local node_h = 400

	-- 整个背景框
	local bg = --display.newSprite(PDKImgs.game_over_item):addTo(node)
		cc.ui.UIImage.new(PDKImgs.game_over_item,{scale9=false})
  		 	:setLayoutSize(node_w, node_h)
			:addTo(node)
			:align(display.LEFT_BOTTOM, -365/2, -340/2)

	-- 头像背景框
	local head_bg = display.newSprite(PDKImgs.room_head_bg)
		:addTo(node)
		:pos(-115,165)

	 --头像
    NetSpriteImg.new(RequestBase:getStrDecode(data.user.icon), 72, 72) -- 78*78
	    :addTo(head_bg)
	    :pos(90/2,92/2+2)

    if data.owner == true then
	    display.newSprite(PDKImgs.gameover_fangzhu_title)
	    :addTo(head_bg)
	    :pos(25,70)
	end

	local font_color = cc.c3b(0x94,0x94,0x61)
    --名字
    local name = RequestBase:getStrDecode(data.user.nickname)
    cc.ui.UILabel.new({
	    	text =name,  
	    	font = Fonts.Font_hkyt_w7,
	        size = Dimens.TextSize_20,
	        color = font_color,
	        -- color = Colors:_16ToRGB(Colors.help_txt),
	        align = cc.ui.TEXT_ALIGN_LEFT,
	        dimensions = cc.size(180,25)
	        })
		:addTo(node)
		:pos(-50,190)

	--ID
	cc.ui.UILabel.new({
			text = "ID："..data.user.account,  
			font = Fonts.Font_hkyt_w7,
	        size = Dimens.TextSize_20,
	        color = font_color,
	        -- color = Colors:_16ToRGB(Colors.round_nickname),
	        align = cc.ui.TEXT_ALIGN_LEFT,
	        dimensions = cc.size(180,25)
	        })
		:addTo(node)
		:pos(-50,160)

  -- IP
	cc.ui.UILabel.new({
			text = "IP："..data.user.ip,  
			font = Fonts.Font_hkyt_w7,
	        size = Dimens.TextSize_20,
	        color = font_color,
	        -- color = Colors:_16ToRGB(Colors.round_nickname),
	        align = cc.ui.TEXT_ALIGN_LEFT,
	        dimensions = cc.size(180,25)
	        })
		:addTo(node)
		:pos(-50,130)

	local item_bg_w = 350
	local item_bg_h = 55
------------单局最高分----
	local high_score_bg = display.newSprite(PDKImgs.gameover_zhanji_bg)
		:addTo(node)
		:pos(0,80)
		:setContentSize(item_bg_w, item_bg_h)

	display.newSprite(PDKImgs.gameover_high_score_title)
		:addTo(high_score_bg)
		:pos(128/2+10,28)
	-- line
    cc.ui.UIImage.new(Imgs.over_room_th_line)
        :setLayoutSize(node_w -20, 2)
        :pos(-10,28 -25)
        :addTo(high_score_bg)

	local view,len = self:createLeftNum(tonumber(data.roundMaxScore))
		view:addTo(high_score_bg)
		:pos(175,28)


------------炸弹数----
	local zhadan_bg = display.newSprite(PDKImgs.gameover_zhanji_bg)
		:addTo(node)
		:pos(0,80 - (54+15))
		:setContentSize(item_bg_w, item_bg_h)
	
	display.newSprite(PDKImgs.gameover_zhadan_title)
		:addTo(zhadan_bg)
		:pos(107/2+10,28)
	-- line
    cc.ui.UIImage.new(Imgs.over_room_th_line)
        :setLayoutSize(node_w -20, 2)
        :pos(-10,28 -25)
        :addTo(zhadan_bg)

	local view,len = self:createLeftNum(tonumber(data.validBombCount))
		view:addTo(zhadan_bg)
		:pos(175,28)


------------输赢情况----
	local winLose_bg = display.newSprite(PDKImgs.gameover_zhanji_bg)
		:addTo(node)
		:pos(0,80 - 2*(54+15))
		:setContentSize(item_bg_w, item_bg_h)
	
	display.newSprite(PDKImgs.gameover_winLose_title)
		:addTo(winLose_bg)
		:pos(107/2+10,28)
	-- line
    cc.ui.UIImage.new(Imgs.over_room_th_line)
        :setLayoutSize(node_w -20, 2)
        :pos(-10,28 -25)
        :addTo(winLose_bg)

	local view = self:createWinLose(tonumber(data.winCount),tonumber(data.loseCount))
		view:addTo(winLose_bg)
		:pos(175,28)


------------总分----
	local total_score_bg = display.newSprite(PDKImgs.gameover_zhanji_bg)
		:addTo(node)
		:pos(0,80 - 3*(54+15))
		:setContentSize(item_bg_w, item_bg_h)

	display.newSprite(PDKImgs.gameover_total_score_title)
		:addTo(total_score_bg)
		:pos(107/2+10,28)
	-- line
    cc.ui.UIImage.new(Imgs.over_room_th_line)
        :setLayoutSize(node_w -20, 2)
        :pos(-10,28 -25)
        :addTo(total_score_bg)

	local view,len = self:createLeftNum(tonumber(data.score))--
		view:addTo(total_score_bg)
		:pos(175,28)

	if data.bigWinner==true then
		display.newSprite(PDKImgs.gameover_win_icon)
		:addTo(node)
		:pos(-20, 80 -4*(54+15)+5)
	end

	return node
end

function PDKOverRoomDialog:createLeftNum(num)
	local len = 1
	local view = display.newSprite()
    local _string = tostring(num)
    local _size = string.len(_string)

    local index = 1
    if num<0 then
    	index = 2
    	cc.ui.UIImage.new(PDKImgs.gameover_nums_fuhao,{scale9=false})
        :addTo(view)
        :align(display.CENTER, -10, 0)
    end


    for i=index,_size do
        len = i
        local i_str = string.sub(_string, i, i)
        local img_i = PDKImgs.gameover_nums_shows..i_str..PDKImgs.img_suff
        cc.ui.UIImage.new(img_i,{scale9=false})
        :addTo(view)
        :align(display.CENTER, (i-1)*18, 0)
    end
    return view,len
end

function PDKOverRoomDialog:createWinLose(win,lose)

	local view = display.newSprite()

	local winView,winLen = self:createLeftNum(win)
	winView:addTo(view)

	display.newSprite(PDKImgs.gameover_nums_win_word)
		:addTo(view)
		:pos(winLen*18+10, 0)

	local loseView,loseLen = self:createLeftNum(lose)
		loseView:addTo(view)
		:pos(winLen*18+10 +30,0)

	display.newSprite(PDKImgs.gameover_nums_lose_word)
		:addTo(view)
		:pos(winLen*18+10 +30 + loseLen*18+10, 0)

	return view
end

function PDKOverRoomDialog:myConfim()
    --self.parent:removeChild(self.pop_window)
    --self:myExit()

    self.submitBtn:setButtonEnabled(false)
    self:performWithDelay(function () 
           self.submitBtn:setButtonEnabled(true)
    end, 1.0)

    local function GameingOverRoomDialog_upLoadImgBack(server_url)
        Commons:printLog_Info("上传文件完成之后的远程地址是：", server_url)
        Commons:gotoShareWX_Img(server_url)
    end
    CutScreenUtil:cutScreen(GameingOverRoomDialog_upLoadImgBack, self, true, CVar._static.roomNo)
end
return PDKOverRoomDialog