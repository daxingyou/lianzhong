--
-- Author: luobinbin
-- Date: 2017-07-17 12:40:33
-- 创建房间

-- 类申明
local CreateMJRoomDialog = class("CreateMJRoomDialog",
	function()
		return display.newNode()
	end
)

local osWidth = Commons.osWidth
local osHeight = Commons.osHeight

local startX_gaping = 86
local startY_gaping = 18

-- 代号
local rounds_code = 1
local person_code = 2
local zimo_code = 3
local marknum_View
local marknum_code = 4
local rewardmark_code = 5
local qiduihu_code = 601
local qiangganghu_code = 602
local huangtype_code = 603

-- 一些公用变量
local imagesSelect = { on=Imgs.c_check_yes, off=Imgs.c_check_no}
local imagesRadio = { on=ImgsM.selected_radio_btn, off=ImgsM.un_select_radio_btn}
local gaping_x = 25 -- 文字和按钮的相距距离
local gapX = 40 -- 选择按钮和文字图片的相距距离
local font_ziti = Fonts.Font_hkyt_w7
local font_size = Dimens.TextSize_30
local font_color = cc.c3b(0x56, 0x0a, 0x0a) -- Colors.edit_txt
-- local size_w = 180
-- local size_h = 40
local bg_img = Imgs.room_item_bg_small -- Imgs.c_transparent -- Imgs.room_item_bg_small


