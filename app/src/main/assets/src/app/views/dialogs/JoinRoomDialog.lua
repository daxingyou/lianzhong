--
-- Author: lte
-- Date: 2016-10-19 12:40:33
-- 加入房间的弹窗

-- 类申明
local JoinRoomDialog = class("JoinRoomDialog")


local osWidth = Commons.osWidth
local osHeight = Commons.osHeight

local roomNo = ""
local _position = 1  -- 输入的位置

-- 输入的值，int型
local showNumber_1_value
local showNumber_2_value
local showNumber_3_value
local showNumber_4_value
local showNumber_5_value
local showNumber_6_value
-- 组件 button
local showNumber_1
local showNumber_2
local showNumber_3
local showNumber_4
local showNumber_5
local showNumber_6

local startX_gaping

local p_parent
local pop_window


-- 创建一个模态弹出框,  parent=要加在哪个上面
function JoinRoomDialog:popDialogBox(_parent)
    p_parent = _parent

    pop_window = display.newColorLayer(cc.c4b(0, 0, 0, 100))       -- 半透明的黑色

    pop_window:setContentSize(osWidth, osHeight)             -- 设置Layer的大小,全屏出现
    --pop_window:align(display.CENTER, display.cx, display.cy) -- Layer的锚点在0.5,0.5 因此对齐的时候要注意
    pop_window:setTouchEnabled(true)
    pop_window:setTouchSwallowEnabled(true)  -- 吞噬下层的响应
    pop_window:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event) -- 点击此Layer时候输出信息,然后把自己销毁
        return true
    end)
    p_parent:addChild(pop_window, CEnum.ZOrder.common_dialog) -- 把Layer添加到父对象上

    startX_gaping = 138
    if CVar._static.isIphone4 or CVar._static.isIpad then
        startX_gaping = 38
        -- pop_window:setScale(0.8)
    elseif CVar._static.NavBarH_Android ~= CEnum.status.NavBarH_def then
        startX_gaping = 138 -CVar._static.NavBarH_Android/2
    end

    ---[[
    -- 整个底色背景
    cc.ui.UIImage.new(Imgs.dialog_bg,{})
        :addTo(pop_window)
        :align(display.CENTER, display.cx, display.cy)
        :setLayoutSize(osWidth-startX_gaping*2, osHeight-16*2)
    --]]

    -- 内容背景
    cc.ui.UIImage.new(Imgs.dialog_content_bg,{})
        :addTo(pop_window)
        :align(display.CENTER, display.cx, display.cy-90/2)
        :setLayoutSize(osWidth-startX_gaping*2-10*2, osHeight-16*2-100)

    -- logo
    cc.ui.UIImage.new(Imgs.room_join_logo,{})
        :addTo(pop_window)
        :align(display.CENTER, display.cx, osHeight-16-16-62/2)

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
            JoinRoomDialog:myExit()
            -- 固定一个值，测试输入之后显示值
            --JoinRoomDialog:showNumbers_deal(6, _position)
            --_position = _position+1

        end)
        :addTo(pop_window)
        :align(display.CENTER, osWidth-startX_gaping-20-56/2, osHeight-16-14-10-56/2)

    --[[
    -- 确定按钮
    cc.ui.UIPushButton.new(
        Imgs.dialog_btn_confim,{scale9=false})
        :setButtonSize(278, 100)
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
        --:setButtonImage(EnStatus.pressed, Imgs.dialog_btn_confim_press)
        :onButtonClicked(function(e)
            JoinRoomDialog:myConfim()
        end)
        :align(display.CENTER, display.cx, osHeight-562-100/2)
        :addTo(pop_window)
    --]]

    -- 显示已经输入的数字
    JoinRoomDialog:create_showNumbers()

    -- 创建键盘
    JoinRoomDialog:create_keyboard()

    if CVar._static.appstoreSwitch == CEnum.appstoreSwitch.open then
        JoinRoomDialog:getLgeLat()
    end
end

