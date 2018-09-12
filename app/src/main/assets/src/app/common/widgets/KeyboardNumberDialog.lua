--
-- Author: lte
-- Date: 2016-10-19 12:40:33
-- 加入房间的弹窗

-- 类申明
local KeyboardNumberDialog = class("KeyboardNumberDialog")


local osWidth = Commons.osWidth
local osHeight = Commons.osHeight

local showNumber_View -- 组件 输入之后的显示数字
local showNumber_Value = "" -- 输入的值

local Fun_Back_Data -- 通配的返回函数申明
local isEncry

local gaping_w -- 整个图层的左右间距
local gaping_h -- 整个图层的上下间距
local gaping_x -- 内容背景，左右 底部 间距
local gaping_y -- 内容背景，顶部间距

local p_parent
local pop_window

-- 创建一个模态弹出框,  parent=要加在哪个上面
-- 在哪个框框上输入，用这个回调=fun_back_data
-- 是否是密文显示=isEncry
function KeyboardNumberDialog:popDialogBox(_parent, fun_back_data, _isEncry)
    showNumber_Value = "" -- 输入的值

    p_parent = _parent
    Fun_Back_Data = fun_back_data
    isEncry = _isEncry -- 如果是需要密文显示

    pop_window = display.newColorLayer(cc.c4b(0, 0, 0, 100))       -- 半透明的黑色

    pop_window:setContentSize(osWidth, osHeight)             -- 设置Layer的大小,全屏出现
    --pop_window:align(display.CENTER, display.cx, display.cy) -- Layer的锚点在0.5,0.5 因此对齐的时候要注意
    pop_window:setTouchEnabled(true)
    pop_window:setTouchSwallowEnabled(true)  -- 吞噬下层的响应
    pop_window:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event) -- 点击此Layer时候输出信息,然后把自己销毁
        return true
    end)
    p_parent:addChild(pop_window, CEnum.ZOrder.common_dialog) -- 把Layer添加到父对象上


    gaping_w = 208
    gaping_h = 70
    gaping_x = 10
    gaping_y = 74

    if CVar._static.isIphone4 then
        gaping_w = gaping_w-50
    elseif CVar._static.isIpad then
        gaping_w = gaping_w-120
    elseif CVar._static.NavBarH_Android ~= CEnum.status.NavBarH_def then
        gaping_w = gaping_w -CVar._static.NavBarH_Android/2
    end


    -- 整个底色背景
    ---[[
    cc.ui.UIImage.new(Imgs.dialog_bg,{})
        :addTo(pop_window)
    	:align(display.CENTER, display.cx, display.cy)
    	:setLayoutSize(osWidth -gaping_w*2, osHeight -gaping_h*2)
    --]]

    -- 内容背景
    cc.ui.UIImage.new(Imgs.dialog_content_bg,{})
        :addTo(pop_window)
        :align(display.CENTER, display.cx, display.cy -gaping_y*0.5)
        :setLayoutSize(osWidth -gaping_w*2 -gaping_x*2, osHeight -gaping_h*2 -gaping_y -gaping_x)

    -- logo
    cc.ui.UIImage.new(Imgs.keyboardNumber_title_logo,{})
    	:addTo(pop_window)
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
            -- 固定一个值，测试输入之后显示值
            -- KeyboardNumberDialog:showNumbers_deal(6, _position)
            --_position = _position+1
            KeyboardNumberDialog:myExit()

        end)
    	:addTo(pop_window)
        :align(display.RIGHT_TOP, osWidth -gaping_w -gaping_x, osHeight -gaping_h -11)
    
    -- 显示已经输入的数字
    KeyboardNumberDialog:create_showNumbers()

    -- 创建键盘
    KeyboardNumberDialog:create_keyboard()

    ---[[
    -- 确定按钮
    cc.ui.UIPushButton.new(
        Imgs.dialog_btn_confim_alert,{scale9=false})
        --:setButtonSize(278, 100)
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
            KeyboardNumberDialog:myConfim()

        end)
        :align(display.CENTER_BOTTOM, display.cx, gaping_h +10)
        :addTo(pop_window)
    --]]
end

function KeyboardNumberDialog:myConfim()
    if Commons:checkIsNull_str(showNumber_Value) then
        Commons:printLog_Info("数字是：", showNumber_Value)
        if Fun_Back_Data ~= nil then
            Fun_Back_Data(showNumber_Value)
        end
    else
        if Fun_Back_Data ~= nil then
            Fun_Back_Data("")
        end
    end

    KeyboardNumberDialog:myExit()
end

