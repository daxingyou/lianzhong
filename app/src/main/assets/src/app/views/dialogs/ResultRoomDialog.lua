--
-- Author: lte
-- Date: 2016-11-05 18:41:34
-- 房间战绩

-- 类申明
local ResultRoomDialog = class("ResultRoomDialog"
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


function ResultRoomDialog:ctor()
end

-- 创建一个模态弹出框,  parent=要加在哪个上面
function ResultRoomDialog:popDialogBox(_parent)

    self.parent = _parent
    -- self.res_data = _res_data

    self.pop_window = display.newColorLayer(cc.c4b(0, 0, 0, 200))       -- 半透明的黑色

    self.pop_window:setContentSize(osWidth, osHeight)             -- 设置Layer的大小,全屏出现
    --self.pop_window:align(display.CENTER, display.cx, display.cy) -- Layer的锚点在0.5,0.5 因此对齐的时候要注意
    self.pop_window:setTouchEnabled(true)
    self.pop_window:setTouchSwallowEnabled(true)  -- 吞噬下层的响应
    self.pop_window:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event) -- 点击此Layer时候输出信息,然后把自己销毁
        return true
    end)
    self.parent:addChild(self.pop_window, CEnum.ZOrder.common_dialog) -- 把Layer添加到父对象上


    gaping_w = 20
    gaping_h = 20
    gaping_x = 10
    gaping_y = 74


    ---[[
    -- 整个底色背景
    cc.ui.UIImage.new(Imgs.dialog_bg,{})
        :addTo(self.pop_window)
    	-- :align(display.LEFT_TOP, gaping_w, osHeight -gaping_h)
    	-- :setLayoutSize(osWidth -gaping_w*2, osHeight -gaping_h*2)
        :align(display.CENTER, display.cx, display.cy)
        :setLayoutSize(osWidth -gaping_w*2, osHeight -gaping_h*2)
    --]]

    ---[[
    -- 内容背景
    cc.ui.UIImage.new(Imgs.dialog_content_bg,{})
        :addTo(self.pop_window)
        -- :align(display.LEFT_TOP, gaping_w +gaping_x, osHeight -gaping_h -gaping_y)
        -- :setLayoutSize(osWidth -gaping_w*2 -gaping_x*2, osHeight -gaping_h*2  -gaping_y-gaping_x)
        :align(display.CENTER, display.cx, display.cy -gaping_y*0.5)
        :setLayoutSize(osWidth -gaping_w*2 -gaping_x*2, osHeight -gaping_h*2 -gaping_y -gaping_x)
    --]]

    -- logo
    cc.ui.UIImage.new(Imgs.result_title_logo,{})
    --cc.ui.UIPushButton.new(Imgs.result_title_logo, {scale9 = false})
    --    :setButtonImage(EnStatus.pressed, Imgs.result_title_logo)
    --    :setButtonImage(EnStatus.disabled, Imgs.result_title_logo)
    	:addTo(self.pop_window)
    	:align(display.CENTER_TOP, display.cx, osHeight -gaping_h -11)

    ---[[
    -- 关闭 
    -- cc.ui.UIPushButton.new(Imgs.dialog_back,{scale9=false})
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
        -- :setButtonImage(EnStatus.pressed, Imgs.dialog_back)
        :setButtonImage(EnStatus.pressed, Imgs.dialog_exit_press)
        :onButtonClicked(function(e)
            VoiceDealUtil:playSound_other(Voices.file.ui_click)
            self:myCancel()
        end)
    	:addTo(self.pop_window)
        -- :align(display.LEFT_TOP, gaping_w +gaping_x, osHeight -gaping_h -3)
        :align(display.RIGHT_TOP, osWidth -gaping_w -gaping_x, osHeight -gaping_h -11)
    --]]

    local hintText = cc.ui.UILabel.new({
            UILabelType = 2, 
            --image = "",
            text = Strings.gameing.ResultDialogHintTxt, 
            size = Dimens.TextSize_20,
            --color = Colors.black,
            color = Colors:_16ToRGB(Colors.gameing_huxi),
            font = Fonts.Font_hkyt_w9,
            align = cc.ui.TEXT_ALIGN_LEFT,
            valign = cc.ui.TEXT_VALIGN_CENTER,
            --dimensions = cc.size((osWidth-120),0) -- height为0，就是自动换行
            --dimensions = cc.size(200,50)
        })
        :align(display.LEFT_TOP, gaping_w +gaping_x+30, gaping_h +gaping_x+30)
        :addTo(self.pop_window)
    if CVar._static.appstoreSwitch == CEnum.appstoreSwitch.open then
        hintText:setVisible(true)
    else
        hintText:setVisible(false)
    end


	-- view
    -- self:createView2()
	-- self:setViewData2()

    self.loadingPop_window = CDAlertLoading.new():popDialogBox(self.pop_window, Strings.hint_Loading)
    if CEnum.AppVersion.gameAlias == CEnum.gameType.pdk then
        RequestPDKRoomResult:getResultRoom(nil, function(...) self:resDataResultRoom(...) end )
    elseif CEnum.AppVersion.gameAlias == CEnum.gameType.hzmj then
        RequestMJRoomResult:getResultRoom(nil, function(...) self:resDataResultRoom(...) end )
    else
        RequestHome:getResultRoom(nil, function(...) self:resDataResultRoom(...) end )
    end

    -- 有权限的人，才可以看他人回放
    local user = GameStateUserInfo:getData()
    local userRights = nil -- 用户是否拥有房卡
    local RightsTag = false -- 是否有查看他人回放功能
    if user ~= nil then
        userRights = user[User.Bean.rights]
        if userRights ~= nil and Commons:checkIsNull_tableList(userRights) then
            for k,v in pairs(userRights) do
                if v~=nil and v==CEnum.userRightsType.selectOtherPlayback then
                    RightsTag = true
                    break
                end
            end
        end
    end
    if RightsTag then
        -- 增加一个他人回放查看
        self.otherPerson_iv_txt = ""
        -- 回放码输入
        local function otherPerson_iv_function(_value)
            self.otherPerson_iv_txt = _value
            if Commons:checkIsNull_str(_value) then
                self.otherPerson_iv:setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
                            UILabelType = 2,
                            text = _value, --"******",
                            -- text = _value,
                            size = Dimens.TextSize_25,
                            color = Colors.white,
                            -- color = Colors:_16ToRGB(Colors.dissRoom_green),
                            -- color = Colors:_16ToRGB(Colors.result_round_bg2),
                            font = Fonts.Font_hkyt_w7,
                            -- align = cc.ui.TEXT_ALIGN_LEFT,
                            -- valign = cc.ui.TEXT_VALIGN_CENTER,
                         }))
            else
                self.otherPerson_iv:setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
                            UILabelType = 2,
                            text = "请输入回放码",
                            size = Dimens.TextSize_20,
                            -- color = Colors.gray,
                            -- color = Colors:_16ToRGB(Colors.dissRoom_green),
                            color = Colors:_16ToRGB(Colors.result_round_bg2),
                            font = Fonts.Font_hkyt_w7,
                            -- align = cc.ui.TEXT_ALIGN_LEFT,
                            -- valign = cc.ui.TEXT_VALIGN_CENTER,
                         }))
            end
        end
        self.otherPerson_iv = cc.ui.UIPushButton.new(
            Imgs.c_edit_bg,{scale9=true})
            :setButtonSize(140, 45)
            :setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
                UILabelType = 2,
                text = "请输入回放码",
                size = Dimens.TextSize_20,
                -- color = Colors.gray,
                -- color = Colors:_16ToRGB(Colors.dissRoom_green),
                color = Colors:_16ToRGB(Colors.result_round_bg2),
                font = Fonts.Font_hkyt_w7,
                -- align = cc.ui.TEXT_ALIGN_LEFT,
                -- valign = cc.ui.TEXT_VALIGN_CENTER,
             }))
            :setButtonLabelAlignment(display.LEFT_CENTER)
            :setButtonLabelOffset(-60, 0)
            :onButtonClicked(function(e)

                VoiceDealUtil:playSound_other(Voices.file.ui_click)
                KeyboardNumberDialog:popDialogBox(self.pop_window, otherPerson_iv_function)

            end)
            -- :align(display.RIGHT_TOP, osWidth -gaping_w -30 -120, osHeight -gaping_h -11)
            :align(display.LEFT_TOP, gaping_w +30, osHeight -gaping_h -15)
            :addTo(self.pop_window)
        -- 查看
        cc.ui.UIPushButton.new(Imgs.dialog_btn_look,{scale9=false})
                :setButtonImage(EnStatus.pressed, Imgs.dialog_btn_look_press)
                -- :setButtonSize(116, 46)
                :onButtonClicked(function(event)
                    Commons:printLog_Info("查看按钮")
                    if not Commons:checkIsNull_str(self.otherPerson_iv_txt) then
                        CDAlert.new():popDialogBox(self.pop_window, "请输入回放码")
                        return
                    end
                    self:myConfim(self.otherPerson_iv_txt, "y")
                end)
                -- :align(display.RIGHT_TOP, osWidth -gaping_w -30, osHeight -gaping_h -11)
                :align(display.LEFT_TOP, gaping_w +30 +150, osHeight -gaping_h -15)
                :addTo(self.pop_window)
    end

