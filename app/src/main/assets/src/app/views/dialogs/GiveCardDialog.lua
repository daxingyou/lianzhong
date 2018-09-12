--
-- Author: lte
-- Date: 2016-11-04 17:37:29
-- 转卡的弹窗

-- 类申明
local GiveCardDialog = class("GiveCardDialog"
    -- ,function()
    --     return display.newNode()
    -- end
    )


local osWidth = Commons.osWidth
local osHeight = Commons.osHeight


local card_yushu = 0

local tipErrorTextView

local _2row_card_yushuView
local _2row_card_zhangView
local _2row_card_jiaoyiView

local nickname_view

-- local _3row_inputView
-- local _4row_inputView
-- local _42row_inputView
-- local _5row_inputView

local _3row_inputView_new
-- local _4row_inputView_new
local _42row_inputView_new
local _5row_inputView_new

local _3row_input_txt_new
-- local _4row_input_txt_new
local _42row_input_txt_new
local _5row_input_txt_new

-- 处理方法申明
local gaping_w -- 整个图层的左右间距
local gaping_h -- 整个图层的上下间距
local gaping_x -- 内容背景，左右 底部 间距
local gaping_y -- 内容背景，顶部间距

function GiveCardDialog:ctor()
end

-- 创建一个模态弹出框,  parent=要加在哪个上面
function GiveCardDialog:popDialogBox(_parent, _user_account, _isRefreshBalance)

    self.parent = _parent
    self.user_account = _user_account
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


    gaping_w = 280
    gaping_h = 110
    gaping_x = 10 
    gaping_y = 74 

    if CVar._static.isIphone4 then
        gaping_w = gaping_w-100
    elseif CVar._static.isIpad then
        gaping_w = gaping_w-170
    elseif CVar._static.NavBarH_Android ~= CEnum.status.NavBarH_def then
        gaping_w = gaping_w -CVar._static.NavBarH_Android/2
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
    cc.ui.UIImage.new(Imgs.givecard_title_logo,{})
    	:addTo(self.pop_window)
    	:align(display.CENTER_TOP, display.cx, osHeight -gaping_h -11)

    ---[[
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
            self:myExit()

        end)
    	:addTo(self.pop_window)
        :align(display.RIGHT_TOP, osWidth -gaping_w -gaping_x, osHeight -gaping_h -11)
    --]]

	-- view
	self:create_EffectView()

    ---[[
    -- 确定按钮
    cc.ui.UIPushButton.new(
        Imgs.dialog_btn_confim_alert,{scale9=false})
        -- :setButtonSize(180, 84)
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
            self:myConfim()

        end)
        :align(display.CENTER_BOTTOM, display.cx, gaping_h +40)
        :addTo(self.pop_window)
    --]]

    -- 错误提示
    tipErrorTextView = cc.ui.UILabel.new({
            UILabelType = 2, 
            --image = "",
            text = "", 
            size = Dimens.TextSize_25,
            color = Colors.red,
            --color = Colors:_16ToRGB(Colors.gameing_roomNo),
            font = Fonts.Font_hkyt_w7,
            align = cc.ui.TEXT_ALIGN_LEFT,
            valign = cc.ui.TEXT_VALIGN_CENTER,
            --dimensions = cc.size((osWidth-120),0) -- height为0，就是自动换行
            --dimensions = cc.size(200,50)
        })
        :align(display.CENTER_BOTTOM, display.cx, gaping_h +40+84+10)
        :addTo(self.pop_window)

    cc.ui.UILabel.new({
            UILabelType = 2, 
            --image = "",
            text = "注意：可以用密码登录后台转卡系统", 
            size = Dimens.TextSize_20,
            --color = Colors.black,
            color = Colors:_16ToRGB(Colors.gameing_huxi),
            font = Fonts.Font_hkyt_w9,
            align = cc.ui.TEXT_ALIGN_LEFT,
            valign = cc.ui.TEXT_VALIGN_CENTER,
            --dimensions = cc.size((osWidth-120),0) -- height为0，就是自动换行
            --dimensions = cc.size(200,50)
        })
        :align(display.LEFT_BOTTOM, gaping_w +10+30, gaping_h +10)
        :addTo(self.pop_window)

    --local param = {};
    RequestHome:getRoomBalance(nil, function(...) self:resDataRoomBalance(...) end)

end

