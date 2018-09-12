--
-- Author: wh
-- Date: 2017-04-21 17:11:07
--创建跑得快

-- 类申明
local base = import("app.common.net.req.RequestBase")
local RequestPDKRoomResult = class("RequestPDKRoomResult", base)

-- 构造函数
function RequestPDKRoomResult:ctor()
end

-- 获取战绩 房间
function RequestPDKRoomResult:getResultRoom(param, fun_back_data)
	-- URL
	local url = self:getHttpUrl(Https.url.getPDKRecords)

	-- 参数
	--Commons:printLog_Req("假设有个table：", param)

	-- 假数据是：
	local testJsonTable = {
		status=0,
		msg=RequestBase:new():getStrEncode("ok"),
		data={
			rooms= 
			{
				{
					roomNo="1000",
					startTime="10-10 00:00:01",
					players = {
						{
							owner=true,
							user={
								nickname=RequestBase:getStrEncode("张三张三张三"),
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon1.jpg"),
							},
							score=1000,
						},
						{
							owner=false,
							user={
								nickname=RequestBase:getStrEncode("李四李四李四"),
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon2.jpg"),
							},
							score=-500,
						},
						-- {
						-- 	owner=false,
						-- 	user={
						-- 		nickname=RequestBase:getStrEncode("王五王五王五王五"),
						-- 		icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon3.jpg"),
						-- 	},
						-- 	score=-500,
						-- },
					}
				},
				{
					roomNo="1001",
					startTime="2016-10-11 00:00:01",
					players = {
						{
							owner=true,
							user={
								nickname=RequestBase:getStrEncode("张三"),
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon1.jpg"),
							},
							score=100,
						},
						{
							owner=false,
							user={
								nickname=RequestBase:getStrEncode("李四"),
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon2.jpg"),
							},
							score=-50,
						},
						{
							owner=false,
							user={
								nickname=RequestBase:getStrEncode("王五"),
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon3.jpg"),
							},
							score=-50,
						},
					}
				},
				{
					roomNo="1002",
					startTime="2016-10-11 00:00:01",
					players = {
						{
							owner=true,
							user={
								nickname=RequestBase:getStrEncode("张三1002"),
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon1.jpg"),
							},
							score=100,
						},
						{
							owner=false,
							user={
								nickname=RequestBase:getStrEncode("李四1002"),
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon2.jpg"),
							},
							score=-50,
						},
						{
							owner=false,
							user={
								nickname=RequestBase:getStrEncode("王五1002"),
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon3.jpg"),
							},
							score=-50,
						},
					}
				},
				{
					roomNo="1003",
					startTime="2016-10-11 00:00:01",
					players = {
						{
							owner=true,
							user={
								nickname=RequestBase:getStrEncode("张三1003"),
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon1.jpg"),
							},
							score=100,
						},
						{
							owner=false,
							user={
								nickname=RequestBase:getStrEncode("李四1003"),
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon2.jpg"),
							},
							score=-50,
						},
						{
							owner=false,
							user={
								nickname=RequestBase:getStrEncode("王五1003"),
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon3.jpg"),
							},
							score=-50,
						},
					}
				}
			}
		}
	}
 
	-- 发起请求
	self:HttpPost(fun_back_data, url, param, testJsonTable)
end