end

function ResultRoomDialog:resDataResultRoom(jsonObj)

    if self.loadingPop_window~=nil and (not tolua.isnull(self.loadingPop_window)) then
        self.loadingPop_window:removeFromParent()
        self.loadingPop_window = nil
    end

    if jsonObj ~= nil then
        local status = jsonObj[ParseBase.status]
        local msg = RequestBase:getStrDecode(jsonObj[ParseBase.msg])
        Commons:printLog_Info("状态是：", status, "内容是：", msg)

        if status ~= nil and status==CEnum.status.success  then
            local _data = jsonObj[ParseBase.data]
            if _data~=nil then
                local rooms = _data[Result.Bean.rooms]
                if Commons:checkIsNull_tableList(rooms) then
                    self.res_data = rooms
                    -- view
                    self:createView2()
                    self:setViewData2()
                else
                    CDAlert.new():popDialogBox(self.parent, Strings.gameing.noData_resultRoom)
                    -- self:myCancel()
                end
            else
                CDAlert.new():popDialogBox(self.parent, Strings.gameing.noData_resultRoom)
                -- self:myCancel()
            end
        else
            CDAlert.new():popDialogBox(self.parent, Strings.gameing.noData_resultRoom)
            -- self:myCancel()
        end
    end
end

function ResultRoomDialog:myCancel()
    self:myExit()