-- 显示已经输入的数字
local startX_showNum
local startY_showNum
function KeyboardNumberDialog:create_showNumbers()

    startX_showNum = gaping_w +46
    startY_showNum = osHeight -gaping_h-gaping_y-46
    if CVar._static.isIphone4 or CVar._static.isIpad then
        startX_showNum = startX_showNum +64
    end

    -- 第1个数字
    cc.ui.UIImage.new(Imgs.room_number_bg,{scale9=true})
        :setLayoutSize(osWidth -startX_showNum*2, 72)
        :addTo(pop_window)
        :align(display.LEFT_TOP, startX_showNum, startY_showNum)

    showNumber_View = 
        display.newNode():addTo(pop_window)
        --display.newLayer():addTo(pop_window)
            -- :setContentSize(osWidth-startX_showNum*2, 72)
        --:align(display.LEFT_TOP, startX_showNum+13, startY_showNum-10)
end

function KeyboardNumberDialog:showNumbers_view(inputText)
    Commons:printLog_Info("最后确定的数字是:", inputText)
    if Commons:checkIsNull_str(inputText) and showNumber_View ~= nil and (not tolua.isnull(showNumber_View)) then

        Commons:printLog_Info("最后确定的数字是 ----要显示出来:")
        if showNumber_View ~= nil and (not tolua.isnull(showNumber_View)) and showNumber_View:getChildrenCount()>0 then
            Commons:printLog_Info("最后确定的数字是 ----先要删除已有的:")
            showNumber_View:removeAllChildren()
        end

        -- 数字显示
        _string = tostring(inputText)
        _size = string.len(_string)
        if _size > 11 then
            _string = string.sub(_string, 1, 11)
            _size = 11
        end
        for i=1,_size do
            local i_str = string.sub(_string, i, i)
            local img_i = GameingDealUtil:getNumImgByShowNumber_RoomJoin(i_str)
            if isEncry ~= nil and isEncry then
                img_i = Imgs.room_nums_code
            end

            --cc.ui.UIPushButton.new(img_i,{scale9=false})
            --    :setButtonSize(20, 20)
            cc.ui.UIImage.new(img_i,{scale9=false})
                :setLayoutSize(46, 52)
                :addTo(showNumber_View)
                :align(display.LEFT_TOP, startX_showNum+13 +46*(i-1), startY_showNum-10)
        end
    else
        Commons:printLog_Info("最后确定的数字是 ----没有:")
        if showNumber_View ~= nil and (not tolua.isnull(showNumber_View)) and showNumber_View:getChildrenCount()>0 then
            Commons:printLog_Info("最后确定的数字是 ----没有也要删除以前的:")
            showNumber_View:removeAllChildren()
        end
    end
end

-- 输入的数字   位置
function KeyboardNumberDialog:showNumbers_deal(inputText)
    Commons:printLog_Info("用户输入的单个数字是:", inputText)
    if inputText ~= nil and inputText ~= "" and inputText~="11" and inputText~="12" then
        Commons:printLog_Info("用户输入的单个数字是 ----普通数字:")
        showNumber_Value = showNumber_Value .. inputText
        KeyboardNumberDialog:showNumbers_view(showNumber_Value)

    else
        Commons:printLog_Info("用户输入的单个数字是 ----重输或者删除:")
        if inputText ~= nil and inputText ~= "" and inputText=="11" then
            Commons:printLog_Info("重输的数字是:", inputText)
            showNumber_Value = ""
            KeyboardNumberDialog:showNumbers_view(showNumber_Value)

        elseif inputText ~= nil and inputText ~= "" and inputText=="12" then
            Commons:printLog_Info("删除的数字是:", inputText)
            if Commons:checkIsNull_str(showNumber_Value) then
                local _size = string.len(showNumber_Value)
                showNumber_Value = string.sub(showNumber_Value, 1, _size-1)
            end
            KeyboardNumberDialog:showNumbers_view(showNumber_Value)
        end 
    end
end

local keyborad_single_w = 190 -- 每个键盘的宽度
local keyborad_single_h = 86 -- 每个键盘的高度
local keyborad_single_gap = 4 -- 间距

-- 键盘组件的一一创建
function KeyboardNumberDialog:createViewByNumber(numStr, x, y)

    local _numStr = numStr;
    if numStr~=nil and numStr=="11" then
        _numStr = Strings.room_join_reset;
    elseif numStr~=nil and numStr=="12" then
        _numStr = Strings.room_join_del;
    end

    cc.ui.UIPushButton.new(
        --Imgs.room_number_bg,{scale9=true})
        --Imgs.c_transparent,{scale9=true})
        Imgs.room_join.keyboard_bg_small,{scale9=true})
        :setButtonSize(keyborad_single_w, keyborad_single_h)
        --:setButtonLabelAlignment(display.CENTER)
        :setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
            UILabelType = 2,
            text = _numStr,
            size = Dimens.TextSize_35,
            color = Colors:_16ToRGB(Colors.keyboard),
            font = Fonts.Font_hkyt_w9,
            align = cc.ui.TEXT_ALIGN_CENTER,
            valign = cc.ui.TEXT_VALIGN_CENTER,
            --dimensions = cc.size(306, 96)
         }))
        :setButtonLabel(EnStatus.pressed, cc.ui.UILabel.new({
            UILabelType = 2,
            text = _numStr,
            size = Dimens.TextSize_45,
            color = Colors:_16ToRGB(Colors.keyboard_press),
            font = Fonts.Font_hkyt_w9,
            align = cc.ui.TEXT_ALIGN_CENTER,
            valign = cc.ui.TEXT_VALIGN_CENTER,
            --dimensions = cc.size(306, 96)
         }))
        :onButtonClicked(function(e)

            VoiceDealUtil:playSound_other(Voices.file.ui_click)
            KeyboardNumberDialog:showNumbers_deal(numStr)

        end)
        :align(display.CENTER, x, y)
        :addTo(pop_window)