function JoinRoomDialog:showNumbers_view(inputText, view)
    if inputText == "0" then
        view:setButtonImage(EnStatus.normal, Imgs.room_nums_0)
    elseif inputText == "1" then
        view:setButtonImage(EnStatus.normal, Imgs.room_nums_1)
    elseif inputText == "2" then
        view:setButtonImage(EnStatus.normal, Imgs.room_nums_2)
    elseif inputText == "3" then
        view:setButtonImage(EnStatus.normal, Imgs.room_nums_3)
    elseif inputText == "4" then
        view:setButtonImage(EnStatus.normal, Imgs.room_nums_4)
    elseif inputText == "5" then
        view:setButtonImage(EnStatus.normal, Imgs.room_nums_5)
    elseif inputText == "6" then
        view:setButtonImage(EnStatus.normal, Imgs.room_nums_6)
    elseif inputText == "7" then
        view:setButtonImage(EnStatus.normal, Imgs.room_nums_7)
    elseif inputText == "8" then
        view:setButtonImage(EnStatus.normal, Imgs.room_nums_8)
    elseif inputText == "9" then
        view:setButtonImage(EnStatus.normal, Imgs.room_nums_9)
    elseif inputText == "11" then -- 重输
        showNumber_1:setButtonImage(EnStatus.normal, Imgs.c_transparent)
        showNumber_2:setButtonImage(EnStatus.normal, Imgs.c_transparent)
        showNumber_3:setButtonImage(EnStatus.normal, Imgs.c_transparent)
        showNumber_4:setButtonImage(EnStatus.normal, Imgs.c_transparent)
        showNumber_5:setButtonImage(EnStatus.normal, Imgs.c_transparent)
        showNumber_6:setButtonImage(EnStatus.normal, Imgs.c_transparent)
    elseif inputText == "12" then -- 删除
        view:setButtonImage(EnStatus.normal, Imgs.c_transparent)
    else
    end
end
-- 输入的数字   位置
function JoinRoomDialog:showNumbers_deal(inputText, position)
    Commons:printLog_Info("用户输入的数字是:",inputText," 位置在:",position)
    if position == 1 and inputText ~= nil and inputText ~= "" and inputText~="11" and inputText~="12" then
        showNumber_1_value = inputText
        JoinRoomDialog:showNumbers_view(inputText, showNumber_1)
    elseif position == 2 and inputText ~= nil and inputText ~= "" and inputText~="11" and inputText~="12" then
        showNumber_2_value = inputText
        JoinRoomDialog:showNumbers_view(inputText, showNumber_2)
    elseif position == 3 and inputText ~= nil and inputText ~= "" and inputText~="11" and inputText~="12" then
        showNumber_3_value = inputText
        JoinRoomDialog:showNumbers_view(inputText, showNumber_3)
    elseif position == 4 and inputText ~= nil and inputText ~= "" and inputText~="11" and inputText~="12" then
        showNumber_4_value = inputText
        JoinRoomDialog:showNumbers_view(inputText, showNumber_4)
    elseif position == 5 and inputText ~= nil and inputText ~= "" and inputText~="11" and inputText~="12" then
        showNumber_5_value = inputText
        JoinRoomDialog:showNumbers_view(inputText, showNumber_5)
    elseif position == 6 and inputText ~= nil and inputText ~= "" and inputText~="11" and inputText~="12" then
        showNumber_6_value = inputText
        JoinRoomDialog:showNumbers_view(inputText, showNumber_6)
    elseif inputText ~= nil and inputText ~= "" and inputText == "11" then -- =11表示重输清空
        Commons:printLog_Info("重输的数字是:",inputText," 位置在:",position)
        _position = 0
        showNumber_1_value = ""
        showNumber_2_value = ""
        showNumber_3_value = ""
        showNumber_4_value = ""
        showNumber_5_value = ""
        showNumber_6_value = ""
        JoinRoomDialog:showNumbers_view(inputText, nil)
    elseif inputText ~= nil and inputText ~= "" and inputText == "12" then -- =12表示删除
        Commons:printLog_Info("删除的数字是:",inputText," 位置在:",position)
        -- Commons:printLog_Info("删除的数字是 6:",showNumber_6_value)
        -- Commons:printLog_Info("删除的数字是 5:",showNumber_5_value)
        -- Commons:printLog_Info("删除的数字是 4:",showNumber_4_value)
        -- Commons:printLog_Info("删除的数字是 3:",showNumber_3_value)
        -- Commons:printLog_Info("删除的数字是 2:",showNumber_2_value)
        -- Commons:printLog_Info("删除的数字是 1:",showNumber_1_value)
        if showNumber_6_value~=nil and showNumber_6_value~="" then
            _position = _position - 2
            showNumber_6_value = ""
            JoinRoomDialog:showNumbers_view(inputText, showNumber_6)
        elseif showNumber_5_value~=nil and showNumber_5_value~="" then
            _position = _position - 2
            showNumber_5_value = ""
            JoinRoomDialog:showNumbers_view(inputText, showNumber_5)
        elseif showNumber_4_value~=nil and showNumber_4_value~="" then
            _position = _position - 2
            showNumber_4_value = ""
            JoinRoomDialog:showNumbers_view(inputText, showNumber_4)
        elseif showNumber_3_value~=nil and showNumber_3_value~="" then
            _position = _position - 2
            showNumber_3_value = ""
            JoinRoomDialog:showNumbers_view(inputText, showNumber_3)
        elseif showNumber_2_value~=nil and showNumber_2_value~="" then
            _position = _position - 2
            showNumber_2_value = ""
            JoinRoomDialog:showNumbers_view(inputText, showNumber_2)
        elseif showNumber_1_value~=nil and showNumber_1_value~="" then
            _position = _position - 2
            showNumber_1_value = ""
            JoinRoomDialog:showNumbers_view(inputText, showNumber_1)
        else
            _position = 0
        end
    else
    end
