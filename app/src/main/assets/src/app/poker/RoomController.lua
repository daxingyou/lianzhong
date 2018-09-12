--[
--	Author: wh
-- Date: 2017-05-08 19:40:54
--房间总控
--
--]
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
local RoomController = class("RoomController")

-- local self.top_scheduler
-- local self.top_schedulerID_network
-- local self.top_schedulerID_network_status = nil
-- local self.isMyManual = false -- 是不是我手动关闭socket，true=是手动关闭，就不需要重连，否则就是可以重连
-- local self.isConnected_sockk_time -- 和服务器可以连接的时间点记录
local osWidth = Commons.osWidth
local osHeight = Commons.osHeight

function RoomController:ctor( scene )

    -- 初始化全局变量
    self.isMyManual = false -- 是不是需要重连socket服务，true=是手动关闭 就不需要重连，否则就是需要重连

    -- 加载所有重要的模块
	cc(self):addComponent("components.behavior.EventProtocol"):exportMethods()

	local ctx = {}
    ctx.scene = scene
    ctx.roomController = self
    ctx.model = RoomModel.new(ctx)
    ctx.roomPlayerManager = RoomPlayerManager.new() -- 玩家头像，座位
    ctx.mycardView = MycardView.new() -- 自己的牌
    ctx.roomTopOprationManager = RoomTopOprationManager.new() --顶部操作及显示
    ctx.statusManager = StatusManager.new()
    ctx.outcardManager = OutcardManager.new(30)
    ctx.leftCardManager = LeftCardManager.new(30)
    ctx.readyControl = ReadyControl.new()
    ctx.outCardControl = OutCardControl.new()
    ctx.weChatInviteControl = WeChatInviteControl.new()
    ctx.animManager = AnimManager.new()

	ctx.export = function(target)
        if target ~= ctx.model then
            target.ctx = ctx    --不是model元素 都绑定一个ctx
            for k, v in pairs(ctx) do
                if k ~= "export" and v ~= target then --每个ctx的元素也保存一份，但不保存export函数，自己本身也不保存
                    target[k] = v
                end
            end
        else
            rawset(target, "ctx", ctx) --设置ctx.model.ctx = ctx
            for k, v in pairs(ctx) do
                if k ~= "export" and v ~= target then
                    rawset(target, k, v)
                end
            end
        end
        return target
    end
    ctx.export(self)
    ctx.export(ctx.outcardManager)
    ctx.export(ctx.mycardView)
    ctx.export(ctx.roomPlayerManager)
    ctx.export(ctx.roomTopOprationManager)
    ctx.export(ctx.animManager)
    ctx.export(ctx.statusManager)
    ctx.export(ctx.readyControl)
    ctx.export(ctx.outCardControl)
    ctx.export(ctx.weChatInviteControl)
    ctx.export(ctx.leftCardManager)
end

-- 网络发生改变，直接就关闭socket来重连了
function RoomController:NetIsOK_change()

    if not self.isMyManual then
        if self.roomTopOprationManager.topRule_view_noConnectServer ~= nil and (not tolua.isnull(self.roomTopOprationManager.topRule_view_noConnectServer)) then
            self.roomTopOprationManager.topRule_view_noConnectServer:setString(Strings.gameing.noConnectServer)
            self.roomTopOprationManager.topRule_view_noConnectServer:setVisible(true)
        end
        self.closeSocket()
    end
    -- if CVar._static.mSocket ~= nil then
    --     CVar._static.mSocket:CloseSocket()
    -- end
end

function RoomController:createNodes()

    self:createLoading() -- 正在加载、连接socket动画

    self.mycardView:addTo(self.scene)
	self.roomPlayerManager:createNodes()
	self.roomTopOprationManager:createNodes()
    self.outcardManager:createNodes()
    self.leftCardManager:createNodes()
    self.statusManager:createNodes()


    -- 控制层
    local yCoord = 265
    -- 准备按钮
    self.readyControl
        :addTo(self.scene)
        :pos(display.width/2,yCoord)
        :setDelegate(self)
    -- 提示和出牌按钮
    self.outCardControl
        :addTo(self.scene)
        :pos(display.width/2,yCoord)
        :setDelegate(self)
    -- 邀请按钮
    self.weChatInviteControl
        :addTo(self.scene)
        :pos(display.width/2, display.cy)-- yCoord-70 +100)
        :setDelegate(self)

    -- 动画管理
    self.animManager:createNodes()

    -- 出牌错误的提示
    self.testTxt = display.newTTFLabel({
        text = "",
        font = Fonts.Font_hkyt_w9,
        size = Dimens.TextSize_20,
        color = display.COLOR_WHITE,
        align = cc.ui.TEXT_ALIGN_LEFT,
        dimensions = cc.size(320,20)
    })
    :addTo(self.scene)
    :center()

    -- 调试使用的日志打印
    if self.errorInfo_ == nil then
        self.errorInfo_ = display.newTTFLabel({
            text = "",
            -- font = "Arial.ttf",
            size = 20,
            -- x = display.cx,
            -- y = display.cy,
            color=cc.c3b(0x00, 0x00, 0x00),
            align = cc.ui.TEXT_ALIGN_LEFT,
            valign = cc.ui.TEXT_VALIGN_CENTER,
            dimensions = cc.size(display.width, display.height)
        })
        :addTo(self.scene, 9999)
        :align(display.CENTER, display.cx, display.cy)
        :hide()
    end
    -- if self.errorInfo_ then
    --     if CEnum and (not CEnum.Environment.screenPrintLog) then
    --         self.errorInfo_:show()
    --     else
    --         self.errorInfo_:hide()
    --     end
    -- end

    --楼下塞一通假数据。。
    -- self.roomTopOprationManager:setRoomId(234213)
    -- self.roomTopOprationManager:setTable(3,10)

    -- self.statusManager:dealPassOut({preSeatId__ = 2})
    -- self.statusManager:dealReady({preSeatId__ = 3})
    -- self.statusManager:dealReady({preSeatId__ = 1})

    -- self.outcardManager:showOutCard({preSeatId__ = 2,preOutCards = {0x01,0x13,0x23,0x04,0x15,0x05,0x03,0x03,0x03,0x03}})
    -- self.outcardManager:showOutCard({preSeatId__ = 1,preOutCards = {0x01,0x13,0x23,0x04,0x15,0x05,0x03}})
    -- self.outcardManager:showOutCard({preSeatId__ = 3,preOutCards = {0x01,0x13,0x23,0x04,0x15,0x05,0x03}})

    -- self.outCardControl:exec(1)
    -- self.readyControl:exec()

    -- socket处理
    self:createSocket()

    -- 测试环境才增加这个键盘事件监控
    if CEnum.Environment.Current~=nil and CEnum.Environment.Current==CEnum.EnvirType.Test then
        self.scene:setKeypadEnabled(true)
        self.scene:addNodeEventListener(cc.KEYPAD_EVENT, handler(self,self.myKeypad))

        -- self:testNodeClick()
    end

    ---[[
    -- 启动定时扫描，看看是否需要重连
    self.top_scheduler = self.scene:getScheduler()
    local function RoomController_listeningNetwork()

        -- NetIsOKUtil:isOK(function(...) GameingScene:NetIsOK(...) end) -- 这个里面包含了网络类型判断 和 一个固定url的读取

        -- 客户端发心跳，找服务器，三次没有响应，就重连
        --GameingScene:NetIsOK_Xintiao()
        -- SocketRequestGameing:gameing_Xintiao_send()

        local _changeNet = false
        local st = Nets:isNetOk()
        if self.top_schedulerID_network_status ~= nil and self.top_schedulerID_network_status == st then
            -- 没有切换网络模式
        elseif self.top_schedulerID_network_status ~= nil and self.top_schedulerID_network_status ~= st then
            _changeNet = true
            -- 切换了网络模式
            -- 去重连接，并且告知用户在重连
            self:NetIsOK_change()
        else
            -- 初始值
            self.top_schedulerID_network_status = st
        end

        if not _changeNet then
            --local nowDate = tonumber(os.date(CEnum.timeFormat.ymdhms) .. "" )
            --local nowDate = tonumber(socketCCC.gettime() )
            --Commons:printLog_Info("----tt 现在的时间是 字符串的：", os.time(), type(os.time()))
            local nowDate = os.time()

            Commons:printLog_Info("----tt 现在的时间是：", nowDate, type(nowDate))
            if self.isConnected_sockk_time ~= nil then
                Commons:printLog_Info("----tt 变化的的时间是：", self.isConnected_sockk_time, type(self.isConnected_sockk_time))
                local gaping_time = nowDate - self.isConnected_sockk_time
                Commons:printLog_Info("----tt 相差多久：", gaping_time, type(gaping_time))
                if gaping_time >= 10 then
                    -- 只要有数据过来，我就改变记录这个时间点
                    self.isConnected_sockk_time = os.time()
                    self:NetIsOK_change()
                end
            end
        end
    end
    Commons:printLog_Info("--gameing 什么平台：：", Commons.osType)
    if Commons.osType == CEnum.osType.A or Commons.osType == CEnum.osType.I 
        --or Commons.osType == CEnum.osType.W
        then
        self.top_schedulerID_network = self.top_scheduler:scheduleScriptFunc(RoomController_listeningNetwork, 4, false) -- **秒一次
        Commons:printLog_Info("----A I 监听网络状态 这个计时器：", self.top_schedulerID_network)
    elseif CEnum.Environment.Current~=nil and CEnum.Environment.Current==CEnum.EnvirType.Test then
        -- self.top_schedulerID_network = self.top_scheduler:scheduleScriptFunc(RoomController_listeningNetwork, 4, false) -- **秒一次
        -- Commons:printLog_Info("----test 监听网络状态 这个计时器：", self.top_schedulerID_network)
    end
    --]]
