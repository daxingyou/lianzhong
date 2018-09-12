--
-- Author: lte
-- Date: 2016-11-02 19:32:19
-- 游戏中 本人吃碰胡过牌的具体处理

-- 类申明
-- local GameingMeChiCardDeal = class("GameingMeChiCardDeal", function ()
--     return display.newNode();
-- end)
local GameingMeChiCardDeal = class("GameingMeChiCardDeal")


local osWidth = Commons.osWidth;
local osHeight = Commons.osHeight;

local myself_view_needChi_list = nil
local needBi_list = nil
local needBi_list_second = nil

local myself_view_needOption_list = nil
-- local roomNo = nil
local actionNo = nil

local meChiList_x = 450+70 -30 -- x起点  越大就靠右
local meChiList_y = 280+40  -- y起点  越大就越低

local meChi_item_w = 52  -- 牌的宽高
local meChi_item_h = 52

local meChi_item_w_mul = 2.0 -- 倍数
local meChi_item_h_mul = 3.4  -- 高扩大的倍数

local meChi_item_w_jia = 0.3  -- 宽扩大的倍数

local meChi_item_w_mul_bg = 1.0 -- 倍数
local meChi_item_h_mul_bg = 1.125 -- 倍数

local offset_x = -23 -8
local offset_y = -7.5

local gap_xiahuo = 20 -- 吃，下火，再次下火的间距

