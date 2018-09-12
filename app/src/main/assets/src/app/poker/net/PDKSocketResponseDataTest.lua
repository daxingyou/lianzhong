--
-- Author: wh
-- Date: 2017-05-13 12:11:58
-- socket tcp 返回的数据，假定的测试数据


local PDKSocketResponseData = class("PDKSocketResponseData")


-- -- 反馈结果：游戏开始了，玩家离线
-- function PDKSocketResponseData:res_gameing_playerExitRoom()
--     local resData = {}

--     local cmd = Sockets.cmd.gameing_playerExitRoom
--     local data = {
--         alarm=false,
--         chu=false,
--         lastHand=false,
--         leftCardCount=0,

--         me=false,
--         owner=false,
--         score=0,
--         seatNo=1 
--     }

--     resData[ParseBase.cmd] = cmd;
--     resData[ParseBase.data] = data;
--     resData[ParseBase.msg] = RequestBase:new():getStrEncode("成功");
--     resData[ParseBase.status] = 0;

--     Commons:printLog_SocketReq("第3家上线 假定tcp返回数据是：",ParseBase.new():parseToJsonString(resData))
--     return ParseBase.new():parseToJsonString(resData)
-- end


function PDKSocketResponseData:loginRoom()
	local resData = {}
	local cmd = Sockets.cmd.loginRoom
    local data = {

            -- 这些值，游戏桌面是要显示对应图片的
                playType = '16',
                num = 3,
                isDisplay = 'y',
                lastRule = 'limit',
                birdRule = 'y',
                payRule = 'aa',
            
            roomNo="1000", -- 房间号
            rounds=10, --最大回合数
            playRound=0,--当前回合数
            playRoundNo=100,--当前回合编号
            --diCardsNum=18,--当前回合底牌数量
            roundStart = false, --回合是否开始
            status="created", --是否已开始游戏

            players=
            {   --玩家列表，元素为Player对象
                {
                    user={ --用户信息，User对象
                        account="6001",
                        nickname=RequestBase:getStrEncode("Thinker"),
                        icon=RequestBase:new():getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon1.jpg"),
                        sex="male",
                        ip="192.168.1.11"
                    },
                    me=true,--这个对象是不是本人
                    netStatus="online", --网络状态
                    playStatus="wait", -- ready wait
                    seatNo=1, -- 座位编号
                    owner=false, -- 是否是房主
                    role = "z", --角色，z 庄家 x 闲家
                    score=1999, -- 当前玩家分数
                    handCards = {},--{52,1,2,3,4,5,6,7,8,9,10},--手牌
                    leftCardCount = 0,--手牌数量
                    chuCards = {},--出过的牌
                    chuCardIndexs = {},--打出手牌在chuCards中的索引下标
                    changeCards = "",--当前改变的手牌
                    options = {"guo"},--玩家当前可以进行的操作，每个元素为枚举字符
                    action = {},--当前游戏动作
                    chu = true,--是否该玩家出牌
                    affordList = {},--玩家大过上家出牌的手牌列表组合 二维数组
                    --xi=1, -- 当前玩家的显示胡息数
                },


                -- {
                --     user={ --用户信息，User对象
                --         account="6001",
                --         nickname=RequestBase:getStrEncode("Terry"),
                --         icon=RequestBase:new():getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon2.jpg"),
                --         sex="male",
                --         ip="192.168.1.11"
                --     },
                --     me=false,--这个对象是不是本人
                --     netStatus="online", --网络状态
                --     playStatus="wait", -- ready wait
                --     seatNo=3, -- 座位编号
                --     owner=false, -- 是否是房主
                --     role = "z", --角色，z 庄家 x 闲家
                --     score=2000, -- 当前玩家分数
                --     handCards = {1,2,3,4,5,6,7,8,9,10},--手牌
                --     leftCardCount = 12,--手牌数量
                --     chuCards = {},--出过的牌
                --     chuCardIndexs = {},--打出手牌在chuCards中的索引下标
                --     changeCards = "",--当前改变的手牌
                --     options = {"guo"},--玩家当前可以进行的操作，每个元素为枚举字符
                --     action = {},--当前游戏动作
                --     chu = true,--是否该玩家出牌
                --     affordList = {},--玩家大过上家出牌的手牌列表组合 二维数组
                --     --xi=1, -- 当前玩家的显示胡息数
                -- },

                -- {
                --     user={ --用户信息，User对象
                --         account="6001",
                --         nickname=RequestBase:getStrEncode("勒天恩"),
                --         icon=RequestBase:new():getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon3.jpg"),
                --         sex="male",
                --         ip="192.168.1.11"
                --     },
                --     me=false,--这个对象是不是本人
                --     netStatus="online", --网络状态
                --     playStatus="wait", -- ready wait
                --     seatNo=2, -- 座位编号
                --     owner=false, -- 是否是房主
                --     role = "z", --角色，z 庄家 x 闲家
                --     score=222, -- 当前玩家分数
                --     handCards = {},--{1,2,3,4,5,6,7,8,9,10},--手牌
                --     leftCardCount = 0,--手牌数量
                --     chuCards = {},--出过的牌
                --     chuCardIndexs = {},--打出手牌在chuCards中的索引下标
                --     changeCards = "",--当前改变的手牌
                --     options = {"guo"},--玩家当前可以进行的操作，每个元素为枚举字符
                --     action = {},--当前游戏动作
                --     chu = true,--是否该玩家出牌
                --     affordList = {},--玩家大过上家出牌的手牌列表组合 二维数组
                --     --xi=1, -- 当前玩家的显示胡息数
                -- }
            },
            roomRecords = {},--房间结束时的结算战绩
            roundRecords = {},--回合结束时战绩
            isNewCircle = 1,--是否新一轮	
	}
	
	resData[ParseBase.cmd] = cmd;
	resData[ParseBase.data] = data;
	resData[ParseBase.msg] = RequestBase:new():getStrEncode("成功");
	resData[ParseBase.status] = 0;

    Commons:printLog_SocketReq("登录房间 假定tcp返回数据是：",ParseBase.new():parseToJsonString(resData))
    return ParseBase.new():parseToJsonString(resData) .. "\n";
