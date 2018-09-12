--
-- Author: lte
-- Date: 2016-10-11 16:27:12
--

local LoginScene = class("LoginScene", function()
    return display.newScene("LoginScene")
end)

local Layer1
local wx_btn_view
local guest_btn_view
local token_inputView

local agreementImg
local agreementTxt

-- function LoginScene:myKeypad(event)
--     --Commons:printLog_Info("event.name:"..event.name,"event.key:"..event.key)
--     Commons:printLog_Info("event.key：" .. event.key)
--     if event ~= nil and event.key == "back" then
--         CAlert:new():show("提示","确定要退出游戏吗？", LoginScene_myOK, nil);
--     else
--         --Commons:printLog_Info('event.key：' .. string.char(event.key))
--         --CAlert:new():show("提示","游戏吗？", myOK, nil);
--     end
-- end
-- function LoginScene_myOK()
--     Commons:printLog_Info("OK")
--     os.exit();
-- end

function LoginScene:ctor()

    -- 预加载这些动画plist文件
    -- display.addSpriteFrames(Imgs.c_loading_plist, Imgs.c_loading_png)

    local osWidth = Commons.osWidth;
    local osHeight = Commons.osHeight;
    Commons:printLog_Info("==login 屏幕宽", osWidth, "屏幕高", osHeight);

    --GameStateUserInfo:new():setData({a=1000})
    --GameStateUserInfo:new():setDataSingle("b", "value")

    --Commons:printLog_Info("系统参数是：",device.platform, device.language, device.model)

    -- 导演
    --local myDirector = cc.Director:getInstance();
    --local myWindowSize = myDirector:getWinSize();
    --Commons:printLog_Info("==login 窗口大小：",myWindowSize)

	-- 层
	Layer1 = display.newLayer() -- display.newColorLayer(Colors.layer_bg)
	--local Layer1 = display.newScale9Sprite(Imgs.c_default_img, 0, 0, cc.size(osWidth, osHeight))
    	--:center()
    	:pos(0, 0)
    	:addTo(self)
    --[[
    -- 响应键盘事件
    Layer1:setKeypadEnabled(true)
    Layer1:addNodeEventListener(cc.KEYPAD_EVENT, handler(self,self.myKeypad))
    --]]

    -- local temp_w = display.widthInPixels
    -- local temp_h = display.heightInPixels
    -- local temp_wh = temp_w/temp_h
    -- local temp_w2 = CommonsUpd.osWidth
    -- local temp_h2 = CommonsUpd.osHeight
    -- local temp_wh2 = temp_w2/temp_h2
    -- CDAlertManu.new():popDialogBox(Layer1, temp_w.."|"..temp_h.."|"..temp_wh..'\n'
    --     ..temp_w2.."|"..temp_h2.."|"..temp_wh2..'\n\n'
    --     ..tostring(CVarUpd._static.isIphone4)..'|'..tostring(CVarUpd._static.isIpad)..'\n'
    --     ..tostring(CVar._static.isIphone4)..'|'..tostring(CVar._static.isIpad)..'\n'
    --     ..CVar._static.NavBarH_Android )

	-- 精灵
	-- local homeImg = 
    display.newSprite(Imgs.login_bg)
    	:center()
    	:addTo(Layer1)
    -- cc.ui.UIImage.new(Imgs.login_bg,{scale9=false})
    --     :addTo(Layer1)
    --     :align(display.CENTER, display.cx, display.cy)
    --     :setLayoutSize(osWidth, osHeight)

	-- 其他组件 文本标签，按钮等等
	--[[
    cc.ui.UILabel.new({
    	UILabelType = 2, 
    	--image = "",
        text = Strings.app_name, 
        size = Dimens.TextSize_80,
    	color = Colors.title,
    	})
        :align(display.CENTER, display.cx, display.cy + 150)
        :addTo(Layer1)
    --]]

    --[[
    -- 退出游戏
    cc.ui.UIPushButton.new(Imgs.login_exit,{scale9=false})
        :setButtonSize(50, 50)
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
        :onButtonClicked(function(e)
            --myOK();
            LoginScene:myKeypad({key="back"})
        end)
        :align(display.CENTER, osWidth-60/2, osHeight-60/2)
        --:addTo(Layer1)
        --:setVisible(false)
    --]]

    local function LoginSceneOnEdit_token(event, editbox)
	    if event == "began" then
	        -- 开始输入
	        --Commons:printLog_Info("开始输入")
	        --tipErrorTextView:setString("")
	    elseif event == "changed" then
	        -- 输入框内容发生变化
	        --local text = editbox:getText()
	        --Commons:printLog_Info("输入框内容发生变化", text, type(text))
	    elseif event == "ended" then
	        -- 输入结束
	        --Commons:printLog_Info("输入结束")
	    elseif event == "return" then
	        -- 从输入框返回
	        --Commons:printLog_Info("从输入框返回")
	    end
	end
    token_inputView = cc.ui.UIInput.new({
	    	UIInputType = 1,
	    	listener = LoginSceneOnEdit_token,
			image = Imgs.c_edit_bg,
			--imagePressed = Imgs.Edit_Press,
			--imageDisabled = Imgs.Edit_Disable,
            --color = Colors.black,
			size = CCSize(420,60),
			--x = display.cx,
			--y = display.cy + 100,
		})
		:align(display.LEFT_TOP, osWidth-124-420-50, 54+194+40) -- 相对右下角的位置
		:addTo(Layer1)
		:setPlaceHolder("请输入您已知的token值")--提示输入文本
		--:setText("你好")
		--:setFontSize(Dimens.TextSize_25)
		--:setFontColor(Colors.black)
    token_inputView:setVisible(true)

    Commons:printLog_Info("--login 什么平台：：", Commons.osType)

    -- 微信登录
    wx_btn_view = cc.ui.UIPushButton.new(Imgs.login_btn_wx,{scale9=false})
        :setButtonSize(470, 134)
        -- :setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
        -- 	UILabelType = 2,
        --     text = Strings.login_wx,
        -- 	size = Dimens.TextSize_30,
        -- 	color = Colors.btn_normal,
        -- 	}))
        -- :setButtonLabel(EnStatus.pressed, cc.ui.UILabel.new({
        -- 	UILabelType = 2,
        --     text = Strings.login_wx,
        -- 	size = Dimens.TextSize_30,
        -- 	color = Colors.btn_press,
        -- 	}))
        --:setButtonLabel(EnStatus.disabled, cc.ui.UILabel.new({
        --	UILabelType = 2,
        --	text = Strings.common_leave,
        --	size = Dimens.TextSize_30,
        --	color = Colors.btn_disable,
        --	}))
        :setButtonImage(EnStatus.pressed, Imgs.login_btn_wx_press)
        :onButtonClicked(function(e)
            VoiceDealUtil:playSound_other(Voices.file.ui_click)

            --Commons:printLog_Info("什么平台：：", Commons.osType)
            if  CEnum.Environment.android_ios_btn then
                local token_txt = token_inputView:getText()
                --Commons:printLog_Info("-----:", token_txt)
                if Commons:checkIsNull_str(token_txt) then
                    --local param = {}
                    CVar._static.token = token_txt
                    RequestLogin:getLogin(nil, function(...) LoginScene:resDataLogin(...) end)
                end
            else
                -- 微信登录的回调处理
                local function LoginScene_CallbackLua(txt)
                    Layer1:setVisible(false)
                    local param = {
                        code = txt,
                        appid = CEnum.WX.appid,
                        secret = CEnum.WX.secret,
                        grant_type = CEnum.WX.grant_type
                    }
                    RequestLogin:new():fromWXService_token(param, function(...) LoginScene:resData_fromWXService_token(...) end)
                end

                if Commons.osType == CEnum.osType.A then
                    if CEnum.Environment.Current~=nil and CEnum.Environment.Current==CEnum.EnvirType.Test then
                        RequestLogin:getLogin(nil, function(...) LoginScene:resDataLogin(...) end)
                    else
                        local _Class= CEnum.WX_login._Class
                        local _Name = CEnum.WX_login._Name
                        local _args = { "android goto_Login_weixin", LoginScene_CallbackLua}
                        local _sig = "(Ljava/lang/String;I)V" --传入string参数，无返回值
                        --local ok, ret = 
                        luaj.callStaticMethod(_Class, _Name, _args, _sig) --没有返回默认nil

                        --if ok then
                        --    Commons:printLog_Info("getIsValid,ret:", ret)
                        --    CDAlert.new():popDialogBox(Layer1, "getIsValid,ret:"..ret)
                        --else
                        --    Commons:printLog_Info("shareEvent error code = ", ret)
                        --    CDAlert.new():popDialogBox(Layer1, "shareEvent error code = "..ret)
                        --end
                    end
                elseif Commons.osType == CEnum.osType.I then
                    if CEnum.Environment.Current~=nil and CEnum.Environment.Current==CEnum.EnvirType.Test then
                        RequestLogin:getLogin(nil, function(...) LoginScene:resDataLogin(...) end)
                    else
                        local _Class= CEnum.WX_login_ios._Class
                        local _Name = CEnum.WX_login_ios._Name
                        local _args = { test="ios goto_Login_weixin", listener=LoginScene_CallbackLua}
                        --local ok, ret = 
                        luaoc.callStaticMethod(_Class, _Name, _args)
                    end
                else
                    if CEnum.Environment.Current~=nil and CEnum.Environment.Current==CEnum.EnvirType.Test then
                        RequestLogin:getLogin(nil, function(...) LoginScene:resDataLogin(...) end)
                    else
                    	local token_txt = token_inputView:getText()
                    	--Commons:printLog_Info("-----:", token_txt)
                    	if Commons:checkIsNull_str(token_txt) then
        	            	--local param = {}
                            CVar._static.token = token_txt
        	            	RequestLogin:getLogin(nil, function(...) LoginScene:resDataLogin(...) end)
        	            end
                    end
                end
            end

        end)
        --:onButtonPressed(function(e)
        --	Commons:printLog_Info("pushButton Pressed")
        --end)
        --:onButtonRelease(function(e)
        --	Commons:printLog_Info("pushButton Release")
        --end)
        --:onButtonStateChanged(function(e)
        --	Commons:printLog_Info("pushButton StateChanged")
        --end)
        --:align(display.CENTER, display.cx+270, display.cy-230) -- 相对中间的位置
        :align(display.LEFT_TOP, osWidth-124-470, 54+164) -- 相对右下角的位置
        :addTo(Layer1)
        :setVisible(false)

    -- 游客登录
    guest_btn_view = cc.ui.UIPushButton.new(Imgs.login_btn_guest,{scale9=false})
        :setButtonSize(470, 134)
        :setButtonImage(EnStatus.pressed, Imgs.login_btn_guest_press)
        :onButtonClicked(function(e)
            VoiceDealUtil:playSound_other(Voices.file.ui_click)

            --local param = {}
            RequestLogin:getGuestLogin(nil, function(...) LoginScene:resDataLogin(...) end)
        end)
        :align(display.LEFT_TOP, osWidth-124-470, 54+164) -- 相对右下角的位置
        :addTo(Layer1)
        :setVisible(false)

    agreementImg = cc.ui.UIImage.new(Imgs.c_check_yes_login,{scale9=false})
        :align(display.LEFT_TOP, osWidth-124-470 +100, 54+154 -124 -5) -- 相对右下角的位置
        :addTo(Layer1)
        :setVisible(false)
    agreementTxt = cc.ui.UIPushButton.new(Imgs.login_agreementTxt,{scale9=false})
        -- :setButtonSize(470, 134)
        :setButtonImage(EnStatus.pressed, Imgs.login_agreementTxt)
        :onButtonClicked(function(e)
        
            VoiceDealUtil:playSound_other(Voices.file.ui_click)
            ImInfoDialog:popDialogBox(Layer1, Strings.login_agreement_text, CEnum.pageView.login_agreement_Page)
            
        end)
        :align(display.LEFT_TOP, osWidth-124-470 +100 +60, 54+154 -124 -15) -- 相对右下角的位置
        :addTo(Layer1)
        :setVisible(false)

    display.newTTFLabel({
        text = Strings.company .. "  版本号:"..CEnum.AppVersion.versionName..'['..CEnum.AppVersion.versionCode..']',
        font = Fonts.Font_hkyt_w7,
        size = Dimens.TextSize_16,
        color = cc.c3b(255,255,255),
        align = cc.ui.TEXT_VALIGN_CENTER,
        valign = cc.ui.TEXT_VALIGN_CENTER,
        --dimensions = cc.size(140,20)
    })
    :addTo(Layer1)
    :align(display.BOTTOM_RIGHT, osWidth-150, 11)

    --[[
    cc.ui.UIPushButton.new(
        Imgs.g_th_green,{scale9=false})
        --:setButtonSize(72, 100)
        -- :setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
        --  UILabelType = 2,
        --  text = "",
        --     size = Dimens.TextSize_30,
        --  color = Colors.btn_normal,
        --  }))
        -- :setButtonLabel(EnStatus.pressed, cc.ui.UILabel.new({
        --  UILabelType = 2,
        --  text = "",
        --  size = Dimens.TextSize_30,
        --  color = Colors.btn_press,
        --  }))
        --:setButtonImage(EnStatus.disabled, Imgs.gameing_user_prepare_ok)
        :setButtonImage(EnStatus.pressed, Imgs.g_th_green)
        :onButtonClicked(function(e)
            VoiceDealUtil:playSound_other(Voices.file.ui_click)
            -- 点开就是具体的信息
            local GprsBean = ParseBase:parseToJsonObj(PDKSocketResponseDataTest:res_gameing_IP_check() ).data.playerDistance--['data']['playerDistance']
            CDAlertGprs4person:popDialogBox(Layer1, GprsBean)
            CDAlertGprs4person:popDialogBox(Layer1, GprsBean)
            CDAlertGprs:popDialogBox(Layer1, GprsBean)
        end)
        :align(display.CENTER, 350, osHeight-40)
        :addTo(Layer1, CEnum.ZOrder.gameingView_myself_voice)
    --]]
