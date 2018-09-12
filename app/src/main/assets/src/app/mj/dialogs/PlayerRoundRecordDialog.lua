--
-- Author: luobinbin
-- Date: 2017-07-17 12:40:33
-- 创建房间

-- 类申明
local PlayerRoundRecordDialog = class("PlayerRoundRecordDialog",
	function()
		return display.newNode()
	end
)

local osWidth = Commons.osWidth
local osHeight = Commons.osHeight

function PlayerRoundRecordDialog:ctor()
    --手牌缩放系数
    self.scaleFact = 1
    self.head_mov_x = 0
    self.score_mov_x = 0
    self.card_mov_y = 0
    self.reward_mov_x = 0

    if CVar._static.isIphone4 then
        self.scaleFact = 0.85
        self.head_mov_x = 25
        self.score_mov_x = 210
        self.card_mov_y = 10
        self.reward_mov_x = 80
    elseif CVar._static.isIpad then
        self.scaleFact = 0.78
        self.head_mov_x = 40
        self.score_mov_x = 288
        self.card_mov_y = 10
        self.reward_mov_x = 105
    elseif CVar._static.NavBarH_Android ~= CEnum.status.NavBarH_def then
        self.scaleFact = 0.92
    end
end

-- 创建一个模态弹出框,  parent=要加在哪个上面
-- function PlayerRoundRecordDialog:popDialogBox(_res_data, _roomNo, _roundNo, _rounds, _PlayeRoundNo, _fromView)
function PlayerRoundRecordDialog:popDialogBox(_res_data, _startTime, _roomNo, _roundNo, _rounds, _PlayeRoundNo, _fromView, _fromOther, _targetToken)
    self.startTime = _startTime
    self.roomNo = _roomNo
    self.playRound = _PlayeRoundNo
    self.roundNo = _roundNo
    self.rounds = _rounds
    self.fromView = _fromView
    self.fromOther = _fromOther
    self.targetToken = _targetToken

    self.pop_window = display.newColorLayer(cc.c4b(0, 0, 0, 200))  -- 半透明的黑色

    self.pop_window:setContentSize(osWidth, osHeight)             -- 设置Layer的大小,全屏出现
    self.pop_window:setTouchEnabled(true)
    self.pop_window:setTouchSwallowEnabled(true)  -- 吞噬下层的响应
    self.pop_window:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event) -- 点击此Layer时候输出信息,然后把自己销毁

        return true
    end)
    self:addChild(self.pop_window, CEnum.ZOrder.common_dialog) -- 把Layer添加到父对象上

    -- 整个底色背景
    self.content_ = cc.ui.UIImage.new(ImgsM.overBg,{scale9 = true})
        :addTo(self.pop_window)
        :align(display.CENTER, display.cx, display.cy)
        :setLayoutSize(osWidth, osHeight-110*2)

    -- 显示桌面
    self.changeToDeskTopBtn = cc.ui.UIPushButton.new(
            Imgs.over_round_btn_changeto_desktop,{scale9=false})
            :setButtonSize(242, 85)
            :setButtonImage(EnStatus.pressed, Imgs.over_round_btn_changeto_desktop)
            :onButtonClicked(function(e)
                self.changeToResultBtn:show()
                self.changeToDeskTopBtn:hide()
                self.pop_window:hide()
            end)
            :align(display.LEFT_BOTTOM, 20, 16)
            :addTo(self:getParent(), CEnum.ZOrder.common_dialog)
            :setName("changeToDeskTopBtn")
            :setScale(self.scaleFact)
    -- 显示战绩
    self.changeToResultBtn = cc.ui.UIPushButton.new(
            Imgs.over_round_btn_changeto_result,{scale9=false})
            :setButtonSize(242, 85)
            :setButtonImage(EnStatus.pressed, Imgs.over_round_btn_changeto_result)
            :onButtonClicked(function(e)
                self.changeToResultBtn:hide()
                self.changeToDeskTopBtn:show()
                self.pop_window:show()
            end)
            :align(display.LEFT_BOTTOM, 20, 16)
            :addTo(self:getParent(), CEnum.ZOrder.common_dialog)
            :setName("changeToResultBtn")
            :setScale(self.scaleFact)
            :hide()

    self.maPaiLabel = display.newTTFLabel({
                text = "码牌",
                size = Dimens.TextSize_25,
                color = Colors:_16ToRGB(Colors.white),
                font = Fonts.Font_hkyt_w7,
                align = cc.ui.TEXT_ALIGN_LEFT,
                valign = cc.ui.TEXT_VALIGN_CENTER,
                })
                :addTo(self.pop_window)
                :align(display.LEFT_BOTTOM, 320-self.reward_mov_x, 43)

    self.roomNoLabel = display.newTTFLabel({
            text = "房号：",
            size = Dimens.TextSize_25,
            color = Colors:_16ToRGB(Colors.white),
            font = Fonts.Font_hkyt_w7,
            align = cc.ui.TEXT_ALIGN_LEFT,
            valign = cc.ui.TEXT_VALIGN_CENTER,
            })
            :addTo(self.pop_window)
            -- :align(display.LEFT_BOTTOM, 20, 660)
            :align(display.LEFT_TOP, 20, osHeight-50)
    if Commons:checkIsNull_str(self.roomNo) then
        self.roomNoLabel:setString("房号："..self.roomNo)
    end

   self.roundsLabel = display.newTTFLabel({
            text = "局数：",
            size = Dimens.TextSize_25,
            color = Colors:_16ToRGB(Colors.white),
            font = Fonts.Font_hkyt_w7,
            align = cc.ui.TEXT_ALIGN_LEFT,
            valign = cc.ui.TEXT_VALIGN_CENTER,
            })
            :addTo(self.pop_window)
            -- :align(display.LEFT_BOTTOM, 20, 628)
            :align(display.LEFT_TOP, 20, osHeight-80)
    if Commons:checkIsNull_numberType(self.playRound) then
            self.roundsLabel:setString("局："..self.playRound.."/"..self.rounds)
    end

    if _res_data ~= nil then
         -- 来自游戏页面
        self.res_data = _res_data
        self:initLayer(_res_data)
    else
        -- 来自战绩界面
        self.changeToDeskTopBtn:hide()
        self.changeToResultBtn:hide()

        -- print("=======================", display.left, display.right, display.top, display.bottom)
        -- 关闭
        self.closeBtn = cc.ui.UIPushButton.new(Imgs.dialog_exit,{scale9=false})
            :setButtonImage(EnStatus.pressed, Imgs.dialog_exit_press)
            :onButtonClicked(function(e)
                VoiceDealUtil:playSound_other(Voices.file.ui_click)
                if self.changeToDeskTopBtn ~= nil and (not tolua.isnull(self.changeToDeskTopBtn)) then
                    self.changeToDeskTopBtn:removeFromParent()
                    self.changeToDeskTopBtn = nil
                end
                
                if self.changeToResultBtn ~= nil and (not tolua.isnull(self.changeToResultBtn)) then
                    self.changeToResultBtn:removeFromParent()
                    self.changeToResultBtn = nil
                end
                
                if self ~= nil and (not tolua.isnull(self)) then
                    self:removeFromParent()
                end
                
                --self.parent:removeChild(self.pop_window)
                --self.changeToResultBtn:hide()
                --self.changeToDeskTopBtn:hide()
                --self.parent:removeChild(self.changeToDeskTopBtn)
                --self.parent:removeChild(self.changeToResultBtn)
            end)
            :addTo(self.pop_window)
            :align(display.RIGHT_TOP, display.right-50 -CVar._static.NavBarH_Android, display.top-50)

        -- 来自战绩界面，需要先请求数据
        self.loadingPop_window = CDAlertLoading.new():popDialogBox(self.pop_window, Strings.hint_Loading)
        local param = { roundNo=self.roundNo }
        if self.fromOther == nil then
            -- 本人的
            RequestMJRoomResult:getResultRound_Detail(param, function(...) self:resDataResultRound_Detail(...) end)
        else
            param = { roundNo=self.roundNo, targetToken=self.targetToken }
            RequestMJRoomResult:getOtherResultRound_Detail(param, function(...) self:resDataResultRound_Detail(...) end)
        end
    end