function GiveCardDialog:resDataRoomBalance(jsonObj)
    local startX_givecard = gaping_w +114
    local startY_givecard = osHeight -gaping_h-gaping_y

    if jsonObj ~= nil then
        local status = jsonObj[ParseBase.status]
        local msg = RequestBase:getStrDecode(jsonObj[ParseBase.msg])
        Commons:printLog_Info("状态是：", status, "内容是：", msg)

        if status ~= nil and status==CEnum.status.success  then
            card_yushu = jsonObj[ParseBase.data][User.Bean.wallet][Wallet.Bean.balance]
            --Commons:printLog_Info("===",card_yushu, type(card_yushu))
            if card_yushu ~= nil then
                _2row_card_yushuView:setString(tostring(card_yushu))
                _2row_card_yushuView:setVisible(false)

                local _size = 0
                if Commons:checkIsNull_numberType(card_yushu) then
                    -- 胡息
                    local _string = tostring(card_yushu)
                    _size = string.len(_string)
                    for i=1,_size do
                        local i_str = string.sub(_string, i, i)
                        local img_i = GameingDealUtil:getNumImg_by_scoreResult(i_str)
                        --cc.ui.UIImage.new(img_i,{scale9=false})
                        cc.ui.UIPushButton.new(img_i,{scale9=false})
                            :setButtonSize(20, 20)
                            :addTo(self.pop_window)
                            :align(display.LEFT_TOP, startX_givecard +170 +0+19*(i-1), startY_givecard -9-15)
                    end
                end

                _2row_card_zhangView:align(display.LEFT_TOP, startX_givecard +170 +0+19*_size +8, startY_givecard -9)
                _2row_card_jiaoyiView:align(display.LEFT_TOP, startX_givecard +170 +0+19*_size +8 +50, startY_givecard -9-3)
            end
        end
    end
end

function GiveCardDialog:myConfim()
    --Commons:printLog_Info("----------_3row_inputView:::",_3row_inputView)
    --Commons:printLog_Info("----------_4row_inputView:::",_4row_inputView)
    --Commons:printLog_Info("----------_42row_inputView:::",_42row_inputView)
    --Commons:printLog_Info("----------_5row_inputView:::",_5row_inputView)
    --Commons:printLog_Info("----------tipErrorTextView:::",tipErrorTextView)

    local _3row_input_txt = _3row_input_txt_new -- _3row_inputView:getText()
    -- local _4row_input_txt = _4row_input_txt_new -- _4row_inputView:getText()
	local _42row_input_txt = _42row_input_txt_new -- _42row_inputView:getText()
	local _5row_input_txt = _5row_input_txt_new --_5row_inputView:getText()

	tipErrorTextView:setString("")

	if not Commons:checkIsNull_str(_3row_input_txt) then
		--CDAlert.new():popDialogBox(parent, "用户ID不能为空")
		tipErrorTextView:setString("用户ID不能为空")
		return
	end

	-- if not Commons:checkIsNull_str(_4row_input_txt) then
	-- 	--CDAlert.new():popDialogBox(parent, "再次确认用户ID不能为空")
	-- 	tipErrorTextView:setString("再次确认用户ID不能为空")
	-- 	return
	-- end

	-- if _3row_input_txt~=_4row_input_txt then
	-- 	--CDAlert.new():popDialogBox(parent, "两次输入的用户ID不相同")
	-- 	tipErrorTextView:setString("两次输入的用户ID不相同")
	-- 	return
	-- end

    local _transPasw = ""
    if not Commons:checkIsNull_str(_42row_input_txt) then
        --CDAlert.new():popDialogBox(parent, "再次确认用户ID不能为空")
        tipErrorTextView:setString("您的密码不能为空")
        return
    else
        _transPasw = string.upper(crypto.md5(_42row_input_txt))
    end

	if not Commons:checkIsNull_str(_5row_input_txt) and "0"~=_5row_input_txt then
		--CDAlert.new():popDialogBox(parent, "转卡数量不能为空")
		tipErrorTextView:setString("转卡数量不能为空")
		return
	end

    self.loadingPop_window_givecard = CDAlertLoading.new():popDialogBox(self.pop_window, Strings.hint_Loading)

    Commons:printLog_Info("========转卡信息是:::", _3row_input_txt, _5row_input_txt, _transPasw)
	local param = {targetAccount=_3row_input_txt, amount=_5row_input_txt, transPasw=_transPasw};
	RequestHome:getGiveCard(param, function(...) self:resDataGiveCard(...) end)
