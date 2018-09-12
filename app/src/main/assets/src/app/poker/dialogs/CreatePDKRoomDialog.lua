--
-- Author: wh
-- Date: 2017-05-10 12:40:33
-- 创建房间

-- 类申明
local CreatePDKRoomDialog = class("CreatePDKRoomDialog",
	function()
		return display.newNode()
	end
)


local osWidth = Commons.osWidth
local osHeight = Commons.osHeight

local alert_gaping_w
local alert_gaping_h

local DIALOG_WIDTH = 1152
local DIALOG_HEIGHT = 701

local WANFA_16 = "一副扑克去掉大小王、3个2（留黑桃2）、1个方块A。\n共48张，每人16张。\n首局黑桃3先出"
local WANFA_15 = "一副扑克去掉大小王、3个2（留黑桃2）、3个A（留黑桃A）、1个方块K。\n共45张，每人15张。\n首局黑桃3先出\n"
local WANFA_SJ = "一副扑克去掉大小王，再从52张牌中随机抽出4张后发牌。\n共48张，每人16张。\n若黑桃3被抽中，则黑、红、梅、方依次往后推至黑桃4先出"

-- 代号
local rounds_code = 1
local person_code = 2
local showCard_code = 3
local leftHand_code = 4
local zhaNiao_code = 5

-- 一些公用变量
local imagesRadio = {on=PDKImgs.pdk_wanfa_selected_btn, off=PDKImgs.pdk_un_select_btn}
local gaping_x = 25 -- 文字和按钮的相距距离
local font_ziti = Fonts.Font_hkyt_w7
local font_size = Dimens.TextSize_30
local font_color = cc.c3b(0x56, 0x0a, 0x0a) -- Colors.edit_txt