function CreateMJRoomDialog:createViewByLine(tag, parent_view, 
                        first_btn_str, second_btn_str, third_btn_str, four_btn_str,
                        first_btn_img, second_btn_img, third_btn_img, four_btn_img,
                        first_btn_x, first_btn_y) 

    gapX = 40
    
    local talbe_8_btn, talbe_16_btn, talbe_24_btn, talbe_36_btn

    local function talbe_btn_handler(tabIndex)
        if tabIndex == first_btn_str then
            talbe_8_btn:setButtonSelected(true)
            if talbe_16_btn then
                talbe_16_btn:setButtonSelected(false)
            end
            if talbe_24_btn then
                talbe_24_btn:setButtonSelected(false)
            end
            if talbe_36_btn then
                talbe_36_btn:setButtonSelected(false)
            end
        elseif tabIndex == second_btn_str then
            talbe_8_btn:setButtonSelected(false)
            if talbe_16_btn then
                talbe_16_btn:setButtonSelected(true)
            end
            if talbe_24_btn then
                talbe_24_btn:setButtonSelected(false)
            end
            if talbe_36_btn then
                talbe_36_btn:setButtonSelected(false)
            end
        elseif tabIndex == third_btn_str then
            talbe_8_btn:setButtonSelected(false)
            if talbe_16_btn then
                talbe_16_btn:setButtonSelected(false)
            end
            if talbe_24_btn then
                talbe_24_btn:setButtonSelected(true)
            end
            if talbe_36_btn then
                talbe_36_btn:setButtonSelected(false)
            end
        elseif tabIndex == four_btn_str then
            talbe_8_btn:setButtonSelected(false)
            if talbe_16_btn then
                talbe_16_btn:setButtonSelected(false)
            end
            if talbe_24_btn then
                talbe_24_btn:setButtonSelected(false)
            end
            if talbe_36_btn then
                talbe_36_btn:setButtonSelected(true)
            end
        end

        VoiceDealUtil:playSound_other(Voices.file.ui_click)

        if tag == rounds_code then
            self.roundNums = tabIndex
            GameState_VoiceSetting:setDataSingle(CEnumM.round.round, self.roundNums)
        elseif tag == person_code then
            self.personNums = tabIndex
            GameState_VoiceSetting:setDataSingle(CEnumM.person.person, self.personNums)
        elseif tag == zimo_code then
            self.zimohu = tabIndex
            GameState_VoiceSetting:setDataSingle(CEnumM.zimohu.zimohu, self.zimohu)
        elseif tag == marknum_code then
            self.marknum = tabIndex
            GameState_VoiceSetting:setDataSingle(CEnumM.marknum.marknum, self.marknum)
        elseif tag == rewardmark_code then
            self.rewardmark = tabIndex
            GameState_VoiceSetting:setDataSingle(CEnumM.rewardmark.rewardmark, self.rewardmark)

            if tabIndex == CEnumM.rewardmark._159 then
                if self.markNumSprite and marknum_View then
                    self.markNumSprite:show()
                    marknum_View:show()
                end
            else
                if self.markNumSprite and marknum_View then
                    self.markNumSprite:hide()
                    marknum_View:hide()
                end
            end
        end

    end

    local startX_move = 220

    -- 8
    local startX_8 = first_btn_x
    local startY_8 = first_btn_y
    talbe_8_btn = cc.ui.UICheckBoxButton.new(imagesRadio)
        :setButtonLabel(cc.ui.UILabel.new({
            text = "",  -- first_btn_img,
            font = font_ziti,
            size = font_size,
            color = font_color
        }))
        :setButtonLabelOffset(gaping_x, 0)
        :setButtonSelected(true)
        :onButtonClicked(function(event)
          talbe_btn_handler(first_btn_str)
        end)
        :align(display.LEFT_TOP, startX_8, startY_8-5)
        :addTo(parent_view)
    cc.ui.UIPushButton.new(
            first_btn_img, {scale9=false})
            :onButtonClicked(function(e)
                talbe_btn_handler(first_btn_str)
            end)
            :align(display.LEFT_TOP, startX_8 +gapX, startY_8)
            :addTo(parent_view)
    -- cc.ui.UIImage.new(first_btn_img)
    -- -- 背景
    -- cc.ui.UIPushButton.new(bg_img, {scale9=true})
    --     :setButtonSize(size_w -moveX, size_h)
    --     :onButtonClicked(function(e)
    --         talbe_btn_handler(first_btn_str)
    --     end)
    --     :align(display.LEFT_TOP, startX_8, startY_8) -- 414 154
    --     :addTo(parent_view)

    -- 16
    if second_btn_str then
        startX_8 = first_btn_x +startX_move
        startY_8 = first_btn_y
        talbe_16_btn = cc.ui.UICheckBoxButton.new(imagesRadio)
            :setButtonLabel(cc.ui.UILabel.new({
                text = "",  -- second_btn_img,
                font = font_ziti,
                size = font_size,
                color = font_color
            }))
            :setButtonLabelOffset(gaping_x, 0)
            :setButtonSelected(true)
            :onButtonClicked(function(event)
              talbe_btn_handler(second_btn_str)
            end)
            :align(display.LEFT_TOP, startX_8, startY_8-5)
            :addTo(parent_view)
        cc.ui.UIPushButton.new(
                second_btn_img, {scale9=false})
                :onButtonClicked(function(e)
                    talbe_btn_handler(second_btn_str)
                end)
                :align(display.LEFT_TOP, startX_8 +gapX, startY_8)
                :addTo(parent_view)
    end

    -- 24
    if third_btn_str then
        startX_8 = first_btn_x +startX_move*2.1
        startY_8 = first_btn_y
        talbe_24_btn = cc.ui.UICheckBoxButton.new(imagesRadio)
            :setButtonLabel(cc.ui.UILabel.new({
                text = "",  -- third_btn_img,
                font = font_ziti,
                size = font_size,
                color = font_color
            }))
            :setButtonLabelOffset(gaping_x, 0)
            :setButtonSelected(true)
            :onButtonClicked(function(event)
              talbe_btn_handler(third_btn_str)
            end)
            :align(display.LEFT_TOP, startX_8, startY_8-5)
            :addTo(parent_view)
        cc.ui.UIPushButton.new(
                third_btn_img, {scale9=false})
                :onButtonClicked(function(e)
                    talbe_btn_handler(third_btn_str)
                end)
                :align(display.LEFT_TOP, startX_8 +gapX, startY_8)
                :addTo(parent_view)
    end

    -- 36
    if four_btn_str then
        startX_8 = first_btn_x +startX_move*3
        startY_8 = first_btn_y
        talbe_36_btn = cc.ui.UICheckBoxButton.new(imagesRadio)
            :setButtonLabel(cc.ui.UILabel.new({
                text = "",  -- four_btn_img,
                font = font_ziti,
                size = font_size,
                color = font_color
            }))
            :setButtonLabelOffset(gaping_x, 0)
            :setButtonSelected(true)
            :onButtonClicked(function(event)
              talbe_btn_handler(four_btn_str)
            end)
            :align(display.LEFT_TOP, startX_8, startY_8-5)
            :addTo(parent_view)
        cc.ui.UIPushButton.new(
                four_btn_img, {scale9=false})
                :onButtonClicked(function(e)
                    talbe_btn_handler(four_btn_str)
                end)
                :align(display.LEFT_TOP, startX_8 +gapX, startY_8)
                :addTo(parent_view)
    end

    -- 记住用户的选择
    if tag == rounds_code then
        local _temp = GameState_VoiceSetting:getDataSingle(CEnumM.round.round)
        if _temp ~= nil and _temp==CEnumM.round._24 then
            talbe_8_btn:setButtonSelected(false)
            talbe_16_btn:setButtonSelected(false)
            talbe_24_btn:setButtonSelected(true)
            self.roundNums = _temp
        elseif _temp ~= nil and _temp==CEnumM.round._16 then
            talbe_8_btn:setButtonSelected(false)
            talbe_16_btn:setButtonSelected(true)
            talbe_24_btn:setButtonSelected(false)
            self.roundNums = _temp
        else
            talbe_8_btn:setButtonSelected(true)
            talbe_16_btn:setButtonSelected(false)
            talbe_24_btn:setButtonSelected(false)
            self.roundNums = CEnumM.round._8
            GameState_VoiceSetting:setDataSingle(CEnumM.round.round, self.roundNums)
        end

    elseif tag == person_code then
        -- local _temp = GameState_VoiceSetting:getDataSingle(CEnumM.person.person)
        -- if _temp ~= nil and _temp==CEnumM.person._3 then
        --     talbe_8_btn:setButtonSelected(false)
        --     talbe_16_btn:setButtonSelected(true)
        --     self.personNums = _temp
        -- else
        --     talbe_8_btn:setButtonSelected(true)
        --     talbe_16_btn:setButtonSelected(false)
        --     self.personNums = CEnumM.person._4
        --     GameState_VoiceSetting:setDataSingle(CEnumM.person.person, self.personNums)
        -- end
        talbe_8_btn:setButtonSelected(true)
        self.personNums = CEnumM.person._4
        GameState_VoiceSetting:setDataSingle(CEnumM.person.person, self.personNums)

    elseif tag == zimo_code then
        -- local _temp = GameState_VoiceSetting:getDataSingle(CEnumM.zimohu.zimohu)
        -- if _temp ~= nil and _temp==CEnumM.zimohu.pao then
        --     talbe_8_btn:setButtonSelected(false)
        --     talbe_16_btn:setButtonSelected(true)
        --     self.zimohu = _temp
        -- else
        --     talbe_8_btn:setButtonSelected(true)
        --     talbe_16_btn:setButtonSelected(false)
        --     self.zimohu = CEnumM.zimohu.mo
        --     GameState_VoiceSetting:setDataSingle(CEnumM.zimohu.zimohu, self.zimohu)
        -- end
        talbe_8_btn:setButtonSelected(true)
        self.zimohu = CEnumM.zimohu.mo
        GameState_VoiceSetting:setDataSingle(CEnumM.zimohu.zimohu, self.zimohu)

    elseif tag == marknum_code then
        local _temp = GameState_VoiceSetting:getDataSingle(CEnumM.marknum.marknum)
        -- 为空的时候设置默认值
        if _temp == nil then
            _temp = self.marknum
            GameState_VoiceSetting:setDataSingle(CEnumM.marknum.marknum, self.marknum)
        end

        if _temp ~= nil and _temp==CEnumM.marknum._6 then
            talbe_8_btn:setButtonSelected(false)
            talbe_16_btn:setButtonSelected(false)
            talbe_24_btn:setButtonSelected(true)
            self.marknum = _temp
        elseif _temp ~= nil and _temp==CEnumM.marknum._4 then
            talbe_8_btn:setButtonSelected(false)
            talbe_16_btn:setButtonSelected(true)
            talbe_24_btn:setButtonSelected(false)
            self.marknum = _temp
        else
            talbe_8_btn:setButtonSelected(true)
            talbe_16_btn:setButtonSelected(false)
            talbe_24_btn:setButtonSelected(false)
            self.marknum = CEnumM.marknum._2
            GameState_VoiceSetting:setDataSingle(CEnumM.marknum.marknum, self.marknum)
        end

    elseif tag == rewardmark_code then
        local _temp = GameState_VoiceSetting:getDataSingle(CEnumM.rewardmark.rewardmark)
        -- 为空的时候设置默认值
        if _temp == nil then
            _temp = self.rewardmark
            GameState_VoiceSetting:setDataSingle(CEnumM.rewardmark.rewardmark, self.rewardmark)
        end

        if _temp ~= nil and _temp==CEnumM.rewardmark.oon then
            talbe_8_btn:setButtonSelected(false)
            talbe_16_btn:setButtonSelected(false)
            talbe_24_btn:setButtonSelected(false)
            talbe_36_btn:setButtonSelected(true)
            self.rewardmark = _temp
            if self.markNumSprite and marknum_View then
                self.markNumSprite:hide()
                marknum_View:hide()
            end

        elseif _temp ~= nil and _temp==CEnumM.rewardmark.ymqz then
            talbe_8_btn:setButtonSelected(false)
            talbe_16_btn:setButtonSelected(false)
            talbe_24_btn:setButtonSelected(true)
            talbe_36_btn:setButtonSelected(false)
            self.rewardmark = _temp
            if self.markNumSprite and marknum_View then
                self.markNumSprite:hide()
                marknum_View:hide()
            end

        elseif _temp ~= nil and _temp==CEnumM.rewardmark._159 then
            talbe_8_btn:setButtonSelected(false)
            talbe_16_btn:setButtonSelected(true)
            talbe_24_btn:setButtonSelected(false)
            talbe_36_btn:setButtonSelected(false)
            self.rewardmark = _temp

            if self.markNumSprite and marknum_View then
                self.markNumSprite:show()
                marknum_View:show()
            end
        else
            talbe_8_btn:setButtonSelected(true)
            talbe_16_btn:setButtonSelected(false)
            talbe_24_btn:setButtonSelected(false)
            talbe_36_btn:setButtonSelected(false)
            self.rewardmark = CEnumM.rewardmark.no
            GameState_VoiceSetting:setDataSingle(CEnumM.rewardmark.rewardmark, self.rewardmark)

            if self.markNumSprite and marknum_View then
                self.markNumSprite:hide()
                marknum_View:hide()
            end
        end

    end

