--
-- Author: luobinbin
-- Date: 2017-07-20 19:40:54
-- 游戏中 需要的单独处理方法


-- 类申明
-- local GameMaJiangUtil = class("GameMaJiangUtil", function ()
--     return display.newNode();
-- end)
local GameMaJiangUtil = class("GameMaJiangUtil")

local MJ_CLIENT_CARD_TABLE = {
  [1]="w1",[2]="w2",[3]="w3",[4]="w4",[5]="w5",[6]="w6",[7]="w7",[8]="w8",[9]="w9",
  [11]="t1",[12]="t2",[13]="t3",[14]="t4",[15]="t5",[16]="t6",[17]="t7",[18]="t8",[19]="t9",
  [21]="s1",[22]="s2",[23]="s3",[24]="s4",[25]="s5",[26]="s6",[27]="s7",[28]="s8",[29]="s9",
  [30]="zhong"
}

-- 确定玩家的座位号 0=本人 1=下一玩家（右手边）2=对面玩家 3=最后一个玩家（左手边）
function GameMaJiangUtil:confimSeatNo(owerNo, currNo)
    local tt = (((0-owerNo)+currNo+4)%4+1)
    if tt == 1 then
      return CEnumM.seatNo.me
    elseif tt == 2 then
      return CEnumM.seatNo.R
    elseif tt == 3 then
      return CEnumM.seatNo.M
    else
      return CEnumM.seatNo.L
    end
end

--取得牌的名字
function GameMaJiangUtil:getCardName(cardID)
    return MJ_CLIENT_CARD_TABLE[cardID]
end

 --本人的出牌选择操作  吃 碰 杠 胡 过 动作按钮 图片显示
function GameMaJiangUtil:getImgByOptionMid(optTxt)
    if optTxt ~= nil and optTxt ~= CEnum.status.def_fill then
      return "#"..optTxt..ImgsM.room_options..Imgs.file_img_suff
    else
      -- 没有牌
      return Imgs.gameing_mid_zhanwei -- 透明图片
    end
end

-- 本人的出牌选择操作  触礁效果  吃 碰 胡 过  王钓 王闯 动作按钮  图片显示
function GameMaJiangUtil:getImgByOptionMid_press(optTxt)
    if optTxt ~= nil and optTxt ~= CEnum.status.def_fill then
      return "#"..optTxt..ImgsM.room_options_sel..Imgs.file_img_suff
    else
      return Imgs.gameing_mid_zhanwei -- 透明图片
    end
end

function GameMaJiangUtil:createTouchableSprite(p)
    local sprite = display.newScale9Sprite(p.image)
    sprite:setContentSize(p.size)

    local cs = sprite:getContentSize()
    local label = cc.ui.UILabel.new({
            UILabelType = 2,
            text = p.label,
            color = p.labelColor})
    label:align(display.CENTER)
    label:setPosition(cs.width / 2, label:getContentSize().height)
    sprite:addChild(label)
    sprite.label = label

    return sprite
end

--手牌数据对比检测
function GameMaJiangUtil:handCardDataCheck(optTxt)
    
end