end

--ui操作
function RoomController:doUIControlAction(action,data)
    local result = false

    if action == CEnumP.CLIENT_UI_ACTION.ready then
        SocketRequestGameing:gameing_Prepare()

    elseif action == CEnumP.CLIENT_UI_ACTION.cardTip then
       if self.tipsIndex_==0 then
            self.tipCardsArr = self.model:getTipCard()
       end

       if not self.tipCardsArr or #self.tipCardsArr<1 then
            --没牌可打
            local playerAction = self.model:getAction()
            local actionNo
            if playerAction then
                actionNo = playerAction.actionNo
            end
            self.animManager:playNotCard()
       else
           self.tipsIndex_ = self.tipsIndex_+1
           if self.tipsIndex_>#self.tipCardsArr  then
                self.tipsIndex_ = 1
           end
           local tempCard = self.tipCardsArr[self.tipsIndex_]
           local cards = self.model:getClientCardsByServer(tempCard)
           self.mycardView:tipsBigCard(cards)
       end

    elseif action == CEnumP.CLIENT_UI_ACTION.outCard then
        local outList = self.mycardView:getWillOutCard()
        --dump(outList,"客户端选择牌")

        if self.model:isMeOutCard() then
            if outList and #outList>0 then
                local sendList = self.model:getServerCardsByClient(outList)
                --dump(sendList,"客户端发送出牌")
                PDKSocketGameing:gameing_Chu(sendList)
            end
        end

    elseif action == CEnumP.CLIENT_UI_ACTION.weChatInvite or action == CEnumP.CLIENT_UI_ACTION.weChatInviteTxt then

            local myself_invite_title
            local myself_invite_content = ""
            local maxPlayer = self.model:getRoomInfo().maxPlayer
            local currentPlayer = #self.model:getPlayerList()

            local roomData = GameStateUserGameing:getData()

            if roomData.rounds == CEnumP.round._10 then
                myself_invite_content=myself_invite_content..' '..CEnumP.round._10info
            elseif roomData.rounds == CEnumP.round._20  then
                myself_invite_content=myself_invite_content..' '..CEnumP.round._20info
            elseif roomData.rounds == CEnumP.round._30  then
                myself_invite_content=myself_invite_content..' '..CEnumP.round._30info
            end

            if roomData.playType == CEnumP.wf._1 then -- "16" then
                myself_invite_content=myself_invite_content..' '..CEnumP.wf._1info -- "16张玩法"
            elseif roomData.playType == CEnumP.wf._2 then -- "15" then
                myself_invite_content=myself_invite_content..' '..CEnumP.wf._2info -- "15张玩法"
            else
                myself_invite_content=myself_invite_content..' '..CEnumP.wf._3info --"随机抽玩法"
            end

            if roomData.lastRule == CEnumP.leftHand._1 then -- "limit" then
                myself_invite_content=myself_invite_content..' '..CEnumP.leftHand._1info -- " 三张全带"
            else
                myself_invite_content=myself_invite_content..' '..CEnumP.leftHand._2info -- " 三张任意带"
            end

            if roomData.birdRule == CEnumP.zhaNiao._1 then -- "n" then
                myself_invite_content=myself_invite_content..' '..CEnumP.zhaNiao._1info -- " 不扎鸟"
            else
                myself_invite_content=myself_invite_content..' '..CEnumP.zhaNiao._2info -- " 红桃10扎鸟"
            end

            if roomData.isDisplay == CEnumP.showCard._1 then -- "y" then
                myself_invite_content=myself_invite_content..' '..CEnumP.showCard._1info -- " 显示牌"
            else
                myself_invite_content=myself_invite_content..' '..CEnumP.showCard._2info -- " 不显示牌"
            end

            if maxPlayer == 3 then
                myself_invite_content=myself_invite_content..' '..CEnumP.person._3info -- " 3个人"

                if maxPlayer-currentPlayer == 1 then
                    myself_invite_title = " "..CEnumP.shareTitle._2 -- 二缺一
                elseif maxPlayer-currentPlayer == 2 then
                    myself_invite_title = " "..CEnumP.shareTitle._1 -- 一缺二
                end
            else
                myself_invite_content=myself_invite_content..' '..CEnumP.person._2info -- " 2个人"

                if maxPlayer-currentPlayer == 1 then
                    myself_invite_title = " "..CEnumP.shareTitle._3 -- 一缺一
                end
            end
            -- if myself_invite_title == nil then return end

            local _title = Strings.app_name_pdk.." 房间号["..CVar._static.roomNo.."] "..myself_invite_title
            local _content = "房间号["..CVar._static.roomNo.."]，"..myself_invite_content..myself_invite_title.."，速度来玩！"
            Commons:printLog_Req("====分享的_title是：", _title, '\n')
            Commons:printLog_Req("====分享的_content是：", _content, '\n')

            if action == CEnumP.CLIENT_UI_ACTION.weChatInvite then
                Commons:gotoShareWX(_title, _content)
            else
	            local function CDAlertIP_CopyTxt_CallbackLua(txt)
	                CDAlert.new():popDialogBox(self.scene, txt)
	            end
	            Commons:gotoCopyContent(CDAlertIP_CopyTxt_CallbackLua, _content)
            end

    end

    return result
end

--连接服务器
function RoomController:createSocket()
    self:closeSocket()

    local SockMsg = import("app.common.net.socket.SocketMsg")
    self.socket_ = SockMsg.new()
    self.socket_:Connect(Sockets.connect.ip, Sockets.connect.port, function(...) self:resDataSocket(...) end )
    CVar._static.mSocket = self.socket_
end

--关闭服务器
function RoomController:closeSocket()
    if CVar._static.mSocket ~= nil then
        CVar._static.mSocket:CloseSocket()
        CVar._static.mSocket = nil
        self.socket_ = nil
    end
end