-- 获取战绩  回合
function RequestPDKRoomResult:getResultRound(param, fun_back_data)
	-- URL
	local url = self:getHttpUrl(Https.url.getPDKRounds)

	-- 参数
	--Commons:printLog_Req("假设有个table：", param)

	-- 假数据是：
	local testJsonTable = {
		status=0,
		msg=RequestBase:new():getStrEncode("ok"),
		data={
			rounds= 
			{
				{
					roundNo="1/10",
					startTime="10-10 00:01:01",
					players = {
						{
							owner=true,
							user={
								nickname=RequestBase:getStrEncode("张三张三张三"),
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon1.jpg"),
							},
							score=1000,
						},
						{
							owner=false,
							user={
								nickname=RequestBase:getStrEncode("李四李四李四"),
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon2.jpg"),
							},
							score=-500,
						},
						-- {
						-- 	owner=false,
						-- 	user={
						-- 		nickname=RequestBase:getStrEncode("王五王五王五王五"),
						-- 		icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon3.jpg"),
						-- 	},
						-- 	score=-500,
						-- },
					}
				},
				{
					roundNo="2/10",
					startTime="2016-10-11 00:00:01",
					players = {
						{
							owner=true,
							user={
								nickname=RequestBase:getStrEncode("张三"),
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon1.jpg"),
							},
							score=100,
						},
						{
							owner=false,
							user={
								nickname=RequestBase:getStrEncode("李四"),
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon2.jpg"),
							},
							score=-50,
						},
						-- {
						-- 	owner=false,
						-- 	user={
						-- 		nickname=RequestBase:getStrEncode("王五"),
						-- 		icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon3.jpg"),
						-- 	},
						-- 	score=-50,
						-- },
					}
				},
				{
					roundNo="3/10",
					startTime="2016-10-11 00:00:01",
					players = {
						{
							owner=true,
							user={
								nickname=RequestBase:getStrEncode("张三1002"),
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon1.jpg"),
							},
							score=100,
						},
						{
							owner=false,
							user={
								nickname=RequestBase:getStrEncode("李四1002"),
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon2.jpg"),
							},
							score=-50,
						},
						-- {
						-- 	owner=false,
						-- 	user={
						-- 		nickname=RequestBase:getStrEncode("王五1002"),
						-- 		icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon3.jpg"),
						-- 	},
						-- 	score=-50,
						-- },
					}
				},
				{
					roundNo="4/10",
					startTime="2016-10-11 00:00:01",
					players = {
						{
							owner=true,
							user={
								nickname=RequestBase:getStrEncode("张三1003"),
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon1.jpg"),
							},
							score=100,
						},
						{
							owner=false,
							user={
								nickname=RequestBase:getStrEncode("李四1003"),
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon2.jpg"),
							},
							score=-50,
						},
						-- {
						-- 	owner=false,
						-- 	user={
						-- 		nickname=RequestBase:getStrEncode("王五1003"),
						-- 		icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon3.jpg"),
						-- 	},
						-- 	score=-50,
						-- },
					}
				},
				{
					roundNo="5/10",
					startTime="2016-10-11 00:00:01",
					players = {
						{
							owner=true,
							user={
								nickname=RequestBase:getStrEncode("张三1003"),
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon1.jpg"),
							},
							score=200,
						},
						{
							owner=false,
							user={
								nickname=RequestBase:getStrEncode("李四1003"),
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon2.jpg"),
							},
							score=-100,
						},
						-- {
						-- 	owner=false,
						-- 	user={
						-- 		nickname=RequestBase:getStrEncode("王五1003"),
						-- 		icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon3.jpg"),
						-- 	},
						-- 	score=-100,
						-- },
					}
				},
				{
					roundNo="6/10",
					startTime="2016-10-11 00:00:01",
					players = {
						{
							owner=true,
							user={
								nickname=RequestBase:getStrEncode("张三1003"),
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon1.jpg"),
							},
							score=300,
						},
						{
							owner=false,
							user={
								nickname=RequestBase:getStrEncode("李四1003"),
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon2.jpg"),
							},
							score=-150,
						},
						-- {
						-- 	owner=false,
						-- 	user={
						-- 		nickname=RequestBase:getStrEncode("王五1003"),
						-- 		icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon3.jpg"),
						-- 	},
						-- 	score=-150,
						-- },
					}
				},
				{
					roundNo="7/10",
					startTime="2016-10-11 00:00:01",
					players = {
						{
							owner=true,
							user={
								nickname=RequestBase:getStrEncode("张三1003"),
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon1.jpg"),
							},
							score=3000,
						},
						{
							owner=false,
							user={
								nickname=RequestBase:getStrEncode("李四1003"),
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon2.jpg"),
							},
							score=-1500,
						},
						-- {
						-- 	owner=false,
						-- 	user={
						-- 		nickname=RequestBase:getStrEncode("王五1003"),
						-- 		icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon3.jpg"),
						-- 	},
						-- 	score=-1500,
						-- },
					}
				}

			}
		}
	}
 
	-- 发起请求
	self:HttpPost(fun_back_data, url, param, testJsonTable)
end

