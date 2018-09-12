--
-- Author: lte
-- Date: 2016-11-05 18:41:34
-- 房间战绩

-- 类申明
local EmojiDialog = class("EmojiDialog"
    -- ,function()
    --     return display.newNode()
    -- end
    )


local osWidth = Commons.osWidth
local osHeight = Commons.osHeight

-- 短语
EmojiDialog.gameingWordsList = {
    {
        code="s01",
        -- msg="大家好，很高兴见到各位。",
        msg="快点吧，我等到花儿都谢啦！",
    },

    {
        code="s02",
        -- msg="快点吧，我等到花儿都谢啦！",
        msg="又断线啦，网络怎么这么差！",
    },

    {
        code="s03",
        -- msg="不要走，决战到天亮！",
        msg="各位，不好意思，我要离开一会",
    },

    {
        code="s04",
        -- msg="又断线啦，网络怎么这么差！",
        msg="你的牌打的太好啦。",
    },

    {
        code="s05",
        -- msg="你的牌打的太好啦。",
        msg="和你合作，真是太愉快啦！",
    },

    {
        code="s06",
        -- msg="你是妹妹，还是哥哥？",
        msg="不要走，决战到天亮！",
    },

    {
        code="s07",
        -- msg="和你合作，真是太愉快啦！",
        msg="大家好，很高兴见到各位。",
    },

    {
        code="s08",
        -- msg="各位，不好意思，我要离开一会",
        msg="你是妹妹，还是哥哥？",
    },

    {
        code="s09",
        msg="不要吵啦，专心玩游戏吧！",
    },
}

function EmojiDialog:ctor()
end

