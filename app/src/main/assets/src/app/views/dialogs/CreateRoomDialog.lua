--
-- Author: lte
-- Date: 2016-10-19 12:40:33
--  创建房间的弹窗


local CreateRoomDialog = class("CreateRoomDialog")


local osWidth = Commons.osWidth
local osHeight = Commons.osHeight

local startX_gaping
local startX_1row
local startX_1row_end


local rounds = CEnum.round._8
local potRule = CEnum.no
local fanRule = CEnum.fanRule.fan
local multRule = CEnum.multRule.single
local mtRule = CEnum.mtRule.xz -- 默认小桌子

local isDlz = CEnum.isDlz.no -- 默认不逗溜子
local dlzLevel = CEnum.dlzLevel._1
local flzUnit = CEnum.flzUnit._80
local dlzLevel_View = nil -- 庄闲页面
local flzUnit_View = nil -- 1登页面

-- 代号
local rounds_code = 1
local potRule_code = 2
local fanRule_code = 3
local multRule_code = 4
local mtRule_code = 5

local isDlz_code = 55
local dlzLevel_code = 555
local flzUnit_code = 5555

-- 一些公用变量
local imagesSelect = { on=Imgs.c_check_yes, off=Imgs.c_check_no}

local p_parent
local pop_window

-- 创建一个模态弹出框, parent 要加在哪个上面
function CreateRoomDialog:popDialogBox(_parent)
    p_parent = _parent

    pop_window = display.newColorLayer(cc.c4b(0, 0, 0, 100))       -- 半透明的黑色

    pop_window:setContentSize(osWidth, osHeight)             -- 设置Layer的大小,全屏出现
    --pop_window:align(display.CENTER, display.cx, display.cy) -- Layer的锚点在0.5,0.5 因此对齐的时候要注意
    pop_window:setTouchEnabled(true)
    pop_window:setTouchSwallowEnabled(true)  -- 吞噬下层的响应
    pop_window:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event) -- 点击此Layer时候输出信息,然后把自己销毁
        return true
    end)
    _parent:addChild(pop_window, CEnum.ZOrder.common_dialog) -- 把Layer添加到父对象上

    startX_gaping = 86
    startX_1row = startX_gaping+114
    startX_1row_end = startX_1row+214-50
    local startY_gaping = 74

    if CEnum.Environment.gameCode == CEnum.gameType.wmq then
        startY_gaping = 14
    elseif CEnum.Environment.gameCode == CEnum.gameType.chz then
        startY_gaping = 34
    end

    if CVar._static.isIphone4 then
        startX_1row = startX_1row -70
        startX_1row_end = startX_1row_end -70
    elseif CVar._static.isIpad then
        startX_gaping = 56
        startX_1row = startX_gaping+114
        startX_1row_end = startX_1row+214-10

        startX_1row = startX_1row -70
        startX_1row_end = startX_1row_end -70
    elseif CVar._static.NavBarH_Android ~= CEnum.status.NavBarH_def then
        startX_1row = startX_1row -CVar._static.NavBarH_Android/2
        startX_1row_end = startX_1row_end -70
    end




    ---[[
    -- 整个底色背景
    local bgImg = cc.ui.UIImage.new(Imgs.dialog_bg,{})
        :addTo(pop_window)
        :align(display.CENTER, display.cx, display.cy)
        :setLayoutSize(osWidth-startX_gaping*2, osHeight-startY_gaping*2)
    --]]

    -- 内容背景
    local contentImg = cc.ui.UIImage.new(Imgs.dialog_content_bg,{})
        :addTo(pop_window)
        :align(display.CENTER, display.cx, display.cy-90/2)
        :setLayoutSize(osWidth-startX_gaping*2-10*2, osHeight-startY_gaping*2-100)

    -- logo
    local logoImg = cc.ui.UIImage.new(Imgs.room_create_logo,{})
        :addTo(pop_window)
        :align(display.CENTER_TOP, display.cx, osHeight-startY_gaping-(100-64)/2)

    -- 关闭
    local closeBtn = cc.ui.UIPushButton.new(Imgs.dialog_exit,{scale9=false})
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
            CreateRoomDialog:myExit()

        end)
        :addTo(pop_window)
        :align(display.CENTER_TOP, osWidth-startX_gaping-10*2-startY_gaping/2-10, osHeight-startY_gaping-22)

    -- 确定按钮
    local submitBtn = cc.ui.UIPushButton.new(
        Imgs.dialog_btn_confim,{scale9=false})
        -- :setButtonSize(278, 100)
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
        :setButtonImage(EnStatus.pressed, Imgs.dialog_btn_confim_press)
        :onButtonClicked(function(e)

            VoiceDealUtil:playSound_other(Voices.file.ui_click)
            CreateRoomDialog:myConfim()

        end)
        :align(display.CENTER_BOTTOM, display.cx, startY_gaping+10)
        :addTo(pop_window)
        :setScale(0.9)

    if CEnum.Environment.gameCode == CEnum.gameType.wmq then
        -- 偎麻雀独有：
        -- 局数
        CreateRoomDialog:create_1jushu()
        -- 名堂选择
        CreateRoomDialog:create_2mt()
        -- 逗留子
        CreateRoomDialog:create_5dlz_dlzLevel()
        CreateRoomDialog:create_5dlz_flzUnit()
        CreateRoomDialog:create_5dlz()

    elseif CEnum.Environment.gameCode == CEnum.gameType.chz then
        -- 扯胡子独有：
        -- 局数
        CreateRoomDialog:create_1jushu_chz()
        -- 加底
        CreateRoomDialog:create_2jiadi()
        -- 翻跟醒
        CreateRoomDialog:create_3fgx()
        -- 单双醒
        CreateRoomDialog:create_4dsx()
    end

    if CVar._static.appstoreSwitch == CEnum.appstoreSwitch.open then
        CreateRoomDialog:getLgeLat()
    end
