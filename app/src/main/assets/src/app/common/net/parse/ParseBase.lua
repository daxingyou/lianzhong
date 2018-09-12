--
-- Author: lte
-- Date: 2016-10-12 20:52:54
-- 解析首页数据


-- 类申明
-- local ParseBase = class("ParseBase", function ()
-- 	return display.newNode();
-- end)

local ParseBase = class("ParseBase")


-- 类变量申明


-- 测试例子json数据
ParseBase.EX_json = '{"a":1,"b":"ss","c":{"c1":1,"c2":2},"d":[10,11],"1":100}';
ParseBase.status = 'status';
ParseBase.msg = 'msg';
ParseBase.data = 'data';

ParseBase.cmd = 'cmd'; -- socket用到的


-- 方法体申明

-- 字符串翻译成json对象，也就是一个table对象
function ParseBase:parseToJsonObj(JsonString)
	if JsonString ~= nil then
		return json.decode(JsonString);
	else
		return nil;
	end
end 


-- json table对象翻译成字符串
function ParseBase:parseToJsonString(JsonObjTable)
	if JsonObjTable ~= nil and type(JsonObjTable) == "table" then
		return json.encode(JsonObjTable);
	else
		return nil;
	end
end 


-- 构造函数
function ParseBase:ctor()
end


-- 必须有这个返回
return ParseBase