end


function CreateMJRoomDialog:createViewByLine_chooseMore(tag, parent_view, 
                        first_btn_str,
                        first_btn_img, 
                        first_btn_x, first_btn_y) 

    gapX = 50 -- 选择按钮和文字图片的相距距离

    local talbe_8_btn

    local function talbe_btn_handler()
        --if tabIndex == first_btn_str then
        if tag == qiduihu_code then
            if self.qiduihu == CEnumM.qiduihu.y then
                self.qiduihu = CEnumM.qiduihu.n
                talbe_8_btn:setButtonSelected(false)
            else
                self.qiduihu = CEnumM.qiduihu.y
                talbe_8_btn:setButtonSelected(true)
            end
            GameState_VoiceSetting:setDataSingle(CEnumM.qiduihu.qiduihu, self.qiduihu)

        elseif tag == qiangganghu_code then
            if self.qiangganghu == CEnumM.qiangganghu.y then
                self.qiangganghu = CEnumM.qiangganghu.n
                talbe_8_btn:setButtonSelected(false)
            else
                self.qiangganghu = CEnumM.qiangganghu.y
                talbe_8_btn:setButtonSelected(true)
            end
            GameState_VoiceSetting:setDataSingle(CEnumM.qiangganghu.qiangganghu, self.qiangganghu)

        elseif tag == huangtype_code then
            if self.huangtype == CEnumM.huangtype.y then
                self.huangtype = CEnumM.huangtype.n
                talbe_8_btn:setButtonSelected(false)
            else
                self.huangtype = CEnumM.huangtype.y
                talbe_8_btn:setButtonSelected(true)
            end
            GameState_VoiceSetting:setDataSingle(CEnumM.huangtype.huangtype, self.huangtype)

        end
        --end

        VoiceDealUtil:playSound_other(Voices.file.ui_click)
    end

    -- 8
    local startX_8 = first_btn_x
    local startY_8 = first_btn_y
    talbe_8_btn = cc.ui.UICheckBoxButton.new(imagesSelect)
        :setButtonLabel(cc.ui.UILabel.new({
            text = "", -- first_btn_img, 
            font = font_ziti,
            size = font_size,
            color = font_color
        }))
        :setButtonLabelOffset(gaping_x, 0)
        :setButtonSelected(true)
        :onButtonClicked(function(event)
          talbe_btn_handler()
        end)
        :align(display.LEFT_TOP, startX_8, startY_8 +7)
        :addTo(parent_view)
    cc.ui.UIPushButton.new(
            first_btn_img, {scale9=false})
            :onButtonClicked(function(e)
                talbe_btn_handler()
            end)
            :align(display.LEFT_TOP, startX_8 +gapX, startY_8 -7)
            :addTo(parent_view)
    -- cc.ui.UIImage.new(first_btn_img)
    -- -- 背景
    -- cc.ui.UIPushButton.new(bg_img, {scale9=true})
    --     :setButtonSize(size_w -moveX, size_h)
    --     :onButtonClicked(function(e)
    --         talbe_btn_handler()
    --     end)
    --     :align(display.LEFT_TOP, startX_8, startY_8) -- 414 154
    --     :addTo(parent_view)

    if tag == qiduihu_code then
        -- 为空的时候设置默认值
        local _temp = GameState_VoiceSetting:getDataSingle(CEnumM.qiduihu.qiduihu)
        if _temp == nil then
            _temp = first_btn_str
            GameState_VoiceSetting:setDataSingle(CEnumM.qiduihu.qiduihu, first_btn_str)
        end

        if _temp ~= CEnumM.qiduihu.y then
            self.qiduihu = CEnumM.qiduihu.n
            talbe_8_btn:setButtonSelected(false)
        else
            self.qiduihu = CEnumM.qiduihu.y
            talbe_8_btn:setButtonSelected(true)
        end
        GameState_VoiceSetting:setDataSingle(CEnumM.qiduihu.qiduihu, self.qiduihu)

    elseif tag == qiangganghu_code then
        -- 为空的时候设置默认值
        local _temp = GameState_VoiceSetting:getDataSingle(CEnumM.qiangganghu.qiangganghu)
        if _temp == nil then
            _temp = first_btn_str
            GameState_VoiceSetting:setDataSingle(CEnumM.qiangganghu.qiangganghu, first_btn_str)
        end

        if _temp ~= CEnumM.qiangganghu.y then
            self.qiangganghu = CEnumM.qiangganghu.n
            talbe_8_btn:setButtonSelected(false)
        else
            self.qiangganghu = CEnumM.qiangganghu.y
            talbe_8_btn:setButtonSelected(true)
        end
        GameState_VoiceSetting:setDataSingle(CEnumM.qiangganghu.qiangganghu, self.qiangganghu)

    elseif tag == huangtype_code then
        -- 为空的时候设置默认值
        local _temp = GameState_VoiceSetting:getDataSingle(CEnumM.huangtype.huangtype)
        if _temp == nil then
            _temp = first_btn_str
            GameState_VoiceSetting:setDataSingle(CEnumM.huangtype.huangtype, first_btn_str)
        end

        if _temp ~= CEnumM.huangtype.y then
            self.huangtype = CEnumM.huangtype.n
            talbe_8_btn:setButtonSelected(false)
        else
            self.huangtype = CEnumM.huangtype.y
            talbe_8_btn:setButtonSelected(true)
        end
        GameState_VoiceSetting:setDataSingle(CEnumM.huangtype.huangtype, self.huangtype)
        
    end