end

-- 显示已经输入的数字
function JoinRoomDialog:create_showNumbers()
    local startX_1row = startX_gaping+254
    if CVar._static.isIphone4 then
        startX_1row = startX_1row-20
    elseif CVar._static.isIpad then
        startX_1row = startX_1row-60
    end

    -- 第1个数字
    cc.ui.UIImage.new(Imgs.room_number_bg,{})
        :addTo(pop_window)
        :align(display.LEFT_TOP, startX_1row, osHeight-16-90-44)
    -- cc.ui.UIPushButton.new(
    --     Imgs.room_number_bg,{scale9=false})
    --     :setButtonSize(72, 72)
    --     :onButtonClicked(function(e)
    --     end)
    --     :align(display.LEFT_TOP, 392, osHeight-16-90-44)
    --     :addTo(pop_window)
    showNumber_1 = cc.ui.UIPushButton.new(
        Imgs.c_transparent,{scale9=false})
        :setButtonSize(46, 52)
        :onButtonClicked(function(e)
        end)
        :align(display.LEFT_TOP, startX_1row +13, osHeight-16-90-44-10)
        :addTo(pop_window)
        --:setButtonImage(EnStatus.normal, Imgs.room_nums_1)

    -- 第2个数字
    cc.ui.UIImage.new(Imgs.room_number_bg,{})
        :addTo(pop_window)
        :align(display.LEFT_TOP, startX_1row +(72+16)*1, osHeight-16-90-44)
    -- cc.ui.UIPushButton.new(
    --     Imgs.room_number_bg,{scale9=false})
    --     :setButtonSize(72, 72)
    --     :onButtonClicked(function(e)
    --     end)
    --     :align(display.LEFT_TOP, 392, osHeight-16-90-44)
    --     :addTo(pop_window)
    showNumber_2 = cc.ui.UIPushButton.new(
        Imgs.c_transparent,{scale9=false})
        :setButtonSize(46, 52)
        :onButtonClicked(function(e)
        end)
        :align(display.LEFT_TOP, startX_1row +13+(72+16)*1, osHeight-16-90-44-10)
        :addTo(pop_window)

    -- 第3个数字
    cc.ui.UIImage.new(Imgs.room_number_bg,{})
        :addTo(pop_window)
        :align(display.LEFT_TOP, startX_1row +(72+16)*2, osHeight-16-90-44)
    -- cc.ui.UIPushButton.new(
    --     Imgs.room_number_bg,{scale9=false})
    --     :setButtonSize(72, 72)
    --     :onButtonClicked(function(e)
    --     end)
    --     :align(display.LEFT_TOP, 392, osHeight-16-90-44)
    --     :addTo(pop_window)
    showNumber_3 = cc.ui.UIPushButton.new(
        Imgs.c_transparent,{scale9=false})
        :setButtonSize(46, 52)
        :onButtonClicked(function(e)
        end)
        :align(display.LEFT_TOP, startX_1row +13+(72+16)*2, osHeight-16-90-44-10)
        :addTo(pop_window)

    -- 第4个数字
    cc.ui.UIImage.new(Imgs.room_number_bg,{})
        :addTo(pop_window)
        :align(display.LEFT_TOP, startX_1row +(72+16)*3, osHeight-16-90-44)
    -- cc.ui.UIPushButton.new(
    --     Imgs.room_number_bg,{scale9=false})
    --     :setButtonSize(72, 72)
    --     :onButtonClicked(function(e)
    --     end)
    --     :align(display.LEFT_TOP, 392, osHeight-16-90-44)
    --     :addTo(pop_window)
    showNumber_4 = cc.ui.UIPushButton.new(
        Imgs.c_transparent,{scale9=false})
        :setButtonSize(46, 52)
        :onButtonClicked(function(e)
        end)
        :align(display.LEFT_TOP, startX_1row +13+(72+16)*3, osHeight-16-90-44-10)
        :addTo(pop_window)

    -- 第5个数字
    cc.ui.UIImage.new(Imgs.room_number_bg,{})
        :addTo(pop_window)
        :align(display.LEFT_TOP, startX_1row +(72+16)*4, osHeight-16-90-44)
    -- cc.ui.UIPushButton.new(
    --     Imgs.room_number_bg,{scale9=false})
    --     :setButtonSize(72, 72)
    --     :onButtonClicked(function(e)
    --     end)
    --     :align(display.LEFT_TOP, 392, osHeight-16-90-44)
    --     :addTo(pop_window)
    showNumber_5 = cc.ui.UIPushButton.new(
        Imgs.c_transparent,{scale9=false})
        :setButtonSize(46, 52)
        :onButtonClicked(function(e)
        end)
        :align(display.LEFT_TOP, startX_1row +13+(72+16)*4, osHeight-16-90-44-10)
        :addTo(pop_window)

    -- 第6个数字
    cc.ui.UIImage.new(Imgs.room_number_bg,{})
        :addTo(pop_window)
        :align(display.LEFT_TOP, startX_1row +(72+16)*5, osHeight-16-90-44)
    -- cc.ui.UIPushButton.new(
    --     Imgs.room_number_bg,{scale9=false})
    --     :setButtonSize(72, 72)
    --     :onButtonClicked(function(e)
    --     end)
    --     :align(display.LEFT_TOP, 392, osHeight-16-90-44)
    --     :addTo(pop_window)
    showNumber_6 = cc.ui.UIPushButton.new(
        Imgs.c_transparent,{scale9=false})
        :setButtonSize(46, 52)
        :onButtonClicked(function(e)
        end)
        :align(display.LEFT_TOP, startX_1row +13+(72+16)*5, osHeight-16-90-44-10)
        :addTo(pop_window)
