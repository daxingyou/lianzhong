--
-- Author: lte
-- Date: 2016-10-11 20:15:06
-- 单个的简单保存  --todo android手机保存不了这个文件

-- 类申明
local UserDefaultUtil = class("UserDefaultUtil")


-- 类变量申明
-- key的申明
local secretKey = "comkl";

UserDefaultUtil.var = 
{	
	currSoundsVolume = "currSoundsVolume", -- 音效
	currMusicVolume = "currMusicVolume", -- 背景音乐

	currStopSounds = "currStopSounds", -- 音效
	currStopMusic = "currStopMusic", -- 背景音乐
}


-- 处理方法申明
function UserDefaultUtil:setData(key,value)
	local userDef = cc.UserDefault:getInstance()
	if type(value) == "string" then
		userDef:setStringForKey(key, value);
		--userDef:setStringForKey(key, crypto.encryptXXTEA(value, secretKey));
		--userDef:setStringForKey(key, string.urlencode(value));
	elseif type(value) == "boolean" then
		userDef:setBoolForKey(key, value);
	elseif type(value) == "number" then
		userDef:setDoubleForKey(key, value);
	end
	userDef:flush();
	--return true;
end

function UserDefaultUtil:getData(key,defValue)
	local userDef = cc.UserDefault:getInstance()
	if type(defValue) == "string" then
		local value = userDef:getStringForKey(key, defValue);
		return value;
		--return crypto.decryptXXTEA(value, secretKey);
		--return string.urldecode(value);
	elseif type(defValue) == "boolean" then
		return userDef:getBoolForKey(key, defValue);
	elseif type(defValue) == "number" then
		userDef:getDoubleForKey(key, defValue);
	end
end


-- 构造函数
function UserDefaultUtil:ctor()
end


-- 必须有这个返回
return UserDefaultUtil