--服务端接手数据
function RoomController:resDataSocket(status, jsonString)
    local res_status
    local res_msg
    local res_cmd
    local res_data
    local receive_res_data = ParseBase:parseToJsonObj(jsonString)

    -- socket数据转换
    if receive_res_data~=nil then
        res_status = receive_res_data[ParseBase.status];
        res_msg = RequestBase:getStrDecode(receive_res_data[ParseBase.msg]);
        res_cmd = receive_res_data[ParseBase.cmd];
        res_data = receive_res_data[ParseBase.data];

        local res_cmd_str = "null cmd"
        if res_cmd then
            res_cmd_str = res_cmd
        end

        -- 只要有数据过来，我就改变记录这个时间点
        self.isConnected_sockk_time = os.time()

        if res_cmd ~= Sockets.cmd.gameing_Xintiao_down then
            Commons:printLog_SocketReq("==pdkGameing_resDataSocket:", jsonString)
            Commons:printLog_SocketReq("==pdkGameing_resDataSocket: status", res_status)
            Commons:printLog_SocketReq("==pdkGameing_resDataSocket: msg", res_msg)
            Commons:printLog_SocketReq("==pdkGameing_resDataSocket: cmd", res_cmd)
            -- Commons:printLog_SocketReq("==pdkGameing_resDataSocket: data", res_data)

            -- if self.errorInfo_ then
            --     self.errorInfo_:setString("cmd="..res_cmd_str.."  status="..res_status.."  res_msg="..res_msg)
            -- end
        else
           -- Commons:printLog_SocketReq("----tt GameingScene_resDataSocket: status", res_status)
        end

        if res_cmd == nil and status == EnStatus.connected_receiveData then
            -- if self.errorInfo_ then
            --     self.errorInfo_:setString("==== ==== 空cmd ==== ====")
            -- end
            if not self.isMyManual then
                if CVar._static.mSocket~=nil and CVar._static.mSocket:getConnected() then
                    if self.roomTopOprationManager.topRule_view_noConnectServer ~= nil and (not tolua.isnull(self.roomTopOprationManager.topRule_view_noConnectServer)) then
                        self.roomTopOprationManager.topRule_view_noConnectServer:setString(Strings.gameing.noConnectServer..'!')
                        self.roomTopOprationManager.topRule_view_noConnectServer:setVisible(true)
                    end
                    if CEnum.Environment.Current ~= nil and CEnum.Environment.Current == CEnum.EnvirType.Http then -- 正式环境
                        SocketRequestGameing:refreshRoom()
                    end
                else
                    self:NetIsOK_change() -- 重连
                end
            end
        end
    else
        if status == EnStatus.connected_receiveData then
            -- if self.errorInfo_ then
            --     self.errorInfo_:setString("==== ==== 空包 ==== ====")
            -- end
            if not self.isMyManual then
                if self.roomTopOprationManager.topRule_view_noConnectServer ~= nil and (not tolua.isnull(self.roomTopOprationManager.topRule_view_noConnectServer)) then
                    self.roomTopOprationManager.topRule_view_noConnectServer:setString(Strings.gameing.noConnectServer..'?')
                    self.roomTopOprationManager.topRule_view_noConnectServer:setVisible(true)
                end
                if CVar._static.mSocket~=nil and CVar._static.mSocket:getConnected() then
                    if CEnum.Environment.Current ~= nil and CEnum.Environment.Current == CEnum.EnvirType.Http then -- 正式环境
                        SocketRequestGameing:refreshRoom()
                    end
                else
                    self:NetIsOK_change() -- 重连
                end
            end
        end
    end

    -- socket连接正常
    if status == EnStatus.connected_succ then
        if self.loadingSpriteAnim~=nil and (not tolua.isnull(self.loadingSpriteAnim)) then
            self.loadingSpriteAnim:stopAllActions()
            self.loadingSpriteAnim:setVisible(false)
        end

        self.isMyManual = false
        if self.roomTopOprationManager.topRule_view_noConnectServer ~= nil and (not tolua.isnull(self.roomTopOprationManager.topRule_view_noConnectServer)) then
            self.roomTopOprationManager.topRule_view_noConnectServer:setVisible(false)
        end
        -- 连接上了socket，直接记录最新网络状态
        self.top_schedulerID_network_status = Nets:isNetOk()

        -- 我的游戏房间信息
        self.userGameing = GameStateUserGameing:getData()
        -- self.user_roomNo = self.userGameing[Room.Bean.roomNo]
        if CEnum.Environment.Current ~= nil and CEnum.Environment.Current == CEnum.EnvirType.Http then -- 正式环境
            SocketRequestGameing:loginRoom(CVar._static.Lge, CVar._static.Lat)
        end

    -- socket连接失败
    elseif status == EnStatus.connected_fail or status == EnStatus.connected_closed then
        if not self.isMyManual then
            if self.roomTopOprationManager.topRule_view_noConnectServer ~= nil and (not tolua.isnull(self.roomTopOprationManager.topRule_view_noConnectServer)) then
                self.roomTopOprationManager.topRule_view_noConnectServer:setString(Strings.gameing.noConnectServer)
                self.roomTopOprationManager.topRule_view_noConnectServer:setVisible(true)
            end
            scheduler.performWithDelayGlobal(function () 
                self:createSocket() -- 一直重连接
            end, 1.0)
        end
    -- elseif status == EnStatus.connected_closed then

    -- 有数据来拉
    elseif status == EnStatus.connected_receiveData then
        
        if CEnum.status.success == res_status then
            
            -- 只要有成功数据，重连字样消失
            self.isMyManual = false
            if self.roomTopOprationManager.topRule_view_noConnectServer ~= nil and (not tolua.isnull(self.roomTopOprationManager.topRule_view_noConnectServer)) then
                self.roomTopOprationManager.topRule_view_noConnectServer:setVisible(false)
            end 

            -- 登录房间
            if res_cmd == Sockets.cmd.loginRoom or res_cmd==Sockets.cmd.refreshRoom then
                self:clearCurTableStatus() -- 清理桌面
                self:readyClearTable() -- 准备之后的主动清理操作

                self.model:parseLogin(receive_res_data)
                local roomdata = self.model:getRoomInfo()
                self.roomTopOprationManager:init(self.userGameing)
                -- self.roomTopOprationManager:init(roomdata)
                self.roomTopOprationManager:setRoomId(roomdata.roomNo)
                self.roomTopOprationManager:setTable(roomdata.playRound, roomdata.rounds)
                self.roomPlayerManager:init()
                self.roomPlayerManager:upDatePlayerStatus()

                -- 本人手牌处理
                local myCardList = self.model:getMyHandCards()

                -- if res_cmd == Sockets.cmd.refreshRoom then
                --     -- dump(myCardList, "myCardList==")
                --     if myCardList then
                --         local tempServerList = RoomModel:getServerCardsByClient(myCardList)
                --         local handCard = ""
                --         for k,v in pairs(tempServerList) do
                --             handCard = handCard..v..'，'
                --         end
                --         if self.errorInfo_ then
                --             self.errorInfo_:setString("refresh过，手牌是："..handCard)
                --         end
                --     end
                -- end

                if #myCardList>0 then
                    self.mycardView:clearAllCard()
                    self.mycardView:setCard(myCardList)
                else
                    self.mycardView:clearAllCard()
                end

                -- 房间处于创建状态的时候处理，也=刚开始进入的时候处理
                if roomdata.status == CEnum.roomStatus.created then -- "created" then
                    self.weChatInviteControl:exec()

                    if self.userGameing ~= nil then
                        local nums = self.userGameing["num"]
                        -- local nums = roomdata.num
                        if nums ~= nil then
                            -- 3人组局就3人到位，2人组局就2人到位，直接去掉邀请好友按钮
                            if self.model~=nil and self.model:getPlayerList()~=nil and #self.model:getPlayerList()==nums then
                                self.weChatInviteControl:hideAll()
                            end
                        else
                            -- 默认值为3人到位，直接去掉邀请好友按钮
                            if self.model~=nil and self.model:getPlayerList()~=nil and #self.model:getPlayerList()==3 then
                                self.weChatInviteControl:hideAll()
                            end
                        end
                    end
                end 
                self.statusManager:dealReady() -- 玩家状态显示为准备

                -- 房间已经开始了，重连上来
                -- 以下情况如果发生在玩家牌局中登录，会要执行下出牌等操作.
                if roomdata.status == CEnum.roomStatus.started then -- "started" then
                    CVar._static.roomStatus = CEnum.roomStatus.started
                    self.statusManager:hideAll() -- 所有玩家状态先隐藏

                    -- -- 本人手牌处理
                    -- local myCardList = self.model:getMyHandCards()
                    -- if #myCardList>0 then
                    --     self.mycardView:clearAllCard()
                    --     self.mycardView:setCard(myCardList)
                    -- end

                    self.roomPlayerManager:showAllLeftCards()
                    self.roomPlayerManager:upDateScore() -- 刷新玩家分数
                    if res_cmd == Sockets.cmd.loginRoom then
                        self.roomPlayerManager:setDealer() -- 庄家设置只设置一次
                    end
                    self.weChatInviteControl:hideAll() -- 邀请微信好友按钮隐藏
                    self.roomTopOprationManager:gameStart()

                    local selfData = self.model:getSelfSeatData()
                    if selfData.chu == true then
                        self.tipsIndex_ = 0
                        --开启出牌操作区
                        self.outCardControl:exec(1)
                        local cmd_action
                        if self.model:getSelfSeatData().options  then
                            cmd_action = RequestBase:getStrDecode(self.model:getSelfSeatData().options[1])
                        end
                        if cmd_action == CEnum.playOptions.guo then
                            local playerAction = self.model:getAction()
                            local actionNo
                            if playerAction then
                                actionNo = playerAction.actionNo
                            end
                            self.outCardControl:hideAll()
                            scheduler.performWithDelayGlobal(function ()
                                SocketRequestGameing:gameing_Guo(actionNo)
                            end, 1)
                        end
                    end

                    self.statusManager:dealPassOut()
                    local playerList = self.model:getPlayerList()
                    for i=1,#playerList do
                        local seatPlayerData = playerList[i]
                        local tempSeatId = self.model:getOtherClientSeatId(playerList[i].seatNo)

                        -- -- 登录后，记录所有玩家信息  最后还是定于在游戏开始的start中给全
                        -- if seatPlayerData[User.Bean.user] ~= nil then
                        --     if tempSeatId == CEnumP.seatNo.me then   
                        --         self.user_icon = RequestBase:getStrDecode(seatPlayerData[User.Bean.user][User.Bean.icon]) 
                        --         self.user_nickname = RequestBase:getStrDecode(seatPlayerData[User.Bean.user][User.Bean.nickname]) 
                        --     elseif tempSeatId == CEnumP.seatNo.R then
                        --         self.user_icon_R = RequestBase:getStrDecode(seatPlayerData[User.Bean.user][User.Bean.icon]) 
                        --         self.user_nickname_R = RequestBase:getStrDecode(seatPlayerData[User.Bean.user][User.Bean.nickname]) 
                        --     elseif tempSeatId == CEnumP.seatNo.L then
                        --         self.user_icon_L = RequestBase:getStrDecode(seatPlayerData[User.Bean.user][User.Bean.icon]) 
                        --         self.user_nickname_L = RequestBase:getStrDecode(seatPlayerData[User.Bean.user][User.Bean.nickname]) 
                        --     end
                        -- end

                        --设置下家出牌闹钟
                        if seatPlayerData.chu == true then
                            self.animManager:showClock(tempSeatId, CVar._static.clockWiseTime)
                        end

                        local outSeatId = 0--当前出牌人座位
                		local outCards = nil --当前打掉一手什么牌
    	                --出牌
    	                if seatPlayerData.action and seatPlayerData.action.type~=CEnum.playOptions.guo then
    	                    --界面出牌操作
    	                    if seatPlayerData.action.cards and #seatPlayerData.action.cards>0  then
    	                        outSeatId = tempSeatId
    	                        outCards = self.model:getListForClient(seatPlayerData.action.cards)
    	                        self.outcardManager:showOutCard(outSeatId,outCards)
    	                    end
    	                end

                        -- 剩下一张牌，服务器告诉要报警，就报警
                        if seatPlayerData.alarm == true then
                            self.animManager:playWarning(tempSeatId)
                            scheduler.performWithDelayGlobal(function ()
                                VoiceDealUtil:playSound_other(PDKVoices.file.alert)
                            end, 0.3)
                            scheduler.performWithDelayGlobal(function ()
                                VoiceDealUtil:playSound_other(PDKVoices.file.leftOneCard)
                            end, 0.9)
                        end
                    end
                    -- self.roomTopOprationManager:setGprs_ViewData(self.model,
                    --         self.user_icon, self.user_nickname, self.user_icon_R, self.user_nickname_R, self.user_icon_L, self.user_nickname_L) --定位信息处理
                end

                --如果游戏为单局结束状态，则开启准备按钮
                local selfData = self.model:getSelfSeatData()
                if selfData.playStatus == CEnum.playStatus.ended or selfData.playStatus==CEnum.playStatus.wait then -- "ended" then
                    self.readyControl:exec() --启动准备按钮
                end
                
            --玩家登陆
            elseif res_cmd == Sockets.cmd.gameing_playerLoginRoom then
                self.model:parsePlayerLogin(receive_res_data)
                self.roomPlayerManager:init()
                self.roomPlayerManager:upDatePlayerStatus()
                -- local myCardList = self.model:getMyHandCards()

                if self.model:getRoomInfo().status == CEnum.roomStatus.created then
                    self.weChatInviteControl:exec()

                    -- if self.model~=nil and self.model:getRoomInfo()~=nil then
                    if self.userGameing ~= nil then
                        local nums = self.userGameing["num"]
                        -- local nums = self.model:getRoomInfo().num
                        if nums ~= nil then
                            -- 3人组局就3人到位，2人组局就2人到位，直接去掉邀请好友按钮
                            if self.model~=nil and self.model:getPlayerList()~=nil and #self.model:getPlayerList()==nums then
                                self.weChatInviteControl:hideAll()
                            end
                        else
                            -- 3人到位，直接去掉邀请好友按钮
                            if self.model~=nil and self.model:getPlayerList()~=nil and #self.model:getPlayerList()==3 then
                                self.weChatInviteControl:hideAll()
                            end
                        end
                    end
                else
                    self.weChatInviteControl:hideAll()
                end 

                self.statusManager:dealReady() -- 玩家状态显示为准备

            --玩家登出 下线==离线而已（但是还在等待这个玩家）
            elseif res_cmd == Sockets.cmd.gameing_playerExitRoom then
                self.model:parsePlayerLoginExit(res_data) -- 下线数据处理
                self.roomPlayerManager:dealUserLogout()
                self.statusManager:userLoginOut()
                self.roomPlayerManager:upDatePlayerStatus()

            -- 玩家离开房间 ==跑路
            elseif res_cmd == Sockets.cmd.gameing_playerOutRoom then
                self.model:parsePlayerLoginOut(res_data) -- 跑路数据处理
                self.roomPlayerManager:dealUserLogout()
                self.statusManager:userLoginOut()
                self.roomPlayerManager:upDatePlayerStatus()

                self.weChatInviteControl:exec() -- 跑路了之后，邀请按钮接着出来

            -- 返回游戏大厅 成功
            elseif res_cmd == Sockets.cmd.gameing_BackHaLL then
                self.isMyManual = true -- 不能再重连
                Commons:gotoPDKHome() -- 退出就会关闭socket

            --游戏准备
            elseif res_cmd == Sockets.cmd.gameing_Prepare then
                self.model:parsePlayerReady(receive_res_data)
                self.statusManager:dealReady()
                self.roomPlayerManager:upDatePlayerStatus()
                local selfData = self.model:getSelfSeatData()
                if selfData.playStatus == CEnum.playStatus.ready then
                    self.readyControl:hideAll()
                    -- self:clearCurTableStatus() -- 清理桌面
                    self:readyClearTable() -- 准备之后的主动清理操作
                end

            --游戏开始
            elseif res_cmd == Sockets.cmd.gameing_Start then
                -- if self.errorInfo_ then
                --     self.errorInfo_:setString("==新的开局==")
                -- end

                CVar._static.roomStatus = CEnum.roomStatus.started -- 房间状态，对定位中按钮有控制作用

                self.model:parseGameStart(receive_res_data)
                -- 更新玩家状态
                self.roomPlayerManager:upDatePlayerStatus()

                -- 设置top界面
                local roomdata = self.model:getRoomInfo()
                self.roomTopOprationManager:setRoomId(roomdata.roomNo)
                self.roomTopOprationManager:setTable(roomdata.playRound, roomdata.rounds)
                self.roomTopOprationManager:gameStart()

                self.statusManager:hideAll()

                -- 本人手牌处理
                local myCardList = self.model:getMyHandCards()                
                if #myCardList>0 then
                    self.mycardView:clearAllCard()
                    self.mycardView:setCard(myCardList)
                    VoiceDealUtil:playSound_other(PDKVoices.file.fapai)
                    self.mycardView:dealCards()
                end
                self.roomPlayerManager:showAllLeftCards()
                self.roomPlayerManager:upDateScore()--刷新玩家分数
                self.roomPlayerManager:setDealer()
                self.weChatInviteControl:hideAll()

                local selfData = self.model:getSelfSeatData()
                if selfData.chu == true then
                    self.tipsIndex_ = 0
                    --开启出牌操作区
                    self.outCardControl:exec(1)
                end
                local playerList = self.model:getPlayerList()
                for i=1,#playerList do
                    local seatPlayerData = playerList[i]
                    local tempSeatId = self.model:getOtherClientSeatId(playerList[i].seatNo)


                    -- -- 游戏开始后，记录所有玩家信息  最后还是定于在游戏开始的start中给全
                    -- if seatPlayerData[User.Bean.user] ~= nil then
                    --     if tempSeatId == CEnumP.seatNo.me then   
                    --         self.user_icon = RequestBase:getStrDecode(seatPlayerData[User.Bean.user][User.Bean.icon]) 
                    --         self.user_nickname = RequestBase:getStrDecode(seatPlayerData[User.Bean.user][User.Bean.nickname]) 
                    --     elseif tempSeatId == CEnumP.seatNo.R then
                    --         self.user_icon_R = RequestBase:getStrDecode(seatPlayerData[User.Bean.user][User.Bean.icon]) 
                    --         self.user_nickname_R = RequestBase:getStrDecode(seatPlayerData[User.Bean.user][User.Bean.nickname]) 
                    --     elseif tempSeatId == CEnumP.seatNo.L then
                    --         self.user_icon_L = RequestBase:getStrDecode(seatPlayerData[User.Bean.user][User.Bean.icon]) 
                    --         self.user_nickname_L = RequestBase:getStrDecode(seatPlayerData[User.Bean.user][User.Bean.nickname]) 
                    --     end
                    -- end

                    --设置下家出牌闹钟
                    --self.animManager:stopAllClock()
                    --self.animManager:stopClock()
                    if seatPlayerData.chu == true then
                        self.animManager:showClock(tempSeatId, CVar._static.clockWiseTime)
                    end
                end
                -- self.roomTopOprationManager:setGprs_ViewData(self.model, 
                --         self.user_icon, self.user_nickname, self.user_icon_R, self.user_nickname_R, self.user_icon_L, self.user_nickname_L) --定位信息处理

            --出牌
            elseif res_cmd == Sockets.cmd.gameing_Chu then
                -- if self.errorInfo_ then
                --     self.errorInfo_:setString("--正常出牌--")
                -- end
                self.model:parseOutCards(receive_res_data)
                self.roomPlayerManager:showAllLeftCards()
                self.roomPlayerManager:upDatePlayerStatus()

                local selfData = self.model:getSelfSeatData()
                --如果下家出牌人是自己
                if selfData.chu == true then
                    --重置联想牌数字
                    self.tipsIndex_ = 0
                    --打开出牌，提示按钮
                    self.outCardControl:exec(1)

                    local cmd_action
                    if self.model:getSelfSeatData().options  then
                        --抓出出牌动作
                        cmd_action = RequestBase:getStrDecode(self.model:getSelfSeatData().options[1])
                    end

                    if cmd_action == CEnum.playOptions.guo then
                        local playerAction = self.model:getAction()
                        local actionNo
                        if playerAction then
                            actionNo = playerAction.actionNo
                        end
                        -- self.tipsIndex_ = 0
                        -- self:doUIControlAction(CEnumP.CLIENT_UI_ACTION.cardTip)
                        --播放要不起的动画
                        self.animManager:playNotCard()

                        --如果自己要不起，又到了自己出牌，则隐藏出牌按钮
                        self.outCardControl:hideAll()
                        scheduler.performWithDelayGlobal(function ()
                            SocketRequestGameing:gameing_Guo(actionNo)
                        end, 1)
                    else
                        if selfData.lastHand == true then
                            scheduler.performWithDelayGlobal(function ()
                            	self:doUIControlAction(CEnumP.CLIENT_UI_ACTION.cardTip)
                               	self:doUIControlAction(CEnumP.CLIENT_UI_ACTION.outCard)
                            end,1.2)
                        else
                        	--不是要不起，就提起第一组可以打的牌
                        	self:doUIControlAction(CEnumP.CLIENT_UI_ACTION.cardTip)
                        end
                    end

                    -- if self.model:getSelfSeatData().options  then
                    --     local cmd_action = RequestBase:getStrDecode(self.model:getSelfSeatData().options[1])
                    --     if cmd_action == CEnum.playOptions.guo then
                    --         local playerAction = self.model:getAction()
                    --         local actionNo ;
                    --         if playerAction then
                    --             actionNo = playerAction.actionNo
                    --         end
                    --         -- self.tipsIndex_ = 0
                    --         -- self:doUIControlAction(CEnumP.CLIENT_UI_ACTION.cardTip)
                    --         self.animManager:playNotCard()

                    --         SocketRequestGameing:gameing_Guo(actionNo)
                    --     end

                    -- else
                    --     self:doUIControlAction(CEnumP.CLIENT_UI_ACTION.cardTip)
                    -- end
                else
                    --关闭出牌按钮
                    self.outCardControl:hideAll()
                end

                local outSeatId = 0--当前出牌人座位
                local outCards = nil --当前打掉一手什么牌
                local playerList = self.model:getPlayerList()
                for i=1,#playerList do
                    local seatPlayerData = playerList[i]
                    local tempSeatId = self.model:getOtherClientSeatId(playerList[i].seatNo)
                    --设置下家出牌闹钟
                    if seatPlayerData.chu == true then
                        self.animManager:showClock(tempSeatId, CVar._static.clockWiseTime)
                        self.outcardManager:hideOutCard(tempSeatId)
                        self.statusManager:hideStatus(tempSeatId)
                    end
                    --出牌
                    if seatPlayerData.action then
                        --界面出牌操作
                        if seatPlayerData.action.cards and #seatPlayerData.action.cards>0  then

                            VoiceDealUtil:playSound_other(PDKVoices.file.outCard)

                            outSeatId = tempSeatId
                            outCards = self.model:getListForClient(seatPlayerData.action.cards)
                            self.outcardManager:showOutCard(outSeatId,outCards)

                            -- --牌少于1或者2张，播放报警动画
                            -- if seatPlayerData.leftCardCount>0 and seatPlayerData.leftCardCount <=2 then
                            --     if seatPlayerData.leftCardCount == 1 then
                            --         self.animManager:playWarning(outSeatId)
                            --         VoiceDealUtil:playSound_other(PDKVoices.file.alert)
                            --         self.scene:performWithDelay(function ()
                            --             VoiceDealUtil:playSound_other(PDKVoices.file.leftOneCard)
                            --         end, 0.8)   
                            --     elseif seatPlayerData.leftCardCount == 2 then
                            --         --去掉了语音报牌2张。
                            --         --VoiceDealUtil:playSound_other(PDKVoices.file.leftTwoCard)
                            --     end
                            -- end
                            -- 剩下一张牌，服务器告诉要报警，就报警
                            if seatPlayerData.alarm == true then
                                self.animManager:playWarning(outSeatId)
                                scheduler.performWithDelayGlobal(function ()
                                    VoiceDealUtil:playSound_other(PDKVoices.file.alert)
                                end, 0.3)
                                scheduler.performWithDelayGlobal(function ()
                                    VoiceDealUtil:playSound_other(PDKVoices.file.leftOneCard)
                                end, 0.9)
                            end

                            --自己打了牌,刷新当前手牌
                            if seatPlayerData.me == true then
                                self.mycardView:removeOutCard(outCards) -- 直接去掉手牌，实际过程有问题：重连或者卡住没有去掉成功
                            end
                        end

                        --牌型动画,音效。
                        --牌型
                        local poker_type =  RequestBase:getStrDecode(seatPlayerData.action.cardType)
                        -- self.testTxt:setString(poker_type)--test

                        if poker_type == CEnumP.serverCardType.dan then
                            --单牌
                            local value = self.model:getCardValue(outCards[1])
                            VoiceDealUtil:playSound_other(PDKVoices.file["card_"..value])

                        elseif poker_type == CEnumP.serverCardType.dui then
                            --对子
                            local value = self.model:getCardValue(outCards[1])
                            VoiceDealUtil:playSound_other(PDKVoices.file["two_"..value])

                        elseif poker_type == CEnumP.serverCardType.ddui then
                            --连对
                            VoiceDealUtil:playSound_other(PDKVoices.file.liandui)
                            scheduler.performWithDelayGlobal(
                                function()
                                    self.animManager:playPokerType(CEnumP.POKER_TYPE.LIANDUI)
                                    VoiceDealUtil:playSound_other(PDKVoices.file.liandui_1)
                                end,0.8
                            )

                        elseif poker_type == CEnumP.serverCardType.shun then
                            --顺子
                            VoiceDealUtil:playSound_other(PDKVoices.file.shunzi)
                            scheduler.performWithDelayGlobal(
                                function()
                                    self.animManager:playPokerType(CEnumP.POKER_TYPE.SHUNZI)
                                    VoiceDealUtil:playSound_other(PDKVoices.file.shunzi_1)
                                end,0.8
                            )
                            
                        elseif poker_type == CEnumP.serverCardType.san then
                            --三张
                            VoiceDealUtil:playSound_other(PDKVoices.file.sanzhang)

                        elseif poker_type == CEnumP.serverCardType.sanA then
                            --三带一
                            VoiceDealUtil:playSound_other(PDKVoices.file.sandaiyi)

                        elseif poker_type == CEnumP.serverCardType.sanAB then
                            --三带二
                            VoiceDealUtil:playSound_other(PDKVoices.file.sandaiyidui)  

                        elseif poker_type == CEnumP.serverCardType.feiji then
                            --飞机
                            VoiceDealUtil:playSound_other(PDKVoices.file.feiji)
                            scheduler.performWithDelayGlobal(
                                function()
                                    self.animManager:playPokerType(CEnumP.POKER_TYPE.FEIJI)
                                    VoiceDealUtil:playSound_other(PDKVoices.file.feiji_1)
                                end,0.8
                            )

                        elseif poker_type == CEnumP.serverCardType.zha then
                            --炸弹
                            VoiceDealUtil:playSound_other(PDKVoices.file.bomb)
                            scheduler.performWithDelayGlobal(
                                function()
                                    self.animManager:playPokerType(CEnumP.POKER_TYPE.BOMB)
                                    VoiceDealUtil:playSound_other(PDKVoices.file.bomb_1)
                                end,0.4
                            )
                        end
                    end

                end

            -- 过牌，不要
            elseif res_cmd == Sockets.cmd.gameing_ChiPengGuoHu_pai then
                self.model:parsePass(receive_res_data)
                self.roomPlayerManager:upDatePlayerStatus()
                VoiceDealUtil:playSound_other(PDKVoices.file.buyao1)
                self.statusManager:dealPassOut()

                local playerList = self.model:getPlayerList()
                for i=1,#playerList do
                    local seatPlayerData = playerList[i]
                    local tempSeatId = self.model:getOtherClientSeatId(playerList[i].seatNo)
                    --设置下家出牌闹钟
                    if seatPlayerData.chu == true then
                        self.animManager:showClock(tempSeatId, CVar._static.clockWiseTime)
                        self.statusManager:hideStatus(tempSeatId)
                        self.outcardManager:hideOutCard(tempSeatId)
                    end
                end

                local selfData = self.model:getSelfSeatData()
                --如果下家出牌人是自己
                if selfData.chu == true then
                   
                    self.outCardControl:exec(1)
                    self.tipsIndex_ = 0
                    if self.model:getRoomInfo().newCircle == false then

                       -- dump(self.model:getSelfSeatData().options,"self.model:getSelfSeatData()")
                        local cmd_action
                        if self.model:getSelfSeatData().options  then
                            cmd_action = RequestBase:getStrDecode(self.model:getSelfSeatData().options[1])
                        end

                        if cmd_action == CEnum.playOptions.guo then
                            --self.testTxt:setString(cmd_action) --test
                            local playerAction = self.model:getAction()
                            local actionNo ;
                            if playerAction then
                                actionNo = playerAction.actionNo
                            end

                            -- self.tipsIndex_ = 0
                            -- self:doUIControlAction(CEnumP.CLIENT_UI_ACTION.cardTip)
                            self.animManager:playNotCard()

                            --SocketRequestGameing:gameing_Guo(actionNo)
                            self.outCardControl:hideAll()
                            scheduler.performWithDelayGlobal(function ()
                                SocketRequestGameing:gameing_Guo(actionNo)
                            end, 1)
                           -- self.animManager:playPokerType(CEnumP.POKER_TYPE.FEIJI)
                        else
                            if selfData.lastHand == true then
                                self.outCardControl:hideAll()
                            	scheduler.performWithDelayGlobal(function ()
                            		self:doUIControlAction(CEnumP.CLIENT_UI_ACTION.cardTip)
                                	self:doUIControlAction(CEnumP.CLIENT_UI_ACTION.outCard)
                                end,1.2)
                            else
                            	self:doUIControlAction(CEnumP.CLIENT_UI_ACTION.cardTip)
                            end
                        end

                        -- if self.model:getSelfSeatData().options  then
                        --     dump(self.model:getSelfSeatData().options,"self.model:getSelfSeatData().options")
                        --     local cmd_action = RequestBase:getStrDecode(self.model:getSelfSeatData().options[1])
                        --     if cmd_action == CEnum.playOptions.guo then
                        --         local playerAction = self.model:getAction()
                        --         local actionNo ;
                        --         if playerAction then
                        --             actionNo = playerAction.actionNo
                        --         end
                        --         -- self.tipsIndex_ = 0
                        --         -- self:doUIControlAction(CEnumP.CLIENT_UI_ACTION.cardTip)
                        --         self.animManager:playNotCard()
                        --         SocketRequestGameing:gameing_Guo(actionNo)
                        --     end
                        -- else
                        --     self:doUIControlAction(CEnumP.CLIENT_UI_ACTION.cardTip)
                        -- end

                    else
                       -- self.animManager:playPokerType(CEnumP.POKER_TYPE.BOMB)
                            --如果轮到自己出牌，自己只有一张牌，系统自动打出
                        if selfData.lastHand == true then
                            self.outCardControl:hideAll()
                        	scheduler.performWithDelayGlobal(function ()
    	                        self:doUIControlAction(CEnumP.CLIENT_UI_ACTION.cardTip)
    	                        self:doUIControlAction(CEnumP.CLIENT_UI_ACTION.outCard)
    	                    end,1.3)
                        end
                    end
                else
                    self.outCardControl:hideAll()
                end

            --出牌不合法
            elseif res_cmd == Sockets.cmd.gameing_outCard_error then
                self.animManager:playOutCardError()

            --回合结束
            elseif res_cmd == Sockets.cmd.gameing_Over then
                if self.model ~= nil then
                    self.model:praseTableOver(receive_res_data)

                    -- 回合结算数据
                    local tableOverData = self.model:getTableOverData()
                    -- 房间结算数据
                    self.gameOverData = self.model:getRoomOverData()

                    -- -- 任何数据都没有
                    -- if tableOverData == nil and self.gameOverData == nil then
                    --      CDialog.new():popDialogBox(self.ctx.scene, nil, "发生错误！牌局结算，房间结算都为空", function()  Commons:gotoPDKHome() end )
                    --      return
                    -- end

                    -- 一旦有房间结束，就直接关闭socket
                    if self.gameOverData ~= nil then
                        self.isMyManual = true -- 不能再重连
                        self:closeSocket()
                        CVar._static.roomStatus = ""
                    end

                    --更新玩家在线离线状态
                    self.roomPlayerManager:upDatePlayerStatus()
                    -- 清空游戏界面中多余的弹窗
                    self:dialogDispose()
                    self:dialogDispose_ip()
                    -- 动画停止，闹钟停止
                    self.animManager:stopClock()
                    self:clearCurTableStatus() --清理桌面 
                    self.roomPlayerManager:upDateScore()--刷新玩家分数

                    -- 有回合结算数据
                    if tableOverData ~= nil then
                        self.animManager:playWin()
                        self.leftCardManager:showGameOverLeftCard()
                    end                                    

                    --检测是否有赢家
                    --没有赢家需要立即弹出结算，否则就需要稍微延迟点点弹窗结算界面
                    local openRusultDelay = 0.1 -- 
                    if tableOverData then
                        for i=1,#tableOverData do
                            if tableOverData[i].roundResult == true then
                                openRusultDelay = 1
                            end
                        end
                    end
                    -- 延迟出回合结算
                    local function tableOverCallback()
                         --如果整个房间结束了，打开总结算窗口
                        PDKOverRoomDialog.new(self.gameOverData, function() Commons:gotoPDKHome() end):addTo(self.scene)                
                    end
                    scheduler.performWithDelayGlobal(function ()
                        if tableOverData then
                            PDKOverRoundDialog.new(tableOverData, self.gameOverData, tableOverCallback, 
                                nil, nil, tostring(self.model:getRoomInfo().roomNo), nil, tostring(self.model:getRoomInfo().playRound) ):addTo(self.scene)
                        elseif tableOverData == nil and self.gameOverData ~= nil then
                            tableOverCallback()
                        else
                            CDialog.new():popDialogBox(self.ctx.scene, nil, "回合、房间数据都为空！", function()  Commons:gotoPDKHome() end)
                        end

                        self.roomPlayerManager:hideAllCards()--去掉玩家牌张数
                        self.readyControl:exec() --启动准备按钮
                        if self.gameOverData then
                            --如果房间完毕，则不开启
                            self.readyControl:hide()
                        end

                    end, openRusultDelay)                    
                    
                else
                    CDialog.new():popDialogBox(self.ctx.scene, nil, "over数据为空！", function()  Commons:gotoPDKHome() end)
                end

            ---申请解散房间 1002
            -- 解散部分结果反馈回来 1003
            elseif res_cmd == Sockets.cmd.dissRoom or res_cmd == Sockets.cmd.dissRoom_confim then
                if self.pdkDissRoomDialog == nil then
                    self.pdkDissRoomDialog = CDAlertDissRoom.new(res_data):addTo(self.scene)
                    -- self.pdkDissRoomDialog = PDKDissRoomDialog.new(res_data):addTo(self.scene)
                else
                    self.pdkDissRoomDialog:create_content(res_data)
                end

            --解散房间成功或者失败 2007
            elseif res_cmd == Sockets.cmd.dissRoom_success then
                local result,descript = self.model:praseDissRoom(res_data)
                --解散成功
                if result then
                    self.isMyManual = true -- 不能再重连
                    self:closeSocket()
                    CDialog.new():popDialogBox(self.ctx.scene, nil, descript, function() Commons:gotoPDKHome() end)
                else
                    --解散失败
                    CDialog.new():popDialogBox(self.ctx.scene, nil, descript, function() end )
                end
                -- 不管解散成功或者失败，都需要关闭ip弹窗，关闭申请解散的弹窗
                self:dialogDispose_ip()
                self:dialogDispose()

            --发生ip检测2011 同时具有定位详细信息
            elseif res_cmd == Sockets.cmd.gameing_IP_check then
                -- -- 需要确认取消的做法
                -- if self.ipcheckDialog_ == nil then
                --     self.ipcheckDialog_ = PDKServerIpCheckDialog.new(res_data):addTo(self.scene)
                -- else
                --     self.ipcheckDialog_:create_content(res_data)
                -- end

                -- 只要弹窗的做法
                --PDKServerIpCheckDialog.new(res_data):addTo(self.scene)

                -- 最新的处理方式
                -- self.roomTopOprationManager:setGprs_ViewData
                self.roomTopOprationManager:players_gprs_setViewData(res_data) --定位信息处理

            elseif res_cmd == Sockets.cmd.gameing_Xintiao_down then -- 心跳下行来拉
                local systime = res_data["systime"]
                if systime ~= nil then
                    SocketRequestGameing:gameing_Xintiao_up(systime)
                end

            elseif res_cmd == Sockets.cmd.gameing_ExitSocket then -- 有多处重连socket告诉上一处自动退出和关闭socket
                self.isMyManual = true -- 不能再重连
                Commons:gotoPDKHome()

            elseif res_cmd == Sockets.cmd.gameing_SendEmoji then -- 表情来了
                EmojiView:emoji_createView_setViewData(res_data, self.scene, self.model)
            elseif res_cmd == Sockets.cmd.gameing_SuperEmoji then -- 超级表情来了
                EmojiView:superEmojoDataHandler(res_data, self.scene, self.model:getMySeatId())

            elseif res_cmd == Sockets.cmd.gameing_SendWords then -- 短语来了
                EmojiView:words_createView_setViewData(res_data, self.scene, self.model)

            elseif res_cmd == Sockets.cmd.gameing_SendVoice then -- 录音来了
                -- 只有开关是打开的，才允许语音自动播放
                -- local _currStopVoice = GameState_VoiceSetting:getDataSingle(CEnum.voiceSetting.currStopVoice)
                -- if _currStopVoice ~= nil and CEnum.musicStatus.on == _currStopVoice then
                    self.scene:voice_createView_setViewData(res_data, self.model)
                -- end

            end
        else
            -- socket有数据过来的时候，status~=0，错误数据

            -- 登录错误的处理
            if res_cmd == Sockets.cmd.dissRoom then
                CDAlertManu.new():popDialogBox(self.ctx.scene, res_msg, true)
            elseif res_cmd == Sockets.cmd.loginRoom or res_cmd==Sockets.cmd.refreshRoom then 
                CDialog.new():popDialogBox(self.ctx.scene, nil, res_msg, function() Commons:gotoPDKHome() end, nil )
                self.isMyManual = true -- 不能再重连
                self:closeSocket()
            --else
                --CDAlertManu.new():popDialogBox(self.ctx.scene, res_msg, false)
            end

        end -- socket有数据过来的时候，status=0，正确数据

    end --  -- socket连接正常，socket连接失败，socket有数据过来的 end

