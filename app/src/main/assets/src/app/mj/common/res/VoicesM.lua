--
-- Author: luobinbin
-- Date: 2017-07-17 19:20:56
-- 声音 音效处理文件


-- 类申明
-- local VoicesM = class("VoicesM", function ()
--     return display.newNode();
-- end)
local VoicesM = class("VoicesM")


local VOICE_PATH = "mj/sound/"


VoicesM.file = {
	ww_suff = ".mp3", -- 后缀名

	empty_sound = VOICE_PATH .."empty_sound.mp3", -- 空声音，可以去抢占停止某些声音的播放

	bg = VOICE_PATH .."bg.mp3", -- 背景音乐

	over_win = VOICE_PATH .."win.mp3", -- 胜利的声音
	over_fail = VOICE_PATH .."fail.mp3", -- 失败的声音
	over_liuju = VOICE_PATH .."liuju.mp3", -- 荒局 的声音   一个人都没有赢

	outCard = VOICE_PATH .."chupai.mp3", --出牌
	moCard = VOICE_PATH .."mopai.mp3", -- 摸牌
	fapai = VOICE_PATH .."fapai.mp3",--发牌
	timeup_alarm = VOICE_PATH .."timeup_alarm.mp3",--报警
	gameStart = VOICE_PATH .."gameStart.mp3",--开始
	handcard_click = VOICE_PATH .."handcard_click.mp3",--手牌点击
	jiangma = VOICE_PATH .."jiangma.mp3",--奖码

	-- -- 就剩下一张牌  和  就剩下2张牌的声音
	-- alert = VOICE_PATH .."effect/".."left_onecards_warning.mp3",--警告灯
	-- -- 动作，pass，要不起
	-- buyao = VOICE_PATH .."effect/".."no.mp3",--不要
	-- buyao1 = VOICE_PATH .."effect/".."buyao1.mp3",--过

	bangzhuang = "sound_superemoji/bangzhuang.mp3",
	egg = "sound_superemoji/egg.mp3",
	flower = "sound_superemoji/flower.mp3",
	water = "sound_superemoji/water.mp3",

	gang = VOICE_PATH .."option/gang.mp3",
	gang_1 = VOICE_PATH .."option/gang_1.mp3",  -- 另外一个读法
	peng = VOICE_PATH .."option/peng.mp3",
	peng_1 = VOICE_PATH .."option/peng_1.mp3", -- 另外一个读法
	ting = VOICE_PATH .."option/ting.mp3",
	hu = VOICE_PATH .."option/hu.mp3", -- 一般的胡
	hu_zimo = VOICE_PATH .."option/hu_zimo.mp3", -- 自模胡
	hu_zimo_1 = VOICE_PATH .."option/hu_zimo_1.mp3", -- 自模胡  -- 另外一个读法
	

	-- 单张牌
	card_1 = VOICE_PATH .."card/man/1.mp3",
	card_1_1 = VOICE_PATH .."card/man/1_1.mp3", -- 另外一个读法
	card_2 = VOICE_PATH .."card/man/2.mp3",
	card_3 = VOICE_PATH .."card/man/3.mp3",
	card_4 = VOICE_PATH .."card/man/4.mp3",
	card_5 = VOICE_PATH .."card/man/5.mp3",
	card_6 = VOICE_PATH .."card/man/6.mp3",
	card_7 = VOICE_PATH .."card/man/7.mp3",
	card_8 = VOICE_PATH .."card/man/8.mp3",
	card_9 = VOICE_PATH .."card/man/9.mp3",

	card_11 = VOICE_PATH .."card/man/11.mp3",
	card_11_1 = VOICE_PATH .."card/man/11_1.mp3", -- 另外一个读法
	card_12 = VOICE_PATH .."card/man/12.mp3",
	card_13 = VOICE_PATH .."card/man/13.mp3",
	card_14 = VOICE_PATH .."card/man/14.mp3",
	card_15 = VOICE_PATH .."card/man/15.mp3",
	card_16 = VOICE_PATH .."card/man/16.mp3",
	card_17 = VOICE_PATH .."card/man/17.mp3",
	card_18 = VOICE_PATH .."card/man/18.mp3",
	card_19 = VOICE_PATH .."card/man/19.mp3",

	card_21 = VOICE_PATH .."card/man/21.mp3",
	card_22 = VOICE_PATH .."card/man/22.mp3",
	card_23 = VOICE_PATH .."card/man/23.mp3",
	card_24 = VOICE_PATH .."card/man/24.mp3",
	card_25 = VOICE_PATH .."card/man/25.mp3",
	card_26 = VOICE_PATH .."card/man/26.mp3",
	card_27 = VOICE_PATH .."card/man/27.mp3",
	card_28 = VOICE_PATH .."card/man/28.mp3",
	card_29 = VOICE_PATH .."card/man/29.mp3",

	card_35 = VOICE_PATH .."card/man/35.mp3",

	
}



-- 构造函数
function VoicesM:ctor()
end

-- 必须有这个返回
return VoicesM