--
-- Author: luobinbin
-- Date: 2017-07-18 16:27:12
--

local MJRoomScene = class("MJRoomScene", function()
    return display.newScene("MJRoomScene")
end)

local osWidth = Commons.osWidth
local osHeight = Commons.osHeight

local view_node_voice -- 录音按钮
local view_node_voice_bg

function MJRoomScene:ctor()
    self.otherLeftRightPGCardLength = 32 --上下家左右杠牌高度大小
    self.otherMidPGCardLength = 33 --对家杠牌宽度大小
    self.otherLeftRightPGChiOffsetDis = 15 --上下家左右杠牌间隙大小
    self.otherMidPGChiOffsetDis = 10 --对家家左右杠牌间隙大小

    self.otherLeftStartPosX = 185 --上家牌起始PosX
    self.otherLeftStartPosY = 630 --上家牌起始PosY
    self.otherRightStartPosX = 185 --下家牌起始PosX
    self.otherRightStartPosY = 160 --下家牌起始PosY
    self.otherMidStartPosX = 400 --对家牌起始PosX
    self.otherMidStartPosY = 26 --对家牌起始PosY

    self.otherLeftRightHandCardLength = 32 --上下家左右手牌高度大小
    self.otherMidHandCardLength = 31.5 --对家左右手牌宽度大小

    self.otherLeftRightMoCardOffset = 25 --上下家左右手牌间隙大小
    self.otherMidMoCardLength = 20 --对家摸牌间隙大小

    -- 预加载这些动画plist文件
    display.addSpriteFrames(Imgs.voiceplay_plist, Imgs.voiceplay_png) -- 语音播放动画
    display.addSpriteFrames(Imgs.biaoqing_expContent.."exp"..Imgs.file_imgPlist_suff, Imgs.biaoqing_expContent.."exp"..Imgs.file_img_suff) -- 表情
    --加载麻将纹理
    display.addSpriteFrames(ImgsM.mjhand_plist, ImgsM.mjhand_texture)
    display.addSpriteFrames(ImgsM.superEmoji_plist, ImgsM.superEmoji_texture) -- 超级表情

    -- self.user_roomNo = 0

    self.loadingSpriteAnim = nil -- 开局等待动画
    self.topRule_view_noConnectServer = nil --网络失连视图
    self.top_view_dissRoom = nil
    self.top_view_backRoom = nil

    self.top_scheduler = nil
    self.top_schedulerID_network = nil
    self.top_schedulerID_network_status = nil
    self.top_scheduleID_voice = nil

    --邀请好友按钮
    self.myself_view_invite = nil
    self.myself_invite_title = "" --邀请好友标题
    self.myself_invite_content = "" --邀请好友内容
    self.players_havePerson = 0 -- 有几个玩家

    self.voiceSpeakBg = nil -- 说话框的背景
    self.voiceSpeakImg = nil -- 说话框的话筒
    self.voiceSpeakSlider = nil -- 说话框的倒计时进度条
    self.voiceSpeakClockTime = CVar._static.clockVoiceTime -- 说话框的倒计时总时间
    self.voiceSpeakClickBtn = nil -- 说话按钮

    self.top_view_gprsBtn = nil
    self.GprsBean = nil
    self.PopGprsDialog = nil

    self.isConnected_sockk_nums = 1
    self.isMyManual = false -- 是不是我手动关闭socket，是手动关闭，就不需要重连，否则就是可以重连
    self.isConnected_sockk_time = nil -- 和服务器可以连接的时间点记录

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
    --是否是重新刷新房间状态
    self.refreshRoomFlag = false
    --是否牌局结束或者房间结束
    self.isGameOver = false
    --其他玩家摸出的牌list
    self.otherMoCards = {}
    --客户端是否可以出牌
    self.clientCanChuCard = true

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

    -- 我的游戏房间信息
    -- local userGameing = GameStateUserGameing:getData()
    -- self.user_roomNo = userGameing[Room.Bean.roomNo]
    -- Commons:printLog_Info("房间号：", self.user_roomNo, userGameing[Room.Bean.status])

    -- 层
    self.Layer1 = display.newLayer()
            :pos(0, 0)
            :addTo(self)

    if CEnum.Environment.Current~=nil and CEnum.Environment.Current==CEnum.EnvirType.Test then
        -- 响应键盘事件
        self.Layer1:setKeypadEnabled(true)
        self.Layer1:addNodeEventListener(cc.KEYPAD_EVENT, handler(self,self.myKeypad))
    end

    -- 整个底色背景
    display.newSprite(ImgsM.room_bg):center():addTo(self.Layer1)

    self.top_scheduler = self.Layer1:getScheduler();

    --中码节点
    self.zhongMaNode = display.newNode():addTo(self.Layer1, CEnumM.ZOrder.playerNode+12):align(display.LEFT_BOTTOM, 0, 0)

    -- 邀请好友
    self.myself_view_invite = cc.ui.UIPushButton.new(Imgs.gameing_btn_invite,{scale9=false})
        :setButtonImage(EnStatus.pressed, Imgs.gameing_btn_invite_press)
        :align(display.CENTER_TOP, display.cx, osHeight-332)
        :addTo(self.Layer1, 30)
        :onButtonClicked(function(e)

            VoiceDealUtil:playSound_forMJ(Voices.file.ui_click)

            if self.players_havePerson ~= nil and self.players_havePerson==3 then
                self.myself_invite_title = " "..CEnumM.shareTitle._3 -- 三缺一
            elseif self.players_havePerson ~= nil and self.players_havePerson==2 then
                self.myself_invite_title = " "..CEnumM.shareTitle._2 -- 二缺二
            else
                self.myself_invite_title = " "..CEnumM.shareTitle._1 -- 一缺三  
            end

            local _title = Strings.app_name_mj.." 房间号["..CVar._static.roomNo.."] " ..self.myself_invite_title
            local _content = "房间号["..CVar._static.roomNo.."]，"..self.myself_invite_content ..self.myself_invite_title.. "，速度来玩！"
            Commons:printLog_Req("====分享的_title是：", _title, '\n')
            Commons:printLog_Req("====分享的_content是：", _content, '\n')

            Commons:gotoShareWX(_title, _content)
            
        end)
        :setVisible(false)
    cc.ui.UIPushButton.new(
        Imgs.gameing_btn_copy_nor,{scale9=false})
        :setButtonImage(EnStatus.pressed, Imgs.gameing_btn_copy_pre)
        :onButtonClicked(function(e)

            VoiceDealUtil:playSound_forMJ(Voices.file.ui_click)

            if self.players_havePerson ~= nil and self.players_havePerson==3 then
                self.myself_invite_title = " "..CEnumM.shareTitle._3 -- 三缺一
            elseif self.players_havePerson ~= nil and self.players_havePerson==2 then
                self.myself_invite_title = " "..CEnumM.shareTitle._2 -- 二缺二
            else
                self.myself_invite_title = " "..CEnumM.shareTitle._1 -- 一缺三  
            end

            local _content = "房间号["..CVar._static.roomNo.."]，"..self.myself_invite_content ..self.myself_invite_title.. "，速度来玩！"
            local function CDAlertIP_CopyTxt_CallbackLua(txt)
                CDAlert.new():popDialogBox(self.Layer1, txt)
            end
            Commons:gotoCopyContent(CDAlertIP_CopyTxt_CallbackLua, _content)

        end)
        :align(display.CENTER, 0, 40)
        :addTo(self.myself_view_invite)

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

    -- 表情展开按钮
    cc.ui.UIPushButton.new(
        Imgs.biaoqing_btn,{scale9=false})
        :setButtonSize(70, 70)
        :setButtonImage(EnStatus.pressed, Imgs.biaoqing_btn)
        :onButtonClicked(function(e)
        
            VoiceDealUtil:playSound_forMJ(Voices.file.ui_click)
            EmojiDialog:popDialogBox(self.Layer1, CEnum.pageView.gameingMJPage)
            
        end)
        :align(display.RIGHT_BOTTOM, osWidth-20, 150)
        :addTo(self.Layer1, CEnum.ZOrder.gameingView_myself_voice)

    -- 语音展示界面相关信息
    --说话框的背景
    self.voiceSpeakBg = cc.ui.UIImage.new(Imgs.hx_record_bg,{})
            :addTo(self.Layer1, CEnum.ZOrder.gameingView_myself_voice)
            :align(display.CENTER, display.cx, display.cy)
            :setVisible(false)

    self.voiceSpeakImg = cc.ui.UIPushButton.new(
            Imgs.hx_record_animate_01,{scale9=false})
            :setButtonSize(75, 111)
            :setButtonImage(EnStatus.pressed, Imgs.hx_record_animate_01)
            :setButtonImage(EnStatus.disabled, Imgs.hx_record_animate_01)
            :setButtonEnabled(false)
            :align(display.CENTER, display.cx, display.cy+10)
            :addTo(self.Layer1, CEnum.ZOrder.gameingView_myself_voice)
            :setVisible(false)
    
    self.voiceSpeakSlider = cc.ProgressTimer:create(cc.Sprite:create(Imgs.voice_slider_bg_layer))  
        :setType(cc.PROGRESS_TIMER_TYPE_BAR) -- 条形
        :setMidpoint(cc.p(0,0)) --设置起点为条形坐下方   
        :setBarChangeRate(cc.p(1,0))  --设置为竖直方向  
        :setPercentage(CVar._static.clockVoiceTime) -- 设置初始进度为30  
        :addTo(self.Layer1, CEnum.ZOrder.gameingView_myself_voice)
        :align(display.CENTER, display.cx, display.cy-80)
        :setVisible(false)

    -- 语音点击展开按钮
    self.voiceSpeakClickBtn = cc.ui.UIPushButton.new(
            Imgs.voice_btn,{scale9=false})
            :setButtonSize(70, 70)
            :setButtonImage(EnStatus.pressed, Imgs.voice_btn)
            :align(display.RIGHT_BOTTOM, osWidth-20, 230)
            :addTo(self.Layer1, CEnum.ZOrder.gameingView_myself_voice)

    self.voiceSpeakClickBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, handler(self,self.Dictate_TouchListener) )
    self.voiceSpeakClickBtn:setTouchEnabled(true)

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
            scoreLabel_X = 58,--13,
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
    -- 加载中的动画显示，搞一个精灵动画即可
    self:createLoading(self.Layer1)

    -- 然后去建立socket连接，一旦成功，获取到相应数据，再进行页面展示
    if CEnum.Environment.Current~=nil and CEnum.Environment.Current==CEnum.EnvirType.Http then
        self:createSocket()
    end
    if CEnum.Environment.Current~=nil and CEnum.Environment.Current==CEnum.EnvirType.Test then
    end

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
        :addTo(self.Layer1, 9999)
        :align(display.CENTER, display.cx, display.cy)
        :hide()
    end

end

-- 加载中的动画显示，搞一个精灵动画即可
function MJRoomScene:createLoading(Layer1)
    self.loadingSpriteAnim = display.newSprite(Imgs.c_juhua):addTo(self.Layer1)
    self.loadingSpriteAnim:runAction(cc.RepeatForever:create(cc.RotateBy:create(100, 36000)))
    self.loadingSpriteAnim:pos(display.cx, display.cy)
end

