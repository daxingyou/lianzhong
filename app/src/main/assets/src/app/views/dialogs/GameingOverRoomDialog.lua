--
-- Author: lte
-- Date: 2016-11-07 22:48:53
-- 房间结束，有房间数据

-- 类申明
local GameingOverRoomDialog = class("GameingOverRoomDialog")


local osWidth = Commons.osWidth
local osHeight = Commons.osHeight

local submitBtn
local view_roomNo
local view_roomTime

local winOrOwner_view_layer_Room
local winOrOwner_view_ccbg_Room
local winOrOwner_view_icon_Room
local winOrOwner_view_owner_Room
local winOrOwner_view_nickname_Room
local winOrOwner_view_winlogo_Room
local winOrOwner_view_flz_Room

local R_view_layer_Room
local R_view_ccbg_Room
local R_view_icon_Room
local R_view_owner_Room
local R_view_nickname_Room
local R_view_winlogo_Room
local R_view_flz_Room

local L_view_layer_Room
local L_view_ccbg_Room
local L_view_icon_Room
local L_view_owner_Room
local L_view_nickname_Room
local L_view_winlogo_Room
local L_view_flz_Room

local moveX
local startY
local icon_view_w
local icon_view_h

local p_parent
local pop_window

local res_data_Room
local roomNo

-- 构造函数
function GameingOverRoomDialog:ctor()
end

-- 创建一个模态弹出框,  parent=要加在哪个上面
function GameingOverRoomDialog:popDialogBox(_parent, _res_data_Room)

    p_parent = _parent
    res_data_Room = _res_data_Room

    pop_window = display.newColorLayer(cc.c4b(0, 0, 0, 200))       -- 半透明的黑色

    pop_window:setContentSize(osWidth, osHeight)             -- 设置Layer的大小,全屏出现
    --pop_window:align(display.CENTER, display.cx, display.cy) -- Layer的锚点在0.5,0.5 因此对齐的时候要注意
    pop_window:setTouchEnabled(true)
    pop_window:setTouchSwallowEnabled(true)  -- 吞噬下层的响应
    pop_window:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event) -- 点击此Layer时候输出信息,然后把自己销毁
        return true
    end)
    _parent:addChild(pop_window, CEnum.ZOrder.common_dialog) -- 把Layer添加到父对象上


    moveX = 0
    startY = osHeight-14 -40 -20
    icon_view_w = 118
    icon_view_h = 116
    if CVar._static.isIphone4 then
        moveX = 60
        startY = osHeight-14 -40 -20
        icon_view_w = 90
        icon_view_h = 96
    elseif CVar._static.isIpad then
        moveX = 100
        startY = osHeight-14 -40 -20
        icon_view_w = 90
        icon_view_h = 96
    elseif CVar._static.NavBarH_Android ~= CEnum.status.NavBarH_def then
        moveX = CVar._static.NavBarH_Android/2 - 17
        startY = osHeight-14 -40 -20
        icon_view_w = 90
        icon_view_h = 96
    end


    ---[[
    -- 整个底色背景
    cc.ui.UIImage.new(Imgs.dialog_bg,{})
    	:addTo(pop_window)
    	:align(display.LEFT_TOP, 14, osHeight-14 -40)
    	:setLayoutSize(osWidth-14*2, osHeight-14*2 -40)
    --]]

    ---[[
    -- 内容背景
    cc.ui.UIImage.new(Imgs.dialog_content_bg,{})
        :addTo(pop_window)
        :align(display.LEFT_TOP, 14+10, startY -38)
        :setLayoutSize(osWidth-14*2 -10*2, osHeight-14*2 -40 -38 -120)
    --]]

    -- logo
    cc.ui.UIImage.new(Imgs.over_room_title_logo,{})
    --cc.ui.UIPushButton.new(Imgs.over_room_title_logo, {scale9 = false})
    --    :setButtonImage(EnStatus.pressed, Imgs.over_room_title_logo)
    --    :setButtonImage(EnStatus.disabled, Imgs.over_room_title_logo)
    	:addTo(pop_window)
    	--:center()
    	--:pos(display.cx, osHeight-80-56/2)
    	:align(display.CENTER, display.cx, osHeight-14 -60/2)
        --:setButtonEnabled(false)

    ---[[
    -- 关闭
    cc.ui.UIPushButton.new(Imgs.dialog_exit,{scale9=false})
        -- :setButtonSize(74, 74)
        -- :setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
        --     UILabelType = 2,
        --     text = "",--Strings.common_exit,
        --     size = Dimens.TextSize_30,
        --     color = Colors.btn_normal,
        --     }))
        -- :setButtonLabel(EnStatus.pressed, cc.ui.UILabel.new({
        --     UILabelType = 2,
        --     text = "",--Strings.common_exit,
        --     size = Dimens.TextSize_30,
        --     color = Colors.btn_press,
        --     }))
        :setButtonImage(EnStatus.pressed, Imgs.dialog_exit_press)
        :onButtonClicked(function(e)

            VoiceDealUtil:playSound_other(Voices.file.ui_click)
            GameingOverRoomDialog:myCancel()

        end)
    	:addTo(pop_window)
        :align(display.CENTER, 14+74/2, osHeight-14 -74/2)
        --:align(display.CENTER, 18+12+74/2, osHeight-16-14-74/2)
    --]]

    ---[[
    -- 确定按钮
    submitBtn = cc.ui.UIPushButton.new(
        Imgs.over_room_btn_share,{scale9=false})
        :setButtonSize(278, 94)
        -- :setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
        --     UILabelType = 2,
        --     text = "",
        --     size = Dimens.TextSize_30,
        --     color = Colors.btn_normal,
        --     }))
        -- :setButtonLabel(EnStatus.pressed, cc.ui.UILabel.new({
        --     UILabelType = 2,
        --     text = "",
        --     size = Dimens.TextSize_30,
        --     color = Colors.btn_press,
        --     }))
        :setButtonImage(EnStatus.pressed, Imgs.over_room_btn_share_press)
        :onButtonClicked(function(e)

            VoiceDealUtil:playSound_other(Voices.file.ui_click)
            GameingOverRoomDialog:myConfim()

        end)
        :align(display.CENTER_BOTTOM, display.cx, 14)
        :addTo(pop_window)
        :setScale(0.9)
    if CVar._static.appstoreSwitch == CEnum.appstoreSwitch.open then
        submitBtn:setVisible(true)
    else
        submitBtn:setVisible(false)
    end
    --]]

	-- view
    GameingOverRoomDialog:createView_winOrOwner()
    GameingOverRoomDialog:createView_R()
    GameingOverRoomDialog:createView_L()
	GameingOverRoomDialog:setViewData()

