--
-- Author: lte
-- Date: 2016-10-11 16:27:12
--

local UpdateScene = class("UpdateScene", function()
    return display.newScene("UpdateScene")
end)


-- 常量
local UPDATE_CHECKING_VERSION = "正在检查app..."
local UPDATE_CHECKING_RES_UPDATE = "正在检查资源更新..."

local UPDATE_DOWNLOAD_PROGRESS = "正在下载资源({1}/{2})    {3}%"

local UPDATE_UPDATE_COMPLETE = "更新完成"
local UPDATE_BAD_NETWORK_MSG = "网络状况不佳，更新失败"


function UpdateScene:ctor()
    ---[[
    -- 因为有热更新，需要重新加载的文件
    -- local function removeModule(moduleName)
    --     package.loaded[moduleName] = nil
    -- end
    -- --已加载模块清理
    -- removeModule("Imgs")
    -- local writePath = cc.FileUtils:getInstance():getWritablePath()
    cc.FileUtils:getInstance():addSearchPath(device.writablePath .. CVarUpd._static.hotUpdateDataResDir)
    cc.FileUtils:getInstance():addSearchPath("res/")
    --require("app.DefineHeader")
    --]]

    -- self.osWidth = CommonsUpd.osWidth
    -- self.osHeight = CommonsUpd.osHeight
    -- CommonsUpd:printLog_Info("==login 屏幕宽", self.osWidth, "屏幕高", self.osHeight);

    self.hotupdVersion = CEnumUpd.AppVersion.versionCode
    self.hotUpdateDataObj = {}

    self.needDown_updFileList = {} -- 需要下载的文件table集合
    self.needDown_updFileALLNum = 0 -- 需要下载的总个数
    self.needDown_updFileALLSize = 0 -- 需要下载的总大小
    self.needDown_updFileNumHave = 0 -- 已经下载完成的个数
    self.needDown_updFileSizeHave = 0 -- 已经下载完成的大小

	-- 层
	self.Layer1 = display.newLayer()
    	:pos(0, 0)
    	:addTo(self)

	-- 精灵
    display.newSprite(ImgsUpd.login_bg)
    	:center()
    	:addTo(self.Layer1)

    -- 进度条

    -- 文字提示
    self.loadingTxtHint = display.newTTFLabel({
            text = UPDATE_CHECKING_VERSION,
            font = FontsUpd.Font_hkyt_w7,
            -- size = Dimens.TextSize_25,
            size = 17,
            --color = display.COLOR_WHITE,
            -- color = Colors:_16ToRGB(Colors.gameing_huxi),
            color = cc.c3b(0,0,0),
            align = cc.ui.TEXT_ALIGN_CENTER,
            valign = cc.ui.TEXT_VALIGN_CENTER,
            -- dimensions = cc.size(75,50)
        })
        :addTo(self.Layer1)
        :align(display.CENTER, display.cx-90 +570*4.5/10, display.cy-200 +45)
        :setVisible(true)

    -- 进度条背景
    self.loadingBg = cc.ui.UIImage.new(ImgsUpd.update_slider_bg,{scale9=false})
            :addTo(self.Layer1)
            :align(display.LEFT_TOP, display.cx-90 -10, display.cy-200 +30)
            :setLayoutSize(525+20, 42)
            :setVisible(false)

    -- 更新进度条
    self.loadingSlider =
    -- -- UISlider 
    -- cc.ui.UISlider.new(display.LEFT_TO_RIGHT, Imgs.Slider_Imgs_Voice, {scale9 = true, max=CVarUpd._static.clockVoiceTime, min=0})
    --     :onSliderValueChanged(function(event)
    --     end)
    --     :setSliderSize(121, 16)
    --     :setSliderValue(CVarUpd._static.clockVoiceTime)
    --     :align(display.CENTER, display.cx, display.cy-80)
    --     :addTo(myself_view)
    --     :setVisible(false)

    -- -- ProgressTimer
    -- cc.ProgressTimer:create(cc.Sprite:create(ImgsUpd.update_slider_bg_layer))  
    -- :setType(cc.PROGRESS_TIMER_TYPE_BAR) -- 条形
    -- :setMidpoint(cc.p(0,0)) --设置起点为条形坐下方  
    -- -- :setType(cc.PROGRESS_TIMER_TYPE_RADIAL) -- 圆形
    -- -- :setReverseDirection(true) --  顺时针覆盖东西=true 
    -- -- :setMidpoint(cc.p(0.5,0.5)) --设置起点为条形坐下方  
    -- :setBarChangeRate(cc.p(1,0))  --设置为竖直方向  
    -- --:setPercentage(CVarUpd._static.clockVoiceTime) -- 设置初始进度为30  

    -- UILoadingBar
    cc.ui.UILoadingBar.new({
        scale9 = true,
        capInsets = cc.rect(0,0,0,0),
        percent = 0,
        direction = 0,
        image =  ImgsUpd.update_slider_btn,
        viewRect = cc.rect(0,0,525,26),
    })

    :addTo(self.Layer1)
    --:setPosition(cc.p(bloodEmptyBgSize.width/2,bloodEmptyBgSize.height/2)) 
    :align(display.LEFT_TOP, display.cx-90, display.cy-200)
    :setVisible(false)

    --self.loadingPop_window = HotAlertLoading:popDialogBox(self.Layer1, "加载中......") 
    self.Layer1:performWithDelay(function ()
        if CEnumUpd.Environment.gotoHttpDNS then
            self:getHttpDns()
        else
            self:Update_AppIsNeedUpdate()
            -- self:Update_HotUpdateInit()
            -- self:EnterAppGame()
        end
    end, 0.1)
