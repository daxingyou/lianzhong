--
-- Author: wh
-- Date: 2017-05-10 12:40:33
-- 发生IP检测（提醒玩家反作弊）

-- 类申明
local PDKServerIpCheckDialogNew = class("PDKServerIpCheckDialogNew",
	function()
		return display.newNode()
	end
)


local osWidth = Commons.osWidth
local osHeight = Commons.osHeight

local dissRoom_cancelBtn
local dissRoom_submitBtn

local alert_gaping_w
local alert_gaping_h

-- 创建一个模态弹出框, parent 要加在哪个上面
function PDKServerIpCheckDialogNew:ctor(res_data)

    self.res_data = res_data

    self.pop_window = display.newColorLayer(cc.c4b(0, 0, 0, 100))       -- 半透明的黑色
    --_self.pop_window_alert = self.pop_window;

    self.pop_window:setContentSize(osWidth, osHeight)             -- 设置Layer的大小,全屏出现
    --self.pop_window:align(display.CENTER, display.cx, display.cy) -- Layer的锚点在0.5,0.5 因此对齐的时候要注意
    self.pop_window:setTouchEnabled(true)
    self.pop_window:setTouchSwallowEnabled(true)  -- 吞噬下层的响应
    self.pop_window:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event) -- 点击此Layer时候输出信息,然后把自己销毁
        --local label = string.format("-- %s x,y: %0.2f, %0.2f", event.name, event.x, event.y)
        --Commons:printLog_Info(label)
        --parent:removeChild(self.pop_window)
        --self.pop_window:removeSelf()
        return true
    end)
    self:addChild(self.pop_window, CEnum.ZOrder.common_dialog) -- 把Layer添加到父对象上


    local topScale = 0.8
    alert_gaping_w = 100 +150
    alert_gaping_h = 95 +50
    local moveY_all = 0
    if CVar._static.isIphone4 then
        alert_gaping_w = alert_gaping_w -10
        alert_gaping_h = alert_gaping_h -30
    elseif CVar._static.isIpad then
        alert_gaping_w = alert_gaping_w -100
        alert_gaping_h = alert_gaping_h -30
    elseif CVar._static.NavBarH_Android ~= CEnum.status.NavBarH_def then
        alert_gaping_w = alert_gaping_w -CVar._static.NavBarH_Android
        alert_gaping_h = alert_gaping_h
    end


    ---[[
    -- 整个底色背景
    cc.ui.UIImage.new(Imgs.dialog_bg,{scale9=false})
        :addTo(self.pop_window)
        :align(display.CENTER, display.cx, display.cy)
        :setLayoutSize(osWidth-alert_gaping_w*2, osHeight-alert_gaping_h*2)
    	-- :align(display.CENTER, display.cx, osHeight -alert_gaping_h-72/2 +moveY_all)
     --    :setLayoutSize(osWidth-alert_gaping_w*2, 72)
    --]]

    ---[[
    -- 内容背景
    cc.ui.UIImage.new(Imgs.dialog_content_bg,{scale9=false})
        :addTo(self.pop_window)
        :align(display.CENTER, display.cx, osHeight -alert_gaping_h-72 -(osHeight-alert_gaping_h*2-72)/2 +moveY_all)
        :setLayoutSize(osWidth-alert_gaping_w*2 -6*2, osHeight-alert_gaping_h*2-72 -12)
    --]]

    ---[[
    -- 提示 logo
    cc.ui.UIImage.new(Imgs.dialog_title_logo,{scale9=false})
    	:addTo(self.pop_window)
        :align(display.CENTER_TOP, display.cx, osHeight-alert_gaping_h-8 -10 +moveY_all)
        :setScale(topScale)
    --]]

    ---[[
    -- 取消按钮  =离开
    dissRoom_cancelBtn = cc.ui.UIPushButton.new(Imgs.dialog_btn_goout,{scale9=false})
        --:setButtonSize(56, 56)
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
        :setButtonImage(EnStatus.pressed, Imgs.dialog_btn_goout_press)
        :onButtonClicked(function(e)

        	VoiceDealUtil:playSound_other(Voices.file.ui_click)
            self:sendDissRoom()

        end)
        :align(display.BOTTOM_CENTER, display.cx-205, alert_gaping_h+50 +moveY_all)
    	:addTo(self.pop_window)
	local owner = nil
    if self.res_data ~= nil then
    	local GprsBean = self.res_data[Room.Bean.playerDistance]
    	owner = GprsBean[Player.Bean.owner]
    end
    -- print("*************************owner==", owner)
    if owner then
    	dissRoom_cancelBtn:setButtonImage(EnStatus.normal, Imgs.dialog_btn_godiss)
        dissRoom_cancelBtn:setButtonImage(EnStatus.pressed, Imgs.dialog_btn_godiss_press)
    end
    --]]

    ---[[
    -- 确定按钮  =继续
    dissRoom_submitBtn = cc.ui.UIPushButton.new(
        Imgs.dialog_btn_goon,{scale9=false})
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
        :setButtonImage(EnStatus.pressed, Imgs.dialog_btn_goon_press)
        :onButtonClicked(function(e)

        	VoiceDealUtil:playSound_other(Voices.file.ui_click)
            self:myExit()
        end)
        :align(display.BOTTOM_CENTER, display.cx+205, alert_gaping_h+50 +moveY_all)
        :addTo(self.pop_window)
    --]]
    
    -- 内容
    self:create_content()