end

function GameingOverRoomDialog:myCancel()
    Commons:gotoHome()
    GameingOverRoomDialog:myExit()
end

function GameingOverRoomDialog:myConfim()

    submitBtn:setButtonEnabled(false)
    p_parent:performWithDelay(function () 
       submitBtn:setButtonEnabled(true)
    end, 1.0)
    -- submitBtn:hide()

    local function GameingOverRoomDialog_upLoadImgBack(server_url)
        -- submitBtn:show()
        -- submitBtn:setButtonEnabled(true)

        Commons:printLog_Info("上传文件完成之后的远程地址是：", server_url)
        Commons:gotoShareWX_Img(server_url)
    end
    CutScreenUtil:cutScreen(GameingOverRoomDialog_upLoadImgBack, p_parent, true, roomNo)
end

function GameingOverRoomDialog:createView_winOrOwner()

    -- 房间号
    view_roomNo = cc.ui.UILabel.new({
            UILabelType = 2,
            text = "",
            font = Fonts.Font_hkyt_w9,
            size = Dimens.TextSize_20,
            color = Colors.white,
            -- color = Colors:_16ToRGB(Colors.gameing_huxi),
            align = cc.ui.TEXT_ALIGN_LEFT,
            valign = cc.ui.TEXT_VALIGN_CENTER,
            dimensions = cc.size(200,25),
            --maxLineWidth = 118,
        })
        :addTo(pop_window)
        :align(display.LEFT_TOP, 14+30, startY-9)

    -- 当前手机时间
    local myDate = os.date("%Y-%m-%d %H:%M:%S") -- "%Y-%m-%d %H:%M:%S"
    view_roomTime = cc.ui.UILabel.new({
            UILabelType = 2,
            text = myDate,
            font = Fonts.Font_hkyt_w9,
            size = Dimens.TextSize_20,
            color = Colors.white,
            -- color = Colors:_16ToRGB(Colors.gameing_huxi),
            align = cc.ui.TEXT_ALIGN_RIGHT,
            valign = cc.ui.TEXT_VALIGN_CENTER,
            dimensions = cc.size(280,25),
            --maxLineWidth = 118,
        })
        :addTo(pop_window)
        :align(display.RIGHT_TOP, osWidth -14-20, startY-9)

    -- 层
    -- winOrOwner_view_layer_Room = display.newLayer() -- .newColorLayer(Colors.layer_bg)
    --     :setContentSize(600,508)
    --     :align(display.LEFT_TOP, 14+30, startY -38)
    --     :addTo(pop_window)
    winOrOwner_view_layer_Room = display.newNode():addTo(pop_window)
    

    -- 内容背景
    --cc.ui.UIImage.new(Imgs.,{})
    --    :setLayoutSize(600, 508)
    winOrOwner_view_ccbg_Room = cc.ui.UIPushButton.new(Imgs.over_room_bg_win,{scale9=false})
    	:setButtonImage(EnStatus.pressed, Imgs.over_room_bg_win)
        :setButtonSize(376 -moveX, 461)
        :addTo(winOrOwner_view_layer_Room)
        :align(display.LEFT_TOP, 14+30, startY -38 -18)

    -- 头像框
    local user_head_bg = --display.newSprite(Imgs.home_user_head_bg_top)
        cc.ui.UIImage.new(Imgs.home_user_head_bg_top,{scale9 = false})
        :align(display.LEFT_TOP, 14+30 +10 -moveX*0.05, startY -38 -18 -16)
        :setLayoutSize(icon_view_w, icon_view_h)
        :addTo(winOrOwner_view_layer_Room)
    -- local user_icon = 'http://wmq.res.apk.yuelaigame.com/test/icon1.jpg'
    -- if user_icon ~= nil and user_icon ~= "" then
    --     winOrOwner_view_icon_Room = NetSpriteImg.new(user_icon, 106, 100) -- 118*116
    --         --:setContentSize(cc.size(100,100))
    --         --:pos(8+106/2+6,osHeight-8-100/2-8)
    --         :align(display.LEFT_TOP,14+30 +10+6, startY -38 -18 -16-8)
    --         :addTo(winOrOwner_view_layer_Room)
    -- end

    -- 房主
    winOrOwner_view_owner_Room = --display.newSprite(Imgs.over_round_owner_logo)
        cc.ui.UIImage.new(Imgs.over_round_owner_logo,{scale9 = false})
        :align(display.LEFT_TOP, 14+30 +10 +60, startY -38 -18 -16 -60)
        -- :addTo(winOrOwner_view_layer_Room)
        -- :setVisible(false)
    if CVar._static.isIphone4 or CVar._static.isIpad or CVar._static.NavBarH_Android ~= CEnum.status.NavBarH_def then
        -- user_head_bg:setLayoutSize(icon_view_w, icon_view_h)
        winOrOwner_view_owner_Room:align(display.LEFT_TOP, 14+30 +10 +60 -moveX*0.05 -25, startY -38 -18 -16 -60+20)
    end

    -- 昵称
    winOrOwner_view_nickname_Room = cc.ui.UILabel.new({
            UILabelType = 2,
            text = "",
            font = Fonts.Font_hkyt_w9,
            size = Dimens.TextSize_25,
            color = Colors:_16ToRGB(Colors.gameing_huxi),
            align = cc.ui.TEXT_ALIGN_LEFT,
            valign = cc.ui.TEXT_VALIGN_CENTER,
            dimensions = cc.size(160,40),
            --maxLineWidth = 118,
        })
        :addTo(winOrOwner_view_layer_Room)
        :align(display.LEFT_TOP, 14+30 +120+28 -moveX*0.4, startY -38 -18 -16)

    -- id
    display.newSprite(Imgs.over_room_th_id)
        :align(display.LEFT_TOP, 14+30 +120+28 -moveX*0.4, startY -38 -18 -16 -50)
        :addTo(winOrOwner_view_layer_Room)
        :setScale(0.8)

    -- ip
    winOrOwner_view_ip_Room = display.newTTFLabel({
            text = "IP：",
            font = Fonts.Font_hkyt_w9,
            size = Dimens.TextSize_18,
            color = Colors:_16ToRGB(Colors.gameing_huxi),
            align = cc.ui.TEXT_ALIGN_LEFT,
            valign = cc.ui.TEXT_VALIGN_CENTER,
            --dimensions = cc.size(100,20)
        })
        :addTo(winOrOwner_view_layer_Room)
        :align(display.LEFT_TOP, 14+30 +120+28 -moveX*0.4, startY -38 -18 -16 -96)

    -- line
    -- display.newSprite(Imgs.over_room_th_line)
    cc.ui.UIImage.new(Imgs.over_room_th_line)
        :setLayoutSize(376-20 -moveX, 2)
        :align(display.LEFT_TOP, 14+30 +10 -moveX*0.4, startY -38 -18 -16 -96 -40)
        :addTo(winOrOwner_view_layer_Room)

    -- 分数
    display.newSprite(Imgs.over_room_th_score)
        :align(display.LEFT_TOP, 14+30 +10+45 -moveX*0.4, startY -38 -18 -16 -6-150 +10)
        :addTo(winOrOwner_view_layer_Room)
        :setScale(0.9)

    -- 胡牌次数
    display.newSprite(Imgs.over_room_th_hunums)
        :align(display.LEFT_TOP, 14+30 +10+45 -moveX*0.4, startY -38 -18 -16 -6-155 -70 +29)
        :addTo(winOrOwner_view_layer_Room)
        :setScale(0.9)

    -- 名堂次数
    display.newSprite(Imgs.over_room_th_mtnums)
        :align(display.LEFT_TOP, 14+30 +10+45 -moveX*0.4, startY -38 -18 -16 -6-155 -70 -70 +45)
        :addTo(winOrOwner_view_layer_Room)
        :setScale(0.9)

    -- 分溜子
    winOrOwner_view_flz_Room = display.newSprite(Imgs.over_room_th_flz)
        :align(display.LEFT_TOP, 14+30 +10+45 -moveX*0.4, startY -38 -18 -16 -6-155 -70 -70 -70 +60)
        :addTo(winOrOwner_view_layer_Room)
        :setScale(0.9)

    -- line
    -- display.newSprite(Imgs.over_room_th_line)
    cc.ui.UIImage.new(Imgs.over_room_th_line)
        :setLayoutSize(376-20 -moveX, 2)
        :align(display.LEFT_TOP, 14+30 +10 -moveX*0.4, startY -38 -18 -16 -6-155 -70 -70 -70 -40 +60)
        :addTo(winOrOwner_view_layer_Room)

    -- 大赢家图标
    winOrOwner_view_winlogo_Room = cc.ui.UIImage.new(Imgs.over_room_win_logo,{scale9=false})
        :addTo(winOrOwner_view_layer_Room)
        :align(display.LEFT_TOP, 14+30 +10+45 +39 -moveX*0.5, startY -38 -18 -16 -162-180)
