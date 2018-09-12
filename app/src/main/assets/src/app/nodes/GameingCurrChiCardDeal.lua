--
-- Author: lte
-- Date: 2016-11-03 17:33:07
-- 游戏中 所有玩家已经吃碰过牌的具体处理 消失动画

-- 类申明
-- local GameingCurrChiCardDeal = class("GameingCurrChiCardDeal", function ()
--     return display.newNode();
-- end)
local GameingCurrChiCardDeal = class("GameingCurrChiCardDeal")


local osWidth = Commons.osWidth;
local osHeight = Commons.osHeight;

local card_w_single_bg = 92  -- 单张牌的宽高  背景框
local card_h_single_bg = 242
local card_w_single = 76  -- 单张牌的宽高
local card_h_single = 226

local card_w = 60  -- 牌的宽高
local card_h = 60

local card_w_out = 42  -- 牌的宽高
local card_h_out = 42

local view_CurrChi_node = nil
-- local roomNo = nil
-- local actionNo = nil
-- local isChu = nil
-- local chu_tipimg = nil

local myself_view_mo_chu_pai_bg_oldName = nil
local xiajia_view_mo_chu_pai_bg_oldName = nil
local lastjia_view_mo_chu_pai_bg_oldName = nil

function GameingCurrChiCardDeal:createCurrChiCards(_seat,v,
	need_view, displayAlign, displayX, displayY,
	myself_view_mo_chu_pai_bg, myself_view_mo_chu_pai,
	xiajia_view_mo_chu_pai_bg, xiajia_view_mo_chu_pai,
	lastjia_view_mo_chu_pai_bg, lastjia_view_mo_chu_pai,
	myself_view_chiguo_list,xiajia_view_chiguo_list,lastjia_view_chiguo_list,
	myself_view_chuguo_list,xiajia_view_chuguo_list,lastjia_view_chuguo_list,
	box_chupai, isMeChu
)
	-- roomNo = _roomNo
	-- actionNo = _actionNo
	-- isChu = _isChu

	local currOption = v[Player.Bean.currOption] -- 当前的操作动作
    local chiDemos = v[Player.Bean.currChiCombs] -- 当前吃、碰了什么牌
    Commons:printLog_Info("====玩家====座位编号： 上一步已经完成的操作：  牌是：",_seat, currOption, chiDemos)

    local playStatus = v[Player.Bean.playStatus] -- 游戏状态
	--Commons:printLog_Info("playStatus=",playStatus)

	local _role = v[Player.Bean.role]
	local role = _role == CEnum.role.z

	local options = v[Player.Bean.options] -- 当前可以的操作

	if playStatus ~= nil and CEnum.playStatus.ended ~= playStatus then -- 游戏中

		if Commons:checkIsNull_str(currOption) and currOption ~= CEnum.playOptions.guo then
			if _seat == CEnum.seatNo.me then
				--myself_view_mo_chu_pai_bg:setVisible(false)
	            --myself_view_mo_chu_pai:setVisible(false)
	            xiajia_view_mo_chu_pai_bg:setVisible(false)
		        xiajia_view_mo_chu_pai_bg:setVisible(false)
		        lastjia_view_mo_chu_pai_bg:setVisible(false)
		        lastjia_view_mo_chu_pai:setVisible(false)

		        --myself_view_mo_chu_pai_bg:setLocalZOrder(1)

				myself_view_mo_chu_pai_bg:setVisible(true)
		        myself_view_mo_chu_pai_bg:setButtonImage(EnStatus.normal, GameingDealUtil:getImgByOptionOut(currOption))
		        myself_view_mo_chu_pai_bg:setButtonImage(EnStatus.pressed, GameingDealUtil:getImgByOptionOut(currOption))
		        myself_view_mo_chu_pai:setVisible(false)
		        if myself_view_mo_chu_pai_bg_oldName == nil then
		        	myself_view_mo_chu_pai_bg_oldName = myself_view_mo_chu_pai_bg:getName()
		        end
		        need_view:performWithDelay(function () 
		        	-- myself_view_mo_chu_pai_bg:setVisible(false)
			        -- myself_view_mo_chu_pai:setVisible(false)

		        	local currName = myself_view_mo_chu_pai_bg:getName()
		        	--print("=================2个时间戳如何my 当前::", currName)
		        	--print("=================2个时间戳如何my 开始::", myself_view_mo_chu_pai_bg_oldName)
		        	if currName ~= nil and myself_view_mo_chu_pai_bg_oldName~=nil and myself_view_mo_chu_pai_bg_oldName~=currName then
		        		myself_view_mo_chu_pai_bg:setVisible(true)
		        		myself_view_mo_chu_pai:setVisible(true)
		        	else
				        myself_view_mo_chu_pai_bg:setVisible(false)
				        myself_view_mo_chu_pai:setVisible(false)
		        	end
		        	myself_view_mo_chu_pai_bg_oldName = nil
			    end, 0.7) -- 要小于或者等于动画时间
	        elseif _seat == CEnum.seatNo.R then
	        	myself_view_mo_chu_pai_bg:setVisible(false)
	            myself_view_mo_chu_pai:setVisible(false)
	            --xiajia_view_mo_chu_pai_bg:setVisible(false)
		        --xiajia_view_mo_chu_pai_bg:setVisible(false)
		        lastjia_view_mo_chu_pai_bg:setVisible(false)
		        lastjia_view_mo_chu_pai:setVisible(false)

				--xiajia_view_mo_chu_pai_bg:setLocalZOrder(1)

	        	xiajia_view_mo_chu_pai_bg:setVisible(true)
		        xiajia_view_mo_chu_pai_bg:setButtonImage(EnStatus.normal, GameingDealUtil:getImgByOptionOut(currOption))
		        xiajia_view_mo_chu_pai_bg:setButtonImage(EnStatus.pressed, GameingDealUtil:getImgByOptionOut(currOption))
		        xiajia_view_mo_chu_pai:setVisible(false)
		        if xiajia_view_mo_chu_pai_bg_oldName == nil then
		        	xiajia_view_mo_chu_pai_bg_oldName = xiajia_view_mo_chu_pai_bg:getName()
		        end
		        need_view:performWithDelay(function () 
			        -- xiajia_view_mo_chu_pai_bg:setVisible(false)
			        -- xiajia_view_mo_chu_pai:setVisible(false)

			        local currName = xiajia_view_mo_chu_pai_bg:getName()
			        --print("=================2个时间戳如何xia 当前::", currName)
		        	--print("=================2个时间戳如何xia 开始::", xiajia_view_mo_chu_pai_bg_oldName)
		        	if currName ~= nil and xiajia_view_mo_chu_pai_bg_oldName~=nil and xiajia_view_mo_chu_pai_bg_oldName~=currName then
		        		xiajia_view_mo_chu_pai_bg:setVisible(true)
		        		xiajia_view_mo_chu_pai:setVisible(true)
		        	else
				        xiajia_view_mo_chu_pai_bg:setVisible(false)
				        xiajia_view_mo_chu_pai:setVisible(false)
		        	end
		        	xiajia_view_mo_chu_pai_bg_oldName = nil
			    end, 0.7) -- 要小于或者等于动画时间
	        elseif _seat == CEnum.seatNo.L then
	        	myself_view_mo_chu_pai_bg:setVisible(false)
	            myself_view_mo_chu_pai:setVisible(false)
	            xiajia_view_mo_chu_pai_bg:setVisible(false)
		        xiajia_view_mo_chu_pai_bg:setVisible(false)
		        --lastjia_view_mo_chu_pai_bg:setVisible(false)
		        --lastjia_view_mo_chu_pai:setVisible(false)

		        --lastjia_view_mo_chu_pai_bg:setLocalZOrder(1)

	        	lastjia_view_mo_chu_pai_bg:setVisible(true)
		        lastjia_view_mo_chu_pai_bg:setButtonImage(EnStatus.normal, GameingDealUtil:getImgByOptionOut(currOption))
		        lastjia_view_mo_chu_pai_bg:setButtonImage(EnStatus.pressed, GameingDealUtil:getImgByOptionOut(currOption))
		        lastjia_view_mo_chu_pai:setVisible(false)
		        if lastjia_view_mo_chu_pai_bg_oldName == nil then
		        	lastjia_view_mo_chu_pai_bg_oldName = xiajia_view_mo_chu_pai_bg:getName()
		        end
		        need_view:performWithDelay(function () 
		            -- lastjia_view_mo_chu_pai_bg:setVisible(false)
		            -- lastjia_view_mo_chu_pai:setVisible(false)

		            local currName = lastjia_view_mo_chu_pai_bg:getName()
		            --print("=================2个时间戳如何last 当前::", currName)
		        	--print("=================2个时间戳如何last 开始::", lastjia_view_mo_chu_pai_bg_oldName)
		        	if currName ~= nil and lastjia_view_mo_chu_pai_bg_oldName~=nil and lastjia_view_mo_chu_pai_bg_oldName~=currName then
		        		lastjia_view_mo_chu_pai_bg:setVisible(true)
		        		lastjia_view_mo_chu_pai:setVisible(true)
		        	else
				        lastjia_view_mo_chu_pai_bg:setVisible(false)
				        lastjia_view_mo_chu_pai:setVisible(false)
		        	end
		        	lastjia_view_mo_chu_pai_bg_oldName = nil
			    end, 0.7) -- 要小于或者等于动画时间
		    end
	    --end
		--if Commons:checkIsNull_str(currOption) then -- and currOption ~= CEnum.playOptions.guo then
			-- 开始出选择界面
			--local chiDemos = v[Player.Bean.chiDemos] -- 当前吃的方案
			-- 考虑多级联动 第一层
			local need_chiDemos = {}
			local columnSize
			local rowMaxSize

			if Commons:checkIsNull_tableList(chiDemos) then
				columnSize = #chiDemos;
				rowMaxSize = 1
				local onlyCard = nil
				for k,v in pairs(chiDemos) do
					if Commons:checkIsNull_tableList(v) then
						onlyCard = v[1]
						local ss = #v
						if ss > rowMaxSize then
							rowMaxSize = ss
						end
					end
				end
				if rowMaxSize > 1 and rowMaxSize < 4 then
					rowMaxSize = 4
				end

				--Commons:printLog_Info("==========:",columnSize, rowMaxSize)
				--Commons:printLog_Info("==========:",(columnSize*rowMaxSize), columnSize+1)
				if rowMaxSize~=1 then
					need_chiDemos = GameingDealUtil:PageView_FillList_MePengCard(chiDemos, (columnSize*rowMaxSize), columnSize+1)
				else
					need_chiDemos[1] = onlyCard
				end
			end
			
			if Commons:checkIsNull_tableList(need_chiDemos) then
				if view_CurrChi_node ~= nil and (not tolua.isnull(view_CurrChi_node)) then
					--view_CurrChi_node:removeAllItems()
					view_CurrChi_node:removeFromParent()
					view_CurrChi_node = nil
				end
				view_CurrChi_node = display.newNode()
				view_CurrChi_node:addTo(need_view)

				local view_CurrChi_list
				--if view_CurrChi_list~=nil and (not tolua.isnull(view_CurrChi_list)) then
				--	view_CurrChi_list:removeAllItems()
				--	view_CurrChi_list:removeFromParent()
				--end

				if rowMaxSize==1 then
					view_CurrChi_list = cc.ui.UIPageView.new({
			            viewRect = cc.rect(0, 0, card_w_single_bg, card_h_single_bg),
			            column = columnSize,
			            row = rowMaxSize, 
			            padding = {left = (card_w_single_bg/2), right = (card_w_single_bg/2), top = 0, bottom = (card_h_single_bg/2)},
			            columnSpace=0,
			            rowSpace=0,
			            --bgColor = cc.c4b(200, 200, 200, 255),
			            bCirc = false
			        })
			        --:onTouch(touchListener)
			        :addTo(view_CurrChi_node)
			        --:align(display.CENTER_TOP, display.cx, osHeight-170-48)
			        :align(displayAlign, displayX, displayY)
			    else
			    	view_CurrChi_list = cc.ui.UIPageView.new({
			            viewRect = cc.rect(0, 0, card_w*columnSize, card_h*rowMaxSize),
			            column = columnSize,
			            row = rowMaxSize, 
			            padding = {left = (card_w/2), right = 0, top = 0, bottom = (card_h/2)},
			            columnSpace=0,
			            rowSpace=0,
			            --bgColor = cc.c4b(200, 200, 200, 255),
			            bCirc = false
			        })
			        --:onTouch(touchListener)
			        :addTo(view_CurrChi_node)
			        --:align(display.CENTER_TOP, display.cx, osHeight-170-48)
			        :align(displayAlign, displayX, displayY)
			    end

				for k_chi,v_chi in pairs(need_chiDemos) do
					local item11 = view_CurrChi_list:newItem()
					local content = display.newNode()
					local img_vv
					if rowMaxSize==1 then
						img_vv = GameingDealUtil:getImgByHandcard(CEnum.userCard.mid_chu, v_chi)
						cc.ui.UIPushButton.new(img_vv, {scale9 = false})
							:setButtonSize(card_w_single, card_h_single)
							:addTo(content)
							--:align(display.CENTER, 0, -121)
						--item11:setItemSize(76, 226)
						item11:addChild(content)
					else
						--Commons:printLog_Info("======222222====:",columnSize, rowMaxSize, k_chi,v_chi)
						img_vv = GameingDealUtil:getImgByHandcard(CEnum.userCard.out, v_chi)
						--img_vv = Imgs.card_mid_ns1
						local tt = cc.ui.UIPushButton.new(img_vv, {scale9 = false})
							:setButtonSize(card_w, card_w)
							:addTo(content)
						--item11:setItemSize(42, 42)
						item11:addChild(content)
					end
					view_CurrChi_list:addItem(item11)
				end
				view_CurrChi_list:reload()

				-- 动画之前播放声音
				if currOption==CEnum.playOptions.chi and columnSize>1 then
					VoiceDealUtil:playSound(CEnum.playOptions.xiahuo)
				else
					VoiceDealUtil:playSound(currOption)
				end

				--need_view:performWithDelay(function () 
					local scale1
					local move1
					local scale2
					-- 总共动画时间要 >=1.2秒
					if _seat == CEnum.seatNo.me then
						--scale1 = cc.ScaleTo:create(0.4, 1.3);
						move1 = cc.MoveTo:create(0.4, cc.p(-430, -80)); -- 图片出现位置越靠左，这个x值就需要负的越小才行，y值变动不大
						scale2 = cc.ScaleTo:create(0.3, 0.8);

					elseif _seat == CEnum.seatNo.R then
						--scale1 = cc.ScaleTo:create(0.4, 1.1);
						--move1 = cc.MoveTo:create(1.3, cc.p(osWidth-250, 250)); -- 可以找到最后落的位置，但是效果不对
						move1 = cc.MoveTo:create(0.4, cc.p(500, -20)); -- 图片出现位置越靠左，这个x值就需要越大，y值变动不大
						scale2 = cc.ScaleTo:create(0.3, 0.98);

					elseif _seat == CEnum.seatNo.L then
						--scale1 = cc.ScaleTo:create(0.4, 1.1);
						move1 = cc.MoveTo:create(0.4, cc.p(-290, 0)); -- 图片出现位置越靠左，这个x值就需要负的越小才行，y值变动不大
						scale2 = cc.ScaleTo:create(0.3, 0.8);
					end

					--local sAction = cc.Spawn:create(scale1)
					local sAction = cc.Sequence:create(move1, scale2, cc.CallFunc:create(function()
							if options~=nil and #options > 1 then
								--print("------------------------我上一步有操作----但是这一步我还有操作 偎牌的情况")
							else
								-- 动画完成后，本人再出现可以出牌区域
								if _seat == CEnum.seatNo.me and isMeChu~=nil then
									--print("------------------------我上一步有操作----我出牌拉拉拉拉拉啦啦啦")
									if box_chupai~= nil and isMeChu then
			        		            -- 本人要出牌了，显示出牌区域
			                            box_chupai:setVisible(true)
			                            -- 只要显示可以出牌，就出现动画
	                        			--chu_tipimg = GameingHandCardDeal:createChupaiHint_Anim(box_chupai, chu_tipimg)
			                        end
								end
							end

							--Commons:printLog_Info("===============================完成吃碰牌动画")
							if not tolua.isnull(view_CurrChi_node) then
								view_CurrChi_node:removeFromParent()
								view_CurrChi_node = nil
							end

							-- 1 吃碰之后应该谁摸或者出牌
							GameingCurrChiCardDeal:DealMoChuCards(_seat,v,
								need_view,
								myself_view_mo_chu_pai_bg, myself_view_mo_chu_pai,
								xiajia_view_mo_chu_pai_bg, xiajia_view_mo_chu_pai,
								lastjia_view_mo_chu_pai_bg, lastjia_view_mo_chu_pai				
							)

							-- 2 显示每位玩家  已经吃、碰过的牌 列表
							GameingCurrChiCardDeal:showPlayers_ChiguoCards(_seat,v,
								myself_view_chiguo_list,xiajia_view_chiguo_list,lastjia_view_chiguo_list
							)

							-- 3 显示每位玩家 已经打出的牌
							GameingCurrChiCardDeal:showPlayers_ChuguoCards(_seat,v,
								myself_view_chuguo_list,xiajia_view_chuguo_list,lastjia_view_chuguo_list
							)

							-- 4 如果当前是跑8 或者提8 三家出牌都是false，需要我打出一个过，告知服务器动画结束，开始下一轮摸牌
							-- if not isChu and _seat == CEnum.seatNo.me then --and role then
							-- 	Commons:printLog_Info("----11不知道具体操作了，所以我过牌:", actionNo)
							-- 	SocketRequestGameing:gameing_Guo(actionNo)
							-- end

							-- 5 动画之后的 我本人的 一些操作显示
							-- GameingCurrChiCardDeal:meOptions(_seat,v,
							-- 	need_view,
							-- 	box_chupai,myself_view_needOption_list
							-- )

						end))
					view_CurrChi_node:runAction(sAction)

			    --end, 0.5)
				
			end
		else
			-- 本人没有操作，既没有动画，但是需要本人出牌再  出现可以出牌区域
			if _seat == CEnum.seatNo.me and isMeChu~=nil then
				--print("------------------------他人的操作----我出牌拉拉拉拉拉啦啦啦")
				if box_chupai~= nil and isMeChu then
		            -- 本人要出牌了，显示出牌区域
                    box_chupai:setVisible(true)
                    -- 只要显示可以出牌，就出现动画
        			--chu_tipimg = GameingHandCardDeal:createChupaiHint_Anim(box_chupai, chu_tipimg)
                end
			end

			-- 1 吃碰之后应该谁摸或者出牌
			GameingCurrChiCardDeal:DealMoChuCards(_seat,v,
				need_view,
				myself_view_mo_chu_pai_bg, myself_view_mo_chu_pai,
				xiajia_view_mo_chu_pai_bg, xiajia_view_mo_chu_pai,
				lastjia_view_mo_chu_pai_bg, lastjia_view_mo_chu_pai					
			)

			-- 2 显示每位玩家  已经吃、碰过的牌 列表
			GameingCurrChiCardDeal:showPlayers_ChiguoCards(_seat,v,
				myself_view_chiguo_list,xiajia_view_chiguo_list,lastjia_view_chiguo_list
			)

			-- 3 显示每位玩家 已经打出的牌
			GameingCurrChiCardDeal:showPlayers_ChuguoCards(_seat,v,
				myself_view_chuguo_list,xiajia_view_chuguo_list,lastjia_view_chuguo_list
			)
		end

	else 
		-- 游戏回合结束
		--[[
		myself_view_mo_chu_pai_bg:setVisible(false)
        myself_view_mo_chu_pai:setVisible(false)
        xiajia_view_mo_chu_pai_bg:setVisible(false)
        xiajia_view_mo_chu_pai_bg:setVisible(false)
        lastjia_view_mo_chu_pai_bg:setVisible(false)
        lastjia_view_mo_chu_pai:setVisible(false)

        -- 1 吃碰之后应该谁摸或者出牌  【游戏over肯定就没有任何显示】

        -- 2 显示每位玩家  已经吃、碰过的牌 列表
		GameingCurrChiCardDeal:showPlayers_ChiguoCards(_seat,v,
			myself_view_chiguo_list,xiajia_view_chiguo_list,lastjia_view_chiguo_list
		)

		-- 3 显示每位玩家 已经打出的牌
		GameingCurrChiCardDeal:showPlayers_ChuguoCards(_seat,v,
			myself_view_chuguo_list,xiajia_view_chuguo_list,lastjia_view_chuguo_list
		)
		--]]

	end -- if 游戏中
	
