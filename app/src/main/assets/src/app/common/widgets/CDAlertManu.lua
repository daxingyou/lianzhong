--
-- Author: lte
-- Date: 2016-10-19 12:40:33
-- 自定义背景和title的弹窗

-- 类申明
local CDAlertManu = class("CDAlertManu")


local osWidth = Commons.osWidth
local osHeight = Commons.osHeight

local gaping_w -- 整个图层的左右间距
local gaping_h -- 整个图层的上下间距
local gaping_x -- 内容背景，左右 底部 间距
local gaping_y -- 内容背景，顶部间距

-- local self.pop_window

-- 创建一个模态弹出框, parent 要加在哪个上面
function CDAlertManu:popDialogBox(_parent, contentMsg, isPressScreenClose)

    self.parent = _parent
    
    self.pop_window = display.newColorLayer(cc.c4b(0, 0, 0, 100))       -- 半透明的黑色

    self.pop_window:setContentSize(osWidth, osHeight)             -- 设置Layer的大小,全屏出现
    --self.pop_window:align(display.CENTER, display.cx, display.cy) -- Layer的锚点在0.5,0.5 因此对齐的时候要注意
    self.pop_window:setTouchEnabled(true)
    self.pop_window:setTouchSwallowEnabled(true)  -- 吞噬下层的响应
    self.pop_window:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event) -- 点击此Layer时候输出信息,然后把自己销毁
        if isPressScreenClose~=nil and isPressScreenClose then
            self:myExit()
        end        
        return true
    end)
    self.parent:addChild(self.pop_window, CEnum.ZOrder.common_dialog) -- 把Layer添加到父对象上


    gaping_w = 336
    gaping_h = 184
    gaping_x = 10
    gaping_y = 74
    if CVar._static.isIphone4 or CVar._static.isIpad then
        gaping_w = gaping_w -100
    end


    ---[[
    -- 整个底色背景
    cc.ui.UIImage.new(Imgs.dialog_bg,{scale9=false})
        :addTo(self.pop_window)
    	:align(display.CENTER, display.cx, display.cy)
    	:setLayoutSize(osWidth -gaping_w*2, osHeight -gaping_h*2)
    --]]

    -- 内容背景
    cc.ui.UIImage.new(Imgs.dialog_content_bg,{scale9=false})
        :addTo(self.pop_window)
        :align(display.CENTER, display.cx, display.cy -gaping_y*0.5)
        :setLayoutSize(osWidth -gaping_w*2 -gaping_x*2, osHeight -gaping_h*2 -gaping_y -gaping_x)

    -- 提示 logo
    cc.ui.UIImage.new(Imgs.dialog_title_logo,{scale9=false})
    	:addTo(self.pop_window)
    	:align(display.CENTER_TOP, display.cx, osHeight -gaping_h -11)

    ---[[
    -- 关闭按钮
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
            self:myExit()

        end)
        :align(display.RIGHT_TOP, osWidth -gaping_w -gaping_x, osHeight -gaping_h -11)
    	:addTo(self.pop_window)
    --]]

    --[[
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
            self:myExit()

        end)
        :align(display.CENTER, display.cx, osHeight-462-100/2)
        :addTo(self.pop_window)
    --]]
    
    -- 内容
    self:create_content(contentMsg)
end

-- 内容
function CDAlertManu:create_content(contentMsg)
    cc.ui.UILabel.new({
            UILabelType = 2, 
            --image = "",
            text = contentMsg, 
            size = Dimens.TextSize_30,
            --color = Colors.black,
            color = Colors:_16ToRGB(Colors.keyboard),
            font = Fonts.Font_hkyt_w9,
            align = cc.ui.TEXT_ALIGN_CENTER,
            valign = cc.ui.TEXT_VALIGN_CENTER,
            dimensions = cc.size((osWidth -gaping_w*2 -20*2),0) -- height为0，就是自动换行
        })
        :align(display.CENTER, display.cx, display.cy-30)
        :addTo(self.pop_window)
end


-- function CDAlertManu:ctor()
-- end

-- function CDAlertManu:onExit()
-- end

function CDAlertManu:myExit()
    if self.pop_window ~= nil and (not tolua.isnull(self.pop_window)) then
        self.pop_window:removeFromParent()
        self.pop_window = nil
    end
end

return CDAlertManu