end


local keyborad_single_w = 306
local keyborad_single_h = 96
local keyborad_single_gap = 4
-- 创建键盘
function JoinRoomDialog:create_keyboard()
    local startX_1row = startX_gaping+10+40
    local startY = osHeight-250-keyborad_single_h/2
    local moveX = 0

    if CVar._static.isIphone4 then
        startX_1row = startX_1row +20
        startY = startY -5

        keyborad_single_w = 306 -30

        moveX = 15
    elseif CVar._static.isIpad then
        startX_1row = startX_1row +20
        startY = startY -5

        keyborad_single_w = 306 -30 -50

        moveX = 15
    end

    -- 背景
    local img_bg = cc.ui.UIImage.new(Imgs.room_keyboard_bg,{scale9=false})
        :addTo(pop_window)
        :align(display.LEFT_TOP, startX_1row, osHeight-250)
        --:setLayoutSize(osWidth-(startX_1row+50)*2, osHeight-250 -50)
    if CVar._static.isIphone4 or CVar._static.isIpad then
        img_bg:align(display.LEFT_TOP, startX_1row, osHeight-250)
        img_bg:setLayoutSize(osWidth -startX_1row*2, osHeight-250 -50)
    end

    -- =1
    JoinRoomDialog:createViewByNumber("1", startX_1row+keyborad_single_w/2+keyborad_single_w*0, startY)
    -- =2
    JoinRoomDialog:createViewByNumber("2", startX_1row+keyborad_single_w/2+keyborad_single_w*1+moveX, startY)
    -- =3
    JoinRoomDialog:createViewByNumber("3", startX_1row+keyborad_single_w/2+keyborad_single_w*2+moveX*2, startY)

    if CVar._static.isIphone4 or CVar._static.isIpad then
        startY = startY -5
    end
    -- =4
    JoinRoomDialog:createViewByNumber("4", startX_1row+keyborad_single_w/2+keyborad_single_w*0, startY-keyborad_single_h-keyborad_single_gap)
    -- =5
    JoinRoomDialog:createViewByNumber("5", startX_1row+keyborad_single_w/2+keyborad_single_w*1+moveX, startY-keyborad_single_h-keyborad_single_gap)
    -- =6
    JoinRoomDialog:createViewByNumber("6", startX_1row+keyborad_single_w/2+keyborad_single_w*2+moveX*2, startY-keyborad_single_h-keyborad_single_gap)

    -- =7
    JoinRoomDialog:createViewByNumber("7", startX_1row+keyborad_single_w/2+keyborad_single_w*0, startY-(keyborad_single_h+keyborad_single_gap)*2)
    -- =8
    JoinRoomDialog:createViewByNumber("8", startX_1row+keyborad_single_w/2+keyborad_single_w*1+moveX, startY-(keyborad_single_h+keyborad_single_gap)*2)
    -- =9
    JoinRoomDialog:createViewByNumber("9", startX_1row+keyborad_single_w/2+keyborad_single_w*2+moveX*2, startY-(keyborad_single_h+keyborad_single_gap)*2)

    if CVar._static.isIphone4 or CVar._static.isIpad then
        startY = startY -5
    end
    -- =重输
    JoinRoomDialog:createViewByNumber("11", startX_1row+keyborad_single_w/2+keyborad_single_w*0, startY-(keyborad_single_h+keyborad_single_gap)*3)
    -- =0
    JoinRoomDialog:createViewByNumber("0", startX_1row+keyborad_single_w/2+keyborad_single_w*1+moveX, startY-(keyborad_single_h+keyborad_single_gap)*3)
    -- =删除
    JoinRoomDialog:createViewByNumber("12", startX_1row+keyborad_single_w/2+keyborad_single_w*2+moveX*2, startY-(keyborad_single_h+keyborad_single_gap)*3)