end

-- 1 吃碰之后应该谁摸或者出牌
function GameingCurrChiCardDeal:DealMoChuCards(_seat,v,
	need_view,
	myself_view_mo_chu_pai_bg, myself_view_mo_chu_pai,
	xiajia_view_mo_chu_pai_bg, xiajia_view_mo_chu_pai,
	lastjia_view_mo_chu_pai_bg, lastjia_view_mo_chu_pai
)
	Commons:printLog_Info("--1 吃碰之后应该谁摸或者出牌")
	--Commons:printLog_Info("1当前的操作是：=============", v)
	local action = v[Player.Bean.action] -- 当前摸或者出的牌
	--Commons:printLog_Info("2当前的操作是：=============", action)
	if Commons:checkIsNull_tableType(action) then
		--Commons:printLog_Info("3当前的操作是：=============", action)
		local _card = action[Player.Bean.card]
		local _type = action[Player.Bean._type]
		--local _actionNo = action[Player.Bean.actionNo]
		Commons:printLog_Info("----1 玩家 当前的操作是：", _type, _card)--, _actionNo)

		if Commons:checkIsNull_str(_card) --and not isWang
			and Commons:checkIsNull_str(_type) and (CEnum.options.mo == _type or CEnum.options.other == _type) then
			VoiceDealUtil:playSound_other(Voices.file.gameing_mocard)
		elseif Commons:checkIsNull_str(_card) --and not isWang
			and Commons:checkIsNull_str(_type) and CEnum.options.chu == _type then
			VoiceDealUtil:playSound_other(Voices.file.gameing_chucard)
		end

		local isWang = false
		--播放声音
		if Commons:checkIsNull_str(_card) then
			local _size = string.len(_card)
			if _size >= 3 then
				local cc = string.sub(_card, 3, _size)
				Commons:printLog_Info("------摸到的是个什么牌：", cc)
				VoiceDealUtil:playSound(cc)
				if cc == CEnum.optionsCard.w0 then -- and _type==CEnum.options.mo then
					Commons:printLog_Info("--------摸到的是个什么牌：是王八")
					isWang = true
				end
			end
		end

		if Commons:checkIsNull_str(_card) --and not isWang
			and Commons:checkIsNull_str(_type) and (CEnum.options.mo == _type or CEnum.options.other == _type) then
			
			if _seat == CEnum.seatNo.me then
				--myself_view_mo_chu_pai_bg:setVisible(false)
	            --myself_view_mo_chu_pai:setVisible(false)
	            xiajia_view_mo_chu_pai_bg:setVisible(false)
		        xiajia_view_mo_chu_pai:setVisible(false)
		        lastjia_view_mo_chu_pai_bg:setVisible(false)
		        lastjia_view_mo_chu_pai:setVisible(false)

				myself_view_mo_chu_pai_bg:setVisible(true)
	            myself_view_mo_chu_pai_bg:setButtonImage(EnStatus.normal, Imgs.gameing_mid_mopai_bg)
	            myself_view_mo_chu_pai_bg:setButtonImage(EnStatus.pressed, Imgs.gameing_mid_mopai_bg)
	            myself_view_mo_chu_pai:setVisible(true)
	            myself_view_mo_chu_pai:setButtonImage(EnStatus.normal, GameingDealUtil:getImgByHandcard(CEnum.userCard.mid_mo, _card))
	            myself_view_mo_chu_pai:setButtonImage(EnStatus.pressed, GameingDealUtil:getImgByHandcard(CEnum.userCard.mid_mo, _card))
            elseif _seat == CEnum.seatNo.R then
            	myself_view_mo_chu_pai_bg:setVisible(false)
	            myself_view_mo_chu_pai:setVisible(false)
	            --xiajia_view_mo_chu_pai_bg:setVisible(false)
		        --xiajia_view_mo_chu_pai:setVisible(false)
		        lastjia_view_mo_chu_pai_bg:setVisible(false)
		        lastjia_view_mo_chu_pai:setVisible(false)

				xiajia_view_mo_chu_pai_bg:setVisible(true)
	            xiajia_view_mo_chu_pai_bg:setButtonImage(EnStatus.normal, Imgs.gameing_mid_mopai_bg)
	            xiajia_view_mo_chu_pai_bg:setButtonImage(EnStatus.pressed, Imgs.gameing_mid_mopai_bg)
	            xiajia_view_mo_chu_pai:setVisible(true)
	            xiajia_view_mo_chu_pai:setButtonImage(EnStatus.normal, GameingDealUtil:getImgByHandcard(CEnum.userCard.mid_mo, _card))
	            xiajia_view_mo_chu_pai:setButtonImage(EnStatus.pressed, GameingDealUtil:getImgByHandcard(CEnum.userCard.mid_mo, _card))
	        elseif _seat == CEnum.seatNo.L then
	        	myself_view_mo_chu_pai_bg:setVisible(false)
	            myself_view_mo_chu_pai:setVisible(false)
	            xiajia_view_mo_chu_pai_bg:setVisible(false)
		        xiajia_view_mo_chu_pai:setVisible(false)
		        --lastjia_view_mo_chu_pai_bg:setVisible(false)
		        --lastjia_view_mo_chu_pai:setVisible(false)

				lastjia_view_mo_chu_pai_bg:setVisible(true)
	            lastjia_view_mo_chu_pai_bg:setButtonImage(EnStatus.normal, Imgs.gameing_mid_mopai_bg)
	            lastjia_view_mo_chu_pai_bg:setButtonImage(EnStatus.pressed, Imgs.gameing_mid_mopai_bg)
	            lastjia_view_mo_chu_pai:setVisible(true)
	            lastjia_view_mo_chu_pai:setButtonImage(EnStatus.normal, GameingDealUtil:getImgByHandcard(CEnum.userCard.mid_mo, _card))
	            lastjia_view_mo_chu_pai:setButtonImage(EnStatus.pressed, GameingDealUtil:getImgByHandcard(CEnum.userCard.mid_mo, _card))
	        end

		elseif Commons:checkIsNull_str(_card) --and not isWang
			and Commons:checkIsNull_str(_type) and CEnum.options.chu == _type then
			if _seat == CEnum.seatNo.me then
				--myself_view_mo_chu_pai_bg:setVisible(false)
	            --myself_view_mo_chu_pai:setVisible(false)
	            xiajia_view_mo_chu_pai_bg:setVisible(false)
		        xiajia_view_mo_chu_pai:setVisible(false)
		        lastjia_view_mo_chu_pai_bg:setVisible(false)
		        lastjia_view_mo_chu_pai:setVisible(false)

				myself_view_mo_chu_pai_bg:setVisible(true)
	            myself_view_mo_chu_pai_bg:setButtonImage(EnStatus.normal, Imgs.gameing_mid_chupai_bg)
	            myself_view_mo_chu_pai_bg:setButtonImage(EnStatus.pressed, Imgs.gameing_mid_chupai_bg)
	            myself_view_mo_chu_pai:setVisible(true)
	            myself_view_mo_chu_pai:setButtonImage(EnStatus.normal, GameingDealUtil:getImgByHandcard(CEnum.userCard.mid_chu, _card))
	            myself_view_mo_chu_pai:setButtonImage(EnStatus.pressed, GameingDealUtil:getImgByHandcard(CEnum.userCard.mid_chu, _card))
            elseif _seat == CEnum.seatNo.R then
            	myself_view_mo_chu_pai_bg:setVisible(false)
	            myself_view_mo_chu_pai:setVisible(false)
	            --xiajia_view_mo_chu_pai_bg:setVisible(false)
		        --xiajia_view_mo_chu_pai:setVisible(false)
		        lastjia_view_mo_chu_pai_bg:setVisible(false)
		        lastjia_view_mo_chu_pai:setVisible(false)

				xiajia_view_mo_chu_pai_bg:setVisible(true)
	            xiajia_view_mo_chu_pai_bg:setButtonImage(EnStatus.normal, Imgs.gameing_mid_chupai_bg)
	            xiajia_view_mo_chu_pai_bg:setButtonImage(EnStatus.pressed, Imgs.gameing_mid_chupai_bg)
	            xiajia_view_mo_chu_pai:setVisible(true)
	            xiajia_view_mo_chu_pai:setButtonImage(EnStatus.normal, GameingDealUtil:getImgByHandcard(CEnum.userCard.mid_chu, _card))
	            xiajia_view_mo_chu_pai:setButtonImage(EnStatus.pressed, GameingDealUtil:getImgByHandcard(CEnum.userCard.mid_chu, _card))
	        elseif _seat == CEnum.seatNo.L then
	        	myself_view_mo_chu_pai_bg:setVisible(false)
	            myself_view_mo_chu_pai:setVisible(false)
	            xiajia_view_mo_chu_pai_bg:setVisible(false)
		        xiajia_view_mo_chu_pai:setVisible(false)
		        --lastjia_view_mo_chu_pai_bg:setVisible(false)
		        --lastjia_view_mo_chu_pai:setVisible(false)

				lastjia_view_mo_chu_pai_bg:setVisible(true)
	            lastjia_view_mo_chu_pai_bg:setButtonImage(EnStatus.normal, Imgs.gameing_mid_chupai_bg)
	            lastjia_view_mo_chu_pai_bg:setButtonImage(EnStatus.pressed, Imgs.gameing_mid_chupai_bg)
	            lastjia_view_mo_chu_pai:setVisible(true)
	            lastjia_view_mo_chu_pai:setButtonImage(EnStatus.normal, GameingDealUtil:getImgByHandcard(CEnum.userCard.mid_chu, _card))
	            lastjia_view_mo_chu_pai:setButtonImage(EnStatus.pressed, GameingDealUtil:getImgByHandcard(CEnum.userCard.mid_chu, _card))
	        end
	    else
	    	-- action中的类型，不认识了，也要相应清除自己位置的东西
	    	if _seat == CEnum.seatNo.me then
				myself_view_mo_chu_pai_bg:setVisible(false)
	            myself_view_mo_chu_pai:setVisible(false)
            elseif _seat == CEnum.seatNo.R then
	            xiajia_view_mo_chu_pai_bg:setVisible(false)
		        xiajia_view_mo_chu_pai:setVisible(false)
	        elseif _seat == CEnum.seatNo.L then
		        lastjia_view_mo_chu_pai_bg:setVisible(false)
		        lastjia_view_mo_chu_pai:setVisible(false)
	        end
		end

		-- action为不空，并且自摸王八
		if Commons:checkIsNull_str(_card) and isWang then
	    	-- 自摸到王八
	    	-- 动画消失到自己手牌上
	    	if _seat == CEnum.seatNo.me then
    			need_view:performWithDelay(function () 
		    		--myself_view_mo_chu_pai_bg:setVisible(false)
		            --myself_view_mo_chu_pai:setVisible(false)
		    		Commons:printLog_Info("王八移动效果：入手牌")
		    		GameingHandCardDeal:createMyselfMoWang_Anim(need_view, myself_view_mo_chu_pai_bg, myself_view_mo_chu_pai)
			    end, 0.3)
			elseif _seat == CEnum.seatNo.R then
				need_view:performWithDelay(function () 
		    		xiajia_view_mo_chu_pai_bg:setVisible(false)
		            xiajia_view_mo_chu_pai:setVisible(false)
			    end, 1.0)
			elseif _seat == CEnum.seatNo.L then
				need_view:performWithDelay(function () 
		    		lastjia_view_mo_chu_pai_bg:setVisible(false)
		            lastjia_view_mo_chu_pai:setVisible(false)
			    end, 1.0)
	    	end
	    end
	else
		-- action为空，也要相应清除自己位置的东西
		if _seat == CEnum.seatNo.me then
			myself_view_mo_chu_pai_bg:setVisible(false)
            myself_view_mo_chu_pai:setVisible(false)
        elseif _seat == CEnum.seatNo.R then
            xiajia_view_mo_chu_pai_bg:setVisible(false)
	        xiajia_view_mo_chu_pai:setVisible(false)
        elseif _seat == CEnum.seatNo.L then
	        lastjia_view_mo_chu_pai_bg:setVisible(false)
	        lastjia_view_mo_chu_pai:setVisible(false)
        end
	end -- end action