end

function ResultRoomDialog:myConfim(roomNo, fromOther)
    ResultRoundDialog:popDialogBox(self.pop_window, roomNo, fromOther)
    -- ResultRoundDialog:new(roomNo, fromOther):addTo(self.pop_window, CEnum.ZOrder.common_dialog)
end

local item_w
local item_h
function ResultRoomDialog:createView2()
    item_w = osWidth -gaping_w*2 -gaping_x*4
    item_h = (osHeight -gaping_h*2 -gaping_y -10-35)/3
    item_h = item_h-item_h%1 -- 取整

    -- 层
    -- winOrOwner_view_layer = display.newLayer() -- .newColorLayer(Colors.layer_bg)
    --     :setContentSize(600,508)
    --     :align(display.LEFT_TOP, 14+30, osHeight-14 -40 -38)
    --     :addTo(self.pop_window)
    --winOrOwner_view_layer = display.newNode():addTo(self.pop_window);

    -- 组合
    self.view_hu_list = cc.ui.UIListView.new({
            --bg = Imgs.c_default_img,
            --bgStartColor = cc.c4b(255,64,64,150),
            --bgEndColor = cc.c4b(0,0,0,150),
            bgColor = cc.c4b(200, 200, 200, 0),
            --bgColor = Colors.btn_bg,
            bgScale9 = false,
            --capInsets = cc.rect(0, 0, 706, 73*4),
            viewRect = cc.rect(0, 0, item_w, item_h*3),
            direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
            --direction = cc.ui.UIScrollView.DIRECTION_HORIZONTAL,
            --alignment = cc.ui.UIListView.ALIGNMENT_VCENTER
            --scrollbarImgH = Imgs.c_default_img
            --scrollbarImgV = Imgs.c_default_img
        })
        :addTo(self.pop_window)
        :align(display.LEFT_TOP, gaping_w +gaping_x*2, gaping_h +gaping_x*2 +22)
end