function CreatePDKRoomDialog:createViewByLine(tag, parent_view, 
                        first_btn_str, second_btn_str, third_btn_str, four_btn_str,
                        first_btn_img, second_btn_img, third_btn_img, four_btn_img,
                        first_btn_x, first_btn_y) 

    
    local talbe_8_btn, talbe_16_btn, talbe_24_btn, talbe_36_btn

    local function talbe_btn_handler(tabIndex)
        if tabIndex == first_btn_str then
            talbe_8_btn:setButtonSelected(true)
            if talbe_16_btn then
                talbe_16_btn:setButtonSelected(false)
            end
            if talbe_24_btn then
                talbe_24_btn:setButtonSelected(false)
            end
            if talbe_36_btn then
                talbe_36_btn:setButtonSelected(false)
            end
        elseif tabIndex == second_btn_str then
            talbe_8_btn:setButtonSelected(false)
            if talbe_16_btn then
                talbe_16_btn:setButtonSelected(true)
            end
            if talbe_24_btn then
                talbe_24_btn:setButtonSelected(false)
            end
            if talbe_36_btn then
                talbe_36_btn:setButtonSelected(false)
            end
        elseif tabIndex == third_btn_str then
            talbe_8_btn:setButtonSelected(false)
            if talbe_16_btn then
                talbe_16_btn:setButtonSelected(false)
            end
            if talbe_24_btn then
                talbe_24_btn:setButtonSelected(true)
            end
            if talbe_36_btn then
                talbe_36_btn:setButtonSelected(false)
            end
        elseif tabIndex == four_btn_str then
            talbe_8_btn:setButtonSelected(false)
            if talbe_16_btn then
                talbe_16_btn:setButtonSelected(false)
            end
            if talbe_24_btn then
                talbe_24_btn:setButtonSelected(false)
            end
            if talbe_36_btn then
                talbe_36_btn:setButtonSelected(true)
            end
        end

        VoiceDealUtil:playSound_other(Voices.file.ui_click)

        if tag == rounds_code then
            self.roundNums = tabIndex
            GameState_VoiceSetting:setDataSingle(CEnumP.round.round, self.roundNums)
        elseif tag == person_code then
            self.personNums = tabIndex
            GameState_VoiceSetting:setDataSingle(CEnumP.person.person, self.personNums)
        elseif tag == showCard_code then
            self.showCard = tabIndex
            GameState_VoiceSetting:setDataSingle(CEnumP.showCard.showCard, self.showCard)
        elseif tag == leftHand_code then
            self.leftHand = tabIndex
            GameState_VoiceSetting:setDataSingle(CEnumP.leftHand.leftHand, self.leftHand)
        elseif tag == zhaNiao_code then
            self.zhaNiao = tabIndex
            GameState_VoiceSetting:setDataSingle(CEnumP.zhaNiao.zhaNiao, self.zhaNiao)
        end

    end

    local startX_move = 200
    if tag == rounds_code then
        startX_move = 120
    elseif tag == person_code then
        startX_move = 120
    end

    -- 8
    local startX_8 = first_btn_x
    local startY_8 = first_btn_y
    talbe_8_btn = cc.ui.UICheckBoxButton.new(imagesRadio)
        :setButtonLabel(cc.ui.UILabel.new({
            text = first_btn_img,  
            font = font_ziti,
            size = font_size,
            color = font_color
        }))
        :setButtonLabelOffset(gaping_x, 0)
        :setButtonSelected(true)
        :onButtonClicked(function(event)
          talbe_btn_handler(first_btn_str)
        end)
        :align(display.LEFT_TOP, startX_8, startY_8-5)
        :addTo(parent_view)
    -- cc.ui.UIPushButton.new(
    --         first_btn_img, {scale9=false})
    --         :onButtonClicked(function(e)
    --             talbe_btn_handler(first_btn_str)
    --         end)
    --         :align(display.LEFT_TOP, startX_8 +gapX, startY_8)
    --         :addTo(parent_view)
    -- cc.ui.UIImage.new(first_btn_img)
    -- -- 背景
    -- cc.ui.UIPushButton.new(bg_img, {scale9=true})
    --     :setButtonSize(size_w -moveX, size_h)
    --     :onButtonClicked(function(e)
    --         talbe_btn_handler(first_btn_str)
    --     end)
    --     :align(display.LEFT_TOP, startX_8, startY_8) -- 414 154
    --     :addTo(parent_view)

    -- 16
    if second_btn_str then
        startX_8 = first_btn_x +startX_move
        startY_8 = first_btn_y
        talbe_16_btn = cc.ui.UICheckBoxButton.new(imagesRadio)
            :setButtonLabel(cc.ui.UILabel.new({
                text = second_btn_img,  
                font = font_ziti,
                size = font_size,
                color = font_color
            }))
            :setButtonLabelOffset(gaping_x, 0)
            :setButtonSelected(true)
            :onButtonClicked(function(event)
              talbe_btn_handler(second_btn_str)
            end)
            :align(display.LEFT_TOP, startX_8, startY_8-5)
            :addTo(parent_view)
        -- cc.ui.UIPushButton.new(
        --         second_btn_img, {scale9=false})
        --         :onButtonClicked(function(e)
        --             talbe_btn_handler(second_btn_str)
        --         end)
        --         :align(display.LEFT_TOP, startX_8 +gapX, startY_8)
        --         :addTo(parent_view)
    end

    -- 24
    if third_btn_str then
        startX_8 = first_btn_x +startX_move*2.1
        startY_8 = first_btn_y
        talbe_24_btn = cc.ui.UICheckBoxButton.new(imagesRadio)
            :setButtonLabel(cc.ui.UILabel.new({
                text = third_btn_img,  
                font = font_ziti,
                size = font_size,
                color = font_color
            }))
            :setButtonLabelOffset(gaping_x, 0)
            :setButtonSelected(true)
            :onButtonClicked(function(event)
              talbe_btn_handler(third_btn_str)
            end)
            :align(display.LEFT_TOP, startX_8, startY_8-5)
            :addTo(parent_view)
        -- cc.ui.UIPushButton.new(
        --         third_btn_img, {scale9=false})
        --         :onButtonClicked(function(e)
        --             talbe_btn_handler(third_btn_str)
        --         end)
        --         :align(display.LEFT_TOP, startX_8 +gapX, startY_8)
        --         :addTo(parent_view)
    end

    -- 36
    if four_btn_str then
        startX_8 = first_btn_x +startX_move*3
        startY_8 = first_btn_y
        talbe_36_btn = cc.ui.UICheckBoxButton.new(imagesRadio)
            :setButtonLabel(cc.ui.UILabel.new({
                text = four_btn_img,  
                font = font_ziti,
                size = font_size,
                color = font_color
            }))
            :setButtonLabelOffset(gaping_x, 0)
            :setButtonSelected(true)
            :onButtonClicked(function(event)
              talbe_btn_handler(four_btn_str)
            end)
            :align(display.LEFT_TOP, startX_8, startY_8-5)
            :addTo(parent_view)
        -- cc.ui.UIPushButton.new(
        --         four_btn_img, {scale9=false})
        --         :onButtonClicked(function(e)
        --             talbe_btn_handler(four_btn_str)
        --         end)
        --         :align(display.LEFT_TOP, startX_8 +gapX, startY_8)
        --         :addTo(parent_view)
    end

    -- 记住用户的选择
    if tag == rounds_code then
        local _temp = GameState_VoiceSetting:getDataSingle(CEnumP.round.round)
        if _temp ~= nil and _temp==CEnumP.round._30 then
            talbe_8_btn:setButtonSelected(false)
            talbe_16_btn:setButtonSelected(false)
            talbe_24_btn:setButtonSelected(true)
            self.roundNums = _temp
        elseif _temp ~= nil and _temp==CEnumP.round._20 then
            talbe_8_btn:setButtonSelected(false)
            talbe_16_btn:setButtonSelected(true)
            talbe_24_btn:setButtonSelected(false)
            self.roundNums = _temp
        else
            talbe_8_btn:setButtonSelected(true)
            talbe_16_btn:setButtonSelected(false)
            talbe_24_btn:setButtonSelected(false)
            self.roundNums = CEnumP.round._10
            GameState_VoiceSetting:setDataSingle(CEnumP.round.round, self.roundNums)
        end

    elseif tag == person_code then
        local _temp = GameState_VoiceSetting:getDataSingle(CEnumP.person.person)
        if _temp ~= nil and _temp==CEnumP.person._2 then
            talbe_8_btn:setButtonSelected(false)
            talbe_16_btn:setButtonSelected(true)
            self.personNums = _temp
        else
            talbe_8_btn:setButtonSelected(true)
            talbe_16_btn:setButtonSelected(false)
            self.personNums = CEnumP.person._3
            GameState_VoiceSetting:setDataSingle(CEnumP.person.person, self.personNums)
        end

    elseif tag == showCard_code then
        local _temp = GameState_VoiceSetting:getDataSingle(CEnumP.showCard.showCard)
        if _temp ~= nil and _temp==CEnumP.showCard._1 then
            talbe_8_btn:setButtonSelected(false)
            talbe_16_btn:setButtonSelected(true)
            self.showCard = _temp
        else
            talbe_8_btn:setButtonSelected(true)
            talbe_16_btn:setButtonSelected(false)
            self.showCard = CEnumP.showCard._2
            GameState_VoiceSetting:setDataSingle(CEnumP.showCard.showCard, self.showCard)
        end

    elseif tag == leftHand_code then
        local _temp = GameState_VoiceSetting:getDataSingle(CEnumP.leftHand.leftHand)

        if _temp ~= nil and _temp==CEnumP.leftHand._1 then
            talbe_8_btn:setButtonSelected(false)
            talbe_16_btn:setButtonSelected(true)
            self.leftHand = _temp
        else
            talbe_8_btn:setButtonSelected(true)
            talbe_16_btn:setButtonSelected(false)
            self.leftHand = CEnumP.leftHand._2
            GameState_VoiceSetting:setDataSingle(CEnumP.leftHand.leftHand, self.leftHand)
        end

    elseif tag == zhaNiao_code then
        local _temp = GameState_VoiceSetting:getDataSingle(CEnumP.zhaNiao.zhaNiao)
        -- -- 为空的时候设置默认值
        -- if _temp == nil then
        --     _temp = self.zhaNiao
        --     GameState_VoiceSetting:setDataSingle(CEnumP.zhaNiao.zhaNiao, self.zhaNiao)
        -- end

        if _temp ~= nil and _temp==CEnumP.zhaNiao._2 then
            talbe_8_btn:setButtonSelected(false)
            talbe_16_btn:setButtonSelected(true)
            self.zhaNiao = _temp
        else
            talbe_8_btn:setButtonSelected(true)
            talbe_16_btn:setButtonSelected(false)
            self.zhaNiao = CEnumP.zhaNiao._1
            GameState_VoiceSetting:setDataSingle(CEnumP.zhaNiao.zhaNiao, self.zhaNiao)
        end

    end