end -- funtion end


-- 关闭所有可以操作的按钮
function RoomController:hideOperation()
    self.weChatInviteControl:hide() -- 邀请按钮
    self.outCardControl:hide() -- 出牌按钮
    self.readyControl:hide() -- 准备按钮
end
-- 清桌操作
function RoomController:clearCurTableStatus()
    -- self.animManager:stopAllClock()
    -- self.mycardView:clearAllCard()
    -- self.leftCardManager:cleanAllCard()
    -- self.outcardManager:hideAll()

    self:hideOperation() -- 关闭所有可以操作的按钮

    self.animManager:stopClock() -- 倒计时  停止
    self.statusManager:hideAll() -- 所有玩家状态 清理
    self.animManager:stopWarning() -- 告警 清理
end
-- 准备之后的主动清理操作
function RoomController:readyClearTable()
    self.animManager:stopWin() -- 停动画
    self.mycardView:clearAllCard() -- 手牌 清理
    self.leftCardManager:cleanAllCard() -- 玩家剩余牌，底牌，废牌  清理
    self.outcardManager:hideAll() -- 出牌 清理
end



--退出房间请求
function RoomController:sendLoginOut()
    SocketRequestGameing:gameing_BackHaLL()
end
--解散房间请求
function RoomController:sendDissRoom()
    SocketRequestGameing:dissRoom()
