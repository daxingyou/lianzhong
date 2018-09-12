--
-- Author: lte
-- Date: 2016-10-19 12:40:33
-- 自定义背景和title的弹窗  需要点击下自动关闭

-- 类申明
local CDAlertIP = class("CDAlertIP"
    -- ,function()
    --     return display.newNode()
    -- end
    )


local osWidth = Commons.osWidth
local osHeight = Commons.osHeight

local startX_gaping

function CDAlertIP:ctor()
end

-- 创建一个模态弹出框,  parent=要加在哪个上面
function CDAlertIP:popDialogBox(_parent, _icon, _nickname, _account, _ip, _rights, _isRefreshBalance)

    self.parent = _parent

    self.icon = _icon
    self.nickname = _nickname
    self.account = _account
    self.ip = _ip
    self.rights = _rights

    self.isRefreshBalance = _isRefreshBalance

    self.pop_window = display.newColorLayer(cc.c4b(0, 0, 0, 100))       -- 半透明的黑色

    self.pop_window:setContentSize(osWidth, osHeight)             -- 设置Layer的大小,全屏出现
    --self.pop_window:align(display.CENTER, display.cx, display.cy) -- Layer的锚点在0.5,0.5 因此对齐的时候要注意
    self.pop_window:setTouchEnabled(true)
    self.pop_window:setTouchSwallowEnabled(true)  -- 吞噬下层的响应
    self.pop_window:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event) -- 点击此Layer时候输出信息,然后把自己销毁
        return true
    end)
    self.parent:addChild(self.pop_window, CEnum.ZOrder.common_dialog) -- 把Layer添加到父对象上


    startX_gaping = 410
    if CVar._static.isIphone4 then
        startX_gaping = startX_gaping -100
    elseif CVar._static.isIpad then
        startX_gaping = startX_gaping -150
    elseif CVar._static.NavBarH_Android ~= CEnum.status.NavBarH_def then
        startX_gaping = startX_gaping -CVar._static.NavBarH_Android
    end


    ---[[
    -- 整个底色背景
    cc.ui.UIImage.new(Imgs.dialog_bg,{scale9=false})
    	:addTo(self.pop_window)
    	:align(display.CENTER, display.cx, display.cy)
    	:setLayoutSize(osWidth-startX_gaping*2, osHeight-214*2)
    --]]

    -- 内容背景
    cc.ui.UIImage.new(Imgs.dialog_content_bg,{scale9=false})
        :addTo(self.pop_window)
        :align(display.CENTER, display.cx, display.cy -64/2)
        :setLayoutSize(osWidth-startX_gaping*2-6*2, osHeight-214*2 -64-4)

    ---[[
    -- 提示 logo
    cc.ui.UIImage.new(Imgs.imip_title_logo,{scale9=false})
    	:addTo(self.pop_window)
    	:align(display.CENTER, display.cx, osHeight-214-64/2-4)
    --]]

    ---[[
    -- 关闭
    cc.ui.UIPushButton.new(Imgs.dialog_exit,{scale9=false})
        --:setButtonSize(56, 56)
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
        :align(display.CENTER, osWidth-startX_gaping-15-52/2, osHeight-214-8-52/2)
    	:addTo(self.pop_window)
    --]]

    --[[
    -- 确定按钮
    local submitBtn = cc.ui.UIPushButton.new(
        Imgs.dialog_btn_confim_alert,{scale9=false})
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
        :setButtonImage(EnStatus.pressed, Imgs.dialog_btn_confim_alert_press)
        :onButtonClicked(function(e)

            VoiceDealUtil:playSound_other(Voices.file.ui_click)
            self:myExit()

        end)
        :align(display.CENTER, display.cx, display.cy-105)
        :addTo(self.pop_window)
        :setVisible(false)
    --]]

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
            GiveCardDialog:popDialogBox(self.pop_window, self.account, self.isRefreshBalance)

        end)
        :align(display.CENTER, display.cx, display.cy-100)
        :addTo(self.pop_window)
        :hide()
    if CVar._static.appstoreSwitch == CEnum.appstoreSwitch.open then
        if self.rights ~= nil and Commons:checkIsNull_tableList(self.rights) then
            local tag = false
            for k,v in pairs(self.rights) do
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
    
    -- 内容
    self:create_content()

end

function CDAlertIP:copyContent(txt)
    if Commons:checkIsNull_str(txt) then
        local function CDAlertIP_CopyTxt_CallbackLua(txt)
            if Commons.osType == CEnum.osType.A then
                CDAlert.new():popDialogBox(self.pop_window, txt)
            elseif Commons.osType == CEnum.osType.I then
                CDAlert.new():popDialogBox(self.pop_window, txt)
            end

            if self.userid_view ~= nil and (not tolua.isnull(self.userid_view)) then
                -- self.userid_view:removeFromParent()
                -- self.userid_view = nil
                -- self.userid_view = cc.ui.UILabel.new({
                --     UILabelType = 2, 
                --     --image = "",
                --     text = ""..self.account, 
                --     size = Dimens.TextSize_25,
                --     color = Colors.green,
                --     -- color = Colors:_16ToRGB(Colors.keyboard),
                --     font = Fonts.Font_hkyt_w9,
                --     align = cc.ui.TEXT_ALIGN_LEFT,
                --     valign = cc.ui.TEXT_VALIGN_CENTER,
                --     --dimensions = cc.size((osWidth-286*2-20*2),0) -- height为0，就是自动换行
                -- })
                -- :align(display.LEFT_TOP, display.cx-80+50, display.cy+13)
                -- :addTo(self.pop_window)

                -- self.userid_view:setString("复制")
                self.userid_view:setColor(Colors.green)
            end
        end
        Commons:gotoCopyContent(CDAlertIP_CopyTxt_CallbackLua, txt)
    end