end


function CreateRoomDialog:createViewByLine_4select_new(tag, pop_view, 
    first_btn_str, second_btn_str, third_btn_str, four_btn_str,
    first_btn_img, second_btn_img, third_btn_img, four_btn_img,
    first_btn_x, first_btn_y)

    local _8ju, _16ju, _24ju, _36ju
    local function updateCheckBoxButtonLabel(tabIndex)
        if tabIndex == first_btn_str then
            _8ju:setButtonSelected(true) 
            _16ju:setButtonSelected(false)
            if _24ju ~= nil then
                _24ju:setButtonSelected(false)
            end
            if _36ju ~= nil then
                _36ju:setButtonSelected(false)
            end
        elseif tabIndex == second_btn_str then
            _8ju:setButtonSelected(false)
            _16ju:setButtonSelected(true)
            if _24ju ~= nil then
                _24ju:setButtonSelected(false)
            end
            if _36ju ~= nil then
                _36ju:setButtonSelected(false)
            end
        elseif tabIndex == third_btn_str then
            _8ju:setButtonSelected(false)
            _16ju:setButtonSelected(false)
            if _24ju ~= nil then
                _24ju:setButtonSelected(true)
            end
            if _36ju ~= nil then
                _36ju:setButtonSelected(false)
            end
        elseif tabIndex == four_btn_str then
            _8ju:setButtonSelected(false)
            _16ju:setButtonSelected(false)
            if _24ju ~= nil then
                _24ju:setButtonSelected(false)
            end
            if _36ju ~= nil then
                _36ju:setButtonSelected(true)
            end
        end

        if tag == rounds_code then
            rounds = tabIndex
            GameState_VoiceSetting:setDataSingle(CEnum.round.round, tabIndex)
        elseif tag == potRule_code then
            potRule = tabIndex
            GameState_VoiceSetting:setDataSingle(CEnum.jiadi.jiadi, tabIndex)
        elseif tag == fanRule_code then
            fanRule = tabIndex
            GameState_VoiceSetting:setDataSingle(CEnum.fanRule.fanRule, tabIndex)
        elseif tag == multRule_code then
            multRule = tabIndex
            GameState_VoiceSetting:setDataSingle(CEnum.multRule.multRule, tabIndex)
        elseif tag == mtRule_code then
            mtRule = tabIndex
            GameState_VoiceSetting:setDataSingle(CEnum.mtRule.mtRule, tabIndex)
        elseif tag == isDlz_code then
            isDlz = tabIndex
            GameState_VoiceSetting:setDataSingle(CEnum.isDlz.isDlz, tabIndex)
            if tabIndex==CEnum.isDlz.yes then
                if dlzLevel_View ~= nil then
                    dlzLevel_View:show()
                end
                if flzUnit_View ~= nil then
                    flzUnit_View:show()
                end
            else
                if dlzLevel_View ~= nil then
                    dlzLevel_View:hide()
                end
                if flzUnit_View ~= nil then
                    flzUnit_View:hide()
                end
            end
        elseif tag == dlzLevel_code then
            dlzLevel = tabIndex
            GameState_VoiceSetting:setDataSingle(CEnum.dlzLevel.dlzLevel, tabIndex)
        elseif tag == flzUnit_code then
            flzUnit = tabIndex
            GameState_VoiceSetting:setDataSingle(CEnum.flzUnit.flzUnit, tabIndex)
        end
    end


    -- 第2个开始 间距变小
    local moveX = 0
    if third_btn_str ~= nil then
        moveX = 120
        if CVar._static.isIphone4 then
            moveX = 140
        elseif CVar._static.isIpad then
            moveX = 160
        end
    end
    if third_btn_str ~= nil and four_btn_str ~= nil then
        moveX = 160
        if CVar._static.isIphone4 then
            moveX = 190
        elseif CVar._static.isIpad then
            moveX = 190
        end
    end


    -- 8局的
    local startX_1row_end8 = first_btn_x
    if CVar._static.isIphone4 then
        startX_1row_end8 = startX_1row_end8 -40
    elseif CVar._static.isIpad then
        startX_1row_end8 = startX_1row_end8 -70
    end
    -- 背景
    cc.ui.UIPushButton.new(
        -- Imgs.room_item_bg_small,{scale9=true})
        Imgs.c_transparent,{scale9=true})
        :setButtonSize(297 -moveX, 74)
        :onButtonClicked(function(e)
            updateCheckBoxButtonLabel(first_btn_str)
        end)
        :align(display.LEFT_TOP, startX_1row_end8, osHeight-first_btn_y) -- 414 154
        :addTo(pop_view)
    -- checkbtn
    _8ju = cc.ui.UICheckBoxButton.new(imagesSelect)
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
        :align(display.LEFT_TOP, startX_1row_end8 +15, osHeight-first_btn_y-8)
        :addTo(pop_view)
        :setButtonEnabled(false)
    -- 图片文字
    cc.ui.UIImage.new(first_btn_img)
        :addTo(pop_view)
        :align(display.LEFT_TOP, startX_1row_end8 +15 +50, osHeight-first_btn_y-14)


    -- 16局的
    local startX_1row_end16 = first_btn_x+300+58
    if CVar._static.isIphone4 then
        startX_1row_end16 = startX_1row_end16 -40
    elseif CVar._static.isIpad then
        startX_1row_end16 = startX_1row_end16 -70
    end
    -- 背景
    cc.ui.UIPushButton.new(
        -- Imgs.room_item_bg_small,{scale9=true})
        Imgs.c_transparent,{scale9=true})
        :setButtonSize(297 -moveX, 74)
        :onButtonClicked(function(e)
            updateCheckBoxButtonLabel(second_btn_str)
        end)
        :align(display.LEFT_TOP, startX_1row_end16 -moveX, osHeight-first_btn_y)
        :addTo(pop_view)
    -- checkbtn
    _16ju = cc.ui.UICheckBoxButton.new(imagesSelect)
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
        :align(display.LEFT_TOP, startX_1row_end16 +15 -moveX, osHeight-first_btn_y-8)
        :addTo(pop_view)
        :setButtonEnabled(false)
    -- 图片文字
    cc.ui.UIImage.new(second_btn_img)
        :addTo(pop_view)
        :align(display.LEFT_TOP, startX_1row_end16 +15 +50 -moveX, osHeight-first_btn_y-14)


    if third_btn_str ~= nil then
        -- 24局的
        -- -- 2行的方式
        -- local startX_1row_end24 = first_btn_x
        -- if CVar._static.isIphone4 or CVar._static.isIpad then
        -- end
        -- 还在一行
        local startX_1row_end24 = first_btn_x+(300+58)*2
        if CVar._static.isIphone4 then
            startX_1row_end24 = startX_1row_end24 -40
        elseif CVar._static.isIpad then
            startX_1row_end24 = startX_1row_end24 -70
        end
        -- 背景
        cc.ui.UIPushButton.new(
            -- Imgs.room_item_bg_small,{scale9=true})
            Imgs.c_transparent,{scale9=true})
            :setButtonSize(297 -moveX, 74)
            :onButtonClicked(function(e)
                updateCheckBoxButtonLabel(third_btn_str)
            end)
            :align(display.LEFT_TOP, startX_1row_end24 -moveX*2, osHeight-first_btn_y)
            :addTo(pop_view)
        -- checkbtn
        _24ju = cc.ui.UICheckBoxButton.new(imagesSelect)
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
            :align(display.LEFT_TOP, startX_1row_end24 +15 -moveX*2, osHeight-first_btn_y-8)
            :addTo(pop_view)
            :setButtonEnabled(false)
        -- 图片文字
        cc.ui.UIImage.new(third_btn_img)
            :addTo(pop_view)
            :align(display.LEFT_TOP, startX_1row_end24 +15 +50 -moveX*2, osHeight-first_btn_y-14)
    end


    if third_btn_str ~= nil and four_btn_str ~= nil then
        -- 36局的
        -- -- 2行的方式
        -- local startX_1row_end36 = startX_1row_end24 +300+58
        -- if CVar._static.isIphone4 or CVar._static.isIpad then
        --     startX_1row_end36 = startX_1row_end36 -30
        -- end
        -- 还在一行
        local startX_1row_end36 = first_btn_x+(300+58)*3
        if CVar._static.isIphone4 then
            startX_1row_end36 = startX_1row_end36 -40
        elseif CVar._static.isIpad then
            startX_1row_end36 = startX_1row_end36 -70
        end
        -- 背景
        cc.ui.UIPushButton.new(
            -- Imgs.room_item_bg_small,{scale9=true})
            Imgs.c_transparent,{scale9=true})
            :setButtonSize(297 -moveX, 74)
            :onButtonClicked(function(e)
                updateCheckBoxButtonLabel(four_btn_str)
            end)
            :align(display.LEFT_TOP, startX_1row_end36 -moveX*3, osHeight-first_btn_y)
            :addTo(pop_view)
        -- checkbtn
        _36ju = cc.ui.UICheckBoxButton.new(imagesSelect)
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
            :align(display.LEFT_TOP, startX_1row_end36 +15 -moveX*3, osHeight-first_btn_y-8)
            :addTo(pop_view)
            :setButtonEnabled(false)
        -- 图片文字
        cc.ui.UIImage.new(four_btn_img)
            :addTo(pop_view)
            :align(display.LEFT_TOP, startX_1row_end36 +15 +50 -moveX*3, osHeight-first_btn_y-14)
    end


    -- -- 默认值为第一项
    -- _8ju:setButtonSelected(true)
    -- _16ju:setButtonSelected(false)
    -- if third_btn_str ~= nil then
    --     _24ju:setButtonSelected(false)
    -- end
    -- if third_btn_str ~= nil and four_btn_str ~= nil then
    --     _36ju:setButtonSelected(false)
    -- end

    -- 记住用户的选择
    if tag == rounds_code then
        local _temp = GameState_VoiceSetting:getDataSingle(CEnum.round.round)
        if _temp ~= nil and _temp==CEnum.round._16 then
            _8ju:setButtonSelected(false)
            _16ju:setButtonSelected(true)
            rounds = _temp
        else
            _8ju:setButtonSelected(true)
            _16ju:setButtonSelected(false)
            rounds = CEnum.round._8
            GameState_VoiceSetting:setDataSingle(CEnum.round.round, rounds)
        end

    elseif tag == potRule_code then
        local _temp = GameState_VoiceSetting:getDataSingle(CEnum.jiadi.jiadi)
        if _temp ~= nil and _temp==CEnum.jiadi.yes then
            _8ju:setButtonSelected(false)
            _16ju:setButtonSelected(true)
            potRule = _temp
        else
            _8ju:setButtonSelected(true)
            _16ju:setButtonSelected(false)
            potRule = CEnum.jiadi.no
            GameState_VoiceSetting:setDataSingle(CEnum.jiadi.jiadi, potRule)
        end

    elseif tag == fanRule_code then
        local _temp = GameState_VoiceSetting:getDataSingle(CEnum.fanRule.fanRule)
        if _temp ~= nil and _temp==CEnum.fanRule.gen then
            _8ju:setButtonSelected(false)
            _16ju:setButtonSelected(true)
            fanRule = _temp
        else
            _8ju:setButtonSelected(true)
            _16ju:setButtonSelected(false)
            fanRule = CEnum.fanRule.fan
            GameState_VoiceSetting:setDataSingle(CEnum.fanRule.fanRule, fanRule)
        end

    elseif tag == multRule_code then
        local _temp = GameState_VoiceSetting:getDataSingle(CEnum.multRule.multRule)
        if _temp ~= nil and _temp==CEnum.multRule.double then
            _8ju:setButtonSelected(false)
            _16ju:setButtonSelected(true)
            multRule = _temp
        else
            _8ju:setButtonSelected(true)
            _16ju:setButtonSelected(false)
            multRule = CEnum.multRule.single
            GameState_VoiceSetting:setDataSingle(CEnum.multRule.multRule, multRule)
        end

    elseif tag == mtRule_code then
        local _temp = GameState_VoiceSetting:getDataSingle(CEnum.mtRule.mtRule)
        if _temp ~= nil and _temp==CEnum.mtRule.laoMt then
            _8ju:setButtonSelected(false)
            _16ju:setButtonSelected(false)
            if _24ju ~= nil then
                _24ju:setButtonSelected(false)
            end
            if _36ju ~= nil then
                _36ju:setButtonSelected(true)
            end
            mtRule = _temp
        elseif _temp ~= nil and _temp==CEnum.mtRule.quanMt then
            _8ju:setButtonSelected(false)
            _16ju:setButtonSelected(false)
            if _24ju ~= nil then
                _24ju:setButtonSelected(true)
            end
            if _36ju ~= nil then
                _36ju:setButtonSelected(false)
            end
            mtRule = _temp
        elseif _temp ~= nil and _temp==CEnum.mtRule.dz then
            _8ju:setButtonSelected(false)
            _16ju:setButtonSelected(true)
            if _24ju ~= nil then
                _24ju:setButtonSelected(false)
            end
            if _36ju ~= nil then
                _36ju:setButtonSelected(false)
            end
            mtRule = _temp
        else
            _8ju:setButtonSelected(true)
            _16ju:setButtonSelected(false)
            if _24ju ~= nil then
                _24ju:setButtonSelected(false)
            end
            if _36ju ~= nil then
                _36ju:setButtonSelected(false)
            end
            mtRule = CEnum.mtRule.xz
            GameState_VoiceSetting:setDataSingle(CEnum.mtRule.mtRule, mtRule)
        end

    elseif tag == isDlz_code then
        local _temp = GameState_VoiceSetting:getDataSingle(CEnum.isDlz.isDlz)
        if _temp ~= nil and _temp==CEnum.isDlz.yes then
            _8ju:setButtonSelected(false)
            _16ju:setButtonSelected(true)
            isDlz = _temp

            if dlzLevel_View ~= nil then
                dlzLevel_View:show()
            end
            if flzUnit_View ~= nil then
                flzUnit_View:show()
            end
        else
            _8ju:setButtonSelected(true)
            _16ju:setButtonSelected(false)
            isDlz = CEnum.isDlz.no
            GameState_VoiceSetting:setDataSingle(CEnum.isDlz.isDlz, isDlz)
            
            if dlzLevel_View ~= nil then
                dlzLevel_View:hide()
            end
            if flzUnit_View ~= nil then
                flzUnit_View:hide()
            end
        end

    elseif tag == dlzLevel_code then
        local _temp = GameState_VoiceSetting:getDataSingle(CEnum.dlzLevel.dlzLevel)
        if _temp ~= nil and _temp==CEnum.dlzLevel._3 then
            _8ju:setButtonSelected(false)
            _16ju:setButtonSelected(false)
            if _24ju ~= nil then
                _24ju:setButtonSelected(true)
            end
            dlzLevel = _temp
        elseif _temp ~= nil and _temp==CEnum.dlzLevel._2 then
            _8ju:setButtonSelected(false)
            _16ju:setButtonSelected(true)
            if _24ju ~= nil then
                _24ju:setButtonSelected(false)
            end
            dlzLevel = _temp
        else
            _8ju:setButtonSelected(true)
            _16ju:setButtonSelected(false)
            if _24ju ~= nil then
                _24ju:setButtonSelected(false)
            end
            dlzLevel = CEnum.dlzLevel._1
            GameState_VoiceSetting:setDataSingle(CEnum.dlzLevel.dlzLevel, dlzLevel)
        end

    elseif tag == flzUnit_code then
        local _temp = GameState_VoiceSetting:getDataSingle(CEnum.flzUnit.flzUnit)
        if _temp ~= nil and _temp==CEnum.flzUnit._200 then
            _8ju:setButtonSelected(false)
            _16ju:setButtonSelected(false)
            if _24ju ~= nil then
                _24ju:setButtonSelected(true)
            end
            flzUnit = _temp
        elseif _temp ~= nil and _temp==CEnum.flzUnit._100 then
            _8ju:setButtonSelected(false)
            _16ju:setButtonSelected(true)
            if _24ju ~= nil then
                _24ju:setButtonSelected(false)
            end
            flzUnit = _temp
        else
            _8ju:setButtonSelected(true)
            _16ju:setButtonSelected(false)
            if _24ju ~= nil then
                _24ju:setButtonSelected(false)
            end
            flzUnit = CEnum.flzUnit._80
            GameState_VoiceSetting:setDataSingle(CEnum.flzUnit.flzUnit, flzUnit)
        end
    end