-- 三个玩家的数据都显示出来
function ResultRoomDialog:setViewData2()
    if self.res_data ~= nil then
        Commons:printLog_Info("宽",item_w)
        Commons:printLog_Info("高",item_h)
        self.view_hu_list:removeAllItems()

        for k,v in pairs(self.res_data) do
            local roomNo = v[Result.Bean.roomNo] .. "号房间"
            local startTime = "对战时间:" .. v[Result.Bean.startTime]
            local players = v[Result.Bean.players]

            local item = self.view_hu_list:newItem()

            -- 背景
            local content = 
                -- cc.LayerColor:create(cc.c4b(math.random(255),math.random(255),math.random(255),255))
                cc.ui.UIImage.new(Imgs.result_item_bg,{scale9 = true})
                    --cc.ui.UIPushButton.new(Imgs.result_item_bg,{scale9=false}):setButtonSize(item_w, item_h-40)
                    :setContentSize(item_w, item_h-10) --设置大小
                -- :setLayoutSize(item_w, item_h-40)
            -- local ww = item_w -- content:getContentSize().width
            -- local hh = item_h -- content:getContentSize().height

            -- 序号
            display.newTTFLabel({
                    text = k,
                    font = Fonts.Font_hkyt_w9,
                    size = Dimens.TextSize_30,
                    color = Colors:_16ToRGB(Colors.gameing_huxi),
                    align = cc.ui.TEXT_ALIGN_CENTER,
                    valign = cc.ui.TEXT_VALIGN_CENTER,
                    --dimensions = cc.size(100,20)
                })
                :addTo(content)
                :align(display.LEFT_TOP, 40, item_h-20)

            -- 房号
            display.newTTFLabel({
                    text = roomNo,
                    font = Fonts.Font_hkyt_w9,
                    size = Dimens.TextSize_30,
                    color = Colors:_16ToRGB(Colors.gameing_huxi),
                    align = cc.ui.TEXT_ALIGN_CENTER,
                    valign = cc.ui.TEXT_VALIGN_CENTER,
                    --dimensions = cc.size(100,20)
                })
                :addTo(content)
                :align(display.LEFT_TOP, 40 +62, item_h-20)

            -- 开始时间
            display.newTTFLabel({
                    text = startTime,
                    font = Fonts.Font_hkyt_w9,
                    size = Dimens.TextSize_30,
                    color = Colors:_16ToRGB(Colors.gameing_huxi),
                    align = cc.ui.TEXT_ALIGN_CENTER,
                    valign = cc.ui.TEXT_VALIGN_CENTER,
                    --dimensions = cc.size(100,20)
                })
                :addTo(content)
                :align(display.RIGHT_TOP, item_w-20, item_h-20)

            -- 三个人的信息
            local wwContent = item_w/3-15 -- 15是间距
            if CEnum.AppVersion.gameAlias == CEnum.gameType.hzmj then
                wwContent = item_w/4-15
            end
            local hhContent = item_h-68 -- 68 是序号和对战时间的高度

            -- 昵称和分数
            local userContent = cc.ui.UIImage.new(Imgs.result_item_content_bg,{scale9 = true})
                :addTo(content)
                :align(display.LEFT_TOP, 10 +wwContent*0, hhContent+10)
                :setLayoutSize(wwContent, hhContent) --设置大小

            local userContent2 = cc.ui.UIImage.new(Imgs.result_item_content_bg,{scale9 = true})
                :addTo(content)
                :align(display.LEFT_TOP, 10 +wwContent*1+10, hhContent+10)
                :setLayoutSize(wwContent, hhContent) --设置大小

            local userContent3 = cc.ui.UIImage.new(Imgs.result_item_content_bg,{scale9 = true})
                :addTo(content)
                :align(display.LEFT_TOP, 10 +wwContent*2+10*2, hhContent+10)
                :setLayoutSize(wwContent, hhContent) --设置大小

            local userContent4 = nil
            if CEnum.AppVersion.gameAlias == CEnum.gameType.hzmj then
                userContent4 = cc.ui.UIImage.new(Imgs.result_item_content_bg,{scale9 = true})
                    :addTo(content)
                    :align(display.LEFT_TOP, 10 +wwContent*3+10*3, hhContent+10)
                    :setLayoutSize(wwContent, hhContent) --设置大小
            end

            -- 三个人
            if Commons:checkIsNull_tableList(players) then
                if #players == 3 then
                    if userContent4 and not tolua.isnull(userContent4) then
                        userContent4:hide()
                    end
                elseif #players == 2 then
                    if userContent3 and not tolua.isnull(userContent3) then
                        userContent3:hide()
                    end
                    if userContent4 and not tolua.isnull(userContent4) then
                        userContent4:hide()
                    end
                end

                for kk,vv in pairs(players) do

                    local user = vv[Player.Bean.user]
                    if user ~= nil then

                        local fontSize = Dimens.TextSize_35
                        local dimenW = 240
                        if CVar._static.isIphone4 then
                        elseif CVar._static.isIpad then
                            fontSize = Dimens.TextSize_30
                            dimenW = 200
                        end

                        local nickname = RequestBase:getStrDecode(user[User.Bean.nickname] )
                        --Commons:printLog_Info("昵称是",nickname)
                        local nickView = display.newTTFLabel({
                                text = nickname,
                                font = Fonts.Font_hkyt_w9,
                                size = fontSize,
                                color = Colors:_16ToRGB(Colors.gameing_huxi),
                                align = cc.ui.TEXT_ALIGN_CENTER,
                                valign = cc.ui.TEXT_VALIGN_CENTER,
                                dimensions = cc.size(dimenW,40)
                            })
                            :align(display.CENTER, wwContent/2-10, hhContent-30)

                        if kk==1 then
                            nickView:addTo(userContent)
                        elseif kk ==2 then
                            nickView:addTo(userContent2)
                        elseif kk ==3 then
                            nickView:addTo(userContent3) 
                        elseif kk ==4 then
                            if userContent4 and not tolua.isnull(userContent4) then
                                nickView:addTo(userContent4) 
                            end  
                        end
                    end

                    local score = vv[Player.Bean.score]
                    --Commons:printLog_Info("分数是",score)
                    if Commons:checkIsNull_numberType(score) then
                        local _string = tostring(score)
                        local _size = string.len(_string)
                        for i=1,_size do
                            local i_str = string.sub(_string, i, i)
                            local img_i = GameingDealUtil:getNumImg_by_scoreResult(i_str)
                            local scoreView = cc.ui.UIImage.new(img_i,{scale9=false})
                            --local scoreView = cc.ui.UIPushButton.new(img_i,{scale9=false})
                            --  :setButtonSize(30, 34)
                                :setLayoutSize(30, 30)
                                --:align(display.CENTER, wwContent/2 +(27*(i-1)), 35) -- 居zuo的做法
                                :align(display.CENTER, wwContent/2 +(-27*_size/2)+(27*(i-1)), 35) -- 居中的做法

                            if kk==1 then
                                scoreView:addTo(userContent)
                            elseif kk ==2 then
                                scoreView:addTo(userContent2)
                            elseif kk ==3 then
                                scoreView:addTo(userContent3)   
                            elseif kk ==4 then
                                if userContent4 and not tolua.isnull(userContent4) then
                                    scoreView:addTo(userContent4)  
                                end 
                            end
                        end
                    end
                end
            end

            item:addContent(content)
            item:setItemSize(item_w, item_h)
            self.view_hu_list:addItem(item) -- 添加item到列表
            --self.view_hu_list:addScrollNode(content)
        end
        self.view_hu_list:onTouch(function(...) self:touchListener_listview(...) end)
        self.view_hu_list:reload() -- 重新加载
    end
