
local TestScene = class("TestScene", function()
    return display.newScene("TestScene")
end)

function TestScene:ctor()    
	--Commons:printLog_Info("arg1=" .. arg1, "arg2=" .. arg2)

	-- label
    --[[
    cc.ui.UILabel.new({
            UILabelType = 2, 
            text = "Hello, World", 
            size = 64
    })
    :align(display.CENTER, display.cx, display.cy)
    :addTo(self)
    --]]
    display.newTTFLabel({
    	text = "AAAA",
        font = Fonts.Font_hkyt_w9,
    	size = 64,
    	color = display.COLOR_RED,
    	align = cc.ui.TEXT_ALIGN_CENTER,
    	dimensions = cc.size(300,100),
    	x = display.cx,
    	y = display.cy,
	})
	:addTo(self)
	--:setText("你好")

    -- button
    --[[
	cc.ui.UIButton.new(UIButton:onButtonClicked(function()
		Commons:printLog_Info("点击了我")
	end), initialState, options)
	:align(display.CENTER, display.cx, display.cy)
	:addTo(self)
	--]]

	-- 输入框
	--[[
	cc.ui.UIInput.new({
		image = Imgs.c_edit_bg,
		imagePressed = Imgs.Edit_Press,
		--imageDisabled = Imgs.Edit_Disable,
		size = CCSize(300,100),
		x = display.cx,
		y = display.cy + 100,
	})
	:addTo(self)
	:setText("你好")
	--:setTextColor();
	--]]

	--dofile("D:/softsgame/mywork_sublime_qv36/gamezp/src/app/utils/Common.lua")
    --Commons:printLog_Info(Commons:addNums(10,10));
    --Commons:printLog_Info(Commons:multNums(10,10));

    -- 图片
    --[[
	local role = display.newSprite("")
	:addTo(self)
	:center()
	--:scaleTo(0.5, 0.3)
	--:setPositionX(100)
	--:runAction(cc.MoveTo:create(2, cc.p(display.width-150, display.cy)))
	--:runAction(cc.MoveBy:create(2, cc.p(500, 0)));
	--]]

	-- 动画
	--[[
	-- 2个动画先后执行
	local move1 = cc.MoveTo:create(2, cc.p(display.width-100, display.cy));
	local move2 = cc.MoveBy:create(2, cc.p(-500, 0));
	role:runAction(cc.Sequence:create(move1,move2));
	--]]

	--[[
	-- 2个动画先后执行
	local move1 = cc.MoveTo:create(2, cc.p(display.width-100, display.cy));
	local move2 = move1:reverse();
	role:runAction(cc.Sequence:create(move1,move2));
	--]]

	--[[
	-- 2个动画同时执行
	local move = cc.MoveTo:create(2, cc.p(500, display.cy));
	local scale = cc.ScaleTo:create(2, 1);
	role:runAction(cc.Spawn:create(move,scale));
	--]]

	--[[
	-- 动画执行完带回调值
	role:runAction(cc.Sequence:create(cc.Spawn:create(move,scale),
		cc.CallFunc:create(function()
			Commons:printLog_Info("完成")
		end)));
	--]]

	--[[
	local role22 = cc.NodeGrid:create();
	role22:addChild(display.newSprite(""));
	role22:center():addTo(self);
	--role22:runAction(cc.Shaky3D:create(3,cc.size(50,50),5,false)); -- 抖动
	--role22:runAction(cc.ShakyTiles3D:create(3,cc.size(50,50),5,false));-- 抖动前分裂
	--role22:runAction(cc.ShuffleTiles:create(3,cc.size(50,50),5));-- 爆炸
	--role22:runAction(cc.TurnOffTiles:create(3,cc.size(50,50)));-- 吞噬消失效果
	--role22:runAction(cc.WavesTiles3D:create(3,cc.size(150,100),5,40));-- 波浪效果

	local shake1 = cc.Shaky3D:create(1,cc.size(50,50),5,false);
	local shake = cc.ShakyTiles3D:create(1,cc.size(50,50),5,false);
	local shuffle = cc.ShuffleTiles:create(0.5,cc.size(50, 50),25);
	role22:runAction(cc.Sequence:create(shake1,shake,shuffle));
	--]]



	-- 导演Director 
	-- 节点Node 
	-- 场景Scene 
	-- 层layer 
	-- 精灵Sprite

	--[[
	--local logo = display.newSprite(""):addTo(self):center();
	-- 等价于
	local img = cc.Director:getInstance():getTextureCache():addImage("");
	local imgSize = img:getContentSize();
	Commons:printLog_Info("imgSize:",imgSize.width, imgSize.height);
	local logo2 = display.newSprite(img):addTo(self):center();
	--]]

	-- 层 图片 到场景中去
	local layer1=display.newLayer():addTo(self):pos(100, 100);
	local layer2=display.newLayer():addTo(self):pos(300, 300);
	local layer3=display.newLayer():addTo(self):pos(500, 500);
	local img1 = display.newSprite(Imgs.edit_press):addTo(layer1);
	local img2 = display.newSprite(Imgs.edit_disable):addTo(layer2);
	local img3 = display.newSprite(Imgs.btn_cancel):addTo(layer3);
	--img1:setAnchorPoint(0);
	--img2:setAnchorPoint(0);
	--img3:setAnchorPoint(0);

	

	--切换到下一场景  
    local function NextScene(scene)  
        runningScene = display.getRunningScene()
        --cc.Director:getRunningScene()
        --CCDirector:sharedDirector():getRunningScene()                      
        --local trans = transition.fadeOut(1.5, scene)
        --CCTransitionFade:create(1.5, scene)  
        if runningScene == nil then 
        	cc.Director:getInstance():runWithScene(scene)
            --CCDirector:sharedDirector():runWithScene(trans)  
        else  
        	cc.Director:getInstance():replaceScene(scene)
            --CCDirector:sharedDirector():replaceScene(trans)  
        end  
    end 

	-- 场景替换
	--self:getScheduler():scheduleScriptFunc(function(f)
		-- 代码创建新的场景
		-- local scene2 = display.newScene(); -- 场景
		-- local scene2layer = display.newLayer():addTo(scene2); --图层
		-- local img = display.newSprite("");
		-- img:center():addTo(scene2layer);
		-- cc.Director:getInstance():replaceScene(scene2);

		-- 需要用的到地方直接申明，好像不行
		--local startScene = require("app/scenes/StartScene")
		--startScene:new()

		--[[
		--local startScene = import("app.scenes.StartScene"):new(); 
		local startScene = StartScene:new();
		--cc.Director:getInstance():replaceScene(startScene);
		-- 这个用户不是3.3版本的 CCDirector:sharedDirector():replaceScene(CCTransitionFade:create(1, startScene))
		-- 这个用法也是ok的
		display.replaceScene(startScene,"fade",0.5,cc.c3b(255,0,0));
		--]]

		--NextScene(startScene);
	--end, 2, false)

	--[[
	local schedule = self:getScheduler();
	local s;
	s = schedule:scheduleScriptFunc(function(f)
		schedule:unscheduleScriptEntry(s);
		Commons:printLog_Info("test");
		local newScene=cc.Scene:create();
		local newBg = display.newSprite("");
		newBg:center():addTo(newScene);
		cc.Director:getInstance():replaceScene(newScene);
	end, 2, false);
	--]]
end

function TestScene:onEnter()
end

function TestScene:onExit()
	self:removeAllChildren();
end

return TestScene
