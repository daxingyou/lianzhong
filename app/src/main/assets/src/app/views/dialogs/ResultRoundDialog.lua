--
-- Author: lte
-- Date: 2016-11-05 18:41:34
-- 房间战绩

-- 类申明
local ResultRoundDialog = class("ResultRoundDialog"
    ,function()
        return display.newNode()
    end
    )


local osWidth = Commons.osWidth
local osHeight = Commons.osHeight

local gaping_w -- 整个图层的左右间距
local gaping_h -- 整个图层的上下间距
local gaping_x -- 内容背景，左右 底部 间距
local gaping_y -- 内容背景，顶部间距

-- function ResultRoundDialog:ctor()
-- end

-- 创建一个模态弹出框,  parent=要加在哪个上面
function ResultRoundDialog:popDialogBox(_parent, _roomNo, _fromOther)
-- function ResultRoundDialog:ctor(_roomNo, _fromOther)

    self.parent = _parent
    self.roomNo = _roomNo
    self.fromOther = _fromOther

    self.pop_window = display.newColorLayer(cc.c4b(0, 0, 0, 200))       -- 半透明的黑色

    self.pop_window:setContentSize(osWidth, osHeight)             -- 设置Layer的大小,全屏出现
    --self.pop_window:align(display.CENTER, display.cx, display.cy) -- Layer的锚点在0.5,0.5 因此对齐的时候要注意
    self.pop_window:setTouchEnabled(true)
    self.pop_window:setTouchSwallowEnabled(true)  -- 吞噬下层的响应
    self.pop_window:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event) -- 点击此Layer时候输出信息,然后把自己销毁
        return true
    end)
    self.parent:addChild(self.pop_window, CEnum.ZOrder.common_dialog) -- 把Layer添加到父对象上

    poper_window = self.pop_window


    gaping_w = 20
    gaping_h = 20
    gaping_x = 10
    gaping_y = 74

    ---[[
    -- 整个底色背景
    cc.ui.UIImage.new(Imgs.dialog_bg,{})
        :addTo(self.pop_window)
    	-- :align(display.LEFT_TOP, gaping_w, osHeight -gaping_h)
    	-- :setLayoutSize(osWidth -gaping_w*2, osHeight -gaping_h*2)
        :align(display.CENTER, display.cx, display.cy)
        :setLayoutSize(osWidth -gaping_w*2, osHeight -gaping_h*2)
    --]]

    ---[[
    -- 内容背景
    cc.ui.UIImage.new(Imgs.dialog_content_bg,{})
        :addTo(self.pop_window)
        -- :align(display.LEFT_TOP, gaping_w +gaping_x, osHeight -gaping_h -gaping_y)
        -- :setLayoutSize(osWidth -gaping_w*2 -gaping_x*2, osHeight -gaping_h*2  -gaping_y-gaping_x)
        :align(display.CENTER, display.cx, display.cy -gaping_y*0.5)
        :setLayoutSize(osWidth -gaping_w*2 -gaping_x*2, osHeight -gaping_h*2 -gaping_y -gaping_x)
    --]]

    -- logo
    cc.ui.UIImage.new(Imgs.result_title_logo,{})
    --cc.ui.UIPushButton.new(Imgs.result_title_logo, {scale9 = false})
    --    :setButtonImage(EnStatus.pressed, Imgs.result_title_logo)
    --    :setButtonImage(EnStatus.disabled, Imgs.result_title_logo)
    	:addTo(self.pop_window)
    	:align(display.CENTER_TOP, display.cx, osHeight -gaping_h -11)

    ---[[
    -- 关闭 
    -- cc.ui.UIPushButton.new(Imgs.dialog_back,{scale9=false})
    cc.ui.UIPushButton.new(Imgs.dialog_exit,{scale9=false})
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

            VoiceDealUtil:playSound_other(Voices.file.ui_click)
            self:myExit()

        end)
    	:addTo(self.pop_window)
        -- :align(display.LEFT_TOP, gaping_w +gaping_x, osHeight -gaping_h -3)
        :align(display.RIGHT_TOP, osWidth -gaping_w -gaping_x, osHeight -gaping_h -11)
    --]]

    local hintText = cc.ui.UILabel.new({
            UILabelType = 2, 
            --image = "",
            text = Strings.gameing.ResultDialogHintTxt, 
            size = Dimens.TextSize_20,
            --color = Colors.black,
            color = Colors:_16ToRGB(Colors.gameing_huxi),
            font = Fonts.Font_hkyt_w9,
            align = cc.ui.TEXT_ALIGN_LEFT,
            valign = cc.ui.TEXT_VALIGN_CENTER,
            --dimensions = cc.size((osWidth-120),0) -- height为0，就是自动换行
            --dimensions = cc.size(200,50)
        })
        :align(display.LEFT_TOP, gaping_w +gaping_x+30, gaping_h +gaping_x+30)
        :addTo(self.pop_window)
    if CVar._static.appstoreSwitch == CEnum.appstoreSwitch.open then
        hintText:setVisible(true)
    else
        hintText:setVisible(false)
    end


	-- view
    -- self:createView2()
	-- self:setViewData2()

    self.loadingPop_window = CDAlertLoading.new():popDialogBox(self.pop_window, Strings.hint_Loading)
    local param = {roomNo = self.roomNo}
    if CEnum.AppVersion.gameAlias == CEnum.gameType.pdk then
        if self.fromOther==nil then
            -- 本人的
            RequestPDKRoomResult:getResultRound(param, function(...) self:resDataResultRound(...) end)
        else
            RequestPDKRoomResult:getOtherResultRound(param, function(...) self:resDataResultRound(...) end)
        end

    elseif CEnum.AppVersion.gameAlias == CEnum.gameType.hzmj then
        if self.fromOther==nil then
            -- 本人的
            RequestMJRoomResult:getResultRound(param, function(...) self:resDataResultRound(...) end)
        else
            RequestMJRoomResult:getOtherResultRound(param, function(...) self:resDataResultRound(...) end)
        end

    else
        -- print("=====self.fromOther==", self.fromOther)
        if self.fromOther==nil then
            -- 本人的
            RequestHome:getResultRound(param, function(...) self:resDataResultRound(...) end)
        else
            RequestHome:getOtherResultRound(param, function(...) self:resDataResultRound(...) end)
        end
    end