end

function GiveCardDialog:resDataGiveCard(jsonObj)
    if self.loadingPop_window_givecard~=nil and (not tolua.isnull(self.loadingPop_window_givecard)) then
        self.loadingPop_window_givecard:removeFromParent()
        self.loadingPop_window_givecard = nil
    end

    if jsonObj~=nil then
        local status = jsonObj[ParseBase.status]
        local msg = RequestBase:getStrDecode(jsonObj[ParseBase.msg])
        Commons:printLog_Info("状态是：", status, "内容是：", msg)

        if status ~= nil and status == CEnum.status.success then
            if self.isRefreshBalance ~= nil and self.isRefreshBalance then
                -- HomeScene:getRoomBalance_home()
                local currentScene = display.getRunningScene()
                if currentScene then
                    currentScene:getRoomBalance_home()
                end
            end

    	    CDAlert.new():popDialogBox(self.parent, msg)
            self:myExit()
        else
        	--tipErrorTextView:setString(msg)
            CDAlert.new():popDialogBox(self.pop_window, msg)
    	end
    end
end

function GiveCardDialog_onEdit_5row(event, editbox)
    if event == "began" then
        -- 开始输入
        --Commons:printLog_Info("开始输入")
        tipErrorTextView:setString("")
    elseif event == "changed" then
        -- 输入框内容发生变化
        local text = editbox:getText()
        --Commons:printLog_Info("输入框内容发生变化", text, type(text))
        local textInt = tonumber(text)
        if Commons:checkIsNull_str(text) and textInt>card_yushu then
            --Commons:printLog_Info("22输入框内容发生变化", text, type(text))
            tipErrorTextView:setString("超出剩余量")
        end
    elseif event == "ended" then
        -- 输入结束
        --Commons:printLog_Info("输入结束")
    elseif event == "return" then
        -- 从输入框返回
        --Commons:printLog_Info("从输入框返回")
    end
end

function GiveCardDialog:resData_TradeLogs(jsonObj)
    if self.loadingPop_window_TradeLogs~=nil and (not tolua.isnull(self.loadingPop_window_TradeLogs)) then
        self.loadingPop_window_TradeLogs:removeFromParent()
        self.loadingPop_window_TradeLogs = nil
    end

    if jsonObj ~= nil then
        local status = jsonObj[ParseBase.status]
        local msg = RequestBase:getStrDecode(jsonObj[ParseBase.msg])
        -- Commons:printLog_Info("状态是：", status, "内容是：", msg)

        if status ~= nil and status==CEnum.status.success  then
            local _data = jsonObj[ParseBase.data];
            if _data~=nil then
                local tradeLogs = _data[TradeLog.Bean.tradeLogs]
                if Commons:checkIsNull_tableList(tradeLogs) then
                    TradeLogDialog:popDialogBox(self.pop_window, tradeLogs)
                else
                    CDAlert.new():popDialogBox(self.pop_window, Strings.gameing.noData_TradeLogs)
                end
            else
                CDAlert.new():popDialogBox(self.pop_window, Strings.gameing.noData_TradeLogs)
            end
        end
    end
end