end

function LoginScene:resData_fromWXService_token(jsonObj)
    Commons:printLog_Info("LoginScene:resData_fromWXService_token:::", jsonObj)

    if jsonObj~=nil then
        local access_token = jsonObj[WX.Bean.access_token]
        local expires_in = jsonObj[WX.Bean.expires_in]
        local refresh_token = jsonObj[WX.Bean.refresh_token]
        local openid = jsonObj[WX.Bean.openid]
        local scope = jsonObj[WX.Bean.scope]
        --local unionid = jsonObj[WX.Bean.unionid]

        Commons:printLog_Info("access_token是：", access_token, "expires_in是：", expires_in)


        if Commons:checkIsNull_str(access_token) then
            local param = {
                accessToken=access_token,
                expiresIn=expires_in,
                refreshToken=refresh_token,
                openid=openid,
                scope=scope
            }
            RequestLogin:new():getWXLogin(param, function(...) LoginScene:resDataLogin(...) end)
        else
            wx_btn_view:setVisible(true)
            Layer1:setVisible(true)
            --CDAlert.new():popDialogBox(Layer1, "微信登录失败");
            agreementImg:setVisible(true)
            agreementTxt:setVisible(true)
        end
    end
end

function LoginScene:resDataLogin(jsonObj)
    Commons:printLog_Info("LoginScene:resDataLogin:::", jsonObj)

    if jsonObj~=nil then
        local status = jsonObj[ParseBase.status]
        local msg = RequestBase:getStrDecode(jsonObj[ParseBase.msg])
        Commons:printLog_Info("状态是：", status, "内容是：", msg)

        if status ~= nil and status == CEnum.status.success then
            local _data = jsonObj[ParseBase.data];
            if _data~=nil then
                local user = _data[User.Bean.user]
                if user~=nil then
                    local token = user[User.Bean.token]
                    CVar._static.token = token
                    local nickname = RequestBase:getStrDecode(user[User.Bean.nickname])
                    Commons:printLog_Info("user token：",token, "user 昵称：",nickname)

                    local sysMsg = RequestBase:getStrDecode(_data[User.Bean.sysMsg])
                    if sysMsg ~= nil then
                        CVar._static.sysMsg = sysMsg
                    end

                    local proxies = _data[Proxies.Bean.proxies]
                    if proxies ~= nil then
                        GameState_UserProxy:new():setData(proxies)
                    end

                    local roomObj = user[User.Bean.room]
                    if roomObj ~= nil then
                        
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
                                Commons:printLog_Info("=====login=====socket ip port shareUrl：", Sockets.connect.ip, Sockets.connect.port, Strings.gameing_share_jumpUrl);

                                -- 记录是哪款游戏
                                if roomObj[Room.Bean.gameAlias] then
                                    CEnum.AppVersion.gameAlias = roomObj[Room.Bean.gameAlias]
                                end
                            end
                        end

                        if tag then
                            -- 这里直接进入主页吧
                            GameStateUserInfo:new():setData(user)
                            -- Commons:new():gotoHome()
                            Commons:new():gotoMainHall()
                        else
                            local roomNo = roomObj[Room.Bean.roomNo]
                            Commons:printLog_Info("====已经有了房间 房间号是：", roomNo,  "状态是：",roomObj[Room.Bean.status])
                            if roomNo~=nil then
                                -- 记录用户信息
                                GameStateUserInfo:new():setData(user)
                                -- 记录房间信息
                                CVar._static.roomNo = roomNo
                                GameStateUserGameing:new():setData(roomObj)
                                
                                --Commons:new():gotoGameing()
                                -- 根据不同的游戏，进入不同的游戏房间
                                if CEnum.AppVersion.gameAlias == CEnum.gameType.pdk then
                                    Commons:new():gotoPDKRoom()
                                elseif CEnum.AppVersion.gameAlias == CEnum.gameType.hzmj then
                                    CommonsM:new():gotoMJRoom()
                                else
                                    Commons:new():gotoGameing()
                                end
                            else
                                -- 记录用户信息
                                GameStateUserInfo:new():setData(user)
                                -- Commons:new():gotoHome()
                                Commons:new():gotoMainHall()
                            end
                        end
                    else
                        GameStateUserInfo:new():setData(user)
                        -- Commons:new():gotoHome()
                        Commons:new():gotoMainHall()
                    end
                    -- 这里不能单纯的进入大厅，一旦有房间信息，就直接加入房间游戏
                end
            end
        else
            if CVar._static.appstoreSwitch == CEnum.appstoreSwitch.close then
                guest_btn_view:setVisible(true)
                wx_btn_view:setVisible(false)
            elseif CVar._static.appstoreSwitch == CEnum.appstoreSwitch.open then
                guest_btn_view:setVisible(false)
                wx_btn_view:setVisible(true)
            else
                guest_btn_view:setVisible(false)
                wx_btn_view:setVisible(false)
            end

            if CVar._static.protocolSwitch == CEnum.appstoreSwitch.close then
                agreementImg:setVisible(false)
                agreementTxt:setVisible(false)
            elseif CVar._static.protocolSwitch == CEnum.appstoreSwitch.open then
                agreementImg:setVisible(true)
                agreementTxt:setVisible(true)
            end

            if CEnum.Environment.Current~=nil and CEnum.Environment.Current==CEnum.EnvirType.Test then
                guest_btn_view:setVisible(false)
                wx_btn_view:setVisible(true)
                -- agreementImg:setVisible(true)
                -- agreementTxt:setVisible(true)
            else
                if Commons.osType == CEnum.osType.W or Commons.osType == CEnum.osType.M then
                    if not CEnum.Environment.window_mac_btn then
                        guest_btn_view:setVisible(false)
                        wx_btn_view:setVisible(true)
                        token_inputView:setVisible(true)
                    else
                        guest_btn_view:setVisible(true)
                        wx_btn_view:setVisible(false)
                    end
                else
                    if not CEnum.Environment.android_ios_btn then
                        guest_btn_view:setVisible(false)
                        wx_btn_view:setVisible(true)
                        token_inputView:setVisible(true)
                    end
                end
            end

            Layer1:setVisible(true)
            CDAlert.new():popDialogBox(Layer1, msg);
        end
    end
