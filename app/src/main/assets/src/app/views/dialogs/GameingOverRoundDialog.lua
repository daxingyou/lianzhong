--
-- Author: lte
-- Date: 2016-11-05 18:41:34
-- 回合结果，房间结束，有房间数据

-- 类申明
local GameingOverRoundDialog = class("GameingOverRoundDialog"
    -- ,function()
    --     return display.newNode()
    -- end
    )


local osWidth = Commons.osWidth
local osHeight = Commons.osHeight

local fromView
local myself_view_btn_Prepare

local gameRound = '0' -- 回合结束
local gameOver = '1' -- 房间结束
local gamePlay = '2' -- 回放
local tag_isSubmit = '1'
local tag_isCancel = '1'

local startY

local showSS = '1' -- 显示回合结果界面
local showHide = '0' -- 隐藏回合结果界面
local tag_isShow = '1'

-- 创建一个模态弹出框,  parent=要加在哪个上面
function GameingOverRoundDialog:popDialogBox(_parent, _res_data, _startTime, _roomNo, _roundNo,
    _fromView,
    _myself_view_btn_Prepare,
    _fromOther, _targetToken
)

    self.parent = _parent
    --self.res_data = _res_data
    self.startTime = _startTime
    self.roomNo = _roomNo
    if _roomNo == nil then
        self.roomNo = CVar._static.roomNo
    end
    self.roundNo = _roundNo
    -- print("=============================", _parent, _res_data, _startTime, _roomNo, _roundNo)

    fromView = _fromView

    myself_view_btn_Prepare = _myself_view_btn_Prepare
    self.fromOther = _fromOther
    self.targetToken = ""
    if Commons:checkIsNull_str(_targetToken) then
        self.targetToken = _targetToken
    end

    tag_isSubmit = gameOver
    tag_isCancel = gameOver
    tag_isShow = showSS

    self.pop_window = display.newColorLayer(cc.c4b(0, 0, 0, 200))       -- 半透明的黑色

    self.pop_window:setContentSize(osWidth, osHeight)             -- 设置Layer的大小,全屏出现
    --self.pop_window:align(display.CENTER, display.cx, display.cy) -- Layer的锚点在0.5,0.5 因此对齐的时候要注意
    self.pop_window:setTouchEnabled(true)
    self.pop_window:setTouchSwallowEnabled(true)  -- 吞噬下层的响应
    self.pop_window:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event) -- 点击此Layer时候输出信息,然后把自己销毁
        return true
    end)
    self.parent:addChild(self.pop_window, CEnum.ZOrder.common_dialog) -- 把Layer添加到父对象上

    startY = osHeight-14 -40 -38 -15

    ---[[
    -- 整个底色背景
    local dialogBg = cc.ui.UIImage.new(Imgs.dialog_bg,{})
        :addTo(self.pop_window)
    	:align(display.LEFT_TOP, 14, osHeight-10 -40)
    	:setLayoutSize(osWidth-14*2, osHeight-10*2 -40)
    --]]

    --[[
    -- 内容背景
    cc.ui.UIImage.new(Imgs.dialog_content_bg,{})
        :addTo(self.pop_window)
        :align(display.LEFT_TOP, 14+10, startY)
        :setLayoutSize(osWidth-14*2 -10*2, osHeight-14*2 -40 -38 -120)
    --]]

    -- logo
    --cc.ui.UIImage.new(Imgs.over_round_title_win,{})
    self.view_title_logo = cc.ui.UIPushButton.new(Imgs.over_round_title_win, {scale9 = false})
        :setButtonImage(EnStatus.pressed, Imgs.over_round_title_win)
        :setButtonImage(EnStatus.disabled, Imgs.over_round_title_invalid)
    	:addTo(self.pop_window)
    	--:center()
    	--:pos(display.cx, osHeight-80-56/2)
    	:align(display.CENTER, display.cx, osHeight-10 -60/2)
        --:setButtonEnabled(false)

    ---[[
    -- 关闭
    self.view_btn_back = cc.ui.UIPushButton.new(
        -- Imgs.dialog_back,{scale9=false})
        Imgs.dialog_exit,{scale9=false})
        -- :setButtonSize(74, 74)
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
        -- :setButtonImage(EnStatus.pressed, Imgs.dialog_back)
        :setButtonImage(EnStatus.pressed, Imgs.dialog_exit_press)
        :onButtonClicked(function(e)

            self:myCancel()

        end)
    	:addTo(self.pop_window)
        -- :align(display.CENTER, 14+74/2, osHeight-10 -74/2)
        :align(display.CENTER, osWidth -14-74/2, osHeight-10 -74/2)
        :setTouchSwallowEnabled(true)
    --]]

    ---[[
    -- 确定按钮
    self.view_btn_submit = cc.ui.UIPushButton.new(
        Imgs.over_round_btn_next,{scale9=false})
        :setButtonSize(278, 94)
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
        :setButtonImage(EnStatus.pressed, Imgs.over_round_btn_next_press)
        :onButtonClicked(function(e)
           self:myConfim()
        end)
        :align(display.CENTER_BOTTOM, display.cx, 10)
        -- :addTo(self.pop_window)
        :addTo(self.parent, CEnum.ZOrder.common_dialog)
        :setVisible(false)
        :setScale(0.9)
    -- if myself_view_btn_Prepare~=nil then
    --     --self.view_btn_submit:addTo(self.pop_window)
    --     self.view_btn_submit:setVisible(true)
    -- end
    --]]

    ---[[
    -- 回合结果和桌面  切换按钮
    self.view_btn_changeto = cc.ui.UIPushButton.new(
        Imgs.over_round_btn_changeto_desktop,{scale9=false})
        -- :setButtonSize(278, 94)
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
        :setButtonImage(EnStatus.pressed, Imgs.over_round_btn_changeto_desktop)
        :onButtonClicked(function(e)
            self:myView_ShowHide()
        end)
        :align(display.LEFT_BOTTOM, 10, 30)
        :addTo(self.parent, CEnum.ZOrder.common_dialog)
        :scale(0.7)
        :setVisible(false)
    --]]


	-- view
 --    self:createView_winOrOwner()
 --    self:createView_R()
 --    self:createView_L()
	-- self:setViewData()

    -- 直接游戏结束页面
    if _res_data ~= nil then -- and fromView~=nil and fromView==CEnum.pageView.gameingOverPage then
        self.res_data = _res_data
        self:createView_winOrOwner()
        self:createView_R()
        self:createView_L()
        self:setViewData()
    else
        -- 战绩界面，需要先请求数据
        self.loadingPop_window = CDAlertLoading.new():popDialogBox(self.pop_window, Strings.hint_Loading)
        local param = { roundNo=self.roundNo }
        if self.fromOther==nil then
            -- 本人的
            RequestHome:getResultRound_Detail(param, function(...) self:resDataResultRound_Detail(...) end)
        else
            param = { roundNo=self.roundNo, targetToken=self.targetToken }
            RequestHome:getOtherResultRound_Detail(param, function(...) self:resDataResultRound_Detail(...) end)
        end
    end

end

function GameingOverRoundDialog:resDataResultRound_Detail(jsonObj)

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
                    self:createView_winOrOwner()
                    self:createView_R()
                    self:createView_L()
                    self:setViewData()
                else
                    CDAlert.new():popDialogBox(self.parent, Strings.gameing.noData_roundDetailRoom)
                    self:myCancel()
                end
            else
                CDAlert.new():popDialogBox(self.parent, Strings.gameing.noData_roundDetailRoom)
                self:myCancel()
            end
        else
            CDAlert.new():popDialogBox(self.parent, Strings.gameing.noData_roundDetailRoom)
            self:myCancel()
        end
    else
        CDAlert.new():popDialogBox(self.parent, Strings.gameing.noData_roundDetailRoom)
        self:myCancel()
    end
end

-- 显示  页面元素  tag有值就显示
function GameingOverRoundDialog:myView_ShowHide()
    VoiceDealUtil:playSound_other(Voices.file.ui_click)

    if tag_isShow == showHide then
        -- 必须变动
        if tag_isSubmit == gameRound and self.view_btn_submit ~= nil and (not tolua.isnull(self.view_btn_submit)) then
            self.view_btn_submit:setButtonImage(EnStatus.normal, Imgs.over_round_btn_next)
            self.view_btn_submit:setButtonImage(EnStatus.pressed, Imgs.over_round_btn_next_press)
        elseif tag_isSubmit == gameOver and self.view_btn_submit ~= nil and (not tolua.isnull(self.view_btn_submit)) then
            self.view_btn_submit:setButtonImage(EnStatus.normal, Imgs.over_round_btn_roomover)
            self.view_btn_submit:setButtonImage(EnStatus.pressed, Imgs.over_round_btn_roomover_press)
        end
        tag_isShow = showSS
        -- 变成另外一个按钮  去显示 桌面
        self.view_btn_changeto:setButtonImage(EnStatus.normal, Imgs.over_round_btn_changeto_desktop)
        self.view_btn_changeto:setButtonImage(EnStatus.pressed, Imgs.over_round_btn_changeto_desktop)

        -- self.pop_window:setCascadeOpacityEnabled(true)
        -- self.pop_window:setOpacity(200)
        self.pop_window:show()

    elseif tag_isShow == showSS then
        -- 必须变动
        if tag_isSubmit == gameRound and self.view_btn_submit ~= nil and (not tolua.isnull(self.view_btn_submit)) then
            self.view_btn_submit:setButtonImage(EnStatus.normal, Imgs.over_round_btn_next2)
            self.view_btn_submit:setButtonImage(EnStatus.pressed, Imgs.over_round_btn_next_press)
        elseif tag_isSubmit == gameOver and self.view_btn_submit ~= nil and (not tolua.isnull(self.view_btn_submit)) then
            self.view_btn_submit:setButtonImage(EnStatus.normal, Imgs.over_round_btn_roomover2)
            self.view_btn_submit:setButtonImage(EnStatus.pressed, Imgs.over_round_btn_roomover_press)
        end
        tag_isShow = showHide
        -- 变成另外一个按钮  去显示 回合结果
        self.view_btn_changeto:setButtonImage(EnStatus.normal, Imgs.over_round_btn_changeto_result)
        self.view_btn_changeto:setButtonImage(EnStatus.pressed, Imgs.over_round_btn_changeto_result)    

        -- self.pop_window:setCascadeOpacityEnabled(true)
        -- self.pop_window:setOpacity(10)
        self.pop_window:hide()

    end
end

function GameingOverRoundDialog:myCancel()

    VoiceDealUtil:playSound_other(Voices.file.ui_click)
    if fromView~=nil and fromView==CEnum.pageView.gameingOverPage then 
        -- 关闭按钮  游戏界面的房间结束
        if tag_isCancel ~= nil and tag_isCancel==gameOver then
            Commons:gotoHome()
            -- self:myViewReset() -- 重置桌面
            self:myExit()
        else
            -- 关闭按钮  游戏界面的回合结束
            self:myViewReset_backDesktop() -- 回到桌面 查看最后胡牌情况
            self:myExit()
        end
    else
        -- 关闭按钮  战绩页面
        -- self:myViewReset() -- 重置桌面
        self:myExit()
    end
    
end

