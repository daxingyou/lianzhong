--
-- Author: wh
-- Date: 2017-05-11 12:40:33
-- 跑得快单局游戏结束弹窗

-- 类申明
local PDKOverRoundDialog = class("PDKOverRoundDialog",
	function()
		return display.newNode()
	end
)

local osWidth = Commons.osWidth
local osHeight = Commons.osHeight

--local gameRound = '0' -- 回合结束
local gameOver = '1' -- 房间结束
local gamePlay = '2' -- 回放

local tag_isSubmit = '1' -- 确认按钮，默认是 gameOver
-- local tag_isCancel = '1' -- 取消按钮，默认是 gameOver


function PDKOverRoundDialog:ctor(roundResult, gameOverData, callback, _fromView, _startTime, _roomNo, _roundNo, playRound, _fromOther, _targetToken)

    tag_isSubmit = gameOver
    -- tag_isCancel = gameOver

    self.roundResult = roundResult
    self.gameOverData_ = gameOverData
    self.callback_ = callback

    self.fromView = _fromView
    self.startTime = _startTime
    self.roomNo = _roomNo
    self.roundNo = _roundNo
    self.fromOther = _fromOther
    self.targetToken = ""
    if Commons:checkIsNull_str(_targetToken) then
        self.targetToken = _targetToken
    end

	self.pop_window = display.newColorLayer(cc.c4b(0, 0, 0, 100))       -- 半透明的黑色
    self.pop_window:setContentSize(osWidth, osHeight)             -- 设置Layer的大小,全屏出现
    self.pop_window:setTouchEnabled(true)
    self.pop_window:setTouchSwallowEnabled(true)  -- 吞噬下层的响应
    self.pop_window:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event) -- 点击此Layer时候输出信息,然后把自己销毁
        return true
    end)
    self.pop_window:addTo(self)


    self.alert_gaping_w = 0
    self.alert_gaping_h = 90
    self.moveX = 0
    if CVar._static.isIphone4 then
        self.moveX = 0
    elseif CVar._static.isIpad then
        self.moveX = 0
    end


    -- 整个背景
    self.bg_ = --display.newSprite(PDKImgs.tableOver_over_bg)
        cc.ui.UIImage.new(PDKImgs.tableOver_over_bg,{scale9=false})
            :addTo(self.pop_window)
            -- :center()
            -- :setPositionY(display.cy-30)
            -- :setContentSize(osWidth, osHeight -self.alert_gaping_h*2)
            :align(display.CENTER_BOTTOM, display.cx, self.alert_gaping_h)

    -- 胜利 title
    self.win_title = display.newSprite(PDKImgs.tableOver_win_title)
        :addTo(self.pop_window)
        -- :pos(display.cx, display.cy+392/2 -20)
        -- :addTo(self.bg_)
        :align(display.CENTER_TOP, display.cx, osHeight -self.alert_gaping_h+70)
        :hide()

    -- 失败 title
    self.lose_title = display.newSprite(PDKImgs.tableOver_lose_title)
        :addTo(self.pop_window)
        -- :pos(display.cx, display.cy+392/2 -20)
        -- :addTo(self.bg_)
        :align(display.CENTER_TOP, display.cx, osHeight -self.alert_gaping_h+70)
        :hide()

    -- 关闭
    local contentSize = self.bg_:getContentSize()
    self.closeBtn = cc.ui.UIPushButton.new({normal=PDKImgs.tableOver_over_close_btn, pressed=PDKImgs.tableOver_over_close_btn},{scale9=false})
        :onButtonClicked(function(e)
            VoiceDealUtil:playSound_other(Voices.file.ui_click)
            if self.callback_ and self.gameOverData_ then
                self.callback_()
            end
            self:removeFromParent()
        end)
        :onButtonPressed(function(event)
          event.target:setPositionY(osHeight -self.alert_gaping_h -80 -3)
        end
        )
        :onButtonRelease(function(event)
          event.target:setPositionY(osHeight -self.alert_gaping_h -80)
        end
        )
        -- :align(display.CENTER, display.cx+contentSize.width/2, display.cy+contentSize.height/2 -10)
        :align(display.CENTER_TOP, display.cx +contentSize.width/2.0 +self.moveX, osHeight -self.alert_gaping_h -80)
    	:addTo(self.pop_window)

    -- 再来一局
    self.GameContinue = cc.ui.UIPushButton.new({normal=PDKImgs.tableOver_game_continue_btn, pressed=PDKImgs.tableOver_game_continue_btn_pre},{scale9=false})
            :onButtonClicked(function(e)
                VoiceDealUtil:playSound_other(Voices.file.ui_click)
                
                if self.callback_ and self.gameOverData_ then
                    self.callback_()
                end
                self:removeFromParent()

            end)
        -- :align(display.CENTER, display.cx, display.cy-contentSize.height/2 +50 -30)
        :align(display.CENTER_BOTTOM, display.cx, self.alert_gaping_h +10)
        :addTo(self.pop_window)
        :hide()

    -- 牌局结束
    self.GameOver = cc.ui.UIPushButton.new({normal=PDKImgs.tableOver_game_over_btn_nor, pressed=PDKImgs.tableOver_game_over_btn_pre},{scale9=false})
        :onButtonClicked(function(e)

            VoiceDealUtil:playSound_other(Voices.file.ui_click)
            if self.callback_ and self.gameOverData_ then
                self.callback_()
            end
                self:removeFromParent()

        end)
        -- :align(display.CENTER, display.cx, display.cy-contentSize.height/2 +50-30)
        :align(display.CENTER_BOTTOM, display.cx, self.alert_gaping_h +10)
        :addTo(self.pop_window)
        :hide()

    -- 回放
    self.GamePlay = cc.ui.UIPushButton.new({normal=PDKImgs.pdk_playback_btn_nor, pressed=PDKImgs.pdk_playback_btn_pre},{scale9=false})
        :onButtonClicked(function(e)

            VoiceDealUtil:playSound_other(Voices.file.ui_click)
            self.loadingPop_window_result = CDAlertLoading.new():popDialogBox(self.pop_window, Strings.hint_Loading)
            local param = { roomNo=self.roomNo, roundNo=self.roundNo }
            if self.fromOther == nil then
                RequestPDKRoomResult.new():getPDKGameingMirror(param, function(...) self:getPDKGameMirror(...) end )
            else
                param = { roomNo=self.roomNo, roundNo=self.roundNo, targetToken=self.targetToken }
                RequestPDKRoomResult.new():getOtherPDKGameingMirror(param, function(...) self:getPDKGameMirror(...) end )
            end

        end)
        -- :align(display.CENTER, display.cx, display.cy-contentSize.height/2 +50-30)
        :align(display.CENTER_BOTTOM, display.cx, self.alert_gaping_h +10)
        :addTo(self.pop_window)
        :hide()

    if CVar._static.isIphone4 then
        self.moveX = -100
    elseif CVar._static.isIpad then
        self.moveX = -150
    end
    local font_color = cc.c3b(0x7b, 0x66,0x57)-- Colors.white
    -- 房间号
    self.view_roomNo = 
    cc.ui.UILabel.new({
            UILabelType = 2,
            text = "",
            font = Fonts.Font_hkyt_w7,
            size = Dimens.TextSize_20,
            -- color = Colors.white,
            color = font_color,
            align = cc.ui.TEXT_ALIGN_LEFT,
            valign = cc.ui.TEXT_VALIGN_CENTER,
            dimensions = cc.size(200,25),
            --maxLineWidth = 118,
        })
        :addTo(self.pop_window)
        :align(display.LEFT_BOTTOM, 14+30+300 +self.moveX, self.alert_gaping_h +60)
        :hide()
    if Commons:checkIsNull_str(self.roomNo) then
        self.view_roomNo:setString("房号："..self.roomNo..'')
    end
    if self.fromView~=nil then -- 来自战绩页面
        self.view_roomNo:show()
    end

    -- 局号
    self.view_roundNo = 
    cc.ui.UILabel.new({
            UILabelType = 2,
            text = "",
            font = Fonts.Font_hkyt_w7,
            size = Dimens.TextSize_20,
            -- color = Colors.white,
            color = font_color,
            align = cc.ui.TEXT_ALIGN_LEFT,
            valign = cc.ui.TEXT_VALIGN_CENTER,
            dimensions = cc.size(200,25),
            --maxLineWidth = 118,
        })
        :addTo(self.pop_window)
        :align(display.LEFT_BOTTOM, 14+30+300 +self.moveX, self.alert_gaping_h +25)
        :hide()
    if Commons:checkIsNull_str(playRound) then
        self.view_roundNo:setString("局："..playRound)--..'/'..rounds)
    end
    if self.fromView~=nil then -- 来自战绩页面
        self.view_roundNo:show()
    end

    -- 当前手机时间
    local myDate = os.date("%Y-%m-%d %H:%M:%S") -- "%Y-%m-%d %H:%M:%S"
    self.view_roomTime = 
    cc.ui.UILabel.new({
            UILabelType = 2,
            text = ''..myDate, -- "结束时间："..myDate,
            font = Fonts.Font_hkyt_w7,
            size = Dimens.TextSize_20,
            -- color = Colors.white,
            color = font_color,
            -- align = cc.ui.TEXT_ALIGN_RIGHT,
            align = cc.ui.TEXT_ALIGN_LEFT,
            valign = cc.ui.TEXT_VALIGN_CENTER,
            dimensions = cc.size(300,25),
            --maxLineWidth = 118,
        })
        :addTo(self.pop_window)
        :align(display.RIGHT_BOTTOM, osWidth -14-30-150 -self.moveX, self.alert_gaping_h +60 -(60-25)/2)
        -- :align(display.LEFT_TOP, 14+30, osHeight -self.alert_gaping_h -35*1)
        :hide()
    if Commons:checkIsNull_str(self.startTime) then
        -- self.view_roomTime:setString("开始时间："..self.startTime)
        self.view_roomTime:setString(''..self.startTime)
    end
    if self.fromView~=nil then -- 来自战绩页面
        self.view_roomTime:show()
    end

    -- 名称
    display.newSprite(PDKImgs.pdk_over_th_name)
        :addTo(self.pop_window)
        :align(display.CENTER_TOP, display.cx-200, osHeight-self.alert_gaping_h -(osHeight-self.alert_gaping_h)/3)
    -- 剩牌
    display.newSprite(PDKImgs.pdk_over_th_sheng)
        :addTo(self.pop_window)
        :align(display.CENTER_TOP, display.cx-200 +150, osHeight-self.alert_gaping_h -(osHeight-self.alert_gaping_h)/3)
    -- 炸弹
    display.newSprite(PDKImgs.pdk_over_th_zhan)
        :addTo(self.pop_window)
        :align(display.CENTER_TOP, display.cx-200 +150*2, osHeight-self.alert_gaping_h -(osHeight-self.alert_gaping_h)/3)
    -- 积分
    display.newSprite(PDKImgs.pdk_over_th_score)
        :addTo(self.pop_window)
        :align(display.CENTER_TOP, display.cx-200 +150*3, osHeight-self.alert_gaping_h -(osHeight-self.alert_gaping_h)/3)

    -- 数据显示
    if self.fromView~=nil then -- and self.fromView==CEnum.pageView.gameingOverPage then
        tag_isSubmit = gamePlay
        self.GamePlay:show()
        -- 来自战绩页面
        self.loadingPop_window = CDAlertLoading.new():popDialogBox(self.pop_window, Strings.hint_Loading)
        local param = { roundNo=self.roundNo }
        if self.fromOther == nil then
            RequestPDKRoomResult.new():getResultRound_Detail(param, function(...) self:resDataResultRound_Detail(...) end )
        else
            param = { roundNo=self.roundNo, targetToken=self.targetToken }
            RequestPDKRoomResult.new():getOtherResultRound_Detail(param, function(...) self:resDataResultRound_Detail(...) end )
        end
    else
        -- 游戏回合结束
        self.closeBtn:hide()
        self:setViewData()
    end