end

-- local apkDownloadUrl
function LoginScene:resData_UpdateApp(jsonObj)
    Commons:printLog_Info("LoginScene:resData_UpdateApp:::", jsonObj)

    if jsonObj~=nil then
        local status = jsonObj[ParseBase.status]
        local msg = RequestBase:getStrDecode(jsonObj[ParseBase.msg])
        Commons:printLog_Info("状态是：", status, "内容是：", msg)

        if status ~= nil and status == CEnum.status.success then
            local _data = jsonObj[ParseBase.data];
            if _data~=nil then
                CVar._static.appstoreSwitch = _data[UpdateApp.Bean.versionSwitch] -- 苹果开关
                CVar._static.protocolSwitch = _data[UpdateApp.Bean.protocolSwitch] -- 用户协议开关

                if CVar._static.appstoreSwitch == CEnum.appstoreSwitch.close then
                    guest_btn_view:setVisible(true)
                    wx_btn_view:setVisible(false)
                elseif CVar._static.appstoreSwitch == CEnum.appstoreSwitch.open then
                    guest_btn_view:setVisible(false)
                    wx_btn_view:setVisible(true)
                else
                    guest_btn_view:setVisible(false)
                    wx_btn_view:setVisible(false)
                end

                if CVar._static.protocolSwitch == CEnum.appstoreSwitch.close then
                    agreementImg:setVisible(false)
                    agreementTxt:setVisible(false)
                elseif CVar._static.protocolSwitch == CEnum.appstoreSwitch.open then
                    agreementImg:setVisible(true)
                    agreementTxt:setVisible(true)
                end

                if CEnum.Environment.Current~=nil and CEnum.Environment.Current==CEnum.EnvirType.Test then
                    guest_btn_view:setVisible(false)
                    wx_btn_view:setVisible(true)
                    -- agreementImg:setVisible(true)
                    -- agreementTxt:setVisible(true)
                else
                    if Commons.osType == CEnum.osType.W or Commons.osType == CEnum.osType.M then
                        if not CEnum.Environment.window_mac_btn then
                            guest_btn_view:setVisible(false)
                            wx_btn_view:setVisible(true)
                            token_inputView:setVisible(true)
                        else
                            guest_btn_view:setVisible(true)
                            wx_btn_view:setVisible(false)
                        end
                    else
                        if not CEnum.Environment.android_ios_btn then
                            guest_btn_view:setVisible(false)
                            wx_btn_view:setVisible(true)
                            token_inputView:setVisible(true)
                        end
                    end
                end

                local newVersion = _data[UpdateApp.Bean.newVersion]
                if newVersion~=nil then
                    local versionCode = newVersion[UpdateApp.Bean.versionCode]

                    local descript = RequestBase:getStrDecode(newVersion[UpdateApp.Bean.descript])
                    local versionName = RequestBase:getStrDecode(newVersion[UpdateApp.Bean.versionName])
                    local apkSize = newVersion[UpdateApp.Bean.apkSize]
                    local upgradeType = newVersion[UpdateApp.Bean.upgradeType]

                    local apkDownloadUrl = RequestBase:getStrDecode(newVersion[UpdateApp.Bean.apkDownloadUrl])

                    if Commons:checkIsNull_str(apkDownloadUrl) then -- 有下载地址，就是可以升级
                        if Commons:checkIsNull_numberType(upgradeType) then
                            if 1 == upgradeType then
                                --CDailogUpdateApp:popDialogBox(Layer1, descript, versionName, apkSize,  apkDownloadUrl, function(...) LoginScene:submitBtn('',apkDownloadUrl) end, nil)
                            elseif 2==upgradeType then
                                --CDailogUpdateApp:popDialogBox(Layer1, descript, versionName, apkSize,  apkDownloadUrl, function(...) LoginScene:submitBtn('',apkDownloadUrl) end, function() LoginScene:cancelBtn() end)
                            end
                            return
                        end                        
                    end
                end
            end
        end
    end

    LoginScene:cancelBtn()
