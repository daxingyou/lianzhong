--
-- Author: lte
-- Date: 2016-11-05 18:41:34
-- 房间战绩

-- 类申明
local GameingMirrorDialog = class("GameingMirrorDialog")


local osWidth = Commons.osWidth
local osHeight = Commons.osHeight

local parent_mirror
local res_data_mirror
local startTime_mirror

-- 处理方法申明
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

local Layer1

local card_w_out_A = 48 -- 出过的拍
local card_h_out_A = 48
local card_line_out_A = 3 -- 3行
local card_cc_out_A = 5 -- 5列

local card_hu_w = 34 -- 牌局结束之后的底牌
local card_hu_h = 34

-- 顶部
local top_view
local top_view_roomNo
local top_view_ju
-- local top_scheduler
-- local top_schedulerID

-- 地板
local topRule_view_noConnectServer

-- 本人
-- local user_roomNo
local user_icon
local user_nickname
local user_account
-- local user_ip

local myself_view
local myself_view_nickname
local myself_view_icon
local myself_view_score
local myself_view_xi
local myself_view_isBanker
local myself_view_timer
local myself_view_btn_Prepare

local myself_view_chuguo_list -- 出过的牌集合
local myself_view_chiguo_list -- 吃过、碰过等等的牌集合

local myself_view_mo_chu_pai_bg
local myself_view_mo_chu_pai

local myself_view_needOption_list -- 吃、碰、过、胡才有的选择

local myself_view_xxg

-- 相对本人 的下一玩家
local user_icon_xiajia
local user_nickname_xiajia
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
local xiajia_view_btn_Prepare

local xiajia_view_chuguo_list -- 出过的牌集合
local xiajia_view_chiguo_list -- 吃过、碰过等等的牌集合

local xiajia_view_mo_chu_pai_bg
local xiajia_view_mo_chu_pai

local xiajia_view_xxg

-- 相对本人 的上一玩家，也是最后一玩家
local user_icon_lastjia
local user_nickname_lastjia
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
local lastjia_view_btn_Prepare

local lastjia_view_chuguo_list -- 出过的牌集合
local lastjia_view_chiguo_list -- 吃过、碰过等等的牌集合

local lastjia_view_mo_chu_pai_bg
local lastjia_view_mo_chu_pai

local lastjia_view_xxg

-- 底牌
local dcard_view
local dcard_view_nums

-- 本人手牌
local bg_view = nil
local sc_view = nil

-- 拖拽对象
local boxSize = CVar._static.boxSize -- 层的大小
local objSize = CVar._static.objSize -- 牌的大小
local t_data = nil -- 层的数组
--local t_drag = nil -- 可拖拽的对象
local _handCardDataTable = nil -- 手上的牌集合
local _handCardDataTable_RL = nil -- 手上的牌集合
-- local _handCardDataTable_L = nil -- 手上的牌集合

local mySeatNo -- 记录我的位置编号

-- 是不是我出牌
local isMeChu = false
-- 出牌区域
local box_chupai = nil
local chu_tipimg = nil

-- 胡牌效果
local mtView
local ruleView 
local fanCardView
local huCard_tipimg_node
local view_diCards_list


-- 下家手牌
local bg_view_R = nil
local sc_view_R = nil
-- 上家手牌
local bg_view_L = nil
local sc_view_L = nil

local boxSize_RL = CVar._static.boxSize_RL -- 层的大小
local objSize_RL = CVar._static.objSize_RL -- 牌的大小


local pauseBtn
local onAgainBtn
local playBtn
local step_label

