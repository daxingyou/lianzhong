--
-- Author: lte
-- Date: 2016-10-19 12:40:33
-- 自定义背景和title的弹窗  需要点击下自动关闭

-- 类申明
local CDAlertGprs4person = class("CDAlertGprs4person"
    -- ,function()
    --     return display.newNode()
    -- end
    )


-- 类变量申明
local osWidth = Commons.osWidth
local osHeight = Commons.osHeight

local alert_gaping_w
local alert_gaping_h

function CDAlertGprs4person:ctor()
end

-- 创建一个模态弹出框,  parent=要加在哪个上面
function CDAlertGprs4person:popDialogBox(_parent, GprsBean)

    self.parent = _parent

    self.GprsBean = GprsBean

    self.pop_window = display.newColorLayer(cc.c4b(0, 0, 0, 100))       -- 半透明的黑色

    self.pop_window:setContentSize(osWidth, osHeight)             -- 设置Layer的大小,全屏出现
    --self.pop_window:align(display.CENTER, display.cx, display.cy) -- Layer的锚点在0.5,0.5 因此对齐的时候要注意
    self.pop_window:setTouchEnabled(true)
    self.pop_window:setTouchSwallowEnabled(true)  -- 吞噬下层的响应
    self.pop_window:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event) -- 点击此Layer时候输出信息,然后把自己销毁
        return true
    end)
    self.parent:addChild(self.pop_window, CEnum.ZOrder.common_dialog) -- 把Layer添加到父对象上


    alert_gaping_w = 100
    alert_gaping_h = 95 -40
    if CVar._static.isIphone4 then
        alert_gaping_w = alert_gaping_w -10
    elseif CVar._static.isIpad then
        alert_gaping_w = alert_gaping_w -50
    elseif CVar._static.NavBarH_Android ~= CEnum.status.NavBarH_def then
        alert_gaping_w = alert_gaping_w -CVar._static.NavBarH_Android
    end

    ---[[
    -- 整个底色背景
    cc.ui.UIImage.new(
        -- Imgs.dialog_bg_round,{scale9=true})
        Imgs.dialog_bg,{scale9=false})
        :addTo(self.pop_window)
    	:align(display.CENTER, display.cx, display.cy)
    	:setLayoutSize(osWidth-alert_gaping_w*2, osHeight-alert_gaping_h*2)
        -- :align(display.CENTER, display.cx, osHeight -alert_gaping_h-72/2)
        -- :setLayoutSize(osWidth-alert_gaping_w*2, 72)
    --]]

    ---[[
    -- 内容背景
    cc.ui.UIImage.new(
        -- Imgs.dialog_content_bg_round,{scale9=true})
        Imgs.dialog_content_bg,{scale9=true})
        :addTo(self.pop_window)
        :align(display.CENTER, display.cx, osHeight -alert_gaping_h-72 -(osHeight-alert_gaping_h*2-72)/2 )
        :setLayoutSize(osWidth-alert_gaping_w*2 -6*2, osHeight-alert_gaping_h*2-72 -12)
    --]]

    ---[[
    -- 提示 logo
    cc.ui.UIImage.new(Imgs.g_title,{scale9=false})
    	:addTo(self.pop_window)
        :align(display.CENTER_TOP, display.cx, osHeight-alert_gaping_h-8 -10)
    --]]

    ---[[
    -- 关闭 弹窗
    cc.ui.UIPushButton.new(Imgs.dialog_exit,{scale9=false})
        -- :setButtonSize(56, 56)
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
            self:myExit()

        end)
        :align(display.CENTER_RIGHT, osWidth-alert_gaping_w-45, osHeight-alert_gaping_h-5 -35)
    	:addTo(self.pop_window)
    --]]

    ---[[
    -- 取消按钮  =离开
    local cancelBtn = cc.ui.UIPushButton.new(
        Imgs.dialog_btn_goout,{scale9=false})
        --:setButtonSize(278, 100)
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
        :setButtonImage(EnStatus.pressed, Imgs.dialog_btn_goout_press)
        :onButtonClicked(function(e)

            VoiceDealUtil:playSound_other(Voices.file.ui_click)
            self:sendDissRoom()

        end)
        :align(display.CENTER, display.cx-220, alert_gaping_h+66)
        :addTo(self.pop_window)
        -- :hide()
    local owner = nil
    if self.GprsBean ~= nil then
        owner = self.GprsBean[Player.Bean.owner]
    end
    -- print("*************************owner==", owner)
    -- print("*************************CVar._static.roomStatus==", CVar._static.roomStatus)
    local _status = CVar._static.roomStatus == CEnum.roomStatus.started
    -- print("*************************_status==", _status)
    if owner or _status then
        cancelBtn:setButtonImage(EnStatus.normal, Imgs.dialog_btn_godiss)
        cancelBtn:setButtonImage(EnStatus.pressed, Imgs.dialog_btn_godiss_press)
    end
    --]]

    ---[[
    -- 确定按钮  =继续
    local submitBtn = cc.ui.UIPushButton.new(
        Imgs.dialog_btn_goon,{scale9=false})
        --:setButtonSize(278, 100)
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
        :setButtonImage(EnStatus.pressed, Imgs.dialog_btn_goon_press)
        :onButtonClicked(function(e)

            VoiceDealUtil:playSound_other(Voices.file.ui_click)
            self:myExit()

        end)
        :align(display.CENTER, display.cx+220, alert_gaping_h+66)
        :addTo(self.pop_window)
        -- :hide()
    --]]

    -- 内容
    self:create_content()

    return self.pop_window
