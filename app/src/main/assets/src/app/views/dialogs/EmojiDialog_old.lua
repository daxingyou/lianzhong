--
-- Author: lte
-- Date: 2016-11-05 18:41:34
-- 房间战绩


-- 类申明
local EmojiDialog = class("EmojiDialog"
    -- ,function()
    --     return display.newNode()
    -- end
    )


local osWidth = Commons.osWidth
local osHeight = Commons.osHeight

function EmojiDialog:ctor()
end


-- 创建一个模态弹出框,  parent=要加在哪个上面
function EmojiDialog:popDialogBox(_parent, _formView)

    self.parent = _parent
    self.formView = _formView

    self.pop_window = display.newColorLayer(cc.c4b(0, 0, 0, 10))       -- 半透明的黑色

    self.pop_window:setContentSize(osWidth, osHeight)             -- 设置Layer的大小,全屏出现
    --self.pop_window:align(display.CENTER, display.cx, display.cy) -- Layer的锚点在0.5,0.5 因此对齐的时候要注意
    self.pop_window:setTouchEnabled(true)
    self.pop_window:setTouchSwallowEnabled(true)  -- 吞噬下层的响应
    self.pop_window:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event) -- 点击此Layer时候输出信息,然后把自己销毁

	    self:myExit()
        return true
    end)
    self.parent:addChild(self.pop_window, CEnum.ZOrder.common_dialog) -- 把Layer添加到父对象上

    --[[
    -- 整个底色背景
    cc.ui.UIImage.new(Imgs.dialog_bg,{})
        :addTo(self.pop_window)
    	:align(display.LEFT_TOP, 20, osHeight-18)
    	:setLayoutSize(osWidth-20*2, osHeight-18*2)
    --]]

    --[[
    -- 内容背景
    cc.ui.UIImage.new(Imgs.dialog_content_bg,{})
        :addTo(self.pop_window)
        :align(display.LEFT_TOP, 20+10, osHeight-18 -88)
        :setLayoutSize(osWidth-20*2 -10*2, osHeight-18*2 -88-10)
    --]]

    --[[
    -- logo
    cc.ui.UIImage.new(Imgs.result_title_logo,{})
    --cc.ui.UIPushButton.new(Imgs.result_title_logo, {scale9 = false})
    --    :setButtonImage(EnStatus.pressed, Imgs.result_title_logo)
    --    :setButtonImage(EnStatus.disabled, Imgs.result_title_logo)
    	:addTo(self.pop_window)
    	:align(display.CENTER, display.cx, osHeight-18 -88/2)
    --]]

    --[[
    -- 关闭 
    cc.ui.UIPushButton.new(Imgs.dialog_back,{scale9=false})
        :setButtonSize(74, 74)
        -- :setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
        --     UILabelType = 2,
        --     text = "",--Strings.common_exit,
        --     size = Dimens.TextSize_30,
        --     color = Colors.btn_normal,
        --     }))
        -- :setButtonLabel(EnStatus.pressed, cc.ui.UILabel.new({
        --     UILabelType = 2,
        --     text = "",--Strings.common_exit,
        --     size = Dimens.TextSize_30,
        --     color = Colors.btn_press,
        --     }))
        :setButtonImage(EnStatus.pressed, Imgs.dialog_back)
        :onButtonClicked(function(e)
           self:myExit()
        end)
    	:addTo(self.pop_window)
        :align(display.CENTER, 20 +13 +74/2, osHeight-18 -12 -74/2)
    --]]

    --[[
    -- 确定按钮
    cc.ui.UIPushButton.new(
        Imgs.over_round_btn_next,{scale9=false})
        :setButtonSize(278, 94)
        -- :setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
        --     UILabelType = 2,
        --     text = "",
        --     size = Dimens.TextSize_30,
        --     color = Colors.btn_normal,
        --     }))
        -- :setButtonLabel(EnStatus.pressed, cc.ui.UILabel.new({
        --     UILabelType = 2,
        --     text = "",
        --     size = Dimens.TextSize_30,
        --     color = Colors.btn_press,
        --     }))
        :setButtonImage(EnStatus.pressed, Imgs.over_round_btn_next_press)
        --:onButtonClicked(function(e)
        --    self:myExit()
        --end)
        :align(display.CENTER_BOTTOM, display.cx, 14+3)
        :addTo(self.pop_window)
    --]]

    --[[
    cc.ui.UILabel.new({
            UILabelType = 2, 
            --image = "",
            text = "注意：房卡在游戏开始后扣除，游戏开始前解散不扣除房卡", 
            size = Dimens.TextSize_20,
            --color = Colors.black,
            color = Colors:_16ToRGB(Colors.gameing_huxi),
            font = Fonts.Font_hkyt_w9,
            align = cc.ui.TEXT_ALIGN_LEFT,
            valign = cc.ui.TEXT_VALIGN_CENTER,
            --dimensions = cc.size((osWidth-120),0) -- height为0，就是自动换行
            --dimensions = cc.size(200,50)
        })
        :align(display.LEFT_TOP, 20+13+25, 18+12+27)
        :addTo(self.pop_window)
    --]]


	-- view
    self:createView2()
	self:setViewData2()
