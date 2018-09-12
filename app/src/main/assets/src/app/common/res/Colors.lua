--
-- Author: lte
-- Date: 2016-10-11 20:15:06
-- 颜色值


--[[
-- 黑色
ZP_Color_black = cc.c3b(0,0,0);

-- 层的通用背景色 橘黄
ZP_Color_layer_bg = cc.c4b(200,80,0,255);

-- 最大标题颜色 橘红色
ZP_Color_title = cc.c3b(255,64,164);

-- 按钮的静态颜色 白色
ZP_Color_btn_normal = cc.c3b(255,255,255);
-- 按钮的点击颜色 红色
ZP_Color_btn_press = cc.c3b(255,64,64);
-- 按钮的不可点击颜色 黑色
ZP_Color_btn_disable = cc.c3b(0,0,0);
--]]


-- 类申明
--local Colors = class("Colors", function ()
--    return display.newNode();
--end)
local Colors = class("Colors")


-- 类变量申明

Colors.black = cc.c3b(0,0,0) -- 纯黑色
Colors.red = cc.c3b(255,0,0) -- 纯红色
Colors.white = cc.c3b(255,255,255) -- 纯白色
Colors.gray = cc.c3b(50,31,11) -- 灰色
Colors.green = cc.c3b(12,151,54) -- 绿色

-- 层的通用背景色 橘黄 不透明
Colors.layer_bg = cc.c4b(200,80,0,255);
Colors.layer_bg_white = cc.c4b(230,230,230,255);

-- 最大标题颜色 橘红色
Colors.title = cc.c3b(255,64,164);

-- 按钮的静态颜色 白色
Colors.btn_normal = cc.c3b(255,255,255);
-- 按钮的点击颜色 红色
Colors.btn_press = cc.c3b(255,64,64);
-- 按钮的不可点击颜色 黑色
Colors.btn_disable = cc.c3b(0,0,0);
-- 按钮的背景色 黑色 全透明
Colors.btn_bg = cc.c4b(0,0,0,0);

-- 创建房间 键盘中输入字的颜色
Colors.keyboard = "7f4d16"; -- 静态色
Colors.keyboard_press = "ff0000"; -- 触礁色

-- 游戏中时间显示颜色
Colors.gameing_time = "ebdd60"; -- 几点钟的颜色 黄色
Colors.gameing_score = "ffeb3a"; -- 分数的颜色  黄色
Colors.gameing_roomNo = "ebdd60"; -- 房间号的颜色  淡黄淡白色
Colors.gameing_huxi = "733815"; -- 多少胡息的颜色  棕色

Colors.gameing_jiadi_color = "a1896d"; -- 底图上的 灰棕色

Colors.help_txt = "804c15"; -- 玩法介绍的颜色 棕色

Colors.result_round_bg1 = "d8d4b6"; -- 回合列表 奇数行 背景色
Colors.result_round_bg2 = "b1ac91"; -- 回合列表 偶数行 背景色

Colors.dissRoom_green = "024500"; -- 解散房间 同意 绿色
Colors.dissRoom_red = "d2471d"; -- 解散房间 等待 红色

-- Colors.versionName = cc.c3b(0,201,187); -- 版本号 淡绿色
Colors.versionName = cc.c3b(255, 255, 255) -- 版本号 白色

Colors.words_txt = cc.c3b(0x5f, 0x34, 0x11) -- 文字提示颜色 淡蓝色

-------------------------------麻将文字颜色-----------------------------------
Colors.directionText = "db8b09";--东南西北颜色
Colors.Remaining = "e5ed83";--剩余牌颜色
Colors.RemainingText = "8df3f2";--剩余牌标题颜色
Colors.roomNumber = "daf9fe";--房间号颜色
Colors.basicRule = "bbc577";--玩法规则颜色
Colors.roomRecord01 = "842e06";--房间结算颜色1
Colors.roomRecord02 = "ee3f35";--房间结算颜色2
Colors.roomRecordName01 = "dbebfd";--房间结算名字
Colors.roomRecordScore01 = "0b4083";--房间结算分数1
Colors.roomRecordScore02 = "914912";--房间结算分数2

-- 处理方法申明
function Colors:_16ToRGB4(color,_int)
	if color~=nil and type(color)=="string" and string.len(color) == 6 then
		local r1 = BigStringToNumber(string.sub(color, 1, 1));
		local r2 = BigStringToNumber(string.sub(color, 2, 2));

		local g1 = BigStringToNumber(string.sub(color, 3, 3));
		local g2 = BigStringToNumber(string.sub(color, 4, 4));

		local b1 = BigStringToNumber(string.sub(color, 5, 5));
		local b2 = BigStringToNumber(string.sub(color, 6, 6));

		local r = r1*16+r2;
		local g = g1*16+g2;
		local b = b1*16+b2;
        --Commons:printLog_Info("r g b:",r,g,b)
		return cc.c4b(r,g,b,_int);
	else
		return nil;
	end
end


-- 处理方法申明
function Colors:_16ToRGB(color)
	if color~=nil and type(color)=="string" and string.len(color) == 6 then
		local r1 = BigStringToNumber(string.sub(color, 1, 1));
		local r2 = BigStringToNumber(string.sub(color, 2, 2));

		local g1 = BigStringToNumber(string.sub(color, 3, 3));
		local g2 = BigStringToNumber(string.sub(color, 4, 4));

		local b1 = BigStringToNumber(string.sub(color, 5, 5));
		local b2 = BigStringToNumber(string.sub(color, 6, 6));

		local r = r1*16+r2;
		local g = g1*16+g2;
		local b = b1*16+b2;
        --Commons:printLog_Info("r g b:",r,g,b)
		return cc.c3b(r,g,b);
	else
		return nil;
	end
end
function BigStringToNumber(txt)
	if txt ~= nil and type(txt) == "string" then
		if txt>="0" and txt<="9" then
			return tonumber(txt)
		elseif txt=="a" or txt=="A" then
			return 10
		elseif txt=="b" or txt=="B" then
			return 11
		elseif txt=="c" or txt=="C" then
			return 12
		elseif txt=="d" or txt=="D" then
			return 13
		elseif txt=="e" or txt=="E" then
			return 14
		elseif txt=="f" or txt=="F" then
			return 15
		end
	end
end


-- 构造函数
function Colors:ctor()
end


-- 必须有这个返回
return Colors