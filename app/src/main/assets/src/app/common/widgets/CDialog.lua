--
-- Author: lte
-- Date: 2016-11-03 11:14:00

-- 自定义背景和title的弹窗
-- 有确认 取消按钮的操作的弹窗

-- 类申明
local CDialog = class("CDialog")


local osWidth = Commons.osWidth
local osHeight = Commons.osHeight

-- 游戏中  各种操作
CDialog.title_logo = {
    dissRoom = "dissRoom", -- 解散房间
	backHome = "backHome", -- 返回大厅
}

local gaping_w -- 整个图层的左右间距
local gaping_h -- 整个图层的上下间距
local gaping_x -- 内容背景，左右 底部 间距
local gaping_y -- 内容背景，顶部间距

-- local self.pop_window

--[[
-- 创建一个模态弹出框,  parent=要加在哪个上面

    @param: parent 基于哪里的弹窗，父类组件
    @param: titleString 头部图片
    @param: msgString   内容文字
    @param: Fun_YES   确认按钮处理事件
    @param: Fun_NO    取消按钮处理事件
--]]
function CDialog:popDialogBox(_parent, titleString, msgString, Fun_YES, Fun_NO)

    self.pop_window = display.newColorLayer(cc.c4b(0, 0, 0, 100))       -- 半透明的黑色

    self.pop_window:setContentSize(osWidth, osHeight)             -- 设置Layer的大小,全屏出现
    --self.pop_window:align(display.CENTER, display.cx, display.cy) -- Layer的锚点在0.5,0.5 因此对齐的时候要注意
    self.pop_window:setTouchEnabled(true)
    self.pop_window:setTouchSwallowEnabled(true)  -- 吞噬下层的响应
    self.pop_window:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event) -- 点击此Layer时候输出信息,然后把自己销毁
        return true
    end)
    _parent:addChild(self.pop_window, CEnum.ZOrder.common_dialog) -- 把Layer添加到父对象上


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
    local title_logo = Imgs.dialog_title_logo
    if Commons:checkIsNull_str(titleString) and CDialog.title_logo.dissRoom==titleString then
    	title_logo = Imgs.dialog_title_disroom_logo
    elseif Commons:checkIsNull_str(titleString) and CDialog.title_logo.backHome==titleString then
        title_logo = Imgs.dialog_title_backhome_logo
    end
    cc.ui.UIImage.new(title_logo,{scale9=false})
    	:addTo(self.pop_window)
    	:align(display.CENTER_TOP, display.cx, osHeight -gaping_h -11)

    --[[
    -- 关闭按钮
    cc.ui.UIPushButton.new(Imgs.dialog_exit,{scale9=false})
        :setButtonSize(56, 56)
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
        :align(display.CENTER, osWidth-214-52/2, osHeight-155-52/2)
    	:addTo(self.pop_window)
    --]]

    -- 取消按钮
    local cancelBtn_logo = Imgs.dialog_btn_cancel_alert
    local cancelBtn_logo_press = Imgs.dialog_btn_cancel_alert_press
    if Commons:checkIsNull_str(titleString) and CDialog.title_logo.dissRoom==titleString then
        cancelBtn_logo = Imgs.dialog_btn_notagree
        cancelBtn_logo_press = Imgs.dialog_btn_notagree_press
    end

    local cancelBtn = cc.ui.UIPushButton.new(
            cancelBtn_logo,{scale9=false})
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
            :setButtonImage(EnStatus.pressed, cancelBtn_logo_press)
            :onButtonClicked(function(e)

                VoiceDealUtil:playSound_other(Voices.file.ui_click)
                self:myExit()
                if Fun_NO~=nil and type(Fun_NO)=="function" then
                    Fun_NO()
                end

            end)
            :align(display.CENTER_BOTTOM, display.cx, gaping_h +10)
            :addTo(self.pop_window)
            :hide()

    -- 确定按钮
    local submitBtn_logo = Imgs.dialog_btn_confim_alert
    local submitBtn_logo_press = Imgs.dialog_btn_confim_alert_press
    if Commons:checkIsNull_str(titleString) and CDialog.title_logo.dissRoom==titleString then
        submitBtn_logo = Imgs.dialog_btn_agree
        submitBtn_logo_press = Imgs.dialog_btn_agree_press
    end
    
    local submitBtn = cc.ui.UIPushButton.new(
           submitBtn_logo,{scale9=false})
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
            :setButtonImage(EnStatus.pressed, submitBtn_logo_press)
            :onButtonClicked(function(e)

                VoiceDealUtil:playSound_other(Voices.file.ui_click)
                self:myExit()
                if Fun_YES~=nil and type(Fun_YES)=="function" then
                    Fun_YES()
                end

            end)
            :align(display.CENTER_BOTTOM, display.cx, gaping_h +10)
            :addTo(self.pop_window)
            :hide()

    
    if Fun_NO ~= nil and Fun_YES ~= nil then -- 2个按钮都有
        cancelBtn
            :align(display.CENTER_BOTTOM, display.cx -105, gaping_h +10)
            :show()
        submitBtn
            :align(display.CENTER_BOTTOM, display.cx +105, gaping_h +10)
            :show()
    elseif Fun_NO == nil and Fun_YES ~= nil then -- 只有确认按钮
        submitBtn
            :align(display.CENTER_BOTTOM, display.cx, gaping_h +10)
            :show()
    elseif Fun_NO ~= nil and Fun_YES == nil then -- 只有取消按钮
        cancelBtn
            :align(display.CENTER_BOTTOM, display.cx, gaping_h +10)
            :show()
    else -- =nil 2个按钮都不在
    end

    -- 内容
    self:create_content(msgString)

    return self.pop_window
end

-- 内容
function CDialog:create_content(contentMsg)
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
        :align(display.CENTER, display.cx, display.cy)
        :addTo(self.pop_window)
end

-- function CDialog:ctor()
-- end

-- function CDialog:onExit()
-- end

function CDialog:myExit()
    if self.pop_window ~= nil and (not tolua.isnull(self.pop_window)) then
        self.pop_window:removeFromParent()
        self.pop_window = nil
    end
end

return CDialog