end

local item_w = 80
local item_h = 70 -- 空出70像素的title部分

-- 表情图片显示
function EmojiDialog:getImgByBiaoqing_new(optTxt)
    if optTxt ~= nil and optTxt ~= CEnum.status.def_fill then
      return Imgs.biaoqing_exp_new .. optTxt .. Imgs.file_imgPlist_suff, Imgs.biaoqing_exp_new .. optTxt .. Imgs.file_img_suff

    else
      -- 没有图片
      --return Imgs.c_check_yes -- 预看效果图片
      return '','' -- 透明图片
    end
end

-- 表情图片显示
function EmojiDialog:getImgByBiaoqing(optTxt)
    if optTxt ~= nil and optTxt ~= CEnum.status.def_fill then
      return Imgs.biaoqing_exp .. optTxt .. Imgs.file_img_suff

    else
      -- 没有图片
      --return Imgs.c_check_yes -- 预看效果图片
      return Imgs.c_transparent -- 透明图片
    end
end

-- 表情图片显示
function EmojiDialog:getImgByBiaoqing1(optTxt)
    if optTxt ~= nil and optTxt ~= CEnum.status.def_fill then
      return Imgs.biaoqing_exp .. optTxt .. "_1" .. Imgs.file_img_suff

    else
      -- 没有图片
      --return Imgs.c_check_yes -- 预看效果图片
      return Imgs.c_transparent -- 透明图片
    end
end

-- 表情图片显示
function EmojiDialog:getImgByBiaoqing2(optTxt)
    if optTxt ~= nil and optTxt ~= CEnum.status.def_fill then
      return Imgs.biaoqing_exp .. optTxt .. "_2" .. Imgs.file_img_suff

    else
      -- 没有图片
      --return Imgs.c_check_yes -- 预看效果图片
      return Imgs.c_transparent -- 透明图片
    end
end

-- ListView
function EmojiDialog:createView2()
    -- 组合
    self.view_hu_list = 
        cc.ui.UIListView.new({
            bg = Imgs.biaoqing_bg,
            --bgStartColor = cc.c4b(255,64,64,150),
            --bgEndColor = cc.c4b(0,0,0,150),
            --bgColor = cc.c4b(200, 200, 200, 150),
            --bgColor = Colors.btn_bg,
            bgScale9 = false,
            --capInsets = cc.rect(0, 0, 706, 73*4),
            viewRect = cc.rect(0, 0, item_w*10, item_h*3),
            direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
            --direction = cc.ui.UIScrollView.DIRECTION_HORIZONTAL,
            --alignment = cc.ui.UIListView.ALIGNMENT_VCENTER
            --scrollbarImgH = Imgs.c_default_img
            --scrollbarImgV = Imgs.c_default_img
        })
        :addTo(self.pop_window)
        :align(display.CENTER, display.cx-item_w*9/2, 0)
        :setBounceable(false)
end

-- ListView
function EmojiDialog:setViewData2()
	
	local res_data = 
    {
		{
		"bf",
		"bs",
		"sj",
		"cl",
		"cy",
		"dk",
		"fn",
		},
		
		{
		"fw",
		"gg",
		"ka",
		"lh",
		"pz",
		"wx",
		"zt",
		}
	}
    if res_data ~= nil then
        Commons:printLog_Info("宽",item_w)
        Commons:printLog_Info("高",item_h)
        self.view_hu_list:removeAllItems()

        local size = #res_data
        for k,v in pairs(res_data) do
        	--Commons:printLog_Info("kkkkkkkkkkkkkkk::",k)
            local item = self.view_hu_list:newItem()
            local content = display.newNode()

            for kk,vv in pairs(v) do
            	--Commons:printLog_Info("PPPPPPP::", kk, item_w/2 + (item_w*(kk-1)), item_h*(size+1-k) )
	            local img_i = self:getImgByBiaoqing(vv)
	            --cc.ui.UIImage.new(img_i,{scale9=false})
	            local dd = cc.ui.UIPushButton.new(img_i,{scale9=false})
	            	--:setButtonSize(item_w, item_h)

	                -- HORIZONTAL
	                --:align(display.CENTER, 80*count - 40, 40)
	                :addTo(content)
	                if kk == 1 then
	                	dd:align(display.LEFT_TOP, item_w/2, item_h*(size+1-k)/3 )
	                else
		                -- VERTICAL
		                dd:align(display.LEFT_TOP, item_w/2 + ((item_w+20)*(kk-1)), item_h*(size+1-k)/3 )
	                end
	                dd:onButtonClicked(function(event)
	                    self:clickListener(vv)
	                end)

            end            

            content:setContentSize(item_w*10, item_h)
            item:addContent(content)
            --Commons:printLog_Info("最终是:",item_w, item_h)
            item:setItemSize(item_w*10, item_h)
            self.view_hu_list:addItem(item) -- 添加item到列表
        end
        --self.view_hu_list:onTouch(EmojiDialog_touchListener_listview)
        self.view_hu_list:reload() -- 重新加载
    end
