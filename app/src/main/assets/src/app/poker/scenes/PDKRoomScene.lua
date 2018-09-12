--
-- Author: wh
-- Date: 2017-05-05 10:00:55
-- 跑得快房间

local PDKRoomScene = class("PDKRoomScene", function()
    return display.newScene("PDKRoomScene")
end)

-- local user_roomNo

local voiceSpeakClockTime = CVar._static.clockVoiceTime -- 说话框的倒计时 总时间
local voiceSpeakBg -- 说话框的背景
local voiceSpeakImg -- 说话框的话筒
local voiceSpeakSlider -- 说话框的倒计时进度条
local voiceSpeakClickBtn -- 说话按钮

local top_scheduler
local top_schedulerID_voice
local Layer1


function PDKRoomScene:ctor()

    -- 预加载这些动画plist文件
    display.addSpriteFrames(Imgs.voiceplay_plist, Imgs.voiceplay_png) -- 语音播放动画
    display.addSpriteFrames(Imgs.biaoqing_expContent.."exp"..Imgs.file_imgPlist_suff, Imgs.biaoqing_expContent.."exp"..Imgs.file_img_suff) -- 表情

    display.addSpriteFrames(ImgsM.superEmoji_plist, ImgsM.superEmoji_texture) -- 超级表情

    -- Layer1 = display.newLayer()
    --     :pos(0, 0)
    --     :addTo(self)
 
	-- 整个底色背景
	display.newSprite(PDKImgs.room_bg)
		:center()
		:addTo(self)

    self.controller = RoomController.new(self)
    self.ctx = self.controller.ctx


	self.touchLayer_ = display.newLayer()
    self:addChild(self.touchLayer_)
    Layer1 = self


    self:setNodeEventEnabled(true)

     --local list = {0x02,0x12,0x0D,0x0C,0x1C,0x0B,0x1B,0x2B,0x32,0x03,0x09,0x07,0x01,0x02,0x03,0x01}
     -- 控制交互层
    self.controller:createNodes()

    self.dragCard_ = CardListView.new(2,30)
    self:addChild(self.dragCard_) 
    self.controller.mycardView:setDragCard(self.dragCard_)
     -- self.controller.mycardView:setCard(list)
     -- self.controller.mycardView:rePositonCard()

     -- 倒计时层
    self.clockNode = display.newNode()
        :addTo(self)

    top_scheduler = self.touchLayer_:getScheduler()
    -- local userGameing = GameStateUserGameing:getData()
    -- user_roomNo = userGameing[Room.Bean.roomNo]
    -- user_roomNo = CVar._static.roomNo
  
    -- 表情
    -- 表情展开按钮
    cc.ui.UIPushButton.new(
      Imgs.biaoqing_btn,{scale9=false})
      :setButtonImage(EnStatus.pressed, Imgs.biaoqing_btn)
      :onButtonClicked(function(e)
      
          VoiceDealUtil:playSound_other(Voices.file.ui_click)
          EmojiDialog:popDialogBox(self)
          
      end)
      :align(display.RIGHT_BOTTOM, display.width-20, 18+200)
      :addTo(self)

    -- 语音展示界面相关信息
    -- 1
    voiceSpeakBg = cc.ui.UIImage.new(Imgs.hx_record_bg,{})
        :addTo(self)
        :align(display.CENTER, display.cx, display.cy)
        :hide()
    -- 2
    voiceSpeakImg = cc.ui.UIImage.new(Imgs.hx_record_bg_inline,{})
        :addTo(self)
        :align(display.CENTER, display.cx, display.cy)
        :hide()
    -- 3
    voiceSpeakSlider = 
        -- cc.ProgressTimer:create(cc.Sprite:create(Imgs.voice_slider_bg_layer))  
        --     :setType(cc.PROGRESS_TIMER_TYPE_RADIAL) -- 圆形
        --     :setReverseDirection(true) --  顺时针覆盖东西=true 
        --     :setMidpoint(cc.p(0.5,0.5)) --设置起点为条形坐下方 
        --     :align(display.CENTER, display.cx, display.cy) 

        cc.ProgressTimer:create(cc.Sprite:create(Imgs.voice_slider_bg_layer))  
            :setType(cc.PROGRESS_TIMER_TYPE_BAR) -- 条形
            :setMidpoint(cc.p(0,0)) --设置起点为条形坐下方 
            :align(display.CENTER, display.cx, display.cy-80)
        
        :setBarChangeRate(cc.p(1,0))  --设置为竖直方向  
        :setPercentage(CVar._static.clockVoiceTime) -- 设置初始进度为30  
        :addTo(self)
        :hide()

    -- 语音点击展开按钮
    voiceSpeakClickBtn = 
    cc.ui.UIPushButton.new(
        Imgs.voice_btn,{scale9=false})
        :setButtonImage(EnStatus.pressed, Imgs.voice_btn)
        :align(display.RIGHT_BOTTOM, display.width-20, 18 +10+70+200)
        :addTo(self)
        -- :hide()
    voiceSpeakClickBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, handler(self,self.Dictate_TouchListener))        
    voiceSpeakClickBtn:setTouchEnabled(true)
    