end

-- 2 显示每位玩家  已经吃、碰过的牌 列表
function GameingCurrChiCardDeal:showPlayers_ChiguoCards(_seat,v,
	myself_view_chiguo_list,xiajia_view_chiguo_list,lastjia_view_chiguo_list
)
	Commons:printLog_Info("--2 玩家 已经吃、碰过的牌 列表")

	local netStatus = v[Player.Bean.netStatus] -- 玩家是不是在线
    local netStatus_bool = CEnum.netStatus.online == netStatus;

	local need_chiguoCombs = {} -- 需要显示的集合
    local chiguoCard_allSize = 24 -- 24个 总共 最多容纳多少张出牌摆放
    local chiguoCard_lineSize = 7 -- 每行6个 4行 一行 最多容纳多少张出牌摆放
	local chiguoCombs = v[Player.Bean.chiCombs] -- 服务器给的 已经吃、碰过的牌集合

	if _seat == CEnum.seatNo.me then -- and netStatus_bool then -- 本人和最后一家的出牌集合  需要调整排序
        need_chiguoCombs = GameingDealUtil:PageView_FillList_MePengCard(chiguoCombs, chiguoCard_allSize, chiguoCard_lineSize)
    --elseif _seat == CEnum.seatNo.me and not netStatus_bool then
    --    --todo最后需要 不在线处理

    elseif _seat == CEnum.seatNo.L then -- and netStatus_bool then -- 本人和最后一家的出牌集合  需要调整排序
		need_chiguoCombs = GameingDealUtil:PageView_FillList_MePengCard(chiguoCombs, chiguoCard_allSize, chiguoCard_lineSize)
	--elseif _seat == CEnum.seatNo.L and netStatus_bool then
    --    --todo最后需要 不在线处理

    elseif _seat == CEnum.seatNo.R then -- and netStatus_bool then
		-- 下一家的排序  也是需要做调整的
		need_chiguoCombs = GameingDealUtil:PageView_FillList_LPengCard(chiguoCombs, chiguoCard_allSize, chiguoCard_lineSize)
	--elseif _seat == CEnum.seatNo.R and netStatus_bool then
    --    --todo最后需要 不在线处理

    end

    if _seat == CEnum.seatNo.me then
        	myself_view_chiguo_list:removeAllItems();
        	for k,v in pairs(need_chiguoCombs) do
        	--for i=1,24 do
        		--local v = "nb3"
				local item = myself_view_chiguo_list:newItem()
				local img_vv = GameingDealUtil:getImgByHandcard(CEnum.userCard.out, v)
				local content = cc.ui.UIPushButton.new(img_vv, {scale9 = false}):setButtonSize(42, 42)
				item:addChild(content)
				myself_view_chiguo_list:addItem(item) -- 添加item到列表
			end
			myself_view_chiguo_list:reload() -- 重新加载

    elseif _seat == CEnum.seatNo.R then
    	xiajia_view_chiguo_list:removeAllItems();
    	for k,v in pairs(need_chiguoCombs) do
    	--for i=1,24 do
    		--local v = "nb4"
			local item = xiajia_view_chiguo_list:newItem()
			local img_vv = GameingDealUtil:getImgByHandcard(CEnum.userCard.out, v)
			local content = cc.ui.UIPushButton.new(img_vv, {scale9 = false})
					:setButtonSize(42, 42)
			item:addChild(content)
			xiajia_view_chiguo_list:addItem(item) -- 添加item到列表
		end
		xiajia_view_chiguo_list:reload() -- 重新加载

    elseif _seat == CEnum.seatNo.L then
    	lastjia_view_chiguo_list:removeAllItems();
    	for k,v in pairs(need_chiguoCombs) do
    	--for i=1,24 do
    		--local v = "nb5"
			local item = lastjia_view_chiguo_list:newItem()
			local img_vv = GameingDealUtil:getImgByHandcard(CEnum.userCard.out, v)
			local content = cc.ui.UIPushButton.new(img_vv, {scale9 = false})
					:setButtonSize(42, 42)
			item:addChild(content)
			lastjia_view_chiguo_list:addItem(item) -- 添加item到列表
		end
		lastjia_view_chiguo_list:reload() -- 重新加载
    end
