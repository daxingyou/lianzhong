--
-- Author: lte
-- Date: 2016-10-29 12:11:58
-- socket tcp 返回的数据，假定的测试数据

local SocketResponseData = class("SocketResponseData")


-- 反馈结果：解散房间申请反馈给其他玩家  等待其他玩家确认
function SocketResponseData:res_dissRoom()
    local resData = {}

    local cmd = Sockets.cmd.dissRoom
    local data = {
        --room = {
            roomNo="1000", -- 房间号         
        --}       
    }
    
    resData[ParseBase.cmd] = cmd;
    resData[ParseBase.data] = data;
    resData[ParseBase.msg] = RequestBase:new():getStrEncode("解散房间不扣除房卡，是否确认解散");
    resData[ParseBase.status] = 0;

    Commons:printLog_SocketReq("解散房间申请 假定tcp返回数据是：",ParseBase.new():parseToJsonString(resData))
    return ParseBase.new():parseToJsonString(resData);
end

-- 模拟服务器发送断开socket退出房间的命令
function SocketResponseData:res_gameing_ExitSocket()
    local resData = {}

    local cmd = Sockets.cmd.gameing_ExitSocket
    local data = {
        -- --room = {
        --     roomNo="1000", -- 房间号         
        -- --}       
    }
    
    resData[ParseBase.cmd] = cmd;
    resData[ParseBase.data] = data;
    resData[ParseBase.msg] = RequestBase:new():getStrEncode("强退房间OK");
    resData[ParseBase.status] = 0;

    Commons:printLog_SocketReq("强退房间 假定tcp返回数据是：",ParseBase.new():parseToJsonString(resData))
    return ParseBase.new():parseToJsonString(resData);
end

-- 反馈结果：解散房间申请反馈给其他玩家  等待其他玩家确认
function SocketResponseData:res_dissRoom_new()
    local resData = {}

    local cmd = Sockets.cmd.dissRoom
    local data = {
        --room = {
            descript="玩家【李刚】请解散游戏，等待其他玩家选择【超过150秒未做选择，则默认同意】", -- 房间号 
            overtime=150,
            choose=false,
            playerChooses={
                {descript="【张三】等待选择",status="wait"}, -- // 状态，wait：等待，agreed：同意
                {descript="【李四】同意解散",status="agreed"},
            }        
        --}       
    }
    
    resData[ParseBase.cmd] = cmd;
    resData[ParseBase.data] = data;
    resData[ParseBase.msg] = RequestBase:new():getStrEncode("解散房间不扣除房卡，是否确认解散");
    resData[ParseBase.status] = 0;

    Commons:printLog_SocketReq("解散房间申请 假定tcp返回数据是：",ParseBase.new():parseToJsonString(resData))
    return ParseBase.new():parseToJsonString(resData);
end

-- 反馈结果：解散房间申请反馈给其他玩家  等待其他玩家确认
function SocketResponseData:res_dissRoom_new2()
    local resData = {}

    local cmd = Sockets.cmd.dissRoom
    local data = {
        --room = {
            descript="***玩家申请解散房间", -- 房间号 
            overtime=150,
            choose=true,
            playerChooses={
                {descript="张三玩家同意解散",status="agreed"}, -- // 状态，wait：等待，agreed：同意
                {descript="李四玩家同意解散",status="agreed"},
            }        
        --}       
    }
    
    resData[ParseBase.cmd] = cmd;
    resData[ParseBase.data] = data;
    resData[ParseBase.msg] = RequestBase:new():getStrEncode("解散房间不扣除房卡，是否确认解散");
    resData[ParseBase.status] = 0;

    Commons:printLog_SocketReq("解散房间申请 假定tcp返回数据是：",ParseBase.new():parseToJsonString(resData))
    return ParseBase.new():parseToJsonString(resData);
end

-- 反馈结果：解散房间全部通过，通知大家
function SocketResponseData:res_dissRoom_success()
    local resData = {}

    local cmd = Sockets.cmd.dissRoom_success
    local data = {
        --room = {
            roomNo="1000", -- 房间号   
            success = false,
            descript =  RequestBase:new():getStrEncode("【谁谁】不同意解散！"),     
        --}       
    }

    --{"cmd":1002,"compress":0,"msg":"已经有解散申请在等待确认，请耐心等待！","status":2104}
    
    resData[ParseBase.cmd] = cmd;
    resData[ParseBase.data] = data;
    resData[ParseBase.msg] = RequestBase:new():getStrEncode("成功");
    resData[ParseBase.status] = 0;

    Commons:printLog_SocketReq("解散房间全部通过，通知大家 假定tcp返回数据是：",ParseBase.new():parseToJsonString(resData))
    return ParseBase.new():parseToJsonString(resData);
end


-- 反馈结果：登录房间  房主本人一个人登录了房间 
function SocketResponseData:res_loginRoom()
	local resData = {}

	local cmd = Sockets.cmd.loginRoom
    local data = {
        --room = {
        

            -- 这些值，游戏桌面是要显示对应图片的
                -- fanRule = "fan",
                -- multRule = "single",
                -- potRule = "y",
                mtRule = "quanMt", -- xiaoZhuo  daZhuo  laoMt quanMt
                isDlz = "y", -- y  n
                dlzLevel = 3, -- 1  2  3
                flzUnit = 200, -- 80  100  200

            
            roomNo="1000", -- 房间号
            rounds=10, --最大回合数
            playRound=0,--当前回合数
            playRoundNo=100,--当前回合编号
            --diCardsNum=18,--当前回合底牌数量
            status="created", --是否已开始游戏
            players=
            {   --玩家列表，元素为Player对象
                {
                    user={ --用户信息，User对象
                        account="6001",
                        nickname=RequestBase:getStrEncode("张三张三张三张三"),
                        icon=RequestBase:new():getStrEncode("http://wmq.res.apk.yuelaigame.com/icon/guest_boy.jpg"),
                        sex="male",
                        ip="192.168.1.11"
                    },
                    me=true,--这个对象是不是本人
                    netStatus="online", --网络状态
                    playStatus="wait",
                    seatNo=1, -- 座位编号
                    owner=false, -- 是否是房主
                    --role="z", -- 角色  z：庄家   x：闲家
                    score=1999, -- 当前玩家分数
                    --xi=1, -- 当前玩家的显示胡息数
                }
            }            
        --}		
	}
	
	resData[ParseBase.cmd] = cmd;
	resData[ParseBase.data] = data;
	resData[ParseBase.msg] = RequestBase:new():getStrEncode("成功");
	resData[ParseBase.status] = 0;

    Commons:printLog_SocketReq("登录房间 假定tcp返回数据是：",ParseBase.new():parseToJsonString(resData))
    return ParseBase.new():parseToJsonString(resData) .. "\n";
end