end

function ResultRoomDialog:touchListener(event)
	--dump(event, "pageView - event:")
	--Commons:printLog_Info("pageView - event:")
	--Commons:printfLog_Info("touchListener: name=%s x,y: %0.2f, %0.2f", event.name, event.x, event.y)

	--local listView = event.pageView
	--local item = event.item
	local position = event.itemIdx
	local event_name = event.name
	--dump(item)

	if EnStatus.clicked == event_name then
		local v = self.res_data[position]
		local roomNo = v[Result.Bean.roomNo]
		Commons:printLog_Info("点击的房间号是：",roomNo)

		self:myConfim(roomNo)

		-- if 100 == position then
		-- 	listView:removeItem(item, true) --移除item,带移除动画
		-- else
		-- 	local w, _ = item:getItemSize()
		-- 	if 60 == w then   --修改item大小 来演示效果
		-- 		item:setItemSize(100, 73*3.5)
		-- 	else
		-- 		item:setItemSize(60, 73*3.5)
		-- 	end
		-- end
	end
end

function ResultRoomDialog:touchListener_listview(event)
    --dump(event, "pageView - event:")
    --Commons:printLog_Info("pageView - event:")
    --Commons:printfLog_Info("touchListener: name=%s x,y: %0.2f, %0.2f", event.name, event.x, event.y)

    --local listView = event.pageView
    --local item = event.item
    local position = event.itemPos
    local event_name = event.name
    --dump(item)

    if EnStatus.clicked == event_name then
        VoiceDealUtil:playSound_other(Voices.file.ui_click)
        
        local v = self.res_data[position]
        local roomNo = v[Result.Bean.roomNo]
        Commons:printLog_Info("点击的房间号是：",roomNo)

        self:myConfim(roomNo)

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
end

function ResultRoomDialog:onExit()
    self:myExit()
end

function ResultRoomDialog:myExit()
    self.res_data = nil
    self.view_hu_list = nil
    if self.pop_window and not tolua.isnull(self.pop_window) then
        self.pop_window:removeFromParent()
        self.pop_window = nil
    end
end

return ResultRoomDialog