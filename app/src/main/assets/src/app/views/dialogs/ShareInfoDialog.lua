--
-- Author: lte
-- Date: 2016-11-04 13:01:54
-- 玩法的弹窗

-- 类申明
local ShareInfoDialog = class("ShareInfoDialog"
    -- ,function()
    --     return display.newNode()
    -- end
    )


local osWidth = Commons.osWidth
local osHeight = Commons.osHeight


-- local ALL_content
-- local shareToken
-- local shareTitle
-- local sharePic
-- local shareContent
-- local jumpUrl
-- local shareType

local gaping_w -- 整个图层的左右间距
local gaping_h -- 整个图层的上下间距
local gaping_x -- 内容背景，左右 底部 间距
local gaping_y -- 内容背景，顶部间距

function ShareInfoDialog:ctor()
end


-- 创建一个模态弹出框,  parent=要加在哪个上面
function ShareInfoDialog:popDialogBox(_parent)
    -- ALL_content = _ALL_content
    -- --shareToken = RequestBase:getStrDecode(ALL_content[ShareInfo.Bean.token])
    -- shareTitle = RequestBase:getStrDecode(ALL_content[ShareInfo.Bean.shareTitle])
    -- sharePic = RequestBase:getStrDecode(ALL_content[ShareInfo.Bean.sharePic])
    -- shareContent = RequestBase:getStrDecode(ALL_content[ShareInfo.Bean.shareContent])
    -- jumpUrl = RequestBase:getStrDecode(ALL_content[ShareInfo.Bean.jumpUrl])

    self.parent = _parent

    self.pop_window = display.newColorLayer(cc.c4b(0, 0, 0, 100))       -- 半透明的黑色

    self.pop_window:setContentSize(osWidth, osHeight)             -- 设置Layer的大小,全屏出现
    --self.pop_window:align(display.CENTER, display.cx, display.cy) -- Layer的锚点在0.5,0.5 因此对齐的时候要注意
    self.pop_window:setTouchEnabled(true)
    self.pop_window:setTouchSwallowEnabled(true)  -- 吞噬下层的响应
    self.pop_window:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event) -- 点击此Layer时候输出信息,然后把自己销毁
        return true
    end)
    self.parent:addChild(self.pop_window, CEnum.ZOrder.common_dialog) -- 把Layer添加到父对象上


    gaping_w = 18
    gaping_h = 16
    gaping_x = 10
    gaping_y = 74


    ---[[
    -- 整个底色背景
    cc.ui.UIImage.new(Imgs.dialog_bg,{})
        :addTo(self.pop_window)
    	:align(display.CENTER, display.cx, display.cy)
    	:setLayoutSize(osWidth -gaping_w*2, osHeight -gaping_h*2)
    --]]

    -- 内容背景
    cc.ui.UIImage.new(Imgs.dialog_content_bg,{})
        :addTo(self.pop_window)
        :align(display.CENTER, display.cx, display.cy -gaping_y*0.5)
        :setLayoutSize(osWidth -gaping_w*2 -gaping_x*2, osHeight -gaping_h*2 -gaping_y -gaping_x)

    -- logo
    cc.ui.UIImage.new(Imgs.share_title_logo,{})
    	:addTo(self.pop_window)
    	:align(display.CENTER_TOP, display.cx, osHeight -gaping_h -11)

    -- 关闭
    cc.ui.UIPushButton.new(Imgs.dialog_exit,{scale9=false})
        -- :setButtonSize(74, 74)
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
        :setButtonImage(EnStatus.pressed, Imgs.dialog_exit_press)
        :onButtonClicked(function(e)

            VoiceDealUtil:playSound_other(Voices.file.ui_click)
            -- HomeScene:getRoomBalance_home()
            MainHallScene:getRoomBalance_home()
            self:myExit()

        end)
    	:addTo(self.pop_window)
        :align(display.RIGHT_TOP, osWidth -gaping_w -gaping_x, osHeight -gaping_h -11)

    ---[[
    -- 微信好友
    self.wxBtn = cc.ui.UIPushButton.new(
        Imgs.share_btn_wx_f,{scale9=false})
        --:setButtonSize(180, 84)
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
        :setButtonImage(EnStatus.pressed, Imgs.share_btn_wx_f_press)
        :onButtonClicked(function(e)

            VoiceDealUtil:playSound_other(Voices.file.ui_click)
            self:myConfim(CEnum.shareType.wx)

        end)
        :align(display.CENTER_BOTTOM, display.cx -160, gaping_h +10)
        :addTo(self.pop_window)
        :hide()
    --]]

    ---[[
    -- 微信朋友圈
    self.wxCircleBtn = cc.ui.UIPushButton.new(
        Imgs.share_btn_wx_c,{scale9=false})
        --:setButtonSize(180, 84)
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
        :setButtonImage(EnStatus.pressed, Imgs.share_btn_wx_c_press)
        :onButtonClicked(function(e)

            VoiceDealUtil:playSound_other(Voices.file.ui_click)
            self:myConfim(CEnum.shareType.wxCircle)

        end)
        :align(display.CENTER_BOTTOM, display.cx +160, gaping_h +10)
        :addTo(self.pop_window)
        :hide()
    --]]

    self.loadingPop_window = CDAlertLoading.new():popDialogBox(self.pop_window, Strings.hint_Loading)
    RequestHome:getShareInfo(nil, function(...) self:resData_ShareInfo(...) end )

