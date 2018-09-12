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

-- 处理方法申明
--[[
function Commons:addNums(a,b)
    return a+b
end
--]] 

--[[
function Commons:multNums(a,b)
    return a*b
end 
--]]

-- http 请求响应日志打印控制
function Commons:printLog_Req(...)
    if not CEnum.Environment.needPrint_Log_Req then
        print(...)
  end
end

-- socket 请求响应日志打印控制
function Commons:printLog_SocketReq(...)
    if not CEnum.Environment.needPrint_Log_SocketReq then
        print(...)
    end
end

-- 普通日志打印控制
function Commons:printLog_Info(...)
    if not CEnum.Environment.needPrint_Log_Info then
        print(...)
    end
end

-- 普通日志打印控制  带格式化的
function Commons:printfLog_Info(...)
    if not CEnum.Environment.needPrint_Log_Info then
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

-- -- 跳转到 开始
-- function Commons:gotoStart()
--     local toScene = StartScene:new();
--     --display.pushScene(toScene)
--     -- 变化的样式就很多，到时具体参考api文档
--     display.replaceScene(toScene, "fade", 0.5, cc.c3b(0,0,0) )
-- end

-- 跳转到 登录页
function Commons:gotoLogin()
    local toScene = require("app.scenes.LoginScene"):new() -- LoginScene:new()
    --display.pushScene(toScene)
    display.replaceScene(toScene, "fade", 0.5, cc.c3b(0,0,0))
end

-- 跳转到 字牌子主页
function Commons:gotoHome()
    -- 游戏别名的赋值
    CEnum.AppVersion.gameAlias = CEnum.gameType.wmq

    local toScene = HomeScene:new({a=0,b=100});
    --display.pushScene(toScene)
    display.replaceScene(toScene, "fade", 0.5, cc.c3b(0,0,0) )
end

-- 跳转到 字牌游戏页
function Commons:gotoGameing()
     -- 游戏别名的赋值
    CEnum.AppVersion.gameAlias = CEnum.gameType.wmq

    local toScene = GameingScene:new()
    --display.pushScene(toScene)
    display.replaceScene(toScene, "fade", 0.5, cc.c3b(0,0,0) )
end

--跳转到 游戏大厅
function Commons:gotoMainHall()
    -- 游戏别名的赋值
    CEnum.AppVersion.gameAlias = CEnum.gameType.mainHall

    local toScene = MainHallScene:new();
    display.replaceScene(toScene, "fade", 0.5, cc.c3b(0,0,0) )
end

--跳转到 跑得快游戏子主页
function Commons:gotoPDKHome()
    -- 游戏别名的赋值
    CEnum.AppVersion.gameAlias = CEnum.gameType.pdk

    local toScene = HomeScene:new()
    display.replaceScene(toScene, "fade", 0.5, cc.c3b(0,0,0) )
end

--跳转到 跑得快游戏房间
function Commons:gotoPDKRoom()
    -- 游戏别名的赋值
    CEnum.AppVersion.gameAlias = CEnum.gameType.pdk

    local toScene = PDKRoomScene:new()
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

-- 公用的 微信发图文给好友
function Commons:gotoShareWX(_title, _content)
  local function CommonScene_invite_CallbackLua(txt)
      --CDAlert:new():popDialogBox(pop_window, txt)
  end
  if Commons.osType == CEnum.osType.A then
      local _Class = CEnum.WX_Invite._Class
      local _Name = CEnum.WX_Invite._Name
      local _args = { 
                  _title, 
                  Imgs.file_logo72, 
                  _content, 
                  Strings.gameing_share_jumpUrl, 
                  CommonScene_invite_CallbackLua}
      local _sig = "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;I)V" --传入string参数，无返回值
      --local ok, ret = 
          luaj.callStaticMethod(_Class, _Name, _args, _sig) --没有返回默认nil
  elseif Commons.osType == CEnum.osType.I then
      local _Class = CEnum.WX_Invite_ios._Class
      local _Name = CEnum.WX_Invite_ios._Name
      local _args = { title = _title, 
                      pic = Imgs.file_logo72, 
                      content = _content, 
                      jumpUrl = Strings.gameing_share_jumpUrl_ios, 
                      listener = CommonScene_invite_CallbackLua}
      --local ok, ret = 
          luaoc.callStaticMethod(_Class, _Name, _args)    
  end