end


function PDKSocketResponseData:playerLogin()
    
    local resData = {}
    local cmd = Sockets.cmd.gameing_playerLoginRoom
    local data = {
            roomNo="1000", -- 房间号
            rounds=10, --最大回合数
            playRound=0,--当前回合数
            playRoundNo=100,--当前回合编号
            --diCardsNum=18,--当前回合底牌数量
            roundStart = false, --回合是否开始
            status="created", --是否已开始游戏

            players=
            {   --玩家列表，元素为Player对象
                {
                    user={ --用户信息，User对象
                        account="6001",
                        nickname=RequestBase:getStrEncode("Thinker"),
                        icon=RequestBase:new():getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon1.jpg"),
                        sex="male",
                        ip="192.168.1.11"
                    },
                    me=true,--这个对象是不是本人
                    netStatus="online", --网络状态
                    playStatus="wait", -- ready wait
                    seatNo=1, -- 座位编号
                    owner=false, -- 是否是房主
                    role = "z", --角色，z 庄家 x 闲家
                    score=1999, -- 当前玩家分数
                    handCards = {},--{52,1,2,3,4,5,6,7,8,9,10},--手牌
                    leftCardCount = 0,--手牌数量
                    chuCards = {},--出过的牌
                    chuCardIndexs = {},--打出手牌在chuCards中的索引下标
                    changeCards = "",--当前改变的手牌
                    options = {"guo"},--玩家当前可以进行的操作，每个元素为枚举字符
                    action = {},--当前游戏动作
                    chu = true,--是否该玩家出牌
                    affordList = {},--玩家大过上家出牌的手牌列表组合 二维数组
                    --xi=1, -- 当前玩家的显示胡息数
                },


                {
                    user={ --用户信息，User对象
                        account="6001",
                        nickname=RequestBase:getStrEncode("Terry"),
                        icon=RequestBase:new():getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon2.jpg"),
                        sex="male",
                        ip="192.168.1.11"
                    },
                    me=false,--这个对象是不是本人
                    netStatus="online", --网络状态
                    playStatus="wait", -- ready wait
                    seatNo=0, -- 座位编号
                    owner=false, -- 是否是房主
                    role = "z", --角色，z 庄家 x 闲家
                    score=2000, -- 当前玩家分数
                    handCards = {},--{1,2,3,4,5,6,7,8,9,10},--手牌
                    leftCardCount = 0,--手牌数量
                    chuCards = {},--出过的牌
                    chuCardIndexs = {},--打出手牌在chuCards中的索引下标
                    changeCards = "",--当前改变的手牌
                    options = {"guo"},--玩家当前可以进行的操作，每个元素为枚举字符
                    action = {},--当前游戏动作
                    chu = true,--是否该玩家出牌
                    affordList = {},--玩家大过上家出牌的手牌列表组合 二维数组
                    --xi=1, -- 当前玩家的显示胡息数
                },

                {
                    user={ --用户信息，User对象
                        account="6001",
                        nickname=RequestBase:getStrEncode("勒天恩"),
                        icon=RequestBase:new():getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon3.jpg"),
                        sex="male",
                        ip="192.168.1.11"
                    },
                    me=false,--这个对象是不是本人
                    netStatus="online", --网络状态
                    playStatus="wait", -- ready wait
                    seatNo=2, -- 座位编号
                    owner=false, -- 是否是房主
                    role = "z", --角色，z 庄家 x 闲家
                    score=222, -- 当前玩家分数
                    handCards = {},--{1,2,3,4,5,6,7,8,9,10},--手牌
                    leftCardCount = 0,--手牌数量
                    chuCards = {},--出过的牌
                    chuCardIndexs = {},--打出手牌在chuCards中的索引下标
                    changeCards = "",--当前改变的手牌
                    options = {"guo"},--玩家当前可以进行的操作，每个元素为枚举字符
                    action = {},--当前游戏动作
                    chu = true,--是否该玩家出牌
                    affordList = {},--玩家大过上家出牌的手牌列表组合 二维数组
                    --xi=1, -- 当前玩家的显示胡息数
                }
            },
            roomRecords = {},--房间结束时的结算战绩
            roundRecords = {},--回合结束时战绩
            isNewCircle = 1,--是否新一轮  
    }
    resData[ParseBase.cmd] = cmd;
    resData[ParseBase.data] = data;
    resData[ParseBase.msg] = RequestBase:new():getStrEncode("成功");
    resData[ParseBase.status] = 0;

    Commons:printLog_SocketReq("玩家登录房间 假定tcp返回数据是：",ParseBase.new():parseToJsonString(resData))
    return ParseBase.new():parseToJsonString(resData) .. "\n";
end