-- 创建一个模态弹出框,  parent=要加在哪个上面
function EmojiDialog:popDialogBox(_parent, _formView)

    self.parent = _parent
    self.formView = _formView

    self.pop_window = display.newColorLayer(cc.c4b(0, 0, 0, 10))       -- 半透明的黑色

    self.pop_window:setContentSize(osWidth, osHeight)             -- 设置Layer的大小,全屏出现
    --self.pop_window:align(display.CENTER, display.cx, display.cy) -- Layer的锚点在0.5,0.5 因此对齐的时候要注意
    self.pop_window:setTouchEnabled(true)
    self.pop_window:setTouchSwallowEnabled(true)  -- 吞噬下层的响应
    self.pop_window:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event) -- 点击此Layer时候输出信息,然后把自己销毁

	    self:myExit()
        return true
    end)
    self.parent:addChild(self.pop_window, CEnum.ZOrder.common_dialog) -- 把Layer添加到父对象上

    self.alert_gaping_w = 200
    self.alert_gaping_h = 95
    if CVar._static.isIphone4 then
        self.alert_gaping_w = self.alert_gaping_w -100
    elseif CVar._static.isIpad then
        self.alert_gaping_w = self.alert_gaping_w -160
    end

    ---[[
    -- 整个底色背景
    cc.ui.UIImage.new(Imgs.dialog_bg, {scale9=false})
        :addTo(self.pop_window)
    	:align(display.LEFT_BOTTOM, self.alert_gaping_w, 10)
    	:setLayoutSize(osWidth -self.alert_gaping_w*2, osHeight -self.alert_gaping_h*2)
    --]]

    --[[
    -- 内容背景
    cc.ui.UIImage.new(Imgs.dialog_content_bg,{})
        :addTo(self.pop_window)
        :align(display.LEFT_TOP, 20+10, osHeight-18 -88)
        :setLayoutSize(osWidth-20*2 -10*2, osHeight-18*2 -88-10)
    --]]

    --[[
    -- logo
    cc.ui.UIImage.new(Imgs.result_title_logo,{})
    --cc.ui.UIPushButton.new(Imgs.result_title_logo, {scale9 = false})
    --    :setButtonImage(EnStatus.pressed, Imgs.result_title_logo)
    --    :setButtonImage(EnStatus.disabled, Imgs.result_title_logo)
    	:addTo(self.pop_window)
    	:align(display.CENTER, display.cx, osHeight-18 -88/2)
    --]]

    -- view
    self:createView2()
    self:setViewData2()

    self:createView_words()
    self:setViewData_words()

    ---[[
    -- 关闭 
    cc.ui.UIPushButton.new(Imgs.bq_exit, {scale9=false})
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
        :setButtonImage(EnStatus.pressed, Imgs.bq_exit)
        :onButtonClicked(function(e)
           self:myExit()
        end)
    	:addTo(self.pop_window)
        :align(display.CENTER_RIGHT, osWidth-self.alert_gaping_w-5 +35, osHeight-self.alert_gaping_h-5)
        :hide()
    --]]

    --[[
    -- 确定按钮
    cc.ui.UIPushButton.new(
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
        --:onButtonClicked(function(e)
        --    self:myExit()
        --end)
        :align(display.CENTER_BOTTOM, display.cx, 14+3)
        :addTo(self.pop_window)
    --]]

    --[[
    cc.ui.UILabel.new({
            UILabelType = 2, 
            --image = "",
            text = "注意：金豆在游戏开始后扣除，游戏开始前解散不扣除金豆", 
            size = Dimens.TextSize_20,
            --color = Colors.black,
            color = Colors:_16ToRGB(Colors.gameing_huxi),
            font = Fonts.Font_hkyt_w9,
            align = cc.ui.TEXT_ALIGN_LEFT,
            valign = cc.ui.TEXT_VALIGN_CENTER,
            --dimensions = cc.size((osWidth-120),0) -- height为0，就是自动换行
            --dimensions = cc.size(200,50)
        })
        :align(display.LEFT_TOP, 20+13+25, 18+12+27)
        :addTo(self.pop_window)
    --]]

end

-- 表情图片显示
function EmojiDialog:getImgByBiaoqing_new(optTxt)
    if optTxt ~= nil and optTxt ~= CEnum.status.def_fill then
      return Imgs.biaoqing_expContent .. optTxt .. Imgs.file_imgPlist_suff, Imgs.biaoqing_expContent .. optTxt .. Imgs.file_img_suff

    else
      -- 没有图片
      --return Imgs.c_check_yes -- 预看效果图片
      return '','' -- 透明图片
    end
end

-- 表情图片显示
function EmojiDialog:getImg_for_expBtn(optTxt)
    if optTxt ~= nil and optTxt ~= CEnum.status.def_fill then
      return Imgs.biaoqing_expBtn .. optTxt .. Imgs.file_img_suff

    else
      -- 没有图片
      --return Imgs.c_check_yes -- 预看效果图片
      return Imgs.c_transparent -- 透明图片
    end
end

function EmojiDialog:getWordsMsg_by_code(codeTxt)
    local msg = ''
    local url = ''
    if codeTxt ~= nil and codeTxt ~= CEnum.status.def_fill then
        for k,v in pairs(EmojiDialog.gameingWordsList) do
            if v ~=nil and v.code~=nil and v.code==codeTxt then
                msg = v.msg
                url = Voices.file.gameingWordsUrl_n..codeTxt..Voices.file.ww_suff
                break
            end
        end
    end
    return msg,url
end

-- ListView
local item_w
local item_h
local nums_row -- 行数
local nums_lie -- 列数
function EmojiDialog:createView2()
    item_w = 123
    item_h = 110 -- 空出70像素的title部分
    nums_row = 2 -- 行数
    nums_lie = 5 -- 列数

    -- 组合
    self.view_emoji_list = 
        cc.ui.UIListView.new({
            bg = Imgs.bq_content_bg,
            --bgStartColor = cc.c4b(255,64,64,150),
            --bgEndColor = cc.c4b(0,0,0,150),
            --bgColor = cc.c4b(200, 200, 200, 150),
            --bgColor = Colors.btn_bg,
            bgScale9 = true,
            --capInsets = cc.rect(0, 0, 706, 73*4),
            viewRect = cc.rect( 0, 0, item_w*nums_lie*1.2, item_h*nums_row),
            direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
            -- direction = cc.ui.UIScrollView.DIRECTION_HORIZONTAL,
            --alignment = cc.ui.UIListView.ALIGNMENT_VCENTER,
            scrollbarImgH = Imgs.c_transparent,
            scrollbarImgV = Imgs.c_transparent
        })
        :addTo(self.pop_window)
        :align(display.CENTER_BOTTOM, display.cx -10 -(item_w*nums_lie)/2, 32)
        :setBounceable(false)

    cc.ui.UIImage.new(Imgs.bq_title,{scale9=false})
        :addTo(self.pop_window)
        :align(display.LEFT_CENTER, display.cx -85 -(item_w*nums_lie)/2, 32 +(item_h*nums_row)/2)
end

-- ListView
function EmojiDialog:setViewData2()
    local res_data = 
    -- {
    --     {
    --     "zt", -- 赞
    --     "dk", -- 大哭
    --     },

    --     {
    --     "bf", -- 傲慢
    --     "sj", -- 睡觉
    --     },

    --     {
    --     "fn", -- 发怒
    --     "gg", -- 惊恐
    --     },

    --     {
    --     "fw", -- 心动，飞吻
    --     "bs", -- 鄙视
    --     },
    -- }
    {
        {
        "bf",
        "bs",
        "sj",
        "cl",
        "cy",
        },
        
        {
        "dk",
        "fn",
        "fw",
        "gg",
        "ka",
        },

        {
        "lh",
        "pz",
        "wx",
        "zt",
        },
    }
    if res_data ~= nil then
        -- Commons:printLog_Info("宽",item_w)
        -- Commons:printLog_Info("高",item_h)
        self.view_emoji_list:removeAllItems()

        local size = #res_data
        for k,v in pairs(res_data) do
            local item = self.view_emoji_list:newItem()
            local content = display.newNode()

            for kk,vv in pairs(v) do
	            local img_i = self:getImg_for_expBtn(vv)
	            --cc.ui.UIImage.new(img_i,{scale9=false})
	            local dd = cc.ui.UIPushButton.new(img_i, {scale9=false})
	            	--:setButtonSize(item_w, item_h)

	                -- HORIZONTAL
	                --:align(display.CENTER, 80*count - 40, 40)
	                :addTo(content)

                local item_h_cc = item_h *0.1

                if kk == 1 then
                    -- VERTICAL
                	dd:align(display.LEFT_BOTTOM, -item_w/8, item_h_cc )
                else
	                -- VERTICAL
	                dd:align(display.LEFT_BOTTOM, -item_w/8 + ((item_w+20)*(kk-1)), item_h_cc )
                end
                dd:onButtonClicked(function(event)
                    self:clickListener(vv)
                end)
            end            

            content:setContentSize(item_w*nums_lie, item_h)
            item:addContent(content)
            --Commons:printLog_Info("最终是:",item_w, item_h)
            item:setItemSize(item_w*nums_lie, item_h)
            self.view_emoji_list:addItem(item) -- 添加item到列表
        end
        --self.view_emoji_list:onTouch(EmojiDialog_touchListener_listview)
        self.view_emoji_list:reload() -- 重新加载
    end
end



-- ListView
local item_w_words
local item_h_words
local nums_row_words -- 行数
local nums_lie_words -- 列数
function EmojiDialog:createView_words()
    item_w_words = item_w*nums_lie
    item_h_words = item_h*nums_row/3
    nums_row_words = 3 -- 行数
    nums_lie_words = 1 -- 列数

    -- 组合
    self.view_words_list = 
        cc.ui.UIListView.new({
            bg = Imgs.bq_content_bg,
            --bgStartColor = cc.c4b(255,64,64,150),
            --bgEndColor = cc.c4b(0,0,0,150),
            --bgColor = cc.c4b(200, 200, 200, 150),
            --bgColor = Colors.btn_bg,
            bgScale9 = true,
            --capInsets = cc.rect(0, 0, 706, 73*4),
            viewRect = cc.rect( 0, 0, item_w_words*nums_lie_words*1.2, item_h_words*nums_row_words+10),
            direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
            -- direction = cc.ui.UIScrollView.DIRECTION_HORIZONTAL,
            --alignment = cc.ui.UIListView.ALIGNMENT_VCENTER,
            scrollbarImgH = Imgs.c_transparent,
            scrollbarImgV = Imgs.c_transparent
        })
        :addTo(self.pop_window)
        -- :align(display.CENTER, display.cx, display.cy -(item_h_words*nums_row_words)*7/10 )
        :align(display.CENTER_BOTTOM, display.cx -10 -(item_w_words*nums_lie_words)/2, 32 +item_h*nums_row +16)
        :setBounceable(false)

    cc.ui.UIImage.new(Imgs.words_title,{scale9=false})
        :addTo(self.pop_window)
        -- :align(display.LEFT_TOP, display.cx +(item_w_words*nums_lie_words)/2, osHeight-self.alert_gaping_h-30)
        :align(display.LEFT_CENTER, display.cx -85 -(item_w_words*nums_lie_words)/2, 32 +item_h*nums_row +16 +(item_h_words*nums_row_words)/2)
end

-- ListView
function EmojiDialog:setViewData_words()
    local res_data = EmojiDialog.gameingWordsList

    if res_data ~= nil then
        -- Commons:printLog_Info("宽", item_w_words)
        -- Commons:printLog_Info("高", item_h_words)
        self.view_words_list:removeAllItems()

        local size = #res_data
        for k,v in pairs(res_data) do
            local item = self.view_words_list:newItem()
            local content = display.newNode()

            --for kk,vv in pairs(v) do
                local img_i = Imgs.words_content_bg -- self:getImg_for_expBtn(vv)  
                local dd = cc.ui.UIImage.new(img_i, {scale9=true})
                            :setLayoutSize(item_w_words*nums_lie_words*1.10, item_h_words*0.9)
                    -- cc.ui.UIPushButton.new(img_i, {scale9=true})
                    --     :setButtonSize(item_w_words*nums_lie_words*1.10, item_h_words*0.9)
                    --     :setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
                    --         UILabelType = 2,
                    --         text = "" .. v.msg,
                    --         font = Fonts.Font_hkyt_w7,
                    --         size = Dimens.TextSize_20,
                    --         color = Colors.words_txt,
                    --         -- align = cc.ui.TEXT_ALIGN_LEFT,
                    --         -- valign = cc.ui.TEXT_VALIGN_CENTER,
                    --     }))
                    :addTo(content)
                    :align(display.LEFT_BOTTOM, -30, 0 )
                --     :setButtonLabelAlignment(display.LEFT_CENTER)        --设置按钮文字的对齐方式  
                --     :setButtonLabelOffset(-(item_w_words*nums_lie_words*1.10)/2 +30, 0)                  --设置按钮文字的x,y偏移
                --     :onButtonClicked(function(event)
                --         self:clickListener_words(v.code)
                --     end)


                display.newTTFLabel({
                        text = v.msg,
                        font = Fonts.Font_hkyt_w7,
                        size = Dimens.TextSize_25,
                        color = Colors.words_txt,
                        align = cc.ui.TEXT_ALIGN_LEFT,
                        valign = cc.ui.TEXT_VALIGN_CENTER,
                        --dimensions = cc.size(100,20)
                    })
                    :addTo(content)
                    :align(display.LEFT_BOTTOM, 10, item_h_words/3)
            --end            

            content:setContentSize(item_w_words*nums_lie_words, item_h_words)
            item:addContent(content)
            item:setItemSize(item_w_words*nums_lie_words, item_h_words)
            self.view_words_list:addItem(item) -- 添加item到列表
        end
        -- self.view_words_list:setTouchEnabled(true)
        self.view_words_list:onTouch(function(...) self:touchListener_listview(...) end)
        self.view_words_list:reload() -- 重新加载
    end