end

function UpdateScene:getHttpDns()
    local param = {host=HttpsUpd.DomainName}
    RequestUpdate:getHttpDns(param, function(a) self:resData_HttpDns(a) end)
end

function UpdateScene:resData_HttpDns(jsonObj)
    -- CommonsUpd:printLog_Info("resData_HttpDns====", jsonObj)
    -- print("resData_HttpDns====", type(jsonObj), jsonObj)
    -- dump(jsonObj, "resData_HttpDns:dump====")

    local _obj = jsonObj -- ParseUpdBase:parseToJsonObj(jsonObj)
    if _obj ~= nil then
        local ips = _obj['ips']
        if ips ~= nil then
            if #ips > 0 then
                if CommonsUpd:checkIsNull_str(ips[1]) then
                    CVarUpd._static.hostIp = ips[1]
                else
                    CVarUpd._static.hostIp = nil
                end
            else
                CVarUpd._static.hostIp = nil
            end
        else
            CVarUpd._static.hostIp = nil
        end
    else
        CVarUpd._static.hostIp = nil
    end
    -- print('resData_HttpDns:ipppppppppppppppp====', CVarUpd._static.hostIp)
    
    self:Update_AppIsNeedUpdate()
end

function UpdateScene:Update_AppIsNeedUpdate()
    RequestUpdate:getUpdateApp(nil, function(a) self:resData_UpdateApp(a) end )
end

function UpdateScene:resData_UpdateApp(jsonObj)
    -- CommonsUpd:printLog_Info("UpdateScene:resData_UpdateApp:::", jsonObj)

    if jsonObj~=nil then
        local status = jsonObj[ParseUpdBase.bean.status]
        local msg = RequestUpdBase:getStrDecode(jsonObj[ParseUpdBase.bean.msg])
        -- CommonsUpd:printLog_Info("状态是：", status, "内容是：", msg)

        if status ~= nil and status == CEnumUpd.status.success then
            local _data = jsonObj[ParseUpdBase.bean.data];
            if _data~=nil then
                CVarUpd._static.appstoreSwitch = _data[UpdateAppHot.Bean.versionSwitch] -- 苹果开关
                CVarUpd._static.protocolSwitch = _data[UpdateAppHot.Bean.protocolSwitch] -- 用户协议开关

                self.hotVersionBO = _data[UpdateAppHot.Bean.hotVersion] -- 热更新对象

                local newVersion = _data[UpdateAppHot.Bean.newVersion]
                if newVersion~=nil then
                    local versionCode = newVersion[UpdateAppHot.Bean.versionCode]

                    local descript = RequestUpdBase:getStrDecode(newVersion[UpdateAppHot.Bean.descript])
                    local versionName = RequestUpdBase:getStrDecode(newVersion[UpdateAppHot.Bean.versionName])
                    local apkSize = newVersion[UpdateAppHot.Bean.apkSize]
                    local upgradeType = newVersion[UpdateAppHot.Bean.upgradeType]

                    local apkDownloadUrl = RequestUpdBase:getStrDecode(newVersion[UpdateAppHot.Bean.apkDownloadUrl])

                    if CommonsUpd:checkIsNull_str(apkDownloadUrl) then -- 有下载地址，就是可以升级
                        if CommonsUpd:checkIsNull_numberType(upgradeType) then
                            -- print("------------------",upgradeType,self.Layer1,descript,versionName,apkSize,apkDownloadUrl)
                            -- print("------------------", apkDownloadUrl)
                            if 1 == upgradeType then
                                CDailogUpdateAppHot:popDialogBox(self.Layer1, descript, versionName, apkSize,  apkDownloadUrl, function(...) self.update_submitBtn('',apkDownloadUrl) end, nil)
                            elseif 2==upgradeType then
                                CDailogUpdateAppHot:popDialogBox(self.Layer1, descript, versionName, apkSize,  apkDownloadUrl, function(...) self.update_submitBtn('',apkDownloadUrl) end, function() self:Update_HotUpdateInit() end )
                            end
                            return
                        end                        
                    end
                end
            end
        end
    end

    self:Update_HotUpdateInit()