end

function PDKOverRoundDialog:resDataResultRound_Detail(jsonObj)

    if self.loadingPop_window~=nil and (not tolua.isnull(self.loadingPop_window)) then
        self.loadingPop_window:removeFromParent()
        self.loadingPop_window = nil
    end

    if jsonObj ~= nil then
        local status = jsonObj[ParseBase.status]
        local msg = RequestBase:getStrDecode(jsonObj[ParseBase.msg])
        Commons:printLog_Info("状态是：", status, "内容是：", msg)

        if status ~= nil and status==CEnum.status.success  then
            local _data = jsonObj[ParseBase.data]
            if _data~=nil then
                local roundRecord = _data[Room.Bean.roundRecord]
                -- dump(roundRecord)
                if CEnum.Environment.Current ~= nil and CEnum.Environment.Current == CEnum.EnvirType.Http then -- 正式环境
                    roundRecord = RequestBase:getStrDecode(roundRecord)
                    roundRecord = ParseBase:parseToJsonObj(roundRecord)
                end

                if roundRecord ~= nil then
                    self.roundResult = roundRecord[Room.Bean.roundRecord]
                    -- viewData
                    self:setViewData()
                else
                    CDAlert.new():popDialogBox(self.pop_window, Strings.gameing.noData_roundDetailRoom)
                    --self:myCancel()
                end
            else
                CDAlert.new():popDialogBox(self.pop_window, Strings.gameing.noData_roundDetailRoom)
                --self:myCancel()
            end
        else
            CDAlert.new():popDialogBox(self.pop_window, Strings.gameing.noData_roundDetailRoom)
            --self:myCancel()
        end
    else
        CDAlert.new():popDialogBox(self.pop_window, Strings.gameing.noData_roundDetailRoom)
        --self:myCancel()
    end