end

function CreatePDKRoomDialog:ctor()

    --以下数据发送给服务器
    self.pokerWf = CEnumP.wf._2  --玩法种类
    self.roundNums = CEnumP.round._10 -- 10   --局数
    self.personNums = CEnumP.person._3 -- 3  --人数
    self.showCard = CEnumP.showCard._2 -- 2   --是否显示牌
    self.leftHand = CEnumP.leftHand._2 -- 2  --最后一手
    self.zhaNiao = CEnumP.zhaNiao._1 -- 1  --扎鸟
    self.payType = CEnumP.payType._1 -- 1  --支付方式

	local pop_window = display.newColorLayer(cc.c4b(0, 0, 0, 100))       -- 半透明的黑色
    pop_window:setContentSize(osWidth, osHeight)             -- 设置Layer的大小,全屏出现
    pop_window:setTouchEnabled(true)
    pop_window:setTouchSwallowEnabled(true)  -- 吞噬下层的响应
    pop_window:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event) -- 点击此Layer时候输出信息,然后把自己销毁
        return true
    end)
    pop_window:addTo(self)


    alert_gaping_w = 64
    alert_gaping_h = 0
    if CVar._static.isIphone4 then
        alert_gaping_w = alert_gaping_w -0
    elseif CVar._static.isIpad then
        alert_gaping_w = alert_gaping_w -0
    end


    --[[
    -- 整个底色背景
    self.content_ = cc.ui.UIImage.new(
        -- Imgs.dialog_bg_round,{scale9=true})
        Imgs.dialog_bg,{scale9=false})
        :addTo(pop_window)
    	:align(display.CENTER, display.cx, display.cy)
    	:setLayoutSize(osWidth-alert_gaping_w*2, osHeight-alert_gaping_h*2)
        -- :align(display.CENTER, display.cx, osHeight -alert_gaping_h-72/2)
        -- :setLayoutSize(osWidth-alert_gaping_w*2, 72)
    --]]

    self.content_ = 
        display.newSprite(PDKImgs.pdk_game_over_bg)
            :addTo(pop_window)
            :center()
            :setPositionY(display.cy - 10)
        -- cc.ui.UIImage.new(Imgs.dialog_content_bg,{})
        --     :addTo(self.content_)
        --     :align(display.CENTER, display.cx-alert_gaping_w, display.cy)
        --     :setLayoutSize(osWidth-alert_gaping_w*2-10*2, osHeight-alert_gaping_h*2)

    self.moveX_contentBg = 0
    if CVar._static.isIphone4 then
        self.content_:scale(0.85)
        self.moveX_contentBg = 100
    elseif CVar._static.isIpad then
        self.content_:scale(0.8)
        self.moveX_contentBg = 160
    end
    

    local contentSize = self.content_:getContentSize()

    -- 关闭
    cc.ui.UIPushButton.new(Imgs.dialog_exit,{scale9=false})
        :setButtonImage(EnStatus.pressed, Imgs.dialog_exit_press)
        :onButtonClicked(function(e)
            VoiceDealUtil:playSound_other(Voices.file.ui_click)
            self:removeFromParent()
        end)
        :align(display.CENTER, contentSize.width -40, contentSize.height-40)
    	:addTo(self.content_)


    -- 玩法介绍 bg
    self.wanfa_bg_ = -- display.newSprite(PDKImgs.pdk_wanfa_bg)
        -- :pos(361/2+180,605/2 +12)
        cc.ui.UIImage.new(PDKImgs.pdk_select_bg,{scale9=true})
            :setLayoutSize(361, 600)
            :align(display.LEFT_BOTTOM, display.cx-463+5 +self.moveX_contentBg, 15)
            :addTo(self.content_)

    -- 玩法介绍的 title
    display.newSprite(PDKImgs.pdk_how_play)
        :addTo(self.wanfa_bg_)
        :pos(358/2 , 600-35)

    -- 玩法介绍 文字内容
    self.wanfa_txt = display.newTTFLabel({
            text = "",
            font = Fonts.Font_hkyt_w7,
            size = Dimens.TextSize_30,
            color = cc.c3b(0x56, 0x0a, 0x0a),
            -- color = Colors.edit_txt,
            align = cc.ui.TEXT_ALIGN_LEFT,
            dimensions = cc.size(320,528)
        })
        :addTo(self.wanfa_bg_)
        -- :pos(361/2,528/2)
        :align(display.LEFT_TOP, 20, 528)

    
    -- 选择内容的大背景框
    self.select_bg_ = -- display.newSprite(PDKImgs.pdk_select_bg)
        cc.ui.UIImage.new(PDKImgs.pdk_select_bg,{scale9=true})
            :addTo(self.content_)
            -- :pos(361+180+588/2,605/2 +15)
            :setLayoutSize(580, 600)
            :align(display.LEFT_BOTTOM, display.cx-100 +self.moveX_contentBg, 15)

    -- 最大的玩法选择
    self.wanfa_16 = self:createTableBtn(PDKImgs.pdk_16_select_nor, PDKImgs.pdk_16_select_pre,
                function()
                    if self.pokerWf == CEnumP.wf._1 then return end

                    self.wanfa_txt:setString(WANFA_16)
                    self.pokerWf = CEnumP.wf._1

                    self:wanfa_16_show()
                    self:wanfa_15_hide()
                    self:wanfa_suiji_hide()

                    GameState_VoiceSetting:setDataSingle(CEnumP.wf.wf, self.pokerWf)
                end
            )
        :addTo(self.content_)
        :pos(159/2+27, 460)        

    self.wanfa_15 = self:createTableBtn(PDKImgs.pdk_15_select_nor, PDKImgs.pdk_15_select_pre,
                function()
                    if self.pokerWf == CEnumP.wf._2 then return end

                    self.wanfa_txt:setString(WANFA_15)
                    self.pokerWf = CEnumP.wf._2

                    self:wanfa_16_hide()
                    self:wanfa_15_show()
                    self:wanfa_suiji_hide()

                    GameState_VoiceSetting:setDataSingle(CEnumP.wf.wf, self.pokerWf)
                end

            )
        :addTo(self.content_)
        :pos(159/2+27, 550) 

    self.wanfa_suiji = self:createTableBtn(PDKImgs.pdk_rondom_nor, PDKImgs.pdk_rondom_pre,
                function()
                    if self.pokerWf == CEnumP.wf._3 then return end

                    self.wanfa_txt:setString(WANFA_SJ)
                    self.pokerWf = CEnumP.wf._3

                    self:wanfa_16_hide()
                    self:wanfa_15_hide()
                    self:wanfa_suiji_show()

                    GameState_VoiceSetting:setDataSingle(CEnumP.wf.wf, self.pokerWf)
                end
            )
        :addTo(self.content_)
        :pos(159/2+27, 370)

    -- 16张 15张 随机的初始状态
    self:setInitStatus()


    local y_rounds = 550
    local y_nums = 550 -82
    local y_showCard = 550 -82*2
    local y_leftCard = 550 -82*3
    local y_zhaniao = 550 -82*4
    -- local y_payType = 550 -82*5

    -- 局数选择 th
    display.newSprite(PDKImgs.pdk_talbe_num_select):addTo(self.select_bg_)
        :pos(25+138/2, y_rounds)

    --人数选择 th
    display.newSprite(PDKImgs.pdk_player_num_select):addTo(self.select_bg_)
        :pos(25+138/2, y_nums)

    -- 显示不显示底牌数量选择 th
    display.newSprite(PDKImgs.pdk_is_show_card):addTo(self.select_bg_)
        :pos(25+138/2, y_showCard)

    -- 三张任意带的选择 th
    display.newSprite(PDKImgs.pdk_left_card):addTo(self.select_bg_)
        :pos(25+138/2, y_leftCard)

    -- 扎鸟选择 th
    display.newSprite(PDKImgs.pdk_zhaniao):addTo(self.select_bg_)
        :pos(25+138/2, y_zhaniao)

    -- 支付方式选择 th
    -- display.newSprite(PDKImgs.pdk_pay_type):addTo(self.select_bg_)
    --     :pos(25+138/2, y_payType)