end

function UpdateScene:update_submitBtn(apkDownloadUrl)
    print("-------------", apkDownloadUrl)
    if CommonsUpd:checkIsNull_str(apkDownloadUrl) then -- 有下载地址，就是可以升级
        --CommonsUpd:printLog_Info("什么平台：：", CommonsUpd.osType)
        local function LoginScene_CallbackLua_UpdateApp(txt)
        end

        if CommonsUpd.osType == CEnumUpd.osType.A then
            local _Class= CEnumUpd.UpdateApp._Class
            local _Name = CEnumUpd.UpdateApp._Name
            local _args = { apkDownloadUrl, LoginScene_CallbackLua_UpdateApp}
            local _sig = "(Ljava/lang/String;I)V" --传入string参数，无返回值
            --local ok, ret = 
            luaj.callStaticMethod(_Class, _Name, _args, _sig) --没有返回默认nil
        elseif CommonsUpd.osType == CEnumUpd.osType.I then
            local _Class= CEnumUpd.UpdateApp_ios._Class
            local _Name = CEnumUpd.UpdateApp_ios._Name
            local _args = { downUrl=apkDownloadUrl, listener=LoginScene_CallbackLua_UpdateApp}
            --local ok, ret = 
            luaoc.callStaticMethod(_Class, _Name, _args)
        end
    end
end

function UpdateScene:Update_HotUpdateInit()
    self.fileVersion = -1
    -- 获取本地文件版本号
    local path = device.writablePath .. CVarUpd._static.hotUpdateDataTxt
    -- print("--------------------------------本地配置文件地址：", path)
    local hotUpdateDataString = HotUpdateUtil:getFile(path)
    -- print("--------------------------------本地配置文件内容：", hotUpdateDataString)
    if CommonsUpd:checkIsNull_str(hotUpdateDataString) then
        self.hotUpdateDataObj = ParseUpdBase:parseToJsonObj(hotUpdateDataString)
        -- print("--------------------------------本地配置文件内容对象：", type(self.hotUpdateDataObj), self.hotUpdateDataObj[HotUpdate.Bean.version])

        self.fileVersion = self.hotUpdateDataObj[HotUpdate.Bean.version]
    end

    if self.hotupdVersion > self.fileVersion then
        if HotUpdateUtil:checkDirOK(device.writablePath..CVarUpd._static.hotUpdateDataDir) then
            HotUpdateUtil:rmdir(device.writablePath..CVarUpd._static.hotUpdateDataDir)
        end
    else
        self.hotupdVersion = self.fileVersion
    end
    print("----------本地配置文件版本号是：", self.hotupdVersion)

    -- 根据最高的版本号去看看是否需要更新
    -- local param = {updVersion=self.hotupdVersion}
    -- RequestUpdate:getHotUpdate(param, function(jsonObj) self:getHotUpdate(jsonObj) end )

    -- 新的做法：根据这个热更新对象，去判断要不要再次热更新
    if self.hotVersionBO ~= nil then
        local hotUpdateDataTxtUrl = RequestUpdBase:getStrDecode(self.hotVersionBO[UpdateAppHot.Bean.resDownLoadUrl])
        if CommonsUpd:checkIsNull_str(hotUpdateDataTxtUrl) then
            -- 有更新地址，所以去下载最新的配置信息
            HotUpdateUtil:downLoad(function(a,b,c) self:getHotUpdate_downTxt(a,b,c) end, hotUpdateDataTxtUrl)
        else
            -- 各种结束后，再进入游戏
            self:EnterAppGame()
        end
    else
        -- 各种结束后，再进入游戏
        self:EnterAppGame()
    end