end

function ShareInfoDialog:resData_ShareInfo(jsonObj)
    if self.loadingPop_window~=nil and (not tolua.isnull(self.loadingPop_window)) then
        self.loadingPop_window:removeFromParent()
        self.loadingPop_window = nil
    end

    local status = jsonObj[ParseBase.status]
    local msg = RequestBase:getStrDecode(jsonObj[ParseBase.msg])
    Commons:printLog_Info("状态是：", status, "内容是：", msg)
    -- dump(jsonObj,"分享数据：")

    if status ~= nil and status == CEnum.status.success then
        local data = jsonObj[ParseBase.data]
        if data ~= nil then
            local content = data[ShareInfo.Bean.content]
            if content ~= nil then
                local activeContent = RequestBase:getStrDecode(content[ShareInfo.Bean.activeContent])
                -- print("===============", activeContent)
                if Commons:checkIsNull_str(activeContent) then
                    self:create_contentView(activeContent)
                else
                    self:create_contentView("")
                end

                --self.shareToken = RequestBase:getStrDecode(content[ShareInfo.Bean.token])
                self.shareTitle = RequestBase:getStrDecode(content[ShareInfo.Bean.shareTitle])
                self.sharePic = RequestBase:getStrDecode(content[ShareInfo.Bean.sharePic])
                self.shareContent = RequestBase:getStrDecode(content[ShareInfo.Bean.shareContent])
                self.jumpUrl = RequestBase:getStrDecode(content[ShareInfo.Bean.jumpUrl])

                -- self.wxBtn:addTo(self.pop_window)
                self.wxBtn:show()
                -- self.wxCircleBtn:addTo(self.pop_window)
                self.wxCircleBtn:show()
            else
                -- self:create_contentView(Strings.gameing.noData_info)
                CDAlert.new():popDialogBox(self.pop_window, Strings.gameing.noData_info)
            end
        else
            -- self:create_contentView(Strings.gameing.noData_info)
            CDAlert.new():popDialogBox(self.pop_window, Strings.gameing.noData_info)
        end
    else
        -- self:create_contentView(msg)
        CDAlert.new():popDialogBox(self.pop_window, msg)
    end

end

function ShareInfoDialog:resData_ShareClick(jsonObj)

    local status = jsonObj[ParseBase.status]
    local msg = RequestBase:getStrDecode(jsonObj[ParseBase.msg])
    Commons:printLog_Info("状态是：", status, "内容是：", msg)

    local data = jsonObj[ParseBase.data]
    if data ~= nil then
        self.shareToken = RequestBase:getStrDecode(data[ShareInfo.Bean.shareToken])
        if self.shareToken ~= nil then
            -- local shareTitle
            -- local sharePic
            -- local shareContent
            -- local jumpUrl

            local function ShareInfoDialog_CallbackLua(txt)
                if Commons:checkIsNull_str(txt) then -- and txt=="ok" then
                    local param = {shareToken=self.shareToken}
                    RequestHome:sendShareSucc(param, nil)
                end
            end
            Commons:printLog_Info("====分享的内容是：", self.shareTitle, self.sharePic, self.shareContent, self.jumpUrl, self.shareType)

            if Commons.osType == CEnum.osType.A then
                local _Class = CEnum.WX_Share_Active._Class
                local _Name = CEnum.WX_Share_Active._Name
                local _args = { 
                            self.shareTitle, 
                            self.sharePic, 
                            self.shareContent, 
                            self.jumpUrl, 
                            self.shareType,
                            ShareInfoDialog_CallbackLua}
                local _sig = "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;I)V" --传入string参数，无返回值
                --local ok, ret = 
                luaj.callStaticMethod(_Class, _Name, _args, _sig) --没有返回默认nil
            elseif Commons.osType == CEnum.osType.I then
                local _Class = CEnum.WX_Share_Active_ios._Class
                local _Name = CEnum.WX_Share_Active_ios._Name
                local _args = { title = self.shareTitle, 
                                pic = self.sharePic, 
                                content = self.shareContent, 
                                jumpUrl = self.jumpUrl, 
                                shareType = self.shareType,
                                listener = ShareInfoDialog_CallbackLua}
                --local ok, ret = 
                luaoc.callStaticMethod(_Class, _Name, _args)    
            end
        end
    end

