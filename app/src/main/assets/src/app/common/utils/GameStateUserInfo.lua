--
-- Author: lte
-- Date: 2016-10-17 18:50:48
--  用户信息

--local base = import(".GameStateUtil")
local GameStateUserInfo = class("GameStateUserInfo", GameStateUtil)

-- 类变量申明
local fileName = "userTxt";


-- 处理方法申明
-- 批量修改
function GameStateUserInfo:setData(_GameData)
	self:setBaseData(_GameData, fileName);
end

-- 批量取出
function GameStateUserInfo:getData()
	return self:getBaseData(fileName);
end

-- 单个修改
function GameStateUserInfo:setDataSingle(key, value)
	self:setBaseDataSingle(key, value, fileName);
end

-- 单个取出
function GameStateUserInfo:getDataSingle(key)
	return self:getBaseDataSingle(key, fileName);
end


-- 构造函数
function GameStateUserInfo:ctor()
end


-- 必须有这个返回
return GameStateUserInfo