end

function ResultRoundDialog:resDataResultRound(jsonObj)

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
                local rounds = _data[Result.Bean.rounds]
                if Commons:checkIsNull_tableList(rounds) then
                    self.res_data = rounds
                    -- view
                    self:createView2()
                    self:setViewData2()
                else
                    CDAlert.new():popDialogBox(self.parent, Strings.gameing.noData_roundRoom)
                    self:myExit()
                end
            else
                CDAlert.new():popDialogBox(self.parent, Strings.gameing.noData_roundRoom)
                self:myExit()
            end
        else
            CDAlert.new():popDialogBox(self.parent, Strings.gameing.noData_roundRoom)
            self:myExit()
        end
    end
end


local item_w
local item_h
local txtLabel3
local txtLabel4
local item_single_w
function ResultRoundDialog:createView2()

    item_w = osWidth -gaping_w*2 -gaping_x*4
    item_h = (osHeight -gaping_h*2 -gaping_y -114)/6 -- 空出70像素的title部分

    local startX = gaping_w
    local startY = osHeight -130

    item_single_w = item_w/7 -- 7列数据
    item_single_w = item_single_w-item_single_w%1 -- 取整
    -- print("========", item_w, item_single_w)

    if CVar._static.isIphone4 then
    elseif CVar._static.isIpad then
    elseif CVar._static.NavBarH_Android ~= CEnum.status.NavBarH_def then
        item_w = item_w -CVar._static.NavBarH_Android
        item_single_w = item_w/7 -- 7列数据
        item_single_w = item_single_w-item_single_w%1 -- 取整
    end

    local moveX = 0
    local fontSize = Dimens.TextSize_25
    local dimenW = 150
    if CVar._static.isIphone4 then
        -- moveX = -20
        fontSize = Dimens.TextSize_20
        dimenW = 120
    elseif CVar._static.isIpad then
        -- moveX = -75
        fontSize = Dimens.TextSize_20
        dimenW = 120
    elseif CVar._static.NavBarH_Android ~= CEnum.status.NavBarH_def then
        -- moveX = -CVar._static.NavBarH_Android/2
    end

    -- 序号
    display.newTTFLabel({
            text = "序号",
            font = Fonts.Font_hkyt_w9,
            size = fontSize,
            color = Colors:_16ToRGB(Colors.gameing_huxi),
            align = cc.ui.TEXT_ALIGN_LEFT,
            valign = cc.ui.TEXT_VALIGN_CENTER,
            dimensions = cc.size(150,30)
        })
        :addTo(self.pop_window)
        :align(display.LEFT_TOP, startX +40, startY)

    -- 对战时间
    local time_view = display.newTTFLabel({
            text = "对战时间",
            font = Fonts.Font_hkyt_w9,
            size = fontSize,
            color = Colors:_16ToRGB(Colors.gameing_huxi),
            align = cc.ui.TEXT_ALIGN_LEFT,
            valign = cc.ui.TEXT_VALIGN_CENTER,
            dimensions = cc.size(150,30)
        })
        :addTo(self.pop_window)
        :align(display.LEFT_TOP, startX +item_single_w -30 +moveX, startY)
    

    if self.res_data ~= nil then
        -- if CVar._static.isIphone4 then
        --     moveX = -20 -145
        -- elseif CVar._static.isIpad then
        --     moveX = -60 -145
        -- end

        v = self.res_data[1]
        local players = v[Result.Bean.players]
        if Commons:checkIsNull_tableList(players) then
            for kk,vv in pairs(players) do
                local user = vv[Player.Bean.user]
                if user ~= nil then
                    local nickname = RequestBase:getStrDecode(user[User.Bean.nickname] )
                    local token = RequestBase:getStrDecode(user[User.Bean.token] )

                    if kk==1 then
                        self.token1 = token
                        -- print("=============", self.token1, token, nickname)
                        -- local txtLabel1 = 
                        display.newTTFLabel({
                            text = nickname,
                            font = Fonts.Font_hkyt_w9,
                            size = fontSize,
                            color = Colors:_16ToRGB(Colors.gameing_huxi),
                            align = cc.ui.TEXT_ALIGN_LEFT,
                            valign = cc.ui.TEXT_VALIGN_CENTER,
                            dimensions = cc.size(dimenW,30)
                        })
                        :addTo(self.pop_window)
                        :align(display.LEFT_TOP, startX +item_single_w*2 +moveX, startY)

                    elseif kk ==2 then
                        -- if CVar._static.isIphone4 then
                        --     --moveX = -20 -145
                        -- elseif CVar._static.isIpad then
                        --     moveX = -60 -170
                        -- end
                        self.token2 = token
                        -- local txtLabel2 = 
                        display.newTTFLabel({
                            text = nickname,
                            font = Fonts.Font_hkyt_w9,
                            size = fontSize,
                            color = Colors:_16ToRGB(Colors.gameing_huxi),
                            align = cc.ui.TEXT_ALIGN_LEFT,
                            valign = cc.ui.TEXT_VALIGN_CENTER,
                            dimensions = cc.size(dimenW,30)
                        })
                        :addTo(self.pop_window)
                        :align(display.LEFT_TOP, startX +item_single_w*3 +moveX, startY)

                    elseif kk ==3 then
                        -- if CVar._static.isIphone4 then
                        --     --moveX = -20 -145
                        -- elseif CVar._static.isIpad then
                        --     moveX = -60 -215
                        -- end
                        self.token3 = token
                        txtLabel3 = display.newTTFLabel({
                            text = nickname,
                            font = Fonts.Font_hkyt_w9,
                            size = fontSize,
                            color = Colors:_16ToRGB(Colors.gameing_huxi),
                            align = cc.ui.TEXT_ALIGN_LEFT,
                            valign = cc.ui.TEXT_VALIGN_CENTER,
                            dimensions = cc.size(dimenW,30)
                        })
                        :addTo(self.pop_window)
                        :align(display.LEFT_TOP, startX +item_single_w*4 +moveX, startY)

                    elseif kk ==4 then
                        -- if CVar._static.isIphone4 then
                        --     --moveX = -20 -145
                        -- elseif CVar._static.isIpad then
                        --     moveX = -60 -215
                        -- end
                        self.token4 = token
                        txtLabel4 = display.newTTFLabel({
                            text = nickname,
                            font = Fonts.Font_hkyt_w9,
                            size = fontSize,
                            color = Colors:_16ToRGB(Colors.gameing_huxi),
                            align = cc.ui.TEXT_ALIGN_LEFT,
                            valign = cc.ui.TEXT_VALIGN_CENTER,
                            dimensions = cc.size(dimenW,30)
                        })
                        :addTo(self.pop_window)
                        :align(display.LEFT_TOP, startX +item_single_w*5 +moveX, startY)

                    end        
                end
            end
        end
    end

    -- 组合
    self.view_hu_list = 
        cc.ui.UIListView.new({
            --bg = Imgs.c_default_img,
            --bgStartColor = cc.c4b(255,64,64,150),
            --bgEndColor = cc.c4b(0,0,0,150),
            --bgColor = cc.c4b(200, 200, 200, 150),
            --bgColor = Colors.btn_bg,
            bgScale9 = false,
            --capInsets = cc.rect(0, 0, 706, 73*4),
            viewRect = cc.rect(0, 0, item_w, item_h*6),
            direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
            --direction = cc.ui.UIScrollView.DIRECTION_HORIZONTAL,
            --alignment = cc.ui.UIListView.ALIGNMENT_VCENTER
            --scrollbarImgH = Imgs.c_default_img
            --scrollbarImgV = Imgs.c_default_img
        })
        :addTo(self.pop_window)
        :align(display.LEFT_TOP, gaping_w +gaping_x*2, gaping_h +gaping_x*2 +22)
