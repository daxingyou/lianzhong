function __G__TRACKBACK__(errorMessage)
    print("----------------------------------------")
    print("LUA ERROR: " .. tostring(errorMessage) .. "\n")
    print(debug.traceback("", 2))
    print("----------------------------------------")
end

package.path = package.path .. ";src/?.lua;src/framework/protobuf/?.lua"
cc.FileUtils:getInstance():setPopupNotify(false)
--require("app.MyApp").new():run()

---[[
-- 有热更新功能，就需要先判断升级和热更新
require("config")
require("cocos.init")
require("framework.init")

-- require("app.DefineHeader") -- 加载全部需要的类文件

-- 因为有热更新，先加载部分文件
CommonsUpd = require("update.common.res.CommonsUpd") -- 方法体内 很多简单处理的类
CEnumUpd = require("update.common.res.CEnumUpd") -- 模拟枚举
CVarUpd = require("update.common.res.CVarUpd") -- 全局变量
ImgsUpd = require("update.common.res.ImgsUpd")
FontsUpd = require("update.common.res.FontsUpd")
-- http请求
HttpsUpd = require("update.common.res.HttpsUpd") -- ip、port、http地址 等等信息


RequestUpdBase=require("update.common.net.req.RequestUpdBase") -- http请求服务连接 基类
RequestUpdate=require("update.common.net.req.RequestUpdate")

-- 解析json文件
ParseUpdBase=require("update.common.net.parse.ParseUpdBase") -- 解析json 基类

-- loading框
HotAlertLoading = require("update.common.widgets.HotAlertLoading")

-- 文件保存类
UpdateStateBaseUtil = require("update.common.utils.UpdateStateBaseUtil") -- table值 热更新信息保存 基类
UpdateStateUtil_dataFile = require("update.common.utils.UpdateStateUtil_dataFile") -- table值 热更新信息保存 

-- beans
HotUpdate = import("update.beans.HotUpdate")
UpdateAppHot = import("update.beans.UpdateAppHot")

HotUpdateUtil = require("update.deal.HotUpdateUtil") -- 热更新处理

CDailogUpdateAppHot = require("update.views.CDailogUpdateAppHot") -- 大版本更新框
--]]

function __G__TRACKBACK__(errorMessage)
    print("----------------------------------------")
    print("LUA ERROR: " .. tostring(errorMessage) .. "\n")
    print(debug.traceback("", 2))
    print("----------------------------------------")

    if CEnumUpd and (not CEnumUpd.Environment.screenPrintLog) then
        local scene = display.getRunningScene()
        if scene then
        	local errorinfo = tostring(errorMessage).."\n"..debug.traceback("", 2)
            if not errorInfo_ then
                errorInfo_ = display.newTTFLabel({
                    -- text = "",
                    -- font = "Arial.ttf",
                    size = 20,
                    -- x = display.cx,
                    -- y = display.cy,
                    color=cc.c3b(0xff, 0x00, 0x00),
                    align = cc.ui.TEXT_ALIGN_LEFT,
            		valign = cc.ui.TEXT_VALIGN_CENTER,
                    dimensions = cc.size(display.width, display.height)
                })
                :addTo(scene, 9999)
                :align(display.CENTER, display.cx, display.cy)
            end
            errorInfo_:setString("")
            errorInfo_:setString(errorinfo)
        end   
    end
end

-- package.path = package.path .. ";src/?.lua;src/framework/protobuf/?.lua"
-- cc.FileUtils:getInstance():setPopupNotify(false)
--[[
-- 没有热更新，不能首先进入这个
require("app.MyApp").new():run()
--]]


---[[
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
    CommonsUpd.osWidth = temp_w
    local temp_h = h-h%1
    CommonsUpd.osHeight = temp_h

	if CEnumUpd.osType.A ~= CommonsUpd.osType then
		-- 高端点苹果手机和安卓手机： 1920/1080=1.777， 1280/800=1.6， 1280/720=1.777， 1136/640=1.775 iphone5， 1024/600=1.706， 960/540=1.777， 854/480=1.779, 800/480=1.666，
        -- 一些超级弱的安卓机器： 960/640=1.5 iphone4， 480/320=1.5 iphone3GS
        -- 1024/768=1.337 ipad，2048/1536=1.333 ipad Retina
	    if w/h <= 1.5 then
	        CVarUpd._static.isIphone4 = true
	        CVarUpd._static.isIpad = false
	        if w/h <= 1.4 then
	        	CVarUpd._static.isIphone4 = false
	        	CVarUpd._static.isIpad = true
	        end
	    end
    else
        -- 安卓机器，目前只是处理 1024/768 这个分辨率的 【用户一个奇葩手机，尽然比例值=1.433左右】
        -- 安卓机器，华为平板m2，又是出现虚拟键=1094/720=1.52多， 不出现虚拟键=1152/720=1.6
        if w/h <= 1.6 then
            CVarUpd._static.isIphone4 = true
            CVarUpd._static.isIpad = false
            if w/h <= 1.4 then
                CVarUpd._static.isIphone4 = false
                CVarUpd._static.isIpad = true
            end
        end
	end
end
CONFIG_SCREEN_AUTOSCALE_CALLBACK(display.width, display.height)
--]]

-- -- android手机 如果有虚拟键的 高度多少
-- local function LoginScene_getNavBarH()
--     local function LoginScene_CallbackLua_getNavBarH(txt)
--         if CommonsUpd:checkIsNull_str(txt) then
--             CVarUpd._static.NavBarH_Android = tonumber(txt)
--             --CDAlertNoAutoShut:popDialogBox(Layer1, CVarUpd._static.NavBarH_Android.."")
--         end
--     end

--     if CommonsUpd.osType == CEnumUpd.osType.A then
--         local _Class= CEnumUpd.getNarBarHeight._Class
--         local _Name = CEnumUpd.getNarBarHeight._Name
--         local _args = { "", LoginScene_CallbackLua_getNavBarH}
--         local _sig = "(Ljava/lang/String;I)V" --传入string参数，无返回值
--         --local ok, ret = 
--         luaj.callStaticMethod(_Class, _Name, _args, _sig) --没有返回默认nil
--     elseif CommonsUpd.osType == CEnumUpd.osType.I then
--         CVarUpd._static.NavBarH_Android = 0
--     end
-- end
-- LoginScene_getNavBarH() -- android手机 如果有虚拟键的 高度多少

CommonsUpd:gotoSplash()
