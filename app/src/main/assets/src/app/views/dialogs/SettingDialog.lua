--
-- Author: lte
-- Date: 2016-11-04 13:01:54
-- 设置的弹窗

-- 类申明
local SettingDialog = class("SettingDialog"
    -- ,function()
    --     return display.newNode()
    -- end
    )


local osWidth = Commons.osWidth
local osHeight = Commons.osHeight

-- 条件值
SettingDialog.Slider_Imgs = {
    bar = Imgs.setting_slider_bg, -- 背景色
    barfg = Imgs.setting_slider_bg_layer, -- 背景填充色
    button = Imgs.setting_slider_btn, -- 滑块
    button_pressed = Imgs.setting_slider_btn -- 滑块触礁图片
}

local currSoundsVolume -- 音效
local currMusicVolume -- 背景音乐

local currStopSounds -- 音效
local currStopMusic -- 背景音乐
local currStopVoice -- 语音自动播放

local StopSoundsView
local StopMusicView
local StopVoiceView -- 语音自动播放


local gaping_w -- 整个图层的左右间距
local gaping_h -- 整个图层的上下间距
local gaping_x -- 内容背景，左右 底部 间距
local gaping_y -- 内容背景，顶部间距

function SettingDialog:ctor()
end

-- 创建一个模态弹出框,  parent=要加在哪个上面
function SettingDialog:popDialogBox(_parent, fromView)

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


    gaping_w = 280
    gaping_h = 128
    gaping_x = 10
    gaping_y = 74

    if CVar._static.isIphone4 then
        gaping_w = gaping_w -100
    elseif CVar._static.isIpad then
        gaping_w = gaping_w -130
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
    cc.ui.UIImage.new(Imgs.setting_title_logo,{})
    	:addTo(self.pop_window)
    	:align(display.CENTER_TOP, display.cx, osHeight -gaping_h -11)

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

	-- 获取目前的设置的音量 和 是否停止了声音
	self:getVolume()

	-- 背景音乐 音量设置
	self:create_BmusicView()

    -- 音效  音量设置
    self:create_EffectView()


    -- 语音是否自动播放，默认是自动播放，但是用户可以关闭
    -- self:create_VoiceAutoView()

	-- 看看当前是关闭还是开启
	self:getOnOff()

    if CEnum.AppVersion.gameAlias ~= CEnum.gameType.pdk
        and CEnum.AppVersion.gameAlias ~= CEnum.gameType.hzmj 
    then
        -- 语言类型
        self:createViewByLine(1, self.pop_window, 
                    CEnum.language.ww, CEnum.language.ax, 
                    Imgs.setting_3row_ww, Imgs.setting_3row_ax, 
                    gaping_w +130, gaping_h +165) -- 这里y值越大，越靠底部 
    end

    ---[[
    -- 确定按钮
    local view_btn_submit_setting = cc.ui.UIPushButton.new(
        Imgs.setting_btn_exit,{scale9=false})
        --:setButtonSize(180, 84)
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
        :setButtonImage(EnStatus.pressed, Imgs.setting_btn_exit_press)
        :onButtonClicked(function(e)

            VoiceDealUtil:playSound_other(Voices.file.ui_click)
            self:myConfim()

        end)
        :align(display.CENTER_BOTTOM, display.cx, gaping_h +10 +20)
        :addTo(self.pop_window)
    if fromView~=nil and fromView==CEnum.pageView.gameingOverPage then
        view_btn_submit_setting:setVisible(false)
    end
    --]]

    display.newTTFLabel({
        text = "版本号："..CEnum.AppVersion.versionName..' ('..CEnum.AppVersion.versionCode..')',
        font = Fonts.Font_hkyt_w7,
        size = Dimens.TextSize_15,
        color = cc.c3b(151,44,11),
        align = cc.ui.TEXT_ALIGN_LEFT,
        valign = cc.ui.TEXT_VALIGN_CENTER,
        --dimensions = cc.size(140,20)
    })
    :addTo(self.pop_window)
    :align(display.CENTER_BOTTOM, display.cx, gaping_h +10)