end

function PlayerRoundRecordDialog:resDataResultRound_Detail(jsonObj)
    if self.loadingPop_window~=nil and (not tolua.isnull(self.loadingPop_window)) then
        self.loadingPop_window:removeFromParent()
        self.loadingPop_window = nil
    end

    if jsonObj ~= nil then
        local status = jsonObj[ParseBase.status]
        local msg = RequestBase:getStrDecode(jsonObj[ParseBase.msg])
        Commons:printLog_Info("状态是：", status, "内容是：", msg)

        if status ~= nil and status==CEnum.status.success  then
            local _data = jsonObj[ParseBase.data];
            if _data~=nil then
                local roundRecord = _data[Room.Bean.roundRecord]
                if CEnum.Environment.Current ~= nil and CEnum.Environment.Current == CEnum.EnvirType.Http then -- 正式环境
                    roundRecord = RequestBase:getStrDecode(roundRecord)
                    roundRecord = ParseBase:parseToJsonObj(roundRecord)
                end
                if roundRecord ~= nil then
                    self.res_data = roundRecord
                    self:initLayer(self.res_data)
                else
                    CDAlert.new():popDialogBox(self, Strings.gameing.noData_roundDetailRoom)
                    self:myCancel()
                end
            else
                CDAlert.new():popDialogBox(self, Strings.gameing.noData_roundDetailRoom)
                self:myCancel()
            end
        else
            CDAlert.new():popDialogBox(self, Strings.gameing.noData_roundDetailRoom)
            self:myCancel()
        end
    else
        CDAlert.new():popDialogBox(self, Strings.gameing.noData_roundDetailRoom)
        self:myCancel()
    end