function PDKSocketResponseData:playerReady()

    local resData = {}
    local cmd = Sockets.cmd.gameing_Prepare
    local data = {
            roomNo="1000", -- 房间号
            rounds=10, --最大回合数
            playRound=0,--当前回合数
            playRoundNo=100,--当前回合编号
            --diCardsNum=18,--当前回合底牌数量
            roundStart = false, --回合是否开始
            status="created", --是否已开始游戏
            
            players=
            {   --玩家列表，元素为Player对象
                {
                    user={ --用户信息，User对象
                        account="6001",
                        nickname=RequestBase:getStrEncode("Thinker"),
                        icon=RequestBase:new():getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon1.jpg"),
                        sex="male",
                        ip="192.168.1.11"
                    },
                    me=true,--这个对象是不是本人
                    netStatus="online", --网络状态
                    playStatus="ready", -- ready wait
                    seatNo=1, -- 座位编号
                    owner=false, -- 是否是房主
                    role = "z", --角色，z 庄家 x 闲家
                    score=1999, -- 当前玩家分数
                    handCards = {},--{52,1,2,3,4,5,6,7,8,9,10},--手牌
                    leftCardCount = 0,--手牌数量
                    chuCards = {},--出过的牌
                    chuCardIndexs = {},--打出手牌在chuCards中的索引下标
                    changeCards = "",--当前改变的手牌
                    options = {"guo"},--玩家当前可以进行的操作，每个元素为枚举字符
                    action = {},--当前游戏动作
                    chu = true,--是否该玩家出牌
                    affordList = {},--玩家大过上家出牌的手牌列表组合 二维数组
                    --xi=1, -- 当前玩家的显示胡息数
                },


                {
                    user={ --用户信息，User对象
                        account="6001",
                        nickname=RequestBase:getStrEncode("Terry"),
                        icon=RequestBase:new():getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon2.jpg"),
                        sex="male",
                        ip="192.168.1.11"
                    },
                    me=false,--这个对象是不是本人
                    netStatus="online", --网络状态
                    playStatus="ready", -- ready wait
                    seatNo=0, -- 座位编号
                    owner=false, -- 是否是房主
                    role = "z", --角色，z 庄家 x 闲家
                    score=2000, -- 当前玩家分数
                    handCards = {},--{1,2,3,4,5,6,7,8,9,10},--手牌
                    leftCardCount = 0,--手牌数量
                    chuCards = {},--出过的牌
                    chuCardIndexs = {},--打出手牌在chuCards中的索引下标
                    changeCards = "",--当前改变的手牌
                    options = {"guo"},--玩家当前可以进行的操作，每个元素为枚举字符
                    action = {},--当前游戏动作
                    chu = true,--是否该玩家出牌
                    affordList = {},--玩家大过上家出牌的手牌列表组合 二维数组
                    --xi=1, -- 当前玩家的显示胡息数
                },

                {
                    user={ --用户信息，User对象
                        account="6001",
                        nickname=RequestBase:getStrEncode("勒天恩"),
                        icon=RequestBase:new():getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon3.jpg"),
                        sex="male",
                        ip="192.168.1.11"
                    },
                    me=false,--这个对象是不是本人
                    netStatus="online", --网络状态
                    playStatus="ready", -- ready wait
                    seatNo=2, -- 座位编号
                    owner=false, -- 是否是房主
                    role = "z", --角色，z 庄家 x 闲家
                    score=222, -- 当前玩家分数
                    handCards = {},--{1,2,3,4,5,6,7,8,9,10},--手牌
                    leftCardCount = 0,--手牌数量
                    chuCards = {},--出过的牌
                    chuCardIndexs = {},--打出手牌在chuCards中的索引下标
                    changeCards = "",--当前改变的手牌
                    options = {"guo"},--玩家当前可以进行的操作，每个元素为枚举字符
                    action = {},--当前游戏动作
                    chu = true,--是否该玩家出牌
                    affordList = {},--玩家大过上家出牌的手牌列表组合 二维数组
                    --xi=1, -- 当前玩家的显示胡息数
                }
            },
            roomRecords = {},--房间结束时的结算战绩
            roundRecords = {},--回合结束时战绩
            isNewCircle = 1,--是否新一轮  
    }
    resData[ParseBase.cmd] = cmd;
    resData[ParseBase.data] = data;
    resData[ParseBase.msg] = RequestBase:new():getStrEncode("成功");
    resData[ParseBase.status] = 0;

    Commons:printLog_SocketReq("玩家登录房间 假定tcp返回数据是：",ParseBase.new():parseToJsonString(resData))
    return ParseBase.new():parseToJsonString(resData) .. "\n";
end