end

function PDKOverRoundDialog:getPDKGameMirror(jsonObj)
    local status = jsonObj[ParseBase.status]
    local msg = RequestBase:getStrDecode(jsonObj[ParseBase.msg])
    Commons:printLog_Info("状态是：", status, "内容是：", msg)

    if status ~= nil and status==CEnum.status.success then
        local data = jsonObj[ParseBase.data]
        -- 文件方式
        if data ~= nil and data[Result.Bean.playbacksUrl] ~= nil then
            local playbacksUrl = RequestBase:getStrDecode( data[Result.Bean.playbacksUrl] )
            NetMirrorDataUtil:downLoad(function(...) self:downFinish_MirrorData(...) end, playbacksUrl)
        else
            if self.loadingPop_window_result~=nil and (not tolua.isnull(self.loadingPop_window_result)) then
                self.loadingPop_window_result:removeFromParent()
                self.loadingPop_window_result = nil
            end
            CDAlert.new():popDialogBox(self.pop_window, Strings.gameing.noData_info)
        end
        --]]
    else
        if self.loadingPop_window_result~=nil and (not tolua.isnull(self.loadingPop_window_result)) then
            self.loadingPop_window_result:removeFromParent()
            self.loadingPop_window_result = nil
        end
        CDAlert.new():popDialogBox(self.pop_window, msg)
    end
