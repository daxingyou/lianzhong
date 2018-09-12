
local EmojiView = class("EmojiView",function()
    return display.newNode()
end)

function EmojiView:ctor()
end

function EmojiView:onEnter()
end

--获取其他玩家的客户端座位号
function EmojiView:confimSeatNo(mySeatId, serverId)
  local tt = (((0-mySeatId)+serverId+3)%3+1)
  if tt == 1 then
    return CEnumP.seatNo.me
  elseif tt == 2 then
    return CEnumP.seatNo.R
  else
    return CEnumP.seatNo.L
  end
  -- return (((0-self.mySeatId)+serverId+3)%3+1)
end

-- 超级表情
function EmojiView:superEmojoDataHandler(res_data, Layer1, mySeatNo)
  -- print("======================3333333333==================", res_data, Layer1, mySeatNo)
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

-- 表情
local emoji_node_view
function EmojiView:emoji_createView_setViewData(res_data, parent_view, model)
    if res_data ~= nil then
        local room = res_data--[User.Bean.room]
        local exp_code = room[Player.Bean.code]
        local currNo = room[Player.Bean.seatNo]

        -- local _seat = GameingDealUtil:confimSeatNo(mySeatNo, currNo) -- 确定相对位置：：0=本人位置，1=下一玩家，-1=上一玩家，最后一玩家
        local _seat = model:getOtherClientSeatId(currNo) -- 确定相对位置：：0=本人位置，1=下一玩家，-1=上一玩家，最后一玩家
        --Commons:printLog_Info("----位置是：", exp_code, currNo, _seat)

        if _seat == CEnumP.seatNo.me then
            -- 自己发送的，自己也播放，但不是这里
        else
            if parent_view ~= nil and model ~= nil then
                emoji_node_view = self:createEmoji_Anim(parent_view, exp_code, _seat, emoji_node_view)
            end
        end
    end
end

-- 短语
local words_node_view
function EmojiView:words_createView_setViewData(res_data, parent_view, model)
    if res_data ~= nil then
        local room = res_data--[User.Bean.room]
        local words_code = room[Player.Bean.code]
        local currNo = room[Player.Bean.seatNo]

        -- local _seat = GameingDealUtil:confimSeatNo(mySeatNo, currNo) -- 确定相对位置：：0=本人位置，1=下一玩家，-1=上一玩家，最后一玩家
        local _seat = model:getOtherClientSeatId(currNo) -- 确定相对位置：：0=本人位置，1=下一玩家，-1=上一玩家，最后一玩家
        --Commons:printLog_Info("----位置是：", words_code, currNo, _seat)

        if _seat == CEnumP.seatNo.me then
            -- 自己发送的，自己也播放，但不是这里
        else
            if parent_view ~= nil and model ~= nil then
                words_node_view = self:createWords_Anim(parent_view, words_code, _seat, words_node_view)
            end
        end
    end
end

--[[
创建一个表情动画
--]]
function EmojiView:createEmoji_Anim(parent_view, exp_code, seatNo, _tipimg_node)

	local osWidth = Commons.osWidth
	local osHeight = Commons.osHeight

    if _tipimg_node ~= nil and (not tolua.isnull(_tipimg_node)) then
  		_tipimg_node:removeFromParent()
  		_tipimg_node = nil
    end

    if exp_code ~= nil then
        -- 第一套表情的处理
        local moveX_exp = 0
        local moveY_exp = 0
        if exp_code=='bf' then
          moveX_exp = -7
          moveY_exp = 0
        elseif exp_code=='ka' then
          moveX_exp = -7
          moveY_exp = 0
        elseif exp_code=='wx' then
          moveX_exp = 4
          moveY_exp = 0
        end

    		-- 图片提示
    		local tipimg_node = display.newNode():addTo(parent_view, CEnum.ZOrder.gameingView_myself_emoji)

  	    --local plist, png = EmojiDialog:getImgByBiaoqing_new(exp_code)
    		--display.addSpriteFrames(plist, png) -- loading动画

    		local frames = display.newFrames(exp_code.."_%d.png",0,2)
    		local animation = display.newAnimation(frames, 0.7/3)
    	    
    		local loadingSpriteAnim = display.newSprite(animation[1])
        if seatNo == CEnumP.seatNo.me then
    				loadingSpriteAnim:align(display.LEFT_TOP, 50 -21 +moveX_exp, 155 +190+2 +moveY_exp)
    		elseif seatNo == CEnumP.seatNo.R then
    				loadingSpriteAnim:align(display.RIGHT_TOP, osWidth-50 +21 -moveX_exp, osHeight-32 -50+2 +moveY_exp)
    		elseif seatNo == CEnumP.seatNo.L then
    				loadingSpriteAnim:align(display.LEFT_TOP, 50 -21 +moveX_exp, osHeight-32 -50+2 +moveY_exp)
    		end
        loadingSpriteAnim:addTo(tipimg_node)
        loadingSpriteAnim:playAnimationForever(animation)

    		parent_view:performWithDelay(function ()
    			if tipimg_node ~= nil and (not tolua.isnull(tipimg_node)) then
              if loadingSpriteAnim ~= nil and (not tolua.isnull(loadingSpriteAnim)) then
                  -- print("============确定停止了")
                  loadingSpriteAnim:stopAllActions()
                  -- tipimg_node:stopAction(loadingSpriteAnim)
              end
    			    tipimg_node:hide()
    			end
    		end, 3)

  		  return tipimg_node
    end