-- 反馈结果：登录房间  来了下一家
function SocketResponseData:res_loginRoom_playerLoginRoom_xiajia()
    local resData = {}

    local cmd = Sockets.cmd.gameing_playerLoginRoom
    local data = {
        --room = {
            roomNo="1000", -- 房间号
            rounds=10, --最大回合数
            playRound=0,--当前回合数
            playRoundNo=100,--当前回合编号
            --diCardsNum=18,--当前回合底牌数量
            status="created", --是否已开始游戏
            players=
            {   --玩家列表，元素为Player对象
                {
                    user={ --用户信息，User对象
                        account="6001",
                        nickname=RequestBase:getStrEncode("张三 xiajia"),
                        icon=RequestBase:new():getStrEncode("http://wmq.res.apk.yuelaigame.com/icon/guest_boy.jpg"),
                        sex="male",
                        ip="192.168.1.11"
                    },
                    me=true,--这个对象是不是本人
                    netStatus="online", --网络状态
                    playStatus="ready",
                    seatNo=1, -- 座位编号
                    owner=true, -- 是否是房主
                    --role="z", -- 角色  z：庄家   x：闲家
                    score=1999, -- 当前玩家分数
                    --xi=1, -- 当前玩家的显示胡息数
                }
                ,{
                    user={ --用户信息，User对象
                        account="6002",
                        nickname=RequestBase:getStrEncode("李四lisi李四李四"),
                        icon=RequestBase:new():getStrEncode("http://wmq.res.apk.yuelaigame.com/icon/guest_girl.png"),
                        sex="male",
                        ip="192.168.1.12"
                    },
                    me=false,--这个对象是不是本人
                    netStatus="online", --网络状态
                    playStatus="ready",
                    seatNo=2, -- 座位编号
                    owner=false, -- 是否是房主
                    --role="z", -- 角色  z：庄家   x：闲家
                    score=2999, -- 当前玩家分数
                    --xi=1, -- 当前玩家的显示胡息数
                }
            }            
        --}       
    }

    resData[ParseBase.cmd] = cmd;
    resData[ParseBase.data] = data;
    resData[ParseBase.msg] = RequestBase:new():getStrEncode("成功");
    resData[ParseBase.status] = 0;

    Commons:printLog_SocketReq("第2家上线 假定tcp返回数据是：",ParseBase.new():parseToJsonString(resData))
    return ParseBase.new():parseToJsonString(resData);
end


-- 反馈结果：登录房间  来了上一家，也是最后一家
function SocketResponseData:res_loginRoom_playerLoginRoom_lastjia()
    local resData = {}

    local cmd = Sockets.cmd.gameing_playerLoginRoom
    local data = {
        --room = {
            roomNo="1000", -- 房间号
            rounds=10, --最大回合数
            playRound=0,--当前回合数
            playRoundNo=100,--当前回合编号
            --diCardsNum=18,--当前回合底牌数量
            status="created", --是否已开始游戏
            players=
            {   --玩家列表，元素为Player对象
                {
                    user={ --用户信息，User对象
                        account="6001",
                        nickname=RequestBase:getStrEncode("张三 lastjia"),
                        icon=RequestBase:new():getStrEncode("http://wmq.res.apk.yuelaigame.com/icon/guest_boy.jpg"),
                        sex="male",
                        ip="192.168.1.11"
                    },
                    me=true,--这个对象是不是本人
                    netStatus="online", --网络状态
                    playStatus="ready",
                    seatNo=1, -- 座位编号
                    owner=true, -- 是否是房主
                    --role="z", -- 角色  z：庄家   x：闲家
                    score=1999, -- 当前玩家分数
                    --xi=1, -- 当前玩家的显示胡息数
                }
                ,{
                    user={ --用户信息，User对象
                        account="6002",
                        nickname=RequestBase:getStrEncode("李四"),
                        icon=RequestBase:new():getStrEncode("http://wmq.res.apk.yuelaigame.com/icon/guest_girl.png"),
                        sex="male",
                        ip="192.168.1.12"
                    },
                    me=false,--这个对象是不是本人
                    netStatus="online", --网络状态
                    playStatus="ready",
                    seatNo=2, -- 座位编号
                    owner=false, -- 是否是房主
                    --role="z", -- 角色  z：庄家   x：闲家
                    score=2999, -- 当前玩家分数
                    --xi=1, -- 当前玩家的显示胡息数
                }
                ,{
                    user={ --用户信息，User对象
                        account="6003",
                        nickname=RequestBase:getStrEncode("王五王五王五王五"),
                        icon=RequestBase:new():getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon1.jpg"),
                        sex="male",
                        ip="192.168.1.13"
                    },
                    me=false,--这个对象是不是本人
                    netStatus="online", --网络状态
                    playStatus="ready",
                    seatNo=0, -- 座位编号
                    owner=false, -- 是否是房主
                    --role="z", -- 角色  z：庄家   x：闲家
                    score=3999, -- 当前玩家分数
                    --xi=1, -- 当前玩家的显示胡息数
                }
            }           
        --}       
    }

    resData[ParseBase.cmd] = cmd;
    resData[ParseBase.data] = data;
    resData[ParseBase.msg] = RequestBase:new():getStrEncode("成功");
    resData[ParseBase.status] = 0;

    Commons:printLog_SocketReq("第3家上线 假定tcp返回数据是：",ParseBase.new():parseToJsonString(resData))
    return ParseBase.new():parseToJsonString(resData) .. "\n";
end

-- 反馈结果：游戏开始了，玩家离线
function SocketResponseData:res_gameing_playerExitRoom()
    local resData = {}

    local cmd = Sockets.cmd.gameing_playerExitRoom
    local data = {
        --room = {
            roomNo="1000", -- 房间号
            rounds=10, --最大回合数
            playRound=0,--当前回合数
            playRoundNo=100,--当前回合编号
            --diCardsNum=18,--当前回合底牌数量
            status="created", --是否已开始游戏
            seatNo = 2,
            players=
            {   --玩家列表，元素为Player对象
                {
                    user={ --用户信息，User对象
                        account="6001",
                        nickname=RequestBase:getStrEncode("张三 lastjia"),
                        icon=RequestBase:new():getStrEncode("http://wmq.res.apk.yuelaigame.com/icon/guest_boy.jpg"),
                        sex="male",
                        ip="192.168.1.11"
                    },
                    me=true,--这个对象是不是本人
                    netStatus="online", --网络状态
                    playStatus="ready",
                    seatNo=1, -- 座位编号
                    owner=true, -- 是否是房主
                    --role="z", -- 角色  z：庄家   x：闲家
                    score=1999, -- 当前玩家分数
                    --xi=1, -- 当前玩家的显示胡息数
                }
                ,{
                    user={ --用户信息，User对象
                        account="6002",
                        nickname=RequestBase:getStrEncode("李四"),
                        icon=RequestBase:new():getStrEncode("http://wmq.res.apk.yuelaigame.com/icon/guest_girl.png"),
                        sex="male",
                        ip="192.168.1.12"
                    },
                    me=false,--这个对象是不是本人
                    netStatus="offline", --网络状态
                    playStatus="ready",
                    seatNo=2, -- 座位编号
                    owner=false, -- 是否是房主
                    --role="z", -- 角色  z：庄家   x：闲家
                    score=2999, -- 当前玩家分数
                    --xi=1, -- 当前玩家的显示胡息数
                }
                ,{
                    user={ --用户信息，User对象
                        account="6003",
                        nickname=RequestBase:getStrEncode("王五"),
                        icon=RequestBase:new():getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon1.jpg"),
                        sex="male",
                        ip="192.168.1.13"
                    },
                    me=false,--这个对象是不是本人
                    netStatus="offline", --网络状态
                    playStatus="ready",
                    seatNo=0, -- 座位编号
                    owner=false, -- 是否是房主
                    --role="z", -- 角色  z：庄家   x：闲家
                    score=3999, -- 当前玩家分数
                    --xi=1, -- 当前玩家的显示胡息数
                }
            }           
        --}       
    }

    resData[ParseBase.cmd] = cmd;
    resData[ParseBase.data] = data;
    resData[ParseBase.msg] = RequestBase:new():getStrEncode("成功");
    resData[ParseBase.status] = 0;

    Commons:printLog_SocketReq("第3家上线 假定tcp返回数据是：",ParseBase.new():parseToJsonString(resData))
    return ParseBase.new():parseToJsonString(resData);
end