end


-- 消失 解散房间的弹窗
function RoomController:dialogDispose()
    if self.pdkDissRoomDialog then
        self.pdkDissRoomDialog:dispose()
        self.pdkDissRoomDialog:removeFromParent()
        self.pdkDissRoomDialog = nil
    end
end
-- 消失 ip定位提示的弹窗
function RoomController:dialogDispose_ip()
    if self.ipcheckDialog_ then
        self.ipcheckDialog_:dispose()
        self.ipcheckDialog_:removeFromParent()
        self.ipcheckDialog_ = nil
    end
end


-- 杀进程
function RoomController:dispose()
    self.isMyManual = true -- 不能再重连
    self:closeSocket()

    if self.loadingSpriteAnim~=nil and (not tolua.isnull(self.loadingSpriteAnim)) then
        self.loadingSpriteAnim:removeFromParent()
        self.loadingSpriteAnim = nil
    end

    if self.errorInfo_ and not tolua.isnull(self.errorInfo_) then
        self.errorInfo_:removeFromParent()
        self.errorInfo_ = nil
    end

    if self.top_scheduler and self.top_schedulerID_network then
        self.top_scheduler:unscheduleScriptEntry(self.top_schedulerID_network)
    end

    self:dialogDispose()
    self:dialogDispose_ip()

	self.roomTopOprationManager:dispose()
    self.animManager:dispose()
    self.roomPlayerManager:dispose()
    self.model:dispose()    
