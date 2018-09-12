--
-- Author: lte
-- Date: 2016-10-23 14:39:28
--


local GameingScene = class("GameingScene", function()
    return display.newScene("GameingScene")
end)

--local socketCCC = require("socket")


local osWidth = Commons.osWidth
local osHeight = Commons.osHeight

-- local user_roomNo

local user_icon
local user_nickname
local user_account
local user_ip
local user_rights -- 用户是否拥有房卡


local Layer1
local loadingSpriteAnim -- 开局等待动画

-- 顶部
local top_scheduler
local top_schedulerID
local top_schedulerID_network
local top_schedulerID_network_status = nil
local top_schedulerID_voice
local top_view
local top_view_roomNo
local top_view_ju

-- 本人
local myself_view
local myself_view_nickname
local myself_view_icon
local myself_view_score
local myself_view_xi
local myself_view_isBanker
local myself_view_timer
--local myself_view_isPrepareOK
local myself_view_btn_Prepare

local myself_view_chuguo_list -- 出过的牌集合
local myself_view_chiguo_list -- 吃过、碰过等等的牌集合

local myself_view_mo_chu_pai_bg
local myself_view_mo_chu_pai

local myself_view_needOption_list -- 吃、碰、过、胡才有的选择

local myself_view_emoji
local myself_view_xxg
--local myself_xxg = nil

local myself_view_invite

local myself_invite_title = ""
local myself_invite_content = ""

-- 相对本人 的下一玩家
local user_icon_xiajia
local user_nickname_xiajia
--local user_nickname_xiajia_change
local user_account_xiajia
local user_ip_xiajia

local xiajia_view
local xiajia_view_nickname
local xiajia_view_offline
local xiajia_view_icon
local xiajia_view_score
local xiajia_view_xi
local xiajia_view_isBanker
local xiajia_view_timer
--local xiajia_view_isPrepareOK
local xiajia_view_btn_Prepare

local xiajia_view_chuguo_list -- 出过的牌集合
local xiajia_view_chiguo_list -- 吃过、碰过等等的牌集合

local xiajia_view_mo_chu_pai_bg
local xiajia_view_mo_chu_pai

local xiajia_view_emoji
local xiajia_view_xxg
--local xiajia_xxg = nil

-- 相对本人 的上一玩家，也是最后一玩家
local user_icon_lastjia
local user_nickname_lastjia
--local user_nickname_lastjia_change
local user_account_lastjia
local user_ip_lastjia

local lastjia_view
local lastjia_view_nickname
local lastjia_view_offline
local lastjia_view_icon
local lastjia_view_score
local lastjia_view_xi
local lastjia_view_isBanker
local lastjia_view_timer
--local lastjia_view_isPrepareOK
local lastjia_view_btn_Prepare

local lastjia_view_chuguo_list -- 出过的牌集合
local lastjia_view_chiguo_list -- 吃过、碰过等等的牌集合

local lastjia_view_mo_chu_pai_bg
local lastjia_view_mo_chu_pai

local lastjia_view_emoji
local lastjia_view_xxg
--local lastjia_xxg = nil

-- 底牌
local dcard_view
local dcard_view_nums
local view_diCards_list

-- 出牌区域
local box_chupai = nil
local chu_tipimg = nil
--local chu_anim = nil
local bg_view = nil
local sc_view = nil

-- 下家手牌
local bg_view_R = nil
local sc_view_R = nil
-- 上家手牌
local bg_view_L = nil
local sc_view_L = nil


-- 拖拽对象
local boxSize = CVar._static.boxSize -- 层的大小
--local objSize = CVar._static.objSize -- 牌的大小
local t_data = nil -- 层的数组
local t_drag = nil -- 可拖拽的对象
local _handCardDataTable = nil -- 手上的牌集合

-- 是不是我出牌
local isMeChu = false

-- 倒计时
local chu_seatNo = CEnum.seatNo.init
--local time_scheduler
local run_logic_id
--时 分 秒 数值  
local hour = 0  
local minute = 0  
local second = CVar._static.clockWiseTime

--表情
local mySeatNo -- 记录我的位置编号
local currMySeatNo
local currRSeatNo
local currLSeatNo

-- 胡牌效果
local mtView
local ruleView 
local fanCardView
local huCard_tipimg_node

local isConnected_sockk_nums = 1
local isMyManual = false -- 是不是我手动关闭socket，是手动关闭，就不需要重连，否则就是可以重连
local isConnected_sockk_time -- 和服务器可以连接的时间点记录

local DialogView_NeedMe_ConfimDissRoom -- 解散弹窗

-- local topRule_view
local topRule_view_noConnectServer
local top_view_dissRoom
local top_view_backRoom


local card_w_out_A = 48 -- 出过的拍
local card_h_out_A = 48
local card_line_out_A = 3 -- 3行
local card_cc_out_A = 5 -- 5列

local players_havePerson = 0 -- 有几个玩家

local card_hu_w = 34 -- 牌局结束之后的底牌
local card_hu_h = 34


--local test_key_i_voice = 1
local voiceSpeakBg -- 说话框的背景
local voiceSpeakImg -- 说话框的话筒
local voiceSpeakSlider -- 说话框的倒计时进度条
local voiceSpeakClockTime = CVar._static.clockVoiceTime -- 说话框的倒计时 总时间
--local voiceSpeakClickLayer -- 说话按钮背景层
local voiceSpeakClickBtn -- 说话按钮

local view_node_voice -- 录音按钮
local view_node_voice_bg -- 录音背景

local currStopSounds_init = nil -- 记录当前声音是开，还是关
local currStopMusic_init = nil -- 记录当前声音是开，还是关

local isNeedAnim_HandCard = false -- 是否需要翻牌动画，只有第一次发牌需要

local myLz_bg = nil -- 逗溜子才有的
local myLz_label = nil

local GprsBean = nil
local PopGprsDialog


-- function GameingScene:myOK()
--     os.exit()
-- end
-- function GameingScene:myNO()
-- end

-- 返回大厅 确认
function GameingScene:backHome_OK()
    Commons:gotoHome()
end
--返回大厅，需要通知服务器可以不可以
function GameingScene:backHome_OK_toSendServer()
    SocketRequestGameing:gameing_BackHaLL()
end
-- 返回大厅 取消
function GameingScene:backHome_NO()
end

-- 本人要解散房间的弹窗确认取消事件
function GameingScene:dissRoomMeConfim_OK()
    SocketRequestGameing:dissRoom()
end
function GameingScene:dissRoomMeConfim_NO()
end

-- 大家都同意解散的提醒
function GameingScene:dissRoom_success_OK()
    Commons:printLog_Info("dissRoom_success OK  大家都同意解散的提醒")
    Commons:gotoHome()
end
-- 有人不同意 不解散的提醒
function GameingScene:dissRoom_success_NO()
    Commons:printLog_Info("dissRoom_success NO 有人不同意 不解散的提醒")
end


-- 构造函数
function GameingScene:ctor()

	Commons:printLog_Info("==GameingScene 屏幕宽", osWidth, "屏幕高", osHeight);

    -- 预加载这些动画plist文件
    display.addSpriteFrames(Imgs.voiceplay_plist, Imgs.voiceplay_png) -- 语音播放动画
    display.addSpriteFrames(Imgs.biaoqing_expContent.."exp"..Imgs.file_imgPlist_suff, Imgs.biaoqing_expContent.."exp"..Imgs.file_img_suff) -- 表情

    display.addSpriteFrames(ImgsM.superEmoji_plist, ImgsM.superEmoji_texture) -- 超级表情

    isNeedAnim_HandCard = false -- 是否需要翻牌动画，只有第一次发牌需要
    isMyManual = false
    CVar._static.isNeedShowPrepareBtn = true -- 是否需要显示准备按钮，默认是显示 
    CVar._static.isComeingData = 0

    if CVar._static.isIphone4 then
        CVar._static.boxSize = cc.size(CVar._static.sCardWH-15, CVar._static.sCardWH-15)
        CVar._static.objSize = cc.size(CVar._static.sCardWH-15, CVar._static.sCardWH+CVar._static.objAddHeight-15)
        boxSize = CVar._static.boxSize
    elseif CVar._static.isIpad then
        CVar._static.boxSize = cc.size(CVar._static.sCardWH-25, CVar._static.sCardWH-25)
        CVar._static.objSize = cc.size(CVar._static.sCardWH-25, CVar._static.sCardWH+CVar._static.objAddHeight-25)
        boxSize = CVar._static.boxSize
    elseif CVar._static.NavBarH_Android ~= CEnum.status.NavBarH_def then
        local moveCard = CVar._static.NavBarH_Android*0.1
        moveCard = moveCard-moveCard%1

        CVar._static.boxSize = cc.size(CVar._static.sCardWH-moveCard, CVar._static.sCardWH-moveCard)
        CVar._static.objSize = cc.size(CVar._static.sCardWH-moveCard, CVar._static.sCardWH+CVar._static.objAddHeight-moveCard)
        boxSize = CVar._static.boxSize
    end

	-- 我的信息
	local user = GameStateUserInfo:getData()
    user_icon = RequestBase:getStrDecode(user[User.Bean.icon])
    user_nickname = Commons:trim(RequestBase:getStrDecode(user[User.Bean.nickname]) )
    user_account = user[User.Bean.account]
    user_ip = user[User.Bean.ip]
    user_rights = user[User.Bean.rights]
    Commons:printLog_Info("icon：",user_icon)
    Commons:printLog_Info("nickname:",user_nickname)
    Commons:printLog_Info("account:",user_account)
    Commons:printLog_Info("ip:",user_ip)

	-- 我的游戏房间信息
	-- local userGameing = GameStateUserGameing:getData()
    -- user_roomNo = userGameing[Room.Bean.roomNo]
	-- Commons:printLog_Info("房间号：", user_roomNo, userGameing[Room.Bean.status])

	-- 层
	Layer1 = display.newLayer() -- display.newColorLayer(Colors.layer_bg)
	--local Layer1 = display.newScale9Sprite(Imgs.gameing_bg, 0, 0, cc.size(osWidth, osHeight))
    	--:center()
    	:pos(0, 0)
    	--:align(display.CENTER, display.cx, display.cy)
    	:addTo(self)

    if CEnum.Environment.Current~=nil and CEnum.Environment.Current==CEnum.EnvirType.Test then
    	-- 响应键盘事件
        Layer1:setKeypadEnabled(true)
        Layer1:addNodeEventListener(cc.KEYPAD_EVENT, handler(self,self.myKeypad))
        GameingScene:testNodeClick()
    end

	-- 整个底色背景
	display.newSprite(Imgs.gameing_bg)
		:center()
    	:addTo(Layer1)

	-- 加载中的动画显示，搞一个精灵动画即可
    GameingScene:createLoading(Layer1)
    
	-- 然后去建立socket连接，一旦成功，获取到相应数据，再进行页面展示
    if CEnum.Environment.Current~=nil and CEnum.Environment.Current==CEnum.EnvirType.Http then
        GameingScene:createSocket()
    end
end

-- 加载中的动画显示，搞一个精灵动画即可
function GameingScene:createLoading(Layer1)
	-- 节点
	-- local loading_node = cc.NodeGrid:create()
	-- 	:addTo(Layer1)
	-- 	--:center()
	-- 	:align(display.CENTER, 0, 0)

	-- 相对节点的位置
	-- cc.ui.UIImage.new(Imgs.c_loading, {scale9=false})
	-- 	:addTo(loading_node)
	-- 	:align(display.CENTER, display.cx, display.cy)

	-- 动画
	--loading_node:runAction(cc.Shaky3D:create(3,cc.size(50,50),5,true)) -- 抖动
	--[[
	-- RotateBy，持续时间为2秒，旋转360度
  	local actionBy = cc.RotateBy:create(2, 360)
  	local actionByBack = actionBy:reverse() -- 相反操作
  	loading_node:runAction(cc.Sequence:create(actionBy, actionByBack))
  	--]]


	--[[
	--建立一个Cache来加载解压出的图片
	local frameCache = CCSpriteFrameCache:create()
	frameCache:addSpriteFrameWithFile(Imgs.c_loading_plist, Imgs.c_loading_png)
	local frameArr = CCArray:createWithCapacity(4)
	--建立一个数组来粗放得到的帧
	for j=1,4 do
		local framePath = string.format("c_loading%d.png",j)
		--将每个帧图片转换成帧Frame
		local frame = frameCache:spriteFrameByName(framePath)
		frameArr.addObject(frame)
	end
	--array 中已经有了Frame了，下来需要将其生成为Animation对象
	local animation = CCAnimation:createWithSpriteFrames(frameArr)
	--有了animation后下来要将其变为可执行的Action
	local action = CCSequence:createWithTwoActions(CCAnimate:create(animation),CCCallFunc:create(function() callBack end))
	--有了Action下来需要在屏幕上播放它，因此需要一个载体来给它提供一个块屏幕上的位置来播放，我们这里就用一个空白的Sprite来搞定
	local animSprite = CreateBlankCCSprite()
	animSprirte:setPosition(x,y)
	--一切就绪，开始播放，因为播放的是一个Sequence动画所以，会先播放第一个完成后会执行回调函数
	animSprite:runAction(action)
	--上述的action为一个动画组合，它会顺序执行执行完动画后会去执行回调函数
	--]]
    
    --[[
    display.addSpriteFrames(Imgs.c_loading_plist, Imgs.c_loading_png)
	loadingSpriteAnim = display.newSprite("#c_loading01.png")
		:align(display.CENTER, display.cx, display.cy)
		:addTo(Layer1)
	local frames = display.newFrames("c_loading%02d.png",1,4)
	local animation = display.newAnimation(frames, 1.0/2)
	--animation:setDelayPerUnit(0.15) -- 设置两个帧播放时
	--animation:setRestoreOriginalFrame(true) -- 动画执行后还原初始状态
	--display.setAnimationCache("stars", animation)
	--animation = display.getAnimationCache("stars")
	--display.removeAnimationCache("stars")
	--loadingSpriteAnim:playAnimationOnce(animation, false, function()
	--	Commons:printLog_Info("complete")
	--end, 2)
	loadingSpriteAnim:playAnimationForever(animation)
	--loadingSpriteAnim:stopAllActions()
	--]]

    loadingSpriteAnim = display.newSprite(Imgs.c_juhua):addTo(Layer1)
    loadingSpriteAnim:runAction(cc.RepeatForever:create(cc.RotateBy:create(100, 36000)))
    loadingSpriteAnim:pos(display.cx, display.cy)
end

function GameingScene:topRule_createView_setViewData(res_data)
    if topRule_view_noConnectServer == nil or tolua.isnull(topRule_view_noConnectServer) then

        -- 失联的提示文字
        topRule_view_noConnectServer = display.newTTFLabel({--cc.ui.UILabel.new({
                --UILabelType = 2,
                text = Strings.gameing.noConnectServer,
                size = Dimens.TextSize_25,
                --color = Colors:_16ToRGB(Colors.gameing_jiadi_color),
                color = cc.c3b(23,23,24),
                --color = Colors.white,
                font = Fonts.Font_hkyt_w7,
                align = cc.ui.TEXT_ALIGN_CENTER,
                valign = cc.ui.TEXT_VALIGN_CENTER,
                --dimensions = cc.size(306, 96)
            })
            :addTo(Layer1)
            :align(display.CENTER, display.cx, display.cy-84)
            :setVisible(false)

        local static_gameing_rounds
        local static_gameing_fanRule
        local static_gameing_multRule
        local static_gameing_jiadi
        local static_gameing_mtRule

        local static_gameing_isDlz
        local static_gameing_dlzLevel
        local static_gameing_flzUnit

        -- 邀请内容的拼接开始
        if res_data ~= nil then
            local room = res_data--[User.Bean.room]

            static_gameing_rounds = room[Room.Bean.rounds]
            static_gameing_fanRule = room[Room.Bean.fanRule]
            static_gameing_multRule = room[Room.Bean.multRule]
            static_gameing_jiadi = room[Room.Bean.potRule]
            static_gameing_mtRule = room[Room.Bean.mtRule]
            -- Commons:printLog_Info("是否翻跟：",static_gameing_fanRule,  "是否单双：",static_gameing_multRule,  "是否加底：",static_gameing_jiadi)
            
            static_gameing_isDlz = room[Room.Bean.isDlz]
            static_gameing_dlzLevel = room[Room.Bean.dlzLevel]
            static_gameing_flzUnit = room[Room.Bean.flzUnit]

            myself_invite_content = myself_invite_content .. " "..static_gameing_rounds.."局"
        end -- 多少局

        if static_gameing_fanRule == CEnum.fanRule.fan then
            -- display.newTTFLabel({--cc.ui.UILabel.new({
            --     --UILabelType = 2,
            --     text = "翻醒",
            --     size = Dimens.TextSize_25,
            --     color = Colors:_16ToRGB(Colors.gameing_jiadi_color),
            --     --color = Colors.white,
            --     font = Fonts.Font_hkyt_w9,
            --     align = cc.ui.TEXT_ALIGN_CENTER,
            --     valign = cc.ui.TEXT_VALIGN_CENTER,
            --     --dimensions = cc.size(306, 96)
            -- })
            cc.ui.UIImage.new(Imgs.room_3fgx_fan_mid,{})
                :addTo(Layer1)
                :align(display.CENTER, display.cx-120, osHeight-120)
            myself_invite_content = myself_invite_content .. " "..CEnum.fanRule.fan_info

        elseif static_gameing_fanRule == CEnum.fanRule.gen then
            cc.ui.UIImage.new(Imgs.room_3fgx_gen_mid,{})
                :addTo(Layer1)
                :align(display.CENTER, display.cx-120, osHeight-120)
            myself_invite_content = myself_invite_content .. " "..CEnum.fanRule.gen_info
        end -- 翻醒跟醒 结束

        if static_gameing_multRule == CEnum.multRule.single then
            cc.ui.UIImage.new(Imgs.room_4dsx_single_mid,{})
                :addTo(Layer1)
                :align(display.CENTER, display.cx+120, osHeight-120)
            myself_invite_content = myself_invite_content .. " "..CEnum.multRule.single_info

        elseif static_gameing_multRule == CEnum.multRule.double then
            cc.ui.UIImage.new(Imgs.room_4dsx_double_mid,{})
                :addTo(Layer1)
                :align(display.CENTER, display.cx+120, osHeight-120)
            myself_invite_content = myself_invite_content .. " "..CEnum.multRule.double_info
        end -- 单双醒 结束

        if static_gameing_jiadi == CEnum.jiadi.yes then
            cc.ui.UIImage.new(Imgs.room_2jiadi_yes_mid,{})
                :addTo(Layer1)
                :align(display.CENTER, display.cx+0, osHeight-120)
            myself_invite_content = myself_invite_content .. " "..CEnum.jiadi.yes_info

        elseif static_gameing_jiadi == CEnum.jiadi.no then
        end -- 加底 结束

        local mtRuleView = nil
        if static_gameing_mtRule == CEnum.mtRule.laoMt then
            mtRuleView = cc.ui.UIImage.new(Imgs.room_2mt_laomt_mid,{})
                :addTo(Layer1)
                :align(display.CENTER, display.cx+0, osHeight-120)
            myself_invite_content = myself_invite_content .. " "..CEnum.mtRule.laoMt_info

        elseif static_gameing_mtRule == CEnum.mtRule.xz then
            mtRuleView = cc.ui.UIImage.new(Imgs.room_2mt_xz_mid,{})
                :addTo(Layer1)
                :align(display.CENTER, display.cx+0, osHeight-120)
            myself_invite_content = myself_invite_content .. " "..CEnum.mtRule.xz_info

        elseif static_gameing_mtRule == CEnum.mtRule.dz then
            mtRuleView = cc.ui.UIImage.new(Imgs.room_2mt_dz_mid,{})
                :addTo(Layer1)
                :align(display.CENTER, display.cx+0, osHeight-120)
            myself_invite_content = myself_invite_content .. " "..CEnum.mtRule.dz_info

        elseif static_gameing_mtRule == CEnum.mtRule.quanMt then
            mtRuleView = cc.ui.UIImage.new(Imgs.room_2mt_quanmt_mid,{})
                :addTo(Layer1)
                :align(display.CENTER, display.cx+0, osHeight-120)
            myself_invite_content = myself_invite_content .. " "..CEnum.mtRule.quanMt_info
        end -- 名堂 结束

        if static_gameing_isDlz == CEnum.isDlz.yes then
            if mtRuleView ~= nil then
                mtRuleView:align(display.CENTER, display.cx-120, osHeight-120)
            end
            cc.ui.UIImage.new(Imgs.room_5dlz_selet_mid,{})
                :addTo(Layer1)
                :align(display.CENTER, display.cx+0, osHeight-120)
            myself_invite_content = myself_invite_content .. " "..CEnum.isDlz.yes_info
            -- 是否逗溜子结束

            if static_gameing_dlzLevel == CEnum.dlzLevel._1 then
                cc.ui.UIImage.new(Imgs.room_5dlz_zx_1_mid,{})
                    :addTo(Layer1)
                    :align(display.CENTER, display.cx+90, osHeight-120)
                    :setLayoutSize(80, 23)
                myself_invite_content = myself_invite_content .. " "..CEnum.dlzLevel._1_info

            elseif static_gameing_dlzLevel == CEnum.dlzLevel._2 then
                cc.ui.UIImage.new(Imgs.room_5dlz_zx_2_mid,{})
                    :addTo(Layer1)
                    :align(display.CENTER, display.cx+90, osHeight-120)
                    :setLayoutSize(80, 23)
                myself_invite_content = myself_invite_content .. " "..CEnum.dlzLevel._2_info

            elseif static_gameing_dlzLevel == CEnum.dlzLevel._3 then
                cc.ui.UIImage.new(Imgs.room_5dlz_zx_3_mid,{})
                    :addTo(Layer1)
                    :align(display.CENTER, display.cx+90, osHeight-120)
                    :setLayoutSize(80, 23)
                myself_invite_content = myself_invite_content .. " "..CEnum.dlzLevel._3_info
            end -- 庄闲扣分 结束

            if static_gameing_flzUnit == CEnum.flzUnit._80 then
                cc.ui.UIImage.new(Imgs.room_5dlz_deng_1_mid,{})
                    :addTo(Layer1)
                    :align(display.CENTER, display.cx+90*2, osHeight-120)
                    :setLayoutSize(80, 20)
                myself_invite_content = myself_invite_content .. " "..CEnum.flzUnit._80_info

            elseif static_gameing_flzUnit == CEnum.flzUnit._100 then
                cc.ui.UIImage.new(Imgs.room_5dlz_deng_2_mid,{})
                    :addTo(Layer1)
                    :align(display.CENTER, display.cx+90*2, osHeight-120)
                    :setLayoutSize(80, 20)
                myself_invite_content = myself_invite_content .. " "..CEnum.flzUnit._100_info

            elseif static_gameing_flzUnit == CEnum.flzUnit._200 then
                cc.ui.UIImage.new(Imgs.room_5dlz_deng_3_mid,{})
                    :addTo(Layer1)
                    :align(display.CENTER, display.cx+90*2, osHeight-120)
                    :setLayoutSize(80, 20)
                myself_invite_content = myself_invite_content .. " "..CEnum.flzUnit._200_info
            end -- 庄闲扣分 结束
        end -- 逗溜子 结束
        
    end
end

-- 逗溜子动画和结果显示
function GameingScene:topLz_setViewData(res_data, isStart)
    if res_data ~= nil then

        local room = res_data

        if isStart==nil or isStart~=CEnum.dlzType.isRoom then
            local out_dlz_view = display.newSprite(Imgs.gameing_out_dlz)
                :addTo(Layer1, CEnum.ZOrder.gameingView_myself_voice)
                :pos(display.cx, display.cy+195)   -- 一副牌的显示位置

            -- 逗溜子
            VoiceDealUtil:playSound_other(Voices.file.gameing_dlz)
            Layer1:performWithDelay(function ()
                if out_dlz_view~=nil and not tolua.isnull(out_dlz_view) then
                    out_dlz_view:removeFromParent()
                end
                VoiceDealUtil:playSound_other(Voices.file.gameing_addcoin)

                -- 每个玩家逗溜子的动画
                DlzAnim.new():addTo(Layer1, CEnum.ZOrder.gameingView_myself_voice)
                -- FlzAnim.new():addTo(Layer1, CEnum.ZOrder.gameingView_myself_voice)
            end, 1)
        end

        if isStart ~= nil and (isStart==CEnum.dlzType.isRound or isStart==CEnum.dlzType.isRoom) then
            local gapTime = 1.0
            if isStart==CEnum.dlzType.isRoom then
                gapTime = 0.5
            elseif isStart==CEnum.dlzType.isRound then
                gapTime = 1.5
            end

            -- 分溜子
            Layer1:performWithDelay(function ()

                local roomRecord = room[Room.Bean.roomRecord]
                local _tag = true
                if Commons:checkIsNull_tableList(roomRecord) then

                    -- 房价结束，存在分溜子
                    for k,v in pairs(roomRecord) do
                        local _flzScore = v[RoomRecord.Bean.flzScore]
                        if Commons:checkIsNull_numberType(_flzScore) and _flzScore > CEnum.isDlz.zeroLz then
                            _tag = false

                            VoiceDealUtil:playSound_other(Voices.file.gameing_flz)
                            Layer1:performWithDelay(function ()
                                VoiceDealUtil:playSound_other(Voices.file.gameing_addcoin)
                                -- 每个玩家分溜子的动画
                                FlzAnim.new():addTo(Layer1, CEnum.ZOrder.gameingView_myself_voice)

                                -- 分完溜子，再出结算页面
                                Layer1:performWithDelay(function ()
                                    ---[[
                                    -- VoiceDealUtil:playSound_other(Voices.file.over_huang)
                                    -- 回合结果
                                    CVar._static.isNeedShowPrepareBtn = false
                                    GameingOverRoundDialog:popDialogBox(Layer1, res_data, nil, nil, nil,
                                        CEnum.pageView.gameingOverPage,
                                        myself_view_btn_Prepare
                                    )
                                    --]]
                                end, 0.8+0.8)
                            end, 0.8)
                        end
                        break
                    end
                end                

                if _tag then -- 房间结束，不存在分溜子，直接出结算
                    ---[[
                    -- VoiceDealUtil:playSound_other(Voices.file.over_huang)
                    -- 弹窗显示回合结果，房间结束，有房间数据
                    CVar._static.isNeedShowPrepareBtn = false
                    GameingOverRoundDialog:popDialogBox(Layer1, res_data, nil, nil, nil,
                        CEnum.pageView.gameingOverPage,
                        myself_view_btn_Prepare
                    )
                    --]]
                end
            end, gapTime)
        else
            -- 开局
            Layer1:performWithDelay(function ()
                local cardNumAll = 21 -- 发牌的数量
                local timeAll = 1.825 -- 显示牌 需要等待的时间 3.175  1.825
                if CVar._static.isIphone4 then
                    cardNumAll = 17
                    timeAll = 1.525 -- 2.675  1.525
                elseif CVar._static.isIpad then
                    cardNumAll = 14
                    timeAll = 1.3 -- 2.3  1.3
                else
                end
                VoiceDealUtil:playSound_other(Voices.file.gameing_facard)
                DealCardAnim.new(cardNumAll):addTo(Layer1) -- 先来一个发牌动画
                -- 动画时间需要多少秒完成，这里就多少秒后执行
                --Layer1:performWithDelay(function()
                --end, timeAll)

                GameingScene:myself_handCard_createView_setViewData(res_data)-- 我手上的牌   主位置
                GameingScene:players_handCard_setViewData(res_data)-- 每位玩家 上次吃牌动画| 已经出过的牌| 已经吃、碰过的牌| 并且庄家第一次出牌
            end, 1+1)
        end

    end -- res_data ~= nil

end

-- 网络发生改变，直接就关闭socket来重连了
function GameingScene:NetIsOK_change()
    if not isMyManual then
        if topRule_view_noConnectServer ~= nil and (not tolua.isnull(topRule_view_noConnectServer)) then
            topRule_view_noConnectServer:setString(Strings.gameing.noConnectServer)
            topRule_view_noConnectServer:setVisible(true)
        end
    end
        
    if CVar._static.mSocket ~= nil then
        CVar._static.mSocket:CloseSocket()
    end
end

--[[
-- 判断网络状况，如果连续3次都不行，就需要重连了
function GameingScene_NetIsOK(status)
    if status == CEnum.status.fail then -- 连续三次连接不上
        if isConnected_sockk_nums <=2 then
            Commons:printLog_Info("没有网络情况出现了 序号是：",isConnected_sockk_nums)
            isConnected_sockk_nums = isConnected_sockk_nums + 1

            if CEnum.Environment.Current~=nil and CEnum.Environment.Current==CEnum.EnvirType.Test then 
                --CVar._static.mSocket:tcpConnected()
                if topRule_view_noConnectServer ~= nil and (not tolua.isnull(topRule_view_noConnectServer)) then
                    topRule_view_noConnectServer:setVisible(false)
                end
            end
        else
            Commons:printLog_Info("没有网络情况出现了 最后一次序号是：",isConnected_sockk_nums)
            if CEnum.Environment.Current~=nil and CEnum.Environment.Current==CEnum.EnvirType.Test then 
                CVar._static.mSocket:tcpClosed()
            end
            
            if CVar._static.mSocket ~= nil then
                CVar._static.mSocket:CloseSocket()
            end
            isConnected_sockk_nums = 1
        end
    else
        Commons:printLog_Info("网络一直正常 序号是：",isConnected_sockk_nums)
        isConnected_sockk_nums = 1
    end
end
--]]

--[[
-- 心跳3次有没有成功，没有成功，就重连
function GameingScene_NetIsOK_Xintiao()
        if isConnected_sockk_nums <=3 then
            Commons:printLog_Info("没有网络情况出现了 序号是：",isConnected_sockk_nums)
            isConnected_sockk_nums = isConnected_sockk_nums + 1

            if CEnum.Environment.Current~=nil and CEnum.Environment.Current==CEnum.EnvirType.Test then 
                --CVar._static.mSocket:tcpConnected()
                if topRule_view_noConnectServer ~= nil and (not tolua.isnull(topRule_view_noConnectServer)) then
                    topRule_view_noConnectServer:setVisible(false)
                end
            end
        else
            Commons:printLog_Info("没有网络情况出现了 最后一次序号是：",isConnected_sockk_nums)
            if CEnum.Environment.Current~=nil and CEnum.Environment.Current==CEnum.EnvirType.Test then 
                CVar._static.mSocket:tcpClosed()
            end
            
            if CVar._static.mSocket ~= nil then
                CVar._static.mSocket:CloseSocket()
            end
            isConnected_sockk_nums = 1
        end
end
--]]

-- 顶部组件初始化
function GameingScene:top_createView()
    --top_view = cc.LayerColor:create(cc.c4b(100,100,100,255),osWidth,osHeight)
    --top_view = display.newScale9Sprite(Imgs.c_default_img, display.cx, display.cy, cc.size(osWidth, osHeight))
    --top_view = display.newScale9Sprite(Imgs.c_default_img)
    --top_view = display.newColorLayer(Colors.layer_bg)
    -- top_view = display.newLayer()
    --     :setPosition(cc.p(0,0))
    --     --:align(display.CENTER, display.cx, osHeight-112/2)
    --     :addTo(Layer1)
    --     :setVisible(false)
    top_view = cc.NodeGrid:create()
   	top_view:addTo(Layer1)
    top_view:setVisible(false)
    
	-- 顶部背景
    cc.ui.UIImage.new(Imgs.gameing_top_bg,{scale9=false})
        :addTo(top_view)
        :align(display.CENTER, display.cx, osHeight-112/2)
        :setLayoutSize(osWidth, 113)

    -- 返回
    if not CEnum.Environment.outRelease then
        cc.ui.UIPushButton.new(
            Imgs.gameing_top_btn_back,{scale9=false})
            :setButtonSize(42, 40)
            -- :setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
            --  UILabelType = 2,
            --  text = "",
            --     size = Dimens.TextSize_30,
            --  color = Colors.btn_normal,
            --  }))
            -- :setButtonLabel(EnStatus.pressed, cc.ui.UILabel.new({
            --  UILabelType = 2,
            --  text = "",
            --  size = Dimens.TextSize_30,
            --  color = Colors.btn_press,
            --  }))
            :setButtonImage(EnStatus.pressed, Imgs.gameing_top_btn_back)
            :onButtonClicked(function(e)
                CDialog.new():popDialogBox(Layer1, 
                    CDialog.title_logo.backHome, "返回大厅,房间仍会保留,快去邀请大伙来玩吧",
                    function() GameingScene:backHome_OK() end, function() GameingScene:backHome_NO() end)
            end)
            :align(display.LEFT_TOP, 20, osHeight-1)
            :addTo(top_view)
    end

	-- 当前时间显示
    local myDate = os.date("%H:%M") -- "%Y-%m-%d %H:%M:%S"
    --Commons:printLog_Info("什么类型：", type(myDate))
    local myDate_label = display.newTTFLabel({--cc.ui.UILabel.new({
	        --UILabelType = 2,
	        text = myDate,
	        size = Dimens.TextSize_20,
            color = Colors:_16ToRGB(Colors.gameing_time),
	        font = Fonts.Font_hkyt_w9,
	        align = cc.ui.TEXT_ALIGN_CENTER,
	        valign = cc.ui.TEXT_VALIGN_CENTER,
	        --dimensions = cc.size(306, 96)
     	})
        :addTo(top_view)
        :align(display.LEFT_TOP, 125, osHeight-8-1) -- 最左边
    if CVar._static.isIphone4 then
        myDate_label:align(display.LEFT_TOP, 125-25, osHeight-8-1)
    elseif CVar._static.isIpad then
        myDate_label:align(display.LEFT_TOP, 125-25-15, osHeight-8-1)
    elseif CVar._static.NavBarH_Android ~= CEnum.status.NavBarH_def then
        myDate_label:align(display.LEFT_TOP, 125 -CVar._static.NavBarH_Android*0.1, osHeight-8-1)
    end

	--local coo = coroutine.create(function ()
        local function GameingScene_changeTime()
        	myDate = os.date("%H:%M") -- "%H:%M:%S"
        	--Commons:printLog_Info("当前时间：", myDate, myDate_label)
        	myDate_label:setString(myDate)
        end
        top_scheduler = Layer1:getScheduler();
        top_schedulerID = top_scheduler:scheduleScriptFunc(GameingScene_changeTime, 60, false) -- 1分钟一次
        Commons:printLog_Info("----走时间 这个计时器：", top_schedulerID)

        ---[[
        local function GameingScene_listeningNetwork()

            -- NetIsOKUtil:isOK(GameingScene_NetIsOK) -- 这个里面包含了网络类型判断 和 一个固定url的读取

            -- 客户端发心跳，找服务器，三次没有响应，就重连
            --GameingScene_NetIsOK_Xintiao()
            -- SocketRequestGameing:gameing_Xintiao_send()

            local _changeNet = false
            local st = Nets:isNetOk()
            if top_schedulerID_network_status ~= nil and top_schedulerID_network_status == st then
                -- 没有切换网络模式
            elseif top_schedulerID_network_status ~= nil and top_schedulerID_network_status ~= st then
                _changeNet = true
                -- 切换了网络模式
                -- 去重连接，并且告知用户在重连
                GameingScene:NetIsOK_change()
            else
                -- 初始值
                top_schedulerID_network_status = st
            end            

            if not _changeNet then
                --local nowDate = tonumber(os.date(CEnum.timeFormat.ymdhms) .. "" )
                --local nowDate = tonumber(socketCCC.gettime() )
                --Commons:printLog_Info("----tt 现在的时间是 字符串的：", os.time(), type(os.time()))
                local nowDate = os.time()

                Commons:printLog_Info("----tt 现在的时间是：", nowDate, type(nowDate))
                if isConnected_sockk_time ~= nil then
                    Commons:printLog_Info("----tt 变化的的时间是：", isConnected_sockk_time, type(isConnected_sockk_time))
                    local gaping_time = nowDate - isConnected_sockk_time
                    Commons:printLog_Info("----tt 相差多久：", gaping_time, type(gaping_time))
                    if gaping_time >= 10 then
                        -- 只要有数据过来，我就改变记录这个时间点
                        --isConnected_sockk_time = tonumber(os.date(CEnum.timeFormat.ymdhms) .. "")
                        --isConnected_sockk_time = tonumber(socketCCC.gettime() )
                        isConnected_sockk_time = os.time()
                        GameingScene:NetIsOK_change()
                    end
                end
            end
        end
        Commons:printLog_Info("--gameing 什么平台：：", Commons.osType)
        if Commons.osType == CEnum.osType.A or Commons.osType == CEnum.osType.I 
            --or Commons.osType == CEnum.osType.W
            then
            top_schedulerID_network = top_scheduler:scheduleScriptFunc(GameingScene_listeningNetwork, 4, false) -- **秒一次
            Commons:printLog_Info("----A I 监听网络状态 这个计时器：", top_schedulerID_network)
        elseif CEnum.Environment.Current~=nil and CEnum.Environment.Current==CEnum.EnvirType.Test then
            -- top_schedulerID_network = top_scheduler:scheduleScriptFunc(GameingScene_listeningNetwork, 4, false) -- **秒一次
            -- Commons:printLog_Info("----test 监听网络状态 这个计时器：", top_schedulerID_network)
        end
    	--]]

        --top_scheduler:unscheduleScriptEntry(top_schedulerID);
	-- end)
	-- Commons:printLog_Info("11协同的状态是：", coroutine.status(coo));
	-- coroutine.resume(coo);
	-- Commons:printLog_Info("22协同的状态是：", coroutine.status(coo));

    -- 逗溜子背景
    myLz_bg = cc.ui.UIImage.new(Imgs.gameing_top_lz,{scale9=false})
        :addTo(top_view)
        :align(display.RIGHT_TOP, osWidth-125-20, osHeight-8) -- 最左边
        -- :setLayoutSize(osWidth, 113)
        :hide()
    myLz_label = display.newTTFLabel({--cc.ui.UILabel.new({
            --UILabelType = 2,
            text = "",
            size = Dimens.TextSize_20,
            color = Colors:_16ToRGB(Colors.gameing_time),
            font = Fonts.Font_hkyt_w9,
            align = cc.ui.TEXT_ALIGN_CENTER,
            valign = cc.ui.TEXT_VALIGN_CENTER,
            --dimensions = cc.size(306, 96)
        })
        :addTo(top_view)
        :align(display.LEFT_TOP, osWidth-125-20 -70, osHeight-8-2) -- 最左边
        :hide()

	-- 设置
	local top_view_setting=cc.ui.UIPushButton.new(
    	Imgs.gameing_top_setting,{scale9=false})
        :setButtonSize(56, 72)
        -- :setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
        -- 	UILabelType = 2,
        -- 	text = "",
        --     size = Dimens.TextSize_30,
        -- 	color = Colors.btn_normal,
        -- 	}))
        -- :setButtonLabel(EnStatus.pressed, cc.ui.UILabel.new({
        -- 	UILabelType = 2,
        -- 	text = "",
        -- 	size = Dimens.TextSize_30,
        -- 	color = Colors.btn_press,
        -- 	}))
        :setButtonImage(EnStatus.pressed, Imgs.gameing_top_setting)
        :onButtonClicked(function(e)
        
            VoiceDealUtil:playSound_other(Voices.file.ui_click)
            SettingDialog:popDialogBox(Layer1, CEnum.pageView.gameingOverPage)
            
        end)
        :align(display.LEFT_TOP, 484, osHeight-8)
        :addTo(top_view)
    if CVar._static.isIphone4 then
        top_view_setting:align(display.LEFT_TOP, 484-80, osHeight-8)
    elseif CVar._static.isIpad then
        top_view_setting:align(display.LEFT_TOP, 484-80-60, osHeight-8)
    elseif CVar._static.NavBarH_Android ~= CEnum.status.NavBarH_def then
        top_view_setting:align(display.LEFT_TOP, 484-CVar._static.NavBarH_Android/2, osHeight-8)
    end

    -- 解散房间
    top_view_dissRoom = cc.ui.UIPushButton.new(
    	Imgs.gameing_top_dismiss_room,{scale9=false})
        :setButtonSize(86, 70)
        -- :setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
        -- 	UILabelType = 2,
        -- 	text = "",
        --     size = Dimens.TextSize_30,
        -- 	color = Colors.btn_normal,
        -- 	}))
        -- :setButtonLabel(EnStatus.pressed, cc.ui.UILabel.new({
        -- 	UILabelType = 2,
        -- 	text = "",
        -- 	size = Dimens.TextSize_30,
        -- 	color = Colors.btn_press,
        -- 	}))
        :setButtonImage(EnStatus.pressed, Imgs.gameing_top_dismiss_room)
        :onButtonClicked(function(e)
            VoiceDealUtil:playSound_other(Voices.file.ui_click)
            --解散房间请求
            --SocketRequestGameing:dissRoom()
            --CDAlert.new():popDialogBox(Layer1, "解散房间请求已经发送,等待其他玩家确认。")
            CDialog.new():popDialogBox(Layer1, 
                nil, Strings.gameing.dissRoomConfim, 
                function() GameingScene:dissRoomMeConfim_OK() end, function() GameingScene:dissRoomMeConfim_NO() end)
        end)
        :align(display.RIGHT_TOP, osWidth-464, osHeight-8)
        :addTo(top_view)
    if CVar._static.isIphone4 then
        top_view_dissRoom:align(display.RIGHT_TOP, osWidth-464+80, osHeight-8)
    elseif CVar._static.isIpad then
        top_view_dissRoom:align(display.RIGHT_TOP, osWidth-464+80+55, osHeight-8)
    elseif CVar._static.NavBarH_Android ~= CEnum.status.NavBarH_def then
        top_view_dissRoom:align(display.RIGHT_TOP, osWidth-464+CVar._static.NavBarH_Android/2-5, osHeight-8)
    end
    -- 返回大厅
    top_view_backRoom = cc.ui.UIPushButton.new(
        Imgs.gameing_top_btn_back2,{scale9=false})
        :setButtonSize(86, 70)
        --:setButtonSize(42, 40)
        -- :setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
        --  UILabelType = 2,
        --  text = "",
        --     size = Dimens.TextSize_30,
        --  color = Colors.btn_normal,
        --  }))
        -- :setButtonLabel(EnStatus.pressed, cc.ui.UILabel.new({
        --  UILabelType = 2,
        --  text = "",
        --  size = Dimens.TextSize_30,
        --  color = Colors.btn_press,
        --  }))
        :setButtonImage(EnStatus.pressed, Imgs.gameing_top_btn_back2)
        :onButtonClicked(function(e)
            VoiceDealUtil:playSound_other(Voices.file.ui_click)
            CDialog.new():popDialogBox(Layer1, 
                CDialog.title_logo.backHome, Strings.gameing.outRoomConfim,
                function() GameingScene:backHome_OK_toSendServer() end, function() GameingScene:backHome_NO() end)
        end)
        :align(display.RIGHT_TOP, osWidth-464, osHeight-8)
        :addTo(top_view)
        :setVisible(false)
    if CVar._static.isIphone4 then
        top_view_backRoom:align(display.RIGHT_TOP, osWidth-464+80, osHeight-8)
    elseif CVar._static.isIpad then
        top_view_backRoom:align(display.RIGHT_TOP, osWidth-464+80+55, osHeight-8)
    elseif CVar._static.NavBarH_Android ~= CEnum.status.NavBarH_def then
        top_view_backRoom:align(display.RIGHT_TOP, osWidth-464+CVar._static.NavBarH_Android/2-5, osHeight-8)
    end

    -- gprs定位信息显示按钮
    top_view_gprsBtn = cc.ui.UIPushButton.new(
        Imgs.g_th_green,{scale9=false})
        --:setButtonSize(72, 100)
        -- :setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
        --  UILabelType = 2,
        --  text = "",
        --     size = Dimens.TextSize_30,
        --  color = Colors.btn_normal,
        --  }))
        -- :setButtonLabel(EnStatus.pressed, cc.ui.UILabel.new({
        --  UILabelType = 2,
        --  text = "",
        --  size = Dimens.TextSize_30,
        --  color = Colors.btn_press,
        --  }))
        --:setButtonImage(EnStatus.disabled, Imgs.gameing_user_prepare_ok)
        :setButtonImage(EnStatus.pressed, Imgs.g_th_green)
        :onButtonClicked(function(e)
            VoiceDealUtil:playSound_other(Voices.file.ui_click)
            PopGprsDialog = CDAlertGprs:popDialogBox(Layer1, GprsBean)
        end)
        :align(display.CENTER, 350+100-40, osHeight-40 +16)
        -- :addTo(myself_view)
        -- 调整到层级最高，就需要第一次处于隐藏状态
        :addTo(Layer1, CEnum.ZOrder.gameingView_myself_voice)
        :setScale(0.9)
        :hide()
    if CVar._static.isIphone4 then
        top_view_gprsBtn:align(display.CENTER, 350+100-40 -100, osHeight-40 +16)
    elseif CVar._static.isIpad then
        top_view_gprsBtn:align(display.CENTER, 350+100-40 -150, osHeight-40 +16)
    elseif CVar._static.NavBarH_Android ~= CEnum.status.NavBarH_def then
        top_view_gprsBtn:align(display.CENTER, 350+100-40 -CVar._static.NavBarH_Android/2, osHeight-40 +16) -- 最左边
    end

    --[[
    -- 房号
    top_view_roomNo = cc.ui.UILabel.new({
        	UILabelType = 2, 
        	--image = "",
        	text = CVar._static.roomNo, 
            size = Dimens.TextSize_20,
        	color = Colors:_16ToRGB(Colors.gameing_roomNo),
	        font = Fonts.Font_hkyt_w9,
	        align = cc.ui.TEXT_ALIGN_CENTER,
	        valign = cc.ui.TEXT_VALIGN_CENTER,
    	})
        :align(display.LEFT_TOP, 484+145, osHeight-15)
        :addTo(top_view)
    --]]
    top_view_roomNo = display.newNode():addTo(top_view);

    --[[
    -- 回合数
    top_view_ju = display.newTTFLabel({
	        text = "第0/0局",
	        font = Fonts.Font_hkyt_w9,
	        size = Dimens.TextSize_20,
	        color = Colors:_16ToRGB(Colors.gameing_roomNo),
	        align = cc.ui.TEXT_ALIGN_CENTER,
            valign = cc.ui.TEXT_VALIGN_CENTER,
	        --dimensions = cc.size(177,34)
	    })
        :addTo(top_view)
	    :align(display.CENTER, display.cx, osHeight-15-34-8)
    --]]
    top_view_ju = display.newNode():addTo(top_view);


    -- 平台
    local osType_show = ""
    if Commons.osType ~= nil and CEnum.osType.A == Commons.osType then
        osType_show = "And"
    elseif Commons.osType ~= nil and CEnum.osType.I == Commons.osType then
        osType_show = "IOS"
    elseif Commons.osType ~= nil and CEnum.osType.W == Commons.osType then
        osType_show = "Win"
    elseif Commons.osType ~= nil and CEnum.osType.M == Commons.osType then
        osType_show = "Mac"
    end
    cc.ui.UILabel.new({
            text = osType_show, 
            font = Fonts.Font_hkyt_w7,
            size = 15, 
            color = Colors.versionName,
            --color = Colors:_16ToRGB(Colors.help_txt),
            align = cc.ui.TEXT_ALIGN_CENTER,
            valign = cc.ui.TEXT_VALIGN_CENTER,
        })
        :align(display.LEFT_TOP, 6, osHeight-2)
        :addTo(top_view)
    -- 版本号
    cc.ui.UILabel.new({
            text = ""..CEnum.AppVersion.versionName..' ('..CEnum.AppVersion.versionCode..')',  
            font = Fonts.Font_hkyt_w7,
            size = 15, 
            color = Colors.versionName,
            --color = Colors:_16ToRGB(Colors.help_txt),
            align = cc.ui.TEXT_ALIGN_CENTER,
            valign = cc.ui.TEXT_VALIGN_CENTER,
        })
        :align(display.RIGHT_TOP, osWidth-6, osHeight-2)
        :addTo(top_view)