-- 创建一个模态弹出框,  parent=要加在哪个上面
function GameingMirrorDialog:popDialogBox(_parent, _res_data, _startTime)

    parent_mirror = _parent
    res_data_mirror = _res_data
    startTime_mirror = _startTime

    Layer1 = display.newColorLayer(cc.c4b(0, 0, 0, 200))       -- 半透明的黑色

    Layer1:setContentSize(osWidth, osHeight)             -- 设置Layer的大小,全屏出现
    --Layer1:align(display.CENTER, display.cx, display.cy) -- Layer的锚点在0.5,0.5 因此对齐的时候要注意
    Layer1:setTouchEnabled(true)
    Layer1:setTouchSwallowEnabled(true)  -- 吞噬下层的响应
    Layer1:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event) -- 点击此Layer时候输出信息,然后把自己销毁        
        return true
    end)
    _parent:addChild(Layer1, CEnum.ZOrder.common_dialog) -- 把Layer添加到父对象上

    if CVar._static.isIphone4 then
        CVar._static.boxSize = cc.size(CVar._static.sCardWH-15, CVar._static.sCardWH-15)
        CVar._static.objSize = cc.size(CVar._static.sCardWH-15, CVar._static.sCardWH+CVar._static.objAddHeight-15)

        CVar._static.boxSize_RL = cc.size(CVar._static.sCardWH_RL-5, CVar._static.sCardWH_RL-5)
        CVar._static.objSize_RL = cc.size(CVar._static.sCardWH_RL-5, CVar._static.sCardWH_RL+CVar._static.objAddHeight-5)

        boxSize = CVar._static.boxSize
        objSize = CVar._static.objSize
        boxSize_RL = CVar._static.boxSize_RL
        objSize_RL = CVar._static.objSize_RL

    elseif CVar._static.isIpad then
        CVar._static.boxSize = cc.size(CVar._static.sCardWH-25, CVar._static.sCardWH-25)
        CVar._static.objSize = cc.size(CVar._static.sCardWH-25, CVar._static.sCardWH+CVar._static.objAddHeight-25)

        CVar._static.boxSize_RL = cc.size(CVar._static.sCardWH_RL-15, CVar._static.sCardWH_RL-15)
        CVar._static.objSize_RL = cc.size(CVar._static.sCardWH_RL-15, CVar._static.sCardWH_RL+CVar._static.objAddHeight-15)

        boxSize = CVar._static.boxSize
        objSize = CVar._static.objSize
        boxSize_RL = CVar._static.boxSize_RL
        objSize_RL = CVar._static.objSize_RL
        
    elseif CVar._static.NavBarH_Android ~= CEnum.status.NavBarH_def then
        local moveCard = CVar._static.NavBarH_Android*0.1
        moveCard = moveCard-moveCard%1
        local moveCard_RL = CVar._static.NavBarH_Android*0.05
        moveCard_RL = moveCard_RL-moveCard_RL%1

        CVar._static.boxSize = cc.size(CVar._static.sCardWH-moveCard, CVar._static.sCardWH-moveCard)
        CVar._static.objSize = cc.size(CVar._static.sCardWH-moveCard, CVar._static.sCardWH+CVar._static.objAddHeight-moveCard)

        CVar._static.boxSize_RL = cc.size(CVar._static.sCardWH_RL-moveCard_RL, CVar._static.sCardWH_RL-moveCard_RL)
        CVar._static.objSize_RL = cc.size(CVar._static.sCardWH_RL-moveCard_RL, CVar._static.sCardWH_RL+CVar._static.objAddHeight-moveCard_RL)

        boxSize = CVar._static.boxSize
        objSize = CVar._static.objSize
        boxSize_RL = CVar._static.boxSize_RL
        objSize_RL = CVar._static.objSize_RL
    end

    -- 整个底色背景
    ---[[
    cc.ui.UIImage.new(Imgs.gameing_bg,{})
        :addTo(Layer1)
    	:align(display.LEFT_TOP, 0, osHeight-0)
    	:setLayoutSize(osWidth-0*2, osHeight-0*2)
    --]]

    -- view
	GameingMirrorDialog:createView()
	GameingMirrorDialog:setViewData()

    -- 操作按钮
    local btn_w_gap = 0
    local btn_w_mirror = 120
    local btn_h_mirror = 116
    local startX_mirror = display.cx -(btn_w_gap+btn_w_mirror)*2 +btn_w_gap+btn_h_mirror/2
    local startY_mirror = display.cy -100 -- -btn_h_mirror/2

    cc.ui.UIPushButton.new(Imgs.gamemirror_bg,{scale9=true})
        :setButtonSize(560, 120)
        :setButtonImage(EnStatus.pressed, Imgs.gamemirror_bg)
        :addTo(Layer1, CEnum.ZOrder.gameingMirror_btn)
        :align(display.CENTER, display.cx, startY_mirror)

    ---[[
    -- 关闭  返回
    cc.ui.UIPushButton.new(Imgs.gamemirror_4back,{scale9=false})
        :setButtonSize(btn_w_mirror, btn_h_mirror)
        -- :setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
        --     UILabelType = 2,
        --     text = "返回",--Strings.common_exit,
        --     size = Dimens.TextSize_30,
        --     color = Colors.btn_disable,
        --     }))
        -- :setButtonLabel(EnStatus.pressed, cc.ui.UILabel.new({
        --     UILabelType = 2,
        --     text = "",--Strings.common_exit,
        --     size = Dimens.TextSize_30,
        --     color = Colors.btn_press,
        --     }))
        :setButtonImage(EnStatus.pressed, Imgs.gamemirror_4back)
        :onButtonClicked(function(e)

            VoiceDealUtil:playSound_other(Voices.file.ui_click)
            GameingMirrorDialog:myCancel()

        end)
    	:addTo(Layer1, CEnum.ZOrder.gameingMirror_btn)
        :align(display.CENTER, startX_mirror +(btn_w_gap+btn_w_mirror)*3, startY_mirror)
    --]]

    ---[[
    -- 慢放按钮
    cc.ui.UIPushButton.new(
        Imgs.gamemirror_1mf,{scale9=false})
        :setButtonSize(btn_w_mirror, btn_h_mirror)
        -- :setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
        --     UILabelType = 2,
        --     text = "慢放",
        --     size = Dimens.TextSize_30,
        --     color = Colors.btn_disable,
        --     }))
        -- :setButtonLabel(EnStatus.pressed, cc.ui.UILabel.new({
        --     UILabelType = 2,
        --     text = "",
        --     size = Dimens.TextSize_30,
        --     color = Colors.btn_press,
        --     }))
        :setButtonImage(EnStatus.pressed, Imgs.gamemirror_1mf)
        :onButtonClicked(function(e)

            showDate_gaptime = showDate_gaptime + showDate_gaptime_m_Step
            if showDate_gaptime >= showDate_gaptimeMax then
                showDate_gaptime = showDate_gaptimeMax
            end

        end)
        :align(display.CENTER, startX_mirror +(btn_w_gap+btn_w_mirror)*0, startY_mirror)
        :addTo(Layer1, CEnum.ZOrder.gameingMirror_btn)
    --]]

    ---[[
    -- 快放按钮
    cc.ui.UIPushButton.new(
        Imgs.gamemirror_3kf,{scale9=false})
        :setButtonSize(btn_w_mirror, btn_h_mirror)
        -- :setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
        --     UILabelType = 2,
        --     text = "快放",
        --     size = Dimens.TextSize_30,
        --     color = Colors.btn_disable,
        --     }))
        -- :setButtonLabel(EnStatus.pressed, cc.ui.UILabel.new({
        --     UILabelType = 2,
        --     text = "",
        --     size = Dimens.TextSize_30,
        --     color = Colors.btn_press,
        --     }))
        :setButtonImage(EnStatus.pressed, Imgs.gamemirror_3kf)
        :onButtonClicked(function(e)

            showDate_gaptime = showDate_gaptime - showDate_gaptime_k_Step
            if showDate_gaptime <= showDate_gaptimeMin then
                showDate_gaptime = showDate_gaptimeMin
            end

        end)
        :align(display.CENTER, startX_mirror +(btn_w_gap+btn_w_mirror)*2, startY_mirror)
        :addTo(Layer1, CEnum.ZOrder.gameingMirror_btn)
    --]]

    ---[[
    -- 暂停按钮
    pauseBtn = cc.ui.UIPushButton.new(
        Imgs.gamemirror_2pause,{scale9=false})
        :setButtonSize(btn_w_mirror, btn_h_mirror)
        -- :setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
        --     UILabelType = 2,
        --     text = "暂停",
        --     size = Dimens.TextSize_30,
        --     color = Colors.btn_disable,
        --     }))
        -- :setButtonLabel(EnStatus.pressed, cc.ui.UILabel.new({
        --     UILabelType = 2,
        --     text = "",
        --     size = Dimens.TextSize_30,
        --     color = Colors.btn_press,
        --     }))
        :setButtonImage(EnStatus.pressed, Imgs.gamemirror_2pause)
        :onButtonClicked(function(e)

            getData_indexNo_Pause = getData_indexNo
            getData_indexNo = getData_indexNo_Max

            pauseBtn:setVisible(false)
            onAgainBtn:setVisible(true)
            playBtn:setVisible(false)

        end)
        :align(display.CENTER, startX_mirror +(btn_w_gap+btn_w_mirror)*1, startY_mirror)
        :addTo(Layer1, CEnum.ZOrder.gameingMirror_btn)
        :setVisible(true)
    --]]

    ---[[
    -- 继续按钮
    onAgainBtn = cc.ui.UIPushButton.new(
        Imgs.gamemirror_2on,{scale9=false})
        :setButtonSize(btn_w_mirror, btn_h_mirror)
        -- :setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
        --     UILabelType = 2,
        --     text = "继续",
        --     size = Dimens.TextSize_30,
        --     color = Colors.btn_normal,
        --     }))
        -- :setButtonLabel(EnStatus.pressed, cc.ui.UILabel.new({
        --     UILabelType = 2,
        --     text = "",
        --     size = Dimens.TextSize_30,
        --     color = Colors.btn_press,
        --     }))
        :setButtonImage(EnStatus.pressed, Imgs.gamemirror_2on)
        :onButtonClicked(function(e)

            getData_indexNo = getData_indexNo_Pause
            getData_indexNo_Pause = 0
            GameingMirrorDialog:setViewData()

            pauseBtn:setVisible(true)
            onAgainBtn:setVisible(false)
            playBtn:setVisible(false)

        end)
        :align(display.CENTER, startX_mirror +(btn_w_gap+btn_w_mirror)*1, startY_mirror)
        :addTo(Layer1, CEnum.ZOrder.gameingMirror_btn)
        :setVisible(false)
    --]]

    ---[[
    -- 播放按钮
    playBtn = cc.ui.UIPushButton.new(
        Imgs.gamemirror_2play,{scale9=false})
        :setButtonSize(btn_w_mirror, btn_h_mirror)
        -- :setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
        --     UILabelType = 2,
        --     text = "继续",
        --     size = Dimens.TextSize_30,
        --     color = Colors.btn_normal,
        --     }))
        -- :setButtonLabel(EnStatus.pressed, cc.ui.UILabel.new({
        --     UILabelType = 2,
        --     text = "",
        --     size = Dimens.TextSize_30,
        --     color = Colors.btn_press,
        --     }))
        :setButtonImage(EnStatus.pressed, Imgs.gamemirror_2play)
        :onButtonClicked(function(e)

            getData_indexNo = getData_indexNo_init
            GameingMirrorDialog:myViewReset_playAgain()

            GameingMirrorDialog:setViewData()

            pauseBtn:setVisible(true)
            onAgainBtn:setVisible(false)
            playBtn:setVisible(false)

        end)
        :align(display.CENTER, startX_mirror +(btn_w_gap+btn_w_mirror)*1, startY_mirror)
        :addTo(Layer1, CEnum.ZOrder.gameingMirror_btn)
        :setVisible(false)
    --]]

end

function GameingMirrorDialog:myCancel()
    GameingMirrorDialog:myViewReset()
    GameingMirrorDialog:myExit()
end


