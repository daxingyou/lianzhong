--
-- Author: luobinbin
-- Date: 2017-07-17 12:26:49
-- 方法类


-- 类申明
local CommonsM = class("CommonsM")

--跳转到 麻将游戏子主页
function CommonsM:gotoMJHome()
    -- 游戏别名的赋值
    CEnum.AppVersion.gameAlias = CEnum.gameType.hzmj

    local toScene = HomeScene:new()
    display.replaceScene(toScene, "fade", 0.5, cc.c3b(0,0,0) )
end

--跳转到 麻将游戏房间
function CommonsM:gotoMJRoom()
    -- 游戏别名的赋值
    CEnum.AppVersion.gameAlias = CEnum.gameType.hzmj

    local toScene = MJRoomScene:new()
    display.replaceScene(toScene, "fade", 0.5, cc.c3b(0,0,0) )
end

--判断一个值是否存在于一个数组中
function CommonsM:IsInTable(value, tbl)
	for k,v in ipairs(tbl) do
	  if v == value then
		  return true;
	  end
	end
	return false;
end

-- 构造函数
function CommonsM:ctor()
end

-- 必须有这个返回
return CommonsM