-----------------------------------局数选择---------------------------------------------华丽的分割线
    self:createViewByLine(rounds_code, self.select_bg_, 
                        CEnumP.round._10, CEnumP.round._20, CEnumP.round._30, nil,
                        CEnumP.round._10info, CEnumP.round._20info, CEnumP.round._30info, nil,
                        25+138+30, y_rounds +20)
-----------------------------------局数选择---------------------------------------------华丽的分割线


-----------------------------------人数选择---------------------------------------------华丽的分割线
    self:createViewByLine(person_code, self.select_bg_, 
                        CEnumP.person._3, CEnumP.person._2, nil, nil,
                        CEnumP.person._3info, CEnumP.person._2info, nil, nil,
                        25+138+30, y_nums +20)
-----------------------------------人数选择---------------------------------------------华丽的分割线


-----------------------------------功能选择---------------------------------------------华丽的分割线
    self:createViewByLine(showCard_code, self.select_bg_, 
                        CEnumP.showCard._2, CEnumP.showCard._1, nil, nil,
                        CEnumP.showCard._2info, CEnumP.showCard._1info, nil, nil,
                        25+138+30, y_showCard +20)
-----------------------------------功能选择---------------------------------------------华丽的分割线


-----------------------------------最后一手---------------------------------------------华丽的分割线
    self:createViewByLine(leftHand_code, self.select_bg_, 
                        CEnumP.leftHand._2, CEnumP.leftHand._1, nil, nil,
                        CEnumP.leftHand._2info, CEnumP.leftHand._1info, nil, nil,
                        25+138+30, y_leftCard +20)
