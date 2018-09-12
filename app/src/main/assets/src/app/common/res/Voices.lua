
--
-- Author: lte
-- Date: 2016-11-08 19:20:56
-- 声音 音效处理文件


-- 类申明
-- local Voices = class("Voices", function ()
--     return display.newNode();
-- end)
local Voices = class("Voices")


local sound_path = "sound/"
local words_sound_path = "sound_words/"


Voices.file = 
{
	ww_suff = ".mp3", -- 后缀名

	bg = sound_path .."bg.mp3", -- 背景音乐
	ui_click = sound_path .."ui_click.mp3", -- 点击


	ww_n = sound_path .."ww/".."n_", -- 男生版本 -- 最初的 常德话
	ww_v = sound_path .."ww/".."v_", -- 女生版本 -- 最初的 安乡话
	over_huang_ww = sound_path .."ww/".."huang.mp3", -- 荒局的声音  常德话

	ax_n = sound_path .."ax/".."n_", -- 男生版本  安乡话
	ax_v = sound_path .."ax/".."v_", -- 女生版本  安乡话
	over_huang = sound_path .."ax/".."huang.mp3", -- 荒局的声音   安乡话


	over_win = sound_path .."over/".."win.mp3", -- 胜利的声音
	over_fail = sound_path .."over/".."lose.mp3", -- 失败的声音


	gameing_sankai = sound_path .."gameing/".."sankai.mp3", -- 发牌散开的声音
	gameing_xxg = sound_path .."gameing/".."xxg.mp3", -- 小相公

	gameing_facard = sound_path .."gameing/".."facard.mp3", -- 发牌声音
	gameing_chucard = sound_path .."gameing/".."chucard.mp3", -- 出牌声音
	gameing_mocard = sound_path .."gameing/".."chucard.mp3", -- 摸牌声音

	gameing_dlz = sound_path .."gameing/".."douliuzi.mp3", -- 逗溜子
	gameing_flz = sound_path .."gameing/".."fenliuzi.mp3", -- 分溜子
	gameing_addcoin = sound_path .."gameing/".."addcoin.mp3", -- 逗溜子，分溜子之前撒钱的声音


	gameingWordsUrl_n = words_sound_path .."mandarin/".."n_", -- 通配短语地址  男生
	-- gameingWordsUrl_v = words_sound_path .."mandarin/".."v_", -- 通配短语地址  女生
}



-- 构造函数
function Voices:ctor()
end

-- 必须有这个返回
return Voices