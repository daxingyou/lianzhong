--
-- Author: lte
-- Date: 2016-11-05 18:41:34
-- 房间战绩

-- 类申明
local TradeLogDialog = class("TradeLogDialog"
    -- ,function()
    --     return display.newNode()
    -- end
    )


local osWidth = Commons.osWidth
local osHeight = Commons.osHeight

local gaping_w -- 整个图层的左右间距
local gaping_h -- 整个图层的上下间距
local gaping_x -- 内容背景，左右 底部 间距
local gaping_y -- 内容背景，顶部间距

function TradeLogDialog:ctor()
end

-- 创建一个模态弹出框,  parent=要加在哪个上面
function TradeLogDialog:popDialogBox(_parent, _res_data)

    self.parent = _parent
    self.res_data = _res_data

    self.pop_window = display.newColorLayer(cc.c4b(0, 0, 0, 200))       -- 半透明的黑色

    self.pop_window:setContentSize(osWidth, osHeight)             -- 设置Layer的大小,全屏出现
    --self.pop_window:align(display.CENTER, display.cx, display.cy) -- Layer的锚点在0.5,0.5 因此对齐的时候要注意
    self.pop_window:setTouchEnabled(true)
    self.pop_window:setTouchSwallowEnabled(true)  -- 吞噬下层的响应
    self.pop_window:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event) -- 点击此Layer时候输出信息,然后把自己销毁
        return true
    end)
    self.parent:addChild(self.pop_window, CEnum.ZOrder.common_dialog) -- 把Layer添加到父对象上


    gaping_w = 18
    gaping_h = 16
    gaping_x = 10
    gaping_y = 74

    ---[[
    -- 整个底色背景
    cc.ui.UIImage.new(Imgs.dialog_bg,{})
        :addTo(self.pop_window)
    	:align(display.CENTER, display.cx, display.cy)
        :setLayoutSize(osWidth -gaping_w*2, osHeight -gaping_h*2)
    --]]

    ---[[
    -- 内容背景
    cc.ui.UIImage.new(Imgs.dialog_content_bg,{})
        :addTo(self.pop_window)
        :align(display.CENTER, display.cx, display.cy -gaping_y*0.5)
        :setLayoutSize(osWidth -gaping_w*2 -gaping_x*2, osHeight -gaping_h*2 -gaping_y -gaping_x)
    --]]

    -- logo
    cc.ui.UIImage.new(Imgs.tradelog_title_logo,{})
    	:addTo(self.pop_window)
        :align(display.CENTER_TOP, display.cx, osHeight -gaping_h -11)

    ---[[
    -- 关闭 
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
        :setButtonImage(EnStatus.pressed, Imgs.dialog_exit_press)
        :onButtonClicked(function(e)

            VoiceDealUtil:playSound_other(Voices.file.ui_click)
            self:myExit()

        end)
    	:addTo(self.pop_window)
        :align(display.RIGHT_TOP, osWidth -gaping_w -gaping_x, osHeight -gaping_h -11)
    --]]

	-- view
    self:createView2()
	self:setViewData2()

end

local item_w
local item_h

