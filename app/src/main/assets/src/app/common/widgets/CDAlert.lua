--
-- Author: lte
-- Date: 2016-10-19 12:40:33
-- 自定义背景和title的弹窗

-- 类申明
local CDAlert = class("CDAlert")

local osWidth = Commons.osWidth
local osHeight = Commons.osHeight

local gaping_w -- 整个图层的左右间距
local gaping_h -- 整个图层的上下间距
-- local gaping_x -- 内容背景，左右 底部 间距
-- local gaping_y -- 内容背景，顶部间距

-- local self.pop_window

-- 创建一个模态弹出框,  parent=要加在哪个上面
function CDAlert:popDialogBox(_parent, contentMsg)

    self.parent = _parent

    self.pop_window = display.newColorLayer(cc.c4b(0, 0, 0, 0))       -- 半透明的黑色

    self.pop_window:setContentSize(osWidth, osHeight)             -- 设置Layer的大小,全屏出现
    --self.pop_window:align(display.CENTER, display.cx, display.cy) -- Layer的锚点在0.5,0.5 因此对齐的时候要注意
    self.pop_window:setTouchEnabled(true)
    self.pop_window:setTouchSwallowEnabled(true)  -- 吞噬下层的响应
    self.pop_window:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event) -- 点击此Layer时候输出信息,然后把自己销毁
        return true
    end)
    self.parent:addChild(self.pop_window, CEnum.ZOrder.common_dialog) -- 把Layer添加到父对象上


    gaping_w = 410+50
    gaping_h = 234+40
    if CVar._static.isIphone4 or CVar._static.isIpad then
        gaping_w = gaping_w -100
    end


    --[[
    -- 整个底色背景
    display.newSprite(Imgs.dialog_bg)
	--display.newScale9Sprite(Imgs.dialog_bg, 0, 0, cc.size(400, 400))--,cc.rect(10,10,400,400))
		:center()
        --:setCapInsets(cc.rect(20,20,400,400))
        --:setCapInsets( Rect CCRectMake(3, 3, 34, 34) );
		--:setContentSize(cc.size(osWidth-100, osHeight-100))
    	:addTo(self.pop_window)
    	:setScale(0.77)
	--]]
    cc.ui.UIImage.new(Imgs.dialog_content_bg_tran,{scale9=true})
        :addTo(self.pop_window)
        :align(display.CENTER, display.cx, display.cy-100)
        :setLayoutSize(osWidth -gaping_w*2 -10*2, osHeight -gaping_h*2 -92)
    
    -- 内容
    self:create_content(contentMsg)

    _parent:performWithDelay(function () 
        self:myExit()
    end, 1.2)
end

-- 内容
function CDAlert:create_content(contentMsg)
    cc.ui.UILabel.new({
            UILabelType = 2, 
            --image = "",
            text = contentMsg, 
            size = Dimens.TextSize_25,
            color = Colors.white,
            -- color = Colors:_16ToRGB(Colors.keyboard),
            font = Fonts.Font_hkyt_w7,
            align = cc.ui.TEXT_ALIGN_CENTER,
            valign = cc.ui.TEXT_VALIGN_CENTER,
            dimensions = cc.size((osWidth -gaping_w*2 -20*2),0) -- height为0，就是自动换行
        })
        :align(display.CENTER, display.cx, display.cy-100)
        :addTo(self.pop_window)
end

-- function CDAlert:ctor()
-- end

-- function CDAlert:onExit()
-- end

function CDAlert:myExit()
    if self.pop_window ~= nil and (not tolua.isnull(self.pop_window)) then
        self.pop_window:removeFromParent()
        self.pop_window = nil
    end
end

return CDAlert
