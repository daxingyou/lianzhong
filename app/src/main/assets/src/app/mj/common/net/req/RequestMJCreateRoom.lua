--
-- Author: luobinbin
-- Date: 2017-07-17 17:11:07
--创建麻将

-- 类申明
local base = import("app.common.net.req.RequestBase")
local RequestMJCreateRoom = class("RequestMJCreateRoom", base)

-- 构造函数
function RequestMJCreateRoom:ctor()
end

function RequestMJCreateRoom:createRoom(param,fun_back_data)
	local url = self:getHttpUrl(Https.url.createMJRoom)

	local testJsonTable = {
		status=0,
		msg=RequestBase:new():getStrEncode("ok"),
		data={
			-- data={
			-- 	name="lbb",idcard="430322187802123462",mobile="13430882957"
			-- },
			room={
				roomNo="1000",
				status="created",

				-- fanRule = "fan",
				-- multRule = "single",
				-- potRule = "y",
				--playType = '16',
				playerNum = 4,
				huRule = "y",
				duiRule = "n",
				gangRule = "y",
				huangRule = "n",
				rewardType = "159",
				rewardNum = 4, 
				rounds = 8,
				--isDisplay = 'y',

				roomServerUrl= RequestBase:getStrEncode("wmq.rs.yuelaigame.com"),
				roomServerPort= 8000,
				roomShareUrl= RequestBase:getStrEncode("http://wmq.yuelaigame.com/"),
			}
		}
	}

	self:HttpPost(fun_back_data, url, param, testJsonTable)
end

-- 必须有这个返回
return RequestMJCreateRoom