end

function SettingDialog:myConfim()
    if Commons.osType == CEnum.osType.A then
        --CDialog.new():popDialogBox(self.pop_window, nil, Strings.exit_login_Really, function() self:exit_OK() end, function() self:exit_NO() end)
        CDialog.new():popDialogBox(self.pop_window, nil, Strings.exit_login, function() self:exit_OK() end, function() self:exit_NO() end)
    elseif Commons.osType == CEnum.osType.I then
        CDialog.new():popDialogBox(self.pop_window, nil, Strings.exit_login, function() self:exit_OK() end, function() self:exit_NO() end)
    else
        CDialog.new():popDialogBox(self.pop_window, nil, Strings.exit_login, function() self:exit_OK() end, function() self:exit_NO() end)
    end
end
function SettingDialog:exit_OK()
    GameStateUserInfo:setData({})
    if Commons.osType == CEnum.osType.A then
        --os.exit();-- 目前要求是直接退出游戏，并不是回登录页面
        Commons:gotoLogin()
    elseif Commons.osType == CEnum.osType.I then
        Commons:gotoLogin()
        -- local function SettingDialog_CallbackLua(txt)
        -- end
        -- local _Class = CEnum.ExitOs_ios._Class
        -- local _Name = CEnum.ExitOs_ios._Name
        -- local _args = { exit = "exit",
        --                 listener = SettingDialog_CallbackLua}
        -- --local ok, ret = 
        -- luaoc.callStaticMethod(_Class, _Name, _args) 
    else
        Commons:gotoLogin()
    end
end
function SettingDialog:exit_NO()
end

function SettingDialog:getVolume()
	local currSoundsVolume_temp
	local currMusicVolume_temp

	currSoundsVolume_temp = --UserDefaultUtil:getData(UserDefaultUtil.var.currSoundsVolume, CEnum.status.def_fill)
        GameState_VoiceSetting:getDataSingle(CEnum.voiceSetting.currSoundsVolume)

	currMusicVolume_temp = --UserDefaultUtil:getData(UserDefaultUtil.var.currMusicVolume, CEnum.status.def_fill)
        GameState_VoiceSetting:getDataSingle(CEnum.voiceSetting.currMusicVolume)

	Commons:printLog_Info("音效：",currSoundsVolume_temp)
	Commons:printLog_Info("背景音乐：",currMusicVolume_temp)

    if currMusicVolume_temp~=nil and currMusicVolume_temp~=CEnum.musicStatus.def_fill then
        currMusicVolume = tonumber(currMusicVolume_temp)

        --audio.setMusicVolume(currMusicVolume/CVar._static.soundVolumMax)
        self:mySetting_MusicVolume(currMusicVolume)
    else
        -- 第一次，默认获取系统设置
        currMusicVolume_temp = string.format("%d", audio.getMusicVolume() * CVar._static.soundVolumMax)
        --Commons:printLog_Info("=====",type(currMusicVolume_temp))
        currMusicVolume = tonumber(currMusicVolume_temp)
        --UserDefaultUtil:setData(UserDefaultUtil.var.currMusicVolume, currMusicVolume)
        GameState_VoiceSetting:setDataSingle(CEnum.voiceSetting.currMusicVolume, currMusicVolume)
    end

    if currSoundsVolume_temp~=nil and currSoundsVolume_temp~=CEnum.musicStatus.def_fill then
		currSoundsVolume = tonumber(currSoundsVolume_temp)

        --audio.setSoundsVolume(currSoundsVolume/CVar._static.soundVolumMax)
        self:mySetting_SoundVolume(currSoundsVolume)
	else
		-- 第一次，默认获取系统设置
		currSoundsVolume_temp = string.format("%d", audio.getSoundsVolume() * CVar._static.soundVolumMax)
		--Commons:printLog_Info("=====",type(currSoundsVolume_temp))
		currSoundsVolume = tonumber(currSoundsVolume_temp)
		--UserDefaultUtil:setData(UserDefaultUtil.var.currSoundsVolume, currSoundsVolume)
        GameState_VoiceSetting:setDataSingle(CEnum.voiceSetting.currSoundsVolume, currSoundsVolume)
	end
   	