-----------------------------------最后一手---------------------------------------------华丽的分割线


-----------------------------------扎鸟规则---------------------------------------------华丽的分割线
    self:createViewByLine(zhaNiao_code, self.select_bg_, 
                        CEnumP.zhaNiao._1, CEnumP.zhaNiao._2, nil, nil,
                        CEnumP.zhaNiao._1info, CEnumP.zhaNiao._2info, nil, nil,
                        25+138+30, y_zhaniao +20)
-----------------------------------扎鸟规则---------------------------------------------华丽的分割线


-----------------------------------房间支付---------------------------------------------华丽的分割线
    -- self:createViewByLine(zhaNiao_code, self.select_bg_, 
    --                     CEnumP.payType._1, CEnumP.payType._2, nil, nil,
    --                     CEnumP.payType._1info, CEnumP.payType._2info, nil, nil,
    --                     25+138+30, y_payType +20)
-----------------------------------房间支付---------------------------------------------华丽的分割线

    -- 确定按钮
    local submitBtn = cc.ui.UIPushButton.new(Imgs.dialog_btn_confim,{scale9=false})
        :setButtonImage(EnStatus.pressed, Imgs.dialog_btn_confim_press)
        :onButtonClicked(function(e)

            VoiceDealUtil:playSound_other(Voices.file.ui_click)
            self:createRoom()

        end)
        :align(display.CENTER, display.cx, 200)
        :addTo(self.select_bg_)
        :pos(588/2, 60+50)

    -- 定位信息
    self:getLgeLat()