end

-- 3 显示每位玩家 已经打出的牌
function GameingCurrChiCardDeal:showPlayers_ChuguoCards(_seat,v,
	myself_view_chuguo_list,xiajia_view_chuguo_list,lastjia_view_chuguo_list
)
	Commons:printLog_Info("--3 显示每位玩家 已经打出的牌")

	local netStatus = v[Player.Bean.netStatus] -- 玩家是不是在线
    local netStatus_bool = CEnum.netStatus.online == netStatus;
	
	local need_chuguoCards = {} -- 需要 显示的集合
	local chuCards = v[Player.Bean.chuCards] -- 服务器给的 出牌集合

	local chuCardIndexs = v[Player.Bean.chuCardIndexs] -- 服务器给的 出牌集合  自己打出来的牌，用颜色标注
	if Commons:checkIsNull_tableList(chuCardIndexs) then
		for k,v in pairs(chuCardIndexs) do
			if chuCards ~= nil and chuCards[v+1] ~= nil then
				chuCards[v+1] = chuCards[v+1] .. "#1"
			end
        end
	end

	if _seat == CEnum.seatNo.me then -- and netStatus_bool then -- 本人和下家的出牌集合需要调整排序
    	need_chuguoCards = GameingDealUtil:PageView_FillList_MeChuCard(chuCards, 15, 5)
    --elseif _seat == CEnum.seatNo.me and not netStatus_bool then
    --    --todo最后需要 不在线处理

    elseif _seat == CEnum.seatNo.R then -- and netStatus_bool then -- 本人和下家的出牌集合需要调整排序
        need_chuguoCards = GameingDealUtil:PageView_FillList_MeChuCard(chuCards, 15, 5)
    --elseif _seat == CEnum.seatNo.R and not netStatus_bool then
    --    --todo最后需要 不在线处理

    elseif  _seat == CEnum.seatNo.L then -- and netStatus_bool then
    	-- 最后一家的出牌集合直接显示
    	if Commons:checkIsNull_tableList(chuCards) then
        	need_chuguoCards = chuCards
        end
    --elseif  _seat == CEnum.seatNo.L and not netStatus_bool then
    --    --todo最后需要 不在线处理

    end

    --print("==============================================",#need_chuguoCards)

    if _seat == CEnum.seatNo.me then -- 是本人，并且在线
    	-- add items
    	myself_view_chuguo_list:removeAllItems();
    	for kk,vv in pairs(need_chuguoCards) do
    		local isHigh = false
            if vv ~= nil then
                local isFindTxt = string.find(tostring(vv), "#1")
                if isFindTxt ~= nil and isFindTxt ~= -1 then
                    -- 找到
                    vv = string.gsub(vv, "#1", "")
                    isHigh = true
                end
            end

			local item = myself_view_chuguo_list:newItem()
			local img_vv = GameingDealUtil:getImgByHandcard(CEnum.userCard.out, vv)
			local content = cc.ui.UIPushButton.new(img_vv, {scale9 = false})
					:setButtonSize(card_w_out, card_h_out)
					-- :setButtonLabel(
					-- 	cc.ui.UILabel.new({
					-- 		--text = "点击大小改变" .. i, 
					-- 		text = "", 
					-- 		size = 16, 
					-- 		color = display.COLOR_BLUE
					-- 	})
					-- )
					--:onButtonPressed(function(event)
					--	event.target:getButtonLabel():setColor(display.COLOR_RED)
					--end)
					--:onButtonRelease(function(event)
					--	event.target:getButtonLabel():setColor(display.COLOR_BLUE)
					--end)
					--:onButtonClicked(function(event)
					--	Commons:printLog_Info("UIListView buttonclicked")
					--	local w, _ = item:getItemSize()
					--	if 60 == w then
					--		item:setItemSize(100, 73*3)
					--	else
					--		item:setItemSize(60, 73*3)
					--	end
					--end)
			if isHigh then
				-- cc.ui.UIPushButton.new(Imgs.home_tip_text_green, {scale9 = false})
    --                 :setButtonSize(8, 8)
    --                 :addTo(content)
    --                 :align(display.CENTER, card_w_out/4+4,card_h_out/4+4)
                cc.ui.UIPushButton.new(Imgs.home_tip_text_green2, {scale9 = false})
                    :setButtonSize(card_w_out, card_h_out)
                    :addTo(content)
            end
			--item:setBg("") -- 设置item背景
			item:addChild(content)
			--item:setItemSize(42, 42)
			myself_view_chuguo_list:addItem(item) -- 添加item到列表
		end
		myself_view_chuguo_list:reload() -- 重新加载

	elseif _seat == CEnum.seatNo.R then -- 下一玩家
		xiajia_view_chuguo_list:removeAllItems();
		for kk,vv in pairs(need_chuguoCards) do
			local isHigh = false
            if vv ~= nil then
                local isFindTxt = string.find(tostring(vv), "#1")
                if isFindTxt ~= nil and isFindTxt ~= -1 then
                    -- 找到
                    vv = string.gsub(vv, "#1", "")
                    isHigh = true
                end
            end

			local item = xiajia_view_chuguo_list:newItem()
			local img_vv = GameingDealUtil:getImgByHandcard(CEnum.userCard.out, vv)
			local content = cc.ui.UIPushButton.new(img_vv, {scale9 = false})
					:setButtonSize(card_w_out, card_h_out)
			if isHigh then
				cc.ui.UIPushButton.new(Imgs.home_tip_text_green2, {scale9 = false})
                    :setButtonSize(card_w_out, card_h_out)
                    :addTo(content)
            end
			item:addChild(content)
			--item:setItemSize(42, 42)
			xiajia_view_chuguo_list:addItem(item) -- 添加item到列表
		end
		xiajia_view_chuguo_list:reload() -- 重新加载

	elseif _seat == CEnum.seatNo.L then	-- 最后一玩家
		lastjia_view_chuguo_list:removeAllItems();
		for kk,vv in pairs(need_chuguoCards) do
			local isHigh = false
            if vv ~= nil then
                local isFindTxt = string.find(tostring(vv), "#1")
                if isFindTxt ~= nil and isFindTxt ~= -1 then
                    -- 找到
                    vv = string.gsub(vv, "#1", "")
                    isHigh = true
                end
            end

			local item = lastjia_view_chuguo_list:newItem()
			local img_vv = GameingDealUtil:getImgByHandcard(CEnum.userCard.out, vv)
			local content = cc.ui.UIPushButton.new(img_vv, {scale9 = false})
					:setButtonSize(card_w_out, card_h_out)
			if isHigh then
				cc.ui.UIPushButton.new(Imgs.home_tip_text_green2, {scale9 = false})
                    :setButtonSize(card_w_out, card_h_out)
                    :addTo(content)
            end
			item:addChild(content)
			--item:setItemSize(42, 42)
			lastjia_view_chuguo_list:addItem(item) -- 添加item到列表
		end
		lastjia_view_chuguo_list:reload() -- 重新加载
    end
end




--[[
-- listview不适合排列组合显示列表
function GameingCurrChiCardDeal:create(chiDemos, need_view, displayAlign, displayX, displayY)
	-- 开始出选择界面
	--local chiDemos = v[Player.Bean.chiDemos] -- 当前吃的方案
	-- 考虑多级联动 第一层
	if chiDemos~=nil and type(chiDemos)=="table" then
		if view_CurrChi_list~=nil then
			view_CurrChi_list:removeAllItems()
		else
			view_CurrChi_list = cc.ui.UIListView.new({
	            bg = Imgs.gameing_mid_chupai_bg,
	            --bgStartColor = cc.c4b(255,64,64,150),
	            --bgEndColor = cc.c4b(0,0,0,150),
	            --bgColor = cc.c4b(200, 200, 200, 150),
	            --bgColor = Colors.btn_bg,
	            bgScale9 = false,
	            --capInsets = cc.rect(20, 20, 120, 92),
	            viewRect = cc.rect(0, 0, 48*1, 48*4),
	            direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
	            --direction = cc.ui.UIScrollView.DIRECTION_HORIZONTAL,
	            --alignment = cc.ui.UIListView.ALIGNMENT_RIGHT -- 居下
	            --scrollbarImgH = Imgs.c_default_img
	            --scrollbarImgV = Imgs.c_default_img
	        })
	        --:onTouch(touchListener)
	        :addTo(need_view)
	        --:align(display.CENTER_TOP, display.cx, osHeight-170-48)
	        :align(displayAlign, displayX, displayY)
		end

		local _ss = #chiDemos -- table的个数
		if _ss == 1 then
			view_CurrChi_list:setViewRect(cc.rect(0, 0, 92, 242))
		else
			--view_CurrChi_list:setViewRect(cc.rect(0, 0, 48+8, 42*_ss+8))	
			view_CurrChi_list:setViewRect(cc.rect(0, 0, 92, 242))	
		end

		local item11 = view_CurrChi_list:newItem()
		for k_chi,v_chi in pairs(chiDemos) do
			local content = display.newNode()
			local img_vv
			if _ss == 1 then
				img_vv = GameingDealUtil:getImgByHandcard(CEnum.userCard.mid_chu, v_chi)
				cc.ui.UIPushButton.new(img_vv, {scale9 = false})
					:setButtonSize(76, 226)
					:addTo(content)
					:align(display.CENTER, 0, -121)
				--item11:setItemSize(76, 226)
				item11:addContent(content)
			else
				img_vv = GameingDealUtil:getImgByHandcard(CEnum.userCard.out, v_chi)
				Commons:printLog_Info(img_vv)
				local tt = cc.ui.UIPushButton.new(img_vv, {scale9 = false})
					:setButtonSize(42, 42)
					:addTo(content)
				if k_chi == 1 then
					tt:align(display.CENTER, (46*0), (-121+(-42*k_chi)) )
				else
					tt:align(display.CENTER, (46*1), (-121+(-42*k_chi)) )
				end
				--item11:setItemSize(42, 42)
				item11:addContent(content)
			end
		end
		view_CurrChi_list:addItem(item11)
		view_CurrChi_list:reload()
		-- 最后界面显示
		--view_CurrChi_list:onTouch(GameingScene_touchListener)
		--view_CurrChi_list:setVisible(true)
	end
end
--]]


function GameingCurrChiCardDeal:ctor()
end


function GameingCurrChiCardDeal:onEnter()
end


function GameingCurrChiCardDeal:onExit()
    --self:removeAllChildren()
    -- chu_tipimg = nil
    if view_CurrChi_node and not tolua.isnull(view_CurrChi_node) then
		view_CurrChi_node:removeFromParent()
		view_CurrChi_node = nil
	end
end

return GameingCurrChiCardDeal