end

-- loading框
function RoomController:createLoading()
    self.loadingSpriteAnim = display.newSprite(Imgs.c_juhua):addTo(self.scene)
    self.loadingSpriteAnim:runAction(cc.RepeatForever:create(cc.RotateBy:create(100, 36000)))
    self.loadingSpriteAnim:pos(display.cx, display.cy)
end

--纯调试部分
function RoomController:myKeypad(event)
    -- print("event.key：" .. event.key, "type.key:"..type(event.key))

    if event ~= nil and event.key == "back" then
        -- 返回处理

    elseif event ~= nil and event.key =="77" then -- 数字 1，模拟连接好socket
        self:createSocket() -- CVar._static.mSocket在这个方法中初始化出来的
        CVar._static.mSocket:tcpConnected()

    elseif event ~= nil and event.key =="78" then -- 数字 2，触发登录房间
        self.animManager:playWarning(1)
        self.animManager:showClock(1, CVar._static.clockWiseTime)
        CVar._static.mSocket:tcpReceiveData( PDKSocketResponseDataTest:loginRoom() )

   elseif event ~= nil and event.key == "79" then --数字 3，触发玩家登录
        self.animManager:playWarning(2)
        self.animManager:showClock(2, CVar._static.clockWiseTime)
        CVar._static.mSocket:tcpReceiveData( PDKSocketResponseDataTest:playerLogin() )

   elseif event ~= nil and event.key == "80" then --数字 4，触发玩家准备
        self.animManager:playWarning(3)
        self.animManager:showClock(3, CVar._static.clockWiseTime)
        CVar._static.mSocket:tcpReceiveData( PDKSocketResponseDataTest:playerReady() )

   elseif event ~= nil and event.key == "81" then --数字 5，触发回合开始
        self.animManager:stopWarning()
        CVar._static.mSocket:tcpReceiveData( PDKSocketResponseDataTest:gameStart() )

    -- elseif event ~= nil and event.key == "82" then -- 数字 6 玩家全部在线 定位信息推送过来了
    --     CVar._static.mSocket:tcpReceiveData( PDKSocketResponseDataTest:res_gameing_gprs_look() )

   elseif event ~= nil and event.key == "140" then --字母 Q，自己出牌
        CVar._static.mSocket:tcpReceiveData( PDKSocketResponseDataTest:outCards() )

   elseif event~=nil and event.key == "146" then -- 字母 W，不要
        -- CVar._static.mSocket:tcpReceiveData( PDKSocketResponseDataTest:playerPass() )
        -- CVar._static.mSocket:tcpReceiveData( PDKSocketResponseDataTest:res_dissRoom_new() )
        -- PDKDissRoomDialog.new(resData.data):addTo(self.scene)

    elseif event ~= nil and event.key == "142" then -- 字母 S 解散房间申请反馈给其他玩家  等待其他玩家确认
        CVar._static.mSocket:tcpReceiveData( SocketResponseDataTest:res_dissRoom_new() )
        -- CVar._static.mSocket:tcpReceiveData( PDKSocketResponseDataTest:res_gameing_IP_check() )

    elseif event ~= nil and event.key == "129" then -- 字母 F 测试又有新的人同意解散的页面显示效果
        CVar._static.mSocket:tcpReceiveData( SocketResponseDataTest:res_dissRoom_new2() )

    elseif event ~= nil and event.key == "127" then -- 字母 D 大家同意散场，解散房间拉
        CVar._static.mSocket:tcpReceiveData( SocketResponseDataTest:res_dissRoom_success() )
        

    elseif event ~= nil and event.key == "147" then -- 字母 X 下一玩家发出的 表情
        -- CVar._static.mSocket:tcpReceiveData( SocketResponseDataTest:res_gameing_SendEmoji("sj",2) )
        -- CVar._static.mSocket:tcpReceiveData( SocketResponseDataTest:res_gameing_SendWords("s01",2) )
        CVar._static.mSocket:tcpReceiveData( MJSocketResponseDataTest.new():res_gameing_SendSuperEmoji("2", 2, 1) )
    elseif event ~= nil and event.key == "126" then -- 字母 C 最后一个玩家发出的 表情
       -- CVar._static.mSocket:tcpReceiveData( SocketResponseDataTest:res_gameing_SendEmoji("dk",3) )
       CVar._static.mSocket:tcpReceiveData( SocketResponseDataTest:res_gameing_SendWords("s01",3) )

    elseif event ~= nil and event.key == "132" then -- 字母 i 本人 不停的说话
        CVar._static.mSocket:tcpReceiveData( SocketResponseDataTest.new():res_gameing_SendVoice(nil,1) )
    elseif event ~= nil and event.key == "137" then -- 字母 N R 下一玩家发出的 录音
        CVar._static.mSocket:tcpReceiveData( SocketResponseDataTest.new():res_gameing_SendVoice(nil,2) )
    elseif event ~= nil and event.key == "136" then -- 字母 M L 最后一个玩家发出的 录音
        CVar._static.mSocket:tcpReceiveData( SocketResponseDataTest.new():res_gameing_SendVoice(nil,3) )

    elseif event ~= nil and event.key == "149" then -- 字母 Z 游戏结束
        CVar._static.mSocket:tcpReceiveData( PDKSocketResponseDataTest:gameOver() )

   end
