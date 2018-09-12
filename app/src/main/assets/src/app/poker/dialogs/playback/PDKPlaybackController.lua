--[
--	Author: wh
-- Date: 2017-05-08 19:40:54
--房间总控
--
--]
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
local PDKPlaybackController = class("PDKPlaybackController")


function PDKPlaybackController:ctor( scene,startTime )

    self.startTime = startTime

	cc(self):addComponent("components.behavior.EventProtocol"):exportMethods()

	local ctx = {}

    ctx.roomController = self
    ctx.scene = scene
    ctx.model = RoomModel.new(ctx)
    ctx.roomPlayerManager = RoomPlayerManager.new() -- 玩家头像，座位
    ctx.mycardView = MycardView.new() -- 自己的牌
    ctx.roomTopOprationManager = RoomTopOprationManager.new(CEnum.pageView.mirrorPdkPage) --顶部操作及显示
    ctx.statusManager = StatusManager.new()
    ctx.outcardManager = OutcardManager.new(30)
    ctx.readyControl = ReadyControl.new()
    ctx.outCardControl = OutCardControl.new()
    ctx.weChatInviteControl = WeChatInviteControl.new()
    ctx.showCardsManager = PDKShowOtherCardsManager.new(30)
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
    ctx.export(ctx.showCardsManager)

    self.isSetedDealer = false
end

function PDKPlaybackController:createNodes()

    self.mycardView:addTo(self.scene)
	self.roomPlayerManager:createNodes()
	self.roomTopOprationManager:createNodes()
    self.outcardManager:createNodes()
    self.showCardsManager:createNodes()
    self.statusManager:createNodes()
    self.roomTopOprationManager:setStartTime(self.startTime)

     -- 控制层
    local yCoord = 265
    self.readyControl:addTo(self.scene)
        :pos(display.width/2,yCoord)
        :setDelegate(self)
    self.outCardControl:addTo(self.scene)
        :pos(display.width/2,yCoord)
        :setDelegate(self)
    self.weChatInviteControl:addTo(self.scene)
        :pos(display.width/2,yCoord-70)
        :setDelegate(self)
    self.animManager:createNodes()

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

    -- =====楼下塞一通假数据
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
end

