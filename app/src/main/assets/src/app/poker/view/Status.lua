
local Status = class("Status",function()
    return display.newNode()
end)

Status.ready = PDKImgs.room_ready --Imgs.gameing_user_prepare_ok
Status.passout = PDKImgs.room_pass_out
Status.win = PDKImgs.room_win

function Status:ctor(align)
	self.align_ = align or display.CENTER
	self.ready_ = display.newSprite(Status.ready)
		:align(self.align_)
		:addTo(self)

	self.passout_ = display.newSprite(Status.passout)
		:align(self.align_)
		:addTo(self)

	-- self.win_ = display.newSprite(Status.win)
	-- 	:align(self.align_)
	-- 	:addTo(self)
	 self:hideAll()
end

function Status:hideAll()
	self.ready_:hide()
	self.passout_:hide()
	--self.win_:hide()
end



function Status:onCleanup()
	
end

return Status