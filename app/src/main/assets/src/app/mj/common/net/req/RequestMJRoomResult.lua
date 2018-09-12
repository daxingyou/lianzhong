--
-- Author: luobinbin
-- Date: 2017-07-17 17:11:07
--创建麻将

-- 类申明
local base = import("app.common.net.req.RequestBase")
local RequestMJRoomResult = class("RequestMJRoomResult", base)

-- 构造函数
function RequestMJRoomResult:ctor()
end

-- 获取战绩 房间
function RequestMJRoomResult:getResultRoom(param, fun_back_data)
	-- URL
	local url = self:getHttpUrl(Https.url.getMJRecords)

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
						{
							owner=false,
							user={
								nickname=RequestBase:getStrEncode("王五王五王五王五"),
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon3.jpg"),
							},
							score=-500,
						},
						{
							owner=false,
							user={
								nickname=RequestBase:getStrEncode("夏雨夏雨夏雨夏雨"),
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon3.jpg"),
							},
							score=-500,
						},
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
function RequestMJRoomResult:getResultRound(param, fun_back_data)
	-- URL
	local url = self:getHttpUrl(Https.url.getMJRounds)

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
					startTime="10-10 00:00:01",
					players = {
						{
							owner=true,
							user={
								nickname=RequestBase:getStrEncode("张三张三张三"),
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/icon/guest_boy.jpg"),
							},
							score=1000,
						},
						{
							owner=false,
							user={
								nickname=RequestBase:getStrEncode("李四李四李四"),
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/icon/guest_girl.png"),
							},
							score=-500,
						},
						{
							owner=false,
							user={
								nickname=RequestBase:getStrEncode("王五王五王五王五"),
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon1.jpg"),
							},
							score=-500,
						},
						{
							owner=false,
							user={
								nickname=RequestBase:getStrEncode("夏雨夏雨夏雨夏雨"),
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon1.jpg"),
							},
							score=-500,
						},
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
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/icon/guest_boy.jpg"),
							},
							score=100,
						},
						{
							owner=false,
							user={
								nickname=RequestBase:getStrEncode("李四"),
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/icon/guest_girl.png"),
							},
							score=-50,
						},
						{
							owner=false,
							user={
								nickname=RequestBase:getStrEncode("王五"),
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon1.jpg"),
							},
							score=-50,
						},
						{
							owner=false,
							user={
								nickname=RequestBase:getStrEncode("夏雨"),
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon1.jpg"),
							},
							score=-50,
						},
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
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/icon/guest_boy.jpg"),
							},
							score=100,
						},
						{
							owner=false,
							user={
								nickname=RequestBase:getStrEncode("李四1002"),
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/icon/guest_girl.png"),
							},
							score=-50,
						},
						{
							owner=false,
							user={
								nickname=RequestBase:getStrEncode("王五1002"),
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon1.jpg"),
							},
							score=-50,
						},
						{
							owner=false,
							user={
								nickname=RequestBase:getStrEncode("夏雨"),
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon1.jpg"),
							},
							score=-50,
						},
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
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/icon/guest_boy.jpg"),
							},
							score=100,
						},
						{
							owner=false,
							user={
								nickname=RequestBase:getStrEncode("李四1003"),
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/icon/guest_girl.png"),
							},
							score=-50,
						},
						{
							owner=false,
							user={
								nickname=RequestBase:getStrEncode("王五1003"),
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon1.jpg"),
							},
							score=-50,
						},
						{
							owner=false,
							user={
								nickname=RequestBase:getStrEncode("夏雨"),
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon1.jpg"),
							},
							score=-50,
						},
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
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/icon/guest_boy.jpg"),
							},
							score=200,
						},
						{
							owner=false,
							user={
								nickname=RequestBase:getStrEncode("李四1003"),
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/icon/guest_girl.png"),
							},
							score=-100,
						},
						{
							owner=false,
							user={
								nickname=RequestBase:getStrEncode("王五1003"),
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon1.jpg"),
							},
							score=-100,
						},
						{
							owner=false,
							user={
								nickname=RequestBase:getStrEncode("夏雨"),
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon1.jpg"),
							},
							score=-50,
						},
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
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/icon/guest_boy.jpg"),
							},
							score=300,
						},
						{
							owner=false,
							user={
								nickname=RequestBase:getStrEncode("李四1003"),
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/icon/guest_girl.png"),
							},
							score=-150,
						},
						{
							owner=false,
							user={
								nickname=RequestBase:getStrEncode("王五1003"),
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon1.jpg"),
							},
							score=-150,
						},
						{
							owner=false,
							user={
								nickname=RequestBase:getStrEncode("夏雨"),
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon1.jpg"),
							},
							score=-50,
						},
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
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/icon/guest_boy.jpg"),
							},
							score=3000,
						},
						{
							owner=false,
							user={
								nickname=RequestBase:getStrEncode("李四1003"),
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/icon/guest_girl.png"),
							},
							score=-1500,
						},
						{
							owner=false,
							user={
								nickname=RequestBase:getStrEncode("王五1003"),
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon1.jpg"),
							},
							score=-1500,
						},
						{
							owner=false,
							user={
								nickname=RequestBase:getStrEncode("夏雨"),
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon1.jpg"),
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
function RequestMJRoomResult:getOtherResultRound(param, fun_back_data)
	-- URL
	local url = self:getHttpUrl(Https.url.getOtherMJRounds)

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
					startTime="10-10 00:00:01",
					players = {
						{
							owner=true,
							user={
								nickname=RequestBase:getStrEncode("张三张三张三"),
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/icon/guest_boy.jpg"),
							},
							score=1000,
						},
						{
							owner=false,
							user={
								nickname=RequestBase:getStrEncode("李四李四李四"),
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/icon/guest_girl.png"),
							},
							score=-500,
						},
						{
							owner=false,
							user={
								nickname=RequestBase:getStrEncode("王五王五王五王五"),
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon1.jpg"),
							},
							score=-500,
						},
						{
							owner=false,
							user={
								nickname=RequestBase:getStrEncode("夏雨"),
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon1.jpg"),
							},
							score=-50,
						},
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
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/icon/guest_boy.jpg"),
							},
							score=100,
						},
						{
							owner=false,
							user={
								nickname=RequestBase:getStrEncode("李四"),
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/icon/guest_girl.png"),
							},
							score=-50,
						},
						{
							owner=false,
							user={
								nickname=RequestBase:getStrEncode("王五"),
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon1.jpg"),
							},
							score=-50,
						},
						{
							owner=false,
							user={
								nickname=RequestBase:getStrEncode("夏雨"),
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon1.jpg"),
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

-- 获取战绩  回合详情
function RequestMJRoomResult:getResultRound_Detail(param, fun_back_data)
	-- URL
	local url = self:getHttpUrl(Https.url.getMJRoundsDetail)

	-- 参数
	--Commons:printLog_Req("假设有个table：", param)

	-- 假数据是：
	local testJsonTable = {
		status=0,
		msg=RequestBase:new():getStrEncode("ok"),
		data={
			-- roundRecords = '{"diCardsNum":11,"playRound":1,"playRoundNo":"b9aa8f95-ff23-405b-8066-ce13b6fb38f3","roomNo":"468260","roundRecords":[{"cardCombs":[{"cards":["anb10","anb10","anb10"],"indexNo":-1,"option":"peng","xi":3},{"cards":["ans9","ans9","ans9"],"indexNo":-1,"option":"peng","xi":2},{"cards":["anb2","anb3","anb4"],"indexNo":-1,"option":"chi","xi":0},{"cards":["bns3","bns3","bns3"],"indexNo":-1,"option":"wei","xi":3},{"cards":["ans4","ans5","ans6"],"indexNo":2,"option":"chi","xi":0},{"cards":["anb7","anb8","anb9"],"indexNo":-1,"option":"chi","xi":0},{"cards":["ans2","ans2"],"indexNo":-1,"option":"jiang","xi":2}],"diCards":["ans10","ans8","ans7","ans5","anb5","ans7","ans1","anb9","ans4","anb3","anb2"],"hu":true,"huCard":"ans6","me":false,"mts":["上下五千年 +50"],"owner":true,"role":"z","score":120,"seatNo":0,"sumXi":60,"user":{"account":"6127801","icon":"http%3A%2F%2Fwx.qlogo.cn%2Fmmopen%2FicJibovBC55clCzL1eYH2IwfvMoDINKTib6sx3ic97HhW0nvnoicbpD5X9flrZB91Y0zaAPNXmzmbZWq4shN3KH75TzicNK8jxib2IC%2F0","ip":"223.104.19.35","nickname":"%E6%89%93%E4%B8%8D%E6%AD%BB%E7%9A%84%E5%B0%8F%E5%BC%BA","sex":"female"},"xi":10},{"cardCombs":[{"cards":["ans6","ans6","ans6"],"indexNo":-1,"option":"peng","xi":2},{"cards":["ans1","anb1","anb2"],"indexNo":-1,"option":"","xi":0},{"cards":["ans2","ans2","ans3"],"indexNo":-1,"option":"","xi":0},{"cards":["anb3","ans4","ans4"],"indexNo":-1,"option":"","xi":0},{"cards":["anb4","anb5","anb7"],"indexNo":-1,"option":"","xi":0},{"cards":["ans7","anb8","ans9"],"indexNo":-1,"option":"","xi":0},{"cards":["anb9"],"indexNo":-1,"option":"","xi":0}],"hu":false,"me":false,"owner":false,"role":"x","score":-60,"seatNo":1,"sumXi":0,"user":{"account":"6763719","icon":"http%3A%2F%2Fwx.qlogo.cn%2Fmmopen%2FCsicRhyibia3ZP7Gk5Y9XoApgtBKLLpfyvsqv7XWchbQkA5BN2uDJf3RsDgvdDiaufzV4NPdIbkTtKZWXj1BnZVklNgZjvxhcjvI%2F0","ip":"119.120.54.51","nickname":"%EF%B8%B7.%E9%BB%98%E5%AE%88%E9%82%A3%E4%BB%BD%E6%83%85","sex":"male"},"xi":2},{"cardCombs":[{"cards":["ans10","ans10","ans10"],"indexNo":-1,"option":"peng","xi":3},{"cards":["ayb5","anb4","anb6"],"indexNo":-1,"option":"chi","xi":0},{"cards":["cns8","cns8","cns8"],"indexNo":-1,"option":"wei","xi":3},{"cards":["anb6","anb6","anb6"],"indexNo":-1,"option":"peng","xi":2},{"cards":["ayb9","anb7","anb8"],"indexNo":-1,"option":"chi","xi":0},{"cards":["ans1","ans1","anb7"],"indexNo":-1,"option":"","xi":0},{"cards":["anb8"],"indexNo":-1,"option":"","xi":0}],"hu":false,"me":true,"owner":false,"role":"x","score":-60,"seatNo":2,"sumXi":0,"user":{"account":"6099337","icon":"http%3A%2F%2Fwx.qlogo.cn%2Fmmopen%2FCsicRhyibia3ZP7Gk5Y9XoAprdK2Uh9DX8LHicECvFoMjeiadRUvB8OTIfwtbtUvqoBrXLdJlFgJ3eGen5jmACKDxurj0nicsFrDxW%2F0","ip":"220.202.152.18","nickname":"%E4%BB%8E%E4%BD%A0%E7%9A%84%E5%85%A8%E4%B8%96%E7%95%8C%E8%B7%AF%E8%BF%87","sex":"male"},"xi":8}],"roundStart":false,"rounds":8,"status":"started"}',
			-- roundRecords = '{"diCardsNum":13,"dlzLevel":0,"flzUnit":0,"playRound":1,"playRoundNo":"49eae347-ac1f-4809-9f44-e66e3bfb3910","players":[{"chiCombs":[["anb5","anb5","anb5"]],"chu":false,"dlzScore":0,"me":false,"owner":false,"score":-90,"seatNo":0,"xi":0},{"chiCombs":[["anb1","anb1","anb1"],["anb6","anb6","anb6"],["cfs2","cfs2","cfs2"]],"chu":false,"dlzScore":0,"me":false,"owner":false,"score":180,"seatNo":1,"xi":0},{"chiCombs":[["anb3","anb3","anb3"]],"chu":false,"dlzScore":0,"me":true,"owner":false,"score":-90,"seatNo":2,"xi":0}],"roomNo":"354057","roundRecords":[{"cardCombs":[{"cards":["anb5","anb5","anb5"],"indexNo":-1,"option":"peng","xi":2},{"cards":["ans1","ans1","anb2"],"indexNo":-1,"option":"","xi":0},{"cards":["anb3","ans4","ans4"],"indexNo":-1,"option":"","xi":0},{"cards":["anb4","ans5","ans6"],"indexNo":-1,"option":"","xi":0},{"cards":["ans6","anb6","anb7"],"indexNo":-1,"option":"","xi":0},{"cards":["anb7","ans8","ans9"],"indexNo":-1,"option":"","xi":0},{"cards":["ans10"],"indexNo":-1,"option":"","xi":0}],"dlzScore":-1,"flzScore":-1,"hu":false,"me":false,"owner":true,"role":"z","score":-90,"seatNo":0,"sumXi":0,"user":{"account":"6086357","icon":"http%3A%2F%2Fwx.qlogo.cn%2Fmmopen%2FrsA6UdvEZMIVI3DTr6f4lwgFxNhSczPibQvrpiaRBuKgM53UQZIQaib2ktKVaumaMRy4mnmZpSxh0JSQ850X0rmQsJ2Tvibf7vhA%2F0","ip":"119.44.13.95","nickname":"%E7%88%B1%E7%88%B1","sex":"female"},"xi":2},{"cardCombs":[{"cards":["anb1","anb1","anb1"],"indexNo":-1,"option":"peng","xi":2},{"cards":["anb6","anb6","anb6"],"indexNo":-1,"option":"peng","xi":2},{"cards":["cns2","cns2","cns2"],"indexNo":-1,"option":"wei","xi":4},{"cards":["ans4","ans5","ans6"],"indexNo":-1,"option":"chi","xi":0},{"cards":["anb8","anb9","anb10"],"indexNo":-1,"option":"chi","xi":0},{"cards":["ans8","ans9","ans10"],"indexNo":-1,"option":"chi","xi":0},{"cards":["ans7","ans7"],"indexNo":0,"option":"jiang","xi":2}],"diCards":["ans3","ans3","anb2","ans7","anb8","anb10","anb5","anb7","ans5","anb8","anb1","anb7","anb2"],"dlzScore":-1,"flzScore":-1,"hu":true,"huCard":"ans7","me":false,"mts":["单吊 +30","卡胡+50"],"owner":false,"role":"x","score":180,"seatNo":1,"sumXi":90,"user":{"account":"6987312","icon":"http%3A%2F%2Fwx.qlogo.cn%2Fmmopen%2FNvxFvXQCL3ia6ib85BPpWcIJLlMjRBO9ibdE5Cc7wowPoc9ibU5TINA0YUxcd5LcMicvsJdejBv1FYOUoP3aMF1UiaIQ1jvgtDQC7o%2F0","ip":"111.8.131.132","nickname":"Jason","sex":"male"},"xi":10},{"cardCombs":[{"cards":["anb3","anb3","anb3"],"indexNo":-1,"option":"peng","xi":2},{"cards":["ans1","ans1","ans2"],"indexNo":-1,"option":"","xi":0},{"cards":["ans3","ans4","ans5"],"indexNo":-1,"option":"","xi":0},{"cards":["ans6","ans7","ans8"],"indexNo":-1,"option":"","xi":0},{"cards":["ans8","anb8","anb9"],"indexNo":-1,"option":"","xi":0},{"cards":["ans9","ans10","ans10"],"indexNo":-1,"option":"","xi":0},{"cards":["anb10"],"indexNo":-1,"option":"","xi":0}],"dlzScore":-1,"flzScore":-1,"hu":false,"me":true,"owner":false,"role":"x","score":-90,"seatNo":2,"sumXi":0,"user":{"account":"6095887","icon":"http%3A%2F%2Fwx.qlogo.cn%2Fmmopen%2FrsA6UdvEZMI9WfMTicatPzbD3m3N64FyWcGh6CTKy9G4rrGaJWicEeVUChO7VIBEEziczgf9zNC2hvdXv0c3e78BNNUmw6JLzibl%2F0","ip":"223.150.154.11","nickname":"%E6%9D%8E%E7%A6%8F%E8%8D%A3","sex":"male"},"xi":2}],"roundStart":false,"rounds":8,"status":"started","surpDlzScore":-1}',
			roundRecords = ParseBase.new():parseToJsonObj( MJSocketResponseDataTest:res_gameing_Over() ).data
		}
	}
 
	-- 发起请求
	self:HttpPost(fun_back_data, url, param, testJsonTable)
end

-- 获取战绩  回合详情
function RequestMJRoomResult:getOtherResultRound_Detail(param, fun_back_data)
	-- URL
	local url = self:getHttpUrl(Https.url.getOtherMJRoundsDetail)

	-- 参数
	--Commons:printLog_Req("假设有个table：", param)

	-- 假数据是：
	local testJsonTable = {
		status=0,
		msg=RequestBase:new():getStrEncode("ok"),
		data={
			-- roundRecords = '{"diCardsNum":11,"playRound":1,"playRoundNo":"b9aa8f95-ff23-405b-8066-ce13b6fb38f3","roomNo":"468260","roundRecords":[{"cardCombs":[{"cards":["anb10","anb10","anb10"],"indexNo":-1,"option":"peng","xi":3},{"cards":["ans9","ans9","ans9"],"indexNo":-1,"option":"peng","xi":2},{"cards":["anb2","anb3","anb4"],"indexNo":-1,"option":"chi","xi":0},{"cards":["bns3","bns3","bns3"],"indexNo":-1,"option":"wei","xi":3},{"cards":["ans4","ans5","ans6"],"indexNo":2,"option":"chi","xi":0},{"cards":["anb7","anb8","anb9"],"indexNo":-1,"option":"chi","xi":0},{"cards":["ans2","ans2"],"indexNo":-1,"option":"jiang","xi":2}],"diCards":["ans10","ans8","ans7","ans5","anb5","ans7","ans1","anb9","ans4","anb3","anb2"],"hu":true,"huCard":"ans6","me":false,"mts":["上下五千年 +50"],"owner":true,"role":"z","score":120,"seatNo":0,"sumXi":60,"user":{"account":"6127801","icon":"http%3A%2F%2Fwx.qlogo.cn%2Fmmopen%2FicJibovBC55clCzL1eYH2IwfvMoDINKTib6sx3ic97HhW0nvnoicbpD5X9flrZB91Y0zaAPNXmzmbZWq4shN3KH75TzicNK8jxib2IC%2F0","ip":"223.104.19.35","nickname":"%E6%89%93%E4%B8%8D%E6%AD%BB%E7%9A%84%E5%B0%8F%E5%BC%BA","sex":"female"},"xi":10},{"cardCombs":[{"cards":["ans6","ans6","ans6"],"indexNo":-1,"option":"peng","xi":2},{"cards":["ans1","anb1","anb2"],"indexNo":-1,"option":"","xi":0},{"cards":["ans2","ans2","ans3"],"indexNo":-1,"option":"","xi":0},{"cards":["anb3","ans4","ans4"],"indexNo":-1,"option":"","xi":0},{"cards":["anb4","anb5","anb7"],"indexNo":-1,"option":"","xi":0},{"cards":["ans7","anb8","ans9"],"indexNo":-1,"option":"","xi":0},{"cards":["anb9"],"indexNo":-1,"option":"","xi":0}],"hu":false,"me":false,"owner":false,"role":"x","score":-60,"seatNo":1,"sumXi":0,"user":{"account":"6763719","icon":"http%3A%2F%2Fwx.qlogo.cn%2Fmmopen%2FCsicRhyibia3ZP7Gk5Y9XoApgtBKLLpfyvsqv7XWchbQkA5BN2uDJf3RsDgvdDiaufzV4NPdIbkTtKZWXj1BnZVklNgZjvxhcjvI%2F0","ip":"119.120.54.51","nickname":"%EF%B8%B7.%E9%BB%98%E5%AE%88%E9%82%A3%E4%BB%BD%E6%83%85","sex":"male"},"xi":2},{"cardCombs":[{"cards":["ans10","ans10","ans10"],"indexNo":-1,"option":"peng","xi":3},{"cards":["ayb5","anb4","anb6"],"indexNo":-1,"option":"chi","xi":0},{"cards":["cns8","cns8","cns8"],"indexNo":-1,"option":"wei","xi":3},{"cards":["anb6","anb6","anb6"],"indexNo":-1,"option":"peng","xi":2},{"cards":["ayb9","anb7","anb8"],"indexNo":-1,"option":"chi","xi":0},{"cards":["ans1","ans1","anb7"],"indexNo":-1,"option":"","xi":0},{"cards":["anb8"],"indexNo":-1,"option":"","xi":0}],"hu":false,"me":true,"owner":false,"role":"x","score":-60,"seatNo":2,"sumXi":0,"user":{"account":"6099337","icon":"http%3A%2F%2Fwx.qlogo.cn%2Fmmopen%2FCsicRhyibia3ZP7Gk5Y9XoAprdK2Uh9DX8LHicECvFoMjeiadRUvB8OTIfwtbtUvqoBrXLdJlFgJ3eGen5jmACKDxurj0nicsFrDxW%2F0","ip":"220.202.152.18","nickname":"%E4%BB%8E%E4%BD%A0%E7%9A%84%E5%85%A8%E4%B8%96%E7%95%8C%E8%B7%AF%E8%BF%87","sex":"male"},"xi":8}],"roundStart":false,"rounds":8,"status":"started"}',
			-- roundRecords = '{"diCardsNum":13,"dlzLevel":0,"flzUnit":0,"playRound":1,"playRoundNo":"49eae347-ac1f-4809-9f44-e66e3bfb3910","players":[{"chiCombs":[["anb5","anb5","anb5"]],"chu":false,"dlzScore":0,"me":false,"owner":false,"score":-90,"seatNo":0,"xi":0},{"chiCombs":[["anb1","anb1","anb1"],["anb6","anb6","anb6"],["cfs2","cfs2","cfs2"]],"chu":false,"dlzScore":0,"me":false,"owner":false,"score":180,"seatNo":1,"xi":0},{"chiCombs":[["anb3","anb3","anb3"]],"chu":false,"dlzScore":0,"me":true,"owner":false,"score":-90,"seatNo":2,"xi":0}],"roomNo":"354057","roundRecords":[{"cardCombs":[{"cards":["anb5","anb5","anb5"],"indexNo":-1,"option":"peng","xi":2},{"cards":["ans1","ans1","anb2"],"indexNo":-1,"option":"","xi":0},{"cards":["anb3","ans4","ans4"],"indexNo":-1,"option":"","xi":0},{"cards":["anb4","ans5","ans6"],"indexNo":-1,"option":"","xi":0},{"cards":["ans6","anb6","anb7"],"indexNo":-1,"option":"","xi":0},{"cards":["anb7","ans8","ans9"],"indexNo":-1,"option":"","xi":0},{"cards":["ans10"],"indexNo":-1,"option":"","xi":0}],"dlzScore":-1,"flzScore":-1,"hu":false,"me":false,"owner":true,"role":"z","score":-90,"seatNo":0,"sumXi":0,"user":{"account":"6086357","icon":"http%3A%2F%2Fwx.qlogo.cn%2Fmmopen%2FrsA6UdvEZMIVI3DTr6f4lwgFxNhSczPibQvrpiaRBuKgM53UQZIQaib2ktKVaumaMRy4mnmZpSxh0JSQ850X0rmQsJ2Tvibf7vhA%2F0","ip":"119.44.13.95","nickname":"%E7%88%B1%E7%88%B1","sex":"female"},"xi":2},{"cardCombs":[{"cards":["anb1","anb1","anb1"],"indexNo":-1,"option":"peng","xi":2},{"cards":["anb6","anb6","anb6"],"indexNo":-1,"option":"peng","xi":2},{"cards":["cns2","cns2","cns2"],"indexNo":-1,"option":"wei","xi":4},{"cards":["ans4","ans5","ans6"],"indexNo":-1,"option":"chi","xi":0},{"cards":["anb8","anb9","anb10"],"indexNo":-1,"option":"chi","xi":0},{"cards":["ans8","ans9","ans10"],"indexNo":-1,"option":"chi","xi":0},{"cards":["ans7","ans7"],"indexNo":0,"option":"jiang","xi":2}],"diCards":["ans3","ans3","anb2","ans7","anb8","anb10","anb5","anb7","ans5","anb8","anb1","anb7","anb2"],"dlzScore":-1,"flzScore":-1,"hu":true,"huCard":"ans7","me":false,"mts":["单吊 +30","卡胡+50"],"owner":false,"role":"x","score":180,"seatNo":1,"sumXi":90,"user":{"account":"6987312","icon":"http%3A%2F%2Fwx.qlogo.cn%2Fmmopen%2FNvxFvXQCL3ia6ib85BPpWcIJLlMjRBO9ibdE5Cc7wowPoc9ibU5TINA0YUxcd5LcMicvsJdejBv1FYOUoP3aMF1UiaIQ1jvgtDQC7o%2F0","ip":"111.8.131.132","nickname":"Jason","sex":"male"},"xi":10},{"cardCombs":[{"cards":["anb3","anb3","anb3"],"indexNo":-1,"option":"peng","xi":2},{"cards":["ans1","ans1","ans2"],"indexNo":-1,"option":"","xi":0},{"cards":["ans3","ans4","ans5"],"indexNo":-1,"option":"","xi":0},{"cards":["ans6","ans7","ans8"],"indexNo":-1,"option":"","xi":0},{"cards":["ans8","anb8","anb9"],"indexNo":-1,"option":"","xi":0},{"cards":["ans9","ans10","ans10"],"indexNo":-1,"option":"","xi":0},{"cards":["anb10"],"indexNo":-1,"option":"","xi":0}],"dlzScore":-1,"flzScore":-1,"hu":false,"me":true,"owner":false,"role":"x","score":-90,"seatNo":2,"sumXi":0,"user":{"account":"6095887","icon":"http%3A%2F%2Fwx.qlogo.cn%2Fmmopen%2FrsA6UdvEZMI9WfMTicatPzbD3m3N64FyWcGh6CTKy9G4rrGaJWicEeVUChO7VIBEEziczgf9zNC2hvdXv0c3e78BNNUmw6JLzibl%2F0","ip":"223.150.154.11","nickname":"%E6%9D%8E%E7%A6%8F%E8%8D%A3","sex":"male"},"xi":2}],"roundStart":false,"rounds":8,"status":"started","surpDlzScore":-1}',
			roundRecords = ParseBase.new():parseToJsonObj( MJSocketResponseDataTest:res_gameing_Over() ).data
		}
	}
 
	-- 发起请求
	self:HttpPost(fun_back_data, url, param, testJsonTable)
end

-- 获取 游戏回放
function RequestMJRoomResult:getGameingMirror(param, fun_back_data)
	-- URL
	local url = self:getHttpUrl(Https.url.getMJGameingMirror)

	-- 参数
	--Commons:printLog_Req("假设有个table：", param)

	-- 假数据是：
	local testJsonTable = {
		status=0,
		msg=RequestBase:new():getStrEncode("ok"),
		data={
			-- 线上假数据
			playbacksUrl = RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/test/mirrorData_mj2.json")
		}
	}
 
	-- 发起请求
	self:HttpPost(fun_back_data, url, param, testJsonTable)
end

-- 获取 游戏回放
function RequestMJRoomResult:getOtherGameingMirror(param, fun_back_data)
	-- URL
	local url = self:getHttpUrl(Https.url.getOtherMJGameingMirror)

	-- 假数据是：
	local testJsonTable = {
		status=0,
		msg=RequestBase:new():getStrEncode("ok"),
		data={
			-- 线上假数据
			playbacksUrl = RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/test/mirrorData_mj.json")
		}
	}
 
	-- 发起请求
	self:HttpPost(fun_back_data, url, param, testJsonTable)
end

-- 必须有这个返回
return RequestMJRoomResult