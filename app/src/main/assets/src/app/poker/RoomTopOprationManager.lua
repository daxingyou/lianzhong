--[
--  Author wh
--  Date: 2017-05-08 19:40:54
--	顶部操作区
--]

local RoomSeat = import(".view.RoomSeat")

local RoomTopOprationManager = class("RoomTopOprationManager")

local osWidth = Commons.osWidth
local osHeight = Commons.osHeight

function RoomTopOprationManager:ctor(_fromView)
    self.fromView = _fromView
end

function RoomTopOprationManager:createNodes()
	if self.nodes_ and self.nodes_:getParent() then
		self.nodes_:removeFromParentAndCleanup(true)
		self.nodes_ = nil
	end

	--创建一个顶部操作节点
	self.nodes_ = display.newNode()
		:addTo(self.ctx.scene)

	-- 顶部背景
    cc.ui.UIImage.new(PDKImgs.room_top_bg,{})
        :addTo(self.nodes_)
        :align(display.CENTER, display.cx, osHeight-90/2+3)
    
	-- 当前时间显示
    local myDate = os.date("%H:%M") -- "%Y-%m-%d %H:%M:%S"
    self.myDate_label = display.newTTFLabel({--cc.ui.UILabel.new({
	        --UILabelType = 2,
	        text = myDate,
	        size = Dimens.TextSize_30,
            color = Colors:_16ToRGB(Colors.gameing_time),
	        font = Fonts.Font_hkyt_w7,
	        align = cc.ui.TEXT_ALIGN_CENTER,
	        valign = cc.ui.TEXT_VALIGN_CENTER,
            dimensions = cc.size(120, 0)
     	})
        :addTo(self.nodes_)
        :align(display.LEFT_TOP, 440-30, osHeight-32 +10) -- 最左边
    if CVar._static.isIphone4 then
        self.myDate_label:align(display.LEFT_TOP, 440-30 -100, osHeight-32 +10)
    elseif CVar._static.isIpad then
        self.myDate_label:align(display.LEFT_TOP, 440-30 -150, osHeight-32 +10)
    elseif CVar._static.NavBarH_Android ~= CEnum.status.NavBarH_def then
        self.myDate_label:align(display.LEFT_TOP, 440-30 -CVar._static.NavBarH_Android/2, osHeight-32 +10) -- 最左边
    end

    local function changeTime()
    	myDate = os.date("%H:%M") -- "%H:%M:%S"
    	self.myDate_label:setString(myDate)
    end
    self.top_scheduler = self.nodes_:getScheduler();
    self.top_schedulerID = self.top_scheduler:scheduleScriptFunc(changeTime, 60, false) -- 1分钟一次

    -- 设置
	local top_view_setting = cc.ui.UIPushButton.new(
    	Imgs.gameing_top_setting,{scale9=false})
        
        :setButtonImage(EnStatus.pressed, Imgs.gameing_top_setting)
        :onButtonClicked(function(e)
        
            VoiceDealUtil:playSound_other(Voices.file.ui_click)
            SettingDialog:popDialogBox(self.ctx.scene, CEnum.pageView.gameingOverPage)
            
        end)
        :align(display.LEFT_TOP, osWidth-480+30, osHeight-22 +15)
        :addTo(self.nodes_)
    if CVar._static.isIphone4 then
        top_view_setting:align(display.LEFT_TOP, osWidth-480+30 +100, osHeight-22 +15)
    elseif CVar._static.isIpad then
        top_view_setting:align(display.LEFT_TOP, osWidth-480+30 +150, osHeight-22 +15)
    elseif CVar._static.NavBarH_Android ~= CEnum.status.NavBarH_def then
        top_view_setting:align(display.LEFT_TOP, osWidth-480+30 +CVar._static.NavBarH_Android/2, osHeight-22 +15)
    end

    -- 解散房间
    self.top_view_dissRoom = cc.ui.UIPushButton.new(
    	Imgs.gameing_top_dismiss_room,{scale9=false})
        :setButtonImage(EnStatus.pressed, Imgs.gameing_top_dismiss_room)
        :onButtonClicked(function(e)
             VoiceDealUtil:playSound_other(Voices.file.ui_click)

            -- --解散房间请求
            -- --SocketRequestGameing:dissRoom()
            -- --CDAlert.new():popDialogBox(Layer1, "解散房间请求已经发送,等待其他玩家确认。");
            CDialog.new():popDialogBox(self.ctx.scene, 
                nil, Strings.gameing.dissRoomConfim, 
                function() self.roomController:sendDissRoom()  end, 
                function()  end )
        end)
        :align(display.RIGHT_TOP, osWidth-490+30, osHeight-22 +15)
        :addTo(self.nodes_)
    if CVar._static.isIphone4 then
        self.top_view_dissRoom:align(display.RIGHT_TOP, osWidth-490+30 +100, osHeight-22 +15)
    elseif CVar._static.isIpad then
        self.top_view_dissRoom:align(display.RIGHT_TOP, osWidth-490+30 +150, osHeight-22 +15)
    elseif CVar._static.NavBarH_Android ~= CEnum.status.NavBarH_def then
        self.top_view_dissRoom:align(display.RIGHT_TOP, osWidth-490+30 +CVar._static.NavBarH_Android/2, osHeight-22 +15)
    end

    --返回房间
    self.top_view_backRoom = cc.ui.UIPushButton.new(
        Imgs.gameing_top_btn_back2,{scale9=false})
        :setButtonImage(EnStatus.pressed, Imgs.gameing_top_btn_back2)
        :onButtonClicked(function(e)
            VoiceDealUtil:playSound_other(Voices.file.ui_click)
            CDialog.new():popDialogBox(self.ctx.scene, 
                CDialog.title_logo.backHome, Strings.gameing.outRoomConfim, 
                function() self.roomController:sendLoginOut() end, 
                function()  end)
        end)
        :align(display.RIGHT_TOP, osWidth-490+30, osHeight-22 +15)
        :addTo(self.nodes_)
        :setVisible(false)
    if CVar._static.isIphone4 then
        self.top_view_backRoom:align(display.RIGHT_TOP, osWidth-490+30 +100, osHeight-22 +15)
    elseif CVar._static.isIpad then
        self.top_view_backRoom:align(display.RIGHT_TOP, osWidth-490+30 +150, osHeight-22 +15)
    elseif CVar._static.NavBarH_Android ~= CEnum.status.NavBarH_def then
        self.top_view_backRoom:align(display.RIGHT_TOP, osWidth-490+30 +CVar._static.NavBarH_Android/2, osHeight-22 +15)
    end

    -- gprs定位信息显示按钮
    self.top_view_gprsBtn = cc.ui.UIPushButton.new(
        Imgs.g_th_green,{scale9=false})
        --:setButtonSize(72, 100)
        -- :setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
        --  UILabelType = 2,
        --  text = "",
        --     size = Dimens.TextSize_30,
        --  color = Colors.btn_normal,
        --  }))
        -- :setButtonLabel(EnStatus.pressed, cc.ui.UILabel.new({
        --  UILabelType = 2,
        --  text = "",
        --  size = Dimens.TextSize_30,
        --  color = Colors.btn_press,
        --  }))
        --:setButtonImage(EnStatus.disabled, Imgs.gameing_user_prepare_ok)
        :setButtonImage(EnStatus.pressed, Imgs.g_th_green)
        :onButtonClicked(function(e)

            VoiceDealUtil:playSound_other(Voices.file.ui_click)
            -- 点开就是具体的信息
            self.PopGprsDialog = CDAlertGprs:popDialogBox(self.ctx.scene, self.GprsBean)

        end)
        :align(display.CENTER, 300+100, osHeight-40)
        -- :addTo(myself_view)
        -- 调整到层级最高，就需要第一次处于隐藏状态
        :addTo(self.nodes_)
        :hide()
    if CVar._static.isIphone4 then
        self.top_view_gprsBtn:align(display.CENTER, 300+100 -100, osHeight-40)
    elseif CVar._static.isIpad then
        self.top_view_gprsBtn:align(display.CENTER, 300+100 -150, osHeight-40)
    elseif CVar._static.NavBarH_Android ~= CEnum.status.NavBarH_def then
        self.top_view_gprsBtn:align(display.CENTER, 300+100 -CVar._static.NavBarH_Android/2, osHeight-40) -- 最左边
    end

    -- 房间号，第几局信息
    local roomno_view = cc.ui.UIImage.new(Imgs.gameing_top_roomtitle)
        :addTo(self.nodes_)
        :align(display.LEFT_TOP, 565, osHeight-15 +7)
    if CVar._static.isIphone4 then
        roomno_view:align(display.LEFT_TOP, 565 -100, osHeight-15 +7)
    elseif CVar._static.isIpad then
        roomno_view:align(display.LEFT_TOP, 565 -150, osHeight-15 +7)
    elseif CVar._static.NavBarH_Android ~= CEnum.status.NavBarH_def then
        roomno_view:align(display.LEFT_TOP, 565 -CVar._static.NavBarH_Android/2, osHeight-15 +7)
    end

    -- self:setRoomId(234153)
    -- self:setTable(3,10)