end
-- 顶部组件赋值
function GameingScene:top_setViewData(res_data)
	if res_data ~= nil then
        local room = res_data--[User.Bean.room]

        local roomNo = room[Room.Bean.roomNo]
        --Commons:printLog_Info("top_view_roomNo:::", roomNo)
        local playRound = room[Room.Bean.playRound]
        local rounds = room[Room.Bean.rounds]

        local _string
        local _size
        local _size2
        if Commons:checkIsNull_str(roomNo) then
            local moveX = 0
            if CVar._static.isIphone4 then
                moveX = -96
            elseif CVar._static.isIpad then
                moveX = -156
            elseif CVar._static.NavBarH_Android ~= CEnum.status.NavBarH_def then
                moveX = -CVar._static.NavBarH_Android/2
            end

        	--top_view_roomNo:setString(roomNo)

            -- 房间编号
            if top_view_roomNo~=nil and (not tolua.isnull(top_view_roomNo)) and top_view_roomNo:getChildrenCount() > 0 then
                top_view_roomNo:removeAllChildren()
            end

            _string = tostring(roomNo)
            _size = string.len(_string)
            for i=1,_size do
                local i_str = string.sub(_string, i, i)
                local img_i = GameingDealUtil:getNumImg_by_roomno(i_str)
                local temp_img = cc.ui.UIImage.new(img_i,{scale9=false})
                    :addTo(top_view_roomNo)
                    :align(display.LEFT_TOP, 484+135 +0+14*(i-1) +moveX, osHeight-15)
            end
        end

        if Commons:checkIsNull_numberType(playRound) and Commons:checkIsNull_numberType(rounds) then
	        --top_view_ju:setString("第"..playRound.."/"..rounds.."局")
            --Commons:printLog_Info("=====",playRound,rounds)

            local moveX = 0
            if CVar._static.isIphone4 then
                moveX = -96
            elseif CVar._static.isIpad then
                moveX = -156
            elseif CVar._static.NavBarH_Android ~= CEnum.status.NavBarH_def then
                moveX = -CVar._static.NavBarH_Android/2
            end


            if top_view_ju~=nil and (not tolua.isnull(top_view_ju)) and top_view_ju:getChildrenCount() > 0 then
               top_view_ju:removeAllChildren()
            end

            -- 第字
            local di_img = cc.ui.UIImage.new(Imgs.over_nums_roundno_di,{scale9=false})
                    :addTo(top_view_ju)
                    :align(display.LEFT_TOP, 484+110 +moveX, osHeight-15-33)

            -- 数字
            _string = tostring(playRound)
            _size = string.len(_string)
            for i=1,_size do
                local i_str = string.sub(_string, i, i)
                local img_i = GameingDealUtil:getNumImg_by_roundno(i_str)
                local temp_img = cc.ui.UIImage.new(img_i,{scale9=false})
                    :addTo(top_view_ju)
                    :align(display.LEFT_TOP, 484+135 +0+12*(i-1) +moveX, osHeight-15-34)
            end

            -- /字
            local gang_img = cc.ui.UIImage.new(Imgs.over_nums_roundno_gang,{scale9=false})
                    :addTo(top_view_ju)
                    :align(display.LEFT_TOP, 484+135 +0+12*_size +2 +moveX, osHeight-15-35)

            -- 数字
            _string = tostring(rounds)
            _size2 = string.len(_string)
            for i=1,_size2 do
                local i_str = string.sub(_string, i, i)
                local img_i = GameingDealUtil:getNumImg_by_roundno(i_str)
                local temp_img = cc.ui.UIImage.new(img_i,{scale9=false})
                    :addTo(top_view_ju)
                    :align(display.LEFT_TOP, 484+135 +0+12*_size +14 +0+12*(i-1) +moveX, osHeight-15-34)
            end

            -- 局字
            local ju_img = cc.ui.UIImage.new(Imgs.over_nums_roundno_ju,{scale9=false})
                    :addTo(top_view_ju)
                    :align(display.LEFT_TOP, 484+135 +0+12*_size +12 +0+12*_size2 +5 +moveX, osHeight-15-33)

            --end
	    end

	    top_view:setVisible(true)
	end
end

-- 选择再来一局，需要将房间界面重置，该去掉的去掉，该隐藏的隐藏
function GameingScene:myViewReset_thisDesktop()
    if myself_view_btn_Prepare ~= nil and (not tolua.isnull(myself_view_btn_Prepare)) then
        CVar._static.isNeedShowPrepareBtn = true

        myself_view_btn_Prepare:setVisible(true)
        myself_view_btn_Prepare:setButtonEnabled(false)

        if myself_view_mo_chu_pai_bg ~= nil and (not tolua.isnull(myself_view_mo_chu_pai_bg)) then
            myself_view_mo_chu_pai_bg:setVisible(false)
        end
        if myself_view_mo_chu_pai ~= nil and (not tolua.isnull(myself_view_mo_chu_pai)) then
            myself_view_mo_chu_pai:setVisible(false)
        end
        if xiajia_view_mo_chu_pai_bg ~= nil and (not tolua.isnull(xiajia_view_mo_chu_pai_bg)) then
            xiajia_view_mo_chu_pai_bg:setVisible(false)
        end
        if xiajia_view_mo_chu_pai ~= nil and (not tolua.isnull(xiajia_view_mo_chu_pai)) then
            xiajia_view_mo_chu_pai:setVisible(false)
        end
        if lastjia_view_mo_chu_pai_bg ~= nil and (not tolua.isnull(lastjia_view_mo_chu_pai_bg)) then
            lastjia_view_mo_chu_pai_bg:setVisible(false)
        end
        if lastjia_view_mo_chu_pai ~= nil and (not tolua.isnull(lastjia_view_mo_chu_pai)) then
            lastjia_view_mo_chu_pai:setVisible(false)
        end

        if myself_view_chiguo_list ~= nil and (not tolua.isnull(myself_view_chiguo_list)) then
            myself_view_chiguo_list:removeAllItems()
        end
        if xiajia_view_chiguo_list ~= nil and (not tolua.isnull(xiajia_view_chiguo_list)) then
            xiajia_view_chiguo_list:removeAllItems()
        end
        if lastjia_view_chiguo_list ~= nil and (not tolua.isnull(lastjia_view_chiguo_list)) then
            lastjia_view_chiguo_list:removeAllItems()
        end

        if myself_view_chuguo_list ~= nil and (not tolua.isnull(myself_view_chuguo_list)) then
            myself_view_chuguo_list:removeAllItems()
        end
        if xiajia_view_chuguo_list ~= nil and (not tolua.isnull(xiajia_view_chuguo_list)) then
            xiajia_view_chuguo_list:removeAllItems()
        end
        if lastjia_view_chuguo_list ~= nil and (not tolua.isnull(lastjia_view_chuguo_list)) then
            lastjia_view_chuguo_list:removeAllItems()
        end

        if dcard_view ~= nil and (not tolua.isnull(dcard_view)) then
            dcard_view:setVisible(false)
        end
        if view_diCards_list ~= nil and (not tolua.isnull(view_diCards_list)) then
            view_diCards_list:removeFromParent()
            view_diCards_list = nil
        end

        if bg_view ~= nil and (not tolua.isnull(bg_view)) then
            bg_view:setVisible(false)
        end
        if box_chupai ~= nil and (not tolua.isnull(box_chupai)) then
            box_chupai:setVisible(false)
        end

        if _handCardDataTable ~= nil then
            _handCardDataTable = nil
        end

        GameingMeChiCardDeal:createChiCards(nil) -- 消失可能操作过的吃牌
        if myself_view_needOption_list ~= nil and (not tolua.isnull(myself_view_needOption_list)) then 
            myself_view_needOption_list:setVisible(false) -- 中间的选择消失
        end

        if mtView ~= nil and (not tolua.isnull(mtView)) then
            mtView:removeFromParent()
            mtView = nil
        end

        if ruleView ~= nil and (not tolua.isnull(ruleView)) then
            ruleView:removeFromParent()
            ruleView = nil
        end

        if fanCardView ~= nil and (not tolua.isnull(fanCardView)) then
            fanCardView:removeFromParent() 
            fanCardView = nil
        end
        if huCard_tipimg_node ~= nil and (not tolua.isnull(huCard_tipimg_node)) then
            huCard_tipimg_node:removeFromParent() 
            huCard_tipimg_node = nil
        end

        if bg_view_R ~= nil and (not tolua.isnull(bg_view_R)) then
            bg_view_R:removeFromParent() 
            bg_view_R = nil
        end

        if bg_view_L ~= nil and (not tolua.isnull(bg_view_L)) then
            bg_view_L:removeFromParent() 
            bg_view_L = nil
        end
    end
end

-- 自己位置的界面组件
function GameingScene:myself_createView()
    -- myself_view = display.newLayer()
    --     :setPosition(cc.p(0,0))
    --     --:align(display.CENTER, display.cx, osHeight-112/2)
    --     :addTo(Layer1)
    --     :setVisible(false)
    myself_view = cc.NodeGrid:create();
   	--myself_view:addTo(Layer1)
    Layer1:addChild(myself_view, CEnum.ZOrder.gameingView_myself)
   	myself_view:setVisible(false)
        
	-- 头像框
	-- display.newSprite(Imgs.gameing_user_head_bg)
 --        :align(display.LEFT_TOP, 40, 165)
 --        :addTo(myself_view)
    cc.ui.UIPushButton.new(Imgs.gameing_user_head_bg,{scale9=false})
        :align(display.LEFT_TOP, 40, 165)
        :addTo(myself_view)
        :onButtonClicked(function(e)
            -- CDAlertIP:popDialogBox(Layer1, user_icon, user_nickname, user_account, user_ip, user_rights)
            SupEmojiDialog.new(user_icon, user_nickname, user_account, user_ip, user_rights, 
                        mySeatNo, currMySeatNo):addTo(Layer1, CEnum.ZOrder.common_dialog)
        end)
    if user_icon ~= nil and user_icon ~= "" then
        myself_view_icon = NetSpriteImg.new(user_icon, 76, 80)
            :align(display.LEFT_TOP,40+6, 165-6)
            :addTo(myself_view)
    end
    -- myself_view_emoji = cc.ui.UIPushButton.new(Imgs.biaoqing_btn,{scale9=false})
    --     :addTo(myself_view)
    --     :align(display.LEFT_TOP, 50, 165)
    --     :setVisible(false)

    -- 昵称
    myself_view_nickname = display.newTTFLabel({
	        text = user_nickname,
	        font = Fonts.Font_hkyt_w9,
	        size = Dimens.TextSize_20,
	        color = display.COLOR_WHITE,
	        align = cc.ui.TEXT_ALIGN_CENTER,
            valign = cc.ui.TEXT_VALIGN_CENTER,
	        dimensions = cc.size(120,25)
	    })
        :addTo(myself_view)
	    :align(display.LEFT_TOP, 16, 67)

    -- 分数框
    display.newSprite(Imgs.gameing_user_score_bg)
        :align(display.LEFT_TOP, 14, 40)
        :addTo(myself_view)
    myself_view_score = display.newTTFLabel({
	        text = "分数:",
	        font = Fonts.Font_hkyt_w9,
	        size = Dimens.TextSize_18,
	        --color = display.COLOR_WHITE,
	        color = Colors:_16ToRGB(Colors.gameing_score),
	        align = cc.ui.TEXT_ALIGN_CENTER,
            valign = cc.ui.TEXT_VALIGN_CENTER,
	        dimensions = cc.size(146,50)
	    })
        :addTo(myself_view)
	    :align(display.LEFT_TOP, 14, 47)

	-- 多少胡息
    myself_view_xi = display.newTTFLabel({
	        text = "1  胡息",
	        font = Fonts.Font_hkyt_w9,
	        size = Dimens.TextSize_25,
	        --color = display.COLOR_WHITE,
	        color = Colors:_16ToRGB(Colors.gameing_huxi),
	        align = cc.ui.TEXT_ALIGN_CENTER,
            valign = cc.ui.TEXT_VALIGN_CENTER,
	        dimensions = cc.size(75,50)
	    })
        :addTo(myself_view)
	    :align(display.LEFT_TOP, 130, 175)

	-- 是否是庄家
    myself_view_isBanker = cc.ui.UIImage.new(Imgs.gameing_banker,{})
        :addTo(myself_view)
        :align(display.LEFT_TOP, 130+8, 175-40)

    -- 出过的牌  这里应该是一个列表  右下角
	--cc.ui.UIImage.new(Imgs.card_out_ns1,{})
    --:addTo(myself_view)
    --:align(display.RIGHT_BOTTOM, osWidth-10, 14)
    myself_view_chuguo_list = 
        cc.ui.UIPageView.new({
            viewRect = cc.rect(0, 0, (card_w_out_A+1)*card_cc_out_A, card_h_out_A*card_line_out_A),
            column = card_cc_out_A,
            row = card_line_out_A, 
            padding = {left = card_w_out_A/2, right = card_w_out_A/2, top = 0, bottom = card_h_out_A/2},
            columnSpace=13,
            rowSpace=5,
            bCirc = false
        })
        :addTo(myself_view)
        :align(display.RIGHT_BOTTOM, osWidth-10-42*card_cc_out_A, 207-card_w_out_A)

    -- 本人碰、吃等等的牌  这里应该是一个列表
    -- cc.ui.UIImage.new(Imgs.card_out_ns1,{})
    --     :addTo(myself_view)
    --     :align(display.BOTTOM_LEFT, 14, 175)
    myself_view_chiguo_list = cc.ui.UIPageView.new({
            viewRect = cc.rect(0, 0, 45*6, 45*4),
            column = 6,
            row = 4, 
            padding = {left = 20, right = 20, top = 0, bottom = 20},
            columnSpace=0,
            rowSpace=0,
            bCirc = false
        })
        :addTo(myself_view)
        :align(display.BOTTOM_LEFT, 14, 170)

    -- 我手上的牌  这里应该是一个列表
    -- 在 GameingHandCardDeal 有处理

    -- 是否准备好了啦？
    -- 准备按钮是否显示？
    myself_view_btn_Prepare = cc.ui.UIPushButton.new(
        Imgs.gameing_btn_prepare,{scale9=false})
        --:setButtonSize(72, 100)
        -- :setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
        --  UILabelType = 2,
        --  text = "",
        --     size = Dimens.TextSize_30,
        --  color = Colors.btn_normal,
        --  }))
        -- :setButtonLabel(EnStatus.pressed, cc.ui.UILabel.new({
        --  UILabelType = 2,
        --  text = "",
        --  size = Dimens.TextSize_30,
        --  color = Colors.btn_press,
        --  }))
        :setButtonImage(EnStatus.disabled, Imgs.gameing_user_prepare_ok)
        :setButtonImage(EnStatus.pressed, Imgs.gameing_btn_prepare_press)
        :onButtonClicked(function(e)

            --游戏准备
            VoiceDealUtil:playSound_other(Voices.file.ui_click)
            SocketRequestGameing:gameing_Prepare()
            GameingScene:myViewReset_thisDesktop()

        end)
        :align(display.CENTER, display.cx, osHeight-508)
        -- :addTo(myself_view)
        :addTo(Layer1, CEnum.ZOrder.gameingView_myself_voice)
        :hide()

    -- 我的倒计时
    myself_view_timer = cc.ui.UIPushButton.new(
        Imgs.gameing_user_time_bg,{scale9=false})
        :setButtonSize(50, 54)
        :setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
            UILabelType = 2,
            text = "" .. CVar._static.clockWiseTime,
            size = Dimens.TextSize_25,
            color = Colors:_16ToRGB(Colors.gameing_time),
            font = Fonts.Font_hkyt_w7,
            }))
        -- :setButtonLabel(EnStatus.pressed, cc.ui.UILabel.new({
        --  UILabelType = 2,
        --  text = "",
        --  size = Dimens.TextSize_30,
        --  color = Colors.btn_press,
        --  }))
        --:setButtonImage(EnStatus.pressed, Imgs.home_btn_back_press)
        --:onButtonClicked(function(e)
        --end)
        :align(display.LEFT_TOP, 162+20, 175-40-35)
        :addTo(myself_view)
        :setVisible(false)

    -- 中间摸到的牌  底框
    -- 打出来的牌   底框
    -- Imgs.gameing_mid_mopai_bg
    -- Imgs.gameing_mid_chupai_bg
    myself_view_mo_chu_pai_bg = cc.ui.UIPushButton.new(Imgs.gameing_mid_mopai_bg,{scale9=false})
        :align(display.CENTER_TOP, display.cx, osHeight-170-18)
        :addTo(myself_view)
        :setVisible(false)
    -- 实际的牌
    myself_view_mo_chu_pai = cc.ui.UIPushButton.new(Imgs.card_mid_ns1,{scale9=false})
        :align(display.CENTER_TOP, display.cx, osHeight-170-18-9)
        :addTo(myself_view)
        :setVisible(false)
        
    -- 邀请好友
    myself_view_invite = cc.ui.UIPushButton.new(Imgs.gameing_btn_invite,{scale9=false})
        :setButtonImage(EnStatus.pressed, Imgs.gameing_btn_invite_press)
        :align(display.CENTER_TOP, display.cx, osHeight-332)
        :addTo(myself_view)
        :onButtonClicked(function(e)

            VoiceDealUtil:playSound_other(Voices.file.ui_click)

            if players_havePerson ~= nil and players_havePerson==2 then
                myself_invite_title = " "..CEnum.shareTitle._2 -- 二缺一
            else
                myself_invite_title = " "..CEnum.shareTitle._1 -- 一缺二  
            end

            local _title = Strings.app_name.." 房间号["..CVar._static.roomNo.."] " ..myself_invite_title
            local _content =                  "房间号["..CVar._static.roomNo.."]，"..myself_invite_content ..myself_invite_title.. "，速度来玩！"
            Commons:printLog_Req("====分享的_title是：", _title, '\n')
            Commons:printLog_Req("====分享的_content是：", _content, '\n')

            Commons:gotoShareWX(_title, _content)

        end)
        :setVisible(true)
    cc.ui.UIPushButton.new(
        Imgs.gameing_btn_copy_nor,{scale9=false})
        :setButtonImage(EnStatus.pressed, Imgs.gameing_btn_copy_pre)
        :onButtonClicked(function(e)

            VoiceDealUtil:playSound_other(Voices.file.ui_click)
        
        	if players_havePerson ~= nil and players_havePerson==2 then
                myself_invite_title = " "..CEnum.shareTitle._2 -- 二缺一
            else
                myself_invite_title = " "..CEnum.shareTitle._1 -- 一缺二  
            end

            local _content = "房间号["..CVar._static.roomNo.."]，"..myself_invite_content ..myself_invite_title.. "，速度来玩！"
            local function CDAlertIP_CopyTxt_CallbackLua(txt)
                CDAlert.new():popDialogBox(self.pop_window, txt)
            end
            Commons:gotoCopyContent(CDAlertIP_CopyTxt_CallbackLua, _content)

        end)
        :align(display.CENTER, 0, 40)
        :addTo(myself_view_invite)

    -- 可以吃，碰，过，胡才有的集合
    myself_view_needOption_list = 
        -- cc.ui.UIPageView.new({
        --     viewRect = cc.rect(0, 0, 190*7, 132),
        --     column = 7,
        --     row = 1, 
        --     padding = {left = 66, right = 66, top = 0, bottom = 66},
        --     columnSpace=33,
        --     rowSpace=0,
        --     --bgColor = cc.c4b(200, 200, 200, 255),
        --     bCirc = false
        -- })
        cc.ui.UIListView.new({
            -- bg = Imgs.gameing_dcard_select_pallet,
            --bgStartColor = cc.c4b(255,64,64,150),
            --bgEndColor = cc.c4b(0,0,0,150),
            -- bgColor = cc.c4b(200, 200, 200, 150),
            --bgColor = Colors.btn_bg,
            bgScale9 = true,
            capInsets = cc.rect(0, 0, 150*7, 132),
            viewRect = cc.rect(0, 0, 150*7, 132),
            -- direction = cc.ui.UIScrollView.DIRECTION_VERTICAL, -- 竖着摆放
            direction = cc.ui.UIScrollView.DIRECTION_HORIZONTAL, -- 水平摆放
            alignment = cc.ui.UIListView.ALIGNMENT_VCENTER
        })
        :addTo(myself_view)
        --:align(display.CENTER_TOP, display.cx-275, osHeight-105)
        :align(display.CENTER, display.cx-150*7/2, display.cy-46-46)

    -- 表情展开按钮
    cc.ui.UIPushButton.new(
        Imgs.biaoqing_btn,{scale9=false})
        :setButtonSize(70, 70)
        -- :setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
        --     UILabelType = 2,
        --     text = "" .. CVar._static.clockWiseTime,
        --     size = Dimens.TextSize_25,
        --     color = Colors:_16ToRGB(Colors.gameing_time),
        --     }))
        -- :setButtonLabel(EnStatus.pressed, cc.ui.UILabel.new({
        --  UILabelType = 2,
        --  text = "",
        --  size = Dimens.TextSize_30,
        --  color = Colors.btn_press,
        --  }))
        :setButtonImage(EnStatus.pressed, Imgs.biaoqing_btn)
        :onButtonClicked(function(e)
            VoiceDealUtil:playSound_other(Voices.file.ui_click)
            
            EmojiDialog:popDialogBox(Layer1, CEnum.pageView.gameingPhzPage)
            --local voiceLocalUrl = device.writablePath .. "flyvoice.wav"
            --print("是否完成：",VoiceDealUtil:playSound_other(voiceLocalUrl))
            --view_node_voice,view_node_voice_bg = GameingDealUtil:createVoice_Anim(myself_view, CEnum.seatNo.me, view_node_voice,view_node_voice_bg)
        end)
        --:align(display.RIGHT_BOTTOM, osWidth-10, 14 +7*2 +10+60)
        :align(display.RIGHT_BOTTOM, osWidth-20, 18)
        -- :addTo(myself_view)
        :addTo(Layer1, CEnum.ZOrder.gameingView_myself_voice)

    -- 语音展示界面相关信息
    -- 1
    voiceSpeakBg = cc.ui.UIImage.new(Imgs.hx_record_bg,{})
            -- :addTo(myself_view)
            :addTo(Layer1, CEnum.ZOrder.gameingView_myself_voice)
            :align(display.CENTER, display.cx, display.cy)
            --:setLayoutSize(osWidth, osHeight)
            :setVisible(false)
    -- 2
    voiceSpeakImg = 
    cc.ui.UIPushButton.new(
        Imgs.hx_record_animate_01,{scale9=false})
        :setButtonSize(75, 111)
        :setButtonImage(EnStatus.pressed, Imgs.hx_record_animate_01)
        :setButtonImage(EnStatus.disabled, Imgs.hx_record_animate_01)
        :setButtonEnabled(false)
        :align(display.CENTER, display.cx, display.cy+10)
        -- :addTo(myself_view)
        :addTo(Layer1, CEnum.ZOrder.gameingView_myself_voice)
        :setVisible(false)
    -- display.newTTFLabel({--cc.ui.UILabel.new({
    --             --UILabelType = 2,
    --             text = Strings.gameing.noConnectServer,
    --             size = Dimens.TextSize_25,
    --             --color = Colors:_16ToRGB(Colors.gameing_jiadi_color),
    --             color = cc.c3b(23,23,24),
    --             --color = Colors.white,
    --             font = Fonts.Font_hkyt_w7,
    --             align = cc.ui.TEXT_ALIGN_CENTER,
    --             valign = cc.ui.TEXT_VALIGN_CENTER,
    --             --dimensions = cc.size(306, 96)
    --         })
    --     :align(display.CENTER, display.cx, display.cy)
    --     :addTo(myself_view)
    --     :setVisible(false)
    -- display:newNode()
    --     --:align(display.CENTER, display.cx, display.cy)
    --     :addTo(myself_view)
    --     :setVisible(false)
    -- 3
    voiceSpeakSlider = 
    -- cc.ui.UISlider.new(display.LEFT_TO_RIGHT, Imgs.Slider_Imgs_Voice, {scale9 = true, max=CVar._static.clockVoiceTime, min=0})
    --     :onSliderValueChanged(function(event)
    --     end)
    --     :setSliderSize(121, 16)
    --     :setSliderValue(CVar._static.clockVoiceTime)
    --     :align(display.CENTER, display.cx, display.cy-80)
    --     :addTo(myself_view)
    --     :setVisible(false)

    cc.ProgressTimer:create(cc.Sprite:create(Imgs.voice_slider_bg_layer))  
    :setType(cc.PROGRESS_TIMER_TYPE_BAR) -- 条形
    :setMidpoint(cc.p(0,0)) --设置起点为条形坐下方  

    -- :setType(cc.PROGRESS_TIMER_TYPE_RADIAL) -- 圆形
    -- :setReverseDirection(true) --  顺时针覆盖东西=true 
    -- :setMidpoint(cc.p(0.5,0.5)) --设置起点为条形坐下方  
    
    :setBarChangeRate(cc.p(1,0))  --设置为竖直方向  
    :setPercentage(CVar._static.clockVoiceTime) -- 设置初始进度为30  
    -- :addTo(myself_view)
    :addTo(Layer1, CEnum.ZOrder.gameingView_myself_voice)
    --:setPosition(cc.p(bloodEmptyBgSize.width/2,bloodEmptyBgSize.height/2)) 
    :align(display.CENTER, display.cx, display.cy-80)
    :setVisible(false)
    --local to1 = cc.ProgressTo:create(2, 100)
    --voiceSpeakSlider:runAction(cc.RepeatForever:create(to1))

    -- cc.ui.UILoadingBar.new({
    --     scale9 = true,
    --     capInsets = cc.rect(0,0,10,10), -- scale region
    --     image =  Imgs.voice_slider_bg_layer, -- loading bar image
    --     viewRect = cc.rect(0,0,121,16), -- set loading bar rect
    --     percent = CVar._static.clockVoiceTime, -- set loading bar percent
    --     -- direction = DIRECTION_RIGHT_TO_LEFT
    --     -- direction = DIRECTION_LEFT_TO_RIGHT -- default
    -- })
    -- :addTo(myself_view)
    -- :align(display.CENTER, display.cx, display.cy-80)
    -- :setVisible(false)

    -- 语音点击展开按钮
    voiceSpeakClickBtn = 
    cc.ui.UIPushButton.new(
        Imgs.voice_btn,{scale9=false})
        :setButtonSize(70, 70)
        -- :setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
        --     UILabelType = 2,
        --     text = "" .. CVar._static.clockWiseTime,
        --     size = Dimens.TextSize_25,
        --     color = Colors:_16ToRGB(Colors.gameing_time),
        --     }))
        -- :setButtonLabel(EnStatus.pressed, cc.ui.UILabel.new({
        --  UILabelType = 2,
        --  text = "",
        --  size = Dimens.TextSize_30,
        --  color = Colors.btn_press,
        --  }))
        :setButtonImage(EnStatus.pressed, Imgs.voice_btn)
        -- :onButtonClicked(function(e)
        -- end)
        :align(display.RIGHT_BOTTOM, osWidth-20, 18 +10+70)
        -- :addTo(myself_view)
        :addTo(Layer1, CEnum.ZOrder.gameingView_myself_voice)
        --:align(display.LEFT_BOTTOM, 0, 0)
        --:addTo(voiceSpeakClickLayer)
    --voiceSpeakClickBtn:onTouch(function() GameingScene:Dictate_TouchListener() end)
    voiceSpeakClickBtn:addNodeEventListener(cc.NODE_TOUCH_EVENT, GameingScene_Dictate_TouchListener)        
    --voiceSpeakClickBtn:registerScriptTouchHandler(function() GameingScene:Dictate_TouchListener() end)
    voiceSpeakClickBtn:setTouchEnabled(true)

    -- voiceSpeakClickLayer = 
    -- --display.newLayer()
    -- display.newColorLayer(Colors.layer_bg)
    -- --local Layer1 = display.newScale9Sprite(Imgs.gameing_bg, 0, 0, cc.size(osWidth, osHeight))
    --     --:center()
    --     :pos(osWidth-70, 90)
    --     --:align(display.CENTER, display.cx, display.cy)
    --     :addTo(myself_view)
    --     :setContentSize(100, 200)

    -- --voiceSpeakClickLayer:onTouch(function() GameingScene:Dictate_TouchListener() end)
    -- --voiceSpeakClickLayer:addNodeEventListener(cc.NODE_TOUCH_EVENT, function() GameingScene:Dictate_TouchListener() end)        
    -- voiceSpeakClickLayer:registerScriptTouchHandler(function() GameingScene:Dictate_TouchListener() end)
    -- voiceSpeakClickLayer:setTouchEnabled(true)

    -- 需要吃牌   底框  也是列表，可能有好几种吃法
    -- 在 GameingMeChiCardDeal 有处理       