function GameingOverRoundDialog:myConfim()
    VoiceDealUtil:playSound_other(Voices.file.ui_click)

    if tag_isSubmit ~= nil and tag_isSubmit == gameOver then
        -- 确定按钮  房间结束
        GameingOverRoomDialog:popDialogBox(self.parent, self.res_data)

        if self.view_btn_changeto ~= nil and (not tolua.isnull(self.view_btn_changeto)) then
            self.view_btn_changeto:removeFromParent() 
            self.view_btn_changeto = nil
        end
        -- self:myViewReset() -- 重置桌面

        -- self:removeChild(self.pop_window)
        -- 这里不能消除控件，因为可以返回查看 
        self:myExit()

    elseif tag_isSubmit ~= nil and tag_isSubmit == gamePlay then    
        -- 确定按钮  回放数据
        self.loadingPop_window = CDAlertLoading.new():popDialogBox(self.pop_window, Strings.hint_Loading)
        local param = { roomNo=self.roomNo, roundNo=self.playRoundNo }
        if self.fromOther == nil then
            -- 本人的
            RequestHome:getGameingMirror(param, function(...) self:resData_GameingMirror(...) end)
        else
            param = { roomNo=self.roomNo, roundNo=self.playRoundNo, targetToken=self.targetToken}
            RequestHome:getOtherGameingMirror(param, function(...) self:resData_GameingMirror(...) end)
        end

    else
        -- 确定按钮  回合结束
        if self.view_btn_changeto ~= nil and (not tolua.isnull(self.view_btn_changeto)) then
            self.view_btn_changeto:removeFromParent() 
            self.view_btn_changeto = nil
        end
        self:myViewReset_backDesktop() -- 回到桌面 查看最后胡牌情况
        self:myExit()
    end
end

-- 选择再来一局，需要将房间界面重置，该去掉的去掉，该隐藏的隐藏
function GameingOverRoundDialog:myViewReset_backDesktop()
    if myself_view_btn_Prepare ~= nil and (not tolua.isnull(myself_view_btn_Prepare)) then
        CVar._static.isNeedShowPrepareBtn = true
        
        myself_view_btn_Prepare:setVisible(true)
        myself_view_btn_Prepare:setButtonEnabled(true)
        myself_view_btn_Prepare:setPosition(cc.p(display.cx, osHeight-508+70))
    end
end

function GameingOverRoundDialog:createView_winOrOwner()
    -- 房间号
    self.view_roomNo = 
    cc.ui.UILabel.new({
            UILabelType = 2,
            text = "",
            font = Fonts.Font_hkyt_w9,
            size = Dimens.TextSize_20,
            color = Colors.white,
            -- color = Colors:_16ToRGB(Colors.gameing_huxi),
            align = cc.ui.TEXT_ALIGN_LEFT,
            valign = cc.ui.TEXT_VALIGN_CENTER,
            dimensions = cc.size(200,25),
            --maxLineWidth = 118,
        })
        :addTo(self.pop_window)
        :align(display.LEFT_TOP, 14+30, startY+27)
    if Commons:checkIsNull_str(self.roomNo) then
        self.view_roomNo:setString("房号："..self.roomNo)
    end

    -- 局号
    self.view_roundNo = 
    cc.ui.UILabel.new({
            UILabelType = 2,
            text = "",
            font = Fonts.Font_hkyt_w9,
            size = Dimens.TextSize_20,
            color = Colors.white,
            -- color = Colors:_16ToRGB(Colors.gameing_huxi),
            align = cc.ui.TEXT_ALIGN_LEFT,
            valign = cc.ui.TEXT_VALIGN_CENTER,
            dimensions = cc.size(200,25),
            --maxLineWidth = 118,
        })
        :addTo(self.pop_window)
        :align(display.LEFT_TOP, 14+30 +200, startY+27)

    -- 当前手机时间
    local myDate = os.date("%Y-%m-%d %H:%M:%S") -- "%Y-%m-%d %H:%M:%S"
    self.view_roomTime = 
    cc.ui.UILabel.new({
            UILabelType = 2,
            text = myDate, -- "结束时间："..myDate,
            font = Fonts.Font_hkyt_w9,
            size = Dimens.TextSize_20,
            color = Colors.white,
            -- color = Colors:_16ToRGB(Colors.gameing_huxi),
            align = cc.ui.TEXT_ALIGN_RIGHT,
            valign = cc.ui.TEXT_VALIGN_CENTER,
            dimensions = cc.size(280,25),
            --maxLineWidth = 118,
        })
        :addTo(self.pop_window)
        :align(display.RIGHT_TOP, osWidth -14-20, startY+27)
    if Commons:checkIsNull_str(self.startTime) then
        self.view_roomTime:setString(self.startTime) -- "开始时间："..startTime
    end

    -- 层
    -- self.winOrOwner_view_layer = display.newLayer() -- .newColorLayer(Colors.layer_bg)
    --     :setContentSize(600,508)
    --     :align(display.LEFT_TOP, 14+30, startY)
    --     :addTo(self.pop_window)
    self.winOrOwner_view_layer = display.newNode():addTo(self.pop_window)

    local moveX = 0
    -- 内容背景
    local winOrOwner_view_bg =  cc.ui.UIImage.new(Imgs.dialog_content_bg,{})
        :addTo(self.winOrOwner_view_layer)
        :align(display.LEFT_TOP, 14+30, startY)
        :setLayoutSize(600, 508)
    if CVar._static.isIphone4 then
        winOrOwner_view_bg:setLayoutSize(500, 508)
    elseif CVar._static.isIpad then
        moveX = -40
        winOrOwner_view_bg:setLayoutSize(500 +moveX, 508)
        winOrOwner_view_bg:align(display.LEFT_TOP, 14+30 +moveX+20, startY)
    elseif CVar._static.NavBarH_Android ~= CEnum.status.NavBarH_def then
        winOrOwner_view_bg:setLayoutSize(600-CVar._static.NavBarH_Android/2, 508)  
    end

    -- 头像框
    local user_head_bg = display.newSprite(Imgs.home_user_head_bg_top)
        :align(display.LEFT_TOP, 14+30 +10, startY -16)
        :addTo(self.winOrOwner_view_layer)
    if CVar._static.isIphone4 then
        -- user_head_bg:align(display.LEFT_TOP, 14+30 +10 +moveX, startY -16)
    elseif CVar._static.isIpad then
        user_head_bg:align(display.LEFT_TOP, 14+30 +10 +moveX+20, startY -16)
    end
    -- local user_icon = 'http://wmq.res.apk.yuelaigame.com/test/icon1.jpg'
    -- if user_icon ~= nil and user_icon ~= "" then
    --     self.winOrOwner_view_icon = NetSpriteImg.new(user_icon, 106, 100) -- 118*116
    --         --:setContentSize(cc.size(100,100))
    --         --:pos(8+106/2+6,osHeight-8-100/2-8)
    --         :align(display.LEFT_TOP,14+30 +10+6, startY -16-8)
    --         :addTo(self.winOrOwner_view_layer)
    -- end

    -- 房主
    self.winOrOwner_view_owner = display.newSprite(Imgs.over_round_owner_logo)
        :align(display.LEFT_TOP, 14+30 +10 +60, startY -16 -60)
        --:addTo(self.winOrOwner_view_layer)
    if CVar._static.isIphone4 then
        -- self.winOrOwner_view_owner:align(display.LEFT_TOP, 14+30 +10 +60 +moveX, startY -16 -60)
    elseif CVar._static.isIpad then
        self.winOrOwner_view_owner:align(display.LEFT_TOP, 14+30 +10 +60 +moveX+20, startY -16 -60)
    end

    -- 昵称
    self.winOrOwner_view_nickname = cc.ui.UILabel.new({
            UILabelType = 2,
            text = "",
            font = Fonts.Font_hkyt_w9,
            size = Dimens.TextSize_25,
            color = Colors:_16ToRGB(Colors.gameing_huxi),
            align = cc.ui.TEXT_ALIGN_LEFT,
            valign = cc.ui.TEXT_VALIGN_CENTER,
            dimensions = cc.size(150,40),
            --maxLineWidth = 118,
        })
        :addTo(self.winOrOwner_view_layer)
        :align(display.LEFT_TOP, 14+30 +10 +moveX+20, startY -16 -116-10)
    if CVar._static.isIphone4 then
        self.winOrOwner_view_nickname:align(display.LEFT_TOP, 14+30 +10 +moveX+10, startY -16 -116-10)
    elseif CVar._static.isIpad then
        self.winOrOwner_view_nickname:align(display.LEFT_TOP, 14+30 +10 +moveX+20, startY -16 -116-10)
    end

    -- 胡牌组合  最多7组
    local lie = 10
    local moveX_android = 0
    if CVar._static.isIphone4 then
        lie = 8.5
    elseif CVar._static.isIpad then
        lie = 7.8
    elseif CVar._static.NavBarH_Android ~= CEnum.status.NavBarH_def then
        lie = 10
        moveX_android = -CVar._static.NavBarH_Android*0.2
    end

    self.winOrOwner_view_hu_list = 
    cc.ui.UIPageView.new({
        viewRect = cc.rect(0, 0, 42*lie+moveX_android, 42*7),
        column = 7,
        row = 6, 
        padding = {left = 26, right = 21, top = 0, bottom = 21},
        columnSpace=20,
        rowSpace=0,
        bCirc = false
    })
    :addTo(self.winOrOwner_view_layer)
    :align(display.LEFT_TOP, 14+30 +10 +118+18 +moveX, startY -16 -116-10 -140 +0)

    -- 1row
    if CEnum.Environment.gameCode == CEnum.gameType.wmq then
        -- 偎麻雀独有：
        -- 硬息
        display.newTTFLabel({
                text = Strings.gameing.xi_maohao,
                font = Fonts.Font_hkyt_w7,
                size = Dimens.TextSize_20,
                color = Colors:_16ToRGB(Colors.gameing_huxi),
                align = cc.ui.TEXT_ALIGN_CENTER,
                valign = cc.ui.TEXT_VALIGN_CENTER,
                dimensions = cc.size(100,30)
            })
            :addTo(self.winOrOwner_view_layer)
            :align(display.LEFT_TOP, 14+30 +10 +moveX, startY -16 -116-10 -150 +40)
        -- 具体的数字，需要动态生成

        -- 总息
        display.newTTFLabel({
                text = "总息：",
                font = Fonts.Font_hkyt_w7,
                size = Dimens.TextSize_20,
                color = Colors:_16ToRGB(Colors.gameing_huxi),
                align = cc.ui.TEXT_ALIGN_CENTER,
                valign = cc.ui.TEXT_VALIGN_CENTER,
                dimensions = cc.size(100,30)
            })
            :addTo(self.winOrOwner_view_layer)
            :align(display.LEFT_TOP, 14+30 +10 +300 +moveX, startY -16 -116-10 -150 +40)
        -- 具体的数字，需要动态生成
    elseif CEnum.Environment.gameCode == CEnum.gameType.chz then
        -- 扯胡子独有：
        -- 胡息
        display.newTTFLabel({
                text = Strings.gameing.xi.."：",
                font = Fonts.Font_hkyt_w7,
                size = Dimens.TextSize_20,
                color = Colors:_16ToRGB(Colors.gameing_huxi),
                align = cc.ui.TEXT_ALIGN_CENTER,
                valign = cc.ui.TEXT_VALIGN_CENTER,
                dimensions = cc.size(100,30)
            })
            :addTo(self.winOrOwner_view_layer)
            :align(display.LEFT_TOP, 14+30 +10 +moveX, startY -16 -116-10 -150)
        -- 具体的数字，需要动态生成

        -- 番数
        display.newTTFLabel({
                text = "番数：",
                font = Fonts.Font_hkyt_w7,
                size = Dimens.TextSize_20,
                color = Colors:_16ToRGB(Colors.gameing_huxi),
                align = cc.ui.TEXT_ALIGN_CENTER,
                valign = cc.ui.TEXT_VALIGN_CENTER,
                dimensions = cc.size(100,30)
            })
            :addTo(self.winOrOwner_view_layer)
            :align(display.LEFT_TOP, 14+30 +10 +300 +moveX, startY -16 -116-10 -150)
        -- 具体的数字，需要动态生成
    end


    -- 2row
    if CEnum.Environment.gameCode == CEnum.gameType.wmq then
        -- 偎麻雀独有：
        -- 分数
        display.newTTFLabel({
                text = Strings.gameing.score,
                font = Fonts.Font_hkyt_w7,
                size = Dimens.TextSize_20,
                color = Colors:_16ToRGB(Colors.gameing_huxi),
                align = cc.ui.TEXT_ALIGN_CENTER,
                valign = cc.ui.TEXT_VALIGN_CENTER,
                dimensions = cc.size(100,30)
            })
            :addTo(self.winOrOwner_view_layer)
            :align(display.LEFT_TOP, 14+30 +10 +moveX, startY -16 -116-10 -150 -42 +30)
        -- 具体的数字，需要动态生成

        ---[[
        -- 分溜子
        self.winOrOwner_view_flz = display.newTTFLabel({
                text = "分溜子：",
                font = Fonts.Font_hkyt_w7,
                size = Dimens.TextSize_20,
                color = Colors:_16ToRGB(Colors.gameing_huxi),
                align = cc.ui.TEXT_ALIGN_CENTER,
                valign = cc.ui.TEXT_VALIGN_CENTER,
                dimensions = cc.size(100,30)
            })
            :addTo(self.winOrOwner_view_layer)
            :align(display.LEFT_TOP, 14+30 +10+300-10 +moveX, startY -16 -116-10 -150 -42 +30)
        -- 具体的数字，需要动态生成
        --]]
    elseif CEnum.Environment.gameCode == CEnum.gameType.chz then
        -- 扯胡子独有：
        -- 分数
        display.newTTFLabel({
                text = Strings.gameing.score,
                font = Fonts.Font_hkyt_w7,
                size = Dimens.TextSize_20,
                color = Colors:_16ToRGB(Colors.gameing_huxi),
                align = cc.ui.TEXT_ALIGN_CENTER,
                valign = cc.ui.TEXT_VALIGN_CENTER,
                dimensions = cc.size(100,30)
            })
            :addTo(self.winOrOwner_view_layer)
            :align(display.LEFT_TOP, 14+30 +10 +moveX, startY -16 -116-10 -150 -42)
        -- 具体的数字，需要动态生成

        ---[[
        -- 等数
        display.newTTFLabel({
                text = "等数：",
                font = Fonts.Font_hkyt_w7,
                size = Dimens.TextSize_20,
                color = Colors:_16ToRGB(Colors.gameing_huxi),
                align = cc.ui.TEXT_ALIGN_CENTER,
                valign = cc.ui.TEXT_VALIGN_CENTER,
                dimensions = cc.size(100,30)
            })
            :addTo(self.winOrOwner_view_layer)
            :align(display.LEFT_TOP, 14+30 +10+300 +moveX, startY -16 -116-10 -150 -42)
        -- 具体的数字，需要动态生成
        --]]
    end
    

    -- 3row
    if CEnum.Environment.gameCode == CEnum.gameType.wmq then
        -- 偎麻雀独有：

        -- 名堂列表
        display.newTTFLabel({
                text = "名堂：",
                font = Fonts.Font_hkyt_w7,
                size = Dimens.TextSize_20,
                color = Colors:_16ToRGB(Colors.gameing_huxi),
                align = cc.ui.TEXT_ALIGN_CENTER,
                valign = cc.ui.TEXT_VALIGN_CENTER,
                dimensions = cc.size(100,30)
            })
            :addTo(self.winOrOwner_view_layer)
            :align(display.LEFT_TOP, 14+30 +10 +moveX, startY -16 -116-10 -150 -40 -45 +20)
        -- 列表需要显现
    elseif CEnum.Environment.gameCode == CEnum.gameType.chz then
        -- 扯胡子独有：

        -- 名堂列表
        display.newTTFLabel({
                text = "名堂：",
                font = Fonts.Font_hkyt_w7,
                size = Dimens.TextSize_20,
                color = Colors:_16ToRGB(Colors.gameing_huxi),
                align = cc.ui.TEXT_ALIGN_CENTER,
                valign = cc.ui.TEXT_VALIGN_CENTER,
                dimensions = cc.size(100,30)
            })
            :addTo(self.winOrOwner_view_layer)
            :align(display.LEFT_TOP, 14+30 +10 +moveX, startY -16 -116-10 -150 -40 -45)
        -- 列表需要显现
    end
    
    
    -- 4row
    local size_card = 36
    if CVar._static.isIpad then
        size_card = 33
    end
    if CEnum.Environment.gameCode == CEnum.gameType.wmq then
        -- 偎麻雀独有：

        -- 底牌列表
        display.newTTFLabel({
                text = "底牌：",
                font = Fonts.Font_hkyt_w7,
                size = Dimens.TextSize_20,
                color = Colors:_16ToRGB(Colors.gameing_huxi),
                align = cc.ui.TEXT_ALIGN_CENTER,
                valign = cc.ui.TEXT_VALIGN_CENTER,
                dimensions = cc.size(100,30)
            })
            :addTo(self.winOrOwner_view_layer)
            :align(display.LEFT_TOP, 14+30 +10 +moveX, startY -16 -116-10 -150 -40 -50 -50 +10)
        -- 列表需要显现
        self.winOrOwner_view_dcard_list = 
            cc.ui.UIPageView.new({
                viewRect = cc.rect(0, 0, size_card*12.5, size_card*2.8),
                column = 11,
                row = 2, 
                padding = {left = size_card/2, right = size_card/2, top = 0, bottom = size_card/2},
                columnSpace=0,
                rowSpace=0,
                bCirc = false
            })
            :addTo(self.winOrOwner_view_layer)
            :align(display.LEFT_TOP, 14+30 +10 +80 +moveX, startY -16 -116-10 -150 -40 -50 -50 -80 +10) -- 1行=-80 2行=-70
    elseif CEnum.Environment.gameCode == CEnum.gameType.chz then
        -- 扯胡子独有：

        -- 底牌列表
        display.newTTFLabel({
                text = "底牌：",
                font = Fonts.Font_hkyt_w7,
                size = Dimens.TextSize_20,
                color = Colors:_16ToRGB(Colors.gameing_huxi),
                align = cc.ui.TEXT_ALIGN_CENTER,
                valign = cc.ui.TEXT_VALIGN_CENTER,
                dimensions = cc.size(100,30)
            })
            :addTo(self.winOrOwner_view_layer)
            :align(display.LEFT_TOP, 14+30 +10 +moveX, startY -16 -116-10 -150 -40 -50 -50)
        -- 列表需要显现
        self.winOrOwner_view_dcard_list = 
            cc.ui.UIPageView.new({
                viewRect = cc.rect(0, 0, size_card*12.5, size_card*2.8),
                column = 11,
                row = 2, 
                padding = {left = size_card/2, right = size_card/2, top = 0, bottom = size_card/2},
                columnSpace=0,
                rowSpace=0,
                bCirc = false
            })
            :addTo(self.winOrOwner_view_layer)
            :align(display.LEFT_TOP, 14+30 +10 +80 +moveX, startY -16 -116-10 -150 -40 -50 -50 -80) -- 1行=-80 2行=-70
    end