end

--游戏初始化进入，房主显示解散按钮，非房主为返回大厅按钮
function RoomTopOprationManager:init(roomData)
    if self.model:isSelfOwner() then
        self.top_view_dissRoom:setVisible(true)
        self.top_view_backRoom:setVisible(false)
    else
        self.top_view_dissRoom:setVisible(false)
        self.top_view_backRoom:setVisible(true)
    end

    if roomData.playType == nil then return end

    --设置房间信息
    local infoNode = display.newNode()
        :addTo(self.nodes_)
        :align(display.CENTER, display.cx, osHeight-210/2)

    -- 失联的提示文字
    self.topRule_view_noConnectServer = display.newTTFLabel({--cc.ui.UILabel.new({
            --UILabelType = 2,
            text = Strings.gameing.noConnectServer,
            size = Dimens.TextSize_25,
            --color = Colors:_16ToRGB(Colors.gameing_jiadi_color),
            color = cc.c3b(23,23,24),
            --color = Colors.white,
            font = Fonts.Font_hkyt_w7,
            align = cc.ui.TEXT_ALIGN_CENTER,
            valign = cc.ui.TEXT_VALIGN_CENTER,
            --dimensions = cc.size(306, 96)
        })
        :addTo(self.nodes_)
        :align(display.CENTER, display.cx, display.cy-35)
        :setVisible(false)

    --玩法
    local wf_node;
    if roomData.playType == CEnumP.wf._1 then --"16" then
        wf_node = display.newSprite(PDKImgs.room_top_slz)
    elseif roomData.playType == CEnumP.wf._2 then --"15" then
        wf_node = display.newSprite(PDKImgs.room_top_swz)
    else
        wf_node = display.newSprite(PDKImgs.room_top_sj)
    end
    wf_node:addTo(infoNode)
        :pos(-180,0)
    local pre_size = wf_node:getContentSize()

    --规则(3张全带,任意带)
    -- dump(roomData,"房间的数据==")
    local rule_node;
    if roomData.lastRule == CEnumP.leftHand._1 then --"limit" then
        rule_node = display.newSprite(PDKImgs.room_top_3zqd)
    else
        rule_node = display.newSprite(PDKImgs.room_top_3zryd)
    end
    local selfSzie = rule_node:getContentSize()

    local pos_x = -180+pre_size.width/2+selfSzie.width/2+20
    local pre_pos_x = pos_x
    rule_node:addTo(infoNode)
        :pos(pos_x,0)

    --扎鸟吗
    local birdNode;
    if roomData.birdRule == CEnumP.zhaNiao._1 then --"n" then
        birdNode = display.newSprite(PDKImgs.room_top_bzn)
    else
        birdNode = display.newSprite(PDKImgs.room_top_htszn)
    end
    birdNode:addTo(infoNode)

    pre_size = rule_node:getContentSize()
    selfSzie = birdNode:getContentSize()
    pos_x = pre_pos_x + pre_size.width/2 + selfSzie.width/2 +20
    pre_pos_x = pos_x
    birdNode:pos(pos_x,0)

    --[[
    --谁付钱啊
    local payNode;
    if roomData.payRule == "aa" then
        payNode = display.newSprite(PDKImgs.room_top_aa_pay)
    else
        payNode = display.newSprite(PDKImgs.room_top_fzf)
    end
    payNode:addTo(infoNode)

    pre_size = birdNode:getContentSize()
    selfSzie = payNode:getContentSize()
    pos_x = pre_pos_x + pre_size.width/2 + selfSzie.width/2 +20
    pre_pos_x = pos_x
    payNode:pos(pos_x,0)
    --]]

end

--游戏开始后，所有玩家显示解散房间按钮
function RoomTopOprationManager:gameStart()
    self.top_view_dissRoom:setVisible(true)
    self.top_view_backRoom:setVisible(false)
end

-- 游戏开始后，显示房号  数字显示
function RoomTopOprationManager:setRoomId(roomId)

    if self.top_view_roomNo then
        self.top_view_roomNo:removeFromParent()
        self.top_view_roomNo = nil
    end
   
    self.top_view_roomNo = display.newNode():addTo(self.nodes_);
    local moveX = 0
    if CVar._static.isIphone4 then
        self.top_view_roomNo:pos(-95,0)
    elseif CVar._static.isIpad then
        self.top_view_roomNo:pos(-155,0)
    elseif CVar._static.NavBarH_Android ~= CEnum.status.NavBarH_def then
        moveX = -CVar._static.NavBarH_Android/2
    end

    _string = tostring(roomId)
    _size = string.len(_string)
    for i=1,_size do
        local i_str = string.sub(_string, i, i)
        local img_i = GameingDealUtil:getNumImg_by_roomno(i_str)
        cc.ui.UIImage.new(img_i,{scale9=false})
        :addTo(self.top_view_roomNo)
        :align(display.LEFT_TOP, 484+135 +0+14*(i-1) +0 + moveX, osHeight-22 +7)
    end
end

-- 游戏开始后，显示第几局  数字
function RoomTopOprationManager:setTable(TurnTable,totalTable)

    if self.top_view_ju then
        self.top_view_ju:removeFromParent()
        self.top_view_ju = nil
    end
    self.top_view_ju = display.newNode():addTo(self.nodes_);

    local moveX = 0
    if CVar._static.isIphone4 then
        self.top_view_ju:pos(-100,0)
    elseif CVar._static.isIpad then
        self.top_view_ju:pos(-160,0)
    elseif CVar._static.NavBarH_Android ~= CEnum.status.NavBarH_def then
        moveX = -CVar._static.NavBarH_Android/2
    end
    
        -- 第字
        cc.ui.UIImage.new(Imgs.over_nums_roundno_di,{scale9=false})
                :addTo(self.top_view_ju)
                :align(display.LEFT_TOP, 484+110 +moveX, osHeight-15-34 +3)

        -- 数字
        _string = tostring(TurnTable)
        _size = string.len(_string)
        for i=1,_size do
            local i_str = string.sub(_string, i, i)
            local img_i = GameingDealUtil:getNumImg_by_roundno(i_str)
            cc.ui.UIImage.new(img_i,{scale9=false})
                :addTo(self.top_view_ju)
                :align(display.LEFT_TOP, 484+135 +0+12*(i-1) +moveX, osHeight-15-34 +3)
        end

        -- /字
        cc.ui.UIImage.new(Imgs.over_nums_roundno_gang,{scale9=false})
                :addTo(self.top_view_ju)
                :align(display.LEFT_TOP, 484+135 +0+12*_size +2 +moveX, osHeight-15-34 +1)

        -- 数字
        _string = tostring(totalTable)
        _size2 = string.len(_string)
        for i=1,_size2 do
            local i_str = string.sub(_string, i, i)
            local img_i = GameingDealUtil:getNumImg_by_roundno(i_str)
            cc.ui.UIImage.new(img_i,{scale9=false})
                :addTo(self.top_view_ju)
                :align(display.LEFT_TOP, 484+135 +0+12*_size +14 +0+12*(i-1) +moveX, osHeight-15-34 +3)
        end

        -- 局字
        cc.ui.UIImage.new(Imgs.over_nums_roundno_ju,{scale9=false})
                :addTo(self.top_view_ju)
                :align(display.LEFT_TOP, 484+135 +0+12*_size +12 +0+12*_size2 +5 +moveX, osHeight-15-34 +3)
end

--设置游戏的开始时间
--用于游戏回放功能    在普通牌局中该function将不会调用。
function RoomTopOprationManager:setStartTime(time)
    local moveX_myDate = 0  
    local moveY_myDate = 0  
    if self.fromView and self.fromView==CEnum.pageView.mirrorPdkPage then
        moveX_myDate = 15
        moveY_myDate = 10
    end

    self.top_scheduler:unscheduleScriptEntry(self.top_schedulerID)
    self.myDate_label:setString(""..time)
    self.myDate_label:align(display.LEFT_TOP, 440+40 -80 +moveX_myDate, osHeight-32 +10 +moveY_myDate) -- 最左边

    if CVar._static.isIphone4 then
        self.myDate_label:align(display.LEFT_TOP, 440+40 -100 -80 +moveX_myDate, osHeight-32 +10 +moveY_myDate)
    elseif CVar._static.isIpad then
        self.myDate_label:align(display.LEFT_TOP, 440+40 -150 -80 +moveX_myDate, osHeight-32 +10 +moveY_myDate)
    elseif CVar._static.NavBarH_Android ~= CEnum.status.NavBarH_def then
        self.myDate_label:align(display.LEFT_TOP, 440+40 -CVar._static.NavBarH_Android/2 -80 +moveX_myDate, osHeight-32 +10 +moveY_myDate) -- 最左边
    end
end

-- -- 定位信息的处理
-- function RoomTopOprationManager:setGprs_ViewData(model, user_icon, user_nickname, user_icon_R, user_nickname_R, user_icon_L, user_nickname_L)
--     -- print("*2222***********************", user_icon, user_nickname, user_icon_R, user_nickname_R, user_icon_L, user_nickname_L)
--     -- gprs信息
--     local room = model:getRoomInfo()
--     if self.GprsBean == nil and room~=nil then

--         local distanceType = room[Room.Bean.distanceType]
--         if distanceType~=nil and self.top_view_gprsBtn~=nil and not tolua.isnull(self.top_view_gprsBtn) then
--             self.top_view_gprsBtn:show()
--             if distanceType==0 then
--                 self.top_view_gprsBtn:setButtonImage(EnStatus.normal, Imgs.g_th_green)
--                 self.top_view_gprsBtn:setButtonImage(EnStatus.pressed, Imgs.g_th_green)
--             elseif distanceType==1 then
--                 self.top_view_gprsBtn:setButtonImage(EnStatus.normal, Imgs.g_th_yellow)
--                 self.top_view_gprsBtn:setButtonImage(EnStatus.pressed, Imgs.g_th_yellow)
--             elseif distanceType==2 then
--                 self.top_view_gprsBtn:setButtonImage(EnStatus.normal, Imgs.g_th_red)
--                 self.top_view_gprsBtn:setButtonImage(EnStatus.pressed, Imgs.g_th_red)
--             end
--         else
--             -- if self.top_view_gprsBtn~=nil and not tolua.isnull(self.top_view_gprsBtn) then
--             --     self.top_view_gprsBtn:hide()
--             -- end
--         end

--         self.GprsBean = room[Room.Bean.distanceDesc]

--         --self.user_icon, self.user_nickname, self.user_icon_R, self.user_nickname_R, self.user_icon_L, self.user_nickname_L, self.GprsBean

--         -- self.user_icon = user_icon
--         -- self.user_nickname = user_nickname

--         -- self.user_icon_R = user_icon_R
--         -- self.user_nickname_R = user_nickname_R

--         -- self.user_icon_L = user_icon_L
--         -- self.user_nickname_L = user_nickname_L

--         local user = {
--             icon = user_icon,
--             nickname = user_nickname
--         }
--         local nextUser = {
--             icon = user_icon_R,
--             nickname = user_nickname_R
--         }
--         local preUser = {
--             icon = user_icon_L,
--             nickname = user_nickname_L
--         }
--         -- table.insert(self.GprsBean, user) 
--         -- table.insert(self.GprsBean, nextUser) 
--         -- table.insert(self.GprsBean, preUser)
--         self.GprsBean[Gprs.Bean.user] = user
--         self.GprsBean[Gprs.Bean.nextUser] = nextUser
--         self.GprsBean[Gprs.Bean.preUser] = preUser
--     end
-- end

-- 定位信息的处理
function RoomTopOprationManager:players_gprs_setViewData(res_data)
    if res_data ~= nil then
        local room = res_data--[User.Bean.room]

        -- 是否弹窗，是否显示gprs按钮
        local isShow = room[Room.Bean.isShow]
        local popDesc = room[Room.Bean.popDesc]
        local distanceType = room[Room.Bean.distanceType]
        local distanceA = room[Gprs.Bean.distanceA]

        if isShow == 'y' then
            if self.PopGprsDialog and not tolua.isnull(self.PopGprsDialog) then
                self.PopGprsDialog:removeFromParent()
            end
            if self.serverGprsIpCheckDialog and not tolua.isnull(self.serverGprsIpCheckDialog) then
                self.serverGprsIpCheckDialog:removeFromParent()
            end
            self.serverGprsIpCheckDialog = PDKServerIpCheckDialogNew.new(res_data):addTo(self.ctx.scene, CEnum.ZOrder.gameingView_myself_voice)
        end

        if distanceType~=nil and self.top_view_gprsBtn~=nil and not tolua.isnull(self.top_view_gprsBtn) then
            if distanceType==0 then
                self.top_view_gprsBtn:setButtonImage(EnStatus.normal, Imgs.g_th_green)
                self.top_view_gprsBtn:setButtonImage(EnStatus.pressed, Imgs.g_th_green)
            elseif distanceType==1 then
                self.top_view_gprsBtn:setButtonImage(EnStatus.normal, Imgs.g_th_yellow)
                self.top_view_gprsBtn:setButtonImage(EnStatus.pressed, Imgs.g_th_yellow)
            elseif distanceType==2 then
                self.top_view_gprsBtn:setButtonImage(EnStatus.normal, Imgs.g_th_red)
                self.top_view_gprsBtn:setButtonImage(EnStatus.pressed, Imgs.g_th_red)
            end
            self.top_view_gprsBtn:show()
        else
            -- if self.top_view_gprsBtn~=nil and not tolua.isnull(self.top_view_gprsBtn) then
            --     self.top_view_gprsBtn:hide()
            -- end
        end

        -- gprs信息
        self.GprsBean = room[Room.Bean.playerDistance]
        if self.PopGprsDialog and not tolua.isnull(self.PopGprsDialog) then
            self.PopGprsDialog:removeFromParent()
            self.PopGprsDialog = CDAlertGprs:popDialogBox(self.ctx.scene, self.GprsBean)
        end
    end
end

-- 退出操作
function RoomTopOprationManager:dispose()
	self.top_scheduler:unscheduleScriptEntry(self.top_schedulerID)
end

return RoomTopOprationManager