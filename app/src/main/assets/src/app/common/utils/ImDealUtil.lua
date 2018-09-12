--
-- Author: lte
-- Date: 2016-10-17 18:50:48
--  截屏图片工具类

--local base = import(".GameStateUtil")
local ImDealUtil = class("ImDealUtil", GameStateUtil)

-- 类变量申明
require "lfs"

local Fun_Back_Data_Voice; -- 通配的返回函数申明
local needUrl

-- sd卡上查找文件是否存在
function ImDealUtil:findFileExist(fileUrl)
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
function ImDealUtil:getFile(file_name)
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
function ImDealUtil:write_content(fileName, content)
    -- local f = assert(io.open(fileName, 'w'))
    local f = io.open(fileName, 'w')
    if f then
        f:write(content)
        f:close()
    else
    end
end

-- 复制文件
function ImDealUtil:filecopy1(source, destination)
    local stt = ImDealUtil:getFile(source)
    ImDealUtil:write_content(destination, stt)
end

-- 上传文件
function ImDealUtil:uploadVoice(fun_back_data, pathSave)
    Fun_Back_Data_Voice = fun_back_data
    Commons:printLog_Info("-----------voice--需要上传的本地路径:", pathSave)
    --pathSave = "D:/softsgame/mywork_sublime_qv36/game_beard/cutImg/share_20161122_212218.jpg"
    --local pathSaveCopy = ""

    if pathSave ~= nil then
    else
    	pathSave = device.writablePath.."flyvoice.wav"
        --pathSaveCopy = device.writablePath.."flyvoiceCopy.wav"

        --ImDealUtil:filecopy1(pathSave, pathSaveCopy)
    end

	local datas = {
		fileFieldName = "file",
		filePath = pathSave, 
        --contentType = "Image/jpeg",
		contentType = "multipart/form-data",
		--extra = {
		--	{"act", "upload"},
		--	{"submit", "upload"},
		--}
	}
	local url = Https.httpUrl .. Https.url.uploadVoice

    if CEnum.Environment.Current ~= nil and CEnum.Environment.Current == CEnum.EnvirType.Http then -- 正式环境
        --Commons:printLog_Info("-------------需要上传的本地路径:http:::", url)
        network.uploadFile(ImDealUtil_CallBack_uploadData_ImgUrl, url, datas)
    else
        needUrl = "http://res.iwoapp.com/audios/20150621/29079338-392c-47fc-8d0f-5bedfcf524eb.wav"
        Fun_Back_Data_Voice(needUrl)
    end
end

-- 上传成功之后的返回对象
function ImDealUtil_CallBack_uploadData_ImgUrl(event)
    --dump(event, "上传中的对象是：")
    if event.name == "completed" then
        local request = event.request
        if request ~= nil then
            --dump(request, "上传完成之后的request对象是：")
            --Commons:printfLog_Info("REQUEST getResponseStatusCode() = %d", request:getResponseStatusCode() )
            --Commons:printfLog_Info("REQUEST getResponseHeadersString() =\n%s", request:getResponseHeadersString() )
            --Commons:printfLog_Info("REQUEST getResponseDataLength() = %d", request:getResponseDataLength() )
            --Commons:printfLog_Info("REQUEST getResponseString() =\n%s", request:getResponseString() )
            if request:getResponseString() ~= nil then
                local ResponseString = string.format("%s", request:getResponseString() )
                --Commons:printfLog_Info("REQUEST getResponseString() =", ResponseString, type(ResponseString))
                --ResponseString = '{"compress":0,"data":{"audioUrl":"http://192.168.1.41/images/20161121/edcada1e-5d0e-4812-a191-c2dd1cb392d0.jpg"},"msg":"成功","status":0}'
                local _dataTable = ParseBase:new():parseToJsonObj(ResponseString )
                if _dataTable ~= nil then
                    local url = _dataTable["data"]["audioUrl"]
                    if url ~= nil then
                        needUrl = url
                        Fun_Back_Data_Voice(url)
                    end
                end
            end
        end
    end
end