end


--返回大厅，需要通知服务器可以不可以
function PDKServerIpCheckDialogNew:backHome_OK_toSendServer()
    SocketRequestGameing:gameing_BackHaLL()
    self:myExit()
end

-- 本人要解散房间的弹窗确认取消事件
function PDKServerIpCheckDialogNew:dissRoomMeConfim_OK()
    SocketRequestGameing:dissRoom()
    self:myExit()
end

function PDKServerIpCheckDialogNew:sendDissRoom()
    local owner = nil
    if self.res_data ~= nil then
    	local GprsBean = self.res_data[Room.Bean.playerDistance]
    	owner = GprsBean[Player.Bean.owner]
    end
    -- print("*************************owner==", owner)
    if owner then
        CDialog.new():popDialogBox(self.pop_window, 
            nil, Strings.gameing.dissRoomConfim, 
            function() self:dissRoomMeConfim_OK() end, 
            function() end )
    else
    	CDialog.new():popDialogBox(self.pop_window, 
            CDialog.title_logo.backHome, Strings.gameing.outRoomConfim, 
            function() self:backHome_OK_toSendServer() end, 
            function() end)
    end
end

-- 内容
function PDKServerIpCheckDialogNew:create_content()

    local moveY = 10
    if CVar._static.isIphone4 then
        moveY = 30
    elseif CVar._static.isIpad then
        moveY = 30
    elseif CVar._static.NavBarH_Android ~= CEnum.status.NavBarH_def then
        moveY = 0
    end

	if self.res_data ~= nil then
		local descript = RequestBase:getStrDecode(self.res_data[Room.Bean.popDesc] )
		if Commons:checkIsNull_str(descript) then
		    cc.ui.UILabel.new({
		            UILabelType = 2, 
		            --image = "",
		            text = descript, 
		            size = Dimens.TextSize_25,
		            --color = Colors.black,
		            color = Colors:_16ToRGB(Colors.keyboard),
		            font = Fonts.Font_hkyt_w7,
		            align = cc.ui.TEXT_ALIGN_LEFT,
		            valign = cc.ui.TEXT_VALIGN_CENTER,
		            dimensions = cc.size((osWidth-alert_gaping_w*2-6*2-90),0) -- height为0，就是自动换行
		        })
		        :align(display.LEFT_TOP, alert_gaping_w+6+10+40, display.cy+alert_gaping_h/2 +moveY)
		        :addTo(self.pop_window)
	    end
    end
end

function PDKServerIpCheckDialogNew:onExit()
    self:myExit()
end

function PDKServerIpCheckDialogNew:myExit()
	if self.pop_window and not tolua.isnull(self.pop_window) then
		self.pop_window:removeFromParent()
		self.pop_window = nil
	end
end

-- 必须有这个返回
return PDKServerIpCheckDialogNew