function GameingMirrorDialog:createView()
    getData_indexNo = getData_indexNo_init
    showDate_gaptime = showDate_gaptime_init

	GameingMirrorDialog:top_createView()
	GameingMirrorDialog:myself_createView()
	GameingMirrorDialog:xiajia_createView()
	GameingMirrorDialog:lastjia_createView()
	GameingMirrorDialog:dcard_createView()
end

-- 全部的数据，一步步的播放出来
function GameingMirrorDialog:setViewData()
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
                if step_label and not tolua.isnull(step_label) then
                    -- step_label:removeFromParent()
                    -- step_label = nil
                    step_label:setString(show_step.."/".._size_mirror)
                else
                    step_label = cc.ui.UILabel.new({
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
                        :addTo(Layer1, CEnum.ZOrder.gameingMirror_btn)
                        -- :align(display.CENTER, display.cx, display.cy -100 +20)
                        :align(display.RIGHT_TOP, osWidth-6, osHeight-2 -20)
                end
            end  

            -- res_data_single = RequestBase:getStrDecode(res_data_mirror[getData_indexNo]) -- 转编码之后的字符串
            -- receive_res_data = ParseBase:parseToJsonObj(res_data_single) -- 字符串变为table对象去使用

            if res_data_single~=nil and receive_res_data~=nil then

                res_data = receive_res_data
                Commons:printLog_Info("==GameingMirrorDialog: data", res_data)
                Commons:printLog_Info("==GameingMirrorDialog: 第几个数据", getData_indexNo)
                Commons:printLog_Info("==GameingMirrorDialog: 间隔时间", showDate_gaptime)


                local surpDlzScore = res_data[Room.Bean.surpDlzScore]
                if Commons:checkIsNull_numberType(surpDlzScore) and surpDlzScore > CEnum.isDlz.noLz then
                    -- 显示总的溜子分数，并且每个玩家出分的动画显示
                    myLz_bg:show()
                    myLz_label:show()
                    myLz_label:setString(tostring(surpDlzScore))
                else
                    myLz_bg:hide()
                    myLz_label:hide()
                end

                GameingMirrorDialog:topRule_createView_setViewData(res_data)

                GameingMirrorDialog:top_setViewData(res_data)-- 顶部组件 数值显示出来
                GameingMirrorDialog:players_info_setViewData(res_data) -- 自己位置的界面组件 数值显示出来
                GameingMirrorDialog:dcard_setViewData(res_data)--, res_cmd)-- 底牌
                GameingMirrorDialog:myself_handCard_createView_setViewData(res_data)-- 我手上的牌   主位置
                GameingMirrorDialog:players_handCard_setViewData(res_data)-- 每位玩家 上次吃牌动画| 已经出过的牌| 已经吃、碰过的牌| 并且庄家第一次出牌

                GameingMirrorDialog:R_handCard_createView_setViewData(res_data) -- 下家的手牌

                GameingMirrorDialog:huCard_createView_setViewData(res_data) -- 胡牌  也是有效果的  --todo效果还需要完善

                parent_mirror:performWithDelay(function ()
                    getData_indexNo = getData_indexNo + 1
                    GameingMirrorDialog:setViewData()
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

-- 底牌  赋值
function GameingMirrorDialog:dcard_setViewData(res_data)--, res_cmd)
    if res_data ~= nil then
        local room = res_data--[User.Bean.room]

        local diCardsNum = room[Room.Bean.diCardsNum]
        local diCards = room[Room.Bean.diCards]

        --底牌列表
        view_diCards_list:removeAllItems()
        if Commons:checkIsNull_tableType(diCards) then
            for k_di,v_di in pairs(diCards) do
                local item = view_diCards_list:newItem()
                local img_vv = GameingDealUtil:getImgByHandcard(CEnum.userCard.out, v_di)
                local content = cc.ui.UIPushButton.new(img_vv, {scale9 = false})
                        :setButtonSize(card_hu_w, card_hu_h)
                --item:setBg("") -- 设置item背景
                item:addChild(content)
                --item:setItemSize(42, 42)
                view_diCards_list:addItem(item) -- 添加item到列表
            end
            view_diCards_list:reload() -- 重新加载
        end

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
                        :setLayoutSize(28, 38)
                        :addTo(dcard_view_nums)
                        :align(display.CENTER, display.cx+(-11*_size/2)+27*(i-1), osHeight-170+10)
                end
            --end
        end 

        dcard_view:setVisible(true)
    end
end

-- 选择再来一局，需要将房间界面重置，该去掉的去掉，该隐藏的隐藏
function GameingMirrorDialog:myViewReset()
	res_data_mirror = nil
    startTime_mirror = nil

    -- 顶部
    -- local top_view
    -- local top_view_roomNo
    -- local top_view_ju
    if top_view ~= nil and (not tolua.isnull(top_view)) then
        top_view:removeFromParent()
        top_view = nil
    end


    -- 底板
    -- local topRule_view_noConnectServer
    if topRule_view_noConnectServer ~= nil and (not tolua.isnull(topRule_view_noConnectServer)) then
        topRule_view_noConnectServer:removeFromParent()
        topRule_view_noConnectServer = nil
    end


    -- 本人
    -- user_roomNo = nil
    user_icon = nil
    user_nickname = nil
    user_account = nil
    -- user_ip = nil
    if myself_view ~= nil and (not tolua.isnull(myself_view)) then
        myself_view:removeFromParent()
        myself_view = nil
    end

    -- 相对本人 的下一玩家
    user_icon_xiajia = nil
    user_nickname_xiajia = nil
    user_account_xiajia = nil
    user_ip_xiajia = nil
    if xiajia_view ~= nil and (not tolua.isnull(xiajia_view)) then
        xiajia_view:removeFromParent()
        xiajia_view = nil
    end

    -- 相对本人 的上一玩家，也是最后一玩家
    user_icon_lastjia = nil
    user_nickname_lastjia = nil
    user_account_lastjia = nil
    user_ip_lastjia = nil
    if lastjia_view ~= nil and (not tolua.isnull(lastjia_view)) then
        lastjia_view:removeFromParent()
        lastjia_view = nil
    end

    -- 底牌
    -- local dcard_view
    -- local dcard_view_nums
    if dcard_view ~= nil and (not tolua.isnull(dcard_view)) then
        dcard_view:removeFromParent()
        dcard_view = nil
    end

    -- 本人手牌
    -- local bg_view = nil
    -- local sc_view = nil
    if sc_view ~= nil and (not tolua.isnull(sc_view)) then
        sc_view:removeFromParent()
        sc_view = nil
    end
    if bg_view ~= nil and (not tolua.isnull(bg_view)) then
        bg_view:removeFromParent()
        bg_view = nil
    end

    if sc_view_R ~= nil and (not tolua.isnull(sc_view_R)) then
        sc_view_R:removeFromParent()
        sc_view_R = nil
    end
    if bg_view_R ~= nil and (not tolua.isnull(bg_view_R)) then
        bg_view_R:removeFromParent()
        bg_view_R = nil
    end

    if sc_view_L ~= nil and (not tolua.isnull(sc_view_L)) then
        sc_view_L:removeFromParent()
        sc_view_L = nil
    end
    if bg_view_L ~= nil and (not tolua.isnull(bg_view_L)) then
        bg_view_L:removeFromParent()
        bg_view_L = nil
    end

    -- 拖拽对象
    -- local boxSize = CVar._static.boxSize -- 层的大小
    -- local objSize = CVar._static.objSize -- 牌的大小
    t_data = nil -- 层的数组
    --local t_drag = nil -- 可拖拽的对象
    _handCardDataTable = nil -- 手上的牌集合
    _handCardDataTable_RL = nil -- 手上的牌集合
    --_handCardDataTable_L = nil -- 手上的牌集合

    mySeatNo = nil -- 记录我的位置编号

    -- 是不是我出牌
    isMeChu = false
    -- 出牌区域
    -- local box_chupai = nil
    -- local chu_tipimg = nil

    -- 胡牌效果
    -- local mtView
    if mtView ~= nil and (not tolua.isnull(mtView)) then
        mtView:removeFromParent()
        mtView = nil
    end
    -- local ruleView 
    if ruleView ~= nil and (not tolua.isnull(ruleView)) then
        ruleView:removeFromParent()
        ruleView = nil
    end
    -- local fanCardView
    if fanCardView ~= nil and (not tolua.isnull(fanCardView)) then
        fanCardView:removeFromParent()
        fanCardView = nil
    end
    -- local huCard_tipimg_node
    if huCard_tipimg_node ~= nil and (not tolua.isnull(huCard_tipimg_node)) then
        huCard_tipimg_node:removeFromParent()
        huCard_tipimg_node = nil
    end
    if view_diCards_list ~= nil and (not tolua.isnull(view_diCards_list)) then
        view_diCards_list:removeFromParent()
        view_diCards_list = nil
    end

end

-- 选择再来一局，需要将房间界面重置，该去掉的去掉，该隐藏的隐藏
function GameingMirrorDialog:myViewReset_playAgain()
    -- 胡牌效果
    -- local mtView
    if mtView ~= nil and (not tolua.isnull(mtView)) then
        mtView:removeFromParent()
        mtView = nil
    end
    -- local ruleView 
    if ruleView ~= nil and (not tolua.isnull(ruleView)) then
        ruleView:removeFromParent()
        ruleView = nil
    end
    -- local fanCardView
    if fanCardView ~= nil and (not tolua.isnull(fanCardView)) then
        fanCardView:removeFromParent()
        fanCardView = nil
    end
    -- local huCard_tipimg_node
    if huCard_tipimg_node ~= nil and (not tolua.isnull(huCard_tipimg_node)) then
        huCard_tipimg_node:removeFromParent()
        huCard_tipimg_node = nil
    end

end


-- 构造函数
function GameingMirrorDialog:ctor()
    Commons:printLog_Info("--------GameingMirrorDialog:  ctor")
end

function GameingMirrorDialog:onExit()
    Commons:printLog_Info("--------GameingMirrorDialog:  onExit")
    GameingMirrorDialog:myExit()
end

function GameingMirrorDialog:myExit()
    Commons:printLog_Info("--------GameingMirrorDialog:  myExit")

    if Layer1 ~= nil and (not tolua.isnull(Layer1)) then
        Layer1:removeFromParent()
        Layer1 = nil
    end
    parent_mirror = nil
end


-- 顶部组件初始化
function GameingMirrorDialog:top_createView()
    top_view = cc.NodeGrid:create()
   	top_view:addTo(Layer1)
   	top_view:setVisible(true)
    
	-- 顶部背景
    cc.ui.UIImage.new(Imgs.gameing_top_bg,{})
        :addTo(top_view)
        :align(display.CENTER, display.cx, osHeight-112/2)
        --:setLayoutSize(osWidth, osHeight)
        :setLayoutSize(osWidth, 113)

	-- 当前时间显示
    local myDate_label = display.newTTFLabel({
	        text = startTime_mirror,
	        size = Dimens.TextSize_18,
            color = Colors:_16ToRGB(Colors.gameing_time),
	        font = Fonts.Font_hkyt_w9,
	        align = cc.ui.TEXT_ALIGN_CENTER,
	        valign = cc.ui.TEXT_VALIGN_CENTER,
	        --dimensions = cc.size(306, 96)
     	})
        :addTo(top_view)
        --:align(display.LEFT_TOP, osWidth-85, osHeight-8-1) -- 最右边
        --:align(display.LEFT_TOP, 125, osHeight-8-1) -- 最左边
        :align(display.CENTER, display.cx, osHeight-100) -- 中间

    -- 逗溜子背景
    myLz_bg = cc.ui.UIImage.new(Imgs.gameing_top_lz,{scale9=false})
        :addTo(top_view)
        :align(display.RIGHT_TOP, display.cx+70, osHeight-196) -- 最左边
        -- :setLayoutSize(osWidth, 113)
        :hide()
    myLz_label = display.newTTFLabel({
            text = "180",
            size = Dimens.TextSize_20,
            color = Colors:_16ToRGB(Colors.gameing_time),
            font = Fonts.Font_hkyt_w9,
            align = cc.ui.TEXT_ALIGN_CENTER,
            valign = cc.ui.TEXT_VALIGN_CENTER,
            --dimensions = cc.size(306, 96)
        })
        :addTo(top_view)
        :align(display.LEFT_TOP, display.cx+70 -70, osHeight-196-2) -- 最左边
        :hide()

	-- 设置
	local top_view_setting=cc.ui.UIPushButton.new(
    	Imgs.gameing_top_setting,{scale9=false})
        :setButtonSize(56, 72)
        :setButtonImage(EnStatus.pressed, Imgs.gameing_top_setting)
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
    local top_view_dissRoom = cc.ui.UIPushButton.new(
    	Imgs.gameing_top_dismiss_room,{scale9=false})
        :setButtonSize(86, 70)
        :setButtonImage(EnStatus.pressed, Imgs.gameing_top_dismiss_room)
        :align(display.RIGHT_TOP, osWidth-464, osHeight-8)
        :addTo(top_view)
    if CVar._static.isIphone4 then
        top_view_dissRoom:align(display.RIGHT_TOP, osWidth-464+80, osHeight-8)
    elseif CVar._static.isIpad then
        top_view_dissRoom:align(display.RIGHT_TOP, osWidth-464+80+55, osHeight-8)
    elseif CVar._static.NavBarH_Android ~= CEnum.status.NavBarH_def then
        top_view_dissRoom:align(display.RIGHT_TOP, osWidth-464 +CVar._static.NavBarH_Android/2-5, osHeight-8)
    end

    -- 房号
    top_view_roomNo = display.newNode():addTo(top_view)

    -- 回合数
    top_view_ju = display.newNode():addTo(top_view)

    cc.ui.UILabel.new({
            text = CEnum.AppVersion.versionName, 
            font = Fonts.Font_hkyt_w7,
            size = 15, 
            color = Colors.versionName,
            --color = Colors:_16ToRGB(Colors.help_txt),
            align = cc.ui.TEXT_ALIGN_CENTER,
            valign = cc.ui.TEXT_VALIGN_CENTER,
        })
        :align(display.RIGHT_TOP, osWidth-6, osHeight-2)
        :addTo(top_view)

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
end


-- 自己位置的界面组件
function GameingMirrorDialog:myself_createView()
    myself_view = cc.NodeGrid:create()
    Layer1:addChild(myself_view, CEnum.ZOrder.gameingView_myself)
   	myself_view:setVisible(true)
        
	-- 头像框
    cc.ui.UIPushButton.new(Imgs.gameing_user_head_bg,{scale9=false})
        :align(display.LEFT_TOP, 40, 165)
        :addTo(myself_view)

    -- 昵称
    myself_view_nickname = display.newTTFLabel({
	        text = "Me",
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
	        text = "分数:1880",
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
	        text = "10胡息",
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
        :setButtonImage(EnStatus.disabled, Imgs.gameing_user_prepare_ok)
        :setButtonImage(EnStatus.pressed, Imgs.gameing_btn_prepare_press)
        :align(display.CENTER, display.cx, osHeight-508)
        :addTo(myself_view)
        :setVisible(false)

    -- 我的倒计时
    myself_view_timer = cc.ui.UIPushButton.new(
        Imgs.gameing_user_time_bg,{scale9=false})
        :setButtonSize(50, 54)
        :setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
	            UILabelType = 2,
	            text = "" .. CVar._static.clockWiseTime,
	            size = Dimens.TextSize_25,
	            color = Colors:_16ToRGB(Colors.gameing_time),
        }))
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
            capInsets = cc.rect(0, 0, 152*7, 132),
            viewRect = cc.rect(0, 0, 152*7, 132),
            -- direction = cc.ui.UIScrollView.DIRECTION_VERTICAL, -- 竖着摆放
            direction = cc.ui.UIScrollView.DIRECTION_HORIZONTAL, -- 水平摆放
            alignment = cc.ui.UIListView.ALIGNMENT_VCENTER
        })
        :addTo(myself_view)
        :align(display.CENTER, display.cx-152*7/2, display.cy-46-46)