end

function CreateMJRoomDialog:ctor()
    --以下数据发送给服务器
    self.roundNums = CEnumM.round._8 -- 8   --局数
    self.personNums = CEnumM.person._4 -- 4  --人数
    self.zimohu = CEnumM.zimohu.mo -- 1  --是否自摸胡
    self.qiduihu = CEnumM.qiduihu.n -- 2  --七对胡
    self.qiangganghu = CEnumM.qiangganghu.y -- 1  --可抢杠胡
    self.huangtype = CEnumM.huangtype.n -- 2  --荒庄荒杠
    self.rewardmark = CEnumM.rewardmark._159 -- 159  --奖码
    self.marknum = CEnumM.marknum._4 -- 4  --码数

	local pop_window = display.newColorLayer(cc.c4b(0, 0, 0, 100))       -- 半透明的黑色
    pop_window:setContentSize(osWidth, osHeight)             -- 设置Layer的大小,全屏出现
    pop_window:setTouchEnabled(true)
    pop_window:setTouchSwallowEnabled(true)  -- 吞噬下层的响应
    pop_window:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event) -- 点击此Layer时候输出信息,然后把自己销毁
        return true
    end)
    pop_window:addTo(self)

    -- 整个底色背景
    self.content_ = cc.ui.UIImage.new(Imgs.dialog_bg,{})
        :addTo(pop_window)
        :align(display.CENTER, display.cx, display.cy)
        :setLayoutSize(osWidth-startX_gaping*2, osHeight-startY_gaping*2)

    -- 内容背景
    self.select_bg_ = cc.ui.UIImage.new(Imgs.dialog_content_bg,{})
        :addTo(pop_window)
        :align(display.CENTER, display.cx, display.cy-90/2)
        :setLayoutSize(osWidth-startX_gaping*2-10*2, osHeight-startY_gaping*2-100)

    -- logo
    local logoImg = cc.ui.UIImage.new(Imgs.room_create_logo,{})
        :addTo(pop_window)
        :align(display.CENTER_TOP, display.cx, osHeight-startY_gaping-(100-64)/2)

    -- 关闭
    local closeBtn = cc.ui.UIPushButton.new(Imgs.dialog_exit,{scale9=false})
        :setButtonImage(EnStatus.pressed, Imgs.dialog_exit_press)
        :onButtonClicked(function(e)

            VoiceDealUtil:playSound_other(Voices.file.ui_click)
            self:removeFromParent()

        end)
        :addTo(pop_window)
        :align(display.CENTER_TOP, osWidth-startX_gaping-10*2-startY_gaping/2-10, osHeight-startY_gaping-(100-56)/2)

    -- 确定按钮
    local submitBtn = cc.ui.UIPushButton.new(
        Imgs.dialog_btn_confim,{scale9=false})
        :setButtonImage(EnStatus.pressed, Imgs.dialog_btn_confim_press)
        :onButtonClicked(function(e)

            VoiceDealUtil:playSound_other(Voices.file.ui_click)
            self:createRoom()

        end)
        :align(display.CENTER_BOTTOM, display.cx, startY_gaping+10)
        :addTo(pop_window)
        :setScale(0.9)

    local y_rounds = 520
    local y_nums = 520 -74
    local y_zimo = 520 -74*2
    local y_huangzhuang = 520 -74*3
    local y_rewardmark = 520 -74*4
    local y_marknum = 520 -74*5

    -- 局数选择 th
    display.newSprite(ImgsM.round_number)
        :addTo(self.select_bg_)
        :align(display.LEFT_TOP, 68, y_rounds)

    --人数选择 th
    display.newSprite(ImgsM.people_number)
        :addTo(self.select_bg_)
        :align(display.LEFT_TOP, 68, y_nums)

    -- 自摸胡选择 th
    display.newSprite(ImgsM.hupai)
        :addTo(self.select_bg_)
        :align(display.LEFT_TOP, 68, y_zimo)

    -- 荒庄荒杠选择 th
    display.newSprite(ImgsM.huangju)
        :addTo(self.select_bg_)
        :align(display.LEFT_TOP, 68, y_huangzhuang)

    -- 奖码选择 th
    display.newSprite(ImgsM.reward_mark)
        :addTo(self.select_bg_)
        :align(display.LEFT_TOP, 68, y_rewardmark)

    -- 码数选择 th
    self.markNumSprite = display.newSprite(ImgsM.marks_num)
        :addTo(self.select_bg_)
        :align(display.LEFT_TOP, 68, y_marknum)