end

-- 下家
function GameingOverRoomDialog:createView_R()
    -- 层
    -- R_view_layer_Room = display.newLayer() -- .newColorLayer(Colors.layer_bg)
    --     :setContentSize(600,508)
    --     :align(display.LEFT_TOP, 14+30, startY -38)
    --     :addTo(pop_window)
    R_view_layer_Room = display.newNode():addTo(pop_window)

    -- 内容背景
    --cc.ui.UIImage.new(Imgs.,{})
    --:setLayoutSize(600, 508/2-2)
    R_view_ccbg_Room = cc.ui.UIPushButton.new(Imgs.over_room_bg_win,{scale9=false})
    	:setButtonImage(EnStatus.pressed, Imgs.over_room_bg_win)
        :setButtonSize(376 -moveX, 461)
        :addTo(R_view_layer_Room)
        :align(display.LEFT_TOP, 14+30 +400 -moveX, startY -38 -18)

    -- 头像框
    local user_head_bg = --display.newSprite(Imgs.home_user_head_bg_top)
        cc.ui.UIImage.new(Imgs.home_user_head_bg_top,{scale9 = false})
        :align(display.LEFT_TOP, 14+30 +10 +400 -moveX*1.05, startY -38 -18 -16)
        :setLayoutSize(icon_view_w, icon_view_h)
        :addTo(R_view_layer_Room)
    -- local user_icon = 'http://wmq.res.apk.yuelaigame.com/test/icon1.jpg'
    -- if user_icon ~= nil and user_icon ~= "" then
    --     R_view_icon_Room = NetSpriteImg.new(user_icon, 106, 100) -- 118*116
    --         --:setContentSize(cc.size(100,100))
    --         --:pos(8+106/2+6,osHeight-8-100/2-8)
    --         :align(display.LEFT_TOP,14+30 +10+6 +400, startY -38 -18 -16-8)
    --         :addTo(R_view_layer_Room)
    -- end
    R_view_owner_Room = --display.newSprite(Imgs.over_round_owner_logo)
        cc.ui.UIImage.new(Imgs.over_round_owner_logo,{scale9 = false})
        :align(display.LEFT_TOP, 14+30 +10 +60 +400, startY -38 -18 -16 -60)
        -- :addTo(R_view_layer_Room)
        -- :setVisible(false)

    if CVar._static.isIphone4 or CVar._static.isIpad or CVar._static.NavBarH_Android ~= CEnum.status.NavBarH_def then
        -- user_head_bg:setLayoutSize(icon_view_w, icon_view_h)
        R_view_owner_Room:align(display.LEFT_TOP, 14+30 +10 +60 +400 -moveX*1.05 -25, startY -38 -18 -16 -60 +20)
    end

    -- 昵称
    R_view_nickname_Room = cc.ui.UILabel.new({
            UILabelType = 2,
            text = "",
            font = Fonts.Font_hkyt_w9,
            size = Dimens.TextSize_25,
            color = Colors:_16ToRGB(Colors.gameing_huxi),
            align = cc.ui.TEXT_ALIGN_LEFT,
            valign = cc.ui.TEXT_VALIGN_CENTER,
            dimensions = cc.size(160,40),
            --maxLineWidth = 118,
        })
        :addTo(R_view_layer_Room)
        :align(display.LEFT_TOP, 14+30 +120+28 +400 -moveX*1.4, startY -38 -18 -16)

    -- id
    display.newSprite(Imgs.over_room_th_id)
        :align(display.LEFT_TOP, 14+30 +120+28 +400 -moveX*1.4, startY -38 -18 -16 -50)
        :addTo(R_view_layer_Room)
        :setScale(0.8)

    -- ip
    R_view_ip_Room = display.newTTFLabel({
            text = "IP：",
            font = Fonts.Font_hkyt_w9,
            size = Dimens.TextSize_18,
            color = Colors:_16ToRGB(Colors.gameing_huxi),
            align = cc.ui.TEXT_ALIGN_LEFT,
            valign = cc.ui.TEXT_VALIGN_CENTER,
            --dimensions = cc.size(100,20)
        })
        :addTo(R_view_layer_Room)
        :align(display.LEFT_TOP, 14+30 +120+28 +400 -moveX*1.4, startY -38 -18 -16 -96)

    -- line
    -- display.newSprite(Imgs.over_room_th_line)
    cc.ui.UIImage.new(Imgs.over_room_th_line)
        :setLayoutSize(376-20 -moveX, 2)
        :align(display.LEFT_TOP, 14+30 +120+28 +250 -moveX*1.4, startY -38 -18 -16 -96 -40)
        :addTo(R_view_layer_Room)

    -- 分数
    display.newSprite(Imgs.over_room_th_score)
        :align(display.LEFT_TOP, 14+30 +120+28 +300 -moveX*1.4, startY -38 -18 -16 -6-150 +10)
        :addTo(R_view_layer_Room)
        :setScale(0.9)

    -- 胡牌次数
    display.newSprite(Imgs.over_room_th_hunums)
        :align(display.LEFT_TOP, 14+30 +120+28 +300 -moveX*1.4, startY -38 -18 -16 -6-155 -70 +29)
        :addTo(R_view_layer_Room)
        :setScale(0.9)

    -- 名堂次数
    display.newSprite(Imgs.over_room_th_mtnums)
        :align(display.LEFT_TOP, 14+30 +120+28 +300 -moveX*1.4, startY -38 -18 -16 -6-155 -70 -70 +45)
        :addTo(R_view_layer_Room)
        :setScale(0.9)

    -- 分溜子
    R_view_flz_Room = display.newSprite(Imgs.over_room_th_flz)
        :align(display.LEFT_TOP, 14+30 +120+28 +300 -moveX*1.4, startY -38 -18 -16 -6-155 -70 -70 -70 +60)
        :addTo(R_view_layer_Room)
        :setScale(0.9)

    -- line
    -- display.newSprite(Imgs.over_room_th_line)
    cc.ui.UIImage.new(Imgs.over_room_th_line)
        :setLayoutSize(376-20 -moveX, 2)
        :align(display.LEFT_TOP, 14+30 +120+28 +250 -moveX*1.4, startY -38 -18 -16 -6-155 -70 -70 -70 -40 +60)
        :addTo(R_view_layer_Room)

    -- 大赢家
    R_view_winlogo_Room = cc.ui.UIImage.new(Imgs.over_room_win_logo,{scale9=false})
        :addTo(R_view_layer_Room)
        :align(display.LEFT_TOP, 14+30 +120+28 +346 -moveX*1.5, startY -38 -18 -16 -162-180)