end

-- 下家
function GameingOverRoundDialog:createView_R()
    -- 层
    -- self.R_view_layer = display.newLayer() -- .newColorLayer(Colors.layer_bg)
    --     :setContentSize(600,508)
    --     :align(display.LEFT_TOP, 14+30, startY)
    --     :addTo(self.pop_window)
    self.R_view_layer = display.newNode():addTo(self.pop_window)

    local startX_R = 608
    if CVar._static.isIphone4 then
        startX_R = 508
    elseif CVar._static.isIpad then
        startX_R = 508 -60
    elseif CVar._static.NavBarH_Android ~= CEnum.status.NavBarH_def then
        startX_R = 608 -CVar._static.NavBarH_Android/2
    end

    -- 内容背景
    local R_view_bg = cc.ui.UIImage.new(Imgs.dialog_content_bg,{scale9=false})
        :addTo(self.R_view_layer)
        :align(display.LEFT_TOP, 14+30 +startX_R, startY)
        :setLayoutSize(600, 508/2-2)
    if CVar._static.isIphone4 then
        R_view_bg:setLayoutSize(480, 508/2-2)
    elseif CVar._static.isIpad then
        R_view_bg:setLayoutSize(480-30, 508/2-2)
    elseif CVar._static.NavBarH_Android ~= CEnum.status.NavBarH_def then
        R_view_bg:setLayoutSize(600 -CVar._static.NavBarH_Android/2, 508/2-2)
    end

    -- 头像框
    display.newSprite(Imgs.home_user_head_bg_top)
        :align(display.LEFT_TOP, 14+30 +10 +startX_R, startY -16)
        :addTo(self.R_view_layer)
    -- local user_icon = 'http://wmq.res.apk.yuelaigame.com/test/icon1.jpg'
    -- if user_icon ~= nil and user_icon ~= "" then
    --     self.R_view_icon = NetSpriteImg.new(user_icon, 106, 100) -- 118*116
    --         --:setContentSize(cc.size(100,100))
    --         --:pos(8+106/2+6,osHeight-8-100/2-8)
    --         :align(display.LEFT_TOP,14+30 +10+6 +608, startY -16-8)
    --         :addTo(self.R_view_layer)
    -- end

    -- 房主
    self.R_view_owner = display.newSprite(Imgs.over_round_owner_logo)
        :align(display.LEFT_TOP, 14+30 +10 +60 +startX_R, startY -16 -60)
        --:addTo(self.R_view_layer)

    -- 昵称
    self.R_view_nickname = cc.ui.UILabel.new({
            UILabelType = 2,
            text = "",
            font = Fonts.Font_hkyt_w9,
            size = Dimens.TextSize_25,
            color = Colors:_16ToRGB(Colors.gameing_huxi),
            align = cc.ui.TEXT_ALIGN_LEFT,
            valign = cc.ui.TEXT_VALIGN_CENTER,
            dimensions = cc.size(150,40),
            --maxLineWidth = 118,
        })
        :addTo(self.R_view_layer)
        :align(display.LEFT_TOP, 14+30 +10 +startX_R, startY -16 -116)

    -- 胡牌组合  最多7组
    -- self.R_view_hu_list = 
    --     cc.ui.UIPageView.new({
    --         viewRect = cc.rect(0, 0, 42*10, 42*7),
    --         column = 7,
    --         row = 6, 
    --         padding = {left = 26, right = 21, top = 0, bottom = 21},
    --         columnSpace=20,
    --         rowSpace=0,
    --         bCirc = false
    --     })
    --     :addTo(self.R_view_layer)
    --     :align(display.LEFT_TOP, 14+30 +10 +118+18 +startX_R, startY -16 -116-10 -140)
    local lie = 10
    local moveX_android = 0
    if CVar._static.isIphone4 then
        lie = 8.5
    elseif CVar._static.isIpad then
        lie = 7.5
    elseif CVar._static.NavBarH_Android ~= CEnum.status.NavBarH_def then
        lie = 10
        moveX_android = -CVar._static.NavBarH_Android*0.2
    end
    self.R_view_hu_list = 
    cc.ui.UIPageView.new({
            viewRect = cc.rect(0, 0, 42*lie+moveX_android, 42*7),
        column = 7,
        row = 6, 
        padding = {left = 26, right = 21, top = 0, bottom = 21},
        columnSpace=20,
        rowSpace=0,
        bCirc = false
    })
    :addTo(self.R_view_layer)
    :align(display.LEFT_TOP, 14+30 +10 +118+18 +startX_R, startY -16 -116-10 -140)

    -- 胡息
    if CEnum.Environment.gameCode == CEnum.gameType.wmq then
        -- 偎麻雀独有：
        display.newTTFLabel({
                text = Strings.gameing.xi_maohao,
                font = Fonts.Font_hkyt_w7,
                size = Dimens.TextSize_20,
                color = Colors:_16ToRGB(Colors.gameing_huxi),
                align = cc.ui.TEXT_ALIGN_CENTER,
                valign = cc.ui.TEXT_VALIGN_CENTER,
                dimensions = cc.size(100,30)
            })
            :addTo(self.R_view_layer)
            :align(display.LEFT_TOP, 14+10 +10 +startX_R, startY -16 -116-10 -35)
        -- 具体的数字，需要动态生成
    elseif CEnum.Environment.gameCode == CEnum.gameType.chz then
        -- 扯胡子独有：
        display.newTTFLabel({
                text = Strings.gameing.xi.."：",
                font = Fonts.Font_hkyt_w7,
                size = Dimens.TextSize_20,
                color = Colors:_16ToRGB(Colors.gameing_huxi),
                align = cc.ui.TEXT_ALIGN_CENTER,
                valign = cc.ui.TEXT_VALIGN_CENTER,
                dimensions = cc.size(100,30)
            })
            :addTo(self.R_view_layer)
            :align(display.LEFT_TOP, 14+10 +10 +startX_R, startY -16 -116-10 -35)
        -- 具体的数字，需要动态生成
    end

    -- 分数
    display.newTTFLabel({
            text = Strings.gameing.score,
            font = Fonts.Font_hkyt_w7,
            size = Dimens.TextSize_20,
            color = Colors:_16ToRGB(Colors.gameing_huxi),
            align = cc.ui.TEXT_ALIGN_CENTER,
            valign = cc.ui.TEXT_VALIGN_CENTER,
            dimensions = cc.size(100,30)
        })
        :addTo(self.R_view_layer)
        :align(display.LEFT_TOP, 14+10 +10 +startX_R, startY -16 -116-10 -32 -36)
    -- 具体的数字，需要动态生成
    