end

-- 键盘组件的一一创建
function JoinRoomDialog:createViewByNumber(numStr, x, y)
    local _numStr = numStr
    if numStr~=nil and numStr=="11" then
        _numStr = Strings.room_join_reset
    elseif numStr~=nil and numStr=="12" then
        _numStr = Strings.room_join_del
    end

    cc.ui.UIPushButton.new(
        --Imgs.room_number_bg,{scale9=true})
        Imgs.c_transparent,{scale9=true})
        :setButtonSize(keyborad_single_w, keyborad_single_h)
        --:setButtonLabelAlignment(display.CENTER)
        :setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
            UILabelType = 2,
            text = _numStr,
            size = Dimens.TextSize_60,
            color = Colors:_16ToRGB(Colors.keyboard),
            font = Fonts.Font_hkyt_w9,
            align = cc.ui.TEXT_ALIGN_CENTER,
            valign = cc.ui.TEXT_VALIGN_CENTER,
            --dimensions = cc.size(306, 96)
         }))
        :setButtonLabel(EnStatus.pressed, cc.ui.UILabel.new({
            UILabelType = 2,
            text = _numStr,
            size = Dimens.TextSize_60,
            color = Colors:_16ToRGB(Colors.keyboard_press),
            font = Fonts.Font_hkyt_w9,
            align = cc.ui.TEXT_ALIGN_CENTER,
            valign = cc.ui.TEXT_VALIGN_CENTER,
            --dimensions = cc.size(306, 96)
         }))
        :onButtonClicked(function(e)
            VoiceDealUtil:playSound_other(Voices.file.ui_click)

            JoinRoomDialog:showNumbers_deal(numStr, _position)
            _position = _position+1
            Commons:printLog_Info("下次输入的位置是：", _position)
            if _position == 7 then
                _position = 1
                JoinRoomDialog:myConfim()
            end
        end)
        :align(display.CENTER, x, y)
        :addTo(pop_window)