end

--返回大厅，需要通知服务器可以不可以
function CDAlertGprs4person:backHome_OK_toSendServer()
    SocketRequestGameing:gameing_BackHaLL()
    self:myExit()
end

-- 本人要解散房间的弹窗确认取消事件
function CDAlertGprs4person:dissRoomMeConfim_OK()
    SocketRequestGameing:dissRoom()
    self:myExit()
end

function CDAlertGprs4person:sendDissRoom()
    local owner = nil
    if self.GprsBean ~= nil then
        owner = self.GprsBean[Player.Bean.owner]
    end
    -- print("*************************owner==", owner)
    local _status = CVar._static.roomStatus == CEnum.roomStatus.started
    if owner or _status then
        CDialog.new():popDialogBox(self.pop_window, 
            nil, Strings.gameing.dissRoomConfim, 
            function() self:dissRoomMeConfim_OK() end, 
            function() end )
    else
        CDialog.new():popDialogBox(self.pop_window, 
            CDialog.title_logo.backHome, Strings.gameing.outRoomConfim, 
            function() self:backHome_OK_toSendServer() end, 
            function() end)
    end
end

-- 内容
function CDAlertGprs4person:create_content()

    local user_icon, user_nickname, R_icon, R_nickname, L_icon, L_nickname, M_icon, M_nickname

    local distanceA = ""
    local distanceB = ""
    local distanceC = ""
    local distanceD = ""
    local distanceE = ""
    local distanceF = ""

    if self.GprsBean~=nil then
        distanceA = self.GprsBean[Gprs.Bean.distanceA]
        distanceB = self.GprsBean[Gprs.Bean.distanceB]
        distanceC = self.GprsBean[Gprs.Bean.distanceC]
        distanceD = self.GprsBean[Gprs.Bean.distanceD]
        distanceE = self.GprsBean[Gprs.Bean.distanceE]
        distanceF = self.GprsBean[Gprs.Bean.distanceF]

        if self.GprsBean[Gprs.Bean.user] ~= nil then
            user_icon = RequestBase:getStrDecode( self.GprsBean[Gprs.Bean.user][User.Bean.icon] )
            user_nickname = RequestBase:getStrDecode( self.GprsBean[Gprs.Bean.user][User.Bean.nickname] )
        end

        if self.GprsBean[Gprs.Bean.nextUser] ~= nil then
            R_icon = RequestBase:getStrDecode( self.GprsBean[Gprs.Bean.nextUser][User.Bean.icon] )
            R_nickname = RequestBase:getStrDecode( self.GprsBean[Gprs.Bean.nextUser][User.Bean.nickname] )
        end

        if self.GprsBean[Gprs.Bean.preUser] ~= nil then
            L_icon = RequestBase:getStrDecode( self.GprsBean[Gprs.Bean.preUser][User.Bean.icon] )
            L_nickname = RequestBase:getStrDecode( self.GprsBean[Gprs.Bean.preUser][User.Bean.nickname] )
        end

        if self.GprsBean[Gprs.Bean.middleUser] ~= nil then
            M_icon = RequestBase:getStrDecode( self.GprsBean[Gprs.Bean.middleUser][User.Bean.icon] )
            M_nickname = RequestBase:getStrDecode( self.GprsBean[Gprs.Bean.middleUser][User.Bean.nickname] )
        end
    end


    local rotat = 25 -- 旋转角度
    local fontSizeDistance = Dimens.TextSize_20
    local fontColorDistance = Colors:_16ToRGB(Colors.keyboard)

    local fontSizeNick = Dimens.TextSize_20
    local fontColorNick = Colors:_16ToRGB(Colors.keyboard)

    local moveX = 0
    local moveY = -200
    -- 整个 线条 布局图
    cc.ui.UIImage.new(Imgs.g_line_4person, {scale9=false})
        :addTo(self.pop_window)
        :align(display.CENTER_BOTTOM, display.cx +moveX, display.cy +60 +moveY)


    -- me
    moveX = 0
    moveY = -200
    -- icon背景框
	display.newSprite(Imgs.gameing_user_head_bg) -- 90*93
        :align(display.CENTER, display.cx +moveX, display.cy +moveY)
        :addTo(self.pop_window)
    -- icon
    if user_icon ~= nil and user_icon ~= "" then
        NetSpriteImg.new(user_icon, 76, 80)
            :align(display.CENTER, display.cx +moveX, display.cy +2.5 +moveY)
            :addTo(self.pop_window)
    end
    -- 昵称
    if user_nickname == nil then
        user_nickname = ''
    end
    cc.ui.UILabel.new({
            UILabelType = 2,
            text = user_nickname,
            size = fontSizeNick,
            color = fontColorNick,
            font = Fonts.Font_hkyt_w7,
            align = cc.ui.TEXT_VALIGN_CENTER,
            valign = cc.ui.TEXT_VALIGN_CENTER,
            --dimensions = cc.size((osWidth-286*2-20*2),0) -- height为0，就是自动换行
            dimensions = cc.size(120,25)
        })
        :align(display.CENTER, display.cx +moveX, display.cy -60 +moveY)
        :addTo(self.pop_window)
    -- 上家与下家的 距离多少公里
    if Commons:checkIsNull_str(distanceC) then
        cc.ui.UILabel.new({
            UILabelType = 2,
            text = distanceC,
            size = fontSizeDistance,
            color = fontColorDistance,
            font = Fonts.Font_hkyt_w9,
            align = cc.ui.TEXT_VALIGN_CENTER,
            valign = cc.ui.TEXT_VALIGN_CENTER,
            --dimensions = cc.size((osWidth-286*2-20*2),0) -- height为0，就是自动换行
            -- dimensions = cc.size(120,25)
        })
        :align(display.CENTER, display.cx -80 +moveX, display.cy +160 +moveY)
        :addTo(self.pop_window)
    end


    -- R
    moveX = 300
    moveY = -20
    -- icon背景框
    display.newSprite(Imgs.gameing_user_head_bg) -- 90*93
        :align(display.CENTER, display.cx +moveX, display.cy +moveY)
        :addTo(self.pop_window)
    -- icon
    if R_icon ~= nil and R_icon ~= "" then
        NetSpriteImg.new(R_icon, 76, 80)
            :align(display.CENTER, display.cx +moveX, display.cy +2.5 +moveY)
            :addTo(self.pop_window)
    end
    -- 昵称
    if R_nickname == nil then
        R_nickname = ''
    end
    cc.ui.UILabel.new({
            UILabelType = 2,
            text = R_nickname,
            size = fontSizeNick,
            color = fontColorNick,
            font = Fonts.Font_hkyt_w7,
            align = cc.ui.TEXT_VALIGN_CENTER,
            valign = cc.ui.TEXT_VALIGN_CENTER,
            --dimensions = cc.size((osWidth-286*2-20*2),0) -- height为0，就是自动换行
            dimensions = cc.size(120,25)
        })
        :align(display.CENTER, display.cx +moveX, display.cy -60 +moveY)
        :addTo(self.pop_window)
    -- 我与下家  距离多少公里
    if Commons:checkIsNull_str(distanceB) then
        cc.ui.UILabel.new({
            UILabelType = 2,
            text = distanceB,
            size = fontSizeDistance,
            color = fontColorDistance,
            font = Fonts.Font_hkyt_w9,
            align = cc.ui.TEXT_VALIGN_CENTER,
            valign = cc.ui.TEXT_VALIGN_CENTER,
            --dimensions = cc.size((osWidth-286*2-20*2),0) -- height为0，就是自动换行
            dimensions = cc.size(260,25)
        })
        :align(display.LEFT_CENTER, display.cx, display.cy -125 +moveY)
        :addTo(self.pop_window)
        :setRotation(-rotat)
    end


    -- L
    moveX = -300
    moveY = -20
    -- icon背景框
    display.newSprite(Imgs.gameing_user_head_bg) -- 90*93
        :align(display.CENTER, display.cx +moveX, display.cy +moveY)
        :addTo(self.pop_window)
    -- icon
    if L_icon ~= nil and L_icon ~= "" then
        NetSpriteImg.new(L_icon, 76, 80)
            :align(display.CENTER, display.cx +moveX, display.cy +2.5 +moveY)
            :addTo(self.pop_window)
    end
    -- 昵称
    if L_nickname == nil then
        L_nickname = ''
    end
    cc.ui.UILabel.new({
            UILabelType = 2,
            text = L_nickname,
            size = fontSizeNick,
            color = fontColorNick,
            font = Fonts.Font_hkyt_w7,
            align = cc.ui.TEXT_VALIGN_CENTER,
            valign = cc.ui.TEXT_VALIGN_CENTER,
            --dimensions = cc.size((osWidth-286*2-20*2),0) -- height为0，就是自动换行
            dimensions = cc.size(120,25)
        })
        :align(display.CENTER, display.cx +moveX, display.cy -60 +moveY)
        :addTo(self.pop_window)
    -- 我与上家 距离多少公里
    if Commons:checkIsNull_str(distanceA) then
        cc.ui.UILabel.new({
            UILabelType = 2,
            text = distanceA,
            size = fontSizeDistance,
            color = fontColorDistance,
            font = Fonts.Font_hkyt_w9,
            align = cc.ui.TEXT_VALIGN_CENTER,
            valign = cc.ui.TEXT_VALIGN_CENTER,
            --dimensions = cc.size((osWidth-286*2-20*2),0) -- height为0，就是自动换行
            dimensions = cc.size(260,25)
        })
        :align(display.RIGHT_CENTER, display.cx, display.cy -125 +moveY)
        :addTo(self.pop_window)
        :setRotation(rotat)
    end  


    -- M
    moveX = 0
    moveY = 170
    -- icon背景框
    display.newSprite(Imgs.gameing_user_head_bg) -- 90*93
        :align(display.CENTER, display.cx +moveX, display.cy +moveY)
        :addTo(self.pop_window)
    -- icon
    if M_icon ~= nil and M_icon ~= "" then
        NetSpriteImg.new(M_icon, 76, 80)
            :align(display.CENTER, display.cx +moveX, display.cy +2.5 +moveY)
            :addTo(self.pop_window)
    end
    -- 昵称
    if M_nickname == nil then
        M_nickname = ''
    end
    cc.ui.UILabel.new({
            UILabelType = 2,
            text = M_nickname,
            size = fontSizeNick,
            color = fontColorNick,
            font = Fonts.Font_hkyt_w7,
            align = cc.ui.TEXT_VALIGN_CENTER,
            valign = cc.ui.TEXT_VALIGN_CENTER,
            --dimensions = cc.size((osWidth-286*2-20*2),0) -- height为0，就是自动换行
            dimensions = cc.size(120,25)
        })
        :align(display.CENTER, display.cx +moveX, display.cy -60 +moveY)
        :addTo(self.pop_window)
    -- 当前玩家与对家的距离(如果存在4个玩家，就有对家，否则没有对家)
    if Commons:checkIsNull_str(distanceD) then
        cc.ui.UILabel.new({
            UILabelType = 2,
            text = distanceD,
            size = fontSizeDistance,
            color = fontColorDistance,
            font = Fonts.Font_hkyt_w9,
            align = cc.ui.TEXT_VALIGN_CENTER,
            valign = cc.ui.TEXT_VALIGN_CENTER,
            --dimensions = cc.size((osWidth-286*2-20*2),0) -- height为0，就是自动换行
            -- dimensions = cc.size(120,25)
        })
        :align(display.LEFT_CENTER, display.cx +20 +moveX, display.cy -120 +moveY)
        :addTo(self.pop_window)
        :setRotation(90)
    end

    -- 当前玩家的上家与对家的距离
    moveX = -300
    moveY = -20
    if Commons:checkIsNull_str(distanceE) then
        cc.ui.UILabel.new({
            UILabelType = 2,
            text = distanceE,
            size = fontSizeDistance,
            color = fontColorDistance,
            font = Fonts.Font_hkyt_w9,
            align = cc.ui.TEXT_VALIGN_CENTER,
            valign = cc.ui.TEXT_VALIGN_CENTER,
            --dimensions = cc.size((osWidth-286*2-20*2),0) -- height为0，就是自动换行
            dimensions = cc.size(260,25)
        })
        :align(display.RIGHT_CENTER, display.cx, display.cy +120 +moveY)
        :addTo(self.pop_window)
        :setRotation(-rotat)
    end

    -- 当前玩家的下家与对家的距离
    moveX = 300
    moveY = -20
    if Commons:checkIsNull_str(distanceF) then
        cc.ui.UILabel.new({
            UILabelType = 2,
            text = distanceF,
            size = fontSizeDistance,
            color = fontColorDistance,
            font = Fonts.Font_hkyt_w9,
            align = cc.ui.TEXT_VALIGN_CENTER,
            valign = cc.ui.TEXT_VALIGN_CENTER,
            --dimensions = cc.size((osWidth-286*2-20*2),0) -- height为0，就是自动换行
            dimensions = cc.size(260,25)
        })
        :align(display.LEFT_CENTER, display.cx, display.cy +120 +moveY)
        :addTo(self.pop_window)
        :setRotation(rotat)
    end

end

function CDAlertGprs4person:onExit()
    self:myExit()
end

function CDAlertGprs4person:myExit()
    if self.pop_window and not tolua.isnull(self.pop_window) then
        self.pop_window:removeFromParent()
        self.pop_window = nil
    end
end

return CDAlertGprs4person