-- 反馈结果：玩家准备了
function SocketResponseData:res_gameing_Prepare()
    local resData = {}

    local cmd = Sockets.cmd.gameing_Prepare
    local data = {
        --room = {
            roomNo="1000", -- 房间号
            rounds=10, --最大回合数
            playRound=0,--当前回合数
            playRoundNo=100,--当前回合编号
            --diCardsNum=18,--当前回合底牌数量
            status="started", --是否已开始游戏
            seatNo = 2,
            players=
            {   --玩家列表，元素为Player对象
                {
                    user={ --用户信息，User对象
                        account="6001",
                        nickname=RequestBase:getStrEncode("张三 lastjia"),
                        icon=RequestBase:new():getStrEncode("http://wmq.res.apk.yuelaigame.com/icon/guest_boy.jpg"),
                        sex="male",
                        ip="192.168.1.11"
                    },
                    me=true,--这个对象是不是本人
                    netStatus="online", --网络状态
                    playStatus="ready",
                    seatNo=1, -- 座位编号
                    owner=true, -- 是否是房主
                    --role="z", -- 角色  z：庄家   x：闲家
                    score=1999, -- 当前玩家分数
                    --xi=1, -- 当前玩家的显示胡息数
                }
                ,{
                    user={ --用户信息，User对象
                        account="6002",
                        nickname=RequestBase:getStrEncode("李四"),
                        icon=RequestBase:new():getStrEncode("http://wmq.res.apk.yuelaigame.com/icon/guest_girl.png"),
                        sex="male",
                        ip="192.168.1.12"
                    },
                    me=false,--这个对象是不是本人
                    netStatus="offline", --网络状态
                    playStatus="ready",
                    seatNo=2, -- 座位编号
                    owner=false, -- 是否是房主
                    --role="z", -- 角色  z：庄家   x：闲家
                    score=2999, -- 当前玩家分数
                    --xi=1, -- 当前玩家的显示胡息数
                }
                ,{
                    user={ --用户信息，User对象
                        account="6003",
                        nickname=RequestBase:getStrEncode("王五"),
                        icon=RequestBase:new():getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon1.jpg"),
                        sex="male",
                        ip="192.168.1.13"
                    },
                    me=false,--这个对象是不是本人
                    netStatus="offline", --网络状态
                    playStatus="ready",
                    seatNo=0, -- 座位编号
                    owner=false, -- 是否是房主
                    --role="z", -- 角色  z：庄家   x：闲家
                    score=3999, -- 当前玩家分数
                    --xi=1, -- 当前玩家的显示胡息数
                }
            }           
        --}       
    }

    resData[ParseBase.cmd] = cmd;
    resData[ParseBase.data] = data;
    resData[ParseBase.msg] = RequestBase:new():getStrEncode("成功");
    resData[ParseBase.status] = 0;

    Commons:printLog_SocketReq("第3家上线 假定tcp返回数据是：",ParseBase.new():parseToJsonString(resData))
    return ParseBase.new():parseToJsonString(resData);
end

-- 反馈结果：游戏未开始  玩家跑路
function SocketResponseData:res_gameing_playerOutRoom()
    local resData = {}

    local cmd = Sockets.cmd.gameing_playerOutRoom
    local data = {
        --room = {
            seatNo = 2,          
        --}       
    }

    resData[ParseBase.cmd] = cmd;
    resData[ParseBase.data] = data;
    resData[ParseBase.msg] = RequestBase:new():getStrEncode("成功");
    resData[ParseBase.status] = 0;

    Commons:printLog_SocketReq("游戏未开始，玩家跑拉 假定tcp返回数据是：",ParseBase.new():parseToJsonString(resData))
    return ParseBase.new():parseToJsonString(resData);
end


-- 反馈结果：游戏开始
function SocketResponseData:res_gameing_Start()
    local resData = {}

    local cmd = Sockets.cmd.gameing_Start
    local data = {
        --room = {

            roomNo="800078", -- 房间号
            rounds=10, --最大回合数
            playRound=8,--当前回合数
            playRoundNo=101,--当前回合编号
            diCardsNum=21,--当前回合底牌数量
            status="started", --是否已开始游戏

            surpDlzScore = 70,

            players=
            {   --玩家列表，元素为Player对象
                {
                    user={ --用户信息，User对象
                        account="6001",
                        nickname=RequestBase:getStrEncode("张三是个撒撒撒"),
                        icon=RequestBase:new():getStrEncode("http://wmq.res.apk.yuelaigame.com/icon/guest_boy.jpg"),
                        sex="male",
                        ip="192.168.1.11"
                    },
                    me=true,--这个对象是不是本人
                    netStatus="online", --网络状态
                    playStatus="playing",
                    seatNo=1, -- 座位编号
                    owner=true, -- 是否是房主
                    role="z", -- 角色  z：庄家   x：闲家
                    score=1999, -- 当前玩家分数
                    xi=0, -- 当前玩家的显示胡息数

                    dlzScore = 30,

                    handCards={ --手牌
                        {"ans3"},
                        {"ans4","ans4","ans4"},
                        {"ans6","ans7"},
                        {"ans10"},
                        {"anb2","anb2"},
                        {"anb5"},
                        {"anb6","anb6"},
                        {"anb7"},
                        {"anb8"},
                        {"anb9","anb9"},
                        {"anb10","anb10","anb10"}
                    },

                    -- handCards={ --手牌
                    --     {"ans3","ans3","ans3"},
                    --     {"ans1"},
                    --     {"ans2"},
                    --     {"anb3","anb3"},
                    --     {"anb4"},
                    --     {"anb5"},
                    --     {"anb10"},
                    --     {"ans10","bnw0","bnw0"},
                    --     {"ans8"},
                    --     {"ans7"},
                    --     {"ans9"}
                    -- },
                    --chiCombs={ -- 吃、跑、碰的牌组合
                    --},
                    --chuCards={ -- 出过的牌
                    --},

                    -- options={
                    --     --"peng","chi","guo"
                    -- },
                    --chiDemos={  -- 本次要吃的选择
                    --},

                    --currChiCombs={},
                    --currOption="",
                    chu=true,--是不是我出牌
                }
                ,{
                    user={ --用户信息，User对象
                        account="6002",
                        nickname=RequestBase:getStrEncode("李四你是谁的老大"),
                        icon=RequestBase:new():getStrEncode("http://wmq.res.apk.yuelaigame.com/icon/guest_girl.png"),
                        sex="male",
                        ip="192.168.1.12"
                    },
                    me=false,--这个对象是不是本人
                    netStatus="online", --网络状态
                    playStatus="playing",
                    seatNo=2, -- 座位编号
                    owner=false, -- 是否是房主
                    role="x", -- 角色  z：庄家   x：闲家
                    score=2999, -- 当前玩家分数
                    xi=0, -- 当前玩家的显示胡息数

                    dlzScore = 20,
                    
                    --chiCombs={ -- 吃、跑、碰的牌组合
                    --},
                    --chuCards={ -- 出过的牌
                    --},

                    --options={
                    --    "peng","chi","guo"
                    --},
                    --chiDemos={  -- 本次要吃的选择
                    --},

                    --currChiCombs={},
                    --currOption="",
                    chu=false,--是不是我出牌
                }
                ,{
                    user={ --用户信息，User对象
                        account="6003",
                        nickname=RequestBase:getStrEncode("王五你个小瓜蛋子"),
                        icon=RequestBase:new():getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon1.jpg"),
                        sex="male",
                        ip="192.168.1.13"
                    },
                    me=false,--这个对象是不是本人
                    netStatus="online", --网络状态
                    playStatus="playing",
                    seatNo=0, -- 座位编号
                    owner=false, -- 是否是房主
                    role="x", -- 角色  z：庄家   x：闲家
                    score=3999, -- 当前玩家分数
                    xi=0, -- 当前玩家的显示胡息数

                    dlzScore = 20,
                    
                    --chiCombs={ -- 吃、跑、碰的牌组合
                        --{"nb5","nb5","nb5","nb5"},
                    --},
                    --chuCards={ -- 出过的牌
                    --},

                    --options={
                    --    "peng","chi","guo"
                    --},
                    --chiDemos={  -- 本次要吃的选择
                    --},

                    --currChiCombs={},
                    --currOption="",
                    chu=false,--是不是我出牌
                }
            }           
        --}       
    }

    resData[ParseBase.cmd] = cmd;
    resData[ParseBase.data] = data;
    resData[ParseBase.msg] = RequestBase:new():getStrEncode("成功");
    resData[ParseBase.status] = 0;

    Commons:printLog_SocketReq("游戏开始 假定tcp返回数据是：",ParseBase.new():parseToJsonString(resData))
    return ParseBase.new():parseToJsonString(resData);
