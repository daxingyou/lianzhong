--
-- Author: lte
-- Date: 2016-10-17 18:50:48
--  截屏图片工具类

local HotUpdateUtil = class("HotUpdateUtil")

require "lfs"

-- 文件夹是否存在
function HotUpdateUtil:isDirExist(path)
    local success, msg = lfs.chdir(path)
    return success
end

-- 文件是否存在
function HotUpdateUtil:isFileExist(path)
    return cc.FileUtils:getInstance():isFileExist(path)
end

-- 创建指定目录所有文件夹 
function HotUpdateUtil:mkdir(path)
    --print("mkdir " .. tostring(path) .. "|"..device.directorySeparator) -- device.directorySeparator = \ 这个符号
    if path ~= nil then
    	path = string.gsub(path, '/', '\\')
    end

    if not HotUpdateUtil:isDirExist(path) then
        local prefix = ""
        if string.sub(path, 1, 1) == device.directorySeparator then
            prefix = device.directorySeparator
        end
        local pathInfo = string.split(path, device.directorySeparator)
        local i = 1
        while(true) do
            if i > #pathInfo then
                break
            end
            local p = string.trim(pathInfo[i] or "")
            if p == "" or p == "." then
                table.remove(pathInfo, i)
            elseif p == ".." then
                if i > 1 then
                    table.remove(pathInfo, i)
                    table.remove(pathInfo, i - 1)
                    i = i - 1
                else
                    return false
                end
            else
                i = i + 1
            end
        end
        for i = 1, #pathInfo do
            local curPath = prefix .. table.concat(pathInfo, device.directorySeparator, 1, i) .. device.directorySeparator
            if not HotUpdateUtil:isDirExist(curPath) then
                --print("mkdir " .. curPath)
                local succ, err = lfs.mkdir(curPath)
                if not succ then 
                    -- print("mkdir " .. path .. " failed, " .. err)
                    return false
                end
            else
                --print(curPath, "exists")
            end
        end
    end
    -- print("done mkdir " .. tostring(path))
    return true
end

-- 强制删除某目录下 所有文件夹和文件 
function HotUpdateUtil:rmdir(path)
    -- print("rmdir " .. path)
    if HotUpdateUtil:isDirExist(path) then
        local function _rmdir(path)
            local iter, dir_obj = lfs.dir(path)
            while true do
                local dir = iter(dir_obj)
                if dir == nil then break end
                if dir ~= "." and dir ~= ".." then
                    local curDir = path..dir
                    local mode = lfs.attributes(curDir, "mode") 
                    if mode == "directory" then
                        _rmdir(curDir.."/")
                    elseif mode == "file" then
                        --print("remove file ", curDir)
                        os.remove(curDir)
                    end
                end
            end
            --print("rmdir ", path)
            local succ, des = lfs.rmdir(path)
            if not succ then print("remove dir " .. path .. " failed, " .. des) end
            return succ
        end
        _rmdir(path)
    end
    -- print("done rmdir " .. path)
    return true
end

-- 读取某个文件
function HotUpdateUtil:readFile(path)
    local file = io.open(path, "rb")
    if file then
        local content = file:read("*all")
        io.close(file)
        return content
    end
    return nil
end

-- 删除某个文件
function HotUpdateUtil:removeFile(path)
    io.writefile(path, "")
    if device.platform == "windows" then
        os.execute("del " .. string.gsub(path, '/', '\\'))
    else
        os.execute("rm " .. path)
    end
end

-- 判断是否有目录
function HotUpdateUtil:checkDirOK( path )
    local oldpath = lfs.currentdir()
    -- print("old path------> ".. oldpath)
    if lfs.chdir(path) then
        lfs.chdir(oldpath)
        -- print("11 path check OK------> ".. path)
        return true
    end

    if lfs.mkdir(path) then
        -- print("22 path create OK------> ".. path)
        return true
    end
end

-- 判断是否有文件  是否合法
function HotUpdateUtil:checkFile(fileName, cryptoCode)
    if not io.exists(fileName) then
        return false
    end

    local data=HotUpdateUtil:readFile(fileName)
    if data==nil then
        return false
    end

    if cryptoCode=="nil" or cryptoCode == "" or cryptoCode == nil then
        return true
    end
    local ms = crypto.md5file(fileName)
    if ms==cryptoCode then
        return true
    end

    return false
end




-- sd卡上查找文件是否存在
function HotUpdateUtil:findFileExist(fileUrl)
    if fileUrl ~= nil then
        if io.exists(fileUrl) then
            --CommonsUpd:printLog_Info("img这个文件存在")
            return true
        else
            --CommonsUpd:printLog_Info("img不存在")
            return false
        end
    else
        return false
    end
end

--拷贝文件的第二种方法，不会乱行
-- 获取文件，读取文件
function HotUpdateUtil:getFile(file_name)
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
function HotUpdateUtil:write_content(fileName, content)
    -- local f = assert(io.open(fileName, 'w'))
    local f = io.open(fileName, 'w')
    if f then
	    f:write(content)
	    f:close()
	else
	end