end

local loadingPop_window_joinRoom
function JoinRoomDialog:myConfim()

    local param = {}

    roomNo = "" -- 重新初始化

    if showNumber_1_value ~= nil then
        Commons:printLog_Info("第1位数字是：",showNumber_1_value)
        roomNo = roomNo .. showNumber_1_value;
    end
    if showNumber_2_value ~= nil then
        Commons:printLog_Info("第2位数字是：",showNumber_2_value)
        roomNo = roomNo .. showNumber_2_value;
    end
    if showNumber_3_value ~= nil then
        Commons:printLog_Info("第3位数字是：",showNumber_3_value)
        roomNo = roomNo .. showNumber_3_value;
    end
    if showNumber_4_value ~= nil then
        Commons:printLog_Info("第4位数字是：",showNumber_4_value)
        roomNo = roomNo .. showNumber_4_value;
    end
    if showNumber_5_value ~= nil then
        Commons:printLog_Info("第5位数字是：",showNumber_5_value)
        roomNo = roomNo .. showNumber_5_value;
    end
    if showNumber_6_value ~= nil then
        Commons:printLog_Info("第6位数字是：",showNumber_6_value)
        roomNo = roomNo .. showNumber_6_value;
    end

    if roomNo ~= nil and roomNo ~= "" then
        Commons:printLog_Info("房间号是：",roomNo)
        param[Room.Bean.roomNo] = roomNo
    end

    if param ~= nil and type(param) == "table" then
        loadingPop_window_joinRoom = CDAlertLoading.new():popDialogBox(pop_window, Strings.hint_Loading)
        RequestHome:getRoomJoin(param, function(...) JoinRoomDialog:resDataRoomCreate(...) end)
    end
end