function TradeLogDialog:createView2()
    item_w = osWidth -gaping_w*2 -gaping_x*2 -gaping_x*2 -10
    item_h = (osHeight -gaping_w*2 -188)/10
    local startX = gaping_w +gaping_x +40

    -- 层
    -- winOrOwner_view_layer = display.newLayer() -- .newColorLayer(Colors.layer_bg)
    --     :setContentSize(600,508)
    --     :align(display.LEFT_TOP, 14+30, osHeight-14 -40 -38)
    --     :addTo(self.pop_window)
    --winOrOwner_view_layer = display.newNode():addTo(self.pop_window);

    -- 序号
    display.newTTFLabel({
            text = "序号",
            font = Fonts.Font_hkyt_w9,
            size = Dimens.TextSize_30,
            color = Colors:_16ToRGB(Colors.gameing_huxi),
            align = cc.ui.TEXT_ALIGN_CENTER,
            valign = cc.ui.TEXT_VALIGN_CENTER,
            --dimensions = cc.size(100,20)
        })
        :addTo(self.pop_window)
        :align(display.LEFT_TOP, startX, osHeight-135)

    -- 时间
    display.newTTFLabel({
            text = "时间",
            font = Fonts.Font_hkyt_w9,
            size = Dimens.TextSize_30,
            color = Colors:_16ToRGB(Colors.gameing_huxi),
            align = cc.ui.TEXT_ALIGN_CENTER,
            valign = cc.ui.TEXT_VALIGN_CENTER,
            --dimensions = cc.size(100,20)
        })
        :addTo(self.pop_window)
        :align(display.LEFT_TOP, startX +200*1, osHeight-135)

    -- 类型
    display.newTTFLabel({
            text = "类型",
            font = Fonts.Font_hkyt_w9,
            size = Dimens.TextSize_30,
            color = Colors:_16ToRGB(Colors.gameing_huxi),
            align = cc.ui.TEXT_ALIGN_CENTER,
            valign = cc.ui.TEXT_VALIGN_CENTER,
            --dimensions = cc.size(100,20)
        })
        :addTo(self.pop_window)
        :align(display.LEFT_TOP, startX +152*3, osHeight-135)

    -- 详情
    display.newTTFLabel({
            text = "详情",
            font = Fonts.Font_hkyt_w9,
            size = Dimens.TextSize_30,
            color = Colors:_16ToRGB(Colors.gameing_huxi),
            align = cc.ui.TEXT_ALIGN_CENTER,
            valign = cc.ui.TEXT_VALIGN_CENTER,
            --dimensions = cc.size(100,20)
        })
        :addTo(self.pop_window)
        :align(display.LEFT_TOP, startX +152*4, osHeight-135)

    -- 组合
    self.view_hu_list = cc.ui.UIListView.new({
            --bg = Imgs.c_default_img,
            --bgStartColor = cc.c4b(255,64,64,150),
            --bgEndColor = cc.c4b(0,0,0,150),
            bgColor = cc.c4b(200, 200, 200, 0),
            --bgColor = Colors.btn_bg,
            bgScale9 = false,
            --capInsets = cc.rect(0, 0, 706, 73*4),
            viewRect = cc.rect(0, 0, item_w, item_h*10),
            direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
            --direction = cc.ui.UIScrollView.DIRECTION_HORIZONTAL,
            --alignment = cc.ui.UIListView.ALIGNMENT_VCENTER
            --scrollbarImgH = Imgs.c_default_img
            --scrollbarImgV = Imgs.c_default_img
        })
        :addTo(self.pop_window)
        :align(display.LEFT_TOP, startX -30, gaping_h +10+12)
end