end

--local Dictate_isMoveToEnd = false -- 看看是不是用户自动结束的
--local Dictate_isTimeToEnd = false -- 看看是不是时间点到了自动结束
local Dictate_y_began = 0
local Dictate_y_gap = 0
function GameingScene_Dictate_TouchListener(event)
    --dump(event, "DictateView - event:")
    --Commons:printfLog_Info("touchListener: name=%s x,y: %0.2f, %0.2f", event.name, event.x, event.y)

    if event.name == EnStatus.began or event.name == EnStatus.clicked then
        Dictate_y_began = event.y
        GameingScene:Dictate_TouchListener_Began()  
        --return onTouchBegan(x, y)
        return true
    elseif event.name == EnStatus.moved then
        -- local Dictate_y_move = event.y
        -- Dictate_y_gap = Dictate_y_move - Dictate_y_began
        -- --Commons:printLog_Info("------move 移动了多少：", Dictate_y_gap)
        -- if Dictate_y_gap >= 15 then
        --     GameingScene:Dictate_TouchListener_Move()
        -- end

        --return onTouchMoved(x, y) 
        return true 
    elseif  event.name == EnStatus.ended then
        -- local Dictate_y_move = event.y
        -- Dictate_y_gap = Dictate_y_move - Dictate_y_began
        -- if Dictate_y_gap >= 15 then
        --     -- 因为移动事件里面可能没有响应到这个，所以最后end里面  移动的太多，也算取消
        --     Commons:printLog_Info("--------------end 瞬间多少啦：：移动的太多，取消录音", Dictate_y_gap)
        --     GameingScene:Dictate_TouchListener_Move()
        -- else
            Commons:printLog_Info("--------------end 瞬间多少啦：：", Dictate_y_gap, voiceSpeakClockTime)
            if voiceSpeakClockTime <= 90 then
                Commons:printLog_Info("--------------end 瞬间多少啦：：去发送")
                GameingScene:Dictate_TouchListener_End()
            else
                Commons:printLog_Info("--------------end 瞬间多少啦：：时间不够")
                GameingScene:Dictate_TouchListener_Move()
            end
        -- end

        --return onTouchEnded(x, y) 
        return true 
    end 
end

-- 开始录音和倒计时
function GameingScene:Dictate_TouchListener_Began()

    VoiceDealUtil:stopBgMusic()
    -- if currStopMusic_init ~= nil and CEnum.musicStatus.off == currStopMusic_init then
    -- else
    --     VoiceDealUtil:pauseBgMusic()
    --     VoiceDealUtil:stopBgMusic()
    -- end
    GameState_VoiceSetting:setDataSingle(CEnum.voiceSetting.currStopMusic, CEnum.musicStatus.off)
    GameState_VoiceSetting:setDataSingle(CEnum.voiceSetting.currStopSounds, CEnum.musicStatus.off)
    -- GameState_VoiceSetting:setDataSingle(CEnum.voiceSetting.currStopVoice, CEnum.musicStatus.on)

    voiceSpeakClockTime = CVar._static.clockVoiceTime
    --voiceSpeakSlider:setSliderValue(voiceSpeakClockTime)
    voiceSpeakSlider:setPercentage(voiceSpeakClockTime)
    -- voiceSpeakSlider:setPercent(voiceSpeakClockTime)

    local function GameingScene_changeVoice()
        voiceSpeakClockTime = voiceSpeakClockTime - 1
        --voiceSpeakSlider:setSliderValue(voiceSpeakClockTime)
        voiceSpeakSlider:setPercentage(voiceSpeakClockTime)
        -- voiceSpeakSlider:setPercent(voiceSpeakClockTime)
        if voiceSpeakClockTime <= 0 then
            GameingScene:Dictate_TouchListener_End()
        end
    end
    top_schedulerID_voice = top_scheduler:scheduleScriptFunc(GameingScene_changeVoice, 0.1, false) -- **秒一次

    --if Commons.osType == CEnum.osType.W or Commons.osType == CEnum.osType.M then
    voiceSpeakBg:setVisible(true)
    --voiceSpeakImg:setVisible(true)
    voiceSpeakSlider:setVisible(true)
    --end

    Commons:gotoDictate()
end

-- move之后，强行停止
function GameingScene:Dictate_TouchListener_Move()
    -- GameState_VoiceSetting:setDataSingle(CEnum.voiceSetting.currStopSounds, CEnum.musicStatus.on)
    -- -- GameState_VoiceSetting:setDataSingle(CEnum.voiceSetting.currStopVoice, CEnum.musicStatus.on)
    if CVar._static.currStopSounds_init ~= nil and CEnum.musicStatus.off == CVar._static.currStopSounds_init then
        GameState_VoiceSetting:setDataSingle(CEnum.voiceSetting.currStopSounds, CEnum.musicStatus.off)
    else
        GameState_VoiceSetting:setDataSingle(CEnum.voiceSetting.currStopSounds, CEnum.musicStatus.on)
    end
    -- if currStopMusic_init ~= nil and CEnum.musicStatus.off == currStopMusic_init then
    --     GameState_VoiceSetting:setDataSingle(CEnum.voiceSetting.currStopMusic, CEnum.musicStatus.off)
    -- else
    --     GameState_VoiceSetting:setDataSingle(CEnum.voiceSetting.currStopMusic, CEnum.musicStatus.on)
    --     -- VoiceDealUtil:resumeBgMusic()
    --     VoiceDealUtil:playBgMusic()
    -- end

    -- 界面消失
    voiceSpeakBg:setVisible(false)
    --voiceSpeakImg:setVisible(false)
    voiceSpeakSlider:setVisible(false)

    -- 关闭倒计时
    if top_scheduler ~= nil and top_schedulerID_voice ~= nil then
        top_scheduler:unscheduleScriptEntry(top_schedulerID_voice)
        top_schedulerID_voice = nil
    end

    -- 用户自己去掉录音，需要把没有播放完的东西继续
    if Commons:checkIsNull_tableType(CVar._static.voiceWaitPlayTable) then
        for k,v in pairs(CVar._static.voiceWaitPlayTable) do
            --Commons:printLog_Info("----voice me--队列>1中选一个 要播放的东西吗？？----",k,v)
            if v ~= CEnum.seatNo.playOver then
                Commons:printLog_Info("----voice me--队列>1中选一个 可以播放的有----",k,v)
                GameingScene:downLoadVoice_toPlay(k, v)
                break
            end
        end
    end
    
    Commons:gotoDictateStop()
end

-- end之后，播放上传
function GameingScene:Dictate_TouchListener_End()
    -- 界面消失
    voiceSpeakBg:setVisible(false)
    --voiceSpeakImg:setVisible(false)
    voiceSpeakSlider:setVisible(false)

    -- 关闭倒计时
    if top_scheduler ~= nil and top_schedulerID_voice ~= nil then
        top_scheduler:unscheduleScriptEntry(top_schedulerID_voice)
        top_schedulerID_voice = nil
    end

    Layer1:performWithDelay(function ()
        -- 停止录音，也停止各项东西
        local function GameScene_DictateStop_CallbackLua(txt)
                --[[
                -- 自己也播放
                view_node_voice,view_node_voice_bg = GameingDealUtil:createVoice_Anim(myself_view, CEnum.seatNo.me, view_node_voice,view_node_voice_bg)
                
                -- local voiceLocalUrl = device.writablePath .. "flyvoice.wav"
                -- VoiceDealUtil:playSound_other(voiceLocalUrl)

                -- Layer1:performWithDelay(function ()
                local function GameScene_DictatePlay_CallbackLua(txt)
                    --print("-----------播放完成了")
                    --voiceSpeakBg:setVisible(true)
                    if view_node_voice ~= nil and (not tolua.isnull(view_node_voice)) then
                      view_node_voice:stopAllActions()
                      view_node_voice:removeFromParent()
                      view_node_voice = nil
                    end

                    -- if view_node_voice_bg ~= nil and (not tolua.isnull(view_node_voice_bg)) then
                    --   view_node_voice_bg:removeFromParent()
                    --   view_node_voice_bg = nil
                    -- end
                end
                if Commons.osType == CEnum.osType.A then
                    local _Class = CEnum.DictatePlay_Me._Class
                    local _Name = CEnum.DictatePlay_Me._Name
                    local _args = { "flyvoice.wav", GameScene_DictatePlay_CallbackLua}
                    local _sig = "(Ljava/lang/String;I)V" --传入string参数，无返回值
                    --local ok, ret = 
                    luaj.callStaticMethod(_Class, _Name, _args, _sig) --没有返回默认nil
                elseif Commons.osType == CEnum.osType.I then
                    local _Class = CEnum.DictatePlay_Me_ios._Class
                    local _Name = CEnum.DictatePlay_Me_ios._Name
                    local _args = { filePath="flyvoice.wav", listener=GameScene_DictatePlay_CallbackLua}
                    --local ok, ret = 
                    luaoc.callStaticMethod(_Class, _Name, _args) --没有返回默认nil
                end
                -- end, 1.2)
                --]]

                if Commons.osType == CEnum.osType.A then
                    -- 由于安卓机器的烂，必须线上传再播放，或者先播放在上传，只能一件一件的事情去顺序执行
                    -- 这样ios机器也同步这个做法
                    local fileNameShort = "flyvoice.wav"
                    local _seat = CEnum.seatNo.me
                    -- 上传文件给其他人听
                    ImDealUtil:uploadVoice(function(url) GameingScene:upLoadVoiceBack_ByOrder(url, fileNameShort, _seat) end, nil)

                elseif Commons.osType == CEnum.osType.I then
                    -- 上传文件给其他人听
                    ImDealUtil:uploadVoice(function(url) GameingScene:upLoadVoiceBack(url) end, nil)
                    --同时播放自己的录音
                    GameingScene:upLoadVoice_andPlayMeVoice()
                end
        end
        Commons:gotoDictateStop(GameScene_DictateStop_CallbackLua)
    end, 0.005)
end

function GameingScene:upLoadVoiceBack(RemoteUrl)
    if Commons:checkIsNull_str(RemoteUrl) then
        SocketRequestGameing:gameing_SendVoice(RemoteUrl)
    end
end

function GameingScene:upLoadVoice_andPlayMeVoice()
    ---[[
    -- 去播放 自己的录音，也放在队列中去播放
    if Commons:checkIsNull_tableType(CVar._static.voiceWaitPlayTable) then
        --所有的语音播完再出音效

            local fileNameShort = "flyvoice.wav"
            local _seat = CEnum.seatNo.me
            Commons:printLog_Info("----voice me--需要 播放信息是：", _seat, fileNameShort)
            --if status == CEnum.status.success then
                if CEnum.Environment.Current~=nil and CEnum.Environment.Current==CEnum.EnvirType.Test then
                    CVar._static.voiceWaitPlayTable[fileNameShort] = _seat
                else
                    -- 相同的东西，只是播放一遍
                    if CVar._static.voiceWaitPlayTable[fileNameShort] ~= nil and CVar._static.voiceWaitPlayTable[fileNameShort] == CEnum.seatNo.playOver then
                    else
                        CVar._static.voiceWaitPlayTable[fileNameShort] = _seat
                    end
                end
            --end
            local _sizeTable = 0
            for k,v in pairs(CVar._static.voiceWaitPlayTable) do
                if v ~= CEnum.seatNo.playOver then
                    _sizeTable = _sizeTable + 1
                end
            end
            Commons:printLog_Info("----voice me--有几个需要播放：", _sizeTable)
            --dump(CVar._static.voiceWaitPlayTable)

            if _sizeTable == 1 then
                Commons:printLog_Info("----voice me--确定 播放信息是：", _seat, fileNameShort)
                --if status == CEnum.status.success then
                    GameingScene:downLoadVoice_toPlay(fileNameShort, _seat)
                --end
            elseif _sizeTable > 1 then
                -- 队列中挑选一个去播放
                if Commons:checkIsNull_tableType(CVar._static.voiceWaitPlayTable) then
                    for k,v in pairs(CVar._static.voiceWaitPlayTable) do
                        --Commons:printLog_Info("----voice me--队列>1中选一个 要播放的东西吗？？----",k,v)
                        if v ~= CEnum.seatNo.playOver then
                            Commons:printLog_Info("----voice me--队列>1中选一个 可以播放的有----",k,v)
                            GameingScene:downLoadVoice_toPlay(k, v)
                            break
                        end
                    end
                end

            end
    end
    --]]
end

function GameingScene:upLoadVoiceBack_ByOrder(RemoteUrl, fileNameShort, _seat)
    if Commons:checkIsNull_str(RemoteUrl) then
        SocketRequestGameing:gameing_SendVoice(RemoteUrl)
    end

    ---[[
    -- 去播放 自己的录音，也放在队列中去播放
    if Commons:checkIsNull_tableType(CVar._static.voiceWaitPlayTable) then
        --所有的语音播完再出音效

            --local fileNameShort = "flyvoice.wav"
            --local _seat = CEnum.seatNo.me
            Commons:printLog_Info("----voice me--需要 播放信息是：", _seat, fileNameShort)
            --if status == CEnum.status.success then
                if CEnum.Environment.Current~=nil and CEnum.Environment.Current==CEnum.EnvirType.Test then
                    CVar._static.voiceWaitPlayTable[fileNameShort] = _seat
                else
                    -- 相同的东西，只是播放一遍
                    if CVar._static.voiceWaitPlayTable[fileNameShort] ~= nil and CVar._static.voiceWaitPlayTable[fileNameShort] == CEnum.seatNo.playOver then
                    else
                        CVar._static.voiceWaitPlayTable[fileNameShort] = _seat
                    end
                end
            --end
            local _sizeTable = 0
            for k,v in pairs(CVar._static.voiceWaitPlayTable) do
                if v ~= CEnum.seatNo.playOver then
                    _sizeTable = _sizeTable + 1
                end
            end
            Commons:printLog_Info("----voice me--有几个需要播放：", _sizeTable)
            --dump(CVar._static.voiceWaitPlayTable)

            if _sizeTable == 1 then
                Commons:printLog_Info("----voice me--确定 播放信息是：", _seat, fileNameShort)
                --if status == CEnum.status.success then
                    GameingScene:downLoadVoice_toPlay(fileNameShort, _seat)
                --end
            elseif _sizeTable > 1 then
                -- 队列中挑选一个去播放
                if Commons:checkIsNull_tableType(CVar._static.voiceWaitPlayTable) then
                    for k,v in pairs(CVar._static.voiceWaitPlayTable) do
                        --Commons:printLog_Info("----voice me--队列>1中选一个 要播放的东西吗？？----",k,v)
                        if v ~= CEnum.seatNo.playOver then
                            Commons:printLog_Info("----voice me--队列>1中选一个 可以播放的有----",k,v)
                            GameingScene:downLoadVoice_toPlay(k, v)
                            break
                        end
                    end
                end

            end
    end
    --]]
end

-- 相对自己的位置  的下一玩家
function GameingScene:xiajia_createView()
    xiajia_view = cc.NodeGrid:create();
    xiajia_view:addTo(Layer1, CEnum.ZOrder.gameingView_RL)
    xiajia_view:setVisible(false)
    
    -- 头像框
    -- display.newSprite(Imgs.gameing_user_head_bg)
    --     :align(display.RIGHT_TOP, osWidth-40, osHeight-52)
    --     :addTo(xiajia_view)
    cc.ui.UIPushButton.new(Imgs.gameing_user_head_bg,{scale9=false})
        :align(display.RIGHT_TOP, osWidth-40, osHeight-52)
        :addTo(xiajia_view)
        :onButtonClicked(function(e)
            -- CDAlertIP:popDialogBox(Layer1, user_icon_xiajia, user_nickname_xiajia, user_account_xiajia, user_ip_xiajia)
            SupEmojiDialog.new(user_icon_xiajia, user_nickname_xiajia, user_account_xiajia, user_ip_xiajia, nil, 
                        mySeatNo, currRSeatNo):addTo(Layer1, CEnum.ZOrder.common_dialog)
        end)
    -- if user_icon ~= nil and user_icon ~= "" then
    --     xiajia_view_icon = NetSpriteImg.new(user_icon, 76, 80)
    --         --:setContentSize(cc.size(100,100))
    --         --:pos(8+106/2+6,osHeight-8-100/2-8)
    --         :align(display.RIGHT_TOP,osWidth-40-6, osHeight-62-6)
    --         :addTo(xiajia_view)
    -- end

    -- 昵称
    xiajia_view_nickname = display.newTTFLabel({
            text = "",
            font = Fonts.Font_hkyt_w9,
            size = Dimens.TextSize_20,
            color = display.COLOR_WHITE,
            align = cc.ui.TEXT_ALIGN_CENTER,
            valign = cc.ui.TEXT_VALIGN_CENTER,
            dimensions = cc.size(120,25)
        })
        :addTo(xiajia_view)
        :align(display.RIGHT_TOP, osWidth-16, osHeight-52-90-8)

    -- 分数框
    display.newSprite(Imgs.gameing_user_score_bg)
        :align(display.RIGHT_TOP, osWidth-14, osHeight-52-90-34)
        :addTo(xiajia_view)
    xiajia_view_score = display.newTTFLabel({
            text = "分数:",
            font = Fonts.Font_hkyt_w9,
            size = Dimens.TextSize_18,
            --color = display.COLOR_WHITE,
            color = Colors:_16ToRGB(Colors.gameing_score),
            align = cc.ui.TEXT_ALIGN_CENTER,
            valign = cc.ui.TEXT_VALIGN_CENTER,
            dimensions = cc.size(146,50)
        })
        :addTo(xiajia_view)
        :align(display.RIGHT_TOP, osWidth-14, osHeight-52-90-28)

    -- 多少胡息
    xiajia_view_xi = display.newTTFLabel({
            text = "2  胡息",
            font = Fonts.Font_hkyt_w9,
            size = Dimens.TextSize_25,
            --color = display.COLOR_WHITE,
            color = Colors:_16ToRGB(Colors.gameing_huxi),
            align = cc.ui.TEXT_ALIGN_CENTER,
            valign = cc.ui.TEXT_VALIGN_CENTER,
            dimensions = cc.size(75,50)
        })
        :addTo(xiajia_view)
        :align(display.RIGHT_TOP, osWidth-14-100-17, osHeight-45)
    -- 是否是庄家
    xiajia_view_isBanker = cc.ui.UIImage.new(Imgs.gameing_banker,{})
        :addTo(xiajia_view)
        :align(display.RIGHT_TOP, osWidth-14-100-22, osHeight-45-40)
    -- 离线显示
    xiajia_view_offline = cc.ui.UIPushButton.new(Imgs.gameing_user_offile_R,{scale9=false})
        :align(display.RIGHT_TOP, osWidth-140+5, osHeight-82-5)
        :addTo(xiajia_view)
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

    -- 出过的牌  这里应该是一个列表
    local moveY = 0
    if CVar._static.isIphone4 then
        moveY = -30
    elseif CVar._static.isIpad then
        moveY = -30
    end
    xiajia_view_chuguo_list = 
        cc.ui.UIPageView.new({
            viewRect = cc.rect(0, 0, (card_w_out_A+1)*card_cc_out_A, card_h_out_A*card_line_out_A),
            column = card_cc_out_A,
            row = card_line_out_A, 
            padding = {left = card_w_out_A/2, right = card_w_out_A/2, top = 0, bottom = card_h_out_A/2},
            columnSpace=13,
            rowSpace=5,
            bCirc = false
        })
        :addTo(xiajia_view)
        :align(display.RIGHT_TOP, osWidth-14-100-100-42*card_cc_out_A, osHeight-45-40-22-42*2 +moveY)

    -- 本人碰、吃等等的牌  这里应该是一个列表
    xiajia_view_chiguo_list = cc.ui.UIPageView.new({
            viewRect = cc.rect(0, 0, 45*6, 45*4),
            column = 6,
            row = 4, 
            padding = {left = 20, right = 20, top = 0, bottom = 20},
            columnSpace=0,
            rowSpace=0,
            bCirc = false
        })
        :addTo(xiajia_view)
        :align(display.RIGHT_TOP, osWidth-14-45*5, osHeight-230-45*3.3 +40)
    if CEnum.Environment.gameCode == CEnum.gameType.wmq then
        -- 偎麻雀独有：
    elseif CEnum.Environment.gameCode == CEnum.gameType.chz then
        -- 扯胡子独有：
        xiajia_view_chiguo_list:align(display.RIGHT_TOP, osWidth-14-45*5, osHeight-230-45*3.3)
    end

    -- 是否准备好了啦？
    -- 准备按钮是否显示？
    xiajia_view_btn_Prepare = cc.ui.UIPushButton.new(
        Imgs.gameing_btn_prepare,{scale9=false})
        --:setButtonSize(72, 100)
        -- :setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
        --  UILabelType = 2,
        --  text = "",
        --     size = Dimens.TextSize_30,
        --  color = Colors.btn_normal,
        --  }))
        -- :setButtonLabel(EnStatus.pressed, cc.ui.UILabel.new({
        --  UILabelType = 2,
        --  text = "",
        --  size = Dimens.TextSize_30,
        --  color = Colors.btn_press,
        --  }))
        :setButtonImage(EnStatus.disabled, Imgs.gameing_user_prepare_ok)
        :setButtonImage(EnStatus.pressed, Imgs.gameing_btn_prepare_press)
        :onButtonClicked(function(e)
            --Commons:gotoLogin();
        end)
        :align(display.RIGHT_TOP, osWidth-206, osHeight-84)
        :addTo(xiajia_view)
    -- 倒计时表
    xiajia_view_timer = cc.ui.UIPushButton.new(
        Imgs.gameing_user_time_bg,{scale9=false})
        :setButtonSize(50, 54)
        :setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
            UILabelType = 2,
            text = "" .. CVar._static.clockWiseTime,
            size = Dimens.TextSize_25,
            color = Colors:_16ToRGB(Colors.gameing_time),
            font = Fonts.Font_hkyt_w7,
        }))
        -- :setButtonLabel(EnStatus.pressed, cc.ui.UILabel.new({
        --  UILabelType = 2,
        --  text = "",
        --  size = Dimens.TextSize_30,
        --  color = Colors.btn_press,
        --  }))
        --:setButtonImage(EnStatus.pressed, Imgs.home_btn_back_press)
        --:onButtonClicked(function(e)
        --end)
        :align(display.RIGHT_TOP, osWidth-14-100-50-20, osHeight-45-40-52-42)
        :addTo(xiajia_view)
        :setVisible(false)

    -- 中间摸到的牌  底框
    -- 打出来的牌   底框
    -- Imgs.gameing_mid_mopai_bg
    -- Imgs.gameing_mid_chupai_bg
    local moveX = 0
    local moveY = 0
    if CVar._static.isIphone4 then
        moveX = 120
        moveY = -65
    elseif CVar._static.isIpad then
        moveX = 120
        moveY = -65
    end
	xiajia_view_mo_chu_pai_bg = cc.ui.UIPushButton.new(Imgs.gameing_mid_mopai_bg,{scale9=false})
        :addTo(xiajia_view)
        :align(display.RIGHT_TOP, osWidth-375-41 +moveX, osHeight-84-13 +moveY)
        :setVisible(false)
    -- 实际的牌
    xiajia_view_mo_chu_pai = cc.ui.UIPushButton.new(Imgs.card_mid_ns1,{scale9=false})
        :addTo(xiajia_view)
        :align(display.RIGHT_TOP, osWidth-375-41-9 +moveX, osHeight-84-13-9 +moveY)
        :setVisible(false)
end

-- 相对自己的位置  的上一玩家，也是最后一玩家
function GameingScene:lastjia_createView()
	lastjia_view = cc.NodeGrid:create();
    lastjia_view:addTo(Layer1, CEnum.ZOrder.gameingView_RL)
    lastjia_view:setVisible(false)

    -- 头像框
    -- display.newSprite(Imgs.gameing_user_head_bg)
    --     :align(display.LEFT_TOP, 40, osHeight-52)
    --     :addTo(lastjia_view)
    cc.ui.UIPushButton.new(Imgs.gameing_user_head_bg,{scale9=false})
        :align(display.LEFT_TOP, 40, osHeight-52)
        :addTo(lastjia_view)
        :onButtonClicked(function(e)
            -- CDAlertIP:popDialogBox(Layer1, user_icon_lastjia, user_nickname_lastjia, user_account_lastjia, user_ip_lastjia)
            SupEmojiDialog.new(user_icon_lastjia, user_nickname_lastjia, user_account_lastjia, user_ip_lastjia, nil, 
                        mySeatNo, currLSeatNo):addTo(Layer1, CEnum.ZOrder.common_dialog)
        end)
    -- if user_icon ~= nil and user_icon ~= "" then
    --     lastjia_view_icon = NetSpriteImg.new(user_icon, 76, 80)
    --         --:setContentSize(cc.size(100,100))
    --         --:pos(8+106/2+6,osHeight-8-100/2-8)
    --         :align(display.LEFT_TOP,40+6, osHeight-52-6)
    --         :addTo(lastjia_view)
    -- end

    -- 昵称
    lastjia_view_nickname=display.newTTFLabel({
	        text = "",
	        font = Fonts.Font_hkyt_w9,
	        size = Dimens.TextSize_20,
	        color = display.COLOR_WHITE,
	        align = cc.ui.TEXT_ALIGN_CENTER,
	        valign = cc.ui.TEXT_VALIGN_CENTER,
	        dimensions = cc.size(120,25)
	    })
        :addTo(lastjia_view)
        :align(display.LEFT_TOP, 16, osHeight-52-90-8)

    -- 分数框
    display.newSprite(Imgs.gameing_user_score_bg)
        :align(display.LEFT_TOP, 14, osHeight-52-90-34)
        :addTo(lastjia_view)
    lastjia_view_score=display.newTTFLabel({
	        text = "分数:",
	        font = Fonts.Font_hkyt_w9,
	        size = Dimens.TextSize_18,
	        --color = display.COLOR_WHITE,
	        color = Colors:_16ToRGB(Colors.gameing_score),
	        align = cc.ui.TEXT_ALIGN_CENTER,
	        valign = cc.ui.TEXT_VALIGN_CENTER,
	        dimensions = cc.size(146,50)
	    })
        :addTo(lastjia_view)
        :align(display.LEFT_TOP, 14, osHeight-52-90-28)

    -- 多少胡息
    lastjia_view_xi=display.newTTFLabel({
	        text = "3  胡息",
	        font = Fonts.Font_hkyt_w9,
	        size = Dimens.TextSize_25,
	        --color = display.COLOR_WHITE,
	        color = Colors:_16ToRGB(Colors.gameing_huxi),
	        align = cc.ui.TEXT_ALIGN_CENTER,
	        valign = cc.ui.TEXT_VALIGN_CENTER,
	        dimensions = cc.size(75,50)
	    })
        :addTo(lastjia_view)
        :align(display.LEFT_TOP, 130, osHeight-45)
    -- 是否是庄家
    lastjia_view_isBanker=cc.ui.UIImage.new(Imgs.gameing_banker,{})
        :addTo(lastjia_view)
        :align(display.LEFT_TOP, 130+8, osHeight-45-40)
    -- 离线显示
    lastjia_view_offline = cc.ui.UIPushButton.new(Imgs.gameing_user_offile_L,{scale9=false})
        :align(display.LEFT_TOP, 140-5, osHeight-82-5)
        :addTo(lastjia_view)
        :setButtonEnabled(false)
        :setButtonLabel(EnStatus.disabled, cc.ui.UILabel.new({
            UILabelType = 2,
            text = "离线",
            font = Fonts.Font_hkyt_w7,
            size = Dimens.TextSize_20,
            color = Colors.gray,
            --color = Colors:_16ToRGB(Colors.gameing_roomNo),
            align = cc.ui.TEXT_ALIGN_CENTER,
            valign = cc.ui.TEXT_VALIGN_CENTER,
         }))
        :setVisible(false)

    -- 出过的牌  这里应该是一个列表  庄字下面
    local moveY = 0
    if CVar._static.isIphone4 then
        moveY = -30
    elseif CVar._static.isIpad then
        moveY = -30
    end
    lastjia_view_chuguo_list = 
        cc.ui.UIPageView.new({
            viewRect = cc.rect(0, 0, (card_w_out_A+1)*card_cc_out_A, card_h_out_A*card_line_out_A),
            column = card_cc_out_A,
            row = card_line_out_A, 
            padding = {left = card_w_out_A/2, right = card_w_out_A/2, top = 0, bottom = card_h_out_A/2},
            columnSpace=13,
            rowSpace=5,
            bCirc = false
        })
        :addTo(lastjia_view)
        :align(display.LEFT_TOP, 202, osHeight-45-40-22-42*2 +moveY)

    -- 本人碰、吃等等的牌  这里应该是一个列表
    lastjia_view_chiguo_list = cc.ui.UIPageView.new({
            viewRect = cc.rect(0, 0, 45*6, 45*4),
            column = 6,
            row = 4,
            padding = {left = 20, right = 20, top = 0, bottom = 20},
            columnSpace=0,
            rowSpace=0,
            bCirc = false
        })
        :addTo(lastjia_view)
        :align(display.LEFT_TOP, 14, osHeight-230-45*3.3 +40)
    if CEnum.Environment.gameCode == CEnum.gameType.wmq then
        -- 偎麻雀独有：
    elseif CEnum.Environment.gameCode == CEnum.gameType.chz then
        -- 扯胡子独有：
        lastjia_view_chiguo_list:align(display.LEFT_TOP, 14, osHeight-230-45*3.3)
    end

    -- 是否准备好了啦？
    -- 准备按钮是否显示？
    lastjia_view_btn_Prepare = cc.ui.UIPushButton.new(
        Imgs.gameing_btn_prepare,{scale9=false})
        --:setButtonSize(72, 100)
        -- :setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
        --  UILabelType = 2,
        --  text = "",
        --     size = Dimens.TextSize_30,
        --  color = Colors.btn_normal,
        --  }))
        -- :setButtonLabel(EnStatus.pressed, cc.ui.UILabel.new({
        --  UILabelType = 2,
        --  text = "",
        --  size = Dimens.TextSize_30,
        --  color = Colors.btn_press,
        --  }))
        :setButtonImage(EnStatus.disabled, Imgs.gameing_user_prepare_ok)
        :setButtonImage(EnStatus.pressed, Imgs.gameing_btn_prepare_press)
        :onButtonClicked(function(e)
            --Commons:gotoLogin();
        end)
        :align(display.LEFT_TOP, 214, osHeight-84)
        :addTo(lastjia_view)

    -- 倒计时表
    lastjia_view_timer=cc.ui.UIPushButton.new(
        Imgs.gameing_user_time_bg,{scale9=false})
        :setButtonSize(50, 54)
        :setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
            UILabelType = 2,
            text = "" .. CVar._static.clockWiseTime,
            size = Dimens.TextSize_25,
            color = Colors:_16ToRGB(Colors.gameing_time),
            font = Fonts.Font_hkyt_w7,
        }))
        -- :setButtonLabel(EnStatus.pressed, cc.ui.UILabel.new({
        --  UILabelType = 2,
        --  text = "",
        --  size = Dimens.TextSize_30,
        --  color = Colors.btn_press,
        --  }))
        --:setButtonImage(EnStatus.pressed, Imgs.home_btn_back_press)
        --:onButtonClicked(function(e)
        --end)
        :align(display.LEFT_TOP, 162+20, osHeight-45-40-52-42)
        :addTo(lastjia_view)
        :setVisible(false)

    -- 中间摸到的牌  底框
    -- 打出来的牌   底框
    -- Imgs.gameing_mid_mopai_bg
    -- Imgs.gameing_mid_chupai_bg
    local moveX = 0
    local moveY = 0
    if CVar._static.isIphone4 then
        moveX = -120
        moveY = -65
    elseif CVar._static.isIpad then
        moveX = -120
        moveY = -65
    end
	lastjia_view_mo_chu_pai_bg = cc.ui.UIPushButton.new(Imgs.gameing_mid_mopai_bg,{scale9=false})
        :addTo(lastjia_view)
        :align(display.LEFT_TOP, 375+36 +moveX, osHeight-84-13 +moveY)
        :setVisible(false)
    -- 实际的牌
    lastjia_view_mo_chu_pai = cc.ui.UIPushButton.new(Imgs.card_mid_ns1,{scale9=false})
        :addTo(lastjia_view)
        :align(display.LEFT_TOP, 375+36+9 +moveX, osHeight-84-13-9 +moveY)
        :setVisible(false)
end

