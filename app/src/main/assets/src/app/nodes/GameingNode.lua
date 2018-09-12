--
-- Author: lte
-- Date: 2016-10-31 12:05:34
--

-- 类申明
-- local GameingNode = class("GameingNode", function ()
--     return display.newNode();
-- end)
local GameingNode = class("GameingNode")


local osWidth = Commons.osWidth;
local osHeight = Commons.osHeight;


			--     -- --调用视频接口
            --     --     local videoPlayer = ccexp.VideoPlayer:create()
            --     -- --载入视频文件
            --     --     videoPlayer:setFileName(voiceLocalUrl)
            --     --     videoPlayer:setPosition(display.cx, display.cy)
            --     --     --播放视频时是否始终保持款高比
            --     --     videoPlayer:setKeepAspectRatioEnabled(false)
            --     --     --是否全屏
            --     --     videoPlayer:setFullScreenEnabled(true)
            --     --     --开始播放
            --     --     videoPlayer:play()
            --     --     Layer1:addChild(videoPlayer, 9999)
            --     -- --回调监听
            --     --     videoPlayer:addEventListener(function(videoPlayer, eventType) 
            --     --         if eventType == ccexp.VideoPlayerEvent.PLAYING then
            --     --             --log("PLAYING")
            --     --         elseif eventType == ccexp.VideoPlayerEvent.PAUSED then
            --     --             --log("PAUSED")
            --     --         elseif eventType == ccexp.VideoPlayerEvent.STOPPED then
            --     --             --log("STOPPED")
            --     --         elseif eventType == ccexp.VideoPlayerEvent.COMPLETED then
            --     --         --播放完成时处理回调
            --     --             --log("COMPLETED")
            --     --             --先停止播放再延迟一段时间销毁视频。
            --     --             --若直接销毁会出现冲突问题。
            --     --             videoPlayer:stop()
            --     --             -- self:runAction(cc.Sequence:create(
            --     --             --     cc.DelayTime:create(0.01),
            --     --             --     cc.CallFunc:create(function() 
            --     --             --         self:removeChild(videoPlayer)
            --     --             --         self:doComplete()
            --     --             --     end)
            --     --             -- ))      
            --     --         end
            --     --     end)


function GameingScene_touchListener(event)
	local listView = event.listView
	local event_name = event.name
	local position = event.itemPos
	local item = event.item

	dump(event, "ListView - event:")
	--Commons:printLog_Info("ListView - event:")
	--Commons:printfLog_Info("touchListener: name=%s x,y: %0.2f, %0.2f", event.name, event.x, event.y)

	-- if "clicked" == event_name then
	-- 	if 100 == position then
	-- 		listView:removeItem(item, true) --移除item,带移除动画
	-- 	else
	-- 		local w, _ = item:getItemSize()
	-- 		if 60 == w then   --修改item大小 来演示效果
	-- 			item:setItemSize(100, 73*3.5)
	-- 		else
	-- 			item:setItemSize(60, 73*3.5)
	-- 		end
	-- 	end
	-- end
end