end

function SettingDialog:mySetting_SoundVolume(_volume)
    local function SettingDialog_SoundVolume_CallbackLua(txt)
        --print("-----------设置完成了")
    end
    if Commons.osType == CEnum.osType.I then
        local _Class = CEnum.SoundVolume_ios._Class
        local _Name = CEnum.SoundVolume_ios._Name
        local _args = { volume=_volume, listener=SettingDialog_SoundVolume_CallbackLua}
        --local ok, ret = 
        luaoc.callStaticMethod(_Class, _Name, _args) --没有返回默认nil
    elseif Commons.osType == CEnum.osType.A then
        local _Class = CEnum.SoundVolume._Class
        local _Name = CEnum.SoundVolume._Name
        local _args = { _volume}
        local _sig = "(I)V" --传入string参数，无返回值
        --local ok, ret = 
        luaj.callStaticMethod(_Class, _Name, _args, _sig) --没有返回默认nil
    else
        audio.setSoundsVolume(_volume/CVar._static.soundVolumMax)
    end
end

function SettingDialog:mySetting_MusicVolume(_volume)
    local function SettingDialog_MusicVolume_CallbackLua(txt)
        --print("-----------设置完成了")
    end
    if Commons.osType == CEnum.osType.I then
        -- local _Class = CEnum.SoundVolume_ios._Class
        -- local _Name = CEnum.SoundVolume_ios._Name
        -- local _args = { volume=_volume, listener=SettingDialog_MusicVolume_CallbackLua}
        -- --local ok, ret = 
        -- luaoc.callStaticMethod(_Class, _Name, _args) --没有返回默认nil

        audio.setMusicVolume(_volume/CVar._static.soundVolumMax)
    elseif Commons.osType == CEnum.osType.A then
        local _Class = CEnum.SoundVolume._Class
        local _Name = CEnum.SoundVolume._Name
        local _args = { _volume}
        local _sig = "(I)V" --传入string参数，无返回值
        --local ok, ret = 
        luaj.callStaticMethod(_Class, _Name, _args, _sig) --没有返回默认nil
    else
        audio.setSoundsVolume(_volume/CVar._static.soundVolumMax)
    end
end

function SettingDialog:getOnOff()
	local currStopSounds_temp
    local currStopMusic_temp
	local currStopVoice_temp

	currStopSounds_temp = --UserDefaultUtil:getData(UserDefaultUtil.var.currStopSounds, CEnum.status.def_fill)
        GameState_VoiceSetting:getDataSingle(CEnum.voiceSetting.currStopSounds)

	currStopMusic_temp = --UserDefaultUtil:getData(UserDefaultUtil.var.currStopMusic, CEnum.status.def_fill)
        GameState_VoiceSetting:getDataSingle(CEnum.voiceSetting.currStopMusic)

    -- currStopVoice_temp = GameState_VoiceSetting:getDataSingle(CEnum.voiceSetting.currStopVoice)

	Commons:printLog_Info("关闭 音效：",currStopSounds_temp)
	Commons:printLog_Info("关闭 背景音乐：",currStopMusic_temp)
    -- Commons:printLog_Info("关闭 语音自动播放：",currStopVoice_temp)


    if currStopMusic_temp~=nil and currStopMusic_temp~=CEnum.musicStatus.def_fill then
        currStopMusic = currStopMusic_temp
        self:settingStopMusicInit()
    else
        -- 第一次，默认只是为开启
        currStopMusic = CEnum.musicStatus.on
        self:settingStopMusicInit()
    end 

    if currStopSounds_temp~=nil and currStopSounds_temp~=CEnum.musicStatus.def_fill then
		currStopSounds = currStopSounds_temp
		self:settingStopSoundsInit()
	else
		-- 第一次，默认只是为开启
        currStopSounds = CEnum.musicStatus.on
		self:settingStopSoundsInit()
	end
    

    -- if currStopVoice_temp~=nil and currStopVoice_temp~=CEnum.musicStatus.def_fill then
    --     currStopVoice = currStopVoice_temp
    --     self:settingStopVoiceInit()
    -- else
    --     -- 第一次，默认只是为开启
    --     currStopVoice = CEnum.musicStatus.on
    --     self:settingStopVoiceInit()
    -- end