end

-- 反馈结果：游戏中   吃牌  假设下家吃牌
function SocketResponseData:res_gameing_Chi_xiajia()
    local resData = {}

    local cmd = Sockets.cmd.gameing_Chi
    local data = {
        --room = {
            roomNo="1000", -- 房间号
            rounds=10, --最大回合数
            playRound=1,--当前回合数
            playRoundNo=101,--当前回合编号
            diCardsNum=0,--当前回合底牌数量
            diCards = {
                "ans1","ans2","ans3","ans4","ans5",
                "ans6","ans7","ans8","ans9","ans10",
                "anb1","anb2","anb3","anb4","anb5",
                "anb6","anb7","anb8","anb9","anb10",
                "anw0","anw0"
            }, -- 底牌列表
            status="started", --是否已开始游戏
            players=
            {   --玩家列表，元素为Player对象
                {
                    user={ --用户信息，User对象
                        account="6001",
                        nickname=RequestBase:getStrEncode("张三 lastjia"),
                        icon=RequestBase:new():getStrEncode("http://wmq.res.apk.yuelaigame.com/icon/guest_boy.jpg"),
                        sex="male",
                        ip="192.168.1.11"
                    },
                    me=true,--这个对象是不是本人
                    netStatus="offline", --网络状态
                    playStatus="playing",
                    gameStatus = "xxg",
                    seatNo=1, -- 座位编号
                    owner=true, -- 是否是房主
                    role="z", -- 角色  z：庄家   x：闲家
                    score=1999, -- 当前玩家分数
                    xi=3, -- 当前玩家的显示胡息数
                    handCards={ --手牌
                        {"ans1"},
                        {"ans2"},
                        {"ans3","ans3"},--"ans3"},
                        {"anb3","anb3"},
                        {"anb4"},
                        {"anb5"},
                        {"anb10"},
                        {"ans10","bnw0","bnw0"},
                        {"ans8"},
                        {"ans7"},
                        {"ans9"},{"ans9"}
                    },
                    chiCombs={ -- 吃、跑、碰的牌组合
                        --{"ays7","ays7","ays7","ays7"},
                        --{"anb4","anb5","anb6"},
                        --{"ans1","ans2","ans3"}
                    },
                    chuCards={ -- 出过的牌
                        "anb1","ans2","ans3","anb4","anb5",
                        "anb6","anb7","anb8","anb9","anb9",
                        "anb9",
                    },
                    chuCardIndexs={ -- 出过的牌   自己打出来的是哪些
                        0,2,4,6,7
                    },

                    -- options={
                    --     --"peng","chi","guo"
                    -- },
                    --chiDemos={  -- 本次要吃的选择
                    --},

                    --currChiCombs={
                    --    "ans1","ans2","ays3"
                    --},
                    --currOption="chi",-- chi peng wei ti hu xiahuo  guo

                    chu=false,--是不是我出牌
                }
                ,{
                    user={ --用户信息，User对象
                        account="6002",
                        nickname=RequestBase:getStrEncode("李四"),
                        icon=RequestBase:new():getStrEncode("http://wmq.res.apk.yuelaigame.com/icon/guest_girl.png"),
                        sex="male",
                        ip="192.168.1.12"
                    },
                    me=false,--这个对象是不是本人
                    netStatus="offline", --网络状态
                    playStatus="playing",
                    gameStatus = "xxg",
                    seatNo=2, -- 座位编号
                    owner=false, -- 是否是房主
                    role="x", -- 角色  z：庄家   x：闲家
                    score=2999, -- 当前玩家分数
                    xi=6, -- 当前玩家的显示胡息数
                    
                    chiCombs={ -- 吃、跑、碰的牌组合
                        {"ans1","ans1","ans1"},
                        --{"anb5","anb6","ayb7"},
                        --{"anb5","anb6","ayb7"},
                        --{"anb5","anb6","ayb7"},
                        --{"anb5","anb6","ayb7"},
                        --{"anb5","anb6","ayb7"},
                        --{"ans5","ans6","ays7"},
                    },
                    chuCards={ -- 出过的牌
                        "anb1","ans2","ans3","anb4","anb5",
                        "anb6","anb7","anb8","anb9","anb10",
                        "anw0","ans8",
                    },
                    chuCardIndexs={ -- 出过的牌   自己打出来的是哪些
                        0,2,4,6
                    },

                    action={card="anb5",type="mo",actionNo="abcd1212_111"},

                    --options={
                    --    "peng","chi","guo"
                    --},
                    --chiDemos={  -- 本次要吃的选择
                    --},

                    currChiCombs={
                       --{"ans1"},
                       {"ans1","ans1","ans1","ans1"},
                       --{"anb1","anb2","ayb3"},
                    },
                    currOption="peng",-- chi peng wei ti hu xiahuo  guo

                    chu=false,--是不是我出牌
                }
                ,{
                    user={ --用户信息，User对象
                        account="6003",
                        nickname=RequestBase:getStrEncode("王五"),
                        icon=RequestBase:new():getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon1.jpg"),
                        sex="male",
                        ip="192.168.1.13"
                    },
                    me=false,--这个对象是不是本人
                    netStatus="offline", --网络状态
                    playStatus="playing",
                    gameStatus = "xxg",
                    seatNo=0, -- 座位编号
                    owner=false, -- 是否是房主
                    role="z", -- 角色  z：庄家   x：闲家
                    score=3999, -- 当前玩家分数
                    xi=9, -- 当前玩家的显示胡息数
                    
                    chiCombs={ -- 吃、跑、碰的牌组合
                        --{"ans7","ans8","ans9"},
                        {"anb7","anb8","ayb9"},
                        {"anb4","anb4","anb4","anb4"},
                    },
                    chuCards={ -- 出过的牌
                        "anb1","ans2","ans3","anb4","anb5",
                        "anb6","anb7","anb8","anb9","anb9",
                        "anb9",
                    },
                    chuCardIndexs={ -- 出过的牌   自己打出来的是哪些
                        0,2,4,6
                    },

                    -- action={card="anb6",type="mo",actionNo="abcd1212"},

                    -- -- options={
                    -- --    "peng","chi","guo"
                    -- -- },
                    -- --chiDemos={  -- 本次要吃的选择
                    -- --},

                    -- currChiCombs={
                    --     --{"ans1"},
                    --     -- {"ans1","ans2","ays3"},
                    --     {"anb3","anb3","anb3","anb3"},
                    -- },
                    -- currOption="wei",-- chi peng wei ti hu xiahuo  guo

                    chu=true,--是不是我出牌
                }
            }           
        --}       
    }

    resData[ParseBase.cmd] = cmd;
    resData[ParseBase.data] = data;
    resData[ParseBase.msg] = RequestBase:new():getStrEncode("成功");
    resData[ParseBase.status] = 0;

    Commons:printLog_SocketReq("下家吃牌 假定tcp返回数据是：",ParseBase.new():parseToJsonString(resData))
    return ParseBase.new():parseToJsonString(resData);
