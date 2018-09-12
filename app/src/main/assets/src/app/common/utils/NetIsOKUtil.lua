--
-- Author: lte
-- Date: 2016-10-17 18:50:48
--  截屏图片工具类

--local base = import(".GameStateUtil")
local NetIsOKUtil = class("NetIsOKUtil", GameStateUtil)

-- 类变量申明

local Fun_Back_Data_NetIsOK; -- 通配的返回函数申明

function NetIsOKUtil:isOK(fun_back_data)
	Fun_Back_Data_NetIsOK = fun_back_data

	local st = Nets:isNetOk()
    if st == CEnum.network.NOT or st == CEnum.network.ERROE then
    	if Fun_Back_Data_NetIsOK ~= nil then
	        Fun_Back_Data_NetIsOK(CEnum.status.fail)
	    end
    else
        if Fun_Back_Data_NetIsOK ~= nil then
            Fun_Back_Data_NetIsOK(CEnum.status.success)
        end
		-- local request = network.createHTTPRequest(
  --           function(event)
		-- 	     NetIsOKUtil:onRequestFinished(event) 
  --           end, 
  --           Imgs.file_logo72, "GET")
		-- request:start()
    end
end

function NetIsOKUtil:onRequestFinished(event)
	--Commons:printLog_Info("NetIsOKUtil:onRequestFinished：", event.name)

    -- dump(event)
    local request = event.request
    local reqName = event.name

    if reqName == "completed" then
        local code = request:getResponseStatusCode()
        if code ~= 200 then
            -- 请求结束，但没有返回 200 响应代码
            Commons:printLog_Info("NetIsOKUtil:code：", code)
            if Fun_Back_Data_NetIsOK ~= nil then
                Fun_Back_Data_NetIsOK(CEnum.status.fail)
            end
            return
        end

        if Fun_Back_Data_NetIsOK ~= nil then
            Fun_Back_Data_NetIsOK(CEnum.status.success)
        end

    elseif reqName == "progress" then
        -- -- 请求过程中
        -- print("--------------11 NetIsOKUtil:progress ：", event.dltotal)
        -- if Fun_Back_Data_Voice ~= nil then
        --     fileNameShort = event.dltotal
        --     Fun_Back_Data_Voice(CEnum.status.success_progress, fileNameShort, RemoteUrl)
        -- end

    else
        -- 请求失败，显示错误代码和错误消息
        Commons:printLog_Info("NetIsOKUtil:error：", request:getErrorCode(), request:getErrorMessage())
        if Fun_Back_Data_NetIsOK ~= nil then
	        Fun_Back_Data_NetIsOK(CEnum.status.fail)
	    end
        
    end
    
end



-- 构造函数
function NetIsOKUtil:ctor()
end


-- 必须有这个返回
return NetIsOKUtil