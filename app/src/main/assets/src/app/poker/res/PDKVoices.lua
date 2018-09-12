--
-- Author: lte
-- Date: 2016-11-08 19:20:56
-- 声音 音效处理文件


-- 类申明
-- local Voices = class("Voices", function ()
--     return display.newNode();
-- end)
local PDKVoices = class("PDKVoices")

local VOICE_PATH = "pdk/sound/"

-- 类变量申明
PDKVoices.file = {
	ww_suff = ".mp3", -- 后缀名

	bg = VOICE_PATH .."bg.mp3", -- 背景音乐

	over_win = VOICE_PATH .."win.mp3", -- 胜利的声音
	over_fail = VOICE_PATH .."fail.mp3", -- 失败的声音

	outCard = VOICE_PATH .."chupai.mp3", --出牌
	fapai = VOICE_PATH .."fapai.mp3",--发牌


	-- 就剩下一张牌  和  就剩下2张牌的声音
	alert = VOICE_PATH .."effect/".."left_onecards_warning.mp3",--警告灯
	leftOneCard = VOICE_PATH .."effect/".."left_onecards.mp3",--我就剩 1张牌啦
	leftTwoCard = VOICE_PATH .."effect/".."left_twocards.mp3",--我就剩 2张牌啦
	-- 动作，pass，要不起
	buyao = VOICE_PATH .."effect/".."pass.mp3",--不要
	buyao1 = VOICE_PATH .."effect/".."yaobuqi.mp3",--过
	-- 出牌大于2张牌的声音
	feiji = VOICE_PATH .."effect/".."airplane.mp3",--飞机
	feiji_1 = VOICE_PATH .."effect/".."airplane_1.mp3",
	shunzi = VOICE_PATH .."effect/".."shunzi.mp3",--顺子
	shunzi_1 = VOICE_PATH .."effect/".."shunzi_1.mp3",--顺子
	bomb = VOICE_PATH .."effect/".."bomb.mp3",--炸弹
	bomb_1 = VOICE_PATH .."effect/".."bomb_1.mp3",--炸弹
	liandui = VOICE_PATH .."effect/".."continuous_pair.mp3",--'连对'
	liandui_1 = VOICE_PATH .."effect/".."continuous_pair_1.mp3",--'连对'
	sanzhang = VOICE_PATH .."effect/".."three_one.mp3",
	sandaiyi = VOICE_PATH .."effect/".."three_with_one.mp3",--三带一
	sandaiyidui = VOICE_PATH .."effect/".."three_with_one_pair.mp3",--三代一对

	
	-- 单张牌
	card_1 = VOICE_PATH .."card/card_1.mp3",
	card_2 = VOICE_PATH .."card/card_2.mp3",
	card_3 = VOICE_PATH .."card/card_3.mp3",
	card_4 = VOICE_PATH .."card/card_4.mp3",
	card_5 = VOICE_PATH .."card/card_5.mp3",
	card_6 = VOICE_PATH .."card/card_6.mp3",
	card_7 = VOICE_PATH .."card/card_7.mp3",
	card_8 = VOICE_PATH .."card/card_8.mp3",
	card_9 = VOICE_PATH .."card/card_9.mp3",
	card_10 = VOICE_PATH .."card/card_10.mp3",
	card_11 = VOICE_PATH .."card/card_11.mp3",
	card_12 = VOICE_PATH .."card/card_12.mp3",
	card_13 = VOICE_PATH .."card/card_13.mp3",
	-- 一对牌
	two_1 = VOICE_PATH .."card/two_1.mp3",
	two_2 = VOICE_PATH .."card/two_2.mp3",
	two_3 = VOICE_PATH .."card/two_3.mp3",
	two_4 = VOICE_PATH .."card/two_4.mp3",
	two_5 = VOICE_PATH .."card/two_5.mp3",
	two_6 = VOICE_PATH .."card/two_6.mp3",
	two_7 = VOICE_PATH .."card/two_7.mp3",
	two_8 = VOICE_PATH .."card/two_8.mp3",
	two_9 = VOICE_PATH .."card/two_9.mp3",
	two_10 = VOICE_PATH .."card/two_10.mp3",
	two_11 = VOICE_PATH .."card/two_11.mp3",
	two_12 = VOICE_PATH .."card/two_12.mp3",
	two_13 = VOICE_PATH .."card/two_13.mp3",
}



-- 构造函数
function PDKVoices:ctor()
end

-- 必须有这个返回
return PDKVoices