end

-- 录音按钮触摸事件
function PDKRoomScene:Dictate_TouchListener(event)

    if event.name == EnStatus.began or event.name == EnStatus.clicked then
        Dictate_y_began = event.y
        PDKRoomScene:Dictate_TouchListener_Began()  
        return true
    elseif event.name == EnStatus.moved then
        return true 
    elseif  event.name == EnStatus.ended then
        if voiceSpeakClockTime <= 90 then
            Commons:printLog_Info("--------------end 瞬间多少啦：：去发送")
            PDKRoomScene:Dictate_TouchListener_End()
        else
            Commons:printLog_Info("--------------end 瞬间多少啦：：时间不够")
            PDKRoomScene:Dictate_TouchListener_Move()
        end
        return true 
    end 
end

-- 开始录音和倒计时
function PDKRoomScene:Dictate_TouchListener_Began()

    -- 背景声音和音效开关控制
    VoiceDealUtil:stopBgMusic()
    GameState_VoiceSetting:setDataSingle(CEnum.voiceSetting.currStopMusic, CEnum.musicStatus.off)
    GameState_VoiceSetting:setDataSingle(CEnum.voiceSetting.currStopSounds, CEnum.musicStatus.off)


    voiceSpeakClockTime = CVar._static.clockVoiceTime
    voiceSpeakSlider:setPercentage(voiceSpeakClockTime)

    local function PDKRoomScene_changeVoice()
        voiceSpeakClockTime = voiceSpeakClockTime - 1
        voiceSpeakSlider:setPercentage(voiceSpeakClockTime)
        if voiceSpeakClockTime <= 0 then
            PDKRoomScene:Dictate_TouchListener_End()
        end
    end
    top_schedulerID_voice = top_scheduler:scheduleScriptFunc(PDKRoomScene_changeVoice, 0.1, false) -- **秒一次

    voiceSpeakBg:setVisible(true)
    voiceSpeakImg:setVisible(false)
    voiceSpeakSlider:setVisible(true)

    Commons:gotoDictate()
end

-- move之后，强行停止
function PDKRoomScene:Dictate_TouchListener_Move()

    -- 背景声音和音效开关控制
    if CVar._static.currStopSounds_init ~= nil and CEnum.musicStatus.off == CVar._static.currStopSounds_init then
        GameState_VoiceSetting:setDataSingle(CEnum.voiceSetting.currStopSounds, CEnum.musicStatus.off)
    else
        GameState_VoiceSetting:setDataSingle(CEnum.voiceSetting.currStopSounds, CEnum.musicStatus.on)
    end

    -- 界面消失
    voiceSpeakBg:setVisible(false)
    voiceSpeakImg:setVisible(false)
    voiceSpeakSlider:setVisible(false)

    -- 关闭倒计时
    if top_scheduler ~= nil and top_schedulerID_voice ~= nil then
        top_scheduler:unscheduleScriptEntry(top_schedulerID_voice)
        top_schedulerID_voice = nil
    end

    -- 用户自己去掉录音，需要把没有播放完的东西继续
    if Commons:checkIsNull_tableType(CVar._static.voiceWaitPlayTable) then
        for k,v in pairs(CVar._static.voiceWaitPlayTable) do
            if v ~= CEnum.seatNo.playOver then
                Commons:printLog_Info("----voice me--队列>1中选一个 可以播放的有----",k,v)
                PDKRoomScene:downLoadVoice_toPlay(k, v)
                break
            end
        end
    end
    
    Commons:gotoDictateStop()