end



-- 局数
function CreateRoomDialog:create_1jushu()

    local moveX = 80+20
    -- 局数
    cc.ui.UIImage.new(Imgs.room_1jushu)
        :addTo(pop_window)
        :align(display.LEFT_TOP, startX_1row, osHeight-316 +70 +moveX) -- y值越小，位置就越靠底部

    -- 一组 radio button
    if CVar._static.appstoreSwitch == CEnum.appstoreSwitch.close then
        CreateRoomDialog:createViewByLine_4select_new(rounds_code, pop_window, 
                        CEnum.round._8, CEnum.round._16, nil, nil,
                        Imgs.room_1jushu_8_close, Imgs.room_1jushu_16_close, nil, nil,
                        startX_1row_end, 316 -82 -moveX)  -- y值越大，就越靠底部
    else
        CreateRoomDialog:createViewByLine_4select_new(rounds_code, pop_window, 
                        CEnum.round._8, CEnum.round._16, nil, nil,
                        Imgs.room_1jushu_8, Imgs.room_1jushu_16, nil, nil,
                        startX_1row_end, 316 -82 -moveX)  -- y值越大，就越靠底部
    end

    --底线
    local line = cc.ui.UIImage.new(Imgs.room_line)
        :align(display.LEFT_TOP, startX_gaping, osHeight-316 -13 +moveX) -- y值越小，位置就越靠底部
        :addTo(pop_window)
        :setLayoutSize(osWidth-startX_gaping*2, 2)
