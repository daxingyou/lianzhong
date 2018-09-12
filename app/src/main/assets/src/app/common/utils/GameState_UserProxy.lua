--
-- Author: lte
-- Date: 2016-10-17 18:50:48
--  代理信息的记录

--local base = import(".GameStateUtil")
local GameState_UserProxy = class("GameState_UserProxy", GameStateUtil)

-- 类变量申明
local fileName = "userProxyTxt";


-- 处理方法申明
-- 批量修改
function GameState_UserProxy:setData(_GameData)
	self:setBaseData(_GameData, fileName);
end

-- 批量取出
function GameState_UserProxy:getData()
	return self:getBaseData(fileName);
end

-- 单个修改
function GameState_UserProxy:setDataSingle(key, value)
	self:setBaseDataSingle(key, value, fileName);
end

-- 单个取出
function GameState_UserProxy:getDataSingle(key)
	return self:getBaseDataSingle(key, fileName);
end


-- 构造函数
function GameState_UserProxy:ctor()
end


-- 必须有这个返回
return GameState_UserProxy