end

--[[
创建一个短语显示和声音播放
--]]
function EmojiView:createWords_Anim(parent_view, words_code, seatNo, _tipimg_node)

    local osWidth = Commons.osWidth
    local osHeight = Commons.osHeight

    if _tipimg_node ~= nil and (not tolua.isnull(_tipimg_node)) then
      _tipimg_node:removeFromParent()
      _tipimg_node = nil
    end

    if words_code ~= nil then
        -- 图片提示
        local tipimg_node = display.newNode():addTo(parent_view, CEnum.ZOrder.gameingView_myself_emoji)

        local msg,url = EmojiDialog:getWordsMsg_by_code(words_code)
        -- print("======================",msg,url)

        if Commons:checkIsNull_str(msg) then
          local item_w_words = 123*2 *1.3
          local item_h_words = 70 -- 空出70像素的title部分

          if seatNo == CEnumP.seatNo.me then
            local bg = display.newScale9Sprite(Imgs.words_txt_me, 0,0, 
                        cc.size(item_w_words, item_h_words), 
                        cc.rect(32, 32, 6, 6)
                      )
                      -- cc.ui.UIPushButton.new(Imgs.words_txt_me, {scale9=true, size=cc.size(item_w_words, item_h_words), capInsets=cc.rect(32, 32, 6, 6)} )
                      --     :setButtonSize(item_w_words*1.2, item_h_words*1.2)
                      --     :setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
                      --         UILabelType = 2,
                      --         text = msg,
                      --         font = Fonts.Font_hkyt_w7,
                      --         size = Dimens.TextSize_20,
                      --         color = Colors.words_txt,
                      --         -- align = cc.ui.TEXT_ALIGN_LEFT,
                      --         -- valign = cc.ui.TEXT_VALIGN_CENTER,
                      --     }))
                      -- :setButtonLabelAlignment(display.LEFT_CENTER)        --设置按钮文字的对齐方式  
                      -- :setButtonLabelOffset(-(item_w_words*1.2)/2+10, 0)                  --设置按钮文字的x,y偏移
                      :addTo(tipimg_node)
                      :align(display.LEFT_BOTTOM, 10, 140+190)

              cc.ui.UILabel.new({
                      UILabelType = 2,
                      text = msg,
                      font = Fonts.Font_hkyt_w7,
                      size = Dimens.TextSize_20,
                      -- color = Colors.words_txt,
                      color = Colors.white,
                      align = cc.ui.TEXT_ALIGN_LEFT,
                      valign = cc.ui.TEXT_VALIGN_CENTER,
                  })
                  :addTo(bg)
                  :align(display.LEFT_BOTTOM, 15, 27+5)

          elseif seatNo == CEnumP.seatNo.R then
            local bg = display.newScale9Sprite(Imgs.words_txt_R, 0,0, 
                        cc.size(item_w_words, item_h_words), 
                        cc.rect(32, 32, 6, 6)
                      )
                      -- cc.ui.UIPushButton.new(Imgs.words_txt_me, {scale9=true, size=cc.size(item_w_words, item_h_words), capInsets=cc.rect(32, 32, 6, 6)} )
                      --     :setButtonSize(item_w_words*1.2, item_h_words*1.2)
                      --     :setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
                      --         UILabelType = 2,
                      --         text = msg,
                      --         font = Fonts.Font_hkyt_w7,
                      --         size = Dimens.TextSize_20,
                      --         color = Colors.words_txt,
                      --         -- align = cc.ui.TEXT_ALIGN_LEFT,
                      --         -- valign = cc.ui.TEXT_VALIGN_CENTER,
                      --     }))
                      -- :setButtonLabelAlignment(display.LEFT_CENTER)        --设置按钮文字的对齐方式  
                      -- :setButtonLabelOffset(-(item_w_words*1.2)/2+10, 0)                  --设置按钮文字的x,y偏移
                      :addTo(tipimg_node)
                      :align(display.RIGHT_BOTTOM, osWidth -10, osHeight -140 -65)

              cc.ui.UILabel.new({
                      UILabelType = 2,
                      text = msg,
                      font = Fonts.Font_hkyt_w7,
                      size = Dimens.TextSize_20,
                      -- color = Colors.words_txt,
                      color = Colors.white,
                      align = cc.ui.TEXT_ALIGN_LEFT,
                      valign = cc.ui.TEXT_VALIGN_CENTER,
                  })
                  :addTo(bg)
                  :align(display.LEFT_BOTTOM, 15, 27 -5)

          elseif seatNo == CEnumP.seatNo.L then
            local bg = display.newScale9Sprite(Imgs.words_txt_L, 0,0, 
                        cc.size(item_w_words, item_h_words), 
                        cc.rect(32, 32, 6, 6)
                      )
                      -- cc.ui.UIPushButton.new(Imgs.words_txt_me, {scale9=true, size=cc.size(item_w_words, item_h_words), capInsets=cc.rect(32, 32, 6, 6)} )
                      --     :setButtonSize(item_w_words*1.2, item_h_words*1.2)
                      --     :setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
                      --         UILabelType = 2,
                      --         text = msg,
                      --         font = Fonts.Font_hkyt_w7,
                      --         size = Dimens.TextSize_20,
                      --         color = Colors.words_txt,
                      --         -- align = cc.ui.TEXT_ALIGN_LEFT,
                      --         -- valign = cc.ui.TEXT_VALIGN_CENTER,
                      --     }))
                      -- :setButtonLabelAlignment(display.LEFT_CENTER)        --设置按钮文字的对齐方式  
                      -- :setButtonLabelOffset(-(item_w_words*1.2)/2+10, 0)                  --设置按钮文字的x,y偏移
                      :addTo(tipimg_node)
                      :align(display.LEFT_BOTTOM, 10, osHeight -140 -65)

              cc.ui.UILabel.new({
                      UILabelType = 2,
                      text = msg,
                      font = Fonts.Font_hkyt_w7,
                      size = Dimens.TextSize_20,
                      -- color = Colors.words_txt,
                      color = Colors.white,
                      align = cc.ui.TEXT_ALIGN_LEFT,
                      valign = cc.ui.TEXT_VALIGN_CENTER,
                  })
                  :addTo(bg)
                  :align(display.LEFT_BOTTOM, 15, 27 -5)
          end  
        end

        if Commons:checkIsNull_str(url) then
          VoiceDealUtil:playSound_forWords(url)
        end

        local gapTime = 2
        -- if words_code==EmojiDialog.gameingWordsList[1].code then
        --   gapTime = 0.28
        -- elseif words_code==EmojiDialog.gameingWordsList[2].code then
        --   gapTime = 0.28
        -- end
        parent_view:performWithDelay(function ()
          if tipimg_node ~= nil and (not tolua.isnull(tipimg_node)) then
              tipimg_node:hide()
          end
        end, gapTime)

        return tipimg_node
    end