end

-- 反馈结果：游戏中   吃牌  假设本人吃牌
function SocketResponseData:res_gameing_Chi_myself(_currOption)
    if _currOption == nil then
        _currOption = "peng"
    end

    local resData = {}

    local cmd = Sockets.cmd.gameing_Chi
    local data = {
        --room = {
            roomNo="1000", -- 房间号
            rounds=10, --最大回合数
            playRound=1,--当前回合数
            playRoundNo=101,--当前回合编号
            diCardsNum=18,--当前回合底牌数量
            diCards = {
                -- "ans1","ans2","ans3","ans4","ans5",
                -- "ans6","ans7","ans8","ans9","ans10",
                "anb1","anb2","anb3","anb4","anb5",
                "anb6","anb7","anb8","anb9","anb10",
                "anw0","anw0"
            }, -- 底牌列表
            status="started", --是否已开始游戏
            players=
            {   --玩家列表，元素为Player对象
                {
                    user={ --用户信息，User对象
                        account="6001",
                        nickname=RequestBase:getStrEncode("张三 lastjia"),
                        icon=RequestBase:new():getStrEncode("http://wmq.res.apk.yuelaigame.com/icon/guest_boy.jpg"),
                        sex="male",
                        ip="192.168.1.11"
                    },
                    me=true,--这个对象是不是本人
                    netStatus="online", --网络状态
                    playStatus="playing",
                    seatNo=1, -- 座位编号
                    owner=true, -- 是否是房主
                    role="z", -- 角色  z：庄家   x：闲家
                    score=1999, -- 当前玩家分数
                    xi=13, -- 当前玩家的显示胡息数

                    handCards={ --手牌
                        {"ans3"},
                        {"ans4","ans4","ans4"},
                        {"ans6","ans7"},
                        {"ans10"},
                        {"anb2","anb2"},
                        {"anb5"},
                        {"anb6","anb6"},
                        {"anb7"},
                        {"anb8"},
                        -- {"anb9","anb9"},
                        {"anb10","anb10","anb10"}
                    },
                    
                    -- handCards={ --手牌
                    --     {"cns3"},--,"cns3","cns3"},
                    --     {"ans1"},
                    --     {"ans2"},
                    --     {"anb3","anb3"},
                    --     {"anb4"},
                    --     {"anb5"},
                    --     {"anb10"},
                    --     {"ans10","bnw0","bnw0"},
                    --     {"ans8"},
                    --     {"ans7"},
                    --     {"ans9"}
                    -- },
                    chiCombs={ -- 吃、跑、碰的牌组合
                        {"ans7","ans7","ans7","ans7"},
                        {"ayb4","anb5","anb6"},
                        {"ays1","ans2","ans3"},
                        --{"ans1","ans2","ans3"},
                        --{"ans1","ans2","ans3"},
                        --{"ans1","ans2","ans3"},
                        --{"ans1","ans2","ans3"},
                    },
                    chuCards={ -- 出过的牌
                        "anb1","ays2","afs3","anb4","anb5",
                        "anb6","anb7",
                        "anb8","anb9"
                    },
                    action={card="ans5",type="other",actionNo="abcd1212"},

                    -- options={
                    --      "chi", "peng", "guo", "hu", --"wei", "ti", --"xiahuo"  
                    -- },
                    -- chiDemos={
                    -- },

                    currChiCard = "anb9",
                    currRemoveCards = {"anb9","anb9"},
                    -- changeCards = {"bn10"},
                    currChiCombs={
                        --{"ans1"}
                        --{"ans1","ans2","ays3"},
                        --{"anb3","anb4","anb5"},
                        {"anb9","anb9","anb9"}
                    },
                    currOption=_currOption,-- chi peng wei ti hu xiahuo  guo
                    chu=true,--是不是我出牌
                }
                ,{
                    user={ --用户信息，User对象
                        account="6002",
                        nickname=RequestBase:getStrEncode("李四"),
                        icon=RequestBase:new():getStrEncode("http://wmq.res.apk.yuelaigame.com/icon/guest_girl.png"),
                        sex="male",
                        ip="192.168.1.12"
                    },
                    me=false,--这个对象是不是本人
                    netStatus="online", --网络状态
                    playStatus="playing",
                    seatNo=2, -- 座位编号
                    owner=false, -- 是否是房主
                    role="x", -- 角色  z：庄家   x：闲家
                    score=2999, -- 当前玩家分数
                    xi=16, -- 当前玩家的显示胡息数
                    
                    chiCombs={ -- 吃、跑、碰的牌组合
                        {"ans1","ans1","ans1"},
                        --{"anb5","anb6","ayb7"},
                        --{"anb5","anb6","ayb7"},
                        --{"anb5","anb6","ayb7"},
                        --{"anb5","anb6","ayb7"},
                        --{"anb5","anb6","ayb7"},
                        --{"ans5","ans6","ays7"},
                    },
                    chuCards={ -- 出过的牌
                    },

                    --options={
                    --},
                    --chiDemos={  -- 本次要吃的选择
                    --},

                    --currChiCombs={
                    --},
                    --currOption="",-- chi peng wei ti hu xiahuo  guo
                    chu=false,--是不是我出牌
                }
                ,{
                    user={ --用户信息，User对象
                        account="6003",
                        nickname=RequestBase:getStrEncode("王五"),
                        icon=RequestBase:new():getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon1.jpg"),
                        sex="male",
                        ip="192.168.1.13"
                    },
                    me=false,--这个对象是不是本人
                    netStatus="online", --网络状态
                    playStatus="playing",
                    seatNo=0, -- 座位编号
                    owner=false, -- 是否是房主
                    role="x", -- 角色  z：庄家   x：闲家
                    score=3999, -- 当前玩家分数
                    xi=19, -- 当前玩家的显示胡息数

                    chiCombs={ -- 吃、跑、碰的牌组合
                         {"anb4","anb4","anb4","anb4"},
                    },
                    chuCards={ -- 出过的牌
                    },

                    --options={
                    --},
                    --chiDemos={  -- 本次要吃的选择
                    --},

                    --currChiCombs={
                    --},
                    --currOption="",-- chi peng wei ti hu xiahuo  guo
                    chu=false,--是不是我出牌
                }
            }           
        --}       
    }

    resData[ParseBase.cmd] = cmd;
    resData[ParseBase.data] = data;
    resData[ParseBase.msg] = RequestBase:new():getStrEncode("成功");
    resData[ParseBase.status] = 0;

    Commons:printLog_SocketReq("本人吃牌 假定tcp返回数据是：",ParseBase.new():parseToJsonString(resData))
    return ParseBase.new():parseToJsonString(resData);
end

-- 反馈结果：游戏中   吃牌  假设本人吃牌  并且下火
function SocketResponseData:res_gameing_Chi_myself_andXiahuo()
    return SocketResponseData:res_gameing_Chi_myself("xiahuo")
end

-- 反馈结果：游戏中   吃牌  假设本人碰牌
function SocketResponseData:res_gameing_Chi_myself_peng()
    return SocketResponseData:res_gameing_Chi_myself("peng")
end