end

function SettingDialog:create_EffectView()
	local barHeight = 36
	local barWidth = 396
    local startX_1row = gaping_w +66
    local startY_1row = osHeight -gaping_h -144

    -- cc.ui.UILabel.new({
    --         text = "语音自动播放", 
    --         size = 30, 
    --         color = display.COLOR_BLACK
    --     })
    cc.ui.UIImage.new(Imgs.setting_1row_effect_tip, {scale9=false})
    	:align(display.LEFT_TOP, startX_1row, startY_1row)
        :addTo(self.pop_window)

    cc.ui.UISlider.new(display.LEFT_TO_RIGHT, SettingDialog.Slider_Imgs, {scale9 = true, max=CVar._static.soundVolumMax, min=0})
        :onSliderValueChanged(function(event)

            --valueLabel:setString(string.format("val=%0.2f", event.value))
            
            --audio.setSoundsVolume(event.value/CVar._static.soundVolumMax)
            self:mySetting_SoundVolume(event.value)

            --UserDefaultUtil:setData(UserDefaultUtil.var.currSoundsVolume, string.format("%d", event.value))
            GameState_VoiceSetting:setDataSingle(CEnum.voiceSetting.currSoundsVolume, string.format("%d", event.value))

        end)
        :setSliderSize(barWidth, barHeight)
        :setSliderValue(currSoundsVolume)
        :align(display.LEFT_TOP, startX_1row +74+18, startY_1row)
        :addTo(self.pop_window)

    StopSoundsView = cc.ui.UIPushButton.new(Imgs.setting_1row_effect_on,{scale9=false})
    	:setButtonSize(51, 51)
        :setButtonImage(EnStatus.pressed, Imgs.setting_1row_effect_on)
    	--:setButtonImage(EnStatus.disabled, Imgs.setting_1row_effect_on)
        :onButtonClicked(function(e)

            VoiceDealUtil:playSound_other(Voices.file.ui_click)
            -- 关闭和开启
            self:settingStopSounds()

        end)
        :align(display.LEFT_TOP, startX_1row +74+18 +barWidth+20, startY_1row +8)
        :addTo(self.pop_window)
	
end

function SettingDialog:settingStopSoundsInit()
	-- 关闭和开启
    if currStopSounds~=nil and currStopSounds~=CEnum.musicStatus.def_fill and currStopSounds==CEnum.musicStatus.on then
        -- CVar._static.currStopSounds_init = CEnum.musicStatus.on
		-- 初始化，是开启就是开启
        currStopSounds = CEnum.musicStatus.on
		--UserDefaultUtil:setData(UserDefaultUtil.var.currStopSounds, "1")
        GameState_VoiceSetting:setDataSingle(CEnum.voiceSetting.currStopSounds, CEnum.musicStatus.on)
		StopSoundsView:setButtonImage(EnStatus.normal, Imgs.setting_1row_effect_on)
		StopSoundsView:setButtonImage(EnStatus.pressed, Imgs.setting_1row_effect_on)
        
        --VoiceDealUtil:resumeSound()
	else
        -- CVar._static.currStopSounds_init = CEnum.musicStatus.off
        currStopSounds = CEnum.musicStatus.off
		--UserDefaultUtil:setData(UserDefaultUtil.var.currStopSounds, "0")
        GameState_VoiceSetting:setDataSingle(CEnum.voiceSetting.currStopSounds, CEnum.musicStatus.off)
		StopSoundsView:setButtonImage(EnStatus.normal, Imgs.setting_1row_effect_off)
		StopSoundsView:setButtonImage(EnStatus.pressed, Imgs.setting_1row_effect_off)

        --VoiceDealUtil:pauseSound()
	end
end