function GiveCardDialog:create_EffectView()
    local startX_givecard = gaping_w +114
    local startY_givecard = osHeight -gaping_h-gaping_y -3
    local gaping_givecard = 20  -- 第2行拉大点距离显示昵称

	-- 1 row
	cc.ui.UILabel.new({
            UILabelType = 2, 
            --image = "",
            text = "用 户："..self.user_account, 
            size = Dimens.TextSize_30,
            --color = Colors.black,
            color = Colors:_16ToRGB(Colors.gameing_huxi),
            font = Fonts.Font_hkyt_w9,
            align = cc.ui.TEXT_ALIGN_LEFT,
            valign = cc.ui.TEXT_VALIGN_CENTER,
            --dimensions = cc.size((osWidth-120),0) -- height为0，就是自动换行
            dimensions = cc.size(300,50)
        })
        :align(display.LEFT_TOP, startX_givecard, startY_givecard )
        :addTo(self.pop_window)
        :setVisible(false)



    -- 2 row
    cc.ui.UILabel.new({
            UILabelType = 2, 
            --image = "",
            text = "卡 数：剩余", 
            size = Dimens.TextSize_30,
            --color = Colors.black,
            color = Colors:_16ToRGB(Colors.gameing_huxi),
            font = Fonts.Font_hkyt_w9,
            align = cc.ui.TEXT_ALIGN_LEFT,
            valign = cc.ui.TEXT_VALIGN_CENTER,
            --dimensions = cc.size((osWidth-120),0) -- height为0，就是自动换行
            dimensions = cc.size(200,50)
        })
        :align(display.LEFT_TOP, startX_givecard -3, startY_givecard -6)
        :addTo(self.pop_window)

    _2row_card_yushuView = cc.ui.UILabel.new({
            UILabelType = 2, 
            --image = "",
            text = card_yushu, 
            size = Dimens.TextSize_30,
            --color = Colors.black,
            color = Colors:_16ToRGB(Colors.gameing_roomNo),
            font = Fonts.Font_hkyt_w9,
            align = cc.ui.TEXT_ALIGN_LEFT,
            valign = cc.ui.TEXT_VALIGN_CENTER,
            --dimensions = cc.size((osWidth-120),0) -- height为0，就是自动换行
            dimensions = cc.size(200,50)
        })
        :align(display.LEFT_TOP, startX_givecard +0 +170, startY_givecard -6)
        :addTo(self.pop_window)

    _2row_card_zhangView = cc.ui.UILabel.new({
            UILabelType = 2, 
            --image = "",
            text = "张", 
            size = Dimens.TextSize_30,
            --color = Colors.black,
            color = Colors:_16ToRGB(Colors.gameing_huxi),
            font = Fonts.Font_hkyt_w9,
            align = cc.ui.TEXT_ALIGN_LEFT,
            valign = cc.ui.TEXT_VALIGN_CENTER,
            --dimensions = cc.size((osWidth-120),0) -- height为0，就是自动换行
            dimensions = cc.size(200,50)
        })
        :align(display.LEFT_TOP, startX_givecard +0 +170 +80, startY_givecard -6)
        :addTo(self.pop_window)

    -- 2.2 - 交易记录
    _2row_card_jiaoyiView = cc.ui.UIPushButton.new(
        -- Imgs.c_transparent,{scale9=false})
        Imgs.tradelog_btn,{scale9=false})
        --:setButtonSize(72, 100)
        -- :setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
        --     UILabelType = 2,
        --     text = "交易记录",
        --     size = Dimens.TextSize_30,
        --     --color = Colors.versionName,
        --     color = Colors:_16ToRGB(Colors.dissRoom_green),
        --     font = Fonts.Font_hkyt_w9,
        --  }))
        -- :setButtonLabel(EnStatus.pressed, cc.ui.UILabel.new({
        --  UILabelType = 2,
        --  text = "",
        --  size = Dimens.TextSize_30,
        --  color = Colors.btn_press,
        --  }))
        --:setButtonImage(EnStatus.disabled, Imgs.gameing_user_prepare_ok)
        --:setButtonImage(EnStatus.pressed, Imgs.gameing_btn_prepare_press)
        :onButtonClicked(function(e)

            VoiceDealUtil:playSound_other(Voices.file.ui_click)
            self.loadingPop_window_TradeLogs = CDAlertLoading.new():popDialogBox(self.pop_window, Strings.hint_Loading)
            --local param = {};
            RequestHome:getTradeLogs(nil, function(...) self:resData_TradeLogs(...) end)

        end)
        :align(display.LEFT_TOP, startX_givecard +0 +170 +80 +60, startY_givecard -9)
        :addTo(self.pop_window)

    -- 3.0 row
    nickname_view = cc.ui.UILabel.new({
            UILabelType = 2, 
            --image = "",
            text = "转给张三李四王五", 
            size = Dimens.TextSize_20,
            color = Colors.red,
            -- color = Colors:_16ToRGB(Colors.gameing_huxi),
            font = Fonts.Font_hkyt_w7,
            align = cc.ui.TEXT_ALIGN_LEFT,
            valign = cc.ui.TEXT_VALIGN_CENTER,
            --dimensions = cc.size((osWidth-120),0) -- height为0，就是自动换行
            dimensions = cc.size(320,30) -- =120，30就控制了6个字
        })
        :align(display.LEFT_TOP, startX_givecard +160, startY_givecard -45)
        :addTo(self.pop_window)
        :setVisible(false)



    -- 3 row
    cc.ui.UILabel.new({
            UILabelType = 2, 
            --image = "",
            text = "收卡用户ID", 
            size = Dimens.TextSize_30,
            --color = Colors.black,
            color = Colors:_16ToRGB(Colors.gameing_huxi),
            font = Fonts.Font_hkyt_w9,
            align = cc.ui.TEXT_ALIGN_LEFT,
            valign = cc.ui.TEXT_VALIGN_CENTER,
            --dimensions = cc.size((osWidth-120),0) -- height为0，就是自动换行
            dimensions = cc.size(200,50)
        })
        :align(display.LEFT_TOP, startX_givecard, startY_givecard -60 -gaping_givecard)
        :addTo(self.pop_window)

    local function _3row_inputView_function(_value)
        _3row_input_txt_new = _value
        if Commons:checkIsNull_str(_value) then

            local function GiveCardDialog_resData_givecard_userNickname(jsonObj)
                Commons:printLog_Info("resData_givecard_userNickname:::", jsonObj)

                if jsonObj~=nil then
                    local status = jsonObj[ParseBase.status]
                    local msg = RequestBase:getStrDecode(jsonObj[ParseBase.msg])
                    Commons:printLog_Info("状态是：", status, "内容是：", msg)

                    if status ~= nil and status == CEnum.status.success then
                        local _data = jsonObj[ParseBase.data];
                        if _data~=nil then
                            local user = _data[User.Bean.user]
                            if user~=nil then
                                local nickname = RequestBase:getStrDecode(user[User.Bean.nickname])
                                Commons:printLog_Info("user 昵称：", nickname)
                                nickname_view:setString(nickname)
                                nickname_view:setVisible(true)
                            else
                                nickname_view:setString("用户ID有误")
                                nickname_view:setVisible(true)
                            end
                        else
                            nickname_view:setString("用户ID有误")
                            nickname_view:setVisible(true)
                        end
                    else
                        nickname_view:setString(msg)
                        nickname_view:setVisible(true)
                    end
                end
            end
            local param = {
                targetAccount=_value
            }
            RequestHome:getUserNickname(param, GiveCardDialog_resData_givecard_userNickname)

            _3row_inputView_new:setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
                        UILabelType = 2,
                        text = _value,
                        size = Dimens.TextSize_25,
                        color = Colors.black,
                        -- color = Colors:_16ToRGB(Colors.dissRoom_green),
                        -- color = Colors:_16ToRGB(Colors.result_round_bg2),
                        font = Fonts.Font_hkyt_w7,
                        align = cc.ui.TEXT_ALIGN_CENTER,
                        valign = cc.ui.TEXT_VALIGN_CENTER,
                     }))
        else
            _3row_inputView_new:setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
                    UILabelType = 2,
                    text = "请输入用户ID    ",
                    size = Dimens.TextSize_25,
                    -- color = Colors.gray,
                    -- color = Colors:_16ToRGB(Colors.dissRoom_green),
                    color = Colors:_16ToRGB(Colors.result_round_bg2),
                    font = Fonts.Font_hkyt_w7,
                    align = cc.ui.TEXT_ALIGN_CENTER,
                    valign = cc.ui.TEXT_VALIGN_CENTER,
                 }))
        end
    end
    _3row_inputView_new = cc.ui.UIPushButton.new(
        Imgs.c_edit_bg,{scale9=true})
        :setButtonSize(220, 45)
        :setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
            UILabelType = 2,
            text = "请输入用户ID    ",
            size = Dimens.TextSize_25,
            -- color = Colors.gray,
            -- color = Colors:_16ToRGB(Colors.dissRoom_green),
            color = Colors:_16ToRGB(Colors.result_round_bg2),
            font = Fonts.Font_hkyt_w7,
            align = cc.ui.TEXT_ALIGN_CENTER,
            valign = cc.ui.TEXT_VALIGN_CENTER,
         }))
        :onButtonClicked(function(e)

            VoiceDealUtil:playSound_other(Voices.file.ui_click)
            KeyboardNumberDialog:popDialogBox(self.pop_window, _3row_inputView_function)

        end)
        :align(display.LEFT_TOP, startX_givecard +160, startY_givecard -60 -gaping_givecard)
        :addTo(self.pop_window)
        :setVisible(true)

    -- 3.2 - 粘贴
    _3row_zhantie_View = cc.ui.UIPushButton.new(
        -- Imgs.c_transparent,{scale9=false})
        Imgs.getCopyContent_btn,{scale9=false})
        --:setButtonSize(72, 100)
        :onButtonClicked(function(e)

            VoiceDealUtil:playSound_other(Voices.file.ui_click)
            local function GiveCardDialog_getCopyTxt_CallbackLua(txt)
                _3row_inputView_function(txt)
            end
            Commons:getCopyContent(GiveCardDialog_getCopyTxt_CallbackLua)

        end)
        :align(display.LEFT_TOP, startX_givecard +160 +230, startY_givecard -60-3 -gaping_givecard)
        :addTo(self.pop_window)



    --[[
    -- 4 row
    cc.ui.UILabel.new({
            UILabelType = 2, 
            --image = "",
            text = "再次输入ID", 
            size = Dimens.TextSize_30,
            --color = Colors.black,
            color = Colors:_16ToRGB(Colors.gameing_huxi),
            font = Fonts.Font_hkyt_w9,
            align = cc.ui.TEXT_ALIGN_LEFT,
            valign = cc.ui.TEXT_VALIGN_CENTER,
            --dimensions = cc.size((osWidth-120),0) -- height为0，就是自动换行
            dimensions = cc.size(200,50)
        })
        :align(display.LEFT_TOP, startX_givecard, startY_givecard -60*2 -gaping_givecard)
        :addTo(self.pop_window)

  --   _4row_inputView = cc.ui.UIInput.new({
	 --    	--UIInputType = 1,
	 --    	listener = GiveCardDialog_onEdit_4row,
		-- 	image = Imgs.c_edit_bg,
		-- 	--imagePressed = Imgs.Edit_Press,
		-- 	--imageDisabled = Imgs.Edit_Disable,
		-- 	size = CCSize(220,40),
		-- 	--x = display.cx,
		-- 	--y = display.cy + 100,
		-- })
		-- :align(display.LEFT_TOP, startX_givecard +160, osHeight-128-74-15 -52 -60 -50 +30)
		-- :addTo(self.pop_window)
		-- :setPlaceHolder("请再次输入ID")--提示输入文本
		-- --:setText("你好")
		-- --:setFontSize(Dimens.TextSize_25)
		-- --:setFontColor(Colors.black)
  --       :setVisible(false)

    local function _4row_inputView_function(_value)
        _4row_input_txt_new = _value
        if Commons:checkIsNull_str(_value) then
            _4row_inputView_new:setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
                        UILabelType = 2,
                        text = _value,
                        size = Dimens.TextSize_25,
                        color = Colors.black,
                        -- color = Colors:_16ToRGB(Colors.dissRoom_green),
                        -- color = Colors:_16ToRGB(Colors.result_round_bg2),
                        font = Fonts.Font_hkyt_w7,
                        align = cc.ui.TEXT_ALIGN_CENTER,
                        valign = cc.ui.TEXT_VALIGN_CENTER,
                     }))
        else
            _4row_inputView_new:setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
                        UILabelType = 2,
                        text = "请再次输入ID    ",
                        size = Dimens.TextSize_25,
                        -- color = Colors.gray,
                        -- color = Colors:_16ToRGB(Colors.dissRoom_green),
                        color = Colors:_16ToRGB(Colors.result_round_bg2),
                        font = Fonts.Font_hkyt_w7,
                        align = cc.ui.TEXT_ALIGN_CENTER,
                        valign = cc.ui.TEXT_VALIGN_CENTER,
                     }))
        end
    end
    _4row_inputView_new = cc.ui.UIPushButton.new(
        Imgs.c_edit_bg,{scale9=true})
        :setButtonSize(220, 45)
        :setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
            UILabelType = 2,
            text = "请再次输入ID    ",
            size = Dimens.TextSize_25,
            -- color = Colors.gray,
            -- color = Colors:_16ToRGB(Colors.dissRoom_green),
            color = Colors:_16ToRGB(Colors.result_round_bg2),
            font = Fonts.Font_hkyt_w7,
            align = cc.ui.TEXT_ALIGN_CENTER,
            valign = cc.ui.TEXT_VALIGN_CENTER,
         }))
        -- :setButtonLabel(EnStatus.pressed, cc.ui.UILabel.new({
        --  UILabelType = 2,
        --  text = "",
        --  size = Dimens.TextSize_30,
        --  color = Colors.btn_press,
        --  }))
        --:setButtonImage(EnStatus.disabled, Imgs.gameing_user_prepare_ok)
        --:setButtonImage(EnStatus.pressed, Imgs.gameing_btn_prepare_press)
        :onButtonClicked(function(e)

            VoiceDealUtil:playSound_other(Voices.file.ui_click)
            KeyboardNumberDialog:popDialogBox(self.pop_window, _4row_inputView_function)

        end)
        :align(display.LEFT_TOP, startX_givecard +160, startY_givecard -60*2 -gaping_givecard)
        :addTo(self.pop_window)
        :setVisible(true)
    --]]



    -- 4.2 row
    cc.ui.UILabel.new({
            UILabelType = 2, 
            --image = "",
            text = "您的密码", 
            size = Dimens.TextSize_30,
            --color = Colors.black,
            color = Colors:_16ToRGB(Colors.gameing_huxi),
            font = Fonts.Font_hkyt_w9,
            align = cc.ui.TEXT_ALIGN_LEFT,
            valign = cc.ui.TEXT_VALIGN_CENTER,
            --dimensions = cc.size((osWidth-120),0) -- height为0，就是自动换行
            dimensions = cc.size(200,50)
        })
        :align(display.LEFT_TOP, startX_givecard, startY_givecard -60*2 -gaping_givecard)
        :addTo(self.pop_window)

    local function _42row_inputView_function(_value)
        _42row_input_txt_new = _value
        if Commons:checkIsNull_str(_value) then
            _42row_inputView_new:setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
                        UILabelType = 2,
                        text = "******",
                        -- text = _value,
                        size = Dimens.TextSize_25,
                        color = Colors.black,
                        -- color = Colors:_16ToRGB(Colors.dissRoom_green),
                        -- color = Colors:_16ToRGB(Colors.result_round_bg2),
                        font = Fonts.Font_hkyt_w7,
                        align = cc.ui.TEXT_ALIGN_CENTER,
                        valign = cc.ui.TEXT_VALIGN_CENTER,
                     }))
        else
            _42row_inputView_new:setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
                        UILabelType = 2,
                        text = "请输入您的密码  ",
                        size = Dimens.TextSize_25,
                        -- color = Colors.gray,
                        -- color = Colors:_16ToRGB(Colors.dissRoom_green),
                        color = Colors:_16ToRGB(Colors.result_round_bg2),
                        font = Fonts.Font_hkyt_w7,
                        align = cc.ui.TEXT_ALIGN_CENTER,
                        valign = cc.ui.TEXT_VALIGN_CENTER,
                     }))
        end
    end
    _42row_inputView_new = cc.ui.UIPushButton.new(
        Imgs.c_edit_bg,{scale9=true})
        :setButtonSize(220, 45)
        :setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
            UILabelType = 2,
            text = "请输入您的密码  ",
            size = Dimens.TextSize_25,
            -- color = Colors.gray,
            -- color = Colors:_16ToRGB(Colors.dissRoom_green),
            color = Colors:_16ToRGB(Colors.result_round_bg2),
            font = Fonts.Font_hkyt_w7,
            align = cc.ui.TEXT_ALIGN_CENTER,
            valign = cc.ui.TEXT_VALIGN_CENTER,
         }))
        :onButtonClicked(function(e)

            VoiceDealUtil:playSound_other(Voices.file.ui_click)
            KeyboardNumberDialog:popDialogBox(self.pop_window, _42row_inputView_function, true)

        end)
        :align(display.LEFT_TOP, startX_givecard +160, startY_givecard -60*2 -gaping_givecard)
        :addTo(self.pop_window)
        :setVisible(true)

    -- 42 - 密码修改
    cc.ui.UIPushButton.new(
        -- Imgs.c_transparent,{scale9=false})
        Imgs.passwd_btn,{scale9=false})
        --:setButtonSize(72, 100)
        :onButtonClicked(function(e)

            VoiceDealUtil:playSound_other(Voices.file.ui_click)
            GPasswdModDialog:popDialogBox(self.pop_window, self.user_account)
            
        end)
        :align(display.LEFT_TOP, startX_givecard +160 +230, startY_givecard -60*2-3 -gaping_givecard)
        :addTo(self.pop_window)



    -- 5 row
    cc.ui.UILabel.new({
            UILabelType = 2, 
            --image = "",
            text = "转卡数量", 
            size = Dimens.TextSize_30,
            --color = Colors.black,
            color = Colors:_16ToRGB(Colors.gameing_huxi),
            font = Fonts.Font_hkyt_w9,
            align = cc.ui.TEXT_ALIGN_LEFT,
            valign = cc.ui.TEXT_VALIGN_CENTER,
            --dimensions = cc.size((osWidth-120),0) -- height为0，就是自动换行
            dimensions = cc.size(200,50)
        })
        :align(display.LEFT_TOP, startX_givecard, startY_givecard -60*3 -gaping_givecard)
        :addTo(self.pop_window)

    local function _5row_inputView_function(_value)
        _5row_input_txt_new = _value
        if Commons:checkIsNull_str(_value) then
            _5row_inputView_new:setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
                        UILabelType = 2,
                        text = _value,
                        size = Dimens.TextSize_25,
                        color = Colors.black,
                        -- color = Colors:_16ToRGB(Colors.dissRoom_green),
                        -- color = Colors:_16ToRGB(Colors.result_round_bg2),
                        font = Fonts.Font_hkyt_w7,
                        align = cc.ui.TEXT_ALIGN_CENTER,
                        valign = cc.ui.TEXT_VALIGN_CENTER,
                     }))
        else
            _5row_inputView_new:setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
                    UILabelType = 2,
                    text = "请输入转卡数量  ",
                    size = Dimens.TextSize_25,
                    -- color = Colors.gray,
                    -- color = Colors:_16ToRGB(Colors.dissRoom_green),
                    color = Colors:_16ToRGB(Colors.result_round_bg2),
                    font = Fonts.Font_hkyt_w7,
                    align = cc.ui.TEXT_ALIGN_CENTER,
                    valign = cc.ui.TEXT_VALIGN_CENTER,
                 }))
        end
    end
    _5row_inputView_new = cc.ui.UIPushButton.new(
        Imgs.c_edit_bg,{scale9=true})
        :setButtonSize(220, 45)
        :setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
            UILabelType = 2,
            text = "请输入转卡数量  ",
            size = Dimens.TextSize_25,
            -- color = Colors.gray,
            -- color = Colors:_16ToRGB(Colors.dissRoom_green),
            color = Colors:_16ToRGB(Colors.result_round_bg2),
            font = Fonts.Font_hkyt_w7,
            align = cc.ui.TEXT_ALIGN_CENTER,
            valign = cc.ui.TEXT_VALIGN_CENTER,
         }))
        :onButtonClicked(function(e)

            VoiceDealUtil:playSound_other(Voices.file.ui_click)
            KeyboardNumberDialog:popDialogBox(self.pop_window, _5row_inputView_function)

        end)
        :align(display.LEFT_TOP, startX_givecard +160, startY_givecard -60*3 -gaping_givecard)
        :addTo(self.pop_window)
        :setVisible(true)

	cc.ui.UILabel.new({
            UILabelType = 2, 
            --image = "",
            text = "张", 
            size = Dimens.TextSize_30,
            --color = Colors.black,
            color = Colors:_16ToRGB(Colors.gameing_huxi),
            font = Fonts.Font_hkyt_w9,
            align = cc.ui.TEXT_ALIGN_LEFT,
            valign = cc.ui.TEXT_VALIGN_CENTER,
            --dimensions = cc.size((osWidth-120),0) -- height为0，就是自动换行
            dimensions = cc.size(200,50)
        })
        :align(display.LEFT_TOP, startX_givecard +160 +230, startY_givecard -60*3 -gaping_givecard)
        :addTo(self.pop_window)

end

function GiveCardDialog:onExit()
    self:myExit()
end

function GiveCardDialog:myExit()
    -- self.parent = nil

	card_yushu = 0
    self.isRefreshBalance = nil

    tipErrorTextView = nil

    _2row_card_yushuView = nil
    _2row_card_zhangView = nil
    _2row_card_jiaoyiView = nil

    nickname_view = nil

 --    _3row_inputView  = nil
 --    _4row_inputView  = nil
	-- _42row_inputView  = nil
	-- _5row_inputView  = nil

    _3row_inputView_new  = nil
    -- _4row_inputView_new  = nil
    _42row_inputView_new  = nil
    _5row_inputView_new  = nil

    _3row_input_txt_new = nil
    -- _4row_input_txt_new = nil
    _42row_input_txt_new = nil
    _5row_input_txt_new = nil	

    if self.pop_window ~= nil and (not tolua.isnull(self.pop_window)) then
        self.pop_window:removeFromParent()
        self.pop_window = nil
    end
end

return GiveCardDialog
