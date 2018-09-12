--[
-- Author: wh
-- Date: 2017-05-08 19:40:54
--	玩家管理器
--
--]
local RoomSeat = import(".view.RoomSeat")

local RoomPlayerManager = class("RoomPlayerManager")

function RoomPlayerManager:ctor()
	
end

function RoomPlayerManager:createNodes()
	if self.nodes_ and self.nodes_:getParent() then
		self.nodes_:removeFromParentAndCleanup(true)
		self.nodes_ = nil
	end
	--创建一个玩家座位节点
	self.nodes_ = display.newNode()
		:addTo(self.ctx.scene)

	--客户端座位编号： 1-3，1为自己，2为右边玩家，3为左边玩家
	self.playerList_ = {}
	local playerHead = nil
	for i=1,3,1 do

		-- local user_rights = ""
		-- if i and i == CEnumP.seatNo.me then
		-- 	local user = GameStateUserInfo:getData()
		-- 	user_rights = user[User.Bean.rights]
		-- end
		-- print("==111==================================================user_rights==", user_rights, i)

		playerHead = RoomSeat.new(self.ctx, i)
		playerHead:addTo(self.nodes_)

		-- cc.EventProxy.new(playerHead, self.ctx.scene)
 		--    :addEventListener(RoomSeat.CLICKED, handler(self, self.onSeatClicked_))
		--playerHead:scale(0.4)
		self.playerList_[i] = playerHead
		if i==CEnumP.seatNo.me then
			--playerHead:align(display.LEFT_BOTTOM,60,130)
			playerHead:align(display.LEFT_BOTTOM, 60, 310)
			--playerHead:setData({name = "Thinker",score = "2523"})
		elseif i== CEnumP.seatNo.R then
			playerHead:align(display.RIGHT_TOP,display.width-60,display.height-120)
			--playerHead:showCards(12)
			--playerHead:setData({name = "Terry",score = "6531"})
		else
			playerHead:align(display.LEFT_TOP,60,display.height-120)
			--playerHead:showCards(14)
			--playerHead:setData({name = "JiaPiPi",score = "2531"})
		end
		playerHead:hide()
	end


	--self:setDealer(2)
	-- CDAlertIP:popDialogBox(Layer1, user_icon, user_nickname, user_account, user_ip, user_rights)
end

function function_name( ... )
	-- body
end

function RoomPlayerManager:onSeatClicked_()
	-- local icon = "https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1494228502&di=fe7de6775d0df07932a2f88d171754cd&src=http://d.hiphotos.baidu.com/zhidao/pic/item/b21bb051f8198618c59dcb8b42ed2e738ad4e6e3.jpg"
	-- CDAlertIP:popDialogBox(self.ctx.scene, icon, "thinekr", "1", "12:12:12:12", "1")
end
function RoomPlayerManager:dispose()
end


function RoomPlayerManager:init()
end

--登陆
function RoomPlayerManager:dealUserLogin()

end
--登出
function RoomPlayerManager:dealUserLogout()
	local model = self.ctx.model
	local serverPlayerList = model:getPlayerList()
	for i=1,#self.playerList_ do
		self.playerList_[i]:hide()
	end
	for i=1,#serverPlayerList do
		local tempSeatId = model:getOtherClientSeatId(serverPlayerList[i].seatNo)
		self.playerList_[tempSeatId]:show()
	end
end

--托管AI
function RoomPlayerManager:dealUserAI(seatId,type)

end

--设置自己
function RoomPlayerManager:setSelf(data)
	if data == nil then return end
	if data.user == nil then return end
	self.playerList_[CEnumP.seatNo.me]:show()
	self.playerList_[CEnumP.seatNo.me]:setData(data)
end

--座位信息初始化
function RoomPlayerManager:init()
	
	local model = self.ctx.model
	local serverPlayerList = model:getPlayerList()
	self:setSelf(model:getSelfSeatData())

	for i=1,#serverPlayerList do
		if serverPlayerList[i].me ~= true then
			local tempSeatId = model:getOtherClientSeatId(serverPlayerList[i].seatNo)
			self.playerList_[tempSeatId]:show()
			if  serverPlayerList[i].user then
				self.playerList_[tempSeatId]:setData(serverPlayerList[i])
			end

			if tempSeatId ~= CEnumP.seatNo.me then 
				if serverPlayerList[i].leftCardCount > 0  then
					self.playerList_[tempSeatId]:showCards(serverPlayerList[i].leftCardCount)
				end
			end 
		end
	end
end

--显示牌
function RoomPlayerManager:showAllLeftCards()
	local model = self.ctx.model
	local serverPlayerList = model:getPlayerList()
	for i=1,#serverPlayerList do
		if serverPlayerList[i].me ~= true then
			local tempSeatId = model:getOtherClientSeatId(serverPlayerList[i].seatNo)
			if tempSeatId ~= CEnumP.seatNo.me then 
				if serverPlayerList[i].leftCardCount > 0  then
					self.playerList_[tempSeatId]:showCards(serverPlayerList[i].leftCardCount)
				end
			end 
		end
	end
end
--隐藏牌数字
function RoomPlayerManager:hideAllCards()
	for i=1,3 do
		self.playerList_[i]:hideCards()
	end
end
--刷新分数
function RoomPlayerManager:upDateScore()
	local model = self.ctx.model
	local serverPlayerList = model:getPlayerList()

	for i=1,#serverPlayerList do
		local tempSeatId = model:getOtherClientSeatId(serverPlayerList[i].seatNo)
		self.playerList_[tempSeatId]:upDateScore(serverPlayerList[i])
	end
end
--设置庄家
function RoomPlayerManager:setDealer()
	local model = self.ctx.model
	local serverPlayerList = model:getPlayerList()
	local dealerSeat = 0
	for i=1,#serverPlayerList do
		--if serverPlayerList[i].me ~= true then
		local tempSeatId = model:getOtherClientSeatId(serverPlayerList[i].seatNo)
			if serverPlayerList[i].role == "z"  then
				dealerSeat = tempSeatId
			end		 
		--end
	end
	for i=1,3 do
		self.playerList_[i]:setDealer(false)
	end

	if dealerSeat == 0 then  return end

	local seatPos = {
		cc.p(60, 130+20+200),
		cc.p(display.width-60, display.height-120),
		cc.p(60,display.height-120),
	}
	self.dealer_icon_ = display.newSprite(PDKImgs.dealer_icon)
		:addTo(self.nodes_)
		:pos(display.cx,display.cy)
		:setScale(1.6)

	--dump(dealerSeat,"dealerSeat")

	transition.moveTo(self.dealer_icon_, {time = .4,  x=seatPos[dealerSeat].x, y=seatPos[dealerSeat].y,  delay = .7, onComplete = function() 
		self.playerList_[dealerSeat]:setDealer(true)
		self.dealer_icon_:removeFromParent()
	end})
end
--更新玩家状态：离线，在线
function RoomPlayerManager:upDatePlayerStatus()
	local model = self.ctx.model
	local serverPlayerList = model:getPlayerList()
	local dealerSeat = 0
	for i=1,#serverPlayerList do
		local tempSeatId = model:getOtherClientSeatId(serverPlayerList[i].seatNo)
		if self.playerList_[tempSeatId] then
			self.playerList_[tempSeatId]:updateStatus(serverPlayerList[i].netStatus)
		end
	end
end
function RoomPlayerManager:dispose()
	self.playerList = nil;
end
return RoomPlayerManager