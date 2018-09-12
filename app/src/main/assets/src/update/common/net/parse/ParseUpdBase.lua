--
-- Author: lte
-- Date: 2016-10-12 20:52:54
-- 解析首页数据


-- 类申明
-- local ParseUpdBase = class("ParseUpdBase", function ()
-- 	return display.newNode();
-- end)

local ParseUpdBase = class("ParseUpdBase")

ParseUpdBase.bean = {
	status = 'status',
	msg = 'msg',
	data = 'data',
	cmd = 'cmd' -- socket用到的
}


-- 字符串翻译成json对象，也就是一个table对象
function ParseUpdBase:parseToJsonObj(JsonString)
	if JsonString ~= nil then
		return json.decode(JsonString);
	else
		return nil;
	end
end 


-- json table对象翻译成字符串
function ParseUpdBase:parseToJsonString(JsonObjTable)
	if JsonObjTable ~= nil and type(JsonObjTable) == "table" then
		return json.encode(JsonObjTable);
	else
		return nil;
	end
end 


-- 构造函数
function ParseUpdBase:ctor()
end


-- 必须有这个返回
return ParseUpdBase
