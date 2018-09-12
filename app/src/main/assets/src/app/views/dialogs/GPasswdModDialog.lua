--
-- Author: lte
-- Date: 2016-11-04 17:37:29
-- 转卡的弹窗

-- 类申明
local GPasswdModDialog = class("GPasswdModDialog"
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

local _3row_inputView_new
local _4row_inputView_new
local _42row_inputView_new

local _3row_input_txt_new
local _4row_input_txt_new
local _42row_input_txt_new

local gaping_w -- 整个图层的左右间距
local gaping_h -- 整个图层的上下间距
local gaping_x -- 内容背景，左右 底部 间距
local gaping_y -- 内容背景，顶部间距

function GPasswdModDialog:ctor()
end

-- 创建一个模态弹出框,  parent=要加在哪个上面
function GPasswdModDialog:popDialogBox(_parent, _user_account)
    
    self.parent = _parent
    self.user_account = _user_account

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
    gaping_h = 150
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
    cc.ui.UIImage.new(Imgs.passwd_title_logo,{})
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
        :align(display.CENTER_BOTTOM, display.cx, gaping_h +10)
        :addTo(self.pop_window)
    --]]

    tipErrorTextView = cc.ui.UILabel.new({
            UILabelType = 2, 
            --image = "",
            text = "", 
            size = Dimens.TextSize_25,
            color = Colors.red,
            --color = Colors:_16ToRGB(Colors.gameing_roomNo),
            font = Fonts.Font_hkyt_w9,
            align = cc.ui.TEXT_ALIGN_LEFT,
            valign = cc.ui.TEXT_VALIGN_CENTER,
            --dimensions = cc.size((osWidth-120),0) -- height为0，就是自动换行
            --dimensions = cc.size(200,50)
        })
        :align(display.LEFT_BOTTOM, display.cx+100, gaping_h +10+32)
        :addTo(self.pop_window)
end

function GPasswdModDialog:myConfim()
    local _3row_input_txt = _3row_input_txt_new -- _3row_inputView:getText()
    local _4row_input_txt = _4row_input_txt_new -- _4row_inputView:getText()
	local _42row_input_txt = _42row_input_txt_new --_42row_inputView:getText()

	tipErrorTextView:setString("")

	local old_pwd = ""
	if not Commons:checkIsNull_str(_3row_input_txt) then
		--CDAlert.new():popDialogBox(parent, "用户ID不能为空")
		tipErrorTextView:setString("原密码不能为空")
		return
	else
		old_pwd = string.upper(crypto.md5(_3row_input_txt))
	end

	if not Commons:checkIsNull_str(_4row_input_txt) then
		--CDAlert.new():popDialogBox(parent, "再次确认用户ID不能为空")
		tipErrorTextView:setString("新密码不能为空")
		return
	end

	if _3row_input_txt==_4row_input_txt then
		--CDAlert.new():popDialogBox(parent, "两次输入的用户ID不相同")
		tipErrorTextView:setString("新密码不能与原密码相同")
		return
	end

	if not Commons:checkIsNull_str(_42row_input_txt) then
		--CDAlert.new():popDialogBox(parent, "再次确认用户ID不能为空")
		tipErrorTextView:setString("确认密码不能为空")
		return
	end

	if _42row_input_txt~=_4row_input_txt then
		--CDAlert.new():popDialogBox(parent, "两次输入的用户ID不相同")
		tipErrorTextView:setString("两次输入的新密码不相同")
		return
	end

    self.loadingPop_window_GPasswdModDialog = CDAlertLoading.new():popDialogBox(self.pop_window, Strings.hint_Loading)

    Commons:printLog_Info("========密码修改:::", _3row_input_txt, _5row_input_txt, _transPasw)
	local param = { oldTransPasw=old_pwd, newTransPasw=_4row_input_txt};
	RequestHome:getPasswdMod(param, function(...) self:resPasswdMod(...) end)
end

function GPasswdModDialog:resPasswdMod(jsonObj)
    if self.loadingPop_window_GPasswdModDialog~=nil and (not tolua.isnull(self.loadingPop_window_GPasswdModDialog)) then
        self.loadingPop_window_GPasswdModDialog:removeFromParent()
        self.loadingPop_window_GPasswdModDialog = nil
    end

    if jsonObj~=nil then
        local status = jsonObj[ParseBase.status]
        local msg = RequestBase:getStrDecode(jsonObj[ParseBase.msg])
        Commons:printLog_Info("状态是：", status, "内容是：", msg)

        if status ~= nil and status == CEnum.status.success then
    	    CDAlert.new():popDialogBox(self.parent, msg)
    	    self:myExit()
        else
        	--tipErrorTextView:setString(msg)
            CDAlert.new():popDialogBox(self.pop_window, msg)
    	end
    end
end