end

function PlayerRoundRecordDialog:myCancel()
    VoiceDealUtil:playSound_other(Voices.file.ui_click)
    if self.changeToDeskTopBtn ~= nil and (not tolua.isnull(self.changeToDeskTopBtn)) then
        self.changeToDeskTopBtn:removeFromParent()
        self.changeToDeskTopBtn = nil
    end
    
    if self.changeToResultBtn ~= nil and (not tolua.isnull(self.changeToResultBtn)) then
        self.changeToResultBtn:removeFromParent()
        self.changeToResultBtn = nil
    end
    
    if self ~= nil and (not tolua.isnull(self)) then
        self:removeFromParent()
    end

    -- self.changeToDeskTopBtn:removeFromParent()
    -- self.changeToResultBtn:removeFromParent()
    -- self:removeFromParent()
end

function PlayerRoundRecordDialog:resData_GameingMirror(jsonObj)
    local status = jsonObj[ParseBase.status]
    local msg = RequestBase:getStrDecode(jsonObj[ParseBase.msg])
    Commons:printLog_Info("状态是：", status, "内容是：", msg)

    if status ~= nil and status==CEnum.status.success then
        local data = jsonObj[ParseBase.data]

        --if not CEnumUpd.Environment.playBackGame then
            --[[
            -- 直接读取json字符串数据方式
            if self.loadingPop_window~=nil and (not tolua.isnull(self.loadingPop_window)) then
                self.loadingPop_window:removeFromParent()
                self.loadingPop_window = nil
            end
            if data ~= nil and data[Result.Bean.playbacks] ~= nil then
                local gameingMirror = RequestBase:getStrDecode( data[Result.Bean.playbacks] )
                --数据量太多打印会崩溃，这里就不能输出 print("---------gameingMirror 是：", gameingMirror)
                --print("---------gameingMirror 是：", type(gameingMirror))
                if gameingMirror ~= nil then -- 这里还是字符串
                    GameingMirrorDialog:popDialogBox(self.pop_window, gameingMirror, self.startTime)
                end
            else
                CDAlert.new():popDialogBox(self.pop_window, Strings.gameing.noData_info)
            end
            --]]
        --else
            ---[[
            -- 下载文件再读取本地文件方式
            if data ~= nil and data[Result.Bean.playbacksUrl] ~= nil then
                local playbacksUrl = RequestBase:getStrDecode( data[Result.Bean.playbacksUrl] )
                print("===============playbacksUrl====", playbacksUrl)
                NetMirrorDataUtil:downLoad(function(...) self:getMirrorData(...) end, playbacksUrl)
            else
                if self.loadingPop_window~=nil and (not tolua.isnull(self.loadingPop_window)) then
                    self.loadingPop_window:removeFromParent()
                    self.loadingPop_window = nil
                end
                CDAlert.new():popDialogBox(self.pop_window, Strings.gameing.noData_info)
            end
            --]]
        --end
    else
        if self.loadingPop_window~=nil and (not tolua.isnull(self.loadingPop_window)) then
            self.loadingPop_window:removeFromParent()
            self.loadingPop_window = nil
        end
        CDAlert.new():popDialogBox(self.pop_window, msg)
    end