end

-- end之后，播放上传
function PDKRoomScene:Dictate_TouchListener_End()

    -- 界面消失
    voiceSpeakBg:setVisible(false)
    voiceSpeakImg:setVisible(false)
    voiceSpeakSlider:setVisible(false)

    -- 关闭倒计时
    if top_scheduler ~= nil and top_schedulerID_voice ~= nil then
        top_scheduler:unscheduleScriptEntry(top_schedulerID_voice)
        top_schedulerID_voice = nil
    end

    -- Layer1:performWithDelay(function ()
        -- 停止录音，也停止各项东西
        local function PDKRoomScene_DictateStop_CallbackLua(txt)
                if Commons.osType == CEnum.osType.A then
                    -- 由于安卓机器的烂，必须先上传再播放，或者先播放在上传，只能一件一件的事情去顺序执行
                    local fileNameShort = "flyvoice.wav"
                    local _seat = CEnumP.seatNo.me
                    -- 上传文件给服务器
                    ImDealUtil:uploadVoice(function(url) PDKRoomScene:upLoadVoiceBack_ByOrder(url, fileNameShort, _seat) end, nil)

                elseif Commons.osType == CEnum.osType.I then
                    -- ios的机器性能好点，其实也是可以走安卓做法
                    -- 上传文件给服务器
                    ImDealUtil:uploadVoice(function(url) PDKRoomScene:upLoadVoiceBack(url) end, nil)
                    --同时播放自己的录音
                    PDKRoomScene:upLoadVoice_andPlayMeVoice()
                end
        end
        Commons:gotoDictateStop(PDKRoomScene_DictateStop_CallbackLua)
    -- end, 0.005)
end

-- 上传完成录音，就开始发送出去
function PDKRoomScene:upLoadVoiceBack(RemoteUrl)
    if Commons:checkIsNull_str(RemoteUrl) then
        SocketRequestGameing:gameing_SendVoice(RemoteUrl)
    end
end

function PDKRoomScene:upLoadVoice_andPlayMeVoice()
    ---[[
    -- 去播放 自己的录音，也放在队列中去播放
    if Commons:checkIsNull_tableType(CVar._static.voiceWaitPlayTable) then
        --所有的语音播完再出音效

            local fileNameShort = "flyvoice.wav"
            local _seat = CEnumP.seatNo.me
            Commons:printLog_Info("----voice me--需要 播放信息是：", _seat, fileNameShort)
            --if status == CEnum.status.success then
                if CEnum.Environment.Current~=nil and CEnum.Environment.Current==CEnum.EnvirType.Test then
                    CVar._static.voiceWaitPlayTable[fileNameShort] = _seat
                else
                    -- 相同的东西，只是播放一遍
                    if CVar._static.voiceWaitPlayTable[fileNameShort] ~= nil and CVar._static.voiceWaitPlayTable[fileNameShort] == CEnum.seatNo.playOver then
                    else
                        CVar._static.voiceWaitPlayTable[fileNameShort] = _seat
                    end
                end
            --end
            local _sizeTable = 0
            for k,v in pairs(CVar._static.voiceWaitPlayTable) do
                if v ~= CEnum.seatNo.playOver then
                    _sizeTable = _sizeTable + 1
                end
            end
            Commons:printLog_Info("----voice me--有几个需要播放：", _sizeTable)
            --dump(CVar._static.voiceWaitPlayTable)

            if _sizeTable == 1 then
                Commons:printLog_Info("----voice me--确定 播放信息是：", _seat, fileNameShort)
                --if status == CEnum.status.success then
                    PDKRoomScene:downLoadVoice_toPlay(fileNameShort, _seat)
                --end
            elseif _sizeTable > 1 then
                -- 队列中挑选一个去播放
                if Commons:checkIsNull_tableType(CVar._static.voiceWaitPlayTable) then
                    for k,v in pairs(CVar._static.voiceWaitPlayTable) do
                        --Commons:printLog_Info("----voice me--队列>1中选一个 要播放的东西吗？？----",k,v)
                        if v ~= CEnum.seatNo.playOver then
                            Commons:printLog_Info("----voice me--队列>1中选一个 可以播放的有----",k,v)
                            PDKRoomScene:downLoadVoice_toPlay(k, v)
                            break
                        end
                    end
                end

            end
    end
    --]]
