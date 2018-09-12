--
-- Author: lte
-- Date: 2016-10-14 19:18:29
--

SocketMsg = class("SocketMsg")
--SocketMsg = {}

net = require("framework.cc.net.init")
cc.utils = require("framework.cc.utils.init")

index10001 = 1

local isConnected  = false   --是否已建立连接
local isConnecting = false   --是否真正建立连接
local isInited     = false   --是否初始化过连接


-- 消息体长度占4个字节
SocketMsg.BODY_LEN = 4


local ip = nil
local port = nil
-- 数据缓存
local buf = cc.utils.ByteArrayVarint.new(cc.utils.ByteArrayVarint.ENDIAN_BIG)

local Fun_Back_Data; -- 通配的返回函数申明

function SocketMsg:getConnected()
	return isConnected
end

function SocketMsg:init()
	Commons:printLog_SocketReq("SocketMsg:init！！！")
	local time = net.SocketTCP.getTime()
	Commons:printLog_SocketReq("socket time：" .. time)


	local socket = net.SocketTCP.new()
	socket:setName("mySocketTcp") -- socket名称
	--socket:setTickTime(0.1) -- 等待服务器返回数据时间
	socket:setReconnTime(2) -- 等待服务器重连时间
	socket:setConnFailTime(1) -- 等待服务器连接失败时间


	--Commons:printLog_SocketReq("socket version is："..net.SocketTCP._VERSION)
	net.SocketTCP._DEBUG = true


	socket:addEventListener(net.SocketTCP.EVENT_DATA, handler(self, self.tcpReceiveData))
	socket:addEventListener(net.SocketTCP.EVENT_CLOSE, handler(self, self.tcpClose))
	socket:addEventListener(net.SocketTCP.EVENT_CLOSED, handler(self, self.tcpClosed))
	socket:addEventListener(net.SocketTCP.EVENT_CONNECTED, handler(self, self.tcpConnected))
	socket:addEventListener(net.SocketTCP.EVENT_CONNECT_FAILURE, handler(self, self.tcpConnectedFail))


	self.socket_ = socket

	--[[
        local socks = Sockets.new()
        local mySocket =  SocketTCP.new(socks.ip, socks.port, socks.isReconnect);

        local function onStatus(event)
            Commons:printLog_SocketReq("Socket status: %s", event.name)

            if event.name == SocketTCP.EVENT_CONNECTED then
                mySocket:send(ByteArray.new():writeString("Hello server, i'm SocketTCP"):getPack())
            end
            if event.name == SocketTCP.EVENT_DATA then
                Commons:printLog_SocketReq("Socket Receive data:%s", event.data)
            end
            if event.name == SocketTCP.EVENT_CLOSE then
                Commons:printLog_SocketReq("Socket Close")
            end
            if event.name == SocketTCP.EVENT_CLOSED then
                -- relese for the safty
                mySocket = nil
            end
        end            

        mySocket:addEventListener(SocketTCP.EVENT_CONNECTED, onStatus);
        mySocket:addEventListener(SocketTCP.EVENT_CONNECTED, onStatus)
        mySocket:addEventListener(SocketTCP.EVENT_CLOSE, onStatus)
        mySocket:addEventListener(SocketTCP.EVENT_CLOSED, onStatus)
        mySocket:addEventListener(SocketTCP.EVENT_CONNECT_FAILURE, onStatus)
        mySocket:addEventListener(SocketTCP.EVENT_DATA, onStatus)

        mySocket:connect();
        self._socket = mySocket;
    --]]
end

function SocketMsg:Connect(_ip, _port, fun_back_data)
    if CEnum.Environment.Current ~= nil and CEnum.Environment.Current == CEnum.EnvirType.Http then -- 正式环境
		Fun_Back_Data = fun_back_data;

		Commons:printLog_SocketReq("SocketMsg:Connect！！！")
		isConnecting  = true
		if isInited == false then  --
			isInited = true
			self:init()
		end
		ip = _ip
		port = _port
		Commons:printLog_SocketReq("开始去建立socket连接...")
		self.socket_:connect(ip, port, Sockets.isReconnect)
	else
		Fun_Back_Data = fun_back_data;
	end
end