end

-- 下家
function GameingOverRoomDialog:createView_L()
    -- 层
    -- L_view_layer_Room = display.newLayer() -- .newColorLayer(Colors.layer_bg)
    --     :setContentSize(600,508)
    --     :align(display.LEFT_TOP, 14+30, startY -38)
    --     :addTo(pop_window)
    L_view_layer_Room = display.newNode():addTo(pop_window)

    -- 内容背景
    --cc.ui.UIImage.new(Imgs.,{})
    --:setLayoutSize(600, 508/2-2)
    L_view_ccbg_Room = cc.ui.UIPushButton.new(Imgs.over_room_bg_win,{scale9=false})
    	:setButtonImage(EnStatus.pressed, Imgs.over_room_bg_win)
        :setButtonSize(376 -moveX, 461)
        :addTo(L_view_layer_Room)
        :align(display.LEFT_TOP, 14+30 +800 -moveX*2, startY -38 -18)

    -- 头像框
    local user_head_bg = --display.newSprite(Imgs.home_user_head_bg_top)
        cc.ui.UIImage.new(Imgs.home_user_head_bg_top,{scale9 = false})
        :align(display.LEFT_TOP, 14+30 +10 +800 -moveX*2.05, startY -38 -18 -16)
        :setLayoutSize(icon_view_w, icon_view_h)
        :addTo(L_view_layer_Room)
    -- local user_icon = 'http://wmq.res.apk.yuelaigame.com/test/icon1.jpg'
    -- if user_icon ~= nil and user_icon ~= "" then
    --     R_view_icon_Room = NetSpriteImg.new(user_icon, 106, 100) -- 118*116
    --         --:setContentSize(cc.size(100,100))
    --         --:pos(8+106/2+6,osHeight-8-100/2-8)
    --         :align(display.LEFT_TOP,14+30 +10+6 +800, startY -38 -18 -16-8)
    --         :addTo(L_view_layer_Room)
    -- end
    L_view_owner_Room = display.newSprite(Imgs.over_round_owner_logo)
        :align(display.LEFT_TOP, 14+30 +10 +60 +800, startY -38 -18 -16 -60)
        -- :addTo(L_view_layer_Room)
        -- :setVisible(false)

    if CVar._static.isIphone4 or CVar._static.isIpad or CVar._static.NavBarH_Android ~= CEnum.status.NavBarH_def then
        -- user_head_bg:setLayoutSize(icon_view_w, icon_view_h)
        L_view_owner_Room:align(display.LEFT_TOP, 14+30 +10 +60 +800 -moveX*2.05 -25, startY -38 -18 -16 -60 +20)
    end

    -- 昵称
    L_view_nickname_Room = cc.ui.UILabel.new({
            UILabelType = 2,
            text = "",
            font = Fonts.Font_hkyt_w9,
            size = Dimens.TextSize_25,
            color = Colors:_16ToRGB(Colors.gameing_huxi),
            align = cc.ui.TEXT_ALIGN_LEFT,
            valign = cc.ui.TEXT_VALIGN_CENTER,
            dimensions = cc.size(160,40),
            --maxLineWidth = 118,
        })
        :addTo(L_view_layer_Room)
        :align(display.LEFT_TOP, 14+30 +120+28 +800 -moveX*2.4, startY -38 -18 -16)

    -- id
    display.newSprite(Imgs.over_room_th_id)
        :align(display.LEFT_TOP, 14+30 +120+28 +800 -moveX*2.4, startY -38 -18 -16 -50)
        :addTo(L_view_layer_Room)
        :setScale(0.8)

    -- ip
    L_view_ip_Room = display.newTTFLabel({
            text = "IP：",
            font = Fonts.Font_hkyt_w9,
            size = Dimens.TextSize_18,
            color = Colors:_16ToRGB(Colors.gameing_huxi),
            align = cc.ui.TEXT_ALIGN_LEFT,
            valign = cc.ui.TEXT_VALIGN_CENTER,
            --dimensions = cc.size(100,20)
        })
        :addTo(L_view_layer_Room)
        :align(display.LEFT_TOP, 14+30 +120+28 +800 -moveX*2.4, startY -38 -18 -16 -96)

    -- line
    -- display.newSprite(Imgs.over_room_th_line)
    cc.ui.UIImage.new(Imgs.over_room_th_line)
        :setLayoutSize(376-20 -moveX, 2)
        :align(display.LEFT_TOP, 14+30 +120+28 +650 -moveX*2.4, startY -38 -18 -16 -96 -40)
        :addTo(L_view_layer_Room)

    -- 分数
    display.newSprite(Imgs.over_room_th_score)
        :align(display.LEFT_TOP, 14+30 +120+28 +700 -moveX*2.4, startY -38 -18 -16 -6-150 +10)
        :addTo(L_view_layer_Room)
        :setScale(0.9)

    -- 胡牌次数
    display.newSprite(Imgs.over_room_th_hunums)
        :align(display.LEFT_TOP, 14+30 +120+28 +700 -moveX*2.4, startY -38 -18 -16 -6-155 -70 +29)
        :addTo(L_view_layer_Room)
        :setScale(0.9)

    -- 名堂次数
    display.newSprite(Imgs.over_room_th_mtnums)
        :align(display.LEFT_TOP, 14+30 +120+28 +700 -moveX*2.4, startY -38 -18 -16 -6-155 -70 -70 +45)
        :addTo(L_view_layer_Room)
        :setScale(0.9)

    -- 分溜子
    L_view_flz_Room = display.newSprite(Imgs.over_room_th_flz)
        :align(display.LEFT_TOP, 14+30 +120+28 +700 -moveX*2.4, startY -38 -18 -16 -6-155 -70 -70 -70 +60)
        :addTo(L_view_layer_Room)
        :setScale(0.9)

    -- line
    -- display.newSprite(Imgs.over_room_th_line)
    cc.ui.UIImage.new(Imgs.over_room_th_line)
        :setLayoutSize(376-20 -moveX, 2)
        :align(display.LEFT_TOP, 14+30 +120+28 +650 -moveX*2.4, startY -38 -18 -16 -6-155 -70 -70 -70 -40 +60)
        :addTo(L_view_layer_Room)

    -- 大赢家
    L_view_winlogo_Room = cc.ui.UIImage.new(Imgs.over_room_win_logo,{scale9=false})
        :addTo(L_view_layer_Room)
        :align(display.LEFT_TOP, 14+30 +120+28 +746 -moveX*2.5, startY -38 -18 -16 -162-180)