end

function ShareInfoDialog:myConfim(_shareType)
    self.shareType = _shareType
	-- 分享点击上报
	local param = {shareType=_shareType}
	RequestHome:sendShareClick(param, function(...) self:resData_ShareClick(...) end)
end

function ShareInfoDialog:create_contentView(contentMsg)
    local item_w = osWidth -120
    local item_h = osHeight -147

	-- local _node = --display.newNode()
 --        cc.ui.UIImage.new(Imgs.round_item_ou,{scale9 = true})
 --    _node:setContentSize(item_w, item_h) --设置大小

	local _node = cc.ui.UILabel.new({
            UILabelType = 2, 
            --image = "",
            text = contentMsg, 
            size = Dimens.TextSize_25,
            --color = Colors.black,
            color = Colors:_16ToRGB(Colors.help_txt),
            font = Fonts.Font_hkyt_w7,
            align = cc.ui.TEXT_ALIGN_LEFT,
            valign = cc.ui.TEXT_VALIGN_TOP,
            dimensions = cc.size(item_w,0) -- height为0，就是自动换行
        })
        :align(display.LEFT_TOP, 0, osHeight -147 -80) -- 这里的x -60，y-30，都是为了填补UIScrollView边距
        --:addTo(_node)
    --local sp = display.newSprite("img/scroll/cloud.png")
    --sp:pos(18+12+30, osHeight-118)

    ---[[
	cc.ui.UIScrollView.new({
            direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
            viewRect = {x = 0, y = 0, width = item_w, height = item_h-80 }, -- 设置显示区域
            --capInsets = {x = 0, y = 0, width = item_w, height = item_h }, -- 设置显示区域
            -- scrollbarImgH = Imgs.scroll_barH,
            -- scrollbarImgV = Imgs.scroll_bar,
            scrollbarImgH = Imgs.c_transparent,
            scrollbarImgV = Imgs.c_transparent,
            bgColor = cc.c4b(160,160,160, 0)
        })
        --:setDirection(cc.ui.UIScrollView.DIRECTION_BOTH)
        :setBounceable(false)
    	--:onScroll(function (event)
    		--Commons:printLog_Info("TestUIScrollViewScene - scrollListener:" .. event.name)
    	--end)
        :addScrollNode(_node)
        :addTo(self.pop_window)
        --:pos(18+12+30, 30)
        :align(display.LEFT_TOP, gaping_w +42, gaping_h +14 +80)
    --]]

    --[[
    local view_hu_list = cc.ui.UIListView.new({
            --bg = Imgs.c_default_img,
            --bgStartColor = cc.c4b(255,64,64,150),
            --bgEndColor = cc.c4b(0,0,0,150),
            bgColor = cc.c4b(200, 200, 200, 0),
            --bgColor = Colors.btn_bg,
            bgScale9 = false,
            --capInsets = cc.rect(0, 0, 706, 73*4),
            viewRect = cc.rect(0, 0, item_w, item_h),
            direction = cc.ui.UIScrollView.DIRECTION_VERTICAL,
            --direction = cc.ui.UIScrollView.DIRECTION_HORIZONTAL,
            --alignment = cc.ui.UIListView.ALIGNMENT_VCENTER
            --scrollbarImgH = Imgs.c_default_img
            --scrollbarImgV = Imgs.c_default_img
        })
        :addTo(self.pop_window)
        :align(display.LEFT_TOP, 18+12+30, 30)

    local item = view_hu_list:newItem()
    item:addContent(_node)
    --Commons:printLog_Info("最终是:",item_w, item_h)
    item:setItemSize(item_w, item_h)
    view_hu_list:addItem(item) -- 添加item到列表
    view_hu_list:reload() -- 重新加载
    --]]
end

function ShareInfoDialog:onExit()
    self:myExit()
end

function ShareInfoDialog:myExit()
    if self.pop_window ~= nil and (not tolua.isnull(self.pop_window)) then
        self.pop_window:removeFromParent()
        self.pop_window = nil
    end
end

return ShareInfoDialog