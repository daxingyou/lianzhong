--
-- Author: luobinbin
-- Date: 2017-08-01 12:40:33
-- 自定义背景和title的弹窗  需要点击下自动关闭

-- 类申明
local SupEmojiDialog = class("SupEmojiDialog",
    function()
        return display.newNode()
    end)


-- 类变量申明
local osWidth = Commons.osWidth
local osHeight = Commons.osHeight

-- 处理方法申明
local startX_gaping

-- 创建一个模态弹出框,  parent=要加在哪个上面
function SupEmojiDialog:ctor(_icon, _nickname, _account, _ip, _rights, mySeatNo, seatNo)

    -- self.parent = _parent
    self.icon = _icon
    self.nickname = _nickname
    self.account = _account
    self.ip = _ip
    self.rights = _rights
    -- self.isRefreshBalance = _isRefreshBalance

    self.mySeatNo = mySeatNo
    self.seatNo = seatNo
    -- print("=============================", self.mySeatNo, self.seatNo)

    self.pop_window = display.newColorLayer(cc.c4b(0, 0, 0, 100))       -- 半透明的黑色

    self.pop_window:setContentSize(osWidth, osHeight)
    self.pop_window:setTouchEnabled(true)
    self.pop_window:setTouchSwallowEnabled(true)  -- 吞噬下层的响应
    self.pop_window:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event) -- 点击此Layer时候输出信息,然后把自己销毁
        
        return true
    end)
    self:addChild(self.pop_window, CEnum.ZOrder.common_dialog) -- 把Layer添加到父对象上


    startX_gaping = 313
    if CVar._static.isIphone4 then
        startX_gaping = startX_gaping -100
    elseif CVar._static.isIpad then
        startX_gaping = startX_gaping -150
    elseif CVar._static.NavBarH_Android ~= CEnum.status.NavBarH_def then
        startX_gaping = startX_gaping -CVar._static.NavBarH_Android
    end


    ---[[
    -- 整个底色背景
    self.dialogBg = cc.ui.UIImage.new(Imgs.dialog_bg,{scale9=true})
        :addTo(self.pop_window)
    	:align(display.CENTER, display.cx, display.cy)
    	:setLayoutSize(616, 374)
    --]]
    local contentSpriteSize = self.dialogBg:getContentSize()

    -- 内容背景
    cc.ui.UIImage.new(Imgs.dialog_content_bg,{scale9=true})
        :addTo(self.dialogBg)
        :align(display.LEFT_BOTTOM, 15, 15)
        :setLayoutSize(588, 294)

    ---[[
    -- 提示 logo
    cc.ui.UIImage.new(Imgs.imip_title_logo,{scale9=false})
    	:addTo(self.dialogBg)
    	:align(display.CENTER_TOP, contentSpriteSize.width * 0.5, contentSpriteSize.height - 14)
    --]]

    ---[[
    -- 关闭
    cc.ui.UIPushButton.new(Imgs.dialog_exit,{scale9=false})
        -- :setButtonSize(56, 56)
        :setButtonImage(EnStatus.pressed, Imgs.dialog_exit_press)
        :onButtonClicked(function(e)

            VoiceDealUtil:playSound_other(Voices.file.ui_click)
            self:myExit()

        end)
        :align(display.RIGHT_TOP, contentSpriteSize.width - 15, contentSpriteSize.height -0)
    	:addTo(self.dialogBg)
    --]]

    --[[
    -- 确定按钮
    local submitBtn = cc.ui.UIPushButton.new(
        Imgs.dialog_btn_confim_alert,{scale9=false})
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
        :setButtonImage(EnStatus.pressed, Imgs.home_btn_givecard_press)
        :onButtonClicked(function(e)

            VoiceDealUtil:playSound_other(Voices.file.ui_click)
            GiveCardDialog:popDialogBox(self.pop_window, self.account, nil)

        end)
        -- :align(display.CENTER, display.cx, display.cy-100)
        :align(display.LEFT_TOP, 378 +6, contentSpriteSize.height-147 +70)
        :addTo(self.dialogBg)
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

function SupEmojiDialog:copyContent(txt)
    if Commons:checkIsNull_str(txt) then
        local function CDAlertIP_CopyTxt_CallbackLua(txt)
            if Commons.osType == CEnum.osType.A then
                CDAlert.new():popDialogBox(self.pop_window, txt)
            elseif Commons.osType == CEnum.osType.I then
                CDAlert.new():popDialogBox(self.pop_window, txt)
            end

            if self.userid_view ~= nil and (not tolua.isnull(self.userid_view)) then
                self.userid_view:setColor(Colors.green)
            end
        end
        Commons:gotoCopyContent(CDAlertIP_CopyTxt_CallbackLua, txt)
    end
end

-- 内容
function SupEmojiDialog:create_content()
    local contentSpriteSize = self.dialogBg:getContentSize()
	display.newSprite(Imgs.gameing_user_head_bg)
        :align(display.LEFT_TOP, 59, contentSpriteSize.height-88)
        :addTo(self.dialogBg)

    if self.icon ~= nil and self.icon ~= "" then
        NetSpriteImg.new(self.icon, 76, 80)
            :align(display.LEFT_TOP, 59+5, contentSpriteSize.height-88-5)
            :addTo(self.dialogBg)
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
        :align(display.LEFT_TOP, 158, contentSpriteSize.height-92)
        :addTo(self.dialogBg)


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
        :align(display.LEFT_TOP, 158, contentSpriteSize.height-92-32*2)
        :addTo(self.dialogBg)
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
        :align(display.LEFT_TOP, 207, contentSpriteSize.height-92-32*2)
        :addTo(self.dialogBg)
    -- copy按钮
    cc.ui.UIPushButton.new(Imgs.buyroomcard_btncopy,{scale9=false})
            :setButtonSize(116, 44)
            :setButtonImage(EnStatus.pressed, Imgs.buyroomcard_btncopy_press)
            --:setButtonImage(EnStatus.disabled, Imgs.setting_1row_effect_on)
            :onButtonClicked(function(e)

                VoiceDealUtil:playSound_other(Voices.file.ui_click)
                self:copyContent(self.account.."")

            end)
            :align(display.LEFT_TOP, 378, contentSpriteSize.height-147)
            :addTo(self.dialogBg)


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
            :align(display.LEFT_TOP, 158, contentSpriteSize.height-92-32*1)
            :addTo(self.dialogBg)
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
            :align(display.LEFT_TOP, 158, contentSpriteSize.height-92-32*1)
            :addTo(self.dialogBg)
    end

    -- 内容背景
    cc.ui.UIImage.new(ImgsM.outu_bg,{scale9=true})
        :addTo(self.dialogBg)
        :align(display.LEFT_BOTTOM, 26, 26)
        :setLayoutSize(564, 154)

    local biaoQingList = {ImgsM.flower, ImgsM.bangzhuang, ImgsM.egg, ImgsM.water}

    local offsetLength = 135
    for i=1,4 do
        local biaoqingBg = cc.ui.UIPushButton.new(ImgsM.biaoqing_bg,{scale9=false})
            :setButtonSize(126, 155)
            :setButtonImage(EnStatus.pressed, ImgsM.biaoqing_bg)
            :onButtonClicked(function(e)

                VoiceDealUtil:playSound_other(Voices.file.ui_click)
                local tempSeatNo = self.seatNo
                --当前是我的座位号时，代表群发
                if self.seatNo == self.mySeatNo then
                    tempSeatNo = -1
                end

                --发送超级表情
                MJSocketGameing:gameing_SuperEmoji(tostring(i), tempSeatNo) 

                self:myExit()  

            end)
            :align(display.LEFT_BOTTOM, 42 + offsetLength * (i-1), 26)
            :addTo(self.dialogBg)

        local contentSpriteSize = biaoqingBg:getContentSize()

        cc.ui.UIImage.new(biaoQingList[i],{scale9=false})
            :addTo(biaoqingBg)
            :align(display.CENTER, 63, 72)

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
            :align(display.LEFT_TOP, contentSpriteSize.width * 0.5, contentSpriteSize.height-5)
            :addTo(biaoqingBg)
    end
end

function SupEmojiDialog:onExit()
    self:myExit()
end

function SupEmojiDialog:myExit()
    -- self.isRefreshBalance = nil

    if self.userid_view ~= nil and (not tolua.isnull(self.userid_view)) then
        self.userid_view:removeFromParent()
        self.userid_view = nil
    end

    if self.pop_window ~= nil and (not tolua.isnull(self.pop_window)) then
        self.pop_window:removeFromParent()
        self.pop_window = nil
    end
end

return SupEmojiDialog