function SettingDialog:settingStopSounds()
	-- 关闭和开启
    if currStopSounds~=nil and currStopSounds~=CEnum.musicStatus.def_fill and currStopSounds==CEnum.musicStatus.on then
        CVar._static.currStopSounds_init = CEnum.musicStatus.off
		-- 已经开启，点击之后就是关闭
        currStopSounds = CEnum.musicStatus.off
		--UserDefaultUtil:setData(UserDefaultUtil.var.currStopSounds, "0")
        GameState_VoiceSetting:setDataSingle(CEnum.voiceSetting.currStopSounds, CEnum.musicStatus.off)
		StopSoundsView:setButtonImage(EnStatus.normal, Imgs.setting_1row_effect_off)
		StopSoundsView:setButtonImage(EnStatus.pressed, Imgs.setting_1row_effect_off)

        --VoiceDealUtil:pauseSound()
	else
        CVar._static.currStopSounds_init = CEnum.musicStatus.on
        currStopSounds = CEnum.musicStatus.on
		--UserDefaultUtil:setData(UserDefaultUtil.var.currStopSounds, "1")
        GameState_VoiceSetting:setDataSingle(CEnum.voiceSetting.currStopSounds, CEnum.musicStatus.on)
		StopSoundsView:setButtonImage(EnStatus.normal, Imgs.setting_1row_effect_on)
		StopSoundsView:setButtonImage(EnStatus.pressed, Imgs.setting_1row_effect_on)

        --VoiceDealUtil:resumeSound()
	end
end

function SettingDialog:create_BmusicView()
	local barHeight = 36
	local barWidth = 396
    local startX_1row = gaping_w +66
    local startY_1row = osHeight -gaping_h -144 -100

    -- cc.ui.UILabel.new({
	   --  	text = "语音自动播放", 
	   --  	size = 30, 
	   --  	color = display.COLOR_BLACK
    -- 	})
    cc.ui.UIImage.new(Imgs.setting_2row_music_tip, {scale9=false})
    	:align(display.LEFT_TOP, startX_1row, startY_1row)
        :addTo(self.pop_window)

    cc.ui.UISlider.new(display.LEFT_TO_RIGHT, SettingDialog.Slider_Imgs, {scale9 = true, max=CVar._static.soundVolumMax, min=0})
        :onSliderValueChanged(function(event)

            --valueLabel:setString(string.format("val=%0.2f", event.value))

            --audio.setMusicVolume(event.value/CVar._static.soundVolumMax)
            self:mySetting_MusicVolume(event.value)

            --UserDefaultUtil:setData(UserDefaultUtil.var.currMusicVolume, string.format("%d", event.value))
            GameState_VoiceSetting:new():setDataSingle(CEnum.voiceSetting.currMusicVolume, string.format("%d", event.value))

        end)
        :setSliderSize(barWidth, barHeight)
        :setSliderValue(currMusicVolume)
        :align(display.LEFT_TOP, startX_1row +74+18, startY_1row)
        :addTo(self.pop_window)

    StopMusicView = cc.ui.UIPushButton.new(Imgs.setting_2row_music_on,{scale9=false})
    	:setButtonSize(51, 51)
        :setButtonImage(EnStatus.pressed, Imgs.setting_2row_music_on)
    	--:setButtonImage(EnStatus.disabled, Imgs.setting_2row_music_on)
        :onButtonClicked(function(e)

            VoiceDealUtil:playSound_other(Voices.file.ui_click)
            -- 关闭和开启
            self:settingStopMusic()

        end)
        :align(display.LEFT_TOP, startX_1row +74+18 +barWidth+20, startY_1row +8)
        :addTo(self.pop_window)
end