end

function CreatePDKRoomDialog:getLgeLat()
    local function CreateRoomDialog_CallbackLua_LgeLat(lgeLat)
        if Commons:checkIsNull_str(lgeLat) then
            --CDAlertManu.new():popDialogBox(self.content_, lgeLat)
            local _lgeLat = string.split(lgeLat, ",")
            if type(_lgeLat)=="table" then
                local _size = #_lgeLat
                if _size == 2 then
                    CVar._static.Lge = _lgeLat[1]
                    CVar._static.Lat = _lgeLat[2]
                    -- CDAlertManu.new():popDialogBox(self.content_, "创建pdk房间："..CVar._static.Lge.."|"..CVar._static.Lat)
                end
            end
        end
    end
    Commons:getLgeLat(CreateRoomDialog_CallbackLua_LgeLat)
end

local loadingPop_window_createroom
function CreatePDKRoomDialog:createRoom()

------------------------
    -- self.pokerWf = self.select_wf 
    -- local playType
    -- if self.pokerWf == CEnumP.wf._1 then
    --     playType = "16"
    -- elseif self.pokerWf == CEnumP.wf._2 then
    --     playType = "15"
    -- else
    --     playType = "random"
    -- end
------------------------

    -- local rounds = self.roundNums
------------------------
    
    -- local num = self.personNums