end

function LoginScene:submitBtn(apkDownloadUrl)
    if Commons:checkIsNull_str(apkDownloadUrl) then -- 有下载地址，就是可以升级
        --Commons:printLog_Info("什么平台：：", Commons.osType)
        local function LoginScene_CallbackLua_UpdateApp(txt)
        end

        if Commons.osType == CEnum.osType.A then
            local _Class= CEnum.UpdateApp._Class
            local _Name = CEnum.UpdateApp._Name
            local _args = { apkDownloadUrl, LoginScene_CallbackLua_UpdateApp}
            local _sig = "(Ljava/lang/String;I)V" --传入string参数，无返回值
            --local ok, ret = 
            luaj.callStaticMethod(_Class, _Name, _args, _sig) --没有返回默认nil
        elseif Commons.osType == CEnum.osType.I then
            local _Class= CEnum.UpdateApp_ios._Class
            local _Name = CEnum.UpdateApp_ios._Name
            local _args = { downUrl=apkDownloadUrl, listener=LoginScene_CallbackLua_UpdateApp}
            --local ok, ret = 
            luaoc.callStaticMethod(_Class, _Name, _args)
        end
    end
end

-- local loadingPop_window
function LoginScene:cancelBtn()
    ---[[
    if CVar._static.appstoreSwitch == CEnum.appstoreSwitch.close then
        guest_btn_view:setVisible(true)
        wx_btn_view:setVisible(false)
    elseif CVar._static.appstoreSwitch == CEnum.appstoreSwitch.open then
        guest_btn_view:setVisible(false)
        wx_btn_view:setVisible(true)
    else
        guest_btn_view:setVisible(false)
        wx_btn_view:setVisible(false)
    end

    if CVar._static.protocolSwitch == CEnum.appstoreSwitch.close then
        agreementImg:setVisible(false)
        agreementTxt:setVisible(false)
    elseif CVar._static.protocolSwitch == CEnum.appstoreSwitch.open then
        agreementImg:setVisible(true)
        agreementTxt:setVisible(true)
    end

    if CEnum.Environment.Current~=nil and CEnum.Environment.Current==CEnum.EnvirType.Test then
        guest_btn_view:setVisible(false)
        wx_btn_view:setVisible(true)
        -- agreementImg:setVisible(true)
        -- agreementTxt:setVisible(true)
    else
        if Commons.osType == CEnum.osType.W or Commons.osType == CEnum.osType.M then
            if not CEnum.Environment.window_mac_btn then
                guest_btn_view:setVisible(false)
                wx_btn_view:setVisible(true)
                token_inputView:setVisible(true)
            else
                guest_btn_view:setVisible(true)
                wx_btn_view:setVisible(false)
            end
        else
            if not CEnum.Environment.android_ios_btn then
                guest_btn_view:setVisible(false)
                wx_btn_view:setVisible(true)
                token_inputView:setVisible(true)
            end
        end
    end

    LoginScene:autoLogin()
    --]]
