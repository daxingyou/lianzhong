--
--

local MirrorMJRoomDialog = class("MirrorMJRoomDialog")

local osWidth = Commons.osWidth
local osHeight = Commons.osHeight







local parent_mirror
local res_data_mirror
local startTime_mirror

local showDate_gaptime_init = 0.8 -- 默认回放间隔时间
local getData_indexNo_init = 1  -- 默认第一步的值

local getData_indexNo_Max = 1000000  -- 播放的最大步
local getData_indexNo = getData_indexNo_init  -- 播放第几步
local getData_indexNo_Pause = 0  -- 暂停时候是第几步

local showDate_gaptime = showDate_gaptime_init -- 播放一组一组数据的间隔，间隔越短，就越播放的越快
local showDate_gaptimeMax = 3.0 -- 3秒，间隔最大值，给慢放控制的
local showDate_gaptimeMin = 0.01 -- 10毫秒，间隔最小值，给快放控制的

local showDate_gaptime_k_Step = 0.3 -- 快放的步长 showDate_gaptime 减少为 showDate_gaptimeMin
local showDate_gaptime_m_Step = 0.3 -- 慢放的步长 showDate_gaptime 增加到 showDate_gaptimeMax

local pauseBtn
local onAgainBtn
local playBtn

-- function MirrorMJRoomDialog:ctor()
-- end
-- 创建一个模态弹出框,  parent=要加在哪个上面
function MirrorMJRoomDialog:popDialogBox(_parent, _res_data, _startTime)

    parent_mirror = _parent
    res_data_mirror = _res_data
    startTime_mirror = _startTime

    self.Layer1 = display.newColorLayer(cc.c4b(0, 0, 0, 200))       -- 半透明的黑色

    self.Layer1:setContentSize(osWidth, osHeight)             -- 设置Layer的大小,全屏出现
    --Layer1:align(display.CENTER, display.cx, display.cy) -- Layer的锚点在0.5,0.5 因此对齐的时候要注意
    self.Layer1:setTouchEnabled(true)
    self.Layer1:setTouchSwallowEnabled(true)  -- 吞噬下层的响应
    self.Layer1:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event) -- 点击此Layer时候输出信息,然后把自己销毁        
        return true
    end)
    _parent:addChild(self.Layer1, CEnum.ZOrder.common_dialog) -- 把Layer添加到父对象上

    -- 整个底色背景
    ---[[
    cc.ui.UIImage.new(ImgsM.room_bg,{})
        :addTo(self.Layer1)
        :align(display.LEFT_TOP, 0, osHeight-0)
        :setLayoutSize(osWidth-0*2, osHeight-0*2)
    --]]

    -- 操作按钮
    local btn_w_gap = 0
    local btn_w_mirror = 120
    local btn_h_mirror = 116
    local startX_mirror = display.cx -(btn_w_gap+btn_w_mirror)*2 +btn_w_gap+btn_h_mirror/2
    local startY_mirror = display.cy -- -100 -- -btn_h_mirror/2

    cc.ui.UIPushButton.new(Imgs.gamemirror_bg,{scale9=true})
        :setButtonSize(560, 120)
        :setButtonImage(EnStatus.pressed, Imgs.gamemirror_bg)
        :addTo(self.Layer1, CEnum.ZOrder.gameingMirror_btn)
        :align(display.CENTER, display.cx, startY_mirror)

    ---[[
    -- 关闭  返回
    cc.ui.UIPushButton.new(Imgs.gamemirror_4back,{scale9=false})
        :setButtonSize(btn_w_mirror, btn_h_mirror)
        :setButtonImage(EnStatus.pressed, Imgs.gamemirror_4back)
        :onButtonClicked(function(e)

            VoiceDealUtil:playSound_other(Voices.file.ui_click)
            self:myExit()

        end)
        :addTo(self.Layer1, CEnum.ZOrder.gameingMirror_btn)
        :align(display.CENTER, startX_mirror +(btn_w_gap+btn_w_mirror)*3, startY_mirror)
    --]]

    ---[[
    -- 慢放按钮
    cc.ui.UIPushButton.new(
        Imgs.gamemirror_1mf,{scale9=false})
        :setButtonSize(btn_w_mirror, btn_h_mirror)
        :setButtonImage(EnStatus.pressed, Imgs.gamemirror_1mf)
        :onButtonClicked(function(e)

            showDate_gaptime = showDate_gaptime + showDate_gaptime_m_Step
            if showDate_gaptime >= showDate_gaptimeMax then
                showDate_gaptime = showDate_gaptimeMax
            end

        end)
        :align(display.CENTER, startX_mirror +(btn_w_gap+btn_w_mirror)*0, startY_mirror)
        :addTo(self.Layer1, CEnum.ZOrder.gameingMirror_btn)
    --]]

    ---[[
    -- 快放按钮
    cc.ui.UIPushButton.new(
        Imgs.gamemirror_3kf,{scale9=false})
        :setButtonSize(btn_w_mirror, btn_h_mirror)
        :setButtonImage(EnStatus.pressed, Imgs.gamemirror_3kf)
        :onButtonClicked(function(e)

            showDate_gaptime = showDate_gaptime - showDate_gaptime_k_Step
            if showDate_gaptime <= showDate_gaptimeMin then
                showDate_gaptime = showDate_gaptimeMin
            end

        end)
        :align(display.CENTER, startX_mirror +(btn_w_gap+btn_w_mirror)*2, startY_mirror)
        :addTo(self.Layer1, CEnum.ZOrder.gameingMirror_btn)
    --]]

    ---[[
    -- 暂停按钮
    pauseBtn = cc.ui.UIPushButton.new(
        Imgs.gamemirror_2pause,{scale9=false})
        :setButtonSize(btn_w_mirror, btn_h_mirror)
        :setButtonImage(EnStatus.pressed, Imgs.gamemirror_2pause)
        :onButtonClicked(function(e)

            getData_indexNo_Pause = getData_indexNo
            getData_indexNo = getData_indexNo_Max

            pauseBtn:setVisible(false)
            onAgainBtn:setVisible(true)
            playBtn:setVisible(false)

        end)
        :align(display.CENTER, startX_mirror +(btn_w_gap+btn_w_mirror)*1, startY_mirror)
        :addTo(self.Layer1, CEnum.ZOrder.gameingMirror_btn)
        :setVisible(true)
    --]]

    ---[[
    -- 继续按钮
    onAgainBtn = cc.ui.UIPushButton.new(
        Imgs.gamemirror_2on,{scale9=false})
        :setButtonSize(btn_w_mirror, btn_h_mirror)
        :setButtonImage(EnStatus.pressed, Imgs.gamemirror_2on)
        :onButtonClicked(function(e)

            getData_indexNo = getData_indexNo_Pause
            self:setViewData()

            pauseBtn:setVisible(true)
            onAgainBtn:setVisible(false)
            playBtn:setVisible(false)

        end)
        :align(display.CENTER, startX_mirror +(btn_w_gap+btn_w_mirror)*1, startY_mirror)
        :addTo(self.Layer1, CEnum.ZOrder.gameingMirror_btn)
        :setVisible(false)
    --]]

    ---[[
    -- 播放按钮
    playBtn = cc.ui.UIPushButton.new(
        Imgs.gamemirror_2play,{scale9=false})
        :setButtonSize(btn_w_mirror, btn_h_mirror)
        :setButtonImage(EnStatus.pressed, Imgs.gamemirror_2play)
        :onButtonClicked(function(e)

            getData_indexNo = getData_indexNo_init
            self:myViewReset_playAgain()

            self:setViewData()

            pauseBtn:setVisible(true)
            onAgainBtn:setVisible(false)
            playBtn:setVisible(false)

        end)
        :align(display.CENTER, startX_mirror +(btn_w_gap+btn_w_mirror)*1, startY_mirror)
        :addTo(self.Layer1, CEnum.ZOrder.gameingMirror_btn)
        :setVisible(false)
    --]]

    -- view
    self:createView()
    self:setViewData()
end
-- 选择再来一局，需要将房间界面重置，该去掉的去掉，该隐藏的隐藏
function MirrorMJRoomDialog:myViewReset_playAgain()
    -- 不退出回放界面，再继续看一遍
    self:myViewReset_thisDesktop()
end
function MirrorMJRoomDialog:myExit()
    self:myViewReset_thisDesktop()

    --关闭倒计时
    TimerM:killAll()

    parent_mirror = nil
    res_data_mirror = nil
    startTime_mirror = nil
    
    if self.Layer1 ~= nil and (not tolua.isnull(self.Layer1)) then
        self.Layer1:removeFromParent()
        self.Layer1 = nil
    end
end
-- 选择再来一局，需要将房间界面重置，该去掉的去掉，该隐藏的隐藏
function MirrorMJRoomDialog:myViewReset_thisDesktop()
    local mySelfPrepareBtn = self.playerHeardViewList[1].btnPrepare
    if mySelfPrepareBtn ~= nil and (not tolua.isnull(mySelfPrepareBtn)) then
        CVar._static.isNeedShowPrepareBtn = true

        mySelfPrepareBtn:setVisible(true)
        mySelfPrepareBtn:setButtonEnabled(false)
    end

    --清除当前房间数据
    self.curResData = nil
    self.prevHandCard = nil

    --清除当前我的手牌
    for k,v in pairs(self.curMyHandCards) do
        if v ~= nil and (not tolua.isnull(v)) then
            v:removeFromParent()
        end
    end
    self.curMyHandCards = {}

    --清除当前我吃，碰，杠的列表
    for k,v in pairs(self.curMyPGChiCards) do
        if v ~= nil and (not tolua.isnull(v)) then
            v:removeFromParent()
        end
    end
    self.curMyPGChiCards = {}

    --清除其他玩家吃，碰，杠的组合列表(上一玩家4，下一玩家2，对家3)
    for k,v in pairs(self.otherPGCHiCards) do
        for ik,iv in pairs(v) do
            if iv ~= nil and (not tolua.isnull(iv)) then
                iv:removeFromParent()
            end
        end
    end
    self.otherPGCHiCards = {[2]={},[3]={},[4]={}}

    --隱藏其他玩家手牌组合列表(上一玩家4，下一玩家2，对家3)
    self:changeOtherPlayerHandCardsVisible("n")

    --清除玩家已经出的牌组合列表(1我,上一玩家4，下一玩家2，对家3)
    for k,v in pairs(self.hasChuCards) do
        for ik,iv in pairs(v) do
            if iv ~= nil and (not tolua.isnull(iv)) then
                iv:removeFromParent()
            end
        end
    end
    self.hasChuCards = {[1]={},[2]={},[3]={},[4]={}}

    --清除玩家明牌组合列表(上一玩家4，下一玩家2，对家3)
    for k,v in pairs(self.otherHandCardMingPaiDic) do
        for ik,iv in pairs(v) do
            if iv ~= nil and (not tolua.isnull(iv)) then
                iv:removeFromParent()
            end
        end
    end
    self.otherHandCardMingPaiDic = {[2]={},[3]={},[4]={}}

    --清除其他玩家摸出的牌list
    for k,v in pairs(self.otherMoCards) do
        if v ~= nil and (not tolua.isnull(v)) then
            v:hide()
            v:removeFromParent()
        end
    end    
    self.otherMoCards = {}

    self.box_chupai:hide()
    self.centerView:hide()
    self.zhongMaNode:removeAllChildren()
    self.tingTipsNode:hide()

    --我当前的手牌数据
    self.currMyHandCardsData = nil
    --我是否可以出牌
    self.isMeChu = false
    --当前出的那张牌
    --self.curMoveMyHandCard = nil
    --碰，杠，吃牌动画运行中，为true时候需要延迟刷新手牌
    self.isPengGangChiMoving = false
    --当前碰，杠，吃牌动画运行完成的个数
    self.totalMoveCount = 0
    --其他玩家当前摸到的手牌
    self.otherMoHandCard = nil
    --当前谁出牌倒计时
    self.chu_seatNo = CEnumM.seatNo.init
    --手牌最后一张是否要间距
    self.handSeparate = false
    --当前出牌的客户端座位号
    self.chuClientNo = -1
    --当前的倒计时进度条
    self.curProgressCircle = nil
    --当前选中的头像
    self.curSelHeader = nil
    self.isMyHu = false

    self.diCardGridBgImage:hide()
    self.diCardGrid:hide()
    self.lookDiCardBtn:hide()
    self.hideDiCardBtn:hide()
end






