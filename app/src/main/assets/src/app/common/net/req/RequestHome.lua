--
-- Author: lte
-- Date: 2016-10-13 17:11:07
--

-- 类申明
local base = import(".RequestBase")
local RequestHome = class("RequestHome", base)


-- 类变量申明

--获取房间信息
function RequestHome:getUserNickname(param, fun_back_data)
	-- URL
	local url = self:getHttpUrl(Https.url.getUserNickname)

	-- 参数
	--Commons:printLog_Req("假设有个table：", param)

	-- 假数据是：
	local testJsonTable = {
		status=0,
		msg=RequestBase:new():getStrEncode("成功"),
		data={
			user={
				nickname=RequestBase:getStrEncode("张三张三张三"),
				-- icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/icon/guest_boy.jpg"),
			}
		}
	}
 
	-- 发起请求
	self:HttpPost(fun_back_data, url, param, testJsonTable)
end

--获取交易记录
function RequestHome:getTradeLogs(param, fun_back_data)
	-- URL
	local url = self:getHttpUrl(Https.url.getTradeLogs)

	-- 参数
	--Commons:printLog_Req("假设有个table：", param)

	-- 假数据是：
	local testJsonTable = {
		status=0,
		msg=RequestBase:new():getStrEncode("成功"),
		data={
			tradeLogs={
				{
					tradeType="购买",
					tradeTime="09-09 01:00:01",
					remark="获取101张房卡,102张房卡,103张房卡,104张房卡,105张房卡",
				},
				{
					tradeType="购买获得,购买获得,购买获得,购买获得",
					tradeTime="2016-09-09 01:00:02",
					remark="获取102张房卡",
				},
				{
					tradeType="支出",
					tradeTime="2016-09-09 01:00:03",
					remark="获取103张房卡",
				},
				{
					tradeType="支出",
					tradeTime="2016-09-09 01:00:04",
					remark="获取104张房卡",
				},
				{
					tradeType="支出",
					tradeTime="2016-09-09 01:00:05",
					remark="获取105张房卡",
				},
				{
					tradeType="支出",
					tradeTime="2016-09-09 01:00:06",
					remark="获取106张房卡",
				},
				{
					tradeType="支出",
					tradeTime="2016-09-09 01:00:07",
					remark="获取107张房卡",
				},
				{
					tradeType="支出",
					tradeTime="2016-09-09 01:00:08",
					remark="获取108张房卡",
				},
				{
					tradeType="支出",
					tradeTime="2016-09-09 01:00:09",
					remark="获取109张房卡",
				},
				{
					tradeType="支出",
					tradeTime="2016-09-09 01:00:10",
					remark="获取110张房卡",
				},
				{
					tradeType="支出",
					tradeTime="2016-09-09 01:00:11",
					remark="获取111张房卡",
				},
			}
		}
	}
 
	-- 发起请求
	self:HttpPost(fun_back_data, url, param, testJsonTable)
end


--获取房间信息
function RequestHome:getHome(param, fun_back_data)
	-- URL
	local url = self:getHttpUrl(Https.url.getHome)

	-- 参数
	--Commons:printLog_Req("假设有个table：", param)

	-- 假数据是：
	local testJsonTable = {
		status=0,
		msg=RequestBase:new():getStrEncode("成功")
	}
 
	-- 发起请求
	self:HttpPost(fun_back_data, url, param, testJsonTable)
end 


-- 创建房间
function RequestHome:getRoomCreate(param, fun_back_data)
	-- URL
	local url = self:getHttpUrl(Https.url.getRoomCreate)

	-- 参数
	--Commons:printLog_Req("假设有个table：", param)

	-- 假数据是：
	local testJsonTable = {
		status=0,
		msg=RequestBase:new():getStrEncode("创建房间失败，请重试。"),
		data={
			room={
				roomNo="1000",
				status="created",

				-- 有这些值，但是没有使用上
					-- fanRule = "fan",
					-- multRule = "single",
					-- potRule = "y",
					-- mtRule = "quanMt", -- xiaoZhuo  daZhuo  laoMt quanMt
		            -- isDlz = "y", -- y  n
		            -- dlzLevel = 3, -- 1  2  3
		            -- flzUnit = 200, -- 80  100  200

				roomServerUrl= RequestBase:getStrEncode("wmq.rs.yuelaigame.com"),
				roomServerPort= 8000,
				roomShareUrl= RequestBase:getStrEncode("http://wmq.yuelaigame.com/"),
			}
		}
	}
 
	-- 发起请求
	self:HttpPost(fun_back_data, url, param, testJsonTable)
end 

-- 加入房间
function RequestHome:getRoomJoin(param, fun_back_data)
	-- URL
	local url = self:getHttpUrl(Https.url.getRoomJoin)

	-- 参数
	--Commons:printLog_Req("假设有个table：", param)

	-- 假数据是：
	local testJsonTable = {
		status=1,
		msg=RequestBase:new():getStrEncode("加入房间失败，请重试。"),
		data={
			room={
				roomNo="1000",
				status="ended",
				-- fanRule = "fan",
				-- multRule = "single",
				-- potRule = "y",
				roomServerUrl= RequestBase:getStrEncode("wmq.rs.yuelaigame.com"),
				roomServerPort= 8000,
				roomShareUrl= RequestBase:getStrEncode("http://wmq.yuelaigame.com/"),
			}
		}
	}
 
	-- 发起请求
	self:HttpPost(fun_back_data, url, param, testJsonTable)