end

-- 下家
function GameingOverRoundDialog:createView_L()
    -- 层
    -- self.L_view_layer = display.newLayer() -- .newColorLayer(Colors.layer_bg)
    --     :setContentSize(600,508)
    --     :align(display.LEFT_TOP, 14+30, startY)
    --     :addTo(self.pop_window)
    self.L_view_layer = display.newNode():addTo(self.pop_window)

    local startX_R = 608
    if CVar._static.isIphone4 then
        startX_R = 508
    elseif CVar._static.isIpad then
        startX_R = 508 -60
    elseif CVar._static.NavBarH_Android ~= CEnum.status.NavBarH_def then
        startX_R = 608 -CVar._static.NavBarH_Android/2
    end

    -- 内容背景
    local L_view_bg = cc.ui.UIImage.new(Imgs.dialog_content_bg,{scale9=false})
        :addTo(self.L_view_layer)
        :align(display.LEFT_TOP, 14+30 +startX_R, startY -508/2-3)
        :setLayoutSize(600, 508/2-3)
    if CVar._static.isIphone4 then
        L_view_bg:setLayoutSize(480, 508/2-3)
    elseif CVar._static.isIpad then
        L_view_bg:setLayoutSize(480-30, 508/2-3)
    elseif CVar._static.NavBarH_Android ~= CEnum.status.NavBarH_def then
        L_view_bg:setLayoutSize(600 -CVar._static.NavBarH_Android/2, 508/2-3)
    end

    -- 头像框
    display.newSprite(Imgs.home_user_head_bg_top)
        :align(display.LEFT_TOP, 14+30 +10 +startX_R, startY -16 -508/2-3)
        :addTo(self.L_view_layer)
    -- local user_icon = 'http://wmq.res.apk.yuelaigame.com/test/icon1.jpg'
    -- if user_icon ~= nil and user_icon ~= "" then
    --     self.L_view_icon = NetSpriteImg.new(user_icon, 106, 100) -- 118*116
    --         --:setContentSize(cc.size(100,100))
    --         --:pos(8+106/2+6,osHeight-8-100/2-8)
    --         :align(display.LEFT_TOP,14+30 +10+6 +608, startY -16-8 -508/2-3)
    --         :addTo(self.L_view_layer)
    -- end

    -- 房主
    self.L_view_owner = display.newSprite(Imgs.over_round_owner_logo)
        :align(display.LEFT_TOP, 14+30 +10 +60 +startX_R, startY -16 -60 -508/2-3)
        --:addTo(self.L_view_layer)

    -- 昵称
    self.L_view_nickname = cc.ui.UILabel.new({
            UILabelType = 2,
            text = "",
            font = Fonts.Font_hkyt_w9,
            size = Dimens.TextSize_25,
            color = Colors:_16ToRGB(Colors.gameing_huxi),
            align = cc.ui.TEXT_ALIGN_LEFT,
            valign = cc.ui.TEXT_VALIGN_CENTER,
            dimensions = cc.size(150,40),
            --maxLineWidth = 118,
        })
        :addTo(self.L_view_layer)
        :align(display.LEFT_TOP, 14+30 +10 +startX_R, startY -16 -116 -508/2-3)

    -- 胡牌组合  最多7组
    local lie = 10
    local moveX_android = 0
    if CVar._static.isIphone4 then
        lie = 8.5
    elseif CVar._static.isIpad then
        lie = 7.5
    elseif CVar._static.NavBarH_Android ~= CEnum.status.NavBarH_def then
        lie = 10
        moveX_android = -CVar._static.NavBarH_Android*0.2
    end
    self.L_view_hu_list = 
    cc.ui.UIPageView.new({
        viewRect = cc.rect(0, 0, 42*lie+moveX_android, 42*7),
        column = 7,
        row = 6, 
        padding = {left = 26, right = 21, top = 0, bottom = 21},
        columnSpace=20,
        rowSpace=0,
        bCirc = false
    })
    :addTo(self.L_view_layer)
    :align(display.LEFT_TOP, 14+30 +10 +118+18 +startX_R, startY -16 -116-10 -140 -508/2-3)

    -- 胡息
    if CEnum.Environment.gameCode == CEnum.gameType.wmq then
        -- 偎麻雀独有：
        display.newTTFLabel({
                text = Strings.gameing.xi_maohao,
                font = Fonts.Font_hkyt_w7,
                size = Dimens.TextSize_20,
                color = Colors:_16ToRGB(Colors.gameing_huxi),
                align = cc.ui.TEXT_ALIGN_CENTER,
                valign = cc.ui.TEXT_VALIGN_CENTER,
                dimensions = cc.size(100,30)
            })
            :addTo(self.L_view_layer)
            :align(display.LEFT_TOP, 14+10 +10 +startX_R, startY -16 -116-10 -35 -508/2-3)
        -- 具体的数字，需要动态生成
    elseif CEnum.Environment.gameCode == CEnum.gameType.chz then
        -- 扯胡子独有：
        display.newTTFLabel({
                text = Strings.gameing.xi.."：",
                font = Fonts.Font_hkyt_w7,
                size = Dimens.TextSize_20,
                color = Colors:_16ToRGB(Colors.gameing_huxi),
                align = cc.ui.TEXT_ALIGN_CENTER,
                valign = cc.ui.TEXT_VALIGN_CENTER,
                dimensions = cc.size(100,30)
            })
            :addTo(self.L_view_layer)
            :align(display.LEFT_TOP, 14+10 +10 +startX_R, startY -16 -116-10 -35 -508/2-3)
        -- 具体的数字，需要动态生成
    end

    -- 分数
    display.newTTFLabel({
            text = Strings.gameing.score,
            font = Fonts.Font_hkyt_w7,
            size = Dimens.TextSize_20,
            color = Colors:_16ToRGB(Colors.gameing_huxi),
            align = cc.ui.TEXT_ALIGN_CENTER,
            valign = cc.ui.TEXT_VALIGN_CENTER,
            dimensions = cc.size(100,30)
        })
        :addTo(self.L_view_layer)
        :align(display.LEFT_TOP, 14+10 +10 +startX_R, startY -16 -116-10 -32 -36 -508/2-3)
    -- 具体的数字，需要动态生成
end

function GameingOverRoundDialog:getMirrorData(status, fileNameShort, RemoteUrl)
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
            GameingMirrorDialog:popDialogBox(self.parent, fileNameShort, self.startTime)
        else
            CDAlert.new():popDialogBox(self.pop_window, Strings.gameing.noData_info)
        end
    else
        -- CDAlert.new():popDialogBox(self.pop_window, Strings.gameing.noData_info)
    end
end

function GameingOverRoundDialog:resData_GameingMirror(jsonObj)
    local status = jsonObj[ParseBase.status]
    local msg = RequestBase:getStrDecode(jsonObj[ParseBase.msg])
    Commons:printLog_Info("状态是：", status, "内容是：", msg)

    if status ~= nil and status==CEnum.status.success then
        local data = jsonObj[ParseBase.data]
        --print("---------data 是：",data)

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