local self_serverGprsIpCheckDialog
-- 定位按钮的显示和详细信息内容
function GameingScene:players_gprs_setViewData(res_data)
    if res_data ~= nil then
        local room = res_data--[User.Bean.room]

        -- 是否弹窗，是否显示gprs按钮
        local isShow = room[Room.Bean.isShow]
        local popDesc = room[Room.Bean.popDesc]
        local distanceType = room[Room.Bean.distanceType]
        -- local distanceA = room[Gprs.Bean.distanceA]

        if isShow == 'y' then
            if PopGprsDialog and not tolua.isnull(PopGprsDialog) then
                PopGprsDialog:removeFromParent()
            end
            if self_serverGprsIpCheckDialog and not tolua.isnull(self_serverGprsIpCheckDialog) then
                self_serverGprsIpCheckDialog:removeFromParent()
            end
            self_serverGprsIpCheckDialog = PDKServerIpCheckDialogNew.new(res_data):addTo(Layer1, CEnum.ZOrder.gameingView_myself_voice)
        end

        if distanceType~=nil and top_view_gprsBtn~=nil and not tolua.isnull(top_view_gprsBtn) then
            if distanceType==0 then
                top_view_gprsBtn:setButtonImage(EnStatus.normal, Imgs.g_th_green)
                top_view_gprsBtn:setButtonImage(EnStatus.pressed, Imgs.g_th_green)
            elseif distanceType==1 then
                top_view_gprsBtn:setButtonImage(EnStatus.normal, Imgs.g_th_yellow)
                top_view_gprsBtn:setButtonImage(EnStatus.pressed, Imgs.g_th_yellow)
            elseif distanceType==2 then
                top_view_gprsBtn:setButtonImage(EnStatus.normal, Imgs.g_th_red)
                top_view_gprsBtn:setButtonImage(EnStatus.pressed, Imgs.g_th_red)
            end
            top_view_gprsBtn:show()
        else
            -- if top_view_gprsBtn~=nil and not tolua.isnull(top_view_gprsBtn) then
            --     top_view_gprsBtn:hide()
            -- end
        end

        -- gprs信息
        GprsBean = room[Room.Bean.playerDistance]
        if PopGprsDialog and not tolua.isnull(PopGprsDialog) then
            PopGprsDialog:removeFromParent()
            PopGprsDialog = CDAlertGprs:popDialogBox(Layer1, GprsBean)
        end
    end
end

-- 玩家上线，直接去创建玩家界面
-- 下一家位置或者最后一家位置都有可能初始化出来
function GameingScene:players_info_setViewData(res_data)
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
                    mySeatNo = v[Player.Bean.seatNo] -- owerNo
                    
                    local owner = v[Player.Bean.owner]
                    if room_status then
                        top_view_dissRoom:setVisible(true)
                        top_view_backRoom:setVisible(false)
                    else
                        if owner then
                            top_view_dissRoom:setVisible(true)
                            top_view_backRoom:setVisible(false)
                        else
                            top_view_dissRoom:setVisible(false)
                            top_view_backRoom:setVisible(true)
                        end
                    end

                    break
            	end
            end
            -- if #players == 1 then
            --     players_havePerson = 1
            -- elseif #players == 2 then
            --     players_havePerson = 2
            -- elseif #players == 3 then
            --     players_havePerson = 3
            -- end
            players_havePerson = #players
        end

        if players ~= nil and type(players)=="table" then
            for k,v in pairs(players) do
            	local currNo = v[Player.Bean.seatNo] -- 当前玩家座位编号
            	local _seat = GameingDealUtil:confimSeatNo(mySeatNo, currNo) -- 确定相对位置：：0=本人位置，1=下一玩家，-1=上一玩家，最后一玩家

            	local playStatus = v[Player.Bean.playStatus] -- 游戏状态
            	--Commons:printLog_Info("playStatus=",playStatus)

                local userBO = v[Player.Bean.user]
                --Commons:printLog_Info("用户对象：：",userBO)
                local icon
                local nickname
                if userBO ~= nil then
                	icon = RequestBase:new():getStrDecode(userBO[User.Bean.icon])
                	nickname = Commons:trim(RequestBase:getStrDecode(userBO[User.Bean.nickname]) )
                end
            	local score = v[Player.Bean.score]
            	local xi = v[Player.Bean.xi]
            	local isBanker = v[Player.Bean.role]
                local netStatus = v[Player.Bean.netStatus] -- 玩家是不是在线
                local netStatus_bool = CEnum.netStatus.online == netStatus;
                local gameStatus = v[Player.Bean.gameStatus] -- 是不是小相公
                local gameStatus_bool = false
                if gameStatus ~= nil then 
                     gameStatus_bool = CEnum.gameStatus.xxg == gameStatus
                end

                if _seat == CEnum.seatNo.me then -- and netStatus_bool then -- 是本人，并且在线
                    currMySeatNo = currNo
                    if userBO ~= nil then
                        user_account = userBO[User.Bean.account]
                        user_ip = userBO[User.Bean.ip]
                    end
                    
                    -- icon不同时候，重新加载一次
                    if Commons:checkIsNull_str(user_icon) 
                        and Commons:checkIsNull_str(icon) 
                        and icon ~= user_icon then -- 两个都有值，但是不相等
                        user_icon = icon
                        if not tolua.isnull(myself_view_icon) then
                            myself_view_icon:removeFromParent()
                            myself_view_icon = nil
                        end
                        myself_view_icon = NetSpriteImg.new(icon, 76, 80)
                            :align(display.LEFT_TOP,40+6, 165-6)
                            :addTo(myself_view)
                    elseif (not Commons:checkIsNull_str(user_icon)) and Commons:checkIsNull_str(icon) then -- icon有值，第一次
                        user_icon = icon
                    	if not tolua.isnull(myself_view_icon) then
                            myself_view_icon:removeFromParent()
                            myself_view_icon = nil
                        end
                        myself_view_icon = NetSpriteImg.new(icon, 76, 80)
                            :align(display.LEFT_TOP,40+6, 165-6)
                            :addTo(myself_view)
                    end

                    -- 表情位置
                    if myself_view_emoji == nil then
                        myself_view_emoji = cc.ui.UIPushButton.new(Imgs.biaoqing_btn,{scale9=false})
                            :addTo(myself_view)
                            :align(display.LEFT_TOP, 50, 155)
                            :setVisible(false)
                    end

                    if gameStatus_bool then
                        if myself_view_xxg~=nil and (not tolua.isnull(myself_view_xxg)) then
                            myself_view_xxg:setVisible(true)
                        else
                            --myself_xxg = CEnum.gameStatus.xxg
                            VoiceDealUtil:playSound_other(Voices.file.gameing_xxg)

                            myself_view_xxg = 
                            --cc.ui.UIImage.new(Imgs.gameing_user_offile_R,{})
                            cc.ui.UIPushButton.new(Imgs.gameing_user_xxg,{scale9=false})
                                :setButtonSize(76, 76)
                                :setButtonEnabled(false)
                                -- :setButtonLabel(EnStatus.disabled, cc.ui.UILabel.new({
                                --     UILabelType = 2,
                                --     text = CEnum.gameStatus.xxgName,
                                --     font = Fonts.Font_hkyt_w7,
                                --     size = Dimens.TextSize_20,
                                --     color = Colors.gray,
                                --     --color = Colors:_16ToRGB(Colors.gameing_roomNo),
                                --     align = cc.ui.TEXT_ALIGN_CENTER,
                                --     valign = cc.ui.TEXT_VALIGN_TOP,
                                --  }))

                                :addTo(myself_view)
                                :align(display.LEFT_TOP, 50-2.5, 155+2.5)
                                :setVisible(true)
                        end
                    else
                        if myself_view_xxg~=nil and (not tolua.isnull(myself_view_xxg)) then
                            --myself_view_xxg:setVisible(false)
                            myself_view_xxg:removeFromParent()
                            myself_view_xxg = nil
                        end
                    end

                    -- 昵称赋值 
                    if Commons:checkIsNull_str(user_nickname) 
                        and Commons:checkIsNull_str(nickname) 
                        and nickname ~= user_nickname then -- 两个都有值，但是不相等
                        user_nickname = nickname
                        myself_view_nickname:setString(user_nickname)
                    elseif Commons:checkIsNull_str(user_nickname) 
                        and Commons:checkIsNull_str(nickname) 
                        and nickname == user_nickname then -- 两个都有值，相等
                        myself_view_nickname:setString(user_nickname)
                    elseif (not Commons:checkIsNull_str(user_nickname)) and Commons:checkIsNull_str(nickname) then -- nickname有值，第一次
                    	user_nickname = nickname
                    	myself_view_nickname:setString(user_nickname)
                    elseif Commons:checkIsNull_str(user_nickname) and (not Commons:checkIsNull_str(nickname)) then -- user_nickname有值，后面变化
                        myself_view_nickname:setString(user_nickname) 
                    end


                    -- 分数赋值
                    if Commons:checkIsNull_numberType(score) then
                        myself_view_score:setString(Strings.gameing.score .. score)
                        myself_view_score:setVisible(true)
                    else
                        myself_view_score:setVisible(false)
                    end

                    -- 胡息赋值
                    if Commons:checkIsNull_number(xi) then
                        myself_view_xi:setString(xi .. Strings.gameing.xi)
                        myself_view_xi:setVisible(true)
                    else
                        myself_view_xi:setVisible(false)
                    end

                    -- 是不是庄家
                    if Commons:checkIsNull_str(isBanker) and isBanker == CEnum.role.z then
                        myself_view_isBanker:setVisible(true)
                    else
                        myself_view_isBanker:setVisible(false)
                    end

                    -- 准备ok，还是需要准备
                    -- 游戏未开始，第一次默认准备好拉
                    if playStatus == CEnum.playStatus.ready then
                        myself_view_btn_Prepare:setVisible(true)
                        myself_view_btn_Prepare:setButtonEnabled(false)

                        --if CEnum.roomStatus.created == _room_status then
                        if CVar._static.appstoreSwitch == CEnum.appstoreSwitch.close then
                            myself_view_invite:setVisible(false)
                        else
                            myself_view_invite:setVisible(true)
                            if players_havePerson ~= nil and players_havePerson==3 then
                                myself_view_invite:setVisible(false)
                            end
                        end
                        --end

                        --myself_view_timer:setVisible(false) -- 倒计时  暂时不用显示
                        myself_view_xi:setVisible(false) -- 胡息  暂时不用显示
                        myself_view_isBanker:setVisible(false) -- 是不是庄家  暂时不用显示
                    elseif playStatus == CEnum.playStatus.playing then
                        myself_view_btn_Prepare:setVisible(false)
                        myself_view_invite:setVisible(false)
                    elseif playStatus == CEnum.playStatus.ended or playStatus == CEnum.playStatus.wait then
                        -- myself_view_btn_Prepare:setVisible(true)
                        if CVar._static.isNeedShowPrepareBtn then
                            myself_view_btn_Prepare:setVisible(true)
                        else
                            myself_view_btn_Prepare:setVisible(false)
                        end
                        myself_view_btn_Prepare:setButtonEnabled(true)
                        -- myself_view_invite:setVisible(false)

                        --if playStatus == CEnum.playStatus.wait then
                        if CVar._static.appstoreSwitch == CEnum.appstoreSwitch.close then
                            myself_view_invite:setVisible(false)
                        else
                            myself_view_invite:setVisible(true)
                            if players_havePerson ~= nil and players_havePerson==3 then
                                myself_view_invite:setVisible(false)
                            end
                        end                            
                        --end
                    end

                    if not netStatus_bool then -- 如果离线
                        -- 离线标识
                        -- if Commons:checkIsNull_str(nickname) then
                        --     user_nickname = nickname
                        --     myself_view_nickname:setString(Strings.gameing.offlineName .. user_nickname)
                        -- elseif Commons:checkIsNull_str(user_nickname) then
                        --     myself_view_nickname:setString(Strings.gameing.offlineName .. user_nickname)
                        -- else
                        --     myself_view_nickname:setString(Strings.gameing.offlineName)
                        -- end
                        if Commons:checkIsNull_str(user_nickname) 
                            and Commons:checkIsNull_str(nickname) 
                            and nickname ~= user_nickname then -- 两个都有值，但是不相等
                            user_nickname = nickname
                            myself_view_nickname:setString(Strings.gameing.offlineName .. user_nickname)
                        elseif Commons:checkIsNull_str(user_nickname) 
                            and Commons:checkIsNull_str(nickname) 
                            and nickname == user_nickname then -- 两个都有值，相等
                            myself_view_nickname:setString(Strings.gameing.offlineName .. user_nickname)
                        elseif (not Commons:checkIsNull_str(user_nickname)) and Commons:checkIsNull_str(nickname) then -- nickname有值，第一次
                            user_nickname = nickname
                            myself_view_nickname:setString(Strings.gameing.offlineName .. user_nickname)
                        elseif Commons:checkIsNull_str(user_nickname) and (not Commons:checkIsNull_str(nickname)) then -- user_nickname有值，后面变化
                            myself_view_nickname:setString(Strings.gameing.offlineName .. user_nickname) 
                        end
                    end

                    myself_view:setVisible(true)


                elseif _seat == CEnum.seatNo.R then -- and netStatus_bool then -- 下一玩家，并且在线
                    currRSeatNo = currNo
                    if userBO ~= nil then
                        user_account_xiajia = userBO[User.Bean.account]
                        user_ip_xiajia = userBO[User.Bean.ip]
                    end

                    -- icon不同时候，重新加载一次
                    --Commons:printLog_Info("--1---",user_icon_xiajia)
                    --Commons:printLog_Info("--2---",icon)
                    if Commons:checkIsNull_str(user_icon_xiajia) 
                        and Commons:checkIsNull_str(icon) 
                        and icon ~= user_icon_xiajia  then -- 两个都有值，但是不相等
                    	user_icon_xiajia = icon
                        if not tolua.isnull(xiajia_view_icon) then
                            xiajia_view_icon:removeFromParent()
                            xiajia_view_icon = nil
                        end
                        xiajia_view_icon = NetSpriteImg.new(icon, 76, 80)
				            :align(display.RIGHT_TOP,osWidth-40-6, osHeight-52-6)
				            :addTo(xiajia_view)
		            elseif (not Commons:checkIsNull_str(user_icon_xiajia)) and Commons:checkIsNull_str(icon) then -- icon有值，第一次
		            	user_icon_xiajia = icon
                        -- if not tolua.isnull(xiajia_view_icon) then
                        --     xiajia_view_icon:removeFromParent()
                        --     xiajia_view_icon = nil
                        -- end
                        xiajia_view_icon = NetSpriteImg.new(icon, 76, 80)
				            :align(display.RIGHT_TOP,osWidth-40-6, osHeight-52-6)
				            :addTo(xiajia_view)
                    end

                    -- 表情位置
                    if xiajia_view_emoji == nil then
                        xiajia_view_emoji = cc.ui.UIPushButton.new(Imgs.biaoqing_btn,{scale9=false})
                            :addTo(xiajia_view)
                            :align(display.RIGHT_TOP, osWidth-50, osHeight-62)
                            :setVisible(false)
                    end

                    if gameStatus_bool then
                        if xiajia_view_xxg~=nil and (not tolua.isnull(xiajia_view_xxg)) then
                            xiajia_view_xxg:setVisible(true)
                        else
                            --xiajia_xxg = CEnum.gameStatus.xxg
                            VoiceDealUtil:playSound_other(Voices.file.gameing_xxg)

                            xiajia_view_xxg = 
                            --cc.ui.UIImage.new(Imgs.gameing_user_offile_R,{})
                            cc.ui.UIPushButton.new(Imgs.gameing_user_xxg,{scale9=false})
                                :setButtonSize(76, 76)
                                :setButtonEnabled(false)
                                -- :setButtonLabel(EnStatus.disabled, cc.ui.UILabel.new({
                                --     UILabelType = 2,
                                --     text = CEnum.gameStatus.xxgName,
                                --     font = Fonts.Font_hkyt_w7,
                                --     size = Dimens.TextSize_20,
                                --     color = Colors.gray,
                                --     --color = Colors:_16ToRGB(Colors.gameing_roomNo),
                                --     align = cc.ui.TEXT_ALIGN_CENTER,
                                --     valign = cc.ui.TEXT_VALIGN_TOP,
                                --  }))

                                :addTo(xiajia_view)
                                :align(display.RIGHT_TOP, osWidth-50+2.5, osHeight-62-15+17)
                                :setVisible(true)
                        end
                    else
                        if xiajia_view_xxg~=nil and (not tolua.isnull(xiajia_view_xxg)) then
                            --xiajia_view_xxg:setVisible(false)
                            xiajia_view_xxg:removeFromParent()
                            xiajia_view_xxg = nil
                        end
                    end

                    -- 昵称赋值
                    if Commons:checkIsNull_str(user_nickname_xiajia) 
                        and Commons:checkIsNull_str(nickname) 
                        and nickname ~= user_nickname_xiajia  then -- 两个都有值，但是不相等
                    	user_nickname_xiajia = nickname
                        xiajia_view_nickname:setString(user_nickname_xiajia)
                    elseif (not Commons:checkIsNull_str(user_nickname_xiajia)) and Commons:checkIsNull_str(nickname) then -- nickname有值，第一次
                    	user_nickname_xiajia = nickname
                        xiajia_view_nickname:setString(user_nickname_xiajia)
                    elseif Commons:checkIsNull_str(user_nickname_xiajia) and (not Commons:checkIsNull_str(nickname)) then -- user_nickname有值，后面变化
                        xiajia_view_nickname:setString(user_nickname_xiajia)    
                    end

                    -- 离线标识
                    xiajia_view_offline:setVisible(false)

                    -- 分数赋值
                    if Commons:checkIsNull_numberType(score) then
                        xiajia_view_score:setString(Strings.gameing.score .. score)
                        xiajia_view_score:setVisible(true)
                    else
                        xiajia_view_score:setVisible(false)
                    end

                    -- 胡息赋值
                    if Commons:checkIsNull_number(xi) then
                        xiajia_view_xi:setString(xi .. Strings.gameing.xi)
                        xiajia_view_xi:setVisible(true)
                    else
                        xiajia_view_xi:setVisible(false)
                    end

                    -- 是不是庄家
                    if Commons:checkIsNull_str(isBanker) and isBanker == CEnum.role.z then
                        xiajia_view_isBanker:setVisible(true)
                    else
                        xiajia_view_isBanker:setVisible(false)
                    end

                    -- 准备ok，还是需要准备
                    -- 游戏未开始，第一次默认准备好拉
                    if playStatus == CEnum.playStatus.ready then
                        xiajia_view_btn_Prepare:setVisible(true)
                        xiajia_view_btn_Prepare:setButtonEnabled(false)

                        --xiajia_view_timer:setVisible(false) -- 倒计时  暂时不用显示
                        xiajia_view_xi:setVisible(false) -- 胡息  暂时不用显示
                        xiajia_view_isBanker:setVisible(false) -- 是不是庄家  暂时不用显示
                    else
                        xiajia_view_btn_Prepare:setVisible(false)
                    end

                    if not netStatus_bool then -- 如果离线
                        -- 离线标识
                        xiajia_view_offline:setVisible(true)
                    end

                    xiajia_view:setVisible(true)

                elseif _seat == CEnum.seatNo.L then -- and netStatus_bool then-- 上一玩家，也是最后一玩家,并且在线
                    currLSeatNo = currNo
                    if userBO ~= nil then
                        user_account_lastjia = userBO[User.Bean.account]
                        user_ip_lastjia = userBO[User.Bean.ip]
                    end

                	-- icon不同时候，重新加载一次
                    if Commons:checkIsNull_str(user_icon_lastjia)
                        and Commons:checkIsNull_str(icon)
                        and icon ~= user_icon_lastjia  then -- 两个都有值，但是不相等
                    	user_icon_lastjia = icon
                        if not tolua.isnull(lastjia_view_icon) then
                            lastjia_view_icon:removeFromParent()
                            lastjia_view_icon = nil
                        end
			            lastjia_view_icon = NetSpriteImg.new(icon, 76, 80)
				            :align(display.LEFT_TOP,40+6, osHeight-52-6)
				            :addTo(lastjia_view)
		            elseif (not Commons:checkIsNull_str(user_icon_lastjia)) and Commons:checkIsNull_str(icon) then -- icon有值，第一次
		            	user_icon_lastjia = icon
                        -- if not tolua.isnull(lastjia_view_icon) then
                        --     lastjia_view_icon:removeFromParent()
                        --     lastjia_view_icon = nil
                        -- end
			            lastjia_view_icon = NetSpriteImg.new(icon, 76, 80)
				            :align(display.LEFT_TOP,40+6, osHeight-52-6)
				            :addTo(lastjia_view)
                    end

                    -- 表情位置
                    if lastjia_view_emoji == nil then
                        lastjia_view_emoji = cc.ui.UIPushButton.new(Imgs.biaoqing_btn,{scale9=false})
                            :addTo(lastjia_view)
                            :align(display.LEFT_TOP, 50, osHeight-62)
                            :setVisible(false)
                    end

                    if gameStatus_bool then
                        if lastjia_view_xxg~=nil and (not tolua.isnull(lastjia_view_xxg)) then
                            lastjia_view_xxg:setVisible(true)
                        else
                            --lastjia_xxg = CEnum.gameStatus.xxg
                            VoiceDealUtil:playSound_other(Voices.file.gameing_xxg)

                            lastjia_view_xxg = 
                            --cc.ui.UIImage.new(Imgs.gameing_user_offile_R,{})
                            cc.ui.UIPushButton.new(Imgs.gameing_user_xxg,{scale9=false})
                                :setButtonSize(76, 76)
                                :setButtonEnabled(false)
                                -- :setButtonLabel(EnStatus.disabled, cc.ui.UILabel.new({
                                --     UILabelType = 2,
                                --     text = CEnum.gameStatus.xxgName,
                                --     font = Fonts.Font_hkyt_w7,
                                --     size = Dimens.TextSize_20,
                                --     color = Colors.gray,
                                --     --color = Colors:_16ToRGB(Colors.gameing_roomNo),
                                --     align = cc.ui.TEXT_ALIGN_CENTER,
                                --     valign = cc.ui.TEXT_VALIGN_TOP,
                                --  }))

                                :addTo(lastjia_view)
                                :align(display.LEFT_TOP, 50-2.5, osHeight-62-15+17)
                                :setVisible(true)
                        end
                    else
                        if lastjia_view_xxg~=nil and (not tolua.isnull(lastjia_view_xxg)) then
                            --lastjia_view_xxg:setVisible(false)
                            lastjia_view_xxg:removeFromParent()
                            lastjia_view_xxg = nil
                        end
                    end

                    -- 昵称赋值
                    if Commons:checkIsNull_str(user_nickname_lastjia) 
                        and Commons:checkIsNull_str(nickname) 
                        and nickname ~= user_nickname_lastjia  then -- 两个都有值，但是不相等
                    	user_nickname_lastjia = nickname
                        lastjia_view_nickname:setString(user_nickname_lastjia)
                    elseif (not Commons:checkIsNull_str(user_nickname_lastjia)) and Commons:checkIsNull_str(nickname) then -- nickname有值，第一次
                    	user_nickname_lastjia = nickname
                        lastjia_view_nickname:setString(user_nickname_lastjia)
                    elseif Commons:checkIsNull_str(user_nickname_lastjia) and (not Commons:checkIsNull_str(nickname)) then -- user_nickname有值，后面变化
                        lastjia_view_nickname:setString(user_nickname_lastjia)  
                    end

                    -- 离线标识
                    lastjia_view_offline:setVisible(false)

                    -- 分数赋值
                    if Commons:checkIsNull_numberType(score) then
                        lastjia_view_score:setString(Strings.gameing.score .. score)
                        lastjia_view_score:setVisible(true)
                    else
                        lastjia_view_score:setVisible(false)
                    end

                    -- 胡息赋值
                    if Commons:checkIsNull_number(xi) then
                        lastjia_view_xi:setString(xi .. Strings.gameing.xi)
                        lastjia_view_xi:setVisible(true)
                    else
                        lastjia_view_xi:setVisible(false)
                    end

                    -- 是不是庄家
                    if Commons:checkIsNull_str(isBanker) and isBanker == CEnum.role.z then
                        lastjia_view_isBanker:setVisible(true)
                    else
                        lastjia_view_isBanker:setVisible(false)
                    end

                    -- 准备ok，还是需要准备
                    -- 游戏未开始，第一次默认准备好拉
                    if playStatus == CEnum.playStatus.ready then
                        lastjia_view_btn_Prepare:setVisible(true)
                        lastjia_view_btn_Prepare:setButtonEnabled(false)

                        --lastjia_view_timer:setVisible(false) -- 倒计时  暂时不用显示
                        lastjia_view_xi:setVisible(false) -- 胡息  暂时不用显示
                        lastjia_view_isBanker:setVisible(false) -- 是不是庄家  暂时不用显示
                    else
                        lastjia_view_btn_Prepare:setVisible(false)
                    end

                    if not netStatus_bool then -- 如果离线
                        -- 离线标识
                        lastjia_view_offline:setVisible(true)
                    end

                    lastjia_view:setVisible(true)

                end
            end
        end  

        --myself_view:setVisible(true)
    end
end

-- 底牌
function GameingScene:dcard_createView()
	dcard_view = cc.NodeGrid:create();
   	dcard_view:addTo(Layer1)
    dcard_view:setVisible(false)

	-- 底牌托盘
	cc.ui.UIImage.new(Imgs.gameing_dcard_pallet,{})
        :addTo(dcard_view)
        :align(display.CENTER, display.cx, osHeight-170)

    -- 底牌托盘中牌
	cc.ui.UIImage.new(Imgs.gameing_dcard_pallet_pai,{})
        :addTo(dcard_view)
        :align(display.CENTER, display.cx, osHeight-170)

    -- 底牌所剩张数
    dcard_view_nums = display.newNode():addTo(dcard_view)
    -- = display.newTTFLabel({
	   --      text = "",
	   --      font = Fonts.Font_hkyt_w9,
	   --      size = Dimens.TextSize_40,
	   --      color = Colors:_16ToRGB(Colors.gameing_time),
	   --      align = cc.ui.TEXT_ALIGN_CENTER,
    --         valign = cc.ui.TEXT_VALIGN_CENTER,
	   --      --dimensions = cc.size(146,20)
	   --  })
	   --  :addTo(dcard_view)
	   --  :align(display.CENTER, display.cx, osHeight-170+10)
end
-- 底牌  赋值
function GameingScene:dcard_setViewData(res_data, res_cmd)
	if res_data ~= nil then
        local room = res_data--[User.Bean.room]

        --local room_status = room[Room.Bean.status]
        local diCardsNum = room[Room.Bean.diCardsNum]
        --Commons:printLog_Info("==================================",diCardsNum, type(diCardsNum))

        if Commons:checkIsNull_numberType(diCardsNum) then -- 游戏中
        	--dcard_view_nums:setString(tostring(diCardsNum))

            if dcard_view_nums~=nil and (not tolua.isnull(dcard_view_nums)) and dcard_view_nums:getChildrenCount() > 0 then
                dcard_view_nums:removeAllChildren()
            end

            -- 底牌
            --if diCardsNum > 0 then
                _string = tostring(diCardsNum)
                _size = string.len(_string)
                for i=1,_size do
                    local i_str = string.sub(_string, i, i)
                    local img_i = GameingDealUtil:getNumImg_by_round_dcard(i_str)
                    --cc.ui.UIPushButton.new(img_i,{scale9=false})
                    --    :setButtonSize(20, 20)
                    cc.ui.UIImage.new(img_i,{scale9=false})
                        :setLayoutSize(28-4, 38-10)
                        :addTo(dcard_view_nums)
                        :align(display.CENTER, display.cx+(-11*_size/2)+27*(i-1), osHeight-170+6)
                end
            --end
        end 

        if res_cmd == Sockets.cmd.gameing_Start 
            or (res_cmd == Sockets.cmd.loginRoom and diCardsNum~=nil and diCardsNum>0)
            or (res_cmd == Sockets.cmd.refreshRoom and diCardsNum~=nil and diCardsNum>0) then
            dcard_view:setVisible(true)
        end
        --if dcard_view:isVisible() then
        --    dcard_view:setVisible(true)
        --end
    end
end