end

-- 玩法介绍
function RequestHome:getHelpInfo(param, fun_back_data)
	-- URL
	local url = self:getHttpUrl(Https.url.getHelpInfo)

	-- 参数
	--Commons:printLog_Req("假设有个table：", param)

	-- 假数据是：
	local testJsonTable = {
		status=0,
		msg=RequestBase:new():getStrEncode(
			"玩法，玩法，玩法，玩法， 玩法，玩法，玩法，" ..
			"玩法，玩法，玩法，玩法， 玩法，玩法，\n" .. 
			"玩法，玩法，玩法，玩法， 玩法，玩法，\n" .. 
			"end"),
		data={
			playIntroUrl = RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/game_rule/playIntro195_0620.txt"),
		}
	}
 
	-- 发起请求
	self:HttpPost(fun_back_data, url, param, testJsonTable)
end

-- 系统消息
function RequestHome:getImInfo(param, fun_back_data)
	-- URL
	local url = self:getHttpUrl(Https.url.getImInfo)

	-- 参数
	--Commons:printLog_Req("假设有个table：", param)

	-- 假数据是：
	local testJsonTable = {
		status=0,
		msg=RequestBase:getStrEncode("ok"),
		data={
			message={
				content=RequestBase:getStrEncode(
					"消息，消息，消息，消息， 消息，消息，消息，" ..
					"玩法，玩法，玩法，玩法， 消息，消息，\n" .. 
					"玩法，玩法，玩法，玩法， 消息，消息，\n" .. 
					"end"),
			}
		}
	}
 
	-- 发起请求
	self:HttpPost(fun_back_data, url, param, testJsonTable)
end

-- 分享有礼
function RequestHome:getShareInfo(param, fun_back_data)
	-- URL
	local url = self:getHttpUrl(Https.url.getShareInfo)

	-- 参数
	--Commons:printLog_Req("假设有个table：", param)

	-- 假数据是：
	local testJsonTable = {
		status=0,
		msg=RequestBase:getStrEncode("ok"),
		data={
			content={
				activeContent=RequestBase:getStrEncode("你是好人"),
				shareTitle=RequestBase:getStrEncode(Strings.app_name),
				sharePic=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/Icon-72.png"),
				shareContent=RequestBase:getStrEncode("房间号是多少"),
				jumpUrl=RequestBase:getStrEncode("http://wmq.yuelaigame.com"),
				--token=RequestBase:getStrEncode("123456"),
			}
		}
	}
 
	-- 发起请求
	self:HttpPost(fun_back_data, url, param, testJsonTable)
end

-- 分享点击上报
function RequestHome:sendShareClick(param, fun_back_data)
	-- URL
	local url = self:getHttpUrl(Https.url.sendShareClick)

	-- 参数
	--Commons:printLog_Req("假设有个table：", param)

	-- 假数据是：
	local testJsonTable = {
		status=0,
		msg=RequestBase:getStrEncode("ok"),
		data={
			shareToken=RequestBase:getStrEncode("abc123456ddd"),
		}
	}
 
	-- 发起请求
	self:HttpPost(fun_back_data, url, param, testJsonTable)
end

-- 分享成功上报
function RequestHome:sendShareSucc(param, fun_back_data)
	-- URL
	local url = self:getHttpUrl(Https.url.sendShareSucc)

	-- 参数
	--Commons:printLog_Req("假设有个table：", param)

	-- 假数据是：
	local testJsonTable = {
		status=0,
		msg=RequestBase:getStrEncode("ok")
	}
 
	-- 发起请求
	self:HttpPost(fun_back_data, url, param, testJsonTable)
end

-- 转卡
function RequestHome:getGiveCard(param, fun_back_data)
	-- URL
	local url = self:getHttpUrl(Https.url.getGiveCard)

	-- 参数
	--Commons:printLog_Req("假设有个table：", param)

	-- 假数据是：
	local testJsonTable = {
		status=0,
		msg=RequestBase:new():getStrEncode("转卡ok"),
		-- data={
		-- 	room={
		-- 		roomNo="1000",
		-- 		status="ended"
		-- 	}
		-- }
	}
 
	-- 发起请求
	self:HttpPost(fun_back_data, url, param, testJsonTable)
end

-- 密码修改
function RequestHome:getPasswdMod(param, fun_back_data)
	-- URL
	local url = self:getHttpUrl(Https.url.getPasswdMod)

	-- 参数
	--Commons:printLog_Req("假设有个table：", param)

	-- 假数据是：
	local testJsonTable = {
		status=0,
		msg=RequestBase:new():getStrEncode("修改完成，请牢记新密码"),
		data={
			room={
				roomNo="1000",
				status="ended"
			}
		}
	}
 
	-- 发起请求
	self:HttpPost(fun_back_data, url, param, testJsonTable)
end

-- 获取用户房卡余额
function RequestHome:getRoomBalance(param, fun_back_data)
	-- URL
	local url = self:getHttpUrl(Https.url.getRoomBalance)

	-- 参数
	--Commons:printLog_Req("假设有个table：", param)

	-- 假数据是：
	local testJsonTable = {
		status=0,
		msg=RequestBase:new():getStrEncode("ok"),
		data={
			wallet={
				balance=23465
			}
		}
	}
 
	-- 发起请求
	self:HttpPost(fun_back_data, url, param, testJsonTable)
end

