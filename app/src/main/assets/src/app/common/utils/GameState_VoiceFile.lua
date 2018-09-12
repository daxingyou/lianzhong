--
-- Author: lte
-- Date: 2016-10-17 18:50:48
--  用户信息

--local base = import(".GameStateUtil")
local GameState_VoiceFile = class("GameState_VoiceFile", GameStateUtil)

-- 类变量申明
local fileName = "userFlyvoiceTxt";


-- 处理方法申明
-- 批量修改
function GameState_VoiceFile:setData(_GameData)
	self:setBaseData(_GameData, fileName);
end

-- 批量取出
function GameState_VoiceFile:getData()
	return self:getBaseData(fileName);
end

-- 单个修改
function GameState_VoiceFile:setDataSingle(key, value)
	self:setBaseDataSingle(key, value, fileName);
end

-- 单个取出
function GameState_VoiceFile:getDataSingle(key)
	return self:getBaseDataSingle(key, fileName);
end


-- 构造函数
function GameState_VoiceFile:ctor()
end


-- 必须有这个返回
return GameState_VoiceFile