-- 反馈结果：游戏中   吃牌  假设本人吃牌
function SocketResponseData:res_gameing_Chi_myself_needChi()
    local resData = {}

    local cmd = Sockets.cmd.gameing_Chi
    local data = {
        --room = {
            roomNo="1000", -- 房间号
            rounds=10, --最大回合数
            playRound=1,--当前回合数
            playRoundNo=101,--当前回合编号
            diCardsNum=20,--当前回合底牌数量
            diCards = {
                -- "ans1","ans2","ans3","ans4","ans5",
                -- "ans6","ans7","ans8","ans9","ans10",
                -- "anb1","anb2","anb3","anb4","anb5",
                -- "anb6","anb7","anb8","anb9","anb10",
                "anw0","anw0"
            }, -- 底牌列表
            status="started", --是否已开始游戏
            players=
            {   --玩家列表，元素为Player对象
                {
                    user={ --用户信息，User对象
                        account="6001",
                        nickname=RequestBase:getStrEncode("张三 lastjia"),
                        icon=RequestBase:new():getStrEncode("http://wmq.res.apk.yuelaigame.com/icon/guest_boy.jpg"),
                        sex="male",
                        ip="192.168.1.11"
                    },
                    me=true,--这个对象是不是本人
                    netStatus="online", --网络状态
                    playStatus="playing",
                    seatNo=1, -- 座位编号
                    owner=true, -- 是否是房主
                    role="z", -- 角色  z：庄家   x：闲家
                    score=1999, -- 当前玩家分数
                    xi=3, -- 当前玩家的显示胡息数

                    handCards={ --手牌
                        {"ans1"},
                        {"ans2"},
                        {"cns3","cns3","cns3"},
                        {"anb3","anb3"},
                        {"anb4"},
                        {"anb5"},
                        {"anb10"},
                        {"ans10","bnw0","bnw0"},
                        {"ans8"},
                        {"ans7"},
                        {"ans9"}
                    },
                    chiCombs={ -- 吃、跑、碰的牌组合
                        {"ays7","ays7","ays7","ays7"},
                        --{"anb4","anb5","anb6"},
                        --{"ans1","ans2","ans3"}
                    },
                    --chuCards={ -- 出过的牌
                    --},
                    --action={card="anb6",type="mo",actionNo="abcd1212"},

                    options={
                         --"wc", 
                         -- "hu", 
                         "chi", 
                         -- "peng", 
                         "guo", 
                         --"wei", 
                         --"ti", 
                         --"xiahuo"  
                    },
                    chiDemos={  -- 本次要吃的选择
                        {chiComb={"ays1","ans2","ans3"},
                                    biDemos={
                                            {biComb={"ays1","ans2","ans3"},nextBiCombs={{"ays1","ans2","ans3"},{"ays4","ans5","ans6"}} },
                                            {biComb={"ays4","ans5","ans6"},nextBiCombs={{"ayb1","anb2","anb3"},{"ayb4","anb5","anb6"}} }
                                        }
                        },
                        -- {chiComb={"ays4","anb5","anb6"},
                        --             biDemos={
                        --                     {biComb={"ays7","ans8","ans9"},nextBiCombs={{"ays7","ans8","ans9"},{"ayb7","anb8","anb9"}} },
                        --                     {biComb={"ays4","ans5","ans6"} }
                        --                  }
                        -- },
                        -- {chiComb={"ays7","ans8","ans9"},
                        --             biDemos={
                        --                     {biComb={"ayb7","anb8","anb9"},nextBiCombs={{"ays10","anb10","anb10"}} },
                        --                  }
                        -- },
                        -- {chiComb={"ayb1","anb2","anb3"},
                        --             biDemos={
                        --                     {biComb={"ays7","ans5","ans6"},nextBiCombs={} },
                        --                  }
                        -- },
                        -- {chiComb={"ayb4","anb5","anb6"},
                        -- }
                    },

                    currChiCombs={
                        --{"ans1"}
                        {"ans4","ans4","ays4","ays4"},
                        --{"anb1","anb2","ayb3"},
                        --{"anb1","anb2","ayb3"}
                    },
                    currOption="wei",-- chi peng wei ti hu xiahuo  guo
                    chu=true,--是不是我出牌
                }
                ,{
                    user={ --用户信息，User对象
                        account="6002",
                        nickname=RequestBase:getStrEncode("李四"),
                        icon=RequestBase:new():getStrEncode("http://wmq.res.apk.yuelaigame.com/icon/guest_girl.png"),
                        sex="male",
                        ip="192.168.1.12"
                    },
                    me=false,--这个对象是不是本人
                    netStatus="online", --网络状态
                    playStatus="playing",
                    seatNo=2, -- 座位编号
                    owner=false, -- 是否是房主
                    role="x", -- 角色  z：庄家   x：闲家
                    score=2999, -- 当前玩家分数
                    xi=6, -- 当前玩家的显示胡息数

                    chiCombs={ -- 吃、跑、碰的牌组合
                         {"ans1","ans1","ans1"},
                    },
                    --chuCards={ -- 出过的牌
                    --},
                    action={card="ans3",type="chu",actionNo="abcd1212"},

                    --options={
                    --},
                    --chiDemos={  -- 本次要吃的选择
                    --},

                    --currChiCombs={
                    --},
                    --currOption="",-- chi peng wei ti hu xiahuo  guo
                    chu=false,--是不是我出牌
                }
                ,{
                    user={ --用户信息，User对象
                        account="6003",
                        nickname=RequestBase:getStrEncode("王五"),
                        icon=RequestBase:new():getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon1.jpg"),
                        sex="male",
                        ip="192.168.1.13"
                    },
                    me=false,--这个对象是不是本人
                    netStatus="online", --网络状态
                    playStatus="playing",
                    seatNo=0, -- 座位编号
                    owner=false, -- 是否是房主
                    role="x", -- 角色  z：庄家   x：闲家
                    score=3999, -- 当前玩家分数
                    xi=9, -- 当前玩家的显示胡息数

                    chiCombs={ -- 吃、跑、碰的牌组合
                         {"anb4","anb4","anb4","anb4"},
                    },
                    --chuCards={ -- 出过的牌
                    --},
                    -- action={card="anb6",type="chu",actionNo="abcd1212"},

                    --options={
                    --},
                    --chiDemos={  -- 本次要吃的选择
                    --},

                    --currChiCombs={
                    --},
                    --currOption="",-- chi peng wei ti hu xiahuo  guo
                    chu=false,--是不是我出牌
                }
            }           
        --}       
    }

    resData[ParseBase.cmd] = cmd;
    resData[ParseBase.data] = data;
    resData[ParseBase.msg] = RequestBase:new():getStrEncode("成功");
    resData[ParseBase.status] = 0;

    Commons:printLog_SocketReq("本人需要吃牌 假定tcp返回数据是：",ParseBase.new():parseToJsonString(resData))
    return ParseBase.new():parseToJsonString(resData);
end