end

-- 上传完成录音，就开始发送，发送后再开始播放我自己的录音（我自己的录音在队列中）
function PDKRoomScene:upLoadVoiceBack_ByOrder(RemoteUrl, fileNameShort, _seat)
    if Commons:checkIsNull_str(RemoteUrl) then
        SocketRequestGameing:gameing_SendVoice(RemoteUrl)
    end

    ---[[
    -- 去播放 自己的录音，也放在队列中去播放
    if Commons:checkIsNull_tableType(CVar._static.voiceWaitPlayTable) then
        --所有的语音播完再出音效

            Commons:printLog_Info("----voice me--需要 播放信息是：", _seat, fileNameShort)
            if CEnum.Environment.Current~=nil and CEnum.Environment.Current==CEnum.EnvirType.Test then
                CVar._static.voiceWaitPlayTable[fileNameShort] = _seat
            else
                -- 相同的东西，只是播放一遍
                if CVar._static.voiceWaitPlayTable[fileNameShort] ~= nil and CVar._static.voiceWaitPlayTable[fileNameShort] == CEnum.seatNo.playOver then
                else
                    CVar._static.voiceWaitPlayTable[fileNameShort] = _seat
                end
            end
            local _sizeTable = 0
            for k,v in pairs(CVar._static.voiceWaitPlayTable) do
                if v ~= CEnum.seatNo.playOver then
                    _sizeTable = _sizeTable + 1
                end
            end
            Commons:printLog_Info("----voice me--有几个需要播放：", _sizeTable)
            --dump(CVar._static.voiceWaitPlayTable)

            if _sizeTable == 1 then
                Commons:printLog_Info("----voice me--确定 播放信息是：", _seat, fileNameShort)
                PDKRoomScene:downLoadVoice_toPlay(fileNameShort, _seat)
            elseif _sizeTable > 1 then
                -- 队列中挑选一个去播放
                if Commons:checkIsNull_tableType(CVar._static.voiceWaitPlayTable) then
                    for k,v in pairs(CVar._static.voiceWaitPlayTable) do
                        --Commons:printLog_Info("----voice me--队列>1中选一个 要播放的东西吗？？----",k,v)
                        if v ~= CEnum.seatNo.playOver then
                            Commons:printLog_Info("----voice me--队列>1中选一个 可以播放的有----",k,v)
                            PDKRoomScene:downLoadVoice_toPlay(k, v)
                            break
                        end
                    end
                end

            end
    end
    --]]
end