end

function PlayerRoundRecordDialog:getMirrorData(status, fileNameShort, RemoteUrl)
    if self.loadingPop_window~=nil and (not tolua.isnull(self.loadingPop_window)) then
        self.loadingPop_window:removeFromParent()
        self.loadingPop_window = nil
    end

    -- print("+++++++++++++++++++++++++++++++++ status:", status)
    if status ~= nil and status == CEnum.status.success then
        --[[
        local file = io.open(fileNameShort,"r")
        if file then
            -- print("+++++++++++++++++++++++++++++++++ file:lines:", file:lines())
            --for line in file:lines() do
                local gameingMirror = file:read("*a")
                if gameingMirror ~= nil then -- 这里还是字符串
                    GameingMirrorDialog:popDialogBox(self.pop_window, gameingMirror, self.startTime)
                end
            --end
        else
            CDAlert.new():popDialogBox(self.pop_window, Strings.gameing.noData_info)
        end
        --]]

        if Commons:checkIsNull_str(fileNameShort) then
            MirrorMJRoomDialog:popDialogBox(self, fileNameShort, self.startTime)
        else
            CDAlert.new():popDialogBox(self.pop_window, Strings.gameing.noData_info)
        end
    else
        -- CDAlert.new():popDialogBox(self.pop_window, Strings.gameing.noData_info)
    end
end


