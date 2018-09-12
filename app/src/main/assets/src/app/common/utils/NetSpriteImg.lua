--
-- Author: lte
-- Date: 2016-10-18 11:19:20
-- 图片下载类

local NetSpriteImg = class("NetSpriteImg",function()
	return display.newSprite()
end)
--local NetSpriteImg = class("NetSpriteImg", cc.ui.UIImage)

require "lfs"
local GameData = {}
--local GameState = require("framework.cc.utils.GameState");
local needShowWidth,needShowHeight


--[[
-- 取出sd卡文件
function NetSpriteImg:getFile(file_name)
	local f = assert(io.open(file_name, 'r'))
	local string = f:read("*all")
	f:close()
	return string
end
-- 给sd卡写入文件
function NetSpriteImg:write_content(fileName,content)
	local f = assert(io.open(fileName, 'w'))
	f:write(content)
	f:close()
end
-- 拷贝文件
function NetSpriteImg:fileCopy(source,destination)
    local _source = self:getFile(source)
    self:write_content(destination, _source)
end
--]]

--[[
--拷贝文件的第三种方法 会乱行
function NetSpriteImg:fileCopy3(source,destination)
	sourcefile = io.open(source,'rb')
	destinationfile = io.open(destination,'wb')
	for line in sourcefile:lines() do
		destinationfile:write(line)
	end
	sourcefile:close()
	destinationfile:close()
end
--]]

--[[
--拷贝文件的第一种方法，不会用，执行linux系统的命令行
function NetSpriteImg:fileCopy1(src,dest)
	if src==nil or dest==nil or src=='' or dest=='' then
		return false
	end

	local src_fs=io.open(src,'rb')
	if src_fs~=nil then
		--os.execute('cmd /c copy /y '..src..' '..dest)
		os.execute('cp -b'..src..' '..dest)	
		local dest_fs=io.open(dest,'rb')
		if dest_fs==nil then
			return false
		else
			return true
		end
	end
end
--]]

-- sd卡上查找文件是否存在
function NetSpriteImg:findFileExist(fileUrl)
	if fileUrl ~= nil then
		if io.exists(fileUrl) then
			--Commons:printLog_Info("img这个文件存在")
			return true
		else
			Commons:printLog_Info("img不存在")
			return false
		end
	else
		return false
	end
end

function NetSpriteImg:ctor(url,_needShowWidth,_needShowHeight)--创建NetSpriteImg
	needShowWidth = _needShowWidth
	needShowHeight = _needShowHeight
	self.path = device.writablePath.."userNetImg/" --获取本地存储目录
	if not io.exists(self.path) then
		lfs.mkdir(self.path) --目录不存在，创建此目录
	end
	self.url  = url
	self:createSprite()
end

function NetSpriteImg:getUrlMd5()
	--[[
	local suffix = ".jpg";
	local suffix_start,suffix_end = string.find(self.url, ".png")
	Commons:printLog_Info("png suffix::", suffix_start, suffix_end)
	if suffix_start ~= nil and suffix_end ~= nil then
		suffix = ".png";
	else
		suffix_start,suffix_end = string.find(self.url, ".PNG")
		Commons:printLog_Info("PNG suffix::", suffix_start, suffix_end)
		if suffix_start ~= nil and suffix_end ~= nil then
			suffix = ".png";
		else
			suffix_start,suffix_end = string.find(self.url, ".bmp")
			Commons:printLog_Info("bmp suffix::", suffix_start, suffix_end)
			if suffix_start ~= nil and suffix_end ~= nil then
				suffix = ".bmp";
			else
				suffix_start,suffix_end = string.find(self.url, ".BMP")
				Commons:printLog_Info("BMP suffix::", suffix_start, suffix_end)
				if suffix_start ~= nil and suffix_end ~= nil then
					suffix = ".BMP";
				end
			end
		end
	end
	--]]
	
	local tempMd5 = crypto.md5(self.url)
	local fileExist = NetSpriteImg:findFileExist(self.path..tempMd5)

	GameData = GameStateNetImg:new():getData()
    if GameData.netSprite == nil then --判断本地保存数据是否存在
        GameData.netSprite = {} --如果不存在，先创建netSprite数组，保存
        --GameState.save(GameData)
        GameStateNetImg:new():setData(GameData)
	else
        for i=1,#(GameData.netSprite) do
            if GameData.netSprite[i] == tempMd5 and fileExist then
                return true,self.path..tempMd5 --存在，返回本地存储文件完整路径
            end
        end
	end
	return false,self.path..tempMd5 --不存在，返回将要存储的文件路径备用

	-- if fileExist then
 --        return true,self.path..tempMd5 --存在，返回本地存储文件完整路径
 --    else
 --        return false,self.path..tempMd5 --不存在，返回将要存储的文件路径备用
 --    end