function PDKSocketResponseData:gameStart()

    local resData = {}
    local cmd = Sockets.cmd.gameing_Start
    local data = {
            roomNo="1000", -- 房间号
            rounds=10, --最大回合数
            playRound=0,--当前回合数
            playRoundNo=100,--当前回合编号
            --diCardsNum=18,--当前回合底牌数量
            roundStart = false, --回合是否开始
            status="started", --是否已开始游戏

            -- distanceType = 1,
            -- distanceDesc = {
            --     seatNo = 1,
            --     distanceA = "2000米",
            --     distanceB = "3000米",
            --     distanceC = "4000米",
            -- },

            players=
            {   --玩家列表，元素为Player对象
                {
                    user={ --用户信息，User对象
                        account="6001",
                        nickname=RequestBase:getStrEncode("Thinker"),
                        icon=RequestBase:new():getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon1.jpg"),
                        sex="male",
                        ip="192.168.1.11"
                    },
                    me=true,--这个对象是不是本人
                    netStatus="online", --网络状态
                    playStatus="playing",
                    seatNo=1, -- 座位编号
                    owner=false, -- 是否是房主
                    role = "x", --角色，z 庄家 x 闲家
                    score=1999, -- 当前玩家分数

                    --handCards = {52,51,50,49,48,47,46,45,44,41,40,39,38,37},--手牌
                    handCards = {
                        {cardId=52},
                        {cardId=51},
                        {cardId=50},
                        {cardId=49},
                        {cardId=48},
                        {cardId=47},
                        {cardId=46},
                        {cardId=45},
                        {cardId=44},
                        {cardId=41},
                        {cardId=40},
                        {cardId=39},
                        {cardId=38},
                        {cardId=37}
                    },--手牌

                    leftCardCount = 16,--手牌数量
                    chuCards = {},--出过的牌
                    chuCardIndexs = {},--打出手牌在chuCards中的索引下标
                    changeCards = "",--当前改变的手牌
                    options = {"chu"},--玩家当前可以进行的操作，每个元素为枚举字符
                    action = {},--当前游戏动作
                    chu = true,--是否该玩家出牌
                    affordList = {},--玩家大过上家出牌的手牌列表组合 二维数组
                    --xi=1, -- 当前玩家的显示胡息数
                },


                {
                    user={ --用户信息，User对象
                        account="6001",
                        nickname=RequestBase:getStrEncode("Terry"),
                        icon=RequestBase:new():getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon2.jpg"),
                        sex="male",
                        ip="192.168.1.11"
                    },
                    me=false,--这个对象是不是本人
                    netStatus="online", --网络状态
                    playStatus="ready",
                    seatNo=0, -- 座位编号
                    owner=false, -- 是否是房主
                    role = "x", --角色，z 庄家 x 闲家
                    score=2000, -- 当前玩家分数
                    handCards = {1,2,3,4,5,6,7,8,9,10},--手牌
                    leftCardCount = 16,--手牌数量
                    chuCards = {},--出过的牌
                    chuCardIndexs = {},--打出手牌在chuCards中的索引下标
                    changeCards = "",--当前改变的手牌
                    options = {"guo"},--玩家当前可以进行的操作，每个元素为枚举字符
                    action = {},--当前游戏动作
                    chu = true,--是否该玩家出牌
                    affordList = {},--玩家大过上家出牌的手牌列表组合 二维数组
                    --xi=1, -- 当前玩家的显示胡息数
                },

                {
                    user={ --用户信息，User对象
                        account="6001",
                        nickname=RequestBase:getStrEncode("勒天恩"),
                        icon=RequestBase:new():getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon3.jpg"),
                        sex="male",
                        ip="192.168.1.11"
                    },
                    me=false,--这个对象是不是本人
                    netStatus="online", --网络状态
                    playStatus="ready",
                    seatNo=2, -- 座位编号
                    owner=false, -- 是否是房主
                    role = "z", --角色，z 庄家 x 闲家
                    score=222, -- 当前玩家分数
                    handCards = {1,2,3,4,5,6,7,8,9,10},--手牌
                    leftCardCount = 16,--手牌数量
                    chuCards = {},--出过的牌
                    chuCardIndexs = {},--打出手牌在chuCards中的索引下标
                    changeCards = "",--当前改变的手牌
                    options = {"guo"},--玩家当前可以进行的操作，每个元素为枚举字符
                    action = {},--当前游戏动作
                    chu = true,--是否该玩家出牌
                    affordList = {},--玩家大过上家出牌的手牌列表组合 二维数组
                    --xi=1, -- 当前玩家的显示胡息数
                }
            },
            roomRecords = {},--房间结束时的结算战绩
            roundRecords = {},--回合结束时战绩
            isNewCircle = 1,--是否新一轮  
    }
    resData[ParseBase.cmd] = cmd;
    resData[ParseBase.data] = data;
    resData[ParseBase.msg] = RequestBase:new():getStrEncode("成功");
    resData[ParseBase.status] = 0;

    Commons:printLog_SocketReq("游戏开始 假定tcp返回数据是：",ParseBase.new():parseToJsonString(resData))
    return ParseBase.new():parseToJsonString(resData) .. "\n";
end

function PDKSocketResponseData:outCards()

    local resData = {}
    local cmd = Sockets.cmd.gameing_Chu
    local data = {
        roomNo="1000", -- 房间号
            rounds=10, --最大回合数
            playRound=0,--当前回合数
            playRoundNo=100,--当前回合编号
            --diCardsNum=18,--当前回合底牌数量
            roundStart = false, --回合是否开始
            status="created", --是否已开始游戏
            players=
            {   --玩家列表，元素为Player对象
                {
                    user={ --用户信息，User对象
                        account="6001",
                        nickname=RequestBase:getStrEncode("Thinker"),
                        icon=RequestBase:new():getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon1.jpg"),
                        sex="male",
                        ip="192.168.1.11"
                    },
                    me=true,--这个对象是不是本人
                    netStatus="online", --网络状态
                    playStatus="ready",
                    seatNo=1, -- 座位编号
                    owner=false, -- 是否是房主
                    role = "x", --角色，z 庄家 x 闲家
                    score=1999, -- 当前玩家分数
                    handCards = {52,51,50,49,48,47,46,45,44,41,40,39,38,37},--手牌
                    leftCardCount = 16,--手牌数量
                    chuCards = {52,51},--出过的牌
                    chuCardIndexs = {},--打出手牌在chuCards中的索引下标
                    changeCards = "",--当前改变的手牌
                    options = {},--玩家当前可以进行的操作，每个元素为枚举字符
                    action = {"chu"},--当前游戏动作
                    chu = false,--是否该玩家出牌
                    affordList = {},--玩家大过上家出牌的手牌列表组合 二维数组
                    --xi=1, -- 当前玩家的显示胡息数
                },


                {
                    user={ --用户信息，User对象
                        account="6001",
                        nickname=RequestBase:getStrEncode("Terry"),
                        icon=RequestBase:new():getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon2.jpg"),
                        sex="male",
                        ip="192.168.1.11"
                    },
                    me=false,--这个对象是不是本人
                    netStatus="online", --网络状态
                    playStatus="ready",
                    seatNo=0, -- 座位编号
                    owner=false, -- 是否是房主
                    role = "z", --角色，z 庄家 x 闲家
                    score=2000, -- 当前玩家分数
                    handCards = {1,2,3,4,5,6,7,8,9,10},--手牌
                    leftCardCount = 16,--手牌数量
                    chuCards = {},--出过的牌
                    chuCardIndexs = {},--打出手牌在chuCards中的索引下标
                    changeCards = "",--当前改变的手牌
                    options = {"guo"},--玩家当前可以进行的操作，每个元素为枚举字符
                    action = {},--当前游戏动作
                    chu = false,--是否该玩家出牌
                    affordList = {},--玩家大过上家出牌的手牌列表组合 二维数组
                    --xi=1, -- 当前玩家的显示胡息数
                },

                {
                    user={ --用户信息，User对象
                        account="6001",
                        nickname=RequestBase:getStrEncode("勒天恩"),
                        icon=RequestBase:new():getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon3.jpg"),
                        sex="male",
                        ip="192.168.1.11"
                    },
                    me=false,--这个对象是不是本人
                    netStatus="online", --网络状态
                    playStatus="ready",
                    seatNo=2, -- 座位编号
                    owner=false, -- 是否是房主
                    role = "x", --角色，z 庄家 x 闲家
                    score=222, -- 当前玩家分数
                    handCards = {1,2,3,4,5,6,7,8,9,10},--手牌
                    leftCardCount = 16,--手牌数量
                    chuCards = {},--出过的牌
                    chuCardIndexs = {},--打出手牌在chuCards中的索引下标
                    changeCards = "",--当前改变的手牌
                    options = {"guo"},--玩家当前可以进行的操作，每个元素为枚举字符
                    action = {},--当前游戏动作
                    chu = true,--是否该玩家出牌
                    affordList = {},--玩家大过上家出牌的手牌列表组合 二维数组
                    --xi=1, -- 当前玩家的显示胡息数
                }
            },
            roomRecords = {},--房间结束时的结算战绩
            roundRecords = {},--回合结束时战绩
            isNewCircle = 1,--是否新一轮  
    }
    resData[ParseBase.cmd] = cmd;
    resData[ParseBase.data] = data;
    resData[ParseBase.msg] = RequestBase:new():getStrEncode("成功");
    resData[ParseBase.status] = 0;

    Commons:printLog_SocketReq("玩家登录房间 假定tcp返回数据是：",ParseBase.new():parseToJsonString(resData))
    return ParseBase.new():parseToJsonString(resData) .. "\n";
