--
-- Author: luobinbin
-- Date: 2017-07-17 12:40:33
-- 创建房间

-- 类申明
local PlayerRoomRecordDialog = class("PlayerRoomRecordDialog",
	function()
		return display.newNode()
	end
)

local osWidth = Commons.osWidth
local osHeight = Commons.osHeight

function PlayerRoomRecordDialog:ctor()
    --手牌缩放系数
    self.roomScaleFact = 1
    self.contentHeight_y = 0
    self.roomNum_y = 0

    if CVar._static.isIphone4 then
        self.roomScaleFact = 0.82
        self.contentHeight_y = 70
        self.roomNum_y = 40
    elseif CVar._static.isIpad then
        self.roomScaleFact = 0.74
        self.contentHeight_y = 100
        self.roomNum_y = 50
    elseif CVar._static.NavBarH_Android ~= CEnum.status.NavBarH_def then
        self.roomScaleFact = 0.92
    end
end

function PlayerRoomRecordDialog:initLayer(res_data)

    self.pop_window = display.newColorLayer(cc.c4b(0, 0, 0, 180))       -- 半透明的黑色
    self.pop_window:setContentSize(osWidth, osHeight)             -- 设置Layer的大小,全屏出现
    self.pop_window:setTouchEnabled(true)
    self.pop_window:setTouchSwallowEnabled(true)  -- 吞噬下层的响应
    self.pop_window:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event) -- 点击此Layer时候输出信息,然后把自己销毁
        return true
    end)
    self.pop_window:addTo(self)

    self.roomNo_Room = ""

    -- 整个底色背景
    self.content_ = cc.ui.UIImage.new(ImgsM.overBg,{scale9 = true})
        :addTo(self.pop_window)
        :align(display.CENTER, display.cx, display.cy)
        :setLayoutSize(osWidth, osHeight-110*2-self.contentHeight_y)

    -- 关闭
    -- local closeBtn = 
    cc.ui.UIPushButton.new(Imgs.dialog_exit,{scale9=false})
        :setButtonImage(EnStatus.pressed, Imgs.dialog_exit_press)
        :onButtonClicked(function(e)

            VoiceDealUtil:playSound_other(Voices.file.ui_click)
            CommonsM:gotoMJHome()

        end)
        :addTo(self.pop_window)
        :align(display.RIGHT_TOP, display.right-50 -CVar._static.NavBarH_Android, display.top -50 -self.roomNum_y)

    if res_data ~= nil then

        self.roomNo_Room = res_data[Room.Bean.roomNo]
        
        local room = res_data--[User.Bean.room]
        local roomNo = room[Room.Bean.roomNo]
        local playRound = room[Room.Bean.playRound]
        local rounds = room[Room.Bean.rounds]


        -- display.newTTFLabel({
        --         text = "中码",
        --         size = Dimens.TextSize_25,
        --         color = Colors:_16ToRGB(Colors.white),
        --         font = Fonts.Font_hkyt_w7,
        --         align = cc.ui.TEXT_ALIGN_LEFT,
        --         valign = cc.ui.TEXT_VALIGN_CENTER,
        --         })
        --         :addTo(self.pop_window)
        --         :align(display.LEFT_BOTTOM, 28, 43)

        if Commons:checkIsNull_str(roomNo) then
            display.newTTFLabel({
                text = "房号：",
                size = Dimens.TextSize_25,
                color = Colors.white,
                -- color = Colors:_16ToRGB(Colors.white),
                font = Fonts.Font_hkyt_w7,
                align = cc.ui.TEXT_ALIGN_LEFT,
                valign = cc.ui.TEXT_VALIGN_CENTER,
                })
                :addTo(self.pop_window)
                :align(display.LEFT_TOP, 20, osHeight-50-self.roomNum_y)
                :setString("房号："..roomNo)
        end

        -- if Commons:checkIsNull_numberType(playRound) then
        --     display.newTTFLabel({
        --         text = "局数：",
        --         size = Dimens.TextSize_25,
        --         color = Colors:_16ToRGB(Colors.white),
        --         font = Fonts.Font_hkyt_w7,
        --         align = cc.ui.TEXT_ALIGN_LEFT,
        --         valign = cc.ui.TEXT_VALIGN_CENTER,
        --         })
        --         :addTo(self.pop_window)
        --         :align(display.LEFT_TOP, 20, osHeight-80)
        --         :setString("局："..playRound.."/"..rounds)
        -- end

        -- 当前手机时间
        local myDate = os.date("%Y-%m-%d %H:%M:%S") -- "%Y-%m-%d %H:%M:%S"
        view_roomTime = cc.ui.UILabel.new({
                UILabelType = 2,
                text = myDate,
                font = Fonts.Font_hkyt_w7,
                size = Dimens.TextSize_20,
                color = Colors.white,
                -- color = Colors:_16ToRGB(Colors.gameing_huxi),
                align = cc.ui.TEXT_ALIGN_LEFT,
                valign = cc.ui.TEXT_VALIGN_CENTER,
                -- dimensions = cc.size(280,25),
                --maxLineWidth = 118,
            })
            :addTo(self.pop_window)
            :align(display.LEFT_TOP, 20, osHeight-85-self.roomNum_y)

        --分享按钮
        self.shareBtn = cc.ui.UIPushButton.new(
            ImgsM.share,{scale9=false})
            :setButtonSize(242, 85)
            :setButtonImage(EnStatus.pressed, ImgsM.share)
            :onButtonClicked(function(e)
                VoiceDealUtil:playSound_other(Voices.file.ui_click)
                self:myShareConfim()
            end)
            :align(display.CENTER_BOTTOM, display.cx, 16+self.roomNum_y)
            :addTo(self.pop_window, 20)

        if CVar._static.appstoreSwitch == CEnum.appstoreSwitch.open then
            self.shareBtn:setVisible(true)
        else
            self.shareBtn:setVisible(false)
        end

        local successImage = cc.ui.UIImage.new(ImgsM.jieSuan,{scale9 = false})
                :addTo(self.pop_window, 10)
                :align(display.CENTER_BOTTOM, display.cx, display.top-120-self.roomNum_y)

        local isFlagHu = false

        local disOffset = 305*self.roomScaleFact
        local roomRecords = room[Room.Bean.roomRecord]
        for i=1,#roomRecords do
            local tempObj = roomRecords[i]
            local userInfo = tempObj[RoomRecord.Bean.user]
            local bgStr = ImgsM.gameOverNorBg
            local recordColor = Colors.roomRecordName01
            local totalScoreColor = Colors.roomRecordScore01
            if tempObj.winner then
                bgStr = ImgsM.gameOverNorWin
                recordColor = Colors.roomRecord01
                totalScoreColor = Colors.roomRecordScore02
            end

            local scoreBg = cc.ui.UIImage.new(bgStr,{scale9 = false})
                :setLayoutSize(272, 412)
                :align(display.LEFT_BOTTOM, 48 + disOffset * (i - 1) , 24)
                :addTo(self.content_)
                :setScale(self.roomScaleFact)

            local contentSpriteSize = scoreBg:getContentSize()

            -- local scoreBorder = cc.ui.UIImage.new(ImgsM.scoreBorder,{scale9 = true}):setLayoutSize(275, 223)
            --     :addTo(scoreBg)
            --     :align(display.LEFT_BOTTOM, 0, 84)

            -- 头像框
            local heardBoder = cc.ui.UIPushButton.new(ImgsM.heard_border,{scale9=false})
                :align(display.LEFT_BOTTOM, 24, 312)
                :addTo(scoreBg)
                
            if userInfo.icon ~= nil and userInfo.icon ~= "" then
                local heardIcon = NetSpriteImg.new(RequestBase:new():getStrDecode(userInfo.icon), 76, 80)
                    :align(display.LEFT_BOTTOM, 30, 322)
                    :addTo(scoreBg)
            end

            if tempObj.owner then
                local roomMain = display.newSprite(ImgsM.roomMain)
                :addTo(scoreBg)
                :align(display.LEFT_TOP, 0, 413)
            end

            if tempObj.bigWinner then
                cc.ui.UIImage.new(ImgsM.bgwinner,{scale9 = false})
                    :align(display.CENTER_BOTTOM, scoreBg:getContentSize().width * 0.5 , 397)
                    :addTo(scoreBg)
            end

            if tempObj.winner then
                cc.ui.UIImage.new(ImgsM.winner,{scale9 = false})
                    :align(display.LEFT_BOTTOM, 231 , 55)
                    :addTo(scoreBg)
            end
            
            -- 昵称
            local nickNameLabel = display.newTTFLabel({
                    text = Commons:trim(RequestBase:getStrDecode(userInfo.nickname)),
                    font = Fonts.Font_hkyt_w7,
                    size = Dimens.TextSize_22,
                    color = Colors:_16ToRGB(recordColor),
                    align = cc.ui.TEXT_ALIGN_LEFT,
                    valign = cc.ui.TEXT_VALIGN_CENTER,
                    dimensions = cc.size(120,25)
                })
                :addTo(scoreBg, 20)
                :align(display.LEFT_BOTTOM, 117, 360)

            -- ID
            local account = display.newTTFLabel({
                    text = Commons:trim(RequestBase:getStrDecode(userInfo.account)),
                    font = Fonts.Font_hkyt_w7,
                    size = Dimens.TextSize_22,
                    color = Colors:_16ToRGB(recordColor),
                    align = cc.ui.TEXT_ALIGN_LEFT,
                    valign = cc.ui.TEXT_VALIGN_CENTER,
                    dimensions = cc.size(120,25)
                })
                :addTo(scoreBg, 20)
                :align(display.LEFT_BOTTOM, 117, 332)

            local totalScore = display.newTTFLabel({
                    text = tempObj.score,
                    font = Fonts.Font_hkyt_w9,
                    size = Dimens.TextSize_70,
                    color = Colors:_16ToRGB(totalScoreColor),
                    align = cc.ui.TEXT_VALIGN_CENTER,
                    valign = cc.ui.TEXT_VALIGN_CENTER,
                    --dimensions = cc.size(120,25)
                })
                :addTo(scoreBg, 20)
                :align(display.CENTER_BOTTOM, 138, 5)

            display.newTTFLabel({
                    text = "明杠次数",
                    font = Fonts.Font_hkyt_w7,
                    size = Dimens.TextSize_22,
                    color = Colors:_16ToRGB(recordColor),
                    align = cc.ui.TEXT_ALIGN_LEFT,
                    valign = cc.ui.TEXT_VALIGN_CENTER,
                    dimensions = cc.size(120,25)
                    })
                :addTo(scoreBg)
                :align(display.LEFT_BOTTOM, 24, 260)

            local ggTimes = display.newTTFLabel({
                    text = tempObj.ggTimes,
                    font = Fonts.Font_hkyt_w7,
                    size = Dimens.TextSize_22,
                    color = Colors:_16ToRGB(recordColor),
                    align = cc.ui.TEXT_VALIGN_LEFT,
                    valign = cc.ui.TEXT_VALIGN_CENTER,
                    dimensions = cc.size(120,25)
                })
                :addTo(scoreBg, 20)
                :align(display.LEFT_BOTTOM, 230, 260)

            display.newTTFLabel({
                    text = "暗杠次数",
                    font = Fonts.Font_hkyt_w7,
                    size = Dimens.TextSize_22,
                    color = Colors:_16ToRGB(recordColor),
                    align = cc.ui.TEXT_ALIGN_LEFT,
                    valign = cc.ui.TEXT_VALIGN_CENTER,
                    dimensions = cc.size(120,25)
                    })
                :addTo(scoreBg)
                :align(display.LEFT_BOTTOM, 24, 260 - 38)

            local agTimes = display.newTTFLabel({
                    text = tempObj.agTimes,
                    font = Fonts.Font_hkyt_w7,
                    size = Dimens.TextSize_22,
                    color = Colors:_16ToRGB(recordColor),
                    align = cc.ui.TEXT_VALIGN_LEFT,
                    valign = cc.ui.TEXT_VALIGN_CENTER,
                    dimensions = cc.size(120,25)
                })
                :addTo(scoreBg, 20)
                :align(display.LEFT_BOTTOM, 230, 260 - 38)

            display.newTTFLabel({
                    text = "放杠次数",
                    font = Fonts.Font_hkyt_w7,
                    size = Dimens.TextSize_22,
                    color = Colors:_16ToRGB(recordColor),
                    align = cc.ui.TEXT_ALIGN_LEFT,
                    valign = cc.ui.TEXT_VALIGN_CENTER,
                    dimensions = cc.size(120,25)
                    })
                :addTo(scoreBg)
                :align(display.LEFT_BOTTOM, 24, 260 - 38 * 2)

            local fgTimes = display.newTTFLabel({
                    text = tempObj.fgTimes,
                    font = Fonts.Font_hkyt_w7,
                    size = Dimens.TextSize_22,
                    color = Colors:_16ToRGB(recordColor),
                    align = cc.ui.TEXT_VALIGN_LEFT,
                    valign = cc.ui.TEXT_VALIGN_CENTER,
                    dimensions = cc.size(120,25)
                })
                :addTo(scoreBg, 20)
                :align(display.LEFT_BOTTOM, 230, 260 - 38 * 2)

            display.newTTFLabel({
                    text = "胡牌次数",
                    font = Fonts.Font_hkyt_w7,
                    size = Dimens.TextSize_22,
                    color = Colors:_16ToRGB(recordColor),
                    align = cc.ui.TEXT_ALIGN_LEFT,
                    valign = cc.ui.TEXT_VALIGN_CENTER,
                    dimensions = cc.size(120,25)
                    })
                :addTo(scoreBg)
                :align(display.LEFT_BOTTOM, 24, 260 - 38 * 3)

            local huTimes = display.newTTFLabel({
                    text = tempObj.huTimes,
                    font = Fonts.Font_hkyt_w7,
                    size = Dimens.TextSize_22,
                    color = Colors:_16ToRGB(recordColor),
                    align = cc.ui.TEXT_VALIGN_LEFT,
                    valign = cc.ui.TEXT_VALIGN_CENTER,
                    dimensions = cc.size(120,25)
                })
                :addTo(scoreBg, 20)
                :align(display.LEFT_BOTTOM, 230, 260 - 38 * 3)

        end
    end
end

function PlayerRoomRecordDialog:myShareConfim()
    self.shareBtn:setButtonEnabled(false)
    self:performWithDelay(function () 
           self.shareBtn:setButtonEnabled(true)
    end, 1.0)

    local function GameingOverRoomDialog_upLoadImgBack(server_url)
        Commons:printLog_Info("上传文件完成之后的远程地址是：", server_url)
        Commons:gotoShareWX_Img(server_url)
    end
    CutScreenUtil:cutScreen(GameingOverRoomDialog_upLoadImgBack, self, true, self.roomNo_Room)
end

function PlayerRoomRecordDialog:onExit()
end

return PlayerRoomRecordDialog