end

function EmojiDialog:touchListener_listview(event)
    --dump(event, "pageView - event:")
    --Commons:printLog_Info("pageView - event:")
    --Commons:printfLog_Info("touchListener: name=%s x,y: %0.2f, %0.2f", event.name, event.x, event.y)

    --local listView = event.pageView
    --local item = event.item
    local position = event.itemPos
    local event_name = event.name
    --dump(item)

    if EnStatus.clicked == event_name then
        local v = EmojiDialog.gameingWordsList[position]
        self:clickListener_words(v.code)
    end
end

local emoji_node_view_Myself
function EmojiDialog:clickListener(biaoqingNo)
    -- Commons:printLog_Info("要发送的表情代码是：",biaoqingNo)
    SocketRequestGameing:gameing_SendEmoji(biaoqingNo)

    if self.formView ~= nil and self.formView==CEnum.pageView.gameingPhzPage then
        emoji_node_view_Myself = GameingDealUtil:createEmoji_Anim(self.parent, biaoqingNo, CEnum.seatNo.me, emoji_node_view_Myself)
    elseif self.formView ~= nil and self.formView==CEnum.pageView.gameingMJPage then
        emoji_node_view_Myself = GameMaJiangUtil:createEmoji_Anim(self.parent, biaoqingNo, CEnumM.seatNo.me, emoji_node_view_Myself)
    else
        emoji_node_view_Myself = EmojiView:createEmoji_Anim(self.parent, biaoqingNo, CEnumP.seatNo.me, emoji_node_view_Myself)
    end

    self:myExit()
end

local words_node_view_Myself
function EmojiDialog:clickListener_words(codeTxt)
    -- print("要发送的短语代码是：", codeTxt)
    SocketRequestGameing:gameing_SendWords(codeTxt)

    if self.formView ~= nil and self.formView==CEnum.pageView.gameingPhzPage then
        words_node_view_Myself = GameingDealUtil:createWords_Anim(self.parent, codeTxt, CEnum.seatNo.me, words_node_view_Myself)
    elseif self.formView ~= nil and self.formView==CEnum.pageView.gameingMJPage then
        words_node_view_Myself = GameMaJiangUtil:createWords_Anim(self.parent, codeTxt, CEnumM.seatNo.me, words_node_view_Myself)
    else
        words_node_view_Myself = EmojiView:createWords_Anim(self.parent, codeTxt, CEnumP.seatNo.me, words_node_view_Myself)
    end

    self:myExit()
end

function EmojiDialog:onExit()
    self:myExit()
end

function EmojiDialog:myExit()

    self.formView = nil

    self.view_emoji_list = nil

    if self.pop_window ~= nil and (not tolua.isnull(self.pop_window)) then
        self.pop_window:removeFromParent()
        self.pop_window = nil
    end
end

return EmojiDialog