end

--[[
创建一个播放语音动画
--]]
function EmojiView:createVoice_Anim(parent_view, seatNo, _tipimg_node)

    --print("------------------------动画已经进入", seatNo)
    local osWidth = Commons.osWidth
    local osHeight = Commons.osHeight

    if _tipimg_node ~= nil and (not tolua.isnull(_tipimg_node)) then
      _tipimg_node:stopAllActions()
      _tipimg_node:removeFromParent()
      _tipimg_node = nil
    end

    -- -- 图片提示
    local tipimg_node = display.newNode():addTo(parent_view, CEnum.ZOrder.gameingView_myself_emoji)
    -- local tipimg_node;

    --display.addSpriteFrames(Imgs.voiceplay_plist, Imgs.voiceplay_png) -- 语音播放动画

    local frames = display.newFrames("voiceplay%02d.png",1,3)
    local animation = display.newAnimation(frames, 0.9/3)

    _tipimg_node = display.newSprite(animation[3])
    if seatNo == CEnumP.seatNo.me then -- me
        _tipimg_node:align(display.LEFT_TOP, 50 -21, 155 +190-6)

    elseif seatNo == CEnumP.seatNo.R then  -- xiajia
        _tipimg_node:align(display.RIGHT_TOP, osWidth-50 +21, osHeight-32 -50-6)

    elseif seatNo == CEnumP.seatNo.L then -- lastjia
        _tipimg_node:align(display.LEFT_TOP, 50 -21, osHeight-32 -50-6)
    end
    _tipimg_node:addTo(tipimg_node)
    -- _tipimg_node:addTo(parent_view, CEnum.ZOrder.gameingView_myself_emoji)
    _tipimg_node:playAnimationForever(animation)

    return _tipimg_node
end

return EmojiView