end

-- 内容
function CDAlertIP:create_content()
	display.newSprite(Imgs.gameing_user_head_bg)
        :align(display.CENTER, display.cx-140, display.cy)
        :addTo(self.pop_window)
    if self.icon ~= nil and self.icon ~= "" then
        NetSpriteImg.new(self.icon, 76, 80)
            :align(display.CENTER, display.cx-140, display.cy+3)
            :addTo(self.pop_window)
    end

    -- 昵称
    cc.ui.UILabel.new({
            UILabelType = 2, 
            --image = "",
            text = self.nickname, 
            size = Dimens.TextSize_25,
            --color = Colors.black,
            color = Colors:_16ToRGB(Colors.keyboard),
            font = Fonts.Font_hkyt_w9,
            align = cc.ui.TEXT_ALIGN_LEFT,
            valign = cc.ui.TEXT_VALIGN_CENTER,
            --dimensions = cc.size((osWidth-286*2-20*2),0) -- height为0，就是自动换行
        })
        :align(display.LEFT_TOP, display.cx-80, display.cy+58)
        :addTo(self.pop_window)

    -- id帐号
    cc.ui.UILabel.new({
            UILabelType = 2, 
            --image = "",
            text = "ID：", 
            size = Dimens.TextSize_25,
            --color = Colors.black,
            color = Colors:_16ToRGB(Colors.keyboard),
            font = Fonts.Font_hkyt_w9,
            align = cc.ui.TEXT_ALIGN_LEFT,
            valign = cc.ui.TEXT_VALIGN_CENTER,
            --dimensions = cc.size((osWidth-286*2-20*2),0) -- height为0，就是自动换行
        })
        :align(display.LEFT_TOP, display.cx-80, display.cy+13)
        :addTo(self.pop_window)
    self.userid_view = cc.ui.UILabel.new({
            UILabelType = 2, 
            --image = "",
            text = ""..self.account, 
            size = Dimens.TextSize_25,
            -- color = Colors.black,
            color = Colors:_16ToRGB(Colors.keyboard),
            font = Fonts.Font_hkyt_w9,
            align = cc.ui.TEXT_ALIGN_LEFT,
            valign = cc.ui.TEXT_VALIGN_CENTER,
            --dimensions = cc.size((osWidth-286*2-20*2),0) -- height为0，就是自动换行
        })
        :align(display.LEFT_TOP, display.cx-80+50, display.cy+13)
        :addTo(self.pop_window)

    -- copy按钮
    cc.ui.UIPushButton.new(Imgs.buyroomcard_btncopy,{scale9=false})
            :setButtonSize(116, 44)
            :setButtonImage(EnStatus.pressed, Imgs.buyroomcard_btncopy_press)
            --:setButtonImage(EnStatus.disabled, Imgs.setting_1row_effect_on)
            :onButtonClicked(function(e)
                VoiceDealUtil:playSound_other(Voices.file.ui_click)
                self:copyContent(self.account.."")
            end)
            :align(display.LEFT_TOP, display.cx-80+160, display.cy+13+6)
            :addTo(self.pop_window)

    -- ip
    if self.ip~= nil then
        cc.ui.UILabel.new({
                UILabelType = 2, 
                --image = "",
                text = "IP："..self.ip, 
                size = Dimens.TextSize_25,
                --color = Colors.black,
                color = Colors:_16ToRGB(Colors.keyboard),
                font = Fonts.Font_hkyt_w9,
                align = cc.ui.TEXT_ALIGN_LEFT,
                valign = cc.ui.TEXT_VALIGN_CENTER,
                --dimensions = cc.size((osWidth-286*2-20*2),0) -- height为0，就是自动换行
            })
            :align(display.LEFT_TOP, display.cx-80, display.cy-32)
            :addTo(self.pop_window)
    else
        cc.ui.UILabel.new({
                UILabelType = 2, 
                --image = "",
                text = "IP：", 
                size = Dimens.TextSize_25,
                --color = Colors.black,
                color = Colors:_16ToRGB(Colors.keyboard),
                font = Fonts.Font_hkyt_w9,
                align = cc.ui.TEXT_ALIGN_LEFT,
                valign = cc.ui.TEXT_VALIGN_CENTER,
                --dimensions = cc.size((osWidth-286*2-20*2),0) -- height为0，就是自动换行
            })
            :align(display.LEFT_TOP, display.cx-80, display.cy-32)
            :addTo(self.pop_window)
    end
end

function CDAlertIP:onExit()
    self:myExit()
end

function CDAlertIP:myExit()
    self.isRefreshBalance = nil

    if self.userid_view ~= nil and (not tolua.isnull(self.userid_view)) then
        self.userid_view:removeFromParent()
        self.userid_view = nil
    end

    if self.pop_window ~= nil and (not tolua.isnull(self.pop_window)) then
        self.pop_window:removeFromParent()
        self.pop_window = nil
    end
end

return CDAlertIP