-- 已经出过的牌  每位玩家
-- 已经吃、碰过的牌  每位玩家
-- 并且庄家，第一次出牌，，以后后面每次摸、出、吃、碰牌
function GameingScene:players_handCard_setViewData(res_data)
	if res_data ~= nil then
        local room = res_data--[User.Bean.room]

        --local room_status = room[Room.Bean.status]
        --local playRound = room[Room.Bean.playRound] -- 第几局
        --local rounds  = room[Room.Bean.rounds] -- 总局数
        local players = room[Room.Bean.players]

        -- 三家共用信息
        --local owerNo = nil -- 我本人的位置在哪里？
        local isChu = false -- 看看是不是三家都没有出牌拉
        local action
        local _actionNo
        local _type
        local _card
        if Commons:checkIsNull_tableType(players) then
          --   -- 找出自己的位置编号
          --   for k,v in pairs(players) do
          --   	--if v[Player.Bean.me] and CEnum.netStatus.online==v[Player.Bean.netStatus] then
        		-- if v[Player.Bean.me] then
        		-- 	owerNo = v[Player.Bean.seatNo]
          --           --mySeatNo = owerNo
          --           break
          --   	end
          --   end

            -- 判断出谁应该出牌拉
            for k,v in pairs(players) do
                if v[Player.Bean.chu] then
                    isChu = true
                    
                    local currNo = v[Player.Bean.seatNo] -- 当前玩家座位编号
                    chu_seatNo = GameingDealUtil:confimSeatNo(mySeatNo, currNo) -- 确定相对位置：：0=本人位置，1=下一玩家，-1=上一玩家，最后一玩家
                    break
                end
            end
            if not isChu then -- 没有任何一家出牌提示，就看options在谁手上
                for k,v in pairs(players) do                
                    local options = v[Player.Bean.options] -- 当前可以的操作
                    if Commons:checkIsNull_tableList(options) then
                        local currNo = v[Player.Bean.seatNo] -- 当前玩家座位编号
                        chu_seatNo = GameingDealUtil:confimSeatNo(mySeatNo, currNo) -- 确定相对位置：：0=本人位置，1=下一玩家，-1=上一玩家，最后一玩家
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
                    Commons:printLog_Info("主程序中 玩家 当前的操作是：", _type, _card, _actionNo)
                end
            end

        end

        if players ~= nil and type(players)=="table" then
            for k,v in pairs(players) do
                local action = v[Player.Bean.action] -- 当前摸或者出的牌
                if Commons:checkIsNull_tableType(action) then
                    local _actionNo = action[Player.Bean.actionNo]

                    local currNo = v[Player.Bean.seatNo] -- 当前玩家座位编号
                    local _seat = GameingDealUtil:confimSeatNo(mySeatNo, currNo) -- 确定相对位置：：0=本人位置，1=下一玩家，-1=上一玩家，最后一玩家

                    math.randomseed(tostring(os.time()):reverse():sub(1, 6)) --设置时间种子，下面随机才有用
                    if _seat == CEnum.seatNo.me then
                        -- myself_view_mo_chu_pai_bg:setName(_actionNo.."")
                        myself_view_mo_chu_pai_bg:setName(os.time().. "_" .. math.random(10,100000) )
                    elseif _seat == CEnum.seatNo.R then
                        -- xiajia_view_mo_chu_pai_bg:setName(_actionNo.."")
                        xiajia_view_mo_chu_pai_bg:setName(os.time().. "_" .. math.random(10,100000) )
                    elseif _seat == CEnum.seatNo.L then
                        -- lastjia_view_mo_chu_pai_bg:setName(_actionNo.."")
                        lastjia_view_mo_chu_pai_bg:setName(os.time().. "_" .. math.random(10,100000) )
                    end
                end
            end
        end

        if players ~= nil and type(players)=="table" then
            for k,v in pairs(players) do
            	local currNo = v[Player.Bean.seatNo] -- 当前玩家座位编号
            	local _seat = GameingDealUtil:confimSeatNo(mySeatNo, currNo) -- 确定相对位置：：0=本人位置，1=下一玩家，-1=上一玩家，最后一玩家

            	local playStatus = v[Player.Bean.playStatus] -- 游戏状态
            	--Commons:printLog_Info("playStatus=",playStatus)

            	local netStatus = v[Player.Bean.netStatus] -- 玩家是不是在线
    			local netStatus_bool = CEnum.netStatus.online == netStatus;

                -- 1 看看应该谁出牌和已经出牌的动画效果
                --myself_view_mo_chu_pai_bg:setVisible(false)
                --myself_view_mo_chu_pai:setVisible(false)
                --xiajia_view_mo_chu_pai_bg:setVisible(false)
		        -- xiajia_view_mo_chu_pai_bg:setVisible(false)
		        -- lastjia_view_mo_chu_pai_bg:setVisible(false)
		        -- lastjia_view_mo_chu_pai:setVisible(false)
                if _seat == CEnum.seatNo.me then -- and netStatus_bool then -- 本人的位置才做相应的处理 需要本人出牌，还是已经吃牌了动画
	                isMeChu = v[Player.Bean.chu] -- 服务器给的 是否出牌
	                --Commons:printLog_Info("========",isMeChu)
	               	--if isMeChu then

                    ---[[
	                local options = v[Player.Bean.options] -- 当前可以的操作
	                local action = v[Player.Bean.action] -- 当前摸或者出的牌
	                Commons:printLog_Info("====本人====当前可以的操作options：",options," 摸或者出的牌action：", action)
                    --]]

	                --local currOption = v[Player.Bean.currOption] -- 当前的操作动作
	                --local currChimobs = v[Player.Bean.currChiCombs] -- 当前吃、碰了什么牌
	                --Commons:printLog_Info("====本人====上一步已经完成的操作： 牌是：",currOption,currChimobs)

			    	GameingCurrChiCardDeal:createCurrChiCards(_seat,v,
			    		myself_view, display.CENTER, (display.cx-100), (display.cy-60), 
			    		myself_view_mo_chu_pai_bg, myself_view_mo_chu_pai,
			    		xiajia_view_mo_chu_pai_bg, xiajia_view_mo_chu_pai,
			    		lastjia_view_mo_chu_pai_bg, lastjia_view_mo_chu_pai,
			    		myself_view_chiguo_list, xiajia_view_chiguo_list, lastjia_view_chiguo_list,
			    		myself_view_chuguo_list, xiajia_view_chuguo_list, lastjia_view_chuguo_list,
                        box_chupai, isMeChu
			    		)

                    ---[[
                    -- init之后的后期玩游戏的时候，本人要做的操作
                    if isMeChu then
                        if box_chupai~= nil then
        		            -- -- 本人要出牌了，显示出牌区域  还需要 到GameingCurrChiCardDeal 进一步判断
                            -- box_chupai:setVisible(true)
                            -- 只要显示可以出牌，就出现动画
                            chu_tipimg = GameingHandCardDeal:createChupaiHint_Anim(box_chupai, chu_tipimg)
                            
                            --倒计时开始
                            GameingScene:updateTimeTickLabel(myself_view_timer)
                        end
                    else
                        if box_chupai~= nil then
                            -- 不是我出牌，隐藏出牌区域
                            box_chupai:setVisible(false)
                        end

                        if chu_seatNo == CEnum.seatNo.me then
                            --倒计时开始
                            GameingScene:updateTimeTickLabel(myself_view_timer)
                        else
                            if myself_view_timer ~= nil and not tolua.isnull(myself_view_timer) then
                                myself_view_timer:hide()
                            end
                        end 
                    end

	               	-- 本人遇到了各种情况：碰，吃，过，胡才进入这里面操作
	               	if Commons:checkIsNull_tableList(options) then
                        GameingMeChiCardDeal:createChiCards(nil) -- 消失可能操作过的吃牌
                        myself_view_needOption_list:setVisible(false) -- 中间的选择消失
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
                            if box_chupai~= nil then
                                -- 不是我出牌，隐藏出牌区域
                                box_chupai:setVisible(false)
                            end

                            -- 是否可以胡牌
                            local isMayHuPai = false
                            for cc,dd in pairs(options) do
                                if dd == CEnum.playOptions.twd 
                                    or dd == CEnum.playOptions.twc
                                    or dd == CEnum.playOptions.wd 
                                    or dd == CEnum.playOptions.wc
                                    or dd == CEnum.playOptions.hu then
                                    isMayHuPai = true
                                    break
                                end
                            end
    	               		
                            local show_options = GameingDealUtil:PageView_FillList_MeChiPeng_Select(options, 7) -- 中间区域显示 吃 碰 过 胡的操作供本人选择
    	               		-- 下面就是具体本人 吃 碰 过 胡 具体的处理，吃里面有下火的概念
    		               	myself_view_needOption_list:removeAllItems();
    	                	for kk,vv in pairs(show_options) do
                    		--Commons:printLog_Info(kk,vv)
    	                	--for i=1,7 do
    	                	--	local v = "nb3"
    							local item = myself_view_needOption_list:newItem()
    							item:setName(vv)
    							local img_vv = GameingDealUtil:getImgByOptionMid(vv)
    							local img_vv_press = GameingDealUtil:getImgByOptionMid_press(vv)
    							local content = cc.ui.UIPushButton.new(img_vv, {scale9 = false})
    								-- :setButtonSize(132, 132)
                                    :align(display.CENTER, 0 , 0)
    								:setButtonImage(EnStatus.pressed, img_vv_press)
    								:onButtonClicked(function(event)

                                        VoiceDealUtil:playSound_other(Voices.file.ui_click)

    									local optName = item:getName();
    									Commons:printLog_Info("------吃 碰 胡 过的ListView buttonclicked：",optName)

                                        if optName ~= CEnum.playOptions.chi 
                                            and optName ~= CEnum.status.def_fill then
                                            GameingMeChiCardDeal:createChiCards(nil) -- 消失可能操作过的吃牌
                                            myself_view_needOption_list:setVisible(false) -- 中间的选择消失
                                        end

    									if optName == CEnum.playOptions.chi then -- 当前吃的方案
    									--elseif optName == CEnum.playOptions.xiahuo then -- 下火方案是在吃牌里面执行出来的
                                            -- 服务器就会告知 一旦这个操作完的下一轮数据
                                            -- if isMayHuPai then
                                            --     local function gameingScene_option_giveup_OK()
                                            --         local chiDemos = v[Player.Bean.chiDemos]
                                            --         GameingMeChiCardDeal:createChiCards(chiDemos, myself_view, myself_view_needOption_list, _actionNo)
                                            --     end
                                            --     local function gameingScene_option_giveup_NO()
                                            --     end
                                            --     CDialog.new():popDialogBox(Layer1, nil, Strings.gameing.giveup_hu, gameingScene_option_giveup_OK, gameingScene_option_giveup_NO)
                                            -- else
                                                local chiDemos = v[Player.Bean.chiDemos]
                                                GameingMeChiCardDeal:createChiCards(chiDemos, myself_view, myself_view_needOption_list, _actionNo)
                                            -- end                                            

    									elseif optName == CEnum.playOptions.peng then
    										-- 服务器就会告知 一旦这个操作完的下一轮数据
                                            if isMayHuPai then
                                                local function gameingScene_option_giveup_OK()
                                                    SocketRequestGameing:gameing_Peng(_actionNo)--cardno)
                                                    -- 测试环境，模拟服务器发送信息
                                                    if CEnum.Environment.Current == CEnum.EnvirType.Test then
                                                        local resData = SocketResponseDataTest.new():res_gameing_Chi_myself_peng();
                                                        CVar._static.mSocket:tcpReceiveData(resData);
                                                    end
                                                end
                                                local function gameingScene_option_giveup_NO()
                                                    myself_view_needOption_list:setVisible(true) -- 中间的选择又出现
                                                end
                                                CDialog.new():popDialogBox(Layer1, nil, Strings.gameing.giveup_hu, gameingScene_option_giveup_OK, gameingScene_option_giveup_NO)
                                            else
                                                SocketRequestGameing:gameing_Peng(_actionNo)--cardno)
        										-- 测试环境，模拟服务器发送信息
        										if CEnum.Environment.Current == CEnum.EnvirType.Test then
        											local resData = SocketResponseDataTest.new():res_gameing_Chi_myself_peng();
                									CVar._static.mSocket:tcpReceiveData(resData);
        										end
                                            end

    										
                                        --elseif optName == CEnum.playOptions.wei then -- 偎 提 跑 等等，直接在前面就有动画效果出现拉这里不需要处理
    									--elseif optName == CEnum.playOptions.chouwei then
    									--elseif optName == CEnum.playOptions.ti then
                                        --elseif optName == CEnum.playOptions.pao then
    									--elseif optName == CEnum.playOptions.pao8 then
    										
    									elseif optName == CEnum.playOptions.hu then
    										-- 服务器就会告知 一旦这个操作完的下一轮数据
                                            SocketRequestGameing:gameing_Hu(_actionNo)--cardno)
    										-- 测试环境，模拟服务器发送信息  靠回合结束信息来显示界面

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
    										-- 服务器就会告知 一旦这个操作完的下一轮数据

                                            if isMayHuPai then
                                                local function gameingScene_option_giveup_OK()
                                                    if _type~=nil and _type~=CEnum.options.other then
                                                        SocketRequestGameing:gameing_Guo(_actionNo)
                                                    else
                                                        -- =other 此时：既不是摸牌，也不是出牌，，可能是第一下 直接就是提牌或者偎牌，那这个时候，需要走过牌这个上行动作，直接根据谁出牌，就谁可以拖拽牌打出去
                                                        
                                                        -- if isMeChu then
                                                        --     -- 可以出牌，不告知过
                                                        -- else
                                                        --     -- 不可以出牌，告知过
                                                        --     SocketRequestGameing:gameing_Guo(_actionNo)
                                                        -- end
                                                    end

                                                    -- 一旦操作 “过” 字，又需要提示出牌拉
                                                    if box_chupai~= nil and isMeChu then
                                                        -- 不是我出牌，隐藏出牌区域
                                                        box_chupai:setVisible(true)
                                                    end
                                                end
                                                local function gameingScene_option_giveup_NO()
                                                    myself_view_needOption_list:setVisible(true) -- 中间的选择又出现
                                                end
                                                CDialog.new():popDialogBox(Layer1, nil, Strings.gameing.giveup_hu, gameingScene_option_giveup_OK, gameingScene_option_giveup_NO)
                                            else
                                                if _type~=nil and _type~=CEnum.options.other then
                                                    SocketRequestGameing:gameing_Guo(_actionNo)
                                                else
                                                    -- =other 此时：既不是摸牌，也不是出牌，，可能是第一下 直接就是提牌或者偎牌，那这个时候，需要走过牌这个上行动作，直接根据谁出牌，就谁可以拖拽牌打出去
                                                    
                                                    -- if isMeChu then
                                                    --     -- 可以出牌，不告知过
                                                    -- else
                                                    --     -- 不可以出牌，告知过
                                                    --     SocketRequestGameing:gameing_Guo(_actionNo)
                                                    -- end
                                                end

                                                -- 一旦操作 “过” 字，又需要提示出牌拉
                                                if box_chupai~= nil and isMeChu then
                                                    -- 不是我出牌，隐藏出牌区域
                                                    box_chupai:setVisible(true)
                                                end
                                            end

    									end

    								end)

                                -- if vv == CEnum.playOptions.wd or vv == CEnum.playOptions.wc then
                                --     content:setButtonSize(190, 132)
                                --     :align(display.CENTER, -30 , 0)
                                -- else
                                --     content:setButtonSize(132, 132)
                                --     :align(display.CENTER, 0 , 0)
                                -- end

    							-- item:addChild(content) -- pageview的做法
                                item:setItemSize(152, 132) -- listview的做法是这样的
                                item:addContent(content)

    							myself_view_needOption_list:addItem(item) -- 添加item到列表
    						end
    						myself_view_needOption_list:reload() -- 重新加载
    						myself_view_needOption_list:setVisible(true)
                        end
                    else
                        GameingMeChiCardDeal:createChiCards(nil) -- 消失可能操作过的吃牌
                        myself_view_needOption_list:setVisible(false) -- 中间的选择消失
					end
                    --]]
                --elseif _seat == CEnum.seatNo.me and not netStatus_bool then
                -- --todo最后需要 不在线处理

               	elseif _seat == CEnum.seatNo.R then -- and netStatus_bool then -- 下一玩家
           			local isMeChu_Other = v[Player.Bean.chu] -- 服务器给的 是否出牌

			    	GameingCurrChiCardDeal:createCurrChiCards(_seat,v,
			    		xiajia_view, display.RIGHT_TOP, osWidth-375-200, osHeight-300, 
			    		myself_view_mo_chu_pai_bg, myself_view_mo_chu_pai,
			    		xiajia_view_mo_chu_pai_bg, xiajia_view_mo_chu_pai,
			    		lastjia_view_mo_chu_pai_bg, lastjia_view_mo_chu_pai,
			    		myself_view_chiguo_list, xiajia_view_chiguo_list, lastjia_view_chiguo_list,
			    		myself_view_chuguo_list, xiajia_view_chuguo_list, lastjia_view_chuguo_list,
                        box_chupai, nil
			    		)

                    if isMeChu_Other then
                        --倒计时开始
                        GameingScene:updateTimeTickLabel(xiajia_view_timer)
                    else
                        if chu_seatNo == CEnum.seatNo.R then
                            --倒计时开始
                            GameingScene:updateTimeTickLabel(xiajia_view_timer)
                        else
                            if xiajia_view_timer ~= nil and not tolua.isnull(xiajia_view_timer) then
                                xiajia_view_timer:hide()
                            end
                        end
                    end
                --elseif _seat == CEnum.seatNo.R and not netStatus_bool then
                -- --todo最后需要 不在线处理

	            elseif _seat == CEnum.seatNo.L then -- and netStatus_bool then -- 最后一玩家
           			local isMeChu_Other = v[Player.Bean.chu] -- 服务器给的 是否出牌
                    
			    	GameingCurrChiCardDeal:createCurrChiCards(_seat,v,
			    		lastjia_view, display.LEFT_TOP, 375+5, osHeight-300, 
			    		myself_view_mo_chu_pai_bg, myself_view_mo_chu_pai,
			    		xiajia_view_mo_chu_pai_bg, xiajia_view_mo_chu_pai,
			    		lastjia_view_mo_chu_pai_bg, lastjia_view_mo_chu_pai,
			    		myself_view_chiguo_list, xiajia_view_chiguo_list, lastjia_view_chiguo_list,
			    		myself_view_chuguo_list, xiajia_view_chuguo_list, lastjia_view_chuguo_list,
                        box_chupai, nil
			    		)

                    if isMeChu_Other then
                        --倒计时开始
                        GameingScene:updateTimeTickLabel(lastjia_view_timer)
                    else
                        if chu_seatNo == CEnum.seatNo.L then
                            --倒计时开始
                            GameingScene:updateTimeTickLabel(lastjia_view_timer)
                        else
                            if lastjia_view_timer ~= nil and not tolua.isnull(lastjia_view_timer) then
                                lastjia_view_timer:hide()
                            end
                        end
                    end
                --elseif _seat == CEnum.seatNo.L and not netStatus_bool then
                -- --todo最后需要 不在线处理

			    -- end 出过牌列表，吃过牌列表，碰过牌列表，偎过的牌列表、当前正在的操作，等等的效果
               	end


            end
        end
    end
end

-- 盖牌最后翻开显示
function GameingScene:players_handCard_refreshViewData(res_data)
    if res_data ~= nil then
        local room = res_data
        local players = room[Room.Bean.players]

        if players ~= nil and type(players)=="table" then
            for k,v in pairs(players) do
                local currNo = v[Player.Bean.seatNo] -- 当前玩家座位编号
                local _seat = GameingDealUtil:confimSeatNo(mySeatNo, currNo) -- 确定相对位置：：0=本人位置，1=下一玩家，-1=上一玩家，最后一玩家
                local score = v[Player.Bean.score]

                if _seat == CEnum.seatNo.me then -- and netStatus_bool then -- 本人的位置才做相应的处理 需要本人出牌，还是已经吃牌了动画

                    -- 分数赋值
                    if Commons:checkIsNull_numberType(score) then
                        if myself_view_score~=nil and (not tolua.isnull(myself_view_score)) then
                            myself_view_score:setString(Strings.gameing.score .. score)
                            myself_view_score:setVisible(true)
                        end
                    end
                    
                    GameingCurrChiCardDeal:showPlayers_ChiguoCards(_seat,v,
                        myself_view_chiguo_list,xiajia_view_chiguo_list,lastjia_view_chiguo_list
                    )

                elseif _seat == CEnum.seatNo.R then -- and netStatus_bool then -- 下一玩家

                    -- 分数赋值
                    if Commons:checkIsNull_numberType(score) then
                        if xiajia_view_score~=nil and (not tolua.isnull(xiajia_view_score)) then
                            xiajia_view_score:setString(Strings.gameing.score .. score)
                            xiajia_view_score:setVisible(true)
                        end
                    end

                    GameingCurrChiCardDeal:showPlayers_ChiguoCards(_seat,v,
                        myself_view_chiguo_list,xiajia_view_chiguo_list,lastjia_view_chiguo_list
                    )

                elseif _seat == CEnum.seatNo.L then -- and netStatus_bool then -- 最后一玩家

                    -- 分数赋值
                    if Commons:checkIsNull_numberType(score) then
                        if lastjia_view_score~=nil and (not tolua.isnull(lastjia_view_score)) then
                            lastjia_view_score:setString(Strings.gameing.score .. score)
                            lastjia_view_score:setVisible(true)
                        end
                    end

                    GameingCurrChiCardDeal:showPlayers_ChiguoCards(_seat,v,
                        myself_view_chiguo_list,xiajia_view_chiguo_list,lastjia_view_chiguo_list
                    )
                end
            end
        end

    end
end

