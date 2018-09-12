--
-- Author: lte
-- Date: 2016-10-17 17:27:25
-- 用户钱包

local Wallet = class("Wallet")


-- 类变量申明
Wallet.Bean = {
	balance = 'balance' -- 金币余额
}


-- 方法体申明


-- 构造函数
function Wallet:ctor()
end


-- 必须有这个返回
return Wallet