-- 三个玩家的数据都显示出来
function GameingOverRoundDialog:setViewData()
    local startX_R = 608
    if CVar._static.isIphone4 then
        startX_R = 508
    elseif CVar._static.isIpad then
        startX_R = 508 -60
    elseif CVar._static.NavBarH_Android ~= CEnum.status.NavBarH_def then
        startX_R = 608 -CVar._static.NavBarH_Android/2
    end

    local moveX = 0 -- 只是控制赢家的起始点
    if CVar._static.isIphone4 then
        -- moveX = 0
    elseif CVar._static.isIpad then
        moveX = -35
    -- elseif CVar._static.NavBarH_Android ~= CEnum.status.NavBarH_def then
        -- moveX = 0
    end

    if self.res_data ~= nil then
        local room = self.res_data--[Room.Bean.room]
        self.roomNo = room[Room.Bean.roomNo]
        self.playRoundNo = room[Room.Bean.playRoundNo]
        local roundRecord = room[Room.Bean.roundRecord]

        local playRound = room[Room.Bean.playRound]
        local rounds = room[Room.Bean.rounds]

        if self.roomNo ~= nil and self.view_roomNo ~= nil then
            self.view_roomNo:setString("房号："..self.roomNo)
        end
        if playRound ~= nil and rounds ~= nil and self.view_roundNo ~= nil then
            self.view_roundNo:setString("局："..playRound..'/'..rounds)
        end

        -- local _room_status = room[Room.Bean.status]
        -- if CEnum.roomStatus.ended==_room_status or CEnum.roomStatus.dissolved==_room_status then
        local roomRecord = room[Room.Bean.roomRecord]
        if roomRecord then
            
            -- 房间结束
            if fromView~=nil and fromView==CEnum.pageView.gameingOverPage then 
                -- 来源游戏界面
                -- 无 返回按钮
                self.view_btn_back:setVisible(false)
            else
                -- 来源战绩页面
                -- 有 返回按钮
                self.view_btn_back:setVisible(true)
            end
            tag_isCancel = gameOver


            if fromView~=nil and fromView==CEnum.pageView.gameingOverPage then 
                -- 来源游戏界面
                -- 牌局结束
                self.view_btn_submit:setVisible(true)
                self.view_btn_submit:setButtonImage(EnStatus.normal, Imgs.over_round_btn_roomover)
                self.view_btn_submit:setButtonImage(EnStatus.pressed, Imgs.over_round_btn_roomover_press)
                tag_isSubmit = gameOver

                self.view_btn_changeto:show()
            else  
                -- 来源战绩页面
                -- 回放
                self.view_btn_submit:setVisible(true)
                self.view_btn_submit:setButtonImage(EnStatus.normal, Imgs.over_round_btn_mirror)
                self.view_btn_submit:setButtonImage(EnStatus.pressed, Imgs.over_round_btn_mirror_press)
                tag_isSubmit = gamePlay

                self.view_btn_changeto:hide()
            end

        else 
            -- 回合结束
            if fromView~=nil and fromView==CEnum.pageView.gameingOverPage then
                -- 来源游戏界面
                -- 有 返回按钮
                self.view_btn_back:setVisible(true)
            else
                -- 来源战绩页面
                -- 有 返回按钮
                self.view_btn_back:setVisible(true)
            end
            tag_isCancel = gameRound

            if fromView~=nil and fromView==CEnum.pageView.gameingOverPage then 
                -- 来源游戏界面
                -- 再来一局
                self.view_btn_submit:setVisible(true)
                tag_isSubmit = gameRound

                self.view_btn_changeto:show()
            else
                -- 来源战绩页面
                -- 回放
                self.view_btn_submit:setVisible(true)
                self.view_btn_submit:setButtonImage(EnStatus.normal, Imgs.over_round_btn_mirror)
                self.view_btn_submit:setButtonImage(EnStatus.pressed, Imgs.over_round_btn_mirror_press)
                tag_isSubmit = gamePlay

                self.view_btn_changeto:hide()
            end
        end


        if Commons:checkIsNull_tableList(roundRecord) then
            local isMeWin
            local isHu

            for k,v in pairs(roundRecord) do
                local me = v[RoundRecord.Bean.me]
                local hu = v[RoundRecord.Bean.hu]
                if me and hu then
                    isMeWin = true
                    break
                end
            end

            for k,v in pairs(roundRecord) do
                local hu = v[RoundRecord.Bean.hu]
                if hu then
                    isHu = true
                    break
                end
            end

            if isHu then
                -- 只要有胡，就看是谁赢了
                if not isMeWin then
                    -- 失败
                    self.view_title_logo:setButtonImage(EnStatus.normal, Imgs.over_round_title_fail)
                    self.view_title_logo:setButtonImage(EnStatus.pressed, Imgs.over_round_title_fail)
                    if fromView~=nil and fromView==CEnum.pageView.gameingOverPage then
                        VoiceDealUtil:playSound_other(Voices.file.over_fail)
                    end
                else
                    if fromView~=nil and fromView==CEnum.pageView.gameingOverPage then
                        VoiceDealUtil:playSound_other(Voices.file.over_win)
                    end
                end
            else
                -- 荒局
                self.view_title_logo:setButtonEnabled(false)
                --self.view_title_logo:setButtonImage(EnStatus.normal, Imgs.over_round_title_invalid)
                -- if fromView~=nil and fromView==CEnum.pageView.gameingOverPage then
                --     VoiceDealUtil:playSound_other(Voices.file.over_huang)
                -- end
            end

            local ii = 0
            for k,v in pairs(roundRecord) do
                local me = v[RoundRecord.Bean.me]
                --Commons:printLog_Info("----",me)
                local hu = v[RoundRecord.Bean.hu]
                local _role = v[RoundRecord.Bean.role]
                local role = _role == CEnum.role.z

                local icon = RequestBase:new():getStrDecode(v[RoundRecord.Bean.user][User.Bean.icon])
                local nickname = Commons:trim(RequestBase:getStrDecode(v[RoundRecord.Bean.user][User.Bean.nickname]) )
                local owner = v[RoundRecord.Bean.owner]

                local cardCombs = v[RoundRecord.Bean.cardCombs]

                local score = v[RoundRecord.Bean.score]

                local xi = v[RoundRecord.Bean.xi]
                local sumXi = v[RoundRecord.Bean.sumXi]
                local flzScore = v[RoundRecord.Bean.flzScore] -- 胡牌了，超过18硬息，分到溜子分数
                
                local fan = v[RoundRecord.Bean.fan]
                local deng = v[RoundRecord.Bean.deng]
                local mts = v[RoundRecord.Bean.mts]
                local diCards = v[RoundRecord.Bean.diCards]

                local fanRule = v[RoundRecord.Bean.fanRule]
                local fanCard = v[RoundRecord.Bean.fanCard]
                local fanNum = v[RoundRecord.Bean.fanNum]
                local xingCard = v[RoundRecord.Bean.xingCard]

                local _string
                local _size

                if hu or (not isHu and role) then -- 胡牌的人 或者 荒局的时候是房主
                    --Commons:printLog_Info("---",nickname)
                    -- 头像
                    if icon ~= nil and icon ~= "" then
                        self.winOrOwner_view_icon = NetSpriteImg.new(icon, 106, 100) -- 118*116
                            --:setContentSize(cc.size(100,100))
                            :align(display.LEFT_TOP,14+30 +10+6, startY -16-8)
                            :addTo(self.winOrOwner_view_layer)
                        if CVar._static.isIphone4 then
                            -- self.winOrOwner_view_icon:align(display.LEFT_TOP,14+30 +10+6 +moveX, startY -16-8)
                        elseif CVar._static.isIpad then
                            self.winOrOwner_view_icon:align(display.LEFT_TOP,14+30 +10+6 +moveX+15, startY -16-8)
                        end
                    end

                    -- 昵称赋值 
                    if Commons:checkIsNull_str(nickname) then
                        self.winOrOwner_view_nickname:setString(nickname)
                    else
                        self.winOrOwner_view_nickname:setString("")
                    end

                    if owner then
                        self.winOrOwner_view_owner:addTo(self.winOrOwner_view_layer)
                        self.winOrOwner_view_owner:setVisible(true)
                    else
                        self.winOrOwner_view_owner:setVisible(false)                        
                    end

                    if Commons:checkIsNull_tableList(cardCombs) then
                        -- 胡牌列表
                        local needShow_cardCombs  = GameingDealUtil:PageView_FillList_huCards(cardCombs)
                        if Commons:checkIsNull_tableList(needShow_cardCombs) then
                            self.winOrOwner_view_hu_list:removeAllItems()
                            for k_hu,v_hu in pairs(needShow_cardCombs) do
                                --Commons:printLog_Info("--------------", k_hu, v_hu)
                                local isHigh = false
                                if v_hu ~= nil then
                                    local isFindTxt = string.find(tostring(v_hu), "#1")
                                    if isFindTxt ~= nil and isFindTxt ~= -1 then
                                        -- 找到
                                        v_hu = string.gsub(v_hu, "#1", "")
                                        isHigh = true
                                    end
                                end

                                local isOperation = false
                                local optTxt = v_hu
                                if optTxt == ""
                                   or optTxt == CEnum.playOptions.chi or optTxt == CEnum.playOptions.xiahuo
                                   or optTxt == CEnum.playOptions.peng 
                                   or optTxt == CEnum.playOptions.wei or optTxt == CEnum.playOptions.chouwei 
                                   or optTxt == CEnum.playOptions.ti or optTxt == CEnum.playOptions.ti8 
                                   or optTxt == CEnum.playOptions.pao or optTxt == CEnum.playOptions.pao8 
                                   or optTxt == CEnum.playOptions.hu or optTxt == CEnum.playOptions.hu 
                                   or optTxt == CEnum.playOptions.jiang
                                then
                                    isOperation = true
                                end

                                local item = self.winOrOwner_view_hu_list:newItem()
                                local img_vv = GameingDealUtil:getImgByShowHu(v_hu)
                                local content
                                if type(img_vv) == "string" then
                                    if isHigh then
                                        content = 
                                        -- cc.ui.UIImage.new(Imgs.card_bg_kk,{scale9 = false})
                                        --     :setLayoutSize(44, 44)
                                        cc.ui.UIPushButton.new(img_vv, {scale9 = false})
                                                :setButtonSize(42, 42)
                                        cc.ui.UIPushButton.new(Imgs.card_bg_kk, {scale9 = false})
                                                :setButtonSize(47, 46)
                                                :addTo(content)
                                    else
                                        local wh_w = 42
                                        local wh_h = 42
                                        if isOperation then
                                            wh_w = 33 -7
                                            wh_h = 34 -7
                                            if optTxt=="" then
                                                wh_w = 42 -7
                                                wh_h = 34 -7
                                            end
                                        end

                                        content = cc.ui.UIPushButton.new(img_vv, {scale9 = false})
                                                :setButtonSize(wh_w, wh_h)
                                                -- :setButtonLabel(
                                                --  cc.ui.UILabel.new({
                                                --      --text = "点击大小改变" .. i, 
                                                --      text = "", 
                                                --      size = 16, 
                                                --      color = display.COLOR_BLUE
                                                --  })
                                                -- )
                                                --:onButtonPressed(function(event)
                                                --  event.target:getButtonLabel():setColor(display.COLOR_RED)
                                                --end)
                                                --:onButtonRelease(function(event)
                                                --  event.target:getButtonLabel():setColor(display.COLOR_BLUE)
                                                --end)
                                                --:onButtonClicked(function(event)
                                                --  Commons:printLog_Info("UIListView buttonclicked")
                                                --  local w, _ = item:getItemSize()
                                                --  if 60 == w then
                                                --      item:setItemSize(100, 73*3)
                                                --  else
                                                --      item:setItemSize(60, 73*3)
                                                --  end
                                                --end)
                                        --item:setBg("") -- 设置item背景
                                        --item:addChild(content)
                                        --item:setItemSize(42, 42)
                                    end
                                else
                                    if type(img_vv) == "number" and img_vv==0 then
                                        img_vv = ""
                                    end
                                    if CEnum.Environment.gameCode == CEnum.gameType.wmq then
                                        -- 偎麻雀独有：
                                        -- content = cc.ui.UIPushButton.new(Imgs.c_transparent, {scale9 = false})
                                        --         :setButtonSize(42, 42)
                                        --         :setButtonLabel(
                                        --             cc.ui.UILabel.new({
                                        --                 text = img_vv,
                                        --                 font = Fonts.Font_hkyt_w9,
                                        --                 size = Dimens.TextSize_20,
                                        --                 color = Colors:_16ToRGB(Colors.gameing_huxi),
                                        --                 align = cc.ui.TEXT_ALIGN_CENTER,
                                        --                 valign = cc.ui.TEXT_VALIGN_CENTER,
                                        --                 --dimensions = cc.size(100,20)
                                        --              })
                                        --         )
                                        content = cc.ui.UILabel.new({
                                                --text = img_vv,
                                                text = "",
                                                font = Fonts.Font_hkyt_w9,
                                                size = Dimens.TextSize_20,
                                                color = Colors:_16ToRGB(Colors.gameing_huxi),
                                                align = cc.ui.TEXT_ALIGN_CENTER,
                                                valign = cc.ui.TEXT_VALIGN_TOP,
                                                --dimensions = cc.size(100,20)
                                             })
                                    elseif CEnum.Environment.gameCode == CEnum.gameType.chz then
                                        -- 扯胡子独有：
                                        content = cc.ui.UILabel.new({
                                                text = img_vv,
                                                -- text = "",
                                                font = Fonts.Font_hkyt_w9,
                                                size = Dimens.TextSize_20,
                                                color = Colors:_16ToRGB(Colors.gameing_huxi),
                                                align = cc.ui.TEXT_ALIGN_CENTER,
                                                valign = cc.ui.TEXT_VALIGN_TOP,
                                                --dimensions = cc.size(100,20)
                                             })
                                    end
                                end
                                item:addChild(content)
                                self.winOrOwner_view_hu_list:addItem(item) -- 添加item到列表
                            end
                            self.winOrOwner_view_hu_list:reload() -- 重新加载
                        end
                    end


                    -- 1rows
                    if CEnum.Environment.gameCode == CEnum.gameType.wmq then
                        -- 偎麻雀独有：
                        if Commons:checkIsNull_numberType(xi) then
                            -- 硬息
                            _string = tostring(xi)
                            _size = string.len(_string)
                            for i=1,_size do
                                local i_str = string.sub(_string, i, i)
                                local img_i = GameingDealUtil:getNumImg_by_scoreRound(i_str)
                                --cc.ui.UIPushButton.new(img_i,{scale9=false})
                                --    :setButtonSize(20, 20)
                                cc.ui.UIImage.new(img_i,{scale9=false})
                                    :setLayoutSize(30, 30)
                                    :addTo(self.winOrOwner_view_layer)
                                    :align(display.LEFT_TOP, 14+30 +10 +80+27*(i-1) +moveX, startY -16 -116-10 -150 +5 +40)
                            end
                        end
                    elseif CEnum.Environment.gameCode == CEnum.gameType.chz then
                        -- 扯胡子独有：
                        if Commons:checkIsNull_numberType(xi) then
                            -- 胡息
                            _string = tostring(xi)
                            _size = string.len(_string)
                            for i=1,_size do
                                local i_str = string.sub(_string, i, i)
                                local img_i = GameingDealUtil:getNumImg_by_scoreRound(i_str)
                                --cc.ui.UIPushButton.new(img_i,{scale9=false})
                                --    :setButtonSize(20, 20)
                                cc.ui.UIImage.new(img_i,{scale9=false})
                                    :setLayoutSize(30, 30)
                                    :addTo(self.winOrOwner_view_layer)
                                    :align(display.LEFT_TOP, 14+30 +10 +80+27*(i-1) +moveX, startY -16 -116-10 -150 +5 +0)
                            end
                        end
                    end

                    if CEnum.Environment.gameCode == CEnum.gameType.wmq then
                        -- 偎麻雀独有：
                        if Commons:checkIsNull_numberType(sumXi) then
                            -- 总息
                            _string = tostring(sumXi)
                            _size = string.len(_string)
                            for i=1,_size do
                                local i_str = string.sub(_string, i, i)
                                local img_i = GameingDealUtil:getNumImg_by_scoreRound(i_str)
                                --cc.ui.UIPushButton.new(img_i,{scale9=false})
                                --    :setButtonSize(20, 20)
                                cc.ui.UIImage.new(img_i,{scale9=false})
                                    :setLayoutSize(30, 30)
                                    :addTo(self.winOrOwner_view_layer)
                                    :align(display.LEFT_TOP, 14+30 +10 +300 +80+27*(i-1) +moveX, startY -16 -116-10 -150 +5 +40)
                            end
                        end
                    elseif CEnum.Environment.gameCode == CEnum.gameType.chz then
                        -- 扯胡子独有：
                        if Commons:checkIsNull_numberType(fan) then
                            -- 番数
                            _string = tostring(fan)
                            _size = string.len(_string)
                            for i=1,_size do
                                local i_str = string.sub(_string, i, i)
                                local img_i = GameingDealUtil:getNumImg_by_scoreRound(i_str)
                                --cc.ui.UIPushButton.new(img_i,{scale9=false})
                                --    :setButtonSize(20, 20)
                                cc.ui.UIImage.new(img_i,{scale9=false})
                                    :setLayoutSize(30, 30)
                                    :addTo(self.winOrOwner_view_layer)
                                    :align(display.LEFT_TOP, 14+30 +10 +300 +80+27*(i-1) +moveX, startY -16 -116-10 -150 +5 +0)
                            end
                        end
                    end
                    

                    -- 2rows
                    if CEnum.Environment.gameCode == CEnum.gameType.wmq then
                        -- 偎麻雀独有：
                        if Commons:checkIsNull_numberType(score) then
                            -- 分数
                            _string = tostring(score)
                            _size = string.len(_string)
                            for i=1,_size do
                                local i_str = string.sub(_string, i, i)
                                local img_i = GameingDealUtil:getNumImg_by_scoreRound(i_str)
                                --cc.ui.UIPushButton.new(img_i,{scale9=false})
                                --    :setButtonSize(20, 20)
                                cc.ui.UIImage.new(img_i,{scale9=false})
                                    :setLayoutSize(30, 30)
                                    :addTo(self.winOrOwner_view_layer)
                                    :align(display.LEFT_TOP, 14+30 +10 +80+27*(i-1) +moveX, startY -16 -116-10 -150 -40 +30)
                            end
                        end

                        if Commons:checkIsNull_numberType(flzScore) then
                            if flzScore > CEnum.isDlz.noLz then
                                -- 分溜子
                                _string = tostring(flzScore)
                                _size = string.len(_string)
                                for i=1,_size do
                                    local i_str = string.sub(_string, i, i)
                                    local img_i = GameingDealUtil:getNumImg_by_scoreRound(i_str)
                                    --cc.ui.UIPushButton.new(img_i,{scale9=false})
                                    --    :setButtonSize(20, 20)
                                    cc.ui.UIImage.new(img_i,{scale9=false})
                                        :setLayoutSize(30, 30)
                                        :addTo(self.winOrOwner_view_layer)
                                        :align(display.LEFT_TOP, 14+30 +10+300 +80+27*(i-1) +moveX, startY -16 -116-10 -150 -40 +30)
                                end
                                self.winOrOwner_view_flz:show()
                            else
                                self.winOrOwner_view_flz:hide()
                            end
                        else
                            self.winOrOwner_view_flz:hide()
                        end
                    elseif CEnum.Environment.gameCode == CEnum.gameType.chz then
                        -- 扯胡子独有：
                        if Commons:checkIsNull_numberType(score) then
                            -- 分数
                            _string = tostring(score)
                            _size = string.len(_string)
                            for i=1,_size do
                                local i_str = string.sub(_string, i, i)
                                local img_i = GameingDealUtil:getNumImg_by_scoreRound(i_str)
                                --cc.ui.UIPushButton.new(img_i,{scale9=false})
                                --    :setButtonSize(20, 20)
                                cc.ui.UIImage.new(img_i,{scale9=false})
                                    :setLayoutSize(30, 30)
                                    :addTo(self.winOrOwner_view_layer)
                                    :align(display.LEFT_TOP, 14+30 +10 +80+27*(i-1) +moveX, startY -16 -116-10 -150 -40 +0)
                            end
                        end

                        if Commons:checkIsNull_numberType(deng) then
                            -- 等数
                            _string = tostring(deng)
                            _size = string.len(_string)
                            for i=1,_size do
                                local i_str = string.sub(_string, i, i)
                                local img_i = GameingDealUtil:getNumImg_by_scoreRound(i_str)
                                --cc.ui.UIPushButton.new(img_i,{scale9=false})
                                --    :setButtonSize(20, 20)
                                cc.ui.UIImage.new(img_i,{scale9=false})
                                    :setLayoutSize(30, 30)
                                    :addTo(self.winOrOwner_view_layer)
                                    :align(display.LEFT_TOP, 14+30 +10+300 +80+27*(i-1) +moveX, startY -16 -116-10 -150 -40)
                            end
                        end
                    end

                    if CEnum.Environment.gameCode == CEnum.gameType.wmq then
                        -- 偎麻雀独有：
                        -- -- 翻醒或者跟醒的显示
                        -- if Commons:checkIsNull_str(xingCard) then
                        --     -- 文字
                        --     if Commons:checkIsNull_str(fanRule) then
                        --         if fanRule == CEnum.fanRule.fan then
                        --             -- cc.ui.UIImage.new(Imgs.room_3fgx_fan,{scale9=false})
                        --             --     :addTo(self.winOrOwner_view_layer)
                        --             --     :align(display.LEFT_TOP, 14+30 +10+300, startY -16 -116-10 -150 -40 -40)
                        --             display.newTTFLabel({
                        --                     text = "翻醒  ",
                        --                     font = Fonts.Font_hkyt_w7,
                        --                     size = Dimens.TextSize_20,
                        --                     color = Colors:_16ToRGB(Colors.gameing_huxi),
                        --                     align = cc.ui.TEXT_ALIGN_CENTER,
                        --                     valign = cc.ui.TEXT_VALIGN_CENTER,
                        --                     dimensions = cc.size(100,20)
                        --                 })
                        --                 :addTo(self.winOrOwner_view_layer)
                        --                 :align(display.LEFT_TOP, 14+30 +10+300, startY -16 -116-10 -150 -40 -45 +30)
                        --         elseif fanRule == CEnum.fanRule.gen then
                        --             -- cc.ui.UIImage.new(Imgs.room_3fgx_gen,{scale9=false})
                        --             --     :addTo(self.winOrOwner_view_layer)
                        --             --     :align(display.LEFT_TOP, 14+30 +10+300, startY -16 -116-10 -150 -40 -40)
                        --             display.newTTFLabel({
                        --                     text = "跟醒  ",
                        --                     font = Fonts.Font_hkyt_w7,
                        --                     size = Dimens.TextSize_20,
                        --                     color = Colors:_16ToRGB(Colors.gameing_huxi),
                        --                     align = cc.ui.TEXT_ALIGN_CENTER,
                        --                     valign = cc.ui.TEXT_VALIGN_CENTER,
                        --                     dimensions = cc.size(100,20)
                        --                 })
                        --                 :addTo(self.winOrOwner_view_layer)
                        --                 :align(display.LEFT_TOP, 14+30 +10+300, startY -16 -116-10 -150 -40 -45 +30)
                        --         end
                        --     end
                        --     -- 牌
                        --     if Commons:checkIsNull_str(xingCard) then
                        --         local img_vv = GameingDealUtil:getImgByHandcard(CEnum.userCard.out, xingCard)
                        --         cc.ui.UIImage.new(img_vv,{scale9=false})
                        --             :setLayoutSize(42, 42)
                        --             :addTo(self.winOrOwner_view_layer)
                        --             :align(display.LEFT_TOP, 14+30 +10+300 +80, startY -16 -116-10 -150 -40 -36 +30)
                        --     end
                        --     -- 倍数
                        --     if Commons:checkIsNull_numberType(fanNum) then
                        --         -- 先增加一个加号
                        --         if fanNum >= 0 then
                        --             cc.ui.UIImage.new(Imgs.over_nums_scoreRound_jia,{scale9=false})
                        --                 :setLayoutSize(30, 30)
                        --                 :addTo(self.winOrOwner_view_layer)
                        --                 :align(display.LEFT_TOP, 14+30 +10+300 +80 +46, startY -16 -116-10 -150 -40 -40 +30)
                        --         end

                        --         -- 翻醒跟醒的倍数
                        --         _string = tostring(fanNum)
                        --         _size = string.len(_string)
                        --         for i=1,_size do
                        --             local i_str = string.sub(_string, i, i)
                        --             local img_i = GameingDealUtil:getNumImg_by_scoreRound(i_str)
                        --             --cc.ui.UIPushButton.new(img_i,{scale9=false})
                        --             --    :setButtonSize(20, 20)
                        --             if fanNum >= 0 then
                        --                 cc.ui.UIImage.new(img_i,{scale9=false})
                        --                     :setLayoutSize(30, 30)
                        --                     :addTo(self.winOrOwner_view_layer)
                        --                     :align(display.LEFT_TOP, 14+30 +10+300 +80 +46 +25 +25*(i-1), startY -16 -116-10 -150 -40 -40 +30)
                        --             else
                        --                 cc.ui.UIImage.new(img_i,{scale9=false})
                        --                     :setLayoutSize(30, 30)
                        --                     :addTo(self.winOrOwner_view_layer)
                        --                     :align(display.LEFT_TOP, 14+30 +10+300 +80 +46 +0 +25*(i-1), startY -16 -116-10 -150 -40 -40 +30)
                        --             end
                        --         end
                        --     end
                        -- end
                    elseif CEnum.Environment.gameCode == CEnum.gameType.chz then
                        -- 扯胡子独有：
                        -- 翻醒或者跟醒的显示
                        if Commons:checkIsNull_str(xingCard) then
                            -- 文字
                            if Commons:checkIsNull_str(fanRule) then
                                if fanRule == CEnum.fanRule.fan then
                                    -- cc.ui.UIImage.new(Imgs.room_3fgx_fan,{scale9=false})
                                    --     :addTo(self.winOrOwner_view_layer)
                                    --     :align(display.LEFT_TOP, 14+30 +10+300, startY -16 -116-10 -150 -40 -40)
                                    display.newTTFLabel({
                                            text = "翻醒  ",
                                            font = Fonts.Font_hkyt_w7,
                                            size = Dimens.TextSize_20,
                                            color = Colors:_16ToRGB(Colors.gameing_huxi),
                                            align = cc.ui.TEXT_ALIGN_CENTER,
                                            valign = cc.ui.TEXT_VALIGN_CENTER,
                                            dimensions = cc.size(100,20)
                                        })
                                        :addTo(self.winOrOwner_view_layer)
                                        :align(display.LEFT_TOP, 14+30 +10+300 +moveX, startY -16 -116-10 -150 -40 -45 +0)
                                elseif fanRule == CEnum.fanRule.gen then
                                    -- cc.ui.UIImage.new(Imgs.room_3fgx_gen,{scale9=false})
                                    --     :addTo(self.winOrOwner_view_layer)
                                    --     :align(display.LEFT_TOP, 14+30 +10+300, startY -16 -116-10 -150 -40 -40)
                                    display.newTTFLabel({
                                            text = "跟醒  ",
                                            font = Fonts.Font_hkyt_w7,
                                            size = Dimens.TextSize_20,
                                            color = Colors:_16ToRGB(Colors.gameing_huxi),
                                            align = cc.ui.TEXT_ALIGN_CENTER,
                                            valign = cc.ui.TEXT_VALIGN_CENTER,
                                            dimensions = cc.size(100,20)
                                        })
                                        :addTo(self.winOrOwner_view_layer)
                                        :align(display.LEFT_TOP, 14+30 +10+300 +moveX, startY -16 -116-10 -150 -40 -45 +0)
                                end
                            end
                            -- 牌
                            if Commons:checkIsNull_str(xingCard) then
                                local img_vv = GameingDealUtil:getImgByHandcard(CEnum.userCard.out, xingCard)
                                cc.ui.UIImage.new(img_vv,{scale9=false})
                                    :setLayoutSize(42, 42)
                                    :addTo(self.winOrOwner_view_layer)
                                    :align(display.LEFT_TOP, 14+30 +10+300 +80 +moveX, startY -16 -116-10 -150 -40 -36 +0)
                            end
                            -- 倍数
                            if Commons:checkIsNull_numberType(fanNum) then
                                -- 先增加一个加号
                                if fanNum >= 0 then
                                    cc.ui.UIImage.new(Imgs.over_nums_scoreRound_jia,{scale9=false})
                                        :setLayoutSize(30, 30)
                                        :addTo(self.winOrOwner_view_layer)
                                        :align(display.LEFT_TOP, 14+30 +10+300 +80 +46 +moveX, startY -16 -116-10 -150 -40 -40 +0)
                                end

                                -- 翻醒跟醒的倍数
                                _string = tostring(fanNum)
                                _size = string.len(_string)
                                for i=1,_size do
                                    local i_str = string.sub(_string, i, i)
                                    local img_i = GameingDealUtil:getNumImg_by_scoreRound(i_str)
                                    --cc.ui.UIPushButton.new(img_i,{scale9=false})
                                    --    :setButtonSize(20, 20)
                                    if fanNum >= 0 then
                                        cc.ui.UIImage.new(img_i,{scale9=false})
                                            :setLayoutSize(30, 30)
                                            :addTo(self.winOrOwner_view_layer)
                                            :align(display.LEFT_TOP, 14+30 +10+300 +80 +46 +25 +25*(i-1) +moveX, startY -16 -116-10 -150 -40 -40 +0)
                                    else
                                        cc.ui.UIImage.new(img_i,{scale9=false})
                                            :setLayoutSize(30, 30)
                                            :addTo(self.winOrOwner_view_layer)
                                            :align(display.LEFT_TOP, 14+30 +10+300 +80 +46 +0 +25*(i-1) +moveX, startY -16 -116-10 -150 -40 -40 +0)
                                    end
                                end
                            end
                        end
                    end


                    -- 3rows
                    if CEnum.Environment.gameCode == CEnum.gameType.wmq then
                        -- 偎麻雀独有：
                        --名堂列表
                        if Commons:checkIsNull_tableType(mts) then
                            -- 这种是算一个个名堂连接组件方式，变为，直接先连接字符串，放一个组件
                            --[[
                            local size_mt = 0
                            for k_mt,v_mt in pairs(mts) do
                                -- 客户端自己转化名字的做法 
                                --_string = GameingDealUtil:getMtImgByShowTxt(v_mt)

                                -- 后台直接给名称
                                _string = v_mt

                                _size = string.len(_string) / 3
                                --Commons:printLog_Info("_size", k_mt, _size, _string)
                                display.newTTFLabel({
                                        text = _string,
                                        font = Fonts.Font_hkyt_w9,
                                        size = Dimens.TextSize_20,
                                        color = Colors:_16ToRGB(Colors.gameing_huxi),
                                        align = cc.ui.TEXT_ALIGN_CENTER,
                                        valign = cc.ui.TEXT_VALIGN_CENTER,
                                        --dimensions = cc.size(100,20)
                                    })
                                    :addTo(self.winOrOwner_view_layer)
                                    :align(display.LEFT_TOP, 14+30 +10 +75 +24*size_mt +10*k_mt, startY -16 -116-10 -150 -40 -50 +20)
                                size_mt = size_mt + _size
                            end
                            --]]

                            _string = ""
                            for k_mt,v_mt in pairs(mts) do
                                -- 后台直接给名称
                                _string = _string .. v_mt .. " "
                            end
                            display.newTTFLabel({
                                    text = _string,
                                    font = Fonts.Font_hkyt_w9,
                                    size = Dimens.TextSize_20,
                                    color = Colors:_16ToRGB(Colors.gameing_huxi),
                                    align = cc.ui.TEXT_ALIGN_LEFT,
                                    valign = cc.ui.TEXT_VALIGN_CENTER,
                                    dimensions = cc.size( (osWidth-160*2)/2, 0)
                                })
                                :addTo(self.winOrOwner_view_layer)
                                :align(display.LEFT_TOP, 14+30 +10 +75 +3 +moveX, startY -16 -116-10 -150 -40 -50 +20)
                        end
                    elseif CEnum.Environment.gameCode == CEnum.gameType.chz then
                        -- 扯胡子独有：
                        --名堂列表
                        if Commons:checkIsNull_tableType(mts) then
                            _string = ""
                            for k_mt,v_mt in pairs(mts) do
                                -- 后台直接给名称
                                _string = _string .. v_mt .. " "
                            end
                            display.newTTFLabel({
                                    text = _string,
                                    font = Fonts.Font_hkyt_w9,
                                    size = Dimens.TextSize_20,
                                    color = Colors:_16ToRGB(Colors.gameing_huxi),
                                    align = cc.ui.TEXT_ALIGN_LEFT,
                                    valign = cc.ui.TEXT_VALIGN_CENTER,
                                    dimensions = cc.size( (osWidth-160*2)/2, 0)
                                })
                                :addTo(self.winOrOwner_view_layer)
                                :align(display.LEFT_TOP, 14+30 +10 +75 +3 +moveX, startY -16 -116-10 -150 -40 -50 +0)
                        end
                    end
                    

                    -- 4rows
                    --底牌列表
                    -- add items
                    if Commons:checkIsNull_tableType(diCards) then
                        self.winOrOwner_view_dcard_list:removeAllItems();
                        for k_di,v_di in pairs(diCards) do
                            local item = self.winOrOwner_view_dcard_list:newItem()
                            local img_vv = GameingDealUtil:getImgByHandcard(CEnum.userCard.out, v_di)
                            local content = cc.ui.UIPushButton.new(img_vv, {scale9 = false})
                                    :setButtonSize(36, 36)
                                    -- :setButtonLabel(
                                    --  cc.ui.UILabel.new({
                                    --      --text = "点击大小改变" .. i, 
                                    --      text = "", 
                                    --      size = 16, 
                                    --      color = display.COLOR_BLUE
                                    --  })
                                    -- )
                                    --:onButtonPressed(function(event)
                                    --  event.target:getButtonLabel():setColor(display.COLOR_RED)
                                    --end)
                                    --:onButtonRelease(function(event)
                                    --  event.target:getButtonLabel():setColor(display.COLOR_BLUE)
                                    --end)
                                    --:onButtonClicked(function(event)
                                    --  Commons:printLog_Info("UIListView buttonclicked")
                                    --  local w, _ = item:getItemSize()
                                    --  if 60 == w then
                                    --      item:setItemSize(100, 73*3)
                                    --  else
                                    --      item:setItemSize(60, 73*3)
                                    --  end
                                    --end)
                            --item:setBg("") -- 设置item背景
                            item:addChild(content)
                            --item:setItemSize(42, 42)
                            self.winOrOwner_view_dcard_list:addItem(item) -- 添加item到列表
                        end
                        self.winOrOwner_view_dcard_list:reload() -- 重新加载
                        if #diCards > 11 then
                            if CEnum.Environment.gameCode == CEnum.gameType.wmq then
                                -- 偎麻雀独有：
                                self.winOrOwner_view_dcard_list:align(display.LEFT_TOP, 14+30 +10 +80 +moveX, startY -16 -116-10 -150 -40 -50 -50 -70 +10) -- 1行=-80 2行=-70
                            elseif CEnum.Environment.gameCode == CEnum.gameType.chz then
                                -- 扯胡子独有：
                                self.winOrOwner_view_dcard_list:align(display.LEFT_TOP, 14+30 +10 +80 +moveX, startY -16 -116-10 -150 -40 -50 -50 -70 +0) -- 1行=-80 2行=-70
                            end
                        end
                    end

                elseif ii==0 then
                    ii = k
                    -- 头像
                    if icon ~= nil and icon ~= "" then
                        self.R_view_icon = NetSpriteImg.new(icon, 106, 100) -- 118*116
                            --:setContentSize(cc.size(100,100))
                            --:pos(8+106/2+6,osHeight-8-100/2-8)
                            :align(display.LEFT_TOP,14+30 +10+6 +startX_R, startY -16-8)
                            :addTo(self.R_view_layer)
                    end

                    -- 昵称赋值 
                    if Commons:checkIsNull_str(nickname) then
                        self.R_view_nickname:setString(nickname)
                    else
                        self.R_view_nickname:setString("")
                    end

                    if owner then
                        self.R_view_owner:addTo(self.R_view_layer)
                        self.R_view_owner:setVisible(true)
                    else
                        self.R_view_owner:setVisible(false)                        
                    end

                    if Commons:checkIsNull_tableList(cardCombs) then
                        -- 胡牌列表
                        local needShow_cardCombs  = GameingDealUtil:PageView_FillList_huCards(cardCombs)
                        self.R_view_hu_list:removeAllItems()
                        if Commons:checkIsNull_tableList(needShow_cardCombs) then
                            for k_hu,v_hu in pairs(needShow_cardCombs) do
                                local isHigh = false
                                if v_hu ~= nil then
                                    local isFindTxt = string.find(tostring(v_hu), "#1")
                                    if isFindTxt ~= nil and isFindTxt ~= -1 then
                                        -- 找到
                                        v_hu = string.gsub(v_hu, "#1", "")
                                        isHigh = true
                                    end
                                end

                                local isOperation = false
                                local optTxt = v_hu
                                if optTxt == ""
                                   or optTxt == CEnum.playOptions.chi or optTxt == CEnum.playOptions.xiahuo
                                   or optTxt == CEnum.playOptions.peng 
                                   or optTxt == CEnum.playOptions.wei or optTxt == CEnum.playOptions.chouwei 
                                   or optTxt == CEnum.playOptions.ti or optTxt == CEnum.playOptions.ti8 
                                   or optTxt == CEnum.playOptions.pao or optTxt == CEnum.playOptions.pao8 
                                   or optTxt == CEnum.playOptions.hu or optTxt == CEnum.playOptions.hu 
                                   or optTxt == CEnum.playOptions.jiang
                                then
                                    isOperation = true
                                end

                                local item = self.R_view_hu_list:newItem()
                                local img_vv = GameingDealUtil:getImgByShowHu(v_hu)
                                local content
                                if type(img_vv) == "string" then
                                    if isHigh then
                                        content = 
                                        -- cc.ui.UIImage.new(Imgs.card_bg_kk,{scale9 = false})
                                        --     :setLayoutSize(44, 44)
                                        cc.ui.UIPushButton.new(img_vv, {scale9 = false})
                                                :setButtonSize(42, 42)
                                        cc.ui.UIPushButton.new(Imgs.card_bg_kk, {scale9 = false})
                                                :setButtonSize(47, 46)
                                                :addTo(content)
                                    else
                                        local wh_w = 42
                                        local wh_h = 42
                                        if isOperation then
                                            wh_w = 33 -7
                                            wh_h = 34 -7
                                            if optTxt=="" then
                                                wh_w = 42 -7
                                                wh_h = 34 -7
                                            end
                                        end

                                        content = cc.ui.UIPushButton.new(img_vv, {scale9 = false})
                                                :setButtonSize(wh_w, wh_h)
                                    end
                                else
                                    if type(img_vv) == "number" and img_vv==0 then
                                        img_vv = ""
                                    end
                                    -- content = cc.ui.UIPushButton.new(Imgs.c_transparent, {scale9 = false})
                                    --         :setButtonSize(42, 42)
                                    --         :setButtonLabel(
                                    --             cc.ui.UILabel.new({
                                    --                 text = img_vv,
                                    --                 font = Fonts.Font_hkyt_w9,
                                    --                 size = Dimens.TextSize_20,
                                    --                 color = Colors:_16ToRGB(Colors.gameing_huxi),
                                    --                 align = cc.ui.TEXT_ALIGN_CENTER,
                                    --                 valign = cc.ui.TEXT_VALIGN_CENTER,
                                    --                 --dimensions = cc.size(100,20)
                                    --              })
                                    --         )
                                    content = cc.ui.UILabel.new({
                                                    --text = img_vv,
                                                    text = "",
                                                    font = Fonts.Font_hkyt_w9,
                                                    size = Dimens.TextSize_20,
                                                    color = Colors:_16ToRGB(Colors.gameing_huxi),
                                                    align = cc.ui.TEXT_ALIGN_CENTER,
                                                    valign = cc.ui.TEXT_VALIGN_TOP,
                                                    --dimensions = cc.size(100,20)
                                                 })
                                end
                                item:addChild(content)
                                self.R_view_hu_list:addItem(item) -- 添加item到列表
                            end
                            self.R_view_hu_list:reload() -- 重新加载
                        end
                    end

                    if Commons:checkIsNull_numberType(xi) then
                        -- 胡息
                        _string = tostring(xi)
                        _size = string.len(_string)
                        for i=1,_size do
                            local i_str = string.sub(_string, i, i)
                            local img_i = GameingDealUtil:getNumImg_by_scoreRound(i_str)
                            --cc.ui.UIPushButton.new(img_i,{scale9=false})
                            --    :setButtonSize(20, 20)
                            cc.ui.UIPushButton.new(img_i,{scale9=false})
                                :setButtonSize(18, 18)
                                :addTo(self.R_view_layer)
                                :align(display.LEFT_TOP, 14+10 +10 +startX_R +75+16*(i-1), startY -16 -116 -52)
                        end
                    end

                    if Commons:checkIsNull_numberType(score) then
                        -- 分数
                        _string = tostring(score)
                        _size = string.len(_string)
                        for i=1,_size do
                            local i_str = string.sub(_string, i, i)
                            local img_i = GameingDealUtil:getNumImg_by_scoreRound(i_str)
                            --cc.ui.UIPushButton.new(img_i,{scale9=false})
                            --    :setButtonSize(20, 20)
                            cc.ui.UIPushButton.new(img_i,{scale9=false})
                                :setButtonSize(18, 18)
                                :addTo(self.R_view_layer)
                                :align(display.LEFT_TOP, 14+10 +10 +startX_R +75+16*(i-1), startY -16 -116 -52-30)
                        end
                    end
                    -- if elseif

                else
                    -- 头像
                    if icon ~= nil and icon ~= "" then
                        self.L_view_icon = NetSpriteImg.new(icon, 106, 100) -- 118*116
                            --:setContentSize(cc.size(100,100))
                            --:pos(8+106/2+6,osHeight-8-100/2-8)
                            :align(display.LEFT_TOP,14+30 +10+6 +startX_R, startY -16-8 -508/2-3)
                            :addTo(self.L_view_layer)
                    end

                    -- 昵称赋值 
                    if Commons:checkIsNull_str(nickname) then
                        self.L_view_nickname:setString(nickname)
                    else
                        self.L_view_nickname:setString(" ")
                    end

                    if owner then
                        self.L_view_owner:addTo(self.R_view_layer)
                        self.L_view_owner:setVisible(true)
                    else
                        self.L_view_owner:setVisible(false)                        
                    end

                    if Commons:checkIsNull_tableList(cardCombs) then
                        -- 胡牌列表
                        local needShow_cardCombs  = GameingDealUtil:PageView_FillList_huCards(cardCombs)
                        self.L_view_hu_list:removeAllItems()
                        if Commons:checkIsNull_tableList(needShow_cardCombs) then
                            for k_hu,v_hu in pairs(needShow_cardCombs) do
                                local isHigh = false
                                if v_hu ~= nil then
                                    local isFindTxt = string.find(tostring(v_hu), "#1")
                                    if isFindTxt ~= nil and isFindTxt ~= -1 then
                                        -- 找到
                                        v_hu = string.gsub(v_hu, "#1", "")
                                        isHigh = true
                                    end
                                end

                                local isOperation = false
                                local optTxt = v_hu
                                if optTxt == ""
                                   or optTxt == CEnum.playOptions.chi or optTxt == CEnum.playOptions.xiahuo
                                   or optTxt == CEnum.playOptions.peng 
                                   or optTxt == CEnum.playOptions.wei or optTxt == CEnum.playOptions.chouwei 
                                   or optTxt == CEnum.playOptions.ti or optTxt == CEnum.playOptions.ti8 
                                   or optTxt == CEnum.playOptions.pao or optTxt == CEnum.playOptions.pao8 
                                   or optTxt == CEnum.playOptions.hu or optTxt == CEnum.playOptions.hu 
                                   or optTxt == CEnum.playOptions.jiang
                                then
                                    isOperation = true
                                end

                                local item = self.L_view_hu_list:newItem()
                                local img_vv = GameingDealUtil:getImgByShowHu(v_hu)
                                local content
                                if type(img_vv) == "string" then
                                    if isHigh then
                                        content = 
                                        -- cc.ui.UIImage.new(Imgs.card_bg_kk,{scale9 = false})
                                        --     :setLayoutSize(44, 44)
                                        cc.ui.UIPushButton.new(img_vv, {scale9 = false})
                                                :setButtonSize(42, 42)
                                        cc.ui.UIPushButton.new(Imgs.card_bg_kk, {scale9 = false})
                                                :setButtonSize(47, 46)
                                                :addTo(content)
                                    else
                                        local wh_w = 42
                                        local wh_h = 42
                                        if isOperation then
                                            wh_w = 33 -7
                                            wh_h = 34 -7
                                            if optTxt=="" then
                                                wh_w = 42 -7
                                                wh_h = 34 -7
                                            end
                                        end

                                        content = cc.ui.UIPushButton.new(img_vv, {scale9 = false})
                                                :setButtonSize(wh_w, wh_h)
                                    end
                                else
                                    if type(img_vv) == "number" and img_vv==0 then
                                        img_vv = ""
                                    end
                                    -- content = cc.ui.UIPushButton.new(Imgs.c_transparent, {scale9 = false})
                                    --         :setButtonSize(42, 42)
                                    --         :setButtonLabel(
                                    --             cc.ui.UILabel.new({
                                    --                 text = img_vv,
                                    --                 font = Fonts.Font_hkyt_w9,
                                    --                 size = Dimens.TextSize_20,
                                    --                 color = Colors:_16ToRGB(Colors.gameing_huxi),
                                    --                 align = cc.ui.TEXT_ALIGN_CENTER,
                                    --                 valign = cc.ui.TEXT_VALIGN_CENTER,
                                    --                 --dimensions = cc.size(100,20)
                                    --              })
                                    --         )
                                    content = cc.ui.UILabel.new({
                                                    --text = img_vv,
                                                    text = "",
                                                    font = Fonts.Font_hkyt_w9,
                                                    size = Dimens.TextSize_20,
                                                    color = Colors:_16ToRGB(Colors.gameing_huxi),
                                                    align = cc.ui.TEXT_ALIGN_CENTER,
                                                    valign = cc.ui.TEXT_VALIGN_TOP,
                                                    --dimensions = cc.size(100,20)
                                                 })
                                end
                                item:addChild(content)
                                self.L_view_hu_list:addItem(item) -- 添加item到列表
                            end
                            self.L_view_hu_list:reload() -- 重新加载
                        end
                    end

                    if Commons:checkIsNull_numberType(xi) then
                        -- 胡息
                        _string = tostring(xi)
                        _size = string.len(_string)
                        for i=1,_size do
                            local i_str = string.sub(_string, i, i)
                            local img_i = GameingDealUtil:getNumImg_by_scoreRound(i_str)
                            --cc.ui.UIPushButton.new(img_i,{scale9=false})
                            --    :setButtonSize(20, 20)
                            cc.ui.UIPushButton.new(img_i,{scale9=false})
                                :setButtonSize(18, 18)
                                :addTo(self.L_view_layer)
                                --:align(display.LEFT_TOP, 14+30 +10 +608 +75+14*(i-1), startY -16 -116-10 -55)
                                :align(display.LEFT_TOP, 14+10 +10 +startX_R +75+16*(i-1), startY -16 -116 -50 -508/2-3)
                        end
                    end

                    if Commons:checkIsNull_numberType(score) then
                        -- 分数
                        _string = tostring(score)
                        _size = string.len(_string)
                        for i=1,_size do
                            local i_str = string.sub(_string, i, i)
                            local img_i = GameingDealUtil:getNumImg_by_scoreRound(i_str)
                            --cc.ui.UIPushButton.new(img_i,{scale9=false})
                            --    :setButtonSize(20, 20)
                            cc.ui.UIPushButton.new(img_i,{scale9=false})
                                :setButtonSize(18, 18)
                                :addTo(self.L_view_layer)
                                --:align(display.LEFT_TOP, 14+30 +10 +608 +75+14*(i-1), startY -16 -116-10 -55-30)
                                :align(display.LEFT_TOP, 14+10 +10 +startX_R +75+16*(i-1), startY -16 -116 -50 -30 -508/2-3)
                        end
                    end
                    -- else

                end -- if me
            end -- for roundRecord
        end -- if roundRecord~=nil
    end