end

-- 公用的 微信发送文字给好友
-- function Commons:copyContent_towx(_content)
--     local function CommonScene_WXTxt_Share_CallbackLua(txt)
--     end
--     if Commons.osType == CEnum.osType.A then
--         local _Class = CEnum.WXTxt_Share._Class
--         local _Name = CEnum.WXTxt_Share._Name
--         local _args = { _content, CommonScene_WXTxt_Share_CallbackLua}
--         local _sig = "(Ljava/lang/String;I)V" --传入string参数，无返回值
--         --local ok, ret = 
--             luaj.callStaticMethod(_Class, _Name, _args, _sig) --没有返回默认nil
--     elseif Commons.osType == CEnum.osType.I then
--         local _Class = CEnum.WXTxt_Share_ios._Class
--         local _Name = CEnum.WXTxt_Share_ios._Name
--         local _args = { content=_content, 
--                         listener=CommonScene_WXTxt_Share_CallbackLua}
--         --local ok, ret = 
--             luaoc.callStaticMethod(_Class, _Name, _args)
--     end
-- end

-- 公用的 微信图片发给好友
function Commons:gotoShareWX_Img(_server_url)
  local function CommonOverRoomDialog_CallbackLua(txt)
      --CDAlert:new():popDialogBox(pop_window, txt)
  end
  if Commons.osType == CEnum.osType.A and _server_url ~= nil then
      local _Class = CEnum.WX_Share._Class
      local _Name = CEnum.WX_Share._Name
      --local _args = { "http://wmq.res.apk.yuelaigame.com/icon/guest_boy.jpg", CommonOverRoomDialog_CallbackLua}
      local _args = { _server_url, CommonOverRoomDialog_CallbackLua}
      local _sig = "(Ljava/lang/String;I)V" --传入string参数，无返回值
      --local ok, ret = 
        luaj.callStaticMethod(_Class, _Name, _args, _sig) --没有返回默认nil
  elseif Commons.osType == CEnum.osType.I and _server_url ~= nil then
      local _Class = CEnum.WX_Share_ios._Class
      local _Name = CEnum.WX_Share_ios._Name
      local _args = { imgUrl=_server_url, 
                      listener=CommonOverRoomDialog_CallbackLua
                    }
      --local ok, ret = 
        luaoc.callStaticMethod(_Class, _Name, _args) --没有返回默认nil
  end
end

-- 公用的复制功能
function Commons:gotoCopyContent(funBack, _content)
  if Commons:checkIsNull_str(_content) then
      local function CommonScene_copyContent_CallbackLua(txt)
          if funBack then
            funBack(txt)
          end
      end
      if Commons.osType == CEnum.osType.A then
          local _Class = CEnum.CopyTxt._Class
          local _Name = CEnum.CopyTxt._Name
          local _args = { _content, "", CommonScene_copyContent_CallbackLua}
          local _sig = "(Ljava/lang/String;Ljava/lang/String;I)V" --传入string参数，无返回值
          --local ok, ret = 
              luaj.callStaticMethod(_Class, _Name, _args, _sig) --没有返回默认nil
      elseif Commons.osType == CEnum.osType.I then
          local _Class = CEnum.CopyTxt_ios._Class
          local _Name = CEnum.CopyTxt_ios._Name
          local _args = { content=_content, 
                          listener=CommonScene_copyContent_CallbackLua}
          --local ok, ret = 
              luaoc.callStaticMethod(_Class, _Name, _args)
      end
  end
end

-- 公用的 粘贴功能
function Commons:getCopyContent(funBack)
      local function CommonScene_getContent_CallbackLua(txt)
          if funBack then
            funBack(txt)
          end
      end
      if Commons.osType == CEnum.osType.A then
          local _Class = CEnum.getCopyTxt._Class
          local _Name = CEnum.getCopyTxt._Name
          local _args = { "", CommonScene_getContent_CallbackLua}
          local _sig = "(Ljava/lang/String;I)V" --传入string参数，无返回值
          --local ok, ret = 
            luaj.callStaticMethod(_Class, _Name, _args, _sig) --没有返回默认nil
      elseif Commons.osType == CEnum.osType.I then
          local _Class = CEnum.getCopyTxt_ios._Class
          local _Name = CEnum.getCopyTxt_ios._Name
          local _args = { content="", 
                          listener=CommonScene_getContent_CallbackLua}
          --local ok, ret = 
            luaoc.callStaticMethod(_Class, _Name, _args)
      end
