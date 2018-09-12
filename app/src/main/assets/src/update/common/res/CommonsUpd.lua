--
-- Author: lte
-- Date: 2016-10-10 12:26:49
-- 方法类


-- 类申明
-- local Commons = class("Commons", function ()
--     return display.newNode();
-- end)
local Commons = class("Commons")


-- 类变量申明
Commons.osWidth = display.width
Commons.osHeight = display.height
Commons.osType = device.platform

-- http 请求响应日志打印控制
function Commons:printLog_Req(...)
    if not CEnumUpd.Environment.needPrint_Log_Req then
        print(...)
    end
end

-- socket 请求响应日志打印控制
function Commons:printLog_SocketReq(...)
    if not CEnumUpd.Environment.needPrint_Log_SocketReq then
        print(...)
    end
end

-- 普通日志打印控制
function Commons:printLog_Info(...)
    if not CEnumUpd.Environment.needPrint_Log_Info then
        print(...)
    end
end

-- 普通日志打印控制  带格式化的
function Commons:printfLog_Info(...)
    if not CEnumUpd.Environment.needPrint_Log_Info then
        printf(...)
    end
end

-- 跳转到 闪屏页
function Commons:gotoSplash()
    local toScene = require("update.scenes.SplashScene"):new() -- SplashScene:new()
    --display.pushScene(toScene)
    display.replaceScene(toScene, "fade", 0.5, cc.c3b(0,0,0) )
end

-- 跳转到 更新页
function Commons:gotoUpdate()
    local toScene = require("update.scenes.UpdateScene"):new() -- UpdateScene:new()
    --display.pushScene(toScene)
    display.replaceScene(toScene, "fade", 0.5, cc.c3b(0,0,0) )
end

-- 跳转到 登录页
function Commons:gotoLogin()
    local toScene = require("app.scenes.LoginScene"):new() -- LoginScene:new()
    --display.pushScene(toScene)
    display.replaceScene(toScene, "fade", 0.5, cc.c3b(0,0,0) )
end

-- Formats a String in .Net-style, with curly braces ("{1},{2}").
function Commons:formatString(str, ...)
    local numArgs = select("#", ...)
    if numArgs >= 1 then
        local output = str
        for i = 1, numArgs do
            local value = select(i, ...)
            output = string.gsub(output, "{" .. i .. "}", value)
        end
        return output
    else
        return str
    end
end

-- 去除字符串两边的空格  
function Commons:trim(obj)
    if Commons:checkIsNull_str(obj) then
      return (string.gsub(obj, "^%s*(.-)%s*$", "%1"))
    else
      return obj
    end
end  

-- 真的是 有值，返回true
function Commons:checkIsNull_str(obj)
  if obj~=nil and type(obj)=="string" then
    if obj~="" then
      return true
    else
      return false
    end
  else
    return false
  end
end

-- 真的是 有值，不为空，不等于零 都会返回true
function Commons:checkIsNull_number(obj)
  if obj~=nil and type(obj) == "number" then
    if obj~=0 then
      return true
    else
      return false
    end
  else
    return false
  end
end

function Commons:checkIsNull_numberType(obj)
  if obj~=nil and type(obj) == "number" then
    --if obj~=0 then
      return true
    --else
    --  return false
    --end
  else
    return false
  end
end

-- 真的是 有值，返回true
function Commons:checkIsNull_tableList(obj)
    if obj~=nil and type(obj)=="table" then
      if #obj~=0 then
        return true
      else
        return false
      end
    else
      return false
    end
end

-- 真的是 有值，返回true
function Commons:checkIsNull_tableType(obj)
    if obj~=nil and type(obj)=="table" then
        return true
    else
        return false
    end
end

-- 构造函数
function Commons:ctor()
end

-- 必须有这个返回
return Commons