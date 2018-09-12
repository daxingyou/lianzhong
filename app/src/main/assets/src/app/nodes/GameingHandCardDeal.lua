--
-- Author: lte
-- Date: 2016-11-02 19:50:35
--

-- 类申明
-- local GameingHandCardDeal = class("GameingHandCardDeal", function ()
--     return display.newNode();
-- end)
local GameingHandCardDeal = class("GameingHandCardDeal")

local socket = require "socket"


local osWidth = Commons.osWidth
local osHeight = Commons.osHeight


--[[
创建一张出牌的盒子（box）
	@param: text 出牌的文字提醒
	@param: point 出牌的文字显示位置
	@param: w，h 出牌的区域的宽高
	@param: chu_seatNo 出牌的座位编号，是不是本人，是本人，动画就启动拉，不是就不需要启动动画
--]]
function GameingHandCardDeal:createEquipmentBox(text, point, w, h, chu_seatNo)
	-- 区域划定
    local box1 = cc.LayerColor:create(cc.c4b(55,55,55, 0), osWidth, h+173)
    box1:setPosition(point)

    local lab1 = display.newTTFLabel({
    	text=text,
    	color=c3,
    	align=cc.ui.TEXT_ALIGN_CENTER,
    	size=30
	})
    lab1:setPosition(cc.p(box1:getContentSize().width/2,box1:getContentSize().height/2))
    box1:addChild(lab1)
    
    -- 区域的底线提示
	cc.ui.UIImage.new(Imgs.gameing_mid_chupai_paizhuo_line,{scale9=false})
		:addTo(box1)
		:setPosition(cc.p(45*5+14,10))

	-- 出牌文字提示
    cc.ui.UIImage.new(Imgs.gameing_chu_tiptxt,{scale9=false})
        :addTo(box1)
        :setPosition(cc.p(osWidth-42*9,10))

    local chu_tipimg_node = display.newNode()--cc.NodeGrid:create();
		:addTo(box1)
		:setPosition(cc.p(osWidth-42*9,-40))

	if chu_seatNo == CEnum.seatNo.me then
		chu_tipimg_node = GameingHandCardDeal:createChupaiHint_Anim(box1, chu_tipimg_node)
	end

    return box1, chu_tipimg_node
end

--[[
创建一个出牌提示动画
--]]
function GameingHandCardDeal:createChupaiHint_Anim(box1, chu_tipimg)
	-- 这里先取消组件的存在，因为cc.Repeat动画完成，无法去除组件
	if chu_tipimg ~= nil and (not tolua.isnull(chu_tipimg)) then
		chu_tipimg:removeFromParent()
        chu_tipimg = nil
	end

    --动画完成，暂时无法去除动画组件
    -- 出牌图片提示
    local chu_tipimg_node = display.newNode()--cc.NodeGrid:create();
		:addTo(box1)
		:setPosition(cc.p(osWidth-42*9,-40))

    cc.ui.UIImage.new(Imgs.gameing_chu_handimg,{scale9=false})
        --:addTo(box1)
        --:setPosition(cc.p(osWidth-42*8,15))
        :addTo(chu_tipimg_node)
    --chu_tipimg_node:runAction(cc.Shaky3D:create(3,cc.size(42,54),5,true)) -- 抖动
	--local move2 = move1:reverse(); -- 需要对应的 MoveBy
	
    --local move1 = cc.MoveTo:create(0.3, cc.p(osWidth-42*7.5, -35));
    --local move2 = cc.MoveTo:create(0.3, cc.p(osWidth-42*7, -5)); -- 来回移动
	--local move3 = cc.MoveTo:create(0.3, cc.p(osWidth-42*6.5, 25));
	local move4 = cc.MoveTo:create(1.0, cc.p(osWidth-42*8, 16));
	local move5 = cc.MoveTo:create(1.0, cc.p(osWidth-42*9, -40));
	local sequenceAction = cc.Sequence:create(move4,move5)
	local repeatAction = cc.Repeat:create(sequenceAction, 15)
	--local repeatAction = cc.RepeatForever:create(sequenceAction)
		--,cc.CallFunc:create(function()
		--	Commons:printLog_Info("完成")
		--	chu_tipimg_node:setVisible(false)
		--end))
	chu_tipimg_node:runAction(repeatAction)

    return chu_tipimg_node
end

--[[
创建一个自摸王八入手牌的动画
--]]
function GameingHandCardDeal:createMyselfMoWang_Anim(need_view, myself_view_mo_chu_pai_bg, myself_view_mo_chu_pai)
	-- 这里先取消组件的存在，因为cc.Repeat动画完成，无法去除组件
	--if chu_tipimg ~= nil and (not tolua.isnull(chu_tipimg)) then
	--	chu_tipimg:removeFromParent()
    --  chu_tipimg = nil
	--end

    -- 图片提示
    local chu_tipimg_node = display.newNode()--cc.NodeGrid:create();
		:addTo(need_view)
		--:align(display.CENTER_TOP, display.cx, osHeight-170-48)
		--:setPosition(cc.p(display.cx, osHeight-170-48))

	--cc.ui.UIImage.new(Imgs.gameing_mid_mopai_bg,{scale9=false})
    --    :addTo(chu_tipimg_node)
    --cc.ui.UIImage.new(Imgs.card_mid_nw0,{scale9=false})
    --    :addTo(chu_tipimg_node)
    chu_tipimg_node:addChild(myself_view_mo_chu_pai_bg:clone()) -- 拷贝个副本进行动画
    chu_tipimg_node:addChild(myself_view_mo_chu_pai:clone())
    myself_view_mo_chu_pai_bg:setVisible(false)
	myself_view_mo_chu_pai:setVisible(false)

	--local scale1 = cc.ScaleTo:create(0.3, 0.5);
	local move1 = cc.MoveTo:create(0.7, cc.p(0, -display.cy+50));
	local anim = cc.Sequence:create(move1, cc.CallFunc:create(function() 
					--myself_view_mo_chu_pai_bg:setVisible(false)
					--myself_view_mo_chu_pai:setVisible(false)
                    if not tolua.isnull(chu_tipimg_node) then
    					chu_tipimg_node:removeFromParent()
                        chu_tipimg_node = nil
                    end
				end))
	chu_tipimg_node:runAction(anim)

    --return chu_tipimg_node
end