-- 如何摆放 一个listview
function GameingScene:myself_handCard_createView1(Layer1)

	function touchListener(event)
		local listView = event.listView
		dump(event, "UIListView - event:")
		--Commons:printfLog_Info("touchListener: name=%s x,y: %0.2f, %0.2f", event.name, event.x, event.y)
		if "clicked" == event.name then
			if 3 == event.itemPos then
				listView:removeItem(event.item, true) --移除item,带移除动画
			else
				event.item:setItemSize(60, 73*3) --修改item大小
			end
		end
	end

	local lvH = cc.ui.UIListView.new({
			--bg = Imgs.c_default_img,
			--bgStartColor = cc.c4b(255,64,64,150),
			--bgEndColor = cc.c4b(0,0,0,150),
			bgColor = cc.c4b(200, 200, 200, 120),
			--bgColor = Colors.btn_bg,
			bgScale9 = true,
			--capInsets = cc.rect(0, 0, 706, 73*4),
			viewRect = cc.rect(0, 0, 706, 73*3),
			--direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
			direction = cc.ui.UIScrollView.DIRECTION_HORIZONTAL,
			alignment = cc.ui.UIListView.ALIGNMENT_BOTTOM
			--scrollbarImgH = Imgs.c_default_img
			--scrollbarImgV = Imgs.c_default_img
		})
		:onTouch(touchListener)
		:addTo(Layer1)
		:align(display.BOTTOM_LEFT, 266, 20)

	-- add items
	for i=1,11 do
		local item = lvH:newItem()
		local content
		content = cc.ui.UIPushButton.new(Imgs.card_hand_b2, {scale9 = false})
				:setButtonSize(60, 73)
				:setButtonLabel(
					cc.ui.UILabel.new({
						--text = "点击大小改变" .. i, 
						text = "", 
						size = 16, 
						color = display.COLOR_BLUE
					})
				)
				:onButtonPressed(function(event)
					event.target:getButtonLabel():setColor(display.COLOR_RED)
				end)
				:onButtonRelease(function(event)
					event.target:getButtonLabel():setColor(display.COLOR_BLUE)
				end)
				:onButtonClicked(function(event)
					Commons:printLog_Info("UIListView buttonclicked")
					local w, _ = item:getItemSize()
					if 60 == w then
						item:setItemSize(100, 73*3)
					else
						item:setItemSize(60, 73*3)
					end
				end)
		--item:setBg("") -- 设置item背景
		item:addContent(content)
		item:setItemSize(60, 73*3)
		lvH:addItem(item) -- 添加item到列表
	end

	lvH:reload() -- 重新加载
end


-- 如何摆放 一个pageview
function GameingScene:myself_handCard_createView2(Layer1)
	---[[
	local pv = cc.ui.UIPageView.new({
		viewRect = cc.rect(0, 0, column_nums*60, 73*3),
		column = column_nums,
		row = 3, 
		padding = {left = 30, right = 30, top = 20, bottom = 40},
		columnSpace=0,
		rowSpace=0,
		bCirc = false
	})
	:onTouch(function (event)-- 注册touch事件监听)
		--dump(event, "TestUIPageViewScene - event:")
	end)
	:addTo(Layer1)
	:align(display.BOTTOM_LEFT, 266, 0)

	-- add items
	--for i=1,24 do
	for kk,vv in pairs(_handCardDataTable) do
		--Commons:printLog_Info("看看是什么：", kk, vv)
        local img_vv = GameingDealUtil:getImgByHandcard(CEnum.userHand, vv)

		local item = pv:newItem() --新建page项

		local content = cc.ui.UIPushButton.new(img_vv, {scale9 = false})
				:setButtonSize(60, 73)
				:setButtonLabel(
					cc.ui.UILabel.new({
						--text = "点击大小改变" .. i, 
						text = "", 
						size = 16, 
						color = display.COLOR_BLUE
					})
				)
				:onButtonPressed(function(event)
					event.target:getButtonLabel():setColor(display.COLOR_RED)
				end)
				:onButtonRelease(function(event)
					event.target:getButtonLabel():setColor(display.COLOR_BLUE)
				end)
				:onButtonClicked(function(event)
					Commons:printLog_Info("UIPageView buttonclicked")
					local w, _ = item:getItemSize()
					if 60 == w then
						item:setItemSize(100, 73)
					else
						item:setItemSize(60, 73)
					end
				end)
		item:addChild(content)
		--item:setItemSize(60, 73)

		pv:addItem(item) --添加page项
	end
	pv:reload() --重新加载
	--]]
end