end

function GameingOverRoundDialog:onExit()
    self:myExit()
end

function GameingOverRoundDialog:myExit()

    myself_view_btn_Prepare = nil

    if self.view_title_logo ~= nil and (not tolua.isnull(self.view_title_logo)) then
        self.view_title_logo:removeFromParent()
        self.view_title_logo = nil
    end
    if self.view_btn_back ~= nil and (not tolua.isnull(self.view_btn_back)) then
        self.view_btn_back:removeFromParent()
        self.view_btn_back = nil
    end
    if self.view_btn_submit ~= nil and (not tolua.isnull(self.view_btn_submit)) then
        self.view_btn_submit:removeFromParent()
        self.view_btn_submit = nil
    end
    if self.view_btn_changeto ~= nil and (not tolua.isnull(self.view_btn_changeto)) then
        self.view_btn_changeto:removeFromParent() 
        self.view_btn_changeto = nil
    end

    if self.winOrOwner_view_layer ~= nil and (not tolua.isnull(self.winOrOwner_view_layer)) then
        self.winOrOwner_view_layer:removeFromParent()
        self.winOrOwner_view_layer = nil
    end

    if self.R_view_layer ~= nil and (not tolua.isnull(self.R_view_layer)) then
        self.R_view_layer:removeFromParent()
        self.R_view_layer = nil
    end

    if self.L_view_layer ~= nil and (not tolua.isnull(self.L_view_layer)) then
        self.L_view_layer:removeFromParent()
        self.L_view_layer = nil
    end

    if self.pop_window ~= nil and (not tolua.isnull(self.pop_window)) then
        self.pop_window:removeFromParent()
        self.pop_window = nil
    end
end

return GameingOverRoundDialog