end


-- 相对自己的位置  的下一玩家
function GameingMirrorDialog:xiajia_createView()
    xiajia_view = cc.NodeGrid:create()
    xiajia_view:addTo(Layer1)
    xiajia_view:setVisible(true)
    
    -- 头像框
    cc.ui.UIPushButton.new(Imgs.gameing_user_head_bg,{scale9=false})
        :align(display.RIGHT_TOP, osWidth-40, osHeight-52)
        :addTo(xiajia_view)

    -- 昵称
    xiajia_view_nickname = display.newTTFLabel({
            text = "R",
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
            text = "分数:2880",
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
            text = "20胡息",
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
    local beishu = 3.2
    if CVar._static.isIphone4 then
        moveY = -30
        beishu = 1.9
    elseif CVar._static.isIpad then
        moveY = -30
        beishu = 1.5
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
        :align(display.RIGHT_TOP, osWidth-14-100-100-42*card_cc_out_A, osHeight-45-40-22-42*beishu +moveY)

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
        :setButtonImage(EnStatus.disabled, Imgs.gameing_user_prepare_ok)
        :setButtonImage(EnStatus.pressed, Imgs.gameing_btn_prepare_press)
        :align(display.RIGHT_TOP, osWidth-206, osHeight-84)
        :addTo(xiajia_view)
        :setVisible(false)

    -- 倒计时表
    xiajia_view_timer = cc.ui.UIPushButton.new(
        Imgs.gameing_user_time_bg,{scale9=false})
        :setButtonSize(50, 54)
        :setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
            UILabelType = 2,
            text = "" .. CVar._static.clockWiseTime,
            size = Dimens.TextSize_25,
            color = Colors:_16ToRGB(Colors.gameing_time),
        }))
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
function GameingMirrorDialog:lastjia_createView()
	lastjia_view = cc.NodeGrid:create()
    lastjia_view:addTo(Layer1)
    lastjia_view:setVisible(true)

    -- 头像框
    cc.ui.UIPushButton.new(Imgs.gameing_user_head_bg,{scale9=false})
        :align(display.LEFT_TOP, 40, osHeight-52)
        :addTo(lastjia_view)

    -- 昵称
    lastjia_view_nickname=display.newTTFLabel({
	        text = "L",
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
	        text = "分数:3880",
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
	        text = "30胡息",
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
    local beishu = 3.2
    if CVar._static.isIphone4 then
        moveY = -30
        beishu = 1.9
    elseif CVar._static.isIpad then
        moveY = -30
        beishu = 1.5
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
        :align(display.LEFT_TOP, 202, osHeight-45-40-22-42*beishu +moveY)

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
        :setButtonImage(EnStatus.disabled, Imgs.gameing_user_prepare_ok)
        :setButtonImage(EnStatus.pressed, Imgs.gameing_btn_prepare_press)
        :align(display.LEFT_TOP, 214, osHeight-84)
        :addTo(lastjia_view)
        :setVisible(false)

    -- 倒计时表
    lastjia_view_timer=cc.ui.UIPushButton.new(
        Imgs.gameing_user_time_bg,{scale9=false})
        :setButtonSize(50, 54)
        :setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
            UILabelType = 2,
            text = "" .. CVar._static.clockWiseTime,
            size = Dimens.TextSize_25,
            color = Colors:_16ToRGB(Colors.gameing_time),
        }))
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