end

function RoomController:testNodeClick()
    ---[[
    local test_node = display.newNode() --cc.NodeGrid:create()
                :addTo(self.scene, 9999)

    cc.ui.UIPushButton.new(Imgs.c_check_no_test,{scale9=false})
        :setButtonImage(EnStatus.pressed, Imgs.c_check_yes_test)
        :setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
            text = "1", -- 到了房间，socket初始化
            size = Dimens.TextSize_30,
            color = Colors:_16ToRGB(Colors.gameing_roomNo),
            UILabelType = 2,
            align = cc.ui.TEXT_ALIGN_CENTER,
            valign = cc.ui.TEXT_VALIGN_CENTER,
         }))
        :onButtonClicked(function(e)
            self:createSocket()
            CVar._static.mSocket:tcpConnected()
        end)
        :align(display.LEFT_TOP, 25 +80*0, osHeight-50)
        :addTo(test_node)

    cc.ui.UIPushButton.new(Imgs.c_check_no_test,{scale9=false})
        :setButtonImage(EnStatus.pressed, Imgs.c_check_yes_test)
        :setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
            text = "2", -- 我自己登录房间，创建房间
            size = Dimens.TextSize_30,
            color = Colors:_16ToRGB(Colors.gameing_roomNo),
            UILabelType = 2,
            align = cc.ui.TEXT_ALIGN_CENTER,
            valign = cc.ui.TEXT_VALIGN_CENTER,
         }))
        :onButtonClicked(function(e)
            self.animManager:playWarning(1)
            self.animManager:showClock(1, CVar._static.clockWiseTime)
            CVar._static.mSocket:tcpReceiveData( PDKSocketResponseDataTest:loginRoom() )
        end)
        :align(display.LEFT_TOP, 25 +80*1, osHeight-50)
        :addTo(test_node)

    cc.ui.UIPushButton.new(Imgs.c_check_no_test,{scale9=false})
        :setButtonImage(EnStatus.pressed, Imgs.c_check_yes_test)
        :setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
            text = "3", -- 下一家上线
            size = Dimens.TextSize_30,
            color = Colors:_16ToRGB(Colors.gameing_roomNo),
            UILabelType = 2,
            align = cc.ui.TEXT_ALIGN_CENTER,
            valign = cc.ui.TEXT_VALIGN_CENTER,
         }))
        :onButtonClicked(function(e)
            self.animManager:playWarning(2)
            self.animManager:showClock(2, CVar._static.clockWiseTime)
            -- CVar._static.mSocket:tcpReceiveData( PDKSocketResponseDataTest:playerLogin() )
        end)
        :align(display.LEFT_TOP, 25 +80*2, osHeight-50)
        :addTo(test_node)

    cc.ui.UIPushButton.new(Imgs.c_check_no_test,{scale9=false})
        :setButtonImage(EnStatus.pressed, Imgs.c_check_yes_test)
        :setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
            text = "4", -- 最后一家上线
            size = Dimens.TextSize_30,
            color = Colors:_16ToRGB(Colors.gameing_roomNo),
            UILabelType = 2,
            align = cc.ui.TEXT_ALIGN_CENTER,
            valign = cc.ui.TEXT_VALIGN_CENTER,
         }))
        :onButtonClicked(function(e)
            self.animManager:playWarning(3)
            self.animManager:showClock(3, CVar._static.clockWiseTime)
            -- CVar._static.mSocket:tcpReceiveData( PDKSocketResponseDataTest:playerReady() )
        end)
        :align(display.LEFT_TOP, 25 +80*3, osHeight-50)
        :addTo(test_node)

    cc.ui.UIPushButton.new(Imgs.c_check_no_test,{scale9=false})
        :setButtonImage(EnStatus.pressed, Imgs.c_check_yes_test)
        :setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
            text = "5", -- 游戏开始
            size = Dimens.TextSize_30,
            color = Colors:_16ToRGB(Colors.gameing_roomNo),
            UILabelType = 2,
            align = cc.ui.TEXT_ALIGN_CENTER,
            valign = cc.ui.TEXT_VALIGN_CENTER,
         }))
        :onButtonClicked(function(e)
            self.animManager:stopWarning()
            CVar._static.mSocket:tcpReceiveData( PDKSocketResponseDataTest:gameStart() )
        end)
        :align(display.LEFT_TOP, 25 +80*4, osHeight-50)
        :addTo(test_node)

    cc.ui.UIPushButton.new(Imgs.c_check_no_test,{scale9=false})
        --:setButtonSize(80, 80)
        :setButtonImage(EnStatus.pressed, Imgs.c_check_yes_test)
        :setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
            text = "S", -- 旧的解散房间界面
            size = Dimens.TextSize_30,
            color = Colors:_16ToRGB(Colors.gameing_roomNo),
            UILabelType = 2,
            align = cc.ui.TEXT_ALIGN_CENTER,
            valign = cc.ui.TEXT_VALIGN_CENTER,
         }))
        :onButtonClicked(function(e)
            CVar._static.mSocket:tcpReceiveData( SocketResponseDataTest:res_dissRoom_new() )
            -- CVar._static.mSocket:tcpReceiveData( PDKSocketResponseDataTest:res_gameing_IP_check() )
        end)
        :align(display.LEFT_TOP, 25 +80*10, osHeight-50)
        :addTo(test_node)

    cc.ui.UIPushButton.new(Imgs.c_check_no_test,{scale9=false})
        --:setButtonSize(80, 80)
        :setButtonImage(EnStatus.pressed, Imgs.c_check_yes_test)
        :setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
            text = "F", -- 新的解散房间界面
            size = Dimens.TextSize_30,
            color = Colors:_16ToRGB(Colors.gameing_roomNo),
            UILabelType = 2,
            align = cc.ui.TEXT_ALIGN_CENTER,
            valign = cc.ui.TEXT_VALIGN_CENTER,
         }))
        :onButtonClicked(function(e)
            CVar._static.mSocket:tcpReceiveData( SocketResponseDataTest:res_dissRoom_new2() )
        end)
        :align(display.LEFT_TOP, 25 +80*10, osHeight-50-50)
        :addTo(test_node)

    cc.ui.UIPushButton.new(Imgs.c_check_no_test,{scale9=false})
        --:setButtonSize(80, 80)
        :setButtonImage(EnStatus.pressed, Imgs.c_check_yes_test)
        :setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
            text = "D", -- 房间解散成功
            size = Dimens.TextSize_30,
            color = Colors:_16ToRGB(Colors.gameing_roomNo),
            UILabelType = 2,
            align = cc.ui.TEXT_ALIGN_CENTER,
            valign = cc.ui.TEXT_VALIGN_CENTER,
         }))
        :onButtonClicked(function(e)
            CVar._static.mSocket:tcpReceiveData( SocketResponseDataTest:res_dissRoom_success() )
        end)
        :align(display.LEFT_TOP, 25 +80*11, osHeight-50)
        :addTo(test_node)

    cc.ui.UIPushButton.new(Imgs.c_check_no_test,{scale9=false})
        --:setButtonSize(80, 80)
        :setButtonImage(EnStatus.pressed, Imgs.c_check_yes_test)
        :setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
            text = "Z", -- 游戏结束
            size = Dimens.TextSize_30,
            color = Colors:_16ToRGB(Colors.gameing_roomNo),
            UILabelType = 2,
            align = cc.ui.TEXT_ALIGN_CENTER,
            valign = cc.ui.TEXT_VALIGN_CENTER,
         }))
        :onButtonClicked(function(e)
            CVar._static.mSocket:tcpReceiveData( PDKSocketResponseDataTest:gameOver() )
        end)
        :align(display.LEFT_TOP, 25 +80*12, osHeight-50)
        :addTo(test_node)

    cc.ui.UIPushButton.new(Imgs.c_check_no_test,{scale9=false})
        :setButtonImage(EnStatus.pressed, Imgs.c_check_yes_test)
        :setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
            text = "X", -- 下一家表情
            size = Dimens.TextSize_30,
            color = Colors:_16ToRGB(Colors.gameing_roomNo),
            UILabelType = 2,
            align = cc.ui.TEXT_ALIGN_CENTER,
            valign = cc.ui.TEXT_VALIGN_CENTER,
         }))
        :onButtonClicked(function(e)
            -- CVar._static.mSocket:tcpReceiveData( SocketResponseDataTest:res_gameing_SendEmoji("sj",2) )
            CVar._static.mSocket:tcpReceiveData( SocketResponseDataTest:res_gameing_SendWords("s01",2) )
        end)
        :align(display.LEFT_TOP, 25 +80*13, osHeight-50*2)
        :addTo(test_node)

    cc.ui.UIPushButton.new(Imgs.c_check_no_test,{scale9=false})
        :setButtonImage(EnStatus.pressed, Imgs.c_check_yes_test)
        :setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
            text = "C", -- 最后一家表情
            size = Dimens.TextSize_30,
            color = Colors:_16ToRGB(Colors.gameing_roomNo),
            UILabelType = 2,
            align = cc.ui.TEXT_ALIGN_CENTER,
            valign = cc.ui.TEXT_VALIGN_CENTER,
         }))
        :onButtonClicked(function(e)
            -- CVar._static.mSocket:tcpReceiveData( SocketResponseDataTest:res_gameing_SendEmoji("dk",3) )
            CVar._static.mSocket:tcpReceiveData( SocketResponseDataTest:res_gameing_SendWords("s01",3) )
        end)
        :align(display.LEFT_TOP, 25 +80*13, osHeight-50*3)
        :addTo(test_node)

    cc.ui.UIPushButton.new(Imgs.c_check_no_test,{scale9=false})
        :setButtonImage(EnStatus.pressed, Imgs.c_check_yes_test)
        :setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
            text = "i", -- 模拟录音
            size = Dimens.TextSize_30,
            color = Colors:_16ToRGB(Colors.gameing_roomNo),
            UILabelType = 2,
            align = cc.ui.TEXT_ALIGN_CENTER,
            valign = cc.ui.TEXT_VALIGN_CENTER,
         }))
        :onButtonClicked(function(e)
            CVar._static.mSocket:tcpReceiveData( SocketResponseDataTest:res_gameing_SendVoice(nil,1) )
        end)
        :align(display.LEFT_TOP, 25 +80*14, osHeight-50)
        :addTo(test_node)

    cc.ui.UIPushButton.new(Imgs.c_check_no_test,{scale9=false})
        :setButtonImage(EnStatus.pressed, Imgs.c_check_yes_test)
        :setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
            text = "N", -- 录音来至于下一家
            size = Dimens.TextSize_30,
            color = Colors:_16ToRGB(Colors.gameing_roomNo),
            UILabelType = 2,
            align = cc.ui.TEXT_ALIGN_CENTER,
            valign = cc.ui.TEXT_VALIGN_CENTER,
         }))
        :onButtonClicked(function(e)
            CVar._static.mSocket:tcpReceiveData( SocketResponseDataTest:res_gameing_SendVoice(nil,2) )
        end)
        :align(display.LEFT_TOP, 25 +80*14, osHeight-50*2)
        :addTo(test_node)

    cc.ui.UIPushButton.new(Imgs.c_check_no_test,{scale9=false})
        :setButtonImage(EnStatus.pressed, Imgs.c_check_yes_test)
        :setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
            text = "M", -- 录音来至于最后一家
            size = Dimens.TextSize_30,
            color = Colors:_16ToRGB(Colors.gameing_roomNo),
            UILabelType = 2,
            align = cc.ui.TEXT_ALIGN_CENTER,
            valign = cc.ui.TEXT_VALIGN_CENTER,
         }))
        :onButtonClicked(function(e)
            CVar._static.mSocket:tcpReceiveData( SocketResponseDataTest:res_gameing_SendVoice(nil,0) )
        end)
        :align(display.LEFT_TOP, 25 +80*14, osHeight-50*3)
        :addTo(test_node)
    --]]
end

return RoomController