--
-- Author: wh
-- Date: 2017-05-10 12:40:33
-- 解散房间

-- 类申明
local PDKDissRoomDialog = class("PDKDissRoomDialog",
	function()
		return display.newNode()
	end
)


local osWidth = Commons.osWidth
local osHeight = Commons.osHeight

local dissRoom_cancelBtn
local dissRoom_submitBtn

local gaping_w
local gaping_h

-- 创建一个模态弹出框, parent 要加在哪个上面
function PDKDissRoomDialog:ctor(res_data)

    self.pop_window = display.newColorLayer(cc.c4b(0, 0, 0, 100))       -- 半透明的黑色

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

    gaping_w = 186
	gaping_h = 114 
	gaping_x = 10
    gaping_y = 74

    if CVar._static.isIphone4 then
    	gaping_w = gaping_w -10
    elseif CVar._static.isIpad then
    	gaping_w = gaping_w -50
    elseif CVar._static.NavBarH_Android ~= CEnum.status.NavBarH_def then
        gaping_w = gaping_w -CVar._static.NavBarH_Android
    end

    ---[[
    -- 整个底色背景
    cc.ui.UIImage.new(Imgs.dialog_bg,{scale9=false})
    	:addTo(self.pop_window)
    	:align(display.CENTER, display.cx, display.cy)
        :setLayoutSize(osWidth -gaping_w*2, osHeight -gaping_h*2)
    --]]

    ---[[
    -- 内容背景
    cc.ui.UIImage.new(Imgs.dialog_content_bg,{scale9=true})
        :addTo(self.pop_window)
        :align(display.CENTER, display.cx, display.cy -gaping_y*0.5)
        :setLayoutSize(osWidth -gaping_w*2 -gaping_x*2, osHeight -gaping_h*2 -gaping_y -gaping_x)
    --]]

    ---[[
    -- 提示 logo
    cc.ui.UIImage.new(Imgs.dialog_title_disroom_logo,{scale9=false})
    	:addTo(self.pop_window)
    	:align(display.CENTER_TOP, display.cx, osHeight -gaping_h -11)
    --]]

    ---[[
    -- 取消按钮  =拒绝
    dissRoom_cancelBtn = cc.ui.UIPushButton.new(Imgs.dialog_btn_notagree,{scale9=false})
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
        :setButtonImage(EnStatus.pressed, Imgs.dialog_btn_notagree_press)
        :onButtonClicked(function(e)
        
        	VoiceDealUtil:playSound_other(Voices.file.ui_click)
            SocketRequestGameing:dissRoom_confim(CEnum.jiadi.no)
            
        end)
        :align(display.CENTER_BOTTOM, display.cx-205, gaping_h+66)
    	:addTo(self.pop_window)
    --]]

    ---[[
    -- 确定按钮  ==同意
    dissRoom_submitBtn = cc.ui.UIPushButton.new(
        Imgs.dialog_btn_agree,{scale9=false})
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
        :setButtonImage(EnStatus.pressed, Imgs.dialog_btn_agree_press)
        :onButtonClicked(function(e)

        	VoiceDealUtil:playSound_other(Voices.file.ui_click)
            SocketRequestGameing:dissRoom_confim(CEnum.jiadi.yes)
            
        end)
        :align(display.CENTER_BOTTOM, display.cx+205, gaping_h+66)
        :addTo(self.pop_window)
    --]]

    
	self.top_scheduler = self:getScheduler()
    
    -- 内容
    self:create_content(res_data)

end

