
require("config")
require("cocos.init")
require("framework.init")

require("app.DefineHeader") -- 加载全部需要的类文件


local MyApp = class("MyApp", cc.mvc.AppBase)

function MyApp:ctor()
    MyApp.super.ctor(self)
end

function MyApp:run()
    --[[
    -- 缩放因子不能算错，弄错，否则布局就乱套
    --cc.Director:getInstance():setContentScaleFactor(1280/CONFIG_SCREEN_WIDTH);
    cc.Director:getInstance():setContentScaleFactor(720/CONFIG_SCREEN_HEIGHT);
    --]]
    
    ---[[
	local CONFIG_SCREEN_AUTOSCALE_CALLBACK = function(w, h)
		-- print("================分辨率==", display.widthInPixels, display.heightInPixels, display.widthInPixels/display.heightInPixels)
	    -- print("================分辨率==", w,h, w/h)
	    -- 宽高取整数
	    local temp_w = w-w%1
	    Commons.osWidth = temp_w
	    local temp_h = h-h%1
	    Commons.osHeight = temp_h
	end
	CONFIG_SCREEN_AUTOSCALE_CALLBACK(display.width, display.height)
	--]]

	---[[
	-- 要变成全局的，修改工作量太大
	CVar._static.appstoreSwitch = CVarUpd._static.appstoreSwitch -- 苹果开关
    CVar._static.protocolSwitch = CVarUpd._static.protocolSwitch -- 用户协议开关

	CVar._static.isIphone4 = CVarUpd._static.isIphone4
	CVar._static.isIpad = CVarUpd._static.isIpad
	-- CVar._static.NavBarH_Android = CVarUpd._static.NavBarH_Android
	--]]


    -- self:enterScene("SplashScene");--,{10,20})
    self:enterScene("LoginScene");--,{10,20})
end

return MyApp