function GameMaJiangUtil:createSimpleButton(imageName, name, movable, listener)
    local __posMaxY = 120
    local __posMinY = 60
    if CVar._static.isIphone4 then
        __posMaxY = 120
        __posMinY = 46
    elseif CVar._static.isIpad then
        __posMaxY = 120
        __posMinY = 46
    elseif CVar._static.NavBarH_Android ~= CEnum.status.NavBarH_def then
        
    end

    local sprite = display.newSprite(imageName)

    if name then
        local cs = sprite:getContentSize()
        local label = cc.ui.UILabel.new({
            UILabelType = 2,text = name, color = display.COLOR_BLACK})
        label:setPosition(cs.width / 2, cs.height / 2)
        -- sprite:addChild(label)
    end

    sprite:setTouchEnabled(true) -- enable sprite touch
    -- sprite:setTouchMode(cc.TOUCH_ALL_AT_ONCE) -- enable multi touches
    sprite:setTouchSwallowEnabled(false)

    sprite:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        local name, x, y, prevX, prevY = event.name, event.x, event.y, event.prevX, event.prevY
        if name == "began" then
            --sprite:setOpacity(128)
            sprite:setLocalZOrder(CEnumM.ZOrder.playerNode+18)
            -- return cc.TOUCH_BEGAN -- stop event dispatching
            if listener.isMeChu == false then
              return false
            end

            if sprite.isCanChu == false then
              return false
            end

            if listener.isGameOver then
              return false
            end

            if listener.clientCanChuCard == false then
              return false
            end

            if listener.isMeChu and sprite.isCanChu then
               VoiceDealUtil:playSound_other(VoicesM.file.handcard_click)
            end

            return true -- continue event dispatching
        end

        local touchInSprite = cc.rectContainsPoint(sprite:getCascadeBoundingBox(), cc.p(x, y))
        if name == "moved" then
            --sprite:setOpacity(128)
            if movable then
                local offsetX = x - prevX
                local offsetY = y - prevY
                local sx, sy = sprite:getPosition()
                sprite:setPosition(sx + offsetX, sy + offsetY)
                return true -- stop event dispatching, remove others node
                -- return cc.TOUCH_MOVED_SWALLOWS -- stop event dispatching
            end

        elseif name == "ended" then
            --if touchInSprite then listener() end
            --sprite:setOpacity(255)
            local offsetY1 = math.ceil(y) - math.ceil(sprite.originalPosY)
            --[[
            if offsetY1 >= 0 then
              if offsetY1 < 140 then
                if sprite.isFlag then
                  --出牌
                else
                  sprite.isFlag = true
                  sprite:setPosition(cc.p(sprite.originalPosX, sprite.originalPosY + 10))
                end
              elseif offsetY >= 140 then
                --出牌
              end
            end
            ]]
            print("sprite:getPositionY()-------->", sprite:getPositionY())

            if sprite:getPositionY() > __posMaxY then
              if listener ~= nil then
                listener:reworkPrevHandCard(sprite)
                --出牌
                listener:handlerMyHandCard(sprite)
              end
            else
              if sprite:getPositionY() < __posMinY then
                --恢复位置
                sprite.isFlag = false
                sprite:setPosition(cc.p(sprite.originalPosX, sprite.originalPosY))
                sprite:setLocalZOrder(CEnumM.ZOrder.handCardNormal)
              else
                print("sprite.isFlag"..tostring(sprite.isFlag))
                if sprite.isFlag then
                  if listener ~= nil then
                      --listener:reworkPrevHandCard(sprite)
                      listener.prevHandCard = nil
                      --出牌
                      listener:handlerMyHandCard(sprite)
                  end
                else
                    print("sprite.originalPosY"..sprite.originalPosY)
                    sprite.isFlag = true
                    sprite:setPosition(cc.p(sprite.originalPosX, sprite.originalPosY + 10))
                    sprite:setLocalZOrder(CEnumM.ZOrder.handCardNormal)
                    --如果不是当前这张牌
                    if sprite ~= listener.prevHandCard then
                      listener:reworkPrevHandCard(sprite)
                    end
                end
              end
            end
        else
            --sprite:setOpacity(255)
        end
    end)

    return sprite
end

function GameMaJiangUtil:drawBoundingBox(parent, target, color)
    local cbb = target:getCascadeBoundingBox()
    local left, bottom, width, height = cbb.origin.x, cbb.origin.y, cbb.size.width, cbb.size.height
    local points = {
        {left, bottom},
        {left + width, bottom},
        {left + width, bottom + height},
        {left, bottom + height},
        {left, bottom},
    }
    local box = display.newPolygon(points, {borderColor = color})
    parent:addChild(box, 1000)
end

--创建一个表情动画
function GameMaJiangUtil:createEmoji_Anim(parent_view, exp_code, seatNo, _tipimg_node)

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
        local tipimg_node = display.newNode():addTo(parent_view, 65)

        --local plist, png = EmojiDialog:getImgByBiaoqing_new(exp_code)
        --display.addSpriteFrames(plist, png) -- loading动画

        local frames = display.newFrames(exp_code.."_%d.png",0,2)
        local animation = display.newAnimation(frames, 0.7/3)

        local moveX_M = 0
        if CVar._static.isIphone4 then
            moveX_M = 65
        elseif CVar._static.isIpad then
            moveX_M = 75
        elseif CVar._static.NavBarH_Android ~= CEnum.status.NavBarH_def then
        end

        local loadingSpriteAnim = display.newSprite(animation[1])
        if seatNo == CEnumM.seatNo.me then
          loadingSpriteAnim:align(display.LEFT_TOP, 25 +moveX_exp, 165 +110 +moveY_exp)
        elseif seatNo == CEnumM.seatNo.R then
          loadingSpriteAnim:align(display.RIGHT_TOP, osWidth -30 -moveX_exp, 165+280 +40 +moveY_exp)

        elseif seatNo == CEnumM.seatNo.M then
          loadingSpriteAnim:align(display.RIGHT_TOP, osWidth -30 -230 +moveX_M +moveX_exp, 165+280 +210 +moveY_exp)

        elseif seatNo == CEnumM.seatNo.L then
          loadingSpriteAnim:align(display.LEFT_TOP, 25 +moveX_exp, 165+280 +40 +moveY_exp)
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