function JoinRoomDialog:resDataRoomCreate(jsonObj)
    if loadingPop_window_joinRoom~=nil and (not tolua.isnull(loadingPop_window_joinRoom)) then
        loadingPop_window_joinRoom:removeFromParent()
        loadingPop_window_joinRoom = nil
    end

    showNumber_1_value = ""
    showNumber_2_value = ""
    showNumber_3_value = ""
    showNumber_4_value = ""
    showNumber_5_value = ""
    showNumber_6_value = ""

    if jsonObj~=nil then
        local status = jsonObj[ParseBase.status]
        local msg = RequestBase:getStrDecode(jsonObj[ParseBase.msg])
        Commons:printLog_Info("状态是：", status, "内容是：", msg)

        if status ~= nil and status == CEnum.status.success then
            local _data = jsonObj[ParseBase.data];
            local roomObj
            if _data ~= nil then
                roomObj = _data[User.Bean.room]
                Commons:printLog_Info("房间号是：",roomObj[Room.Bean.roomNo],  "状态是：",roomObj[Room.Bean.status])

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
                        Commons:printLog_Info("=====join room=====socket ip port shareUrl：", Sockets.connect.ip, Sockets.connect.port, Strings.gameing_share_jumpUrl);
                    end
                end

                if tag then
                    -- 弹出错误
                    CDAlertManu.new():popDialogBox(p_parent, Strings.hint_NoSocketIpPort)
                    -- 关闭当前弹窗
                    JoinRoomDialog:myExit()
                else
                    -- 记录房间信息
                    local roomNo = roomObj[Room.Bean.roomNo]
                    CVar._static.roomNo = roomNo 
                    GameStateUserGameing:new():setData(roomObj)

                    -- 进入房间页面
                    if roomObj[Room.Bean.gameAlias] and roomObj[Room.Bean.gameAlias]==CEnum.gameType.pdk then
                        Commons:gotoPDKRoom()
                    elseif roomObj[Room.Bean.gameAlias] and roomObj[Room.Bean.gameAlias]==CEnum.gameType.hzmj then
                        CommonsM:gotoMJRoom()
                    else
                        Commons:gotoGameing()
                    end

                    -- 关闭当前弹窗
                    JoinRoomDialog:myExit()
                end
            end
        else
            -- 弹出错误
            CDAlertManu.new():popDialogBox(p_parent, msg) -- 有明显的关闭按钮，触屏也可以消失
            -- CDAlertManu.new():popDialogBox(p_parent, msg, true) -- 需要用户点击后才消失，触屏也可以消失
            -- CDAlert.new():popDialogBox(p_parent, msg) -- 会自动关闭
            -- CDAlertLoading.new():popDialogBox(p_parent, msg) -- 必须程序来关闭，用户无法关闭
            -- CDialog.new():popDialogBox(p_parent, nil, "你好", function() end, function() end) -- 有确认和取消按钮操作

            -- 关闭当前弹窗
            JoinRoomDialog:myExit()
        end
    end
end

function JoinRoomDialog:getLgeLat()
    local function CreateRoomDialog_CallbackLua_LgeLat(lgeLat)
        if Commons:checkIsNull_str(lgeLat) then
            --CDAlertManu.new():popDialogBox(pop_window, lgeLat)
            local _lgeLat = string.split(lgeLat, ",")
            if type(_lgeLat)=="table" then
                local _size = #_lgeLat
                if _size == 2 then
                    CVar._static.Lge = _lgeLat[1]
                    CVar._static.Lat = _lgeLat[2]
                    -- CDAlertManu.new():popDialogBox(pop_window, "加入房间："..CVar._static.Lge.."|"..CVar._static.Lat)
                end
            end
        end
    end
    Commons:getLgeLat(CreateRoomDialog_CallbackLua_LgeLat)
end

function JoinRoomDialog:ctor()
end

function JoinRoomDialog:onExit()
    JoinRoomDialog:myExit()
end

function JoinRoomDialog:myExit()
    p_parent = nil

    roomNo = ""
    _position = 1  -- 输入的位置

    -- 输入的值，int型
    showNumber_1_value = nil
    showNumber_2_value = nil
    showNumber_3_value = nil
    showNumber_4_value = nil
    showNumber_5_value = nil
    showNumber_6_value = nil
    -- 组件 button
    showNumber_1 = nil
    showNumber_2 = nil
    showNumber_3 = nil
    showNumber_4 = nil
    showNumber_5 = nil
    showNumber_6 = nil

    if pop_window ~= nil and (not tolua.isnull(pop_window)) then
        pop_window:removeFromParent()
        pop_window = nil
    end
end

return JoinRoomDialog