end

function PDKOverRoundDialog:downFinish_MirrorData(status, fileNameShort, RemoteUrl)

    if self.loadingPop_window_result~=nil and (not tolua.isnull(self.loadingPop_window_result)) then
        self.loadingPop_window_result:removeFromParent()
        self.loadingPop_window_result = nil
    end

    if status ~= nil and status == CEnum.status.success then
        if Commons:checkIsNull_str(fileNameShort) then
            --GameingMirrorDialog:popDialogBox(self.pop_window, fileNameShort, self.startTime)
            PDKPlaybackNode.new(fileNameShort,self.startTime):addTo(self.pop_window, CEnum.ZOrder.common_dialog)
        else
            CDAlert.new():popDialogBox(self.pop_window, Strings.gameing.noData_info)
        end
    else
        CDAlert.new():popDialogBox(self.pop_window, Strings.gameing.noData_info)
    end
end

function PDKOverRoundDialog:setViewData()

    if self.roundResult then
        -- 胜利还是失败的title变换
        for i=1,#self.roundResult do
           local tempData = self.roundResult[i]
           if tempData.me == true then
                if tempData.roundResult == true then
                    --赢了
                    self.win_title:show()
                    if self.fromView~=nil then -- 来自战绩页面
                    else
                        VoiceDealUtil:playSound_other(PDKVoices.file.over_win)
                    end
                else
                    --输了
                    self.lose_title:show()
                    if self.fromView~=nil then -- 来自战绩页面
                    else
                        VoiceDealUtil:playSound_other(PDKVoices.file.over_fail)
                    end
                end
           end
        end

        self.moveX_item = 0
        -- if CVar._static.isIphone4 then
        --     self.moveX_item = -0
        -- elseif CVar._static.isIpad then
        --     self.moveX_item = -0
        -- elseif CVar._static.NavBarH_Android ~= CEnum.status.NavBarH_def then
        --     self.moveX_item = -0 -- -CVar._static.NavBarH_Android
        -- end

        if self.roundResult[1] then
            -- self:createItem(self.roundResult[1]):addTo(self.bg_):pos(656/2 +self.moveX_item,250+25)
            self:createItem(self.roundResult[1]):addTo(self.bg_):pos(self.alert_gaping_w +self.moveX_item,250-25)
        end
        if self.roundResult[2] then
            -- self:createItem(self.roundResult[2]):addTo(self.bg_):pos(656/2 +self.moveX_item,190)
            self:createItem(self.roundResult[2]):addTo(self.bg_):pos(self.alert_gaping_w +self.moveX_item,190-25)
        end
        if self.roundResult[3] then
            -- self:createItem(self.roundResult[3]):addTo(self.bg_):pos(656/2 +self.moveX_item,130-25) 
            self:createItem(self.roundResult[3]):addTo(self.bg_):pos(self.alert_gaping_w +self.moveX_item,130-25) 
        end
    end

    -- 按钮状态显示
    if self.gameOverData_ ~= nil then
        self.GameContinue:hide()
        self.GameOver:show()
    else
        if tag_isSubmit == gameOver then
            self.GameContinue:show()
            self.GameOver:hide()
        end
    end 