function SettingDialog:settingStopMusicInit()
	-- 关闭和开启
    if currStopMusic~=nil and currStopMusic~=CEnum.musicStatus.def_fill and currStopMusic==CEnum.musicStatus.on then
		-- 初始化，是开启就是开启
        currStopMusic=CEnum.musicStatus.on
		--UserDefaultUtil:setData(UserDefaultUtil.var.currStopMusic, "1")
        GameState_VoiceSetting:setDataSingle(CEnum.voiceSetting.currStopMusic, CEnum.musicStatus.on)
		StopMusicView:setButtonImage(EnStatus.normal, Imgs.setting_2row_music_on)
		StopMusicView:setButtonImage(EnStatus.pressed, Imgs.setting_2row_music_on)
        
        --VoiceDealUtil:playBgMusic()
	else
        currStopMusic=CEnum.musicStatus.off
		--UserDefaultUtil:setData(UserDefaultUtil.var.currStopMusic, "0")
        GameState_VoiceSetting:setDataSingle(CEnum.voiceSetting.currStopMusic, CEnum.musicStatus.off)
		StopMusicView:setButtonImage(EnStatus.normal, Imgs.setting_2row_music_off)
		StopMusicView:setButtonImage(EnStatus.pressed, Imgs.setting_2row_music_off)

        --VoiceDealUtil:stopBgMusic()
	end
end

function SettingDialog:settingStopMusic()
	-- 关闭和开启
    if currStopMusic~=nil and currStopMusic~=CEnum.musicStatus.def_fill and currStopMusic==CEnum.musicStatus.on then
		-- 已经开启，点击之后就是关闭
        currStopMusic=CEnum.musicStatus.off
		--UserDefaultUtil:setData(UserDefaultUtil.var.currStopMusic, "0")
        GameState_VoiceSetting:setDataSingle(CEnum.voiceSetting.currStopMusic, CEnum.musicStatus.off)
		StopMusicView:setButtonImage(EnStatus.normal, Imgs.setting_2row_music_off)
		StopMusicView:setButtonImage(EnStatus.pressed, Imgs.setting_2row_music_off)

        --VoiceDealUtil:pauseBgMusic()
        VoiceDealUtil:stopBgMusic()
	else
        currStopMusic=CEnum.musicStatus.on
		--UserDefaultUtil:setData(UserDefaultUtil.var.currStopMusic, "1")
        GameState_VoiceSetting:setDataSingle(CEnum.voiceSetting.currStopMusic, CEnum.musicStatus.on)
		StopMusicView:setButtonImage(EnStatus.normal, Imgs.setting_2row_music_on)
		StopMusicView:setButtonImage(EnStatus.pressed, Imgs.setting_2row_music_on)

        -- --VoiceDealUtil:resumeBgMusic()
        -- VoiceDealUtil:playBgMusic()
        if CEnum.AppVersion.gameAlias == CEnum.gameType.pdk then
            VoiceDealUtil:playPDKBgMusic()
        elseif CEnum.AppVersion.gameAlias == CEnum.gameType.hzmj then
            VoiceDealUtil:playMJBgMusic()
        elseif CEnum.AppVersion.gameAlias == CEnum.gameType.mainHall then
        else
            VoiceDealUtil:playBgMusic()
        end
	end
end

function SettingDialog:create_VoiceAutoView()
    local barHeight = 36
    local barWidth = 396
    local startX_1row = gaping_w +66
    local startY_1row = osHeight -gaping_h -144 -180

    -- cc.ui.UILabel.new({
    --         text = "语音自动播放", 
    --         size = 30, 
    --         color = display.COLOR_BLACK
    --     })
    cc.ui.UIImage.new(Imgs.setting_3row_voice_tip, {scale9=false})
        :align(display.LEFT_TOP, startX_1row, startY_1row)
        :addTo(self.pop_window)

    StopVoiceView = cc.ui.UIPushButton.new(Imgs.setting_3row_voice_on,{scale9=false})
        -- :setButtonSize(51, 51)
        :setButtonImage(EnStatus.pressed, Imgs.setting_3row_voice_on)
        --:setButtonImage(EnStatus.disabled, Imgs.setting_3row_voice_on)
        :onButtonClicked(function(e)

            VoiceDealUtil:playSound_other(Voices.file.ui_click)
            -- 关闭和开启
            self:settingStopVoice()

        end)
        :align(display.LEFT_TOP, startX_1row +74+18 +95, startY_1row)
        :addTo(self.pop_window)
end