-- 三个玩家的数据都显示出来
function TradeLogDialog:setViewData2()
    if self.res_data ~= nil then
        Commons:printLog_Info("宽",item_w)
        Commons:printLog_Info("高",item_h)
        self.view_hu_list:removeAllItems()

        for k,v in pairs(self.res_data) do
        --for i=1,10 do
            local tradeTime = v[TradeLog.Bean.tradeTime]
            local tradeType = v[TradeLog.Bean.tradeType]
            local remark = v[TradeLog.Bean.remark]

            local item = self.view_hu_list:newItem()
            local content;
            --content = cc.LayerColor:create(cc.c4b(math.random(255),math.random(255),math.random(255),255))
            --content:setContentSize(item_w, item_h-40) --设置大小

            -- 背景
            -- content = cc.ui.UIImage.new(Imgs.result_item_bg,{scale9 = false})
            --         --cc.ui.UIPushButton.new(Imgs.result_item_bg,{scale9=false}):setButtonSize(item_w, item_h-40)
            --     --:setLayoutSize(item_w, item_h-40)
            --     --:align(display.CENTER, content:getContentSize().width / 2, content:getContentSize().height / 2)
            --     --:addTo(content)
            if k%2==0 then
                --content = cc.LayerColor:create(Colors:_16ToRGB4(Colors.result_round_bg2,255))
                --content = display.newColorLayer(Colors:_16ToRGB4(Colors.result_round_bg2,255))
                content = cc.ui.UIImage.new(Imgs.round_item_ou,{scale9 = true})
            else
                --content = cc.LayerColor:create(Colors:_16ToRGB4(Colors.result_round_bg1,255))
                --content = display.newColorLayer(Colors:_16ToRGB4(Colors.result_round_bg1,255))
                content = cc.ui.UIImage.new(Imgs.round_item_ji,{scale9 = true})
            end
            content:setContentSize(item_w, item_h-6) --设置大小
            local ww = content:getContentSize().width
            local hh = content:getContentSize().height

            -- 序号
            display.newTTFLabel({
                    text = k,
                    font = Fonts.Font_hkyt_w7,
                    size = Dimens.TextSize_25,
                    color = Colors:_16ToRGB(Colors.gameing_huxi),
                    align = cc.ui.TEXT_ALIGN_CENTER,
                    valign = cc.ui.TEXT_VALIGN_CENTER,
                    -- dimensions = cc.size(20,30)
                })
                :addTo(content)
                :align(display.LEFT_TOP, 40, hh-10)

            -- 时间
            display.newTTFLabel({
                    text = tradeTime,
                    font = Fonts.Font_hkyt_w7,
                    size = Dimens.TextSize_25,
                    color = Colors:_16ToRGB(Colors.gameing_huxi),
                    align = cc.ui.TEXT_ALIGN_CENTER,
                    valign = cc.ui.TEXT_VALIGN_CENTER,
                    -- dimensions = cc.size(250,30)
                })
                :addTo(content)
                :align(display.LEFT_TOP, 40 +150, hh-10)

            -- 类型
            display.newTTFLabel({
                    text = tradeType,
                    font = Fonts.Font_hkyt_w7,
                    size = Dimens.TextSize_25,
                    color = Colors:_16ToRGB(Colors.gameing_huxi),
                    align = cc.ui.TEXT_ALIGN_LEFT,
                    valign = cc.ui.TEXT_VALIGN_CENTER,
                    dimensions = cc.size(250,30)
                })
                :addTo(content)
                :align(display.LEFT_TOP, 40 +150*3, hh-10)

            -- 详情
            display.newTTFLabel({
                    text = remark,
                    font = Fonts.Font_hkyt_w7,
                    size = Dimens.TextSize_25,
                    color = Colors:_16ToRGB(Colors.gameing_huxi),
                    align = cc.ui.TEXT_ALIGN_LEFT,
                    valign = cc.ui.TEXT_VALIGN_CENTER,
                    dimensions = cc.size(580,30)
                })
                :addTo(content)
                :align(display.LEFT_TOP, 40 +150*4, hh-10)

            item:addContent(content)
            item:setItemSize(item_w, item_h)
            self.view_hu_list:addItem(item) -- 添加item到列表
            --self.view_hu_list:addScrollNode(content)
        end
        self.view_hu_list:onTouch(TradeLogDialog_touchListener_listview)
        self.view_hu_list:reload() -- 重新加载
    end
end

function TradeLogDialog_touchListener_listview(event)
    --dump(event, "pageView - event:")
    --Commons:printLog_Info("pageView - event:")
    --Commons:printfLog_Info("touchListener: name=%s x,y: %0.2f, %0.2f", event.name, event.x, event.y)

    --local listView = event.pageView
    --local item = event.item
    local position = event.itemPos
    local event_name = event.name
    --dump(item)

    --[[
    if EnStatus.clicked == event_name then
        VoiceDealUtil:playSound_other(Voices.file.ui_click)
        
        local v = self.res_data[position]
        local roomNo = v[Result.Bean.roomNo]
        Commons:printLog_Info("点击的房间号是：",roomNo)

        TradeLogDialog:myConfim(roomNo)

        -- if 100 == position then
        --  listView:removeItem(item, true) --移除item,带移除动画
        -- else
        --  local w, _ = item:getItemSize()
        --  if 60 == w then   --修改item大小 来演示效果
        --      item:setItemSize(100, 73*3.5)
        --  else
        --      item:setItemSize(60, 73*3.5)
        --  end
        -- end
    end
    --]]
end

function TradeLogDialog:onExit()
    self:myExit()
end

function TradeLogDialog:myExit()
    self.res_data = nil
    self.view_hu_list = nil

    if self.pop_window ~= nil and (not tolua.isnull(self.pop_window)) then
        self.pop_window:removeFromParent()
        self.pop_window = nil
    end
end

return TradeLogDialog