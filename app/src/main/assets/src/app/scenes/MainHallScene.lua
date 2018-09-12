--
-- Author: lte
-- Date: 2016-10-12 15:43:55
-- 游戏首页

local MainHallScene = class("MainHallScene", function()
    return display.newScene("MainHallScene")
end)

local Layer1
local view_roomCard_have

local top_scheduler_homescene
local top_schedulerID_homescene

local osWidth = Commons.osWidth
local osHeight = Commons.osHeight

function MainHallScene:ctor()
    -- Commons:printLog_Info("MainHallScene arg1：", arg1, arg1.a, arg1.b)
    -- for k,v in pairs(arg1) do
    --      Commons:printLog_Info("MainHallScene k v::",k,v)
    -- end
    Commons:printLog_Info("==Home=CVar._static.token：", CVar._static.token)
    Commons:printLog_Info("==Home 屏幕宽", osWidth, "屏幕高", osHeight)

    -- 层
    Layer1 = display.newLayer()
    --local Layer1 = display.newColorLayer(Colors.layer_bg)
    --local Layer1 = display.newScale9Sprite(Imgs.c_default_img, 0, 0, cc.size(osWidth, osHeight))
        --:center()
        :pos(0, 0)
        :addTo(self)

    -- 整个底色背景
    --local homeBg = 
    display.newSprite(Imgs.mainHall_bg)
        :center()
        :addTo(Layer1)

    ---[[
    if Commons:checkIsNull_str(CVar._static.sysMsg) then
        local laba_moveX = 0
        if CVar._static.isIphone4 then
            laba_moveX=  90
        elseif CVar._static.isIpad then
            laba_moveX=  90
        elseif CVar._static.NavBarH_Android ~= CEnum.status.NavBarH_def then
            laba_moveX=  CVar._static.NavBarH_Android/2
        end

        -- 跑马灯的背景框
        local lab_bg = cc.ui.UIImage.new(Imgs.home_tip_text_bg,{})
            :addTo(Layer1)
            :align(display.LEFT_TOP, 165 +laba_moveX/2, display.cy+245)
            :setLayoutSize(osWidth-165*2 -laba_moveX, 46)
        
        -- 跑马灯的内容
        local lab_text = cc.ui.UILabel.new({
                text = CVar._static.sysMsg, 
                size = 28, 
                color = Colors.white,
                --color = Colors:_16ToRGB(Colors.help_txt),
                font = Fonts.Font_hkyt_w7,
                align = cc.ui.TEXT_ALIGN_LEFT,
                valign = cc.ui.TEXT_ALIGN_TOP,
            })
            -- :align(display.BOTTOM_LEFT, osWidth-165, display.cy+205)
            -- :addTo(Layer1)
            :align(display.LEFT_TOP, osWidth-170*2 -laba_moveX, 50)

        -- 跑马灯的内容 sc
        local lab_sc = cc.ui.UIScrollView.new({
                direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
                viewRect = {x = 0, y = 0, width = osWidth-170*2 -laba_moveX, height = 54 }, -- 设置显示区域
                --capInsets = {x = 0, y = 0, width = item_w, height = item_h }, -- 设置显示区域
                -- scrollbarImgH = Imgs.scroll_barH,
                -- scrollbarImgV = Imgs.scroll_bar,
                scrollbarImgH = Imgs.c_transparent,
                scrollbarImgV = Imgs.c_transparent,
                bgColor = cc.c4b(160, 160, 160, 0)
            })
            :setBounceable(false)
            --:onScroll(function (event)
            --end)
            :addScrollNode(lab_text)
            :addTo(Layer1)
            :align(display.LEFT_TOP, 170 +laba_moveX/2, display.cy+185)

        -- 跑马灯的背景框  含有点击事件的背景框
        local lab_bg2 = cc.ui.UIImage.new(Imgs.c_transparent,{})
            :addTo(Layer1)
            :align(display.LEFT_TOP, 165 +laba_moveX/2, display.cy+245)
            :setLayoutSize(osWidth-165*2 -laba_moveX, 46)
        lab_bg2:setTouchEnabled(true)
        -- lab_bg2:addNodeEventListener(cc.NODE_TOUCH_EVENT, function() end)

        -- 跑马灯实际的计算
        top_scheduler_homescene = Layer1:getScheduler()
        local speed = 3
        local init_x = lab_text:getPositionX()
        local function homeScene_onInterval(dt)
            local w = lab_text:getContentSize().width
            local x = lab_text:getPositionX()            
            --Commons:printLog_Info("-------------在滚动没-------------宽 x：", w, x, y)

            if x <= (-200 + (-w)) then
                lab_text:setPositionX(init_x)
                return
            end
            lab_text:setPositionX(x - speed)
        end
        top_schedulerID_homescene = top_scheduler_homescene:scheduleScriptFunc(homeScene_onInterval, 0.03, false)
    end
    --]]

    -- 人物信息
    -- 昵称 id 房卡信息
    display.newSprite(Imgs.home_user_head_bg_bottom)
        :align(display.LEFT_TOP, 100,osHeight-2)
        :addTo(Layer1)

    -- 头像
    local user = GameStateUserInfo:getData()
    local user_icon = "";
    local user_account = "";
    local user_nickname = "";
    local user_ip = "";
    local user_rights = ""; -- 用户是否拥有房卡
    local proxies = GameState_UserProxy:getData()
    if user ~= nil then
        user_icon = RequestBase:getStrDecode(user[User.Bean.icon])
        user_account = user[User.Bean.account]
        user_nickname = Commons:trim(RequestBase:getStrDecode(user[User.Bean.nickname]) )
        user_ip = RequestBase:getStrDecode(user[User.Bean.ip])
        user_rights = user[User.Bean.rights]
        Commons:printLog_Info("icon：", user_icon)
        Commons:printLog_Info("nickname:", user_nickname)
    end
    local user_head_bg = cc.ui.UIPushButton.new(Imgs.home_user_head_bg_top,{scale9=false})
        :align(display.LEFT_TOP, 8,osHeight-8)
        :addTo(Layer1)
        :onButtonClicked(function(e)
            CDAlertIP:popDialogBox(Layer1, user_icon, user_nickname, user_account, user_ip, user_rights, true)
            self:getRoomBalance_home()
        end)
    if user_icon ~= nil and user_icon ~= "" then
        NetSpriteImg.new(user_icon, 104, 100) -- 118*116
            :align(display.LEFT_TOP, 7, -8)
            :addTo(user_head_bg)
    end

    -- 昵称 id 房卡信息
    display.newTTFLabel({
        text = user_nickname,
        font = Fonts.Font_hkyt_w9,
        size = Dimens.TextSize_16,
        color = display.COLOR_WHITE,
        align = cc.ui.TEXT_ALIGN_LEFT,
        dimensions = cc.size(110,20)
    })
    :addTo(Layer1)
    :align(display.LEFT_TOP, 130, osHeight-8 -17)

    -- id信息
    display.newTTFLabel({
        text = ""..user_account,
        font = Fonts.Font_hkyt_w9,
        size = Dimens.TextSize_18,
        color = display.COLOR_WHITE,
        align = cc.ui.TEXT_ALIGN_LEFT,
        dimensions = cc.size(118,20)
    })
    :addTo(Layer1)
    :align(display.LEFT_TOP, 130, osHeight-8 -17 -22)


    -- 购买房卡
    local home_buy_roomcard_btn = cc.ui.UIPushButton.new(Imgs.home_btn_buy_roomcard,{scale9=false})
        --:setButtonSize(128, 50)
        -- :setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
        --  UILabelType = 2,
        --  text = "",
        --     size = Dimens.TextSize_30,
        --  color = Colors.btn_normal,
        --  }))
        -- :setButtonLabel(EnStatus.pressed, cc.ui.UILabel.new({
        --  UILabelType = 2,
        --  text = "",
        --     size = Dimens.TextSize_30,
        --  color = Colors.btn_press,
        --  }))
        :setButtonImage(EnStatus.pressed, Imgs.home_btn_buy_roomcard_press)
        :onButtonClicked(function(e)

            VoiceDealUtil:playSound_other(Voices.file.ui_click)
            BuyRoomcardDialog:popDialogBox(self, proxies)
            self:getRoomBalance_home()

        end)
        :align(display.LEFT_TOP, 110+ 8+118+14, osHeight-11)
        :addTo(Layer1)
    if CVar._static.appstoreSwitch == CEnum.appstoreSwitch.open then
        home_buy_roomcard_btn:setVisible(true)
    else
        home_buy_roomcard_btn:setVisible(false)
    end

    -- 房卡信息
    view_roomCard_have = 
        -- display.newTTFLabel({
        --     text = "房卡："..user_balance,
        --     font = Fonts.Font_hkyt_w9,
        --     size = Dimens.TextSize_16,
        --     color = display.COLOR_WHITE,
        --     align = cc.ui.TEXT_ALIGN_LEFT,
        --     dimensions = cc.size(118,20)
        -- })
        display.newNode()
        :addTo(Layer1)
        --:align(display.LEFT_TOP, 130, osHeight-8 -10 -20 -20)
    if CVar._static.appstoreSwitch == CEnum.appstoreSwitch.open then
        view_roomCard_have:setVisible(true)
    else
        view_roomCard_have:setVisible(false)
    end

    ---[[
    -- 转卡
    local giveCardView = cc.ui.UIPushButton.new(Imgs.home_btn_givecard,{scale9=false})
        --:setButtonSize(100, 50)
        -- :setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
        --  UILabelType = 2,
        --  text = "",
        --     size = Dimens.TextSize_30,
        --  color = Colors.btn_normal,
        --  }))
        -- :setButtonLabel(EnStatus.pressed, cc.ui.UILabel.new({
        --  UILabelType = 2,
        --  text = "",
        --     size = Dimens.TextSize_30,
        --  color = Colors.btn_press,
        --  }))
        :setButtonImage(EnStatus.pressed, Imgs.home_btn_givecard_press)
        :onButtonClicked(function(e)
            VoiceDealUtil:playSound_other(Voices.file.ui_click)
            GiveCardDialog:popDialogBox(self, user_account, true)
        end)
        :align(display.LEFT_TOP, 14, osHeight-130)
        :addTo(Layer1)
        :hide()
    if CVar._static.appstoreSwitch == CEnum.appstoreSwitch.open then
        if user_rights ~= nil and Commons:checkIsNull_tableList(user_rights) then
            local tag = false
            for k,v in pairs(user_rights) do
                if v~=nil and v==CEnum.userRightsType.transCard then
                    tag = true
                    break
                end
            end
            if tag then
                giveCardView:show()
            end
        end
    end
    --]]

    local topScale = 1
    local moveX_title = 0
    if CVar._static.isIphone4 then
        topScale = 1
        moveX_title = -(69+15)*0.6
    elseif CVar._static.isIpad then
        topScale = 0.8
        moveX_title = -(69+15)*0.6
    end
    -- 标题
    local home_logo = 
    display.newSprite(Imgs.mainHall_title)
        :align(display.LEFT_TOP, 8+118+14 +164+14 +100+90 +moveX_title, osHeight-11)
        :addTo(Layer1)
        :setScale(topScale)

    local moveX = 0
    if CVar._static.isIphone4 then
        moveX = -(69+15)*2.5
    elseif CVar._static.isIpad then
        moveX = -(69+15)*4.0
    elseif CVar._static.NavBarH_Android ~= CEnum.status.NavBarH_def then
        moveX = -CVar._static.NavBarH_Android
    end

    ---[[
    -- 分享
    local home_share_btn = 
    cc.ui.UIPushButton.new(
        Imgs.home_btn_share,{scale9=false})
        --{normal = Imgs.home_btn_share, pressed = Imgs.home_btn_share_press},{scale9 = false})
        -- :setButtonSize(72, 100)
        -- :setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
        --  UILabelType = 2,
        --  text = "",
        --  size = Dimens.TextSize_30,
        --  color = Colors.btn_normal,
        --  }))
        -- :setButtonLabel(EnStatus.pressed, cc.ui.UILabel.new({
        --  UILabelType = 2,
        --  text = "",
        --  size = Dimens.TextSize_30,
        --  color = Colors.btn_press,
        --  }))
        :setButtonImage(EnStatus.pressed, Imgs.home_btn_share_press)
        :onButtonClicked(function(e)

            VoiceDealUtil:playSound_other(Voices.file.ui_click)
            ShareInfoDialog:popDialogBox(self)

        end)
        :align(display.LEFT_TOP, 8+118+14 +164+14 +100+90 +274+84 +(69+15)*2 +moveX,osHeight-11) -- osWidth-25*4-72*4
        -- :setScale(0.5)
        :addTo(Layer1)
    if CVar._static.appstoreSwitch == CEnum.appstoreSwitch.open then
        home_share_btn:setVisible(true)
    else
        home_share_btn:setVisible(false)
    end
    --]]


    ---[[
    -- 消息
    local home_im_btn = 
    cc.ui.UIPushButton.new(
        Imgs.home_btn_im,{scale9=false})
        :setButtonSize(72, 100)
        -- :setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
        --  UILabelType = 2,
        --  text = "",
        --  size = Dimens.TextSize_30,
        --  color = Colors.btn_normal,
        --  }))
        -- :setButtonLabel(EnStatus.pressed, cc.ui.UILabel.new({
        --  UILabelType = 2,
        --  text = "",
        --  size = Dimens.TextSize_30,
        --  color = Colors.btn_press,
        --  }))
        :setButtonImage(EnStatus.pressed, Imgs.home_btn_im_press)
        :onButtonClicked(function(e)

            VoiceDealUtil:playSound_other(Voices.file.ui_click)
            ImInfoDialog:popDialogBox(self)

        end)
        :align(display.LEFT_TOP, 8+118+14 +164+14 +100+90 +274+84 +(69+15)*4 +moveX,osHeight-11) -- osWidth-25*4-72*4
        :addTo(Layer1)

    local home_im_btn_red =
    --cc.ui.UIImage.new(Imgs.home_tip_text_red,{})
    cc.ui.UIPushButton.new(
        Imgs.home_tip_text_red,{scale9=false})
        --:setButtonSize(72, 100)
        :setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
             UILabelType = 2,
             text = "1",
             size = Dimens.TextSize_18,
             color = Colors.white,
         }))
        :setButtonLabel(EnStatus.pressed, cc.ui.UILabel.new({
             UILabelType = 2,
             text = "1",
             size = Dimens.TextSize_18,
             color = Colors.white,
         }))
        :setButtonImage(EnStatus.pressed, Imgs.home_tip_text_red)
        :addTo(Layer1)
        :align(display.LEFT_TOP, 8+118+14 +164+14 +100+90 +274+84 +(69+15)*4+53 +moveX, osHeight-6)
    --]]


    --[[
    -- 玩法
    local home_help_btn = 
    cc.ui.UIPushButton.new(
        Imgs.home_btn_help,{scale9=false})
        :setButtonSize(72, 100)
        -- :setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
        --  UILabelType = 2,
        --  text = "",
        --  size = Dimens.TextSize_30,
        --  color = Colors.btn_normal,
        --  }))
        -- :setButtonLabel(EnStatus.pressed, cc.ui.UILabel.new({
        --  UILabelType = 2,
        --  text = "",
        --  size = Dimens.TextSize_30,
        --  color = Colors.btn_press,
        --  }))
        :setButtonImage(EnStatus.pressed, Imgs.home_btn_help_press)
        :onButtonClicked(function(e)

            VoiceDealUtil:playSound_other(Voices.file.ui_click)
            HelpInfoDialog:popDialogBox(self)

        end)
        :align(display.LEFT_TOP, 8+118+14 +164+14 +100+90 +274+84 +(69+15)*2 +moveX,osHeight-11) -- osWidth-25*5-72*5
        :addTo(Layer1)
        :hide()
    --]]

    --[[
    -- 战绩
    local home_result_btn = 
    cc.ui.UIPushButton.new(
        Imgs.home_btn_result,{scale9=false})
        :setButtonSize(72, 100)
        -- :setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
        --  UILabelType = 2,
        --  text = "",
        --  size = Dimens.TextSize_30,
        --  color = Colors.btn_normal,
        --  }))
        -- :setButtonLabel(EnStatus.pressed, cc.ui.UILabel.new({
        --  UILabelType = 2,
        --  text = "",
        --  size = Dimens.TextSize_30,
        --  color = Colors.btn_press,
        --  }))
        :setButtonImage(EnStatus.pressed, Imgs.home_btn_result_press)
        :onButtonClicked(function(e)

            VoiceDealUtil:playSound_other(Voices.file.ui_click)
            ResultRoomDialog:popDialogBox(self)

        end)
        :align(display.LEFT_TOP, 8+118+14 +164+14 +100+90 +274+84 +(69+15)*3 +moveX,osHeight-11) -- osWidth-25*2-72*2
        :addTo(Layer1)
        :hide()
    --]]

    ---[[
    -- 设置
    local home_setting_btn = 
    cc.ui.UIPushButton.new(
        Imgs.home_btn_setting,{scale9=false})
        :setButtonSize(72, 100)
        -- :setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
        --  UILabelType = 2,
        --  text = "",
        --  size = Dimens.TextSize_30,
        --  color = Colors.btn_normal,
        --  }))
        -- :setButtonLabel(EnStatus.pressed, cc.ui.UILabel.new({
        --  UILabelType = 2,
        --  text = "",
        --  size = Dimens.TextSize_30,
        --  color = Colors.btn_press,
        --  }))
        :setButtonImage(EnStatus.pressed, Imgs.home_btn_setting_press)
        :onButtonClicked(function(e)

            VoiceDealUtil:playSound_other(Voices.file.ui_click)
            SettingDialog:popDialogBox(self)

        end)
        :align(display.LEFT_TOP, 8+118+14 +164+14 +100+90 +274+84 +(69+15)*3 +moveX,osHeight-11) -- osWidth-25*3-72*3
        :addTo(Layer1)
    --]]

    local moveX_2 = 0
    local moveY_2 = 0
    if CVar._static.isIphone4 or CVar._static.isIpad then
        moveX_2 = 40
        moveY_2 = -0
    end

    if CVar._static.isIpad then
        topScale = 0.86
    end

    ---[[
    -- 麻将
    local mjBtn = 
    cc.ui.UIPushButton.new(
        Imgs.mainHall_MJ_btn,{scale9=false})
        -- :setButtonSize(450, 485)
        -- :setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
        --  UILabelType = 2,
        --  text = "",
        --  size = Dimens.TextSize_30,
        --  color = Colors.btn_normal,
        --  }))
        -- :setButtonLabel(EnStatus.pressed, cc.ui.UILabel.new({
        --  UILabelType = 2,
        --  text = "",
        --  size = Dimens.TextSize_30,
        --  color = Colors.btn_press,
        --  }))
        :onButtonClicked(function(e)

            VoiceDealUtil:playSound_other(Voices.file.ui_click)
            CommonsM:gotoMJHome()
            --CDAlert.new():popDialogBox(self, "敬请期待")
        end)
        :onButtonPressed(function(event)
            event.target:setPositionY(display.cy-9 +moveY_2 -10)
        end)
        :onButtonRelease(function(event)
            event.target:setPositionY(display.cy-9 +moveY_2)
        end)
        :align(display.CENTER, display.cx-450/2-102/2-100 +moveX_2, display.cy-9 +moveY_2)
        :addTo(Layer1)
        :setScale(topScale)
    if CVar._static.appstoreSwitch == CEnum.appstoreSwitch.open then
        mjBtn:show()
    else
        mjBtn:hide()
    end
    --]]

    ---[[
    -- 字牌
    local ghzBtn = 
    cc.ui.UIPushButton.new(
        Imgs.mainHall_GHZ_btn,{scale9=false})
        -- :setButtonSize(450, 485)
        -- :setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
        --  UILabelType = 2,
        --  text = "",
        --  size = Dimens.TextSize_30,
        --  color = Colors.btn_normal,
        --  }))
        -- :setButtonLabel(EnStatus.pressed, cc.ui.UILabel.new({
        --  UILabelType = 2,
        --  text = "",
        --  size = Dimens.TextSize_30,
        --  color = Colors.btn_press,
        --  }))
        :onButtonClicked(function(e)

            VoiceDealUtil:playSound_other(Voices.file.ui_click)
            Commons:gotoHome()

        end)
        :onButtonPressed(function(event)
            event.target:setPositionY(display.cy-7 +moveY_2 -10)
        end)
        :onButtonRelease(function(event)
            event.target:setPositionY(display.cy-7 +moveY_2)
        end)
        :align(display.CENTER, display.cx, display.cy-7 +moveY_2)
        :addTo(Layer1)
        :setScale(topScale)
    --]]

    ---[[
    -- 扑克牌
    local pokerBtn = 
    cc.ui.UIPushButton.new(
        Imgs.mainHall_poker_btn,{scale9=false})
        -- :setButtonSize(450, 485)
        -- :setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
        --  UILabelType = 2,
        --  text = "",
        --  size = Dimens.TextSize_30,
        --  color = Colors.btn_normal,
        --  }))
        -- :setButtonLabel(EnStatus.pressed, cc.ui.UILabel.new({
        --  UILabelType = 2,
        --  text = "",
        --  size = Dimens.TextSize_30,
        --  color = Colors.btn_press,
        --  }))
        :onButtonClicked(function(e)

            VoiceDealUtil:playSound_other(Voices.file.ui_click)
            Commons:gotoPDKHome()

        end)
        :onButtonPressed(function(event)
            event.target:setPositionY(display.cy-0 +moveY_2 -10)
        end)
        :onButtonRelease(function(event)
            event.target:setPositionY(display.cy-0 +moveY_2)
        end)
        :align(display.CENTER, display.cx+450/2+102/2+100 -moveX_2, display.cy-0 +moveY_2)
        :addTo(Layer1)
        :setScale(topScale)
    if CVar._static.appstoreSwitch == CEnum.appstoreSwitch.open then
        pokerBtn:show()
    else
        pokerBtn:hide()
    end
    --]]

    -- 快速加入房间
    cc.ui.UIPushButton.new( {normal=Imgs.fast_join_btn_nor, pressed=Imgs.fast_join_btn_pre},{scale9 = false})
        :addTo(Layer1)
        :onButtonClicked(function(e)

            VoiceDealUtil:playSound_other(Voices.file.ui_click)
            JoinRoomDialog:popDialogBox(self)

        end)
        :align(display.BOTTOM_CENTER, display.cx, 80)

    -- 下面提示语句  健康游戏
    cc.ui.UILabel.new({
            UILabelType = 2, 
            --image = "",
            text = Strings.home_bottom,-- .. "aa再来一旦aa",
            size = Dimens.TextSize_17,
            color = Colors.black,
            font = Fonts.Font_hkyt_w9,
        })
        :align(display.CENTER, display.cx, 20)
        :addTo(Layer1)
