--
-- Author: lte
-- Date: 2016-10-17 17:17:58
-- 用户信息

local User = class("User")


-- 类变量申明
User.Bean = {
	user = 'user', -- 用户本身对象

	token = 'token',
	account = 'account',
	nickname = 'nickname',
	icon = 'icon',
	sex = 'sex',
	ip = 'ip',

	-- list
	rights = 'rights', -- 是不是有转卡权限

	-- 对象
	wallet = 'wallet', -- 余额对象
	room = 'room', -- 房间对象

	sysMsg = "sysMsg", -- 系统信息
}



-- 方法体申明


-- 构造函数
function User:ctor()
end


-- 必须有这个返回
return User