end

-- 公用的 录音点击
function Commons:gotoDictate()
    local function CommonScene_Dictate_CallbackLua(txt)
    end
    if Commons.osType == CEnum.osType.A then
        local _Class = CEnum.Dictate._Class
        local _Name = CEnum.Dictate._Name
        local _args = { "test", CommonScene_Dictate_CallbackLua}
        local _sig = "(Ljava/lang/String;I)V" --传入string参数，无返回值
        --local ok, ret = 
          luaj.callStaticMethod(_Class, _Name, _args, _sig) --没有返回默认nil
    elseif Commons.osType == CEnum.osType.I then
        local _Class = CEnum.Dictate_ios._Class
        local _Name = CEnum.Dictate_ios._Name
        local _args = { test="test", 
                        listener=CommonScene_Dictate_CallbackLua}
        --local ok, ret = 
          luaoc.callStaticMethod(_Class, _Name, _args) --没有返回默认nil
    end
end

-- 公用的 录音停止
function Commons:gotoDictateStop(funBack)
    -- 停止录音，也停止各项东西
    local function CommonScene_DictateStop_CallbackLua(txt)
      if funBack then
        funBack(txt)
      end
    end
    if Commons.osType == CEnum.osType.A then
        local _Class = CEnum.DictateStop._Class
        local _Name = CEnum.DictateStop._Name
        local _args = { "test", CommonScene_DictateStop_CallbackLua}
        local _sig = "(Ljava/lang/String;I)V" --传入string参数，无返回值
        --local ok, ret = 
          luaj.callStaticMethod(_Class, _Name, _args, _sig) --没有返回默认nil
    elseif Commons.osType == CEnum.osType.I then
        local _Class = CEnum.DictateStop_ios._Class
        local _Name = CEnum.DictateStop_ios._Name
        local _args = { test="test", 
                        listener=CommonScene_DictateStop_CallbackLua}
        --local ok, ret = 
          luaoc.callStaticMethod(_Class, _Name, _args) --没有返回默认nil
    end
end

-- 公用的 录音播放
function Commons:gotoDictatePlay(funBack, fileNameShort)
    -- 停止录音，也停止各项东西
    local function CommonScene_DictatePlay_CallbackLua_RL(txt)
      if funBack then
        funBack(txt)
      end
    end
    if Commons.osType == CEnum.osType.A then
        -- Commons:printLog_Info("-----------安卓平台 开始播放了", fileNameShort, _seat)
        local _Class = CEnum.DictatePlay._Class
        local _Name = CEnum.DictatePlay._Name
        local _args = { fileNameShort, CommonScene_DictatePlay_CallbackLua_RL}
        local _sig = "(Ljava/lang/String;I)V" --传入string参数，无返回值
        --local ok, ret = 
          luaj.callStaticMethod(_Class, _Name, _args, _sig) --没有返回默认nil
    elseif Commons.osType == CEnum.osType.I then
        -- Commons:printLog_Info("-----------ios平台 开始播放了", fileNameShort, _seat)
        local _Class = CEnum.DictatePlay_ios._Class
        local _Name = CEnum.DictatePlay_ios._Name
        local _args = { filePath=fileNameShort, listener=CommonScene_DictatePlay_CallbackLua_RL}
        --local ok, ret = 
          luaoc.callStaticMethod(_Class, _Name, _args) --没有返回默认nil
    end
end

-- 公用的 定位
function Commons:getLgeLat(funBack)
    -- 停止录音，也停止各项东西
    local function CommonScene_getLgeLat_CallbackLua(txt)
      if funBack then
        funBack(txt)
      end
    end
    if Commons.osType == CEnum.osType.A then
        local _Class= CEnum.LgeLat._Class
        local _Name = CEnum.LgeLat._Name
        local _args = { "android getLgeLat", CommonScene_getLgeLat_CallbackLua}
        local _sig = "(Ljava/lang/String;I)V" --传入string参数，无返回值
        --local ok, ret = 
          luaj.callStaticMethod(_Class, _Name, _args, _sig) --没有返回默认nil

    elseif Commons.osType == CEnum.osType.I then
        local _Class= CEnum.LgeLat_ios._Class
        local _Name = CEnum.LgeLat_ios._Name
        local _args = { test="ios getLgeLat", listener=CommonScene_getLgeLat_CallbackLua}
        --local ok, ret = 
          luaoc.callStaticMethod(_Class, _Name, _args)
    end
