--
-- Author: lte
-- Date: 2016-10-14 18:04:31
-- socket tcp 的申明

-- 类申明
-- local Sockets = class("Sockets", function ()
--     return display.newNode();
-- end)
local Sockets = class("Sockets")


-- 类变量申明

-- socket连接 --todo 正式打包，需要更新的
Sockets.connect = {
	-- ip = "192.168.1.41", -- 测试ip地址
	-- port = 8081, -- 测试端口号

	-- -- 快来扯胡子
	-- ip = "yzchz.rs.depuju.com", -- 正式ip地址
	-- port = 6009, -- 正式端口号

    -- -- 快来偎麻雀
    -- ip = "wmq.rs.depuju.com", -- 正式ip地址
    -- port = 6003, -- 正式端口号

    -- 偎麻雀
	-- ip = "wmq.rs.yuelaigame.com", -- 正式ip地址
	-- ip = "192.168.31.75", -- 测试ip地址
	ip = "101.124.66.110", -- 正式ip地址
    port = 6003, -- 正式端口号
	
	isReconnect = true, -- 是否重连
}

-- socket cmd上行指令
Sockets.cmd = {
	-- 只有上行的指令
	dissRoom_confim = 1003, -- cmd指令  解散房间确认  需要上行：同意或者不同意
	gameing_Prepare = 1004,  -- cmd指令  进入房间之后，就准备了
	
	gameing_Chu = 1005,  -- cmd指令  游戏开始后，出牌

	gameing_Wei = 1010, -- cmd指令  游戏开始后，偎牌
	gameing_ChouWei = 1015, -- cmd指令  游戏开始后，偎牌
	gameing_Ti = 1011, -- cmd指令  游戏开始后，提牌
	gameing_Ti8 = 1012, -- cmd指令  游戏开始后，提牌
	gameing_Pao = 1013, -- cmd指令  游戏开始后，跑牌
	gameing_Pao8 = 1014, -- cmd指令  游戏开始后，跑牌

	gameing_Chi = 1008,  -- cmd指令  游戏开始后，吃牌
	gameing_Peng = 1007, -- cmd指令  游戏开始后，碰牌
	gameing_Hu = 1009,  -- cmd指令  游戏开始后，胡牌
	gameing_Guo = 1006,  -- cmd指令  游戏开始后，过牌

	gameing_Wc = 1016,  -- cmd指令  游戏开始后，王闯来胡牌
	gameing_Wd = 1017,  -- cmd指令  游戏开始后，王钓来胡牌

	gameing_TWc = 1018,  -- cmd指令  游戏开始后，听王闯来胡牌
	gameing_TWd = 1019,  -- cmd指令  游戏开始后，听王钓来胡牌
	gameing_Gang = 1022, -- cmd指令  游戏开始后，杠牌

	-- 上下行都会有的指令
	loginRoom = 1000, -- cmd指令  登录房间
	dissRoom = 1002, -- cmd指令  解散房间申请  下行：需要其他玩家同意或者不同意操作

	------------区别登录命令--------------
	refreshRoom = 1105, -- cmd指令  刷新房间数据，这里永远不会有t出用户的操作

	gameing_SendEmoji = 1100,  -- cmd指令  游戏中，发送表情
	gameing_SendVoice = 1101,  -- cmd指令  游戏中，发送录音
	gameing_SendWords = 1102,  -- cmd指令  游戏中，发送短语

	-- 只有下行消息的指令
	dissRoom_success = 2007, -- cmd指令  解散房间成功或者失败

	gameing_playerLoginRoom = 2000,  -- cmd指令  玩家上线，进入房间
	gameing_playerExitRoom = 2001,  -- cmd指令  玩家下线，退出房间
	
	gameing_playerOutRoom = 5000,  -- cmd指令  玩家退出，游戏并没有开始过
	gameing_BackHaLL = 1001,  -- cmd指令  玩家进入房间，自己点击返回大厅，需要告知服务器，是主动行为，不然离线不算

	gameing_Start = 2002,  -- cmd指令  玩家全部上线，游戏开始
	gameing_Over = 2003,  -- cmd指令  游戏每个回合结束，【如果是最后一局，包含房间游戏结束】

	gameing_Mo_pai = 2005,  -- cmd指令  游戏开始后，摸牌
	gameing_ChiPengGuoHu_pai = 2006,  -- cmd指令  游戏开始后，吃 碰 过 胡牌
	gameing_WeiTiPao_pai = 2005, -- cmd指令  游戏开始后，偎 提 跑  提8 跑8

	gameing_Xintiao_down = 200, -- 心跳下行  服务器查找客户端
	gameing_Xintiao_up = 100, -- 心跳上行 客户端答复服务器

	gameing_Xintiao_send = 1103, -- 心跳上行 客户端查找服务器

	gameing_ExitSocket = 4000, -- 有多处重连socket告诉上一处自动退出和关闭socket

	------------跑得快--------------
	gameing_outCard_error = 2009, --出牌不合法(跑得快)
	-- gameing_gameOver = 2004, --整个游戏结束（跑得快）
	------------跑得快--------------

	------------定位信息 ip检查--------------
	gameing_IP_check = 3000, -- 2011, -- 服务器下发ip检测
	-- gameing_IP_check_reslut = 2012, -- 服务器下发ip检测结果(如发生同ip情况)
	-- gameing_IP_check_up = 1104, -- 客户端上行是否同意ip相同

	-----------------麻将-------------------
	gameing_SuperEmoji = 1104,  -- cmd指令  游戏中，发送超级表情
}

-- 构造函数
function Sockets:ctor()
end

-- 必须有这个返回
return Sockets