-- 如何摆放 一个listview  还嵌套了一个listview
function GameingScene:myself_handCard_createView3(Layer1)

	-- 服务器给到的json字符串是
	--local handCardDataString = '{"a":1,"b":"ss","c":{"c1":1,"c2":2},"d":[10,11],"1":100}';
	--local handCardDataString = '{"b":[1,2,"3",[10,11]]}'
	local handCardDataString = '[ ["ns1"],["ns2"],["ns3","ns3","nb3"],["nb3","nb3"],["nb4"],["nb5"],["nb10"],'
		.. '["ns10","nw0","nw0"],["ns8"],["ns7"],["ns9"]'
		.. ']'
	-- 本地翻译成table对象
    local _handCardDataTable = ParseBase:new():parseToJsonObj(handCardDataString)
	--dump(_handCardDataTable)
	-- 自己编写的假数据
	-- local _handCardDataTable = {
	-- 	"ns1",
	-- 	"ns2",
	-- 	{"ns3","ns3","nb3"},
	-- 	{"nb3","nb3"},
	-- 	"nb4",
	-- 	"nb5",
	-- 	"nb10",
	-- 	{"ns10","nw0","nw0"},
	-- 	"ns8",
	-- 	"ns7",
	-- 	{"ns9"}
	-- }
	-- local size = #_handCardDataTable -- 长度
	-- local startDotX = 266 -- 起点像素 X值
	-- local midDotX = display.cx; -- 中间点像素 X值
	-- local singleCardW = 60; -- 单张牌的宽度

	-- 一级listview的触摸事件
	function touchListener(event)
		local listView = event.listView
		local event_name = event.name
		local position = event.itemPos
		local item = event.item

		dump(event, "ListView - event:")
		Commons:printLog_Info("ListView - event:")
		--Commons:printfLog_Info("touchListener: name=%s x,y: %0.2f, %0.2f", event.name, event.x, event.y)

		if "clicked" == event_name then
			if 100 == position then
				listView:removeItem(item, true) --移除item,带移除动画
			else
				local w, _ = item:getItemSize()
				if 60 == w then   --修改item大小 来演示效果
					item:setItemSize(100, 73*3.5)
				else
					item:setItemSize(60, 73*3.5)
				end
			end
		end
	end

	-- 二级listview的触摸事件
	function touchListener_child(event)
		local listView = event.listView
		local event_name = event.name
		local position = event.itemPos
		local item = event.item

		dump(event, "child ListView - event:")
		--Commons:printLog_Info("child ListView - event:")
		--Commons:printfLog_Info("touchListener: name=%s x,y: %0.2f, %0.2f", event.name, event.x, event.y)

		local x_began
		local y_began

		if "clicked" == event_name then
			if 100 == position then
				listView:removeItem(item, true) --移除item,带移除动画
			else
				local w, _ = item:getItemSize()
				if 60 == w then   --修改item大小 来演示效果
					item:setItemSize(100, 73*3)
				else
					item:setItemSize(60, 73*3)
				end
			end

		elseif "began" == event_name then
			Commons:printLog_Info("began-------------------")
			x_began = event.x
			y_began = event.y
			return true

		elseif "moved" == event_name then
			Commons:printLog_Info("moved-------------------")
			-- local x_mov = event.x
			-- local y_mov = event.y
			-- local x_gap = x_mov - x_began
			-- local y_gap = y_mov - y_began
			-- Commons:printLog_Info("水平 垂直移动了：",x_gap, y_gap)

		elseif "ended" == event_name then
			Commons:printLog_Info("ended-------------------")
			Commons:printLog_Info("item PositionX：",item:getPositionX())
			Commons:printLog_Info("item PositionY：",item:getPositionY())
			local x_end = event.x
			local y_end = event.y
			local x_gap = x_end - x_began
			local y_gap = y_end - y_began
			item:setPosition(cc.p(item:getPositionX() + x_gap, item:getPositionY() + y_gap))
			return true

		end
	end

	-- 一级listview
	local lvH = cc.ui.UIListView.new({
	--local lvH = import("app.common.widgets.CUIListView").new({
			--bg = Imgs.c_default_img,
			--bgStartColor = cc.c4b(255,64,64,150),
			--bgEndColor = cc.c4b(0,0,0,150),
			bgColor = cc.c4b(200, 200, 200, 150),
			--bgColor = Colors.btn_bg,
			bgScale9 = true,
			--capInsets = cc.rect(0, 0, 706, 73*4),
			viewRect = cc.rect(0, 0, 706, 73*3.5),
			--direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
			direction = cc.ui.UIScrollView.DIRECTION_HORIZONTAL,
			alignment = cc.ui.UIListView.ALIGNMENT_RIGHT -- 居下
			--scrollbarImgH = Imgs.c_default_img
			--scrollbarImgV = Imgs.c_default_img
		})
		:onTouch(touchListener)
		:addTo(Layer1)
		:align(display.BOTTOM_LEFT, 266, 0)

	-- add items
	--for i=1,#_handCardDataTable do
	for k,v in pairs(_handCardDataTable) do
		local item = lvH:newItem()

		-- 二级listview		
		local content = cc.ui.UIListView.new({
			--bg = Imgs.c_default_img,
			--bgStartColor = cc.c4b(255,64,64,150),
			--bgEndColor = cc.c4b(0,0,0,150),
			bgColor = cc.c4b(200, 200, 200, 150),
			--bgColor = Colors.btn_bg,
			bgScale9 = true,
			--capInsets = cc.rect(0, 0, 706, 73*4),
			viewRect = cc.rect(0, 0, 60, 73*3),
			direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
			--direction = cc.ui.UIScrollView.DIRECTION_HORIZONTAL,
			--alignment = cc.ui.UIListView.ALIGNMENT_TOP -- 默认居中
			--scrollbarImgH = Imgs.c_default_img
			--scrollbarImgV = Imgs.c_default_img
		})
		:onTouch(touchListener_child)
		--:addTo(Layer1)
		--:align(display.BOTTOM_LEFT, 266, 20)

		local childDataTable = {}
		if type(v) == "table" then
			-- 是list的时候
			--childDataTable = v;
			local size_v = #v;
			local yushu_size_v = 3 - size_v;
			if yushu_size_v == 1 then
                childDataTable[1] = CEnum.status.def_fill
				childDataTable[2] = v[2]
				childDataTable[3] = v[1]
			elseif yushu_size_v == 2 then
                childDataTable[1] = CEnum.status.def_fill
                childDataTable[2] = CEnum.status.def_fill
				childDataTable[3] = v[1]
			else
				childDataTable[1] = v[3]
				childDataTable[2] = v[2]
				childDataTable[3] = v[1]
			end
		else
            childDataTable[1] = CEnum.status.def_fill
            childDataTable[2] = CEnum.status.def_fill
			childDataTable[3] = v
		end

		--for i=1,item_child_size do
		for kk,vv in pairs(childDataTable) do
			--Commons:printLog_Info("看看是什么：", kk, vv)
            local img_vv = GameingDealUtil:getImgByHandcard(CEnum.userHand, vv)
			local item_child = content:newItem()
			local content_child = cc.ui.UIPushButton.new(img_vv, {scale9 = false})
					:setButtonSize(60, 73)
					:setButtonLabel(
						cc.ui.UILabel.new({
							--text = "点击大小改变" .. i, 
							text = "", 
							size = 16, 
							color = display.COLOR_BLUE
						})
					)
					:onButtonPressed(function(event)
						event.target:getButtonLabel():setColor(display.COLOR_RED)
					end)
					:onButtonRelease(function(event)
						event.target:getButtonLabel():setColor(display.COLOR_BLUE)
					end)
					:onButtonClicked(function(event)
						Commons:printLog_Info("child itemClicked")
						dump(item_child, "有什么属性：")
						Commons:printLog_Info("pos:", item_child:getMargin())
						for k,v in pairs(item_child:getMargin()) do
							Commons:printLog_Info("pos:",k,v)
						end
						local w, _ = item_child:getItemSize()
						Commons:printLog_Info("宽",w)
						if 60 == w then
							item_child:setItemSize(100, 73)
						else
							item_child:setItemSize(60, 73)
						end
					end)
			item_child:addContent(content_child)
			item_child:setItemSize(60, 73)

			content_child:setTouchEnabled(true)
			--content_child:setTouchSwallowEnabled(true)
			--content_child:setTouchMode(cc.TOUCH_MODE_ONE_BY_ONE)
			content_child:addNodeEventListener(cc.NODE_TOUCH_EVENT, touchListener_child, false)

			content:addItem(item_child) -- 添加item到列表
			content:reload()
		end

		item:addContent(content)
		item:setItemSize(60, 73*3)
		lvH:addItem(item) -- 添加item到列表
	end

	lvH:reload() -- 重新加载
end

-- 构造函数
function GameingNode:ctor()
end


function GameingNode:onEnter()
end


function GameingNode:onExit()
    --Commons:printLog_Info("GameingNode:onExit")
    --self:removeAllChildren();
end

-- 必须有这个返回
return GameingNode