end


---[[
-- PageView
function EmojiDialog:createView()
	cc.ui.UIImage.new(Imgs.biaoqing_bg,{scale9 = true})
		:addTo(self.pop_window)
        :align(display.CENTER, display.cx, item_h)
        --:setContentSize() --设置大小
        :setLayoutSize(item_w*7+20*7+40, item_h*2+20*2+40 +50) --设置大小

    -- 组合
    self.view_hu_list = 
        cc.ui.UIPageView.new({
            viewRect = cc.rect(0, 0, item_w*7+20*7+40, item_h*2+20*2+40),
            column = 7,
            row = 2, 
            padding = {left = 80, right = 20, top = 20, bottom =60},
            columnSpace=20,
            rowSpace=20,
            bCirc = false
        })
        :addTo(self.pop_window)
        :align(display.CENTER, display.cx-(item_w*7+20*7+40)/2, 0)
end
--]]

-- PageView
function EmojiDialog:setViewData()
	local res_data = 
    {
		"bf",
		"bs",
		"cj",
		"cl",
		"cy",
		"dk",
		"fn",
		
		"fw",
		"gg",
		"ka",
		"lh",
		"pz",
		"wx",
		"zt",
	}
    if res_data ~= nil then
    	Commons:printLog_Info("宽",item_w)
    	Commons:printLog_Info("高",item_h)
    	self.view_hu_list:removeAllItems()

    	for k,v in pairs(res_data) do

    		local item = self.view_hu_list:newItem()

    		local img_i = self:getImgByBiaoqing(v)
            local content = 
            	--cc.ui.UIImage.new(img_i,{scale9=false})
            	--content:setContentSize(item_w, item_h) --设置大小
            	cc.ui.UIPushButton.new(img_i,{scale9=false})
            		--:setButtonSize(30, 34)
                	--:align(display.CENTER, wwContent/2 +(-29*_size/2)+(29*(i-1)), hhContent/2)
                	--:align(display.CENTER, wwContent/2 +(27*(i-1)), hhContent/2)
                	:onButtonClicked(function(event)
	                    self:clickListener(v)
	                end)

            item:addChild(content)
            self.view_hu_list:addItem(item) -- 添加item到列表
    	end
    	--self.view_hu_list:onTouch(EmojiDialog_touchListener)
		self.view_hu_list:reload() -- 重新加载
    end
end

local emoji_tipimg_node
function EmojiDialog:clickListener(biaoqingNo)
    Commons:printLog_Info("要发送的表情代码是：", biaoqingNo)
    SocketRequestGameing:gameing_SendEmoji(biaoqingNo)

    if self.formView ~= nil and self.formView==CEnum.pageView.gameingPhzPage then
        emoji_tipimg_node = GameingDealUtil:createEmoji_Anim(self, biaoqingNo, CEnum.seatNo.me, emoji_tipimg_node)
    else
        emoji_tipimg_node = EmojiView:createEmoji_Anim(self, biaoqingNo, CEnumP.seatNo.me, emoji_tipimg_node)
    end

    self:myExit()
end


function EmojiDialog:onExit()
    self:myExit()
end

function EmojiDialog:myExit()

    if self.view_hu_list ~= nil and (not tolua.isnull(self.view_hu_list)) then
        self.view_hu_list:removeFromParent()
        self.view_hu_list = nil
    end

    if self.pop_window ~= nil and (not tolua.isnull(self.pop_window)) then
        self.pop_window:removeFromParent()
        self.pop_window = nil
    end
end

return EmojiDialog