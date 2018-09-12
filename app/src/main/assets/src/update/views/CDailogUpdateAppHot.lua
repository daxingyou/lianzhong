--
-- Author: lte
-- Date: 2016-10-19 12:40:33
-- 自定义背景和title的弹窗  需要点击下自动关闭

-- 类申明
local CDailogUpdateAppHot = class("CDailogUpdateAppHot")


-- 处理方法申明

-- 创建一个模态弹出框, parent 要加在哪个上面
function CDailogUpdateAppHot:popDialogBox(parent,  descript, versionName, apkSize,  apkDownloadUrl, Fun_YES, Fun_NO)
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

        --parent:removeChild(self.pop_window)
        --self.pop_window:removeSelf()

        return true
    end)
    parent:addChild(self.pop_window, CEnumUpd.ZOrder.alert_dialog) -- 把Layer添加到父对象上


    self.gaping_w = 306
    self.gaping_h = 134
    self.gaping_x = 10
    self.gaping_y = 74

    if CVarUpd._static.isIphone4 or CVarUpd._static.isIpad then
        self.gaping_w = 206
    end
    if CVarUpd._static.NavBarH_Android ~= CEnumUpd.status.NavBarH_def then
        self.gaping_w = 306 -CVarUpd._static.NavBarH_Android
    end


    ---[[
    -- 整个底色背景
    cc.ui.UIImage.new(ImgsUpd.dialog_bg,{scale9=false})
    	:addTo(self.pop_window)
    	:align(display.CENTER, display.cx, display.cy)
    	:setLayoutSize(self.osWidth -self.gaping_w*2, self.osHeight -self.gaping_h*2)
    --]]

    -- 内容背景
    cc.ui.UIImage.new(ImgsUpd.dialog_content_bg,{scale9=false})
        :addTo(self.pop_window)
        :align(display.CENTER, display.cx, display.cy -self.gaping_y*0.5)
        :setLayoutSize(self.osWidth -self.gaping_w*2 -self.gaping_x*2, osHeight -self.gaping_h*2 -self.gaping_y -self.gaping_x)

    ---[[
    -- 提示 logo
    cc.ui.UIImage.new(ImgsUpd.dialog_title_logo,{scale9=false})
    	:addTo(self.pop_window)
        :align(display.CENTER_TOP, display.cx, self.osHeight -self.gaping_h -11)
    --]]

    ---[[
    -- 关闭
    local cancelBtn = cc.ui.UIPushButton.new(
        -- ImgsUpd.dialog_exit,
        {
        normal=ImgsUpd.dialog_exit,
        pressed=ImgsUpd.dialog_exit_press
        },
        {scale9=false})
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
        -- :setButtonImage(EnStatus.pressed, ImgsUpd.dialog_exit_press)
        :onButtonClicked(function(e)

        	-- VoiceDealUtil:playSound_other(Voices.file.ui_click)
            self:myExit()
            if Fun_NO~=nil and type(Fun_NO)=="function" then
                Fun_NO()
            end

        end)
        :align(display.RIGHT_TOP, self.osWidth -self.gaping_w -self.gaping_x, self.osHeight -self.gaping_h -11)
    	:addTo(self.pop_window)
        :hide()
    --]]

    ---[[
    -- 确定按钮
    local submitBtn = cc.ui.UIPushButton.new(
        -- ImgsUpd.dialog_btn_update,
        {
        normal=ImgsUpd.dialog_btn_update,
        pressed=ImgsUpd.dialog_btn_update_press
        },
        {scale9=false})
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
        -- :setButtonImage(EnStatus.pressed, ImgsUpd.dialog_btn_update_press)
        :onButtonClicked(function(e)

        	-- VoiceDealUtil:playSound_other(Voices.file.ui_click)
            if Fun_YES~=nil and type(Fun_YES)=="function" then
                Fun_YES()
            end

        end)
        :align(display.CENTER_BOTTOM, display.cx, self.gaping_h +10)
        :addTo(self.pop_window)
        :hide()
    --]]

    if Fun_NO ~= nil and Fun_YES ~= nil then -- 2个按钮都有
        cancelBtn:show()
        submitBtn:show()
    elseif Fun_NO == nil and Fun_YES ~= nil then -- 只有确认按钮
        submitBtn:show()
    elseif Fun_NO ~= nil and Fun_YES == nil then -- 只有取消按钮
        cancelBtn:show()
    else -- =nil 2个按钮都不在
    end
    
    -- 内容
    self:create_content(descript, versionName, apkSize,  apkDownloadUrl)

