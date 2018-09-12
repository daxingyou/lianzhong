--
-- Author: wh
-- Date: 2017-05-05 10:00:55
-- 跑得快房间(回放)


local PDKPlaybackNode = class("PDKPlaybackNode", function()
    return display.newScene("PDKPlaybackNode")
end)



function PDKPlaybackNode:ctor(fileNameShort, startTime)

  self.startTime = startTime -- 传入的游戏开始时间
  self.fileNameShort_ = fileNameShort -- 传入的游戏数据json
 
	-- 整个底色背景
	display.newSprite(PDKImgs.room_bg)
  		:center()
  		:addTo(self)

  self.controller = PDKPlaybackController.new(self, self.startTime)
  self.ctx = self.controller.ctx

  -- 控制手牌是否可以触摸
	self.touchLayer_ = display.newLayer()
  self:addChild(self.touchLayer_)
  self:setNodeEventEnabled(true)

  -- 创建页面布局
  self.controller:createNodes()

  self.dragCard_ = CardListView.new(2,30)
  self:addChild(self.dragCard_) 
  self.controller.mycardView:setDragCard(self.dragCard_)
  -- self.controller.mycardView:setCard(list)
  -- self.controller.mycardView:rePositonCard()

  -- 倒计时层
  self.clockNode = display.newNode()
      :addTo(self)


  local pop_window = display.newColorLayer(cc.c4b(0, 0, 0, 0))       -- 半透明的黑色
  pop_window:setContentSize(osWidth, osHeight)             -- 设置Layer的大小,全屏出现
  pop_window:setTouchEnabled(true)
  pop_window:setTouchSwallowEnabled(true)  -- 吞噬下层的响应
  pop_window:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event) -- 点击此Layer时候输出信息,然后把自己销毁
     
      return true
  end)
  pop_window:addTo(self, CEnum.ZOrder.common_dialog)


  self.res_data_ = ParseBase:parseToJsonObj(self.fileNameShort_)  -- json转为对象
  self.totalIndex_ = #self.res_data_
  self.currentIndex_ = 0
  self:createAction() -- 去执行数据回放


  -- 回放界面特有的控制按钮
  -- 所有按钮的背景
  local playback_bg = display.newSprite(PDKImgs.playback_bg)
      :addTo(pop_window)
      :pos(display.cx,display.cy+90)

  -- 暂停
  self.pauseBtn_ = cc.ui.UIPushButton.new({normal = Imgs.gamemirror_2pause,pressed = Imgs.gamemirror_2pause},{scale9 = false})
      :addTo(playback_bg)
      :onButtonClicked(function( ... )

          VoiceDealUtil:playSound_other(Voices.file.ui_click)
          self:stopAction(self.action_)
          self.action_ = nil

          self.againBtn_:show()
          self.pauseBtn_:hide()

      end)
      :pos(120-30,116/2)

  -- 播放
  self.againBtn_ = cc.ui.UIPushButton.new({normal = Imgs.gamemirror_2on,pressed = Imgs.gamemirror_2on},{scale9 = false})
      :addTo(playback_bg)
      :onButtonClicked(function( ... )

          VoiceDealUtil:playSound_other(Voices.file.ui_click)

          if self.currentIndex_ == 0 then
            self.controller:clearCurTableStatus()
            self.controller.showCardsManager:cleanAllCard()
            self.controller.mycardView:setIsSeted(false)
            self.controller:dispose()
          end

          if self.action_ == nil then
            self:createAction()
          end

          self.againBtn_:hide()
          self.pauseBtn_:show()

      end)
      :pos(120-30,116/2)
      :hide()

  -- 返回退出
  cc.ui.UIPushButton.new({normal = Imgs.gamemirror_4back,pressed = Imgs.gamemirror_4back},{scale9 = false})
      :addTo(playback_bg)
      :onButtonClicked(function( ... )

          VoiceDealUtil:playSound_other(Voices.file.ui_click)
          self:stopAction(self.action_)
          self.action_ = nil
          self:onExit()
          self:removeFromParent()

      end)
      :pos(120-30+120,116/2)

end

function PDKPlaybackNode:createAction()
  self.action_ = self:schedule( handler(self,self.doAction), 1.1)
end

function PDKPlaybackNode:doAction()
    self.currentIndex_=self.currentIndex_+1
    self.controller:doAction({data = self.res_data_[self.currentIndex_]})
    
    if self.currentIndex_ >= self.totalIndex_ then
        self:stopAction(self.action_)
        self.action_ = nil

        self.againBtn_:show()
        self.pauseBtn_:hide()
        self.currentIndex_ = 0
    end
end


function PDKPlaybackNode:onExit()
    self.controller:dispose()
end

function PDKPlaybackNode:onEnter()
    self.touchLayer_:addNodeEventListener(cc.NODE_TOUCH_EVENT, 
      function(event)
        return self:onTouch(event)
      end
    )
end

function PDKPlaybackNode:onTouch(event)
  if self.controller and self.controller.mycardView then
	   return self.controller.mycardView:onTouch(event)
  end

  return nil
end

return PDKPlaybackNode