--
-- Author: lte
-- Date: 2016-10-17 18:50:48
--  用户声音和音效设置值保存

--local base = import(".GameStateUtil")
local GameState_VoiceSetting = class("GameState_VoiceSetting", GameStateUtil)

-- 类变量申明
local fileName = "userVoiceTxt";


-- 处理方法申明
-- 批量修改
function GameState_VoiceSetting:setData(_GameData)
	self:setBaseData(_GameData, fileName);
end

-- 批量取出
function GameState_VoiceSetting:getData()
	return self:getBaseData(fileName);
end

-- 单个修改
function GameState_VoiceSetting:setDataSingle(key, value)
	self:setBaseDataSingle(key, value, fileName);
end

-- 单个取出
function GameState_VoiceSetting:getDataSingle(key)
	return self:getBaseDataSingle(key, fileName);
end


-- 构造函数
function GameState_VoiceSetting:ctor()
end


-- 必须有这个返回
return GameState_VoiceSetting