------------------------

    -- local isDisplay = self.showCard
    -- if self.showCard == CEnumP.showCard._1 then
    --     isDisplay = "y"
    -- elseif self.showCard == CEnumP.showCard._2 then
    --     isDisplay = "n"
    -- end
------------------------

    -- local lastRule = self.leftHand
    -- if self.leftHand == CEnumP.leftHand._1 then
    --     lastRule = "limit"
    -- elseif self.leftHand == CEnumP.leftHand._2 then
    --     lastRule = "nolimit"
    -- end
-------------------------

    -- local birdRule = self.zhaNiao
    -- if self.zhaNiao == CEnumP.zhaNiao._1 then
    --     birdRule = "n"
    -- elseif self.zhaNiao == CEnumP.zhaNiao._2 then
    --     birdRule = "y"
    -- end
---------------------------

    -- local payRule  = self.payType
    -- if self.payType == CEnumP.payType._1 then
    --     payRule = "owner"
    -- elseif self.payType == CEnumP.payType._2 then
    --     payRule = "aa"
    -- end
---------------------------

    local param = {
        playType = self.pokerWf,
        num = self.personNums,
        rounds = self.roundNums,
        isDisplay = self.showCard,
        lastRule = self.leftHand,
        birdRule = self.zhaNiao,
        payRule = self.payType
    }

    loadingPop_window_createroom = CDAlertLoading.new():popDialogBox(self, Strings.hint_Loading)
    RequestPDKcreateRoom:createRoom(param,
        function(data)
            -- Commons:gotoPDKRoom()
            self:getCreateData(data)
        end
    )

end


function CreatePDKRoomDialog:getCreateData(jsonObj)
    if loadingPop_window_createroom~=nil and (not tolua.isnull(loadingPop_window_createroom)) then
        loadingPop_window_createroom:removeFromParent()
        loadingPop_window_createroom = nil
    end

    Commons:printLog_Info("resDataRoomCreate:::", jsonObj)

    if jsonObj~=nil then
        local status = jsonObj[ParseBase.status]
        local msg = RequestBase:getStrDecode(jsonObj[ParseBase.msg])
        Commons:printLog_Info("状态是：", status, "内容是：", msg)

        if status ~= nil and status == CEnum.status.success then
            local _data = jsonObj[ParseBase.data];
            if _data~=nil then

                local roomObj = _data[User.Bean.room]
                Commons:printLog_Info("房间号是：",roomObj[Room.Bean.roomNo],  "状态是：",roomObj[Room.Bean.status])

                if CEnum.Environment.needPoint_Socket_ip_port then
                    local tag = false
                    if roomObj ~= nil then
                        local roomServerUrl = RequestBase:getStrDecode(roomObj[Room.Bean.roomServerUrl])
                        if Commons:checkIsNull_str(roomServerUrl) then
                            Sockets.connect.ip = roomServerUrl
                        else
                            tag = true
                        end
                        local roomServerPort = roomObj[Room.Bean.roomServerPort]
                        if Commons:checkIsNull_number(roomServerPort) then
                            Sockets.connect.port = roomServerPort
                        else
                            tag = true
                        end
                        local roomShareUrl = RequestBase:getStrDecode(roomObj[Room.Bean.roomShareUrl])
                        if Commons:checkIsNull_str(roomShareUrl) then
                            Strings.gameing_share_jumpUrl = roomShareUrl
                            Strings.gameing_share_jumpUrl_ios = roomShareUrl
                        else
                            tag = true
                        end
                        Commons:printLog_Info("=====creat room=====socket ip port shareUrl：", Sockets.connect.ip, Sockets.connect.port, Strings.gameing_share_jumpUrl);
                    end
                end

                if tag then
                    -- 关闭当前弹窗，弹出错误
                    -- _parent:removeChild(_pop_window)
                    -- CreateRoomDialog:myExit()
                    --self:removeFromParent()
                    CDAlertManu.new():popDialogBox(self, Strings.hint_NoSocketIpPort)
                else

                    -- 记录房间信息
                    local roomNo = roomObj[Room.Bean.roomNo]
                    CVar._static.roomNo = roomNo 
                    GameStateUserGameing:setData(roomObj)

                    -- 关闭当前弹窗，进入房间页面
                    --  _parent:removeChild(_pop_window)
                    --CreateRoomDialog:myExit()
                    
                    -- local entTime = os.clock()--socket.gettime()
                    -- local _time = entTime - startTime
                    -- print("------------time：创建房间http请求回来耗时：".._time.." 秒")

                    -- startTime = os.clock()--socket.gettime()
                    Commons:gotoPDKRoom()
                    -- entTime = os.clock()--socket.gettime()
                    -- _time = entTime - startTime
                    -- print("------------time：登录房间socket，显示桌面耗时：".._time.." 秒")
                end
            end
        else
            -- 关闭当前弹窗，弹出错误
           -- _parent:removeChild(_pop_window)
            CDAlertManu.new():popDialogBox(self, msg);
          --  CreateRoomDialog:myExit()
        end
    end
