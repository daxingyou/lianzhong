--
-- Author: lte
-- Date: 2016-11-04 13:01:54
-- 玩法的弹窗

-- 类申明
local HelpInfoDialog = class("HelpInfoDialog"
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

function HelpInfoDialog:ctor()
end

-- 创建一个模态弹出框,  parent=要加在哪个上面
function HelpInfoDialog:popDialogBox(_parent, contentMsg)

    self.parent = _parent

    self.pop_window = display.newColorLayer(cc.c4b(0, 0, 0, 100))       -- 半透明的黑色

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

    -- 内容背景
    cc.ui.UIImage.new(Imgs.dialog_content_bg,{})
        :addTo(self.pop_window)
        :align(display.CENTER, display.cx, display.cy -gaping_y*0.5)
        :setLayoutSize(osWidth -gaping_w*2 -gaping_x*2, osHeight -gaping_h*2 -gaping_y -gaping_x)

    -- logo
    cc.ui.UIImage.new(Imgs.help_title_logo,{})
    	:addTo(self.pop_window)
    	:align(display.CENTER_TOP, display.cx, osHeight -gaping_h -11)

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

    -- 本地内容
    -- 显示玩法内容
    -- if Commons:checkIsNull_str(contentMsg) then
    -- 	   self:create_contentView(contentMsg)
    -- end
    -- 服务器给玩法介绍下载地址
    self.loadingPop_window = CDAlertLoading.new():popDialogBox(self.pop_window, Strings.hint_Loading)
    RequestHome:getHelpInfo(nil, function(...) self:resData_getHelpInfo(...) end)

end

function HelpInfoDialog:getInfoData(status, fileNameShort, RemoteUrl)
    if self.loadingPop_window~=nil and (not tolua.isnull(self.loadingPop_window)) then
        self.loadingPop_window:removeFromParent()
        self.loadingPop_window = nil
    end
    -- if self.loadingPop_window~=nil and (not tolua.isnull(self.loadingPop_window)) then
    --     self.loadingPop_window:stopAllActions()
    --     self.loadingPop_window:setVisible(false)
    -- end

    if status ~= nil and status == CEnum.status.success then

        if Commons:checkIsNull_str(fileNameShort) then
            self:create_contentView(fileNameShort)
        else
            -- self:create_contentView(Strings.gameing.noData_info)
            CDAlert.new():popDialogBox(self.pop_window, Strings.gameing.noData_info)
        end
    else
        -- "暂无数据"
    end
end

function HelpInfoDialog:resData_getHelpInfo(jsonObj)

    local status = jsonObj[ParseBase.status]
    local msg = RequestBase:getStrDecode(jsonObj[ParseBase.msg])
    Commons:printLog_Info("状态是：", status, "内容是：", msg)

    if status ~= nil and status==CEnum.status.success then
        local data = jsonObj[ParseBase.data]

        ---[[
        -- 下载文件再读取本地文件方式
        if data ~= nil and data[Result.Bean.playIntroUrl] ~= nil then
            local playIntroUrl = RequestBase:getStrDecode( data[Result.Bean.playIntroUrl] )
            NetMirrorDataUtil:downLoad(function(...) self:getInfoData(...) end, playIntroUrl)
        else
            if self.loadingPop_window~=nil and (not tolua.isnull(self.loadingPop_window)) then
                self.loadingPop_window:removeFromParent()
                self.loadingPop_window = nil
            end
            -- self:create_contentView(Strings.gameing.noData_info)
            CDAlert.new():popDialogBox(self.pop_window, Strings.gameing.noData_info)
        end
        --]]
    else
        if self.loadingPop_window~=nil and (not tolua.isnull(self.loadingPop_window)) then
            self.loadingPop_window:removeFromParent()
            self.loadingPop_window = nil
        end
        -- self:create_contentView(msg)
        CDAlert.new():popDialogBox(self.pop_window, msg)
    end
end

function HelpInfoDialog:create_contentView(contentMsg)
    local item_w = osWidth -120
    local item_h = osHeight -147

	-- local _node = --display.newNode()
 --        cc.ui.UIImage.new(Imgs.round_item_ou,{scale9 = true})
 --    _node:setContentSize(item_w, item_h) --设置大小

	local _node = cc.ui.UILabel.new({
            UILabelType = 2, 
            --image = "",
            text = contentMsg, 
            size = Dimens.TextSize_25,
            --color = Colors.black,
            color = Colors:_16ToRGB(Colors.help_txt),
            font = Fonts.Font_hkyt_w7,
            align = cc.ui.TEXT_ALIGN_LEFT,
            valign = cc.ui.TEXT_VALIGN_TOP,
            dimensions = cc.size(item_w,0) -- height为0，就是自动换行
        })
        :align(display.LEFT_TOP, 0, osHeight -147) -- 这里的x -60，y-30，都是为了填补UIScrollView边距
        --:addTo(_node)

    --local sp = display.newSprite("")
    --sp:pos(18+12+30, osHeight-118)

    ---[[
	cc.ui.UIScrollView.new({
            direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
            viewRect = {x = 0, y = 0, width = item_w, height = item_h }, -- 设置显示区域
            --capInsets = {x = 0, y = 0, width = item_w, height = item_h }, -- 设置显示区域
            -- scrollbarImgH = Imgs.scroll_barH,
            -- scrollbarImgV = Imgs.scroll_bar,
            scrollbarImgH = Imgs.c_transparent,
            scrollbarImgV = Imgs.c_transparent,
            bgColor = cc.c4b(160,160,160,0)
        })
        --:setDirection(cc.ui.UIScrollView.DIRECTION_BOTH)
        :setBounceable(false)
    	--:onScroll(function (event)
    		--Commons:printLog_Info("TestUIScrollViewScene - scrollListener:" .. event.name)
    	--end)
        :addScrollNode(_node)
        :addTo(self.pop_window)
        :align(display.LEFT_TOP, gaping_w +42, gaping_h +14)
    --]]

    --[[
    local view_hu_list = cc.ui.UIListView.new({
            --bg = Imgs.c_default_img,
            --bgStartColor = cc.c4b(255,64,64,150),
            --bgEndColor = cc.c4b(0,0,0,150),
            bgColor = cc.c4b(200, 200, 200, 0),
            --bgColor = Colors.btn_bg,
            bgScale9 = false,
            --capInsets = cc.rect(0, 0, 706, 73*4),
            viewRect = cc.rect(0, 0, item_w, item_h),
            direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
            --direction = cc.ui.UIScrollView.DIRECTION_HORIZONTAL,
            --alignment = cc.ui.UIListView.ALIGNMENT_VCENTER
            --scrollbarImgH = Imgs.c_default_img
            --scrollbarImgV = Imgs.c_default_img
        })
        :addTo(self.pop_window)
        :align(display.LEFT_TOP, 18+12+30, 30)

    local item = view_hu_list:newItem()
    item:addContent(_node)
    --Commons:printLog_Info("最终是:",item_w, item_h)
    item:setItemSize(item_w, item_h)
    view_hu_list:addItem(item) -- 添加item到列表
    view_hu_list:reload() -- 重新加载
    --]]
end

function HelpInfoDialog:onExit()
    self:myExit()
end

function HelpInfoDialog:myExit()
    if self.pop_window ~= nil and (not tolua.isnull(self.pop_window)) then
        self.pop_window:removeFromParent()
        self.pop_window = nil
    end
end

return HelpInfoDialog