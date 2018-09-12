--
-- Author: lte
-- Date: 2016-10-09 16:07:08
--


local SplashScene = class("SplashScene", function()
    return display.newScene("SplashScene")
end)

function SplashScene:ctor()
	
    -- self.osWidth = CommonsUpd.osWidth
    -- self.osHeight = CommonsUpd.osHeight
	-- CommonsUpd:printLog_Info("==Start 屏幕宽", self.osWidth, "屏幕高", self.osHeight)

   	-- 层
    self.Layer1 = display.newColorLayer(cc.c4b(230,230,230,255))
        :addTo(self)
        :align(display.CENTER, 0, 0)

    self.splashTxt =
	[[  健康游戏忠告

	抵制不良游戏  拒绝盗版游戏

	注意自我保护  谨防受骗上当

	适度游戏益脑  沉迷游戏伤身

	合理安排时间  享受健康生活
	]]
    cc.ui.UILabel.new({
            UILabelType = 2, 
            --image = "",
            text = self.splashTxt, 
            size = 40,
            --color = Colors.black,
            -- color = Colors:_16ToRGB(Colors.help_txt),
            color = cc.c3b(128,76,21),
            font = FontsUpd.Font_hkyt_w7,
            align = cc.ui.TEXT_ALIGN_CENTER,
            valign = cc.ui.TEXT_VALIGN_CENTER,
            dimensions = cc.size(self.osWidth, 0) -- height为0，就是自动换行
        })
        :align(display.CENTER, display.cx, display.cy)
        :addTo(self.Layer1)
end

function SplashScene:onEnter()
	self:performWithDelay(function () 
        CommonsUpd:gotoUpdate()
    end, 1.0)
end

function SplashScene:onExit()
	self:removeAllChildren()
end

return SplashScene