end

--过牌
function PDKSocketResponseData:playerPass()
    --

    local resData = {}
    local cmd = Sockets.cmd.gameing_ChiPengGuoHu_pai
    local data = {
        roomNo="1000", -- 房间号
            rounds=10, --最大回合数
            playRound=0,--当前回合数
            playRoundNo=100,--当前回合编号
            --diCardsNum=18,--当前回合底牌数量
            roundStart = false, --回合是否开始
            status="created", --是否已开始游戏
            players=
            {   --玩家列表，元素为Player对象
                {
                    user={ --用户信息，User对象
                        account="6001",
                        nickname=RequestBase:getStrEncode("Thinker"),
                        icon=RequestBase:new():getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon1.jpg"),
                        sex="male",
                        ip="192.168.1.11"
                    },
                    me=true,--这个对象是不是本人
                    netStatus="online", --网络状态
                    playStatus="ready",
                    seatNo=1, -- 座位编号
                    owner=false, -- 是否是房主
                    role = "x", --角色，z 庄家 x 闲家
                    score=1999, -- 当前玩家分数
                    handCards = {52,51,50,49,48,47,46,45,44,41,40,39,38,37},--手牌
                    leftCardCount = 16,--手牌数量
                    chuCards = {52,51},--出过的牌
                    chuCardIndexs = {},--打出手牌在chuCards中的索引下标
                    changeCards = "",--当前改变的手牌
                    options = {},--玩家当前可以进行的操作，每个元素为枚举字符
                    action = {"chu"},--当前游戏动作
                    chu = false,--是否该玩家出牌
                    affordList = {},--玩家大过上家出牌的手牌列表组合 二维数组
                    --xi=1, -- 当前玩家的显示胡息数
                },


                {
                    user={ --用户信息，User对象
                        account="6001",
                        nickname=RequestBase:getStrEncode("Terry"),
                        icon=RequestBase:new():getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon2.jpg"),
                        sex="male",
                        ip="192.168.1.11"
                    },
                    me=false,--这个对象是不是本人
                    netStatus="online", --网络状态
                    playStatus="ready",
                    seatNo=0, -- 座位编号
                    owner=false, -- 是否是房主
                    role = "z", --角色，z 庄家 x 闲家
                    score=2000, -- 当前玩家分数
                    handCards = {1,2,3,4,5,6,7,8,9,10},--手牌
                    leftCardCount = 16,--手牌数量
                    chuCards = {},--出过的牌
                    chuCardIndexs = {},--打出手牌在chuCards中的索引下标
                    changeCards = "",--当前改变的手牌
                    options = {"guo"},--玩家当前可以进行的操作，每个元素为枚举字符
                    action = {},--当前游戏动作
                    chu = true,--是否该玩家出牌
                    affordList = {},--玩家大过上家出牌的手牌列表组合 二维数组
                    --xi=1, -- 当前玩家的显示胡息数
                },

                {
                    user={ --用户信息，User对象
                        account="6001",
                        nickname=RequestBase:getStrEncode("勒天恩"),
                        icon=RequestBase:new():getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon3.jpg"),
                        sex="male",
                        ip="192.168.1.11"
                    },
                    me=false,--这个对象是不是本人
                    netStatus="online", --网络状态
                    playStatus="ready",
                    seatNo=2, -- 座位编号
                    owner=false, -- 是否是房主
                    role = "x", --角色，z 庄家 x 闲家
                    score=222, -- 当前玩家分数
                    handCards = {1,2,3,4,5,6,7,8,9,10},--手牌
                    leftCardCount = 16,--手牌数量
                    chuCards = {},--出过的牌
                    chuCardIndexs = {},--打出手牌在chuCards中的索引下标
                    changeCards = "",--当前改变的手牌
                    options = {"guo"},--玩家当前可以进行的操作，每个元素为枚举字符
                    action = {"guo"},--当前游戏动作
                    chu = false,--是否该玩家出牌
                    affordList = {},--玩家大过上家出牌的手牌列表组合 二维数组
                    --xi=1, -- 当前玩家的显示胡息数
                }
            },
            roomRecords = {},--房间结束时的结算战绩
            roundRecords = {},--回合结束时战绩
            isNewCircle = 1,--是否新一轮  
    }
    resData[ParseBase.cmd] = cmd;
    resData[ParseBase.data] = data;
    resData[ParseBase.msg] = RequestBase:new():getStrEncode("成功");
    resData[ParseBase.status] = 0;

    Commons:printLog_SocketReq("玩家登录房间 假定tcp返回数据是：",ParseBase.new():parseToJsonString(resData))
    return ParseBase.new():parseToJsonString(resData) .. "\n";