end

function NetSpriteImg:setUrlMd5(isOvertime)
	if not isOvertime then --如果不是超时
		table.insert(GameData.netSprite,crypto.md5(self.url)) --保存下载后的文件MD5值
		--GameState.save(GameData)
		GameStateNetImg:new():setData(GameData)
	end
end

function NetSpriteImg:createSprite()
	local isExist,fileName = self:getUrlMd5()
	Commons:printLog_Info("NetSpriteImg:createSprite fileName：", fileName)
	if isExist then --如果存在，直接更新纹理
		self:updateTexture(fileName) 
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
		--Commons:printLog_Info("NetSpriteImg:createSprite：url=", self.url )
		local request = network.createHTTPRequest(function(event)
			self:onRequestFinished(event,fileName)end, self.url, "GET")
		request:start()
	end
end

function NetSpriteImg:onRequestFinished(event,fileName)
	--Commons:printLog_Info("NetSpriteImg:onRequestFinished：", event.name )
    Commons:printLog_Info("NetSpriteImg:onRequestFinished fileName：", fileName )

    -- dump(event)
    local request = event.request
    local reqName = event.name

    if reqName == "completed" then
    	local code = request:getResponseStatusCode()
	    if code ~= 200 then
	        -- 请求结束，但没有返回 200 响应代码
	        Commons:printLog_Info("NetSpriteImg:code：", code)
	        return
	    end

	    -- 请求成功，显示服务端返回的内容
	    local response = request:getResponseString()
	    --Commons:printLog_Info(response)
	    
	    --保存下载数据到本地文件，如果不成功，重试5次。
	    local times = 1 
	    while (not request:saveResponseData(fileName)) and times < 15 do
	    	times = times + 1
	    end
	    local isOvertime = (times == 5) --是否超时
	    self:setUrlMd5(isOvertime) --保存md5
	    self:updateTexture(fileName) --更新纹理

    elseif reqName == "progress" then
    	-- -- 请求过程中
        -- print("--------------11 NetSpriteImg:progress ：", event.dltotal)
        -- if Fun_Back_Data_Voice ~= nil then
        --     fileNameShort = event.dltotal
        --     Fun_Back_Data_Voice(CEnum.status.success_progress, fileNameShort, RemoteUrl)
        -- end

    else
        -- 请求失败，显示错误代码和错误消息
        Commons:printLog_Info("NetSpriteImg:error：", request:getErrorCode(), request:getErrorMessage())

    end
    
end

---[[
function NetSpriteImg:updateTexture(fileName)
	local sprite = display.newSprite(fileName) --创建下载成功的sprite
	if not sprite then return end
	local texture = sprite:getTexture()--获取纹理
	local size = texture:getContentSize()
	self:setTexture(texture)--更新自身纹理
	self:setContentSize(size)
	self:setTextureRect(cc.rect(0,0,size.width,size.height))
	if needShowWidth ~= nil then
        --self:scaleTo(0.1, 0.5)
		self:setScaleX(needShowWidth/size.width)
	end
	if needShowHeight ~= nil then
	    self:setScaleY(needShowHeight/size.height)
	end
end
--]]

--[[
function NetSpriteImg:updateTexture(fileName)
	local sprite = cc.ui.UIImage.new(fileName,{});
	--sprite:setLayoutSize(110, 100);
	if not sprite then return end
	local texture = sprite:getTexture()--获取纹理
	local size = texture:getContentSize()
	self:setTexture(texture)--更新自身纹理
	self:setContentSize(size)
	self:setTextureRect(cc.rect(0,0,size.width,size.height))
end
--]]

return NetSpriteImg