--type 消息类型
function SocketMsg:SendSokcetDataString(_data) 
	-- local s = json.encode(_data)
	-- if Globe_print then
	-- 		Commons:printLog_SocketReq("发送消息" ..  _data["cmd"] .. "==具体参数" ..s)  -- for test lz
	-- end
	
	if type(_data) == "string" then
		local msg_byte = cc.utils.ByteArray.new()
		msg_byte:writeString(_data .. "\n")
		--Commons:printLog_SocketReq("发送数据 dada is：".._data)
		if self.socket_ ~= nil and self.socket_.isConnected then    -- 
			-- self.socket_:send(_data)
			-- self.socket_:send(msg_byte:getPack(1, msg_byte:getAvailable()))
			self.socket_:send(msg_byte:getPack())
			--Commons:printLog_SocketReq("发送数据 the pack is："..msg_byte:getPack())
		else
			Commons:printLog_SocketReq("socket 已经断开，正在重新连接! ")
			-- self.socket_:connect(ip, port, Sockets.isReconnect)
		end
	end	
end


--type 消息类型
function SocketMsg:SendSokcetData(_data,type) 
	-- local s = json.encode(_data)
	-- if Globe_print then
	-- Commons:printLog_SocketReq("发送消息" ..  _data["cmd"] .. "==具体参数" ..s)  -- for test lz
	-- end
	local c_byte = cc.utils.ByteArray.new(cc.utils.ByteArrayVarint.ENDIAN_BIG)
	c_byte:writeStringBytes(_data)
	c_byte:setPos(1)


	local content_len = c_byte:getAvailable()
	Commons:printLog_SocketReq("the content_len is："..content_len)
	local msg_byte = cc.utils.ByteArray.new(cc.utils.ByteArrayVarint.ENDIAN_BIG)
	-- msg_byte:writeUInt(content_len)
	msg_byte:writeUShort(content_len+4)
	msg_byte:writeUShort(type)
	msg_byte:writeStringBytes(_data)
	-- msg_byte:writeString(s)
	-- msg_byte:setPos(1)

	--Commons:printLog_SocketReq("发送数据 dada is：".._data)
	if self.socket_ ~= nil and self.socket_.isConnected then    -- 
		-- self.socket_:send(_data)
		-- self.socket_:send(msg_byte:getPack(1, msg_byte:getAvailable()))
		self.socket_:send(msg_byte:getPack())
		Commons:printLog_SocketReq("发送数据 the pack is："..msg_byte:getPack())
	else
		Commons:printLog_SocketReq("socket 已经断开，正在重新连接! ")
		--self.socket_:connect(ip, port, Sockets.isReconnect)
	end
end


function SocketMsg:CloseSocket()
	if CEnum.Environment.Current ~= nil and CEnum.Environment.Current == CEnum.EnvirType.Http then -- 正式环境
		if self.socket_ ~= nil and self.socket_.isConnected then
			self.socket_:close()
			self.socket_:disconnect()
			self.socket_ = nil
			isConnected  = false   --是否已建立连接
			isConnecting = false   --是否真正建立连接
			isInited     = false   --是否初始化过连接
		end
	end
end


function SocketMsg.getBaseBA()
	return cc.utils.ByteArrayVarint.new(cc.utils.ByteArrayVarint.ENDIAN_BIG)
end