end

-- 复制文件  字符文件
function HotUpdateUtil:filecopy1(source, destination)
    local stt = HotUpdateUtil:getFile(source)
    HotUpdateUtil:write_content(destination, stt)
end


--[[
-- 复制文件
function HotUpdateUtil:fileCopyImg(source, destination)
    local stt = HotUpdateUtil:getFile(source)
    HotUpdateUtil:write_content_Img(destination, stt)

    -- HotUpdateUtil:write_content_Img(source, destination)
end

-- 写入
function HotUpdateUtil:write_content_Img(fileName, content)
    -- io.writefile(fileName, content, "w+b")

    -- local f = assert(io.open(fileName, 'w'))
    local f = io.open(fileName, 'w+b')
    if f then
	    f:write(content)
	    f:close()
	else

	end
end

-- 复制文件
function HotUpdateUtil:fileCopyImgExe(source, destination)
    -- os.execute('cp -r '..source..' '..dest)

    local sourcefile = io.open(source,'rb')
	local destinationfile = io.open(destination,'wb')
	for line in sourcefile:lines() do
		destinationfile:write(line)
	end
	sourcefile:close()
	destinationfile:close()
end
--]]

-- 创建指定目录所有文件夹 
function HotUpdateUtil:mkdir_MoreDir(path)
    --print("mkdir " .. tostring(path) .. "|"..device.directorySeparator) -- device.directorySeparator = \ 这个符号

    local pathS
    if path ~= nil then
        pathS = string.split(path, "/")
    end

    -- print('--------------------需要创建的目录文件个数是：',#pathS)
    if pathS~=nil and type(pathS)=="table" then
        local pp = ''
        for k,v in pairs(pathS) do
            if v~=nil and v~='' then
                pp = pp .. v .. '/'
                -- print("-----------需要创建的目录文件是：", pp)
                if not io.exists(device.writablePath..pp) then
                    lfs.mkdir(device.writablePath..pp) --目录不存在，创建此目录
                end
            end
        end
    end
end




local GameData_UpdData = {}
function HotUpdateUtil:getUrlMd5(RemoteUrl, localPath, localFileName)	
	local tempMd5 = crypto.md5(RemoteUrl) -- 文件名

	-- 绝对路径
	local path = device.writablePath .. CVarUpd._static.hotUpdateDataDir
    local path2 = CVarUpd._static.hotUpdateDataDir
	if CommonsUpd:checkIsNull_str(localPath) then
		path = device.writablePath .. CVarUpd._static.hotUpdateDataDir .. localPath
        path2 = CVarUpd._static.hotUpdateDataDir .. localPath
    else
	end

	-- print("------------------------要建立的目录是：", path)
	-- if path ~= nil then
    -- 	path = string.gsub(path, '/', '\\')
    -- end
	-- if not io.exists(path) then
	-- 	lfs.mkdir(path) --目录不存在，创建此目录
	-- end

	-- 多层文件夹的创建
	-- HotUpdateUtil:mkdir(path)

    HotUpdateUtil:mkdir_MoreDir(path2)

	-- 相对路径
	local filePathNameShort = CVarUpd._static.hotUpdateDataDir .. tempMd5
	if CommonsUpd:checkIsNull_str(localFileName) then
		filePathNameShort = CVarUpd._static.hotUpdateDataDir .. localPath .. localFileName -- tempMd5
	end

	-- 绝对路径 文件名
	local filePathName = path .. tempMd5
    if CommonsUpd:checkIsNull_str(localFileName) then
        filePathName = path .. localFileName -- tempMd5
    end

	local fileExist = HotUpdateUtil:findFileExist(filePathName)

	GameData_UpdData = UpdateStateUtil_dataFile:getData()
    if GameData_UpdData.netSprite == nil then --判断本地保存数据是否存在
        GameData_UpdData.netSprite = {} --如果不存在，先创建netSprite数组，保存
        --GameState.save(GameData_UpdData)
        UpdateStateUtil_dataFile:setData(GameData_UpdData)
	else
        for i=1,#(GameData_UpdData.netSprite) do
            if GameData_UpdData.netSprite[i] == tempMd5 and fileExist then
                return true, filePathName, filePathNameShort --存在，返回本地存储文件完整路径
            end
        end
	end
	return false, filePathName, filePathNameShort --不存在，返回将要存储的文件路径备用
end

function HotUpdateUtil:setUrlMd5(isOvertime, RemoteUrl)
	if not isOvertime then --如果不是超时
        local tempMd5 = crypto.md5(RemoteUrl) -- 文件名
		table.insert(GameData_UpdData.netSprite, tempMd5) --保存下载后的文件MD5值
		--GameState.save(GameData_UpdData)
		UpdateStateUtil_dataFile:setData(GameData_UpdData)
	end
end

function HotUpdateUtil:downLoad(fun_back_data, RemoteUrl, localPath, localFileName)
	self.Fun_Back_Data_Voice = fun_back_data
	local isExist, fileName, fileNameShort = HotUpdateUtil:getUrlMd5(RemoteUrl, localPath, localFileName)
    -- CommonsUpd:printLog_Info("HotUpdateUtil:createSprite fileName：", isExist, fileName, fileNameShort)
	-- print("--------------11 HotUpdateUtil:createSprite fileName：", isExist, fileName, fileNameShort)

	if isExist then --如果存在，直接更新纹理
		--self:updateTexture(fileName)
		-- 直接播放
		if self.Fun_Back_Data_Voice ~= nil then
			fileNameShort = HotUpdateUtil:getFile(fileName)
			self.Fun_Back_Data_Voice(CEnumUpd.status.success, fileNameShort, RemoteUrl)
		end

	else --如果不存在，启动http下载
		--[[
		if network.getInternetConnectionStatus() == cc.kCCNetworkStatusNotReachable then
			CommonsUpd:printLog_Info("not net")
			return
		end
		--]]
		--[[
		if Nets:new():isNetOk() == CEnumUpd.NOT then
			--CommonsUpd:printLog_Info("not net")
			return
		end
		--]]
		--CommonsUpd:printLog_Info("HotUpdateUtil:createSprite：url=", RemoteUrl)
		local request = network.createHTTPRequest(function(event)
			HotUpdateUtil:onRequestFinished(event, fileName, fileNameShort, RemoteUrl, localPath, localFileName)end, RemoteUrl, "GET")
		request:start()
	end
end

function HotUpdateUtil:onRequestFinished(event, fileName, fileNameShort, RemoteUrl, localPath, localFileName)
    -- CommonsUpd:printLog_Info("HotUpdateUtil:onRequestFinished fileName：", fileName, fileNameShort, RemoteUrl)
    -- print("--------------11 HotUpdateUtil:event.name--", event.name, fileName, fileNameShort, RemoteUrl)

    -- local newFileName = fileName
    -- if CommonsUpd:checkIsNull_str(localFileName) then
    --     newFileName = device.writablePath..CVarUpd._static.hotUpdateDataDir..localPath..localFileName
    -- end

    -- dump(event)
    local request = event.request
    local reqName = event.name

    if reqName == "completed" then
        -- 这个只有一次
        local code = request:getResponseStatusCode()
        -- print("--------------11 HotUpdateUtil:code：", code)
        if code ~= 200 then
            -- 请求结束，但没有返回 200 响应代码
            -- CommonsUpd:printLog_Info("HotUpdateUtil:code：", code)
            if self.Fun_Back_Data_Voice ~= nil then
                fileNameShort = nil
                self.Fun_Back_Data_Voice(CEnumUpd.status.fail, fileNameShort, RemoteUrl)
            end
            return
        end

        -- 请求成功，显示服务端返回的内容
        -- local response = request:getResponseString()
        --CommonsUpd:printLog_Info(response)
        
        --保存下载数据到本地文件，如果不成功，重试5次。
        -- print("--------------11 HotUpdateUtil:写入文件？？？")
        local times = 1 
        while (not request:saveResponseData(fileName)) and times < 15 do
            times = times + 1
        end
        local isOvertime = (times == 5) --是否超时
        HotUpdateUtil:setUrlMd5(isOvertime, RemoteUrl) --保存md5

        --self:updateTexture(fileName) --更新纹理
        -- 直接播放
        if self.Fun_Back_Data_Voice ~= nil then
            -- if CommonsUpd:checkIsNull_str(localFileName) then
            --  os.rename(fileName, newFileName)
            --  -- HotUpdateUtil:fileCopyImg(fileName, newFileName)
            -- end

            fileNameShort = HotUpdateUtil:getFile(fileName)
            -- print("--------------11 成功后的:code：", fileNameShort, RemoteUrl)
            self.Fun_Back_Data_Voice(CEnumUpd.status.success, fileNameShort, RemoteUrl)
        end

    elseif reqName == "progress" then
        -- -- 请求过程中
        -- print("--------------11 HotUpdateUtil:progress ：", event.dltotal)
        -- if self.Fun_Back_Data_Voice ~= nil then
        --     fileNameShort = event.dltotal
        --     self.Fun_Back_Data_Voice(CEnumUpd.status.success_progress, fileNameShort, RemoteUrl)
        -- end

    else
        -- 请求失败
        -- CommonsUpd:printLog_Info("HotUpdateUtil:error：", request:getErrorCode(), request:getErrorMessage())
        -- print("--------------11 HotUpdateUtil:error：", request:getErrorCode(), request:getErrorMessage())

        if self.Fun_Back_Data_Voice ~= nil then
            fileNameShort = nil
            self.Fun_Back_Data_Voice(CEnumUpd.status.fail, fileNameShort, RemoteUrl)
        end

    end
end



-- 构造函数
function HotUpdateUtil:ctor()
end


-- 必须有这个返回
return HotUpdateUtil