end

-- 名堂
function CreateRoomDialog:create_2mt()

    local moveX = 34-20
    -- 名堂
    cc.ui.UIImage.new(Imgs.room_2mt)
        :addTo(pop_window)
        :align(display.LEFT_TOP, startX_1row, osHeight-316 +70 -moveX) -- y值越小，位置就越靠底部

    -- 一组 radio button
    CreateRoomDialog:createViewByLine_4select_new(mtRule_code, pop_window, 
                CEnum.mtRule.xz, CEnum.mtRule.dz, CEnum.mtRule.quanMt, CEnum.mtRule.laoMt, 
                Imgs.room_2mt_xz, Imgs.room_2mt_dz, Imgs.room_2mt_quanmt, Imgs.room_2mt_laomt,
                startX_1row_end, 316 -82 +moveX) -- y值越大，就越靠底部

    --底线
    local line = cc.ui.UIImage.new(Imgs.room_line)
        :align(display.LEFT_TOP, startX_gaping, osHeight-316 -13 -moveX) -- y值越小，位置就越靠底部
        :addTo(pop_window)
        :setLayoutSize(osWidth-startX_gaping*2, 2)
end

-- 逗溜子
function CreateRoomDialog:create_5dlz()

    local moveX = 34*4.5-20
    -- 逗溜子
    cc.ui.UIImage.new(Imgs.room_5dlz_selet)
        :addTo(pop_window)
        :align(display.LEFT_TOP, startX_1row, osHeight-316 +70 -moveX) -- y值越小，位置就越靠底部

    -- 一组 radio button
    CreateRoomDialog:createViewByLine_4select_new(isDlz_code, pop_window, 
                CEnum.isDlz.no, CEnum.isDlz.yes, nil, nil, 
                Imgs.room_5dlz_selet_no, Imgs.room_5dlz_selet_yes, nil, nil,
                startX_1row_end, 316 -82 +moveX) -- y值越大，就越靠底部