end
-- 反馈结果：解散房间申请反馈给其他玩家  等待其他玩家确认
function PDKSocketResponseData:res_dissRoom_new()
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
-- 构造函数
function PDKSocketResponseData:ctor()
end

function PDKSocketResponseData:gameOver()
    local resData = {}

    -- local jsonData = '{"cmd":2003,"compress":0,"data":{"diCardsNum":16,"distanceDesc":"玩家:Thinker 未开启定位功能\n玩家:蒙牛 未开启定位功能\n","distanceType":2,"newCircle":false,"num":2,"playRound":5,"playRoundNo":"0d32f992-71bb-4c23-85a7-c70b619799a5","players":[{"alarm":false,"chu":false,"lastHand":false,"leftCardCount":0,"me":false,"owner":false,"score":0,"seatNo":0},{"alarm":false,"chu":false,"lastHand":false,"leftCardCount":0,"me":true,"owner":false,"score":0,"seatNo":1}],"roomNo":"899182","roundRecords":[{"bird":false,"diCards":[{"cardId":41,"colorType":"H","grade":15,"numType":"TWO"},{"cardId":40,"colorType":"H","grade":14,"numType":"ONE"},{"cardId":27,"colorType":"T","grade":14,"numType":"ONE"},{"cardId":14,"colorType":"M","grade":14,"numType":"ONE"},{"cardId":52,"colorType":"H","grade":13,"numType":"K"},{"cardId":26,"colorType":"M","grade":13,"numType":"K"},{"cardId":23,"colorType":"M","grade":10,"numType":"TEN"},{"cardId":33,"colorType":"T","grade":7,"numType":"SEVEN"},{"cardId":19,"colorType":"M","grade":6,"numType":"SIX"},{"cardId":6,"colorType":"F","grade":6,"numType":"SIX"},{"cardId":44,"colorType":"H","grade":5,"numType":"FIVE"},{"cardId":31,"colorType":"T","grade":5,"numType":"FIVE"},{"cardId":18,"colorType":"M","grade":5,"numType":"FIVE"},{"cardId":43,"colorType":"H","grade":4,"numType":"FOUR"},{"cardId":29,"colorType":"T","grade":3,"numType":"THREE"},{"cardId":3,"colorType":"F","grade":3,"numType":"THREE"}],"holeCards":[{"cardId":39,"colorType":"T","grade":13,"numType":"K"},{"cardId":13,"colorType":"F","grade":13,"numType":"K"},{"cardId":51,"colorType":"H","grade":12,"numType":"Q"},{"cardId":38,"colorType":"T","grade":12,"numType":"Q"},{"cardId":37,"colorType":"T","grade":11,"numType":"J"},{"cardId":11,"colorType":"F","grade":11,"numType":"J"},{"cardId":48,"colorType":"H","grade":9,"numType":"NINE"},{"cardId":47,"colorType":"H","grade":8,"numType":"EIGHT"},{"cardId":46,"colorType":"H","grade":7,"numType":"SEVEN"},{"cardId":4,"colorType":"F","grade":4,"numType":"FOUR"},{"cardId":42,"colorType":"H","grade":3,"numType":"THREE"}],"leftCardCount":11,"me":false,"owner":true,"role":"x","roundBombNum":0,"roundMaxScore":6,"roundResult":false,"roundScore":-11,"seatNo":0,"spring":false,"user":{"account":"6742283","icon":"http%3A%2F%2Fwx.qlogo.cn%2Fmmopen%2FibCyof4TdEDiaWjkp5uXibWdoWyG4aibhI510XfTZ5qQ7VLzjo7aBYGGGnbsXKlOrbRK4UgEYy1xZ1JL0JRlJHkTL6aWnINg8jW2%2F0","ip":"183.39.199.62","nickname":"Thinker","sex":"male"}},{"bird":false,"diCards":[{"cardId":41,"colorType":"H","grade":15,"numType":"TWO"},{"cardId":40,"colorType":"H","grade":14,"numType":"ONE"},{"cardId":27,"colorType":"T","grade":14,"numType":"ONE"},{"cardId":14,"colorType":"M","grade":14,"numType":"ONE"},{"cardId":52,"colorType":"H","grade":13,"numType":"K"},{"cardId":26,"colorType":"M","grade":13,"numType":"K"},{"cardId":23,"colorType":"M","grade":10,"numType":"TEN"},{"cardId":33,"colorType":"T","grade":7,"numType":"SEVEN"},{"cardId":19,"colorType":"M","grade":6,"numType":"SIX"},{"cardId":6,"colorType":"F","grade":6,"numType":"SIX"},{"cardId":44,"colorType":"H","grade":5,"numType":"FIVE"},{"cardId":31,"colorType":"T","grade":5,"numType":"FIVE"},{"cardId":18,"colorType":"M","grade":5,"numType":"FIVE"},{"cardId":43,"colorType":"H","grade":4,"numType":"FOUR"},{"cardId":29,"colorType":"T","grade":3,"numType":"THREE"},{"cardId":3,"colorType":"F","grade":3,"numType":"THREE"}],"leftCardCount":0,"me":true,"owner":false,"role":"z","roundBombNum":0,"roundMaxScore":14,"roundResult":true,"roundScore":11,"seatNo":1,"spring":false,"user":{"account":"6690389","icon":"http%3A%2F%2Fwx.qlogo.cn%2Fmmopen%2FQFzWl50ZTiccIRiaL23v0x06HwDdyg3vjKAFkTdteud5ljJ8Q5GjAkM8Eiagqg8C14OOgcicMnlGTiaAS7TAAZRnZ2waibYou3vX8N%2F0","ip":"183.39.199.62","nickname":"%E8%92%99%E7%89%9B","sex":"male"}}],"roundStart":false,"rounds":10,"status":"started"},"msg":"成功","status":0}'
    -- local data = json.decode(jsonData)

    local data = {
        cmd=2003,
        compress=0,
        msg="成功",
        status=0,

        data = {
            status="started",
            roomNo="899182",
            playRoundNo="0d32f992-71bb-4c23-85a7-c70b619799a5",
            roundStart=false,
            rounds=10,
            playRound=5,
            diCardsNum=16,
            
            distanceDesc="玩家:Thinker 未开启定位功能\n玩家:蒙牛 未开启定位功能\n",
            distanceType=2,
            newCircle=false,
            num=2,

            players={
                {
                alarm=false,
                chu=false,
                lastHand=false,
                leftCardCount=0,
                me=false,
                owner=false,
                score=0,
                seatNo=0
                },

                {alarm=false,
                chu=false,
                lastHand=false,
                leftCardCount=0,
                me=true,
                owner=false,
                score=0,
                seatNo=1
                }
            },

            roundRecords= {
                {
                    diCards={
                        {cardId=41, colorType="H", grade=15, numType="TWO"},
                        {cardId=40, colorType="H", grade=14, numType="ONE"},
                        {cardId=27, colorType="T", grade=14, numType="ONE"},
                        {cardId=14, colorType="M", grade=14, numType="ONE"},
                        {cardId=52, colorType="H", grade=13, numType="K"},
                        {cardId=26, colorType="M", grade=13, numType="K"},
                        {cardId=23, colorType="M", grade=10, numType="TEN"},
                        {cardId=33, colorType="T", grade=7, numType="SEVEN"},
                        {cardId=19, colorType="M", grade=6, numType="SIX"},
                        {cardId=6, colorType="F", grade=6, numType="SIX"},
                        {cardId=44, colorType="H", grade=5, numType="FIVE"},
                        {cardId=31, colorType="T", grade=5, numType="FIVE"},
                        {cardId=18, colorType="M", grade=5, numType="FIVE"},
                        {cardId=43, colorType="H", grade=4, numType="FOUR"},
                        {cardId=29, colorType="T", grade=3, numType="THREE"},
                        {cardId=3, colorType="F", grade=3, numType="THREE"}
                    },
                    holeCards={
                        {cardId=39, colorType="T", grade=13, numType="K"},
                        {cardId=13, colorType="F", grade=13, numType="K"},
                        {cardId=51, colorType="H", grade=12, numType="Q"},
                        {cardId=38, colorType="T", grade=12, numType="Q"},
                        {cardId=37, colorType="T", grade=11, numType="J"},
                        {cardId=11, colorType="F", grade=11, numType="J"},
                        {cardId=48, colorType="H", grade=9, numType="NINE"},
                        {cardId=47, colorType="H", grade=8, numType="EIGHT"},
                        {cardId=46, colorType="H", grade=7, numType="SEVEN"},
                        {cardId=4, colorType="F", grade=4, numType="FOUR"},
                        {cardId=42, colorType="H", grade=3, numType="THREE"}
                    },
                    leftCardCount=11,
                    me=false,
                    owner=true,
                    role="x",
                    roundBombNum=0,
                    roundMaxScore=6,
                    roundResult=false, -- true  false
                    roundScore=-11,
                    seatNo=0,

                    spring=false,
                    bird=false,

                    user={
                        account="6742283",
                        icon="http%3A%2F%2Fwx.qlogo.cn%2Fmmopen%2FibCyof4TdEDiaWjkp5uXibWdoWyG4aibhI510XfTZ5qQ7VLzjo7aBYGGGnbsXKlOrbRK4UgEYy1xZ1JL0JRlJHkTL6aWnINg8jW2%2F0",
                        ip="183.39.199.62",
                        nickname="T",
                        sex="male"
                    }
                } -- end 1

                ,{
                    diCards={
                        {cardId=41},
                        {cardId=40},
                        {cardId=27},
                        {cardId=14},
                        {cardId=52},
                        {cardId=26},
                        {cardId=23},
                        {cardId=33},
                        {cardId=19},
                        {cardId=6},
                        {cardId=44},
                        {cardId=31},
                        {cardId=18},
                        {cardId=43},
                        {cardId=29},
                        {cardId=3}
                    },
                    leftCardCount=0,
                    me=false,
                    owner=false,
                    role="z",
                    roundBombNum=0,
                    roundMaxScore=14,
                    roundResult=false, -- true  false
                    roundScore=11,
                    seatNo=1,

                    spring=true,
                    bird=false,

                    user={
                        account="6690389",
                        icon="http%3A%2F%2Fwx.qlogo.cn%2Fmmopen%2FQFzWl50ZTiccIRiaL23v0x06HwDdyg3vjKAFkTdteud5ljJ8Q5GjAkM8Eiagqg8C14OOgcicMnlGTiaAS7TAAZRnZ2waibYou3vX8N%2F0",
                        ip="183.39.199.62",
                        nickname="%E8%92%99%E7%89%9B%E8%92%99%E7%89%9B%E8%92%99%E7%89%9B%E8%92%99%E7%89%9B%E8%92%99%E7%89%9B",
                        sex="male"
                    }
                }-- end 2

                ,{
                    diCards={
                        {cardId=41},
                        {cardId=40},
                        {cardId=27},
                        {cardId=14},
                        {cardId=52},
                        {cardId=26},
                        {cardId=23},
                        {cardId=33},
                        {cardId=19},
                        {cardId=6},
                        {cardId=44},
                        {cardId=31},
                        {cardId=18},
                        {cardId=43},
                        {cardId=29},
                        {cardId=3}
                    },
                    leftCardCount=0,
                    me=true,
                    owner=false,
                    role="z",
                    roundBombNum=0,
                    roundMaxScore=14,
                    roundResult=false, -- true  false
                    roundScore=11,
                    seatNo=2,

                    spring=true,
                    bird=true,

                    user={
                        account="6690388",
                        icon="http%3A%2F%2Fwx.qlogo.cn%2Fmmopen%2FQFzWl50ZTiccIRiaL23v0x06HwDdyg3vjKAFkTdteud5ljJ8Q5GjAkM8Eiagqg8C14OOgcicMnlGTiaAS7TAAZRnZ2waibYou3vX8N%2F0",
                        ip="183.39.199.62",
                        nickname="test33",
                        sex="male"
                    }
                }-- end 3

            } -- end roundRecords

            ---[[
            ,roomRecords = { -- 游戏结束
               {
                    user={ --用户信息，User对象
                        account="6001",
                        nickname=RequestBase:getStrEncode("张三last"),
                        icon=RequestBase:new():getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon1.jpg"),
                        sex="male",
                        ip="192.168.111.111"
                    },
                    owner = true, -- 我是房主
                    score = 5000, -- 分数

                    roundMaxScore = 10,
                    winCount = 10,
                    loseCount = 1,
                    validBombCount = 1,
                    bigWinner = true,

                    -- winner = true,
                }
                ,{
                    user={ --用户信息，User对象
                        account="6002",
                        nickname=RequestBase:getStrEncode("李四李四李四"),
                        icon=RequestBase:new():getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon2.jpg"),
                        sex="male",
                        ip="192.168.111.123"
                    },
                    owner = true, -- 我是房主
                    score = -2500, -- 分数

                    roundMaxScore = 20,
                    winCount = 20,
                    loseCount = 2,
                    validBombCount = 2,
                    bigWinner = true,

                    -- winner = false,
                }
                -- ,{
                --     user={ --用户信息，User对象
                --         account="6003",
                --         nickname=RequestBase:getStrEncode("王五王五王五"),
                --         icon=RequestBase:new():getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon3.jpg"),
                --         sex="male",
                --         ip="192.168.111.133"
                --     },
                --     owner = true, -- 我是房主
                --     score = -2500, -- 分数

                --     roundMaxScore = 30,
                --     winCount = 30,
                --     loseCount = 3,
                --     validBombCount = 3,
                --     bigWinner = true,

                --     -- winner = false,
                -- }
            } -- end  游戏结束
            --]]

        }
    }
   
    resData[ParseBase.cmd] = data.cmd;
    resData[ParseBase.data] = data.data;
    resData[ParseBase.msg] = data.msg
    resData[ParseBase.status] = 0;

    return ParseBase.new():parseToJsonString(resData);

