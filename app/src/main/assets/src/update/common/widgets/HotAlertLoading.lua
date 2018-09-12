--
-- Author: lte
-- Date: 2016-10-19 12:40:33
-- 自定义背景和title的弹窗

-- 类申明
local HotAlertLoading = class("HotAlertLoading")


-- 创建一个模态弹出框, parent 要加在哪个上面
function HotAlertLoading:popDialogBox(parent, contentMsg)
    self.osWidth = CommonsUpd.osWidth
    self.osHeight = CommonsUpd.osHeight

    self._parent = parent
    self.pop_window = display.newColorLayer(cc.c4b(0, 0, 0, 100))       -- 半透明的黑色

    self.pop_window:setContentSize(self.osWidth, self.osHeight)             -- 设置Layer的大小,全屏出现
    --self.pop_window:align(display.CENTER, display.cx, display.cy) -- Layer的锚点在0.5,0.5 因此对齐的时候要注意
    self.pop_window:setTouchEnabled(true)
    self.pop_window:setTouchSwallowEnabled(true)  -- 吞噬下层的响应
    self.pop_window:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event) -- 点击此Layer时候输出信息,然后把自己销毁
        --local label = string.format("-- %s x,y: %0.2f, %0.2f", event.name, event.x, event.y)
        --CommonsUpd:printLog_Info(label)

        -- parent:removeChild(self.pop_window)
        --self.pop_window:removeSelf()
        
        return true
    end)
    parent:addChild(self.pop_window, CEnumUpd.ZOrder.alert_dialog) -- 把Layer添加到父对象上


    self.gaping_w = 410
    if CVarUpd._static.isIphone4 or CVarUpd._static.isIpad then
        self.gaping_w = self.gaping_w - 150
    end
    
    -- 内容
    -- self:create_content(contentMsg)
    self:createLoading2()
    return self.pop_window

end

-- 加载中的动画显示，搞一个精灵动画即可
function HotAlertLoading:createLoading()
    ---[[
    display.addSpriteFrames(ImgsUpd.c_loading_plist, ImgsUpd.c_loading_png)
    self.loadingPop_window = display.newSprite("#c_loading01.png")
        :align(display.CENTER, display.cx, display.cy)
        :addTo(self.pop_window)
        :setVisible(true)
    local frames = display.newFrames("c_loading%02d.png",1,4)
    local animation = display.newAnimation(frames, 1.0/2)
    --animation:setDelayPerUnit(0.15) -- 设置两个帧播放时
    --animation:setRestoreOriginalFrame(true) -- 动画执行后还原初始状态
    --display.setAnimationCache("stars", animation)
    --animation = display.getAnimationCache("stars")
    --display.removeAnimationCache("stars")
    --self.loadingPop_window:playAnimationOnce(animation, false, function()
    --  CommonsUpd:printLog_Info("complete")
    --end, 2)
    self.loadingPop_window:playAnimationForever(animation)
    --self.loadingPop_window:stopAllActions()
    --]]
end

-- 加载中的动画显示，搞一个精灵动画即可
function HotAlertLoading:createLoading2()
    self.juhua = display.newSprite(ImgsUpd.c_juhua)
    :addTo(self.pop_window)
    self.juhua:runAction(cc.RepeatForever:create(cc.RotateBy:create(100, 36000)))
    self.juhua:pos(display.cx,display.cy)
end

-- 内容
function HotAlertLoading:create_content(contentMsg)
    local txtView = cc.ui.UILabel.new({
            UILabelType = 2, 
            --image = "",
            text = contentMsg, 
            -- size = Dimens.TextSize_30,
            size = 30,
            --color = Colors.black,
            -- color = Colors:_16ToRGB(Colors.keyboard),
            color = cc.c3b(127,77,22),
            font = FontsUpd.Font_hkyt_w9,
            align = cc.ui.TEXT_ALIGN_CENTER,
            valign = cc.ui.TEXT_VALIGN_CENTER,
            dimensions = cc.size((self.osWidth -self.gaping_w*2 -20*2),0) -- height为0，就是自动换行
        })
        :align(display.CENTER, display.cx, display.cy-60)
        :addTo(self.pop_window)
    return txtView
end

-- 构造函数
function HotAlertLoading:ctor()
end

function HotAlertLoading:onExit()
    self:myExit()
end

function HotAlertLoading:myExit()
    if self.loadingPop_window~=nil and (not tolua.isnull(self.loadingPop_window)) then
        self.loadingPop_window:stopAllActions()
        self.loadingPop_window:setVisible(false)
        self.loadingPop_window = nil
    end
end

-- 必须有这个返回
return HotAlertLoading