-- 底牌
function GameingMirrorDialog:dcard_createView()
	dcard_view = cc.NodeGrid:create()
   	dcard_view:addTo(Layer1)
    dcard_view:setVisible(true)

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
        :addTo(dcard_view)
        :align(display.CENTER, display.cx-120, osHeight-226)
end



--[[ 真实数据的响应 --]]
function GameingMirrorDialog:topRule_createView_setViewData(res_data)
    if topRule_view_noConnectServer == nil then

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
        end

        if static_gameing_fanRule == CEnum.fanRule.fan then
            cc.ui.UIImage.new(Imgs.room_3fgx_fan_mid,{})
                :addTo(Layer1)
                :align(display.CENTER, display.cx-120, osHeight-120)
        elseif static_gameing_fanRule == CEnum.fanRule.gen then
            cc.ui.UIImage.new(Imgs.room_3fgx_gen_mid,{})
                :addTo(Layer1)
                :align(display.CENTER, display.cx-120, osHeight-120)
        end

        if static_gameing_multRule == CEnum.multRule.single then
            cc.ui.UIImage.new(Imgs.room_4dsx_single_mid,{})
                :addTo(Layer1)
                :align(display.CENTER, display.cx+120, osHeight-120)
        elseif static_gameing_multRule == CEnum.multRule.double then
            cc.ui.UIImage.new(Imgs.room_4dsx_double_mid,{})
                :addTo(Layer1)
                :align(display.CENTER, display.cx+120, osHeight-120)
        end

        if static_gameing_jiadi == CEnum.jiadi.yes then
            cc.ui.UIImage.new(Imgs.room_2jiadi_yes_mid,{})
                :addTo(Layer1)
                :align(display.CENTER, display.cx+0, osHeight-120)
        elseif static_gameing_jiadi == CEnum.jiadi.no then
        end

        local mtRuleView = nil
        if static_gameing_mtRule == CEnum.mtRule.laoMt then
            mtRuleView = cc.ui.UIImage.new(Imgs.room_2mt_laomt_mid,{})
                :addTo(Layer1)
                :align(display.CENTER, display.cx+0, osHeight-120)
        elseif static_gameing_mtRule == CEnum.mtRule.xz then
            mtRuleView = cc.ui.UIImage.new(Imgs.room_2mt_xz_mid,{})
                :addTo(Layer1)
                :align(display.CENTER, display.cx+0, osHeight-120)
        elseif static_gameing_mtRule == CEnum.mtRule.dz then
            mtRuleView = cc.ui.UIImage.new(Imgs.room_2mt_dz_mid,{})
                :addTo(Layer1)
                :align(display.CENTER, display.cx+0, osHeight-120)
        elseif static_gameing_mtRule == CEnum.mtRule.quanMt then
            mtRuleView = cc.ui.UIImage.new(Imgs.room_2mt_quanmt_mid,{})
                :addTo(Layer1)
                :align(display.CENTER, display.cx+0, osHeight-120)
        end

        if static_gameing_isDlz == CEnum.isDlz.yes then
            if mtRuleView ~= nil then
                mtRuleView:align(display.CENTER, display.cx-120, osHeight-120)
            end
            cc.ui.UIImage.new(Imgs.room_5dlz_selet_mid,{})
                :addTo(Layer1)
                :align(display.CENTER, display.cx+0, osHeight-120)
            -- 是否逗溜子结束

            if static_gameing_dlzLevel == CEnum.dlzLevel._1 then
                cc.ui.UIImage.new(Imgs.room_5dlz_zx_1_mid,{})
                    :addTo(Layer1)
                    :align(display.CENTER, display.cx+90, osHeight-120)
                    :setLayoutSize(80, 23)

            elseif static_gameing_dlzLevel == CEnum.dlzLevel._2 then
                cc.ui.UIImage.new(Imgs.room_5dlz_zx_2_mid,{})
                    :addTo(Layer1)
                    :align(display.CENTER, display.cx+90, osHeight-120)
                    :setLayoutSize(80, 23)

            elseif static_gameing_dlzLevel == CEnum.dlzLevel._3 then
                cc.ui.UIImage.new(Imgs.room_5dlz_zx_3_mid,{})
                    :addTo(Layer1)
                    :align(display.CENTER, display.cx+90, osHeight-120)
                    :setLayoutSize(80, 23)
            end -- 庄闲扣分 结束

            if static_gameing_flzUnit == CEnum.flzUnit._80 then
                cc.ui.UIImage.new(Imgs.room_5dlz_deng_1_mid,{})
                    :addTo(Layer1)
                    :align(display.CENTER, display.cx+90*2, osHeight-120)
                    :setLayoutSize(80, 20)

            elseif static_gameing_flzUnit == CEnum.flzUnit._100 then
                cc.ui.UIImage.new(Imgs.room_5dlz_deng_2_mid,{})
                    :addTo(Layer1)
                    :align(display.CENTER, display.cx+90*2, osHeight-120)
                    :setLayoutSize(80, 20)

            elseif static_gameing_flzUnit == CEnum.flzUnit._200 then
                cc.ui.UIImage.new(Imgs.room_5dlz_deng_3_mid,{})
                    :addTo(Layer1)
                    :align(display.CENTER, display.cx+90*2, osHeight-120)
                    :setLayoutSize(80, 20)
            end -- 庄闲扣分 结束
        end -- 逗溜子 结束

    end
