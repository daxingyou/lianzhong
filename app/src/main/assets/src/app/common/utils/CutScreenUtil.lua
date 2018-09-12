--
-- Author: lte
-- Date: 2016-10-17 18:50:48
--  截屏图片工具类

--local base = import(".GameStateUtil")
local CutScreenUtil = class("CutScreenUtil", GameStateUtil)

-- 类变量申明
require "lfs"

local Fun_Back_Data_Img; -- 通配的返回函数申明
local needUrl

-- sd卡上查找文件是否存在
function CutScreenUtil:findFileExist(fileUrl)
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


-- 处理方法申明
--截屏代码 有一个咔嚓的动画
function CutScreenUtil:cutScreen(fun_back_data, Layer, isNeedUpload, roomNo)
	Fun_Back_Data_Img = fun_back_data

    local writablePath = device.writablePath
	local _path = "userCutImg/"
	local path = writablePath .. _path
	if not io.exists(path) then
		lfs.mkdir(path) --目录不存在，创建此目录
	end


    --local size = cc.Director:sharedDirector():getWinSize()
    local size = cc.Director:getInstance():getWinSize()
    --Commons:printLog_Info("----宽 高是：", size.width, size.height)
    local screen = cc.RenderTexture:create(size.width, size.height)--, 0)
    --local temp  = cc.Director:sharedDirector():getRunningScene()
    local temp  = cc.Director:getInstance():getRunningScene()
    screen:begin()
    temp:visit()
    screen:endToLua()

    -- 当前时间显示
    local _fileName = "share";
    local myDate = "_"..roomNo .. os.date("_%Y%m%d") -- "%Y-%m-%d %H:%M:%S"
    local fileName = _path .. _fileName .. myDate .. Imgs.file_img_suff_jpg
    local pathSave = path .. _fileName .. myDate .. Imgs.file_img_suff_jpg

    -- local function CutScreenUtil_CallBack_saveFileData_LocalUrl(isFinish)
    --     --dump(isFinish,"截屏之后是：")
    --     -- if isFinish and isNeedUpload then
    --     --     CutScreenUtil:uploadImg(fun_back_data, pathSave)
    --     -- end
    -- end
    -- -- 截屏
    -- display.captureScreen(CutScreenUtil_CallBack_saveFileData_LocalUrl, pathSave) -- 绝对路径

    local fileExist = CutScreenUtil:findFileExist(pathSave) 
    --Commons:printLog_Info("--------------", fileExist)
    if fileExist and Commons:checkIsNull_str(needUrl) then
        --Commons:printLog_Info("--------------", fileExist, needUrl)
        Fun_Back_Data_Img(needUrl)
        return
    end

    local result = screen:saveToFile(fileName, cc.IMAGE_FORMAT_PNG)
    if result then
       Commons:printLog_Info("----图片保存路径是：", pathSave)
       if isNeedUpload then
            Layer:performWithDelay(function ()
               --CutScreenUtil:uploadImg(fun_back_data, pathSave)
               needUrl = fileName
               Fun_Back_Data_Img(fileName)
            end, 1.2)
       end
       --return pathSave
    end


    --String filePath = "file:////data/data/" + s_instance.getApplicationInfo().packageName + fileName

    --[[
    -- 截屏动画
    local colorLayer1 = display.newColorLayer(cc.c4b(0, 0, 0, 125)):addTo(Layer) -- 10001
    colorLayer1:setAnchorPoint(cc.p(0, 0))
    colorLayer1:setPosition(cc.p(0, display.height))

    local colorLayer2 = display.newColorLayer(cc.c4b(0, 0, 0, 125)):addTo(Layer) -- 10001
    colorLayer2:setAnchorPoint(cc.p(0, 0))
    colorLayer2:setPosition(cc.p(0, - display.height))

    transition.moveTo(colorLayer1, {y = display.cy, time = 0.5})
    Layer:performWithDelay(function () 
    	transition.moveTo(colorLayer1, {y = display.height, time = 0.3})
    end, 0.5) 

    transition.moveTo(colorLayer2, {y = -display.cy, time = 0.5})
    Layer:performWithDelay(function () 
    	transition.moveTo(colorLayer2, {y = -display.height, time = 0.3})
    end, 0.5) 
    --]]
end

-- 上传文件
function CutScreenUtil:uploadImg(fun_back_data, pathSave) -- Layer, 
    Fun_Back_Data_Img = fun_back_data
    Commons:printLog_Info("-------------需要上传的本地路径:", pathSave)
    --pathSave = "D:/softsgame/mywork_sublime_qv36/game_beard/cutImg/share_20161122_212218.jpg"

	local datas = {
		fileFieldName = "file",
		filePath = pathSave, -- device.writablePath.."screen" .. Imgs.file_img_suff_jpg,
        --contentType = "Image/jpeg",
		contentType = "multipart/form-data",
		--extra = {
		--	{"act", "upload"},
		--	{"submit", "upload"},
		--}
	}
	local url = Https.httpUrl .. Https.url.uploadImg

    if CEnum.Environment.Current ~= nil and CEnum.Environment.Current == CEnum.EnvirType.Http then -- 正式环境
        --Commons:printLog_Info("-------------需要上传的本地路径:http:::", url)
        network.uploadFile(CutScreenUtil_CallBack_uploadData_ImgUrl, url, datas)
    else
        needUrl = "http://wmq.res.apk.yuelaigame.com/icon/guest_boy.jpg"
        Fun_Back_Data_Img(needUrl)
    end
end

-- 上传成功之后的返回对象
function CutScreenUtil_CallBack_uploadData_ImgUrl(event)
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
                --ResponseString = '{"compress":0,"data":{"picUrl":"http://192.168.1.41/images/20161121/edcada1e-5d0e-4812-a191-c2dd1cb392d0.jpg"},"msg":"成功","status":0}'
                local _dataTable = ParseBase:new():parseToJsonObj(ResponseString )
                if _dataTable ~= nil then
                    local url = _dataTable["data"]["picUrl"]
                    if url ~= nil then
                        needUrl = url
                        Fun_Back_Data_Img(url)
                    end
                end
            end
        end
    end
end



-- 构造函数
function CutScreenUtil:ctor()
end


-- 必须有这个返回
return CutScreenUtil