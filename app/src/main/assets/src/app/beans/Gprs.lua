--
-- Author: wh
-- Date: 2017-04-19 11:38:01
--

local Gprs = class("Gprs")


-- 类变量申明
Gprs.Bean = {
	seatNo = 'seatNo', -- 自己的座位编号

	distanceA = 'distanceA', -- 自己距离上家，右手边的玩家
	distanceB = 'distanceB', -- 自己距离下家，左手边的玩家
	distanceC = 'distanceC', -- 相对自己的，其他2家的距离

	user = 'user',
	nextUser = 'nextUser',
	preUser = 'preUser',
	


	--------------麻将多加出来的-----------------------
	distanceD = 'distanceD',
	distanceE = 'distanceE',
	distanceF = 'distanceF',

	middleUser = 'middleUser',



	-- isGprsMe = 'isGprsMe',
	-- isGprsR = 'isGprsR',
	-- isGprsL = 'isGprsL',
}


-- 构造函数
function Gprs:ctor()
end


-- 必须有这个返回
return Gprs