function MirrorMJRoomDialog:createView()
    getData_indexNo = getData_indexNo_init
    showDate_gaptime = showDate_gaptime_init

    ----------- 全部的页面创建 ----------------------------------

    -- 预加载这些动画plist文件
    display.addSpriteFrames(Imgs.voiceplay_plist, Imgs.voiceplay_png) -- 语音播放动画
    display.addSpriteFrames(Imgs.biaoqing_expContent.."exp"..Imgs.file_imgPlist_suff, Imgs.biaoqing_expContent.."exp"..Imgs.file_img_suff) -- 表情
    --加载麻将纹理
    display.addSpriteFrames(ImgsM.mjhand_plist, ImgsM.mjhand_texture)
    display.addSpriteFrames(ImgsM.superEmoji_plist, ImgsM.superEmoji_texture)

    self.top_view_dissRoom = nil

    self.players_havePerson = 0 -- 有几个玩家

    --当前房间数据
    self.curResData = nil
    --房间号
    self.roomNoLabel = nil
    --玩法规则
    self.basicRule = nil
    --当前我的座位号
    self.mySeatNo = nil
    --当前我的手牌
    self.curMyHandCards = {}
    --当前我已经出的牌
    --self.curMyChuCards = {}
    --当前我吃，碰，杠的列表
    self.curMyPGChiCards = {}
    --其他玩家吃，碰，杠的组合列表(上一玩家4，下一玩家2，对家3)
    self.otherPGCHiCards = {[2]={},[3]={},[4]={}}
    --玩家已经出过的牌一行为10列
    self.chuCardColumn = 10
    --手牌离底部的距离
    self.CARD_TO_BOTTOM = 60

    --其他玩家手牌组合列表(上一玩家4，下一玩家2，对家3)
    self.otherHandCards = {[2]={},[3]={},[4]={}}
    --其他玩家已经出的牌组合列表(上一玩家4，下一玩家2，对家3)
    --self.otherHasChuCards = {[2]={},[3]={},[4]={}}
    --玩家已经出的牌组合列表(1我,上一玩家4，下一玩家2，对家3)
    self.hasChuCards = {[1]={},[2]={},[3]={},[4]={}}
    --其他玩家游戏结束后的明牌组合列表
    self.otherHandCardMingPaiDic = {[2]={},[3]={},[4]={}}
    --我当前的手牌数据
    self.currMyHandCardsData = nil
    --我的出牌的指示
    self.box_chupai = nil
    --我是否可以出牌
    self.isMeChu = false
    -- 吃、碰、过、胡才有的选择
    self.myself_view_needOption_list = nil 
    --当前出的那张牌
    --self.curMoveMyHandCard = nil
    --碰，杠，吃牌动画运行中，为true时候需要延迟刷新手牌
    self.isPengGangChiMoving = false
    --当前碰，杠，吃牌动画运行完成的个数
    self.totalMoveCount = 0
    --其他玩家当前摸到的手牌
    self.otherMoHandCard = nil
    --听牌列表
    self.tingBgSprite = nil
    --当前谁出牌倒计时
    self.chu_seatNo = CEnumM.seatNo.init
    --当前杠，碰可选择的牌
    self.gangDemosListBg = nil
    --手牌最后一张是否要间距
    self.handSeparate = false
    --当前出牌的客户端座位号
    self.chuClientNo = -1
    --当前的倒计时进度条
    self.curProgressCircle = nil
    --当前选中的头像
    self.curSelHeader = nil
    --是否已经胡牌
    self.isMyHu = false
    --游戏人数
    self.playerNum = -1
    --其他玩家摸出的牌list
    self.otherMoCards = {}

    --手牌缩放系数
    self.handCardScaleFact = 1
    self.diCardGrid_mov_y = 0
    
    if CVar._static.isIphone4 then
        self.handCardScaleFact = 0.82
        self.diCardGrid_mov_y = 50
    elseif CVar._static.isIpad then
        self.handCardScaleFact = 0.78
        self.diCardGrid_mov_y = 65
    elseif CVar._static.NavBarH_Android ~= CEnum.status.NavBarH_def then
        self.handCardScaleFact = 0.92
    end

    CVar._static.isNeedShowPrepareBtn = true -- 是否需要显示准备按钮，默认是显示 

    -- 我的信息
    local user = GameStateUserInfo:getData()
    self.myIcon = RequestBase:getStrDecode(user[User.Bean.icon])
    self.myNickname = Commons:trim(RequestBase:getStrDecode(user[User.Bean.nickname]) )
    self.myAccount = user[User.Bean.account]
    self.myIp = user[User.Bean.ip]
    self.myRights = user[User.Bean.rights]
    Commons:printLog_Info("icon：",self.myIcon)
    Commons:printLog_Info("nickname:",self.myNickname)
    Commons:printLog_Info("account:",self.myAccount)
    Commons:printLog_Info("ip:",self.myIp)

    --中码节点
    self.zhongMaNode = display.newNode():addTo(self.Layer1, CEnumM.ZOrder.playerNode+12):align(display.LEFT_BOTTOM, 0, 0)

    -- 可以吃，碰，过，胡才有的集合
    self.myself_view_needOption_list = 
        cc.ui.UIListView.new({
            bgScale9 = true,
            capInsets = cc.rect(0, 0, 150*7, 132),
            viewRect = cc.rect(0, 0, 150*7, 132),
            -- direction = cc.ui.UIScrollView.DIRECTION_VERTICAL, -- 竖着摆放
            direction = cc.ui.UIScrollView.DIRECTION_HORIZONTAL, -- 水平摆放
            alignment = cc.ui.UIListView.ALIGNMENT_VCENTER
        })
        :addTo(self.Layer1, 50)
        :align(display.CENTER, display.cx-80*self.handCardScaleFact, display.bottom+150)
        :setScale(self.handCardScaleFact)

    self.gangDemosListBg = display.newScale9Sprite(ImgsM.tingBg, 0,0, 
                        cc.size(330, 100), 
                        cc.rect(10, 10, 10, 10)
                      )
            :align(display.CENTER, display.cx, display.cy)
            :addTo(self.Layer1, 40)
            :hide()

    self.gangDemosListBg.gangDemosListView = cc.ui.UIListView.new({
            bgScale9 = true,
            capInsets = cc.rect(0, 0, 55*7, 86),
            viewRect = cc.rect(0, 0, 55*7, 86),
            -- direction = cc.ui.UIScrollView.DIRECTION_VERTICAL, -- 竖着摆放
            direction = cc.ui.UIScrollView.DIRECTION_HORIZONTAL, -- 水平摆放
            alignment = cc.ui.UIListView.ALIGNMENT_VCENTER
        })
        :addTo(self.gangDemosListBg, 50)
        :align(display.LEFT_BOTTOM, 5, 5)

    self:createTopView()
    self:createRoomCenterInfo()
    self:createChuPaiTixing()

    --创建底牌Grid
    self.diCardGridBgImage = display.newScale9Sprite(ImgsM.tingBg, 0,0, 
                                        cc.size(470, 40 * 3 + 20), 
                                        cc.rect(10, 10, 10, 10)
                                      )
                            :align(display.LEFT_BOTTOM, 390*self.handCardScaleFact, 295)
                            :addTo(self.Layer1, CEnumM.ZOrder.playerNode+13)
                            :hide()

    self.diCardGridBgImage.noDiCard = display.newTTFLabel({
            text = "底牌已摸完",
            size = Dimens.TextSize_30,
            --color = Colors:_16ToRGB(Colors.directionText),
            color =  Colors.white,
            font = Fonts.Font_hkyt_w9,
            align = cc.ui.TEXT_ALIGN_CENTER,
            valign = cc.ui.TEXT_VALIGN_CENTER,
        })
        :addTo(self.diCardGridBgImage)
        :align(display.CENTER, self.diCardGridBgImage:getContentSize().width * 0.5, self.diCardGridBgImage:getContentSize().height * 0.5)
        :hide()

    self.diCardGrid = cc.ui.UIListView.new {
        viewRect = cc.rect(370*self.handCardScaleFact, 305*self.handCardScaleFact, 380, 120),
        direction = cc.ui.UIScrollView.DIRECTION_VERTICAL}
        :addTo(self.Layer1, CEnumM.ZOrder.playerNode+14)
        :hide()

    --玩家头像及信息视图列表
    self.playerHeardViewList = {}
    --创建自己头像信息
    self:createPlayerHeaderInfo({
            heardBoder_X = 13,
            heardBoder_Y = 81+95,
            heardBoder_AnchorPoint = display.LEFT_TOP,
            heardIcon_X = 20,
            heardIcon_Y = 169,
            heardIcon_AnchorPoint = display.LEFT_TOP,
            nickName_X = 58,
            nickName_Y = 80,
            nickName_AnchorPoint = display.CENTER_TOP,
            scoreLabel_X = 58,-- 13,
            scoreLabel_Y = 65,
            scoreLabel_AnchorPoint = display.CENTER_TOP,
            isBanker_X = 20,
            isBanker_Y = 169,
            isBanker_AnchorPoint = display.LEFT_TOP,
            btnPrepare_X = display.cx,
            btnPrepare_Y = osHeight-630,
            btnPrepare_AnchorPoint = display.CENTER,
            viewOffline_X = 23,
            viewOffline_Y = 147,
            viewOffline_AnchorPoint = display.LEFT_TOP,
            iconPath = self.myIcon,
            headview_X = display.left,
            headview_Y = display.bottom+110
        })

    --创建下家头像信息
    self:createPlayerHeaderInfo({
            heardBoder_X = 13,
            heardBoder_Y = 81+95,
            heardBoder_AnchorPoint = display.LEFT_TOP,
            heardIcon_X = 20,
            heardIcon_Y = 169,
            heardIcon_AnchorPoint = display.LEFT_TOP,
            nickName_X = 58,
            nickName_Y = 80,
            nickName_AnchorPoint = display.CENTER_TOP,
            scoreLabel_X = 58,-- 13,
            scoreLabel_Y = 65,
            scoreLabel_AnchorPoint = display.CENTER_TOP,
            isBanker_X = 20,
            isBanker_Y = 169,
            isBanker_AnchorPoint = display.LEFT_TOP,
            btnPrepare_X = -95,
            btnPrepare_Y = 180,
            btnPrepare_AnchorPoint = display.LEFT_TOP,
            viewOffline_X = 23,
            viewOffline_Y = 147,
            viewOffline_AnchorPoint = display.LEFT_TOP,
            iconPath = self.myIcon,
            headview_X = display.right - 120,
            headview_Y = display.bottom + 320
        })

    --创建对家头像信息
    self:createPlayerHeaderInfo({
            heardBoder_X = 13,
            heardBoder_Y = 81+95,
            heardBoder_AnchorPoint = display.LEFT_TOP,
            heardIcon_X = 20,
            heardIcon_Y = 169,
            heardIcon_AnchorPoint = display.LEFT_TOP,
            nickName_X = 58,
            nickName_Y = 80,
            nickName_AnchorPoint = display.CENTER_TOP,
            scoreLabel_X = 58,-- 13,
            scoreLabel_Y = 65,
            scoreLabel_AnchorPoint = display.CENTER_TOP,
            isBanker_X = 20,
            isBanker_Y = 169,
            isBanker_AnchorPoint = display.LEFT_TOP,
            btnPrepare_X = -95,
            btnPrepare_Y = 180,
            btnPrepare_AnchorPoint = display.LEFT_TOP,
            viewOffline_X = 23,
            viewOffline_Y = 147,
            viewOffline_AnchorPoint = display.LEFT_TOP,
            iconPath = self.myIcon,
            headview_X = display.right - (253 + 94)*self.handCardScaleFact,
            headview_Y = display.top - 55 - 176
        })

    --创建上家头像信息
    self:createPlayerHeaderInfo({
            heardBoder_X = 13,
            heardBoder_Y = 81+95,
            heardBoder_AnchorPoint = display.LEFT_TOP,
            heardIcon_X = 20,
            heardIcon_Y = 169,
            heardIcon_AnchorPoint = display.LEFT_TOP,
            nickName_X = 58,
            nickName_Y = 80,
            nickName_AnchorPoint = display.CENTER_TOP,
            scoreLabel_X = 58,-- 13,
            scoreLabel_Y = 65,
            scoreLabel_AnchorPoint = display.CENTER_TOP,
            isBanker_X = 20,
            isBanker_Y = 169,
            isBanker_AnchorPoint = display.LEFT_TOP,
            btnPrepare_X = 120,
            btnPrepare_Y = 180,
            btnPrepare_AnchorPoint = display.LEFT_TOP,
            viewOffline_X = 23,
            viewOffline_Y = 147,
            viewOffline_AnchorPoint = display.LEFT_TOP,
            iconPath = self.myIcon,
            headview_X = display.left,
            headview_Y = display.bottom + 320
        })

    --创建其他三个玩家的手牌
    self:createOtherPlayerHandCards()
    --创建听牌tips
    self:createTingTips()
end

-- 全部的数据，一步步的播放出来
function MirrorMJRoomDialog:setViewData()
    -- print("================回放来起拉--11-----------", res_data_mirror, type(res_data_mirror))
    if Commons:checkIsNull_str(res_data_mirror) then --这里还是字符串

        local res_data_single = nil
        local receive_res_data = nil

        local res_status = nil
        local res_msg = nil
        local res_cmd = nil
        local res_data = nil


            res_data_single = ParseBase:parseToJsonObj(res_data_mirror)
            --print("================回放来起拉--22-----------", res_data_single, type(res_data_single))
            local _size_mirror = #res_data_single
            getData_indexNo_Max = _size_mirror
            --print("================回放来起拉--33-----------", _size_mirror)

            if Commons:checkIsNull_tableList(res_data_single) then
                receive_res_data = res_data_single[getData_indexNo]

                local show_step = getData_indexNo -- 播放到第几步
                if getData_indexNo~=nil and _size_mirror~=nil and getData_indexNo>_size_mirror then
                    show_step = _size_mirror
                end
                if getData_indexNo_Pause ~= 0 then
                    show_step = getData_indexNo_Pause
                end
                if self.step_label and not tolua.isnull(self.step_label) then
                    -- self.step_label:removeFromParent()
                    -- self.step_label = nil
                    self.step_label:setString(show_step.."/".._size_mirror)
                else
                    self.step_label = cc.ui.UILabel.new({
                            UILabelType = 2, 
                            --image = "",
                            text = show_step.."/".._size_mirror, 
                            size = Dimens.TextSize_18,
                            color = Colors.versionName,
                            font = Fonts.Font_hkyt_w7,
                            align = cc.ui.TEXT_ALIGN_CENTER,
                            valign = cc.ui.TEXT_VALIGN_CENTER,
                            --dimensions = cc.size((osWidth-120),0) -- height为0，就是自动换行
                            --dimensions = cc.size(200,50)
                        })
                        :addTo(self.Layer1, CEnum.ZOrder.gameingMirror_btn)
                        -- :align(display.CENTER, display.cx, display.cy -100 +20)
                        :align(display.RIGHT_TOP, osWidth-6, osHeight-2 -20)
                end
            end  

            -- res_data_single = RequestBase:getStrDecode(res_data_mirror[getData_indexNo]) -- 转编码之后的字符串
            -- receive_res_data = ParseBase:parseToJsonObj(res_data_single) -- 字符串变为table对象去使用

            if res_data_single~=nil and receive_res_data~=nil then
                res_data = receive_res_data
                Commons:printLog_Info("==MirrorMJRoomDialog: data", res_data)
                Commons:printLog_Info("==MirrorMJRoomDialog: 第几个数据", getData_indexNo)
                Commons:printLog_Info("==MirrorMJRoomDialog: 间隔时间", showDate_gaptime)

                ----------- 全部的数据展示 ----------------------------------
                self.curResData = res_data
                if res_data ~= nil then
                    local players = res_data[Room.Bean.players]
                    if players ~= nil and type(players)=="table" then
                        for k,v in pairs(players) do
                            if v[Player.Bean.me] then
                                self.mySeatNo = v[Player.Bean.seatNo]
                                break
                            end
                        end
                    end
                end
                
                self:top_setViewData(res_data)-- 顶部组件 数值显示出来
                self:dcard_setViewData(res_data, res_cmd)-- 底牌
                self:players_info_setViewData(res_data) -- 自己位置的界面组件 数值显示出来
                self:myself_handCard_createView_setViewData(res_data)-- 我手上的牌   主位置
                self:players_handCard_setViewData(res_data)-- 每位玩家 上次吃牌动画| 已经出过的牌| 已经吃、碰过的牌| 并且庄家第一次出牌

                -- self:players_online_offline(res_data)

                self:players_diCard_refreshViewData(res_data)-- 底牌明牌显示
                self:huCard_createView_setViewData(res_data) -- 胡牌  也是有效果的  --todo效果还需要完善


                self.Layer1:performWithDelay(function ()
                    getData_indexNo = getData_indexNo + 1
                    self:setViewData()
                    --[[
                    -- 测试使用
                    if getData_indexNo == 2  then -- 预设第几步跳出，就把最后步数直接设置为一个超大值
                        getData_indexNo = getData_indexNo_Max
                    end
                    --]]
                end, showDate_gaptime)
            else
                res_data_single = nil
                receive_res_data = nil

                res_status = nil
                res_msg = nil
                res_cmd = nil
                res_data = nil
            end

            if getData_indexNo == _size_mirror then
                pauseBtn:setVisible(false)
                onAgainBtn:setVisible(false)
                playBtn:setVisible(true)
            end
        
    end
end