end


--[[
-- 真的是 有值，返回true
function Commons:checkIsNull_json(obj)
  if obj ~= nil and obj ~= "nil" and obj ~= "{}" and obj ~= "[]" and obj ~= "" then
    return true
  else
    return false
  end
end
--]]

--[[
-- 传入DrawNode对象，画圆角矩形
function Commons:drawNodeRoundRect(drawNode, rect, borderWidth, radius, color, fillColor)
  -- segments表示圆角的精细度，值越大越精细
  local segments    = 100
  local origin      = cc.p(rect.x, rect.y)
  local destination = cc.p(rect.x + rect.width, rect.y - rect.height)
  local points      = {}

  -- 算出1/4圆
  local coef     = math.pi / 2 / segments
  local vertices = {}

  for i=0, segments do
    local rads = (segments - i) * coef
    local x    = radius * math.sin(rads)
    local y    = radius * math.cos(rads)

    table.insert(vertices, cc.p(x, y))
  end

  local tagCenter      = cc.p(0, 0)
  local minX           = math.min(origin.x, destination.x)
  local maxX           = math.max(origin.x, destination.x)
  local minY           = math.min(origin.y, destination.y)
  local maxY           = math.max(origin.y, destination.y)
  local dwPolygonPtMax = (segments + 1) * 4
  local pPolygonPtArr  = {}

  -- 左上角
  tagCenter.x = minX + radius;
  tagCenter.y = maxY - radius;

  for i=0, segments do
    local x = tagCenter.x - vertices[i + 1].x
    local y = tagCenter.y + vertices[i + 1].y

    table.insert(pPolygonPtArr, cc.p(x, y))
  end

  -- 右上角
  tagCenter.x = maxX - radius;
  tagCenter.y = maxY - radius;

  for i=0, segments do
    local x = tagCenter.x + vertices[#vertices - i].x
    local y = tagCenter.y + vertices[#vertices - i].y

    table.insert(pPolygonPtArr, cc.p(x, y))
  end

  -- 右下角
  tagCenter.x = maxX - radius;
  tagCenter.y = minY + radius;

  for i=0, segments do
    local x = tagCenter.x + vertices[i + 1].x
    local y = tagCenter.y - vertices[i + 1].y

    table.insert(pPolygonPtArr, cc.p(x, y))
  end

  -- 左下角
  tagCenter.x = minX + radius;
  tagCenter.y = minY + radius;

  for i=0, segments do
    local x = tagCenter.x - vertices[#vertices - i].x
    local y = tagCenter.y - vertices[#vertices - i].y

    table.insert(pPolygonPtArr, cc.p(x, y))
  end

  if fillColor == nil then
    fillColor = cc.c4f(0, 0, 0, 0)
  end

  drawNode:drawPolygon(pPolygonPtArr, #pPolygonPtArr, fillColor, borderWidth, color)
end


-- 一个通用的 创建一个模态弹出框,parent 要加在哪个上面
function Commons:popDialogBox(parent)
    local pop_window = display.newColorLayer(cc.c4b(0, 0, 0, 100))       -- 半透明的黑色
    pop_window:setContentSize(display.width, display.height)             -- 设置Layer的大小,全屏出现
    pop_window:align(display.CENTER, 0, 0) -- Layer的锚点在0.5,0.5 因此对齐的时候要注意
    pop_window:setTouchEnabled(true)
    pop_window:setTouchSwallowEnabled(true)                              -- 吞噬下层的响应
    pop_window:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event) -- 点击此Layer时候输出信息,然后把自己销毁
        local label = string.format("-- %s x,y: %0.2f, %0.2f", event.name, event.x, event.y)
        print(label)
        parent:removeChild(pop_window)
        pop_window:removeSelf()
        return true
    end)
    parent:addChild(pop_window, 9999)                                     -- 把Layer添加到父对象上
end
--]]


-- 构造函数
function Commons:ctor()
end

-- 必须有这个返回
return Commons