end

-- 根据本地版本号，查看是否需要下载最新配置文件
function UpdateScene:getHotUpdate(jsonObj)
    local status = jsonObj[ParseUpdBase.bean.status]
    local msg = RequestUpdBase:getStrDecode(jsonObj[ParseUpdBase.bean.msg])
    -- CommonsUpd:printLog_Info("状态是：", status, "内容是：", msg)

    if status ~= nil and status==CEnumUpd.status.success then
        local data = jsonObj[ParseUpdBase.bean.data]

        ---[[
        -- 下载文件再读取本地文件方式
        if data ~= nil and data[HotUpdate.Bean.hotUpdateDataTxtUrl] ~= nil then
            local hotUpdateDataTxtUrl = RequestUpdBase:getStrDecode( data[HotUpdate.Bean.hotUpdateDataTxtUrl] )
            print("----------配置文件的下载地址：", type(hotUpdateDataTxtUrl), hotUpdateDataTxtUrl)
            if CommonsUpd:checkIsNull_str(hotUpdateDataTxtUrl) then
                -- 有更新地址，所以去下载最新的配置信息
                HotUpdateUtil:downLoad(function(a,b,c) self:getHotUpdate_downTxt(a,b,c) end, hotUpdateDataTxtUrl)
            else
                -- 各种结束后，再进入游戏
                self:EnterAppGame()
            end
        else
            -- 各种结束后，再进入游戏
            self:EnterAppGame()
        end
        --]]
    else
        -- 各种结束后，再进入游戏
        self:EnterAppGame()
    end
end

-- 最新的配置信息 下载完成
function UpdateScene:getHotUpdate_downTxt(status, fileNameShort, RemoteUrl)
    if self.loadingPop_window~=nil and (not tolua.isnull(self.loadingPop_window)) then
        self.loadingPop_window:removeFromParent()
        self.loadingPop_window = nil
    end
    -- if self.loadingPop_window~=nil and (not tolua.isnull(self.loadingPop_window)) then
    --     self.loadingPop_window:stopAllActions()
    --     self.loadingPop_window:setVisible(false)
    -- end

    if status ~= nil and status == CEnumUpd.status.success then

        if fileNameShort~=nil then -- CommonsUpd:checkIsNull_str(fileNameShort) then
            local isOK, path, small_path = HotUpdateUtil:getUrlMd5(RemoteUrl)
            -- print("--------------------------------配置文件的下载完之后是：", isOK, path, small_path)
            if isOK then
                self.txtPath = path
                self.loadingTxtHint:setVisible(true)
                self.loadingTxtHint:setString( UPDATE_CHECKING_RES_UPDATE )
                self.Layer1:performWithDelay(function ()
                    -- 处理最新配置信息中需要处理的所有文件
                    self:getHotUpdate_dealTxt_init(fileNameShort)
                end, 1.0)
            else
                -- 下载之后，本地文件没有内容
                -- 各种结束后，再进入游戏
                self:EnterAppGame()
            end
        else
            -- 下载的文件没有内容
            -- 各种结束后，再进入游戏
            self:EnterAppGame()
        end
    elseif status ~= nil and status == CEnumUpd.status.success_progress then

    else
        -- "下载文件不成功"
        -- 各种结束后，再进入游戏
        self:EnterAppGame()
    end
end

--[[
-- 处理这些要更新的具体文件
function UpdateScene_getHotUpdate_dealZip(path)
    print("-------------------------zip的本地地址::",path)
    if CommonsUpd:checkIsNull_str(path) then
        --cc.LuaLoadChunksFromZIP(path)
        UpdateScene_getHotUpdate_UnzipFile(path) 
    end
end
--]]

--解压到某个目录
function UpdateScene:getHotUpdate_UnzipFile(_path) 
    if CEnumUpd.osType.W == CommonsUpd.osType or CEnumUpd.osType.M == CommonsUpd.osType then
        print(" UnzipFile  ")
        -- unzip test.zip -d /root/ 
        -- os.execute(" unzip \"" .. _path .."\" -d " .." res/test ")
    else
        print("-------------------------zip 解压完成在当前目录下::")
        os.execute(" unzip  -p \"" .. _path .. "\"")
    end 