-- 播放录音
local voice_node_view
function PDKRoomScene:downLoadVoice_toPlay(fileNameShort, _seat)

    if Commons:checkIsNull_str(fileNameShort) then

        -- 背景声音和音效开关控制
        VoiceDealUtil:stopBgMusic()
        GameState_VoiceSetting:setDataSingle(CEnum.voiceSetting.currStopMusic, CEnum.musicStatus.off)
        GameState_VoiceSetting:setDataSingle(CEnum.voiceSetting.currStopSounds, CEnum.musicStatus.off)

        Commons:printLog_Info("-----------到播放了", fileNameShort, _seat)
        voice_node_view = EmojiView:createVoice_Anim(Layer1, _seat, voice_node_view)

        local function PDKRoomScene_DictatePlay_CallbackLua_RL(txt)
            Commons:printLog_Info("-----------播放完成拉")
            if voice_node_view ~= nil and (not tolua.isnull(voice_node_view)) then
              voice_node_view:stopAllActions()
              voice_node_view:removeFromParent()
              voice_node_view = nil
            end

            -- 队列播放
            if Commons:checkIsNull_tableType(CVar._static.voiceWaitPlayTable) then
                CVar._static.voiceWaitPlayTable[fileNameShort] = CEnum.seatNo.playOver
                local isHaveNeedPlay = false

                for k,v in pairs(CVar._static.voiceWaitPlayTable) do
                    --Commons:printLog_Info("----还有要播放的东西吗？？----",k,v)
                    if v ~= CEnum.seatNo.playOver then
                        Commons:printLog_Info("----可以播放的有----",k,v)
                        isHaveNeedPlay = true
                        PDKRoomScene:downLoadVoice_toPlay(k, v)
                        break
                    end
                end

                if not isHaveNeedPlay then
                    CVar._static.voiceWaitPlayTable = {}

                    -- 背景声音和音效开关控制
                    if CVar._static.currStopSounds_init ~= nil and CEnum.musicStatus.off == CVar._static.currStopSounds_init then
                        GameState_VoiceSetting:setDataSingle(CEnum.voiceSetting.currStopSounds, CEnum.musicStatus.off)
                    else
                        GameState_VoiceSetting:setDataSingle(CEnum.voiceSetting.currStopSounds, CEnum.musicStatus.on)
                    end
                end
            end

        end
        Commons:gotoDictatePlay(PDKRoomScene_DictatePlay_CallbackLua_RL, fileNameShort)
        Commons:printLog_Info("-----------平台 播放结束拉", fileNameShort, _seat)
    end
end

-- 先下载完成，再去播放
function PDKRoomScene:downLoadVoiceBack(status, fileNameShort, _seat, RemoteUrl)
        -- 去播放
        if Commons:checkIsNull_tableType(CVar._static.voiceWaitPlayTable) then
                Commons:printLog_Info("----voice 22--需要 播放信息是：", _seat, fileNameShort)
                if status == CEnum.status.success then
                    if CEnum.Environment.Current~=nil and CEnum.Environment.Current==CEnum.EnvirType.Test then
                        CVar._static.voiceWaitPlayTable[fileNameShort] = _seat
                    else
                        -- 相同的东西，只是播放一遍
                        if CVar._static.voiceWaitPlayTable[fileNameShort] ~= nil and CVar._static.voiceWaitPlayTable[fileNameShort] == CEnum.seatNo.playOver then
                        else
                            CVar._static.voiceWaitPlayTable[fileNameShort] = _seat
                        end
                    end
                end
                local _sizeTable = 0
                for k,v in pairs(CVar._static.voiceWaitPlayTable) do
                    if v ~= CEnum.seatNo.playOver then
                        _sizeTable = _sizeTable + 1
                    end
                end
                Commons:printLog_Info("----voice 22--有几个需要播放：", _sizeTable)
                --dump(CVar._static.voiceWaitPlayTable)

                if _sizeTable == 1 then
                    Commons:printLog_Info("----voice 22--确定播放信息是：", _seat, fileNameShort)
                    if status == CEnum.status.success then
                        PDKRoomScene:downLoadVoice_toPlay(fileNameShort, _seat)
                    end                    
                end
        end

        -- 队列下载
        if Commons:checkIsNull_tableType(CVar._static.voiceWaitDownTable) then
            CVar._static.voiceWaitDownTable[RemoteUrl] = CEnum.seatNo.downOver
            local isHaveNeedDown = false

            for k,v in pairs(CVar._static.voiceWaitDownTable) do
                --Commons:printLog_Info("----voice 22--还有要下载的东西吗？？----",k,v)
                if v ~= CEnum.seatNo.downOver then
                    Commons:printLog_Info("----voice 22--可以下载的有----",k,v)
                    isHaveNeedDown = true
                    ImDealUtil:downLoad(function(a,b,c,d) PDKRoomScene:downLoadVoiceBack(a,b,c,d) end, k, v)
                    break
                end
            end

            if not isHaveNeedDown then
                CVar._static.voiceWaitDownTable = {}
            end
        end
end