end

-- 三个玩家的数据都显示出来
function ResultRoundDialog:setViewData2()
    local moveX = 0
    local moveX_index = 0
    if CVar._static.isIphone4 then
        -- moveX = -10
    elseif CVar._static.isIpad then
        -- moveX = -55
        moveX_index = -10
    elseif CVar._static.NavBarH_Android ~= CEnum.status.NavBarH_def then
        -- moveX = -CVar._static.NavBarH_Android/2
    end

    if self.res_data ~= nil then
        -- Commons:printLog_Info("宽",item_w)
        -- Commons:printLog_Info("高",item_h)
        self.view_hu_list:removeAllItems()

        for k,v in pairs(self.res_data) do
            local rounds = #self.res_data
            local roundNo = v[Result.Bean.roundNo]
            local startTime = v[Result.Bean.startTime]
            local players = v[Result.Bean.players]

            local item = self.view_hu_list:newItem()

            -- 背景
            local contentImg = Imgs.round_item_ou
            if k%2==0 then
            else
                contentImg = Imgs.round_item_ji
            end
            local content = cc.ui.UIImage.new(contentImg,{scale9 = true})
                :setContentSize(item_w, item_h-0) --设置大小
                :setLayoutSize(item_w, item_h-0) --设置大小
            -- local ww = item_w -- content:getContentSize().width
            -- local hh = item_h -- content:getContentSize().height

            -- 三个人的信息
            local wwContent = item_single_w
            local wwContentX = item_single_w -10
            local hhContent = item_h
            -- print("==============hhContent==", hhContent)
            local hhContentH = item_h -20
            local hhContentY = item_h -10

            -- 序号
            display.newTTFLabel({
                    text = k,
                    font = Fonts.Font_hkyt_w9,
                    size = Dimens.TextSize_25,
                    color = Colors:_16ToRGB(Colors.gameing_huxi),
                    align = cc.ui.TEXT_ALIGN_CENTER,
                    valign = cc.ui.TEXT_VALIGN_CENTER,
                    --dimensions = cc.size(100,20)
                })
                :addTo(content)
                :align(display.LEFT_TOP, 42 +moveX_index, (hhContent+20)/2) -- 一行字高度20个像素

            -- 对战时间
            display.newTTFLabel({
                text = startTime,
                font = Fonts.Font_hkyt_w9,
                size = Dimens.TextSize_25,
                color = Colors:_16ToRGB(Colors.gameing_huxi),
                align = cc.ui.TEXT_ALIGN_LEFT,
                valign = cc.ui.TEXT_VALIGN_CENTER,
                dimensions = cc.size(100,0)
            })
            :addTo(content)
            :align(display.LEFT_TOP, wwContentX -40 +moveX, (hhContent+40)/2) -- 一行字高度20个像素,2行高度40个像素

            local userContentBg = Imgs.c_transparent -- Imgs.c_transparent -- Imgs.result_item_content_bg
            -- 分数
            local userContent
            if self.fromOther==nil then
                userContent = 
                    cc.ui.UIImage.new(userContentBg,{scale9 = false})
                        -- :setLayoutSize(wwContent, hhContentH) --设置大小
                        :setContentSize(wwContent, hhContentH) --设置大小
            else
                userContent = 
                    cc.ui.UIPushButton.new(userContentBg,{scale9=false})
                        :setButtonSize(wwContent, hhContentH)
                        :onButtonClicked(function(event)
                            self:clickListener(roundNo, startTime, k, rounds, self.token1)
                        end)
            end
            userContent:addTo(content)
                    :align(display.LEFT_TOP, wwContentX*2 +moveX, hhContentY)
                    -- -- :setTouchSwallowEnabled(false)
                    -- userContent:setTouchEnabled(true)
                    -- :addNodeEventListener(cc.NODE_TOUCH_EVENT, function(...) self.clickListener(roundNo, startTime, k, rounds, self.token1) end )
                    -- -- :addNodeEventListener(cc.NODE_TOUCH_EVENT, 
                    -- --     function(event) 
                    -- --         if event.name == EnStatus.began or event.name == EnStatus.clicked then
                    -- --             return true
                    -- --         elseif event.name == EnStatus.moved then
                    -- --             return true    
                    -- --         elseif event.name == EnStatus.ended then
                    -- --             self.clickListener(roundNo, startTime, k, rounds, self.token1)
                    -- --         end
                    -- --     end
                    -- -- )

            local userContent2 
            if self.fromOther==nil then
                userContent2 =
                    cc.ui.UIImage.new(userContentBg,{scale9 = false})
                        -- :setLayoutSize(wwContent, hhContentH) --设置大小
                        :setContentSize(wwContent, hhContentH) --设置大小
            else
                userContent2 =
                    cc.ui.UIPushButton.new(userContentBg,{scale9=false})
                        :setButtonSize(wwContent, hhContentH)
                        :onButtonClicked(function(event)
                            self:clickListener(roundNo, startTime, k, rounds, self.token2)
                        end)
            end
            userContent2:addTo(content)
                :align(display.LEFT_TOP, wwContentX*3 +moveX, hhContentY)
                    -- -- :setTouchSwallowEnabled(false)
                    -- userContent2:setTouchEnabled(true)
                    -- :addNodeEventListener(cc.NODE_TOUCH_EVENT, function(...) self.clickListener(roundNo, startTime, k, rounds, self.token2) end )

            local userContent3
            if self.fromOther==nil then
                userContent3 = 
                    cc.ui.UIImage.new(userContentBg,{scale9 = false})
                        -- :setLayoutSize(wwContent, hhContentH) --设置大小
                        :setContentSize(wwContent, hhContentH) --设置大小
            else
                userContent3 = 
                    cc.ui.UIPushButton.new(userContentBg,{scale9=false})
                        :setButtonSize(wwContent, hhContentH)
                        :onButtonClicked(function(event)
                            self:clickListener(roundNo, startTime, k, rounds, self.token3)
                        end)
            end
            userContent3:addTo(content)
                :align(display.LEFT_TOP, wwContentX*4 +moveX, hhContentY)
                    -- -- :setTouchSwallowEnabled(false)
                    -- userContent3:setTouchEnabled(true)
                    -- :addNodeEventListener(cc.NODE_TOUCH_EVENT, function(...) self.clickListener(roundNo, startTime, k, rounds, self.token3) end )

            local userContent4
            if self.fromOther==nil then
                userContent4 =
                    cc.ui.UIImage.new(userContentBg,{scale9 = false})
                        -- :setLayoutSize(wwContent, hhContentH) --设置大小
                        :setContentSize(wwContent, hhContentH) --设置大小
            else
                userContent4 =
                    cc.ui.UIPushButton.new(userContentBg,{scale9=false})
                        :setButtonSize(wwContent, hhContentH)
                        :onButtonClicked(function(event)
                            self:clickListener(roundNo, startTime, k, rounds, self.token4)
                        end)
            end
            userContent4:addTo(content)
                :align(display.LEFT_TOP, wwContentX*5 +moveX, hhContentY)
                    -- -- :setTouchSwallowEnabled(false)
                    -- userContent4:setTouchEnabled(true)
                    -- :addNodeEventListener(cc.NODE_TOUCH_EVENT, function(...) self.clickListener(roundNo, startTime, k, rounds, self.token4) end )

            local userContent5 = cc.ui.UIPushButton.new(Imgs.dialog_btn_look,{scale9=false})
                :setButtonImage(EnStatus.pressed, Imgs.dialog_btn_look_press)
                :setButtonSize(116, 46)
                :align(display.LEFT_TOP, wwContentX*6 +20 +moveX, (hhContent+40)/2) -- 按钮的高度46
                :addTo(content)
                :onButtonClicked(function(event)
                    Commons:printLog_Info("查看按钮")
                    self:clickListener(roundNo, startTime, k, rounds)
                end)

            -- 三个人
            if Commons:checkIsNull_tableList(players) then
                for kk,vv in pairs(players) do

                    --[[
                    local user = vv[Player.Bean.user]
                    if user ~= nil then
                        local nickname = RequestBase:getStrDecode(user[User.Bean.nickname] )
                        --Commons:printLog_Info("昵称是",nickname)
                        local nickView = display.newTTFLabel({
                                text = nickname,
                                font = Fonts.Font_hkyt_w9,
                                size = Dimens.TextSize_60,
                                color = Colors:_16ToRGB(Colors.gameing_huxi),
                                align = cc.ui.TEXT_ALIGN_CENTER,
                                valign = cc.ui.TEXT_VALIGN_CENTER,
                                --dimensions = cc.size(100,20)
                            })
                            :align(display.CENTER, wwContent/2, hhContent-30)

                        if kk==1 then
                            nickView:addTo(userContent)
                        elseif kk ==2 then
                            nickView:addTo(userContent2)
                        elseif kk ==3 then
                            nickView:addTo(userContent3)    
                        end
                    end
                    --]]

                    local score = vv[Player.Bean.score]
                    --Commons:printLog_Info("分数是",score)
                    if Commons:checkIsNull_numberType(score) then
                        local _string = tostring(score)
                        local _size = string.len(_string)
                        for i=1,_size do
                            local i_str = string.sub(_string, i, i)
                            local img_i = GameingDealUtil:getNumImg_by_scoreResult(i_str)
                            local scoreView = cc.ui.UIImage.new(img_i,{scale9=false})
                            -- cc.ui.UIPushButton.new(img_i,{scale9=false})
                                --:setButtonSize(30, 34)
                            if self.fromOther==nil then
                                --  scoreView:setLayoutSize(48, 48)
                                --     :align(display.CENTER, 30 +(45*(i-1)), hhContent -20)-- 居zuo的做法
                                --     --:align(display.CENTER, wwContent/2 +(-27*_size/2)+(27*(i-1)), hhContent/2) -- 居中的做法
                                -- -- if score < 0 then
                                -- --     scoreView:align(display.CENTER, wwContent/2 +(25*(i-1)), hhContent/2)
                                -- -- else
                                -- --     scoreView:align(display.CENTER, wwContent/2 +(27*(i-1)), hhContent/2)
                                -- -- end
                                scoreView:setLayoutSize(28, 28)
                                -- scoreView:setContentSize(28, 28)
                                scoreView:align(display.CENTER, 12 +(25*(i-1)), hhContent/2 -16)-- 居zuo的做法
                            else
                                scoreView:setLayoutSize(28, 28)
                                -- scoreView:setContentSize(28, 28)
                                scoreView:align(display.CENTER, 12 +(25*(i-1)), -30)-- 居zuo的做法
                            end

                            if kk==1 then
                                scoreView:addTo(userContent)
                            elseif kk ==2 then
                                scoreView:addTo(userContent2)
                            elseif kk ==3 then
                                scoreView:addTo(userContent3) 
                            elseif kk ==4 then
                                scoreView:addTo(userContent4)  
                            end
                        end
                    end
                end

                -- if #players == 3 then
                --     if userContent4 then
                --         userContent4:hide()
                --     end
                --     if txtLabel4 ~= nil then
                --         txtLabel4:hide()
                --     end
                --     if userContent4 then
                --         local posX, posY = userContent4:getPosition()
                --         userContent5:setPosition(posX, posY)
                --     end
                -- end
            end

            item:addContent(content)
            --Commons:printLog_Info("最终是:",item_w, item_h)
            item:setItemSize(item_w, item_h)
            self.view_hu_list:addItem(item) -- 添加item到列表
        end
        self.view_hu_list:onTouch(function(...) self:touchListener_listview(...) end)
        self.view_hu_list:reload() -- 重新加载
    end