function PlayerRoundRecordDialog:initLayer(res_data)
    if res_data ~= nil then
        local room = res_data--[User.Bean.room]
        local roundRecords = room[Room.Bean.roundRecord]
        local roomRecords = room[Room.Bean.roomRecord]
        
        if self.fromView~=nil and self.fromView==CEnum.pageView.gameingOverPage then
            -- 来自游戏结束
            self.roomNo = room[Room.Bean.roomNo]
            self.playRound = room[Room.Bean.playRound]
            self.rounds = room[Room.Bean.rounds]
        end
        -- 游戏结束有值，就会以游戏结束值为准，，
        if Commons:checkIsNull_str(self.roomNo) then
            self.roomNoLabel:setString("房号："..self.roomNo)
        end
        if Commons:checkIsNull_numberType(self.playRound) then
            self.roundsLabel:setString("局："..self.playRound.."/"..self.rounds)
        end

        local continueStr = ImgsM.continue -- 继续按钮
        local continuePressStr = ImgsM.continue
        if Commons:checkIsNull_tableList(roomRecords) then
            continueStr = ImgsM.gameOverNormal -- 房间结束
            continuePressStr = ImgsM.gameOverPress
        end
        if self.fromView == nil then
            -- 来自战绩页面，就是回放按钮
            continueStr = Imgs.over_round_btn_mirror
            continuePressStr = Imgs.over_round_btn_mirror_press
        end

        local continueBtn = cc.ui.UIPushButton.new(
            continueStr,{scale9=false})
            -- :setButtonSize(242, 85)
            :setButtonImage(EnStatus.pressed, continuePressStr)
            :onButtonClicked(function(e)

                if self.fromView == nil then
                    -- CDAlert.new():popDialogBox(self.pop_window, "正在进行中...\n")
                    -- 来自战绩页面，就是回放按钮
                    self.loadingPop_window = CDAlertLoading.new():popDialogBox(self.pop_window, Strings.hint_Loading)
                    local param = { roomNo=self.roomNo, roundNo=self.roundNo }
                    if self.fromOther==nil then
                        -- 本人的
                        RequestMJRoomResult:getGameingMirror(param, function(...) self:resData_GameingMirror(...) end)
                    else
                        param = { roomNo=self.roomNo, roundNo=self.roundNo, targetToken=self.targetToken }
                        RequestMJRoomResult:getOtherGameingMirror(param, function(...) self:resData_GameingMirror(...) end)
                    end

                else
                    -- 来自游戏结束
                    if Commons:checkIsNull_tableList(roomRecords) then
                        local recordLayer = PlayerRoomRecordDialog.new()
                                                :addTo(self:getParent(), CEnum.ZOrder.common_dialog)
                                                :setName("PlayerRoomRecordDialog")
                        recordLayer:initLayer(res_data)
                    end

                    self:getParent():getParent().playerHeardViewList[CEnumM.seatNo.me].btnPrepare:show()
                    self:getParent():getParent().playerHeardViewList[CEnumM.seatNo.me].btnPrepare:setButtonEnabled(true)

                    CVar._static.isNeedShowPrepareBtn = true

                    if self.changeToDeskTopBtn ~= nil and (not tolua.isnull(self.changeToDeskTopBtn)) then
                        self.changeToDeskTopBtn:removeFromParent()
                        self.changeToDeskTopBtn = nil
                    end
                    
                    if self.changeToResultBtn ~= nil and (not tolua.isnull(self.changeToResultBtn)) then
                        self.changeToResultBtn:removeFromParent()
                        self.changeToResultBtn = nil
                    end
                    
                    if self ~= nil and (not tolua.isnull(self)) then
                        self:removeFromParent()
                    end

                    -- self.changeToDeskTopBtn:removeFromParent()
                    -- self.changeToResultBtn:removeFromParent()
                    -- self:removeFromParent()
                    --self.parent:removeChild(self.pop_window)
                    --self.changeToResultBtn:hide()
                    --self.changeToDeskTopBtn:hide()
                    --self.parent:removeChild(self.changeToDeskTopBtn)
                    --self.parent:removeChild(self.changeToResultBtn)
                end

            end)
            :align(display.RIGHT_BOTTOM, display.right - 50*self.scaleFact, 16)
            :addTo(self.pop_window, 21)
            :setScale(self.scaleFact)

        --输赢图标
        local successImage = cc.ui.UIImage.new(ImgsM.fail,{scale9 = false})
                :addTo(self.pop_window, 10)
                :align(display.CENTER_BOTTOM, display.cx, display.top-122)

        local isFlagHu = false
        local isMeHu = false

        local rewardCardsListVeiw = cc.ui.UIListView.new({
                            bgScale9 = true,
                            capInsets = cc.rect(0, 0, 55*15, 86),
                            viewRect = cc.rect(0, 0, 55*15, 86),
                            direction = cc.ui.UIScrollView.DIRECTION_HORIZONTAL, -- 水平摆放
                            alignment = cc.ui.UIListView.ALIGNMENT_VCENTER
                        })
                        :addTo(self.pop_window, 20)
                        :align(display.LEFT_BOTTOM, 380-self.reward_mov_x  , 15)
                        :setScale(self.scaleFact)

        local rewardCards = room[Room.Bean.rewardCards]
        if rewardCards ~= nil and type(rewardCards)=="table" then
            for i=1,#rewardCards do
                local cardObj = rewardCards[i]
                local item = rewardCardsListVeiw:newItem()
                    item:setItemSize(55, 86)
                    local cardBg = display.newSprite(ImgsM.peng_shang)
                    local contentSpriteSize = cardBg:getContentSize()
                    if cardObj.showType == CEnumM.showType.y then
                        display.newSprite(ImgsM.zhongMaBg)
                            :addTo(cardBg)
                            :align(display.CENTER, contentSpriteSize.width * 0.5, contentSpriteSize.height * 0.5+10)
                    end

                    local innerSprite = display.newSprite("#"..tostring(cardObj.id)..".png")
                            :addTo(cardBg)
                            :align(display.CENTER, contentSpriteSize.width * 0.5, contentSpriteSize.height * 0.5)
                            :setScale(0.65)
                    item:addContent(cardBg)
                    rewardCardsListVeiw:addItem(item)
                rewardCardsListVeiw:reload()
            end
        end

        if Commons:checkIsNull_tableList(rewardCards) then
            self.maPaiLabel:show()
        else
            self.maPaiLabel:hide()
        end
        
        if roundRecords ~= nil and type(roundRecords)=="table" then
            for i=1,#roundRecords do
                local roundObj = roundRecords[i]
                local userInfo = roundObj[RoundRecord.Bean.user]
                local score =  roundObj[RoundRecord.Bean.score]
                local isMe = roundObj[RoundRecord.Bean.me]
                local isHu = roundObj[RoundRecord.Bean.hu]
                local mts = roundObj[RoundRecord.Bean.mts]
                local huCard = roundObj[RoundRecord.Bean.huCard]
                local cardCombs = roundObj[RoundRecord.Bean.cardCombs]
                
                local mtsStr = ""
                if Commons:checkIsNull_tableList(mts) then
                    for t=1,#mts do
                        mtsStr = mtsStr..mts[t].." "
                    end
                end

                local contentHeight = self.content_:getContentSize().height
                -- 头像框
                local heardBoder = cc.ui.UIPushButton.new(ImgsM.heard_border,{scale9=false})
                    :align(display.LEFT_BOTTOM, 74-self.head_mov_x, contentHeight-117 - (i-1) * 122)
                    :addTo(self.content_, 20)

                if userInfo.icon ~= nil then
                    heardBoder:onButtonClicked(
                        function(e)
                        end
                    )
                end
                    
                if userInfo.icon ~= nil and userInfo.icon ~= "" then
                    local heardIcon = NetSpriteImg.new(RequestBase:new():getStrDecode(userInfo.icon), 76, 80)
                        :align(display.LEFT_BOTTOM, 81-self.head_mov_x, contentHeight-110- (i-1) * 122)
                        :addTo(self.content_, 20)
                end
                
                -- 昵称
                local nickNameLabel = display.newTTFLabel({
                        text = Commons:trim(RequestBase:getStrDecode(userInfo.nickname)),
                        font = Fonts.Font_hkyt_w7,
                        size = Dimens.TextSize_22,
                        color = display.COLOR_WHITE,
                        align = cc.ui.TEXT_ALIGN_LEFT,
                        valign = cc.ui.TEXT_VALIGN_CENTER,
                        dimensions = cc.size(120,25)
                    })
                    :addTo(self.content_, 20)
                    :align(display.LEFT_BOTTOM, 203*self.scaleFact, contentHeight-33- (i-1) * 122)
                    :setScale(self.scaleFact)

                --mts
                local mtsLabel = display.newTTFLabel({
                        text = mtsStr,
                        font = Fonts.Font_hkyt_w7,
                        size = Dimens.TextSize_22,
                        color = display.COLOR_WHITE,
                        align = cc.ui.TEXT_ALIGN_LEFT,
                        valign = cc.ui.TEXT_VALIGN_CENTER,
                        --dimensions = cc.size(120,25)
                    })
                    :addTo(self.content_)
                    :align(display.LEFT_BOTTOM, 386*self.scaleFact, contentHeight-33- (i-1) * 122)
                    :setScale(self.scaleFact)

                local scoreStr = tostring(score)
                if score > 0 then
                    scoreStr = "+"..scoreStr
                end

                local scoreLabel = display.newTTFLabel({
                        text = scoreStr,
                        font = Fonts.Font_hkyt_w7,
                        size = Dimens.TextSize_40,
                        color = display.COLOR_WHITE,
                        align = cc.ui.TEXT_ALIGN_LEFT,
                        valign = cc.ui.TEXT_VALIGN_BOTTOM,
                        --dimensions = cc.size(120,25)
                    })
                    :addTo(self.content_)
                    :align(display.LEFT_BOTTOM, 1038-self.score_mov_x, contentHeight-115-(i-1) * 122)
                    :setScale(self.scaleFact)

                if isHu then
                    local huBg = cc.ui.UIImage.new(ImgsM.huBorder,{scale9 = true})
                        :addTo(self.content_, 10)
                        :align(display.LEFT_BOTTOM, 20, contentHeight-131- (i-1) * 122)
                        :setLayoutSize(1238*self.scaleFact, 125)

                    local huBgSprite = cc.ui.UIImage.new(ImgsM.recordHu,{scale9 = false})
                        :addTo(self.content_, 20)
                        :align(display.RIGHT_BOTTOM, display.right-40*self.scaleFact, contentHeight-124-(i-1) * 122)
                        :setScale(self.scaleFact)

                    if isMe then
                        successImage:removeFromParent()
                        successImage = cc.ui.UIImage.new(ImgsM.success,{scale9 = false})
                            :addTo(self.pop_window, 10)
                            :align(display.CENTER_BOTTOM, display.cx, display.top-122)

                        isMeHu = true
                    end
                    isFlagHu = true
                end

                local totalOffsetDis = 0
                for j=1,#cardCombs do
                    local cardCombsListVeiw = cc.ui.UIListView.new({
                            bgScale9 = true,
                            capInsets = cc.rect(0, 0, 55*20, 100),
                            viewRect = cc.rect(0, 0, 55*20, 100),
                            direction = cc.ui.UIScrollView.DIRECTION_HORIZONTAL, -- 水平摆放
                            alignment = cc.ui.UIListView.ALIGNMENT_VCENTER
                        })
                        :addTo(self.content_, 20)
                        :align(display.LEFT_BOTTOM, 188*self.scaleFact + totalOffsetDis 
                            , contentHeight-136- (i-1) * 122+self.card_mov_y)
                        :setScale(self.scaleFact)

                    local isGang = false
                    if cardCombs[j].option ~= nil and cardCombs[j].option == CEnum.playOptions.gang then
                        isGang = true
                    end

                    local cardCombCardList = cardCombs[j].cards
                    for m=1,#cardCombCardList do
                        local item = cardCombsListVeiw:newItem()
                        item:setItemSize(55, 100)
                        local cardStr = ImgsM.peng_shang
                        if cardCombCardList[m].showType == CEnumM.showType.g then
                            cardStr = ImgsM.peng_gai
                        end
                        local cardBg = display.newSprite(cardStr)

                        local contentSpriteSize = cardBg:getContentSize()
                        local innerSprite = display.newSprite("#"..tostring(cardCombCardList[m].id)..".png")
                                :addTo(cardBg)
                                :align(display.CENTER, contentSpriteSize.width * 0.5, contentSpriteSize.height * 0.5+10)
                                :setScale(0.65)
                        if cardCombCardList[m].showType == CEnumM.showType.g then
                            innerSprite:hide()
                        end

                        if cardCombCardList[m].isLaiZi == CEnumM.isLaiZi.y then
                            display.newSprite(ImgsM.laizi)
                                :addTo(cardBg)
                                :align(display.LEFT_TOP, 0, contentSpriteSize.height)
                        end

                        if isGang then
                            if m ~= 4 then
                                item:addContent(cardBg)
                                cardCombsListVeiw:addItem(item)
                                totalOffsetDis = totalOffsetDis + 55*self.scaleFact
                            else
                                cardBg:align(display.LEFT_BOTTOM, 0, 10)
                                cardCombsListVeiw.items_[2]:getContent():addChild(cardBg)
                            end
                        else
                            item:addContent(cardBg)
                            cardCombsListVeiw:addItem(item)
                            totalOffsetDis = totalOffsetDis + 55*self.scaleFact
                        end

                    end 
                    totalOffsetDis = totalOffsetDis + 10

                    cardCombsListVeiw:reload()
                end

                if isHu then
                    if huCard ~= nil then
                        local cardBg = display.newSprite(ImgsM.peng_shang)
                            :addTo(self.content_, 21)
                            :align(display.LEFT_BOTTOM, 188*self.scaleFact + totalOffsetDis , contentHeight-126- (i-1) * 122+self.card_mov_y)
                            :setScale(self.scaleFact)
                        local contentSpriteSize = cardBg:getContentSize()
                        local innerSprite = display.newSprite("#"..tostring(huCard.id)..".png")
                                :addTo(cardBg)
                                :align(display.CENTER, contentSpriteSize.width * 0.5, contentSpriteSize.height * 0.5)
                                :setScale(0.65)

                        cc.ui.UIImage.new(ImgsM.recordHu,{scale9 = false})
                            :addTo(cardBg, 20)
                            :align(display.RIGHT_TOP, contentSpriteSize.width+6, contentSpriteSize.height+6)
                            :setScale(0.3)
                    end
                end
            end

            if isFlagHu == false then
                successImage = cc.ui.UIImage.new(ImgsM.huangJu,{scale9 = false})
                            :addTo(self.pop_window, 10)
                            :align(display.CENTER_BOTTOM, display.cx, display.top-122)
                -- 荒局也要播放声音            
                if self.fromView~=nil and self.fromView==CEnum.pageView.gameingOverPage then
                    VoiceDealUtil:playSound_other(VoicesM.file.over_liuju)
                end
            else
                if self.fromView~=nil and self.fromView==CEnum.pageView.gameingOverPage then
                    -- 游戏结束才播放声音
                    if isMeHu then
                        VoiceDealUtil:playSound_other(VoicesM.file.over_win)
                    else
                        VoiceDealUtil:playSound_other(VoicesM.file.over_fail)
                    end
                end
            end
            
        end  
    end
end

function PlayerRoundRecordDialog:onExit()
    if self.changeToDeskTopBtn ~= nil and (not tolua.isnull(self.changeToDeskTopBtn)) then
        self.changeToDeskTopBtn:removeFromParent()
        self.changeToDeskTopBtn = nil
    end
    
    if self.changeToResultBtn ~= nil and (not tolua.isnull(self.changeToResultBtn)) then
        self.changeToResultBtn:removeFromParent()
        self.changeToResultBtn = nil
    end
    
    if self ~= nil and (not tolua.isnull(self)) then
        self:removeFromParent()
    end

    -- self.changeToDeskTopBtn:removeFromParent()
    -- self.changeToResultBtn:removeFromParent()
    -- self:removeFromParent()
end

return PlayerRoundRecordDialog