--[[
初始化所有手上拿到的牌
--]]
function GameingHandCardDeal:createEquipements(handCardDataTable, isNeedAnim)
    local equList = {}

    for k,v in pairs(handCardDataTable) do
    	--Commons:printLog_Info("----初始化装备----", k,v)
        if v~=nil and v ~= CEnum.status.def_fill then 
	    	local obj1 = GameingHandCardDeal:createEquipement(v, k, isNeedAnim)
		    --设置拖拽对象的tag,或者设置userData也可以。
		    obj1:setTag(1)
		    obj1:setName(k.."#"..v)
		    equList[#equList+1] = obj1
		else
			local obj1 = GameingHandCardDeal:createEquipement(v, 0, isNeedAnim)
		    --设置拖拽对象的tag,或者设置userData也可以。
		    obj1:setTag(-1)
		    obj1:setName(k.."#"..v)
		    equList[#equList+1] = obj1
		end
    end

    return equList
end

--[[
创建一张手上的牌
--]]
function GameingHandCardDeal:createEquipement(text, i, isNeedAnim)    
	local objSize = CVar._static.objSize -- 牌的大小
	
    local img_vv = GameingDealUtil:getImgByHandcard(CEnum.userCard.hand, text)
    local obj_card = --cc.LayerColor:create(cc.c4b(55,55,55,0), objSize.width, objSize.height)
                 cc.Layer:create():setContentSize(objSize.width, objSize.height)
    --当作图片处理
    obj_card:ignoreAnchorPointForPosition(false)

    local addHeight = 0
    local yushu = i % CVar._static.handRows
    if yushu == 1 then
        addHeight = -CVar._static.objAddHeight -- -7*2
        if CVar._static.isIphone4 then
            addHeight = -CVar._static.objAddHeight+10 -- -7*2
        elseif CVar._static.isIpad then
            addHeight = -CVar._static.objAddHeight+10 -- -7*2
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

    --local lab_o1 = display.newTTFLabel({
	--    	text=text,
	--    	color=c2,
	--    	align=cc.ui.TEXT_ALIGN_CENTER,
	--    	size=28
	-- })
    --lab_o1:setPosition(cc.p(obj_card:getContentSize().width/2,obj_card:getContentSize().height/2))
    -- obj_card:addChild(lab_o1)

    local card_img = cc.ui.UIPushButton.new(img_vv, {scale9 = false})
				:setButtonSize(objSize.width, objSize.height)
				-- :setButtonLabel(
				-- 	cc.ui.UILabel.new({
				-- 		--text = "点击大小改变" .. i, 
				-- 		--text = text, 
				-- 		text = "", 
				-- 		size = 16, 
				-- 		color = display.COLOR_BLUE
				-- 	})
				-- )
				-- :onButtonPressed(function(event)
				-- 	event.target:getButtonLabel():setColor(display.COLOR_RED)
				-- end)
				-- :onButtonRelease(function(event)
				-- 	event.target:getButtonLabel():setColor(display.COLOR_BLUE)
				-- end)
				-- :onButtonClicked(function(event)
				-- 	Commons:printLog_Info("UIPageView buttonclicked")
				-- 	local w, _ = item:getItemSize()
				-- 	if 60 == w then
				-- 		item:setItemSize(100, 73)
				-- 	else
				-- 		item:setItemSize(60, 73)
				-- 	end
				--end)
	card_img:setPosition(cc.p(obj_card:getContentSize().width/2, obj_card:getContentSize().height/2 +addHeight) )

    if isNeedAnim~=nil and isNeedAnim and i~=nil and i > 0  then
        card_img:setVisible(false)
    end
    obj_card:addChild(card_img)

    ---[[
    -- 每张牌自动翻转过来显示
    if isNeedAnim~=nil and isNeedAnim and i~=nil and i > 0 then
        --盖着的牌
        local card_Bg = 
        -- cc.ui.UIImage.new(img_vv,{scale9=false})
        --     -- :setLayoutSize(objSize.width, objSize.height)
        --     :setContentSize(objSize.width, objSize.height)

        -- display.newSprite(img_vv)
        --     :setLayoutSize(objSize.width, objSize.height)
        
        cc.ui.UIPushButton.new(Imgs.card_hand_g, {scale9 = false})
            :setButtonSize(objSize.width, objSize.height)
        -- card_Bg:setPosition(cc.p(obj_card:getContentSize().width/2, obj_card:getContentSize().height/2))
        card_Bg:setPosition(cc.p(objSize.width/2, objSize.height/2))
        :setVisible(false)
        obj_card:addChild(card_Bg)

        -- 牌布局好了，启动翻牌  一张张来
        obj_card:runAction(
            cc.Sequence:create(
                cc.DelayTime:create(0.1 + i*0.05), 
                cc.CallFunc:create(
                    function()
                        self:openCardBg(card_Bg, card_img)
                    end
                )
            )
        )
        obj_card:runAction(
            cc.Sequence:create(
                cc.DelayTime:create(0.2 + i*0.05), 
                cc.CallFunc:create(
                    function()
                        self:openCard(card_Bg, card_img)
                    end
                )
            )
        )
    end
    --]]

    return obj_card
end

-- 翻开动画
function GameingHandCardDeal:openCard(cardBg, cardImg)
    cc.Director:getInstance():setProjection(cc.DIRECTOR_PROJECTION2_D)--cocos2d::DisplayLinkDirector::Projection::_2D
    -- 盖牌 消失
    cardBg:runAction(
            cc.Sequence:create(
                -- cc.OrbitCamera:create(0.1,1,0,0,90,0,0), 
                cc.OrbitCamera:create(0.1,1,0,0,0,0,0), 
                cc.Hide:create(),
                cc.CallFunc:create(--开始角度设置为0，旋转90度
                    function()
                        -- 字牌 显示
                        cardImg:runAction( cc.Sequence:create(cc.Show:create(), cc.OrbitCamera:create(0.1,1,0,270,90,0,0)) )--开始角度是270，旋转90度
                    end
                )
            )
    )
end

-- 翻开动画
function GameingHandCardDeal:openCardBg(cardBg, cardImg)
    cc.Director:getInstance():setProjection(cc.DIRECTOR_PROJECTION2_D)--cocos2d::DisplayLinkDirector::Projection::_2D
    -- 盖牌 消失
    cardBg:runAction(
        cc.Sequence:create(
            cc.DelayTime:create(0.1),
            cc.Show:create(), 
            cc.CallFunc:create(
            function()
                -- cc.Sequence:create(
                --     cc.OrbitCamera:create(0.1,1,0,0,90,0,0), 
                --     cc.Hide:create(),
                --     cc.CallFunc:create(--开始角度设置为0，旋转90度
                --         function()
                --             -- 字牌 显示
                --             cardImg:runAction( cc.Sequence:create(cc.Show:create(), cc.OrbitCamera:create(0.1,1,0,270,90,0,0)) )--开始角度是270，旋转90度
                --         end
                --     )
                -- )
            end
            )
        )
    )
end

--[[
-- 手牌的码放方式
    @param: cardno 源头牌
    @param: indexNo 源头牌的位置编号  
                            这个如果为空，就是直接在需要的位置上加牌入手

    @param: zhihou_indexNo 源头牌的新入座位置编号，就是要判断这个位置是否可以放下，还是朝最近的放下
                           当 zhihou_indexNo 为空，就只是动源头挪动的位置，这个时候cardno也可以为空
--]]
--[[
function GameingHandCardDeal:myself_handcard_buildOK(_cardno, _indexNo, _zhihou_indexNo, _handCardDataTable)
    local rowNums = CVar._static.handRows -- 规定是3行
    local cardno = _cardno -- 要移动的牌
    local allColumn = CVar._static.handCardNums -- 手牌总共列数
    local half = allColumn/2 - 1.9 -- + 0.1 -- 一半在哪里
    local yushu = -1 -- = indexNo % allColumn -- 源头位置的对应所在列
    --Commons:printLog_Info("源头自己 要移动的列是：",yushu)

    ---11
    -- 目标对象 targetItem  已经有源头dragObj对象
    local indexNo = _indexNo
    local indexNo_1
    local indexNo_2

    -- 找出下面有几行
    if indexNo ~= nil then
        yushu = indexNo % allColumn
        Commons:printLog_Info("源头自己 要移动的列是：",yushu)

        -- 减法不会出现为0的位置编号
        if indexNo>0 and indexNo <= allColumn then -- 假如在第1行
            --indexNo_1 = allColumn*1 + yushu
            --indexNo_2 = allColumn*2 + yushu
            indexNo_1 = allColumn*2 - (allColumn-indexNo) -- 相邻的第一行
            indexNo_2 = allColumn*3 - (allColumn-indexNo) -- 相邻的第二行
        elseif indexNo>allColumn and indexNo <= (allColumn*2) then -- 假如在第2行
            --indexNo_1 = allColumn*0 + yushu
            --indexNo_2 = allColumn*2 + yushu
            indexNo_1 = allColumn*1 - (allColumn*2-indexNo)
            indexNo_2 = allColumn*3 - (allColumn*2-indexNo)
        elseif indexNo>allColumn*2 and indexNo <= (allColumn*3) then -- 假如在第3行
            --indexNo_1 = allColumn*0 + yushu
            --indexNo_2 = allColumn*1 + yushu
            indexNo_1 = allColumn*1 - (allColumn*3-indexNo)
            indexNo_2 = allColumn*2 - (allColumn*3-indexNo)
        end
    end
    Commons:printLog_Info("源头自己编号是：",indexNo)
    Commons:printLog_Info("源头相邻第一行：",indexNo_1)
    Commons:printLog_Info("源头相邻第二行：",indexNo_2)
    --11

    ---22
    -- 目标对象 targetItem
    local zhihou_indexNo = _zhihou_indexNo
    -- 找出下面有几行
    local always_isOverHalf = nil -- 记录第一次的寻找方向，以防找过半数，之后突然改变方向，就坑爹拉    

    if zhihou_indexNo ~= nil then
        ---33
        -- 还需要检测移动到的新列是不是有隔壁列为空的情况，有一直找到不为空为，最近一列为空的摆放即可
        local init_zhihou_indexNo = zhihou_indexNo -- 记录最早的位置信息，防止同一列拖动 突然位置信息就+1或者-1拉
        Commons:printLog_Info("检查之前 位置是：", zhihou_indexNo)
        local function GameingScene_js_no(temp_zhihou_indexNo)
            Commons:printLog_Info("检查中 位置是：",temp_zhihou_indexNo)
            local temp_yushu = temp_zhihou_indexNo % allColumn
            local _abs = math.abs(temp_zhihou_indexNo - allColumn)
            local isOverHalf = false
            if temp_yushu > half or temp_yushu==0 then
                isOverHalf = true -- 过半数，是true,往这边寻找 ←
            end
            if always_isOverHalf == nil then
                always_isOverHalf = isOverHalf
            end
            --Commons:printLog_Info("--检查中 always_isOverHalf是：", always_isOverHalf)
            --Commons:printLog_Info("--检查中 余数是：", temp_yushu)
            --Commons:printLog_Info("--检查中 _abs是：", _abs)
            --Commons:printLog_Info("--检查中 half是：", half)
            --Commons:printLog_Info("--检查中 isOverHalf是：", isOverHalf)
            if temp_yushu == 0 then
                temp_yushu = allColumn
            end
            local temp_1row = _handCardDataTable[allColumn * 0 + temp_yushu]
            local temp_2row = _handCardDataTable[allColumn * 1 + temp_yushu]
            local temp_3row = _handCardDataTable[allColumn * 2 + temp_yushu]
            --Commons:printLog_Info("--检查中 row是：", temp_1row, temp_2row, temp_3row)
            if temp_1row == CEnum.status.def_fill and temp_2row == CEnum.status.def_fill and temp_3row == CEnum.status.def_fill then
                if _abs >= 0 then
                    if always_isOverHalf then
                        temp_zhihou_indexNo = temp_zhihou_indexNo - 1
                    else
                        temp_zhihou_indexNo = temp_zhihou_indexNo + 1
                    end
                    zhihou_indexNo = temp_zhihou_indexNo
                    GameingScene_js_no(temp_zhihou_indexNo)
                end
            else
                if zhihou_indexNo ~= init_zhihou_indexNo then -- 和原值不相等，说明变动过，需要+1或者-1
                    if _abs >= 0 then
                        if always_isOverHalf then
                            zhihou_indexNo = zhihou_indexNo + 1
                        else
                            zhihou_indexNo = zhihou_indexNo - 1
                        end
                    end
                end
            end
        end
        GameingScene_js_no(zhihou_indexNo)
        Commons:printLog_Info("检查之后 位置是：",zhihou_indexNo) 

        if zhihou_indexNo == indexNo then -- 源头位置和目标位置相同，证明不移动牌，只是用户点击了一下牌面
            return _handCardDataTable
        end
        --33               


        -- 减法不会出现为0的位置编号
        local isRow = 0
        if zhihou_indexNo>0 and zhihou_indexNo <= allColumn then -- 假如在第1行
            isRow = 1
            zhihou_indexNo_1 = allColumn*2 - (allColumn-zhihou_indexNo) -- 相邻的第一行
            zhihou_indexNo_2 = allColumn*3 - (allColumn-zhihou_indexNo) -- 相邻的第二行
        elseif zhihou_indexNo>allColumn and zhihou_indexNo <= (allColumn*2) then -- 假如在第2行
            isRow = 2
            zhihou_indexNo_1 = allColumn - (allColumn*2-zhihou_indexNo)
            zhihou_indexNo_2 = allColumn*3 - (allColumn*2-zhihou_indexNo)
        elseif zhihou_indexNo>allColumn*2 and zhihou_indexNo <= (allColumn*3) then -- 假如在第3行
            isRow = 3
            zhihou_indexNo_1 = allColumn - (allColumn*3-zhihou_indexNo)
            zhihou_indexNo_2 = allColumn*2 - (allColumn*3-zhihou_indexNo)
        end
        --Commons:printLog_Info("zhihou相邻的自己是：",zhihou_indexNo)
        --Commons:printLog_Info("zhihou相邻的第一行：",zhihou_indexNo_1)
        --Commons:printLog_Info("zhihou相邻的第二行：",zhihou_indexNo_2)

        ---44
        -- 判断目标落牌位置
        local zhihou_yushu = zhihou_indexNo % allColumn

        local need_row = _handCardDataTable[zhihou_indexNo]
        local _1row = _handCardDataTable[zhihou_indexNo_1]
        local _2row = _handCardDataTable[zhihou_indexNo_2]
        Commons:printLog_Info("zhihou相邻me  要放的位置：", zhihou_indexNo, need_row)
        Commons:printLog_Info("zhihou相邻的第一行，牌是：", zhihou_indexNo_1, _1row)
        Commons:printLog_Info("zhihou相邻的第二行，牌是：", zhihou_indexNo_2, _2row)

        -- 不管放哪里，源头最后是要置空的
        if indexNo ~= nil then
            _handCardDataTable[indexNo] = CEnum.status.def_fill
        end
        if isRow == 1 then
            -- 要放的位置在第一行，但是要看看下面几行如何
            if _2row == CEnum.status.def_fill then
                _handCardDataTable[zhihou_indexNo_2] = cardno

            elseif _2row ~= CEnum.status.def_fill and _1row == CEnum.status.def_fill then
                _handCardDataTable[zhihou_indexNo_1] = cardno

            else
                if need_row == CEnum.status.def_fill then
                    _handCardDataTable[zhihou_indexNo] = cardno
                else
                    _handCardDataTable[indexNo] = cardno -- 满格 不交换的处理方式

                    -- local qian_abc = CEnum.cardType.a
                    -- if Commons:checkIsNull_str(need_row) and need_row ~= CEnum.status.def_fill then
                    --     local _size = string.len(need_row)
                    --     if _size >= 2 then
                    --         qian_abc = string.sub(need_row, 1, 1) -- 从第1位开始算 1位
                    --     end
                    -- end
                    -- if CEnum.cardType.c ~= qian_abc then
                    --     -- 满格 交换的处理方式
                    --     _handCardDataTable[indexNo] = need_row -- 需要落下位置的值  给到源头位置去
                    --     _handCardDataTable[zhihou_indexNo] = cardno -- 源头值 给到要落下的位置去
                    -- else
                    --     _handCardDataTable[indexNo] = cardno -- 与不能拖动的牌，不能做交换
                    -- end
                end
            end

        elseif isRow == 2 then
            -- 要放的位置在第二行，但是要看看下面几行如何
            if _2row == CEnum.status.def_fill then
                _handCardDataTable[zhihou_indexNo_2] = cardno

            elseif _2row ~= CEnum.status.def_fill and need_row == CEnum.status.def_fill then
                _handCardDataTable[zhihou_indexNo] = cardno

            else
                if _1row == CEnum.status.def_fill then
                    _handCardDataTable[zhihou_indexNo_1] = cardno
                else
                    _handCardDataTable[indexNo] = cardno -- 满格 不交换的处理方式

                    -- local qian_abc = CEnum.cardType.a
                    -- if Commons:checkIsNull_str(need_row) and need_row ~= CEnum.status.def_fill then
                    --     local _size = string.len(need_row)
                    --     if _size >= 2 then
                    --         qian_abc = string.sub(need_row, 1, 1) -- 从第1位开始算 1位
                    --     end
                    -- end
                    -- if CEnum.cardType.c ~= qian_abc then
                    --     -- 满格 交换的处理方式
                    --     _handCardDataTable[indexNo] = need_row -- 需要落下位置的值  给到源头位置去
                    --     _handCardDataTable[zhihou_indexNo] = cardno -- 源头值 给到要落下的位置去
                    -- else
                    --     _handCardDataTable[indexNo] = cardno -- 与不能拖动的牌，不能做交换
                    -- end
                end
            end

        elseif isRow == 3 then
            -- 要放的位置在第三行，但是要看看下面几行如何
            if need_row == CEnum.status.def_fill then
                _handCardDataTable[zhihou_indexNo] = cardno

            elseif need_row ~= CEnum.status.def_fill and _2row == CEnum.status.def_fill then
                _handCardDataTable[zhihou_indexNo_2] = cardno

            else
                if _1row == CEnum.status.def_fill then
                    _handCardDataTable[zhihou_indexNo_1] = cardno
                else
                    _handCardDataTable[indexNo] = cardno -- 满格 不交换的处理方式

                    -- local qian_abc = CEnum.cardType.a
                    -- if Commons:checkIsNull_str(need_row) and need_row ~= CEnum.status.def_fill then
                    --     local _size = string.len(need_row)
                    --     if _size >= 2 then
                    --         qian_abc = string.sub(need_row, 1, 1) -- 从第1位开始算 1位
                    --     end
                    -- end
                    -- if CEnum.cardType.c ~= qian_abc then
                    --     -- 满格 交换的处理方式
                    --     _handCardDataTable[indexNo] = need_row -- 需要落下位置的值  给到源头位置去
                    --     _handCardDataTable[zhihou_indexNo] = cardno -- 源头值 给到要落下的位置去
                    -- else
                    --     _handCardDataTable[indexNo] = cardno -- 与不能拖动的牌，不能做交换
                    -- end
                end
            end

        end

        --444
        -- if yushu ~= zhihou_yushu and _2row == CEnum.status.def_fill then
        --     Commons:printLog_Info("zhihou相邻 111111111111111111")
     --        if indexNo ~= nil then
        --         _handCardDataTable[indexNo] = CEnum.status.def_fill
     --        end
        --     _handCardDataTable[zhihou_indexNo] = CEnum.status.def_fill
        --     _handCardDataTable[zhihou_indexNo_2] = cardno

        -- elseif yushu ~= zhihou_yushu and _2row ~= CEnum.status.def_fill and _1row == CEnum.status.def_fill then
        --     Commons:printLog_Info("zhihou相邻 222222222222222222")
        --     if zhihou_indexNo > zhihou_indexNo_1 then
     --            if indexNo ~= nil then
        --             _handCardDataTable[indexNo] = CEnum.status.def_fill
     --            end
        --         _handCardDataTable[zhihou_indexNo] = cardno
        --     else
        --         _handCardDataTable[indexNo] = CEnum.status.def_fill
        --         _handCardDataTable[zhihou_indexNo] = CEnum.status.def_fill
        --         _handCardDataTable[zhihou_indexNo_1] = cardno
        --     end

        -- else
        --     Commons:printLog_Info("zhihou相邻 55555555555555555")
        --     if yushu == zhihou_yushu then -- 同列操作
        --         Commons:printLog_Info("zhihou相邻 55555555555555555  同列操作")
     --            if indexNo ~= nil then
        --             _handCardDataTable[indexNo] = cardno
     --            end
        --         _handCardDataTable[zhihou_indexNo] = CEnum.status.def_fill
        --     else
        --        Commons:printLog_Info("zhihou相邻 55555555555555555  跨列") -- 目标那一列 就剩下最上面一个位置
     --           if indexNo ~= nil then
        --            _handCardDataTable[indexNo] = CEnum.status.def_fill
     --           end
        --        _handCardDataTable[zhihou_indexNo] = cardno
        --     end
        -- end
        --444

        --44

    --else   
    end
    --22


    ---55
    Commons:printLog_Info("--检查zhihou always_isOverHalf是：", always_isOverHalf)
    if always_isOverHalf == nil and indexNo ~= nil then
        -- 没有目标位置的时候，只是源头部分落牌
        always_isOverHalf = false
        if yushu > half or yushu==0 then
            always_isOverHalf = true -- 过半数，是true,往这边寻找 ←
        end
    end

    -- 源头需要相应的落动
    local yuan_row = _handCardDataTable[indexNo]
    local yuan_1row = _handCardDataTable[indexNo_1]
    local yuan_2row = _handCardDataTable[indexNo_2]
    Commons:printLog_Info("111源头值还是多少：",yuan_row,yuan_1row,yuan_2row)
    Commons:printLog_Info("111源头值 序号 还是多少：",indexNo, indexNo_1, indexNo_2)
    if yuan_row == CEnum.status.def_fill then 
        -- 说明已经移动了
        if indexNo<indexNo_1 and indexNo<indexNo_2 then
            -- 最上层移动，无需变化
        elseif indexNo>indexNo_1 and indexNo<indexNo_2 then
            -- 第二层移走了
            _handCardDataTable[indexNo_1] = CEnum.status.def_fill
            _handCardDataTable[indexNo] = yuan_1row
            --_handCardDataTable[indexNo_2] = yuan_2row
        elseif indexNo>indexNo_1 and indexNo>indexNo_2 then
            -- 第三层移走了
            _handCardDataTable[indexNo_1] = CEnum.status.def_fill
            _handCardDataTable[indexNo_2] = yuan_1row
            _handCardDataTable[indexNo] = yuan_2row
        end
    end
    --55

    -- 源头挪动了位置，需要检查是不是整列给挪空了，挪空了，就需要2边的列同时移动过来
    yuan_row = _handCardDataTable[indexNo]
    yuan_1row = _handCardDataTable[indexNo_1]
    yuan_2row = _handCardDataTable[indexNo_2]
    Commons:printLog_Info("源头值还是多少：",yuan_row,yuan_1row,yuan_2row)
    --Commons:printLog_Info("源头值还是多少：",_handCardDataTable[indexNo_1],_handCardDataTable[indexNo_2],_handCardDataTable[indexNo])
    if yuan_row==CEnum.status.def_fill and yuan_1row==CEnum.status.def_fill and yuan_2row==CEnum.status.def_fill then 
        --Commons:printLog_Info("这个always_isOverHalf是：",always_isOverHalf)
        Commons:printLog_Info("这个yushu是：",yushu)

        ---66
        -- -- 这里的做法，是根据前面源头牌的最早移动方向来确定落牌之后的牌的移动方向
        -- if always_isOverHalf then -- 过半数，是true,往这边寻找 ←
        --     -- 只是保留这里，那就是全部往右移
        --     local i = yushu
        --     while i>=1 do
        --         Commons:printLog_Info("往右移",i);
        --         if i-1 ~= 0 then
        --             _handCardDataTable[allColumn*0+i] = _handCardDataTable[allColumn*0+(i-1)]
        --             _handCardDataTable[allColumn*1+i] = _handCardDataTable[allColumn*1+(i-1)]
        --             _handCardDataTable[allColumn*2+i] = _handCardDataTable[allColumn*2+(i-1)]
        --         else -- 等于最小值
        --             _handCardDataTable[allColumn*0+i] = CEnum.status.def_fill
        --             _handCardDataTable[allColumn*1+i] = CEnum.status.def_fill
        --             _handCardDataTable[allColumn*2+i] = CEnum.status.def_fill
        --         end
        --         i = i - 1;
        --     end
        -- else
        --     -- 只是保留这里，那就是全部往zuo移
        --     local i = yushu
        --     while i<=allColumn and i>0 do
        --         Commons:printLog_Info("往zuo移",i);
        --         if i ~= allColumn then
        --             _handCardDataTable[allColumn*0+i] = _handCardDataTable[allColumn*0+(i+1)]
        --             _handCardDataTable[allColumn*1+i] = _handCardDataTable[allColumn*1+(i+1)]
        --             _handCardDataTable[allColumn*2+i] = _handCardDataTable[allColumn*2+(i+1)]
        --         else -- 等于最大值
        --             _handCardDataTable[allColumn*0+i] = CEnum.status.def_fill
        --             _handCardDataTable[allColumn*1+i] = CEnum.status.def_fill
        --             _handCardDataTable[allColumn*2+i] = CEnum.status.def_fill
        --         end
        --         i = i + 1;
        --     end
        -- end
        --66

        ---66
        -- 来一个靠中间移动的
        if yushu < half then
            -- 落牌位置处于zuo边，靠中间移动  其实就是右移
            local i = yushu
            while i>=1 do
                Commons:printLog_Info("往右移",i);
                if i-1 ~= 0 then
                    _handCardDataTable[allColumn*0+i] = _handCardDataTable[allColumn*0+(i-1)]
                    _handCardDataTable[allColumn*1+i] = _handCardDataTable[allColumn*1+(i-1)]
                    _handCardDataTable[allColumn*2+i] = _handCardDataTable[allColumn*2+(i-1)]
                else -- 等于最小值
                    _handCardDataTable[allColumn*0+i] = CEnum.status.def_fill
                    _handCardDataTable[allColumn*1+i] = CEnum.status.def_fill
                    _handCardDataTable[allColumn*2+i] = CEnum.status.def_fill
                end
                i = i - 1;
            end
        else
            -- 落牌位置处于右边，靠中间移动  其实就是zuo移
            local i = yushu
            while i<=allColumn and i>0 do
                Commons:printLog_Info("往zuo移",i);
                if i ~= allColumn then
                    _handCardDataTable[allColumn*0+i] = _handCardDataTable[allColumn*0+(i+1)]
                    _handCardDataTable[allColumn*1+i] = _handCardDataTable[allColumn*1+(i+1)]
                    _handCardDataTable[allColumn*2+i] = _handCardDataTable[allColumn*2+(i+1)]
                else -- 等于最大值
                    _handCardDataTable[allColumn*0+i] = CEnum.status.def_fill
                    _handCardDataTable[allColumn*1+i] = CEnum.status.def_fill
                    _handCardDataTable[allColumn*2+i] = CEnum.status.def_fill
                end
                i = i + 1;
            end
        end
        --66
    end

    ---77
    -- 已经组装好了之后，看看现在多少列，再全部居中一次
    local _temp = {}
    if _handCardDataTable ~= nil then
        local size = #_handCardDataTable/rowNums
        local ii = 1
        while ii > 0 and ii <=size do
            local _temp2 = {}
            if _handCardDataTable[ii+allColumn*2]~=nil and _handCardDataTable[ii+allColumn*2]~=CEnum.status.def_fill then
                table.insert(_temp2, _handCardDataTable[ii+allColumn*2])
            end
            if _handCardDataTable[ii+allColumn*1]~=nil and _handCardDataTable[ii+allColumn*1]~=CEnum.status.def_fill then
                table.insert(_temp2, _handCardDataTable[ii+allColumn*1])
            end
            if _handCardDataTable[ii+allColumn*0]~=nil and _handCardDataTable[ii+allColumn*0]~=CEnum.status.def_fill then
                table.insert(_temp2, _handCardDataTable[ii+allColumn*0])
            end
            if _temp2 ~= nil and #_temp2 ~= 0 then
                table.insert(_temp, _temp2)
            end
            ii = ii + 1
        end
        if _temp ~= nil and #_temp ~= 0 then
            -- print("------------", #_temp)
            _handCardDataTable = GameingDealUtil:ScrollView_FillList(_temp, CVar._static.handCardNums)
        end
    end
    --77

    return _handCardDataTable
end
--]]

--[[
-- 手牌的码放方式
    @param: cardno 源头牌
    @param: indexNo 源头牌的位置编号  
                            这个如果为空，就是直接在需要的位置上加牌入手

    @param: zhihou_indexNo 源头牌的新入座位置编号，就是要判断这个位置是否可以放下，还是朝最近的放下
                           当 zhihou_indexNo 为空，就只是动源头挪动的位置，这个时候cardno也可以为空
--]]
---[[
function GameingHandCardDeal:myself_handcard_buildOK(_cardno, _indexNo, _zhihou_indexNo, _handCardDataTable)
    -- local startTime = socket.gettime() -- os.time() -- os.clock()

    local rowNums = CVar._static.handRows -- 规定是3行
    local cardno = _cardno -- 要移动的牌
    local allColumn = CVar._static.handCardNums -- 手牌总共列数
    local half = allColumn * rowNums/2 - 0.1 -- 一半数字在哪里
    local yushu = -1 -- 源头位置的余数的数字
    local rowIndexNo = nil -- 源头位置的对应所在行
    local allSize = allColumn * rowNums

    ---11
    -- 目标对象 targetItem  已经有源头dragObj对象
    local indexNo = _indexNo
    local indexNo_1 = nil
    local indexNo_2 = nil

    -- 找出和自己同一列标号
    if indexNo ~= nil then
        yushu = indexNo % allSize
        rowIndexNo = indexNo % rowNums
        Commons:printLog_Info("源头自己所在行是：", rowIndexNo)

        -- 从上到下数
        if rowIndexNo==1 then -- 假如在第1行
            indexNo_1 = indexNo +1 -- 第2行
            indexNo_2 = indexNo +2 -- 第3行

        elseif rowIndexNo==2 then -- 假如在第2行
            indexNo_1 = indexNo -1 -- 第1行
            indexNo_2 = indexNo +1 -- 第3行

        elseif rowIndexNo==0 then -- 假如在第3行
            indexNo_1 = indexNo -2 -- 第1行
            indexNo_2 = indexNo -1 -- 第2行
        end
    end
    Commons:printLog_Info("源头自己编号是：", indexNo)
    Commons:printLog_Info("源头相邻第一行：", indexNo_1)
    Commons:printLog_Info("源头相邻第二行：", indexNo_2, '\n')
    --11

    ---22
    -- 目标对象 targetItem
    local zhihou_indexNo = _zhihou_indexNo
    -- 找出和自己同一列标号
    local always_isOverHalf = nil -- 记录第一次的寻找方向，以防找过半数，之后突然改变方向，就坑爹拉    

    if zhihou_indexNo ~= nil then
        ---33
        -- 还需要检测移动到的新列是不是有隔壁列为空的情况，有一直找到不为空为，最近一列为空的摆放即可
        local init_zhihou_indexNo = zhihou_indexNo -- 记录最早的位置信息，防止同一列拖动 突然位置信息就+1或者-1拉
        Commons:printLog_Info("检查之前 位置是：", zhihou_indexNo)
        local function GameingScene_js_no(temp_zhihou_indexNo)
            Commons:printLog_Info("检查中的 位置是：", temp_zhihou_indexNo)
            local yushu_zhihou_temp = temp_zhihou_indexNo % allSize
            local isOverHalf = false
            if yushu_zhihou_temp > half or yushu_zhihou_temp==0 then
                isOverHalf = true -- 过半数，是true,往这边寻找 ←
            end
            if always_isOverHalf == nil then
                always_isOverHalf = isOverHalf
            end
            --Commons:printLog_Info("--检查中 always_isOverHalf是：", always_isOverHalf)
            --Commons:printLog_Info("--检查中 余数是：", yushu_zhihou_temp)
            --Commons:printLog_Info("--检查中 _abs是：", _abs)
            --Commons:printLog_Info("--检查中 half是：", half)
            --Commons:printLog_Info("--检查中 isOverHalf是：", isOverHalf)

            yushu_zhihou_temp = temp_zhihou_indexNo % rowNums
            local temp_1row = nil
            local temp_2row = nil
            local temp_3row = nil
            -- 从上到下数
            if yushu_zhihou_temp==1 then -- 假如在第1行
                temp_1row = _handCardDataTable[temp_zhihou_indexNo]    -- 第1行
                temp_2row = _handCardDataTable[temp_zhihou_indexNo +1] -- 第2行
                temp_3row = _handCardDataTable[temp_zhihou_indexNo +2] -- 第3行

            elseif yushu_zhihou_temp==2 then -- 假如在第2行
                temp_1row = _handCardDataTable[temp_zhihou_indexNo -1] -- 第1行
                temp_2row = _handCardDataTable[temp_zhihou_indexNo]    -- 第2行
                temp_3row = _handCardDataTable[temp_zhihou_indexNo +1] -- 第3行

            elseif yushu_zhihou_temp==0 then -- 假如在第3行
                temp_1row = _handCardDataTable[temp_zhihou_indexNo -2] -- 第1行
                temp_2row = _handCardDataTable[temp_zhihou_indexNo -1] -- 第2行
                temp_3row = _handCardDataTable[temp_zhihou_indexNo]    -- 第3行
            end
            --Commons:printLog_Info("--检查中 row是：", temp_1row, temp_2row, temp_3row)

            if temp_1row == CEnum.status.def_fill and temp_2row == CEnum.status.def_fill and temp_3row == CEnum.status.def_fill then
                    if always_isOverHalf then
                        temp_zhihou_indexNo = temp_zhihou_indexNo - rowNums
                    else
                        temp_zhihou_indexNo = temp_zhihou_indexNo + rowNums
                    end
                    zhihou_indexNo = temp_zhihou_indexNo
                    GameingScene_js_no(temp_zhihou_indexNo)
            else
                if zhihou_indexNo ~= init_zhihou_indexNo then -- 和原值不相等，说明变动过，需要+1或者-1
                        if always_isOverHalf then
                            zhihou_indexNo = zhihou_indexNo + rowNums
                        else
                            zhihou_indexNo = zhihou_indexNo - rowNums
                        end
                end
            end
        end
        GameingScene_js_no(zhihou_indexNo)
        Commons:printLog_Info("检查之后 位置是：", zhihou_indexNo, '\n') 

        if zhihou_indexNo == indexNo then -- 源头位置和目标位置相同，证明不移动牌，只是用户点击了一下牌面
            return _handCardDataTable
        end
        --33                


        -- 减法不会出现为0的位置编号
        local isRow = 0
        local yushu_zhihou = zhihou_indexNo % rowNums
        if yushu_zhihou==1 then -- 假如在第1行
            isRow = 1
            zhihou_indexNo_1 = zhihou_indexNo +1 -- 第2行
            zhihou_indexNo_2 = zhihou_indexNo +2 -- 第3行

        elseif yushu_zhihou==2 then -- 假如在第2行
            isRow = 2
            zhihou_indexNo_1 = zhihou_indexNo -1 -- 第1行
            zhihou_indexNo_2 = zhihou_indexNo +1 -- 第3行

        elseif yushu_zhihou==0 then -- 假如在第3行
            isRow = 3
            zhihou_indexNo_1 = zhihou_indexNo -2 -- 第1行
            zhihou_indexNo_2 = zhihou_indexNo -1 -- 第2行
        end
        --Commons:printLog_Info("zhihou相邻的自己是：",zhihou_indexNo)
        --Commons:printLog_Info("zhihou相邻的第一行：",zhihou_indexNo_1)
        --Commons:printLog_Info("zhihou相邻的第二行：",zhihou_indexNo_2)

        ---44
        -- 判断目标落牌位置
        local need_row = _handCardDataTable[zhihou_indexNo]
        local _1row = _handCardDataTable[zhihou_indexNo_1]
        local _2row = _handCardDataTable[zhihou_indexNo_2]
        Commons:printLog_Info("zhihou要放下的位置、值：", zhihou_indexNo, need_row)
        Commons:printLog_Info("zhihou第一行的位置、值：", zhihou_indexNo_1, _1row)
        Commons:printLog_Info("zhihou第二行的位置、值：", zhihou_indexNo_2, _2row, '\n')

        -- 不管放哪里，源头最后是要置空的
        if indexNo ~= nil then
            _handCardDataTable[indexNo] = CEnum.status.def_fill
        end
        if isRow == 1 then
            -- 要放的位置在第一行，但是要看看下面几行如何
            if _2row == CEnum.status.def_fill then
                _handCardDataTable[zhihou_indexNo_2] = cardno

            elseif _2row ~= CEnum.status.def_fill and _1row == CEnum.status.def_fill then
                _handCardDataTable[zhihou_indexNo_1] = cardno

            else
                if need_row == CEnum.status.def_fill then
                    _handCardDataTable[zhihou_indexNo] = cardno
                else
                    _handCardDataTable[indexNo] = cardno -- 满格 不交换的处理方式

                    -- local qian_abc = CEnum.cardType.a
                    -- if Commons:checkIsNull_str(need_row) and need_row ~= CEnum.status.def_fill then
                    --     local _size = string.len(need_row)
                    --     if _size >= 2 then
                    --         qian_abc = string.sub(need_row, 1, 1) -- 从第1位开始算 1位
                    --     end
                    -- end
                    -- if CEnum.cardType.c ~= qian_abc then
                    --     -- 满格 交换的处理方式
                    --     _handCardDataTable[indexNo] = need_row -- 需要落下位置的值  给到源头位置去
                    --     _handCardDataTable[zhihou_indexNo] = cardno -- 源头值 给到要落下的位置去
                    -- else
                    --     _handCardDataTable[indexNo] = cardno -- 与不能拖动的牌，不能做交换
                    -- end
                end
            end

        elseif isRow == 2 then
            -- 要放的位置在第二行，但是要看看下面几行如何
            if _2row == CEnum.status.def_fill then
                _handCardDataTable[zhihou_indexNo_2] = cardno

            elseif _2row ~= CEnum.status.def_fill and need_row == CEnum.status.def_fill then
                _handCardDataTable[zhihou_indexNo] = cardno

            else
                if _1row == CEnum.status.def_fill then
                    _handCardDataTable[zhihou_indexNo_1] = cardno
                else
                    _handCardDataTable[indexNo] = cardno -- 满格 不交换的处理方式

                    -- local qian_abc = CEnum.cardType.a
                    -- if Commons:checkIsNull_str(need_row) and need_row ~= CEnum.status.def_fill then
                    --     local _size = string.len(need_row)
                    --     if _size >= 2 then
                    --         qian_abc = string.sub(need_row, 1, 1) -- 从第1位开始算 1位
                    --     end
                    -- end
                    -- if CEnum.cardType.c ~= qian_abc then
                    --     -- 满格 交换的处理方式
                    --     _handCardDataTable[indexNo] = need_row -- 需要落下位置的值  给到源头位置去
                    --     _handCardDataTable[zhihou_indexNo] = cardno -- 源头值 给到要落下的位置去
                    -- else
                    --     _handCardDataTable[indexNo] = cardno -- 与不能拖动的牌，不能做交换
                    -- end
                end
            end

        elseif isRow == 3 then
            -- 要放的位置在第三行，但是要看看下面几行如何
            if need_row == CEnum.status.def_fill then
                _handCardDataTable[zhihou_indexNo] = cardno

            elseif need_row ~= CEnum.status.def_fill and _2row == CEnum.status.def_fill then
                _handCardDataTable[zhihou_indexNo_2] = cardno

            else
                if _1row == CEnum.status.def_fill then
                    _handCardDataTable[zhihou_indexNo_1] = cardno
                else
                    _handCardDataTable[indexNo] = cardno -- 满格 不交换的处理方式

                    -- local qian_abc = CEnum.cardType.a
                    -- if Commons:checkIsNull_str(need_row) and need_row ~= CEnum.status.def_fill then
                    --     local _size = string.len(need_row)
                    --     if _size >= 2 then
                    --         qian_abc = string.sub(need_row, 1, 1) -- 从第1位开始算 1位
                    --     end
                    -- end
                    -- if CEnum.cardType.c ~= qian_abc then
                    --     -- 满格 交换的处理方式
                    --     _handCardDataTable[indexNo] = need_row -- 需要落下位置的值  给到源头位置去
                    --     _handCardDataTable[zhihou_indexNo] = cardno -- 源头值 给到要落下的位置去
                    -- else
                    --     _handCardDataTable[indexNo] = cardno -- 与不能拖动的牌，不能做交换
                    -- end
                end
            end

        end
        --44

    --else 
    end
    --22


    ---55
    Commons:printLog_Info("--检查zhihou always_isOverHalf是：", always_isOverHalf, '\n')
    if always_isOverHalf == nil and indexNo ~= nil then
        -- 没有目标位置的时候，只是源头部分落牌
        always_isOverHalf = false
        if yushu > half or yushu==0 then
            always_isOverHalf = true -- 过半数，是true,往这边寻找 ←
        end
    end

    -- 源头需要相应的挪动
    local yuan_row = _handCardDataTable[indexNo]
    local yuan_1row = _handCardDataTable[indexNo_1]
    local yuan_2row = _handCardDataTable[indexNo_2]
    Commons:printLog_Info("--111源头 的序号：", indexNo, indexNo_1, indexNo_2)
    Commons:printLog_Info("--111源头 的值是：", yuan_row, yuan_1row, yuan_2row)
    if yuan_row == CEnum.status.def_fill then 
        -- 说明已经移动了
        if indexNo<indexNo_1 and indexNo<indexNo_2 then
            -- 最上层移动，无需变化
        elseif indexNo>indexNo_1 and indexNo<indexNo_2 then
            -- 第二层移走了
            _handCardDataTable[indexNo_1] = CEnum.status.def_fill
            _handCardDataTable[indexNo] = yuan_1row
            --_handCardDataTable[indexNo_2] = yuan_2row
        elseif indexNo>indexNo_1 and indexNo>indexNo_2 then
            -- 第三层移走了
            _handCardDataTable[indexNo_1] = CEnum.status.def_fill
            _handCardDataTable[indexNo_2] = yuan_1row
            _handCardDataTable[indexNo] = yuan_2row
        end
    end
    --55

    -- 源头挪动了位置，需要检查是不是整列给挪空了，挪空了，就需要2边的列同时移动过来
    yuan_row = _handCardDataTable[indexNo]
    yuan_1row = _handCardDataTable[indexNo_1]
    yuan_2row = _handCardDataTable[indexNo_2]
    Commons:printLog_Info("--222源头 值还是：", yuan_row, yuan_1row, yuan_2row, '\n')

    if yuan_row==CEnum.status.def_fill and yuan_1row==CEnum.status.def_fill and yuan_2row==CEnum.status.def_fill then 
        --Commons:printLog_Info("这个always_isOverHalf是：",always_isOverHalf)
        Commons:printLog_Info("这个yushu是：", yushu)

        ---66
        -- 来一个靠中间移动的
        if yushu < half then
            -- 落牌位置处于zuo边，靠中间移动  其实就是右移
            local i = yushu
            while i>=rowNums do
                Commons:printLog_Info("--往右移 →",i);
                if i-rowNums ~= 0 then
                    -- _handCardDataTable[allColumn*0+i] = _handCardDataTable[allColumn*0+(i-1)]
                    -- _handCardDataTable[allColumn*1+i] = _handCardDataTable[allColumn*1+(i-1)]
                    -- _handCardDataTable[allColumn*2+i] = _handCardDataTable[allColumn*2+(i-1)]

                    if rowIndexNo==1 then -- 假如在第1行
                        _handCardDataTable[0+i] = _handCardDataTable[0+(i-rowNums)]
                        _handCardDataTable[1+i] = _handCardDataTable[1+(i-rowNums)]
                        _handCardDataTable[2+i] = _handCardDataTable[2+(i-rowNums)]

                    elseif rowIndexNo==2 then
                        _handCardDataTable[-1+i] = _handCardDataTable[-1+(i-rowNums)]
                        _handCardDataTable[0+i] = _handCardDataTable[0+(i-rowNums)]
                        _handCardDataTable[1+i] = _handCardDataTable[1+(i-rowNums)]

                    elseif rowIndexNo==0 then
                        _handCardDataTable[-2+i] = _handCardDataTable[-2+(i-rowNums)]
                        _handCardDataTable[-1+i] = _handCardDataTable[-1+(i-rowNums)]
                        _handCardDataTable[0+i] = _handCardDataTable[0+(i-rowNums)]
                    end
                else -- 等于最小值
                    -- _handCardDataTable[allColumn*0+i] = CEnum.status.def_fill
                    -- _handCardDataTable[allColumn*1+i] = CEnum.status.def_fill
                    -- _handCardDataTable[allColumn*2+i] = CEnum.status.def_fill

                    if rowIndexNo==1 then -- 假如在第1行
                        _handCardDataTable[0+i] = CEnum.status.def_fill
                        _handCardDataTable[1+i] = CEnum.status.def_fill
                        _handCardDataTable[2+i] = CEnum.status.def_fill

                    elseif rowIndexNo==2 then
                        _handCardDataTable[-1+i] = CEnum.status.def_fill
                        _handCardDataTable[0+i] = CEnum.status.def_fill
                        _handCardDataTable[1+i] = CEnum.status.def_fill

                    elseif rowIndexNo==0 then
                        _handCardDataTable[-2+i] = CEnum.status.def_fill
                        _handCardDataTable[-1+i] = CEnum.status.def_fill
                        _handCardDataTable[0+i] = CEnum.status.def_fill
                    end
                end
                i = i - rowNums
            end
        else
            -- 落牌位置处于右边，靠中间移动  其实就是zuo移
            local i = yushu
            while i<=allSize and i>0 do
                Commons:printLog_Info("--往zuo移 ←",i);
                if i ~= allSize then
                    -- _handCardDataTable[allColumn*0+i] = _handCardDataTable[allColumn*0+(i+1)]
                    -- _handCardDataTable[allColumn*1+i] = _handCardDataTable[allColumn*1+(i+1)]
                    -- _handCardDataTable[allColumn*2+i] = _handCardDataTable[allColumn*2+(i+1)]

                    if rowIndexNo==1 then -- 假如在第1行
                        _handCardDataTable[0+i] = _handCardDataTable[0+(i+rowNums)]
                        _handCardDataTable[1+i] = _handCardDataTable[1+(i+rowNums)]
                        _handCardDataTable[2+i] = _handCardDataTable[2+(i+rowNums)]

                    elseif rowIndexNo==2 then
                        _handCardDataTable[-1+i] = _handCardDataTable[-1+(i+rowNums)]
                        _handCardDataTable[0+i] = _handCardDataTable[0+(i+rowNums)]
                        _handCardDataTable[1+i] = _handCardDataTable[1+(i+rowNums)]

                    elseif rowIndexNo==0 then
                        _handCardDataTable[-2+i] = _handCardDataTable[-2+(i+rowNums)]
                        _handCardDataTable[-1+i] = _handCardDataTable[-1+(i+rowNums)]
                        _handCardDataTable[0+i] = _handCardDataTable[0+(i+rowNums)]
                    end
                else -- 等于最大值
                    -- _handCardDataTable[allColumn*0+i] = CEnum.status.def_fill
                    -- _handCardDataTable[allColumn*1+i] = CEnum.status.def_fill
                    -- _handCardDataTable[allColumn*2+i] = CEnum.status.def_fill

                    if rowIndexNo==1 then -- 假如在第1行
                        _handCardDataTable[0+i] = CEnum.status.def_fill
                        _handCardDataTable[1+i] = CEnum.status.def_fill
                        _handCardDataTable[2+i] = CEnum.status.def_fill

                    elseif rowIndexNo==2 then
                        _handCardDataTable[-1+i] = CEnum.status.def_fill
                        _handCardDataTable[0+i] = CEnum.status.def_fill
                        _handCardDataTable[1+i] = CEnum.status.def_fill

                    elseif rowIndexNo==0 then
                        _handCardDataTable[-2+i] = CEnum.status.def_fill
                        _handCardDataTable[-1+i] = CEnum.status.def_fill
                        _handCardDataTable[0+i] = CEnum.status.def_fill
                    end
                end
                i = i + rowNums
            end
        end
        --66
    end

    -- ---77
    -- -- 已经组装好了之后，看看现在多少列，再全部居中一次
    -- local _temp = {}
    -- if _handCardDataTable ~= nil then
    --     local size = #_handCardDataTable
    --     local ii = 1
    --     while ii > 0 and ii <=size do
    --         local _temp2 = {}
    --         if _handCardDataTable[ii+2]~=nil and _handCardDataTable[ii+2]~=CEnum.status.def_fill then
    --             table.insert(_temp2, _handCardDataTable[ii+2])
    --         end
    --         if _handCardDataTable[ii+1]~=nil and _handCardDataTable[ii+1]~=CEnum.status.def_fill then
    --             table.insert(_temp2, _handCardDataTable[ii+1])
    --         end
    --         if _handCardDataTable[ii+0]~=nil and _handCardDataTable[ii+0]~=CEnum.status.def_fill then
    --             table.insert(_temp2, _handCardDataTable[ii+0])
    --         end
    --         if _temp2 ~= nil and #_temp2 ~= 0 then
    --             table.insert(_temp, _temp2)
    --         end
    --         ii = ii + rowNums
    --     end
    --     if _temp ~= nil and #_temp ~= 0 then
    --         -- print("------------", #_temp)
    --         _handCardDataTable = GameingDealUtil:ScrollView_FillList(_temp, CVar._static.handCardNums)
    --     end
    -- end
    -- --77

    -- local entTime = socket.gettime() -- os.time() -- os.clock()
    -- local _time = entTime - startTime
    -- print(entTime, startTime, "------------time：移动牌落牌处理 耗时：".._time.." ms")

    return _handCardDataTable
end
--]]


-- 构造函数
function GameingHandCardDeal:ctor()
end


function GameingHandCardDeal:onEnter()
end


function GameingHandCardDeal:onExit()
    --Commons:printLog_Info("GameingHandCardDeal:onExit")
    --self:removeAllChildren();
end

-- 必须有这个返回
return GameingHandCardDeal