local GameData_Voice = {}
function ImDealUtil:getUrlMd5(RemoteUrl)	
	local tempMd5 = crypto.md5(RemoteUrl)
	local path = device.writablePath.."userFlyvoice/"
	local fileNameShort = "userFlyvoice/" .. tempMd5
	local fileExist = ImDealUtil:findFileExist(path..tempMd5)

	if not io.exists(path) then
		lfs.mkdir(path) --目录不存在，创建此目录
	end

	GameData_Voice = GameState_VoiceFile:getData()
    if GameData_Voice.netSprite == nil then --判断本地保存数据是否存在
        GameData_Voice.netSprite = {} --如果不存在，先创建netSprite数组，保存
        --GameState.save(GameData_Voice)
        GameState_VoiceFile:setData(GameData_Voice)
	else
        for i=1,#(GameData_Voice.netSprite) do
            if GameData_Voice.netSprite[i] == tempMd5 and fileExist then
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

function ImDealUtil:setUrlMd5(isOvertime, RemoteUrl)
	if not isOvertime then --如果不是超时
		table.insert(GameData_Voice.netSprite, crypto.md5(RemoteUrl)) --保存下载后的文件MD5值
		--GameState.save(GameData_Voice)
		GameState_VoiceFile:setData(GameData_Voice)
	end
end

function ImDealUtil:downLoad(fun_back_data, RemoteUrl, seatNo)
	Fun_Back_Data_Voice = fun_back_data
	local isExist,fileName,fileNameShort = ImDealUtil:getUrlMd5(RemoteUrl)
	Commons:printLog_Info("ImDealUtil:createSprite fileName：", fileName)
	if isExist then --如果存在，直接更新纹理
		--self:updateTexture(fileName)
		-- 直接播放
		if Fun_Back_Data_Voice ~= nil then
			Fun_Back_Data_Voice(CEnum.status.success, fileNameShort, seatNo, RemoteUrl)
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
		--Commons:printLog_Info("ImDealUtil:createSprite：url=", RemoteUrl)
		local request = network.createHTTPRequest(function(event)
			ImDealUtil:onRequestFinished(event, fileName, fileNameShort, RemoteUrl, seatNo)end, RemoteUrl, "GET")
		request:start()
	end
end

function ImDealUtil:onRequestFinished(event, fileName, fileNameShort, RemoteUrl, seatNo)
	--Commons:printLog_Info("ImDealUtil:onRequestFinished：", event.name )
    Commons:printLog_Info("ImDealUtil:onRequestFinished fileName：", fileName, fileNameShort, RemoteUrl, seatNo)

    -- dump(event)
    local request = event.request
    local reqName = event.name

    if reqName == "completed" then
        local code = request:getResponseStatusCode()
        if code ~= 200 then
            -- 请求结束，但没有返回 200 响应代码
            Commons:printLog_Info("ImDealUtil:code：", code)
            if Fun_Back_Data_Voice ~= nil then
                Fun_Back_Data_Voice(CEnum.status.fail, fileNameShort, seatNo, RemoteUrl)
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
        ImDealUtil:setUrlMd5(isOvertime, RemoteUrl) --保存md5

        --self:updateTexture(fileName) --更新纹理
        -- 直接播放
        if Fun_Back_Data_Voice ~= nil then
            Fun_Back_Data_Voice(CEnum.status.success, fileNameShort, seatNo, RemoteUrl)
        end

    elseif reqName == "progress" then
        -- -- 请求过程中
        -- print("--------------11 ImDealUtil:progress ：", event.dltotal)
        -- if Fun_Back_Data_Voice ~= nil then
        --     fileNameShort = event.dltotal
        --     Fun_Back_Data_Voice(CEnum.status.success_progress, fileNameShort, RemoteUrl)
        -- end

    else
        Commons:printLog_Info("ImDealUtil:error：", request:getErrorCode(), request:getErrorMessage())
        if Fun_Back_Data_Voice ~= nil then
	        Fun_Back_Data_Voice(CEnum.status.fail, fileNameShort, seatNo, RemoteUrl)
	    end

    end
    
end



-- 构造函数
function ImDealUtil:ctor()
end


-- 必须有这个返回
return ImDealUtil