end

function MainHallScene:onEnter()
    --Layer1:performWithDelay(function () 
    --end, 1.3)

        -- 苹果手机会出现播放现象，所以注释掉 VoiceDealUtil:preloadBgMusic()
        --VoiceDealUtil:preloadAllSound()

        -- if not audio.isMusicPlaying() then
        --     VoiceDealUtil:playBgMusic()
        -- else
        -- end
        VoiceDealUtil:stopBgMusic()
        -- VoiceDealUtil:playBgMusic()

        local language = GameState_VoiceSetting:getDataSingle(CEnum.voiceSetting.language)
        if language == nil then
            GameState_VoiceSetting:setDataSingle(CEnum.voiceSetting.language, CEnum.language.ax) -- 有2种选择，现在默认方言
        end

        -- 覆盖安装时候初始化 已经有的值
        local currStopSounds_temp = GameState_VoiceSetting:getDataSingle(CEnum.voiceSetting.currStopSounds)
        if currStopSounds_temp ~= nil then
            CVar._static.currStopSounds_init = currStopSounds_temp
        end

        local currSoundsVolume_temp = GameState_VoiceSetting:getDataSingle(CEnum.voiceSetting.currSoundsVolume)
        if currSoundsVolume_temp~=nil and currSoundsVolume_temp~=CEnum.musicStatus.def_fill then
        else
            GameState_VoiceSetting:setDataSingle(CEnum.voiceSetting.currSoundsVolume, CVar._static.soundVolumMax)
            --audio.setSoundsVolume(1.0)
            SettingDialog:mySetting_SoundVolume(CVar._static.soundVolumMax)
        end

    -- local coo = coroutine.create(function() 
    --     --for i=1,10 do Commons:printLog_Info("hahahahahaha") 
    --     --end
    --     VoiceDealUtil:preloadBgMusic()
    --     VoiceDealUtil:preloadAllSound()

    --     VoiceDealUtil:playBgMusic() 
    -- end)
    -- coroutine.resume(coo)
    -- Commons:printLog_Info("oh yeah,i am here")

    -- 每次进入大厅，都重新获取下用户钱包余额
    self:getRoomBalance_home()