-- 反馈结果：游戏结束之后的信息
function SocketResponseData:res_gameing_Over()
    local resData = {}

    local cmd = Sockets.cmd.gameing_Over
    local data = {
        --room = {
            roomNo="1111", -- 房间号
            rounds=10, --最大回合数
            playRound=1,--当前回合数
            playRoundNo=101,--当前回合编号
            diCardsNum=8,--当前回合底牌数量
            status="started", --是否已开始游戏  started  ended

            surpDlzScore = 70,

            players=
            {   --玩家列表，元素为Player对象
                {
                    me=true,--这个对象是不是本人
                    -- netStatus="online", --网络状态
                    -- playStatus="playing",
                    seatNo=1, -- 座位编号
                    -- owner=true, -- 是否是房主
                    -- role="z", -- 角色  z：庄家   x：闲家
                    score=1999, -- 当前玩家分数
                    -- xi=3, -- 当前玩家的显示胡息数

                    -- dlzScore = 30,

                    chiCombs={ -- 吃、跑、碰的牌组合
                        {"ays9","ays9","ays9","ays9"},
                        --{"anb4","anb5","anb6"},
                        --{"ans1","ans2","ans3"}
                    },
                }
                ,{
                    me=false,--这个对象是不是本人
                    -- netStatus="online", --网络状态
                    -- playStatus="playing",
                    seatNo=2, -- 座位编号
                    -- owner=false, -- 是否是房主
                    -- role="x", -- 角色  z：庄家   x：闲家
                    score=2999, -- 当前玩家分数
                    -- xi=6, -- 当前玩家的显示胡息数

                    -- dlzScore = 20,

                    chiCombs={ -- 吃、跑、碰的牌组合
                         {"ans9","ans9","ans9"},
                    },
                }
                ,{
                    me=false,--这个对象是不是本人
                    -- netStatus="online", --网络状态
                    -- playStatus="playing",
                    seatNo=0, -- 座位编号
                    -- owner=false, -- 是否是房主
                    -- role="x", -- 角色  z：庄家   x：闲家
                    score=3999, -- 当前玩家分数
                    -- xi=9, -- 当前玩家的显示胡息数

                    -- dlzScore = 20,

                    chiCombs={ -- 吃、跑、碰的牌组合
                         {"ans3","ans3","ans3"},
                         {"anb6","anb6","anb6"},
                         {"cg","cfb7","cfb7"},
                         {"cfb2","cfb2","cfb2"}
                    },
                }
            },
            
            roundRecords = { -- 回合结束
                {
                    user={ --用户信息，User对象
                        account="6001",
                        nickname=RequestBase:getStrEncode("张三lastjia"),
                        icon=RequestBase:new():getStrEncode("http://wmq.res.apk.yuelaigame.com/icon/guest_boy.jpg"),
                        sex="male",
                        ip="192.168.111.111"
                    },
                    role="z", -- 是不是庄家
                    me = true, -- 是本人
                    seatNo = 1,
                    owner = true, -- 我是房主
                    hu = false, -- 是不是胡牌的人 true  false
                    score = 5000, -- 分数
                    xi = 16, -- 息数
                    sumXi = 10000, -- 总息

                    flzScore = 80, -- 赢的人，超过18硬息，才分溜子分数
                    -- dlzScore = 30,

                    -- deng = 20, -- 等数
                    -- fan = 10000, -- 番数
                    -- fanRule = "fan",
                    -- fanCard = "anw0", -- 胡之后翻出的那张牌
                    -- fanNum = 2, -- 增加了几等
                    -- xingCard = "anw0",
                    
                    huCard = "anb1", -- 胡的牌是什么
                    -- wbMt = "wd",

                    mts = {
                        "红胡 x2",
                        "点胡 x2",
                        "黑胡 x4",
                        "王霸 x4",
                        "王钓王 x8",
                        "王闯 x8",
                        "自摸 x2",
                        --"名堂列表 名堂列表 名堂列表 名堂列表 名堂列表"
                    }, -- 名堂列表
                    diCards = {
                        "ans1","ans2","ans3","ans4","ans5",
                        "ans6","ans7","ans8","ans9","ans10",
                        "anb1","anb2","anb3","anb4","anb5",
                        "anb6","anb7","anb8","anb9","anb10",
                        "anw0","anw0"
                    }, -- 底牌列表
                    
                    cardCombs = { -- 胡牌组合  最多7组
                        -- {option="chi",cards={"ans1","ans2","ans3","anb3"}, xi=3},
                        -- {option="peng",cards={"anb2","anb2","anb3"}, xi=6},
                        -- {option="wei",cards={"anb4","anb4","anb4","anb4"}, xi=12},
                        -- {option="ti",cards={"anb4","anb4","anb4","anb4"}, xi=12},
                        -- {option="ti8",cards={"anb4","anb4","anb4","anb4"}, xi=12},
                        -- {option="",cards={"anb4","anb4","anb4","anb4"}, xi=0},
                        -- {option="",cards={"anb4","anb4","anb4","anb4"}, xi=0},

                        {cards={"anb4","ans4","ans4"}, option="chi", xi=0,indexNo=0},
                        {cards={"ans4","ans5","ans6"}, option="chi", xi=0},
                        {cards={"anb8","anb8","anb8"}, option="peng", xi=3},
                        {cards={"anb2","anb7","anb10"}, option="chi", xi=6},
                        {cards={"anb2","anb7","anb10"}, option="chi", xi=6},
                        {cards={"anb3","anb3","anw0","anw0"}, option="ti", xi=12},
                        {cards={"anb5","anb5"}, option="jiang", xi=0}
                    }
                },
                {
                    user={ --用户信息，User对象
                        account="6002",
                        nickname=RequestBase:getStrEncode("李四"),
                        icon=RequestBase:new():getStrEncode("http://wmq.res.apk.yuelaigame.com/icon/guest_girl.png"),
                        sex="male",
                        ip="192.168.111.123"
                    },
                    role="x", -- 是不是庄家
                    me = false, -- 是本人
                    seatNo = 2,
                    owner = false, -- 我是房主
                    hu = false, -- 是不是胡牌的人 true  false
                    score = -2500, -- 分数
                    xi = 8, -- 息数
                    -- sumXi = -5000, -- 总息

                    -- flzScore = 80, -- 赢的人，超过18硬息，才分溜子分数
                    -- dlzScore = 30,

                    deng = 20, -- 等数
                    fan = 10000, -- 番数
                    fanRule = "fan",
                    fanCard = "ans3", -- 胡之后翻出的那张牌

                    huCard = "anb1", -- 胡的牌是什么
                    wbMt = "wd",

                    mts = {"hong","dian","hei","wd","wdw","wc","mo"}, -- 名堂列表
                    diCards = {"ans1","ans2","ans3","ans4","ans5","ans6","ans7","ans8","ans9","ans10","anb1","anb2"}, -- 底牌列表

                    holeCards={ --手牌
                        {"cns3","cns3","cns3"},
                        {"ans1"},
                        {"ans2"},
                        {"anb3","anb3"},
                        -- {"anb4"},
                        -- {"anb5"},
                        -- {"anb10"},
                        -- {"ans10","bnw0","bnw0"},
                        -- {"ans8"},
                        -- {"ans7"},
                        -- {"ans9"}
                    },

                    cardCombs = { -- 胡牌组合  最多7组
                        {option="chi",cards={"ans1","ans2","ans3","anb3"}, xi=3,indexNo=1},
                        {option="peng",cards={"anb2","anb2","anb3"}, xi=6},
                        {option="wei",cards={"anb4","anb4","anb4","anb4"}, xi=12},
                        {option="ti",cards={"anb4","anb4","anb4","anb4"}, xi=12},
                        {option="ti8",cards={"anb4","anb4","anb4","anb4"}, xi=12},
                        {option="",cards={"anb4","anb4","anb4","anb4"}, xi=0},
                        {option="",cards={"anb4","anb4","anb4","anb4"}, xi=0},
                    }
                },
                {
                    user={ --用户信息，User对象
                        account="6003",
                        nickname=RequestBase:getStrEncode("王五王五王五王五"),
                        icon=RequestBase:new():getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon1.jpg"),
                        sex="male",
                        ip="192.168.111.133"
                    },
                    role="x", -- 是不是庄家
                    me = false, -- 是本人
                    seatNo = 0,
                    owner = false, -- 我是房主
                    hu = true, -- 是不是胡牌的人 true  false
                    score = -2500, -- 分数
                    xi = 6, -- 息数
                    -- sumXi = -4000, -- 总息

                    -- flzScore = 80, -- 赢的人，超过18硬息，才分溜子分数
                    -- dlzScore = 30,

                    deng = 20, -- 等数
                    fan = 10000, -- 番数
                    fanRule = "fan",
                    fanCard = "ans3", -- 胡之后翻出的那张牌

                    huCard = "anb1", -- 胡的牌是什么
                    wbMt = "wd",

                    mts = {"hong","dian","hei","wd","wdw","wc","mo"}, -- 名堂列表
                    diCards = {"ans1","ans2","ans3","ans4","ans5","ans6","ans7","ans8","ans9","ans10","anb1","anb2"}, -- 底牌列表

                    holeCards={ --手牌
                        {"anb5","anb5","anb5"},
                        {"anb8","anb8","ans8"},
                        {"ans9","ans10"},
                        -- {"anb3","anb3"},
                        -- {"anb4"},
                        -- {"anb5"},
                        -- {"anb10"},
                        -- {"ans10","bnw0","bnw0"},
                        -- {"ans8"},
                        -- {"ans7"},
                        -- {"ans9"}
                    },

                    cardCombs = { -- 胡牌组合  最多7组
                        {option="chi",cards={"ans1","ans2","ans3","anb3"}, xi=3,indexNo=2},
                        {option="peng",cards={"anb2","anb2","anb3"}, xi=6},
                        {option="wei",cards={"anb4","anb4","anb4","anb4"}, xi=12},
                        {option="ti",cards={"anb4","anb4","anb4","anb4"}, xi=12},
                        {option="ti8",cards={"anb4","anb4","anb4","anb4"}, xi=12},
                        {option="",cards={"anb4","anb4","anb4","anb4"}, xi=0},
                        {option="",cards={"anb4","anb4","anb4","anb4"}, xi=0},
                    }
                },
            },

            ---[[
            roomRecords = { -- 游戏结束
               {
                    user={ --用户信息，User对象
                        account="6001",
                        nickname=RequestBase:getStrEncode("张三last"),
                        icon=RequestBase:new():getStrEncode("http://wmq.res.apk.yuelaigame.com/icon/guest_boy.jpg"),
                        sex="male",
                        ip="192.168.111.111"
                    },
                    owner = true, -- 我是房主
                    score = 5000, -- 分数
                    winner = true,
                    bigWinner = true,
                    huTimes = 16, -- 胡牌次数
                    mtTimes = 20, -- 名堂次数

                    flzScore = 200,
                    -- gameScore = 100,
                },
                {
                    user={ --用户信息，User对象
                        account="6002",
                        nickname=RequestBase:getStrEncode("李四李四李四"),
                        icon=RequestBase:new():getStrEncode("http://wmq.res.apk.yuelaigame.com/icon/guest_girl.png"),
                        sex="male",
                        ip="192.168.111.123"
                    },
                    owner = true, -- 我是房主
                    score = -2500, -- 分数
                    winner = true,
                    bigWinner = true,
                    huTimes = 8, -- 胡牌次数
                    mtTimes = 30, -- 名堂次数

                    flzScore = 0,
                    -- gameScore = 110,
                },
                {
                    user={ --用户信息，User对象
                        account="6003",
                        nickname=RequestBase:getStrEncode("王五王五王五王五"),
                        icon=RequestBase:new():getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon1.jpg"),
                        sex="male",
                        ip="192.168.111.133"
                    },
                    owner = true, -- 我是房主
                    score = -2500, -- 分数
                    winner = false,
                    bigWinner = true,
                    huTimes = 6, -- 息数
                    mtTimes = 50, -- 名堂次数

                    flzScore = -10,
                    -- gameScore = 120,
                },
            }
            --]]

        --}       
    }

    resData[ParseBase.cmd] = cmd;
    resData[ParseBase.data] = data;
    resData[ParseBase.msg] = RequestBase:new():getStrEncode("成功");
    resData[ParseBase.status] = 0;

    Commons:printLog_SocketReq("游戏结束 回合 假定tcp返回数据是：",ParseBase.new():parseToJsonString(resData))
    return ParseBase.new():parseToJsonString(resData);
