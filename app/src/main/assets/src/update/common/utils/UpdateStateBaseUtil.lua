--
-- Author: lte
-- Date: 2016-10-11 20:15:06
-- 复杂值的保存

-- 类申明
local UpdateStateBaseUtil = class("UpdateStateBaseUtil")


-- 常量
local secretKey = "comkl";
local secretBodyKey = "gamezp";


-- 批量修改
function UpdateStateBaseUtil:setBaseData(_GameData, fileName)
	local myGameState = self:initBaseData(fileName);
	--local myGameData = myGameState.load() or {}
	--myGameData.hello = "hello world";
	--myGameState.save(myGameData)
	myGameState.save(_GameData)
end

-- 批量取出
function UpdateStateBaseUtil:getBaseData(fileName)
	local myGameState = self:initBaseData(fileName);
	local myGameData = myGameState.load() or {}
	return myGameData;
end

-- 单个修改
function UpdateStateBaseUtil:setBaseDataSingle(key, value, fileName)
	local myGameState = self:initBaseData(fileName);
	local myGameData = myGameState.load() or {}
	myGameData[key] = value;
	myGameState.save(myGameData)
	--myGameState.save(_GameData)
end

-- 单个取出
function UpdateStateBaseUtil:getBaseDataSingle(key, fileName)
	local myGameState = self:initBaseData(fileName);
	local myGameData = myGameState.load() or {}
	return myGameData[key];
end

-- 初始化
function UpdateStateBaseUtil:initBaseData(fileName)
    -- if not CEnumUpd.Environment.toReleasePhone then 
    --     fileName = fileName .. CVarUpd._static.token   
    -- end
    
	local myGameState = require("framework.cc.utils.GameState");
	myGameState.init(
		function(param)
			local returnValue = nil;
			if param.errorCode then
				-- Commons:printfLog_Info("error code:%d", param.errorCode)
			else
				-- crypto
				if param.name == "save" then
					local str = json.encode(param.values)
					if str ~= nil then -- and str ~= "" then
                        --todo最后需要  加密处理的
						str = crypto.encryptXXTEA(str, secretBodyKey)
						returnValue = {data = str}
					end
				elseif param.name == "load" then
					local str = param.values.data;
					if str ~= nil then -- and str ~= "" then
                        --todo最后需要  加密处理的
						str = crypto.decryptXXTEA(str, secretBodyKey)
						returnValue = json.decode(str)
					end
				end
			end
			return returnValue;
		end,
		fileName,
		secretKey
	)
	return myGameState;
end


-- 构造函数
function UpdateStateBaseUtil:ctor()
end


-- 必须有这个返回
return UpdateStateBaseUtil