---------------------------------- 每行组件，共用起来--------------------------------

-----------------------------------局数选择---------------------------------------------华丽的分割线
    self:createViewByLine(rounds_code, self.select_bg_, 
                        CEnumM.round._8, CEnumM.round._16, CEnumM.round._24, nil,
                        ImgsM.round8, ImgsM.round16, ImgsM.round24, nil,
                        237, y_rounds) 

-----------------------------------人数选择---------------------------------------------华丽的分割线
    self:createViewByLine(person_code, self.select_bg_, 
                        CEnumM.person._4, nil, nil, nil,
                        ImgsM.person4, nil, nil, nil,
                        237, y_nums)

-----------------------------------自摸胡---------------------------------------------华丽的分割线
    -- self:createViewByLine(zimo_code, self.select_bg_, 
    --                     CEnumM.zimohu.mo, CEnumM.zimohu.pao, nil, nil,
    --                     ImgsM.zimo_hu, ImgsM.fangpao_hu, nil, nil,
    --                     237, y_zimo)
    self:createViewByLine(zimo_code, self.select_bg_, 
                        CEnumM.zimohu.mo, nil, nil, nil,
                        ImgsM.zimo_hu, nil, nil, nil,
                        237, y_zimo)

-----------------------------------七对胡---------------------------------------------华丽的分割线
    self:createViewByLine_chooseMore(qiduihu_code, self.select_bg_, 
                        CEnumM.qiduihu.n, -- 默认值的设定
                        ImgsM.can_qidui_hu, 
                        237, y_huangzhuang)