end


-- 顶部组件赋值
function GameingMirrorDialog:top_setViewData(res_data)
    if res_data ~= nil then
        local room = res_data--[User.Bean.room]

        local roomNo = room[Room.Bean.roomNo]
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
                --top_view_roomNo:removeAllChildren()
            else
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
        end

        if Commons:checkIsNull_number(playRound) and Commons:checkIsNull_number(rounds) then
            local moveX = 0
            if CVar._static.isIphone4 then
                moveX = -96
            elseif CVar._static.isIpad then
                moveX = -156
            elseif CVar._static.NavBarH_Android ~= CEnum.status.NavBarH_def then
                moveX = -CVar._static.NavBarH_Android/2
            end

            --top_view_ju:setString("第"..playRound.."/"..rounds.."局")
            --Commons:printLog_Info("=====",playRound,rounds)

            if top_view_ju~=nil and (not tolua.isnull(top_view_ju)) and top_view_ju:getChildrenCount() > 0 then
               --top_view_ju:removeAllChildren()
            else
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
            
        end

        top_view:setVisible(true)
    end
end


-- 玩家上线，直接去创建玩家界面
-- 下一家位置或者最后一家位置都有可能初始化出来
function GameingMirrorDialog:players_info_setViewData(res_data)
    if res_data ~= nil then
        local room = res_data--[User.Bean.room]

        local _room_status = room[Room.Bean.status]
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
                if v[Player.Bean.me] then
                    --owerNo = v[Player.Bean.seatNo]
                    mySeatNo = v[Player.Bean.seatNo] -- owerNo
                    break
                end
            end
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
                    if userBO ~= nil then
                        user_account = userBO[User.Bean.account]
                        -- user_ip = userBO[User.Bean.ip]
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

                        myself_view_xi:setVisible(false) -- 胡息  暂时不用显示
                        myself_view_isBanker:setVisible(false) -- 是不是庄家  暂时不用显示
                    elseif playStatus == CEnum.playStatus.playing then
                        myself_view_btn_Prepare:setVisible(false)
                    elseif playStatus == CEnum.playStatus.ended then
                        myself_view_btn_Prepare:setVisible(true)
                        myself_view_btn_Prepare:setButtonEnabled(true)
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

                        xiajia_view_xi:setVisible(false) -- 胡息  暂时不用显示
                        xiajia_view_isBanker:setVisible(false) -- 是不是庄家  暂时不用显示
                    elseif playStatus == CEnum.playStatus.playing then
                        xiajia_view_btn_Prepare:setVisible(false)
                    elseif playStatus == CEnum.playStatus.ended then
                        xiajia_view_btn_Prepare:setVisible(false)
                    end

                    if not netStatus_bool then -- 如果离线
                        -- 离线标识
                        xiajia_view_offline:setVisible(true)
                    end

                    xiajia_view:setVisible(true)

                elseif _seat == CEnum.seatNo.L then -- and netStatus_bool then-- 上一玩家，也是最后一玩家,并且在线
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

                        lastjia_view_xi:setVisible(false) -- 胡息  暂时不用显示
                        lastjia_view_isBanker:setVisible(false) -- 是不是庄家  暂时不用显示
                    elseif playStatus == CEnum.playStatus.playing then
                        lastjia_view_btn_Prepare:setVisible(false)
                    elseif playStatus == CEnum.playStatus.ended then
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


-- 手上有的牌 如何摆放 一个pageview
function GameingMirrorDialog:myself_handCard_createView_setViewData(res_data)
    local _handCardDataTable_temp = nil

    if res_data ~= nil then
        local room = res_data--[User.Bean.room]

        local players = room[Room.Bean.players]

        if players ~= nil and type(players)=="table" then
            for k,v in pairs(players) do
                if v[Player.Bean.me] then
                    _handCardDataTable_temp = v[Player.Bean.handCards]
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
        end

        _handCardDataTable = GameingDealUtil:ScrollView_FillList(_handCardDataTable_temp, CVar._static.handCardNums)
        GameingMirrorDialog:handCard_initUI()  -- 更新手牌UI
    end

end