-- 获取战绩 房间
function RequestHome:getResultRoom(param, fun_back_data)
	-- URL
	local url = self:getHttpUrl(Https.url.getResultRoom)

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
					startTime="2016-10-10 00:00:01",
					players = {
						{
							owner=true,
							user={
								nickname=RequestBase:getStrEncode("张三张三张三"),
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/icon/guest_boy.jpg"),
							},
							score=100,
						},
						{
							owner=false,
							user={
								nickname=RequestBase:getStrEncode("李四李四李四"),
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/icon/guest_girl.png"),
							},
							score=-50,
						},
						{
							owner=false,
							user={
								nickname=RequestBase:getStrEncode("王五王五王五王五"),
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon1.jpg"),
							},
							score=-50,
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
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/icon/guest_boy.jpg"),
							},
							score=200,
						},
						{
							owner=false,
							user={
								nickname=RequestBase:getStrEncode("李四"),
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/icon/guest_girl.png"),
							},
							score=-100,
						},
						{
							owner=false,
							user={
								nickname=RequestBase:getStrEncode("王五"),
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon1.jpg"),
							},
							score=-100,
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
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/icon/guest_boy.jpg"),
							},
							score=300,
						},
						{
							owner=false,
							user={
								nickname=RequestBase:getStrEncode("李四1002"),
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/icon/guest_girl.png"),
							},
							score=-150,
						},
						{
							owner=false,
							user={
								nickname=RequestBase:getStrEncode("王五1002"),
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon1.jpg"),
							},
							score=-150,
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
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/icon/guest_boy.jpg"),
							},
							score=400,
						},
						{
							owner=false,
							user={
								nickname=RequestBase:getStrEncode("李四1003"),
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/icon/guest_girl.png"),
							},
							score=-200,
						},
						{
							owner=false,
							user={
								nickname=RequestBase:getStrEncode("王五1003"),
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon1.jpg"),
							},
							score=-200,
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
function RequestHome:getResultRound(param, fun_back_data)
	-- URL
	local url = self:getHttpUrl(Https.url.getResultRound)

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
					}
				},
				{
					roundNo="2/10",
					startTime="2016-10-11 00:00:02",
					players = {
						{
							owner=true,
							user={
								nickname=RequestBase:getStrEncode("张三"),
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/icon/guest_boy.jpg"),
							},
							score=2000,
						},
						{
							owner=false,
							user={
								nickname=RequestBase:getStrEncode("李四"),
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/icon/guest_girl.png"),
							},
							score=-1000,
						},
						{
							owner=false,
							user={
								nickname=RequestBase:getStrEncode("王五"),
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon1.jpg"),
							},
							score=-1000,
						},
					}
				},
				{
					roundNo="3/10",
					startTime="2016-10-11 00:00:03",
					players = {
						{
							owner=true,
							user={
								nickname=RequestBase:getStrEncode("张三1002"),
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/icon/guest_boy.jpg"),
							},
							score=3000,
						},
						{
							owner=false,
							user={
								nickname=RequestBase:getStrEncode("李四1002"),
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/icon/guest_girl.png"),
							},
							score=-1500,
						},
						{
							owner=false,
							user={
								nickname=RequestBase:getStrEncode("王五1002"),
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon1.jpg"),
							},
							score=-1500,
						},
					}
				},
				{
					roundNo="4/10",
					startTime="2016-10-11 00:00:04",
					players = {
						{
							owner=true,
							user={
								nickname=RequestBase:getStrEncode("张三1003"),
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/icon/guest_boy.jpg"),
							},
							score=4000,
						},
						{
							owner=false,
							user={
								nickname=RequestBase:getStrEncode("李四1003"),
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/icon/guest_girl.png"),
							},
							score=-2000,
						},
						{
							owner=false,
							user={
								nickname=RequestBase:getStrEncode("王五1003"),
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon1.jpg"),
							},
							score=-2000,
						},
					}
				},
				{
					roundNo="5/10",
					startTime="2016-10-11 00:00:05",
					players = {
						{
							owner=true,
							user={
								nickname=RequestBase:getStrEncode("张三1003"),
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/icon/guest_boy.jpg"),
							},
							score=5000,
						},
						{
							owner=false,
							user={
								nickname=RequestBase:getStrEncode("李四1003"),
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/icon/guest_girl.png"),
							},
							score=-2500,
						},
						{
							owner=false,
							user={
								nickname=RequestBase:getStrEncode("王五1003"),
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon1.jpg"),
							},
							score=-2500,
						},
					}
				},
				{
					roundNo="6/10",
					startTime="2016-10-11 00:00:06",
					players = {
						{
							owner=true,
							user={
								nickname=RequestBase:getStrEncode("张三1003"),
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/icon/guest_boy.jpg"),
							},
							score=6000,
						},
						{
							owner=false,
							user={
								nickname=RequestBase:getStrEncode("李四1003"),
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/icon/guest_girl.png"),
							},
							score=-3000,
						},
						{
							owner=false,
							user={
								nickname=RequestBase:getStrEncode("王五1003"),
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon1.jpg"),
							},
							score=-3000,
						},
					}
				},
				{
					roundNo="7/10",
					startTime="2016-10-11 00:00:07",
					players = {
						{
							owner=true,
							user={
								nickname=RequestBase:getStrEncode("张三1003"),
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/icon/guest_boy.jpg"),
							},
							score=7000,
						},
						{
							owner=false,
							user={
								nickname=RequestBase:getStrEncode("李四1003"),
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/icon/guest_girl.png"),
							},
							score=-3500,
						},
						{
							owner=false,
							user={
								nickname=RequestBase:getStrEncode("王五1003"),
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon1.jpg"),
							},
							score=-3500,
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
function RequestHome:getOtherResultRound(param, fun_back_data)
	-- URL
	local url = self:getHttpUrl(Https.url.getOtherResultRound)

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
								token="1111",
							},
							score=1000,
						},
						{
							owner=false,
							user={
								nickname=RequestBase:getStrEncode("李四李四李四"),
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/icon/guest_girl.png"),
								token="2222",
							},
							score=-500,
						},
						{
							owner=false,
							user={
								nickname=RequestBase:getStrEncode("王五王五王五王五"),
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon1.jpg"),
								token="3333",
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
								token="1111",
							},
							score=100,
						},
						{
							owner=false,
							user={
								nickname=RequestBase:getStrEncode("李四"),
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/icon/guest_girl.png"),
								token="2222",
							},
							score=-50,
						},
						{
							owner=false,
							user={
								nickname=RequestBase:getStrEncode("王五"),
								icon=RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon1.jpg"),
								token="3333",
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
function RequestHome:getResultRound_Detail(param, fun_back_data)
	-- URL
	local url = self:getHttpUrl(Https.url.getResultRound_Detail)

	-- 参数
	--Commons:printLog_Req("假设有个table：", param)

	-- 假数据是：
	local testJsonTable = {
		status=0,
		msg=RequestBase:new():getStrEncode("ok"),
		data={
			-- roundRecords = '{"diCardsNum":11,"playRound":1,"playRoundNo":"b9aa8f95-ff23-405b-8066-ce13b6fb38f3","roomNo":"468260","roundRecords":[{"cardCombs":[{"cards":["anb10","anb10","anb10"],"indexNo":-1,"option":"peng","xi":3},{"cards":["ans9","ans9","ans9"],"indexNo":-1,"option":"peng","xi":2},{"cards":["anb2","anb3","anb4"],"indexNo":-1,"option":"chi","xi":0},{"cards":["bns3","bns3","bns3"],"indexNo":-1,"option":"wei","xi":3},{"cards":["ans4","ans5","ans6"],"indexNo":2,"option":"chi","xi":0},{"cards":["anb7","anb8","anb9"],"indexNo":-1,"option":"chi","xi":0},{"cards":["ans2","ans2"],"indexNo":-1,"option":"jiang","xi":2}],"diCards":["ans10","ans8","ans7","ans5","anb5","ans7","ans1","anb9","ans4","anb3","anb2"],"hu":true,"huCard":"ans6","me":false,"mts":["上下五千年 +50"],"owner":true,"role":"z","score":120,"seatNo":0,"sumXi":60,"user":{"account":"6127801","icon":"http%3A%2F%2Fwx.qlogo.cn%2Fmmopen%2FicJibovBC55clCzL1eYH2IwfvMoDINKTib6sx3ic97HhW0nvnoicbpD5X9flrZB91Y0zaAPNXmzmbZWq4shN3KH75TzicNK8jxib2IC%2F0","ip":"223.104.19.35","nickname":"%E6%89%93%E4%B8%8D%E6%AD%BB%E7%9A%84%E5%B0%8F%E5%BC%BA","sex":"female"},"xi":10},{"cardCombs":[{"cards":["ans6","ans6","ans6"],"indexNo":-1,"option":"peng","xi":2},{"cards":["ans1","anb1","anb2"],"indexNo":-1,"option":"","xi":0},{"cards":["ans2","ans2","ans3"],"indexNo":-1,"option":"","xi":0},{"cards":["anb3","ans4","ans4"],"indexNo":-1,"option":"","xi":0},{"cards":["anb4","anb5","anb7"],"indexNo":-1,"option":"","xi":0},{"cards":["ans7","anb8","ans9"],"indexNo":-1,"option":"","xi":0},{"cards":["anb9"],"indexNo":-1,"option":"","xi":0}],"hu":false,"me":false,"owner":false,"role":"x","score":-60,"seatNo":1,"sumXi":0,"user":{"account":"6763719","icon":"http%3A%2F%2Fwx.qlogo.cn%2Fmmopen%2FCsicRhyibia3ZP7Gk5Y9XoApgtBKLLpfyvsqv7XWchbQkA5BN2uDJf3RsDgvdDiaufzV4NPdIbkTtKZWXj1BnZVklNgZjvxhcjvI%2F0","ip":"119.120.54.51","nickname":"%EF%B8%B7.%E9%BB%98%E5%AE%88%E9%82%A3%E4%BB%BD%E6%83%85","sex":"male"},"xi":2},{"cardCombs":[{"cards":["ans10","ans10","ans10"],"indexNo":-1,"option":"peng","xi":3},{"cards":["ayb5","anb4","anb6"],"indexNo":-1,"option":"chi","xi":0},{"cards":["cns8","cns8","cns8"],"indexNo":-1,"option":"wei","xi":3},{"cards":["anb6","anb6","anb6"],"indexNo":-1,"option":"peng","xi":2},{"cards":["ayb9","anb7","anb8"],"indexNo":-1,"option":"chi","xi":0},{"cards":["ans1","ans1","anb7"],"indexNo":-1,"option":"","xi":0},{"cards":["anb8"],"indexNo":-1,"option":"","xi":0}],"hu":false,"me":true,"owner":false,"role":"x","score":-60,"seatNo":2,"sumXi":0,"user":{"account":"6099337","icon":"http%3A%2F%2Fwx.qlogo.cn%2Fmmopen%2FCsicRhyibia3ZP7Gk5Y9XoAprdK2Uh9DX8LHicECvFoMjeiadRUvB8OTIfwtbtUvqoBrXLdJlFgJ3eGen5jmACKDxurj0nicsFrDxW%2F0","ip":"220.202.152.18","nickname":"%E4%BB%8E%E4%BD%A0%E7%9A%84%E5%85%A8%E4%B8%96%E7%95%8C%E8%B7%AF%E8%BF%87","sex":"male"},"xi":8}],"roundStart":false,"rounds":8,"status":"started"}',
			-- roundRecords = '{"diCardsNum":13,"dlzLevel":0,"flzUnit":0,"playRound":1,"playRoundNo":"49eae347-ac1f-4809-9f44-e66e3bfb3910","players":[{"chiCombs":[["anb5","anb5","anb5"]],"chu":false,"dlzScore":0,"me":false,"owner":false,"score":-90,"seatNo":0,"xi":0},{"chiCombs":[["anb1","anb1","anb1"],["anb6","anb6","anb6"],["cfs2","cfs2","cfs2"]],"chu":false,"dlzScore":0,"me":false,"owner":false,"score":180,"seatNo":1,"xi":0},{"chiCombs":[["anb3","anb3","anb3"]],"chu":false,"dlzScore":0,"me":true,"owner":false,"score":-90,"seatNo":2,"xi":0}],"roomNo":"354057","roundRecords":[{"cardCombs":[{"cards":["anb5","anb5","anb5"],"indexNo":-1,"option":"peng","xi":2},{"cards":["ans1","ans1","anb2"],"indexNo":-1,"option":"","xi":0},{"cards":["anb3","ans4","ans4"],"indexNo":-1,"option":"","xi":0},{"cards":["anb4","ans5","ans6"],"indexNo":-1,"option":"","xi":0},{"cards":["ans6","anb6","anb7"],"indexNo":-1,"option":"","xi":0},{"cards":["anb7","ans8","ans9"],"indexNo":-1,"option":"","xi":0},{"cards":["ans10"],"indexNo":-1,"option":"","xi":0}],"dlzScore":-1,"flzScore":-1,"hu":false,"me":false,"owner":true,"role":"z","score":-90,"seatNo":0,"sumXi":0,"user":{"account":"6086357","icon":"http%3A%2F%2Fwx.qlogo.cn%2Fmmopen%2FrsA6UdvEZMIVI3DTr6f4lwgFxNhSczPibQvrpiaRBuKgM53UQZIQaib2ktKVaumaMRy4mnmZpSxh0JSQ850X0rmQsJ2Tvibf7vhA%2F0","ip":"119.44.13.95","nickname":"%E7%88%B1%E7%88%B1","sex":"female"},"xi":2},{"cardCombs":[{"cards":["anb1","anb1","anb1"],"indexNo":-1,"option":"peng","xi":2},{"cards":["anb6","anb6","anb6"],"indexNo":-1,"option":"peng","xi":2},{"cards":["cns2","cns2","cns2"],"indexNo":-1,"option":"wei","xi":4},{"cards":["ans4","ans5","ans6"],"indexNo":-1,"option":"chi","xi":0},{"cards":["anb8","anb9","anb10"],"indexNo":-1,"option":"chi","xi":0},{"cards":["ans8","ans9","ans10"],"indexNo":-1,"option":"chi","xi":0},{"cards":["ans7","ans7"],"indexNo":0,"option":"jiang","xi":2}],"diCards":["ans3","ans3","anb2","ans7","anb8","anb10","anb5","anb7","ans5","anb8","anb1","anb7","anb2"],"dlzScore":-1,"flzScore":-1,"hu":true,"huCard":"ans7","me":false,"mts":["单吊 +30","卡胡+50"],"owner":false,"role":"x","score":180,"seatNo":1,"sumXi":90,"user":{"account":"6987312","icon":"http%3A%2F%2Fwx.qlogo.cn%2Fmmopen%2FNvxFvXQCL3ia6ib85BPpWcIJLlMjRBO9ibdE5Cc7wowPoc9ibU5TINA0YUxcd5LcMicvsJdejBv1FYOUoP3aMF1UiaIQ1jvgtDQC7o%2F0","ip":"111.8.131.132","nickname":"Jason","sex":"male"},"xi":10},{"cardCombs":[{"cards":["anb3","anb3","anb3"],"indexNo":-1,"option":"peng","xi":2},{"cards":["ans1","ans1","ans2"],"indexNo":-1,"option":"","xi":0},{"cards":["ans3","ans4","ans5"],"indexNo":-1,"option":"","xi":0},{"cards":["ans6","ans7","ans8"],"indexNo":-1,"option":"","xi":0},{"cards":["ans8","anb8","anb9"],"indexNo":-1,"option":"","xi":0},{"cards":["ans9","ans10","ans10"],"indexNo":-1,"option":"","xi":0},{"cards":["anb10"],"indexNo":-1,"option":"","xi":0}],"dlzScore":-1,"flzScore":-1,"hu":false,"me":true,"owner":false,"role":"x","score":-90,"seatNo":2,"sumXi":0,"user":{"account":"6095887","icon":"http%3A%2F%2Fwx.qlogo.cn%2Fmmopen%2FrsA6UdvEZMI9WfMTicatPzbD3m3N64FyWcGh6CTKy9G4rrGaJWicEeVUChO7VIBEEziczgf9zNC2hvdXv0c3e78BNNUmw6JLzibl%2F0","ip":"223.150.154.11","nickname":"%E6%9D%8E%E7%A6%8F%E8%8D%A3","sex":"male"},"xi":2}],"roundStart":false,"rounds":8,"status":"started","surpDlzScore":-1}',
			roundRecords = ParseBase.new():parseToJsonObj( SocketResponseDataTest:res_gameing_Over() ).data
		}
	}
 
	-- 发起请求
	self:HttpPost(fun_back_data, url, param, testJsonTable)
end

-- 获取战绩  回合详情
function RequestHome:getOtherResultRound_Detail(param, fun_back_data)
	-- URL
	local url = self:getHttpUrl(Https.url.getOtherResultRound_Detail)

	-- 参数
	--Commons:printLog_Req("假设有个table：", param)

	-- 假数据是：
	local testJsonTable = {
		status=0,
		msg=RequestBase:new():getStrEncode("ok"),
		data={
			-- roundRecords = '{"diCardsNum":11,"playRound":1,"playRoundNo":"b9aa8f95-ff23-405b-8066-ce13b6fb38f3","roomNo":"468260","roundRecords":[{"cardCombs":[{"cards":["anb10","anb10","anb10"],"indexNo":-1,"option":"peng","xi":3},{"cards":["ans9","ans9","ans9"],"indexNo":-1,"option":"peng","xi":2},{"cards":["anb2","anb3","anb4"],"indexNo":-1,"option":"chi","xi":0},{"cards":["bns3","bns3","bns3"],"indexNo":-1,"option":"wei","xi":3},{"cards":["ans4","ans5","ans6"],"indexNo":2,"option":"chi","xi":0},{"cards":["anb7","anb8","anb9"],"indexNo":-1,"option":"chi","xi":0},{"cards":["ans2","ans2"],"indexNo":-1,"option":"jiang","xi":2}],"diCards":["ans10","ans8","ans7","ans5","anb5","ans7","ans1","anb9","ans4","anb3","anb2"],"hu":true,"huCard":"ans6","me":false,"mts":["上下五千年 +50"],"owner":true,"role":"z","score":120,"seatNo":0,"sumXi":60,"user":{"account":"6127801","icon":"http%3A%2F%2Fwx.qlogo.cn%2Fmmopen%2FicJibovBC55clCzL1eYH2IwfvMoDINKTib6sx3ic97HhW0nvnoicbpD5X9flrZB91Y0zaAPNXmzmbZWq4shN3KH75TzicNK8jxib2IC%2F0","ip":"223.104.19.35","nickname":"%E6%89%93%E4%B8%8D%E6%AD%BB%E7%9A%84%E5%B0%8F%E5%BC%BA","sex":"female"},"xi":10},{"cardCombs":[{"cards":["ans6","ans6","ans6"],"indexNo":-1,"option":"peng","xi":2},{"cards":["ans1","anb1","anb2"],"indexNo":-1,"option":"","xi":0},{"cards":["ans2","ans2","ans3"],"indexNo":-1,"option":"","xi":0},{"cards":["anb3","ans4","ans4"],"indexNo":-1,"option":"","xi":0},{"cards":["anb4","anb5","anb7"],"indexNo":-1,"option":"","xi":0},{"cards":["ans7","anb8","ans9"],"indexNo":-1,"option":"","xi":0},{"cards":["anb9"],"indexNo":-1,"option":"","xi":0}],"hu":false,"me":false,"owner":false,"role":"x","score":-60,"seatNo":1,"sumXi":0,"user":{"account":"6763719","icon":"http%3A%2F%2Fwx.qlogo.cn%2Fmmopen%2FCsicRhyibia3ZP7Gk5Y9XoApgtBKLLpfyvsqv7XWchbQkA5BN2uDJf3RsDgvdDiaufzV4NPdIbkTtKZWXj1BnZVklNgZjvxhcjvI%2F0","ip":"119.120.54.51","nickname":"%EF%B8%B7.%E9%BB%98%E5%AE%88%E9%82%A3%E4%BB%BD%E6%83%85","sex":"male"},"xi":2},{"cardCombs":[{"cards":["ans10","ans10","ans10"],"indexNo":-1,"option":"peng","xi":3},{"cards":["ayb5","anb4","anb6"],"indexNo":-1,"option":"chi","xi":0},{"cards":["cns8","cns8","cns8"],"indexNo":-1,"option":"wei","xi":3},{"cards":["anb6","anb6","anb6"],"indexNo":-1,"option":"peng","xi":2},{"cards":["ayb9","anb7","anb8"],"indexNo":-1,"option":"chi","xi":0},{"cards":["ans1","ans1","anb7"],"indexNo":-1,"option":"","xi":0},{"cards":["anb8"],"indexNo":-1,"option":"","xi":0}],"hu":false,"me":true,"owner":false,"role":"x","score":-60,"seatNo":2,"sumXi":0,"user":{"account":"6099337","icon":"http%3A%2F%2Fwx.qlogo.cn%2Fmmopen%2FCsicRhyibia3ZP7Gk5Y9XoAprdK2Uh9DX8LHicECvFoMjeiadRUvB8OTIfwtbtUvqoBrXLdJlFgJ3eGen5jmACKDxurj0nicsFrDxW%2F0","ip":"220.202.152.18","nickname":"%E4%BB%8E%E4%BD%A0%E7%9A%84%E5%85%A8%E4%B8%96%E7%95%8C%E8%B7%AF%E8%BF%87","sex":"male"},"xi":8}],"roundStart":false,"rounds":8,"status":"started"}',
			-- roundRecords = '{"diCardsNum":13,"dlzLevel":0,"flzUnit":0,"playRound":1,"playRoundNo":"49eae347-ac1f-4809-9f44-e66e3bfb3910","players":[{"chiCombs":[["anb5","anb5","anb5"]],"chu":false,"dlzScore":0,"me":false,"owner":false,"score":-90,"seatNo":0,"xi":0},{"chiCombs":[["anb1","anb1","anb1"],["anb6","anb6","anb6"],["cfs2","cfs2","cfs2"]],"chu":false,"dlzScore":0,"me":false,"owner":false,"score":180,"seatNo":1,"xi":0},{"chiCombs":[["anb3","anb3","anb3"]],"chu":false,"dlzScore":0,"me":true,"owner":false,"score":-90,"seatNo":2,"xi":0}],"roomNo":"354057","roundRecords":[{"cardCombs":[{"cards":["anb5","anb5","anb5"],"indexNo":-1,"option":"peng","xi":2},{"cards":["ans1","ans1","anb2"],"indexNo":-1,"option":"","xi":0},{"cards":["anb3","ans4","ans4"],"indexNo":-1,"option":"","xi":0},{"cards":["anb4","ans5","ans6"],"indexNo":-1,"option":"","xi":0},{"cards":["ans6","anb6","anb7"],"indexNo":-1,"option":"","xi":0},{"cards":["anb7","ans8","ans9"],"indexNo":-1,"option":"","xi":0},{"cards":["ans10"],"indexNo":-1,"option":"","xi":0}],"dlzScore":-1,"flzScore":-1,"hu":false,"me":false,"owner":true,"role":"z","score":-90,"seatNo":0,"sumXi":0,"user":{"account":"6086357","icon":"http%3A%2F%2Fwx.qlogo.cn%2Fmmopen%2FrsA6UdvEZMIVI3DTr6f4lwgFxNhSczPibQvrpiaRBuKgM53UQZIQaib2ktKVaumaMRy4mnmZpSxh0JSQ850X0rmQsJ2Tvibf7vhA%2F0","ip":"119.44.13.95","nickname":"%E7%88%B1%E7%88%B1","sex":"female"},"xi":2},{"cardCombs":[{"cards":["anb1","anb1","anb1"],"indexNo":-1,"option":"peng","xi":2},{"cards":["anb6","anb6","anb6"],"indexNo":-1,"option":"peng","xi":2},{"cards":["cns2","cns2","cns2"],"indexNo":-1,"option":"wei","xi":4},{"cards":["ans4","ans5","ans6"],"indexNo":-1,"option":"chi","xi":0},{"cards":["anb8","anb9","anb10"],"indexNo":-1,"option":"chi","xi":0},{"cards":["ans8","ans9","ans10"],"indexNo":-1,"option":"chi","xi":0},{"cards":["ans7","ans7"],"indexNo":0,"option":"jiang","xi":2}],"diCards":["ans3","ans3","anb2","ans7","anb8","anb10","anb5","anb7","ans5","anb8","anb1","anb7","anb2"],"dlzScore":-1,"flzScore":-1,"hu":true,"huCard":"ans7","me":false,"mts":["单吊 +30","卡胡+50"],"owner":false,"role":"x","score":180,"seatNo":1,"sumXi":90,"user":{"account":"6987312","icon":"http%3A%2F%2Fwx.qlogo.cn%2Fmmopen%2FNvxFvXQCL3ia6ib85BPpWcIJLlMjRBO9ibdE5Cc7wowPoc9ibU5TINA0YUxcd5LcMicvsJdejBv1FYOUoP3aMF1UiaIQ1jvgtDQC7o%2F0","ip":"111.8.131.132","nickname":"Jason","sex":"male"},"xi":10},{"cardCombs":[{"cards":["anb3","anb3","anb3"],"indexNo":-1,"option":"peng","xi":2},{"cards":["ans1","ans1","ans2"],"indexNo":-1,"option":"","xi":0},{"cards":["ans3","ans4","ans5"],"indexNo":-1,"option":"","xi":0},{"cards":["ans6","ans7","ans8"],"indexNo":-1,"option":"","xi":0},{"cards":["ans8","anb8","anb9"],"indexNo":-1,"option":"","xi":0},{"cards":["ans9","ans10","ans10"],"indexNo":-1,"option":"","xi":0},{"cards":["anb10"],"indexNo":-1,"option":"","xi":0}],"dlzScore":-1,"flzScore":-1,"hu":false,"me":true,"owner":false,"role":"x","score":-90,"seatNo":2,"sumXi":0,"user":{"account":"6095887","icon":"http%3A%2F%2Fwx.qlogo.cn%2Fmmopen%2FrsA6UdvEZMI9WfMTicatPzbD3m3N64FyWcGh6CTKy9G4rrGaJWicEeVUChO7VIBEEziczgf9zNC2hvdXv0c3e78BNNUmw6JLzibl%2F0","ip":"223.150.154.11","nickname":"%E6%9D%8E%E7%A6%8F%E8%8D%A3","sex":"male"},"xi":2}],"roundStart":false,"rounds":8,"status":"started","surpDlzScore":-1}',
			roundRecords = ParseBase.new():parseToJsonObj( SocketResponseDataTest:res_gameing_Over() ).data
		}
	}
 
	-- 发起请求
	self:HttpPost(fun_back_data, url, param, testJsonTable)
end


-- 获取 游戏回放
function RequestHome:getGameingMirror(param, fun_back_data)
	-- URL
	local url = self:getHttpUrl(Https.url.getGameingMirror)

	-- 参数
	--Commons:printLog_Req("假设有个table：", param)

	--[[
	local res_gameing_Login = ParseBase:parseToJsonString( ParseBase:parseToJsonObj(SocketResponseDataTest:res_loginRoom())[ParseBase.data] )
	local res_gameing_Start = ParseBase:parseToJsonString( ParseBase:parseToJsonObj(SocketResponseDataTest:res_gameing_Start())[ParseBase.data] )
	local res_gameing_Chi_xiajia = ParseBase:parseToJsonString( ParseBase:parseToJsonObj(SocketResponseDataTest:res_gameing_Chi_xiajia())[ParseBase.data] )
	local res_gameing_Chi_myself_needChi = ParseBase:parseToJsonString( ParseBase:parseToJsonObj(SocketResponseDataTest:res_gameing_Chi_myself_needChi())[ParseBase.data] )
	local res_gameing_Chi_myself = ParseBase:parseToJsonString( ParseBase:parseToJsonObj(SocketResponseDataTest:res_gameing_Chi_myself())[ParseBase.data] )
	local res_gameing_Chi_myself_needChi = ParseBase:parseToJsonString( ParseBase:parseToJsonObj(SocketResponseDataTest:res_gameing_Chi_myself_needChi())[ParseBase.data] )
	local res_gameing_Over = ParseBase:parseToJsonString( ParseBase:parseToJsonObj(SocketResponseDataTest:res_gameing_Over())[ParseBase.data] )

	local _playbacks =
		""..res_gameing_Login..","..
		""..res_gameing_Start..","..
		""..res_gameing_Chi_xiajia..","..
		""..res_gameing_Chi_myself_needChi..","..
		""..res_gameing_Chi_myself..","..
		""..res_gameing_Chi_myself_needChi..","..
		""..res_gameing_Over..""

	local _playbacks2 = RequestBase:getStrEncode( "[".._playbacks.."]" )
	--]]

	-- 模拟代入
	-- local _playbacks2 = ''

	-- 假数据是：
	local testJsonTable = {
		status=0,
		msg=RequestBase:new():getStrEncode("ok"),
		data={
			-- playbacks = _playbacks2,
			-- 线上假数据
			playbacksUrl = RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/test/mirrorData.json")
			-- playbacksUrl = RequestBase:getStrEncode("http://wmq.pbres99.yuelaigame.com/playbacks/20170612/354057_49eae347-ac1f-4809-9f44-e66e3bfb3910_6987312.json")
		}
	}
 
	-- 发起请求
	self:HttpPost(fun_back_data, url, param, testJsonTable)
end

-- 获取 游戏回放
function RequestHome:getOtherGameingMirror(param, fun_back_data)
	-- URL
	local url = self:getHttpUrl(Https.url.getOtherGameingMirror)

	-- 假数据是：
	local testJsonTable = {
		status=0,
		msg=RequestBase:new():getStrEncode("ok"),
		data={
			-- 线上假数据
			playbacksUrl = RequestBase:getStrEncode("http://wmq.res.apk.yuelaigame.com/test/mirrorData.json")
		}
	}
 
	-- 发起请求
	self:HttpPost(fun_back_data, url, param, testJsonTable)
end


--RequestHome.EVENT_DATA_getHome = "EVENT_DATA_getHome" -- 自定义事件名
--用于测试执行的函数  发送监听消息
--[[
function RequestHome:BackData()
	Commons:printLog_Req("进入了 RequestHome:BackData")
	self:dispatchEvent({name = RequestHome.EVENT_DATA_getHome})
end
--]]


-- 构造函数
function RequestHome:ctor()
	--Commons:printLog_Req("RequestHome:ctor")

	--cc.GameObject.extend(self):addComponent("components.behavior.EventProtocol"):exportMethods()
	--cc(self):addComponent("components.behavior.EventProtocol"):exportMethods()
	--self:performWithDelay(function () 
	--	Commons:printLog_Req("开始了一次")
    --    self:dispatchEvent({name = RequestHome.EVENT_DATA_getHome})
    --end, 1.5)
	--self:dispatchEvent({name = RequestHome.EVENT_DATA_getHome})
	
	--[[
	-- 1.获取事件分发器  : EventDispatcher
    local dispatcher = cc.Director:getInstance():getEventDispatcher()
    -- 2.创建事件监听器  : EventListener 
    local listener = cc.EventListenerCustom:create(RequestHome.EVENT_DATA_getHome, RequestHome:BackData)
    -- 4.在事件分发器中，添加监听器。事件响应委托为
    --dispatcher:addEventListenerWithSceneGraphPriority(listener, self)
    dispatcher:addEventListenerWithFixedPriority(listener, 1)
    --测试事件  
    local eventDispatcher = cc.Director:getInstance():getEventDispatcher()
    local event = cc.EventCustom:new(RequestHome.EVENT_DATA_getHome)
    eventDispatcher:dispatchEvent(event) 
    --]]
end


-- 必须有这个返回
return RequestHome