-----------------------------------抢杠胡---------------------------------------------华丽的分割线
    self:createViewByLine_chooseMore(qiangganghu_code, self.select_bg_, 
                        CEnumM.qiangganghu.y, -- 默认值的设定
                        ImgsM.can_qian_ganghu, 
                        237 +50+170, y_huangzhuang)

-----------------------------------荒庄荒杠---------------------------------------------华丽的分割线
    self:createViewByLine_chooseMore(huangtype_code, self.select_bg_, 
                        CEnumM.huangtype.n, -- 默认值的设定
                        ImgsM.huangzhuang, 
                        237 +(50+170)*2, y_huangzhuang)

-----------------------------------码数---------------------------------------------华丽的分割线
    marknum_View = display.newNode():addTo(self.select_bg_)
    self:createViewByLine(marknum_code, marknum_View, 
                        CEnumM.marknum._2, CEnumM.marknum._4, CEnumM.marknum._6, nil,
                        ImgsM.mark2, ImgsM.mark4, ImgsM.mark6, nil,
                        237, y_marknum)

-----------------------------------奖码---------------------------------------------华丽的分割线
    self:createViewByLine(rewardmark_code, self.select_bg_, 
                        CEnumM.rewardmark.no, CEnumM.rewardmark._159, CEnumM.rewardmark.ymqz, CEnumM.rewardmark.oon,
                        ImgsM.no_reward_mark, ImgsM.zhong_mark_159, ImgsM.one_mark_ok, ImgsM.wowo_bird,
                        237, y_rewardmark)