end

function CreatePDKRoomDialog:setInitStatus()

    -- self.pokerWf = CEnumP.wf._1

    -- self.wanfa_txt:setString(WANFA_16)
    -- self.wanfa_16.unSelect_:hide()
    -- self.wanfa_16.select_:show()

    -- self.wanfa_15.unSelect_:show()
    -- self.wanfa_15.select_:hide()

    -- self.wanfa_suiji.unSelect_:show()
    -- self.wanfa_suiji.select_:hide()

    local _temp = GameState_VoiceSetting:getDataSingle(CEnumP.wf.wf)
    if _temp ~= nil and _temp==CEnumP.wf._3 then
        self.wanfa_txt:setString(WANFA_SJ)

        self:wanfa_16_hide()
        self:wanfa_15_hide()
        self:wanfa_suiji_show()

        self.pokerWf = _temp

    elseif  _temp ~= nil and _temp==CEnumP.wf._1 then
        self.wanfa_txt:setString(WANFA_16)

        self:wanfa_16_show()
        self:wanfa_15_hide()
        self:wanfa_suiji_hide()

        self.pokerWf = _temp
    else
        self.wanfa_txt:setString(WANFA_15)

        self:wanfa_16_hide()
        self:wanfa_15_show()
        self:wanfa_suiji_hide()

        self.pokerWf = CEnumP.wf._2
        GameState_VoiceSetting:setDataSingle(CEnumP.wf.wf, self.pokerWf)
    end
end

function CreatePDKRoomDialog:wanfa_16_hide()
    self.wanfa_16.unSelect_:show()
    self.wanfa_16.select_:hide()
end
function CreatePDKRoomDialog:wanfa_16_show()
    self.wanfa_16.unSelect_:hide()
    self.wanfa_16.select_:show()
end

function CreatePDKRoomDialog:wanfa_15_hide()
    self.wanfa_15.unSelect_:show()
    self.wanfa_15.select_:hide()
end
function CreatePDKRoomDialog:wanfa_15_show()
    self.wanfa_15.unSelect_:hide()
    self.wanfa_15.select_:show()
end

function CreatePDKRoomDialog:wanfa_suiji_hide()
    self.wanfa_suiji.unSelect_:show()
    self.wanfa_suiji.select_:hide()
end
function CreatePDKRoomDialog:wanfa_suiji_show()
    self.wanfa_suiji.unSelect_:hide()
    self.wanfa_suiji.select_:show()
end

function CreatePDKRoomDialog:createTableBtn(imgNor, imgPre, callback)

    local node = display.newSprite()

    cc.ui.UIPushButton.new({normal = Imgs.common_transparent_skin,pressed = Imgs.common_transparent_skin},{scale9 = true})
        :addTo(node)
        :setButtonSize(161,82)
        :onButtonClicked(
            function()
                VoiceDealUtil:playSound_other(Voices.file.ui_click)
                if callback then
                  callback()
                end
            end
        )

    -- local selectStutes = display.newSprite(PDKImgs.pdk_select_btn_pre)
    local selectStutes = display.newSprite(imgPre)
        :addTo(node)

    -- local unSelect = display.newSprite(PDKImgs.pdk_select_btn_nor)
    local unSelect = display.newSprite(imgNor)
        :addTo(node)
        :hide()

    -- display.newSprite()
    --     :addTo(node)

    node.select_ = selectStutes
    node.unSelect_ = unSelect

    return node
end

function CreatePDKRoomDialog:onExit()
end

return CreatePDKRoomDialog