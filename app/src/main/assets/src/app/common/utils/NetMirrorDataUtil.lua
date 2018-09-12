--
-- Author: lte
-- Date: 2016-10-17 18:50:48
--  截屏图片工具类

--local base = import(".GameStateUtil")
local NetMirrorDataUtil = class("NetMirrorDataUtil", GameStateUtil)

-- 类变量申明
require "lfs"

local Fun_Back_Data_Voice; -- 通配的返回函数申明
local needUrl

-- sd卡上查找文件是否存在
function NetMirrorDataUtil:findFileExist(fileUrl)
    if fileUrl ~= nil then
        if io.exists(fileUrl) then
            --Commons:printLog_Info("img这个文件存在")
            return true
        else
            --Commons:printLog_Info("img不存在")
            return false
        end
    else
        return false
    end
end

--拷贝文件的第二种方法，不会乱行
-- 获取文件，读取文件
function NetMirrorDataUtil:getFile(file_name)
    -- local f = assert(io.open(file_name, 'r'))
    local f = io.open(file_name, 'r')
    if f then
        local string = f:read("*all")
        f:close()
        return string
    else
        return nil
    end
end

-- 写入
function NetMirrorDataUtil:write_content(fileName, content)
    -- local f = assert(io.open(fileName, 'w'))
    local f = io.open(fileName, 'w')
    if f then
        f:write(content)
        f:close()
    else
    end
end

-- 复制文件
function NetMirrorDataUtil:filecopy1(source, destination)
    local stt = NetMirrorDataUtil:getFile(source)
    NetMirrorDataUtil:write_content(destination, stt)
end




local GameData_MirrorData = {}
function NetMirrorDataUtil:getUrlMd5(RemoteUrl)	
	local tempMd5 = crypto.md5(RemoteUrl)
	local path = device.writablePath.."userMirrorData/"
	local fileNameShort = "userMirrorData/" .. tempMd5
	local fileExist = NetMirrorDataUtil:findFileExist(path..tempMd5)

	if not io.exists(path) then
		lfs.mkdir(path) --目录不存在，创建此目录
	end

	GameData_MirrorData = GameState_MirrorDataFile:getData()
    if GameData_MirrorData.netSprite == nil then --判断本地保存数据是否存在
        GameData_MirrorData.netSprite = {} --如果不存在，先创建netSprite数组，保存
        --GameState.save(GameData_MirrorData)
        GameState_MirrorDataFile:setData(GameData_MirrorData)
	else
        for i=1,#(GameData_MirrorData.netSprite) do
            if GameData_MirrorData.netSprite[i] == tempMd5 and fileExist then
                return true,path..tempMd5,fileNameShort --存在，返回本地存储文件完整路径
            end
        end
	end
	return false,path..tempMd5,fileNameShort --不存在，返回将要存储的文件路径备用

    -- if fileExist then
    --     return true,path..tempMd5,fileNameShort --存在，返回本地存储文件完整路径
    -- else
    --     return false,path..tempMd5,fileNameShort --不存在，返回将要存储的文件路径备用
    -- end
end

function NetMirrorDataUtil:setUrlMd5(isOvertime, RemoteUrl)
	if not isOvertime then --如果不是超时
		table.insert(GameData_MirrorData.netSprite, crypto.md5(RemoteUrl)) --保存下载后的文件MD5值
		--GameState.save(GameData_MirrorData)
		GameState_MirrorDataFile:setData(GameData_MirrorData)
	end
end

function NetMirrorDataUtil:downLoad(fun_back_data, RemoteUrl)
	Fun_Back_Data_Voice = fun_back_data
	local isExist,fileName,fileNameShort = NetMirrorDataUtil:getUrlMd5(RemoteUrl)
	Commons:printLog_Info("NetMirrorDataUtil:createSprite fileName：", fileName)
	if isExist then --如果存在，直接更新纹理
		--self:updateTexture(fileName)
		-- 直接播放
		if Fun_Back_Data_Voice ~= nil then
			fileNameShort = NetMirrorDataUtil:getFile(fileName)
			Fun_Back_Data_Voice(CEnum.status.success, fileNameShort, RemoteUrl)
		end

	else --如果不存在，启动http下载
		--[[
		if network.getInternetConnectionStatus() == cc.kCCNetworkStatusNotReachable then
			Commons:printLog_Info("not net")
			return
		end
		--]]
		--[[
		if Nets:new():isNetOk() == CEnum.NOT then
			--Commons:printLog_Info("not net")
			return
		end
		--]]
		--Commons:printLog_Info("NetMirrorDataUtil:createSprite：url=", RemoteUrl)
		local request = network.createHTTPRequest(function(event)
			NetMirrorDataUtil:onRequestFinished(event, fileName, fileNameShort, RemoteUrl)end, RemoteUrl, "GET")
		request:start()
	end
end

function NetMirrorDataUtil:onRequestFinished(event, fileName, fileNameShort, RemoteUrl)
	--Commons:printLog_Info("NetMirrorDataUtil:onRequestFinished：", event.name )
    Commons:printLog_Info("NetMirrorDataUtil:onRequestFinished fileName：", fileName, fileNameShort, RemoteUrl)

    -- dump(event)
    local request = event.request
    local reqName = event.name

    if reqName == "completed" then
        local code = request:getResponseStatusCode()
        if code ~= 200 then
            -- 请求结束，但没有返回 200 响应代码
            Commons:printLog_Info("NetMirrorDataUtil:code：", code)
            if Fun_Back_Data_Voice ~= nil then
                fileNameShort = nil
                Fun_Back_Data_Voice(CEnum.status.fail, fileNameShort, RemoteUrl)
            end
            return
        end

        -- 请求成功，显示服务端返回的内容
        -- local response = request:getResponseString()
        --Commons:printLog_Info(response)
        
        --保存下载数据到本地文件，如果不成功，重试5次。
        local times = 1 
        while (not request:saveResponseData(fileName)) and times < 15 do
            times = times + 1
        end
        local isOvertime = (times == 5) --是否超时
        NetMirrorDataUtil:setUrlMd5(isOvertime, RemoteUrl) --保存md5

        --self:updateTexture(fileName) --更新纹理
        -- 直接播放
        if Fun_Back_Data_Voice ~= nil then
            fileNameShort = NetMirrorDataUtil:getFile(fileName)
            Fun_Back_Data_Voice(CEnum.status.success, fileNameShort, RemoteUrl)
        end

    elseif reqName == "progress" then
        -- -- 请求过程中
        -- print("--------------11 NetMirrorDataUtil:progress ：", event.dltotal)
        -- if Fun_Back_Data_Voice ~= nil then
        --     fileNameShort = event.dltotal
        --     Fun_Back_Data_Voice(CEnum.status.success_progress, fileNameShort, RemoteUrl)
        -- end

    else
        -- 请求失败，显示错误代码和错误消息
        Commons:printLog_Info("NetMirrorDataUtil:error：", request:getErrorCode(), request:getErrorMessage())
        if Fun_Back_Data_Voice ~= nil then
        	fileNameShort = nil
	        Fun_Back_Data_Voice(CEnum.status.fail, fileNameShort, RemoteUrl)
	    end

    end
    
end



-- 构造函数
function NetMirrorDataUtil:ctor()
end


-- 必须有这个返回
return NetMirrorDataUtil