--[[
初始化 手上的牌 需要的组件
参数有：
@param：多少个元素
@param：宽
@param：高
--]]
function GameingMirrorDialog:handCard_initUI()
    local column_nums = #_handCardDataTable / 3
    local w = column_nums * boxSize.width;
    local h = boxSize.height * 3;

    --我手上牌的背景层区域 背包
    if bg_view == nil then 
        bg_view = cc.LayerColor:create(cc.c4b(100,100,100,0),w,h)
        bg_view:setPosition(cc.p(130,0))
        Layer1:addChild(bg_view)
    end

    if sc_view == nil then
        sc_view =  cc.ui.UIScrollView.new({
            viewRect = cc.rect(0,0, bg_view:getContentSize().width, bg_view:getContentSize().height), 
            --capInsets = cc.rect(0,0, bg_view:getContentSize().width, bg_view:getContentSize().height), 
            direction = 2
        })
        --sc_view:setContentSize(bg_view:getContentSize().width,bg_view:getContentSize().height)
        sc_view:setBounceable(false) -- 回弹效果去掉，就不会出现貌似滑动的效果
        bg_view:addChild(sc_view);
    else
        if not tolua.isnull(sc_view) then
            sc_view:removeFromParent();
            sc_view = nil
        end
        sc_view = cc.ui.UIScrollView.new({
            viewRect = cc.rect(0,0, bg_view:getContentSize().width, bg_view:getContentSize().height),
            --capInsets = cc.rect(0,0, bg_view:getContentSize().width, bg_view:getContentSize().height),  
            direction = 2
        })
        --sc_view:setContentSize(bg_view:getContentSize().width,bg_view:getContentSize().height)
        sc_view:setBounceable(false) -- 回弹效果去掉，就不会出现貌似滑动的效果
        bg_view:addChild(sc_view);
        --sc_view:removeAllChildren(); -- 这个处理方式，有问题，加载不出来新的数据
    end

    -- 我手上具体有多少张牌，一张张加入
    t_data = {}
    --t_drag = nil
    ---[[
    for k,v in pairs(_handCardDataTable) do
        --CDAlert.new():popDialogBox(Layer1,"666")
        -- 每个小背包
        local png = cc.LayerColor:create(cc.c4b(160,160,160,0), boxSize.width, boxSize.height)
        png:setTouchSwallowEnabled(false)
        --把layer当作精灵来处理
        png:ignoreAnchorPointForPosition(false)

        t_data[#t_data+1] = png

        ---[[
        local addHeight = 0
        local yushu = k % CVar._static.handRows
        if yushu == 1 then
            addHeight = -CVar._static.objAddHeight
            if CVar._static.isIphone4 then
                addHeight = -CVar._static.objAddHeight+10
            elseif CVar._static.isIpad then
                addHeight = -CVar._static.objAddHeight+10
            end
        elseif yushu == 2 then
            addHeight = -CVar._static.objAddHeight/2
            if CVar._static.isIphone4 then
                addHeight = -CVar._static.objAddHeight/2+5
            elseif CVar._static.isIpad then
                addHeight = -CVar._static.objAddHeight/2+5
            end
        else
        end
        -- 不能移动的手牌显示，可以放这里
        local img_vv = GameingDealUtil:getImgByHandcard(CEnum.userCard.hand, v)
        cc.ui.UIPushButton.new(img_vv, {scale9 = false})
                :setButtonSize(objSize.width, objSize.height)
                :align(display.CENTER, png:getContentSize().width/2, png:getContentSize().height/2 +addHeight)
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
    sc_view:fill(t_data, {itemSize = (t_data[#t_data]):getContentSize()})
    SCROLL_HANDLER_SLIDE(sc_view)
    S_XY(sc_view:getScrollNode(), 0, sc_view:getViewRect().height-H(sc_view:getScrollNode())-0 ) -- -8 就可以让牌压下去点点，就是有点可以拖动的感觉，用户觉得不要为好
    --]]
end


-- 下一个玩家 手上有的牌 如何摆放 一个pageview
function GameingMirrorDialog:R_handCard_createView_setViewData(res_data)
    local _handCardDataTable_temp = nil
    local _handCardDataTable_temp_2 = nil

    if res_data ~= nil then
        local room = res_data--[User.Bean.room]

        local players = room[Room.Bean.players]

        -- if CEnum.Environment.Current~=nil and CEnum.Environment.Current==CEnum.EnvirType.Test then
        --     if players ~= nil and type(players)=="table" then
        --         for k,v in pairs(players) do
        --             --if v[Player.Bean.me] and CEnum.netStatus_online==v[Player.Bean.netStatus] then
        --             if v[Player.Bean.me] then
        --                 --_seatNO = v[Player.Bean.seatNo]
        --                 _handCardDataTable_temp = v[Player.Bean.handCards]
        --             end
        --         end
        --     end
        --     -- 如果没有手牌或者找不到本人对象
        --     if _handCardDataTable_temp == nil then
        --         -- return
        --     else

        --         if bg_view_R ~= nil and (not tolua.isnull(bg_view_R) ) then
        --            bg_view_R:setVisible(true)
        --         end
        --         if bg_view_L ~= nil and (not tolua.isnull(bg_view_L) ) then
        --            bg_view_L:setVisible(true)
        --         end

        --         _handCardDataTable_RL = GameingDealUtil:ScrollView_FillList_RL(_handCardDataTable_temp, CVar._static.handCardNums, CEnum.seatNo.R)
        --         GameingMirrorDialog:R_handCard_initUI()  -- 更新手牌UI

        --         _handCardDataTable_RL = GameingDealUtil:ScrollView_FillList_RL(_handCardDataTable_temp, CVar._static.handCardNums, CEnum.seatNo.L)
        --         GameingMirrorDialog:L_handCard_initUI()  -- 更新手牌UI
        --     end 

        -- else
            --正式发布
            if players ~= nil and type(players)=="table" then
                for k,v in pairs(players) do
                    local currNo = v[Player.Bean.seatNo] -- 当前玩家座位编号
                    local _seat = GameingDealUtil:confimSeatNo(mySeatNo, currNo) -- 确定相对位置：：0=本人位置，1=下一玩家，-1=上一玩家，最后一玩家

                    -- 如果没有手牌或者找不到本人对象
                    if _seat == CEnum.seatNo.me then
                    elseif _seat == CEnum.seatNo.R then
                        _handCardDataTable_temp = v[Player.Bean.handCards]
                    elseif _seat == CEnum.seatNo.L then
                        _handCardDataTable_temp_2 = v[Player.Bean.handCards]
                    end
                end
            end

            -- 如果没有手牌或者找不到本人对象
            if _handCardDataTable_temp == nil then
                --return
            else
                if bg_view_R ~= nil and (not tolua.isnull(bg_view_R) ) then
                   bg_view_R:setVisible(true)
                end
                _handCardDataTable_RL = GameingDealUtil:ScrollView_FillList_RL(_handCardDataTable_temp, CVar._static.handCardNums, CEnum.seatNo.R)
                GameingMirrorDialog:R_handCard_initUI()  -- 更新手牌UI
            end

            -- 如果没有手牌或者找不到本人对象
            if _handCardDataTable_temp_2 == nil then
                --return
            else
                if bg_view_L ~= nil and (not tolua.isnull(bg_view_L) ) then
                   bg_view_L:setVisible(true)
                end
                _handCardDataTable_RL = GameingDealUtil:ScrollView_FillList_RL(_handCardDataTable_temp_2, CVar._static.handCardNums, CEnum.seatNo.L)
                GameingMirrorDialog:L_handCard_initUI()  -- 更新手牌UI
            end

        -- end

    end
end

function GameingMirrorDialog:R_handCard_initUI()
    local column_nums = #_handCardDataTable_RL / 3
    local w = column_nums * boxSize_RL.width;
    local h = boxSize_RL.height * 3;

    --我手上牌的背景层区域 背包
    if bg_view_R == nil then 
        bg_view_R = cc.LayerColor:create(cc.c4b(100,100,100,0),w,h)
        bg_view_R:setPosition(cc.p(osWidth-w-50, osHeight-h-4))
        Layer1:addChild(bg_view_R)
    end

    if sc_view_R == nil then
        sc_view_R =  cc.ui.UIScrollView.new({
            viewRect = cc.rect(0,0, bg_view_R:getContentSize().width, bg_view_R:getContentSize().height), 
            direction = 1
        })
        sc_view_R:setBounceable(false) -- 回弹效果去掉，就不会出现貌似滑动的效果
        bg_view_R:addChild(sc_view_R);
    else
        if not tolua.isnull(sc_view_R) then
            sc_view_R:removeFromParent();
            sc_view_R = nil
        end
        sc_view_R = cc.ui.UIScrollView.new({
            viewRect = cc.rect(0,0, bg_view_R:getContentSize().width, bg_view_R:getContentSize().height),
            direction = 1
        })
        sc_view:setBounceable(false) -- 回弹效果去掉，就不会出现貌似滑动的效果
        bg_view_R:addChild(sc_view_R);
    end

    -- 我手上具体有多少张牌，一张张加入
    t_data = {}
    --t_drag = nil
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
        local addHeight = -CVar._static.objAddHeight/2+5
        -- 不能移动的手牌显示，可以放这里
        local img_vv = GameingDealUtil:getImgByHandcard(CEnum.userCard.hand, v)
        cc.ui.UIPushButton.new(img_vv, {scale9 = false})
                :setButtonSize(objSize_RL.width, objSize_RL.height)
                :align(display.CENTER, png:getContentSize().width/2, png:getContentSize().height/2 +addHeight)
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
    SCROLL_HANDLER_SLIDE(sc_view)
    S_XY(sc_view_R:getScrollNode(), 0, sc_view_R:getViewRect().height-H(sc_view_R:getScrollNode()) )
    --]]
end

function GameingMirrorDialog:L_handCard_initUI()
    local column_nums = #_handCardDataTable_RL / 3
    local w = column_nums * boxSize_RL.width;
    local h = boxSize_RL.height * 3;

    --我手上牌的背景层区域 背包
    if bg_view_L == nil then 
        bg_view_L = cc.LayerColor:create(cc.c4b(100,100,100,0),w,h)
        bg_view_L:setPosition(cc.p(50, osHeight-h-4))
        Layer1:addChild(bg_view_L)
    end

    if sc_view_L == nil then
        sc_view_L =  cc.ui.UIScrollView.new({
            viewRect = cc.rect(0,0, bg_view_L:getContentSize().width, bg_view_L:getContentSize().height), 
            direction = 1
        })
        sc_view_L:setBounceable(false) -- 回弹效果去掉，就不会出现貌似滑动的效果
        bg_view_L:addChild(sc_view_L);
    else
        if not tolua.isnull(sc_view_L) then
            sc_view_L:removeFromParent();
            sc_view_L = nil
        end
        sc_view_L = cc.ui.UIScrollView.new({
            viewRect = cc.rect(0,0, bg_view_L:getContentSize().width, bg_view_L:getContentSize().height),
            direction = 1
        })
        sc_view:setBounceable(false) -- 回弹效果去掉，就不会出现貌似滑动的效果
        bg_view_L:addChild(sc_view_L);
    end

    -- 我手上具体有多少张牌，一张张加入
    t_data = {}
    --t_drag = nil
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
        local addHeight = -CVar._static.objAddHeight/2+5
        -- 不能移动的手牌显示，可以放这里
        local img_vv = GameingDealUtil:getImgByHandcard(CEnum.userCard.hand, v)
        cc.ui.UIPushButton.new(img_vv, {scale9 = false})
                :setButtonSize(objSize_RL.width, objSize_RL.height)
                :align(display.CENTER, png:getContentSize().width/2, png:getContentSize().height/2 +addHeight)
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
    SCROLL_HANDLER_SLIDE(sc_view)
    S_XY(sc_view_L:getScrollNode(), 0, sc_view_L:getViewRect().height-H(sc_view_R:getScrollNode()) )
    --]]
end


-- 已经出过的牌  每位玩家
-- 已经吃、碰过的牌  每位玩家
-- 并且庄家，第一次出牌，，以后后面每次摸、出、吃、碰牌
function GameingMirrorDialog:players_handCard_setViewData(res_data)
    if res_data ~= nil then
        local room = res_data--[User.Bean.room]

        local players = room[Room.Bean.players]

        local isChu = false -- 看看是不是三家都没有出牌拉
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

                local netStatus = v[Player.Bean.netStatus] -- 玩家是不是在线
                local netStatus_bool = CEnum.netStatus.online == netStatus

                if _seat == CEnum.seatNo.me then
                    isMeChu = v[Player.Bean.chu] -- 服务器给的 是否出牌

                    local options = v[Player.Bean.options] -- 当前可以的操作
                    local action = v[Player.Bean.action] -- 当前摸或者出的牌
                    Commons:printLog_Info("====本人====当前可以的操作options：",options," 摸或者出的牌action：", action)

                    GameingCurrChiCardDeal:createCurrChiCards(_seat,v,
                        myself_view, display.CENTER, (display.cx-100), (display.cy-60), 
                        myself_view_mo_chu_pai_bg, myself_view_mo_chu_pai,
                        xiajia_view_mo_chu_pai_bg, xiajia_view_mo_chu_pai,
                        lastjia_view_mo_chu_pai_bg, lastjia_view_mo_chu_pai,
                        myself_view_chiguo_list, xiajia_view_chiguo_list, lastjia_view_chiguo_list,
                        myself_view_chuguo_list, xiajia_view_chuguo_list, lastjia_view_chuguo_list,
                        box_chupai, isMeChu
                        )

                    -- 本人遇到了各种情况：碰，吃，过，胡才进入这里面操作
                    if Commons:checkIsNull_tableList(options) then
                        GameingMeChiCardDeal:createChiCards(nil) -- 消失可能操作过的吃牌
                        myself_view_needOption_list:setVisible(false) -- 中间的选择消失

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
                            
                            local show_options = GameingDealUtil:PageView_FillList_MeChiPeng_Select(options, 7) -- 中间区域显示 吃 碰 过 胡的操作供本人选择
                            myself_view_needOption_list:removeAllItems();

                            for kk,vv in pairs(show_options) do
                                local item = myself_view_needOption_list:newItem()
                                item:setName(vv)
                                local img_vv = GameingDealUtil:getImgByOptionMid(vv)
                                local content = cc.ui.UIPushButton.new(img_vv, {scale9 = false})
                                    -- :setButtonSize(132, 132)
                                    :align(display.CENTER, 0 , 0)

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

                end -- end 出过牌列表，吃过牌列表，碰过牌列表，偎过的牌列表、当前正在的操作，等等的效果

            end
        end
    end
end


function GameingMirrorDialog:huCard_createView_setViewData(res_data)
    if res_data ~= nil then
        local room = res_data--[User.Bean.room]

        local roundRecord = room[Room.Bean.roundRecord] 

        local roomRecord = room[Room.Bean.roomRecord]

        local _seat
        local owerNo = nil -- 我本人的位置在哪里？
        local isHu = nil -- 看下有没有胡牌？
        local mt
        local fanRule
        local fanCard
        local huCard

        if Commons:checkIsNull_tableList(roundRecord) then
            
            GameingMeChiCardDeal:createChiCards(nil) -- 消失可能操作过的吃牌
            myself_view_needOption_list:setVisible(false) -- 中间的选择消失

            -- 主位置是谁
            for k,v in pairs(roundRecord) do
                local me = v[RoundRecord.Bean.me]
                if me then
                    owerNo = v[Player.Bean.seatNo]
                    break
                end
            end

            --[[
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
            --]]

            ---[[
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
                    break
                end
            end

            -- 只要运行一次即可，看谁胡牌了
            if isHu ~= nil and isHu then

                -- 图片提示
                huCard_tipimg_node = display.newNode()--cc.NodeGrid:create();
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
                    chu_hu_bg:align(display.CENTER_TOP, display.cx, osHeight-170-55)
                    chu_hu_title:align(display.CENTER_TOP, display.cx, osHeight-170-55-48-52)
                    chu_hu:align(display.CENTER_TOP, display.cx, osHeight-170-55-48)
                elseif _seat == CEnum.seatNo.R then
                    --huCard_tipimg_node:addTo(xiajia_view)
                    chu_hu_card:align(display.RIGHT_TOP, osWidth-176-110, osHeight-84 -30)
                    chu_hu_bg:align(display.RIGHT_TOP, osWidth-176, osHeight-84 -30)
                    chu_hu_title:align(display.RIGHT_TOP, osWidth-176-10, osHeight-84-65-52 -30)
                    chu_hu:align(display.RIGHT_TOP, osWidth-176-80, osHeight-84-65 -30)
                elseif _seat == CEnum.seatNo.L then
                    --huCard_tipimg_node:addTo(lastjia_view)
                    chu_hu_card:align(display.LEFT_TOP, 164+110, osHeight-84 -30)
                    chu_hu_bg:align(display.LEFT_TOP, 164, osHeight-84 -30)
                    chu_hu_title:align(display.LEFT_TOP, 164+10, osHeight-84-65-52 -30)
                    chu_hu:align(display.LEFT_TOP, 164+80, osHeight-84-65 -30)
                end 

                --local a1 = cc.MoveTo:create(0.7, cc.p(0, -display.cy+50))
                --local a1 = cc.Shaky3D:create(3,cc.size(50,50),5,false)
                --local a1 = cc.ShuffleTiles:create(3,cc.size(300,300),5)
                --local a1 = cc.FadeOut:create(1)
                --local a2 = cc.FadeIn:create(1)
                    -- local a1 = cc.RotateBy:create(2,360)
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

                        local img_vv = GameingDealUtil:getImgByHandcard(CEnum.userCard.mid_mo, fanCard)
                        fanCardView = cc.ui.UIImage.new(img_vv,{scale9=false})
                            :setLayoutSize(76*2/3, 226*2/3)
                            :addTo(huCard_tipimg_node)
                            :align(display.CENTER, display.cx, osHeight-180)

                    end, hu_time)
                end
            else
                VoiceDealUtil:playSound_other(Voices.file.over_huang)
            end
        else

        end
  
    end
end

-- 必须有这个返回
return GameingMirrorDialog