-- 内容
local dissRoom_title
local dissRoom_second
local dissRoom_players_node
function PDKDissRoomDialog:create_content(res_data)
	local startX_1row = gaping_w +6+10+40
	
	if res_data ~= nil then
		local descript = RequestBase:getStrDecode(res_data[Room.Bean.descript] )
		local overtime = res_data[Room.Bean.overtime]
		local choose = res_data[Room.Bean.choose]
		local playerChooses = res_data[Room.Bean.playerChooses]

		if Commons:checkIsNull_str(descript) then
			if dissRoom_title then 
				dissRoom_title:removeFromParent()
				dissRoom_title = nil
			end
		    dissRoom_title = cc.ui.UILabel.new({
		            UILabelType = 2, 
		            --image = "",
		            text = descript, 
		            size = Dimens.TextSize_25,
		            --color = Colors.black,
		            color = Colors:_16ToRGB(Colors.keyboard),
		            font = Fonts.Font_hkyt_w7,
		            align = cc.ui.TEXT_ALIGN_LEFT,
		            valign = cc.ui.TEXT_VALIGN_CENTER,
		            dimensions = cc.size((osWidth -gaping_w*2 -gaping_x*2 -82),0) -- height为0，就是自动换行
		        })
		        :align(display.LEFT_TOP, startX_1row, display.cy+100)
		        :addTo(self.pop_window)
	    end

	    if Commons:checkIsNull_tableList(playerChooses) then

	    	if dissRoom_players_node then
	    		dissRoom_players_node:removeFromParent()
	    		dissRoom_players_node = nil
	    	end

	    	dissRoom_players_node = display.newNode():addTo(self.pop_window)
	    		--dissRoom_players_node:align(display.LEFT_TOP, 186+6+10+30, display.cy+50)

	    	for k,v in pairs(playerChooses) do
	    		local desc = RequestBase:getStrDecode(v[Room.Bean.descript])
	    		local status = v[Room.Bean.status]

	    		if status == CEnum.dissRoomStatus.wait then
	    			cc.ui.UILabel.new({
			            UILabelType = 2, 
			            --image = "",
			            text = desc, 
			            size = Dimens.TextSize_25,
			            --color = Colors.red,
			            color = Colors:_16ToRGB(Colors.dissRoom_red),
			            font = Fonts.Font_hkyt_w7,
			            align = cc.ui.TEXT_ALIGN_CENTER,
			            valign = cc.ui.TEXT_VALIGN_CENTER,
			            --dimensions = cc.size((osWidth-gaping_w*2-6*2-20),0) -- height为0，就是自动换行
			        })
			        :align(display.LEFT_TOP, startX_1row, display.cy+20-((k-1)*30))
			        :addTo(dissRoom_players_node)
	    		elseif status == CEnum.dissRoomStatus.agreed then
	    			cc.ui.UILabel.new({
			            UILabelType = 2, 
			            --image = "",
			            text = desc, 
			            size = Dimens.TextSize_25,
			            --color = Colors.green,
			            color = Colors:_16ToRGB(Colors.dissRoom_green),
			            font = Fonts.Font_hkyt_w7,
			            align = cc.ui.TEXT_ALIGN_CENTER,
			            valign = cc.ui.TEXT_VALIGN_CENTER,
			            --dimensions = cc.size((osWidth-gaping_w*2-6*2-20),0) -- height为0，就是自动换行
			        })
			        :align(display.LEFT_TOP, startX_1row, display.cy+20-((k-1)*30))
			        :addTo(dissRoom_players_node)
	    		end
	    	end
	    end

	    if Commons:checkIsNull_number(overtime) then
	    	if dissRoom_second then
	    		dissRoom_second:removeFromParent()
	    		dissRoom_second = nil
	    	end
	        dissRoom_second = cc.ui.UILabel.new({
		            UILabelType = 2, 
		            --image = "",
		            text = ""..overtime, 
		            size = Dimens.TextSize_25,
		            --color = Colors.black,
		            color = Colors:_16ToRGB(Colors.keyboard),
		            font = Fonts.Font_hkyt_w7,
		            align = cc.ui.TEXT_ALIGN_CENTER,
		            valign = cc.ui.TEXT_VALIGN_CENTER,
		            --dimensions = cc.size((osWidth-186*2-6*2-20),0) -- height为0，就是自动换行
		        })
		        :align(display.CENTER_BOTTOM, display.cx, gaping_h+66 +30)
		        :addTo(self.pop_window)

	        local function PDKDissRoomDialog_changeSecond()
	        	overtime = overtime - 1
		    	dissRoom_second:setString(""..overtime)
		    	if overtime <= 0 then
		    		if self.top_schedulerID_dissRoom ~= nil then
			        	self.top_scheduler:unscheduleScriptEntry(self.top_schedulerID_dissRoom)
			        	self.top_schedulerID_dissRoom = nil
			        end
		    	end
	        end
	        if self.top_scheduler~=nil then
		        if self.top_schedulerID_dissRoom ~= nil then
		        	self.top_scheduler:unscheduleScriptEntry(self.top_schedulerID_dissRoom)
		        	self.top_schedulerID_dissRoom = nil
		        end
		        self.top_schedulerID_dissRoom = self.top_scheduler:scheduleScriptFunc(PDKDissRoomDialog_changeSecond, 1, false) -- 1秒一次
		    end
	    end

	    if not choose then
	    	dissRoom_cancelBtn:setVisible(true)
	    	dissRoom_submitBtn:setVisible(true)
    	else
	    	dissRoom_cancelBtn:setVisible(false)
	    	dissRoom_submitBtn:setVisible(false)
	    end

	    -- return dissRoom_title, overtime, dissRoom_players_node, 
	    -- 	dissRoom_cancelBtn, dissRoom_submitBtn, top_schedulerID_dissRoom

    end
end


function PDKDissRoomDialog:onExit()
end

function PDKDissRoomDialog:myExit()
end

function PDKDissRoomDialog:dispose()
	if self.top_scheduler~=nil then
		if self.top_schedulerID_dissRoom ~= nil then
		    self.top_scheduler:unscheduleScriptEntry(self.top_schedulerID_dissRoom)
		    self.top_schedulerID_dissRoom = nil
		    self.top_scheduler = nil
		end
	end

	if dissRoom_title then 
		dissRoom_title:removeFromParent()
		dissRoom_title = nil
	end

	if dissRoom_players_node then
	   	dissRoom_players_node:removeFromParent()
	    dissRoom_players_node = nil
	end

	if dissRoom_second then
	    dissRoom_second:removeFromParent()
	    dissRoom_second = nil
	end

	if self.pop_window then
		self.pop_window:removeFromParent()
		self.pop_window = nil
	end
	
end

-- 必须有这个返回
return PDKDissRoomDialog