end

-- 创建键盘
function KeyboardNumberDialog:create_keyboard()
    local kuang_size = 88 -- 输入好的数字显示框的高度
    local startX = gaping_w +46
    local startY = osHeight -gaping_h-gaping_y -46 -kuang_size -40

    if CVar._static.isIphone4 or CVar._static.isIpad then
        startX = startX +50

        keyborad_single_w = 143
    end

    -- 背景
    -- cc.ui.UIImage.new(Imgs.room_keyboard_bg,{scale9=true})
    --  :setLayoutSize(keyborad_single_w*4, keyborad_single_h*3)
    --     :addTo(pop_window)
    --     :align(display.LEFT_TOP, startX, startY+30)

    -- =1
    KeyboardNumberDialog:createViewByNumber("1", startX+keyborad_single_w/2+keyborad_single_w*0 +keyborad_single_gap*0, startY)
    -- =2
    KeyboardNumberDialog:createViewByNumber("2", startX+keyborad_single_w/2+keyborad_single_w*1 +keyborad_single_gap*1, startY)
    -- =3
    KeyboardNumberDialog:createViewByNumber("3", startX+keyborad_single_w/2+keyborad_single_w*2 +keyborad_single_gap*2, startY)
    -- =重输
    KeyboardNumberDialog:createViewByNumber("11", startX+keyborad_single_w/2+keyborad_single_w*3 +keyborad_single_gap*3, startY)

    -- =4
    KeyboardNumberDialog:createViewByNumber("4", startX+keyborad_single_w/2+keyborad_single_w*0 +keyborad_single_gap*0, startY-(keyborad_single_h+keyborad_single_gap) )
    -- =5
    KeyboardNumberDialog:createViewByNumber("5", startX+keyborad_single_w/2+keyborad_single_w*1 +keyborad_single_gap*1, startY-(keyborad_single_h+keyborad_single_gap) )
    -- =6
    KeyboardNumberDialog:createViewByNumber("6", startX+keyborad_single_w/2+keyborad_single_w*2 +keyborad_single_gap*2, startY-(keyborad_single_h+keyborad_single_gap) )
    -- =0
    KeyboardNumberDialog:createViewByNumber("0", startX+keyborad_single_w/2+keyborad_single_w*3 +keyborad_single_gap*3, startY-(keyborad_single_h+keyborad_single_gap) )

    -- =7
    KeyboardNumberDialog:createViewByNumber("7", startX+keyborad_single_w/2+keyborad_single_w*0 +keyborad_single_gap*0, startY-(keyborad_single_h+keyborad_single_gap)*2)
    -- =8
    KeyboardNumberDialog:createViewByNumber("8", startX+keyborad_single_w/2+keyborad_single_w*1 +keyborad_single_gap*1, startY-(keyborad_single_h+keyborad_single_gap)*2)
    -- =9
    KeyboardNumberDialog:createViewByNumber("9", startX+keyborad_single_w/2+keyborad_single_w*2 +keyborad_single_gap*2, startY-(keyborad_single_h+keyborad_single_gap)*2)
    -- =删除
    KeyboardNumberDialog:createViewByNumber("12", startX+keyborad_single_w/2+keyborad_single_w*3 +keyborad_single_gap*3, startY-(keyborad_single_h+keyborad_single_gap)*2)

    -- -- =重输
    -- KeyboardNumberDialog:createViewByNumber("11", startX+keyborad_single_w/2+keyborad_single_w*0, startY-(keyborad_single_h+4)*3)
    -- -- =0
    -- KeyboardNumberDialog:createViewByNumber("0", startX+keyborad_single_w/2+keyborad_single_w*1, startY-(keyborad_single_h+4)*3)
    -- -- =删除
    -- KeyboardNumberDialog:createViewByNumber("12", startX+keyborad_single_w/2+keyborad_single_w*2, startY-(keyborad_single_h+4)*3)
end

function KeyboardNumberDialog:onExit()
    KeyboardNumberDialog:myExit()
end

function KeyboardNumberDialog:myExit()
    ---[[
    -- 这个类的类变量要全部恢复初始值
    p_parent = nil
    showNumber_Value = "" -- 输入的值
    --]]

    if pop_window ~= nil and (not tolua.isnull(pop_window)) then
        pop_window:removeFromParent()
        pop_window = nil
    end
end

return KeyboardNumberDialog