function GPasswdModDialog:create_EffectView()
    local startX = gaping_w -20
    local startY_passwdMod = osHeight -gaping_h-gaping_y -10

	-- 1 row
	cc.ui.UILabel.new({
            UILabelType = 2, 
            --image = "",
            text = "用 户：  "..self.user_account, 
            size = Dimens.TextSize_30,
            --color = Colors.black,
            color = Colors:_16ToRGB(Colors.gameing_huxi),
            font = Fonts.Font_hkyt_w9,
            align = cc.ui.TEXT_ALIGN_LEFT,
            valign = cc.ui.TEXT_VALIGN_CENTER,
            --dimensions = cc.size((osWidth-120),0) -- height为0，就是自动换行
            dimensions = cc.size(300,50)
        })
        :align(display.LEFT_TOP, startX+187, startY_passwdMod)
        :addTo(self.pop_window)


    -- 3 row
    cc.ui.UILabel.new({
            UILabelType = 2, 
            --image = "",
            text = "原 密 码", 
            size = Dimens.TextSize_30,
            --color = Colors.black,
            color = Colors:_16ToRGB(Colors.gameing_huxi),
            font = Fonts.Font_hkyt_w9,
            align = cc.ui.TEXT_ALIGN_LEFT,
            valign = cc.ui.TEXT_VALIGN_CENTER,
            --dimensions = cc.size((osWidth-120),0) -- height为0，就是自动换行
            dimensions = cc.size(200,50)
        })
        :align(display.LEFT_TOP, startX+160, startY_passwdMod -60*1)
        :addTo(self.pop_window)

    local function _3row_inputView_function(_value)
        _3row_input_txt_new = _value
        if Commons:checkIsNull_str(_value) then
            _3row_inputView_new:setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
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
            _3row_inputView_new:setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
                        UILabelType = 2,
                        text = "请输入原密码    ",
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
            text = "请输入原密码    ",
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
            KeyboardNumberDialog:popDialogBox(self.pop_window, _3row_inputView_function, true)

        end)
        :align(display.LEFT_TOP, startX+160 +160, startY_passwdMod -60*1)
        :addTo(self.pop_window)
        :setVisible(true)


    -- 4 row
    cc.ui.UILabel.new({
            UILabelType = 2, 
            --image = "",
            text = "新 密 码", 
            size = Dimens.TextSize_30,
            --color = Colors.black,
            color = Colors:_16ToRGB(Colors.gameing_huxi),
            font = Fonts.Font_hkyt_w9,
            align = cc.ui.TEXT_ALIGN_LEFT,
            valign = cc.ui.TEXT_VALIGN_CENTER,
            --dimensions = cc.size((osWidth-120),0) -- height为0，就是自动换行
            dimensions = cc.size(200,50)
        })
        :align(display.LEFT_TOP, startX+160, startY_passwdMod -60*2)
        :addTo(self.pop_window)

    local function _4row_inputView_function(_value)
        _4row_input_txt_new = _value
        if Commons:checkIsNull_str(_value) then
            _4row_inputView_new:setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
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
            _4row_inputView_new:ssetButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
                        UILabelType = 2,
                        text = "请输入新密码    ",
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
            text = "请输入新密码    ",
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
            KeyboardNumberDialog:popDialogBox(self.pop_window, _4row_inputView_function, true)

        end)
        :align(display.LEFT_TOP, startX+160 +160, startY_passwdMod -60*2)
        :addTo(self.pop_window)
        :setVisible(true)


    -- 4.2 row
    cc.ui.UILabel.new({
            UILabelType = 2, 
            --image = "",
            text = "确认密码", 
            size = Dimens.TextSize_30,
            --color = Colors.black,
            color = Colors:_16ToRGB(Colors.gameing_huxi),
            font = Fonts.Font_hkyt_w9,
            align = cc.ui.TEXT_ALIGN_LEFT,
            valign = cc.ui.TEXT_VALIGN_CENTER,
            --dimensions = cc.size((osWidth-120),0) -- height为0，就是自动换行
            dimensions = cc.size(200,50)
        })
        :align(display.LEFT_TOP, startX+160, startY_passwdMod -60*3)
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
                        text = "请再次输入新密码",
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
            text = "请再次输入新密码",
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
            KeyboardNumberDialog:popDialogBox(self.pop_window, _42row_inputView_function, true)

        end)
        :align(display.LEFT_TOP, startX+160 +160, startY_passwdMod -60*3)
        :addTo(self.pop_window)
        :setVisible(true)
end

function GPasswdModDialog:onExit()
    self:myExit()
end

function GPasswdModDialog:myExit()
    self.parent = nil

	card_yushu = 0

    tipErrorTextView = nil

    _2row_card_yushuView = nil
    _2row_card_zhangView = nil

    _3row_inputView_new  = nil
    _4row_inputView_new  = nil
    _42row_inputView_new  = nil

    _3row_input_txt_new = nil
    _4row_input_txt_new = nil
    _42row_input_txt_new = nil
	

    if self.pop_window ~= nil and (not tolua.isnull(self.pop_window)) then
        self.pop_window:removeFromParent()
        self.pop_window = nil
    end
end

-- 必须有这个返回
return GPasswdModDialog