end
-- 逗溜子
function CreateRoomDialog:create_5dlz_dlzLevel()

    dlzLevel_View = display.newNode():addTo(pop_window)

    local moveX = 34*7-20
    -- 逗溜子
    cc.ui.UIImage.new(Imgs.room_5dlz_zx)
        :addTo(dlzLevel_View)
        :align(display.LEFT_TOP, startX_1row, osHeight-316 +70 -moveX) -- y值越小，位置就越靠底部

    -- 一组 radio button
    CreateRoomDialog:createViewByLine_4select_new(dlzLevel_code, dlzLevel_View, 
                CEnum.dlzLevel._1, CEnum.dlzLevel._2, CEnum.dlzLevel._3, nil, 
                Imgs.room_5dlz_zx_1, Imgs.room_5dlz_zx_2, Imgs.room_5dlz_zx_3, nil,
                startX_1row_end, 316 -82 +moveX) -- y值越大，就越靠底部
end
-- 逗溜子
function CreateRoomDialog:create_5dlz_flzUnit()

    flzUnit_View = display.newNode():addTo(pop_window)

    local moveX = 34*9.5-20
    -- 逗溜子
    cc.ui.UIImage.new(Imgs.room_5dlz_deng)
        :addTo(flzUnit_View)
        :align(display.LEFT_TOP, startX_1row, osHeight-316 +70 -moveX) -- y值越小，位置就越靠底部

    -- 一组 radio button
    CreateRoomDialog:createViewByLine_4select_new(flzUnit_code, flzUnit_View, 
                CEnum.flzUnit._80, CEnum.flzUnit._100, CEnum.flzUnit._200, nil, 
                Imgs.room_5dlz_deng_1, Imgs.room_5dlz_deng_2, Imgs.room_5dlz_deng_3, nil,
                startX_1row_end, 316 -82 +moveX) -- y值越大，就越靠底部