end

function MainHallScene:getRoomBalance_home()
    RequestHome:getRoomBalance(nil, function(resJsonObj) MainHallScene:resDataRoomBalance_Home(resJsonObj) end )
end

function MainHallScene:resDataRoomBalance_Home(jsonObj)
    if jsonObj ~= nil then
        local status = jsonObj[ParseBase.status]
        local msg = RequestBase:getStrDecode(jsonObj[ParseBase.msg])
        Commons:printLog_Info("状态是：", status, "内容是：", msg)

        if status ~= nil and status==CEnum.status.success  then
            card_yushu = jsonObj[ParseBase.data][User.Bean.wallet][Wallet.Bean.balance]
            --Commons:printLog_Info("===",card_yushu, type(card_yushu))
            if card_yushu ~= nil then
                --view_roomCard_have:setString("房卡：".. tostring(card_yushu))

                if view_roomCard_have~=nil and (not tolua.isnull(view_roomCard_have)) and view_roomCard_have:getChildrenCount() > 0 then
                    view_roomCard_have:removeAllChildren()
                end

                if Commons:checkIsNull_numberType(card_yushu) then
                    -- 余额
                    local _string = tostring(card_yushu)
                    _size = string.len(_string)
                    for i=1,_size do
                        local i_str = string.sub(_string, i, i)
                        local img_i = GameingDealUtil:getNumImg_by_money(i_str)
                        local img_temp = 
                            cc.ui.UIImage.new(img_i,{scale9=false})
                                -- :setContentSize(15,24)
                            -- cc.ui.UIPushButton.new(img_i,{scale9=false})
                            --    :setButtonSize(15, 24)
                                :addTo(view_roomCard_have)
                                --:align(display.LEFT_TOP, 110+ 8+118+14 +50+19*(i-1), osHeight-26) -- 居zuo的做法
                                :align(display.CENTER, 110+ 8+118+14 +45 +(-14*_size/2) +50+14*(i-1), osHeight-36) -- 居中的做法
                    end
                end
            end
        end
    end
end

function MainHallScene:onExit()
    Commons:printLog_Info("MainHallScene:onExit")

    view_roomCard_have = nil
    
    Layer1 = nil

    if top_scheduler_homescene~=nil and top_schedulerID_homescene~=nil then
        top_scheduler_homescene:unscheduleScriptEntry(top_schedulerID_homescene)
        top_schedulerID_homescene = nil
        top_scheduler_homescene = nil
    end

    self:removeAllChildren()
end

return MainHallScene