end

function LoginScene:onEnter()
    -- 必须判断下是否需要升级
    -- 需要升级或者强制升级，都必须进入手机浏览器
    -- 不需要升级或者没有升级，就判断有没有token能否自动登录
    --if CEnum.Environment.toReleasePhone then
        guest_btn_view:setVisible(false)
        wx_btn_view:setVisible(false)
        agreementImg:setVisible(false)
        agreementTxt:setVisible(false)

        LoginScene_getNavBarH() -- android手机 如果有虚拟键的 高度多少

        Layer1:performWithDelay(function ()
            -- RequestLogin:getUpdateApp(nil, function(...) LoginScene:resData_UpdateApp(...) end)

            LoginScene:cancelBtn()
        end, 1.0)
    --end
end

function LoginScene:autoLogin()
    -- 判断有没有token能否自动登录
    if CEnum.Environment.toReleasePhone then
        local user = GameStateUserInfo:getData();
        --Commons:printLog_Info("--11---", user)
        if Commons:checkIsNull_tableType(user) then
            local user_token = user[User.Bean.token]
            --Commons:printLog_Info("--22---", user_token)
            if Commons:checkIsNull_str(user_token) then
                guest_btn_view:setVisible(false)
                wx_btn_view:setVisible(false)
                agreementImg:setVisible(false)
                agreementTxt:setVisible(false)

                --Layer1:performWithDelay(function () 

                    -- 每次都要登录下，重新获取用户各类基本资料的
                    --local param = {}
                    CVar._static.token = user_token
                    RequestLogin:new():getLogin(nil, function(...) LoginScene:resDataLogin(...) end)

                --end, 0.1)
            end
        end
    end
end

-- android手机 如果有虚拟键的 高度多少
function LoginScene_getNavBarH()
    local function LoginScene_CallbackLua_getNavBarH(txt)
        if Commons:checkIsNull_str(txt) then
            CVar._static.NavBarH_Android = tonumber(txt)
            -- CDAlertManu.new():popDialogBox(Layer1, CVar._static.NavBarH_Android.."", true)
        end
    end

    if Commons.osType == CEnum.osType.A then
        local _Class= CEnum.getNarBarHeight._Class
        local _Name = CEnum.getNarBarHeight._Name
        local _args = { "", LoginScene_CallbackLua_getNavBarH}
        local _sig = "(Ljava/lang/String;I)V" --传入string参数，无返回值
        --local ok, ret = 
        luaj.callStaticMethod(_Class, _Name, _args, _sig) --没有返回默认nil
    elseif Commons.osType == CEnum.osType.I then
        CVar._static.NavBarH_Android = 0
    end
end

function LoginScene:onExit()
    Commons:printLog_Info("LoginScene:onExit")
    self:removeAllChildren()
end

return LoginScene