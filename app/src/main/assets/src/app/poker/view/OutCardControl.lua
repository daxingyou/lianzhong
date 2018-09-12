
--出牌按钮

local OutCardControl = class("OutCardControl",function()
    return display.newNode()
end)

function OutCardControl:ctor()
	self.outCardBtn_= cc.ui.UIPushButton.new({normal=PDKImgs.outCard_btn_nor, pressed=PDKImgs.outCard_btn_pre},{scale9 = false})
	 :addTo(self)
	 :onButtonClicked(function( ... )
	 		 VoiceDealUtil:playSound_other(Voices.file.ui_click)
			self:onBtnClick(self.outCardBtn_)
	end)

	self.tipBtn_= cc.ui.UIPushButton.new({normal=PDKImgs.tip_btn_nor, pressed=PDKImgs.tip_btn_pre},{scale9 = false})
	 :addTo(self)
	 :onButtonClicked(function( ... )
	 		 VoiceDealUtil:playSound_other(Voices.file.ui_click)
			self:onBtnClick(self.tipBtn_)
	end)
	
	self:hideAll()
end

function OutCardControl:onBtnClick(btn)
	
	-- local result = false
	if btn==self.outCardBtn_ then
		self.delegate_:doUIControlAction(CEnumP.CLIENT_UI_ACTION.outCard)
	end

	if btn == self.tipBtn_ then
		self.delegate_:doUIControlAction(CEnumP.CLIENT_UI_ACTION.cardTip)
	end
	-- if result then
	-- 	self:hideAll()
	-- end
end

function OutCardControl:hideAll()
	self.tipBtn_:hide()
	self.outCardBtn_:hide()
end

function OutCardControl:exec(status)
	
	if status == 1 then
		self:show()
		self.tipBtn_:show()
		self.outCardBtn_:show()
		self.tipBtn_:setPositionX(-150)
		self.outCardBtn_:setPositionX(150)
	else
		self:hideAll()
		self:show()
		self.outCardBtn_:show()
		self.outCardBtn_:setPositionX(0)
	end
end

function OutCardControl:onCleanup()
	self.delegate_ = nil
end
function OutCardControl:setDelegate(delegate)
	self.delegate_ = delegate
	return self
end
return OutCardControl