end


-- 三个玩家的数据都显示出来
function GameingOverRoomDialog:setViewData()
    local icon_w = 106
    local icon_h = 100
    if CVar._static.isIphone4 or CVar._static.isIpad then
        icon_w = 80
        icon_h = 82
    elseif CVar._static.NavBarH_Android ~= CEnum.status.NavBarH_def then
        icon_w = 80
        icon_h = 82
    end

    if res_data_Room ~= nil then
        local room = res_data_Room--[Room.Bean.room]
        
        roomNo = room[Room.Bean.roomNo]
        local roomRecord = room[Room.Bean.roomRecord]

        -- local _room_status = room[Room.Bean.status]
        -- --local room_status
        -- if CEnum.roomStatus.ended==_room_status or CEnum.roomStatus.dissolved==_room_status then
        --     --room_status = true -- 游戏结束
        -- end

        if roomNo ~= nil and view_roomNo ~= nil then
            view_roomNo:setString("房间号："..roomNo)
        end

        if Commons:checkIsNull_tableList(roomRecord) then
            for k,v in pairs(roomRecord) do

                local icon = RequestBase:new():getStrDecode(v[RoomRecord.Bean.user][User.Bean.icon])
                local nickname = Commons:trim(RequestBase:getStrDecode(v[RoomRecord.Bean.user][User.Bean.nickname]) )
                local ip = RequestBase:getStrDecode(v[RoomRecord.Bean.user][User.Bean.ip])
                local owner = v[RoomRecord.Bean.owner]
                local score = v[RoomRecord.Bean.score]
                local winner = v[RoomRecord.Bean.winner]
                local bigWinner = v[RoomRecord.Bean.bigWinner]
                local huTimes = v[RoomRecord.Bean.huTimes]
                local mtTimes = v[RoomRecord.Bean.mtTimes]
                local account = v[RoomRecord.Bean.user][User.Bean.account]

                local flzScore = v[RoomRecord.Bean.flzScore]

                local _string
                local _size

                if k==1 then -- 第一个
                	if winner then
                		winOrOwner_view_ccbg_Room:setButtonImage(EnStatus.normal, Imgs.over_room_bg_win)
                		winOrOwner_view_ccbg_Room:setButtonImage(EnStatus.pressed, Imgs.over_room_bg_win)
            		else
            			winOrOwner_view_ccbg_Room:setButtonImage(EnStatus.normal, Imgs.over_room_bg_fail)
                		winOrOwner_view_ccbg_Room:setButtonImage(EnStatus.pressed, Imgs.over_room_bg_fail)

                        winOrOwner_view_ccbg_Room:setButtonSize(376 -moveX, 461)
                	end

                	if bigWinner then
                		winOrOwner_view_winlogo_Room:setVisible(true)
                	else
                		winOrOwner_view_winlogo_Room:setVisible(false)
                	end
                	
                    --Commons:printLog_Info("---",nickname)
                    -- 头像
                    if icon ~= nil and icon ~= "" then
                        winOrOwner_view_icon_Room = NetSpriteImg.new(icon, icon_w, icon_h) -- 118*116
                            --:setContentSize(cc.size(100,100))
                            :align(display.LEFT_TOP,14+30 +10+6 -moveX*0.05, startY -38 -18 -16-8)
                            :addTo(winOrOwner_view_layer_Room)
                    end

                    -- 昵称赋值 
                    if Commons:checkIsNull_str(nickname) then
                        winOrOwner_view_nickname_Room:setString(nickname)
                    else
                        winOrOwner_view_nickname_Room:setString("")
                    end

                    -- ip
                    if Commons:checkIsNull_str(ip) then
                        winOrOwner_view_ip_Room:setString("IP："..ip)
                    else
                        winOrOwner_view_ip_Room:setString("")
                    end

                    if owner then
                        -- 要显示在头像的上面，所以必须这里加入布局
                        winOrOwner_view_owner_Room:addTo(winOrOwner_view_layer_Room)
                        winOrOwner_view_owner_Room:setVisible(true)
                    else
                        winOrOwner_view_owner_Room:setVisible(false)                        
                    end

                    if Commons:checkIsNull_str(account) then
                        -- 用户编号
                        _string = account -- tostring(account)
                        _size = string.len(_string)
                        for i=1,_size do
                            local i_str = string.sub(_string, i, i)
                            local img_i = GameingDealUtil:getNumImgByShowUserId(i_str)
                            local temp_img = cc.ui.UIImage.new(img_i,{scale9=false})
                                :addTo(winOrOwner_view_layer_Room)
                                :align(display.LEFT_TOP, 14+30 +120+24 +60+16*(i-1) -moveX*0.5, startY -38 -18 -16 -53)
                        end
                    end

                    if Commons:checkIsNull_numberType(score) then
                        -- 分数
                        _string = tostring(score)
                        _size = string.len(_string)
                        for i=1,_size do
                            local i_str = string.sub(_string, i, i)
                            local img_i = GameingDealUtil:getNumImg_by_scoreRound(i_str)
                            --cc.ui.UIPushButton.new(img_i,{scale9=false})
                            --    :setButtonSize(20, 20)
                            local temp_img = cc.ui.UIImage.new(img_i,{scale9=false})
                                :addTo(winOrOwner_view_layer_Room)
                                :align(display.LEFT_TOP, 14+30 +10+56+50 +80+27*(i-1) -moveX*1, startY -38 -18 -16 -6-150 +10)
                                :setScale(0.9)
                        end
                    end

                    if Commons:checkIsNull_numberType(huTimes) then
                        -- 胡牌次数
                        _string = tostring(huTimes)
                        _size = string.len(_string)
                        for i=1,_size do
                            local i_str = string.sub(_string, i, i)
                            local img_i = GameingDealUtil:getNumImg_by_scoreRound(i_str)
                            --cc.ui.UIPushButton.new(img_i,{scale9=false})
                            --    :setButtonSize(20, 20)
                            local temp_img = cc.ui.UIImage.new(img_i,{scale9=false})
                                :addTo(winOrOwner_view_layer_Room)
                                :align(display.LEFT_TOP, 14+30 +10+56+120 +10+27*(i-1) -moveX*0.5, startY -38 -18 -16 -6-155 -70 +29)
                                :setScale(0.9)
                        end
                    end

                    if Commons:checkIsNull_numberType(mtTimes) then
                        -- 名堂次数
                        _string = tostring(mtTimes)
                        _size = string.len(_string)
                        for i=1,_size do
                            local i_str = string.sub(_string, i, i)
                            local img_i = GameingDealUtil:getNumImg_by_scoreRound(i_str)
                            --cc.ui.UIPushButton.new(img_i,{scale9=false})
                            --    :setButtonSize(20, 20)
                            local temp_img = cc.ui.UIImage.new(img_i,{scale9=false})
                                :addTo(winOrOwner_view_layer_Room)
                                :align(display.LEFT_TOP, 14+30 +10+56+120 +10+27*(i-1) -moveX*0.5, startY -38 -18 -16 -6-155 -70 -70 +45)
                                :setScale(0.9)
                        end
                    end

                    if Commons:checkIsNull_numberType(flzScore) then
                        if flzScore > CEnum.isDlz.noLz then
                            -- 分溜子
                            _string = tostring(flzScore)
                            _size = string.len(_string)
                            for i=1,_size do
                                local i_str = string.sub(_string, i, i)
                                local img_i = GameingDealUtil:getNumImg_by_scoreRound(i_str)
                                --cc.ui.UIPushButton.new(img_i,{scale9=false})
                                --    :setButtonSize(20, 20)
                                local temp_img = cc.ui.UIImage.new(img_i,{scale9=false})
                                    :addTo(winOrOwner_view_layer_Room)
                                    :align(display.LEFT_TOP, 14+30 +10+56+120 +10+27*(i-1) -moveX*0.5, startY -38 -18 -16 -6-155 -70 -70 -70 +60)
                                    :setScale(0.9)
                            end
                            winOrOwner_view_flz_Room:show()
                        else
                            winOrOwner_view_flz_Room:hide()
                        end
                    else
                        winOrOwner_view_flz_Room:hide()
                    end
                    -- k==1

                elseif k==2 then
                	if winner then
                		R_view_ccbg_Room:setButtonImage(EnStatus.normal, Imgs.over_room_bg_win)
                		R_view_ccbg_Room:setButtonImage(EnStatus.pressed, Imgs.over_room_bg_win)
            		else
            			R_view_ccbg_Room:setButtonImage(EnStatus.normal, Imgs.over_room_bg_fail)
                		R_view_ccbg_Room:setButtonImage(EnStatus.pressed, Imgs.over_room_bg_fail)

                        R_view_ccbg_Room:setButtonSize(376 -moveX, 461)
                        R_view_ccbg_Room:align(display.LEFT_TOP, 14+30 +400 -moveX, startY -38 -18)
                	end

                	if bigWinner then
                		R_view_winlogo_Room:setVisible(true)
                	else
                		R_view_winlogo_Room:setVisible(false)
                	end

                    -- 头像
                    if icon ~= nil and icon ~= "" then
                        R_view_icon_Room = NetSpriteImg.new(icon, icon_w, icon_h) -- 118*116
                            --:setContentSize(cc.size(100,100))
                            :align(display.LEFT_TOP,14+30 +10+6 +400 -moveX*1.05, startY -38 -18 -16-8)
                            :addTo(R_view_layer_Room)
                    end

                    -- 昵称赋值 
                    if Commons:checkIsNull_str(nickname) then
                        R_view_nickname_Room:setString(nickname)
                    else
                        R_view_nickname_Room:setString("")
                    end

                    -- ip
                    if Commons:checkIsNull_str(ip) then
                        R_view_ip_Room:setString("IP："..ip)
                    else
                        R_view_ip_Room:setString("")
                    end

                    if owner then
                        -- 要显示在头像的上面，所以必须这里加入布局
                        R_view_owner_Room:addTo(R_view_layer_Room)
                        R_view_owner_Room:setVisible(true)
                    else
                        R_view_owner_Room:setVisible(false)                        
                    end

                    if Commons:checkIsNull_str(account) then
                        -- 用户编号
                        _string = account -- tostring(account)
                        _size = string.len(_string)
                        for i=1,_size do
                            local i_str = string.sub(_string, i, i)
                            local img_i = GameingDealUtil:getNumImgByShowUserId(i_str)
                            local temp_img = cc.ui.UIImage.new(img_i,{scale9=false})
                                :addTo(R_view_layer_Room)
                                :align(display.LEFT_TOP, 14+30 +120+24 +400 +60+16*(i-1) -moveX*1.5, startY -38 -18 -16 -53)
                        end
                    end

                    if Commons:checkIsNull_numberType(score) then
                        -- 分数
                        _string = tostring(score)
                        _size = string.len(_string)
                        for i=1,_size do
                            local i_str = string.sub(_string, i, i)
                            local img_i = GameingDealUtil:getNumImg_by_scoreRound(i_str)
                            --cc.ui.UIPushButton.new(img_i,{scale9=false})
                            --    :setButtonSize(20, 20)
                            local temp_img = cc.ui.UIImage.new(img_i,{scale9=false})
                                :addTo(R_view_layer_Room)
                                :align(display.LEFT_TOP, 14+30 +10+56+50 +400 +80+27*(i-1) -moveX*2, startY -38 -18 -16 -6-150 +10)
                                :setScale(0.9)
                        end
                    end

                    if Commons:checkIsNull_numberType(huTimes) then
                        -- 胡牌次数
                        _string = tostring(huTimes)
                        _size = string.len(_string)
                        for i=1,_size do
                            local i_str = string.sub(_string, i, i)
                            local img_i = GameingDealUtil:getNumImg_by_scoreRound(i_str)
                            local temp_img = cc.ui.UIImage.new(img_i,{scale9=false})
                                :addTo(R_view_layer_Room)
                                :align(display.LEFT_TOP, 14+30 +10+56+120 +400 +10+27*(i-1) -moveX*1.5, startY -38 -18 -16 -6-155 -70 +29)
                                :setScale(0.9)
                        end
                    end

                    if Commons:checkIsNull_numberType(mtTimes) then
                        -- 名堂次数
                        _string = tostring(mtTimes)
                        _size = string.len(_string)
                        for i=1,_size do
                            local i_str = string.sub(_string, i, i)
                            local img_i = GameingDealUtil:getNumImg_by_scoreRound(i_str)
                            --cc.ui.UIPushButton.new(img_i,{scale9=false})
                            --    :setButtonSize(20, 20)
                            local temp_img = cc.ui.UIImage.new(img_i,{scale9=false})
                                :addTo(R_view_layer_Room)
                                :align(display.LEFT_TOP, 14+30 +10+56+120 +400 +10+27*(i-1)  -moveX*1.5, startY -38 -18 -16 -6-155 -70 -70 +45)
                                :setScale(0.9)
                        end
                    end

                    if Commons:checkIsNull_numberType(flzScore) then
                        if flzScore > CEnum.isDlz.noLz then
                            -- 分溜子
                            _string = tostring(flzScore)
                            _size = string.len(_string)
                            for i=1,_size do
                                local i_str = string.sub(_string, i, i)
                                local img_i = GameingDealUtil:getNumImg_by_scoreRound(i_str)
                                --cc.ui.UIPushButton.new(img_i,{scale9=false})
                                --    :setButtonSize(20, 20)
                                local temp_img = cc.ui.UIImage.new(img_i,{scale9=false})
                                    :addTo(R_view_layer_Room)
                                    :align(display.LEFT_TOP, 14+30 +10+56+120 +400 +10+27*(i-1)  -moveX*1.5, startY -38 -18 -16 -6-155 -70 -70 -70 +60)
                                    :setScale(0.9)
                            end
                            R_view_flz_Room:show()
                        else
                            R_view_flz_Room:hide()
                        end
                    else
                        R_view_flz_Room:hide()
                    end
                    -- k==2

                else
                	if winner then
                		L_view_ccbg_Room:setButtonImage(EnStatus.normal, Imgs.over_room_bg_win)
                		L_view_ccbg_Room:setButtonImage(EnStatus.pressed, Imgs.over_room_bg_win)
            		else
            			L_view_ccbg_Room:setButtonImage(EnStatus.normal, Imgs.over_room_bg_fail)
                		L_view_ccbg_Room:setButtonImage(EnStatus.pressed, Imgs.over_room_bg_fail)

                        L_view_ccbg_Room:setButtonSize(376 -moveX, 461)
                        L_view_ccbg_Room:align(display.LEFT_TOP, 14+30 +800 -moveX*2, startY -38 -18)
                	end

                	if bigWinner then
                		L_view_winlogo_Room:setVisible(true)
                	else
                		L_view_winlogo_Room:setVisible(false)
                	end

                    -- 头像 
                    if icon ~= nil and icon ~= "" then
                        L_view_icon_Room = NetSpriteImg.new(icon, icon_w, icon_h) -- 118*116
                            --:setContentSize(cc.size(100,100))
                            :align(display.LEFT_TOP,14+30 +10+6 +800 -moveX*2.05, startY -38 -18 -16-8)
                            :addTo(L_view_layer_Room)                        
                    end

                    -- 昵称赋值 
                    if Commons:checkIsNull_str(nickname) then
                        L_view_nickname_Room:setString(nickname)
                    else
                        L_view_nickname_Room:setString(" ")
                    end

                    -- ip
                    if Commons:checkIsNull_str(ip) then
                        L_view_ip_Room:setString("IP："..ip)
                    else
                        L_view_ip_Room:setString("")
                    end

                    if owner then
                        -- 要显示在头像的上面，所以必须这里加入布局
                        L_view_owner_Room:addTo(L_view_layer_Room)
                        L_view_owner_Room:setVisible(true)
                    else
                        L_view_owner_Room:setVisible(false)                        
                    end

                    if Commons:checkIsNull_str(account) then
                        -- 用户编号
                        _string = account -- tostring(account)
                        _size = string.len(_string)
                        for i=1,_size do
                            local i_str = string.sub(_string, i, i)
                            local img_i = GameingDealUtil:getNumImgByShowUserId(i_str)
                            local temp_img = cc.ui.UIImage.new(img_i,{scale9=false})
                                :addTo(L_view_layer_Room)
                                :align(display.LEFT_TOP, 14+30 +120+24 +800 +60+16*(i-1) -moveX*2.5, startY -38 -18 -16 -53)
                        end
                    end

                    if Commons:checkIsNull_numberType(score) then
                        -- 分数
                        _string = tostring(score)
                        _size = string.len(_string)
                        for i=1,_size do
                            local i_str = string.sub(_string, i, i)
                            local img_i = GameingDealUtil:getNumImg_by_scoreRound(i_str)
                            --cc.ui.UIPushButton.new(img_i,{scale9=false})
                            --    :setButtonSize(20, 20)
                            local temp_img = cc.ui.UIImage.new(img_i,{scale9=false})
                                :addTo(L_view_layer_Room)
                                :align(display.LEFT_TOP, 14+30 +10+56+50 +800 +80+27*(i-1) -moveX*3, startY -38 -18 -16 -6-150 +10)
                                :setScale(0.9)
                        end
                    end

                    if Commons:checkIsNull_numberType(huTimes) then
                        -- 胡牌次数
                        _string = tostring(huTimes)
                        _size = string.len(_string)
                        for i=1,_size do
                            local i_str = string.sub(_string, i, i)
                            local img_i = GameingDealUtil:getNumImg_by_scoreRound(i_str)
                            --cc.ui.UIPushButton.new(img_i,{scale9=false})
                            --    :setButtonSize(20, 20)
                            local temp_img = cc.ui.UIImage.new(img_i,{scale9=false})
                                :addTo(L_view_layer_Room)
                                :align(display.LEFT_TOP, 14+30 +10+56+120 +800 +10+27*(i-1) -moveX*2.5, startY -38 -18 -16 -6-155 -70 +29)
                                :setScale(0.9)
                        end
                    end

                    if Commons:checkIsNull_numberType(mtTimes) then
                        -- 名堂次数
                        _string = tostring(mtTimes)
                        _size = string.len(_string)
                        for i=1,_size do
                            local i_str = string.sub(_string, i, i)
                            local img_i = GameingDealUtil:getNumImg_by_scoreRound(i_str)
                            --cc.ui.UIPushButton.new(img_i,{scale9=false})
                            --    :setButtonSize(20, 20)
                            local temp_img = cc.ui.UIImage.new(img_i,{scale9=false})
                                :addTo(L_view_layer_Room)
                                :align(display.LEFT_TOP, 14+30 +10+56+120 +800 +10+27*(i-1)  -moveX*2.5, startY -38 -18 -16 -6-155 -70 -70 +45)
                                :setScale(0.9)
                        end
                    end

                    if Commons:checkIsNull_numberType(flzScore) then
                        if flzScore > CEnum.isDlz.noLz then
                            -- 分溜子
                            _string = tostring(flzScore)
                            _size = string.len(_string)
                            for i=1,_size do
                                local i_str = string.sub(_string, i, i)
                                local img_i = GameingDealUtil:getNumImg_by_scoreRound(i_str)
                                --cc.ui.UIPushButton.new(img_i,{scale9=false})
                                --    :setButtonSize(20, 20)
                                local temp_img = cc.ui.UIImage.new(img_i,{scale9=false})
                                    :addTo(L_view_layer_Room)
                                    :align(display.LEFT_TOP, 14+30 +10+56+120 +800 +10+27*(i-1)  -moveX*2.5, startY -38 -18 -16 -6-155 -70 -70 -70 +60)
                                    :setScale(0.9)
                            end
                            L_view_flz_Room:show()
                        else
                            L_view_flz_Room:hide()   
                        end
                    else
                        L_view_flz_Room:hide()
                    end
                    -- k==3

                end -- if
            end -- for roomRecord
        end -- if roomRecord~=nil
    end
end

function GameingOverRoomDialog:onExit()
    GameingOverRoomDialog:myExit()
end

function GameingOverRoomDialog:myExit()

    res_data_Room = nil

    view_roomNo = nil
    view_roomTime = nil

    winOrOwner_view_layer_Room = nil
    winOrOwner_view_icon_Room = nil
    winOrOwner_view_nickname_Room = nil
    winOrOwner_view_winlogo_Room = nil
    winOrOwner_view_flz_Room = nil

    R_view_layer_Room  = nil
    R_view_icon_Room  = nil
    R_view_owner_Room  = nil
    R_view_nickname_Room  = nil
    R_view_winlogo_Room = nil
    R_view_flz_Room = nil

    L_view_layer_Room  = nil
    L_view_icon_Room  = nil
    L_view_owner_Room  = nil
    L_view_nickname_Room  = nil
    L_view_winlogo_Room = nil
    L_view_flz_Room = nil
end

-- 必须有这个返回
return GameingOverRoomDialog