function SettingDialog:settingStopVoiceInit()
    -- 关闭和开启
    if currStopVoice~=nil and currStopVoice~=CEnum.musicStatus.def_fill and currStopVoice==CEnum.musicStatus.on then
        -- 初始化，是开启就是开启
        currStopVoice=CEnum.musicStatus.on

        GameState_VoiceSetting:setDataSingle(CEnum.voiceSetting.currStopVoice, CEnum.musicStatus.on)
        StopVoiceView:setButtonImage(EnStatus.normal, Imgs.setting_3row_voice_on)
        StopVoiceView:setButtonImage(EnStatus.pressed, Imgs.setting_3row_voice_on)
    else
        currStopVoice=CEnum.musicStatus.off

        GameState_VoiceSetting:setDataSingle(CEnum.voiceSetting.currStopVoice, CEnum.musicStatus.off)
        StopVoiceView:setButtonImage(EnStatus.normal, Imgs.setting_3row_voice_off)
        StopVoiceView:setButtonImage(EnStatus.pressed, Imgs.setting_3row_voice_off)
    end
end

function SettingDialog:settingStopVoice()
    -- print("-------------------00000000000000000000000000")
    -- 关闭和开启
    if currStopVoice~=nil and currStopVoice~=CEnum.musicStatus.def_fill and currStopVoice==CEnum.musicStatus.on then
        -- print("-------------------11111111111111111111111")
        -- 已经开启，点击之后就是关闭
        currStopVoice=CEnum.musicStatus.off

        GameState_VoiceSetting:setDataSingle(CEnum.voiceSetting.currStopVoice, CEnum.musicStatus.off)
        StopVoiceView:setButtonImage(EnStatus.normal, Imgs.setting_3row_voice_off)
        StopVoiceView:setButtonImage(EnStatus.pressed, Imgs.setting_3row_voice_off)
    else
        -- print("-------------------222222222222222222222222222")
        currStopVoice=CEnum.musicStatus.on

        GameState_VoiceSetting:setDataSingle(CEnum.voiceSetting.currStopVoice, CEnum.musicStatus.on)
        StopVoiceView:setButtonImage(EnStatus.normal, Imgs.setting_3row_voice_on)
        StopVoiceView:setButtonImage(EnStatus.pressed, Imgs.setting_3row_voice_on)
    end
end

