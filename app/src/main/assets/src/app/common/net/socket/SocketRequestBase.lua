--
-- Author: lte
-- Date: 2016-10-28 17:37:14
--

-- 类申明
-- local SocketRequestBase = class("SocketRequestBase", function ()
-- 	return display.newNode();
-- end)
local SocketRequestBase = class("SocketRequestBase")

-- 类变量申明

-- 类方法申明
function SocketRequestBase:UP(cmd, data)
	local txt = "{";
	if cmd ~= nil and cmd ~= "" then
		txt = txt .. '"cmd":' .. cmd .. ","
	end
	if data ~= nil and type(data) == "table" then
        data[User.Bean.token] = CVar._static.token
        data[Room.Bean.roomNo] = CVar._static.roomNo
        txt = txt .. '"data":' .. ParseBase.new():parseToJsonString(data)
    else
        data = {}
        data[User.Bean.token] = CVar._static.token
        data[Room.Bean.roomNo] = CVar._static.roomNo
        txt = txt .. '"data":' .. ParseBase.new():parseToJsonString(data)
	end
	txt = txt .. "}"

    Commons:printLog_SocketReq("上行json是：",txt)
	if txt ~= nil and txt ~= "" and txt ~= "{}" then
		if CEnum.Environment.Current == CEnum.EnvirType.Http then
            --todo最后需要  加密处理的
            CVar._static.mSocket:SendSokcetDataString(txt)
		end
	end
end


-- 构造函数
function SocketRequestBase:ctor()
end


function SocketRequestBase:onEnter()
end


function SocketRequestBase:onExit()
end

-- 必须有这个返回
return SocketRequestBase