local function _tick(msg)
	local __msgs = {}
	Commons:printLog_SocketReq("buf len is："..buf:getLen())
	buf:setPos(buf:getLen()+1)
	buf:writeBuf(msg)
	buf:setPos(1)

	while buf:getAvailable() >= SocketMsg.BODY_LEN do 
		local bodyLen = buf:readUShort()
		Commons:printLog_SocketReq("bodyLen length is："..bodyLen)
		local len2 = buf:readUShort()
		    Commons:printLog_SocketReq("the data type is："..len2)
		if buf:getAvailable() < bodyLen-4 then
			buf:setPos(buf:getPos() - SocketMsg.BODY_LEN)
			break
		end
		Commons:printLog_SocketReq("the data is："..buf:readStringBytes(bodyLen-4))
		local len3 = buf:getAvailable()
		Commons:printLog_SocketReq("the data len3 is："..len3)
		-- __msgs[#__msgs+1] = buf:readStringBytes(bodyLen)
	end

	if buf:getAvailable() <= 0 then
		buf = SocketMsg.getBaseBA()
	else
		local __tmp = SocketMsg.getBaseBA()
		buf:readBytes(__tmp, 1, buf:getAvailable())
		buf = __tmp
	end

	return __msgs
end

local needConnectTxt = ""
function SocketMsg:tcpReceiveData(event)
    --Commons:printLog_SocketReq("socket 服务器来数据啦！！！")
    --dump(event,"socket 服务器来数据啦！！！")
	if CEnum.Environment.Current ~= nil and CEnum.Environment.Current == CEnum.EnvirType.Http then -- 正式环境
		--local msgs = _tick(event.data)
		--print_lua_table(msgs)
		if event.data ~= nil then
			-- local jsonTable = {
			-- 	status=0,
			-- 	msg="connected_receiveData"
			-- }
			--Commons:printLog_SocketReq("event.data是什么格式：", type(event.data))
			local txt = event.data
			--Commons:printLog_SocketReq("======11111111111111111===============================", txt)

			if Commons:checkIsNull_str(txt) then
				-- local isFindTxt = string.find(txt,"\n")
				-- Commons:printLog_SocketReq("====是否找到结束符：", isFindTxt)
				-- if isFindTxt ~= nil and isFindTxt ~= -1 then
				-- 	if Commons:checkIsNull_str(needConnectTxt) then
				-- 		txt = needConnectTxt .. txt
				-- 		needConnectTxt = ""
				-- 	end
				-- else
				-- 	needConnectTxt = needConnectTxt .. txt
				-- 	return
				-- end
				--Commons:printLog_SocketReq("========最后组装好的txt===============", txt)

				local _n = string.split(txt, "\n")
				if type(_n)=="table" then
					local _size = #_n
					if _size > 1 then
						for k,v in pairs(_n) do
							--Commons:printLog_SocketReq("======333333333333 大于1条===============================", k, v)

							local nOutTxt = "";
							if k == 1 and Commons:checkIsNull_str(v) then
								-- 第1条
								if Commons:checkIsNull_str(needConnectTxt) then
									needConnectTxt = needConnectTxt .. v
									nOutTxt = needConnectTxt
									needConnectTxt = ""
								else
									nOutTxt = v
								end

							elseif k == _size and Commons:checkIsNull_str(v) then
								-- 最大1条
								if Commons:checkIsNull_str(needConnectTxt) then
									needConnectTxt = needConnectTxt .. v
									nOutTxt = needConnectTxt
									needConnectTxt = ""
								else
									nOutTxt = v
								end
							else
								-- 中间任意条
								nOutTxt = v
							end

							if Commons:checkIsNull_str(nOutTxt) then
								Fun_Back_Data(EnStatus.connected_receiveData, nOutTxt)
							end
						end
					elseif _size == 1 then
						for k,v in pairs(_n) do
							--Commons:printLog_SocketReq("======333333333333 =1条还mei有换行===============================", k, v)
							needConnectTxt = needConnectTxt .. v
						end
					end
				else
					--Commons:printLog_SocketReq("======4444444444444===============================")
					Fun_Back_Data(EnStatus.connected_receiveData, txt)
				end
			end

			--Fun_Back_Data(EnStatus.connected_receiveData, event.data)
			
			-- Commons:printLog_SocketReq("接收到的数据  data is "..event.data)
			-- local data =  cjson.decode(event.data)
			-- if conditions then
			-- end
			-- Event_dispatchEvent(data.cmd,data)
		else
			Commons:printLog_SocketReq("SocketMsg:tcpReceiveData is nil！！！")
		end
	else
		-- local txt = event
		-- --Commons:printLog_SocketReq("========11111111===============", txt)
		-- --txt = txt .. "\n" .. '{"status":100,"cmd":3000}'
		-- --Commons:printLog_SocketReq("=========2222222222==============", txt)

		-- if Commons:checkIsNull_str(txt) then
		-- 	-- local isFindTxt = string.find(txt,"\n")
		-- 	-- Commons:printLog_SocketReq("====是否找到结束符：", isFindTxt)
		-- 	-- if isFindTxt ~= nil and isFindTxt ~= -1 then
		-- 	-- 	if Commons:checkIsNull_str(needConnectTxt) then
		-- 	-- 		txt = needConnectTxt .. txt
		-- 	-- 		needConnectTxt = ""
		-- 	-- 	end
		-- 	-- else
		-- 	-- 	needConnectTxt = needConnectTxt .. txt
		-- 	-- 	return
		-- 	-- end
		-- 	--Commons:printLog_SocketReq("========最后组装好的txt===============", txt)

		-- 	local _n = string.split(txt, "\n")
		-- 	if type(_n)=="table" then
		-- 		local _size = #_n
		-- 		if _size > 1 then
		-- 			for k,v in pairs(_n) do
		-- 				Commons:printLog_SocketReq("======333333333333 大于1条===============================", k, v)

		-- 				local nOutTxt = "";
		-- 				if k == 1 and Commons:checkIsNull_str(v) then
		-- 					-- 第1条
		-- 					if Commons:checkIsNull_str(needConnectTxt) then
		-- 						needConnectTxt = needConnectTxt .. v
		-- 						nOutTxt = needConnectTxt
		-- 						needConnectTxt = ""
		-- 					else
		-- 						nOutTxt = v
		-- 					end

		-- 				elseif k == _size and Commons:checkIsNull_str(v) then
		-- 					-- 最大1条
		-- 					if Commons:checkIsNull_str(needConnectTxt) then
		-- 						needConnectTxt = needConnectTxt .. v
		-- 						nOutTxt = needConnectTxt
		-- 						needConnectTxt = ""
		-- 					else
		-- 						nOutTxt = v
		-- 					end
		-- 				else
		-- 					-- 中间任意条
		-- 					nOutTxt = v
		-- 				end

		-- 				if Commons:checkIsNull_str(nOutTxt) then
		-- 					Fun_Back_Data(EnStatus.connected_receiveData, nOutTxt)
		-- 				end
		-- 			end
		-- 		elseif _size == 1 then
		-- 			for k,v in pairs(_n) do
		-- 				Commons:printLog_SocketReq("======333333333333 =1条还mei有换行===============================", k, v)
		-- 				needConnectTxt = needConnectTxt .. v
		-- 			end
		-- 		end
		-- 	else
		-- 		Commons:printLog_SocketReq("======4444444444444===============================")
		-- 		Fun_Back_Data(EnStatus.connected_receiveData, txt)
		-- 	end
		-- end

		Fun_Back_Data(EnStatus.connected_receiveData, event)
	end
end


function SocketMsg:tcpClose()
	Commons:printLog_SocketReq("socket连接即将关闭！！！")

	local jsonTable = {
		status=0,
		msg="connected_close"
	}
	Fun_Back_Data(EnStatus.connected_close, ParseBase:parseToJsonString(jsonTable) )
end

function SocketMsg:tcpClosed()
	Commons:printLog_SocketReq("socket连接已经关闭！！！")

	isInited = false   --是否初始化过连接

	local jsonTable = {
		status=0,
		msg="connected_closed"
	}
	Fun_Back_Data(EnStatus.connected_closed, ParseBase:parseToJsonString(jsonTable) )
end


function SocketMsg:tcpConnected()
	Commons:printLog_SocketReq("socket连接建立成功！！！")
	isConnected  = true
	--self:SendSokcetData("wo shi shei",1000)

	local jsonTable = {
		status=0,
		msg="connected_succ"
	}
	Fun_Back_Data(EnStatus.connected_succ, ParseBase:parseToJsonString(jsonTable) )
end


function SocketMsg:tcpConnectedFail()
	Commons:printLog_SocketReq("socket连接已经断开！！！")

	isInited = false   --是否初始化过连接

	local jsonTable = {
		status=0,
		msg="connected_fail"
	}
	Fun_Back_Data(EnStatus.connected_fail, ParseBase:parseToJsonString(jsonTable) )
end


-- 构造函数
function SocketMsg:ctor()
	Commons:printLog_SocketReq("SocketMsg:ctor()！！！")
end


function SocketMsg:onEnter()
	Commons:printLog_SocketReq("SocketMsg:onEnter()！！！")
end


function SocketMsg:onExit()
	Commons:printLog_SocketReq("SocketMsg:onExit()！！！")
	if CEnum.Environment.Current ~= nil and CEnum.Environment.Current == CEnum.EnvirType.Http then -- 正式环境
		-- if self.socket_.isConnected then
		-- 	self.socket_:close()
		-- 	self.socket_:disconnect()
		-- 	--self.socket_ = nil
		-- end
		SocketMsg:CloseSocket()
	end
end


return SocketMsg