function PDKPlaybackController:doAction(data)

    -- 每笔数据来了
    self.model:parseLogin(data)
            local roomdata = self.model:getRoomInfo()
            self.roomTopOprationManager:init(roomdata)
            self.roomTopOprationManager:setRoomId(roomdata.roomNo)
            self.roomTopOprationManager:setTable(roomdata.playRound,roomdata.rounds)
            self.roomPlayerManager:init()
            self.roomPlayerManager:hideAllCards()

            -- 回合结束
            local tableOverData = self.model:getTableOverData()
            if tableOverData then
                -- 回合结束，需要显示回合结算信息
                --PDKOverRoundDialog.new(tableOverData,self.gameOverData,tableOverCallback):addTo(self.scene)
                
                -- self.roomPlayerManager:hideAllCards()--去掉玩家牌张数
                self:hideOperation() --关闭所有控件
                --self.mycardView:clearAllCard()
                self.animManager:stopAllClock() -- 回合结束，停止所有闹钟倒计时
                self.statusManager:hideAll() -- 回合结束，隐藏所有玩家状态
                -- self.outcardManager:hideAll() -- 回合结束，最后出的牌 清空
                self.animManager:stopWarning() -- 回合结束，有报警，清空
                self.isSetedDealer = false -- 回合结束，庄家图标不能再次设置

                -- self.statusManager:dealWin() -- 回合结束，显示输赢
                self.animManager:playWinForPlayback() -- 回合结束，播放赢的图标
                do return end
            end 

            -- 手牌
            local myCardList = self.model:getMyHandCards()
            if #myCardList>0 and self.mycardView:isSeted() == false then
                self.mycardView:clearAllCard()
                self.mycardView:setCard(myCardList)
            end
            self.showCardsManager:init()

            self.weChatInviteControl:hideAll() -- 邀请微信好友  按钮  隐藏

            self.statusManager:dealReady() -- 玩家状态  准备

            --以下情况如果发生在玩家牌局中登录，会要执行下出牌等操作.
            if roomdata.status == CEnum.roomStatus.started then -- "started" then
                self.statusManager:hideAll() -- 玩家状态  全部隐藏

                -- self.roomPlayerManager:showAllLeftCards()
                self.roomPlayerManager:upDateScore() --刷新玩家分数

                -- 设置庄家图标
                if self.isSetedDealer == false then
                    self.isSetedDealer = true
                    self.roomPlayerManager:setDealer()
                end

                -- 是不是本人出牌
                local selfData = self.model:getSelfSeatData()
                if selfData.chu == true then
                    self.tipsIndex_ = 0
                    --开启出牌操作区
                    self.outCardControl:exec(1)
                end

                -- 其他玩家信息
                local playerList = self.model:getPlayerList()
                for i=1,#playerList do
                    local seatPlayerData = playerList[i]
                    local tempSeatId = self.model:getOtherClientSeatId(playerList[i].seatNo)
                    --设置下家出牌闹钟
                    if seatPlayerData.chu == true then
                        -- self.animManager:showClock(tempSeatId, CVar._static.clockWiseTime)
                    end
                end
            end

    
    --出牌
    local selfData = self.model:getSelfSeatData()
            -- 如果本人出牌
            if selfData.chu == true then
                --重置联想牌数字
                self.tipsIndex_ = 0
                --打开出牌，提示按钮
                self.outCardControl:exec(1)

                local cmd_action
                if self.model:getSelfSeatData().options then
                    --抓出出牌动作
                    cmd_action = RequestBase:getStrDecode(self.model:getSelfSeatData().options[1])
                end

                if cmd_action == CEnum.playOptions.guo then -- 过牌，直接隐藏出牌按钮
                    local playerAction = self.model:getAction()
                    local actionNo
                    if playerAction then
                        actionNo = playerAction.actionNo
                    end
                    self.outCardControl:hideAll()
                end
            else
                -- 隐藏出牌按钮
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
                    -- self.animManager:showClock(tempSeatId, CVar._static.clockWiseTime)
                    self.outcardManager:hideOutCard(tempSeatId)
                    self.statusManager:hideStatus(tempSeatId)
                end

                --出牌  各种操作
                if seatPlayerData.action and seatPlayerData.action.type == CEnum.options.chu then
                    -- 界面出牌操作
                    if seatPlayerData.action.cards and #seatPlayerData.action.cards>0  then

                        VoiceDealUtil:playSound_other(PDKVoices.file.outCard)

                        outSeatId = tempSeatId
                        outCards = self.model:getListForClient(seatPlayerData.action.cards)
                        self.outcardManager:showOutCard(outSeatId,outCards)

                        -- 牌少于1张，播放报警动画，有服务器告知
                        if seatPlayerData.alarm == true then
                            self.animManager:playWarning(outSeatId)
                            VoiceDealUtil:playSound_other(PDKVoices.file.alert)
                            scheduler.performWithDelayGlobal(function ()
                                VoiceDealUtil:playSound_other(PDKVoices.file.leftOneCard)
                            end, 0.8)
                        end

                        -- 自己打了牌,刷新当前手牌
                        if seatPlayerData.me == true then
                            self.mycardView:removeOutCard(outCards)
                        else
                            self.showCardsManager:outCards(outSeatId,outCards)
                        end
                    end

                    --牌型动画,音效。
                    --牌型
                    local poker_type = RequestBase:getStrDecode(seatPlayerData.action.cardType)
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
                            end,0.4
                        )

                    elseif poker_type == CEnumP.serverCardType.shun then
                        --顺子
                        VoiceDealUtil:playSound_other(PDKVoices.file.shunzi)
                        scheduler.performWithDelayGlobal(
                            function()
                                self.animManager:playPokerType(CEnumP.POKER_TYPE.SHUNZI)
                                VoiceDealUtil:playSound_other(PDKVoices.file.shunzi_1)
                            end,0.4
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
                            end,0.4
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

                -- 出牌的时候，要不起
                if seatPlayerData.action and seatPlayerData.action.type == CEnum.playOptions.guo then
                     VoiceDealUtil:playSound_other(PDKVoices.file.buyao1)
                end

            end

    self.statusManager:dealPassOut()
end

-- 关闭所有可以操作的按钮
function PDKPlaybackController:hideOperation()
    self.weChatInviteControl:hide() -- 邀请按钮
    self.outCardControl:hide() -- 出牌按钮
    self.readyControl:hide() -- 准备按钮
end

-- 清桌操作
function PDKPlaybackController:clearCurTableStatus()
    self:hideOperation() -- 关闭所有可以操作的按钮

    self.mycardView:clearAllCard() -- 手牌  清理
    self.animManager:stopAllClock() -- 所有的倒计时  停止
    self.statusManager:hideAll() -- 所有玩家状态 清理
    self.outcardManager:hideAll() -- 所有出牌 清理
    self.animManager:stopWarning() -- 告警 清理
    self.isSetedDealer = false -- 庄家图标不能再次设置
end

--杀进程
function PDKPlaybackController:dispose()
    self:clearCurTableStatus() -- 清桌操作

    self.showCardsManager:cleanAllCard() -- 展示的牌处理
    self.mycardView:setIsSeted(false) -- 手牌提示处理

    -- 界面组件全部销毁
	self.roomTopOprationManager:dispose()
    self.animManager:dispose()
    self.roomPlayerManager:dispose()
    self.model:dispose()
    self.showCardsManager:dispose()
end

return PDKPlaybackController