end



-- 局数
function CreateRoomDialog:create_1jushu_chz()

    -- 局数
    cc.ui.UIImage.new(Imgs.room_1jushu)
        :addTo(pop_window)
        :align(display.LEFT_TOP, startX_1row, osHeight-166) -- y值越小，位置就越靠底部

    -- 一组 radio button
    if CVar._static.appstoreSwitch == CEnum.appstoreSwitch.close then
        CreateRoomDialog:createViewByLine_4select_new(rounds_code, pop_window, 
                        CEnum.round._8, CEnum.round._16, nil, nil,
                        Imgs.room_1jushu_8_close, Imgs.room_1jushu_16_close, nil, nil,
                        startX_1row_end, 154) -- y值越大，就越靠底部
    else
        CreateRoomDialog:createViewByLine_4select_new(rounds_code, pop_window, 
                        CEnum.round._8, CEnum.round._16, nil, nil,
                        Imgs.room_1jushu_8, Imgs.room_1jushu_16, nil, nil,
                        startX_1row_end, 154) -- y值越大，就越靠底部
    end

    --底线
    local line = cc.ui.UIImage.new(Imgs.room_line)
        :align(display.LEFT_TOP, 98, osHeight-244)
        :addTo(pop_window)
        :setLayoutSize(osWidth-startX_gaping*2, 2)
    if CVar._static.isIphone4 or CVar._static.isIpad then
        line:align(display.LEFT_TOP, startX_gaping, osHeight-244)
    end