end



-- 处理最新配置信息中需要处理的所有文件
function UpdateScene:getHotUpdate_dealTxt_init(jsonString)
    self.needDown_updFileList = {} -- 需要下载的文件table集合
    self.needDown_updFileALLNum = 0 -- 需要下载的总个数
    self.needDown_updFileALLSize = 0 -- 需要下载的总大小
    self.needDown_updFileNumHave = 0 -- 已经下载完成的个数
    self.needDown_updFileSizeHave = 0 -- 已经下载完成的大小

    --print("-------------------------配置文件所有内容：",jsonString)
    local jsonObj = ParseUpdBase:parseToJsonObj(jsonString)

    if CommonsUpd:checkIsNull_tableType(jsonObj) then
        self.version = jsonObj[HotUpdate.Bean.version]
        -- print("-------------------------zip下载中 最新版本号是：",self.version)

        -- 配置文件中，如果给出了最新的版本号，就去去一个个下载更新文件
        if CommonsUpd:checkIsNull_number(self.version) and self.hotupdVersion<self.version then
            local assets = jsonObj[HotUpdate.Bean.assets]
            if CommonsUpd:checkIsNull_tableList(assets) then
                self.needDown_updFileList = clone(assets) -- 把这个list复制给我们需要变更的变量中来
                self.needDown_updFileALLNum = #assets
                for k,v in pairs(assets) do
                    -- 本来全部都是下载，但是ios平台需要单独处理部分特殊文件
                    local isIOS = v[HotUpdate.Bean.isIOS]
                    if isIOS == nil or isIOS~='y' then
                        -- 任何平台都需要下载和加载
                        self.needDown_updFileALLSize = self.needDown_updFileALLSize + v[HotUpdate.Bean.size]
                    else -- isIOS==y
                        if CEnumUpd.osType.I == CommonsUpd.osType then
                            -- ios系统，就下载和加载
                            self.needDown_updFileALLSize = self.needDown_updFileALLSize + v[HotUpdate.Bean.size]
                        else
                            -- 非ios系统，就不需要下载和加载
                        end 
                    end
                end

                if self.needDown_updFileList == nil or self.needDown_updFileALLSize==0 then
                    -- 各种结束后，再进入游戏
                    self:EnterAppGame()
                end
            else
                -- 各种结束后，再进入游戏
                self:EnterAppGame()
            end
            -- print("-------------------------zip下载中 集合个数是：", #self.needDown_updFileList)
            -- print("-------------------------zip下载中 集合个数是：", self.needDown_updFileALLNum)
            -- print("-------------------------zip下载中 集合文件总大小是：", self.needDown_updFileALLSize)


            -- 要开始更新了，要开始下载文件了，开始初始化
            self.loadingBg:setVisible(true) -- 更新进度条背景
            self.loadingSlider:setVisible(true) -- 更新进度条
            -- self.loadingSlider:setPercentage(self.needDown_updFileALLSize - self.needDown_updFileSizeHave)
            -- self.loadingSlider:setPercent(0)
            -- 最新配置信息已经有了，开始删除历史文件拉
            if HotUpdateUtil:checkDirOK(device.writablePath..CVarUpd._static.hotUpdateDataResDir) then
                HotUpdateUtil:rmdir(device.writablePath..CVarUpd._static.hotUpdateDataResDir)
            end
            self.loadingTxtHint:setString( CommonsUpd:formatString(UPDATE_DOWNLOAD_PROGRESS, 0,self.needDown_updFileALLNum,0) )


            if CommonsUpd:checkIsNull_tableList(assets) then
                for k,v in pairs(assets) do
                    local path = v[HotUpdate.Bean.path]
                    local name = v[HotUpdate.Bean.name]
                    local downUrl = v[HotUpdate.Bean.downUrl]
                    print("-------------------------zip下载中 一个个文件的下载地址：", downUrl, path, name)

                    -- 本来全部都是下载，但是ios平台需要单独处理部分特殊文件
                    local tag = true
                    local isIOS = v[HotUpdate.Bean.isIOS]
                    if isIOS == nil or isIOS~='y' then
                        -- 任何平台都需要下载和加载
                        HotUpdateUtil:downLoad(function(a,b,c) self:getHotUpdate_downZip2(a,b,c) end, downUrl, path..'/', name)
                    else -- isIOS==y
                        if CEnumUpd.osType.I == CommonsUpd.osType then
                            -- ios系统，就下载和加载
                            HotUpdateUtil:downLoad(function(a,b,c) self:getHotUpdate_downZip2(a,b,c) end, downUrl, path..'/', name)
                        else
                            -- 非ios系统，就不需要下载和加载
                            tag = false
                        end 
                    end

                    if tag then
                        ------------------要启动第一个即可，后续下载，在递归中实现
                        break
                    end
                end
            end

        else
            -- 各种结束后，再进入游戏
            self:EnterAppGame()
        end

    end
end

-- 一个个来，再次下载
function UpdateScene:getHotUpdate_dealTxt_goon()
    if CommonsUpd:checkIsNull_tableList(self.needDown_updFileList) then
        for k,v in pairs(self.needDown_updFileList) do
            local path = v[HotUpdate.Bean.path]
            local name = v[HotUpdate.Bean.name]
            local downUrl = v[HotUpdate.Bean.downUrl]
            local isDownFinish = v[HotUpdate.Bean.isDownFinish]
            if isDownFinish==nil or (not isDownFinish) then
                print("-------------------------zip下载中 一个个文件的下载地址  null再次：", downUrl, path, name)
                HotUpdateUtil:downLoad(function(a,b,c) self:getHotUpdate_downZip2(a,b,c) end, downUrl, path..'/', name)
                break
            end
        end
    end
end

-- 如果有zip文件下载，就去下载zip文件，具体的更新文件集合
function UpdateScene:getHotUpdate_downZip2(status, fileNameShort, RemoteUrl)
    -- if self.loadingPop_window~=nil and (not tolua.isnull(self.loadingPop_window)) then
    --     self.loadingPop_window:removeFromParent()
    --     self.loadingPop_window = nil
    -- end
    -- if self.loadingPop_window~=nil and (not tolua.isnull(self.loadingPop_window)) then
    --     self.loadingPop_window:stopAllActions()
    --     self.loadingPop_window:setVisible(false)
    -- end

    if status ~= nil and status == CEnumUpd.status.success then
        -- print("-------------------------zip下载中 一个个文件的下载地址 第一个：", fileNameShort)
        if fileNameShort ~= nil then --CommonsUpd:checkIsNull_str(fileNameShort) then
            if CommonsUpd:checkIsNull_tableList(self.needDown_updFileList) then

                for k,v in pairs(self.needDown_updFileList) do
                    if v ~= nil and v[HotUpdate.Bean.downUrl] ~= nil and v[HotUpdate.Bean.downUrl] == RemoteUrl then
                        self.needDown_updFileNumHave = self.needDown_updFileNumHave + 1 -- 已经下载完成的个数
                        self.needDown_updFileSizeHave = self.needDown_updFileSizeHave + v[HotUpdate.Bean.size] -- 已经下载完成的大小

                        -- 下载过程
                        -- self.loadingSlider:setPercentage(self.needDown_updFileALLSize - self.needDown_updFileSizeHave)
                        self.loadingSlider:setPercent( (self.needDown_updFileSizeHave/self.needDown_updFileALLSize)*100)
                        local perCent = string.format("%.3f", self.needDown_updFileSizeHave/self.needDown_updFileALLSize)
                        perCent = tonumber(perCent) * 100
                        self.loadingTxtHint:setString( CommonsUpd:formatString(UPDATE_DOWNLOAD_PROGRESS, self.needDown_updFileNumHave,self.needDown_updFileALLNum,perCent) )

                        v[HotUpdate.Bean.isDownFinish] = true
                        
                        -- if v[HotUpdate.Bean.action]~=nil and CEnumUpd.UpdResType.unzip==v[HotUpdate.Bean.action] then
                        --     print("---------------开始解压zip资源文件，看看权限是否ok")
                        --     self:getHotUpdate_UnzipFile(fileNameShort)
                        -- end

                        break
                    end
                end

                -- 看看是不是全部下载完成
                print("-----------------------要完成了--------", #self.needDown_updFileList)
                --if CommonsUpd:checkIsNull_tableList(self.needDown_updFileList) then
                local tag = true
                for k,v in pairs(self.needDown_updFileList) do
                    print("-----------------------22 要完成了--------", v[HotUpdate.Bean.isDownFinish])
                    if v ~= nil and v[HotUpdate.Bean.isDownFinish] ~= nil and (not v[HotUpdate.Bean.isDownFinish]) then
                        tag = false
                        -- break
                    elseif v ~= nil and v[HotUpdate.Bean.isDownFinish] == nil then
                        tag = false
                        -- break    
                    end

                    -- 本来全部都是下载，但是ios平台需要单独处理部分特殊文件
                    if not tag then
                        local isIOS = v[HotUpdate.Bean.isIOS]
                        if isIOS == nil or isIOS~='y' then
                            -- 任何平台都需要下载和加载
                            tag = false
                            break
                        else -- isIOS==y
                            if CEnumUpd.osType.I == CommonsUpd.osType then
                                -- ios系统，就下载和加载
                                tag = false
                                break
                            else
                                -- 非ios系统，就不需要下载和加载
                                tag = true
                            end 
                        end
                    end
                end

                -- 全部下载ok，进入游戏
                print("-----------------------33 要完成了--------", tag)
                if tag then
                    -- 覆盖本地的配置文件信息
                    if CommonsUpd:checkIsNull_str(self.txtPath) then
                        HotUpdateUtil:filecopy1(self.txtPath, device.writablePath..CVarUpd._static.hotUpdateDataTxt)
                    end
                    if self.version ~= nil then
                        CEnumUpd.AppVersion.versionCode = self.version
                    end

                    self.loadingTxtHint:setString( UPDATE_UPDATE_COMPLETE )
                    -- 各种结束后，再进入游戏
                    self:EnterAppGame()
                else
                    -- 只要有一个没有下载完成，就继续下载，本身就是队列下载，一个个来
                    self:getHotUpdate_dealTxt_goon()
                end
                --end

            end
        else
            -- if CommonsUpd:checkIsNull_tableList(self.needDown_updFileList) then
            --     for k,v in pairs(self.needDown_updFileList) do
            --         if v ~= nil and v[HotUpdate.Bean.downUrl] ~= nil and v[HotUpdate.Bean.downUrl] == RemoteUrl then
            --             v[HotUpdate.Bean.isDownFinish] = false
            --             break
            --         end
            --     end
            -- end
        end
    elseif status ~= nil and status == CEnumUpd.status.success_progress then
        -- print("-------------------------------------------------", fileNameShort)

        -- if fileNameShort ~= nil then --CommonsUpd:checkIsNull_str(fileNameShort) then
        --     self.needDown_updFileSizeHave = self.needDown_updFileSizeHave + fileNameShort -- 已经下载完成的大小
        --     -- 下载过程
        --     -- self.loadingSlider:setPercentage(self.needDown_updFileALLSize - self.needDown_updFileSizeHave)
        --     self.loadingSlider:setPercent( (self.needDown_updFileSizeHave/self.needDown_updFileALLSize)*100)
        --     local perCent = string.format("%.3f", self.needDown_updFileSizeHave/self.needDown_updFileALLSize)
        --     perCent = tonumber(perCent) * 100
        --     self.loadingTxtHint:setString( CommonsUpd:formatString(UPDATE_DOWNLOAD_PROGRESS, self.needDown_updFileNumHave,self.needDown_updFileALLNum,perCent) )
        -- end

    else
        -- if CommonsUpd:checkIsNull_tableList(self.needDown_updFileList) then
        --     for k,v in pairs(self.needDown_updFileList) do
        --         if v ~= nil and v[HotUpdate.Bean.downUrl] == RemoteUrl then
        --             v[HotUpdate.Bean.isDownFinish] = false
        --             break
        --         end
        --     end
        -- end
    end

end

-- function UpdateScene:reload_module(module_name)
--     local old_module = _G[module_name]

--     package.loaded[module_name] = nil
--     require (module_name)

--     local new_module = _G[module_name]
--     for k,v in pairs(new_module) do
--         old_module[k] = v
--     end

--     package.loaded[module_name] = old_module
-- end

-- 各种结束后，再进入游戏
function UpdateScene:EnterAppGame()
    print("----------准备进入游戏了")

    if not CommonsUpd:checkIsNull_tableList(self.needDown_updFileList) then
        local version = self.hotUpdateDataObj[HotUpdate.Bean.version]
        if version ~= nil then
            CEnumUpd.AppVersion.versionCode = version
        end

        -- 本次没有做任何更新，应该读取旧的更新
        --if self.fileVersion > -1 then
            if self.hotUpdateDataObj ~= nil then
                local assets = self.hotUpdateDataObj[HotUpdate.Bean.assets]
                if CommonsUpd:checkIsNull_tableList(assets) then
                    self.needDown_updFileList = clone(assets)
                end
            end
        --end
    end

    print("----------最后确认的版本号是：", CEnumUpd.AppVersion.versionCode)

    if CommonsUpd:checkIsNull_tableList(self.needDown_updFileList) then
        for k,v in pairs(self.needDown_updFileList) do
            if v ~= nil then
                local path = v[HotUpdate.Bean.path]
                local name = v[HotUpdate.Bean.name]
                local downUrl = v[HotUpdate.Bean.downUrl]
                local isDownFinish = v[HotUpdate.Bean.isDownFinish]
                local action = v[HotUpdate.Bean.action]

                -- if isDownFinish~=nil and action~=nil and isDownFinish and CEnumUpd.UpdResType.load==action then
                if action~=nil and CEnumUpd.UpdResType.load==action then
                    print("---------------进入了 22：action：", action)
                    print("---------------进入了 22：path：", path)
                    print("---------------进入了 22：name：", name)

                    local uu = device.writablePath .. CVarUpd._static.hotUpdateDataDir .. path .. '/' .. name
                    -- CVarUpd._static.hotUpdateDataDir .. path .. '/' .. name
                    --path .. '/' .. name
                    -- uu = string.gsub(uu, '/', '\\')
                    -- print("---------------进入了 22：uu 路径：", uu)

                    -- print("---------------进入了 33：name fullPathForFilename：", cc.FileUtils:getInstance():fullPathForFilename(name) )
                    -- print("---------------进入了 33：getSearchPaths：", cc.FileUtils:getInstance():getSearchPaths() )

                    -- -- cc.LuaLoadChunksFromZIP(uu)
                    -- print( "--------------看看是否加载成功：", cc.LuaLoadChunksFromZIP(uu) )

                    -- -- cc.LuaLoadChunksFromZIP(uu)
                    -- print( "--------------看看是否加载成功：", cc.LuaLoadChunksFromZIP(uu) )

                    -- 本来全部都是下载，但是ios平台需要单独处理部分特殊文件
                    if isIOS == nil or isIOS~='y' then
                        -- 任何平台都需要下载和加载
                        cc.LuaLoadChunksFromZIP(uu)
                        -- print( "--------------n 看看是否加载成功：", cc.LuaLoadChunksFromZIP(uu) )
                    else -- isIOS==y
                        if CEnumUpd.osType.I == CommonsUpd.osType then
                            -- ios系统，就下载和加载
                            cc.LuaLoadChunksFromZIP(uu)
                            -- print( "--------------y-ios 看看是否加载成功：", cc.LuaLoadChunksFromZIP(uu) )
                        else
                            -- 非ios系统，就不需要下载和加载
                        end 
                    end

                    --[[
                        -- 因为有热更新，需要重新加载的文件
                        local function removeModule(moduleName)
                            package.loaded[moduleName] = nil
                            -- HomeScene = require(moduleName)
                        end
                        --已加载模块清理
                        removeModule("app.common.res.CommonsUpd")
                    --]]
                end
            end
        end
    end

    self.Layer1:performWithDelay(function () 
        -- CommonsUpd:gotoLogin()
        -- CommonsUpd:gotoSplash()

        require("app.MyApp").new():run()
        UpdateScene:onExit()

    end, 1.0)
end

function UpdateScene:onEnter()
end

function UpdateScene:onExit()
    -- CommonsUpd:printLog_Info("UpdateScene:onExit")
    -- self:removeAllChildren()

    -- if loadingTxtHint ~= nil and (not tolua.isnull(loadingTxtHint)) then
    --     loadingTxtHint:removeFromParent()
    --     loadingTxtHint = nil
    -- end

    -- if Layer1 ~= nil and (not tolua.isnull(Layer1)) then
    --     Layer1:removeFromParent()
    --     Layer1 = nil
    -- end
end

return UpdateScene