function SettingDialog:createViewByLine(tag, parent_view, 
    first_btn_str, second_btn_str, 
    first_btn_img, second_btn_img, 
    first_btn_x, first_btn_y)

    local _8ju, _16ju
    local function updateCheckBoxButtonLabel(checkbox, tabIndex)
        if tabIndex == first_btn_str then
            _8ju:setButtonSelected(true) 
            _16ju:setButtonSelected(false)
            if tag == 1 then
                -- language = first_btn_str
                GameState_VoiceSetting:setDataSingle(CEnum.voiceSetting.language, first_btn_str)
            else
            end
        elseif tabIndex == second_btn_str then
            _8ju:setButtonSelected(false)
            _16ju:setButtonSelected(true)
            if tag == 1 then
                -- rounds = second_btn_str
                GameState_VoiceSetting:setDataSingle(CEnum.voiceSetting.language, second_btn_str)
            else
            end   
        end
    end

    -- 8局的
    -- 背景
    cc.ui.UIPushButton.new(
        -- Imgs.room_item_bg_small,{scale9=true})
        Imgs.c_transparent,{scale9=true})
        :setButtonSize(250, 52)
        :onButtonClicked(function(e)
            updateCheckBoxButtonLabel(_8ju, first_btn_str)
        end)
        :align(display.LEFT_TOP, first_btn_x, first_btn_y-5) -- 414 154
        :addTo(parent_view)
    -- checkbtn
    _8ju = cc.ui.UICheckBoxButton.new({
        off = Imgs.c_check_no,
        on = Imgs.c_check_yes
        })
        -- :setButtonLabel(cc.ui.UILabel.new({
        --     UILabelType = 2, 
        --     text = "                                 ",--33个空格，可以铺满 
        --     size = Dimens.TextSize_30,
        --     color = Colors.btn_normal,
        -- }))
        --:setButtonLabelOffset(120,0)
        :setButtonLabelAlignment(display.CENTER)
        -- :onButtonStateChanged(function(e)
        --     updateCheckBoxButtonLabel(e.target, first_btn_str)
        -- end)
        --:pos(414+34, osHeight-154-16-30/2)
        :align(display.LEFT_TOP, first_btn_x +15 +0, first_btn_y-3)
        :addTo(parent_view)
        :setButtonEnabled(false)
    -- 图片文字
    cc.ui.UIImage.new(first_btn_img)
        :setLayoutSize(124*8/10,43*8/10)
        :addTo(parent_view)
        :align(display.LEFT_TOP, first_btn_x +15 +50, first_btn_y-12)


    -- 16局的
    local startX_1row_end_end = 260
    if CVar._static.isIphone4 or CVar._static.isIpad then
        startX_1row_end_end = startX_1row_end_end -30
    end
    -- 背景
    cc.ui.UIPushButton.new(
        -- Imgs.room_item_bg_small,{scale9=true})
        Imgs.c_transparent,{scale9=true})
        :setButtonSize(250, 52)
        :onButtonClicked(function(e)
            updateCheckBoxButtonLabel(_16ju, second_btn_str)
        end)
        :align(display.LEFT_TOP, first_btn_x +startX_1row_end_end, first_btn_y-5 )
        :addTo(parent_view)
    -- checkbtn
    _16ju = cc.ui.UICheckBoxButton.new({
        off = Imgs.c_check_no,
        on = Imgs.c_check_yes
        })
        --:setButtonImage(UICheckBoxButton.ON, Imgs.room_1jushu_8, true)
        -- :setButtonLabel(cc.ui.UILabel.new({
        --     UILabelType = 2, 
        --     text = "                                 ",--33个空格，可以铺满 
        --     size = Dimens.TextSize_30,
        --     color = Colors.btn_normal,
        -- }))
        --:setButtonLabelOffset(120,0)
        :setButtonLabelAlignment(display.CENTER)
        -- :onButtonStateChanged(function(e)
        --     updateCheckBoxButtonLabel(e.target, second_btn_str)
        -- end)
        --:pos(414+300+58+34, osHeight-154-16-30/2)
        :align(display.LEFT_TOP, first_btn_x +startX_1row_end_end +15 +0, first_btn_y-3 )
        :addTo(parent_view)
        :setButtonEnabled(false)
    -- 图片文字
    cc.ui.UIImage.new(second_btn_img)
        :setLayoutSize(124*8/10,43*8/10)
        :addTo(parent_view)
        :align(display.LEFT_TOP, first_btn_x +startX_1row_end_end +15 +50, first_btn_y-12 )

    -- 默认值为第一项
    _8ju:setButtonSelected(false)
    _16ju:setButtonSelected(true)
    local language = GameState_VoiceSetting:getDataSingle(CEnum.voiceSetting.language)
    if language ~= nil and CEnum.language.ww == language then
        _8ju:setButtonSelected(true)
        _16ju:setButtonSelected(false)
    end

    -- local group = cc.ui.UICheckBoxButtonGroup.new(display.LEFT_TO_RIGHT);
    -- group:addButton(_8ju)
    --     :addButton(_16ju)
    --     :addTo(self.pop_window)
    --     :align(display.LEFT_TOP, 414, osHeight-154)
end

function SettingDialog:onExit()
    self:myExit()
end

function SettingDialog:myExit()

	currSoundsVolume = nil -- 音效
	currMusicVolume = nil -- 背景音乐

	currStopSounds = nil -- 音效
    currStopMusic = nil -- 背景音乐
	currStopVoice = nil -- 语音自动播放

	StopSoundsView = nil
    StopMusicView = nil
	StopVoiceView = nil

    if self.pop_window ~= nil and (not tolua.isnull(self.pop_window)) then
        self.pop_window:removeFromParent()
        self.pop_window = nil
    end
end

return SettingDialog