--创建桌面中间信息
function MJRoomScene:createRoomCenterInfo()
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
function MJRoomScene:refreshRoomCenterInfo(clientSeatNo)
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
function MJRoomScene:createRoomDirectionText(serverSeatNo)
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
function MJRoomScene:dcard_setViewData(res_data, res_cmd)
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

        if res_cmd == Sockets.cmd.gameing_Start 
            or (res_cmd == Sockets.cmd.loginRoom and diCardsNum~=nil and diCardsNum>0)
            or (res_cmd == Sockets.cmd.refreshRoom and diCardsNum~=nil and diCardsNum>0) then
            self.centerView:setVisible(true)
            self:createRoomDirectionText(self.mySeatNo)

        end

        if res_cmd == Sockets.cmd.gameing_Start then
            --游戏开始的时候手牌出现
            self:changeOtherPlayerHandCardsVisible("y")
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
function MJRoomScene:updateTimeTickLabel()
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

        -- 响起告警声音
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
function MJRoomScene:createPlayerHeaderInfo(params)
    -- assert(type(params) == "table", "createPlayerHeaderInfo invalid params")
    local headView = cc.NodeGrid:create()
    headView:setPosition(params.headview_X, params.headview_Y)
    
    self.Layer1:addChild(headView, CEnumM.ZOrder.playerNode)
    headView:hide()

    -- 头像框
    headView.heardBoder = cc.ui.UIPushButton.new(ImgsM.heard_border,{scale9=false})
        :align(params.heardBoder_AnchorPoint, params.heardBoder_X, params.heardBoder_Y)
        :addTo(headView)

    if params.iconPath ~= nil then
        headView.heardBoder:onButtonClicked(
            function(e)
                if headView.me then
                    SupEmojiDialog.new(headView.user_icon, headView.user_nickname, headView.user_account, headView.user_ip, self.myRights, 
                        self.mySeatNo, headView.seatNo):addTo(self.Layer1, CEnum.ZOrder.common_dialog)
                else
                    SupEmojiDialog.new(headView.user_icon, headView.user_nickname, headView.user_account, headView.user_ip, nil, 
                        self.mySeatNo, headView.seatNo):addTo(self.Layer1, CEnum.ZOrder.common_dialog)
                end
            end
        )
    end
        
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
        --:onButtonClicked(function(e)
            --游戏准备
            --SocketRequestGameing:gameing_Prepare()
            --GameingScene:myViewReset_thisDesktop()
        --end)
        :align(params.btnPrepare_AnchorPoint, params.btnPrepare_X, params.btnPrepare_Y)
        :addTo(headView)
        --:setButtonEnabled(false)
        :hide()

    --如果是我自己的头像，第一个
    if #self.playerHeardViewList == 0 then
        headView.btnPrepare:onButtonClicked(function(e)
            --游戏准备
            VoiceDealUtil:playSound_forMJ(Voices.file.ui_click)
            SocketRequestGameing:gameing_Prepare()
            self:myViewReset_thisDesktop()
        end)
    else
        --不是我自己准备按钮不能点击
        headView.btnPrepare:setButtonEnabled(false)
    end

    self.playerHeardViewList[#self.playerHeardViewList + 1] = headView
end

--更新头像及相关信息
function MJRoomScene:updatePlayerHeaderInfo(playerData)
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

        if _seat == CEnumM.seatNo.me then
            if CVar._static.appstoreSwitch == CEnum.appstoreSwitch.close then
                self.myself_view_invite:setVisible(false)
            else
                self.myself_view_invite:setVisible(true)
                if self.players_havePerson ~= nil and self.players_havePerson==4 then
                    self.myself_view_invite:setVisible(false)
                end
            end
        end 
        
        headView.isBanker:setVisible(false) -- 是不是庄家  暂时不用显示
    elseif playStatus == CEnum.playStatus.playing then
        headView.btnPrepare:setVisible(false)
        if _seat == CEnumM.seatNo.me then
            self.myself_view_invite:setVisible(false)
        end
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
            self.myself_view_invite:setVisible(false)

            if CVar._static.appstoreSwitch == CEnum.appstoreSwitch.close then
                self.myself_view_invite:setVisible(false)
            else
                self.myself_view_invite:setVisible(true)
                if self.players_havePerson ~= nil and self.players_havePerson==4 then
                    self.myself_view_invite:setVisible(false)
                end
            end --_seat == CEnumM.seatNo.me
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
function MJRoomScene:createTopView()
    self.topView = cc.NodeGrid:create()
    self.topView:addTo(self.Layer1)
    self.topView:setVisible(true)

    -- 失联的提示文字
    self.topRule_view_noConnectServer = display.newTTFLabel({
            text = Strings.gameing.noConnectServer,
            size = Dimens.TextSize_25,
            color = cc.c3b(23,23,24),
            font = Fonts.Font_hkyt_w7,
            align = cc.ui.TEXT_ALIGN_CENTER,
            valign = cc.ui.TEXT_VALIGN_CENTER,
        })
        :addTo(self.Layer1)
        :align(display.CENTER, display.cx, display.cy-84)
        :setVisible(false)

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

    -- 返回大厅
    if not CEnum.Environment.outRelease then
        cc.ui.UIPushButton.new(
            Imgs.gameing_top_btn_back,{scale9=false})
            :setButtonSize(42, 40)
            :setButtonImage(EnStatus.pressed, Imgs.gameing_top_btn_back)
            :onButtonClicked(function(e)
                CDialog.new():popDialogBox(self.Layer1, 
                    CDialog.title_logo.backHome, "返回大厅,房间仍会保留,快去邀请大伙来玩吧",
                    function(...)
                        self:backHome_OK()
                    end
                    , function( ... )
                        self:backHome_NO()
                    end)
            end)
            :align(display.RIGHT_TOP, display.right-17, display.top-8)
            :addTo(self.topView)
    end

    -- 当前时间显示
    local myDate = os.date("%H:%M") -- "%Y-%m-%d %H:%M:%S"
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
    --[[
    if CVar._static.isIphone4 then
        myDate_label:align(display.LEFT_TOP, 125-25, osHeight-8-1)
    elseif CVar._static.isIpad then
        myDate_label:align(display.LEFT_TOP, 125-25-15, osHeight-8-1)
    elseif CVar._static.NavBarH_Android ~= CEnum.status.NavBarH_def then
        myDate_label:align(display.LEFT_TOP, 125 -CVar._static.NavBarH_Android*0.1, osHeight-8-1)
    end
    ]]

    local function MJRoomScene_changeTime()
        myDate = os.date("%H:%M") -- "%H:%M:%S"
        myDate_label:setString(myDate)
    end
    
    self.scheduleTimeID = self.top_scheduler:scheduleScriptFunc(MJRoomScene_changeTime, 60, false) -- 1分钟一次
    --Commons:printLog_Info("----走时间 这个计时器：", self.top_schedulerID)

    local function listeningNetwork()
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
            local nowDate = os.time()

            Commons:printLog_Info("----tt 现在的时间是：", nowDate, type(nowDate))
            if self.isConnected_sockk_time ~= nil then
                Commons:printLog_Info("----tt 变化的的时间是：", self.isConnected_sockk_time, type(self.isConnected_sockk_time))
                local gaping_time = nowDate - self.isConnected_sockk_time
                Commons:printLog_Info("----tt 相差多久：", gaping_time, type(gaping_time))
                if gaping_time >= 10 then
                    -- 只要有数据过来，我就改变记录这个时间点
                    --isConnected_sockk_time = tonumber(os.date(CEnum.timeFormat.ymdhms) .. "")
                    --isConnected_sockk_time = tonumber(socketCCC.gettime() )
                    self.isConnected_sockk_time = os.time()
                    self:NetIsOK_change()
                end
            end
        end
    end

    Commons:printLog_Info("--gameing 什么平台：：", Commons.osType)
    if Commons.osType == CEnum.osType.A or Commons.osType == CEnum.osType.I -- or Commons.osType == CEnum.osType.W 
        then
        self.top_schedulerID_network = self.top_scheduler:scheduleScriptFunc(listeningNetwork, 4, false) -- **秒一次
        Commons:printLog_Info("----A I 监听网络状态 这个计时器：", self.top_schedulerID_network)
    elseif CEnum.Environment.Current~=nil and CEnum.Environment.Current==CEnum.EnvirType.Test then
        
    end

    -- 设置
    local top_view_setting=cc.ui.UIPushButton.new(
        ImgsM.setting,{scale9=false})
        :setButtonSize(42, 44)
        :setButtonImage(EnStatus.pressed, ImgsM.setting)
        :onButtonClicked(function(e)
        
            VoiceDealUtil:playSound_forMJ(Voices.file.ui_click)
            SettingDialog:popDialogBox(self.Layer1, CEnum.pageView.gameingOverPage)
            
        end)
        :align(display.RIGHT_TOP, display.right-17, display.top-67)
        :addTo(self.topView)
    --[[
    if CVar._static.isIphone4 then
        top_view_setting:align(display.LEFT_TOP, 484-80, osHeight-8)
    elseif CVar._static.isIpad then
        top_view_setting:align(display.LEFT_TOP, 484-80-60, osHeight-8)
    elseif CVar._static.NavBarH_Android ~= CEnum.status.NavBarH_def then
        top_view_setting:align(display.LEFT_TOP, 484-CVar._static.NavBarH_Android/2, osHeight-8)
    end
    ]]

    -- 解散房间
    self.top_view_dissRoom = cc.ui.UIPushButton.new(
        ImgsM.dms_room,{scale9=false})
        :setButtonSize(46, 41)
        :setButtonImage(EnStatus.pressed, ImgsM.dms_room)
        :onButtonClicked(function(e)

            VoiceDealUtil:playSound_forMJ(Voices.file.ui_click)
            CDialog.new():popDialogBox(self.Layer1, 
                nil, Strings.gameing.dissRoomConfim,
                function( ... )
                        self:dissRoomMeConfim_OK()
                end 
                , function( ... )
                        self:dissRoomMeConfim_NO()
                end)
        end)
        :align(display.RIGHT_TOP, display.right-17, display.top-8)
        :addTo(self.topView)
    --[[
    if CVar._static.isIphone4 then
        self.top_view_dissRoom:align(display.RIGHT_TOP, osWidth-464+80, osHeight-8)
    elseif CVar._static.isIpad then
        self.top_view_dissRoom:align(display.RIGHT_TOP, osWidth-464+80+55, osHeight-8)
    elseif CVar._static.NavBarH_Android ~= CEnum.status.NavBarH_def then
        self.top_view_dissRoom:align(display.RIGHT_TOP, osWidth-464+CVar._static.NavBarH_Android/2-5, osHeight-8)
    end
    ]]
    -- 返回大厅
    self.top_view_backRoom = cc.ui.UIPushButton.new(
        Imgs.gameing_top_btn_back,{scale9=false})
        :setButtonSize(42, 40)
        :setButtonImage(EnStatus.pressed, Imgs.gameing_top_btn_back)
        :onButtonClicked(function(e)

            VoiceDealUtil:playSound_forMJ(Voices.file.ui_click)
            CDialog.new():popDialogBox(self.Layer1, 
                CDialog.title_logo.backHome, Strings.gameing.outRoomConfim,function( ... )
                    self:backHome_OK_toSendServer()
                end
                , function( ... )
                        self:backHome_NO()
                end)
        end)
        :align(display.RIGHT_TOP, display.right-17, display.top-8)
        :addTo(self.topView)
        :setVisible(false)
    --[[
    if CVar._static.isIphone4 then
        self.top_view_backRoom:align(display.RIGHT_TOP, osWidth-464+80, osHeight-8)
    elseif CVar._static.isIpad then
        self.top_view_backRoom:align(display.RIGHT_TOP, osWidth-464+80+55, osHeight-8)
    elseif CVar._static.NavBarH_Android ~= CEnum.status.NavBarH_def then
        self.top_view_backRoom:align(display.RIGHT_TOP, osWidth-464+CVar._static.NavBarH_Android/2-5, osHeight-8)
    end
    ]]

    -- gprs定位信息显示按钮
    self.top_view_gprsBtn = cc.ui.UIPushButton.new(
        Imgs.g_th_green,{scale9=false})
        :setButtonImage(EnStatus.pressed, Imgs.g_th_green)
        :onButtonClicked(function(e)

            VoiceDealUtil:playSound_forMJ(Voices.file.ui_click)
            if self.playerNum == 4 then
                self.PopGprsDialog = CDAlertGprs4person:popDialogBox(self.Layer1, self.GprsBean)
            else
                self.PopGprsDialog = CDAlertGprs:popDialogBox(self.Layer1, self.GprsBean)
            end
        end)
        -- :align(display.CENTER, 350, osHeight-40 +16)
        :align(display.RIGHT_TOP, display.right-20, display.top-67-60)
        -- 调整到层级最高，就需要第一次处于隐藏状态
        :addTo(self.Layer1, CEnum.ZOrder.gameingView_myself_voice)
        :setScale(0.9)
        :hide()
    --[[
    if CVar._static.isIphone4 then
        self.top_view_gprsBtn:align(display.CENTER, 350 -100, osHeight-40 +16)
    elseif CVar._static.isIpad then
        self.top_view_gprsBtn:align(display.CENTER, 350 -150, osHeight-40 +16)
    elseif CVar._static.NavBarH_Android ~= CEnum.status.NavBarH_def then
        self.top_view_gprsBtn:align(display.CENTER, 350 -CVar._static.NavBarH_Android/2, osHeight-40 +16) -- 最左边
    end   
    --]]
end


--创建出牌的提醒手势
function MJRoomScene:createChuPaiTixing()
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
function MJRoomScene:chuPaiTixingAnimal()
    self.chu_tipimg_node:stopAllActions()
    local move4 = cc.MoveTo:create(1.0, cc.p(osWidth-42*8, 16));
    local move5 = cc.MoveTo:create(1.0, cc.p(osWidth-42*9, -40));
    local sequenceAction = cc.Sequence:create(move4,move5)
    local repeatAction = cc.Repeat:create(sequenceAction, 15)
    self.chu_tipimg_node:runAction(repeatAction)
end

-- 顶部组件赋值
function MJRoomScene:top_setViewData(res_data)
    if res_data ~= nil then
        local room = res_data--[User.Bean.room]

        local roomNo = room[Room.Bean.roomNo]
        --Commons:printLog_Info("top_view_roomNo:::", roomNo)
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
function MJRoomScene:players_info_setViewData(res_data)
    if res_data ~= nil then
        local room = res_data--[User.Bean.room]

        local _room_status = room[Room.Bean.status]
        CVar._static.roomStatus = room[Room.Bean.status]
        local room_status
        if CEnum.roomStatus.started == _room_status then
            room_status = true
        end
        --local playRound = room[Room.Bean.playRound] -- 第几局
        --local rounds  = room[Room.Bean.rounds] -- 总局数

        local players = room[Room.Bean.players]

        --local owerNo = nil -- 我本人的位置在哪里？ 
        if players ~= nil and type(players)=="table" then
            for k,v in pairs(players) do
                --if v[Player.Bean.me] and CEnum.netStatus.online==v[Player.Bean.netStatus] then
                if v[Player.Bean.me] then
                    --owerNo = v[Player.Bean.seatNo]
                    --self.mySeatNo = v[Player.Bean.seatNo] -- owerNo
                    local playStatus = v[Player.Bean.playStatus] -- 游戏状态
                    local owner = v[Player.Bean.owner]
                    if room_status then
                        self.top_view_dissRoom:setVisible(true)
                        self.top_view_backRoom:setVisible(false)
                    else
                        if owner then
                            self.top_view_dissRoom:setVisible(true)
                            self.top_view_backRoom:setVisible(false)
                        else
                            self.top_view_dissRoom:setVisible(false)
                            self.top_view_backRoom:setVisible(true)
                        end
                    end

                    if playStatus == CEnum.playStatus.ended then
                        self:changeOtherPlayerHandCardsVisible("n")
                    end

                    break
                end
            end

            self.players_havePerson = #players
            --[[
            if #players == 1 then
                self.players_havePerson = 1
            elseif #players == 2 then
                self.players_havePerson = 2
            elseif #players == 3 then
                self.players_havePerson = 3
            end
            ]]
        end

        if players ~= nil and type(players)=="table" then
            for k,v in pairs(players) do
                self:updatePlayerHeaderInfo(v)
            end
        end
    end
end

--根据服务器数据更新我的手牌
function MJRoomScene:myself_handCard_createView_setViewData(res_data)
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
                            --if #self.currMyHandCardsData ~= #tempMyHandCardsData then
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
                            --end
                        end
                    end

                    if Commons:checkIsNull_tableType(action) then
                        --_card = action[Player.Bean.card]
                        local _type = action[Player.Bean._type]
                        local _cardObject = action[Player.Bean.card]
                        if self.refreshRoomFlag == false then
                            if _cardObject ~= nil and _type == CEnum.options.mo then
                                VoiceDealUtil:playSound_forMJ(VoicesM.file.moCard)
                                if tempMyHandCardsData ~= nil and #tempMyHandCardsData ~= #self.curMyHandCards then
                                    self:moPaiMyHandCards(_cardObject)
                                end
                            elseif _cardObject ~= nil and _type == CEnum.options.chu then
                                --self:curMyHandCardMove()
                                self:refreshMyHandCards(self.currMyHandCardsData)
                                self:refreshPlayerChuCards()
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
function MJRoomScene:createMyHandCards(cardList)
    --[[
    local chiCombs = nil 
    if self.curResData ~= nil then
        local players = self.curResData[Room.Bean.players]

        if players ~= nil and type(players)=="table" then
            for k,v in pairs(players) do
                if v[Player.Bean.me] then
                    chiCombs = v[Player.Bean.chiCombs]
                end
            end
        end 
    end
    local number = 0
    if Commons:checkIsNull_tableList(chiCombs) then
        number = #chiCombs    
    end
    ]]

    local number = #self.curMyPGChiCards/ 3
    --算出偏移量
    local offsetDis = number * (52 *self.handCardScaleFact * 3 + 15)

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
            if handObject.optionType == "a" then
                handSprite.isCanChu = true
            else
                handSprite.isCanChu = false
            end

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

    self.clientCanChuCard = true
    
end

--刷新手牌
function MJRoomScene:refreshMyHandCards(cardList)
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
function MJRoomScene:reworkPrevHandCard(curHandCard)
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
function MJRoomScene:moPaiMyHandCards(card)
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
    if card.optionType == "a" then
        handSprite.isCanChu = true
    else
        handSprite.isCanChu = false
    end

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
    local offsetDis = number * (52*self.handCardScaleFact * 3 + 15)
    --放到手牌最后的位置，偏移8个像素
    local endPosX = display.left+40*self.handCardScaleFact+offsetDis+(#self.curMyHandCards)*81*self.handCardScaleFact + 40*self.handCardScaleFact
    local endPosY = display.bottom+self.CARD_TO_BOTTOM*self.handCardScaleFact
    handSprite.originalPosX = endPosX
    handSprite.originalPosY = endPosY

    self.curMyHandCards[#self.curMyHandCards + 1] = handSprite

    transition.execute(handSprite, cc.MoveTo:create(0.3, cc.p(endPosX, endPosY)), {
        --delay = 0.0,
        --easing = "backout",
        onComplete = function()
            --如果手牌不一致，刷新手牌
            if self.currMyHandCardsData ~= nil then
                self:refreshMyHandCards(self.currMyHandCardsData)
            end
            --[[
            if self.currMyHandCardsData ~= nil and #self.curMyHandCards ~= #self.currMyHandCardsData then
                self:refreshMyHandCards(self.currMyHandCardsData)
            end
            ]]
        end,
    })

    
end

--出牌后先保存当前移动的牌，等服务器出牌下行后才开始动画
function MJRoomScene:handlerMyHandCard(curHandCard)
    --self.curMoveMyHandCard = curHandCard
    if self.isMyHu then
        local function option_giveup_OK()
            MJSocketGameing:gameing_Chu(tonumber(curHandCard:getName()))
            self.isMyHu = false
            self:curMyHandCardMove(curHandCard)
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
        self:curMyHandCardMove(curHandCard)
    end

end

--将当前牌移动到中间位置，并消失，同时生成一张已经出的牌
function MJRoomScene:curMyHandCardMove(curHandCard)
    self.clientCanChuCard = false
    VoiceDealUtil:playSound_forMJ(VoicesM.file.outCard)
    VoiceDealUtil:playSound_forMJ(VoicesM.file["card_"..curHandCard:getName()])

    --curHandCard:setLocalZOrder(20)
    --if self.curMoveMyHandCard ~= nil then
        self.prevHandCard = nil
        transition.execute(curHandCard, cc.MoveTo:create(0.3, cc.p(display.cx-40, display.bottom+167+70)), {
            --delay = 0.0,
            --easing = "backout",
            onComplete = function()
                
                --先不删除
                curHandCard:hide()
                
                --self.prevHandCard = nil
                --self:refreshMyHandCard()
                --[[
                self.prevHandCard = nil
                table.remove(self.curMyHandCards, curHandCard.indexNum)
                self:refreshMyHandCard()
                curHandCard:hide()
                curHandCard:removeFromParent()
                ]]

                --生成一张刚出过的牌
                local chuNums = #self.hasChuCards[CEnumM.seatNo.me]
                local tempCard = display.newSprite(ImgsM.chu_card_bg)
                    :addTo(self.Layer1)

                --记录ID
                tempCard.cardID = curHandCard:getName()

                --一行10列
                local hangNum = math.floor(chuNums / self.chuCardColumn)
                tempCard:align(display.LEFT_BOTTOM, 
                             display.left + display.cx - 165 * self.handCardScaleFact 
                             + (chuNums % self.chuCardColumn) * 33* self.handCardScaleFact,
                              display.bottom + 152 + 45 * hangNum * self.handCardScaleFact)
                            :setLocalZOrder(10-hangNum)
                            :setScale(self.handCardScaleFact)

                local temCardSize = tempCard:getContentSize()
                display.newSprite("#s_"..curHandCard:getName()..".png")
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
                self:removeMyHandCard(curHandCard)
                
                --刷新已经出的牌
                --self:refreshPlayerChuCards()

                --self.curMoveMyHandCard = nil
                --出完牌动画播放完成后再刷新手牌
                --if self.currMyHandCardsData ~= nil then
                    --self:refreshMyHandCards(self.currMyHandCardsData)
                --end
                
            end,
        })
    --end
    
end

--移除手牌
function MJRoomScene:removeMyHandCard(card)
    self.prevHandCard = nil
    table.remove(self.curMyHandCards, card.indexNum)
    if card ~= nil and (not tolua.isnull(card)) then
        card:hide()
        card:removeFromParent()
    end
    card = nil
end

--刷新手牌位置，没次出完牌，或碰，杠牌后刷新手中的手牌
function MJRoomScene:refreshMyHandCardPos()
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
function MJRoomScene:myPlayerChiGangPengScaleCard(curOptionObj)
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
function MJRoomScene:createPengGangChiCards(curOptionObj) 
    --刷新手牌
    --self:refreshMyHandCards(self.currMyHandCardsData)

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
            local offsetDis = number * (52*self.handCardScaleFact * 3 + 15)

            local startPosX = display.left+500*self.handCardScaleFact+numX*52*self.handCardScaleFact
            local startPosY = display.bottom+222

            local endPosX = display.left+40*self.handCardScaleFact+offsetDis+numX*52*self.handCardScaleFact
            local endPosY = display.bottom+posY

            local cardBgStr = ImgsM.peng_shang
            if cardObj.showType == CEnumM.showType.g then
                cardBgStr = ImgsM.peng_gai
            end

            local tempCard = display.newSprite(cardBgStr)
                    --:addTo(self.Layer1)
                    --:align(display.LEFT_BOTTOM, startPosX, startPosY)
                    :setLocalZOrder(20)
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
                            
                            --去除杠，碰的其他玩家已经出的对应的牌

                            --local chuCard = self.hasChuCards[clientSeatNo][#self.hasChuCards[clientSeatNo]]
                            --if chuCard ~= nil then
                            --    table.remove(self.hasChuCards[clientSeatNo], #self.hasChuCards[clientSeatNo])
                            --    chuCard:removeFromParent()
                            --end
                            --chuCard = nil
                            
                            --刷新出过的牌
                            self:refreshPlayerChuCards()
                            
                        end
                        
                    end,
                })
            end

    end

    tempPengIndexArray = {}

end

function MJRoomScene:buildPengGangChiCards(curOptionObj)  
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
            local offsetDis = number * (52*self.handCardScaleFact * 3 + 15)

            local endPosX = display.left+40*self.handCardScaleFact+offsetDis+numX*52*self.handCardScaleFact
            local endPosY = display.bottom+posY

            local cardBgStr = ImgsM.peng_shang
            if cardObj.showType == CEnumM.showType.g then
                cardBgStr = ImgsM.peng_gai
            end

            local tempCard = display.newSprite(cardBgStr)
                    :setLocalZOrder(20)
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
function MJRoomScene:refreshPengGangChiCards()
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

                if clientSeatNo == CEnumM.seatNo.me and chiCombs == nil then
                    for i=1,#self.curMyPGChiCards do
                        local tempObj = self.curMyPGChiCards[i]
                        tempObj:removeFromParent()
                    end
                    self.curMyPGChiCards = {}
                end
                
            end
        end
    end
end

--刷新玩家已经出的牌
function MJRoomScene:refreshPlayerChuCards()
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
                                    :setLocalZOrder(19-indexNum)
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
function MJRoomScene:createOtherPlayerHandCards()
    for i=1,13 do
        local leftBlank = display.newSprite(ImgsM.left_blank)
                    :align(display.LEFT_BOTTOM, display.left + self.otherLeftStartPosX * self.handCardScaleFact,
                     display.bottom + self.otherLeftStartPosY * self.handCardScaleFact - (i-1)*self.otherLeftRightHandCardLength * self.handCardScaleFact)
                    :setFlippedX(true)
                    :setScale(self.handCardScaleFact)
                    :addTo(self.Layer1)
        leftBlank.originalPosX = leftBlank:getPositionX()
        leftBlank.originalPosY = leftBlank:getPositionY()
        self.otherHandCards[CEnumM.seatNo.L][#self.otherHandCards[CEnumM.seatNo.L] + 1] = leftBlank

        local rightBlank = display.newSprite(ImgsM.left_blank)
                    :align(display.RIGHT_BOTTOM, display.right - self.otherRightStartPosX * self.handCardScaleFact,
                     display.bottom + self.otherRightStartPosY  * self.handCardScaleFact + (i-1)*self.otherLeftRightHandCardLength * self.handCardScaleFact)
                    :setScale(self.handCardScaleFact)
                    :addTo(self.Layer1)
                    :setLocalZOrder(22-i)
        rightBlank.originalPosX = rightBlank:getPositionX()
        rightBlank.originalPosY = rightBlank:getPositionY()
        self.otherHandCards[CEnumM.seatNo.R][#self.otherHandCards[CEnumM.seatNo.R] + 1] = rightBlank

        local midHandBlank = display.newSprite(ImgsM.mid_hand_blank)
                    :align(display.RIGHT_TOP, display.right - self.otherMidStartPosX * self.handCardScaleFact - (i-1)*self.otherMidHandCardLength* self.handCardScaleFact, 
                        display.top - self.otherMidStartPosY)
                    :setScale(self.handCardScaleFact)
                    :addTo(self.Layer1)
        midHandBlank.originalPosX = midHandBlank:getPositionX()
        midHandBlank.originalPosY = midHandBlank:getPositionY()
        self.otherHandCards[CEnumM.seatNo.M][#self.otherHandCards[CEnumM.seatNo.M] + 1] = midHandBlank
    end

    self:changeOtherPlayerHandCardsVisible("n")
end

--改变其他三个玩家的手牌显示
--isShow: true  false
function MJRoomScene:changeOtherPlayerHandCardsVisible(ishSow)
    -- for k,v in pairs(self.otherHandCards) do
    --     for ik,iv in pairs(v) do
    --         if iv ~= nil and (not tolua.isnull(iv)) then
    --             iv:hide()
    --             iv:removeFromParent()
    --         end
    --     end
    -- end
    -- self.otherHandCards = {[2]={},[3]={},[4]={}}

    -- local flag = false
    -- if self.curResData ~= nil then
    --     local players = self.curResData[Room.Bean.players]

    --     if players ~= nil and type(players)=="table" then
    --         for k,v in pairs(players) do
    --             if v[Player.Bean.me] then
    --                 local playStatus = v[Player.Bean.playStatus]
    --                 if self.curResData.status == "started" and playStatus == CEnum.playStatus.playing then
    --                     flag = true
    --                 end
    --             end
                
    --         end
    --     end
    -- end

    -- if self.curResData ~= nil and flag == true then
    --     local players = self.curResData[Room.Bean.players]

    --     if players ~= nil and type(players)=="table" then
    --         for k,v in pairs(players) do
    --             local seatNo = v[Player.Bean.seatNo]
    --             local chiCombs = v[Player.Bean.chiCombs]
    --             local playerType = GameMaJiangUtil:confimSeatNo(self.mySeatNo, seatNo)

    --             if playerType ~= CEnumM.seatNo.me then
    --                 local handCount = 13
    --                 local number = 0
    --                 if chiCombs ~= nil then
    --                     handCount = 13 - #chiCombs*3
    --                     number = #chiCombs
    --                 end

    --                 for i=1,handCount do
    --                     local numX = i - 1
    --                     local posY = 5

    --                     --算出偏移量
    --                     local offsetDis = number * (32 * self.handCardScaleFact * 3 + 15)
    --                     --如果为对家是横向偏移，其他为纵向偏移
    --                     if playerType == CEnumM.seatNo.R  then
    --                         offsetDis = number * (32 * self.handCardScaleFact * 3 + 15)
    --                     elseif playerType == CEnumM.seatNo.M then
    --                         offsetDis = number * (33 * self.handCardScaleFact * 3 + 9)
    --                     end

    --                     local cardStr = ImgsM.left_blank
    --                     if playerType == CEnumM.seatNo.M then
    --                         cardStr = ImgsM.mid_hand_blank
    --                     end

    --                     local tempCard = display.newSprite(cardStr):addTo(self.Layer1)
    --                     if playerType == CEnumM.seatNo.L then
    --                         tempCard:setFlippedX(true)
    --                         local posX = display.left+185*self.handCardScaleFact
    --                         local posY = display.bottom+630*self.handCardScaleFact-offsetDis-32*self.handCardScaleFact*numX
    --                         tempCard:align(display.LEFT_BOTTOM, posX, posY)
    --                     elseif playerType == CEnumM.seatNo.R then
    --                         local posX = display.right-185*self.handCardScaleFact
    --                         local posY = display.bottom+160*self.handCardScaleFact+offsetDis+32*self.handCardScaleFact*numX
    --                         tempCard:align(display.RIGHT_BOTTOM, posX, posY)
    --                     elseif playerType == CEnumM.seatNo.M then
    --                         local posX = display.right-400*self.handCardScaleFact-offsetDis-33*self.handCardScaleFact*numX
    --                         local posY = display.top-26
    --                         tempCard:align(display.RIGHT_TOP, posX, posY)
    --                     end
    --                     self.otherHandCards[playerType][#self.otherHandCards[playerType]+1] = tempCard

    --                 end
    --             end

                

    --         end
    --     end
    -- end

    local isFlagShow =  ishSow=='y'
    if ishSow == 'y' then
        --if self.playerHeardViewList[CEnumM.seatNo.me] ~= nil 
        --    and self.playerHeardViewList[CEnumM.seatNo.me].btnPrepare:isButtonEnabled() == false then

            for k,v in pairs(self.otherHandCards) do
                for ik,iv in pairs(v) do
                    if iv ~= nil then
                        iv:setPosition(iv.originalPosX, iv.originalPosY)
                        iv:setVisible(isFlagShow)
                        
                    end
                end
            end

            if self.curResData ~= nil then
                local players = self.curResData[Room.Bean.players]
                if players ~= nil and type(players)=="table" then
                    for k,v in pairs(players) do
                        if v[Player.Bean.me] == false then
                            local seatNo = v[Player.Bean.seatNo]
                            local tempSeatNo = GameMaJiangUtil:confimSeatNo(self.mySeatNo, seatNo)
                            --local holdNum = v[Player.Bean.holdNum]
                            local chiCombs = v[Player.Bean.chiCombs]
                            local length = 0
                            if Commons:checkIsNull_tableList(chiCombs) then
                                --算出偏移量
                                local offsetDis = #chiCombs * (32 * self.handCardScaleFact * 3 + 15)
                                --如果为对家是横向偏移，其他为纵向偏移
                                if tempSeatNo == CEnumM.seatNo.R  then
                                    offsetDis = #chiCombs * (32 * self.handCardScaleFact * 3 + 15)
                                elseif tempSeatNo == CEnumM.seatNo.M then
                                    offsetDis = #chiCombs * (32 * self.handCardScaleFact * 3 + 10)
                                end

                                length = #chiCombs * 3
                                --隐藏其他玩家相对应的手牌
                                if length > 0 then
                                    for j=1,length do
                                        if j > 13 then
                                            break
                                        end
                                        
                                        self.otherHandCards[tempSeatNo][j]:hide()
                                    end

                                    local needMoveLength = length+1
                                    local numX = 0

                                    for j = needMoveLength, 13 do
                                         if tempSeatNo == CEnumM.seatNo.L then
                                            local posX = display.left+185*self.handCardScaleFact
                                            local posY = display.bottom+630*self.handCardScaleFact-offsetDis-32*self.handCardScaleFact*numX 
                                            self.otherHandCards[tempSeatNo][j]:align(display.LEFT_BOTTOM, posX, posY)
                                        elseif tempSeatNo == CEnumM.seatNo.R then
                                            local posX = display.right-185*self.handCardScaleFact
                                            local posY = display.bottom+160*self.handCardScaleFact+offsetDis+32*self.handCardScaleFact*numX
                                            self.otherHandCards[tempSeatNo][j]:align(display.RIGHT_BOTTOM, posX, posY)
                                        elseif tempSeatNo == CEnumM.seatNo.M then
                                            local posX = display.right-400*self.handCardScaleFact-offsetDis-31.5*self.handCardScaleFact*numX-5
                                            local posY = display.top-26
                                            self.otherHandCards[tempSeatNo][j]:align(display.RIGHT_TOP, posX, posY)
                                        end

                                        numX = numX + 1
                                    end
                                end
                                
                            end
                        end
                    end
                end
            end
            
        --end
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
function MJRoomScene:moOtherPlayerHandCards(playerType, card)
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
            :setLocalZOrder(19-indexNum)
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

--[[
    transition.execute(handSprite, cc.MoveTo:create(0.3, cc.p(endPosX, endPosY)), {
        --delay = 0.0,
        --easing = "backout",
        onComplete = function()
                
            end
                })
]]
end

--创建一张他玩家的手牌，不明示
function MJRoomScene:otherPlayerMoHandCard(playerType, card)

    VoiceDealUtil:playSound_forMJ(VoicesM.file.moCard)

    local imgeStr = ImgsM.left_blank
    if playerType == CEnumM.seatNo.M then
        imgeStr = ImgsM.mid_hand_blank
    end

    local tempCard = display.newSprite(imgeStr)
                    :setScale(self.handCardScaleFact)
                    :addTo(self.Layer1)

    -- if playerType == CEnumM.seatNo.L then
    --     tempCard:setFlippedX(true)
    --     tempCard:align(display.LEFT_BOTTOM, display.left + 185 * self.handCardScaleFact, 
    --         display.bottom + 590 * self.handCardScaleFact - (#self.otherHandCards[CEnumM.seatNo.L])*32 * self.handCardScaleFact-15)
    -- elseif playerType == CEnumM.seatNo.R then
    --     tempCard:align(display.RIGHT_BOTTOM, display.right - 185 * self.handCardScaleFact, 
    --         display.bottom + 190 * self.handCardScaleFact + (#self.otherHandCards[CEnumM.seatNo.R])*32 * self.handCardScaleFact+15)
    -- else
    --     tempCard:align(display.RIGHT_TOP, display.right - 435 * self.handCardScaleFact 
    --         - (#self.otherHandCards[CEnumM.seatNo.M])*33 * self.handCardScaleFact-10, display.top - 26)
    -- end

    local length = 0
    if self.curResData ~= nil then
        local players = self.curResData[Room.Bean.players]
        if players ~= nil and type(players)=="table" then
            for k,v in pairs(players) do
                if v[Player.Bean.me] == false then
                    local seatNo = v[Player.Bean.seatNo]
                    local tempSeatNo = GameMaJiangUtil:confimSeatNo(self.mySeatNo, seatNo)
                    local chiCombs = v[Player.Bean.chiCombs]
                    
                    if tempSeatNo == playerType then
                        if Commons:checkIsNull_tableList(chiCombs) then
                            length = #chiCombs
                        end

                        break
                    end
                end
            end
        end
    end

    --算出偏移量
    local offsetDis = length * (self.otherLeftRightPGCardLength * self.handCardScaleFact * 3 + self.otherLeftRightPGChiOffsetDis)
    --如果为对家是横向偏移，其他为纵向偏移
    if playerType == CEnumM.seatNo.R  then
        offsetDis = length * (self.otherLeftRightPGCardLength * self.handCardScaleFact * 3 + self.otherLeftRightPGChiOffsetDis)
    elseif playerType == CEnumM.seatNo.M then
        offsetDis = length * (self.otherMidPGCardLength * self.handCardScaleFact * 3 + self.otherMidPGChiOffsetDis)
    end

    local numX = 14 - length*3 - 1
    if playerType == CEnumM.seatNo.L then
        local posX = display.left+self.otherLeftStartPosX*self.handCardScaleFact
        local posY = display.bottom+self.otherLeftStartPosY*self.handCardScaleFact-offsetDis-self.otherLeftRightHandCardLength*self.handCardScaleFact*numX - self.otherLeftRightMoCardOffset -- - addPosX
        tempCard:align(display.LEFT_BOTTOM, posX, posY)
    elseif playerType == CEnumM.seatNo.R then
        local posX = display.right-self.otherRightStartPosX*self.handCardScaleFact
        local posY = display.bottom+self.otherRightStartPosY*self.handCardScaleFact+offsetDis+self.otherLeftRightHandCardLength*self.handCardScaleFact*numX + self.otherLeftRightMoCardOffset -- + addPosX
        tempCard:align(display.RIGHT_BOTTOM, posX, posY)
    elseif playerType == CEnumM.seatNo.M then
        local posX = display.right-self.otherMidStartPosX*self.handCardScaleFact-offsetDis-self.otherMidHandCardLength*self.handCardScaleFact*numX - self.otherMidMoCardLength -- - addPosX
        local posY = display.top-self.otherMidStartPosY
        tempCard:align(display.RIGHT_TOP, posX, posY)
    end

    if self.otherMoHandCard ~= nil and (not tolua.isnull(self.otherMoHandCard)) then
        self.otherMoHandCard:removeFromParent()
        self.otherMoHandCard = nil
    end

    self.otherMoCards[#self.otherMoCards+1] = tempCard
    self.otherMoHandCard = tempCard
    
    -- local sequence = transition.sequence({
    --     cc.DelayTime:create(2.5),
    --     cc.CallFunc:create(
    --         function()
    --                 --tempCard:removeFromParent()
    --         end
    --         )
        
    -- })
    -- tempCard:runAction(sequence)
end

--创建一张临时的牌，做放大，消失动画
function MJRoomScene:otherPlayerChuCardScaleCard(playerType, card)
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
function MJRoomScene:otherPlayerCPGHScaleCard(playerType, curOptionObj)
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
function MJRoomScene:createOtherPengGangChiCards(playerType, curOptionObj)
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
        local offsetDis = number * (self.otherLeftRightPGCardLength * self.handCardScaleFact * 3 + self.otherLeftRightPGChiOffsetDis)
        --如果为对家是横向偏移，其他为纵向偏移
        if playerType == CEnumM.seatNo.M then
            offsetDis = number * (self.otherMidPGCardLength * self.handCardScaleFact * 3 + self.otherMidPGChiOffsetDis)
        end

        local posX = display.left+self.otherLeftStartPosX*self.handCardScaleFact
        local posY = display.bottom+self.otherLeftStartPosY*self.handCardScaleFact-offsetDis-self.otherLeftRightPGCardLength*self.handCardScaleFact*numX
        if playerType == CEnumM.seatNo.R then
            posX = display.right-185*self.handCardScaleFact
            posY = display.bottom+160*self.handCardScaleFact+offsetDis+self.otherLeftRightPGCardLength*self.handCardScaleFact*numX
        elseif playerType == CEnumM.seatNo.M then
            posX = display.right-400*self.handCardScaleFact-offsetDis-self.otherMidPGCardLength*self.handCardScaleFact*numX
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
            tempCard:setLocalZOrder(CEnumM.ZOrder.playerNode+10-i)
        else
            tempCard:setLocalZOrder(20)
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
                if chiCard ~= nil and (not tolua.isnull(chiCard)) then
                    chiCard:removeFromParent()
                end
                
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

    
    -- for i=1,#self.otherPGCHiCards[playerType] do
    --     if i > 13 then
    --         break
    --     end
        
    --     self.otherHandCards[playerType][i]:hide()
    -- end

    --隐藏其他玩家相对应的手牌
    if self.curResData ~= nil then
        local players = self.curResData[Room.Bean.players]
        if players ~= nil and type(players)=="table" then
            for k,v in pairs(players) do
                if v[Player.Bean.me] == false then
                    local seatNo = v[Player.Bean.seatNo]
                    local tempSeatNo = GameMaJiangUtil:confimSeatNo(self.mySeatNo, seatNo)
                    if tempSeatNo == playerType then
                        local chiCombs = v[Player.Bean.chiCombs]
                        if Commons:checkIsNull_tableList(chiCombs) then
                            --算出偏移量
                            local offsetDis = #chiCombs * (32 * self.handCardScaleFact * 3 + 15)
                            --如果为对家是横向偏移，其他为纵向偏移
                            if playerType == CEnumM.seatNo.R  then
                                offsetDis = #chiCombs * (32 * self.handCardScaleFact * 3 + 15)
                            elseif playerType == CEnumM.seatNo.M then
                                offsetDis = #chiCombs * (32 * self.handCardScaleFact * 3 + 10)
                            end

                            local length = #chiCombs * 3
                            --隐藏其他玩家相对应的手牌
                            if length > 0 then
                                for i=1,length do
                                    if i > 13 then
                                        break
                                    end
                                    
                                    self.otherHandCards[playerType][i]:hide()
                                end

                                local needMoveLength = length+1
                                local numX = 0
print("needMoveLength-------"..needMoveLength)
                                for j = needMoveLength, 13 do
                                     if playerType == CEnumM.seatNo.L then
                                        local posX = display.left+185*self.handCardScaleFact
                                        local posY = display.bottom+630*self.handCardScaleFact-offsetDis-32*self.handCardScaleFact*numX
                                        self.otherHandCards[playerType][j]:align(display.LEFT_BOTTOM, posX, posY)
                                    elseif playerType == CEnumM.seatNo.R then
                                        local posX = display.right-185*self.handCardScaleFact
                                        local posY = display.bottom+160*self.handCardScaleFact+offsetDis+32*self.handCardScaleFact*numX
                                        self.otherHandCards[playerType][j]:align(display.RIGHT_BOTTOM, posX, posY)
                                    elseif playerType == CEnumM.seatNo.M then
                                        local posX = display.right-400*self.handCardScaleFact-offsetDis-31.5*self.handCardScaleFact*numX-5
                                        local posY = display.top-26
                                        self.otherHandCards[playerType][j]:align(display.RIGHT_TOP, posX, posY)
                                        print("88888888888888888-------")
                                    end

                                    numX = numX + 1
                                end
                            end
                            
                        end
                        
                        break
                    end
                end
                
            end
        end
    end

end

--刷新其他玩家吃，杠，碰牌列表
function MJRoomScene:refreshOtherPengGangChiCards()
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
                            if tempObj ~= nil and (not tolua.isnull(tempObj)) then
                                tempObj:removeFromParent()
                            end
                            
                        end
                        self.otherPGCHiCards[clientSeatNo] = {}

                        for i=1,#chiCombs do
                            local combObj = chiCombs[i]
                            self:createOtherPengGangChiCards(clientSeatNo,combObj)
                        end
                end

                if clientSeatNo ~= CEnumM.seatNo.me then
                    --清除
                    if chiCombs == nil then
                        for i=1,#self.otherPGCHiCards[clientSeatNo] do
                            local tempObj = self.otherPGCHiCards[clientSeatNo][i]
                            if tempObj ~= nil and (not tolua.isnull(tempObj)) then
                                tempObj:removeFromParent()
                            end
                            
                        end
                        self.otherPGCHiCards[clientSeatNo] = {}
                    end
                end

            end
        end
    end
end


--创建听牌tips
function MJRoomScene:createTingTips()
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
function MJRoomScene:refreshTingTips(list)
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
function MJRoomScene:showGangDemos(isHu, gangDemosList, actionNo, optionName)
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
                                --VoiceDealUtil:playSound_forMJ(VoicesM.file.gang)
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
                            --VoiceDealUtil:playSound_forMJ(VoicesM.file.gang)
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

-- 选择再来一局，需要将房间界面重置，该去掉的去掉，该隐藏的隐藏
function MJRoomScene:myViewReset_thisDesktop()
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
    self.refreshRoomFlag = false
    --是否牌局结束或者房间结束
    self.isGameOver = false
    --客户端是否可以出牌
    self.clientCanChuCard = true

    self.diCardGridBgImage:hide()
    self.diCardGrid:hide()
    self.lookDiCardBtn:hide()
    self.hideDiCardBtn:hide()

    local changeToDeskTopBtn = self.Layer1:getChildByName("changeToDeskTopBtn")
    if changeToDeskTopBtn ~= nil and (not tolua.isnull(changeToDeskTopBtn)) then
        changeToDeskTopBtn:hide()
        changeToDeskTopBtn:removeFromParent()
    end

    local changeToResultBtn = self.Layer1:getChildByName("changeToResultBtn")
    if changeToResultBtn ~= nil and (not tolua.isnull(changeToResultBtn)) then
        changeToResultBtn:hide()
        changeToResultBtn:removeFromParent()
    end

    local roundRecordLayer = self.Layer1:getChildByName("PlayerRoundRecordDialog")
    if roundRecordLayer ~= nil and (not tolua.isnull(roundRecordLayer)) then
        roundRecordLayer:hide()
        roundRecordLayer:removeFromParent()
    end

    local roomRecordLayer = self.Layer1:getChildByName("PlayerRoomRecordDialog")
    if roomRecordLayer ~= nil and (not tolua.isnull(roomRecordLayer)) then
        roomRecordLayer:hide()
        roomRecordLayer:removeFromParent()
    end

end

-- 然后去建立socket连接，一旦成功，获取到相应数据，再进行页面展示
function MJRoomScene:createSocket()
    -- socket连接和发送消息的例子
    
        if CVar._static.mSocket ~= nil then
            CVar._static.mSocket:CloseSocket()
            CVar._static.mSocket = nil
        end

        local SockMsg = import("app.common.net.socket.SocketMsg");
        SockMsg:Connect(Sockets.connect.ip, Sockets.connect.port, function(...) self:resDataSocket(...) end)
        CVar._static.mSocket = SockMsg
        --Commons:printLog_Info("11 发送对象===", self, self._SockMsg, CVar._static.mSocket)
    
end

function MJRoomScene:resDataSocket(status, jsonString)
    local res_status
    local res_msg
    local res_cmd
    local res_data
    --Commons:printLog_Info("==resDataSocket:", jsonString)
    local receive_res_data = ParseBase:parseToJsonObj(jsonString)
    --local receive_res_data = resData

    if receive_res_data~=nil then
            
        end

    if receive_res_data~=nil then
        res_status = receive_res_data[ParseBase.status];
        res_msg = RequestBase:getStrDecode(receive_res_data[ParseBase.msg]);
        res_cmd = receive_res_data[ParseBase.cmd];
        res_data = receive_res_data[ParseBase.data];

        --self.curResData = res_data
        -- if res_data ~= nil then
        --     local players = res_data[Room.Bean.players]
        --     if players ~= nil and type(players)=="table" then
        --         for k,v in pairs(players) do
        --             if v[Player.Bean.me] then
        --                 self.mySeatNo = v[Player.Bean.seatNo]
        --                 break
        --             end
        --         end
        --     end
        -- end
        if res_cmd ~= Sockets.cmd.gameing_SendEmoji
           and res_cmd ~= Sockets.cmd.gameing_SuperEmoji 
           and res_cmd ~= Sockets.cmd.gameing_SendVoice 
           and res_cmd ~= Sockets.cmd.gameing_SendWords
           and res_cmd ~= Sockets.cmd.gameing_Xintiao_down
           and res_cmd ~= Sockets.cmd.gameing_Xintiao_send
           and res_cmd ~= Sockets.cmd.gameing_ExitSocket 
           and res_cmd ~= Sockets.cmd.gameing_IP_check then

            if res_data ~= nil then
                self.curResData = res_data
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
        end

        -- 只要有数据过来，我就改变记录这个时间点
        --isConnected_sockk_time = tonumber(os.date(CEnum.timeFormat.ymdhms) .. "")
        --isConnected_sockk_time = tonumber(socketCCC.gettime() )
        self.isConnected_sockk_time = os.time()

        if res_cmd ~= Sockets.cmd.gameing_Xintiao_down then
            Commons:printLog_SocketReq("==resDataSocket:", jsonString)
            Commons:printLog_Info("==resDataSocket: status", res_status)
            Commons:printLog_Info("==resDataSocket: msg", res_msg)
            Commons:printLog_Info("==resDataSocket: cmd", res_cmd)
            Commons:printLog_Info("==resDataSocket: data", res_data)
        else
            Commons:printLog_Info("----tt resDataSocket: status", res_status)
        end

        if res_cmd == nil and status == EnStatus.connected_receiveData then
            if self.errorInfo_ then
                self.errorInfo_:setString("==== ==== 空cmd ==== ====")
                -- self.errorInfo_:setString("cmd="..res_cmd_str.."  status="..res_status.."  res_msg="..res_msg)
            end
            if not self.isMyManual then
                if CVar._static.mSocket~=nil and CVar._static.mSocket:getConnected() then
                    if self.topRule_view_noConnectServer ~= nil and (not tolua.isnull(self.topRule_view_noConnectServer)) then
                        self.topRule_view_noConnectServer:setString(Strings.gameing.noConnectServer..'!')
                        self.topRule_view_noConnectServer:setVisible(true)
                    end
                    if CEnum.Environment.Current ~= nil and CEnum.Environment.Current == CEnum.EnvirType.Http then -- 正式环境
                        -- SocketRequestGameing:loginRoom(CVar._static.Lge, CVar._static.Lat)
                        SocketRequestGameing:refreshRoom()
                    end
                else
                    self:NetIsOK_change() -- 重连
                end
            end
        end
    else
        if status == EnStatus.connected_receiveData then
            if self.errorInfo_ then
                self.errorInfo_:setString("==== ==== 空包 ==== ====")
            end
            if not self.isMyManual then
                if CVar._static.mSocket~=nil and CVar._static.mSocket:getConnected() then
                    if self.topRule_view_noConnectServer ~= nil and (not tolua.isnull(self.topRule_view_noConnectServer)) then
                        self.topRule_view_noConnectServer:setString(Strings.gameing.noConnectServer..'?')
                        self.topRule_view_noConnectServer:setVisible(true)
                    end
                    if CEnum.Environment.Current ~= nil and CEnum.Environment.Current == CEnum.EnvirType.Http then -- 正式环境
                        -- SocketRequestGameing:loginRoom(CVar._static.Lge, CVar._static.Lat)
                        SocketRequestGameing:refreshRoom()
                    end
                else
                    self:NetIsOK_change() -- 重连
                end
            end
        end
    end

    if status == EnStatus.connected_succ then
        -- 连接成功，打印下返回什么数据，，同时可以给服务器上行数据拉
        Commons:printLog_Info("==connected_succ:", res_status, type(res_status))

        self.isConnected_sockk_nums = 1
        self.top_schedulerID_network_status = Nets:isNetOk()

        self.isMyManual = false
        if self.topRule_view_noConnectServer ~= nil and (not tolua.isnull(self.topRule_view_noConnectServer)) then
            self.topRule_view_noConnectServer:setVisible(false)
        end

        if CEnum.status.success == res_status then
            if self.loadingSpriteAnim~=nil and (not tolua.isnull(self.loadingSpriteAnim)) then
                self.loadingSpriteAnim:stopAllActions()
                self.loadingSpriteAnim:setVisible(false)
            end
            
            --[[
            if self.topView ~= nil and (not tolua.isnull(self.topView)) then
            else
                -- 顶部组件初始化
                GameingScene:top_createView()
            end
            if dcard_view ~= nil and (not tolua.isnull(dcard_view)) then
            else
                -- 底牌
                GameingScene:dcard_createView()
            end
            if myself_view ~= nil and (not tolua.isnull(myself_view)) then
            else
                -- 自己位置的界面组件
                GameingScene:myself_createView()
            end
            if xiajia_view ~= nil and (not tolua.isnull(xiajia_view)) then 
            else
                -- 相对自己的位置  的下一玩家
                GameingScene:xiajia_createView()
            end
            if lastjia_view ~= nil and (not tolua.isnull(lastjia_view)) then
            else
                -- 相对自己的位置  的上一玩家，也是最后一玩家
                GameingScene:lastjia_createView()
            end  
            ]]          

            if CEnum.Environment.Current ~= nil and CEnum.Environment.Current == CEnum.EnvirType.Http then -- 正式环境
                 SocketRequestGameing:loginRoom(CVar._static.Lge, CVar._static.Lat)
             end
        end

    elseif status == EnStatus.connected_fail or status == EnStatus.connected_closed then
        -- 连接失败，进行重新连接
        Commons:printLog_Info("==connected_fail or closed:", res_status, type(res_status))

        if not self.isMyManual then
            if self.topRule_view_noConnectServer ~= nil and (not tolua.isnull(self.topRule_view_noConnectServer)) then
                self.topRule_view_noConnectServer:setString(Strings.gameing.noConnectServer)
                self.topRule_view_noConnectServer:setVisible(true)
            end
            self.Layer1:performWithDelay(function () 
                self:createSocket() -- 一直重连接
            end, 1.2)
        end

    -- elseif status == EnStatus.connected_close then
    --  -- 连接即将关闭，需要的话，继续进行重新连接
    --  Commons:printLog_Info("==connected_close即将:", res_status, type(res_status))

    -- elseif status == EnStatus.connected_closed then
    --  -- 连接已经关闭，需要的话，继续进行重新连接
    --  Commons:printLog_Info("==connected_closed:", res_status, type(res_status))

    elseif status == EnStatus.connected_receiveData then
        -- 有数据来拉
        Commons:printLog_Info("==connected_data 有数据来:", res_status, type(res_status))

        self.refreshRoomFlag = false
        if res_data ~= nil and res_data.status == "started" and self.isGameOver == false then
            if  res_cmd == Sockets.cmd.loginRoom or res_cmd==Sockets.cmd.refreshRoom then

                local players = res_data[Room.Bean.players]

                if players ~= nil and type(players)=="table" then
                    for k,v in pairs(players) do
                        if v[Player.Bean.me] then
                            local playStatus = v[Player.Bean.playStatus] -- 游戏状态                            

                            if playStatus == CEnum.playStatus.playing then
                                self:changeOtherPlayerHandCardsVisible("y")
                            end

                            break
                        end
                    end
                end
            end
        end

        if CEnum.status.success == res_status then

            -- 只要有成功数据，重连字样消失
            self.isMyManual = false
            if self.topRule_view_noConnectServer ~= nil and (not tolua.isnull(self.topRule_view_noConnectServer)) then
                self.topRule_view_noConnectServer:setVisible(false)
            end

            if res_cmd == Sockets.cmd.loginRoom or res_cmd==Sockets.cmd.refreshRoom -- 登录房间
                --or res_cmd == Sockets.cmd.gameing_playerLoginRoom -- 玩家上线
                --or res_cmd == Sockets.cmd.gameing_playerExitRoom -- 玩家下线
                or res_cmd == Sockets.cmd.gameing_Start  -- 游戏开始
                or res_cmd == Sockets.cmd.gameing_Prepare  -- 准备ok拉
            then

                if res_cmd == Sockets.cmd.gameing_Prepare then
                    --_handCardDataTable = nil
                    self:players_info_setViewData(res_data) -- 自己位置的界面组件 数值显示出来

                elseif  res_cmd == Sockets.cmd.loginRoom or res_cmd==Sockets.cmd.refreshRoom then
                    self.refreshRoomFlag = true
                    if self.isGameOver == true then
                        self:myViewReset_thisDesktop()
                    end
                    --如果游戏未结束
                    --if self.isGameOver == false then
                        self:refreshPengGangChiCards()
                        self:refreshOtherPengGangChiCards()
                        self:refreshPlayerChuCards()
                    --end
                    
                    --self:topRule_createView_setViewData(res_data)
                    self:top_setViewData(res_data)-- 顶部组件 数值显示出来
                    self:dcard_setViewData(res_data, res_cmd)-- 底牌
                    self:players_info_setViewData(res_data) -- 自己位置的界面组件 数值显示出来
                    --如果游戏未结束
                    --if self.isGameOver == false then
                        self:myself_handCard_createView_setViewData(res_data)-- 我手上的牌   主位置
                        self:players_handCard_setViewData(res_data)-- 每位玩家 上次吃牌动画| 已经出过的牌| 已经吃、碰过的牌| 并且庄家第一次出牌
                    --end
                    
                elseif  res_cmd == Sockets.cmd.gameing_Start then
                    if self.errorInfo_ then
                        self.errorInfo_:setString("==== ==== 游戏开了 ==== ====" )
                    end

                    VoiceDealUtil:playSound_forMJ(VoicesM.file.gameStart)
                    --self:topRule_createView_setViewData(res_data)
                    self:top_setViewData(res_data)-- 顶部组件 数值显示出来
                    self:dcard_setViewData(res_data, res_cmd)-- 底牌
                    self:players_info_setViewData(res_data) -- 自己位置的界面组件 数值显示出来
                    self:myself_handCard_createView_setViewData(res_data)-- 我手上的牌   主位置
                    self:players_handCard_setViewData(res_data)-- 每位玩家 上次吃牌动画| 已经出过的牌| 已经吃、碰过的牌| 并且庄家第一次出牌
                end
            
            elseif res_cmd == Sockets.cmd.gameing_playerLoginRoom -- 玩家上线
            then
                self:top_setViewData(res_data)-- 顶部组件 数值显示出来
                self:players_info_setViewData(res_data) -- 自己位置的界面组件 数值显示出来
                self:dcard_setViewData(res_data, res_cmd)-- 底牌
            
            elseif res_cmd == Sockets.cmd.gameing_playerExitRoom -- 玩家下线
            then
                 self:players_online_offline(res_data)

            elseif res_cmd == Sockets.cmd.gameing_playerOutRoom -- 玩家退出，游戏并没有开始过
            then
                 self:players_outRoom(res_data) 

            elseif res_cmd == Sockets.cmd.gameing_BackHaLL -- 玩家进入房间，自己点击返回大厅，需要告知服务器，是主动行为，不然离线不算
            then
                self.isMyManual = true -- 不能再重连
                self:backHome_OK()   

            elseif 
                res_cmd == Sockets.cmd.gameing_Chi  -- 吃牌
                or res_cmd == Sockets.cmd.gameing_Peng  -- 碰牌
                --or res_cmd == Sockets.cmd.gameing_Hu -- 胡牌
                or res_cmd == Sockets.cmd.gameing_ChiPengGuoHu_pai  -- 吃 碰 胡 过
                
                or res_cmd == Sockets.cmd.gameing_Mo_pai  -- 摸牌
                or res_cmd == Sockets.cmd.gameing_Chu  -- 出牌

                or res_cmd == Sockets.cmd.gameing_Wei  -- 偎牌
                or res_cmd == Sockets.cmd.gameing_ChouWei  -- 偎牌
                or res_cmd == Sockets.cmd.gameing_Ti  -- 提牌
                or res_cmd == Sockets.cmd.gameing_Ti8  -- 提牌
                or res_cmd == Sockets.cmd.gameing_Pao  -- 跑牌
                or res_cmd == Sockets.cmd.gameing_Pao8  -- 跑牌

                or res_cmd == Sockets.cmd.gameing_WeiTiPao_pai  -- 偎 提 跑  提8 跑8
            then  
                --GameingScene:top_setViewData(res_data)-- 顶部组件更新显示
                self:players_info_setViewData(res_data)-- 玩家信息更新显示  每位玩家
                self:dcard_setViewData(res_data, res_cmd)-- 底牌

                self:myself_handCard_createView_setViewData(res_data)-- 我手上的牌   主位置
                self:players_handCard_setViewData(res_data)-- 每位玩家 上次吃牌动画| 已经出过的牌| 已经吃、碰过的牌| 并且庄家第一次出牌
                
            elseif res_cmd == Sockets.cmd.dissRoom
                or res_cmd == Sockets.cmd.dissRoom_confim 
            then 
                -- 解散房间申请反馈给其他玩家  等待其他玩家确认
                -- 解散房间申请反馈给其他玩家  等待其他玩家确认
                if self.DialogView_NeedMe_ConfimDissRoom and not tolua.isnull(self.DialogView_NeedMe_ConfimDissRoom) then
                    self.DialogView_NeedMe_ConfimDissRoom:create_content(res_data)
                else
                    self.DialogView_NeedMe_ConfimDissRoom = CDAlertDissRoom.new(res_data):addTo(self.Layer1, CEnum.ZOrder.common_dialog)
                end

            elseif res_cmd == Sockets.cmd.dissRoom_success then -- 解散房间成功反馈给所有  等待其他玩家退出游戏处理
                if res_data ~= nil then
                    local success = res_data.success
                    local descript = RequestBase:getStrDecode(res_data.descript)
                    if success then -- 大家都同意
                        self.isMyManual = true -- 不能再重连
                        self:dissRoomDialogExit()
                        CDialog.new():popDialogBox(self.Layer1, nil, descript, function( ... ) self:dissRoom_success_OK() end, nil)
                    else 
                        -- 有人拒绝
                        self:dissRoomDialogExit()
                        CDialog.new():popDialogBox(self.Layer1, nil, descript, function( ... ) self:dissRoom_success_NO() end, nil)
                    end
                end

            --发生ip检测2011 同时具有定位详细信息
            elseif res_cmd == Sockets.cmd.gameing_IP_check then
                self:players_gprs_setViewData(res_data)
                
            elseif res_cmd == Sockets.cmd.gameing_Over then -- 游戏结束 
                self:dissRoomDialogExit()

                -- 还是要更新底牌的
                self:dcard_setViewData(res_data, res_cmd)-- 底牌
                self:players_diCard_refreshViewData(res_data)-- 底牌明牌显示
                
                self:huCard_createView_setViewData(res_data) -- 胡牌  也是有效果的  --todo效果还需要完善
                self.isGameOver = true

            elseif res_cmd == Sockets.cmd.gameing_SendEmoji then -- 表情来了
                self:emoji_createView_setViewData(res_data)
            elseif res_cmd == Sockets.cmd.gameing_SuperEmoji then -- 超级表情来了
                self:superEmojoDataHandler(res_data)

            elseif res_cmd == Sockets.cmd.gameing_SendVoice then -- 录音来了
                -- 只有开关是打开的，才允许语音自动播放
                -- local _currStopVoice = GameState_VoiceSetting:getDataSingle(CEnum.voiceSetting.currStopVoice)
                -- if _currStopVoice ~= nil and CEnum.musicStatus.on == _currStopVoice then
                    self:voice_createView_setViewData(res_data)
                -- end

            elseif res_cmd == Sockets.cmd.gameing_SendWords then -- 短语来了
                self:words_createView_setViewData(res_data)

            elseif res_cmd == Sockets.cmd.gameing_Xintiao_down then -- 心跳下行来拉
                local systime = res_data["systime"]
                --Commons:printLog_Info("----心跳时间：", systime)
                if systime ~= nil then
                    SocketRequestGameing:gameing_Xintiao_up(systime)
                end
            elseif res_cmd == Sockets.cmd.gameing_Xintiao_send then -- 心跳下行来拉
                self.isConnected_sockk_nums = 1
            elseif res_cmd == Sockets.cmd.gameing_ExitSocket then -- 有多处重连socket告诉上一处自动退出和关闭socket
                self.isMyManual = true -- 不能再重连
                self:backHome_OK()
            end
            -- status = 0
        else
            -- status ~= 0
            --Commons:printLog_Info("异常情况来拉")
            if res_cmd == Sockets.cmd.dissRoom then
                CDAlertManu.new():popDialogBox(self.Layer1, res_msg, true);
            elseif res_cmd == Sockets.cmd.loginRoom or res_cmd==Sockets.cmd.refreshRoom then
                CDialog.new():popDialogBox(self.Layer1, nil, res_msg, function( ... )
                            self:dissRoom_success_OK()
                        end, nil)
            end
        end
    -- 所有接受后台socket数据

    --else -- 其他 EnStatus.connected 

    end
end

function MJRoomScene:dissRoomDialogExit()
    if self.DialogView_NeedMe_ConfimDissRoom and not tolua.isnull(self.DialogView_NeedMe_ConfimDissRoom) then
        self.DialogView_NeedMe_ConfimDissRoom:dispose()
        self.DialogView_NeedMe_ConfimDissRoom:removeFromParent()
        self.DialogView_NeedMe_ConfimDissRoom = nil
    end
end

-- 已经出过的牌  每位玩家
-- 已经吃、碰过的牌  每位玩家
-- 并且庄家，第一次出牌，，以后后面每次摸、出、吃、碰、杠牌
function MJRoomScene:players_handCard_setViewData(res_data)
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
                        --local number = math.floor(#self.curMyPGChiCards/3)
                        --生成杠，碰牌子，并动画
                        if self.refreshRoomFlag == false then
                            self:myPlayerChiGangPengScaleCard(currChiComb)
                        end
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
                            self.box_chupai:show()
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
                        --GameingMeChiCardDeal:createChiCards(nil) -- 消失可能操作过的吃牌
                        --myself_view_needOption_list:setVisible(false) -- 中间的选择消失
                        if #options == 1 and options[1] == CEnum.playOptions.guo then
                            -- Commons:printLog_Info("----我就一个过的操作，所以我过牌:", _actionNo)
                            --if _type~=nil and _type~=CEnum.options.other then
                            SocketRequestGameing:gameing_Guo(_actionNo)
                            --end

                        elseif #options == 1 and options[1] == CEnum.playOptions.peng then
                            SocketRequestGameing:gameing_Peng(_actionNo)

                        elseif #options == 1 and options[1] == CEnum.playOptions.hu then
                            SocketRequestGameing:gameing_Hu(_actionNo)

                        elseif #options == 1 and options[1] == CEnum.playOptions.wei then
                            SocketRequestGameing:gameing_Wei(_actionNo)
                        elseif #options == 1 and options[1] == CEnum.playOptions.chouwei then
                            SocketRequestGameing:gameing_ChouWei(_actionNo)

                        elseif #options == 1 and options[1] == CEnum.playOptions.ti then
                            SocketRequestGameing:gameing_Ti(_actionNo)
                        elseif #options == 1 and options[1] == CEnum.playOptions.ti8 then
                            SocketRequestGameing:gameing_Ti8(_actionNo)

                        elseif #options == 1 and options[1] == CEnum.playOptions.pao then
                            SocketRequestGameing:gameing_Pao(_actionNo)
                        elseif #options == 1 and options[1] == CEnum.playOptions.pao8 then
                            SocketRequestGameing:gameing_Pao8(_actionNo)

                        elseif #options == 1 and options[1] == CEnum.playOptions.wc then
                            SocketRequestGameing:gameing_Wc(_actionNo)
                        elseif #options == 1 and options[1] == CEnum.playOptions.wd then
                            SocketRequestGameing:gameing_Wd(_actionNo)

                        elseif #options == 1 and options[1] == CEnum.playOptions.twc then
                            SocketRequestGameing:gameing_TWc(_actionNo)
                        elseif #options == 1 and options[1] == CEnum.playOptions.twd then
                            SocketRequestGameing:gameing_TWd(_actionNo)

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
                            self.myself_view_needOption_list:removeAllItems();
                            for kk,vv in pairs(show_options) do
        
                                local item = self.myself_view_needOption_list:newItem()
                                item:setName(vv)
                                local img_vv = GameMaJiangUtil:getImgByOptionMid(vv)
                                local img_vv_press = GameMaJiangUtil:getImgByOptionMid_press(vv)
                                local content = cc.ui.UIPushButton.new(img_vv, {scale9 = false})
                                    -- :setButtonSize(132, 132)
                                    :align(display.CENTER, 0 , 0)
                                    :setButtonImage(EnStatus.pressed, img_vv_press)
                                    :onButtonClicked(function(event)

                                        VoiceDealUtil:playSound_forMJ(Voices.file.ui_click)

                                        local optName = item:getName();
                                        Commons:printLog_Info("------吃 碰 胡 过的ListView buttonclicked：",optName)

                                        if optName == CEnum.playOptions.guo then
                                            self.myself_view_needOption_list:setVisible(false)
                                        else
                                            if optName ~= CEnum.status.def_fill 
                                                and (gangDemos ~= nil and #gangDemos <= 1) 
                                                and gangDemos == nil then
                                                self.myself_view_needOption_list:setVisible(false) -- 中间的选择消失
                                            end
                                        end

                                        if optName == CEnum.playOptions.chi then -- 当前吃的方案
                                                                    

                                        elseif optName == CEnum.playOptions.peng then
                                            
                                                -- 服务器就会告知 一旦这个操作完的下一轮数据
                                                if isMayHuPai then
                                                    local function option_giveup_OK()
                                                        --VoiceDealUtil:playSound_forMJ(VoicesM.file.peng)
                                                        SocketRequestGameing:gameing_Peng(_actionNo)--cardno)
                                                        self.isMyHu = false
                                                        -- 测试环境，模拟服务器发送信息
                                                        if CEnum.Environment.Current == CEnum.EnvirType.Test then
                                                            local resData = MJSocketResponseDataTest.new():res_gameing_Peng();
                                                            CVar._static.mSocket:tcpReceiveData(resData);
                                                        end
                                                    end
                                                    local function option_giveup_NO()
                                                        self.myself_view_needOption_list:setVisible(true) -- 中间的选择又出现
                                                    end
                                                    CDialog.new():popDialogBox(self.Layer1, nil, Strings.gameing.giveup_hu, option_giveup_OK, option_giveup_NO)
                                                else
                                                    --VoiceDealUtil:playSound_forMJ(VoicesM.file.peng)
                                                    SocketRequestGameing:gameing_Peng(_actionNo)--cardno)
                                                    -- 测试环境，模拟服务器发送信息
                                                    if CEnum.Environment.Current == CEnum.EnvirType.Test then
                                                        local resData = MJSocketResponseDataTest.new():res_gameing_Peng();
                                                        CVar._static.mSocket:tcpReceiveData(resData);
                                                    end
                                                end
                                            --end
                                             
                                        elseif optName == CEnum.playOptions.gang then
                                            if gangDemos ~= nil and #gangDemos > 1 then
                                                self:showGangDemos(isMayHuPai, gangDemos, _actionNo, optName)
                                            else
                                                -- 服务器就会告知 一旦这个操作完的下一轮数据
                                                if isMayHuPai then
                                                    local function option_giveup_OK()
                                                        --VoiceDealUtil:playSound_forMJ(VoicesM.file.gang)
                                                        MJSocketGameing:gameing_Gang(_actionNo, gangDemos[1].id)--cardno)
                                                        self.isMyHu = false
                                                        -- 测试环境，模拟服务器发送信息
                                                        if CEnum.Environment.Current == CEnum.EnvirType.Test then
                                                            local resData = MJSocketResponseDataTest.new():res_gameing_Gang();
                                                            CVar._static.mSocket:tcpReceiveData(resData);
                                                        end
                                                    end
                                                    local function option_giveup_NO()
                                                        self.myself_view_needOption_list:setVisible(true) -- 中间的选择又出现
                                                    end
                                                    CDialog.new():popDialogBox(self.Layer1, nil, Strings.gameing.giveup_hu, option_giveup_OK, option_giveup_NO)
                                                else
                                                    --VoiceDealUtil:playSound_forMJ(VoicesM.file.gang)
                                                    MJSocketGameing:gameing_Gang(_actionNo, gangDemos[1].id)--cardno)
                                                    -- 测试环境，模拟服务器发送信息
                                                    if CEnum.Environment.Current == CEnum.EnvirType.Test then
                                                        local resData = MJSocketResponseDataTest.new():res_gameing_Gang();
                                                        CVar._static.mSocket:tcpReceiveData(resData);
                                                    end
                                                end
                                            end
                                             
                                        elseif optName == CEnum.playOptions.hu then
                                            -- 服务器就会告知 一旦这个操作完的下一轮数据
                                            SocketRequestGameing:gameing_Hu(_actionNo)--cardno)
                                            -- 测试环境，模拟服务器发送信息  靠回合结束信息来显示界面
                                            self.myself_view_needOption_list:setVisible(false)

                                        elseif optName == CEnum.playOptions.wc then
                                            -- 服务器就会告知 一旦这个操作完的下一轮数据
                                            SocketRequestGameing:gameing_Wc(_actionNo)--cardno)
                                            -- 测试环境，模拟服务器发送信息  靠回合结束信息来显示界面

                                        elseif optName == CEnum.playOptions.wd then
                                            -- 服务器就会告知 一旦这个操作完的下一轮数据
                                            SocketRequestGameing:gameing_Wd(_actionNo)--cardno)
                                            -- 测试环境，模拟服务器发送信息  靠回合结束信息来显示界面

                                        elseif optName == CEnum.playOptions.twc then
                                            -- 服务器就会告知 一旦这个操作完的下一轮数据
                                            SocketRequestGameing:gameing_TWc(_actionNo)--cardno)
                                            -- 测试环境，模拟服务器发送信息  靠回合结束信息来显示界面

                                        elseif optName == CEnum.playOptions.twd then
                                            -- 服务器就会告知 一旦这个操作完的下一轮数据
                                            SocketRequestGameing:gameing_TWd(_actionNo)--cardno)
                                            -- 测试环境，模拟服务器发送信息  靠回合结束信息来显示界面

                                        elseif optName == CEnum.playOptions.guo then
                                            --VoiceDealUtil:playSound_forMJ(Voices.file.ui_click)
                                            if isMayHuPai then
                                                local function option_giveup_OK()
                                                    self.isMyHu = false
                                                    if _type~=nil and (_type == CEnum.options.other
                                                            or _type == CEnum.options.other3
                                                            or _type == CEnum.options.chu or _type == CEnum.options.mo) then
                                                        SocketRequestGameing:gameing_Guo(_actionNo)
                                                    else
                                                        self.myself_view_needOption_list:setVisible(false)
                                                        -- =other 此时：既不是摸牌，也不是出牌，，可能是第一下 直接就是提牌或者偎牌，那这个时候，需要走过牌这个上行动作，直接根据谁出牌，就谁可以拖拽牌打出去
                                                        
                                                        -- if isMeChu then
                                                        --     -- 可以出牌，不告知过
                                                        -- else
                                                        --     -- 不可以出牌，告知过
                                                        --     SocketRequestGameing:gameing_Guo(_actionNo)
                                                        -- end
                                                    end

                                                    -- 一旦操作 “过” 字，又需要提示出牌拉
                                                    if self.box_chupai~= nil and self.isMeChu then
                                                        -- 不是我出牌，隐藏出牌区域
                                                        self.box_chupai:setVisible(true)
                                                    end

                                                    self.gangDemosListBg:hide()
                                                end
                                                local function option_giveup_NO()
                                                    self.myself_view_needOption_list:setVisible(true) -- 中间的选择又出现
                                                end
                                                CDialog.new():popDialogBox(self.Layer1, nil, Strings.gameing.giveup_hu, option_giveup_OK, option_giveup_NO)
                                            else
                                                if _type~=nil and (_type == CEnum.options.other 
                                                            or _type == CEnum.options.chu or _type == CEnum.options.mo) then
                                                    SocketRequestGameing:gameing_Guo(_actionNo)
                                                else
                                                    self.myself_view_needOption_list:setVisible(false)
                                                    -- =other 此时：既不是摸牌，也不是出牌，，可能是第一下 直接就是提牌或者偎牌，那这个时候，需要走过牌这个上行动作，直接根据谁出牌，就谁可以拖拽牌打出去
                                                    
                                                    -- if isMeChu then
                                                    --     -- 可以出牌，不告知过
                                                    -- else
                                                    --     -- 不可以出牌，告知过
                                                    --     SocketRequestGameing:gameing_Guo(_actionNo)
                                                    -- end
                                                end

                                                -- 一旦操作 “过” 字，又需要提示出牌拉
                                                if self.box_chupai~= nil and self.isMeChu then
                                                    -- 不是我出牌，隐藏出牌区域
                                                    self.box_chupai:setVisible(true)
                                                end

                                                self.gangDemosListBg:hide()
                                            end

                                        end

                                    end)

                                
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
                        if self.refreshRoomFlag == false then
                            if actionObj.type == CEnum.options.mo then
                                self:otherPlayerMoHandCard(_seat,tostring(actionObj.card.id))
                            elseif actionObj.type == CEnum.options.chu then
                                self:otherPlayerChuCardScaleCard(_seat,tostring(actionObj.card.id))
                            end
                        else
                            if actionObj.type == CEnum.options.mo then
                                self:otherPlayerMoHandCard(_seat,tostring(actionObj.card.id))
                            end
                        end
                    end

                    local chiCombs = v[Player.Bean.chiCombs]
                    local currChiComb = v[Player.Bean.currChiComb] --当前吃，碰，杠对象

                    if currChiComb ~= nil then
                        --local number = math.floor(#self.otherPGCHiCards[_seat]/3)
                        --生成杠，碰牌子，并动画
                        if self.refreshRoomFlag == false then
                            self:otherPlayerCPGHScaleCard(_seat, currChiComb)
                        end
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
function MJRoomScene:players_diCard_refreshViewData(res_data)
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
                    local separate = v[Player.Bean.separate]
                    
                    local clientSeatNo = GameMaJiangUtil:confimSeatNo(self.mySeatNo, seatNo)

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

                            local moveOffset = 0
                            if separate ~= nil and separate and i == #handCards and i ~= 1 then
                                moveOffset = 15
                            end

                            local posX = display.left+185*self.handCardScaleFact
                            local posY = display.bottom+630*self.handCardScaleFact-10-offsetDis-32*self.handCardScaleFact*numX-moveOffset
                            if clientSeatNo == CEnumM.seatNo.R then
                                posX = display.right-185*self.handCardScaleFact
                                posY = display.bottom+160*self.handCardScaleFact+10+offsetDis+32*self.handCardScaleFact*numX+moveOffset
                            elseif clientSeatNo == CEnumM.seatNo.M then
                                posX = display.right-400*self.handCardScaleFact-10-offsetDis-33*self.handCardScaleFact*numX-moveOffset
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
                                tempCard:setLocalZOrder(20-i)
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

-- function MJRoomScene:huCard_createView_setViewData(res_data)
--     self:createZhongMaNode(res_data)
-- end

--创建中码节点
function MJRoomScene:huCard_createView_setViewData(res_data)
    TimerM:killAll()
    if self.curProgressCircle ~= nil then
        self.curProgressCircle:hide()
    end

    if self.curSelHeader ~= nil then
        self.curSelHeader:hide()
    end

    local rewardCardsList = res_data[Room.Bean.rewardCards] 
    
    local isHuangJi = true -- 是否荒局
    local huType = nil
    local roundRecords = res_data[Room.Bean.roundRecord]

    if roundRecords ~= nil and type(roundRecords)=="table" then
        if self.errorInfo_ then
            self.errorInfo_:setString("==== ==== 回合结束 ==== ====" )
        end

        --  先找出是不是有人胡牌了
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

                -- 胡 字的显示
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

                -- 奖 字的显示
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
                    :align(display.CENTER, display.cx, display.cy-100)
                    :hide()
    local sequence = transition.sequence({
        cc.ScaleTo:create(0.3, 1),
        cc.DelayTime:create(delayTime),
        cc.CallFunc:create(
            function()   
                    tempSprite:hide()                 
                    local rewardCards = res_data[Room.Bean.rewardCards]  -- 奖码牌
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
                        -- 房间结束
                        self.isMyManual = true -- 不能再重连
                        -- 同时关闭 socket
                        if CVar._static.mSocket ~= nil then
                            CVar._static.mSocket:CloseSocket()
                        end
                        CVar._static.roomStatus = ""
                    end

                    if Commons:checkIsNull_tableList(roundRecord) then
                        self.myself_view_needOption_list:setVisible(false) -- 中间的选择消失
                        
                        self.lookDiCardBtn:show()

                        --回合结算
                        PlayerRoundRecordDialog.new()
                            :addTo(self.Layer1, CEnum.ZOrder.common_dialog)
                            :setName("PlayerRoundRecordDialog")
                            :popDialogBox(res_data, nil, nil, nil, nil, nil, CEnum.pageView.gameingOverPage, nil, nil)

                    else
                        -- 未开局，就解散了，只有roomRecord对象
                        if Commons:checkIsNull_tableList(roomRecord) then
                            CVar._static.isNeedShowPrepareBtn = false
                            PlayerRoomRecordDialog.new()
                                :addTo(self.Layer1, CEnum.ZOrder.common_dialog)
                                :setName("PlayerRoomRecordDialog")
                                :initLayer(res_data)
                        end
                    end

                end
            end
        )
        
    })
    tempSprite:runAction(sequence)
end

function MJRoomScene:onEnter()
end

function MJRoomScene:onExit()
    self:myViewReset_thisDesktop()

    self.isConnected_sockk_nums = 1
    self.isMyManual = true -- 不能再重连
    --关闭倒计时
    TimerM:killAll()

    -- 网络监听
    if self.top_scheduler ~= nil and self.top_schedulerID_network ~= nil then
        self.top_scheduler:unscheduleScriptEntry(self.top_schedulerID_network)
        self.top_schedulerID_network = nil
    end

    if self.top_scheduler ~= nil and self.top_scheduleID_voice ~= nil then
        self.top_scheduler:unscheduleScriptEntry(self.top_scheduleID_voice)
        self.top_scheduleID_voice = nil
    end

    if self.top_scheduler ~= nil and self.scheduleTimeID ~= nil then
        self.top_scheduler:unscheduleScriptEntry(self.scheduleTimeID)
        self.scheduleTimeID = nil
    end

    self.top_scheduler = nil

    CVar._static.voiceWaitDownTable = {}
    CVar._static.voiceWaitPlayTable = {}
    CVar._static.mSocket:CloseSocket(); -- socket关闭

    self.Layer1 = nil
    self.loadingSpriteAnim = nil -- 开局等待动画
    CVar._static.mSocket = nil  -- 此类中的全局变量 socket发送消息的对象

    -- -- topRule_view = nil
    -- topRule_view_noConnectServer = nil
    if self.topRule_view_noConnectServer ~= nil and (not tolua.isnull(self.topRule_view_noConnectServer)) then
        self.topRule_view_noConnectServer:removeFromParent()
        self.topRule_view_noConnectServer = nil
    end
    -- top_view_dissRoom = nil
    if self.top_view_dissRoom ~= nil and (not tolua.isnull(self.top_view_dissRoom)) then
        self.top_view_dissRoom:removeFromParent()
        self.top_view_dissRoom = nil
    end
    -- top_view_backRoom = nil
    if self.top_view_backRoom ~= nil and (not tolua.isnull(self.top_view_backRoom)) then
        self.top_view_backRoom:removeFromParent()
        self.top_view_backRoom = nil
    end

end

-- 网络发生改变，直接就关闭socket来重连了
function MJRoomScene:NetIsOK_change()
    if not self.isMyManual then
        if self.topRule_view_noConnectServer ~= nil and (not tolua.isnull(self.topRule_view_noConnectServer)) then
            self.topRule_view_noConnectServer:setString(Strings.gameing.noConnectServer)
            self.topRule_view_noConnectServer:setVisible(true)
        end
    end
        
    if CVar._static.mSocket ~= nil then
        CVar._static.mSocket:CloseSocket()
    end
end

function MJRoomScene:superEmojoDataHandler(res_data)
    if res_data ~= nil then
        local num = 1
        for k,v in pairs(res_data) do
            if num == 1 then
                AnimationManager:playSuperEmoji(self.Layer1, self.mySeatNo, tonumber(v.code), v.seatNo, v.targetSeatNo, true)
            else
                AnimationManager:playSuperEmoji(self.Layer1, self.mySeatNo, tonumber(v.code), v.seatNo, v.targetSeatNo, nil)
            end

            num = num + 1
        end
    end
end

local emoji_node_view
function MJRoomScene:emoji_createView_setViewData(res_data)
    if res_data ~= nil then
        local room = res_data--[User.Bean.room]
        local exp_code = room[Player.Bean.code]
        local currNo = room[Player.Bean.seatNo]
        
        local _seat = GameMaJiangUtil:confimSeatNo(self.mySeatNo, currNo) -- 确定相对位置：：0=本人位置，1=下一玩家，-1=上一玩家，最后一玩家
        --Commons:printLog_Info("----位置是：", _seat)

        if _seat == CEnumM.seatNo.me then
            -- 自己发送的，自己也播放，但不是这里
        else
            if self.Layer1 ~= nil then
                emoji_node_view = GameMaJiangUtil:createEmoji_Anim(self.Layer1, exp_code, _seat, emoji_node_view)
            end
        end
    end
end

-- 短语的处理
local words_node_view
function MJRoomScene:words_createView_setViewData(res_data)
    if res_data ~= nil then
        local room = res_data--[User.Bean.room]
        local words_code = room[Player.Bean.code]
        local currNo = room[Player.Bean.seatNo]

        local _seat = GameMaJiangUtil:confimSeatNo(self.mySeatNo, currNo) -- 确定相对位置：：0=本人位置，1=下一玩家，-1=上一玩家，最后一玩家

        if _seat == CEnumM.seatNo.me then
            -- 自己发送的，自己也播放，但不是这里
        else
            if self.Layer1 ~= nil then
                words_node_view = GameMaJiangUtil:createWords_Anim(self.Layer1, words_code, _seat, words_node_view)
            end
        end
    end
end


local Dictate_y_began = 0
local Dictate_y_gap = 0
function MJRoomScene:Dictate_TouchListener(event)
    if event.name == EnStatus.began or event.name == EnStatus.clicked then
        Dictate_y_began = event.y
        self:Dictate_TouchListener_Began()
        return true
    elseif event.name == EnStatus.moved then
        return true 
    elseif  event.name == EnStatus.ended then
        Commons:printLog_Info("--------------end 瞬间多少啦：：", Dictate_y_gap, self.voiceSpeakClockTime)
        if self.voiceSpeakClockTime <= 90 then
            Commons:printLog_Info("--------------end 瞬间多少啦：：去发送")
            self:Dictate_TouchListener_End()
        else
            Commons:printLog_Info("--------------end 瞬间多少啦：：时间不够")
            self:Dictate_TouchListener_Move()
        end
        return true 
    end 
end

-- 开始录音和倒计时
function MJRoomScene:Dictate_TouchListener_Began()
    VoiceDealUtil:stopBgMusic()
    GameState_VoiceSetting:setDataSingle(CEnum.voiceSetting.currStopMusic, CEnum.musicStatus.off)
    GameState_VoiceSetting:setDataSingle(CEnum.voiceSetting.currStopSounds, CEnum.musicStatus.off)

    self.voiceSpeakClockTime = CVar._static.clockVoiceTime
    self.voiceSpeakSlider:setPercentage(self.voiceSpeakClockTime)

    local function changeVoice()
        self.voiceSpeakClockTime = self.voiceSpeakClockTime - 1
        self.voiceSpeakSlider:setPercentage(self.voiceSpeakClockTime)
        if self.voiceSpeakClockTime <= 0 then
            self:Dictate_TouchListener_End()
        end
    end
    self.top_scheduleID_voice = self.top_scheduler:scheduleScriptFunc(changeVoice, 0.1, false) -- **秒一次

    self.voiceSpeakBg:setVisible(true)
    self.voiceSpeakSlider:setVisible(true)

    Commons:gotoDictate()
end

-- move之后，强行停止
function MJRoomScene:Dictate_TouchListener_Move()
    if CVar._static.currStopSounds_init ~= nil and CEnum.musicStatus.off == CVar._static.currStopSounds_init then
        GameState_VoiceSetting:setDataSingle(CEnum.voiceSetting.currStopSounds, CEnum.musicStatus.off)
    else
        GameState_VoiceSetting:setDataSingle(CEnum.voiceSetting.currStopSounds, CEnum.musicStatus.on)
    end

    -- 界面消失
    self.voiceSpeakBg:setVisible(false)
    self.voiceSpeakSlider:setVisible(false)

    -- 关闭倒计时
    if self.top_scheduler ~= nil and self.top_schedulerID_voice ~= nil then
        self.top_scheduler:unscheduleScriptEntry(self.top_scheduleID_voice)
        self.top_scheduleID_voice = nil
    end

    -- 用户自己去掉录音，需要把没有播放完的东西继续
    if Commons:checkIsNull_tableType(CVar._static.voiceWaitPlayTable) then
        for k,v in pairs(CVar._static.voiceWaitPlayTable) do
            if v ~= CEnumM.seatNo.playOver then
                Commons:printLog_Info("----voice me--队列>1中选一个 可以播放的有----",k,v)
                self:downLoadVoice_toPlay(k, v)
                break
            end
        end
    end

    Commons:gotoDictateStop()
end

-- end之后，播放上传
function MJRoomScene:Dictate_TouchListener_End()
    -- 界面消失
    self.voiceSpeakBg:setVisible(false)
    self.voiceSpeakSlider:setVisible(false)

    -- 关闭倒计时
    if self.top_scheduler ~= nil and self.top_scheduleID_voice ~= nil then
        self.top_scheduler:unscheduleScriptEntry(self.top_scheduleID_voice)
        self.top_scheduleID_voice = nil
    end

    --self.Layer1:performWithDelay(function ()
        -- 停止录音，也停止各项东西
        local function MJRoomScene_DictateStop_CallbackLua(txt)
                if Commons.osType == CEnum.osType.A then
                    -- 由于安卓机器的烂，必须线上传再播放，或者先播放在上传，只能一件一件的事情去顺序执行
                    -- 这样ios机器也同步这个做法
                    local fileNameShort = "flyvoice.wav"
                    local _seat = CEnumM.seatNo.me
                    -- 上传文件给其他人听
                    ImDealUtil:uploadVoice(function(url) self:upLoadVoiceBack_ByOrder(url, fileNameShort, _seat) end, nil)

                elseif Commons.osType == CEnum.osType.I then
                    -- 上传文件给其他人听
                    ImDealUtil:uploadVoice(function(url) self:upLoadVoiceBack(url) end, nil)
                    --同时播放自己的录音
                    self:upLoadVoice_andPlayMeVoice()                    
                end
        end
        Commons:gotoDictateStop(MJRoomScene_DictateStop_CallbackLua)
    --end, 0.005)
end

function MJRoomScene:upLoadVoiceBack(RemoteUrl)
    if Commons:checkIsNull_str(RemoteUrl) then
        SocketRequestGameing:gameing_SendVoice(RemoteUrl)
    end
end

function MJRoomScene:upLoadVoice_andPlayMeVoice()
    ---[[
    -- 去播放 自己的录音，也放在队列中去播放
    if Commons:checkIsNull_tableType(CVar._static.voiceWaitPlayTable) then
        --所有的语音播完再出音效

            local fileNameShort = "flyvoice.wav"
            local _seat = CEnumM.seatNo.me
            Commons:printLog_Info("----voice me--需要 播放信息是：", _seat, fileNameShort)
            --if status == CEnum.status.success then
                if CEnum.Environment.Current~=nil and CEnum.Environment.Current==CEnum.EnvirType.Test then
                    CVar._static.voiceWaitPlayTable[fileNameShort] = _seat
                else
                    -- 相同的东西，只是播放一遍
                    if CVar._static.voiceWaitPlayTable[fileNameShort] ~= nil and CVar._static.voiceWaitPlayTable[fileNameShort] == CEnumM.seatNo.playOver then
                    else
                        CVar._static.voiceWaitPlayTable[fileNameShort] = _seat
                    end
                end
            --end
            local _sizeTable = 0
            for k,v in pairs(CVar._static.voiceWaitPlayTable) do
                if v ~= CEnumM.seatNo.playOver then
                    _sizeTable = _sizeTable + 1
                end
            end
            Commons:printLog_Info("----voice me--有几个需要播放：", _sizeTable)

            if _sizeTable == 1 then
                Commons:printLog_Info("----voice me--确定 播放信息是：", _seat, fileNameShort)
                    self:downLoadVoice_toPlay(fileNameShort, _seat)
                
            elseif _sizeTable > 1 then
                -- 队列中挑选一个去播放
                if Commons:checkIsNull_tableType(CVar._static.voiceWaitPlayTable) then
                    for k,v in pairs(CVar._static.voiceWaitPlayTable) do
                        --Commons:printLog_Info("----voice me--队列>1中选一个 要播放的东西吗？？----",k,v)
                        if v ~= CEnumM.seatNo.playOver then
                            Commons:printLog_Info("----voice me--队列>1中选一个 可以播放的有----",k,v)
                            self:downLoadVoice_toPlay(k, v)
                            break
                        end
                    end
                end

            end
    end
    --]]
end

function MJRoomScene:upLoadVoiceBack_ByOrder(RemoteUrl, fileNameShort, _seat)
    if Commons:checkIsNull_str(RemoteUrl) then
        SocketRequestGameing:gameing_SendVoice(RemoteUrl)
    end

    ---[[
    -- 去播放 自己的录音，也放在队列中去播放
    if Commons:checkIsNull_tableType(CVar._static.voiceWaitPlayTable) then
        --所有的语音播完再出音效
            Commons:printLog_Info("----voice me--需要 播放信息是：", _seat, fileNameShort)
            
                if CEnum.Environment.Current~=nil and CEnum.Environment.Current==CEnum.EnvirType.Test then
                    CVar._static.voiceWaitPlayTable[fileNameShort] = _seat
                else
                    -- 相同的东西，只是播放一遍
                    if CVar._static.voiceWaitPlayTable[fileNameShort] ~= nil and CVar._static.voiceWaitPlayTable[fileNameShort] == CEnumM.seatNo.playOver then
                    else
                        CVar._static.voiceWaitPlayTable[fileNameShort] = _seat
                    end
                end
            
            local _sizeTable = 0
            for k,v in pairs(CVar._static.voiceWaitPlayTable) do
                if v ~= CEnumM.seatNo.playOver then
                    _sizeTable = _sizeTable + 1
                end
            end
            Commons:printLog_Info("----voice me--有几个需要播放：", _sizeTable)

            if _sizeTable == 1 then
                Commons:printLog_Info("----voice me--确定 播放信息是：", _seat, fileNameShort)
                --if status == CEnum.status.success then
                   self:downLoadVoice_toPlay(fileNameShort, _seat)
                --end
            elseif _sizeTable > 1 then
                -- 队列中挑选一个去播放
                if Commons:checkIsNull_tableType(CVar._static.voiceWaitPlayTable) then
                    for k,v in pairs(CVar._static.voiceWaitPlayTable) do
                        --Commons:printLog_Info("----voice me--队列>1中选一个 要播放的东西吗？？----",k,v)
                        if v ~= CEnumM.seatNo.playOver then
                            Commons:printLog_Info("----voice me--队列>1中选一个 可以播放的有----",k,v)
                            self:downLoadVoice_toPlay(k, v)
                            break
                        end
                    end
                end

            end
    end
    --]]
end

-- 播放录音
local voice_node_view
function MJRoomScene:downLoadVoice_toPlay(fileNameShort, _seat)
    if Commons:checkIsNull_str(fileNameShort) then

        VoiceDealUtil:stopBgMusic()
        
        GameState_VoiceSetting:setDataSingle(CEnum.voiceSetting.currStopMusic, CEnum.musicStatus.off)
        GameState_VoiceSetting:setDataSingle(CEnum.voiceSetting.currStopSounds, CEnum.musicStatus.off)

        Commons:printLog_Info("-----------到播放了", fileNameShort, _seat)
        -- 自己发送的，自己也播放
        voice_node_view = GameMaJiangUtil:createVoice_Anim(self.Layer1, _seat, voice_node_view)

        local function MJRoomScene_DictatePlay_CallbackLua_RL(txt)
            Commons:printLog_Info("-----------播放完成拉")
            
            if voice_node_view ~= nil and (not tolua.isnull(voice_node_view)) then
              voice_node_view:stopAllActions()
              voice_node_view:removeFromParent()
              voice_node_view = nil
            end
            -- 队列播放
            if Commons:checkIsNull_tableType(CVar._static.voiceWaitPlayTable) then
                CVar._static.voiceWaitPlayTable[fileNameShort] = CEnumM.seatNo.playOver
                local isHaveNeedPlay = false

                for k,v in pairs(CVar._static.voiceWaitPlayTable) do
                    --Commons:printLog_Info("----还有要播放的东西吗？？----",k,v)
                    if v ~= CEnumM.seatNo.playOver then
                        Commons:printLog_Info("----可以播放的有----",k,v)
                        isHaveNeedPlay = true
                        self:downLoadVoice_toPlay(k, v)
                        break
                    end
                end

                if not isHaveNeedPlay then
                    CVar._static.voiceWaitPlayTable = {}

                    if CVar._static.currStopSounds_init ~= nil and CEnum.musicStatus.off == CVar._static.currStopSounds_init then
                        GameState_VoiceSetting:setDataSingle(CEnum.voiceSetting.currStopSounds, CEnum.musicStatus.off)
                    else
                        GameState_VoiceSetting:setDataSingle(CEnum.voiceSetting.currStopSounds, CEnum.musicStatus.on)
                    end
                end
            end
        end
        Commons:gotoDictatePlay(MJRoomScene_DictatePlay_CallbackLua_RL, fileNameShort)
        Commons:printLog_Info("-----------平台 播放结束拉", fileNameShort, _seat)
    end
end

-- 先下载完成，再去播放
function MJRoomScene:downLoadVoiceBack(status, fileNameShort, _seat, RemoteUrl)
        -- 去播放
        
        if Commons:checkIsNull_tableType(CVar._static.voiceWaitPlayTable) then
                Commons:printLog_Info("----voice 22--需要 播放信息是：", _seat, fileNameShort)
                if status == CEnum.status.success then
                    if CEnum.Environment.Current~=nil and CEnum.Environment.Current==CEnum.EnvirType.Test then
                        CVar._static.voiceWaitPlayTable[fileNameShort] = _seat
                    else
                        -- 相同的东西，只是播放一遍
                        if CVar._static.voiceWaitPlayTable[fileNameShort] ~= nil and CVar._static.voiceWaitPlayTable[fileNameShort] == CEnumM.seatNo.playOver then
                        else
                            CVar._static.voiceWaitPlayTable[fileNameShort] = _seat
                        end
                    end
                end
                local _sizeTable = 0
                for k,v in pairs(CVar._static.voiceWaitPlayTable) do
                    if v ~= CEnumM.seatNo.playOver then
                        _sizeTable = _sizeTable + 1
                    end
                end
                Commons:printLog_Info("----voice 22--有几个需要播放：", _sizeTable)
                --dump(CVar._static.voiceWaitPlayTable)

                if _sizeTable == 1 then
                    Commons:printLog_Info("----voice 22--确定播放信息是：", _seat, fileNameShort)
                    if status == CEnum.status.success then
                        self:downLoadVoice_toPlay(fileNameShort, _seat)
                    end
                end
        end

        -- 队列下载
        if Commons:checkIsNull_tableType(CVar._static.voiceWaitDownTable) then
            CVar._static.voiceWaitDownTable[RemoteUrl] = CEnumM.seatNo.downOver
            local isHaveNeedDown = false

            for k,v in pairs(CVar._static.voiceWaitDownTable) do
                --Commons:printLog_Info("----voice 22--还有要下载的东西吗？？----",k,v)
                if v ~= CEnumM.seatNo.downOver then
                    Commons:printLog_Info("----voice 22--可以下载的有----",k,v)
                    isHaveNeedDown = true
                    ImDealUtil:downLoad(function(...) self:downLoadVoiceBack(...) end, k, v)
                    break
                end
            end

            if not isHaveNeedDown then
                CVar._static.voiceWaitDownTable = {}
            end
        end
end

function MJRoomScene:voice_createView_setViewData(res_data)
    if res_data ~= nil then
        local room = res_data--[User.Bean.room]
        local voiceUrl = room[Player.Bean.voiceUrl]
        local currNo = room[Player.Bean.seatNo]
        local _seat = GameMaJiangUtil:confimSeatNo(self.mySeatNo, currNo) -- 确定相对位置：：0=本人位置，1=下一玩家，-1=上一玩家，最后一玩家

        if Commons:checkIsNull_tableType(CVar._static.voiceWaitDownTable) then
            Commons:printLog_Info("----voice 11--当前 下载信息是：", _seat, voiceUrl)
            if CEnum.Environment.Current~=nil and CEnum.Environment.Current==CEnum.EnvirType.Test then
                CVar._static.voiceWaitDownTable[voiceUrl] = _seat
            else
                -- 相同的东西，只是播放一遍
                if CVar._static.voiceWaitDownTable[voiceUrl] ~= nil and CVar._static.voiceWaitDownTable[voiceUrl] == CEnumM.seatNo.downOver then
                else
                    CVar._static.voiceWaitDownTable[voiceUrl] = _seat
                end  
            end

            local _sizeTable = 0
            for k,v in pairs(CVar._static.voiceWaitDownTable) do
                if v ~= CEnumM.seatNo.downOver then
                    _sizeTable = _sizeTable + 1
                end
            end
            Commons:printLog_Info("----voice 11--有几个需要下载：", _sizeTable)

            if _sizeTable == 1 then
                Commons:printLog_Info("----voice 11--确定 下载信息是：", _seat, voiceUrl)
                if _seat == CEnumM.seatNo.me then
                    -- 自己发送的表情，自己不播放
                    if CEnum.Environment.Current~=nil and CEnum.Environment.Current==CEnum.EnvirType.Test then
                        ImDealUtil:downLoad(function(...) self:downLoadVoiceBack(...) end, voiceUrl, _seat)
                    end
                elseif _seat == CEnumM.seatNo.R then
                    ImDealUtil:downLoad(function(...) self:downLoadVoiceBack(...) end, voiceUrl, _seat)
                elseif _seat == CEnumM.seatNo.M then
                    ImDealUtil:downLoad(function(...) self:downLoadVoiceBack(...) end, voiceUrl, _seat)
                elseif _seat == CEnumM.seatNo.L then
                    ImDealUtil:downLoad(function(...) self:downLoadVoiceBack(...) end, voiceUrl, _seat)
                end
            elseif _sizeTable > 1 then
                -- 队列中挑选一个去下载
                if Commons:checkIsNull_tableType(CVar._static.voiceWaitDownTable) then
                    for k,v in pairs(CVar._static.voiceWaitDownTable) do
                        --Commons:printLog_Info("----voice 11--队列>1中选一个 要下载的东西吗？？----",k,v)
                        if v ~= CEnumM.seatNo.downOver then
                            Commons:printLog_Info("----voice 11--队列>1中选一个 可以下载的有----",k,v)
                            ImDealUtil:downLoad(function(...) self:downLoadVoiceBack(...) end, k, v)
                            break
                        end
                    end
                end

            end

        end
    end
end

local self_serverGprsIpCheckDialog
-- 定位按钮的显示和详细信息内容
function MJRoomScene:players_gprs_setViewData(res_data)
    if res_data ~= nil then
        local room = res_data--[User.Bean.room]

        -- 是否弹窗，是否显示gprs按钮
        local isShow = room[Room.Bean.isShow]
        local popDesc = room[Room.Bean.popDesc]
        local distanceType = room[Room.Bean.distanceType]
        -- local distanceA = room[Gprs.Bean.distanceA]

        if isShow == 'y' then
            if self.PopGprsDialog and not tolua.isnull(self.PopGprsDialog) then
                self.PopGprsDialog:removeFromParent()
            end
            if self_serverGprsIpCheckDialog and not tolua.isnull(self_serverGprsIpCheckDialog) then
                self_serverGprsIpCheckDialog:removeFromParent()
            end
            self_serverGprsIpCheckDialog = PDKServerIpCheckDialogNew.new(res_data):addTo(self.Layer1, CEnum.ZOrder.common_dialog)
        end

        if distanceType~=nil and self.top_view_gprsBtn~=nil and not tolua.isnull(self.top_view_gprsBtn) then
            if distanceType==0 then
                self.top_view_gprsBtn:setButtonImage(EnStatus.normal, Imgs.g_th_green)
                self.top_view_gprsBtn:setButtonImage(EnStatus.pressed, Imgs.g_th_green)
            elseif distanceType==1 then
                self.top_view_gprsBtn:setButtonImage(EnStatus.normal, Imgs.g_th_yellow)
                self.top_view_gprsBtn:setButtonImage(EnStatus.pressed, Imgs.g_th_yellow)
            elseif distanceType==2 then
                self.top_view_gprsBtn:setButtonImage(EnStatus.normal, Imgs.g_th_red)
                self.top_view_gprsBtn:setButtonImage(EnStatus.pressed, Imgs.g_th_red)
            end
            self.top_view_gprsBtn:show()
        else
            -- if self.top_view_gprsBtn~=nil and not tolua.isnull(self.top_view_gprsBtn) then
            --     self.top_view_gprsBtn:hide()
            -- end
        end
        -- gprs信息
        self.GprsBean = room[Room.Bean.playerDistance]
        if self.PopGprsDialog and not tolua.isnull(self.PopGprsDialog) then
            self.PopGprsDialog:removeFromParent()
            if self.playerNum == 4 then
                self.PopGprsDialog = CDAlertGprs4person:popDialogBox(self.Layer1, self.GprsBean)
            else
                self.PopGprsDialog = CDAlertGprs:popDialogBox(self.Layer1, self.GprsBean)
            end
        end
    end
end

function MJRoomScene:players_outRoom(res_data)
    if res_data ~= nil then
        local room = res_data--[User.Bean.room]
        local currNo = room[Player.Bean.seatNo]
        local _seat = GameMaJiangUtil:confimSeatNo(self.mySeatNo, currNo)
        
        if _seat == CEnumM.seatNo.me then

        else
            self.playerHeardViewList[_seat]:hide()
            self.players_havePerson = self.players_havePerson - 1
        end
    end
end

--玩家下线
function MJRoomScene:players_online_offline(res_data)
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

function MJRoomScene:sendSuperEmoji()
    MJSocketGameing:gameing_SuperEmoji(actionNo, emotionCode, targetSeatNo)
end

-- 返回大厅 确认
function MJRoomScene:backHome_OK()
    CommonsM:gotoMJHome()
end
--返回大厅，需要通知服务器可以不可以
function MJRoomScene:backHome_OK_toSendServer()
    SocketRequestGameing:gameing_BackHaLL()
end
-- 返回大厅 取消
function MJRoomScene:backHome_NO()
end

-- 本人要解散房间的弹窗确认取消事件
function MJRoomScene:dissRoomMeConfim_OK()
    SocketRequestGameing:dissRoom()
end
function MJRoomScene:dissRoomMeConfim_NO()
end

-- 大家都同意解散的提醒
function MJRoomScene:dissRoom_success_OK()
    Commons:printLog_Info("dissRoom_success OK  大家都同意解散的提醒")
    CommonsM:gotoMJHome()
end
-- 有人不同意 不解散的提醒
function MJRoomScene:dissRoom_success_NO()
    Commons:printLog_Info("dissRoom_success NO 有人不同意 不解散的提醒")
end

function MJRoomScene:myKeypad(event)
    Commons:printLog_Info("event.key：" .. event.key, "type.key:"..type(event.key))
    print("event.key="..event.key)
    if event ~= nil and event.key == "back" then
        --CAlert:new():show("提示","确定要退出游戏吗？", GameingScene_myOK, GameingScene_myNO)

    elseif event ~= nil and event.key == "77" then -- 数字 1 连接上
        local SockMsg = import("app.common.net.socket.SocketMsg");
        SockMsg:Connect(Sockets.connect.ip, Sockets.connect.port, function(...) self:resDataSocket(...) end)
        CVar._static.mSocket = SockMsg
        CVar._static.mSocket:tcpConnected()

    elseif event ~= nil and event.key == "78" then -- 数字 2 房主登录房间Z
        CVar._static.mSocket:tcpReceiveData( MJSocketResponseDataTest.new():res_loginRoom() )

    elseif event ~= nil and event.key == "79" then -- 数字 3 第2个玩家上线
        CVar._static.mSocket:tcpReceiveData( MJSocketResponseDataTest.new():res_loginRoom_playerLoginRoom_xiajia() )

    elseif event ~= nil and event.key == "80" then -- 数字 4 第3个玩家上线 也可以同时支持2个同时上线
        CVar._static.mSocket:tcpReceiveData( MJSocketResponseDataTest.new():res_loginRoom_playerLoginRoom_duijia() )
    elseif event ~= nil and event.key == "89" then -- + 第4个玩家上线 也可以同时支持2个同时上线
        CVar._static.mSocket:tcpReceiveData( MJSocketResponseDataTest.new():res_loginRoom_playerLoginRoom_lastjia() )
    elseif event ~= nil and event.key == "81" then -- 数字 5 玩家全部在线 游戏开始拉
        CVar._static.mSocket:tcpReceiveData( MJSocketResponseDataTest.new():res_gameing_Start() )

    elseif event ~= nil and event.key == "82" then -- 数字 6 自己摸牌测试
        CVar._static.mSocket:tcpReceiveData( MJSocketResponseDataTest.new():res_gameing_Mo() )
    elseif event ~= nil and event.key == "83" then -- 数字 7 自己出牌后下行
        CVar._static.mSocket:tcpReceiveData( MJSocketResponseDataTest.new():res_gameing_ChuPai() )
    elseif event ~= nil and event.key == "84" then -- 数字 8 出现，碰，杠，胡，过 options
        CVar._static.mSocket:tcpReceiveData( MJSocketResponseDataTest.new():res_gameing_PengGangHuGuoOption() )
    elseif event ~= nil and event.key == "85" then -- 数字 9 我碰牌
        CVar._static.mSocket:tcpReceiveData( MJSocketResponseDataTest.new():res_gameing_Peng() )
    elseif event ~= nil and event.key == "76" then -- 数字 0 我杠牌
        CVar._static.mSocket:tcpReceiveData( MJSocketResponseDataTest.new():res_gameing_Gang() )
    elseif event ~= nil and event.key == "73" then -- -减号 我暗杠牌
        CVar._static.mSocket:tcpReceiveData( MJSocketResponseDataTest.new():res_gameing_AnGang() )
    elseif event ~= nil and event.key == "130" then -- 字母 G 我听牌
        CVar._static.mSocket:tcpReceiveData( MJSocketResponseDataTest.new():res_gameing_Ting() )
        
    elseif event ~= nil and event.key == "26" then -- 左方向键 其他玩家出牌
        CVar._static.mSocket:tcpReceiveData( MJSocketResponseDataTest.new():res_gameing_OtherPlayerMo() )
    elseif event ~= nil and event.key == "27" then -- 右方向键 其他玩家出牌
        CVar._static.mSocket:tcpReceiveData( MJSocketResponseDataTest.new():res_gameing_OtherPlayerChu() )
    elseif event ~= nil and event.key == "28" then -- 上方向键 其他玩家碰牌
        CVar._static.mSocket:tcpReceiveData( MJSocketResponseDataTest.new():res_gameing_OtherPeng() )
    elseif event ~= nil and event.key == "29" then -- 上方向键 其他玩家碰牌
        CVar._static.mSocket:tcpReceiveData( MJSocketResponseDataTest.new():res_gameing_OtherGang() )


        
    elseif event ~= nil and event.key == "140" then -- 字母 Q 下家吃牌 动画效果显示而已
        CVar._static.mSocket:tcpReceiveData( MJSocketResponseDataTest.new():res_gameing_OtherPlayerChu2() )
        --CVar._static.mSocket:tcpReceiveData( MJSocketResponseDataTest.new():res_gameing_Chi_xiajia() )

    elseif event ~= nil and event.key == "146" then -- 字母 W 本人已经吃牌 动画效果显示而已
        CVar._static.mSocket:tcpReceiveData( MJSocketResponseDataTest.new():res_gameing_Chi_myself() )

    elseif event ~= nil and event.key == "128" then -- 字母 E 本人需要吃牌 选择吃牌方案
        CVar._static.mSocket:tcpReceiveData( MJSocketResponseDataTest.new():res_gameing_Chi_myself_needChi() )

    elseif event ~= nil and event.key == "124" then -- 字母 A 玩家 离线或者跑路
        -- CVar._static.mSocket:tcpReceiveData( SocketResponseDataTest.new():res_gameing_playerExitRoom() ) -- 游戏开始 玩家离线
        CVar._static.mSocket:tcpReceiveData( MJSocketResponseDataTest.new():res_gameing_playerOutRoom() ) -- 游戏未开始 玩家跑路

    elseif event ~= nil and event.key == "142" then -- 字母 S 解散房间申请反馈给其他玩家  等待其他玩家确认
        -- CVar._static.mSocket:tcpReceiveData( SocketResponseDataTest.new():res_dissRoom_new() )
        CVar._static.mSocket:tcpReceiveData( PDKSocketResponseDataTest:res_gameing_IP_check() )

    elseif event ~= nil and event.key == "129" then -- 字母 F 测试又有新的人同意解散的页面显示效果
        CVar._static.mSocket:tcpReceiveData( MJSocketResponseDataTest.new():res_dissRoom_new2() )

    elseif event ~= nil and event.key == "127" then -- 字母 D 大家同意散场，解散房间拉
        CVar._static.mSocket:tcpReceiveData( MJSocketResponseDataTest.new():res_dissRoom_success() )

    elseif event ~= nil and event.key == "149" then -- 字母 Z 游戏结束
        CVar._static.mSocket:tcpReceiveData( MJSocketResponseDataTest.new():res_gameing_Over() )


    elseif event ~= nil and event.key == "147" then -- 字母 X 下一玩家发出的 表情
        -- CVar._static.mSocket:tcpReceiveData( SocketResponseDataTest.new():res_gameing_SendEmoji("sj",2) )
        -- CVar._static.mSocket:tcpReceiveData( SocketResponseDataTest:res_gameing_SendWords("s01",2) )
        CVar._static.mSocket:tcpReceiveData( MJSocketResponseDataTest.new():res_gameing_SendSuperEmoji("2", 1, 3) )
        -- CVar._static.mSocket:tcpReceiveData( "" )
    elseif event ~= nil and event.key == "126" then -- 字母 C 最后一个玩家发出的 表情
        CVar._static.mSocket:tcpReceiveData( SocketResponseDataTest.new():res_gameing_SendEmoji("sj",3) )
        -- CVar._static.mSocket:tcpReceiveData( SocketResponseDataTest:res_gameing_SendWords("s01",3) )
    elseif event ~= nil and event.key == "145" then -- 字母 V 假设scoket连接失败
        -- CVar._static.mSocket:tcpClosed()
        CVar._static.mSocket:tcpReceiveData( SocketResponseDataTest.new():res_gameing_SendEmoji("sj",4) )
        -- CVar._static.mSocket:tcpReceiveData( SocketResponseDataTest:res_gameing_SendWords("s01",4) )


    elseif event ~= nil and event.key == "137" then -- 字母 N 本人 录音
        CVar._static.mSocket:tcpReceiveData( SocketResponseDataTest.new():res_gameing_SendVoice(nil,1) )
    elseif event ~= nil and event.key == "136" then -- 字母 M R 下家 录音
        CVar._static.mSocket:tcpReceiveData( SocketResponseDataTest.new():res_gameing_SendVoice(nil,2) )
    elseif event ~= nil and event.key == "72" then -- 符号 逗号 M 对家 录音
        CVar._static.mSocket:tcpReceiveData( SocketResponseDataTest.new():res_gameing_SendVoice(nil,3) )
    elseif event ~= nil and event.key == "74" then -- 符号 句号 L 最后一家 录音
        CVar._static.mSocket:tcpReceiveData( SocketResponseDataTest.new():res_gameing_SendVoice(nil,4) )

    elseif event ~= nil and event.key == "132" then -- 字母 i

    
    elseif event ~= nil and event.key == "125" then -- 字母 B 假设scoket连接又好拉
        CVar._static.mSocket:tcpConnected()
    elseif event ~= nil and event.key == "139" then -- 字母 P 准备
        CVar._static.mSocket:tcpReceiveData( MJSocketResponseDataTest.new():res_gameing_Prepare() )
    end
    
end

return MJRoomScene