end

function ResultRoundDialog:clickListener(_roundNo, _startTime, playRound, rounds, targetToken)
    Commons:printLog_Info("查看的回合号是：", _roundNo, _startTime, playRound, targetToken)

    VoiceDealUtil:playSound_other(Voices.file.ui_click)

    if CEnum.AppVersion.gameAlias == CEnum.gameType.pdk then
        PDKOverRoundDialog.new(nil,nil,nil, "yes", _startTime, self.roomNo, _roundNo, tostring(playRound), self.fromOther, targetToken):addTo(self.pop_window, CEnum.ZOrder.common_dialog)
    elseif CEnum.AppVersion.gameAlias == CEnum.gameType.hzmj then
        PlayerRoundRecordDialog.new()
            :addTo(self.pop_window, CEnum.ZOrder.common_dialog)
            :popDialogBox(nil, _startTime, self.roomNo, _roundNo, rounds, playRound, nil, self.fromOther, targetToken)
    else
        -- print("====回合号== targetToken==", self.pop_window, self.roomNo, targetToken)
        -- GameingOverRoundDialog:popDialogBox(self.pop_window, nil, _startTime, self.roomNo, _roundNo, nil, nil, self.fromOther, targetToken)
        GameingOverRoundDialog:popDialogBox(poper_window, nil, _startTime, self.roomNo, _roundNo, nil, nil, self.fromOther, targetToken)
    end
end

function ResultRoundDialog:touchListener_listview(event)
    --dump(event, "pageView - event:")
    --Commons:printLog_Info("pageView - event:")
    --Commons:printfLog_Info("touchListener: name=%s x,y: %0.2f, %0.2f", event.name, event.x, event.y)

    --local listView = event.pageView
    --local item = event.item
    local position = event.itemPos
    local event_name = event.name
    --dump(item)

    if EnStatus.clicked == event_name then
        local v = self.res_data[position]
        local roundNo = v[Result.Bean.roundNo]
        local rounds = #self.res_data
        Commons:printLog_Info("点击的回合号是：", roundNo)

        local startTime = v[Result.Bean.startTime]

        self:clickListener(roundNo, startTime, position, rounds)
    end
end


function ResultRoundDialog:onExit()
    self:myExit()
end

function ResultRoundDialog:myExit()
    self.res_data = nil
    self.roomNo = nil
    self.fromOther = nil

    self.view_hu_list = nil

    if self.pop_window and not tolua.isnull(self.pop_window) then
        self.pop_window:removeFromParent()
        self.pop_window = nil
    end
end

return ResultRoundDialog
