--
-- Author: wh
-- Date: 2017-04-21 17:11:07
--创建跑得快

-- 类申明
local base = import("app.common.net.req.RequestBase")
local RequestPDKcreateRoom = class("RequestPDKcreateRoom", base)

-- 构造函数
function RequestPDKcreateRoom:ctor()
end

function RequestPDKcreateRoom:createRoom(param,fun_back_data)
	local url = self:getHttpUrl(Https.url.createPDKroom)

	local testJsonTable = {
		status=0,
		msg=RequestBase:new():getStrEncode("ok"),
		data={
			room=
			{
				roomNo="1000",
				status="created",

				-- 有这些值，但是没有使用上
					-- playType = '16',
					-- num = 3,
					-- isDisplay = 'y',
					-- lastRule = 'limit',
					-- birdRule = 'y',
					-- payRule = 'aa',
					
					-- rounds = 20,

				roomServerUrl= RequestBase:getStrEncode("wmq.rs.yuelaigame.com"),
				roomServerPort= 8000,
				roomShareUrl= RequestBase:getStrEncode("http://wmq.yuelaigame.com/"),
			}
		}
	}

	self:HttpPost(fun_back_data, url, param, testJsonTable)
end

-- 必须有这个返回
return RequestPDKcreateRoom