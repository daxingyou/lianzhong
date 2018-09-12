
--微信邀请按钮

local WeChatInviteControl = class("WeChatInviteControl",function()
    return display.newNode()
end)

function WeChatInviteControl:ctor()
	-- self.inviteBtn_ = cc.ui.UIPushButton.new({normal=PDKImgs.wechat_invite_btn_nor, pressed=PDKImgs.wechat_invite_btn_pre},{scale9 = false})
	self.inviteBtn_= cc.ui.UIPushButton.new({ normal=Imgs.gameing_btn_invite, pressed=Imgs.gameing_btn_invite_press },{scale9 = false})
		:addTo(self)
		:onButtonClicked(function( ... )
	 		VoiceDealUtil:playSound_other(Voices.file.ui_click)
			self:onBtnClick(self.inviteBtn_)
		end)
	-- 复制按钮，主要是复制房间游戏信息
	cc.ui.UIPushButton.new(
        Imgs.gameing_btn_copy_nor,{scale9=false})
        :setButtonImage(EnStatus.pressed, Imgs.gameing_btn_copy_pre)
        :onButtonClicked(function(e)
        	
        	VoiceDealUtil:playSound_other(Voices.file.ui_click)
            self:onBtnClickTxt()

        end)
        :align(display.CENTER, 0, 96)
        :addTo(self.inviteBtn_)
	
	self:hideAll()
end

function WeChatInviteControl:onBtnClick(btn)
	
	-- local result = false
	-- if btn==self.inviteBtn_ then
	-- 	-- result = self.delegate_ and self.delegate_:doUIControlAction(CEnum.playStatus.ready)
	-- end
	-- if result then
	-- 	self:hideAll()
	-- end
	self.delegate_:doUIControlAction(CEnumP.CLIENT_UI_ACTION.weChatInvite)
end

function WeChatInviteControl:onBtnClickTxt()
	self.delegate_:doUIControlAction(CEnumP.CLIENT_UI_ACTION.weChatInviteTxt)
end

function WeChatInviteControl:hideAll()
	self.inviteBtn_:hide()
end

function WeChatInviteControl:exec(status)
	self.inviteBtn_:show()
	self:show()
end

function WeChatInviteControl:onCleanup()
	self.delegate_ = nil
end
function WeChatInviteControl:setDelegate(delegate)
	self.delegate_ = delegate
	return self
end
return WeChatInviteControl