end

function PDKOverRoundDialog:createItem(data)
	local node = display.newNode()
    if data == nil then return node end

	local bg = -- display.newSprite(PDKImgs.talbeOver_item_bg)
        cc.ui.UIImage.new(PDKImgs.talbeOver_item_bg,{scale9=false})
            :setContentSize(osWidth, 45)
            --:align(display.CENTER_BOTTOM, display.cx, self.alert_gaping_h -40)
            :addTo(node)

    local font_color = cc.c3b(0x7b, 0x66,0x57)-- Colors.white
	--名字
	cc.ui.UILabel.new({text = RequestBase:getStrDecode(data.user.nickname),  font = Fonts.Font_hkyt_w7,
            size = Dimens.TextSize_25,
            color = font_color,
            font = Fonts.Font_hkyt_w9,
            align = cc.ui.TEXT_VALIGN_CENTER,
            dimensions = cc.size(180,30)
            })
    	:addTo(bg)
    	:pos(25, 20)

	--剩牌
	cc.ui.UILabel.new({text = ""..data.leftCardCount,  font = Fonts.Font_hkyt_w7,
            size = Dimens.TextSize_30,
            color = font_color,
            font = Fonts.Font_hkyt_w9,
            align = cc.ui.TEXT_ALIGN_RIGHT,
            dimensions = cc.size(30,30)
            })
    	:addTo(bg)
    	:pos(250, 20)

	--炸弹
	cc.ui.UILabel.new({text = ''..data.roundBombNum,  font = Fonts.Font_hkyt_w7,
            size = Dimens.TextSize_30,
            color = font_color,
            font = Fonts.Font_hkyt_w9,
            align = cc.ui.TEXT_ALIGN_RIGHT,
            dimensions = cc.size(30,30)
            })
    	:addTo(bg)
    	:pos(350+30, 20)

	--积分
	cc.ui.UILabel.new({text = ""..data.roundScore,  font = Fonts.Font_hkyt_w7,
            size = Dimens.TextSize_30,
            color = font_color,
            font = Fonts.Font_hkyt_w9,
            align = cc.ui.TEXT_ALIGN_RIGHT,
            dimensions = cc.size(30,30)
            })
    	:addTo(bg)
    	:pos(480+45, 20)

    if data.bird == true then
    	--扎鸟
    	display.newSprite(PDKImgs.talbeOver_zhaniao_title)
        	:addTo(bg)
        	:pos(70, 20)
    end

    if data.spring ==true then
    	--春天
    	display.newSprite(PDKImgs.talbeOver_spring_title)
        	:addTo(bg)
        	:pos(150,20)
    end

	return node 
end

return PDKOverRoundDialog