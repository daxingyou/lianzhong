--
-- Author: lte
-- Date: 2016-10-17 18:50:48
--  用户信息

--local base = import(".GameStateUtil")
local UpdateStateUtil_dataFile = class("UpdateStateUtil_dataFile", UpdateStateBaseUtil)


-- 常量
local fileName = "userUpdDataTxt";


-- 批量修改
function UpdateStateUtil_dataFile:setData(_GameData)
	self:setBaseData(_GameData, fileName);
end

-- 批量取出
function UpdateStateUtil_dataFile:getData()
	return self:getBaseData(fileName);
end

-- 单个修改
function UpdateStateUtil_dataFile:setDataSingle(key, value)
	self:setBaseDataSingle(key, value, fileName);
end

-- 单个取出
function UpdateStateUtil_dataFile:getDataSingle(key)
	return self:getBaseDataSingle(key, fileName);
end


-- 构造函数
function UpdateStateUtil_dataFile:ctor()
end


-- 必须有这个返回
return UpdateStateUtil_dataFile