--
-- Author: luobinbin
-- Date: 2017-07-17 12:26:49
-- 模拟枚举


-- 类申明
--local CEnumM = class("CEnumM", function ()
--    return display.newNode();
--end)
local CEnumM = class("CEnumM")

-- 客户端座位编号
CEnumM.seatNo = {
	me = 1, -- 本人
	R = 2, -- 下一玩家（右手边） 
    M = 3, -- 对面玩家（对家） 
	L = 4, -- 最后一个玩家（左手边）

    init = -99, -- 假设初始值，默认值
    downOver = -199, -- 假设初始值，默认值
    playOver = -299, -- 假设初始值，默认值
}

CEnumM.shareTitle = {
    _1 = "一缺三", -- 共4个位置，剩下 3个空位
    _2 = "二缺二", -- 共4个位置，剩下 2个空位
    _3 = "三缺一", -- 共4个位置，剩下 1个空位
}

CEnumM.round = {
	round = "create_round_mj",
    _8 = 8,
    _16 = 16,
    _24 = 24,

    _8info = '8局',
    _16info = '16局',
    _24info = '24局',
}

CEnumM.person = {
	person = "create_person_mj",
    _2 = 2,
    _3 = 3,
    _4 = 4,

    _2info = '2人玩',
    _3info = '3人玩',
    _4info = '4人玩',
}

--自摸胡 or 可炮胡
CEnumM.zimohu = {
    zimohu = "create_zimohu_mj",
    mo = "mo",
    pao = "pao",

    mo_info = "自摸胡",
    pao_info = "可炮胡(含自摸)",
}

--七对胡
CEnumM.qiduihu = {
    qiduihu = "create_qiduihu_mj",
    y = "y",
    n = "n",

    y_info = "可七对胡",
    n_info = "不可七对胡",
}

--抢杠胡
CEnumM.qiangganghu = {
    qiangganghu = "create_qiangganghu_mj",
    y = "y",
    n = "n",

    y_info = "可抢杠胡",
    n_info = "不可抢杠胡",
}

--荒庄荒杠
CEnumM.huangtype = {
    huangtype = "create_huangtype_mj",
    y = "y",
    n = "n",

    y_info = "荒庄荒杠",
    n_info = "荒庄不荒杠",
}

--奖码
CEnumM.rewardmark = {
    rewardmark = "create_rewardmark_mj",
    no = "no",
    _159 = "159",
    ymqz = "ymqz",
    oon = "oon",

    no_info = '不奖码',
    _159_info = '159中码',
    ymqz_info = '一码全中',
    oon_info = '窝窝鸟',
}

--码数
CEnumM.marknum = {
    marknum = "create_marknum_mj",
    _2 = 2,
    _4 = 4,
    _6 = 6,

    _2info = '2码',
    _4info = '4码',
    _6info = '6码',
}

CEnumM.payType = {
	payType = "create_payType_pdk",
    _1 = "owner",-- 1,
    _2 = "aa",-- 2,

    _1info = "房主支付",-- 1,
    _2info = "AA支付",-- 2,
}

--吃3，碰1，杠2类型
CEnumM.actionType = {
    peng = 1, --碰
    ming_gang = 2, --明杠
    an_gang = 3, --暗杠
    chi = 4, --吃
}

--牌的显示类型 n：正面公开显示 y:  正面阴影显示 g：反面隐藏显示
CEnumM.showType = {
    n = "n", --正面公开显示
    y = "y", --正面阴影显示
    g = "g", --反面隐藏显示
}

--牌是否是癞子，y：是癞子，n：不是癞子
CEnumM.isLaiZi = {
    y = "y", 
    n = "n", 
}

CEnumM.ZOrder = {    
    -- common_dialog = 999, -- 普通一级弹窗
    -- common_dialog_second = 999, -- 普通一级弹窗  紧随还可以来一下弹窗
    -- alert_dialog = 999, -- 提示，提醒的超级弹窗

    handCardNormal=10, --手牌层级
    pengGangChiCardNormal=20, --碰杠吃正常层级
    otherHandCardMax=22, --下家手牌最高层级
    playerNode = 30, --玩家节点，因为准备按钮放在了玩家节点下面，准备按钮要在所有麻将子层级之上，所以抬高
    handCardDrag=31, --手牌拖拽层级临时抬高，放下后还原handCardNormal
}

-- 构造函数
function CEnumM:ctor()
end

-- 必须有这个返回
return CEnumM