-- 手上有的牌 如何摆放 一个pageview
function GameingScene:myself_handCard_createView_setViewData(res_data)
	local _handCardDataTable_temp = nil
    local playStatus = nil
    local currRemoveCards = nil
    --local currChiCombs = nil
    local isWang = false
    local _card

	if res_data ~= nil then
		local room = res_data--[User.Bean.room]
        --local room_status = room[Room.Bean.status]
        --local playRound = room[Room.Bean.playRound] -- 第几局
        --local rounds  = room[Room.Bean.rounds] -- 总局数
        local players = room[Room.Bean.players]
        --local _seatNO = nil -- 我本人的位置在哪里？

        if players ~= nil and type(players)=="table" then
            for k,v in pairs(players) do
            	--if v[Player.Bean.me] and CEnum.netStatus_online==v[Player.Bean.netStatus] then
        		if v[Player.Bean.me] then
        			--_seatNO = v[Player.Bean.seatNo]
                    playStatus = v[Player.Bean.playStatus]
                    _handCardDataTable_temp = v[Player.Bean.handCards]
                    currRemoveCards = v[Player.Bean.currRemoveCards]
                    changeCards = v[Player.Bean.changeCards]

                    local action = v[Player.Bean.action] -- 当前摸或者出的牌
                    if Commons:checkIsNull_tableType(action) then
                        _card = action[Player.Bean.card]
                        local _type = action[Player.Bean._type]
                        --local _actionNo = action[Player.Bean.actionNo]
                        --Commons:printLog_Info("--手牌--1 玩家 当前的操作是：", _type, _card)--, _actionNo)

                        if Commons:checkIsNull_str(_card) then
                            local _size = string.len(_card)
                            if _size >= 3 then
                                local cc = string.sub(_card, 3, _size)
                                if cc == CEnum.optionsCard.w0 then -- and _type==CEnum.options.mo then
                                    isWang = true
                                end
                            end
                        end
                    end -- 是否有王八

            	end
            end
        end 
	end

	-- 如果没有手牌或者找不到本人对象
	if _handCardDataTable_temp == nil then
		return
    else

        if bg_view ~= nil and (not tolua.isnull(bg_view) ) then
           bg_view:setVisible(true)
           --sc_view:setVisible(true)
        end

        ---[[
        -- 看看新的手牌数据是不是和已有的等同，个数上相同，只要不同，就更新UI，这样的做法简单，但是体验差
        -- 特别注意：这里还是需要获取总数的原因是：摸牌是王八，不能多次入手牌【socket重连可能发现多次同样的摸王八的手牌数据】
        local serviceData_size_all = 0
        local handData_size_all = 0
        --local handCardDataTable_temp_bijiao = {} -- 后台给的数据，组合到一个table中，去掉了多层嵌套table
        if _handCardDataTable_temp ~= nil then
            --local ii = 1
            for k,v in pairs(_handCardDataTable_temp) do
                if Commons:checkIsNull_tableList(v) then
                    serviceData_size_all = serviceData_size_all + #v
                    --for kk,vv in pairs(v) do
                    --    handCardDataTable_temp_bijiao[ii] = vv
                    --    ii = ii + 1
                    --end
                end
            end
            if _handCardDataTable ~= nil then
                for k,v in pairs(_handCardDataTable) do
                    if v ~= CEnum.status.def_fill then
                        handData_size_all = handData_size_all + 1
                    end
                end
            end
        end
        Commons:printLog_Info("111111111111======后台手牌的个数：",serviceData_size_all)
        Commons:printLog_Info("111111111111======本地手牌的个数：",handData_size_all)

        -- -- 个数上不相等的时候，看看具体多了什么，少了什么
        -- -- 直接比较手牌，比较麻烦，暂时不用这种方式
        -- if serviceData_size_all ~= handData_size_all then
        -- 	_handCardDataTable = GameingDealUtil:ScrollView_FillList(_handCardDataTable_temp, CVar._static.handCardNums)
        -- 	GameingScene:myself_handCard_create_UI() -- 重新加载手牌UI
        -- end
        --]]

        if _handCardDataTable ~= nil then
            if Commons:checkIsNull_tableList(_handCardDataTable) then

                -- 直接判断自己是不是有出牌
                -- 目前的处理方式：属性不一致的牌都可以干掉，属性完全相同牌肯定也可以干掉
                if Commons:checkIsNull_tableList(currRemoveCards) then
                    Commons:printLog_Info("+++++++++++++++++++++++++++变动数据的 有吃碰操作：")
                    CVar._static.isComeingData = CVar._static.isComeingData +1 -- 只要服务器来了数据，需要去掉牌或者修改牌

                    for kk,vv in pairs(currRemoveCards) do
                        --for kk,vv in pairs(v) do
                            local temp_vv = string.sub(vv, 3, string.len(vv))
                            for k_3,v_3 in pairs(_handCardDataTable) do
                                if v_3 ~= CEnum.status.def_fill then
                                    local temp_v3 = string.sub(v_3, 3, string.len(v_3))
                                    if temp_vv == temp_v3 then
                                        _handCardDataTable[k_3] = CEnum.status.def_fill
                                        --[[
                                            -- 直接删牌
                                            GameingHandCardDeal:myself_handcard_buildOK(nil, k_3, nil, _handCardDataTable)
                                        --]]
                                        break -- 一张张牌删除，如果去掉这个，会一下子同样的牌全部删除掉
                                    end
                                end
                            end
                        --end
                    end

                    ---[[
                    -- 上面直接删除牌有问题，所以先把值变为空值，再进行全部手牌整理
                    local _temp = {}
                    if _handCardDataTable ~= nil then
                        local size = #_handCardDataTable
                        local ii = 1
                        while ii > 0 and ii <=size do
                            local _temp2 = {}
                            if _handCardDataTable[ii+2]~=nil and _handCardDataTable[ii+2]~=CEnum.status.def_fill then
                                table.insert(_temp2, _handCardDataTable[ii+2])
                            end
                            if _handCardDataTable[ii+1]~=nil and _handCardDataTable[ii+1]~=CEnum.status.def_fill then
                                table.insert(_temp2, _handCardDataTable[ii+1])
                            end
                            if _handCardDataTable[ii+0]~=nil and _handCardDataTable[ii+0]~=CEnum.status.def_fill then
                                table.insert(_temp2, _handCardDataTable[ii+0])
                            end
                            if _temp2 ~= nil and #_temp2 ~= 0 then
                                table.insert(_temp, _temp2)
                            end
                            ii = ii + CVar._static.handRows
                        end
                        if _temp ~= nil and #_temp ~= 0 then
                            -- print("------------", #_temp)
                            _handCardDataTable = GameingDealUtil:ScrollView_FillList(_temp, CVar._static.handCardNums)
                        end
                    end
                    --]]
                    GameingScene:myself_handCard_create_UI() -- 重新加载手牌UI
                end -- currRemoveCards 不为空


                -- 判断action是不是有自摸到王八，需要加入手牌
                if isWang then
                    local i = CVar._static.handCardNums*3
                    while i>=1 do
                        Commons:printLog_Info("从高位找到最小值", i, _handCardDataTable[i]);
                        if i-1 ~= 0 and _handCardDataTable[i] == CEnum.status.def_fill then
                            --_handCardDataTable[i] = _card
                            -- 直接入牌
                            if serviceData_size_all ~= handData_size_all then
                                GameingHandCardDeal:myself_handcard_buildOK(_card, nil, i, _handCardDataTable)
                            end
                            break
                        end
                        i = i - 1;
                    end  
                    GameingScene:myself_handCard_create_UI() -- 重新加载手牌UI             
                end


                -- 直接判断是不是有牌变动了属性
                if Commons:checkIsNull_tableList(changeCards) then
                    Commons:printLog_Info("+++++++++++++++++++++++++++有变动的牌：")
                    CVar._static.isComeingData = CVar._static.isComeingData +1 -- 只要服务器来了数据，需要去掉牌或者修改牌

                    for kk,vv in pairs(changeCards) do
                        --for kk,vv in pairs(v) do
                            local temp_vv = string.sub(vv, 2, string.len(vv))
                            for k_3,v_3 in pairs(_handCardDataTable) do
                                if v_3 ~= CEnum.status.def_fill then
                                    local temp_v3 = string.sub(v_3, 2, string.len(v_3))
                                    if temp_vv == temp_v3 then
                                        -- 直接变动
                                        _handCardDataTable[k_3] = vv
                                        --break
                                    end
                                end
                            end
                        --end
                    end
                    GameingScene:myself_handCard_create_UI() -- 重新加载手牌UI
                end -- changeCards 不为空

                -- 其他情况，手牌需要做任何变化
                -- GameingScene:myself_handCard_create_UI() -- 重新加载手牌UI

                ---[[
                -- 该处理的牌都处理完了，最后比较一次牌型，如果还有不相同的，直接以服务器为主，刷新

                -- 服务器手牌
                local _handCardDataTable_temp_single = {}
                local ii = 1
                for k,v in pairs(_handCardDataTable_temp) do
                    if Commons:checkIsNull_tableList(v) then
                        for kk,vv in pairs(v) do
                            _handCardDataTable_temp_single[ii] = vv
                            ii = ii + 1
                        end
                    end
                end

                local _handCardDataTable_temp_single_string = ""
                -- for k,v in pairs(_handCardDataTable_temp_single) do
                --     print("====比较之前，服务器的牌是：",k,v)
                --     _handCardDataTable_temp_single_string = _handCardDataTable_temp_single_string .. v .. ","
                -- end
                -- print("====比较之前，服务器的牌string是：",_handCardDataTable_temp_single_string)

                if _handCardDataTable_temp_single ~= nil then
                    table.sort(_handCardDataTable_temp_single, function(a,b) return a<b end) -- 小到大
                end
                _handCardDataTable_temp_single_string = ""
                for k,v in pairs(_handCardDataTable_temp_single) do
                    --print("====比较之前，服务器的牌是 牌进行排序之后：",k,v)
                    _handCardDataTable_temp_single_string = _handCardDataTable_temp_single_string .. v .. ","
                end
                Commons:printLog_Info("====比较之前，服务器的牌string是 牌进行排序之后：",_handCardDataTable_temp_single_string)


                -- 本地手牌
                local _handCardDataTable_single = {}
                ii = 1
                for k,v in pairs(_handCardDataTable) do
                    if v ~= nil and v ~= CEnum.status.def_fill then
                        _handCardDataTable_single[ii] = v
                        ii = ii + 1
                    end
                end

                local _handCardDataTable_single_string = ""
                -- for k,v in pairs(_handCardDataTable_single) do
                --     print("====比较之前，本地的牌是：",k,v)
                --     _handCardDataTable_single_string = _handCardDataTable_single_string .. v .. ","
                -- end
                -- print("====比较之前，本地的牌string是：",_handCardDataTable_single_string)

                if _handCardDataTable_single ~= nil then
                    table.sort(_handCardDataTable_single, function(a,b) return a<b end) -- 小到大
                end
                _handCardDataTable_single_string = ""
                for k,v in pairs(_handCardDataTable_single) do
                    --print("====比较之前，本地的牌是 牌进行排序之后：",k,v)
                    _handCardDataTable_single_string = _handCardDataTable_single_string .. v .. ","
                end
                Commons:printLog_Info("====比较之前，本地的牌string是 牌进行排序之后：",_handCardDataTable_single_string)

                -- 最后字符串比较
                _handCardDataTable_temp_single = nil
                _handCardDataTable_single = nil
                if _handCardDataTable_temp_single_string ~= _handCardDataTable_single_string then
                    Commons:printLog_Info("====出现了不相同拉！！！！！---------------------")
                    CVar._static.isComeingData = CVar._static.isComeingData +1 -- 只要服务器来了数据，需要去掉牌或者修改牌
                    
                    _handCardDataTable = GameingDealUtil:ScrollView_FillList(_handCardDataTable_temp, CVar._static.handCardNums)
                    GameingScene:myself_handCard_create_UI()  -- 重新加载手牌UI
                end

                --]]


            else
                -- _handCardDataTable == nil
                _handCardDataTable = GameingDealUtil:ScrollView_FillList(_handCardDataTable_temp, CVar._static.handCardNums)
                GameingScene:myself_handCard_create_UI()  -- 重新加载手牌UI

            end 
            -- _handCardDataTable ~= nil
        else
            -- == nil
            _handCardDataTable = GameingDealUtil:ScrollView_FillList(_handCardDataTable_temp, CVar._static.handCardNums)
            GameingScene:myself_handCard_create_UI()  -- 重新加载手牌UI
        end



    end

end


--创建手上的牌
function GameingScene:myself_handCard_create_UI()
	--格子数据
    --t_data = {}
	--拖拽对象
    --t_drag = nil
    --加载ui
    GameingScene:handCard_initUI()
    GameingScene:handCard_loadDrag()
end

--[[
初始化 手上的牌 需要的组件
参数有：
@param：多少个元素
@param：宽
@param：高
--]]
function GameingScene:handCard_initUI()
    --CDAlert.new():popDialogBox(Layer1,"111")
	local column_nums = #_handCardDataTable / CVar._static.handRows
	local w = column_nums * boxSize.width
	local h = boxSize.height * CVar._static.handRows

	-- 出牌区域
	if box_chupai == nil then 
        --CDAlert.new():popDialogBox(Layer1,"222")
		box_chupai, chu_tipimg = GameingHandCardDeal:createEquipmentBox("", cc.p(0, boxSize.height*CVar._static.handRows), w, h, chu_seatNo)
        box_chupai:setVisible(false)
	    Layer1:addChild(box_chupai, CEnum.ZOrder.gameingView_myself)

        if chu_seatNo == CEnum.seatNo.me then
            -- init的时候，本人要做的操作

            --倒计时开始
            GameingScene:updateTimeTickLabel(myself_view_timer)

            box_chupai:setVisible(true)
        else
            box_chupai:setVisible(false) -- 不是我出牌，需要隐藏这个出牌区域的
        end
	end

	--我手上牌的背景层区域 背包
	if bg_view == nil then 
        --CDAlert.new():popDialogBox(Layer1,"333")
	    bg_view = cc.LayerColor:create(cc.c4b(100,100,100,0),w,h)
	    bg_view:setPosition(cc.p(130,0))
	    Layer1:addChild(bg_view, CEnum.ZOrder.gameingView_myself)
	end

	if sc_view == nil then
        --CDAlert.new():popDialogBox(Layer1,"444")
	    sc_view =  cc.ui.UIScrollView.new({
	    	viewRect = cc.rect(0,0, bg_view:getContentSize().width, bg_view:getContentSize().height), 
	    	--capInsets = cc.rect(0,0, bg_view:getContentSize().width, bg_view:getContentSize().height), 
	    	direction = 2
		})
        --sc_view:setContentSize(bg_view:getContentSize().width,bg_view:getContentSize().height)
        sc_view:setBounceable(false) -- 回弹效果去掉，就不会出现貌似滑动的效果
	    bg_view:addChild(sc_view)
	else
        --CDAlert.new():popDialogBox(Layer1,"555")
		--Commons:printLog_Info("22再来删除一遍")
        if not tolua.isnull(sc_view) then
    		sc_view:removeFromParent()
    		sc_view = nil
        end
		sc_view = cc.ui.UIScrollView.new({
			viewRect = cc.rect(0,0, bg_view:getContentSize().width, bg_view:getContentSize().height),
            --capInsets = cc.rect(0,0, bg_view:getContentSize().width, bg_view:getContentSize().height),  
			direction = 2
		})
        --sc_view:setContentSize(bg_view:getContentSize().width,bg_view:getContentSize().height)
        sc_view:setBounceable(false) -- 回弹效果去掉，就不会出现貌似滑动的效果
		bg_view:addChild(sc_view)
		--sc_view:removeAllChildren() -- 这个处理方式，有问题，加载不出来新的数据

        if t_drag then
	        --t_drag:removeDragAll()
            if not tolua.isnull(t_drag) then
	           t_drag:removeFromParent()
	        end
	    end
	end

    -- 我手上具体有多少张牌，一张张加入
    t_data = {}
    t_drag = nil
    ---[[
	for k,v in pairs(_handCardDataTable) do
        --CDAlert.new():popDialogBox(Layer1,"666")
    	-- 每个小背包
        local png = cc.LayerColor:create(cc.c4b(160,160,160,0), boxSize.width, boxSize.height)
        png:setTouchSwallowEnabled(false)
        --把layer当作精灵来处理
        png:ignoreAnchorPointForPosition(false)
        t_data[#t_data+1] = png

        --[[
        display.newTTFLabel({
	        	text = k, 
	        	--text = "",
	        	size = 30, 
	        	color = cc.c3b(100,100,100)
	    	})
            :align(display.CENTER, png:getContentSize().width/2, png:getContentSize().height/2)
            :addTo(png)
        --]]
    end
    --CDAlert.new():popDialogBox(Layer1,"777")
    sc_view:fill(t_data, {itemSize = (t_data[#t_data]):getContentSize()})
    -- sc_view:fill(t_data, {itemSize = cc.size(boxSize.width , boxSize.height+7) })
    SCROLL_HANDLER_SLIDE(sc_view)
    S_XY(sc_view:getScrollNode(), 0, sc_view:getViewRect().height-H(sc_view:getScrollNode())-0 ) -- -8 就可以让牌压下去点点，就是有点可以拖动的感觉，用户觉得不要为好
    -- sc_view:setLayoutPadding(20, 20, 20, 120)
    -- sc_view:setTouchEnabled(false)
    --]]
end

-- 加载手上的牌，可以拖拽
function GameingScene:handCard_loadDrag()
	-- 拖拽对象去掉相关属性
    -- if t_drag and (not tolua.isnull(t_drag) ) then
    --    t_drag:removeDragAll()
    --    t_drag:removeFromParent()
    -- end

    --创建拖拽对象
    t_drag = UIDrag.new()

    --支持交换拖拽
    t_drag.isExchangeModel = true
    --镜像模式
    t_drag.isISOModel = true
    t_drag:setTouchSwallowEnabled(false)

    Layer1:addChild(t_drag, CEnum.ZOrder.common_dialog)

    --让出牌区域box_chupai具备拖拽属性,设置出牌区域的属性标记tag
    t_drag:addDragItem(box_chupai):setGroup(1)
    --self.t_drag:addDragItem(self.box2):setGroup(2)
    --self.t_drag:addDragItem(self.box3):setGroup(3)
    --self.t_drag:addDragItem(self.box4):setGroup(4)
    --self.t_drag:addDragItem(self.box5):setGroup(5)

    --让手牌具备拖拽属性
    for i = 1 , #t_data do
        t_data[i]:setName(i.."") -- 设置位置标注
        t_drag:addDragItem(t_data[i]):setGroup(1000)
    end

    --牌放到手牌里
    local equList = GameingHandCardDeal:createEquipements(_handCardDataTable, isNeedAnim_HandCard)
    isNeedAnim_HandCard = false -- 发完牌就变回初始值
    
    -- t_drag:find(t_data[1]):setDragObj(equList[1])
    -- t_drag:find(t_data[2]):setDragObj(equList[2])
    -- t_drag:find(t_data[3]):setDragObj(equList[3])
    -- t_drag:find(t_data[4]):setDragObj(equList[4])
    -- t_drag:find(t_data[5]):setDragObj(equList[5])
    for k,v in pairs(equList) do
    	--Commons:printLog_Info("----完成装备有----", k, type(v:getTag()))
    	if v~=nil and v:getTag() == 1 then
	    	t_drag:find(t_data[k]):setDragObj(v)
	    	-- t_drag:find(t_data[k]):setDragObjFun(function()
		    --     local obj = v
		    --     obj:setTag(1)
		    --     return obj
		    -- end)
	    end
    end

    --拖拽前事件  false=结束后续操作
    t_drag:setOnDragUpBeforeEvent(function(currentItem,point)
        --判定是否真正的触摸到scroll的内部窗体
        if t_drag:handler_ScrollView(sc_view,point) then 
        	return false
        end

        --判断出牌区域是否可见，可见才可以拖牌出去
        if (not bg_view:isVisible()) then
            return false
        end

        -- 有些牌是不允许拖拽，也不允许打出去的
        if currentItem~=nil and currentItem.dragObj~=nil then -- currentItem 源头对象
            local name = currentItem.dragObj:getName();
            Commons:printLog_Info("拖拽前 getName:", type(name), name)
            if name ~= nil then
                local _n = string.split(name, "#")
                if type(_n)=="table" and #_n==2 then
                    local indexno = tonumber(_n[1])
                    local cardno = _n[2];
                    Commons:printLog_Info("要拖拽的牌是：", indexno, cardno)
                    --找出牌的状态
                    if Commons:checkIsNull_str(cardno) then
                        local _size = string.len(cardno)
                        if _size >= 1 then
                            local cc = string.sub(cardno, 1, 1)
                            if cc == CEnum.cardType.c then
                                return false
                            end
                        end
                    end
                end
            end
        end

        return true
    end)

    --拖拽移动
    --[[
    t_drag:setOnDragMoveEvent(function(currentItem,dragObj,worldPoint,dragPoint)
        --判定是否真正的触摸到scroll的内部窗体\
        local rect = sc_view:getViewRect()
        local lp = sc_view:convertToWorldSpace(cc.p(0,0))
        local rect = cc.rect(lp.x,lp.y,rect.width,rect.height)
        
        dragObj:setPosition(cc.p(dragPoint.x,dragPoint.y))
        
        local x = dragPoint.x
        local y = dragPoint.y
        if (dragObj:getPositionX()-dragObj:getContentSize().width/2) <= rect.x then
            x = rect.x+dragObj:getContentSize().width/2
        end
        if (dragObj:getPositionX()+dragObj:getContentSize().width/2) >= rect.x+rect.width then
            x = rect.x+rect.width-dragObj:getContentSize().width/2
        end
        if (dragObj:getPositionY()-dragObj:getContentSize().height/2) <= rect.y then
            y = rect.y+dragObj:getContentSize().height/2
        end
        if (dragObj:getPositionY()+dragObj:getContentSize().height/2) >= rect.y+rect.height then
            y = rect.y+rect.height-dragObj:getContentSize().height/2
        end
        dragObj:setPosition(cc.p(x,y))
    end)
    --]]

    --拖拽放下之前
    local indexNo 
    --local indexNo_1 -- 相邻的第一行
    --local indexNo_2 -- 相邻的第二行

    local zhihou_indexNo 
    --local zhihou_indexNo_1 -- zhihou相邻的第一行
    --local zhihou_indexNo_2 -- zhihou相邻的第二行
    t_drag:setOnDragDownBeforeEvent(function(currentItem,targetItem,point)
    	Commons:printLog_Info("---------------------放下之前")

        --判定是否真正的触摸到scroll的内部窗体
        if t_drag:handler_ScrollView(sc_view,point) then 
        	return false
        end

        if targetItem and currentItem then
        	--dump(currentItem,"放下之前 currentItem是：") -- 之前 源头对象  含有移动对象dragObj
        	--dump(targetItem,"放下之前 targetItem是：")   -- 之前 目标对象  不含有移动对象dragObj(盒子里面有东西，就会有移动对象dragObj)

        	--dump(currentItem.dragObj:getTag(),"放下之前 getTag:")
	        --Commons:printLog_Info("放下之前 getTag:", type(currentItem.dragObj:getTag()))
	        --Commons:printLog_Info("放下之前 getTag:", currentItem.dragObj:getTag())

	        --dump(currentItem.dragObj:getName(),"放下之前 getName:")
	        --Commons:printLog_Info("放下之前 getName:", type(currentItem.dragObj:getName()))
	        --Commons:printLog_Info("放下之前 getName:", currentItem.dragObj:getName())

            --手牌范围内可以随意拖放
            if targetItem:getGroup() == 1000 then
                Commons:printLog_Info("---------------------放下之前 还是在手牌区域中")
                return true
            end

            -- targetItem:getGroup() == 1
            --背包里对应的装备只能装备到指定的位置上
            if currentItem.dragObj~=nil then
                --Commons:printLog_Info("要打出牌的东西是：", currentItem.dragObj:getTag(), targetItem:getGroup())

                -- 要放牌到出牌区域  并且是我出牌  并且出牌区域可见
                -- 满足这3个条件，这个牌才可以打出去
                local isVisible_box_chupai = false
                if not tolua.isnull(box_chupai) then
                    isVisible_box_chupai = box_chupai:isVisible()
                    --Commons:printLog_Info("----::",isVisible_box_chupai)
                end

                if currentItem.dragObj:getTag()~=nil and currentItem.dragObj:getTag() == targetItem:getGroup() and isMeChu and isVisible_box_chupai then

                    -- 有些牌是可以拖拽，不允许打出去的
                    local fangxiaOK = true
                    local name = currentItem.dragObj:getName();
                    Commons:printLog_Info("放下前 getName:", type(name), name)
                    if name ~= nil then
                        local _n = string.split(name, "#")
                        if type(_n)=="table" and #_n==2 then
                            local indexno = tonumber(_n[1])
                            local cardno = _n[2];
                            Commons:printLog_Info("放下前的牌是：", indexno, cardno)
                            --找出牌的状态
                            if Commons:checkIsNull_str(cardno) then
                                local _size = string.len(cardno)
                                if _size >= 1 then
                                    local cc = string.sub(cardno, 1, 1)
                                    if cc == CEnum.cardType.b then
                                        -- 不能打出去的牌，随便拖动下，也需要重新恢复下界面布局
                                        GameingScene:myself_handCard_create_UI() -- 重新加载手牌UI
                                        fangxiaOK = false
                                    end
                                end
                            end
                        end
                    end
                    return fangxiaOK
                else
                    -- print("================随便拖动了牌。。。。。。")
                    -- 不能出牌的时候，随便拖动下，也需要重新恢复下界面布局
                    GameingScene:myself_handCard_create_UI() -- 重新加载手牌UI
                end
            end
            return false

        end

        return true
    end)

    --拖拽放下之后
    t_drag:setOnDragDownAfterEvent(function(currentItem,targetItem,point)
        Commons:printLog_Info("---------------------放下zhihou")

        --dump(currentItem,"放下zhihou currentItem是：")  -- 之后 源头对象  不含有移动对象dragObj  
        --dump(targetItem, "放下zhihou targetItem是")     -- 之后 目标对象  已经含有移动对象dragObj    
        --dump(point, "放下zhihou 坐标的是：")

        --dump(targetItem.dragBox,"放下zhihou dragBox：")
        --Commons:printLog_Info("放下zhihou dragBox:",type(targetItem.dragBox))

        --dump(targetItem.dragBox:getTag(),"放下zhihougetTag:")
        --Commons:printLog_Info("放下zhihou getTag:",type(targetItem.dragBox:getTag()))
        --Commons:printLog_Info("放下zhihou getTag:", targetItem.dragBox:getTag())

        --Commons:printLog_Info("放下zhihou targetItem.dragObj:getTag():", targetItem.dragObj:getTag())
        --Commons:printLog_Info("放下zhihou targetItem:getGroup():", targetItem:getGroup())
        
        if targetItem and currentItem then

	        --手牌区域可以随意拖放
            --Commons:printLog_Info("确定要挪动的牌Tag Group是：", targetItem.dragObj:getTag(), targetItem:getGroup())
	        if targetItem:getGroup() == 1000 then
                --Commons:printLog_Info("--currentItem空盒子的name：",currentItem.dragBox:getTag()) -- 源头对象
                --Commons:printLog_Info("--targetItem空盒子的name：",targetItem.dragBox:getTag()) -- 目标对象

                -- 目标对象 targetItem  已经有源头dragObj对象
                local cardno
                if targetItem.dragObj~=nil then
                    local name = targetItem.dragObj:getName();
                    --Commons:printLog_Info("放下之前 getName:", type(name), name)
                    if name ~= nil then
                        local _n = string.split(name, "#")
                        if type(_n)=="table" and #_n==2 then
                            indexNo = tonumber(_n[1])
                            cardno = _n[2]
                            --Commons:printLog_Info("放下zhihou的牌是：", indexNo, cardno)
                        end
                    end
                end

                -- 目标对象 targetItem
                if targetItem.dragBox~=nil then
                    local _tag = targetItem.dragBox:getName();
                    --Commons:printLog_Info("放下zhihou 目标对象 _tag值:", type(_tag), _tag)
                    if _tag ~= nil then
                        zhihou_indexNo = tonumber(_tag)
                    end
                end

                --[[
                -- 1
                -- 直接删牌 和 入牌 都进行
                -- _handCardDataTable = 
                GameingHandCardDeal:myself_handcard_buildOK(cardno, indexNo, zhihou_indexNo, _handCardDataTable)
                GameingScene:myself_handCard_create_UI() -- 重新加载手牌UI
                --]]

                ---[[
                -- 2
                -- 移动手牌数据，怕和服务器来数据并发存在处理冲突
                if _handCardDataTable then
                    local tempCurrent_HandCardData = {}
                    for k,v in pairs(_handCardDataTable) do
                        tempCurrent_HandCardData[k] = v
                    end

                    if tempCurrent_HandCardData and #tempCurrent_HandCardData>0 then
                        local tempCurrent_ComeingData = CVar._static.isComeingData
                        -- print("=================================tempCurrent_ComeingData==", tempCurrent_ComeingData)
                        local tempCurrent_backData = GameingHandCardDeal:myself_handcard_buildOK(cardno, indexNo, zhihou_indexNo, tempCurrent_HandCardData)
                        local tempCurrent_ComeingData_Finish = CVar._static.isComeingData
                        -- print("=========================tempCurrent_ComeingData_Finish==", tempCurrent_ComeingData_Finish)
                        if tempCurrent_ComeingData == tempCurrent_ComeingData_Finish then
                            -- 如果相等，那就需要这个处理
                            -- 如果不相等，说明服务器已经有最新数据，这个移动放弃处理
                            for k,v in pairs(tempCurrent_backData) do
                                _handCardDataTable[k] = v
                            end
                            tempCurrent_HandCardData = nil
                            GameingScene:myself_handCard_create_UI() -- 重新加载手牌UI
                        end
                    end
                end
                --]]

	        end

	        --背包里对应的装备只能装备到指定的位置上
            if targetItem.dragObj~=nil and isMeChu then
                -- Commons:printLog_Info("确定要打出牌的东西是：", targetItem.dragObj:getTag(), targetItem:getGroup())
                if (not tolua.isnull(targetItem.dragObj) ) and targetItem.dragObj:getTag()~=nil and targetItem.dragObj:getTag() == targetItem:getGroup()  then
                    local name = targetItem.dragObj:getName();
                    Commons:printLog_Info("放下zhihou getName:", type(name), name)

    	        	-- 放下之后，就是出牌拉：消失组件并且记录出牌记录
                    if not tolua.isnull(targetItem.dragObj) then
    	               targetItem.dragObj:removeFromParent()
    	            end
    	            -- 出牌区域  需要再次  让盒子box_chupai具备拖拽属性,设置盒子的属性标记tag
    	            t_drag:addDragItem(box_chupai):setGroup(1)

    	            -- 这里是页面变化和服务器的处理交互
    	            if name ~= nil then
    	            	local _n = string.split(name, "#")
    	            	if type(_n)=="table" and #_n==2 then
    	            		local indexNo = tonumber(_n[1])
    	            		local cardno = _n[2];
    	            		Commons:printLog_Info("要出的牌是：", indexNo, cardno)
    			            --table.remove(_handCardDataTable, indexNo)
    			            --table.insert(_handCardDataTable, indexNo, CEnum.status.def_fill)

                            VoiceDealUtil:playSound_other(Voices.file.gameing_chucard)
                            
                            _handCardDataTable[indexNo] = CEnum.status.def_fill
                            -- -- 直接删牌
                            -- _handCardDataTable = GameingHandCardDeal:myself_handcard_buildOK(nil, indexNo, nil, _handCardDataTable)
                            ---[[
                            -- 上面直接删除牌有问题，所以先把值变为空值，再进行全部手牌整理
                            local _temp = {}
                            if _handCardDataTable ~= nil then
                                local size = #_handCardDataTable
                                local ii = 1
                                while ii > 0 and ii <=size do
                                    local _temp2 = {}
                                    if _handCardDataTable[ii+2]~=nil and _handCardDataTable[ii+2]~=CEnum.status.def_fill then
                                        table.insert(_temp2, _handCardDataTable[ii+2])
                                    end
                                    if _handCardDataTable[ii+1]~=nil and _handCardDataTable[ii+1]~=CEnum.status.def_fill then
                                        table.insert(_temp2, _handCardDataTable[ii+1])
                                    end
                                    if _handCardDataTable[ii+0]~=nil and _handCardDataTable[ii+0]~=CEnum.status.def_fill then
                                        table.insert(_temp2, _handCardDataTable[ii+0])
                                    end

                                    if _temp2 ~= nil and #_temp2 ~= 0 then
                                        table.insert(_temp, _temp2)
                                    end
                                    ii = ii + CVar._static.handRows
                                end
                                if _temp ~= nil and #_temp ~= 0 then
                                    -- print("------------", #_temp)
                                    _handCardDataTable = GameingDealUtil:ScrollView_FillList(_temp, CVar._static.handCardNums)
                                end
                            end
                            --]]
                            GameingScene:myself_handCard_create_UI() -- 重新加载手牌UI


    			            SocketRequestGameing:gameing_Chu(cardno)

    						myself_view_mo_chu_pai_bg:setVisible(true)
    			            myself_view_mo_chu_pai_bg:setButtonImage(EnStatus.normal, Imgs.gameing_mid_chupai_bg)
                            myself_view_mo_chu_pai_bg:setButtonImage(EnStatus.pressed, Imgs.gameing_mid_chupai_bg)
    						myself_view_mo_chu_pai:setVisible(true)
    						local img_vv = GameingDealUtil:getImgByHandcard(CEnum.userCard.mid_chu, cardno)
    						myself_view_mo_chu_pai:setButtonImage(EnStatus.normal, img_vv)
                            myself_view_mo_chu_pai:setButtonImage(EnStatus.pressed, img_vv)

                            --播放声音
                            if Commons:checkIsNull_str(cardno) then
                                local _size = string.len(cardno)
                                if _size >= 3 then
                                    local cc = string.sub(cardno, 3, _size)
                                    VoiceDealUtil:playSound(cc)
                                    --VoiceDealUtil:playSound_other(Voices.file.gameing_sankai)
                                end
                            end

    						isMeChu = false
                            -- 我的牌出完了，隐藏出牌区域
                            box_chupai:setVisible(false)
    			        end
    		        end
    	        end

            end -- end targetItem.dragObj~=nil
	    end

    end)

end


-- 然后去建立socket连接，一旦成功，获取到相应数据，再进行页面展示
function GameingScene:createSocket()
    -- socket连接和发送消息的例子
	---[[
        if CVar._static.mSocket ~= nil then
            CVar._static.mSocket:CloseSocket()
            CVar._static.mSocket = nil
        end

        --local socks = Sockets.new()
        local SockMsg = import("app.common.net.socket.SocketMsg");
        --SockMsg:init();
        SockMsg:Connect(Sockets.connect.ip, Sockets.connect.port, function(...) GameingScene:resDataSocket(...) end)
        --self._SockMsg = SockMsg;
        CVar._static.mSocket = SockMsg
        --Commons:printLog_Info("11 发送对象===", self, self._SockMsg, CVar._static.mSocket)
    --]]
end

function GameingScene:resDataSocket(status, jsonString)
    local res_status
    local res_msg
    local res_cmd
    local res_data

    --Commons:printLog_Info("==GameingScene_resDataSocket:", jsonString)
    local receive_res_data = ParseBase:parseToJsonObj(jsonString)

    if receive_res_data~=nil then
        res_status = receive_res_data[ParseBase.status];
        res_msg = RequestBase:getStrDecode(receive_res_data[ParseBase.msg]);
        res_cmd = receive_res_data[ParseBase.cmd];
        res_data = receive_res_data[ParseBase.data];

        -- 只要有数据过来，我就改变记录这个时间点
        --isConnected_sockk_time = tonumber(os.date(CEnum.timeFormat.ymdhms) .. "")
        --isConnected_sockk_time = tonumber(socketCCC.gettime() )
        isConnected_sockk_time = os.time()

        if res_cmd ~= Sockets.cmd.gameing_Xintiao_down then
            Commons:printLog_SocketReq("==GameingScene_resDataSocket:", jsonString)
            Commons:printLog_Info("==GameingScene_resDataSocket: status", res_status)
            Commons:printLog_Info("==GameingScene_resDataSocket: msg", res_msg)
            Commons:printLog_Info("==GameingScene_resDataSocket: cmd", res_cmd)
            Commons:printLog_Info("==GameingScene_resDataSocket: data", res_data)
        else
            Commons:printLog_Info("----tt GameingScene_resDataSocket: status", res_status)
        end

        if res_cmd == nil and status == EnStatus.connected_receiveData then
            -- self.errorInfo_:setString("==== ==== 空cmd ==== ====")
            if not isMyManual then
                if CVar._static.mSocket~=nil and CVar._static.mSocket:getConnected() then
                    if topRule_view_noConnectServer ~= nil and (not tolua.isnull(topRule_view_noConnectServer)) then
                        topRule_view_noConnectServer:setString(Strings.gameing.noConnectServer..'!')
                        topRule_view_noConnectServer:setVisible(true)
                    end
                    if CEnum.Environment.Current ~= nil and CEnum.Environment.Current == CEnum.EnvirType.Http then -- 正式环境
                        -- SocketRequestGameing:loginRoom(CVar._static.Lge, CVar._static.Lat)
                        SocketRequestGameing:refreshRoom()
                    end
                else
                    GameingScene:NetIsOK_change() -- 重连
                end
            end
        end
    else
        if status == EnStatus.connected_receiveData then
            --self.errorInfo_:setString("==== ==== 空包 ==== ====")
            if not isMyManual then
                if CVar._static.mSocket~=nil and CVar._static.mSocket:getConnected() then
                    if topRule_view_noConnectServer ~= nil and (not tolua.isnull(topRule_view_noConnectServer)) then
                        topRule_view_noConnectServer:setString(Strings.gameing.noConnectServer..'?')
                        topRule_view_noConnectServer:setVisible(true)
                    end
                    if CEnum.Environment.Current ~= nil and CEnum.Environment.Current == CEnum.EnvirType.Http then -- 正式环境
                        -- SocketRequestGameing:loginRoom(CVar._static.Lge, CVar._static.Lat)
                        SocketRequestGameing:refreshRoom()
                    end
                else
                    GameingScene:NetIsOK_change() -- 重连
                end
            end
        end
    end

	if status == EnStatus.connected_succ then
		-- 连接成功，打印下返回什么数据，，同时可以给服务器上行数据拉
		Commons:printLog_Info("==connected_succ:", res_status, type(res_status))

        isConnected_sockk_nums = 1
        top_schedulerID_network_status = Nets:isNetOk()

        isMyManual = false
        if topRule_view_noConnectServer ~= nil and (not tolua.isnull(topRule_view_noConnectServer)) then
            topRule_view_noConnectServer:setVisible(false)
        end

		if CEnum.status.success == res_status then
            if loadingSpriteAnim~=nil and (not tolua.isnull(loadingSpriteAnim)) then
                loadingSpriteAnim:stopAllActions()
                loadingSpriteAnim:setVisible(false)
            end
            
            if top_view ~= nil and (not tolua.isnull(top_view)) then
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

            if CEnum.Environment.Current ~= nil and CEnum.Environment.Current == CEnum.EnvirType.Http then -- 正式环境
    			 --Commons:printLog_Info("22 发送对象===", CVar._static.mSocket)
    			 --Commons:printLog_Info("22 发送对象===", _SockMsg)
    			 --Commons:printLog_Info("22 发送对象===", self)
    			 --Commons:printLog_Info("22 发送对象===", self._SockMsg)
    			 --CVar._static.mSocket:SendSokcetDataString("ni hao")
    	    	 --self._SockMsg:SendSokcetData("hao a", 1000)
    	    	 SocketRequestGameing:loginRoom(CVar._static.Lge, CVar._static.Lat)
	    	 end
	    end

	elseif status == EnStatus.connected_fail or status == EnStatus.connected_closed then
		-- 连接失败，进行重新连接
		Commons:printLog_Info("==connected_fail or closed:", res_status, type(res_status))

        if not isMyManual then
            if topRule_view_noConnectServer ~= nil and (not tolua.isnull(topRule_view_noConnectServer)) then
                topRule_view_noConnectServer:setString(Strings.gameing.noConnectServer)
                topRule_view_noConnectServer:setVisible(true)
            end
            Layer1:performWithDelay(function () 
                GameingScene:createSocket() -- 一直重连接
            end, 1.2)
        end

	-- elseif status == EnStatus.connected_close then
	-- 	-- 连接即将关闭，需要的话，继续进行重新连接
	-- 	Commons:printLog_Info("==connected_close即将:", res_status, type(res_status))

	-- elseif status == EnStatus.connected_closed then
	-- 	-- 连接已经关闭，需要的话，继续进行重新连接
	-- 	Commons:printLog_Info("==connected_closed:", res_status, type(res_status))

	elseif status == EnStatus.connected_receiveData then
		-- 有数据来拉
        Commons:printLog_Info("==connected_data 有数据来:", res_status, type(res_status))

        if res_data ~= nil then
            local surpDlzScore = res_data[Room.Bean.surpDlzScore]
            if Commons:checkIsNull_numberType(surpDlzScore) and surpDlzScore > CEnum.isDlz.noLz then
                -- 显示总的溜子分数，并且每个玩家出分的动画显示
                myLz_bg:show()
                myLz_label:show()
                myLz_label:setString(tostring(surpDlzScore))
            else
                -- myLz_bg:hide()
                -- myLz_label:hide()
            end
        end

		if CEnum.status.success == res_status then

            -- 只要有成功数据，重连字样消失
            isMyManual = false
            if topRule_view_noConnectServer ~= nil and (not tolua.isnull(topRule_view_noConnectServer)) then
                topRule_view_noConnectServer:setVisible(false)
            end

			if res_cmd == Sockets.cmd.loginRoom or res_cmd==Sockets.cmd.refreshRoom -- 登录房间
                --or res_cmd == Sockets.cmd.gameing_playerLoginRoom -- 玩家上线
                --or res_cmd == Sockets.cmd.gameing_playerExitRoom -- 玩家下线
                or res_cmd == Sockets.cmd.gameing_Start  -- 游戏开始
                or res_cmd == Sockets.cmd.gameing_Prepare  -- 准备ok拉
            then    
                if res_cmd == Sockets.cmd.gameing_Prepare then
                    _handCardDataTable = nil
                    GameingScene:players_info_setViewData(res_data) -- 自己位置的界面组件 数值显示出来

                elseif  res_cmd == Sockets.cmd.loginRoom or res_cmd==Sockets.cmd.refreshRoom then
                    _handCardDataTable = nil

                    GameingScene:topRule_createView_setViewData(res_data)
                    GameingScene:top_setViewData(res_data)-- 顶部组件 数值显示出来
                    GameingScene:dcard_setViewData(res_data, res_cmd)-- 底牌
                    GameingScene:players_info_setViewData(res_data) -- 自己位置的界面组件 数值显示出来
                    GameingScene:myself_handCard_createView_setViewData(res_data)-- 我手上的牌   主位置
                    GameingScene:players_handCard_setViewData(res_data)-- 每位玩家 上次吃牌动画| 已经出过的牌| 已经吃、碰过的牌| 并且庄家第一次出牌

                elseif  res_cmd == Sockets.cmd.gameing_Start then
                    
                    isNeedAnim_HandCard = true

                    GameingScene:topRule_createView_setViewData(res_data)
                    GameingScene:top_setViewData(res_data)-- 顶部组件 数值显示出来
                    GameingScene:dcard_setViewData(res_data, res_cmd)-- 底牌
                    GameingScene:players_info_setViewData(res_data) -- 自己位置的界面组件 数值显示出来

                    local _tag = true
                    if res_data ~= nil then
                        -- 开局，player对象中存在逗溜子分数，说明还需要逗溜子
                        local players = res_data[Room.Bean.players]
                        if players ~= nil and type(players)=="table" then
                            for k,v in pairs(players) do
                                local dlzScore = v[Player.Bean.dlzScore]
                                if Commons:checkIsNull_numberType(dlzScore) and dlzScore > CEnum.isDlz.noLz then
                                    _tag = false
                                    GameingScene:topLz_setViewData(res_data)
                                end
                                break
                            end
                        end
                    end

                    if _tag then -- 存在逗溜子，逗玩之后再发牌
                        local cardNumAll = 21 -- 发牌的数量
                        --local timeAll = 1.825 -- 显示牌 需要等待的时间 3.175  1.825
                        if CVar._static.isIphone4 then
                            cardNumAll = 17
                            --timeAll = 1.525 -- 2.675  1.525
                        elseif CVar._static.isIpad then
                            cardNumAll = 14
                            --timeAll = 1.3 -- 2.3  1.3
                        else
                        end                        
                        VoiceDealUtil:playSound_other(Voices.file.gameing_facard)
                        DealCardAnim.new(cardNumAll):addTo(Layer1) -- 先来一个发牌动画
                        -- 动画时间需要多少秒完成，这里就多少秒后执行
                        --Layer1:performWithDelay(function()
                        --end, timeAll)

                        GameingScene:myself_handCard_createView_setViewData(res_data)-- 我手上的牌   主位置
                        GameingScene:players_handCard_setViewData(res_data)-- 每位玩家 上次吃牌动画| 已经出过的牌| 已经吃、碰过的牌| 并且庄家第一次出牌
                    end

                end
            
            elseif res_cmd == Sockets.cmd.gameing_playerLoginRoom -- 玩家上线
            then
                GameingScene:top_setViewData(res_data)-- 顶部组件 数值显示出来
                GameingScene:players_info_setViewData(res_data) -- 自己位置的界面组件 数值显示出来
                GameingScene:dcard_setViewData(res_data, res_cmd)-- 底牌
            
            elseif res_cmd == Sockets.cmd.gameing_playerExitRoom -- 玩家下线
            then
                 GameingScene:players_online_offline(res_data)

            elseif res_cmd == Sockets.cmd.gameing_playerOutRoom -- 玩家退出，游戏并没有开始过
            then
                 GameingScene:players_outRoom(res_data) 

            elseif res_cmd == Sockets.cmd.gameing_BackHaLL -- 玩家进入房间，自己点击返回大厅，需要告知服务器，是主动行为，不然离线不算
            then
                isMyManual = true -- 不能再重连
                GameingScene:backHome_OK()   

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
                GameingScene:players_info_setViewData(res_data)-- 玩家信息更新显示  每位玩家
                GameingScene:dcard_setViewData(res_data, res_cmd)-- 底牌

                -- 判断下是不是自摸王八了，自摸王八，先动画后入手牌，，其他情况，先变化手牌，后动画，再吃过，出过的牌显示
                local isWang = false
                if res_data ~= nil then
                    local room = res_data--[User.Bean.room]
                    local players = room[Room.Bean.players]
                    if Commons:checkIsNull_tableType(players) then
                        for i,v in ipairs(players) do
                            local action = v[Player.Bean.action] -- 当前摸或者出的牌
                            if Commons:checkIsNull_tableType(action) then
                                local _card = action[Player.Bean.card]
                                local _type = action[Player.Bean._type]
                                --local _actionNo = action[Player.Bean.actionNo]
                                --local isWang = false
                                if Commons:checkIsNull_str(_card) then
                                    local _size = string.len(_card)
                                    if _size >= 3 then
                                        local cc = string.sub(_card, 3, _size)
                                        if cc == CEnum.optionsCard.w0 then -- and _type==CEnum.options.mo  then
                                            isWang = true
                                        end
                                    end
                                end
                            end
                        end
                    end
                end

                if isWang then
                    GameingScene:players_handCard_setViewData(res_data)-- 每位玩家 上次吃牌动画| 已经出过的牌| 已经吃、碰过的牌| 并且庄家第一次出牌
                    Layer1:performWithDelay(function () 
                        GameingScene:myself_handCard_createView_setViewData(res_data)-- 我手上的牌   主位置
                    end, 1.3) -- 有吃牌动画和摸到王八的动画，所以这里延迟1.7秒实现手牌更新
                else
                    GameingScene:myself_handCard_createView_setViewData(res_data)-- 我手上的牌   主位置
                    GameingScene:players_handCard_setViewData(res_data)-- 每位玩家 上次吃牌动画| 已经出过的牌| 已经吃、碰过的牌| 并且庄家第一次出牌
                end

            elseif res_cmd == Sockets.cmd.dissRoom
                or res_cmd == Sockets.cmd.dissRoom_confim 
            then 
                -- 解散房间申请反馈给其他玩家  等待其他玩家确认
                if DialogView_NeedMe_ConfimDissRoom and not tolua.isnull(DialogView_NeedMe_ConfimDissRoom) then
                    DialogView_NeedMe_ConfimDissRoom:create_content(res_data)
                else
                    DialogView_NeedMe_ConfimDissRoom = CDAlertDissRoom.new(res_data):addTo(Layer1, CEnum.ZOrder.common_dialog)
                end

    		elseif res_cmd == Sockets.cmd.dissRoom_success then -- 解散房间成功反馈给所有  等待其他玩家退出游戏处理
                if res_data ~= nil then
                    local success = res_data.success
                    local descript = RequestBase:getStrDecode(res_data.descript)
                    if success then -- 大家都同意
                        isMyManual = true -- 不能再重连
                        GameingScene:dissRoomDialogExit()
        				CDialog.new():popDialogBox(Layer1, nil, descript, function() GameingScene:dissRoom_success_OK() end, nil)
                    else 
                        -- 有人拒绝
                        GameingScene:dissRoomDialogExit()
                        CDialog.new():popDialogBox(Layer1, nil, descript, function() GameingScene:dissRoom_success_NO() end, nil)
                    end
                end

            --发生ip检测2011 同时具有定位详细信息
            elseif res_cmd == Sockets.cmd.gameing_IP_check then
                if CVar._static.appstoreSwitch == CEnum.appstoreSwitch.open then
                    GameingScene:players_gprs_setViewData(res_data)
                end
			    
		    elseif res_cmd == Sockets.cmd.gameing_Over then -- 游戏结束 

                -- 去掉可能有的解散弹窗
                GameingScene:dissRoomDialogExit()

                -- 还是要更新底牌的
                GameingScene:dcard_setViewData(res_data, res_cmd)-- 底牌
                GameingScene:players_handCard_refreshViewData(res_data)-- 最后每位玩家的吃碰跑的牌明牌显示
                GameingScene:huCard_createView_setViewData(res_data) -- 胡牌  也是有效果的  --todo效果还需要完善

            elseif res_cmd == Sockets.cmd.gameing_SendEmoji then -- 表情来了
                GameingScene:emoji_createView_setViewData(res_data)
            elseif res_cmd == Sockets.cmd.gameing_SuperEmoji then -- 超级表情来了
                GameingScene:superEmojoDataHandler(res_data)

            elseif res_cmd == Sockets.cmd.gameing_SendVoice then -- 录音来了
                -- 只有开关是打开的，才允许语音自动播放
                -- local _currStopVoice = GameState_VoiceSetting:getDataSingle(CEnum.voiceSetting.currStopVoice)
                -- if _currStopVoice ~= nil and CEnum.musicStatus.on == _currStopVoice then
                    GameingScene:voice_createView_setViewData(res_data)
                -- end

            elseif res_cmd == Sockets.cmd.gameing_SendWords then -- 短语来了
                GameingScene:words_createView_setViewData(res_data)

            elseif res_cmd == Sockets.cmd.gameing_Xintiao_down then -- 心跳下行来拉
                local systime = res_data["systime"]
                --Commons:printLog_Info("----心跳时间：", systime)
                if systime ~= nil then
                    SocketRequestGameing:gameing_Xintiao_up(systime)
                end
            elseif res_cmd == Sockets.cmd.gameing_Xintiao_send then -- 心跳下行来拉
                isConnected_sockk_nums = 1
            elseif res_cmd == Sockets.cmd.gameing_ExitSocket then -- 有多处重连socket告诉上一处自动退出和关闭socket
                isMyManual = true -- 不能再重连
                GameingScene:backHome_OK()
			end
            -- status = 0
        else
            -- status ~= 0
            --Commons:printLog_Info("异常情况来拉")
            if res_cmd == Sockets.cmd.dissRoom then
                CDAlertManu.new():popDialogBox(Layer1, res_msg, true);
            elseif res_cmd == Sockets.cmd.loginRoom or res_cmd==Sockets.cmd.refreshRoom then
                CDialog.new():popDialogBox(Layer1, nil, res_msg, function() GameingScene:dissRoom_success_OK() end, nil)
            end
		end
    -- 所有接受后台socket数据

	--else -- 其他 EnStatus.connected 

	end
end

function GameingScene:dissRoomDialogExit()
    if DialogView_NeedMe_ConfimDissRoom and not tolua.isnull(DialogView_NeedMe_ConfimDissRoom) then
        DialogView_NeedMe_ConfimDissRoom:dispose()
        DialogView_NeedMe_ConfimDissRoom:removeFromParent()
        DialogView_NeedMe_ConfimDissRoom = nil
    end
end

function GameingScene:players_outRoom(res_data)
    if res_data ~= nil then
        local room = res_data--[User.Bean.room]
        local currNo = room[Player.Bean.seatNo]
        local _seat = GameingDealUtil:confimSeatNo(mySeatNo, currNo) -- 确定相对位置：：0=本人位置，1=下一玩家，-1=上一玩家，最后一玩家
        
        --Commons:printLog_Info("----位置是：", _seat)
        if _seat == CEnum.seatNo.me then
            -- 自己的位置应该不会出现这个显示

        elseif _seat == CEnum.seatNo.R then
            players_havePerson = players_havePerson - 1
            xiajia_view:setVisible(false)

        elseif _seat == CEnum.seatNo.L then
            players_havePerson = players_havePerson - 1
            lastjia_view:setVisible(false)

        end
    end
end

function GameingScene:players_online_offline(res_data)
    if res_data ~= nil then
        local room = res_data--[User.Bean.room]
        local currNo = room[Player.Bean.seatNo]
        local _seat = GameingDealUtil:confimSeatNo(mySeatNo, currNo) -- 确定相对位置：：0=本人位置，1=下一玩家，-1=上一玩家，最后一玩家
        
        --Commons:printLog_Info("----位置是：", _seat)
        if _seat == CEnum.seatNo.me then
            -- 自己的位置应该不会出现这个显示
            if Commons:checkIsNull_str(user_nickname) then
                myself_view_nickname:setString(Strings.gameing.offlineName .. user_nickname)
            else
                myself_view_nickname:setString(Strings.gameing.offlineName)
            end

        elseif _seat == CEnum.seatNo.R then
            -- if Commons:checkIsNull_str(user_nickname_xiajia) then
            --     xiajia_view_nickname:setString(Strings.gameing.offlineName .. user_nickname_xiajia)
            -- else
            --     xiajia_view_nickname:setString(Strings.gameing.offlineName)
            -- end
            xiajia_view_offline:setVisible(true)
            VoiceDealUtil:playSound_other(Voices.file.gameing_sankai)

        elseif _seat == CEnum.seatNo.L then
            -- if Commons:checkIsNull_str(user_nickname_lastjia) then
            --     lastjia_view_nickname:setString(Strings.gameing.offlineName .. user_nickname_lastjia)
            -- else
            --     lastjia_view_nickname:setString(Strings.gameing.offlineName)
            -- end
            lastjia_view_offline:setVisible(true)
            VoiceDealUtil:playSound_other(Voices.file.gameing_sankai)
        end
    end
end

function GameingScene:superEmojoDataHandler(res_data)
    if res_data ~= nil then
        local num = 1
        for k,v in pairs(res_data) do
            if num == 1 then
                AnimationManager:playSuperEmoji(Layer1, mySeatNo, tonumber(v.code), v.seatNo, v.targetSeatNo, true)
            else
                AnimationManager:playSuperEmoji(Layer1, mySeatNo, tonumber(v.code), v.seatNo, v.targetSeatNo, nil)
            end

            num = num + 1
        end
    end
end

local emoji_node_view
function GameingScene:emoji_createView_setViewData(res_data)
    if res_data ~= nil then
        local room = res_data--[User.Bean.room]
        local exp_code = room[Player.Bean.code]
        local currNo = room[Player.Bean.seatNo]
        
        local _seat = GameingDealUtil:confimSeatNo(mySeatNo, currNo) -- 确定相对位置：：0=本人位置，1=下一玩家，-1=上一玩家，最后一玩家
        --Commons:printLog_Info("----位置是：", _seat)

        if _seat == CEnum.seatNo.me then
            -- 自己发送的，自己也播放，但不是这里
        else
            if Layer1 ~= nil then
                emoji_node_view = GameingDealUtil:createEmoji_Anim(Layer1, exp_code, _seat, emoji_node_view)
            end
        end
    end
end

-- 短语的处理
local words_node_view
function GameingScene:words_createView_setViewData(res_data)
    if res_data ~= nil then
        local room = res_data--[User.Bean.room]
        local words_code = room[Player.Bean.code]
        local currNo = room[Player.Bean.seatNo]

        local _seat = GameingDealUtil:confimSeatNo(mySeatNo, currNo) -- 确定相对位置：：0=本人位置，1=下一玩家，-1=上一玩家，最后一玩家
        --Commons:printLog_Info("----位置是：", _seat)

        if _seat == CEnum.seatNo.me then
            -- 自己发送的，自己也播放，但不是这里
        else
            if Layer1 ~= nil then
                words_node_view = GameingDealUtil:createWords_Anim(Layer1, words_code, _seat, words_node_view)
            end
        end
    end
end

-- 播放录音
local voice_node_view
function GameingScene:downLoadVoice_toPlay(fileNameShort, _seat)
    if Commons:checkIsNull_str(fileNameShort) then

        VoiceDealUtil:stopBgMusic()
        -- if currStopMusic_init ~= nil and CEnum.musicStatus.off == currStopMusic_init then
        -- else
        --     -- VoiceDealUtil:pauseBgMusic()
        --     VoiceDealUtil:stopBgMusic()
        -- end
        GameState_VoiceSetting:setDataSingle(CEnum.voiceSetting.currStopMusic, CEnum.musicStatus.off)
        GameState_VoiceSetting:setDataSingle(CEnum.voiceSetting.currStopSounds, CEnum.musicStatus.off)

        Commons:printLog_Info("-----------到播放了", fileNameShort, _seat)
        -- 自己发送的，自己也播放
        voice_node_view = GameingDealUtil:createVoice_Anim(Layer1, _seat, voice_node_view)

        local function GameScene_DictatePlay_CallbackLua_RL(txt)
            Commons:printLog_Info("-----------播放完成拉")
            --voiceSpeakBg:setVisible(true)
            if voice_node_view ~= nil and (not tolua.isnull(voice_node_view)) then
              voice_node_view:stopAllActions()
              voice_node_view:removeFromParent()
              voice_node_view = nil
            end

            -- 队列播放
            if Commons:checkIsNull_tableType(CVar._static.voiceWaitPlayTable) then
                CVar._static.voiceWaitPlayTable[fileNameShort] = CEnum.seatNo.playOver
                local isHaveNeedPlay = false

                for k,v in pairs(CVar._static.voiceWaitPlayTable) do
                    --Commons:printLog_Info("----还有要播放的东西吗？？----",k,v)
                    if v ~= CEnum.seatNo.playOver then
                        Commons:printLog_Info("----可以播放的有----",k,v)
                        isHaveNeedPlay = true
                        GameingScene:downLoadVoice_toPlay(k, v)
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
                    -- if currStopMusic_init ~= nil and CEnum.musicStatus.off == currStopMusic_init then
                    --     GameState_VoiceSetting:setDataSingle(CEnum.voiceSetting.currStopMusic, CEnum.musicStatus.off)
                    -- else
                    --     GameState_VoiceSetting:setDataSingle(CEnum.voiceSetting.currStopMusic, CEnum.musicStatus.on)
                    --     --VoiceDealUtil:resumeBgMusic()
                    --     VoiceDealUtil:playBgMusic()
                    -- end
                end
            end

        end
        Commons:gotoDictatePlay(GameScene_DictatePlay_CallbackLua_RL, fileNameShort)
        Commons:printLog_Info("-----------平台 播放结束拉", fileNameShort, _seat)
    end
end

-- 先下载完成，再去播放
function GameingScene:downLoadVoiceBack(status, fileNameShort, _seat, RemoteUrl)
        -- 去播放
        --GameingScene:downLoadVoice_toPlay(fileNameShort, _seat, RemoteUrl)
        if Commons:checkIsNull_tableType(CVar._static.voiceWaitPlayTable) then
                Commons:printLog_Info("----voice 22--需要 播放信息是：", _seat, fileNameShort)
                if status == CEnum.status.success then
                    if CEnum.Environment.Current~=nil and CEnum.Environment.Current==CEnum.EnvirType.Test then
                        CVar._static.voiceWaitPlayTable[fileNameShort] = _seat
                    else
                        -- 相同的东西，只是播放一遍
                        if CVar._static.voiceWaitPlayTable[fileNameShort] ~= nil and CVar._static.voiceWaitPlayTable[fileNameShort] == CEnum.seatNo.playOver then
                        else
                            CVar._static.voiceWaitPlayTable[fileNameShort] = _seat
                        end
                    end
                end
                local _sizeTable = 0
                for k,v in pairs(CVar._static.voiceWaitPlayTable) do
                    if v ~= CEnum.seatNo.playOver then
                        _sizeTable = _sizeTable + 1
                    end
                end
                Commons:printLog_Info("----voice 22--有几个需要播放：", _sizeTable)
                --dump(CVar._static.voiceWaitPlayTable)

                if _sizeTable == 1 then
                    Commons:printLog_Info("----voice 22--确定播放信息是：", _seat, fileNameShort)
                    if status == CEnum.status.success then
                        GameingScene:downLoadVoice_toPlay(fileNameShort, _seat)
                    end
                -- elseif _sizeTable > 1 then
                --     -- 队列中挑选一个去播放
                --     if Commons:checkIsNull_tableType(CVar._static.voiceWaitPlayTable) then
                --         for k,v in pairs(CVar._static.voiceWaitPlayTable) do
                --             --Commons:printLog_Info("----22--队列>1中选一个 要播放的东西吗？？----",k,v)
                --             if v ~= CEnum.seatNo.playOver then
                --                 Commons:printLog_Info("----22--队列>1中选一个 可以播放的有----",k,v)
                --                 GameingScene:downLoadVoice_toPlay(k, v)
                --                 break
                --             end
                --         end
                --     end
                    
                end
        end

        -- 队列下载
        if Commons:checkIsNull_tableType(CVar._static.voiceWaitDownTable) then
            CVar._static.voiceWaitDownTable[RemoteUrl] = CEnum.seatNo.downOver
            local isHaveNeedDown = false

            for k,v in pairs(CVar._static.voiceWaitDownTable) do
                --Commons:printLog_Info("----voice 22--还有要下载的东西吗？？----",k,v)
                if v ~= CEnum.seatNo.downOver then
                    Commons:printLog_Info("----voice 22--可以下载的有----",k,v)
                    isHaveNeedDown = true
                    ImDealUtil:downLoad(function(...) GameingScene:downLoadVoiceBack(...) end, k, v)
                    break
                end
            end

            if not isHaveNeedDown then
                CVar._static.voiceWaitDownTable = {}
            end
        end
end

function GameingScene:voice_createView_setViewData(res_data)
    if res_data ~= nil then
        local room = res_data--[User.Bean.room]
        local voiceUrl = room[Player.Bean.voiceUrl]
        local currNo = room[Player.Bean.seatNo]
        local _seat = GameingDealUtil:confimSeatNo(mySeatNo, currNo) -- 确定相对位置：：0=本人位置，1=下一玩家，-1=上一玩家，最后一玩家

        if Commons:checkIsNull_tableType(CVar._static.voiceWaitDownTable) then
            Commons:printLog_Info("----voice 11--当前 下载信息是：", _seat, voiceUrl)
            if CEnum.Environment.Current~=nil and CEnum.Environment.Current==CEnum.EnvirType.Test then
                CVar._static.voiceWaitDownTable[voiceUrl] = _seat
            else
                -- 相同的东西，只是播放一遍
                if CVar._static.voiceWaitDownTable[voiceUrl] ~= nil and CVar._static.voiceWaitDownTable[voiceUrl] == CEnum.seatNo.downOver then
                else
                    CVar._static.voiceWaitDownTable[voiceUrl] = _seat
                end  
            end

            local _sizeTable = 0
            for k,v in pairs(CVar._static.voiceWaitDownTable) do
                if v ~= CEnum.seatNo.downOver then
                    _sizeTable = _sizeTable + 1
                end
            end
            Commons:printLog_Info("----voice 11--有几个需要下载：", _sizeTable)

            if _sizeTable == 1 then
                Commons:printLog_Info("----voice 11--确定 下载信息是：", _seat, voiceUrl)
                if _seat == CEnum.seatNo.me then
                    -- 自己发送的表情，自己不播放
                    if CEnum.Environment.Current~=nil and CEnum.Environment.Current==CEnum.EnvirType.Test then
                        ImDealUtil:downLoad(function(...) GameingScene:downLoadVoiceBack(...) end, voiceUrl, _seat)
                    end
                elseif _seat == CEnum.seatNo.R then
                    ImDealUtil:downLoad(function(...) GameingScene:downLoadVoiceBack(...) end, voiceUrl, _seat)
                elseif _seat == CEnum.seatNo.L then
                    ImDealUtil:downLoad(function(...) GameingScene:downLoadVoiceBack(...) end, voiceUrl, _seat)
                end
            elseif _sizeTable > 1 then
                -- 队列中挑选一个去下载
                if Commons:checkIsNull_tableType(CVar._static.voiceWaitDownTable) then
                    for k,v in pairs(CVar._static.voiceWaitDownTable) do
                        --Commons:printLog_Info("----voice 11--队列>1中选一个 要下载的东西吗？？----",k,v)
                        if v ~= CEnum.seatNo.downOver then
                            Commons:printLog_Info("----voice 11--队列>1中选一个 可以下载的有----",k,v)
                            ImDealUtil:downLoad(function(...) GameingScene:downLoadVoiceBack(...) end, k, v)
                            break
                        end
                    end
                end

            end

        end
        
    end
end

function GameingScene:huCard_createView_setViewData(res_data)
    if res_data ~= nil then
        local room = res_data--[User.Bean.room]
        local roundRecord = room[Room.Bean.roundRecord] 
        -- local _room_status = room[Room.Bean.status]
        -- --local room_status
        -- if CEnum.roomStatus.ended==_room_status or CEnum.roomStatus.dissolved==_room_status then
        --     --room_status = true 
        --     -- 房间结束
        -- else -- 回合结束
        -- end

        local roomRecord = room[Room.Bean.roomRecord]
        if Commons:checkIsNull_tableList(roomRecord) then
            -- 房间结束
            isMyManual = true -- 不能再重连
            -- 同时关闭 socket
            if CVar._static.mSocket ~= nil then
                CVar._static.mSocket:CloseSocket()
            end
            CVar._static.roomStatus = ""
        end

        local owerNo = nil -- 我本人的位置在哪里？
        local isHu = nil -- 看下有没有胡牌？
        local _seat
        local mt
        local fanRule
        local fanCard
        local huCard
        local diCards
        local flzScore
        if Commons:checkIsNull_tableList(roundRecord) then
            
            GameingMeChiCardDeal:createChiCards(nil) -- 消失可能操作过的吃牌
            myself_view_needOption_list:setVisible(false) -- 中间的选择消失

            -- 关闭倒计时
            GameingScene:killTimeTick(myself_view_timer)

            for k,v in pairs(roundRecord) do
                local me = v[RoundRecord.Bean.me]
                if me then
                    owerNo = v[Player.Bean.seatNo]
                    break
                end
            end

            ---[[
            -- 其他人手牌的呈现
            for k,v in pairs(roundRecord) do
                local currNo = v[Player.Bean.seatNo] -- 当前玩家座位编号
                local _seat2 = GameingDealUtil:confimSeatNo(owerNo, currNo) -- 确定相对位置：：0=本人位置，1=下一玩家，-1=上一玩家，最后一玩家
                local holeCards = v[RoundRecord.Bean.holeCards]

                -- 另外2个人的底牌
                if _seat2 == CEnum.seatNo.me then
                elseif _seat2 == CEnum.seatNo.R then
                    if holeCards ~= nil then
                        local _handCardDataTable_RL = GameingDealUtil:ScrollView_FillList_RL(holeCards, CVar._static.handCardNums, CEnum.seatNo.R)
                        GameingScene:R_handCard_initUI(_handCardDataTable_RL)  -- 更新手牌UI
                    end
                elseif _seat2 == CEnum.seatNo.L then
                    if holeCards ~= nil then
                        local _handCardDataTable_RL = GameingDealUtil:ScrollView_FillList_RL(holeCards, CVar._static.handCardNums, CEnum.seatNo.L)
                        GameingScene:L_handCard_initUI(_handCardDataTable_RL)  -- 更新手牌UI
                    end
                end
            end
            --]]

            for k,v in pairs(roundRecord) do
                diCards = v[RoundRecord.Bean.diCards]
                if Commons:checkIsNull_tableList(diCards) then
                        view_diCards_list = 
                        cc.ui.UIPageView.new({
                            viewRect = cc.rect(0, 0, card_hu_w*8.2, card_hu_h*3.2),
                            column = 8,
                            row = 3, 
                            padding = {left = card_hu_w/2, right = card_hu_w/2, top = 0, bottom = card_hu_h/2},
                            columnSpace=0,
                            rowSpace=0,
                            bCirc = false
                        })
                        :addTo(Layer1)
                        :align(display.CENTER, display.cx-120, osHeight-226)
                    --底牌列表
                    view_diCards_list:removeAllItems();
                    if Commons:checkIsNull_tableType(diCards) then
                        for k_di,v_di in pairs(diCards) do
                            local item = view_diCards_list:newItem()
                            local img_vv = GameingDealUtil:getImgByHandcard(CEnum.userCard.out, v_di)
                            local content = cc.ui.UIPushButton.new(img_vv, {scale9 = false})
                                    :setButtonSize(card_hu_w, card_hu_h)
                                    -- :setButtonLabel(
                                    --  cc.ui.UILabel.new({
                                    --      --text = "点击大小改变" .. i, 
                                    --      text = "", 
                                    --      size = 16, 
                                    --      color = display.COLOR_BLUE
                                    --  })
                                    -- )
                                    --:onButtonPressed(function(event)
                                    --  event.target:getButtonLabel():setColor(display.COLOR_RED)
                                    --end)
                                    --:onButtonRelease(function(event)
                                    --  event.target:getButtonLabel():setColor(display.COLOR_BLUE)
                                    --end)
                                    --:onButtonClicked(function(event)
                                    --  Commons:printLog_Info("UIListView buttonclicked")
                                    --  local w, _ = item:getItemSize()
                                    --  if 60 == w then
                                    --      item:setItemSize(100, 73*3)
                                    --  else
                                    --      item:setItemSize(60, 73*3)
                                    --  end
                                    --end)
                            --item:setBg("") -- 设置item背景
                            item:addChild(content)
                            --item:setItemSize(42, 42)
                            view_diCards_list:addItem(item) -- 添加item到列表
                        end
                        view_diCards_list:reload() -- 重新加载
                    end

                    break
                end
            end

            --[[
            -- 更新最后3个人的胡息和分数
            for k,v in pairs(roundRecord) do
                local score = v[Player.Bean.score]
                -- local xi = v[Player.Bean.xi]
                local currNo = v[Player.Bean.seatNo] -- 当前玩家座位编号
                local _seat2 = GameingDealUtil:confimSeatNo(owerNo, currNo) -- 确定相对位置：：0=本人位置，1=下一玩家，-1=上一玩家，最后一玩家

                if _seat2 == CEnum.seatNo.me then

                    -- 分数赋值
                    if Commons:checkIsNull_numberType(score) then
                        if myself_view_score~=nil and (not tolua.isnull(myself_view_score)) then
                            myself_view_score:setString(Strings.gameing.score .. score)
                            myself_view_score:setVisible(true)
                        end
                    end

                    -- -- 胡息赋值
                    -- if Commons:checkIsNull_number(xi) then
                    --     if myself_view_xi~=nil and (not tolua.isnull(myself_view_xi)) then
                    --         myself_view_xi:setString(xi .. Strings.gameing.xi)
                    --         myself_view_xi:setVisible(true)
                    --     end
                    -- end
                elseif _seat2 == CEnum.seatNo.R then

                    -- 分数赋值
                    if Commons:checkIsNull_numberType(score) then
                        if xiajia_view_score~=nil and (not tolua.isnull(xiajia_view_score)) then
                            xiajia_view_score:setString(Strings.gameing.score .. score)
                            xiajia_view_score:setVisible(true)
                        end
                    end

                    -- -- 胡息赋值
                    -- if Commons:checkIsNull_number(xi) then
                    --     if xiajia_view_xi~=nil and (not tolua.isnull(xiajia_view_xi)) then
                    --         xiajia_view_xi:setString(xi .. Strings.gameing.xi)
                    --         xiajia_view_xi:setVisible(true)
                    --     end
                    -- end
                elseif _seat2 == CEnum.seatNo.L then

                    -- 分数赋值
                    if Commons:checkIsNull_numberType(score) then
                        if lastjia_view_score~=nil and (not tolua.isnull(lastjia_view_score)) then
                            lastjia_view_score:setString(Strings.gameing.score .. score)
                            lastjia_view_score:setVisible(true)
                        end
                    end

                    -- -- 胡息赋值
                    -- if Commons:checkIsNull_number(xi) then
                    --     if lastjia_view_xi~=nil and (not tolua.isnull(lastjia_view_xi)) then
                    --         lastjia_view_xi:setString(xi .. Strings.gameing.xi)
                    --         lastjia_view_xi:setVisible(true)
                    --     end
                    -- end
                end
            end
            --]]

            -- 谁胡牌了，谁赢了
            for k,v in pairs(roundRecord) do
                local hu = v[RoundRecord.Bean.hu]
                if hu then
                    isHu = true
                    local currNo = v[Player.Bean.seatNo] -- 当前玩家座位编号
                    _seat = GameingDealUtil:confimSeatNo(owerNo, currNo) -- 确定相对位置：：0=本人位置，1=下一玩家，-1=上一玩家，最后一玩家
                    mt = v[RoundRecord.Bean.wbMt]
                    fanRule = v[RoundRecord.Bean.fanRule]
                    fanCard = v[RoundRecord.Bean.fanCard]
                    huCard = v[RoundRecord.Bean.huCard]
                    flzScore = v[RoundRecord.Bean.flzScore]
                    --diCards = v[RoundRecord.Bean.diCards]
                    break
                end
            end
            -- 只要运行一次即可，看谁胡牌了
            --local huResult = room[Room.Bean.huResult]
            if isHu ~= nil and isHu then

                    --local currNo = huResult[Player.Bean.seatNo] -- 当前玩家座位编号
                    --local _seat = GameingDealUtil:confimSeatNo(owerNo, currNo) -- 确定相对位置：：0=本人位置，1=下一玩家，-1=上一玩家，最后一玩家
                    --local mt = huResult[RoundRecord.Bean.mt]
                    --local fanRule = huResult[Room.Bean.fanRule]
                    --local fanCard = huResult[Player.Bean.card]
                    -- Commons:printLog_Info("===========================胡牌 ",_seat, mt, fanRule, fanCard, huCard)
                    -- 图片提示
                    huCard_tipimg_node = display.newNode() --cc.NodeGrid:create()
                        :addTo(Layer1, CEnum.ZOrder.gameingView_myself_emoji)
                        :setVisible(true)
                    --huCard_tipimg_node:setPosition(0,0)
                    --huCard_tipimg_node:setAnchorPoint(cc.p(display.cx, 0))

                    huCard = GameingDealUtil:getImgByHandcard(CEnum.userCard.mid_mo, huCard)
                    local chu_hu_card = cc.ui.UIImage.new(huCard,{scale9=false})
                        :addTo(huCard_tipimg_node)
                        -- :align(display.CENTER_TOP, display.cx, osHeight-170)
                        :setVisible(false)
                    local chu_hu_bg = cc.ui.UIImage.new(Imgs.gameing_out_hu_bg,{scale9=false})
                        :addTo(huCard_tipimg_node)
                        -- :align(display.CENTER_TOP, display.cx, osHeight-170)
                        :setVisible(false)
                    local chu_hu_title = cc.ui.UIImage.new(Imgs.gameing_out_hu_title,{scale9=false})
                        :addTo(huCard_tipimg_node)
                        -- :align(display.CENTER_TOP, display.cx, osHeight-170-48-52)
                        :setVisible(false)
                    local chu_hu = cc.ui.UIImage.new(Imgs.gameing_out_hu,{scale9=false})
                        :addTo(huCard_tipimg_node)
                        -- :align(display.CENTER_TOP, display.cx, osHeight-170-48)
                        :setVisible(false)

                    if _seat == CEnum.seatNo.me then
                        --huCard_tipimg_node:addTo(myself_view)
                        chu_hu_card:align(display.CENTER_TOP, display.cx, osHeight-170-55)
                        -- chu_hu_bg:align(display.CENTER_TOP, display.cx, osHeight-170-55)
                        chu_hu_bg:align(display.CENTER, display.cx, (osHeight-170-55)*7/10)

                        chu_hu_title:align(display.CENTER_TOP, display.cx, osHeight-170-55-48-52)
                        chu_hu:align(display.CENTER_TOP, display.cx, osHeight-170-55-48)
                    elseif _seat == CEnum.seatNo.R then
                        --huCard_tipimg_node:addTo(xiajia_view)
                        chu_hu_card:align(display.RIGHT_TOP, osWidth-176-110, osHeight-84)
                        -- chu_hu_bg:align(display.RIGHT_TOP, osWidth-176, osHeight-84)
                        chu_hu_bg:align(display.CENTER, (osWidth-176)*8.5/10, (osHeight-84)*7.2/10)
                        if CVar._static.isIphone4 then
                            chu_hu_bg:align(display.CENTER, (osWidth-176)*8.2/10, (osHeight-84)*7.2/10)
                        elseif CVar._static.isIpad then
                            chu_hu_bg:align(display.CENTER, (osWidth-176)*8.0/10, (osHeight-84)*7.2/10)
                        end

                        chu_hu_title:align(display.RIGHT_TOP, osWidth-176-10, osHeight-84-65-52)
                        chu_hu:align(display.RIGHT_TOP, osWidth-176-80, osHeight-84-65)
                    elseif _seat == CEnum.seatNo.L then
                        --huCard_tipimg_node:addTo(lastjia_view)
                        chu_hu_card:align(display.LEFT_TOP, 164+110, osHeight-84)
                        -- chu_hu_bg:align(display.LEFT_TOP, 164, osHeight-84)
                        chu_hu_bg:align(display.CENTER, 164*20/10, (osHeight-84)*7.5/10)
                        -- if CVar._static.isIphone4 then
                        --     chu_hu_bg:align(display.CENTER, 164*20/10, (osHeight-84)*7.5/10)
                        -- elseif CVar._static.isIpad then
                        --     chu_hu_bg:align(display.CENTER, 164*20/10, (osHeight-84)*7.5/10)
                        -- end
                        chu_hu_title:align(display.LEFT_TOP, 164+10, osHeight-84-65-52)
                        chu_hu:align(display.LEFT_TOP, 164+80, osHeight-84-65)
                    end 

                    --local a1 = cc.MoveTo:create(0.7, cc.p(0, -display.cy+50))
                    --local a1 = cc.Shaky3D:create(3,cc.size(50,50),5,false)
                    --local a1 = cc.ShuffleTiles:create(3,cc.size(300,300),5)
                    --local a1 = cc.FadeOut:create(1)
                    --local a2 = cc.FadeIn:create(1)
                        local a1 = cc.RotateBy:create(2,360)
                    --local a2 = cc.RotateBy:create(3,360)
                    --local a1 = cc.ScaleBy:create(2, 1.3)
                        -- local a2 = a1:reverse() -- 需要对应的 MoveBy
                        -- local anim = cc.Sequence:create(a1, a2, cc.CallFunc:create(function() 
                        --         --myself_view_mo_chu_pai_bg:setVisible(false)
                        --         --myself_view_mo_chu_pai:setVisible(false)
                        --         --if not tolua.isnull(huCard_tipimg_node) then
                        --             --huCard_tipimg_node:removeFromParent()
                        --         --end
                        --     end))
                    --local anim2 = cc.RepeatForever:create(anim)
                    --local anim2 = cc.Spawn:create(a1,a2)
                    --local anim2 = cc.Repeat:create(anim, 3)
                    --huCard_tipimg_node:runAction(anim)
                    chu_hu_bg:runAction(a1)

                    local hu_time = 0.1
                    -- mtView 名堂优先播报
                    if Commons:checkIsNull_str(mt) then
                        hu_time = 0.1
                        Layer1:performWithDelay(function () 
                            -- mt --todo 最后需要相应更多的声音
                                local img_vv = GameingDealUtil:getImgByOptionOut(mt)
                                local _string

                                if img_vv ~= Imgs.c_transparent then
                                    _string = mt
                                    mtView = cc.ui.UIImage.new(img_vv,{scale9=false})
                                                :addTo(huCard_tipimg_node)
                                                :align(display.CENTER, display.cx, display.cy)
                                else
                                    _string = GameingDealUtil:getMtImgByShowTxt(mt) 
                                    mtView = display.newTTFLabel({
                                                    text = _string,
                                                    font = Fonts.Font_hkyt_w9,
                                                    size = Dimens.TextSize_30,
                                                    color = Colors:_16ToRGB(Colors.gameing_huxi),
                                                    align = cc.ui.TEXT_ALIGN_CENTER,
                                                    valign = cc.ui.TEXT_VALIGN_CENTER,
                                                    --dimensions = cc.size(100,20)
                                                })
                                        :addTo(huCard_tipimg_node)
                                        :align(display.CENTER, display.cx, display.cy)  
                                end

                                if mtView ~= nil then
                                    if _seat == CEnum.seatNo.me then
                                        mtView:align(display.CENTER, display.cx, display.cy)
                                    elseif _seat == CEnum.seatNo.R then
                                        mtView:align(display.RIGHT_TOP, osWidth-106, osHeight-84-65)
                                    elseif _seat == CEnum.seatNo.L then
                                        mtView:align(display.LEFT_TOP, 114, osHeight-84-65)
                                    end
                                end

                                if _string ~= nil then
                                    local cc
                                    if CEnum.mt.wd == mt or CEnum.mt.twd == mt then
                                        cc = "wd"
                                    elseif CEnum.mt.wc == mt or CEnum.mt.twc == mt then
                                        cc = "wc"
                                    end 
                                    VoiceDealUtil:playSound(cc)
                                end
                        end, hu_time)

                        hu_time = 1.0
                    end

                    -- 胡了 播报
                    Layer1:performWithDelay(function ()
                        VoiceDealUtil:playSound(CEnum.playOptions.hu)
                        chu_hu_card:setVisible(true)
                        chu_hu_bg:setVisible(true)
                        chu_hu_title:setVisible(true)
                        chu_hu:setVisible(true)
                    end, hu_time)
                    

                    -- fanRule
                    if Commons:checkIsNull_str(fanRule) then
                        hu_time = hu_time +0.5
                        Layer1:performWithDelay(function () 
                            -- if mtView ~= nil then
                            --     if not tolua.isnull(mtView) then
                            --         mtView:removeFromParent()
                            --         mtView = nil
                            --     end
                            -- end
                            if fanRule == CEnum.fanRule.fan then
                                ruleView = cc.ui.UIImage.new(Imgs.room_3fgx_fan,{scale9=false})
                                    :addTo(huCard_tipimg_node)
                                    :align(display.CENTER, display.cx, osHeight-170)
                                    :setLayoutSize(76, 46)
                            elseif fanRule == CEnum.fanRule.gen then
                                ruleView = cc.ui.UIImage.new(Imgs.room_3fgx_gen,{scale9=false})
                                    :addTo(huCard_tipimg_node)
                                    :align(display.CENTER, display.cx, osHeight-170)
                                    :setLayoutSize(76, 46)
                            end
                        end, hu_time)
                    end

                    -- fanCard
                    if Commons:checkIsNull_str(fanCard) then
                        hu_time = hu_time +0.5
                        Layer1:performWithDelay(function ()
                            -- if ruleView ~= nil then
                            --     if not tolua.isnull(ruleView) then
                            --         ruleView:removeFromParent()
                            --         ruleView = nil
                            --     end
                            -- end
                                --local cc2 = string.sub(fanCard, 2, _size)
                                local img_vv = GameingDealUtil:getImgByHandcard(CEnum.userCard.mid_mo, fanCard)
                                --Commons:printLog_Info(img_vv)
                                fanCardView = cc.ui.UIImage.new(img_vv,{scale9=false})
                                    :setLayoutSize(76*2/3, 226*2/3)
                                    :addTo(huCard_tipimg_node)
                                    :align(display.CENTER, display.cx, osHeight-180)
                                --local _size = string.len(fanCard)
                                --if _size >= 3 then
                                --    local cc = string.sub(fanCard, 3, _size)
                                --    VoiceDealUtil:playSound(cc)
                                --end
                        end, hu_time)
                    end

                    ---[[
                    hu_time = hu_time +1.0
                    Layer1:performWithDelay(function ()
                        -- if fanCardView ~= nil then
                        --     if not tolua.isnull(fanCardView) then
                        --         fanCardView:removeFromParent() 
                        --         fanCardView = nil
                        --     end
                        -- end
                        -- if huCard_tipimg_node ~= nil then
                        --     if not tolua.isnull(huCard_tipimg_node) then
                        --         huCard_tipimg_node:removeFromParent() 
                        --         huCard_tipimg_node = nil
                        --     end
                        -- end

                        -- 回合结束：有人胡牌，并且超过18硬息，存在单局分溜子，，也可能存在房间结束分溜子，这种情况我们就走一次分溜子动画即可
                        if Commons:checkIsNull_numberType(flzScore) and flzScore > CEnum.isDlz.zeroLz then
                            VoiceDealUtil:playSound_other(Voices.file.gameing_flz)
                            Layer1:performWithDelay(function ()
                                VoiceDealUtil:playSound_other(Voices.file.gameing_addcoin)
                                -- 每个玩家分溜子的动画
                                FlzAnim.new(_seat):addTo(Layer1, CEnum.ZOrder.gameingView_myself_voice)

                                Layer1:performWithDelay(function ()
                                    -- 弹窗显示回合结果，房间结束，有房间数据
                                    CVar._static.isNeedShowPrepareBtn = false
                                    GameingOverRoundDialog:popDialogBox(Layer1, res_data, nil, nil, nil,
                    					CEnum.pageView.gameingOverPage,
                                        myself_view_btn_Prepare
                                    )
                                end, 0.8+0.8)
                            end, 0.8)
                        else
                            -- 回合结束：有人胡牌，没有超过18硬息，不存在单局分溜子，可能存在房间结束分溜子

                            -- 弹窗显示回合结果，房间结束，有房间数据
                            GameingScene:topLz_setViewData(res_data, CEnum.dlzType.isRoom) -- 逗完存在分
                        end

                    end, hu_time)
                    --]]

            else
                -- 荒局，roundRecord对象中存在逗溜子分数，说明还需要逗溜子
                local _tag = true
                if roundRecord ~= nil and type(roundRecord)=="table" then
                    for k,v in pairs(roundRecord) do
                        local dlzScore = v[RoundRecord.Bean.dlzScore]
                        if Commons:checkIsNull_numberType(dlzScore) and dlzScore > CEnum.isDlz.noLz then
                            _tag = false
                            VoiceDealUtil:playSound_other(Voices.file.over_huang)
                            Layer1:performWithDelay(function ()
                                GameingScene:topLz_setViewData(res_data, CEnum.dlzType.isRound) -- 纯逗溜子
                            end,1)
                        end
                        break
                    end
                end

                if _tag then -- 不存在逗，直接弹出回合结束，，可能还存在房间结束分溜子
                    ---[[
                    VoiceDealUtil:playSound_other(Voices.file.over_huang)
                    GameingScene:topLz_setViewData(res_data, CEnum.dlzType.isRoom) -- 逗完存在分
                    --]]
                end
            end
        else
            -- 未开局，就解散了，只有roomRecord对象
            local _tag = true
            if Commons:checkIsNull_tableList(roomRecord) then

                -- 房间结束，存在分溜子
                for k,v in pairs(roomRecord) do
                    local _flzScore = v[RoomRecord.Bean.flzScore]
                    if Commons:checkIsNull_numberType(_flzScore) and _flzScore > CEnum.isDlz.zeroLz then
                        _tag = false

                        VoiceDealUtil:playSound_other(Voices.file.gameing_flz)
                        Layer1:performWithDelay(function ()
                            VoiceDealUtil:playSound_other(Voices.file.gameing_addcoin)
                            -- 每个玩家分溜子的动画
                            FlzAnim.new():addTo(Layer1, CEnum.ZOrder.gameingView_myself_voice)

                            -- 分完溜子，再出结算页面
                            Layer1:performWithDelay(function ()
                                CVar._static.isNeedShowPrepareBtn = false
                                GameingOverRoomDialog:popDialogBox(Layer1, res_data)
                            end, 0.8+0.8)
                        end, 0.8)
                    end
                    break
                end
            end                

            if _tag then -- 房间结束，不存在分溜子，直接出结算
                -- 回合结果没有，直接牌局结束拉，，往往出现在一局结束，下局没有开始就解散了房间
                if Commons:checkIsNull_tableList(roomRecord) then
                    CVar._static.isNeedShowPrepareBtn = false
                    GameingOverRoomDialog:popDialogBox(Layer1, res_data)
                end
            end
        end

        
    end
end

function GameingScene:R_handCard_initUI(_handCardDataTable_RL)
    local boxSize_RL = cc.size(33,33)
    local objSize_RL = cc.size(33,33+7)
    if CVar._static.isIphone4 then
        boxSize_RL = cc.size(33-5,33-5)
        objSize_RL = cc.size(33-5,33+7-5)
    elseif CVar._static.isIpad then
        boxSize_RL = cc.size(33-15,33-15)
        objSize_RL = cc.size(33-15,33+7-15)
    end

    local column_nums = #_handCardDataTable_RL / 3
    local w = column_nums * boxSize_RL.width;
    local h = boxSize_RL.height * 3;

    --我手上牌的背景层区域 背包
    if bg_view_R == nil then 
        bg_view_R = cc.LayerColor:create(cc.c4b(100,100,100,0),w,h)
            :setPosition(cc.p(osWidth-w-30-210, osHeight-h-4-200))
            -- :setVisible(false)
            :addTo(Layer1, CEnum.ZOrder.gameingView_myself_voice)
    else   
        if not tolua.isnull(bg_view_R) then
            bg_view_R:removeFromParent()
            bg_view_R = nil
        end
        bg_view_R = cc.LayerColor:create(cc.c4b(100,100,100,0),w,h)
            :setPosition(cc.p(osWidth-w-30-200, osHeight-h-4-200))
            -- :setVisible(false)
            :addTo(Layer1, CEnum.ZOrder.gameingView_myself_voice)
    end

    if sc_view_R == nil then
        sc_view_R =  cc.ui.UIScrollView.new({
            viewRect = cc.rect(0,0, bg_view_R:getContentSize().width, bg_view_R:getContentSize().height), 
            direction = 1
        })
        sc_view_R:setBounceable(false) -- 回弹效果去掉，就不会出现貌似滑动的效果
        bg_view_R:addChild(sc_view_R)
    else
        if not tolua.isnull(sc_view_R) then
            sc_view_R:removeFromParent()
            sc_view_R = nil
        end
        sc_view_R = cc.ui.UIScrollView.new({
            viewRect = cc.rect(0,0, bg_view_R:getContentSize().width, bg_view_R:getContentSize().height),
            direction = 1
        })
        sc_view_R:setBounceable(false) -- 回弹效果去掉，就不会出现貌似滑动的效果
        bg_view_R:addChild(sc_view_R)
    end

    -- 我手上具体有多少张牌，一张张加入
    local t_data = {}
    ---[[
    for k,v in pairs(_handCardDataTable_RL) do
        --CDAlert.new():popDialogBox(Layer1,"666")
        -- 每个小背包
        local png = cc.LayerColor:create(cc.c4b(160,160,160,0), boxSize_RL.width, boxSize_RL.height)
        png:setTouchSwallowEnabled(false)
        --把layer当作精灵来处理
        png:ignoreAnchorPointForPosition(false)

        t_data[#t_data+1] = png

        ---[[
        -- 不能移动的手牌显示，可以放这里
        local img_vv = GameingDealUtil:getImgByHandcard(CEnum.userCard.hand, v)
        cc.ui.UIPushButton.new(img_vv, {scale9 = false})
                :setButtonSize(objSize_RL.width, objSize_RL.height)
                :align(display.CENTER, png:getContentSize().width/2, png:getContentSize().height/2)
                :addTo(png)
        -- display.newTTFLabel({
        --         text = k, 
        --         --text = "",
        --         size = 30, 
        --         color = cc.c3b(100,100,100)
        --     })
        --     :align(display.CENTER, png:getContentSize().width/2, png:getContentSize().height/2)
        --     :addTo(png)
        --]]
    end
    sc_view_R:fill(t_data, {itemSize = (t_data[#t_data]):getContentSize()})
    SCROLL_HANDLER_SLIDE(sc_view_R)
    S_XY(sc_view_R:getScrollNode(), 0, sc_view_R:getViewRect().height-H(sc_view_R:getScrollNode()) )
    --]]
end

function GameingScene:L_handCard_initUI(_handCardDataTable_RL)
    local boxSize_RL = cc.size(33,33)
    local objSize_RL = cc.size(33,33+7)
    if CVar._static.isIphone4 then
        boxSize_RL = cc.size(33-5,33-5)
        objSize_RL = cc.size(33-5,33+7-5)
    elseif CVar._static.isIpad then
        boxSize_RL = cc.size(33-15,33-15)
        objSize_RL = cc.size(33-15,33+7-15)
    end

    local column_nums = #_handCardDataTable_RL / 3
    local w = column_nums * boxSize_RL.width;
    local h = boxSize_RL.height * 3;

    --我手上牌的背景层区域 背包
    if bg_view_L == nil then 
        bg_view_L = cc.LayerColor:create(cc.c4b(100,100,100,0),w,h)
            :setPosition(cc.p(30+216, osHeight-h-4-200))
            -- :setVisible(false)
            :addTo(Layer1, CEnum.ZOrder.gameingView_myself_voice)
    else
        if not tolua.isnull(bg_view_L) then
            bg_view_L:removeFromParent()
            bg_view_L = nil
        end
        bg_view_L = cc.LayerColor:create(cc.c4b(100,100,100,0),w,h)
            :setPosition(cc.p(30+200, osHeight-h-4-200))
            -- :setVisible(false)
            :addTo(Layer1, CEnum.ZOrder.gameingView_myself_voice)
    end

    if sc_view_L == nil then
        sc_view_L =  cc.ui.UIScrollView.new({
            viewRect = cc.rect(0,0, bg_view_L:getContentSize().width, bg_view_L:getContentSize().height), 
            direction = 1
        })
        sc_view_L:setBounceable(false) -- 回弹效果去掉，就不会出现貌似滑动的效果
        bg_view_L:addChild(sc_view_L)
    else
        if not tolua.isnull(sc_view_L) then
            sc_view_L:removeFromParent()
            sc_view_L = nil
        end
        sc_view_L = cc.ui.UIScrollView.new({
            viewRect = cc.rect(0,0, bg_view_L:getContentSize().width, bg_view_L:getContentSize().height),
            direction = 1
        })
        sc_view_L:setBounceable(false) -- 回弹效果去掉，就不会出现貌似滑动的效果
        bg_view_L:addChild(sc_view_L)
    end

    -- 我手上具体有多少张牌，一张张加入
    local t_data = {}
    ---[[
    for k,v in pairs(_handCardDataTable_RL) do
        --CDAlert.new():popDialogBox(Layer1,"666")
        -- 每个小背包
        local png = cc.LayerColor:create(cc.c4b(160,160,160,0), boxSize_RL.width, boxSize_RL.height)
        png:setTouchSwallowEnabled(false)
        --把layer当作精灵来处理
        png:ignoreAnchorPointForPosition(false)

        t_data[#t_data+1] = png

        ---[[
        -- 不能移动的手牌显示，可以放这里
        local img_vv = GameingDealUtil:getImgByHandcard(CEnum.userCard.hand, v)
        cc.ui.UIPushButton.new(img_vv, {scale9 = false})
                :setButtonSize(objSize_RL.width, objSize_RL.height)
                :align(display.CENTER, png:getContentSize().width/2, png:getContentSize().height/2)
                :addTo(png)
        -- display.newTTFLabel({
        --         text = k, 
        --         --text = "",
        --         size = 30, 
        --         color = cc.c3b(100,100,100)
        --     })
        --     :align(display.CENTER, png:getContentSize().width/2, png:getContentSize().height/2)
        --     :addTo(png)
        --]]
    end
    sc_view_L:fill(t_data, {itemSize = (t_data[#t_data]):getContentSize()})
    SCROLL_HANDLER_SLIDE(sc_view_L)
    S_XY(sc_view_L:getScrollNode(), 0, sc_view_L:getViewRect().height-H(sc_view_L:getScrollNode()) )
    --]]
end

-- 场景刚进入
function GameingScene:onEnter()
end

-- 场景退出
function GameingScene:onExit()
	Commons:printLog_Info("GameingScene:onExit")

    isConnected_sockk_nums = 1
    isMyManual = true -- 不能再重连

    -- 时间表
    if top_scheduler ~= nil and top_schedulerID ~= nil then
        top_scheduler:unscheduleScriptEntry(top_schedulerID)
        top_schedulerID = nil
	end

    -- 网络监听
    if top_scheduler ~= nil and top_schedulerID_network ~= nil then
        top_scheduler:unscheduleScriptEntry(top_schedulerID_network)
        top_schedulerID_network = nil
    end

    -- 关闭倒计时
    GameingScene:killTimeTick(myself_view_timer)

    top_scheduler = nil

    user_icon = nil
    user_nickname = nil
    user_account = nil
    user_ip = nil
    user_rights = nil

    user_icon_xiajia = nil
    user_nickname_xiajia = nil
    user_account_xiajia = nil
    user_ip_xiajia = nil

    user_icon_lastjia = nil
    user_nickname_lastjia = nil
    user_account_lastjia = nil
    user_ip_lastjia = nil

    myself_invite_title = ""
    myself_invite_content = ""

    -- 我手上的牌
    t_data = nil -- 层的数组
    t_drag = nil -- 可拖拽的对象
    _handCardDataTable = nil -- 手上的牌集合

    -- 出牌区域
    -- box_chupai = nil
    if box_chupai ~= nil and (not tolua.isnull(box_chupai)) then
        box_chupai:removeFromParent()
        box_chupai = nil
    end
    --chu_tipimg = nil
    --chu_anim = nil

    -- 手牌
    -- bg_view = nil
    -- sc_view = nil
    if sc_view ~= nil and (not tolua.isnull(sc_view)) then
        sc_view:removeFromParent()
        sc_view = nil
    end
    if bg_view ~= nil and (not tolua.isnull(bg_view)) then
        bg_view:removeFromParent()
        bg_view = nil
    end

    CVar._static.voiceWaitDownTable = {}
    CVar._static.voiceWaitPlayTable = {}

    CVar._static.mSocket:CloseSocket(); -- socket关闭

    -- if myself_view_xxg~=nil and (not tolua.isnull(myself_view_xxg)) then
    --     myself_view_xxg:removeFromParent()
    --     myself_view_xxg = nil
    -- end
    -- if xiajia_view_xxg~=nil and (not tolua.isnull(xiajia_view_xxg)) then
    --     xiajia_view_xxg:removeFromParent()
    --     xiajia_view_xxg = nil
    -- end
    -- if lastjia_view_xxg~=nil and (not tolua.isnull(lastjia_view_xxg)) then
    --     lastjia_view_xxg:removeFromParent()
    --     lastjia_view_xxg = nil
    -- end

    GameingScene:myExit(); -- 清除变量

	self:removeAllChildren(); -- 清除组件
end

function GameingScene:myExit()
	---[[
    -- 这个类的类变量要全部恢复初始值

    Layer1 = nil
    loadingSpriteAnim = nil -- 开局等待动画
    CVar._static.mSocket = nil  -- 此类中的全局变量 socket发送消息的对象

    -- 顶部
	-- top_view = nil
	top_view_roomNo = nil
	top_view_ju = nil
    if top_view ~= nil and (not tolua.isnull(top_view)) then
        top_view:removeFromParent()
        top_view = nil
    end

    -- -- topRule_view = nil
    -- topRule_view_noConnectServer = nil
    if topRule_view_noConnectServer ~= nil and (not tolua.isnull(topRule_view_noConnectServer)) then
        topRule_view_noConnectServer:removeFromParent()
        topRule_view_noConnectServer = nil
    end
    -- top_view_dissRoom = nil
    if top_view_dissRoom ~= nil and (not tolua.isnull(top_view_dissRoom)) then
        top_view_dissRoom:removeFromParent()
        top_view_dissRoom = nil
    end
    -- top_view_backRoom = nil
    if top_view_backRoom ~= nil and (not tolua.isnull(top_view_backRoom)) then
        top_view_backRoom:removeFromParent()
        top_view_backRoom = nil
    end


    --本人
	-- myself_view = nil
	myself_view_nickname = nil
	myself_view_icon = nil
	myself_view_score = nil
	myself_view_xi = nil
	myself_view_isBanker = nil
	myself_view_timer = nil
	myself_view_isPrepareOK = nil
	myself_view_btn_Prepare = nil

    myself_view_chuguo_list = nil -- 出过的牌集合
    myself_view_chiguo_list = nil -- 吃过、碰过等等的牌集合

    myself_view_mo_chu_pai_bg = nil
    myself_view_mo_chu_pai = nil

    myself_view_needOption_list = nil -- 吃、碰、过、胡才有的选择

    myself_view_emoji = nil
    if myself_view ~= nil and (not tolua.isnull(myself_view)) then
        myself_view:removeFromParent()
        myself_view = nil
    end
	
    -- 相对本人 的下一玩家
    -- xiajia_view = nil
    xiajia_view_nickname = nil
    xiajia_view_offline = nil
    xiajia_view_icon = nil
    xiajia_view_score = nil
    xiajia_view_xi = nil
    xiajia_view_isBanker = nil
    xiajia_view_timer = nil
    xiajia_view_isPrepareOK = nil
    xiajia_view_btn_Prepare = nil

    xiajia_view_chuguo_list = nil -- 出过的牌集合
    xiajia_view_chiguo_list = nil -- 吃过、碰过等等的牌集合

    xiajia_view_mo_chu_pai_bg = nil
	xiajia_view_mo_chu_pai = nil

    xiajia_view_emoji = nil
    if xiajia_view ~= nil and (not tolua.isnull(xiajia_view)) then
        xiajia_view:removeFromParent()
        xiajia_view = nil
    end

    -- 相对本人 的上一玩家，也是最后一玩家
    -- lastjia_view = nil
    lastjia_view_nickname = nil
    lastjia_view_offline = nil
    lastjia_view_icon = nil
    lastjia_view_score = nil
    lastjia_view_xi = nil
    lastjia_view_isBanker = nil
    lastjia_view_timer = nil
    lastjia_view_isPrepareOK = nil
    lastjia_view_btn_Prepare = nil

    lastjia_view_chuguo_list = nil -- 出过的牌集合
    lastjia_view_chiguo_list = nil -- 吃过、碰过等等的牌集合

    lastjia_view_mo_chu_pai_bg = nil
	lastjia_view_mo_chu_pai = nil

    lastjia_view_emoji = nil
    if lastjia_view ~= nil and (not tolua.isnull(lastjia_view)) then
        lastjia_view:removeFromParent()
        lastjia_view = nil
    end

	-- 底牌
	-- dcard_view = nil
	-- dcard_view_nums = nil
    if dcard_view_nums ~= nil and (not tolua.isnull(dcard_view_nums)) then
        dcard_view_nums:removeFromParent()
        dcard_view_nums = nil
    end
    if dcard_view ~= nil and (not tolua.isnull(dcard_view)) then
        dcard_view:removeFromParent()
        dcard_view = nil
    end
	--]]
end

function GameingScene:killTimeTick(needView)
    -- 倒计时
    if top_scheduler ~= nil and run_logic_id ~= nil then
        --Commons:printLog_Info("---1111111111--3 初始化这里run_logic_id:",run_logic_id)
        top_scheduler:unscheduleScriptEntry(run_logic_id)  
        run_logic_id = nil
        needView:hide()
        second = CVar._static.clockWiseTime  
    end
end

function GameingScene:updateTimeTickLabel(needView)
    --倒计时更新函数  开始倒计时 每1秒调用一次anticlockwiseUpdate方法
    if run_logic_id ~= nil then
        --Commons:printLog_Info("---1111111111--3 初始化这里run_logic_id:",run_logic_id)
        top_scheduler:unscheduleScriptEntry(run_logic_id)  
        run_logic_id = nil
        if needView and not tolua.isnull(needView) then
            needView:hide()
        end
        second = CVar._static.clockWiseTime  
    end
    if needView and not tolua.isnull(needView) then
        needView:show()
    end
    run_logic_id = top_scheduler:scheduleScriptFunc(function() GameingScene:anticlockwiseUpdate(needView) end,1,false)
    Commons:printLog_Info("---1111111111-- 初始化这里run_logic_id:",run_logic_id)
end

-- local isLeft3second = false -- 是否有过一次低于3秒的闹钟告警声音
-- 倒计时
function GameingScene:anticlockwiseUpdate(needView) 
    local timeView = needView
    -- if chu_seatNo == CEnum.seatNo.me then
    --     timeView = myself_view_timer
    -- elseif chu_seatNo == CEnum.seatNo.R then
    --     timeView = xiajia_view_timer
    -- elseif chu_seatNo == CEnum.seatNo.L then
    --     timeView = lastjia_view_timer
    -- end

    second = second-1 
    --Commons:printLog_Info("---33333333--11 要关闭了second:",second) 
    if second == -1 then  
        if minute ~= -1 or hour ~= -1 then  
            minute = minute-1  
            second = 59  
            if minute == -1 then  
                if hour ~= -1 then  
                    hour = hour-1  
                    minute = 59  
                    if hour == -1 then  
                        --倒计时结束停止更新  
                        Commons:printLog_Info("---33333333--555 要关闭了",run_logic_id)
                        if run_logic_id ~= nil then  
                            --Commons:printLog_Info("---33333333--666 要关闭了",run_logic_id)
                            top_scheduler:unscheduleScriptEntry(run_logic_id)  
                            run_logic_id = nil
                            --timeView:setVisible(false)
                            --if chu_seatNo == CEnum.seatNo.init then
                            --    myself_view_timer:setVisible(false)
                            --    xiajia_view_timer:setVisible(false)
                            --    lastjia_view_timer:setVisible(false)
                            --end
                        end  
                        second = CVar._static.clockWiseTime  
                        minute = 0  
                        hour = 0  
                        --timeView:setColor(ccc3(255,0,0)) --以红色标识结束  
                    end  
                end  
            end  
        end  
    end

    -- 响起告警声音
    -- if second == 3 then
    --     isLeft3second = true
    --     VoiceDealUtil:playSound_other(VoicesM.file.timeup_alarm)
    -- else
    --     if isLeft3second then -- 有过一次低于3秒的闹钟告警声音
    --         if second > 3 then -- 如果大于三，说明又是新的开始，闹钟告警声音立马抢占停止
    --             isLeft3second = false
    --             VoiceDealUtil:playSound_other(VoicesM.file.empty_sound)
    --         end
    --     end
    -- end

    --Commons:printLog_Info("---33333333--22 要关闭了second:",second) 

    --将int类型转换为string类型
    second = second..""  
    minute = minute..""  
    hour = hour.."" 
    _clockWiseTime = CVar._static.clockWiseTime..""

    --当显示数字为个位数时，前位用0补上      
    if string.len(second) == 1 then  
        second = "0"..second  
    end  
      
    if string.len(minute) == 1 then  
        minute = "0"..minute  
    end  
      
    if string.len(hour) == 1 then  
        hour = "0"..hour  
    end  

    if string.len(_clockWiseTime) == 1 then  
        _clockWiseTime = "0".._clockWiseTime  
    end

    --Commons:printLog_Info("---33333333--22 要关闭了 second:",second) 
    --Commons:printLog_Info("---33333333--22 要关闭了 _clockWiseTime:",_clockWiseTime)
    if second ~= _clockWiseTime then
        --timeView:setString("倒计时："..hour..":"..minute..":"..second)
        timeView:setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
                UILabelType = 2,
                text = "" .. second,
                size = Dimens.TextSize_25,
                color = Colors:_16ToRGB(Colors.gameing_time),
                font = Fonts.Font_hkyt_w7,
                }))
    end
end

function GameingScene:myKeypad(event)
    Commons:printLog_Info("event.key：" .. event.key, "type.key:"..type(event.key))

    if event ~= nil and event.key == "back" then
        --CAlert:new():show("提示","确定要退出游戏吗？", function() GameingScene:myOK() end, function() GameingScene:myNO() end)

    elseif event ~= nil and event.key == "77" then -- 数字 1 连接上
        local SockMsg = import("app.common.net.socket.SocketMsg")
        SockMsg:Connect(Sockets.connect.ip, Sockets.connect.port, function(...) GameingScene:resDataSocket(...) end)
        CVar._static.mSocket = SockMsg

        CVar._static.mSocket:tcpConnected()

    elseif event ~= nil and event.key == "78" then -- 数字 2 房主登录房间
        CVar._static.mSocket:tcpReceiveData( SocketResponseDataTest.new():res_loginRoom() )

    elseif event ~= nil and event.key == "79" then -- 数字 3 第2个玩家上线
        CVar._static.mSocket:tcpReceiveData( SocketResponseDataTest.new():res_loginRoom_playerLoginRoom_xiajia() )

    elseif event ~= nil and event.key == "80" then -- 数字 4 第3个玩家上线 也可以同时支持2个同时上线
        CVar._static.mSocket:tcpReceiveData( SocketResponseDataTest.new():res_loginRoom_playerLoginRoom_lastjia() )

    elseif event ~= nil and event.key == "81" then -- 数字 5 玩家全部在线 游戏开始拉
        CVar._static.mSocket:tcpReceiveData( SocketResponseDataTest.new():res_gameing_Start() )

    elseif event ~= nil and event.key == "140" then -- 字母 Q 下家吃牌 动画效果显示而已
        CVar._static.mSocket:tcpReceiveData( SocketResponseDataTest.new():res_gameing_Chi_xiajia() )

    elseif event ~= nil and event.key == "146" then -- 字母 W 本人已经吃牌 动画效果显示而已
        CVar._static.mSocket:tcpReceiveData( SocketResponseDataTest.new():res_gameing_Chi_myself() )

    elseif event ~= nil and event.key == "128" then -- 字母 E 本人需要吃牌 选择吃牌方案
        CVar._static.mSocket:tcpReceiveData( SocketResponseDataTest.new():res_gameing_Chi_myself_needChi() )

    elseif event ~= nil and event.key == "124" then -- 字母 A 玩家 离线或者跑路
        -- CVar._static.mSocket:tcpReceiveData( SocketResponseDataTest.new():res_gameing_playerExitRoom() ) -- 游戏开始 玩家离线
        CVar._static.mSocket:tcpReceiveData( SocketResponseDataTest.new():res_gameing_playerOutRoom() ) -- 游戏未开始 玩家跑路

    elseif event ~= nil and event.key == "142" then -- 字母 S 解散房间申请反馈给其他玩家  等待其他玩家确认
        CVar._static.mSocket:tcpReceiveData( SocketResponseDataTest.new():res_dissRoom_new() )
        -- CVar._static.mSocket:tcpReceiveData( PDKSocketResponseDataTest:res_gameing_IP_check() )

    elseif event ~= nil and event.key == "129" then -- 字母 F 测试又有新的人同意解散的页面显示效果
        CVar._static.mSocket:tcpReceiveData( SocketResponseDataTest.new():res_dissRoom_new2() )

    elseif event ~= nil and event.key == "127" then -- 字母 D 大家同意散场，解散房间拉
        CVar._static.mSocket:tcpReceiveData( SocketResponseDataTest.new():res_dissRoom_success() )

    elseif event ~= nil and event.key == "149" then -- 字母 Z 游戏结束
        CVar._static.mSocket:tcpReceiveData( SocketResponseDataTest.new():res_gameing_Over() )

    elseif event ~= nil and event.key == "147" then -- 字母 X 下一玩家发出的 表情
        -- CVar._static.mSocket:tcpReceiveData( SocketResponseDataTest.new():res_gameing_SendEmoji("sj",2) )
        -- CVar._static.mSocket:tcpReceiveData( SocketResponseDataTest:res_gameing_SendWords("s01",2) )
        CVar._static.mSocket:tcpReceiveData( MJSocketResponseDataTest.new():res_gameing_SendSuperEmoji("2", 2, 1) )
    elseif event ~= nil and event.key == "126" then -- 字母 C 最后一个玩家发出的 表情
        -- CVar._static.mSocket:tcpReceiveData( SocketResponseDataTest.new():res_gameing_SendEmoji("sj",0) )
        CVar._static.mSocket:tcpReceiveData( SocketResponseDataTest:res_gameing_SendWords("s01",0) )

    elseif event ~= nil and event.key == "132" then -- 字母 i 本人 不停的说话
        CVar._static.mSocket:tcpReceiveData( SocketResponseDataTest.new():res_gameing_SendVoice(nil,1) )
    elseif event ~= nil and event.key == "137" then -- 字母 N R 下一玩家发出的 录音
        CVar._static.mSocket:tcpReceiveData( SocketResponseDataTest.new():res_gameing_SendVoice(nil,2) )
    elseif event ~= nil and event.key == "136" then -- 字母 M  L 最后一个玩家发出的 录音
        CVar._static.mSocket:tcpReceiveData( SocketResponseDataTest.new():res_gameing_SendVoice(nil,0) )

    elseif event ~= nil and event.key == "145" then -- 字母 V 假设scoket连接失败
        CVar._static.mSocket:tcpClosed()

    elseif event ~= nil and event.key == "125" then -- 字母 B 假设scoket连接又好拉
        CVar._static.mSocket:tcpConnected()

    elseif event ~= nil and event.key == "139" then -- 字母 P 准备
        CVar._static.mSocket:tcpReceiveData( SocketResponseDataTest.new():res_gameing_Prepare() )
    end
end

function GameingScene:testNodeClick()
    ---[[
    local test_node = display.newNode() --cc.NodeGrid:create()
            :addTo(Layer1, 29999)

    cc.ui.UIPushButton.new(Imgs.c_check_no_test,{scale9=false})
        --:setButtonSize(80, 80)
        :setButtonImage(EnStatus.pressed, Imgs.c_check_yes_test)
        :setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
            UILabelType = 2,
            text = "1", -- 到了房间，socket初始化
            size = Dimens.TextSize_30,
            color = Colors:_16ToRGB(Colors.gameing_roomNo),
            align = cc.ui.TEXT_ALIGN_CENTER,
            valign = cc.ui.TEXT_VALIGN_CENTER,
         }))
        :onButtonClicked(function(e)
            local SockMsg = import("app.common.net.socket.SocketMsg");
            SockMsg:Connect(Sockets.connect.ip, Sockets.connect.port, function(...) GameingScene:resDataSocket(...) end)
            CVar._static.mSocket = SockMsg

            CVar._static.mSocket:tcpConnected()
        end)
        :align(display.LEFT_TOP, 25 +80*0, osHeight-50)
        :addTo(test_node)

    cc.ui.UIPushButton.new(Imgs.c_check_no_test,{scale9=false})
        --:setButtonSize(80, 80)
        :setButtonImage(EnStatus.pressed, Imgs.c_check_yes_test)
        :setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
            UILabelType = 2,
            text = "2", -- 我自己登录房间，创建房间
            size = Dimens.TextSize_30,
            color = Colors:_16ToRGB(Colors.gameing_roomNo),
            align = cc.ui.TEXT_ALIGN_CENTER,
            valign = cc.ui.TEXT_VALIGN_CENTER,
         }))
        :onButtonClicked(function(e)
            CVar._static.mSocket:tcpReceiveData( SocketResponseDataTest.new():res_loginRoom() )
        end)
        :align(display.LEFT_TOP, 25 +80*1, osHeight-50)
        :addTo(test_node)

    cc.ui.UIPushButton.new(Imgs.c_check_no_test,{scale9=false})
        --:setButtonSize(80, 80)
        :setButtonImage(EnStatus.pressed, Imgs.c_check_yes_test)
        :setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
            UILabelType = 2,
            text = "3", -- 下一家上线
            size = Dimens.TextSize_30,
            color = Colors:_16ToRGB(Colors.gameing_roomNo),
            align = cc.ui.TEXT_ALIGN_CENTER,
            valign = cc.ui.TEXT_VALIGN_CENTER,
         }))
        :onButtonClicked(function(e)
            CVar._static.mSocket:tcpReceiveData( SocketResponseDataTest.new():res_loginRoom_playerLoginRoom_xiajia() )
        end)
        :align(display.LEFT_TOP, 25 +80*2, osHeight-50)
        :addTo(test_node)

    cc.ui.UIPushButton.new(Imgs.c_check_no_test,{scale9=false})
        --:setButtonSize(80, 80)
        :setButtonImage(EnStatus.pressed, Imgs.c_check_yes_test)
        :setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
            UILabelType = 2,
            text = "4", -- 最后一家上线
            size = Dimens.TextSize_30,
            color = Colors:_16ToRGB(Colors.gameing_roomNo),
            align = cc.ui.TEXT_ALIGN_CENTER,
            valign = cc.ui.TEXT_VALIGN_CENTER,
         }))
        :onButtonClicked(function(e)
            CVar._static.mSocket:tcpReceiveData( SocketResponseDataTest.new():res_loginRoom_playerLoginRoom_lastjia() )
        end)
        :align(display.LEFT_TOP, 25 +80*3, osHeight-50)
        :addTo(test_node)

    cc.ui.UIPushButton.new(Imgs.c_check_no_test,{scale9=false})
        --:setButtonSize(80, 80)
        :setButtonImage(EnStatus.pressed, Imgs.c_check_yes_test)
        :setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
            UILabelType = 2,
            text = "5", -- 游戏开始
            size = Dimens.TextSize_30,
            color = Colors:_16ToRGB(Colors.gameing_roomNo),
            align = cc.ui.TEXT_ALIGN_CENTER,
            valign = cc.ui.TEXT_VALIGN_CENTER,
         }))
        :onButtonClicked(function(e)
            CVar._static.mSocket:tcpReceiveData( SocketResponseDataTest.new():res_gameing_Start() )
        end)
        :align(display.LEFT_TOP, 25 +80*4, osHeight-50)
        :addTo(test_node)

    cc.ui.UIPushButton.new(Imgs.c_check_no_test,{scale9=false})
        --:setButtonSize(80, 80)
        :setButtonImage(EnStatus.pressed, Imgs.c_check_yes_test)
        :setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
            UILabelType = 2,
            text = "Q", -- 下家吃牌
            size = Dimens.TextSize_30,
            color = Colors:_16ToRGB(Colors.gameing_roomNo),
            align = cc.ui.TEXT_ALIGN_CENTER,
            valign = cc.ui.TEXT_VALIGN_CENTER,
         }))
        :onButtonClicked(function(e)
            CVar._static.mSocket:tcpReceiveData( SocketResponseDataTest.new():res_gameing_Chi_xiajia() )
        end)
        :align(display.LEFT_TOP, 25 +80*5, osHeight-50)
        :addTo(test_node)

    cc.ui.UIPushButton.new(Imgs.c_check_no_test,{scale9=false})
        --:setButtonSize(80, 80)
        :setButtonImage(EnStatus.pressed, Imgs.c_check_yes_test)
        :setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
            UILabelType = 2,
            text = "W", -- 我吃牌
            size = Dimens.TextSize_30,
            color = Colors:_16ToRGB(Colors.gameing_roomNo),
            align = cc.ui.TEXT_ALIGN_CENTER,
            valign = cc.ui.TEXT_VALIGN_CENTER,
         }))
        :onButtonClicked(function(e)
            CVar._static.mSocket:tcpReceiveData( SocketResponseDataTest.new():res_gameing_Chi_myself() )
        end)
        :align(display.LEFT_TOP, 25 +80*6, osHeight-50)
        :addTo(test_node)

    cc.ui.UIPushButton.new(Imgs.c_check_no_test,{scale9=false})
        --:setButtonSize(80, 80)
        :setButtonImage(EnStatus.pressed, Imgs.c_check_yes_test)
        :setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
            UILabelType = 2,
            text = "E", -- 我吃碰胡等选择操作
            size = Dimens.TextSize_30,
            color = Colors:_16ToRGB(Colors.gameing_roomNo),
            align = cc.ui.TEXT_ALIGN_CENTER,
            valign = cc.ui.TEXT_VALIGN_CENTER,
         }))
        :onButtonClicked(function(e)
            CVar._static.mSocket:tcpReceiveData( SocketResponseDataTest.new():res_gameing_Chi_myself_needChi() )
        end)
        :align(display.LEFT_TOP, 25 +80*7, osHeight-50)
        :addTo(test_node)

    cc.ui.UIPushButton.new(Imgs.c_check_no_test,{scale9=false})
        --:setButtonSize(80, 80)
        :setButtonImage(EnStatus.pressed, Imgs.c_check_yes_test)
        :setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
            UILabelType = 2,
            text = "A", -- 玩家退出房间
            size = Dimens.TextSize_30,
            color = Colors:_16ToRGB(Colors.gameing_roomNo),
            align = cc.ui.TEXT_ALIGN_CENTER,
            valign = cc.ui.TEXT_VALIGN_CENTER,
         }))
        :onButtonClicked(function(e)
            -- CVar._static.mSocket:tcpReceiveData( SocketResponseDataTest.new():res_gameing_playerExitRoom() )
            CVar._static.mSocket:tcpReceiveData( SocketResponseDataTest.new():res_gameing_playerOutRoom() )
        end)
        :align(display.LEFT_TOP, 25 +80*8, osHeight-50)
        :addTo(test_node)

    cc.ui.UIPushButton.new(Imgs.c_check_no_test,{scale9=false})
        --:setButtonSize(80, 80)
        :setButtonImage(EnStatus.pressed, Imgs.c_check_yes_test)
        :setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
            UILabelType = 2,
            text = "S", -- 旧的解散房间界面
            size = Dimens.TextSize_30,
            color = Colors:_16ToRGB(Colors.gameing_roomNo),
            align = cc.ui.TEXT_ALIGN_CENTER,
            valign = cc.ui.TEXT_VALIGN_CENTER,
         }))
        :onButtonClicked(function(e)
            CVar._static.mSocket:tcpReceiveData( SocketResponseDataTest.new():res_dissRoom_new() )
            -- CVar._static.mSocket:tcpReceiveData( PDKSocketResponseDataTest:res_gameing_IP_check() )
        end)
        :align(display.LEFT_TOP, 25 +80*10, osHeight-50)
        :addTo(test_node)

    cc.ui.UIPushButton.new(Imgs.c_check_no_test,{scale9=false})
        --:setButtonSize(80, 80)
        :setButtonImage(EnStatus.pressed, Imgs.c_check_yes_test)
        :setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
            UILabelType = 2,
            text = "F", -- 新的解散房间界面
            size = Dimens.TextSize_30,
            color = Colors:_16ToRGB(Colors.gameing_roomNo),
            align = cc.ui.TEXT_ALIGN_CENTER,
            valign = cc.ui.TEXT_VALIGN_CENTER,
         }))
        :onButtonClicked(function(e)
            CVar._static.mSocket:tcpReceiveData( SocketResponseDataTest.new():res_dissRoom_new2() )
        end)
        :align(display.LEFT_TOP, 25 +80*10, osHeight-50*2)
        :addTo(test_node)

    cc.ui.UIPushButton.new(Imgs.c_check_no_test,{scale9=false})
        --:setButtonSize(80, 80)
        :setButtonImage(EnStatus.pressed, Imgs.c_check_yes_test)
        :setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
            UILabelType = 2,
            text = "D", -- 房间解散成功
            size = Dimens.TextSize_30,
            color = Colors:_16ToRGB(Colors.gameing_roomNo),
            align = cc.ui.TEXT_ALIGN_CENTER,
            valign = cc.ui.TEXT_VALIGN_CENTER,
         }))
        :onButtonClicked(function(e)
            CVar._static.mSocket:tcpReceiveData( SocketResponseDataTest.new():res_dissRoom_success() )
        end)
        :align(display.LEFT_TOP, 25 +80*11, osHeight-50)
        :addTo(test_node)

    cc.ui.UIPushButton.new(Imgs.c_check_no_test,{scale9=false})
        --:setButtonSize(80, 80)
        :setButtonImage(EnStatus.pressed, Imgs.c_check_yes_test)
        :setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
            UILabelType = 2,
            text = "Z", -- 游戏结束
            size = Dimens.TextSize_30,
            color = Colors:_16ToRGB(Colors.gameing_roomNo),
            align = cc.ui.TEXT_ALIGN_CENTER,
            valign = cc.ui.TEXT_VALIGN_CENTER,
         }))
        :onButtonClicked(function(e)
            CVar._static.mSocket:tcpReceiveData( SocketResponseDataTest.new():res_gameing_Over() )
        end)
        :align(display.LEFT_TOP, 25 +80*12, osHeight-50)
        :addTo(test_node)

    cc.ui.UIPushButton.new(Imgs.c_check_no_test,{scale9=false})
        --:setButtonSize(80, 80)
        :setButtonImage(EnStatus.pressed, Imgs.c_check_yes_test)
        :setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
            UILabelType = 2,
            text = "X", -- 下一家表情
            size = Dimens.TextSize_30,
            color = Colors:_16ToRGB(Colors.gameing_roomNo),
            align = cc.ui.TEXT_ALIGN_CENTER,
            valign = cc.ui.TEXT_VALIGN_CENTER,
         }))
        :onButtonClicked(function(e)
            -- CVar._static.mSocket:tcpReceiveData( SocketResponseDataTest.new():res_gameing_SendEmoji("wx", 2) )
            CVar._static.mSocket:tcpReceiveData( SocketResponseDataTest:res_gameing_SendWords("s01",2) )
        end)
        :align(display.LEFT_TOP, 25 +80*13, osHeight-50*2)
        :addTo(test_node)

    cc.ui.UIPushButton.new(Imgs.c_check_no_test,{scale9=false})
        --:setButtonSize(80, 80)
        :setButtonImage(EnStatus.pressed, Imgs.c_check_yes_test)
        :setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
            UILabelType = 2,
            text = "C", -- 最后一家表情
            size = Dimens.TextSize_30,
            color = Colors:_16ToRGB(Colors.gameing_roomNo),
            align = cc.ui.TEXT_ALIGN_CENTER,
            valign = cc.ui.TEXT_VALIGN_CENTER,
         }))
        :onButtonClicked(function(e)
            -- CVar._static.mSocket:tcpReceiveData( SocketResponseDataTest.new():res_gameing_SendEmoji("wx",0) )
            CVar._static.mSocket:tcpReceiveData( SocketResponseDataTest:res_gameing_SendWords("s01",0) )
        end)
        :align(display.LEFT_TOP, 25 +80*13, osHeight-50*3)
        :addTo(test_node)

    cc.ui.UIPushButton.new(Imgs.c_check_no_test,{scale9=false})
        --:setButtonSize(80, 80)
        :setButtonImage(EnStatus.pressed, Imgs.c_check_yes_test)
        :setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
            UILabelType = 2,
            text = "i", -- 模拟录音
            size = Dimens.TextSize_30,
            color = Colors:_16ToRGB(Colors.gameing_roomNo),
            align = cc.ui.TEXT_ALIGN_CENTER,
            valign = cc.ui.TEXT_VALIGN_CENTER,
         }))
        :onButtonClicked(function(e)
            CVar._static.mSocket:tcpReceiveData( SocketResponseDataTest.new():res_gameing_SendVoice(nil,1) )
        end)
        :align(display.LEFT_TOP, 25 +80*14, osHeight-50)
        :addTo(test_node)

    cc.ui.UIPushButton.new(Imgs.c_check_no_test,{scale9=false})
        --:setButtonSize(80, 80)
        :setButtonImage(EnStatus.pressed, Imgs.c_check_yes_test)
        :setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
            UILabelType = 2,
            text = "N", -- 录音来至于下一家
            size = Dimens.TextSize_30,
            color = Colors:_16ToRGB(Colors.gameing_roomNo),
            align = cc.ui.TEXT_ALIGN_CENTER,
            valign = cc.ui.TEXT_VALIGN_CENTER,
         }))
        :onButtonClicked(function(e)
            CVar._static.mSocket:tcpReceiveData( SocketResponseDataTest.new():res_gameing_SendVoice(nil,2) )
        end)
        :align(display.LEFT_TOP, 25 +80*14, osHeight-50*2)
        :addTo(test_node)

    cc.ui.UIPushButton.new(Imgs.c_check_no_test,{scale9=false})
        --:setButtonSize(80, 80)
        :setButtonImage(EnStatus.pressed, Imgs.c_check_yes_test)
        :setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
            UILabelType = 2,
            text = "M", -- 录音来至于最后一家
            size = Dimens.TextSize_30,
            color = Colors:_16ToRGB(Colors.gameing_roomNo),
            align = cc.ui.TEXT_ALIGN_CENTER,
            valign = cc.ui.TEXT_VALIGN_CENTER,
         }))
        :onButtonClicked(function(e)
            CVar._static.mSocket:tcpReceiveData( SocketResponseDataTest.new():res_gameing_SendVoice(nil,0) )
        end)
        :align(display.LEFT_TOP, 25 +80*14, osHeight-50*3)
        :addTo(test_node)

    cc.ui.UIPushButton.new(Imgs.c_check_no_test,{scale9=false})
        --:setButtonSize(80, 80)
        :setButtonImage(EnStatus.pressed, Imgs.c_check_yes_test)
        :setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
            UILabelType = 2,
            text = "V", -- socket断开
            size = Dimens.TextSize_30,
            color = Colors:_16ToRGB(Colors.gameing_roomNo),
            align = cc.ui.TEXT_ALIGN_CENTER,
            valign = cc.ui.TEXT_VALIGN_CENTER,
         }))
        :onButtonClicked(function(e)
            CVar._static.mSocket:tcpClosed()
        end)
        :align(display.LEFT_TOP, 25 +80*15, osHeight-50)
        :addTo(test_node)

    cc.ui.UIPushButton.new(Imgs.c_check_no_test,{scale9=false})
        --:setButtonSize(80, 80)
        :setButtonImage(EnStatus.pressed, Imgs.c_check_yes_test)
        :setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
            UILabelType = 2,
            text = "B", -- socket重新连接好了
            size = Dimens.TextSize_30,
            color = Colors:_16ToRGB(Colors.gameing_roomNo),
            align = cc.ui.TEXT_ALIGN_CENTER,
            valign = cc.ui.TEXT_VALIGN_CENTER,
         }))
        :onButtonClicked(function(e)
            CVar._static.mSocket:tcpConnected()
        end)
        :align(display.LEFT_TOP, 25 +80*15, osHeight-50*2)
        :addTo(test_node)

    cc.ui.UIPushButton.new(Imgs.c_check_no_test,{scale9=false})
        --:setButtonSize(80, 80)
        :setButtonImage(EnStatus.pressed, Imgs.c_check_yes_test)
        :setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
            UILabelType = 2,
            text = "P", -- 再次准备
            size = Dimens.TextSize_30,
            color = Colors:_16ToRGB(Colors.gameing_roomNo),
            align = cc.ui.TEXT_ALIGN_CENTER,
            valign = cc.ui.TEXT_VALIGN_CENTER,
         }))
        :onButtonClicked(function(e)
            CVar._static.mSocket:tcpReceiveData( SocketResponseDataTest.new():res_gameing_Prepare() )
        end)
        :align(display.LEFT_TOP, 25 +80*15, osHeight-50*3)
        :addTo(test_node) 
    --]]
end


-- 必须的返回值
return GameingScene