end


-- 反馈结果：游戏中的表情
function SocketResponseData:res_gameing_SendEmoji(_code, _seatNo)
    local resData = {}

    if _code == nil then
        _code = "sj"
    end
    if _seatNo == nil then
        _seatNo = 2
    end

    local cmd = Sockets.cmd.gameing_SendEmoji
    local data = {
        --room = {
            code = _code, -- 表情代号 bf sj cl
            seatNo = _seatNo, --座位编号，发送者的
        --}       
    }

    resData[ParseBase.cmd] = cmd;
    resData[ParseBase.data] = data;
    resData[ParseBase.msg] = RequestBase:new():getStrEncode("成功");
    resData[ParseBase.status] = 0;

    Commons:printLog_SocketReq("游戏中的表情 回合 假定tcp返回数据是：",ParseBase.new():parseToJsonString(resData))
    return ParseBase.new():parseToJsonString(resData);
end

-- 反馈结果：游戏中的短语
function SocketResponseData:res_gameing_SendWords(_code, _seatNo)
    local resData = {}

    if _code == nil then
        _code = "s01"
    end
    if _seatNo == nil then
        _seatNo = 2
    end

    local cmd = Sockets.cmd.gameing_SendWords
    local data = {
        --room = {
            code = _code, -- 代号 s01 s02 s03
            seatNo = _seatNo, --座位编号，发送者的
        --}       
    }

    resData[ParseBase.cmd] = cmd;
    resData[ParseBase.data] = data;
    resData[ParseBase.msg] = RequestBase:new():getStrEncode("成功");
    resData[ParseBase.status] = 0;

    Commons:printLog_SocketReq("游戏中的短语 回合 假定tcp返回数据是：", ParseBase.new():parseToJsonString(resData))
    return ParseBase.new():parseToJsonString(resData);
end

-- 反馈结果：游戏中的录音
function SocketResponseData:res_gameing_SendVoice(_voiceUrl, _seatNo)
    local resData = {}

    if _voiceUrl == nil then
        _voiceUrl = "http://wmq.res.apk.yuelaigame.com/test/testVoiceMe_huang.wav"
    end
    if _seatNo == nil then
        _seatNo = 2
    end

    local cmd = Sockets.cmd.gameing_SendVoice
    local data = {
        --room = {
            voiceUrl = _voiceUrl, -- 表情代号 bf sj cl
            seatNo = _seatNo, --座位编号，发送者的
        --}       
    }

    resData[ParseBase.cmd] = cmd;
    resData[ParseBase.data] = data;
    resData[ParseBase.msg] = RequestBase:new():getStrEncode("成功");
    resData[ParseBase.status] = 0;

    Commons:printLog_SocketReq("游戏中的录音 回合 假定tcp返回数据是：",ParseBase.new():parseToJsonString(resData))
    return ParseBase.new():parseToJsonString(resData);
end

-- 反馈结果：心跳下行
function SocketResponseData:res_gameing_xintiao_down()
    local resData = {}

    local cmd = Sockets.cmd.gameing_Xintiao_down
    local data = {
        --room = {
            systime = 1234567890, -- 系统时间 整型
        --}       
    }

    resData[ParseBase.cmd] = cmd;
    resData[ParseBase.data] = data;
    resData[ParseBase.msg] = RequestBase:new():getStrEncode("成功");
    resData[ParseBase.status] = 0;

    Commons:printLog_SocketReq("心跳下行 回合 假定tcp返回数据是：",ParseBase.new():parseToJsonString(resData))
    return ParseBase.new():parseToJsonString(resData);
end


-- 构造函数
function SocketResponseData:ctor()
end

-- 必须有这个返回
return SocketResponseData