--创建一个短语显示和声音播放
function GameMaJiangUtil:createWords_Anim(parent_view, words_code, seatNo, _tipimg_node)

    local osWidth = Commons.osWidth
    local osHeight = Commons.osHeight

    if _tipimg_node ~= nil and (not tolua.isnull(_tipimg_node)) then
      _tipimg_node:removeFromParent()
      _tipimg_node = nil
    end

    if words_code ~= nil then
        -- 图片提示
        local tipimg_node = display.newNode():addTo(parent_view, 65)

        local msg,url = EmojiDialog:getWordsMsg_by_code(words_code)

        if Commons:checkIsNull_str(msg) then
          local item_w_words = 123*2 *1.3
          local item_h_words = 70 -- 空出70像素的title部分

          local moveX_M = 0
          if CVar._static.isIphone4 then
              moveX_M = 65
          elseif CVar._static.isIpad then
              moveX_M = 75
          elseif CVar._static.NavBarH_Android ~= CEnum.status.NavBarH_def then
          end

          if seatNo == CEnumM.seatNo.me then
            local bg = display.newScale9Sprite(Imgs.words_txt_me, 0,0, 
                        cc.size(item_w_words, item_h_words), 
                        cc.rect(32, 32, 6, 6)
                      )
                      :addTo(tipimg_node)
                      :align(display.LEFT_BOTTOM, 10, 150+110)

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
                  :align(display.LEFT_BOTTOM, 15, 27 +5)

          elseif seatNo == CEnumM.seatNo.R then
            local bg = display.newScale9Sprite(Imgs.words_txt_R, 0,0, 
                        cc.size(item_w_words, item_h_words), 
                        cc.rect(32, 32, 6, 6)
                      )
                      :addTo(tipimg_node)
                      :align(display.RIGHT_BOTTOM, osWidth -10, 150 +170+40)

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

          elseif seatNo == CEnumM.seatNo.M then
            local bg = display.newScale9Sprite(Imgs.words_txt_R, 0,0, 
                        cc.size(item_w_words, item_h_words), 
                        cc.rect(32, 32, 6, 6)
                      )
                      :addTo(tipimg_node)
                      :align(display.RIGHT_BOTTOM, osWidth -10 -230 +moveX_M, 150 +170 +210)
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

          elseif seatNo == CEnumM.seatNo.L then
            local bg = display.newScale9Sprite(Imgs.words_txt_L, 0,0, 
                        cc.size(item_w_words, item_h_words), 
                        cc.rect(32, 32, 6, 6)
                      )
                      :addTo(tipimg_node)
                      :align(display.LEFT_BOTTOM, 10, 150 +170+40)
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
function GameMaJiangUtil:createVoice_Anim(parent_view, seatNo, _tipimg_node)

    --print("------------------------动画已经进入", seatNo)
    local osWidth = Commons.osWidth
    local osHeight = Commons.osHeight

    if _tipimg_node ~= nil and (not tolua.isnull(_tipimg_node)) then
      _tipimg_node:stopAllActions()
      _tipimg_node:removeFromParent()
      _tipimg_node = nil
    end

    -- 图片提示
    local tipimg_node = display.newNode():addTo(parent_view, 65)
    -- local tipimg_node;

    --display.addSpriteFrames(Imgs.voiceplay_plist, Imgs.voiceplay_png) -- 语音播放动画

    local frames = display.newFrames("voiceplay%02d.png",1,3)
    local animation = display.newAnimation(frames, 0.9/3)

    _tipimg_node = display.newSprite(animation[3])

    local moveX_M = 0
    if CVar._static.isIphone4 then
        moveX_M = 65
    elseif CVar._static.isIpad then
        moveX_M = 75
    elseif CVar._static.NavBarH_Android ~= CEnum.status.NavBarH_def then
    end

    if seatNo == CEnumM.seatNo.me then -- me
        _tipimg_node:align(display.LEFT_TOP, 30, 155 +110)

    elseif seatNo == CEnumM.seatNo.R then  -- xiajia
        _tipimg_node:align(display.RIGHT_TOP, osWidth-30, 155+280+40)

    elseif seatNo == CEnumM.seatNo.M then  -- M
        _tipimg_node:align(display.RIGHT_TOP, osWidth-30 -230 +moveX_M, 155+280 +210)

    elseif seatNo == CEnumM.seatNo.L then -- lastjia
        _tipimg_node:align(display.LEFT_TOP, 30, 155+280+40)
    end
    _tipimg_node:addTo(tipimg_node)
    -- _tipimg_node:addTo(parent_view, 65)
    _tipimg_node:playAnimationForever(animation)

    return _tipimg_node
end

-- 构造函数
function GameMaJiangUtil:ctor()
end


function GameMaJiangUtil:onEnter()
end


function GameMaJiangUtil:onExit()
    
end

-- 必须有这个返回
return GameMaJiangUtil