--创建桌面中间信息
function MirrorMJRoomDialog:createRoomCenterInfo()
    --玩家指示列表，标注当前哪个玩家出牌
    self.zhiShiList = {}

    self.centerView = cc.NodeGrid:create()
    self.centerView:addTo(self.Layer1)
    self.centerView:setVisible(false)

    display.newSprite(ImgsM.mj_namebg)
        :addTo(self.centerView)
        :align(display.CENTER_BOTTOM, display.cx, display.cy+40)

    local timeBg = display.newSprite(ImgsM.timebg)
        :addTo(self.centerView)
        :align(display.CENTER, display.cx, display.cy)

    local zhishiBoom = display.newSprite(ImgsM.zhishi_boom)
        :addTo(timeBg)
        :align(display.CENTER_BOTTOM, timeBg:getContentSize().width * 0.5, 12)
        :hide()
    self.zhiShiList[#self.zhiShiList + 1] = zhishiBoom

    local zhishiRight = display.newSprite(ImgsM.zhishi_right)
        :addTo(timeBg)
        :align(display.RIGHT_CENTER, timeBg:getContentSize().width - 12, timeBg:getContentSize().height * 0.5)
        :hide()
    self.zhiShiList[#self.zhiShiList + 1] = zhishiRight

    local zhishiTop = display.newSprite(ImgsM.zhishi_top)
        :addTo(timeBg)
        :align(display.CENTER_TOP, timeBg:getContentSize().width * 0.5, timeBg:getContentSize().height-12)
        :hide()
    self.zhiShiList[#self.zhiShiList + 1] = zhishiTop

    local zhishiLeft = display.newSprite(ImgsM.zhishi_left)
        :addTo(timeBg)
        :align(display.LEFT_CENTER, 12, timeBg:getContentSize().height * 0.5)
        :hide()
    self.zhiShiList[#self.zhiShiList + 1] = zhishiLeft
--[[
    display.newSprite(ImgsM.timebg_top)
        :addTo(self.centerView)
        :align(display.CENTER, display.cx, display.cy)
]]
    --倒计时
    self.timeTicklabel = display.newTTFLabel({
            text = "15",
            size = Dimens.TextSize_30,
            --color = Colors:_16ToRGB(Colors.directionText),
            color =  Colors.white,
            font = Fonts.Font_hkyt_w9,
            align = cc.ui.TEXT_ALIGN_CENTER,
            valign = cc.ui.TEXT_VALIGN_CENTER,
        })
        :addTo(self.centerView)
        :align(display.CENTER, display.cx, display.cy)

    display.newTTFLabel({
            text = "剩余牌",
            size = Dimens.TextSize_25,
            color = Colors:_16ToRGB(Colors.RemainingText),
            font = Fonts.Font_hkyt_w7,
            align = cc.ui.TEXT_ALIGN_CENTER,
            valign = cc.ui.TEXT_VALIGN_CENTER,
        })
        :addTo(self.centerView)
        :align(display.LEFT_TOP, display.cx - 88 * self.handCardScaleFact, 276)

    self.remainingValue = display.newTTFLabel({
            text = "10",
            size = Dimens.TextSize_25,
            color = Colors:_16ToRGB(Colors.Remaining),
            font = Fonts.Font_hkyt_w7,
            align = cc.ui.TEXT_ALIGN_CENTER,
            valign = cc.ui.TEXT_VALIGN_CENTER,
        })
        :addTo(self.centerView)
        :align(display.CENTER_TOP, display.cx + 45 * self.handCardScaleFact, 276)

    --查看底牌
    self.lookDiCardBtn = cc.ui.UIPushButton.new(
        ImgsM.lookDicardNor,{scale9=false})
        :setButtonImage(EnStatus.pressed, ImgsM.lookDicardSel)
        :onButtonClicked(function(e)

            VoiceDealUtil:playSound_forMJ(Voices.file.ui_click)
            self.diCardGridBgImage:show()
            self.diCardGrid:show()
            self.hideDiCardBtn:show()
            self.lookDiCardBtn:hide()
            
        end)
        :align(display.LEFT_TOP, display.cx + 89 * self.handCardScaleFact, 288)
        :addTo(self.Layer1, CEnumM.ZOrder.playerNode+15)
        :hide()

    --隐藏底牌
    self.hideDiCardBtn = cc.ui.UIPushButton.new(
        ImgsM.hideDicardNor,{scale9=false})
        :setButtonImage(EnStatus.pressed, ImgsM.hideDicardSel)
        :onButtonClicked(function(e)
            
            VoiceDealUtil:playSound_forMJ(Voices.file.ui_click)
            self.diCardGridBgImage:hide()
            self.diCardGrid:hide()
            self.lookDiCardBtn:show()
            self.hideDiCardBtn:hide()
        end)
        :align(display.LEFT_TOP, display.cx + 89 * self.handCardScaleFact, 288)
        :addTo(self.Layer1, CEnumM.ZOrder.playerNode+15)
        :hide()

end

--刷新桌面中间信息
--clientSeatNo 1,2,3,4
function MirrorMJRoomDialog:refreshRoomCenterInfo(clientSeatNo)
    if self.curZhiShiSprite ~= nil and (not tolua.isnull(self.curZhiShiSprite)) then
        self.curZhiShiSprite:hide()
    end
    self.zhiShiList[clientSeatNo]:show()
    self.zhiShiList[clientSeatNo]:stopAllActions()
    local sequence = transition.sequence({cc.FadeOut:create(1.2),
                    cc.FadeIn:create(1.2)})
    self.zhiShiList[clientSeatNo]:runAction(cc.RepeatForever:create(sequence))
    self.curZhiShiSprite = self.zhiShiList[clientSeatNo]
end

--创建桌面中间东南西北文字
--当前我在服务器端的座位号
function MirrorMJRoomDialog:createRoomDirectionText(serverSeatNo)
    local tempList = {"东","南","西","北"}
    local _offsetText = 30

    for i=1,4 do
        --求出数组索引
        local index = (serverSeatNo + (i-1)) % 4 + 1
        
        local textLabel = nil
        if self.centerView:getChildByTag(1000 + i) ~= nil then
            textLabel = self.centerView:getChildByTag(1000 + i)
            textLabel:setString(""..tempList[index])
        else
            textLabel = display.newTTFLabel({
                text = ""..tempList[index],
                size = Dimens.TextSize_30,
                color = Colors:_16ToRGB(Colors.directionText),
                font = Fonts.Font_hkyt_w9,
                align = cc.ui.TEXT_ALIGN_CENTER,
                valign = cc.ui.TEXT_VALIGN_CENTER,
            })
            :setTag(1000 + i)
            :addTo(self.centerView)

            if i == 1 then
                textLabel:align(display.CENTER_TOP, display.cx, display.cy - _offsetText)
            elseif i == 2 then
                textLabel:align(display.CENTER, display.cx + _offsetText + 15, display.cy)
                textLabel:setRotation(-90)
            elseif i == 3 then
                textLabel:align(display.CENTER, display.cx, display.cy + _offsetText + 15)
                textLabel:setRotation(180)
            elseif i == 4 then
                textLabel:align(display.CENTER, display.cx - _offsetText -15 , display.cy)
                textLabel:setRotation(90)
            end
        end
 
        
    end
end

-- 更新桌面中间信息(底牌数量）
function MirrorMJRoomDialog:dcard_setViewData(res_data, res_cmd)
    if res_data ~= nil then
        local room = res_data--[User.Bean.room]
        local playRound = room[Room.Bean.playRound]
        local rounds = room[Room.Bean.rounds]
        if Commons:checkIsNull_numberType(playRound) then
            self.juValue:setString(playRound.."/"..rounds)
            self.juValue:show()
            self.juLabel:show()
        end

        local diCardsNum = room[Room.Bean.diCardsNum]
        if Commons:checkIsNull_numberType(diCardsNum) then -- 游戏中
            -- 底牌
            self.remainingValue:setString(""..diCardsNum.."张")
        end 

        if diCardsNum~=nil and diCardsNum>0 then
            self.centerView:setVisible(true)
            if self.centerView:getChildByTag(1001) == nil then
                self:createRoomDirectionText(self.mySeatNo)
            end
        end

        local players = room[Room.Bean.players]
        local chuSeatNo = -1
        if players ~= nil and type(players)=="table" then
            for k,v in pairs(players) do
                if v[Player.Bean.chu] then
                    chuSeatNo = v[Player.Bean.seatNo]
                    break
                end
            end
        end

        if chuSeatNo ~= -1 then
            local clientSeatNo = GameMaJiangUtil:confimSeatNo(self.mySeatNo, chuSeatNo)
            self:refreshRoomCenterInfo(clientSeatNo)
            self.chuClientNo = clientSeatNo
        end
    end
end

local isLeft3second = false -- 是否有过一次低于3秒的闹钟告警声音
--出牌后中间的倒计时
function MirrorMJRoomDialog:updateTimeTickLabel()
    if self.curProgressCircle ~= nil then
        self.curProgressCircle:hide()
    end

    if self.curSelHeader ~= nil then
        self.curSelHeader:hide()
    end

    self.playerHeardViewList[self.chuClientNo].heard_border_light:show()
    self.curSelHeader = self.playerHeardViewList[self.chuClientNo].heard_border_light

    local tempPlayerView = self.playerHeardViewList[self.chuClientNo]
    tempPlayerView.progress:show():setPercentage(100)
    self.curProgressCircle = tempPlayerView.progress


    local num = 15
    TimerM:killAll()
    TimerM:start(function()
        local numStr = ""
        if num < 10 then
            numStr = "0"
        end
        self.timeTicklabel:setString(numStr..""..num)
        if num == 3 then
            isLeft3second = true
            VoiceDealUtil:playSound_forMJ(VoicesM.file.timeup_alarm)
        else
            if isLeft3second then -- 有过一次低于3秒的闹钟告警声音
                if num > 3 then -- 如果大于三，说明又是新的开始，闹钟告警声音立马抢占停止
                    isLeft3second = false
                    VoiceDealUtil:playSound_forMJ(VoicesM.file.empty_sound)
                end
            end
        end
        num = num - 1
    end, 1, 16)

    local num2 = 100
    TimerM:start(function()
        
        if tempPlayerView ~= nil then
            tempPlayerView.progress:setPercentage(num2)
        end

        num2 = num2 - 1
    end, 0.15, 170)

end

--创建头像及相关信息
function MirrorMJRoomDialog:createPlayerHeaderInfo(params)
    -- assert(type(params) == "table", "createPlayerHeaderInfo invalid params")
    local headView = cc.NodeGrid:create()
    headView:setPosition(params.headview_X, params.headview_Y)
    
    self.Layer1:addChild(headView, CEnumM.ZOrder.playerNode)
    headView:hide()

    -- 头像框
    headView.heardBoder = cc.ui.UIPushButton.new(ImgsM.heard_border,{scale9=false})
        :align(params.heardBoder_AnchorPoint, params.heardBoder_X, params.heardBoder_Y)
        :addTo(headView)

    -- if params.iconPath ~= nil then
    --     headView.heardBoder:onButtonClicked(
    --         function(e)
    --             if headView.me then
    --                 SupEmojiDialog.new(headView.user_icon, headView.user_nickname, headView.user_account, headView.user_ip, self.myRights, 
    --                     self, headView.seatNo):addTo(self.Layer1, CEnum.ZOrder.common_dialog)
    --             else
    --                 SupEmojiDialog.new(headView.user_icon, headView.user_nickname, headView.user_account, headView.user_ip, nil, 
    --                     self, headView.seatNo):addTo(self.Layer1, CEnum.ZOrder.common_dialog)
    --             end
    --         end
    --     )
    -- end
        
    if params.iconPath ~= nil and params.iconPath ~= "" then
        headView.heardIcon = NetSpriteImg.new(params.iconPath, 76, 80)
            :align(params.heardIcon_AnchorPoint, params.heardIcon_X, params.heardIcon_Y)
            :addTo(headView, CEnumM.ZOrder.playerNode)
    end

    headView.progress = cc.ProgressTimer:create(cc.Sprite:create(ImgsM.headlight))  
        :setType(cc.PROGRESS_TIMER_TYPE_RADIAL)
        :setMidpoint(cc.p(0.5,0.5)) 
        :setReverseDirection(true) 
        :setPercentage(100) 
        :addTo(headView, CEnumM.ZOrder.playerNode+6)
        :align(params.heardBoder_AnchorPoint, params.heardBoder_X+3, params.heardBoder_Y-3)
        :hide()

    headView.heard_border_light = display.newSprite(ImgsM.heard_border_light) 
        :addTo(headView, CEnumM.ZOrder.playerNode+3)
        :align(params.heardBoder_AnchorPoint, params.heardBoder_X-10, params.heardBoder_Y+10)
        :hide()

    -- 昵称
    headView.nickNameLabel = display.newTTFLabel({
            text = self.myNickname,
            font = Fonts.Font_hkyt_w7,
            size = Dimens.TextSize_20,
            color = display.COLOR_WHITE,
            align = cc.ui.TEXT_ALIGN_CENTER,
            valign = cc.ui.TEXT_VALIGN_CENTER,
            dimensions = cc.size(120,25)
        })
        :addTo(headView)
        :align(params.nickName_AnchorPoint, params.nickName_X, params.nickName_Y)

    --[[
        -- 分数框
        display.newSprite(Imgs.gameing_user_score_bg)
            :align(params.sorceBorder_AnchorPoint, params.sorceBorder_X, params.sorceBorder_Y)
            :addTo(headView)
    ]]

    headView.scoreLabel = display.newTTFLabel({
            text = "分数:",
            font = Fonts.Font_hkyt_w7,
            size = Dimens.TextSize_20,
            --color = display.COLOR_WHITE,
            color = Colors:_16ToRGB(Colors.gameing_score),
            align = cc.ui.TEXT_VALIGN_CENTER,
            valign = cc.ui.TEXT_VALIGN_CENTER,
            dimensions = cc.size(120,50)
        })
        :addTo(headView)
        :align(params.scoreLabel_AnchorPoint, params.scoreLabel_X, params.scoreLabel_Y)


    -- 是否是庄家
    headView.isBanker = cc.ui.UIImage.new(ImgsM.head_zhuang,{})
        :addTo(headView,CEnumM.ZOrder.playerNode+4)
        :align(params.isBanker_AnchorPoint, params.isBanker_X, params.isBanker_Y)


    -- 离线显示
    headView.viewOffline = cc.ui.UIPushButton.new(Imgs.gameing_user_offile_R,{scale9=false})
        :align(params.viewOffline_AnchorPoint, params.viewOffline_X, params.viewOffline_Y)
        :addTo(headView, CEnumM.ZOrder.playerNode+5)
        :setButtonEnabled(false)
        :setButtonLabel(EnStatus.disabled, cc.ui.UILabel.new({
            UILabelType = 2,
            text = "离线",
            font = Fonts.Font_hkyt_w7,
            size = Dimens.TextSize_20,
            color = Colors.gray,
            --color = Colors:_16ToRGB(Colors.gameing_roomNo),
            align = cc.ui.TEXT_ALIGN_CENTER,
            valign = cc.ui.TEXT_VALIGN_TOP,
         }))
        :setVisible(false)

    -- 是否准备好了啦？
    -- 准备按钮是否显示？
    headView.btnPrepare = cc.ui.UIPushButton.new(
        Imgs.gameing_btn_prepare,{scale9=false})
        :setButtonImage(EnStatus.disabled, Imgs.gameing_user_prepare_ok)
        :setButtonImage(EnStatus.pressed, Imgs.gameing_btn_prepare_press)
        :align(params.btnPrepare_AnchorPoint, params.btnPrepare_X, params.btnPrepare_Y)
        :addTo(headView)
        :hide()

    self.playerHeardViewList[#self.playerHeardViewList + 1] = headView
end

--更新头像及相关信息
function MirrorMJRoomDialog:updatePlayerHeaderInfo(playerData)
    local currNo = playerData[Player.Bean.seatNo] -- 当前玩家座位编号
    local _seat = GameMaJiangUtil:confimSeatNo(self.mySeatNo, currNo) -- 确定相对位置：1=本人位置，2下一玩家，3=上一玩家，4最后一玩家

    local playStatus = playerData[Player.Bean.playStatus] -- 游戏状态
    --Commons:printLog_Info("playStatus=",playStatus)

    local userBO = playerData[Player.Bean.user]
    --Commons:printLog_Info("用户对象：：",userBO)
    local icon
    local nickname
    if userBO ~= nil then
        icon = RequestBase:new():getStrDecode(userBO[User.Bean.icon])
        nickname = Commons:trim(RequestBase:getStrDecode(userBO[User.Bean.nickname]) )
    end
    local score = playerData[Player.Bean.score]
    local isBanker = playerData[Player.Bean.role]
    local netStatus = playerData[Player.Bean.netStatus] -- 玩家是不是在线
    local netStatus_bool = CEnum.netStatus.online == netStatus;

    local headView = self.playerHeardViewList[_seat]
    if userBO ~= nil then
        headView.user_account = userBO[User.Bean.account]
        headView.user_ip = userBO[User.Bean.ip]
    end

    local isMe = playerData[Player.Bean.me]
    if isMe ~= nil then
        headView.me = isMe
    end
    headView.seatNo = currNo

    -- icon不同时候，重新加载一次
    if Commons:checkIsNull_str(headView.user_icon) 
        and Commons:checkIsNull_str(icon) 
        and icon ~= headView.user_icon then -- 两个都有值，但是不相等
        headView.user_icon = icon
        if not tolua.isnull(headView.heardIcon) then
            headView.heardIcon:removeFromParent()
            headView.heardIcon = nil
        end
        headView.heardIcon = NetSpriteImg.new(icon, 76, 80)
            :align(display.LEFT_TOP, 20, 169)
            :addTo(headView, CEnumM.ZOrder.playerNode+1)
    elseif (not Commons:checkIsNull_str(headView.user_icon)) and Commons:checkIsNull_str(icon) then -- icon有值，第一次
        headView.user_icon = icon
        if not tolua.isnull(headView.heardIcon) then
            headView.heardIcon:removeFromParent()
            headView.heardIcon = nil
        end
        headView.heardIcon = NetSpriteImg.new(icon, 76, 80)
            :align(display.LEFT_TOP, 20, 169)
            :addTo(headView, CEnumM.ZOrder.playerNode+1)
    end

    -- 昵称赋值 
    if Commons:checkIsNull_str(headView.user_nickname) 
        and Commons:checkIsNull_str(nickname) 
        and nickname ~= headView.user_nickname then -- 两个都有值，但是不相等
        headView.user_nickname = nickname
        headView.nickNameLabel:setString(headView.user_nickname)
    elseif Commons:checkIsNull_str(headView.user_nickname) 
        and Commons:checkIsNull_str(nickname) 
        and nickname == headView.user_nickname then -- 两个都有值，相等
        headView.nickNameLabel:setString(nickname)
    elseif (not Commons:checkIsNull_str(headView.user_nickname)) and Commons:checkIsNull_str(nickname) then -- nickname有值，第一次
        headView.user_nickname = nickname
        headView.nickNameLabel:setString(headView.user_nickname)
    elseif Commons:checkIsNull_str(headView.user_nickname) and (not Commons:checkIsNull_str(nickname)) then -- user_nickname有值，后面变化
        headView.nickNameLabel:setString(headView.user_nickname) 
    end

    -- 离线标识
    headView.viewOffline:setVisible(false)

    -- 分数赋值
    if Commons:checkIsNull_numberType(score) then
        headView.scoreLabel:setString(Strings.gameing.score .. score)
        headView.scoreLabel:setVisible(true)
    else
        headView.scoreLabel:setVisible(false)
    end

    -- 是不是庄家
    if Commons:checkIsNull_str(isBanker) and isBanker == CEnum.role.z then
        
        headView.isBanker:setVisible(true)
    else
        headView.isBanker:setVisible(false)
    end

    -- 准备ok，还是需要准备
    -- 游戏未开始，第一次默认准备好拉
    if playStatus == CEnum.playStatus.ready then
        headView.btnPrepare:setVisible(true)
        headView.btnPrepare:setButtonEnabled(false)
        
        headView.isBanker:setVisible(false) -- 是不是庄家  暂时不用显示
    elseif playStatus == CEnum.playStatus.playing then
        headView.btnPrepare:setVisible(false)
    elseif playStatus == CEnum.playStatus.ended or playStatus == CEnum.playStatus.wait then
        -- myself_view_btn_Prepare:setVisible(true)
        if _seat ~= CEnumM.seatNo.me then
            headView.btnPrepare:setVisible(false)
        else
            if CVar._static.isNeedShowPrepareBtn then
                headView.btnPrepare:setVisible(true)
            else
                headView.btnPrepare:setVisible(false)
            end

            headView.btnPrepare:setButtonEnabled(true)
        end                        
    end

    if not netStatus_bool then -- 如果离线
        if _seat == CEnumM.seatNo.me then
            headView.viewOffline:setVisible(false)
            -- 离线标识
            if Commons:checkIsNull_str(headView.user_nickname) 
                and Commons:checkIsNull_str(nickname) 
                and nickname ~= headView.user_nickname then -- 两个都有值，但是不相等
                headView.user_nickname = nickname
                headView.nickNameLabel:setString(Strings.gameing.offlineName .. user_nickname)
            elseif Commons:checkIsNull_str(headView.user_nickname) 
                and Commons:checkIsNull_str(nickname) 
                and nickname == headView.user_nickname then -- 两个都有值，相等
                headView.nickNameLabel:setString(Strings.gameing.offlineName .. headView.user_nickname)
            elseif (not Commons:checkIsNull_str(headView.user_nickname)) and Commons:checkIsNull_str(nickname) then -- nickname有值，第一次
                headView.user_nickname = nickname
                headView.nickNameLabel:setString(Strings.gameing.offlineName .. headView.user_nickname)
            elseif Commons:checkIsNull_str(headView.user_nickname) and (not Commons:checkIsNull_str(nickname)) then -- user_nickname有值，后面变化
                headView.nickNameLabel:setString(Strings.gameing.offlineName .. headView.user_nickname) 
            end
        else
            headView.viewOffline:setVisible(true)
        end
    end

    headView:setVisible(true)
end

--创建顶部信息
function MirrorMJRoomDialog:createTopView()
    self.topView = cc.NodeGrid:create()
    self.topView:addTo(self.Layer1)
    self.topView:setVisible(true)

    --房间号
    self.roomNoLabel = display.newTTFLabel({
            text = "",
            size = Dimens.TextSize_25,
            color = Colors:_16ToRGB(Colors.roomNumber),
            font = Fonts.Font_hkyt_w7,
            align = cc.ui.TEXT_ALIGN_CENTER,
            valign = cc.ui.TEXT_VALIGN_CENTER,
        })
        :addTo(self.topView)
        :align(display.LEFT_TOP, display.left + 14, display.top - 6)

    self.juLabel = display.newTTFLabel({
            text = "局",
            size = Dimens.TextSize_25,
            color = Colors:_16ToRGB(Colors.RemainingText),
            font = Fonts.Font_hkyt_w7,
            align = cc.ui.TEXT_ALIGN_CENTER,
            valign = cc.ui.TEXT_VALIGN_CENTER,
        })
        :addTo(self.topView)
        :align(display.LEFT_TOP, 73, display.top - 36)
        :hide()

    self.juValue = display.newTTFLabel({
            text = "2/8",
            size = Dimens.TextSize_25,
            color = Colors:_16ToRGB(Colors.Remaining),
            font = Fonts.Font_hkyt_w7,
            align = cc.ui.TEXT_ALIGN_LEFT,
            valign = cc.ui.TEXT_VALIGN_CENTER,
        })
        :addTo(self.topView)
        :align(display.LEFT_TOP, 14, display.top - 36)
        :hide()

    --玩法规则
    self.basicRule = display.newTTFLabel({
            text = "",
            size = Dimens.TextSize_20,
            color = Colors:_16ToRGB(Colors.basicRule),
            font = Fonts.Font_hkyt_w7,
            align = cc.ui.TEXT_ALIGN_LEFT,
            valign = cc.ui.TEXT_VALIGN_CENTER,
        })
        :addTo(self.topView)
        :align(display.LEFT_TOP, display.left + 14, display.top - 68)

    -- 当前时间显示
    local myDate = ""
    if startTime_mirror~=nil and startTime_mirror~="" then
        myDate = startTime_mirror
    end
    local myDate_label = display.newTTFLabel({
            text = myDate,
            size = Dimens.TextSize_25,
            color = Colors:_16ToRGB(Colors.roomNumber),
            font = Fonts.Font_hkyt_w7,
            align = cc.ui.TEXT_ALIGN_CENTER,
            valign = cc.ui.TEXT_VALIGN_CENTER,
        })
        :addTo(self.topView)
        :align(display.RIGHT_TOP, display.right-78, display.top-18) -- 最左边

    -- 设置
    local top_view_setting=cc.ui.UIPushButton.new(
        ImgsM.setting,{scale9=false})
        :setButtonSize(42, 44)
        :setButtonImage(EnStatus.pressed, ImgsM.setting)
        :align(display.RIGHT_TOP, display.right-17, display.top-67)
        :addTo(self.topView)
        :hide()

    -- 解散房间
    self.top_view_dissRoom = cc.ui.UIPushButton.new(
        ImgsM.dms_room,{scale9=false})
        :setButtonSize(46, 41)
        :setButtonImage(EnStatus.pressed, ImgsM.dms_room)
        :align(display.RIGHT_TOP, display.right-17, display.top-8)
        :addTo(self.topView)
        :hide()
end


--创建出牌的提醒手势
function MirrorMJRoomDialog:createChuPaiTixing()
    -- 区域划定
    self.box_chupai = cc.LayerColor:create(cc.c4b(55,55,55, 0), osWidth, display.bottom + 173)
                        :addTo(self.Layer1, CEnumM.ZOrder.playerNode+10):hide()
    self.box_chupai:setPosition(cc.p(0,180))

    local lab1 = display.newTTFLabel({
        text="滑动即可出牌",
        color=c3,
        align=cc.ui.TEXT_ALIGN_CENTER,
        size=25
    })
    lab1:setPosition(cc.p(self.box_chupai:getContentSize().width/2 + 230,26))
    self.box_chupai:addChild(lab1)
    
    -- 区域的底线提示
    cc.ui.UIImage.new(Imgs.gameing_mid_chupai_paizhuo_line,{scale9=false})
        :addTo(self.box_chupai)
        :setPosition(cc.p(45*5+14,10))

    -- 出牌图片提示
    self.chu_tipimg_node = cc.ui.UIImage.new(Imgs.gameing_chu_handimg,{scale9=false})
        :addTo(self.box_chupai)
        :setPosition(cc.p(osWidth-42*9,-40))
    self:chuPaiTixingAnimal()
end

--播放出牌的提醒手势动画
function MirrorMJRoomDialog:chuPaiTixingAnimal()
    self.chu_tipimg_node:stopAllActions()
    local move4 = cc.MoveTo:create(1.0, cc.p(osWidth-42*8, 16));
    local move5 = cc.MoveTo:create(1.0, cc.p(osWidth-42*9, -40));
    local sequenceAction = cc.Sequence:create(move4,move5)
    local repeatAction = cc.Repeat:create(sequenceAction, 15)
    self.chu_tipimg_node:runAction(repeatAction)
end

-- 顶部组件赋值
function MirrorMJRoomDialog:top_setViewData(res_data)
    if res_data ~= nil then
        local room = res_data--[User.Bean.room]

        local roomNo = room[Room.Bean.roomNo]
        local playRound = room[Room.Bean.playRound]
        local rounds = room[Room.Bean.rounds]
        local huRule = room[Room.Bean.huRule]
        local duiRule = room[Room.Bean.duiRule]
        local gangRule = room[Room.Bean.gangRule]
        local huangRule = room[Room.Bean.huangRule]
        local rewardType = room[Room.Bean.rewardType]
        local rewardNum = room[Room.Bean.rewardNum]
        if self.playerNum == -1 then
            self.playerNum = room[Room.Bean.playerNum]
        end

        local ruleStr = ""
        self.myself_invite_content = ""

        self.myself_invite_content = self.myself_invite_content .. " "..rounds.."局"

        if Commons:checkIsNull_str(huRule) then
            if huRule == CEnumM.zimohu.mo then
                ruleStr = ruleStr .. CEnumM.zimohu.mo_info.."\n" --"自摸胡\n"
                self.myself_invite_content = self.myself_invite_content .. " "..CEnumM.zimohu.mo_info
            else
                ruleStr = ruleStr .. CEnumM.zimohu.pao_info.."\n" --"可炮胡(含自摸)\n"
                self.myself_invite_content = self.myself_invite_content .. " "..CEnumM.zimohu.pao_info
            end
        end
        
        if Commons:checkIsNull_str(duiRule) then
            if duiRule == CEnumM.qiduihu.y then
                ruleStr = ruleStr .. CEnumM.qiduihu.y_info.."\n" --"可对胡\n"
                self.myself_invite_content = self.myself_invite_content .. " "..CEnumM.qiduihu.y_info
            else
                ruleStr = ruleStr .. CEnumM.qiduihu.n_info.."\n" --"不可对胡\n"
                self.myself_invite_content = self.myself_invite_content .. " "..CEnumM.qiduihu.n_info
            end
        end

        if Commons:checkIsNull_str(gangRule) then
            if gangRule == CEnumM.qiangganghu.y then
                ruleStr = ruleStr .. CEnumM.qiangganghu.y_info.."\n" --"可抢杠\n"
                self.myself_invite_content = self.myself_invite_content .. " "..CEnumM.qiangganghu.y_info
            else
                ruleStr = ruleStr .. CEnumM.qiangganghu.n_info.."\n" --"不可抢杠\n"
                self.myself_invite_content = self.myself_invite_content .. " "..CEnumM.qiangganghu.n_info
            end
        end
        
        if Commons:checkIsNull_str(huangRule) then
            if huangRule == CEnumM.huangtype.y then
                ruleStr = ruleStr .. CEnumM.huangtype.y_info.."\n" --"荒庄荒杠\n"
                self.myself_invite_content = self.myself_invite_content .. " "..CEnumM.huangtype.y_info
            else
                ruleStr = ruleStr .. CEnumM.huangtype.n_info.."\n" --"荒庄不荒杠\n"
                self.myself_invite_content = self.myself_invite_content .. " "..CEnumM.huangtype.n_info
            end
        end

        if Commons:checkIsNull_str(rewardType) then
            if rewardType == CEnumM.rewardmark.no then
                ruleStr = ruleStr .. CEnumM.rewardmark.no_info.."\n" --"不奖码\n"
                self.myself_invite_content = self.myself_invite_content .. " "..CEnumM.rewardmark.no_info

            elseif rewardType == CEnumM.rewardmark._159 then
                ruleStr = ruleStr .. CEnumM.rewardmark._159_info.."\n" --"按159奖码\n"
                self.myself_invite_content = self.myself_invite_content .. " "..CEnumM.rewardmark._159_info

            elseif rewardType == CEnumM.rewardmark.ymqz then
                ruleStr = ruleStr .. CEnumM.rewardmark.ymqz_info.."\n" --"一码全中\n"
                self.myself_invite_content = self.myself_invite_content .. " "..CEnumM.rewardmark.ymqz_info

            else
                ruleStr = ruleStr .. CEnumM.rewardmark.oon_info.."\n" --"窝窝鸟\n"
                self.myself_invite_content = self.myself_invite_content .. " "..CEnumM.rewardmark.oon_info
            end
        end
        
        if Commons:checkIsNull_number(rewardNum) then
            ruleStr = ruleStr .."奖"..rewardNum.."码"
            self.myself_invite_content = self.myself_invite_content .. " ".."奖"..rewardNum.."码"
        end

        if Commons:checkIsNull_str(roomNo) then
            self.roomNoLabel:setString("房间号："..roomNo)
        end

        if Commons:checkIsNull_str(ruleStr) and self.basicRule:getString() == ""  then
            self.basicRule:setString(ruleStr)
        end
    end
    self.topView:setVisible(true)
end

-- 玩家上线，直接去创建玩家界面
-- 下一家位置或者最后一家位置都有可能初始化出来
function MirrorMJRoomDialog:players_info_setViewData(res_data)
    if res_data ~= nil then
        local room = res_data--[User.Bean.room]

        local _room_status = room[Room.Bean.status]
        CVar._static.roomStatus = room[Room.Bean.status]
        local room_status
        if CEnum.roomStatus.started == _room_status then
            room_status = true
        end
        local players = room[Room.Bean.players]

        if players ~= nil and type(players)=="table" then
            for k,v in pairs(players) do
                if v[Player.Bean.me] then
                    local playStatus = v[Player.Bean.playStatus] -- 游戏状态
                    if playStatus == CEnum.playStatus.ended then
                        self:changeOtherPlayerHandCardsVisible("n")
                    end
                    break
                end
            end
            self.players_havePerson = #players
        end

        if players ~= nil and type(players)=="table" then
            for k,v in pairs(players) do
                self:updatePlayerHeaderInfo(v)
            end
        end
    end
end

--根据服务器数据更新我的手牌
function MirrorMJRoomDialog:myself_handCard_createView_setViewData(res_data)
    local tempMyHandCardsData = nil
    local playStatus = nil

    if res_data ~= nil then
        local room = res_data
        local players = room[Room.Bean.players]

        if players ~= nil and type(players)=="table" then
            for k,v in pairs(players) do
                if v[Player.Bean.me] then
                    playStatus = v[Player.Bean.playStatus]
                    self.handSeparate = v[Player.Bean.separate]

                    tempMyHandCardsData = v[Player.Bean.handCards]

                    local action = v[Player.Bean.action] -- 当前摸或者出的牌

                    local currChiComb = v[Player.Bean.currChiComb] --当前吃，碰，杠对象
                    --如果是吃，碰，杠是延迟刷新手牌
                    if Commons:checkIsNull_tableType(currChiComb) then
                        self.isPengGangChiMoving = false
                    end

                    if Commons:checkIsNull_tableType(action) then
                        --_card = action[Player.Bean.card]
                        local _type = action[Player.Bean._type]
                        local _cardObject = action[Player.Bean.card]
                            if _cardObject ~= nil and _type == CEnum.options.mo then
                                VoiceDealUtil:playSound_forMJ(VoicesM.file.moCard)
                                if tempMyHandCardsData ~= nil and #tempMyHandCardsData ~= #self.curMyHandCards then
                                    self:moPaiMyHandCards(_cardObject)
                                end
                            elseif _cardObject ~= nil and _type == CEnum.options.chu then
                                self:curMyHandCardMove(_cardObject.id)
                                self:refreshMyHandCards(self.currMyHandCardsData)
                                
                            end
                    end

                    --如果之前没有手牌
                    if self.currMyHandCardsData == nil then
                        self.currMyHandCardsData = tempMyHandCardsData
                        if self.currMyHandCardsData ~= nil then
                            self:createMyHandCards(self.currMyHandCardsData)
                        end
                    else
                        --如果手牌有变化
                        if tempMyHandCardsData == nil then
                            self:refreshMyHandCards(tempMyHandCardsData)
                        else
                            if #self.currMyHandCardsData ~= #tempMyHandCardsData then
                                self.currMyHandCardsData = tempMyHandCardsData
                                --如果服务器端手牌数量和客户端生成的牌的sprite数量不相等，
                                --并且我不是在出牌之后(我出牌后动画播放完成后才要刷新手牌)，
                                --碰，杠，吃牌后也要延迟刷新手牌
                                --这个时候才要刷新手牌
                                if #self.curMyHandCards ~= #self.currMyHandCardsData 
                                    --and self.curMoveMyHandCard == nil
                                    and self.isPengGangChiMoving == false then
                                    self:refreshMyHandCards(self.currMyHandCardsData)
                                end
                            end
                        end
                    end

                end
            end
        end 
    end

    -- 如果没有手牌或者找不到本人对象
    if self.currMyHandCardsData ~= nil then
        
    end
end

--创建手牌
function MirrorMJRoomDialog:createMyHandCards(cardList)

    local number = #self.curMyPGChiCards/ 3
    --算出偏移量
    local offsetDis = number * (52 *self.handCardScaleFact * 3 + 8)

    if cardList ~= nil then
        for i=1,#cardList do
            local width_x = display.left+40*self.handCardScaleFact+(i-1)*81*self.handCardScaleFact+offsetDis

            if self.handSeparate and i == #cardList then
                width_x = width_x + 40*self.handCardScaleFact
            end

            local handObject = cardList[i]
            local handSprite = GameMaJiangUtil:createSimpleButton(ImgsM.hand_bg,"", true, self)
            :align(display.LEFT_CENTER, width_x, display.bottom+self.CARD_TO_BOTTOM*self.handCardScaleFact)
            :addTo(self.Layer1)

            handSprite:setName(tostring(handObject.id))
            handSprite.originalPosX = handSprite:getPositionX()
            handSprite.originalPosY = handSprite:getPositionY()
            handSprite:setScale(self.handCardScaleFact)
            --isFlag==true时代表双击，出牌
            handSprite.isFlag = false
            --当前手牌的数组序号
            handSprite.indexNum = i
            handSprite.cardData = handObject
            --牌是否可以点和拖
            -- if handObject.optionType == "a" then
            --     handSprite.isCanChu = true
            -- else
                handSprite.isCanChu = false
            -- end

            local handSpriteSize = handSprite:getContentSize()
            local innerSprite = display.newSprite("#"..tostring(handObject.id)..".png")
                    :addTo(handSprite)
                    :align(display.CENTER, handSpriteSize.width * 0.5, handSpriteSize.height * 0.5-4)

            --如果是红中则加癞子图片
            if handObject.isLaiZi == "y" then
                display.newSprite(ImgsM.laizi)
                        :addTo(handSprite)
                        :align(display.LEFT_TOP, 0, handSpriteSize.height)
            end

            self.curMyHandCards[#self.curMyHandCards + 1] = handSprite
        end
    end
    
end

--刷新手牌
function MirrorMJRoomDialog:refreshMyHandCards(cardList)
    if #self.curMyHandCards > 0 then
        for i=1,#self.curMyHandCards do
            if self.curMyHandCards[i] ~= nil and (not tolua.isnull(self.curMyHandCards[i]))  then
                self.curMyHandCards[i]:removeFromParent()
                self.curMyHandCards[i] = nil
            end
        end
        self.curMyHandCards = {}
    end
    self:createMyHandCards(cardList)
end

--当点击一张牌后，再点击或拖拽第二张牌，第一张牌状态要还原
function MirrorMJRoomDialog:reworkPrevHandCard(curHandCard)
    if self.prevHandCard ~= nil then
        if (not tolua.isnull(self.prevHandCard)) then
            self.prevHandCard.isFlag = false
            if self.prevHandCard.originalPosX ~= nil and self.prevHandCard.originalPosY ~= nil then
                self.prevHandCard:setPosition(cc.p(self.prevHandCard.originalPosX, self.prevHandCard.originalPosY))
            end
        end
    end
    
    self.prevHandCard = curHandCard
end

--摸一张手牌
function MirrorMJRoomDialog:moPaiMyHandCards(card)
    -- VoiceDealUtil:playSound_forMJ(VoicesM.file.moCard)

    local handSprite = GameMaJiangUtil:createSimpleButton(ImgsM.hand_bg,"", true, self)
        :align(display.LEFT_CENTER, display.cx - 40, display.cy - 70)
        :addTo(self.Layer1)
    handSprite:setName(tostring(card.id))
    --isFlag==true时代表双击，出牌
    handSprite.isFlag = false
    handSprite.indexNum = #self.curMyHandCards + 1
    handSprite.cardData = card

    --牌是否可以点和拖
    -- if card.optionType == "a" then
    --     handSprite.isCanChu = true
    -- else
        handSprite.isCanChu = false
    -- end

    local handSpriteSize = handSprite:getContentSize()
    local innerSprite = display.newSprite("#"..tostring(card.id)..".png")
            :addTo(handSprite)
            :align(display.CENTER, handSpriteSize.width * 0.5, handSpriteSize.height * 0.5-2)
    --如果是红中则加癞子图片
    if card.isLaiZi == "y" then
            display.newSprite(ImgsM.laizi)
                    :addTo(handSprite)
                    :align(display.LEFT_TOP, 0, handSpriteSize.height)
    end

    local number = math.floor(#self.curMyPGChiCards/3)
    --算出偏移量
    local offsetDis = number * (52*self.handCardScaleFact * 3 + 8)
    --放到手牌最后的位置，偏移8个像素
    local endPosX = display.left+40*self.handCardScaleFact+offsetDis+(#self.curMyHandCards)*81*self.handCardScaleFact + 40*self.handCardScaleFact
    local endPosY = display.bottom+self.CARD_TO_BOTTOM*self.handCardScaleFact
    handSprite.originalPosX = endPosX
    handSprite.originalPosY = endPosY

    self.curMyHandCards[#self.curMyHandCards + 1] = handSprite

    transition.execute(handSprite, cc.MoveTo:create(0.3, cc.p(endPosX, endPosY)), {
        onComplete = function()
            --如果手牌不一致，刷新手牌
            if self.currMyHandCardsData ~= nil then
                self:refreshMyHandCards(self.currMyHandCardsData)
            end
        end,
    })

    
end

--出牌后先保存当前移动的牌，等服务器出牌下行后才开始动画
function MirrorMJRoomDialog:handlerMyHandCard(curHandCard)
    --self.curMoveMyHandCard = curHandCard
    if self.isMyHu then
        local function option_giveup_OK()
            MJSocketGameing:gameing_Chu(tonumber(curHandCard:getName()))
            self.isMyHu = false
            --self:curMyHandCardMove(curHandCard)
        end
        local function option_giveup_NO()
            if curHandCard ~= nil then
                if (not tolua.isnull(curHandCard)) then
                    curHandCard.isFlag = false
                    if curHandCard.originalPosX ~= nil and curHandCard.originalPosY ~= nil then
                        curHandCard:setPosition(cc.p(curHandCard.originalPosX, curHandCard.originalPosY))
                    end
                end
            end
            self.myself_view_needOption_list:setVisible(true) -- 中间的选择又出现
        end
        CDialog.new():popDialogBox(self.Layer1, nil, Strings.gameing.giveup_hu, option_giveup_OK, option_giveup_NO)
    else
        MJSocketGameing:gameing_Chu(tonumber(curHandCard:getName()))
        --self:curMyHandCardMove(curHandCard)
    end

end

--将当前牌移动到中间位置，并消失，同时生成一张已经出的牌
function MirrorMJRoomDialog:curMyHandCardMove(cardId)
    VoiceDealUtil:playSound_forMJ(VoicesM.file.outCard)
    VoiceDealUtil:playSound_forMJ(VoicesM.file["card_"..cardId])

        self.prevHandCard = nil
        
        local tempCard2 = display.newSprite(ImgsM.hand_bg)
            :addTo(self.Layer1,CEnumM.ZOrder.playerNode+50)
            :setScale(0.5)

        tempCard2:align(display.CENTER, display.cx, display.cy - 70)
        
        display.newSprite("#"..cardId..".png")
                        :align(display.CENTER, tempCard2:getContentSize().width * 0.5, tempCard2:getContentSize().height * 0.5)
                        :addTo(tempCard2)

        local sequence = transition.sequence({
            cc.ScaleTo:create(0.3, 1),
            cc.DelayTime:create(0.8),
            cc.CallFunc:create(
                function()
                        tempCard2:removeFromParent()
                        
                end
                )
            
        })
        tempCard2:runAction(sequence)


        --生成一张刚出过的牌
        local chuNums = #self.hasChuCards[CEnumM.seatNo.me]
        local tempCard = display.newSprite(ImgsM.chu_card_bg)
            :addTo(self.Layer1)

        --记录ID
        tempCard.cardID = cardId

        --一行10列
        local hangNum = math.floor(chuNums / self.chuCardColumn)
        tempCard:align(display.LEFT_BOTTOM, 
                     display.left + display.cx - 165 * self.handCardScaleFact 
                     + (chuNums % self.chuCardColumn) * 33* self.handCardScaleFact,
                      display.bottom + 152 + 45 * hangNum * self.handCardScaleFact)
                    :setLocalZOrder(10-hangNum)
                    :setScale(self.handCardScaleFact)

        local temCardSize = tempCard:getContentSize()
        display.newSprite("#s_"..cardId..".png")
            :addTo(tempCard)
            :align(display.CENTER, temCardSize.width * 0.5, temCardSize.height * 0.5)

        tempCard.zhishiCard = display.newSprite(ImgsM.mj_zhishi)
            :addTo(tempCard)
            :setScale(0.8)
            :align(display.CENTER, temCardSize.width * 0.5, temCardSize.height * 1.3)

        local sequence = transition.sequence({cc.MoveBy:create(0.4, cc.p(0,10)),
            cc.MoveBy:create(0.4, cc.p(0,-10))})

        tempCard.zhishiCard:runAction(cc.RepeatForever:create(sequence))

        local playerChuCardsView = self.hasChuCards[CEnumM.seatNo.me]
        --隐藏指示卡
        for ik,iv in pairs(playerChuCardsView) do
            if iv ~= nil and iv.zhishiCard ~= nil and iv.zhishiCard:isVisible() then
                iv.zhishiCard:hide()
            end
        end
        --当前指示卡显示
        tempCard.zhishiCard:show()
        self.hasChuCards[CEnumM.seatNo.me][#self.hasChuCards[CEnumM.seatNo.me] + 1] = tempCard

        self:refreshPlayerChuCards()
               
    
end

--移除手牌
function MirrorMJRoomDialog:removeMyHandCard(card)
    self.prevHandCard = nil
    table.remove(self.curMyHandCards, card.indexNum)
    card:hide()
    card:removeFromParent()
    card = nil
end

--刷新手牌位置，没次出完牌，或碰，杠牌后刷新手中的手牌
function MirrorMJRoomDialog:refreshMyHandCardPos()
    local number = #self.curMyPGChiCards/ 3
    --算出偏移量
    local offsetDis = number * (52 * 3 + 8)
    for i=1,#self.curMyHandCards do
        self.curMyHandCards[i].indexNum = i
        self.curMyHandCards[i].isFlag = false

        transition.execute(self.curMyHandCards[i],
                cc.MoveTo:create(0.35, cc.p(display.left+40+(i-1)*81 + offsetDis, display.bottom+self.CARD_TO_BOTTOM)), {
                onComplete = function()
                    self.curMyHandCards[i].originalPosX = self.curMyHandCards[i]:getPositionX()
                    self.curMyHandCards[i].originalPosY = self.curMyHandCards[i]:getPositionY()
                end,
        })
    end
end

--创建我吃，碰，杠，胡图片，做放大，消失动画
function MirrorMJRoomDialog:myPlayerChiGangPengScaleCard(curOptionObj)
    local nameStr = ImgsM.sprite_peng
    if curOptionObj.option == CEnum.playOptions.gang then
        nameStr = ImgsM.sprite_gang
        VoiceDealUtil:playSound_forMJ(VoicesM.file.gang)
    elseif curOptionObj.option == CEnum.playOptions.peng then
        VoiceDealUtil:playSound_forMJ(VoicesM.file.peng)
    elseif curOptionObj.option == CEnum.playOptions.hu then
        nameStr = ImgsM.sprite_hu
    end

    local tempSprite = display.newSprite(nameStr)
                    :addTo(self.Layer1)
                    :setScale(0.5)

    tempSprite:align(display.CENTER, display.cx, display.cy-100)

    local sequence = transition.sequence({
        cc.ScaleTo:create(0.3, 1),
        cc.DelayTime:create(0.1),
        cc.CallFunc:create(
            function()
                    
                    self:createPengGangChiCards(curOptionObj)
                    --tempSprite:removeFromParent()
            end
            ),
        cc.DelayTime:create(0.3),
        cc.CallFunc:create(
            function()
                    tempSprite:removeFromParent()
            end
            )
        
    })
    tempSprite:runAction(sequence)
end

--我吃，碰，杠牌的组合显示
--[[
mjName:吃，碰，杠哪张牌
mjList:吃，碰，杠的列表
actionType:吃，碰，杠的类型 碰1 杠(明2,暗3) 吃4
]]
function MirrorMJRoomDialog:createPengGangChiCards(curOptionObj) 

    local sourceSeatNo = -1
    for i=1,#curOptionObj.cards do
        if curOptionObj.cards[i].sourceSeatNo > -1 then
            sourceSeatNo = curOptionObj.cards[i].sourceSeatNo
            break
        end
    end
    local clientSeatNo = GameMaJiangUtil:confimSeatNo(self.mySeatNo, sourceSeatNo)

    local tempCardId = -1
    if curOptionObj ~= nil and curOptionObj.cards ~= nil and #curOptionObj.cards > 0 then
        tempCardId = curOptionObj.cards[1].id
    end

    local isGang = false
    --明杠情况下先找出已经碰的牌
    local tempPengIndexArray = {}
    if #curOptionObj.cards == 4 then
        isGang = true
        for i=1,#self.curMyPGChiCards do
            if tempCardId == self.curMyPGChiCards[i].cardId and self.curMyPGChiCards[i].isGang == false then
                tempPengIndexArray[#tempPengIndexArray + 1] = i
            end
        end
    end

    self.isPengGangChiMoving = true   
    self.totalMoveCount = 0 
    for i=1,#curOptionObj.cards do
        
            local cardObj = curOptionObj.cards[i]
            local numX = i - 1
            local posY = 15*self.handCardScaleFact

            local number = math.floor(#self.curMyPGChiCards/3)
            --算出偏移量
            local offsetDis = number * (52*self.handCardScaleFact * 3 + 8)

            local startPosX = display.left+500*self.handCardScaleFact+numX*52*self.handCardScaleFact
            local startPosY = display.bottom+222

            local endPosX = display.left+40*self.handCardScaleFact+offsetDis+numX*52*self.handCardScaleFact
            local endPosY = display.bottom+posY

            local cardBgStr = ImgsM.peng_shang
            if cardObj.showType == CEnumM.showType.g then
                cardBgStr = ImgsM.peng_gai
            end

            local tempCard = display.newSprite(cardBgStr)
                    :setLocalZOrder(CEnumM.ZOrder.pengGangChiCardNormal)
                    :setScale(self.handCardScaleFact)

            tempCard.cardId = cardObj.id
            tempCard.isGang = isGang
            local innerMj = display.newSprite("#"..tostring(cardObj.id)..".png")
                            :align(display.CENTER, tempCard:getContentSize().width * 0.5, tempCard:getContentSize().height * 0.5 + 10)
                            :addTo(tempCard)
                            :setScale(0.65)
            if cardObj.showType == CEnumM.showType.g then
                innerMj:hide()
            end 

            if cardObj.sourceSeatNo ~= -1 then
                --生产一个方向箭头，指明碰，杠，吃了哪家的牌
                local arrow = display.newSprite(ImgsM.arrow)
                            --:align(display.CENTER, tempCard:getContentSize().width * 0.5, 8.5)
                            :align(display.CENTER, tempCard:getContentSize().width-10, tempCard:getContentSize().height - 10)
                            :addTo(tempCard)
                --根据服务器告知的吃的哪家的座位号算出客户端对应座位号
                local cusNo = GameMaJiangUtil:confimSeatNo(self.mySeatNo, cardObj.sourceSeatNo)
                
                --箭头图片只有一张，默认向右
                if cusNo == CEnumM.seatNo.L then
                    arrow:setRotation(-180)
                elseif cusNo == CEnumM.seatNo.me then
                    arrow:setRotation(90)
                elseif cusNo == CEnumM.seatNo.M then
                    arrow:setRotation(-90)
                elseif cusNo == CEnumM.seatNo.R then
                    
                end
            end

            --当为4张牌的时候，为杠牌，加到第二张牌上面
            if i == 4 then
                if #tempPengIndexArray > 0 then
                    tempCard:addTo(self.curMyPGChiCards[tempPengIndexArray[2]]):setScale(1)
                else
                    tempCard:addTo(self.curMyPGChiCards[#self.curMyPGChiCards-1]):setScale(1)
                end
                
                tempCard:align(display.LEFT_BOTTOM, 0, 10)
            else
                tempCard:addTo(self.Layer1)
                tempCard:align(display.LEFT_BOTTOM, startPosX, startPosY)

                if #tempPengIndexArray > 0 then
                    local chiCard = self.curMyPGChiCards[tempPengIndexArray[i]]
                    endPosX = chiCard:getPositionX()
                    endPosY = chiCard:getPositionY()
                    chiCard:removeFromParent()
                    self.curMyPGChiCards[tempPengIndexArray[i]] = tempCard
                else
                    self.curMyPGChiCards[#self.curMyPGChiCards+1] = tempCard
                end

                local totalCount = 0
                transition.execute(tempCard, cc.MoveTo:create(0.1, cc.p(endPosX, endPosY)), {
                    --delay = 0.0,
                    --easing = "backout",
                    onComplete = function()
                        self.totalMoveCount = self.totalMoveCount + 1
                        if self.totalMoveCount >= 3 then
                            self.totalMoveCount = 0
                            self.isPengGangChiMoving = false 
                            --刷新我的吃杠碰牌
                            self:refreshPengGangChiCards()

                            --刷新手牌
                            self:refreshMyHandCards(self.currMyHandCardsData)

                            --刷新出过的牌
                            self:refreshPlayerChuCards()     
                        end
                        
                    end,
                })
            end

    end

    tempPengIndexArray = {}

end

function MirrorMJRoomDialog:buildPengGangChiCards(curOptionObj)  
    local sourceSeatNo = -1
    for i=1,#curOptionObj.cards do
        if curOptionObj.cards[i].sourceSeatNo > -1 then
            sourceSeatNo = curOptionObj.cards[i].sourceSeatNo
            break
        end
    end
    local clientSeatNo = GameMaJiangUtil:confimSeatNo(self.mySeatNo, sourceSeatNo)

    local tempCardId = -1
    if curOptionObj ~= nil and curOptionObj.cards ~= nil and #curOptionObj.cards > 0 then
        tempCardId = curOptionObj.cards[1].id
    end

    local isGang = false
    --明杠情况下先找出已经碰的牌
    local tempPengIndexArray = {}
    if #curOptionObj.cards == 4 then
        isGang = true
        for i=1,#self.curMyPGChiCards do
            if tempCardId == self.curMyPGChiCards[i].cardId and self.curMyPGChiCards[i].isGang == false then
                tempPengIndexArray[#tempPengIndexArray + 1] = i
            end
        end
    end
 
    self.totalMoveCount = 0 
    for i=1,#curOptionObj.cards do
        
            local cardObj = curOptionObj.cards[i]
            local numX = i - 1
            local posY = 15

            local number = math.floor(#self.curMyPGChiCards/3)
            --算出偏移量
            local offsetDis = number * (52*self.handCardScaleFact * 3 + 8)

            local endPosX = display.left+40*self.handCardScaleFact+offsetDis+numX*52*self.handCardScaleFact
            local endPosY = display.bottom+posY

            local cardBgStr = ImgsM.peng_shang
            if cardObj.showType == CEnumM.showType.g then
                cardBgStr = ImgsM.peng_gai
            end

            local tempCard = display.newSprite(cardBgStr)
                    :setLocalZOrder(CEnumM.ZOrder.pengGangChiCardNormal)
                    :setScale(self.handCardScaleFact)

            tempCard.cardId = cardObj.id
            tempCard.isGang = isGang
            local innerMj = display.newSprite("#"..tostring(cardObj.id)..".png")
                            :align(display.CENTER, tempCard:getContentSize().width * 0.5, tempCard:getContentSize().height * 0.5+10)
                            :addTo(tempCard)
                            :setScale(0.65)
            if cardObj.showType == CEnumM.showType.g then
                innerMj:hide()
            end 

            if cardObj.sourceSeatNo ~= -1 then
                --生产一个方向箭头，指明碰，杠，吃了哪家的牌
                local arrow = display.newSprite(ImgsM.arrow)
                            :align(display.CENTER, tempCard:getContentSize().width-10, tempCard:getContentSize().height - 10)
                            :addTo(tempCard)
                --根据服务器告知的吃的哪家的座位号算出客户端对应座位号
                local cusNo = GameMaJiangUtil:confimSeatNo(self.mySeatNo, cardObj.sourceSeatNo)
                
                --箭头图片只有一张，默认向右
                if cusNo == CEnumM.seatNo.L then
                    arrow:setRotation(-180)
                elseif cusNo == CEnumM.seatNo.me then
                    arrow:setRotation(90)
                elseif cusNo == CEnumM.seatNo.M then
                    arrow:setRotation(-90)
                elseif cusNo == CEnumM.seatNo.R then
                    
                end
            end
                
            --当为4张牌的时候，为杠牌，加到第二张牌上面
            if i == 4 then
                if #tempPengIndexArray > 0 then
                    tempCard:addTo(self.curMyPGChiCards[tempPengIndexArray[2]]):setScale(1)
                else
                    tempCard:addTo(self.curMyPGChiCards[#self.curMyPGChiCards-1]):setScale(1)
                end
                
                tempCard:align(display.LEFT_BOTTOM, 0, 10)
            else
                tempCard:addTo(self.Layer1)
                tempCard:align(display.LEFT_BOTTOM, endPosX, endPosY)

                if #tempPengIndexArray > 0 then
                    local chiCard = self.curMyPGChiCards[tempPengIndexArray[i]]
                    endPosX = chiCard:getPositionX()
                    endPosY = chiCard:getPositionY()
                    chiCard:removeFromParent()
                    self.curMyPGChiCards[tempPengIndexArray[i]] = tempCard
                else
                    self.curMyPGChiCards[#self.curMyPGChiCards+1] = tempCard
                end
            end

    end

    tempPengIndexArray = {}

end

--刷新我的吃，杠，碰牌列表
function MirrorMJRoomDialog:refreshPengGangChiCards()
    if self.curResData ~= nil then
        local players = self.curResData[Room.Bean.players]

        if players ~= nil and type(players)=="table" then
            for k,v in pairs(players) do
                local seatNo = v[Player.Bean.seatNo]
                local chiCombs = v[Player.Bean.chiCombs]
                local clientSeatNo = GameMaJiangUtil:confimSeatNo(self.mySeatNo, seatNo)
                --如果数量不同就刷新
                if clientSeatNo == CEnumM.seatNo.me 
                    and chiCombs ~= nil 
                    --and #self.curMyPGChiCards > 0
                    and #chiCombs ~= math.floor(#self.curMyPGChiCards/3) then
                        --先清除
                        for i=1,#self.curMyPGChiCards do
                            local tempObj = self.curMyPGChiCards[i]
                            tempObj:removeFromParent()
                        end
                        self.curMyPGChiCards = {}

                        for i=1,#chiCombs do
                            local combObj = chiCombs[i]
                            self:buildPengGangChiCards(combObj)
                        end

                    break
                end
                
            end
        end
    end
end

--刷新玩家已经出的牌
function MirrorMJRoomDialog:refreshPlayerChuCards()
    if self.curResData ~= nil then
        local players = self.curResData[Room.Bean.players]

        --local owerNo = nil -- 我本人的位置在哪里？ 
        if players ~= nil and type(players)=="table" then
            for k,v in pairs(players) do
                local seatNo = v[Player.Bean.seatNo]
                local chuCards = v[Player.Bean.chuCards]
                local clientSeatNo = GameMaJiangUtil:confimSeatNo(self.mySeatNo, seatNo)
                local action = v[Player.Bean.action]

                local playerChuCardsView = self.hasChuCards[clientSeatNo]
                --隐藏指示卡，由后面action决定指示哪张
                for ik,iv in pairs(playerChuCardsView) do
                    if iv ~= nil and iv.zhishiCard ~= nil and iv.zhishiCard:isVisible() then
                        iv.zhishiCard:hide()
                    end
                end

                if Commons:checkIsNull_tableList(chuCards) == false and #playerChuCardsView > 0 then
                    --清除吃过的牌
                    for i=1,#playerChuCardsView do
                        playerChuCardsView[i]:removeFromParent()
                        playerChuCardsView[i] = nil
                    end
                    self.hasChuCards[clientSeatNo] = {}
                end

                if Commons:checkIsNull_tableList(chuCards) and #chuCards ~= #playerChuCardsView then
                
                --if Commons:checkIsNull_tableList(chuCards) then
                    --if #playerChuCardsView > 0 then
                        --清除吃过的牌
                        for i=1,#playerChuCardsView do
                            playerChuCardsView[i]:removeFromParent()
                            playerChuCardsView[i] = nil
                        end
                        self.hasChuCards[clientSeatNo] = {}

                        for i=1,#chuCards do
                            local cardObj = chuCards[i]

                            local spriteStr = ImgsM.left_shang02
                            if clientSeatNo == CEnumM.seatNo.M then
                                spriteStr = ImgsM.chu_card_bg
                            elseif clientSeatNo == CEnumM.seatNo.me then
                                spriteStr = ImgsM.chu_card_bg
                            end

                            local tempCard = display.newSprite(spriteStr)
                                            :addTo(self.Layer1)
                                            :setName(card)
                                            :setScale(self.handCardScaleFact)

                            local innerMj = display.newSprite("#s_"..tostring(cardObj.id)..".png")
                                                    :align(display.CENTER, tempCard:getContentSize().width * 0.5, tempCard:getContentSize().height * 0.5)
                                                    :addTo(tempCard)

                            tempCard.cardID = tostring(cardObj.id)
                            if clientSeatNo == CEnumM.seatNo.L then
                                innerMj:setRotation(90)
                                local chuNums = #self.hasChuCards[CEnumM.seatNo.L]
                                innerMj:align(display.CENTER, tempCard:getContentSize().width * 0.5-5, tempCard:getContentSize().height * 0.5+5)
                                tempCard:align(display.LEFT_BOTTOM, 
                                    display.left + 280 *self.handCardScaleFact + 48*self.handCardScaleFact * math.floor(chuNums / self.chuCardColumn), 
                                    display.bottom + 470 - 32* (chuNums % self.chuCardColumn)*self.handCardScaleFact)
                                self.hasChuCards[CEnumM.seatNo.L][#self.hasChuCards[CEnumM.seatNo.L] + 1] = tempCard
                            elseif clientSeatNo == CEnumM.seatNo.R then
                                innerMj:setRotation(-90)
                                local chuNums = #self.hasChuCards[CEnumM.seatNo.R]
                                local indexNum = chuNums % self.chuCardColumn
                                innerMj:align(display.CENTER, tempCard:getContentSize().width * 0.5+5, tempCard:getContentSize().height * 0.5+5)
                                tempCard:align(display.RIGHT_BOTTOM, 
                                    display.right - 280*self.handCardScaleFact - 48*self.handCardScaleFact * math.floor(chuNums / self.chuCardColumn),
                                     display.bottom + 185 + 32 * indexNum*self.handCardScaleFact)
                                    :setLocalZOrder(CEnumM.ZOrder.pengGangChiCardNormal-indexNum)
                                self.hasChuCards[CEnumM.seatNo.R][#self.hasChuCards[CEnumM.seatNo.R] + 1] = tempCard
                            elseif clientSeatNo == CEnumM.seatNo.M then
                                local chuNums = #self.hasChuCards[CEnumM.seatNo.M]
                                tempCard:align(display.LEFT_TOP, 
                                    display.right - display.cx + 165 * self.handCardScaleFact - 33 * self.handCardScaleFact * (chuNums % self.chuCardColumn), 
                                    display.top - 105 - 45 * math.floor(chuNums / self.chuCardColumn) * self.handCardScaleFact)
                                tempCard:setLocalZOrder(CEnumM.ZOrder.playerNode+10)
                                --innerMj:setRotation(180)
                                self.hasChuCards[CEnumM.seatNo.M][#self.hasChuCards[CEnumM.seatNo.M] + 1] = tempCard
                            elseif clientSeatNo == CEnumM.seatNo.me then
                                --生成一张刚出过的牌
                                local chuNums = #self.hasChuCards[CEnumM.seatNo.me]
                                --一行10列
                                local hangNum = math.floor(chuNums / self.chuCardColumn)
                                tempCard:align(display.LEFT_BOTTOM, 
                                             display.left + display.cx - 165 * self.handCardScaleFact 
                                             + (chuNums % self.chuCardColumn) * 33 * self.handCardScaleFact,
                                              display.bottom + 152 + 45 * hangNum * self.handCardScaleFact)
                                            :setLocalZOrder(10-hangNum)
                                self.hasChuCards[CEnumM.seatNo.me][#self.hasChuCards[CEnumM.seatNo.me] + 1] = tempCard
                            end

                            tempCard.zhishiCard = display.newSprite(ImgsM.mj_zhishi)
                                        :addTo(tempCard)
                                        :setScale(0.8)
                                        :align(display.CENTER, tempCard:getContentSize().width * 0.5, tempCard:getContentSize().height * 1.3)
                                        :hide()

                            if action ~= nil and action.card ~= nil then
                                if action.card.id == cardObj.id and i == #chuCards then
                                    local sequence = transition.sequence({cc.MoveBy:create(0.4, cc.p(0,10)),
                                        cc.MoveBy:create(0.4, cc.p(0,-10))})
                                    tempCard.zhishiCard:runAction(cc.RepeatForever:create(sequence))
                                    tempCard.zhishiCard:show()
                                end
                            end
                            
                        end

                    --end
                end
            end

            
        end
    end
end

--创建其他三个玩家的手牌，不亮牌
function MirrorMJRoomDialog:createOtherPlayerHandCards()
    for i=1,13 do
        local leftBlank = display.newSprite(ImgsM.left_blank)
                    :align(display.LEFT_BOTTOM, display.left + 185 * self.handCardScaleFact,
                     display.bottom + 590 * self.handCardScaleFact - (i-1)*32 * self.handCardScaleFact)
                    :setFlippedX(true)
                    :addTo(self.Layer1)
        self.otherHandCards[CEnumM.seatNo.L][#self.otherHandCards[CEnumM.seatNo.L] + 1] = leftBlank

        local rightBlank = display.newSprite(ImgsM.left_blank)
                    :align(display.RIGHT_BOTTOM, display.right - 185 * self.handCardScaleFact,
                     display.bottom + 190 * self.handCardScaleFact + (i-1)*32 * self.handCardScaleFact)
                    :addTo(self.Layer1)
                    :setLocalZOrder(CEnumM.ZOrder.otherHandCardMax-i)
        self.otherHandCards[CEnumM.seatNo.R][#self.otherHandCards[CEnumM.seatNo.R] + 1] = rightBlank

        local midHandBlank = display.newSprite(ImgsM.mid_hand_blank)
                    :align(display.RIGHT_TOP, display.right - 445 * self.handCardScaleFact - (i-1)*32 * self.handCardScaleFact, display.top - 26)
                    :addTo(self.Layer1)
        self.otherHandCards[CEnumM.seatNo.M][#self.otherHandCards[CEnumM.seatNo.M] + 1] = midHandBlank
    end

    self:changeOtherPlayerHandCardsVisible("n")
end

--改变其他三个玩家的手牌显示
--isShow: true  false
function MirrorMJRoomDialog:changeOtherPlayerHandCardsVisible(ishSow)

    local isFlagShow =  ishSow=='y'
    if ishSow == 'y' then

            for k,v in pairs(self.otherHandCards) do
                for ik,iv in pairs(v) do
                    if iv ~= nil then
                        iv:setVisible(isFlagShow)
                        
                    end
                end
            end

            if self.curResData ~= nil then
                local players = self.curResData[Room.Bean.players]
                if players ~= nil and type(players)=="table" then
                    for i=2,4 do
                        for k,v in pairs(players) do
                            local seatNo = v[Player.Bean.seatNo]
                            local tempSeatNo = GameMaJiangUtil:confimSeatNo(self.mySeatNo, seatNo)
                            if tempSeatNo == i then
                                local chiCombs = v[Player.Bean.chiCombs]
                                if Commons:checkIsNull_tableList(chiCombs) then
                                    local length = #chiCombs * 3
                                    --隐藏其他玩家相对应的手牌
                                    for j=1,length do
                                        if j > 13 then
                                            break
                                        end
                                        
                                        self.otherHandCards[i][j]:hide()
                                    end
                                end
                                
                            end
                        end
                    end
                    
                end
            end
            
    else
        for k,v in pairs(self.otherHandCards) do
            for ik,iv in pairs(v) do
                if iv ~= nil then
                    iv:setVisible(isFlagShow)
                    
                end
            end
        end
    end
end

--其它玩家出牌
function MirrorMJRoomDialog:moOtherPlayerHandCards(playerType, card)
    local spriteStr = ImgsM.left_shang
    if playerType == CEnumM.seatNo.M then
        spriteStr = ImgsM.chu_card_bg
    end

    local tempCard = display.newSprite(spriteStr)
                    :addTo(self.Layer1)
                    :setName(card)

    local innerMj = display.newSprite("#s_"..card..".png")
                            :align(display.CENTER, tempCard:getContentSize().width * 0.5, tempCard:getContentSize().height * 0.5)
                            :addTo(tempCard)
    tempCard.cardID = card
    if playerType == CEnumM.seatNo.L then
        innerMj:setRotation(90)
        local chuNums = #self.hasChuCards[CEnumM.seatNo.L]
        tempCard:align(display.LEFT_BOTTOM, 
            display.left + 300 + 34 * math.floor(chuNums / self.chuCardColumn), display.bottom + 470 - 25 * (chuNums % self.chuCardColumn))
        self.hasChuCards[CEnumM.seatNo.L][#self.hasChuCards[CEnumM.seatNo.L] + 1] = tempCard
    elseif playerType == CEnumM.seatNo.R then
        innerMj:setRotation(-90)
        local chuNums = #self.hasChuCards[CEnumM.seatNo.R]
        local indexNum = chuNums % self.chuCardColumn
        tempCard:align(display.RIGHT_BOTTOM, 
            display.right - 300 - 34 * math.floor(chuNums / self.chuCardColumn), display.bottom + 245 + 25 * indexNum)
            :setLocalZOrder(CEnumM.ZOrder.otherHandCardMax-indexNum)
        self.hasChuCards[CEnumM.seatNo.R][#self.hasChuCards[CEnumM.seatNo.R] + 1] = tempCard
    elseif playerType == CEnumM.seatNo.M then
        local chuNums = #self.hasChuCards[CEnumM.seatNo.M]
        tempCard:align(display.LEFT_TOP, 
            display.right - 494 - 29 * (chuNums % self.chuCardColumn), display.top - 143 - 35 * math.floor(chuNums / self.chuCardColumn))
        innerMj:setRotation(180)
        self.hasChuCards[CEnumM.seatNo.M][#self.hasChuCards[CEnumM.seatNo.M] + 1] = tempCard
    end

    tempCard.zhishiCard = display.newSprite(ImgsM.mj_zhishi)
                :addTo(tempCard)
                :setScale(0.8)
                :align(display.CENTER, tempCard:getContentSize().width * 0.5, tempCard:getContentSize().height * 1.3)
end

--创建一张他玩家的手牌，不明示
function MirrorMJRoomDialog:otherPlayerMoHandCard(playerType, card)

    VoiceDealUtil:playSound_forMJ(VoicesM.file.moCard)

    local imgeStr = ImgsM.left_blank
    if playerType == CEnumM.seatNo.M then
        imgeStr = ImgsM.mid_hand_blank
    end

    local tempCard = display.newSprite(imgeStr)
                    :addTo(self.Layer1)

    if playerType == CEnumM.seatNo.L then
        tempCard:setFlippedX(true)
        tempCard:align(display.LEFT_BOTTOM, display.left + 185 * self.handCardScaleFact, 
            display.bottom + 590 * self.handCardScaleFact - (#self.otherHandCards[CEnumM.seatNo.L])*32 * self.handCardScaleFact-15)
    elseif playerType == CEnumM.seatNo.R then
        tempCard:align(display.RIGHT_BOTTOM, display.right - 185 * self.handCardScaleFact, 
            display.bottom + 190 * self.handCardScaleFact + (#self.otherHandCards[CEnumM.seatNo.R])*32 * self.handCardScaleFact+15)
    else
        tempCard:align(display.RIGHT_TOP, display.right - 435 * self.handCardScaleFact 
            - (#self.otherHandCards[CEnumM.seatNo.M])*33 * self.handCardScaleFact-10, display.top - 26)
    end

    if self.otherMoHandCard ~= nil and (not tolua.isnull(self.otherMoHandCard)) then
        self.otherMoHandCard:removeFromParent()
        self.otherMoHandCard = nil
    end

    self.otherMoCards[#self.otherMoCards+1] = tempCard
    self.otherMoHandCard = tempCard
    
    local sequence = transition.sequence({
        cc.DelayTime:create(2.5),
        cc.CallFunc:create(
            function()
                    --tempCard:removeFromParent()
            end
            )
        
    })
    tempCard:runAction(sequence)
end

--创建一张临时的牌，做放大，消失动画
function MirrorMJRoomDialog:otherPlayerChuCardScaleCard(playerType, card)
    self:refreshPlayerChuCards()

    if self.otherMoHandCard ~= nil and (not tolua.isnull(self.otherMoHandCard)) then
        self.otherMoHandCard:removeFromParent()
        self.otherMoHandCard = nil
    end

    --清除其他玩家摸出的牌list
    for k,v in pairs(self.otherMoCards) do
        if v ~= nil and (not tolua.isnull(v)) then
            v:hide()
            v:removeFromParent()
        end
    end    
    self.otherMoCards = {}

    local tempCard = display.newSprite(ImgsM.hand_bg)
                    :addTo(self.Layer1,CEnumM.ZOrder.playerNode+50)
                    :setScale(0.5)

    if playerType == 4 then
        tempCard:align(display.CENTER, display.left + 347, display.cy)
    elseif playerType == 2 then
        tempCard:align(display.CENTER, display.right - 347, display.cy)
    else
        tempCard:align(display.CENTER, display.cx, display.top - 150)
    end
    display.newSprite("#"..card..".png")
                    :align(display.CENTER, tempCard:getContentSize().width * 0.5, tempCard:getContentSize().height * 0.5)
                    :addTo(tempCard)

    VoiceDealUtil:playSound_forMJ(VoicesM.file.outCard)
    VoiceDealUtil:playSound_forMJ(VoicesM.file["card_"..card])

    local sequence = transition.sequence({
        cc.ScaleTo:create(0.3, 1),
        cc.DelayTime:create(0.8),
        cc.CallFunc:create(
            function()
                    tempCard:removeFromParent()
                    --self:moOtherPlayerHandCards(playerType, card)
            end
            )
        
    })
    tempCard:runAction(sequence)
end


--创建其他玩家吃，碰，杠，胡图片，做放大，消失动画
function MirrorMJRoomDialog:otherPlayerCPGHScaleCard(playerType, curOptionObj)
    local nameStr = ImgsM.sprite_peng
    if curOptionObj.option == CEnum.playOptions.gang then
        nameStr = ImgsM.sprite_gang
        VoiceDealUtil:playSound_forMJ(VoicesM.file.gang)
    elseif curOptionObj.option == CEnum.playOptions.peng then
        VoiceDealUtil:playSound_forMJ(VoicesM.file.peng)
    elseif curOptionObj.option == CEnum.playOptions.hu then
        nameStr = ImgsM.sprite_hu
    end

    local tempSprite = display.newSprite(nameStr)
                    :addTo(self.Layer1, CEnumM.ZOrder.playerNode+50)
                    :setScale(0.5)

    if playerType == CEnumM.seatNo.L then
        tempSprite:align(display.CENTER, display.left + 347, display.cy)
    elseif playerType == CEnumM.seatNo.R then
        tempSprite:align(display.CENTER, display.right - 347, display.cy)
    else
        tempSprite:align(display.CENTER, display.cx, display.top - 150)
    end

    local sequence = transition.sequence({
        cc.ScaleTo:create(0.3, 1),
        cc.DelayTime:create(0.1),
        cc.CallFunc:create(
            function()
                    self:createOtherPengGangChiCards(playerType, curOptionObj)
                    --其他玩家碰，杠检查，刷新碰杠牌
                    self:refreshOtherPengGangChiCards()
                    --刷新吃过的牌
                    self:refreshPlayerChuCards()                    
            end
            ),
        cc.DelayTime:create(0.3),
        cc.CallFunc:create(
            function()
                    tempSprite:removeFromParent()
            end
            )

        
    })
    tempSprite:runAction(sequence)
end

--其他玩家吃，碰，杠牌的组合显示
--playerType 玩家类型L R M
function MirrorMJRoomDialog:createOtherPengGangChiCards(playerType, curOptionObj)
    local sourceSeatNo = -1
    for i=1,#curOptionObj.cards do
        if curOptionObj.cards[i].sourceSeatNo > -1 then
            sourceSeatNo = curOptionObj.cards[i].sourceSeatNo
            break
        end
    end
    local clientSeatNo = GameMaJiangUtil:confimSeatNo(self.mySeatNo, sourceSeatNo)

    local tempCardId = -1
    if curOptionObj ~= nil and curOptionObj.cards ~= nil and #curOptionObj.cards > 0 then
        tempCardId = curOptionObj.cards[1].id
    end

    local isGang = false
    --明杠情况下先找出已经碰的牌
    local tempPengIndexArray = {}
    if #curOptionObj.cards == 4 then
        isGang = true
        for i=1,#self.otherPGCHiCards[playerType] do
            if tempCardId == self.otherPGCHiCards[playerType][i].cardId and self.otherPGCHiCards[playerType][i].isGang == false then
                tempPengIndexArray[#tempPengIndexArray + 1] = i
            end
        end
    end

    for i=1,#curOptionObj.cards do
        local cardObject = curOptionObj.cards[i]
        local numX = i - 1
        local posY = 5

        local number = math.floor(#self.otherPGCHiCards[playerType]/3)
        
        --算出偏移量
        local offsetDis = number * (32 * self.handCardScaleFact * 3 + 12)
        --如果为对家是横向偏移，其他为纵向偏移
        if playerType == CEnumM.seatNo.M then
            offsetDis = number * (33 * self.handCardScaleFact * 3 + 9)
        end

        local posX = display.left+185*self.handCardScaleFact
        local posY = display.bottom+630*self.handCardScaleFact-offsetDis-32*self.handCardScaleFact*numX
        if playerType == CEnumM.seatNo.R then
            posX = display.right-185*self.handCardScaleFact
            posY = display.bottom+160*self.handCardScaleFact+offsetDis+32*self.handCardScaleFact*numX
        elseif playerType == CEnumM.seatNo.M then
            posX = display.right-400*self.handCardScaleFact-offsetDis-33*self.handCardScaleFact*numX
            posY = display.top-26
        end

        local cardBgStr = ImgsM.chu_card_bg
        if playerType == CEnumM.seatNo.M then
            if cardObject.showType == CEnumM.showType.g then
                cardBgStr = ImgsM.mjgai
            end
        else
            cardBgStr = ImgsM.left_shang02
            if cardObject.showType == CEnumM.showType.g then
                cardBgStr = ImgsM.left_gai02
            end
        end

        local tempCard = display.newSprite(cardBgStr):setScale(self.handCardScaleFact)
                
        tempCard.cardId = cardObject.id
        tempCard.isGang = isGang

        if cardObject.sourceSeatNo ~= -1 then
            --生产一个方向箭头，指明碰，杠，吃了哪家的牌
            local arrow = display.newSprite(ImgsM.arrow)
                        :addTo(tempCard)
            --根据服务器告知的吃的哪家的座位号算出客户端对应座位号
            local cusNo = GameMaJiangUtil:confimSeatNo(self.mySeatNo, cardObject.sourceSeatNo)
            if playerType == CEnumM.seatNo.L then
                arrow:align(display.CENTER, tempCard:getContentSize().width, 5)
                if cusNo == CEnumM.seatNo.me then
                    arrow:setRotation(90)
                elseif cusNo == CEnumM.seatNo.L then
                    arrow:setRotation(-180)
                elseif cusNo == CEnumM.seatNo.M then
                    arrow:setRotation(-90)
                elseif cusNo == CEnumM.seatNo.R then
                    
                end
            elseif playerType == CEnumM.seatNo.R then
                arrow:align(display.CENTER, 0, tempCard:getContentSize().height-5)
                if cusNo == CEnumM.seatNo.me then
                    arrow:setRotation(90)
                elseif cusNo == CEnumM.seatNo.R then
                    
                elseif cusNo == CEnumM.seatNo.M then
                    arrow:setRotation(-90)
                elseif cusNo == CEnumM.seatNo.L then
                    arrow:setRotation(-180)
                end
            elseif playerType == CEnumM.seatNo.M then
                arrow:align(display.CENTER, tempCard:getContentSize().width-5, tempCard:getContentSize().height)
                if cusNo == CEnumM.seatNo.L then
                    arrow:setRotation(-180)
                elseif cusNo == CEnumM.seatNo.M then
                    arrow:setRotation(-90)
                elseif cusNo == CEnumM.seatNo.R then
                    
                elseif cusNo == CEnumM.seatNo.me then
                    arrow:setRotation(90)
                end
            end
        end
        
        local innerMj = display.newSprite("#s_"..tostring(cardObject.id)..".png")
                        :align(display.CENTER, tempCard:getContentSize().width * 0.5, tempCard:getContentSize().height * 0.5)
                        --:setScale(0.40)
                        

        innerMj:addTo(tempCard)
        if cardObject.showType == CEnumM.showType.g then
            innerMj:hide()
        end

        if playerType == CEnumM.seatNo.R then
            tempCard:setLocalZOrder(CEnumM.ZOrder.pengGangChiCardNormal-i)
        else
            tempCard:setLocalZOrder(CEnumM.ZOrder.pengGangChiCardNormal)
        end

        if playerType == CEnumM.seatNo.L then
            innerMj:setRotation(90)
            innerMj:align(display.CENTER, tempCard:getContentSize().width * 0.5-5, tempCard:getContentSize().height * 0.5+5)
        elseif playerType == CEnumM.seatNo.R then
            innerMj:setRotation(-90)
            innerMj:align(display.CENTER, tempCard:getContentSize().width * 0.5+5, tempCard:getContentSize().height * 0.5+5)
        elseif playerType == CEnumM.seatNo.M then
            --innerMj:setRotation(180)
        end

        --如果为杠牌
        if i == 4 then
            if playerType == CEnumM.seatNo.M then
                tempCard:align(display.LEFT_BOTTOM, 0, 5)
            elseif playerType == CEnumM.seatNo.L then
                tempCard:align(display.LEFT_BOTTOM, 0, 5)
            elseif playerType == CEnumM.seatNo.R then
                tempCard:align(display.LEFT_BOTTOM, 0, 5)
            end

            if #tempPengIndexArray > 0 then
                --加入到中间那张牌上
                tempCard:addTo(self.otherPGCHiCards[playerType][tempPengIndexArray[2]]):setScale(1)
                --把第二张牌的zorder抬高
                if playerType ~= CEnumM.seatNo.M then
                    self.otherPGCHiCards[playerType][tempPengIndexArray[2]]:setLocalZOrder(CEnumM.ZOrder.playerNode+10):setOpacity(0)
                else
                    self.otherPGCHiCards[playerType][tempPengIndexArray[2]]:setLocalZOrder(CEnumM.ZOrder.playerNode+10)
                end
                
            else
                --加入到中间那张牌上
                tempCard:addTo(self.otherPGCHiCards[playerType][#self.otherPGCHiCards[playerType]-1]):setScale(1)
                --把第二张牌的zorder抬高
                if playerType ~= CEnumM.seatNo.M then
                    self.otherPGCHiCards[playerType][#self.otherPGCHiCards[playerType]-1]:setLocalZOrder(CEnumM.ZOrder.playerNode+10):setOpacity(0)
                else
                    self.otherPGCHiCards[playerType][#self.otherPGCHiCards[playerType]-1]:setLocalZOrder(CEnumM.ZOrder.playerNode+10)
                end
            end
        else
            tempCard:addTo(self.Layer1)

            if #tempPengIndexArray > 0 then
                local chiCard = self.otherPGCHiCards[playerType][tempPengIndexArray[i]]
                posX = chiCard:getPositionX()
                posY = chiCard:getPositionY()
                chiCard:removeFromParent()
                self.otherPGCHiCards[playerType][tempPengIndexArray[i]] = tempCard
            else
                self.otherPGCHiCards[playerType][#self.otherPGCHiCards[playerType]+1] = tempCard
            end

            if playerType == CEnumM.seatNo.M then
                tempCard:align(display.RIGHT_TOP, posX, posY)
            elseif playerType == CEnumM.seatNo.L then
                tempCard:align(display.LEFT_BOTTOM, posX, posY)
            elseif playerType == CEnumM.seatNo.R then
                tempCard:align(display.RIGHT_BOTTOM, posX, posY)
            end

        end
    end

    if self.curResData ~= nil then
        local players = self.curResData[Room.Bean.players]
        if players ~= nil and type(players)=="table" then
            for k,v in pairs(players) do
                local seatNo = v[Player.Bean.seatNo]
                local tempSeatNo = GameMaJiangUtil:confimSeatNo(self.mySeatNo, seatNo)
                if tempSeatNo == playerType then
                    local chiCombs = v[Player.Bean.chiCombs]
                    if Commons:checkIsNull_tableList(chiCombs) then
                        local length = #chiCombs * 3
                        --隐藏其他玩家相对应的手牌
                        for i=1,length do
                            if i > 13 then
                                break
                            end
                            
                            self.otherHandCards[playerType][i]:hide()
                        end
                    end
                    
                    break
                end
                
            end
        end
    end

end

--刷新其他玩家吃，杠，碰牌列表
function MirrorMJRoomDialog:refreshOtherPengGangChiCards()
    if self.curResData ~= nil then
        local players = self.curResData[Room.Bean.players]

        if players ~= nil and type(players)=="table" then
            for k,v in pairs(players) do
                local seatNo = v[Player.Bean.seatNo]
                local chiCombs = v[Player.Bean.chiCombs]
                local clientSeatNo = GameMaJiangUtil:confimSeatNo(self.mySeatNo, seatNo)
                --如果数量不同就刷新
                if clientSeatNo ~= CEnumM.seatNo.me 
                    and chiCombs ~= nil 
                    --and #self.otherPGCHiCards[clientSeatNo] > 0
                    and #chiCombs ~= math.floor(#self.otherPGCHiCards[clientSeatNo]/3) then
                        --先清除
                        for i=1,#self.otherPGCHiCards[clientSeatNo] do
                            local tempObj = self.otherPGCHiCards[clientSeatNo][i]
                            tempObj:removeFromParent()
                        end
                        self.otherPGCHiCards[clientSeatNo] = {}

                        for i=1,#chiCombs do
                            local combObj = chiCombs[i]
                            self:createOtherPengGangChiCards(clientSeatNo,combObj)
                        end
                end
            end
        end
    end
end


--创建听牌tips
function MirrorMJRoomDialog:createTingTips()
    self.closeTingLayer = display.newNode() -- newColorLayer(cc.c4b(0, 0, 0, 0))
        :addTo(self.Layer1)
         :setTouchEnabled(true)
         :setTouchSwallowEnabled(false)
         :setContentSize(osWidth, osHeight)
         :addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
            if event.name == "began" then
                return true
            end 

            if event.name == "ended" then
                self.tingBgSprite:hide()
                --self.closeTingLayer:hide()
                if self.hideDiCardBtn:isVisible() then
                    self.diCardGridBgImage:hide()
                    self.diCardGrid:hide()
                    self.lookDiCardBtn:show()
                    self.hideDiCardBtn:hide()
                end
            end
        end)

    self.tingTipsNode = display.newNode():addTo(self.Layer1, 100)
        :hide()
    self.tingTipsNode:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
            if event.name == "began" then
                return true
            end 

            if event.name == "ended" then
                self.tingBgSprite:hide()
            end
        end)
        

    cc.ui.UIPushButton.new(ImgsM.ting,{scale9=false})
        :setButtonSize(65, 84)
        :setButtonImage(EnStatus.normal, ImgsM.ting)
        :onButtonClicked(function(e)
            if self.tingBgSprite:isVisible() then
                self.tingBgSprite:hide()
            else 
                self.tingBgSprite:show()
            end
        end)
        :align(display.LEFT_BOTTOM, 320, 155):addTo(self.tingTipsNode)

    self.tingBgSprite = display.newScale9Sprite(ImgsM.tingBg, 0,0, 
                        cc.size(350, 100), 
                        cc.rect(10, 10, 10, 10)
                      )
            :align(display.LEFT_BOTTOM, 380, 155)
            :addTo(self.tingTipsNode)
            :setTouchEnabled(true) 
            :setTouchSwallowEnabled(false)
            :hide()

    
end

--刷新听牌列表
function MirrorMJRoomDialog:refreshTingTips(list)
    self.tingBgSprite:removeAllChildren()
    self.tingTipsNode:show()
    --self.tingBgSprite:setContentSize(cc.size(16+52*10,92))
    for i=0,#list - 1 do
        local tempCard = display.newSprite(ImgsM.peng_shang)
                    :addTo(self.tingBgSprite)
                    :align(display.LEFT_BOTTOM, 8+53*(i%10), (8+84) * math.floor(i/10) + 8)
        local innerCard = display.newSprite("#"..tostring(list[i+1].id)..".png")
                    :addTo(tempCard)
                    :align(display.CENTER, tempCard:getContentSize().width * 0.5, tempCard:getContentSize().height * 0.5+10)
                    :setScale(0.65)

    end

    local num = 10
    --只有一行就取list的长度
    if math.ceil(#list/10) == 1 then
        num = #list
    end

    self.tingBgSprite:setContentSize(cc.size(16+53*num,92 * math.ceil(#list/10) + 10))
end

--弹出选择碰哪张牌的列表
--[[
isHu:已经是否胡牌
gangDemosList:可杠牌的列表
actionNo:动作编号
optionType:杠，还是碰类型
]]
function MirrorMJRoomDialog:showGangDemos(isHu, gangDemosList, actionNo, optionName)
    self.gangDemosListBg:show()
    self.gangDemosListBg:setContentSize(55 * #gangDemosList + 10, 98)
    local demosListView = self.gangDemosListBg.gangDemosListView
    demosListView:removeAllItems()
    for i=1,#gangDemosList do
        local item = demosListView:newItem()
        item:setItemSize(55, 86)
        local content = cc.ui.UIPushButton.new(ImgsM.peng_shang, {scale9 = true})
                :setButtonSize(52, 84)
                :onButtonClicked(
                    function(event)
                         -- 服务器就会告知 一旦这个操作完的下一轮数据
                        if isHu then
                            local function option_giveup_OK()
                                VoiceDealUtil:playSound_forMJ(VoicesM.file.gang)
                                MJSocketGameing:gameing_Gang(actionNo, gangDemosList[i].id)--cardno)
                                self.isMyHu = false
                                -- 测试环境，模拟服务器发送信息
                                if CEnum.Environment.Current == CEnum.EnvirType.Test then
                                    local resData = MJSocketResponseDataTest.new():res_gameing_Peng();
                                    CVar._static.mSocket:tcpReceiveData(resData);
                                end
                                self.myself_view_needOption_list:setVisible(false)
                                self.gangDemosListBg:hide()
                            end
                            local function option_giveup_NO()
                                self.myself_view_needOption_list:setVisible(true) -- 中间的选择又出现
                                self.gangDemosListBg:hide()
                            end
                            CDialog.new():popDialogBox(self.Layer1, nil, Strings.gameing.giveup_hu, 
                                option_giveup_OK, option_giveup_NO)
                        else
                            VoiceDealUtil:playSound_forMJ(VoicesM.file.gang)
                            MJSocketGameing:gameing_Gang(actionNo, gangDemosList[i].id)--cardno)
                            -- 测试环境，模拟服务器发送信息
                            if CEnum.Environment.Current == CEnum.EnvirType.Test then
                                local resData = MJSocketResponseDataTest.new():res_gameing_Peng();
                                CVar._static.mSocket:tcpReceiveData(resData);
                            end

                            self.myself_view_needOption_list:setVisible(false)
                            self.gangDemosListBg:hide()
                        end
                    end)

        local contentSpriteSize = content:getContentSize()
        local innerSprite = display.newSprite("#"..tostring(gangDemosList[i].id)..".png")
                :addTo(content)
                :align(display.CENTER, contentSpriteSize.width * 0.5, contentSpriteSize.height * 0.5)
                :setScale(0.65)
        item:addContent(content)
        demosListView:addItem(item)
    end 

    demosListView:reload()
end


-- 已经出过的牌  每位玩家
-- 已经吃、碰过的牌  每位玩家
-- 并且庄家，第一次出牌，，以后后面每次摸、出、吃、碰、杠牌
function MirrorMJRoomDialog:players_handCard_setViewData(res_data)
    if res_data ~= nil then
        local room = res_data--[User.Bean.room]
        local players = room[Room.Bean.players]

        local isChu = false -- 看看是不是四家都没有出牌拉
        local action
        local _actionNo
        local _type
        local _card
        if Commons:checkIsNull_tableType(players) then
            -- 判断出谁应该出牌拉
            for k,v in pairs(players) do
                if v[Player.Bean.chu] then
                    isChu = true
                    
                    local currNo = v[Player.Bean.seatNo] -- 当前玩家座位编号
                    self.chu_seatNo = GameMaJiangUtil:confimSeatNo(self.mySeatNo, currNo) -- 确定相对位置：：0=本人位置，1=下一玩家，-1=上一玩家，最后一玩家
                    break
                end
            end
            if not isChu then -- 没有任何一家出牌提示，就看options在谁手上
                for k,v in pairs(players) do                
                    local options = v[Player.Bean.options] -- 当前可以的操作
                    if Commons:checkIsNull_tableList(options) then
                        local currNo = v[Player.Bean.seatNo] -- 当前玩家座位编号
                        self.chu_seatNo = GameMaJiangUtil:confimSeatNo(self.mySeatNo, currNo) -- 确定相对位置：：0=本人位置，1=下一玩家，-1=上一玩家，最后一玩家
                        break
                    end
                end
            end

            -- 当前的action在谁手上，是哪些值，只是会一个人有这个action对象
            for k,v in pairs(players) do
                action = v[Player.Bean.action] -- 当前摸或者出的牌
                if Commons:checkIsNull_tableType(action) then
                    _actionNo = action[Player.Bean.actionNo]
                    _type = action[Player.Bean._type]
                    _card = action[Player.Bean.card]
                    Commons:printLog_Info("主程序中 玩家 当前的操作是：", _type , _card, _actionNo)
                end
            end

        end

        if players ~= nil and type(players)=="table" then
            for k,v in pairs(players) do
                local currNo = v[Player.Bean.seatNo] -- 当前玩家座位编号
                local _seat = GameMaJiangUtil:confimSeatNo(self.mySeatNo, currNo) -- 确定相对位置：0,1,2,3  客户端座位1,2,3,4 相对于我

                local playStatus = v[Player.Bean.playStatus] -- 游戏状态
                --Commons:printLog_Info("playStatus=",playStatus)

                local netStatus = v[Player.Bean.netStatus] -- 玩家是不是在线
                local netStatus_bool = CEnum.netStatus.online == netStatus;

                if _seat == CEnumM.seatNo.me then -- and netStatus_bool then -- 本人的位置才做相应的处理 需要本人出牌，还是已经吃牌了动画
                    self.isMeChu = v[Player.Bean.chu] -- 服务器给的 是否出牌
                    local options = v[Player.Bean.options] -- 当前可以的操作
                    local action = v[Player.Bean.action] -- 当前摸或者出的牌
                    local currChiComb = v[Player.Bean.currChiComb] --当前吃，碰，杠对象
                    local gangDemos = v[Player.Bean.gangDemos] --当前碰，杠可选择的牌，比如此事可杠二万，三万
                    local tingCards = v[Player.Bean.tingCards] --当前听牌列表
                    local chiCombs = v[Player.Bean.chiCombs]

                    self.gangDemosListBg:hide()

                    if currChiComb ~= nil then
                        self:myPlayerChiGangPengScaleCard(currChiComb)
                    end

                    if Commons:checkIsNull_tableList(tingCards) then
                        --刷新听牌
                        self:refreshTingTips(tingCards)
                    else
                        self.tingTipsNode:hide()
                    end
                    
                    -- init之后的后期玩游戏的时候，本人要做的操作
                    if self.isMeChu then
                        if self.box_chupai~= nil then
                            --self.box_chupai:show()
                            -- -- 本人要出牌了，显示出牌区域
                            -- box_chupai:setVisible(true)
                            -- 只要显示可以出牌，就出现动画
                            self:chuPaiTixingAnimal()
                            --chu_tipimg = GameingHandCardDeal:createChupaiHint_Anim(box_chupai, chu_tipimg)
                            --倒计时开始
                            self:updateTimeTickLabel()
                        end
                    else
                        --Commons:printLog_Info("----333--来了来了来了")
                        if self.box_chupai~= nil then
                            -- 不是我出牌，隐藏出牌区域
                            self.box_chupai:hide()
                        end

                        if self.chu_seatNo == CEnum.seatNo.me then
                            --倒计时开始
                            self:updateTimeTickLabel()
                        end
                    end

                    -- 本人遇到了各种情况：碰，吃，过，胡才进入这里面操作
                    if Commons:checkIsNull_tableList(options) then

                        if #options == 1 and options[1] == CEnum.playOptions.guo then

                        elseif #options == 1 and options[1] == CEnum.playOptions.peng then

                        elseif #options == 1 and options[1] == CEnum.playOptions.hu then

                        elseif #options == 1 and options[1] == CEnum.playOptions.wei then

                        elseif #options == 1 and options[1] == CEnum.playOptions.chouwei then

                        elseif #options == 1 and options[1] == CEnum.playOptions.ti then
    
                        elseif #options == 1 and options[1] == CEnum.playOptions.ti8 then

                        elseif #options == 1 and options[1] == CEnum.playOptions.pao then

                        elseif #options == 1 and options[1] == CEnum.playOptions.pao8 then

                        elseif #options == 1 and options[1] == CEnum.playOptions.wc then

                        elseif #options == 1 and options[1] == CEnum.playOptions.wd then

                        elseif #options == 1 and options[1] == CEnum.playOptions.twc then

                        elseif #options == 1 and options[1] == CEnum.playOptions.twd then

                        else

                            -- 只要可以操作，并且操作超过1个，就必须优先中间按钮点击操作
                            if self.box_chupai~= nil then
                                -- 不是我出牌，隐藏出牌区域
                                self.box_chupai:setVisible(false)
                            end

                            -- 是否可以胡牌
                            local isMayHuPai = false
                            for cc,dd in pairs(options) do
                                if dd == CEnum.playOptions.hu then
                                    isMayHuPai = true
                                    self.isMyHu = true
                                    break
                                end
                            end
                            
                            local show_options = GameingDealUtil:PageView_FillList_MeChiPeng_Select(options, 4) -- 中间区域显示 吃 碰 过 胡的操作供本人选择
                            -- 下面就是具体本人 吃 碰 过 胡 具体的处理
                            self.myself_view_needOption_list:removeAllItems()
                            for kk,vv in pairs(show_options) do
        
                                local item = self.myself_view_needOption_list:newItem()
                                item:setName(vv)
                                local img_vv = GameMaJiangUtil:getImgByOptionMid(vv)
                                local img_vv_press = GameMaJiangUtil:getImgByOptionMid_press(vv)
                                local content = cc.ui.UIPushButton.new(img_vv, {scale9 = false})
                                    -- :setButtonSize(132, 132)
                                    :align(display.CENTER, 0 , 0)
                                    :setButtonImage(EnStatus.pressed, img_vv_press)

                                -- item:addChild(content) -- pageview的做法
                                item:setItemSize(152, 132) -- listview的做法是这样的
                                item:addContent(content)

                                self.myself_view_needOption_list:addItem(item) -- 添加item到列表
                            end
                            self.myself_view_needOption_list:reload() -- 重新加载
                            self.myself_view_needOption_list:setVisible(true)
                        end
                    else
                        self.myself_view_needOption_list:setVisible(false) -- 中间的选择消失
                    end

                elseif _seat == CEnumM.seatNo.R or _seat == CEnumM.seatNo.M or _seat == CEnumM.seatNo.L then
                    local isOtherChu = v[Player.Bean.chu] -- 服务器给的 是否出牌
                    local actionObj = v[Player.Bean.action]

                    if Commons:checkIsNull_tableType(actionObj) then
                        if actionObj.type == CEnum.options.mo then
                            self:otherPlayerMoHandCard(_seat,tostring(actionObj.card.id))
                        elseif actionObj.type == CEnum.options.chu then
                            self:otherPlayerChuCardScaleCard(_seat,tostring(actionObj.card.id))
                        end
                    end

                    local chiCombs = v[Player.Bean.chiCombs]
                    local currChiComb = v[Player.Bean.currChiComb] --当前吃，碰，杠对象

                    if currChiComb ~= nil then
                        self:otherPlayerCPGHScaleCard(_seat, currChiComb)
                    end

                    if isOtherChu then
                        --倒计时开始
                        self:updateTimeTickLabel()
                    end

                end

            end
        end
    end
    
end

-- 胡牌后底牌，其他玩家明牌显示
function MirrorMJRoomDialog:players_diCard_refreshViewData(res_data)
    if res_data ~= nil then
        local room = res_data
        local players = room[Room.Bean.players]
        if players ~= nil and type(players)=="table" then
            for k,v in pairs(players) do
                local currNo = v[Player.Bean.seatNo] -- 当前玩家座位编号
                local _seat = GameMaJiangUtil:confimSeatNo(self.mySeatNo, currNo)
                local score = v[Player.Bean.score]

                if self.playerHeardViewList[_seat] ~= nil then
                    local scoreLabel = self.playerHeardViewList[_seat].scoreLabel
                    -- 分数赋值
                    if Commons:checkIsNull_numberType(score) then
                        if scoreLabel~=nil and (not tolua.isnull(scoreLabel)) then
                            scoreLabel:setString(Strings.gameing.score .. score)
                            scoreLabel:setVisible(true)
                        end
                    end
                end
            end
        end
    end

    self.diCardGrid:removeAllItems()
    local diCardList = res_data.diCards
    if Commons:checkIsNull_tableList(diCardList) then
        local rowTotalNum = math.ceil(#diCardList/15)
        local leafNum = #diCardList%15
        self.diCardGrid:setViewRect(cc.rect(365*self.handCardScaleFact, 305*self.handCardScaleFact+self.diCardGrid_mov_y, 550*self.handCardScaleFact, 50*self.handCardScaleFact * 3))
        self.diCardGridBgImage:setContentSize(520*self.handCardScaleFact, 50*self.handCardScaleFact * 3 + 20)

        local indexCount = 1
        for i=1, rowTotalNum do
            local item = self.diCardGrid:newItem()
            local content
            content = display.newNode()
            local innerNum = 15
            if i == rowTotalNum and leafNum ~= 0 then
                innerNum = leafNum
            end

            for count = 1, innerNum do
                local tempSprite = display.newSprite(ImgsM.chu_card_bg)
                    :align(display.LEFT_BOTTOM, 33*self.handCardScaleFact*count, 0)
                    :addTo(content)
                    :setScale(self.handCardScaleFact)
                display.newSprite("#s_"..tostring(diCardList[indexCount].id)..".png")
                    :align(display.CENTER, tempSprite:getContentSize().width * 0.5, tempSprite:getContentSize().height * 0.5)
                    :addTo(tempSprite)
                indexCount = indexCount + 1
            end
            content:setContentSize(550*self.handCardScaleFact, 50*self.handCardScaleFact)
            item:addContent(content)
            item:setItemSize(550*self.handCardScaleFact, 50*self.handCardScaleFact)

            self.diCardGrid:addItem(item)
        end
        self.diCardGrid:reload()
        self.diCardGridBgImage.noDiCard:hide()
    else
        self.diCardGridBgImage.noDiCard:show()
    end
 
    if self.otherMoHandCard ~= nil and (not tolua.isnull(self.otherMoHandCard)) then
        self.otherMoHandCard:removeFromParent()
        self.otherMoHandCard = nil
    end

    self:changeOtherPlayerHandCardsVisible("n")

    ----其他玩家明牌
    if res_data ~= nil then
        local players = res_data[Room.Bean.players]

        if players ~= nil and type(players)=="table" then
            for k,v in pairs(players) do
                if v[Player.Bean.me] == false then
                    local seatNo = v[Player.Bean.seatNo]
                    local handCards = v[Player.Bean.handCards]
                    
                    local clientSeatNo = GameMaJiangUtil:confimSeatNo(self.mySeatNo, seatNo)
                    if self.otherHandCardMingPaiDic[clientSeatNo] ~= nil then
                        if #self.otherHandCardMingPaiDic[clientSeatNo] ~= #handCards then
                            for ik,iv in pairs(self.otherHandCardMingPaiDic[clientSeatNo]) do
                                if iv ~= nil and (not tolua.isnull(iv)) then
                                    iv:removeFromParent()
                                end
                            end
                        end
                    end

                    if Commons:checkIsNull_tableList(handCards) then
                        for i=1,#handCards do
                            local cardObj = handCards[i]

                            local numX = i - 1
                            local posY = 5
                            local number = math.floor(#self.otherPGCHiCards[clientSeatNo]/3)
                            
                            --算出偏移量
                            local offsetDis = number * (32*self.handCardScaleFact * 3 + 12)
                            --如果为对家是横向偏移，其他为纵向偏移
                            if playerType == CEnumM.seatNo.M then
                                offsetDis = number * (33*self.handCardScaleFact * 3 + 12)
                            end

                            local posX = display.left+185*self.handCardScaleFact
                            local posY = display.bottom+630*self.handCardScaleFact-10-offsetDis-32*self.handCardScaleFact*numX
                            if clientSeatNo == CEnumM.seatNo.R then
                                posX = display.right-185*self.handCardScaleFact
                                posY = display.bottom+160*self.handCardScaleFact+10+offsetDis+32*self.handCardScaleFact*numX
                            elseif clientSeatNo == CEnumM.seatNo.M then
                                posX = display.right-400*self.handCardScaleFact-20-offsetDis-33*self.handCardScaleFact*numX
                                posY = display.top-26
                            end

                            local spriteStr = ImgsM.left_shang02
                            if clientSeatNo == CEnumM.seatNo.M then
                                spriteStr = ImgsM.chu_card_bg
                            end

                            local tempCard = display.newSprite(spriteStr)
                                            :addTo(self.Layer1)
                                            :setScale(self.handCardScaleFact)

                            local innerMj = display.newSprite("#s_"..tostring(cardObj.id)..".png")
                                :align(display.CENTER, tempCard:getContentSize().width * 0.5, tempCard:getContentSize().height * 0.5)
                                --:setScale(0.4)
                                :addTo(tempCard)

                            if clientSeatNo == CEnumM.seatNo.M then
                                tempCard:align(display.RIGHT_TOP, posX, posY)
                            elseif clientSeatNo == CEnumM.seatNo.L then
                                tempCard:align(display.LEFT_BOTTOM, posX, posY)
                                innerMj:align(display.CENTER, tempCard:getContentSize().width * 0.5-5, tempCard:getContentSize().height * 0.5+5)
                            elseif clientSeatNo == CEnumM.seatNo.R then
                                tempCard:align(display.RIGHT_BOTTOM, posX, posY)
                                innerMj:align(display.CENTER, tempCard:getContentSize().width * 0.5+5, tempCard:getContentSize().height * 0.5+5)
                                tempCard:setLocalZOrder(CEnumM.ZOrder.pengGangChiCardNormal-i)
                            end

                            if clientSeatNo == CEnumM.seatNo.L then
                                innerMj:setRotation(90)
                            elseif clientSeatNo == CEnumM.seatNo.R then
                                innerMj:setRotation(-90)
                            elseif clientSeatNo == CEnumM.seatNo.M then
                                --innerMj:setRotation(180)
                            end

                            self.otherHandCardMingPaiDic[clientSeatNo][#self.otherHandCardMingPaiDic[clientSeatNo] + 1] = tempCard

                        end
                    end
                end
                
            end

        end
    end
end

--创建中码节点
function MirrorMJRoomDialog:huCard_createView_setViewData(res_data)
    TimerM:killAll()
    if self.curProgressCircle ~= nil then
        self.curProgressCircle:hide()
    end

    if self.curSelHeader ~= nil then
        self.curSelHeader:hide()
    end

    local rewardCardsList = res_data[Room.Bean.rewardCards] 
    
    local isHuangJi = true
    local huType = nil
    local roundRecords = res_data[Room.Bean.roundRecord]

    if roundRecords ~= nil and type(roundRecords)=="table" then
        CVar._static.isNeedShowPrepareBtn = false
        for i=1, #roundRecords do
            local roundObj = roundRecords[i]
            local isHu = roundObj[RoundRecord.Bean.hu]
            if isHu then
                huType = roundObj[RoundRecord.Bean.huType]
                isHuangJi = false
                break
            end
        end
    end

    -- 如果有胡牌 先出胡动画和胡声音
    local tempRandom = 0
    if isHuangJi == false then
        -- print("=============================", huType)
        if huType~=nil and huType==CEnumM.zimohu.mo then
            math.randomseed(tostring(os.time()):reverse():sub(1, 6)) --设置时间种子，下面随机才有用
            tempRandom = math.random(1,100)
            if tempRandom>70 then -- 随机变成另外一个读法
                VoiceDealUtil:playSound_forMJ(VoicesM.file.hu_zimo_1)
            else
                VoiceDealUtil:playSound_forMJ(VoicesM.file.hu_zimo)
            end
        else
            VoiceDealUtil:playSound_forMJ(VoicesM.file.hu)
        end
    end

    -- 正常胡牌的情况
    local jianMaDelay = 1.2
    local delayTime = jianMaDelay +0.7 -- 包含奖码字的出现，所以出现奖码牌需要这个时间
    if not Commons:checkIsNull_tableList(rewardCardsList) then -- 不奖码
        jianMaDelay = 1.2
        if tempRandom>70 then -- 随机变成另外一个读法
            -- 这里播放声音要长点
        else
            jianMaDelay = 0.6
        end
        delayTime = jianMaDelay +0.01 
    end
    if isHuangJi then 
        -- 没人胡牌
        jianMaDelay = 0.01
        delayTime = jianMaDelay +0.7 -- 包含奖码字的出现，所以出现奖码牌需要这个时间
        if not Commons:checkIsNull_tableList(rewardCardsList) then -- 不奖码
            jianMaDelay = 0.01
            delayTime = jianMaDelay +0.01
        end
    end
    -- print("==============jianMaDelay==", jianMaDelay)
    -- print("==============delayTime==", delayTime)

    -- 出现多家胡牌，每个位置都要显示胡的字
    if roundRecords ~= nil and type(roundRecords)=="table" then
        for i=1, #roundRecords do
            local roundObj = roundRecords[i]
            local isHu = roundObj[RoundRecord.Bean.hu]
            if isHu then
                local clientSeatNo = GameMaJiangUtil:confimSeatNo(self.mySeatNo, roundObj[RoundRecord.Bean.seatNo])

                local tempCard = display.newSprite(ImgsM.sprite_hu)
                        :addTo(self.Layer1, CEnumM.ZOrder.playerNode+20)
                        :setScale(0.5)

                if clientSeatNo == CEnumM.seatNo.L then
                    tempCard:align(display.CENTER, display.left + 347*self.handCardScaleFact, display.cy)
                elseif clientSeatNo == CEnumM.seatNo.R then
                    tempCard:align(display.CENTER, display.right - 347*self.handCardScaleFact, display.cy)
                elseif clientSeatNo == CEnumM.seatNo.M then
                    tempCard:align(display.CENTER, display.cx, display.top - 150*self.handCardScaleFact)
                elseif clientSeatNo == CEnumM.seatNo.me then
                    tempCard:align(display.CENTER, display.cx, display.cy-100*self.handCardScaleFact)
                end

                local sequence = transition.sequence({
                    cc.ScaleTo:create(0.3, 1),
                    cc.DelayTime:create(jianMaDelay),
                    cc.CallFunc:create(
                        function()
                                if Commons:checkIsNull_tableList(rewardCardsList) then
                                    VoiceDealUtil:playSound_forMJ(VoicesM.file.jiangma)
                                    local jiangMaCard = display.newSprite(ImgsM.jiangma)
                                                    :addTo(self.Layer1, CEnumM.ZOrder.playerNode+20)
                                                    :setScale(0.5)

                                    jiangMaCard:align(display.CENTER, display.cx, display.cy)
                                    local sequence = transition.sequence({
                                                    cc.ScaleTo:create(0.3, 1),
                                                    cc.DelayTime:create(1),
                                                    cc.CallFunc:create(
                                                        function()
                                                                jiangMaCard:removeFromParent()
                                                        end
                                                        )
                                    })

                                    jiangMaCard:runAction(sequence)
                                end

                        end
                        ),
                    cc.CallFunc:create(
                        function()
                                tempCard:removeFromParent()
                        end
                        )
                })

                tempCard:runAction(sequence)
            end
            
        end
    end

    -- 奖码牌 的显示
    -- if isHuangJi then
    --     -- 没人胡牌
    --     delayTime = 0.1
    -- end
    local tempSprite = display.newSprite(ImgsM.sprite_hu)
                    :addTo(self.Layer1)
                    :setScale(0.5)
                    :hide()
                    :align(display.CENTER, display.cx, display.cy-100)
    local sequence = transition.sequence({
        cc.ScaleTo:create(0.3, 1),
        cc.DelayTime:create(delayTime),
        cc.CallFunc:create(
            function()   
                    tempSprite:hide()                 
                    local rewardCards = res_data[Room.Bean.rewardCards] 
                    if rewardCards ~= nil then
                        self.zhongMaNode:removeAllChildren()
                        for i=0,#rewardCards - 1 do
                                local tempCard = display.newSprite(ImgsM.hand_bg)
                                            :addTo(self.zhongMaNode)
                                            :setLocalZOrder(CEnumM.ZOrder.playerNode+12)
                                            :setScale(self.handCardScaleFact)

                                tempCard:align(display.LEFT_BOTTOM, 
                                                430*self.handCardScaleFact+90*self.handCardScaleFact*(i%5), 
                                                430 - (140)*self.handCardScaleFact * math.floor(i/5))
                                

                                if rewardCards[i+1].showType == CEnumM.showType.y then
                                    display.newSprite(ImgsM.zhongma_border)
                                        :addTo(tempCard)
                                        :align(display.CENTER, tempCard:getContentSize().width * 0.5, tempCard:getContentSize().height * 0.5 + 10)
                                        :setScale(1)
                                end
                                local innerCard = display.newSprite("#"..tostring(rewardCards[i+1].id)..".png")
                                            :addTo(tempCard)
                                            :align(display.CENTER, tempCard:getContentSize().width * 0.5, tempCard:getContentSize().height * 0.5)

                        end
                    end
            end
            ),
        cc.DelayTime:create(delayTime),
        cc.CallFunc:create(
            function ( ...)
                tempSprite:removeFromParent()
                if res_data ~= nil then
                    local room = res_data--[User.Bean.room]
                    local roundRecord = room[Room.Bean.roundRecord] 

                    local roomRecord = room[Room.Bean.roomRecord]
                    if Commons:checkIsNull_tableList(roomRecord) then
                    end

                    if Commons:checkIsNull_tableList(roundRecord) then
                        self.myself_view_needOption_list:setVisible(false) -- 中间的选择消失
                        
                        self.lookDiCardBtn:show()
                    else
                        
                    end

                end
            end
        )
        
    })
    tempSprite:runAction(sequence)
end


--玩家下线
function MirrorMJRoomDialog:players_online_offline(res_data)
    if res_data ~= nil then
        local room = res_data--[User.Bean.room]
        local currNo = room[Player.Bean.seatNo]
        local _seat = GameMaJiangUtil:confimSeatNo(self.mySeatNo, currNo)
        
        local playerHeardViewTemp = self.playerHeardViewList[_seat]
        if _seat == CEnumM.seatNo.me then
            -- 自己的位置应该不会出现这个显示
            if Commons:checkIsNull_str(playerHeardViewTemp.user_nickname) then
                playerHeardViewTemp.nickNameLabel:setString(Strings.gameing.offlineName .. playerHeardViewTemp.user_nickname)
            else
                playerHeardViewTemp.nickNameLabel:setString(Strings.gameing.offlineName)
            end
        else 
            playerHeardViewTemp.viewOffline:setVisible(true)
            VoiceDealUtil:playSound_forMJ(Voices.file.gameing_sankai)
        end    
    end
end






return MirrorMJRoomDialog