function PDKRoomScene:voice_createView_setViewData(res_data, model)
    if res_data ~= nil then
        local room = res_data--[User.Bean.room]
        local voiceUrl = room[Player.Bean.voiceUrl]
        local currNo = room[Player.Bean.seatNo]

        -- local _seat = GameingDealUtil:confimSeatNo(mySeatNo, currNo) -- 确定相对位置：：0=本人位置，1=下一玩家，-1=上一玩家，最后一玩家
        local _seat = model:getOtherClientSeatId(currNo) -- 确定相对位置：：0=本人位置，1=下一玩家，-1=上一玩家，最后一玩家

        if Commons:checkIsNull_tableType(CVar._static.voiceWaitDownTable) then
            Commons:printLog_Info("----voice 11--当前 下载信息是：", _seat, voiceUrl)
            if CEnum.Environment.Current~=nil and CEnum.Environment.Current==CEnum.EnvirType.Test then
                CVar._static.voiceWaitDownTable[voiceUrl] = _seat
            else
                -- 相同的东西，只是播放一遍
                if CVar._static.voiceWaitDownTable[voiceUrl] ~= nil and CVar._static.voiceWaitDownTable[voiceUrl] == CEnum.seatNo.downOver then
                else
                    CVar._static.voiceWaitDownTable[voiceUrl] = _seat
                end  
            end

            local _sizeTable = 0
            for k,v in pairs(CVar._static.voiceWaitDownTable) do
                if v ~= CEnum.seatNo.downOver then
                    _sizeTable = _sizeTable + 1
                end
            end
            Commons:printLog_Info("----voice 11--有几个需要下载：", _sizeTable)

            if _sizeTable == 1 then
                Commons:printLog_Info("----voice 11--确定 下载信息是：", _seat, voiceUrl)
                if _seat == CEnumP.seatNo.me then
                    -- 自己发送的表情，自己不播放
                    if CEnum.Environment.Current~=nil and CEnum.Environment.Current==CEnum.EnvirType.Test then
                        ImDealUtil:downLoad( function(a,b,c,d) PDKRoomScene:downLoadVoiceBack(a,b,c,d) end, voiceUrl, _seat)
                    end
                elseif _seat == CEnumP.seatNo.R then
                    ImDealUtil:downLoad( function(a,b,c,d) PDKRoomScene:downLoadVoiceBack(a,b,c,d) end, voiceUrl, _seat)
                elseif _seat == CEnumP.seatNo.L then
                    ImDealUtil:downLoad( function(a,b,c,d) PDKRoomScene:downLoadVoiceBack(a,b,c,d) end, voiceUrl, _seat)
                end
            elseif _sizeTable > 1 then
                -- 队列中挑选一个去下载
                if Commons:checkIsNull_tableType(CVar._static.voiceWaitDownTable) then
                    for k,v in pairs(CVar._static.voiceWaitDownTable) do
                        --Commons:printLog_Info("----voice 11--队列>1中选一个 要下载的东西吗？？----",k,v)
                        if v ~= CEnum.seatNo.downOver then
                            Commons:printLog_Info("----voice 11--队列>1中选一个 可以下载的有----",k,v)
                            ImDealUtil:downLoad( function(a,b,c,d) PDKRoomScene:downLoadVoiceBack(a,b,c,d) end, k, v)
                            break
                        end
                    end
                end

            end

        end
        
    end
end


-- 构造方法 
function PDKRoomScene:onEnter()
    self.touchLayer_:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        return self:onTouch(event)
    end)

    -- CEnum.AppVersion.gameAlias = CEnum.gameType.pdk
    -- VoiceDealUtil:stopBgMusic()
    -- -- self:performWithDelay(function ()
    -- VoiceDealUtil:playPDKBgMusic()              
    -- --end, 2)
end

-- 触屏事件申明
function PDKRoomScene:onTouch(event)
  if self.controller and self.controller.mycardView then
	   return self.controller.mycardView:onTouch(event)
  end
  return nil
end

-- 游戏界面退出
function PDKRoomScene:onExit()
    self.controller:dispose()
end

return PDKRoomScene