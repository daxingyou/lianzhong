--
-- Author: lte
-- Date: 2016-11-04 17:37:29
-- 购买房卡的弹窗

-- 类申明
local BuyRoomcardDialog = class("BuyRoomcardDialog"
    -- ,function()
    --     return display.newNode()
    -- end
    )


local osWidth = Commons.osWidth
local osHeight = Commons.osHeight

local gaping_w -- 整个图层的左右间距
local gaping_h -- 整个图层的上下间距
local gaping_x -- 内容背景，左右 底部 间距
local gaping_y -- 内容背景，顶部间距

function BuyRoomcardDialog:ctor()
end

-- 创建一个模态弹出框,  parent=要加在哪个上面
function BuyRoomcardDialog:popDialogBox(_parent, proxies)

    self.parent = _parent

    self.pop_window = display.newColorLayer(cc.c4b(0, 0, 0, 100))       -- 半透明的黑色

    self.pop_window:setContentSize(osWidth, osHeight)             -- 设置Layer的大小,全屏出现
    --self.pop_window:align(display.CENTER, display.cx, display.cy) -- Layer的锚点在0.5,0.5 因此对齐的时候要注意
    self.pop_window:setTouchEnabled(true)
    self.pop_window:setTouchSwallowEnabled(true)  -- 吞噬下层的响应
    self.pop_window:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event) -- 点击此Layer时候输出信息,然后把自己销毁
        return true
    end)
    self.parent:addChild(self.pop_window, CEnum.ZOrder.common_dialog) -- 把Layer添加到父对象上


    gaping_w = 300
    gaping_h = 170
    gaping_x = 10
    gaping_y = 74

    if CVar._static.isIphone4 then
        gaping_w = gaping_w-100
    elseif CVar._static.isIpad then
        gaping_w = gaping_w-170
    elseif CVar._static.NavBarH_Android ~= CEnum.status.NavBarH_def then
        gaping_w = gaping_w -CVar._static.NavBarH_Android
    end


    ---[[
    -- 整个底色背景
    cc.ui.UIImage.new(Imgs.dialog_bg,{})
        :addTo(self.pop_window)
    	:align(display.CENTER, display.cx, display.cy)
        :setLayoutSize(osWidth -gaping_w*2, osHeight -gaping_h*2)
    --]]

    -- 内容背景
    cc.ui.UIImage.new(Imgs.dialog_content_bg,{})
        :addTo(self.pop_window)
        :align(display.CENTER, display.cx, display.cy -gaping_y*0.5)
        :setLayoutSize(osWidth -gaping_w*2 -gaping_x*2, osHeight -gaping_h*2 -gaping_y -gaping_x)

    -- logo
    cc.ui.UIImage.new(Imgs.dialog_title_logo,{})
    	:addTo(self.pop_window)
    	:align(display.CENTER_TOP, display.cx, osHeight -gaping_h -11)


	-- view
	self:create_EffectView(proxies)

    -- 关闭
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
            -- 固定一个值，测试输入之后显示值
            -- self:showNumbers_deal(6, _position)
            --_position = _position+1
            self:myExit()

        end)
        :addTo(self.pop_window)
        :align(display.RIGHT_TOP, osWidth -gaping_w -gaping_x, osHeight -gaping_h -11)

    ---[[
    -- 确定按钮
    cc.ui.UIPushButton.new(
        Imgs.dialog_btn_confim_alert,{scale9=false})
        :setButtonSize(180, 84)
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
        :align(display.CENTER_BOTTOM, display.cx, gaping_h +10)
        :addTo(self.pop_window)
    --]]

end