end

-- 反馈结果：解散房间申请反馈给其他玩家  等待其他玩家确认
function PDKSocketResponseData:res_gameing_IP_check()
    local resData = {}

    local cmd = Sockets.cmd.gameing_IP_check
    local data = {
        isShow = 'y', -- 是否弹窗提醒，y：提醒，n：不提醒
        popDesc = "玩家【李刚】和【老严】距离太近，相距30米，\n玩家【您】和【老严】距离太近，相距50米，\n玩家【您】和【李刚】距离太近，相距90米，\n等待您的选择\n等待您的选择\n等待您的选择", -- 弹窗描述
        distanceType = 0, -- 距离预警类型，0：绿，1：黄，2：红

        playerDistance = 
        {
            owner=true, -- 是否是房主
            seatNo = 1,
            distanceA = "200米，ip相同", -- 当前玩家与上家的距离
            distanceB = "3000米，未知距离，没有开定位", -- 当前玩家与下家的距离
            distanceC = "400米，找不到他", -- 当前玩家的上下与下家的距离

            distanceD = "500米，相距很近", -- 当前玩家与对家的距离(如果存在4个玩家，就有对家，否则没有对家)
            distanceE = "600米，相距很近", -- 当前玩家的上家与对家的距离
            distanceF = "700米，相距很近", -- 当前玩家的下家与对家的距离

            -- 本人
            user = {
                nickname=RequestBase:getStrEncode("张三张三张三张三"),
                icon=RequestBase:new():getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon1.jpg"),
            },

            -- 下家
            nextUser = {
                nickname=RequestBase:getStrEncode("李四lisi李四李四"),
                icon=RequestBase:new():getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon2.jpg"),
            },

            -- 上家
            preUser = {
                nickname=RequestBase:getStrEncode("王五王五王五王五"),
                icon=RequestBase:new():getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon3.jpg"),
            },

            -- 对家
            middleUser = {
                nickname=RequestBase:getStrEncode("黄龙黄龙黄龙黄龙"),
                icon=RequestBase:new():getStrEncode("http://wmq.res.apk.yuelaigame.com/test/icon1.jpg"),
            },

            -- isGprsMe = 'y', -- 本人开启了定位
            -- isGprsR = 'y', -- 下家开启了定位
            -- isGprsL = 'y', -- 上家开启了定位
        },

        descript="玩家【李刚】和【老严】距离太近，相距30米，\n玩家【您】和【老严】距离太近，相距50米，\n玩家【您】和【李刚】距离太近，相距90米，\n，等待您的选择【超过150秒未做选择，则默认同意】", -- 房间号 
        overtime=150,
        choose=false,
        playerChooses={
            {descript="【李刚】等待选择",status="wait"}, -- // 状态，wait：等待，agreed：同意
            {descript="【老严】选择退出",status="agreed"},
        } 
    }
    
    resData[ParseBase.cmd] = cmd;
    resData[ParseBase.data] = data;
    resData[ParseBase.msg] = RequestBase:new():getStrEncode("解散房间不扣除房卡，是否确认解散");
    resData[ParseBase.status] = 0;

    Commons:printLog_SocketReq("解散房间申请 假定tcp返回数据是：",ParseBase.new():parseToJsonString(resData))
    return ParseBase.new():parseToJsonString(resData);
end

-- 必须有这个返回
return PDKSocketResponseData