--[[
	@param: chiDemos 吃牌的组合方式集合
	@param: myself_view 当前父类组件
	@param: _myself_view_needOption_list 吃牌，下火牌的第一个组件
	@param: roomNo 房间编号
	@param: actionNo 动作编号
--]]
function GameingMeChiCardDeal:createChiCards(chiDemos, myself_view, _myself_view_needOption_list, _actionNo)

	if CVar._static.isIphone4 then
		meChiList_x = 450+70 -140  -- x起点  越大就靠右
	elseif CVar._static.isIpad then
		meChiList_x = 450+70 -140  -- x起点  越大就靠右
	end

	--[[
	-- 计算起始位置
	local _nums_bi_0 = 0
	local _nums_bi_1 = 0
	local _nums_bi_2 = 0
	if chiDemos~=nil and type(chiDemos)=="table" then
		_nums_bi_0 = #chiDemos
		for k,v in pairs(chiDemos) do
			local temp_biDemos_table = v[Player.Bean.biDemos]
			if temp_biDemos_table~=nil and type(temp_biDemos_table)=="table" then
				_nums_bi_1 = _nums_bi_1 + #temp_biDemos_table
				for kk,vv in pairs(temp_biDemos_table) do
					local temp_biDemos_table2 = vv[Player.Bean.nextBiCombs]
					if temp_biDemos_table2~=nil and type(temp_biDemos_table2)=="table" then
						_nums_bi_2 = _nums_bi_2 + #temp_biDemos_table2
					end
				end
			end
		end
	end
	if _nums_bi_0 > 0 then
		meChiList_x = 490  -- x起点  越大就靠右
		if _nums_bi_1 >0 then
			meChiList_x = 490 -_nums_bi_1*20  -- x起点  越大就靠右
			if _nums_bi_2>0 then
				meChiList_x = 490 -(_nums_bi_1+_nums_bi_2)*20  -- x起点  越大就靠右
			end
		end
	end
	--]]

	myself_view_needOption_list = _myself_view_needOption_list
	actionNo = _actionNo

	-- 开始出选择界面
	--local chiDemos = v[Player.Bean.chiDemos] -- 当前吃的方案
	-- 考虑多级联动 第一层
	if chiDemos~=nil and type(chiDemos)=="table" then
		local _ss = #chiDemos
		_ss = _ss+meChi_item_w_jia
		--print("----------------具体多少列：", _ss)

		-- function GameingMeChiCardDeal_touchListener(event)
		-- 	local listView = event.listView
		-- 	dump(event, "UIListView - event:")
		-- 	--Commons:printfLog_Info("touchListener: name=%s x,y: %0.2f, %0.2f", event.name, event.x, event.y)
		-- 	if "clicked" == event.name then
		-- 		event.item:setBg(Imgs.gameing_dcard_select_bg)
		-- 	end
		-- end

		if myself_view_needChi_list~=nil then
			myself_view_needChi_list:removeAllItems()
			--myself_view_needChi_list:onTouch(GameingMeChiCardDeal_touchListener)
			myself_view_needChi_list:removeFromParent()
			myself_view_needChi_list = nil
		end
		--else
			myself_view_needChi_list = cc.ui.UIListView.new({
	            bg = Imgs.gameing_dcard_select_pallet,
	            --bgStartColor = cc.c4b(255,64,64,150),
	            --bgEndColor = cc.c4b(0,0,0,150),
	            --bgColor = cc.c4b(200, 200, 200, 150),
	            --bgColor = Colors.btn_bg,
	            bgScale9 = true,
	            capInsets = cc.rect(15, 15, 29, 130),
	            viewRect = cc.rect(0, 0, meChi_item_w*meChi_item_w_mul*_ss*meChi_item_w_mul_bg, meChi_item_h*meChi_item_h_mul*meChi_item_h_mul_bg),
	            --direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
	            direction = cc.ui.UIScrollView.DIRECTION_HORIZONTAL,
	            alignment = cc.ui.UIListView.ALIGNMENT_RIGHT -- 居下
	            --scrollbarImgH = Imgs.c_default_img
	            --scrollbarImgV = Imgs.c_default_img
	        })
	        --:onTouch(GameingMeChiCardDeal_touchListener)
	        :addTo(myself_view)
	        :align(display.LEFT_TOP, meChiList_x, osHeight-meChiList_y)
	        :setVisible(false)
		--end

		-- 这个设置尽然没有生效
		--myself_view_needChi_list:setViewRect(cc.rect(0, 0, meChi_item_w*meChi_item_w_mul*_ss, meChi_item_h*meChi_item_h_mul) )

		for k_chi,v_chi in pairs(chiDemos) do
			local item11 = myself_view_needChi_list:newItem()

			-- 第二层 也是一个listview
			local myself_view_needChi_list22 = cc.ui.UIListView.new({
					--bg = Imgs.gameing_dcard_select_bg,
					--bgStartColor = cc.c4b(255,64,64,150),
					--bgEndColor = cc.c4b(0,0,0,150),
					--bgColor = cc.c4b(200, 200, 200, 150),
					--bgColor = Colors.btn_bg,
					bgScale9 = true,
					--capInsets = cc.rect(20, 20, 106, 22),
					viewRect = cc.rect(offset_x, offset_y, meChi_item_w*meChi_item_w_mul, meChi_item_h*meChi_item_h_mul),
					direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
					--direction = cc.ui.UIScrollView.DIRECTION_HORIZONTAL,
					--alignment = cc.ui.UIListView.ALIGNMENT_TOP -- 默认居中
					--scrollbarImgH = Imgs.c_default_img
					--scrollbarImgV = Imgs.c_default_img
				})
			local content_table = v_chi[Player.Bean.chiComb]
			if content_table~=nil and type(content_table)=="table" then
				local chiComb = ""
				for k_con, v_con in pairs(content_table) do
					--Commons:printLog_Info(k_con, v_con)
					if k_con == 1 then
						chiComb = chiComb .. v_con
					else
						chiComb = chiComb .. "|" .. v_con
					end

					local item22 =  myself_view_needChi_list22:newItem()
					local img_vv = GameingDealUtil:getImgByHandcard(CEnum.userCard.out, v_con)
					local item22_content = cc.ui.UIPushButton.new(img_vv, {scale9 = false})
						:setButtonSize(meChi_item_w, meChi_item_h)
						:onButtonClicked(function(event)
							-- if myself_view_needChi_list ~= nil then
							-- 	local _size = myself_view_needChi_list:getitem
							-- 	for i=1,_size do
							-- 		myself_view_needChi_list:getItemPos(i):setBg(Imgs.c_transparent)
							-- 	end
							-- end
							-- item11:setBg(Imgs.gameing_dcard_select_bg)

							Commons:printLog_Info("child itemClicked 第几列：",k_chi)
							--dump(item22, "有什么属性：")
							--Commons:printLog_Info("pos:", item22:getMargin())
							--for k,v in pairs(item22:getMargin()) do
							--	Commons:printLog_Info("pos:",k,v)
							--end
							--local w, _ = item22:getItemSize()
							--Commons:printLog_Info("宽",w)
							--item22:setItemSize(60, 73)
							--item22:setBg(Imgs.gameing_dcard_select_bg)

							-- 吃的一组牌是
							--for k_endchi,v_endchi in pairs(content_table) do
							--	Commons:printLog_Info("最后选择吃的牌是：",k_endchi,v_endchi)
							--end
							local biDemos_table = v_chi[Player.Bean.biDemos]
							--local biDemos_table = chiDemos[k_chi][Player.Bean.biDemos]
							Commons:printLog_Info("下火的牌有：",biDemos_table)
							if biDemos_table~=nil then
								Commons:printLog_Info("下火的牌个数有：",#biDemos_table)
								if #biDemos_table > 0 then
									-- 第2级 再次 弹窗显示 需要下火牌的选择
									GameingMeChiCardDeal:createXiahuoCards(biDemos_table, myself_view, meChi_item_w*meChi_item_w_mul*_ss+gap_xiahuo, chiComb)
								else
									--没有第2级下火方案，或者就一组吃牌，应该直接告知服务器吃牌方案是
									SocketRequestGameing:gameing_Chi(actionNo, chiComb, nil, nil)
									GameingMeChiCardDeal:createXiahuoCards(nil, myself_view, meChi_item_w*meChi_item_w_mul*_ss+gap_xiahuo) -- 消失可能有的下火牌
									-- 最后的清空内存，隐藏不需要显示的组件
									GameingMeChiCardDeal:myExit_clearView()
									myself_view_needOption_list:setVisible(false)

									-- 正式环境下火 等待服务器给数据过来，自然就有了吃或者下火动画

									-- 测试环境，模拟服务器发送吃牌信息，给客户端做效果
									if CEnum.Environment.Current == CEnum.EnvirType.Test then
										local resData = SocketResponseDataTest.new():res_gameing_Chi_myself();
										CVar._static.mSocket:tcpReceiveData(resData);
									end
								end
							else
								--没有第2级下火方案，或者就一组吃牌，应该直接告知服务器吃牌方案是
									SocketRequestGameing:gameing_Chi(actionNo, chiComb, nil, nil)
									GameingMeChiCardDeal:createXiahuoCards(nil, myself_view, meChi_item_w*meChi_item_w_mul*_ss+gap_xiahuo) -- 消失可能有的下火牌
									-- 最后的清空内存，隐藏不需要显示的组件
									GameingMeChiCardDeal:myExit_clearView()
									myself_view_needOption_list:setVisible(false)

									-- 正式环境下火 等待服务器给数据过来，自然就有了吃或者下火动画

									-- 测试环境，模拟服务器发送吃牌信息，给客户端做效果
									if CEnum.Environment.Current == CEnum.EnvirType.Test then
										local resData = SocketResponseDataTest.new():res_gameing_Chi_myself();
										CVar._static.mSocket:tcpReceiveData(resData);
									end
							end
						end)
					
					item22:setItemSize(meChi_item_w, meChi_item_h)
					item22:addContent(item22_content)
					myself_view_needChi_list22:addItem(item22)
				end
				--myself_view_needChi_list22:onTouch(GameingScene_touchListener)
				myself_view_needChi_list22:reload()
			end

			item11:setItemSize(meChi_item_w*meChi_item_w_mul, meChi_item_h*meChi_item_h_mul)
			item11:addContent(myself_view_needChi_list22)
			myself_view_needChi_list:addItem(item11)
		end
		myself_view_needChi_list:reload()
		-- 最后界面显示
		--myself_view_needChi_list:onTouch(GameingScene_touchListener)
		myself_view_needChi_list:setVisible(true)

	else
		GameingMeChiCardDeal:myExit_clearView()
	end
end

function GameingMeChiCardDeal:myExit_clearView()
	if myself_view_needChi_list~=nil and (not tolua.isnull(myself_view_needChi_list)) then
		myself_view_needChi_list:removeAllItems()
		--myself_view_needChi_list:setVisible(false)
		myself_view_needChi_list:removeFromParent()
		myself_view_needChi_list = nil
	end
	if needBi_list~=nil and (not tolua.isnull(needBi_list)) then
		needBi_list:removeAllItems()
		--needBi_list:setVisible(false)
		needBi_list:removeFromParent()
		needBi_list = nil
	end
	if needBi_list_second~=nil and (not tolua.isnull(needBi_list_second)) then
		needBi_list_second:removeAllItems()
		--needBi_list_second:setVisible(false)
		needBi_list_second:removeFromParent()
		needBi_list_second = nil
	end
end

-- 二级弹窗显示 需要下火牌的选择
--[[
	@param： biDemos 下火的table
	@param： myself_view 父类组件
	@param： biX 相对父类组件x轴坐标移动距离
	@param： chiComb 吃牌的选择值
--]]
function GameingMeChiCardDeal:createXiahuoCards(biDemos, myself_view, biX, chiComb)

	-- 没有下火牌，需要清空后面的布局界面出现
	if biDemos == nil then
		Commons:printLog_Info("确定没有下火")
		if needBi_list~=nil and (not tolua.isnull(needBi_list)) then
			Commons:printLog_Info("确定没有对象还有保留吗")
			needBi_list:removeAllItems()
			--needBi_list:setVisible(false)
			needBi_list:removeFromParent()
			needBi_list = nil
		end

		if needBi_list_second~=nil and (not tolua.isnull(needBi_list_second)) then
			Commons:printLog_Info("确定没有对象还有保留吗")
			needBi_list_second:removeAllItems()
			--needBi_list_second:setVisible(false)
			needBi_list_second:removeFromParent()
			needBi_list_second = nil
		end
		return;
	end
	-- 有下火牌，清空紧随后面
	if needBi_list_second~=nil and (not tolua.isnull(needBi_list_second)) then
		Commons:printLog_Info("确定没有对象还有保留吗")
		needBi_list_second:removeAllItems()
		--needBi_list_second:setVisible(false)
		needBi_list_second:removeFromParent()
		needBi_list_second = nil
	end

	-- 开始出选择界面
	-- 当前下火的方案
	-- 考虑多级联动 第一层
	if biDemos~=nil and type(biDemos)=="table" then
		local _ss = #biDemos
		_ss = _ss+meChi_item_w_jia

		if needBi_list~=nil and (not tolua.isnull(needBi_list)) then
			needBi_list:removeAllItems()
			--needBi_list:setVisible(false)
			needBi_list:removeFromParent()
			needBi_list = nil
		end
		--else
			needBi_list = cc.ui.UIListView.new({
	            bg = Imgs.gameing_dcard_select_pallet,
	            --bgStartColor = cc.c4b(255,64,64,150),
	            --bgEndColor = cc.c4b(0,0,0,150),
	            --bgColor = cc.c4b(200, 200, 200, 150),
	            --bgColor = Colors.btn_bg,
	            bgScale9 = true,
	            capInsets = cc.rect(15, 15, 29, 130),
	            viewRect = cc.rect(0, 0, meChi_item_w*meChi_item_w_mul*_ss*meChi_item_w_mul_bg, meChi_item_h*meChi_item_h_mul*meChi_item_h_mul_bg),
	            --direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
	            direction = cc.ui.UIScrollView.DIRECTION_HORIZONTAL,
	            alignment = cc.ui.UIListView.ALIGNMENT_RIGHT -- 居下
	            --scrollbarImgH = Imgs.c_default_img
	            --scrollbarImgV = Imgs.c_default_img
	        })
	        --:onTouch(touchListener)
	        :addTo(myself_view)
	        :align(display.LEFT_TOP, meChiList_x + biX, osHeight-meChiList_y)
	        --:setVisible(false)
		--end

		-- 这个设置尽然没有生效
		--needBi_list:setViewRect(cc.rect(0, 0, meChi_item_w*meChi_item_w_mul*_ss, meChi_item_h*meChi_item_h_mul) )

		for k_chi,v_chi in pairs(biDemos) do
			local item11 = needBi_list:newItem()

			-- 第二层 也是一个listview
			local needBi_list22 = cc.ui.UIListView.new({
					--bg = Imgs.gameing_dcard_select_bg,
					--bgStartColor = cc.c4b(255,64,64,150),
					--bgEndColor = cc.c4b(0,0,0,150),
					--bgColor = cc.c4b(200, 200, 200, 150),
					--bgColor = Colors.btn_bg,
					bgScale9 = true,
					--capInsets = cc.rect(20, 20, 106, 22),
					viewRect = cc.rect(offset_x, offset_y, meChi_item_w*meChi_item_w_mul, meChi_item_h*meChi_item_h_mul),
					direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
					--direction = cc.ui.UIScrollView.DIRECTION_HORIZONTAL,
					--alignment = cc.ui.UIListView.ALIGNMENT_TOP -- 默认居中
					--scrollbarImgH = Imgs.c_default_img
					--scrollbarImgV = Imgs.c_default_img
				})
			local content_table = v_chi[Player.Bean.biComb]
			if content_table~=nil and type(content_table)=="table" then
				local biComb1 = ""
				for k_con,v_con in pairs(content_table) do
					--Commons:printLog_Info(k_con,v_con)
					if k_con == 1 then
						biComb1 = biComb1 .. v_con
					else
						biComb1 = biComb1 .. "|" .. v_con
					end

					local item22 =  needBi_list22:newItem()
					local img_vv = GameingDealUtil:getImgByHandcard(CEnum.userCard.out, v_con)
					local item22_content = cc.ui.UIPushButton.new(img_vv, {scale9 = false})
						:setButtonSize(meChi_item_w, meChi_item_h)
						:onButtonClicked(function(event)
							Commons:printLog_Info("child itemClicked 第几列：",k_chi)
							--dump(item22, "有什么属性：")
							--Commons:printLog_Info("pos:", item22:getMargin())
							--for k,v in pairs(item22:getMargin()) do
							--	Commons:printLog_Info("pos:",k,v)
							--end
							--local w, _ = item22:getItemSize()
							--Commons:printLog_Info("宽",w)
							--item22:setItemSize(60, 73)
							--item22:setBg(Imgs.gameing_dcard_select_bg)

							-- 吃的一组牌是
							--for k_endchi,v_endchi in pairs(content_table) do
							--	Commons:printLog_Info("最后选择下火的牌是：",k_endchi,v_endchi)
							--end
							local biDemos_table = v_chi[Player.Bean.nextBiCombs]
							--local biDemos_table = biDemos[k_chi][Player.Bean.biDemos]
							Commons:printLog_Info("再次 下火的牌有：",biDemos_table)
							if biDemos_table~=nil then
								Commons:printLog_Info("再次 下火的牌个数有：",#biDemos_table)
								if #biDemos_table > 0 then
									-- 第3级 再再次 弹窗显示 需要下火牌的选择
									GameingMeChiCardDeal:createXiahuoCards_second(biDemos_table, myself_view, biX + meChi_item_w*meChi_item_w_mul*_ss+gap_xiahuo, chiComb, biComb1)
								else
									--没有第3级下火方案，应该直接告知服务器吃牌方案是
									SocketRequestGameing:gameing_Chi(actionNo, chiComb, biComb1, nil)
									GameingMeChiCardDeal:createXiahuoCards_second(nil, myself_view, biX + meChi_item_w*meChi_item_w_mul*_ss+gap_xiahuo) -- 消失后面的组件显示
									-- 最后的清空内存，隐藏不需要显示的组件
									GameingMeChiCardDeal:myExit_clearView()
									myself_view_needOption_list:setVisible(false)
									-- 正式环境下火 等待服务器给数据过来，自然就有了吃或者下火动画
									-- 测试环境，模拟服务器发送胡牌信息
									if CEnum.Environment.Current == CEnum.EnvirType.Test then
										local resData = SocketResponseDataTest.new():res_gameing_Chi_myself_andXiahuo();
    					 				CVar._static.mSocket:tcpReceiveData(resData);
									end
								end
							else
								--没有第3级下火方案，应该直接告知服务器吃牌方案是
									SocketRequestGameing:gameing_Chi(actionNo, chiComb, biComb1, nil)
									GameingMeChiCardDeal:createXiahuoCards_second(nil, myself_view, biX + meChi_item_w*meChi_item_w_mul*_ss+gap_xiahuo) -- 消失后面的组件显示
									-- 最后的清空内存，隐藏不需要显示的组件
									GameingMeChiCardDeal:myExit_clearView()
									myself_view_needOption_list:setVisible(false)
									-- 正式环境下火 等待服务器给数据过来，自然就有了吃或者下火动画
									-- 测试环境，模拟服务器发送胡牌信息
									if CEnum.Environment.Current == CEnum.EnvirType.Test then
										local resData = SocketResponseDataTest.new():res_gameing_Chi_myself_andXiahuo();
                                        CVar._static.mSocket:tcpReceiveData(resData);
									end
							end
						end)
					
					item22:setItemSize(meChi_item_w, meChi_item_h)
					item22:addContent(item22_content)
					needBi_list22:addItem(item22)
				end
				--needBi_list22:onTouch(GameingScene_touchListener)
				needBi_list22:reload()
			end

			item11:setItemSize(meChi_item_w*meChi_item_w_mul, meChi_item_h*meChi_item_h_mul)
			item11:addContent(needBi_list22)
			needBi_list:addItem(item11)
		end
		needBi_list:reload()
		needBi_list:setVisible(true)
	end
end

-- 三级弹窗显示 需要第2次下火牌的选择
--[[
	@param： biDemos 下火的table
	@param： myself_view 父类组件
	@param： biX 相对父类组件x轴坐标移动距离
	@param： chiComb 吃牌的选择值
	@param： biComb1 第一次下火牌的选择值
--]]
function GameingMeChiCardDeal:createXiahuoCards_second(biDemos, myself_view, biX, chiComb, biComb1)

	-- 没有下火牌，需要清空后面的布局界面出现
	if biDemos == nil then
		Commons:printLog_Info("确定没有下火")
		if needBi_list_second~=nil and (not tolua.isnull(needBi_list_second)) then
			Commons:printLog_Info("确定没有对象还有保留吗")
			needBi_list_second:removeAllItems()
			--needBi_list_second:setVisible(false)
			needBi_list_second:removeFromParent()
			needBi_list_second = nil
		end
		return;
	end

	-- 开始出选择界面
	-- 当前下火的方案
	-- 考虑多级联动 第一层
	if biDemos~=nil and type(biDemos)=="table" then
		local _ss = #biDemos
		_ss = _ss+meChi_item_w_jia

		if needBi_list_second~=nil and (not tolua.isnull(needBi_list_second)) then
			needBi_list_second:removeAllItems()
			--needBi_list_second:setVisible(false)
			needBi_list_second:removeFromParent()
			needBi_list_second = nil
		end
		--else
			needBi_list_second = cc.ui.UIListView.new({
	            bg = Imgs.gameing_dcard_select_pallet,
	            --bgStartColor = cc.c4b(255,64,64,150),
	            --bgEndColor = cc.c4b(0,0,0,150),
	            --bgColor = cc.c4b(200, 200, 200, 150),
	            --bgColor = Colors.btn_bg,
	            bgScale9 = true,
	            capInsets = cc.rect(15, 15, 29, 130),
	            viewRect = cc.rect(0, 0, meChi_item_w*meChi_item_w_mul*_ss*meChi_item_w_mul_bg, meChi_item_h*meChi_item_h_mul*meChi_item_h_mul_bg),
	            --direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
	            direction = cc.ui.UIScrollView.DIRECTION_HORIZONTAL,
	            alignment = cc.ui.UIListView.ALIGNMENT_RIGHT -- 居下
	            --scrollbarImgH = Imgs.c_default_img
	            --scrollbarImgV = Imgs.c_default_img
	        })
	        --:onTouch(touchListener)
	        :addTo(myself_view)
	        :align(display.LEFT_TOP, meChiList_x + biX, osHeight-meChiList_y)
	        --:setVisible(false)
		--end

		-- 这个设置尽然没有生效
		--needBi_list_second:setViewRect(cc.rect(0, 0, meChi_item_w*meChi_item_w_mul*_ss, meChi_item_h*meChi_item_h_mul) )

		for k_chi,v_chi in pairs(biDemos) do
			local item11 = needBi_list_second:newItem()

			-- 第二层 也是一个listview
			local needBi_list_second22 = cc.ui.UIListView.new({
					--bg = Imgs.gameing_dcard_select_bg,
					--bgStartColor = cc.c4b(255,64,64,150),
					--bgEndColor = cc.c4b(0,0,0,150),
					--bgColor = cc.c4b(200, 200, 200, 150),
					--bgColor = Colors.btn_bg,
					bgScale9 = true,
					--capInsets = cc.rect(20, 20, 106, 22),
					viewRect = cc.rect(offset_x, offset_y, meChi_item_w*meChi_item_w_mul, meChi_item_h*meChi_item_h_mul),
					direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
					--direction = cc.ui.UIScrollView.DIRECTION_HORIZONTAL,
					--alignment = cc.ui.UIListView.ALIGNMENT_TOP -- 默认居中
					--scrollbarImgH = Imgs.c_default_img
					--scrollbarImgV = Imgs.c_default_img
				})
			local content_table = v_chi--[Player.Bean.biComb]
			if content_table~=nil and type(content_table)=="table" then
				local biComb2 = ""
				for k_con,v_con in pairs(content_table) do
					--Commons:printLog_Info(k_con,v_con)
					if k_con == 1 then
						biComb2 = biComb2 .. v_con
					else
						biComb2 = biComb2 .. "|" .. v_con
					end

					local item22 =  needBi_list_second22:newItem()
					local img_vv = GameingDealUtil:getImgByHandcard(CEnum.userCard.out, v_con)
					local item22_content = cc.ui.UIPushButton.new(img_vv, {scale9 = false})
						:setButtonSize(meChi_item_w, meChi_item_h)
						:onButtonClicked(function(event)
							Commons:printLog_Info("child itemClicked 第几列：",k_chi)
							--dump(item22, "有什么属性：")
							--Commons:printLog_Info("pos:", item22:getMargin())
							--for k,v in pairs(item22:getMargin()) do
							--	Commons:printLog_Info("pos:",k,v)
							--end
							--local w, _ = item22:getItemSize()
							--Commons:printLog_Info("宽",w)
							--item22:setItemSize(60, 73)
							--item22:setBg(Imgs.gameing_dcard_select_bg)

							-- 吃的一组牌是
							--for k_endchi,v_endchi in pairs(content_table) do
							--	Commons:printLog_Info("最后选择下火的牌是：",k_endchi,v_endchi)
							--end
							local biDemos_table = v_chi[Player.Bean.nextBiCombs]
							--local biDemos_table = biDemos[k_chi][Player.Bean.biDemos]
							Commons:printLog_Info("第二次 下火的牌有：",biDemos_table)
							if biDemos_table~=nil then
								Commons:printLog_Info("第二次 下火的牌个数有：",#biDemos_table)
								if #biDemos_table > 0 then
									-- 最后一次弹窗显示，第二次下火牌
									SocketRequestGameing:gameing_Chi(actionNo, chiComb, biComb1, biComb2)
									-- 最后的清空内存，隐藏不需要显示的组件
									GameingMeChiCardDeal:myExit_clearView()
									myself_view_needOption_list:setVisible(false)
									-- 正式环境下火 等待服务器给数据过来，自然就有了吃或者下火动画
									-- 测试环境，模拟服务器发送胡牌信息
									if CEnum.Environment.Current == CEnum.EnvirType.Test then
										local resData = SocketResponseDataTest.new():res_gameing_Chi_myself_andXiahuo();
                                        CVar._static.mSocket:tcpReceiveData(resData);
									end
								else
									-- 最后一次弹窗显示，第二次下火牌
									SocketRequestGameing:gameing_Chi(actionNo, chiComb, biComb1, biComb2)
									-- 最后的清空内存，隐藏不需要显示的组件
									GameingMeChiCardDeal:myExit_clearView()
									myself_view_needOption_list:setVisible(false)
									-- 正式环境下火 等待服务器给数据过来，自然就有了吃或者下火动画
									-- 测试环境，模拟服务器发送胡牌信息
									if CEnum.Environment.Current == CEnum.EnvirType.Test then
										local resData = SocketResponseDataTest.new():res_gameing_Chi_myself_andXiahuo();
                                        CVar._static.mSocket:tcpReceiveData(resData);
									end
								end
							else
								-- 最后一次弹窗显示，第二次下火牌
									SocketRequestGameing:gameing_Chi(actionNo, chiComb, biComb1, biComb2)
									-- 最后的清空内存，隐藏不需要显示的组件
									GameingMeChiCardDeal:myExit_clearView()
									myself_view_needOption_list:setVisible(false)
									-- 正式环境下火 等待服务器给数据过来，自然就有了吃或者下火动画
									-- 测试环境，模拟服务器发送胡牌信息
									if CEnum.Environment.Current == CEnum.EnvirType.Test then
										local resData = SocketResponseDataTest.new():res_gameing_Chi_myself_andXiahuo();
                                        CVar._static.mSocket:tcpReceiveData(resData);
									end
							end
						end)
					
					item22:setItemSize(meChi_item_w, meChi_item_h)
					item22:addContent(item22_content)
					needBi_list_second22:addItem(item22)
				end
				--needBi_list_second22:onTouch(GameingScene_touchListener)
				needBi_list_second22:reload()
			end

			item11:setItemSize(meChi_item_w*meChi_item_w_mul, meChi_item_h*meChi_item_h_mul)
			item11:addContent(needBi_list_second22)
			needBi_list_second:addItem(item11)
		end
		needBi_list_second:reload()
		needBi_list_second:setVisible(true)
	end
end


-- 构造函数
function GameingMeChiCardDeal:ctor()
end


function GameingMeChiCardDeal:onEnter()
end


function GameingMeChiCardDeal:onExit()
    --Commons:printLog_Info("GameingMeChiCardDeal:onExit")
    --self:removeAllChildren();

    myself_view_needChi_list = nil
	needBi_list = nil
	needBi_list_second = nil

	myself_view_needOption_list = nil
	actionNo = nil
end

-- 必须有这个返回
return GameingMeChiCardDeal