-- 获取战绩  回合
function RequestPDKRoomResult:getOtherResultRound(param, fun_back_data)
	-- URL
	local url = self:getHttpUrl(Https.url.getOtherPDKRounds)

	-- 参数
	--Commons:printLog_Req("假设有个table：", param)

	-- 假数据是：
	local testJsonTable = {
		status=0,
		msg=RequestBase:new():getStrEncode("ok"),
		data={
			rounds= 
			{
				{
					roundNo="1/10",
					startTime="10-10 00:01:01",
					players = {
						{
							owner=true,
							user={
								nickname=RequestBase:getStrEncode("张三张三张三"),
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon1.jpg"),
							},
							score=1000,
						},
						{
							owner=false,
							user={
								nickname=RequestBase:getStrEncode("李四李四李四"),
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon2.jpg"),
							},
							score=-500,
						},
						-- {
						-- 	owner=false,
						-- 	user={
						-- 		nickname=RequestBase:getStrEncode("王五王五王五王五"),
						-- 		icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon3.jpg"),
						-- 	},
						-- 	score=-500,
						-- },
					}
				},
				{
					roundNo="2/10",
					startTime="2016-10-11 00:00:01",
					players = {
						{
							owner=true,
							user={
								nickname=RequestBase:getStrEncode("张三"),
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon1.jpg"),
							},
							score=100,
						},
						{
							owner=false,
							user={
								nickname=RequestBase:getStrEncode("李四"),
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon2.jpg"),
							},
							score=-50,
						},
						-- {
						-- 	owner=false,
						-- 	user={
						-- 		nickname=RequestBase:getStrEncode("王五"),
						-- 		icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon3.jpg"),
						-- 	},
						-- 	score=-50,
						-- },
					}
				}

			}
		}
	}
 
	-- 发起请求
	self:HttpPost(fun_back_data, url, param, testJsonTable)
end

function RequestPDKRoomResult:getResultRound_Detail(param,fun_back_data)
	local url = self:getHttpUrl(Https.url.getPDKRoundsDetail)

	-- 参数
	--Commons:printLog_Req("假设有个table：", param)

	-- 假数据是：
	local testJsonTable = 
	{
		status=0,
		msg=RequestBase:new():getStrEncode("ok"),
		data={
			roundRecords = ParseBase.new():parseToJsonObj( PDKSocketResponseDataTest:gameOver() ).data
		}
	}
 
	-- 发起请求
	self:HttpPost(fun_back_data, url, param, testJsonTable)
end

function RequestPDKRoomResult:getOtherResultRound_Detail(param,fun_back_data)
	local url = self:getHttpUrl(Https.url.getOtherPDKRoundsDetail)

	-- 参数
	--Commons:printLog_Req("假设有个table：", param)

	-- 假数据是：
	local testJsonTable = 
	{
		status=0,
		msg=RequestBase:new():getStrEncode("ok"),
		data={
			roundRecords = ParseBase.new():parseToJsonObj( PDKSocketResponseDataTest:gameOver() ).data
		}
	}
 
	-- 发起请求
	self:HttpPost(fun_back_data, url, param, testJsonTable)
end

function RequestPDKRoomResult:getPDKGameingMirror(param,fun_back_data)
	local url = self:getHttpUrl(Https.url.getPDKGameingMirror)

	local testJsonTable = {
		status=0,
		msg=RequestBase:new():getStrEncode("ok"),
		data={
			-- playbacksUrl = RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/test/mirrorData_pdk.json")
			playbacksUrl = RequestBase:getStrEncode("http://shimen.pdk.pbres.funnycome.com/playbacks/20170705/874390_044aced5-d11a-42ae-983e-ea86bedfc53c_6108054.json")
		}
	}

	self:HttpPost(fun_back_data, url, param, testJsonTable)
end

function RequestPDKRoomResult:getOtherPDKGameingMirror(param,fun_back_data)
	local url = self:getHttpUrl(Https.url.getOtherPDKGameingMirror)

	local testJsonTable = {
		status=0,
		msg=RequestBase:new():getStrEncode("ok"),
		data={
			-- playbacksUrl = RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/test/mirrorData_pdk.json")
			playbacksUrl = RequestBase:getStrEncode("http://shimen.pdk.pbres.funnycome.com/playbacks/20170705/874390_044aced5-d11a-42ae-983e-ea86bedfc53c_6108054.json")
		}
	}

	self:HttpPost(fun_back_data, url, param, testJsonTable)
end

-- 必须有这个返回
return RequestPDKRoomResult