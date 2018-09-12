--
-- Author: lte
-- Date: 2017-02-28 11:38:01
--

local TradeLog = class("TradeLog")


-- 类变量申明
TradeLog.Bean = {
	tradeLogs = 'tradeLogs', -- 交易对象

	tradeType = 'tradeType', -- 交易类型
	tradeTime = 'tradeTime', -- 交易时间
	remark = 'remark', -- 详情
}



-- 方法体申明


-- 构造函数
function TradeLog:ctor()
end


-- 必须有这个返回
return TradeLog