function BuyRoomcardDialog:create_EffectView(proxies)

    local startX_1row = gaping_w +88
    if CVar._static.isIphone4 or CVar._static.isIpad then
        startX_1row = startX_1row -28
    end
    local startY_1row = osHeight -gaping_h -gaping_y -40

    --Commons:printLog_Info("===============================333333333333=",proxies)
    if Commons:checkIsNull_tableList(proxies) then
        for k,v in pairs(proxies) do
            local descript = RequestBase:getStrDecode(v[Proxies.Bean.descript])
            local proxyNo = RequestBase:getStrDecode(v[Proxies.Bean.proxyNo])
            --Commons:printLog_Info("===============================333333333333=",k, type(k))
            --Commons:printLog_Info("===============================333333333333=",descript)
            --Commons:printLog_Info("===============================333333333333=",proxyNo)
            if k == 1 then
                -- 1 row
                -- cc.ui.UIImage.new(Imgs.buyroomcard_1row_logo, {scale9=false})
                -- 	:align(display.LEFT_TOP, 298+10+78, osHeight-188-74-52 -0)
                --     :addTo(self.pop_window)
                cc.ui.UILabel.new({
                        UILabelType = 2, 
                        --image = "",
                        text = descript, 
                        size = Dimens.TextSize_30,
                        --color = Colors.black,
                        color = Colors:_16ToRGB(Colors.help_txt),
                        font = Fonts.Font_hkyt_w9,
                        align = cc.ui.TEXT_ALIGN_LEFT,
                        valign = cc.ui.TEXT_VALIGN_CENTER,
                        --dimensions = cc.size((osWidth-120),0) -- height为0，就是自动换行
                        dimensions = cc.size(400,50)
                    })
                    :align(display.LEFT_TOP, startX_1row, startY_1row -0)
                    :addTo(self.pop_window)

                -- local txtLabel1 = 
                cc.ui.UILabel.new({
                        UILabelType = 2, 
                        --image = "",
                        text = proxyNo.."", 
                        size = Dimens.TextSize_30,
                        --color = Colors.black,
                        color = Colors:_16ToRGB(Colors.help_txt),
                        font = Fonts.Font_hkyt_w7,
                        align = cc.ui.TEXT_ALIGN_LEFT,
                        valign = cc.ui.TEXT_VALIGN_CENTER,
                        --dimensions = cc.size((osWidth-120),0) -- height为0，就是自动换行
                        dimensions = cc.size(200,50)
                    })
                    :align(display.LEFT_TOP, startX_1row +182+20, startY_1row +5)
                    --:addTo(self.pop_window)

                cc.ui.UIPushButton.new(Imgs.buyroomcard_btncopy,{scale9=false})
                	:setButtonSize(116, 44)
                    :setButtonImage(EnStatus.pressed, Imgs.buyroomcard_btncopy_press)
                	--:setButtonImage(EnStatus.disabled, Imgs.setting_1row_effect_on)
                    :onButtonClicked(function(e)

                        VoiceDealUtil:playSound_other(Voices.file.ui_click)
                        local function CDAlertIP_CopyTxt_CallbackLua(txt)
			                CDAlert.new():popDialogBox(self.pop_window, txt)
			            end
			            Commons:gotoCopyContent(CDAlertIP_CopyTxt_CallbackLua, proxyNo.."")

                    end)
                    :align(display.LEFT_TOP, startX_1row +182+20 +200+20, startY_1row -0)
                    :addTo(self.pop_window)

            elseif k == 2 then
                -- 2 row
                -- cc.ui.UIImage.new(Imgs.buyroomcard_2row_logo, {scale9=false})
                --     :align(display.LEFT_TOP, 298+10+78, osHeight-188-74-52 -35-32)
                --     :addTo(self.pop_window)
                cc.ui.UILabel.new({
                        UILabelType = 2, 
                        --image = "",
                        text = descript, 
                        size = Dimens.TextSize_30,
                        --color = Colors.black,
                        color = Colors:_16ToRGB(Colors.help_txt),
                        font = Fonts.Font_hkyt_w9,
                        align = cc.ui.TEXT_ALIGN_LEFT,
                        valign = cc.ui.TEXT_VALIGN_CENTER,
                        --dimensions = cc.size((osWidth-120),0) -- height为0，就是自动换行
                        dimensions = cc.size(400,50)
                    })
                    :align(display.LEFT_TOP, startX_1row, startY_1row -35-30 -0)
                    :addTo(self.pop_window)

                -- local txtLabel2 = 
                cc.ui.UILabel.new({
                        UILabelType = 2, 
                        --image = "",
                        text = proxyNo.."", 
                        size = Dimens.TextSize_30,
                        --color = Colors.black,
                        color = Colors:_16ToRGB(Colors.help_txt),
                        font = Fonts.Font_hkyt_w7,
                        align = cc.ui.TEXT_ALIGN_LEFT,
                        valign = cc.ui.TEXT_VALIGN_CENTER,
                        --dimensions = cc.size((osWidth-120),0) -- height为0，就是自动换行
                        --dimensions = cc.size(200,50)
                    })
                    :align(display.LEFT_TOP, startX_1row +182+20, startY_1row -35-30 +2)
                    --:addTo(self.pop_window)


                cc.ui.UIPushButton.new(Imgs.buyroomcard_btncopy,{scale9=false})
                    :setButtonSize(116, 44)
                    :setButtonImage(EnStatus.pressed, Imgs.buyroomcard_btncopy_press)
                    --:setButtonImage(EnStatus.disabled, Imgs.setting_1row_effect_on)
                    :onButtonClicked(function(e)

                        VoiceDealUtil:playSound_other(Voices.file.ui_click)
                        local function CDAlertIP_CopyTxt_CallbackLua(txt)
			                CDAlert.new():popDialogBox(self.pop_window, txt)
			            end
			            Commons:gotoCopyContent(CDAlertIP_CopyTxt_CallbackLua, proxyNo.."")

                    end)
                    :align(display.LEFT_TOP, startX_1row +182+20 +200+20, startY_1row -35-27 -0)
                    :addTo(self.pop_window)

            elseif k == 3 then
                -- 2 row
                -- cc.ui.UIImage.new(Imgs.buyroomcard_2row_logo, {scale9=false})
                --     :align(display.LEFT_TOP, 298+10+78, osHeight-188-74-52 -35-32)
                --     :addTo(self.pop_window)
                cc.ui.UILabel.new({
                        UILabelType = 2, 
                        --image = "",
                        text = descript, 
                        size = Dimens.TextSize_30,
                        --color = Colors.black,
                        color = Colors:_16ToRGB(Colors.help_txt),
                        font = Fonts.Font_hkyt_w9,
                        align = cc.ui.TEXT_ALIGN_LEFT,
                        valign = cc.ui.TEXT_VALIGN_CENTER,
                        --dimensions = cc.size((osWidth-120),0) -- height为0，就是自动换行
                        dimensions = cc.size(400,50)
                    })
                    :align(display.LEFT_TOP, startX_1row, startY_1row -35-27 -35-27 -0)
                    :addTo(self.pop_window)

                -- local txtLabel3 = 
                cc.ui.UILabel.new({
                        UILabelType = 2, 
                        --image = "",
                        text = proxyNo.."", 
                        size = Dimens.TextSize_30,
                        --color = Colors.black,
                        color = Colors:_16ToRGB(Colors.help_txt),
                        font = Fonts.Font_hkyt_w7,
                        align = cc.ui.TEXT_ALIGN_LEFT,
                        valign = cc.ui.TEXT_VALIGN_CENTER,
                        --dimensions = cc.size((osWidth-120),0) -- height为0，就是自动换行
                        dimensions = cc.size(200,50)
                    })
                    :align(display.LEFT_TOP, startX_1row +182+20, startY_1row -35-27 -35-27 +5)
                    --:addTo(self.pop_window)


                cc.ui.UIPushButton.new(Imgs.buyroomcard_btncopy,{scale9=false})
                    :setButtonSize(116, 44)
                    :setButtonImage(EnStatus.pressed, Imgs.buyroomcard_btncopy_press)
                    --:setButtonImage(EnStatus.disabled, Imgs.setting_1row_effect_on)
                    :onButtonClicked(function(e)

                        VoiceDealUtil:playSound_other(Voices.file.ui_click)
                        local function CDAlertIP_CopyTxt_CallbackLua(txt)
			                CDAlert.new():popDialogBox(self.pop_window, txt)
			            end
			            Commons:gotoCopyContent(CDAlertIP_CopyTxt_CallbackLua, proxyNo.."")

                    end)
                    :align(display.LEFT_TOP, startX_1row +182+20 +200+20, startY_1row -35-27 -35-27 -0)
                    :addTo(self.pop_window)
            end
        end
    end
	
end

function BuyRoomcardDialog:onExit()
    self:myExit()
end

function BuyRoomcardDialog:myExit()
    if self.pop_window ~= nil and (not tolua.isnull(self.pop_window)) then
        self.pop_window:removeFromParent()
        self.pop_window = nil
    end
end

return BuyRoomcardDialog