end

-- 内容
function CDailogUpdateAppHot:create_content(descript, versionName, apkSize,  apkDownloadUrl)

		if CommonsUpd:checkIsNull_str(descript) then
		    dissRoom_title = cc.ui.UILabel.new({
		            UILabelType = 2, 
		            --image = "",
		            text = descript, 
                    -- size = Dimens.TextSize_30,
		            size = 30,
		            --color = Colors.black,
                    -- color = Colors:_16ToRGB(Colors.keyboard),
		            color = cc.c3b(127,77,22),
		            font = FontsUpd.Font_hkyt_w7,
		            align = cc.ui.TEXT_ALIGN_LEFT,
		            valign = cc.ui.TEXT_VALIGN_CENTER,
		            dimensions = cc.size((self.osWidth -self.gaping_w*2 -self.gaping_x*2 -82),0) -- height为0，就是自动换行
		        })
		        :align(display.LEFT_TOP, self.gaping_w +(self.osWidth-self.gaping_w*2-self.gaping_x*2)/5, display.cy+80)
		        :addTo(self.pop_window)
	    end


		-- if CommonsUpd:checkIsNull_str(versionName) then
		-- 	cc.ui.UILabel.new({
	 --            UILabelType = 2, 
	 --            --image = "",
	 --            text = "版本号："..versionName, 
	 --            size = Dimens.TextSize_25,
	 --            --color = Colors.red,
	 --            color = Colors:_16ToRGB(Colors.dissRoom_green),
	 --            font = Fonts.Font_hkyt_w7,
	 --            align = cc.ui.TEXT_ALIGN_CENTER,
	 --            valign = cc.ui.TEXT_VALIGN_CENTER,
	 --            --dimensions = cc.size((self.osWidth-186*2-6*2-20),0) -- height为0，就是自动换行
	 --        })
	 --        :align(display.LEFT_TOP, 186+6+10+40, display.cy+20-((1-1)*30))
	 --        :addTo(self.pop_window)
	 --    end

		-- if CommonsUpd:checkIsNull_str(apkSize) then
		-- 	--apkSize = apkSize / 1024 /1024
		-- 	--local zz = apkSize - apkSize%1
		-- 	--local xi = apkSize - apkSize%0.01
		-- 	--CommonsUpd:printLog_Info(x-x%1)-- 整数部分
		-- 	--CommonsUpd:printLog_Info(x-x%0.01)--取2位小数
		-- 	cc.ui.UILabel.new({
	 --            UILabelType = 2, 
	 --            --image = "",
	 --            text = "大  小：".. apkSize, 
	 --            --text = "大  小：".. string.format("%.1f", apkSize)  .. "MB", 
	 --            size = Dimens.TextSize_25,
	 --            --color = Colors.green,
	 --            color = Colors:_16ToRGB(Colors.dissRoom_green),
	 --            font = Fonts.Font_hkyt_w7,
	 --            align = cc.ui.TEXT_ALIGN_CENTER,
	 --            valign = cc.ui.TEXT_VALIGN_CENTER,
	 --            --dimensions = cc.size((self.osWidth-186*2-6*2-20),0) -- height为0，就是自动换行
	 --        })
	 --        :align(display.LEFT_TOP, 186+6+10+40, display.cy+20-((2-1)*35))
	 --        :addTo(self.pop_window)
		-- end
end


-- 构造函数
function CDailogUpdateAppHot:ctor()
end

function CDailogUpdateAppHot:onExit()
    self:myExit()
end

function CDailogUpdateAppHot:myExit()
    if self.pop_window ~= nil and (not tolua.isnull(self.pop_window)) then
        self.pop_window:removeFromParent()
        self.pop_window = nil
    end
end

-- 必须有这个返回
return CDailogUpdateAppHot