----------------------------------------------------------------------------------华丽的分割线
    -- 定位信息
    self:getLgeLat()

end


function CreateMJRoomDialog:getLgeLat()
    local function CreateRoomDialog_CallbackLua_LgeLat(lgeLat)
        if Commons:checkIsNull_str(lgeLat) then
            --CDAlertManu.new():popDialogBox(self.content_, lgeLat)
            local _lgeLat = string.split(lgeLat, ",")
            if type(_lgeLat)=="table" then
                local _size = #_lgeLat
                if _size == 2 then
                    CVar._static.Lge = _lgeLat[1]
                    CVar._static.Lat = _lgeLat[2]
                    -- CDAlertManu.new():popDialogBox(self.content_, "创建pdk房间："..CVar._static.Lge.."|"..CVar._static.Lat)
                end
            end
        end
    end
    Commons:getLgeLat(CreateRoomDialog_CallbackLua_LgeLat)
end

local loadingPop_window_createroom
function CreateMJRoomDialog:createRoom()
    if self.rewardmark ~= CEnumM.rewardmark._159 then
        self.marknum = 0
    end
    
    local param = {
        playerNum = self.personNums,
        rounds = self.roundNums,
        huRule = self.zimohu,
        duiRule = self.qiduihu,
        gangRule = self.qiangganghu,
        huangRule = self.huangtype,
        rewardType = self.rewardmark,
        rewardNum = self.marknum
    }

    loadingPop_window_createroom = CDAlertLoading.new():popDialogBox(self, Strings.hint_Loading)
    RequestMJCreateRoom:createRoom(param,
        function(data)
            -- Commons:gotoPDKRoom()
            self:getCreateData(data)
        end
    )