end

-- 加底
function CreateRoomDialog:create_2jiadi()

    -- 加底
    cc.ui.UIImage.new(Imgs.room_2jiadi,{})
        :addTo(pop_window)
        :align(display.LEFT_TOP, startX_1row, osHeight-272) -- y值越小，位置就越靠底部

    -- 一组 radio button
    CreateRoomDialog:createViewByLine_4select_new(potRule_code, pop_window, 
                    CEnum.jiadi.no, CEnum.jiadi.yes, nil, nil,
                    Imgs.room_2jiadi_no, Imgs.room_2jiadi_yes, nil, nil,
                    startX_1row_end, 260) -- y值越大，就越靠底部

    --底线
    local line = cc.ui.UIImage.new(Imgs.room_line)
        :addTo(pop_window)
        :align(display.LEFT_TOP, 98, osHeight-244-103)
        :setLayoutSize(osWidth-startX_gaping*2, 2)
    if CVar._static.isIphone4 or CVar._static.isIpad then
        line:align(display.LEFT_TOP, startX_gaping, osHeight-244-103)
    end
end

-- 翻跟醒
function CreateRoomDialog:create_3fgx()

    -- 翻跟醒
    cc.ui.UIImage.new(Imgs.room_3fgx,{})
        :addTo(pop_window)
        :align(display.LEFT_TOP, startX_1row, osHeight-375) -- y值越小，位置就越靠底部

    -- 一组 radio button
    CreateRoomDialog:createViewByLine_4select_new(fanRule_code, pop_window, 
                CEnum.fanRule.fan, CEnum.fanRule.gen, nil, nil,
                Imgs.room_3fgx_fan, Imgs.room_3fgx_gen, nil, nil,
                startX_1row_end, 364) -- y值越大，就越靠底部

    --底线
    local line = cc.ui.UIImage.new(Imgs.room_line)
        :addTo(pop_window)
        :align(display.LEFT_TOP, 98, osHeight-244-103*2)
        :setLayoutSize(osWidth-startX_gaping*2, 2)
    if CVar._static.isIphone4 or CVar._static.isIpad then
        line:align(display.LEFT_TOP, startX_gaping, osHeight-244-103*2)
    end
end

-- 单双醒
function CreateRoomDialog:create_4dsx()

    -- 单双醒
    cc.ui.UIImage.new(Imgs.room_4dsx,{})
        :addTo(pop_window)
        :align(display.LEFT_TOP, startX_1row, osHeight-478) -- y值越小，位置就越靠底部

    -- 一组 radio button
    CreateRoomDialog:createViewByLine_4select_new(multRule_code, pop_window, 
                CEnum.multRule.single, CEnum.multRule.double, nil, nil,
                Imgs.room_4dsx_single, Imgs.room_4dsx_double, nil, nil,
                startX_1row_end, 466) -- y值越大，就越靠底部
end

function CreateRoomDialog:getLgeLat()
    local function CreateRoomDialog_CallbackLua_LgeLat(lgeLat)
        if Commons:checkIsNull_str(lgeLat) then
            --CDAlertManu.new():popDialogBox(pop_window, lgeLat)
            local _lgeLat = string.split(lgeLat, ",")
            if type(_lgeLat)=="table" then
                local _size = #_lgeLat
                if _size == 2 then
                    CVar._static.Lge = _lgeLat[1]
                    CVar._static.Lat = _lgeLat[2]
                    -- CDAlertManu.new():popDialogBox(pop_window, "创建phz房间："..CVar._static.Lge.."|"..CVar._static.Lat)
                end
            end
        end
    end
    Commons:getLgeLat(CreateRoomDialog_CallbackLua_LgeLat)
end

