
--准备按钮

local ReadyControl = class("ReadyControl",function()
    return display.newNode()
end)

function ReadyControl:ctor()
	-- self.readyBtn_= cc.ui.UIPushButton.new({normal=PDKImgs.ready_btn_nor, pressed=PDKImgs.ready_btn_pre},{scale9 = false})
	self.readyBtn_= cc.ui.UIPushButton.new( {normal=Imgs.gameing_btn_prepare, pressed=Imgs.gameing_btn_prepare_press}, {scale9 = false})
		:addTo(self)
		:onButtonClicked(function( ... )

			VoiceDealUtil:playSound_other(Voices.file.ui_click)
			self:onBtnClick(self.readyBtn_)
			
		end)
	self:hideAll()
end

function ReadyControl:onBtnClick(btn)
	
	-- local result = false
	-- if btn==self.readyBtn_ then
	-- 	-- result = self.delegate_ and self.delegate_:doUIControlAction(CEnum.playStatus.ready)
	-- end
	-- if result then
	-- 	self:hideAll()
	-- end
	--self.ctx.animManager:playNotCard()

	self.delegate_:doUIControlAction(CEnumP.CLIENT_UI_ACTION.ready)
end

function ReadyControl:hideAll()
	self.readyBtn_:hide()
end

function ReadyControl:exec(status)
	self.readyBtn_:show()
	self:show()
end

function ReadyControl:onCleanup()
	self.delegate_ = nil
end
function ReadyControl:setDelegate(delegate)
	self.delegate_ = delegate
	return self
end
return ReadyControl