end

function CreateMJRoomDialog:getCreateData(jsonObj)
    if loadingPop_window_createroom~=nil and (not tolua.isnull(loadingPop_window_createroom)) then
        loadingPop_window_createroom:removeFromParent()
        loadingPop_window_createroom = nil
    end

    Commons:printLog_Info("resDataRoomCreate:::", jsonObj)

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
                    -- 关闭当前弹窗，弹出错误
                    CDAlertManu.new():popDialogBox(self, Strings.hint_NoSocketIpPort)
                else

                    -- 记录房间信息
                    local roomNo = roomObj[Room.Bean.roomNo]
                    CVar._static.roomNo = roomNo 
                    GameStateUserGameing:setData(roomObj)

                    -- 关闭当前弹窗，进入房间页面
                    --  _parent:removeChild(_pop_window)
                    --CreateRoomDialog:myExit()
                    
                    -- local entTime = os.clock()--socket.gettime()
                    -- local _time = entTime - startTime
                    -- print("------------time：创建房间http请求回来耗时：".._time.." 秒")

                    -- startTime = os.clock()--socket.gettime()
                    CommonsM:gotoMJRoom()
                    -- entTime = os.clock()--socket.gettime()
                    -- _time = entTime - startTime
                    -- print("------------time：登录房间socket，显示桌面耗时：".._time.." 秒")
                end
            end
        else
            -- 关闭当前弹窗，弹出错误
           -- _parent:removeChild(_pop_window)
            CDAlertManu.new():popDialogBox(self, msg);
          --  CreateRoomDialog:myExit()
        end
    end
end

function CreateMJRoomDialog:onExit()
end

return CreateMJRoomDialog