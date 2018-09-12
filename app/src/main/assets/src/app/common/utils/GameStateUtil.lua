--
-- Author: lte
-- Date: 2016-10-11 20:15:06
-- 复杂值的保存

-- 类申明
local GameStateUtil = class("GameStateUtil")


-- 类变量申明
local secretKey = "comkl";
local secretBodyKey = "gamezp";


-- 处理方法申明
-- 批量修改
function GameStateUtil:setBaseData(_GameData, fileName)
	local myGameState = GameStateUtil:initBaseData(fileName);
	--local myGameData = myGameState.load() or {}
	--myGameData.hello = "hello world";
	--myGameState.save(myGameData)
	myGameState.save(_GameData)
end

-- 批量取出
function GameStateUtil:getBaseData(fileName)
	local myGameState = GameStateUtil:initBaseData(fileName);
	local myGameData = myGameState.load() or {}
	return myGameData;
end

-- 单个修改
function GameStateUtil:setBaseDataSingle(key, value, fileName)
	local myGameState = GameStateUtil:initBaseData(fileName);
	local myGameData = myGameState.load() or {}
	myGameData[key] = value;
	myGameState.save(myGameData)
	--myGameState.save(_GameData)
end

-- 单个取出
function GameStateUtil:getBaseDataSingle(key, fileName)
	local myGameState = GameStateUtil:initBaseData(fileName);
	local myGameData = myGameState.load() or {}
	return myGameData[key];
end

function GameStateUtil:initBaseData(fileName)
    if not CEnum.Environment.toReleasePhone then 
        fileName = fileName .. CVar._static.token   
    end
    
	local myGameState = require("framework.cc.utils.GameState");
	myGameState.init(
		function(param)
			local returnValue = nil;
			if param.errorCode then
				Commons:printfLog_Info("error code:%d", param.errorCode)
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
function GameStateUtil:ctor()
end


-- 必须有这个返回
return GameStateUtil