--local socket = require "socket"
-- local startTime = nil
local loadingPop_window_createRoom
function CreateRoomDialog:myConfim()
    local param = {}

    if rounds ~= nil then
        Commons:printLog_Info("回合数：",Room.Bean.rounds,rounds)
        param[Room.Bean.rounds] = rounds
    end

    if CEnum.Environment.gameCode == CEnum.gameType.wmq then
        -- 偎麻雀独有：
        if mtRule ~= nil then
            Commons:printLog_Info("名堂规则：",Room.Bean.mtRule,mtRule)
            param[Room.Bean.mtRule] = mtRule
        end

        if isDlz ~= nil then
            Commons:printLog_Info("是否逗溜子：",Room.Bean.isDlz,isDlz)
            param[Room.Bean.isDlz] = isDlz
            if CEnum.isDlz.yes == isDlz then
                param[Room.Bean.dlzLevel] = dlzLevel
                param[Room.Bean.flzUnit] = flzUnit
            end
        end
    elseif CEnum.Environment.gameCode == CEnum.gameType.chz then
        -- 扯胡子独有：
        if potRule ~= nil then
            Commons:printLog_Info("加底规则：",Room.Bean.potRule,potRule)
            param[Room.Bean.potRule] = potRule
        end
        if fanRule ~= nil then
            Commons:printLog_Info("翻牌规则：",Room.Bean.fanRule,fanRule)
            param[Room.Bean.fanRule] = fanRule
        end
        if multRule ~= nil then
            Commons:printLog_Info("加倍规则：",Room.Bean.multRule,multRule)
            param[Room.Bean.multRule] = multRule
        end
    end    

    if param ~= nil and type(param) == "table" then
        loadingPop_window_createRoom = CDAlertLoading.new():popDialogBox(pop_window, Strings.hint_Loading)
        RequestHome:getRoomCreate(param, function(...) CreateRoomDialog:resDataRoomCreate(...) end) 
    end
end

function CreateRoomDialog:resDataRoomCreate(jsonObj)
    if loadingPop_window_createRoom~=nil and (not tolua.isnull(loadingPop_window_createRoom)) then
        loadingPop_window_createRoom:removeFromParent()
        loadingPop_window_createRoom = nil
    end

    if jsonObj~=nil then
        local status = jsonObj[ParseBase.status]
        local msg = RequestBase:getStrDecode(jsonObj[ParseBase.msg])
        Commons:printLog_Info("状态是：", status, "内容是：", msg)

        if status ~= nil and status == CEnum.status.success then
            local _data = jsonObj[ParseBase.data];
            if _data~=nil then

                local roomObj = _data[User.Bean.room]
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
                        Commons:printLog_Info("=====creat room=====socket ip port shareUrl：", Sockets.connect.ip, Sockets.connect.port, Strings.gameing_share_jumpUrl);
                    end
                end

                if tag then
                    -- 弹出错误
                    CDAlertManu.new():popDialogBox(p_parent, Strings.hint_NoSocketIpPort)

                    -- 关闭当前弹窗
                    CreateRoomDialog:myExit()
                else
                    -- 记录房间信息
                    local roomNo = roomObj[Room.Bean.roomNo]
                    CVar._static.roomNo = roomNo
                    GameStateUserGameing:new():setData(roomObj)

                    -- 进入房间页面
                    -- local entTime = os.clock()--socket.gettime()
                    -- local _time = entTime - startTime
                    -- print("------------time：创建房间http请求回来耗时：".._time.." 秒")

                    -- startTime = os.clock()--socket.gettime()
                    Commons:gotoGameing()
                    -- entTime = os.clock()--socket.gettime()
                    -- _time = entTime - startTime
                    -- print("------------time：登录房间socket，显示桌面耗时：".._time.." 秒")
                    
                    -- 关闭当前弹窗
                    CreateRoomDialog:myExit()
                end
            end
        else
            -- 弹出错误
            CDAlertManu.new():popDialogBox(p_parent, msg)
            -- 关闭当前弹窗
            CreateRoomDialog:myExit()
        end
    end
end


-- 构造函数
function CreateRoomDialog:ctor()
end

function CreateRoomDialog:onExit()
    CreateRoomDialog:myExit()
end

function CreateRoomDialog:myExit()
    ---[[

    -- 这个类的类变量要全部恢复初始值
    -- rounds = CEnum.round._8
    -- potRule = CEnum.no
    -- fanRule = CEnum.fanRule.fan
    -- multRule = CEnum.multRule.single -- 创建房间需要的值
    -- mtRule = CEnum.mtRule.xz -- 默认小桌子
    -- isDlz = CEnum.isDlz.no -- 默认不逗溜子
    -- dlzLevel = CEnum.dlzLevel._1
    -- flzUnit = CEnum.flzUnit._80

    p_parent = nil
    --]]

    if pop_window ~= nil and (not tolua.isnull(pop_window)) then
        pop_window:removeFromParent()
        pop_window = nil
    end
end

-- 必须有这个返回
return CreateRoomDialog
