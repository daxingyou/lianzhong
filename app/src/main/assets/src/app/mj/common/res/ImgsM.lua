--
-- Author: luobinbin
-- Date: 2017-07-19 18:32:11
-- 图片文件名


-- 类申明
--local ImgsM = class("ImgsM", function ()
--    return display.newNode();
--end)
local ImgsM = class("ImgsM")

-- 第一级目录
ImgsM.mj_respath = "mj/img/"

    -- 弹窗 相关图片
	ImgsM.dialog_respath = ImgsM.mj_respath .. "dialogs/"

		-- 创建房间
		ImgsM.createMJRoom_dialog_respath = ImgsM.dialog_respath .. "createMJRoom/"
			ImgsM.round_number = ImgsM.createMJRoom_dialog_respath  .."round_number.png"
			ImgsM.people_number = ImgsM.createMJRoom_dialog_respath  .."people_number.png"
			ImgsM.reward_mark = ImgsM.createMJRoom_dialog_respath  .."reward_mark.png"
			ImgsM.huangju = ImgsM.createMJRoom_dialog_respath  .."huangju.png"
			ImgsM.hupai = ImgsM.createMJRoom_dialog_respath  .."hupai.png"
			ImgsM.marks_num = ImgsM.createMJRoom_dialog_respath  .."marks_num.png"
			ImgsM.zimo_hu = ImgsM.createMJRoom_dialog_respath  .."zimo_hu.png"
			ImgsM.fangpao_hu = ImgsM.createMJRoom_dialog_respath  .."fangpao_hu.png"
			ImgsM.can_qidui_hu = ImgsM.createMJRoom_dialog_respath  .."can_qidui_hu.png"
			ImgsM.can_qian_ganghu = ImgsM.createMJRoom_dialog_respath  .."can_qian_ganghu.png"
			ImgsM.no_reward_mark = ImgsM.createMJRoom_dialog_respath  .."no_reward_mark.png"
			ImgsM.zhong_mark_159 = ImgsM.createMJRoom_dialog_respath  .."zhong_mark_159.png"
			ImgsM.one_mark_ok = ImgsM.createMJRoom_dialog_respath  .."one_mark_ok.png"
			ImgsM.wowo_bird = ImgsM.createMJRoom_dialog_respath  .."wowo_bird.png"
			ImgsM.mark2 = ImgsM.createMJRoom_dialog_respath  .."mark2.png"
			ImgsM.mark4 = ImgsM.createMJRoom_dialog_respath  .."mark4.png"
			ImgsM.mark6 = ImgsM.createMJRoom_dialog_respath  .."mark6.png"
			ImgsM.huangzhuang = ImgsM.createMJRoom_dialog_respath  .."huangzhuang.png"
			ImgsM.round8 = ImgsM.createMJRoom_dialog_respath  .."round8.png"
			ImgsM.round16 = ImgsM.createMJRoom_dialog_respath  .."round16.png"
			ImgsM.round24 = ImgsM.createMJRoom_dialog_respath  .."round24.png"
			ImgsM.round24 = ImgsM.createMJRoom_dialog_respath  .."round24.png"
			ImgsM.person4 = ImgsM.createMJRoom_dialog_respath  .."person4.png"
			ImgsM.un_select_radio_btn = ImgsM.createMJRoom_dialog_respath  .."un_select_radio_btn.png"
			ImgsM.selected_radio_btn = ImgsM.createMJRoom_dialog_respath  .."selected_radio_btn.png"

	-- 游戏房间
	ImgsM.room_respath = ImgsM.mj_respath .. "room/"
		ImgsM.dms_room = ImgsM.room_respath  .."dms_room.png"
		ImgsM.setting = ImgsM.room_respath  .."setting.png"
		ImgsM.head_zhuang = ImgsM.room_respath  .."head_zhuang.png"
		ImgsM.heard_border = ImgsM.room_respath  .."heard_border.png"
		ImgsM.heard_border_light = ImgsM.room_respath  .."heard_border_light.png"
		ImgsM.jiangtou_boom = ImgsM.room_respath  .."jiangtou_boom.png"
		ImgsM.jiangtou_left = ImgsM.room_respath  .."jiangtou_left.png"
		ImgsM.jiangtou_right = ImgsM.room_respath  .."jiangtou_right.png"
		ImgsM.jiangtou_top = ImgsM.room_respath  .."jiangtou_top.png"
		ImgsM.laizi = ImgsM.room_respath  .."laizi.png"
		ImgsM.mj_namebg = ImgsM.room_respath  .."mj_namebg.png"
		ImgsM.room_bg = ImgsM.room_respath  .."room_bg.jpg"
		ImgsM.timebg = ImgsM.room_respath  .."timebg.png"
		ImgsM.timebg_top = ImgsM.room_respath  .."timebg_top.png"
		ImgsM.ting = ImgsM.room_respath  .."ting.png"
		ImgsM.wei_zhongma = ImgsM.room_respath  .."wei_zhongma.png"
		ImgsM.zhishi = ImgsM.room_respath  .."zhishi.png"
		ImgsM.zhishi_boom = ImgsM.room_respath  .."zhishi_boom.png"
		ImgsM.zhishi_left = ImgsM.room_respath  .."zhishi_left.png"
		ImgsM.zhishi_right = ImgsM.room_respath  .."zhishi_right.png"
		ImgsM.zhishi_top = ImgsM.room_respath  .."zhishi_top.png"
		ImgsM.zhongma_border = ImgsM.room_respath  .."zhongma_border.png"
		ImgsM.headlight = ImgsM.room_respath  .."headlight.png"
		ImgsM.lookDicardNor = ImgsM.room_respath  .."lookDicardNor.png"
		ImgsM.lookDicardSel = ImgsM.room_respath  .."lookDicardSel.png"
		ImgsM.jiangma = ImgsM.room_respath  .."jiangma.png"
		ImgsM.hideDicardNor = ImgsM.room_respath  .."hideDicardNor.png"
		ImgsM.hideDicardSel = ImgsM.room_respath  .."hideDicardSel.png"

		ImgsM.mjhand_plist = ImgsM.room_respath  .."plist/mjhand.plist"
		ImgsM.mjhand_texture = ImgsM.room_respath  .."plist/mjhand.png"

		ImgsM.ting = ImgsM.room_respath  .."ting.png" -- 听
		ImgsM.tingBg = "#tingBg.png" -- 听牌背景

		ImgsM.mj_zhishi = "#mj_zhishi.png" -- 谁打的牌，一个指示陀螺图标
		ImgsM.laizi = "#laizi.png" -- 癞子标识
		ImgsM.arrow = "#arrow.png" -- 指示箭头
		ImgsM.chu_card_bg = "#chu_card_bg.png" -- 出牌 牌背景牌

		ImgsM.sprite_peng = "#sprite_peng.png" -- 碰
		ImgsM.sprite_gang = "#sprite_gang.png" -- 杠
		ImgsM.sprite_hu = "#sprite_hu.png" -- 胡		

		ImgsM.hand_bg = "#hand_bg.png" -- 自己  竖着的白底牌
		ImgsM.peng_shang = "#peng_shang.png" -- 自己  横着的白底牌
		ImgsM.peng_gai = "#peng_gai.png" -- 自己  盖住的背景牌
		
		ImgsM.left_shang = "#left_shang.png" -- 左手边 横着的白底牌
		ImgsM.left_shang02 = "#left_shang02.png"
		ImgsM.left_blank = "#left_blank.png" -- 左手边 竖着的白底牌
		ImgsM.left_gai = "#left_gai.png" -- 左手边  盖住的背景牌
		ImgsM.left_gai02 = "#left_gai02.png"

		ImgsM.mid_hand_blank = "#mid_hand_blank.png" -- 对家的 竖着的盖牌
		ImgsM.mjgai = "#mjgai.png" -- 对家的 竖着的盖牌
		

		-- 游戏 回合结束
		ImgsM.room_record_respath = ImgsM.room_respath .. "record/"
			ImgsM.continue = ImgsM.room_record_respath  .."continue.png"
			ImgsM.fail = ImgsM.room_record_respath  .."fail.png"
			ImgsM.huangJu = ImgsM.room_record_respath  .."huangJu.png"
			ImgsM.huBorder = ImgsM.room_record_respath  .."huBorder.png"
			ImgsM.jieSuan = ImgsM.room_record_respath  .."jieSuan.png"
			ImgsM.overBg = ImgsM.room_record_respath  .."overBg.png"
			ImgsM.recordHu = ImgsM.room_record_respath  .."recordHu.png"
			ImgsM.roomMain = ImgsM.room_record_respath  .."roomMain.png"
			ImgsM.scoreBg = ImgsM.room_record_respath  .."scoreBg.png"
			ImgsM.scoreBorder = ImgsM.room_record_respath  .."scoreBorder.png"
			ImgsM.share = ImgsM.room_record_respath  .."share.png"
			ImgsM.success = ImgsM.room_record_respath  .."success.png"
			ImgsM.zhongMaBg = ImgsM.room_record_respath  .."zhongMaBg.png"
			ImgsM.gameOverNormal = ImgsM.room_record_respath  .."gameOverNormal.png"
			ImgsM.gameOverPress = ImgsM.room_record_respath  .."gameOverPress.png"
			ImgsM.winner = ImgsM.room_record_respath  .."winner.png"
			ImgsM.gameOverNorBg = ImgsM.room_record_respath  .."gameOverNorBg.png"
			ImgsM.gameOverNorWin = ImgsM.room_record_respath  .."gameOverNorWin.png"
			ImgsM.bgwinner = ImgsM.room_record_respath  .."bgwinner.png"

		-- 超级表情  静态显示图片
		ImgsM.room_superEmoji_respath = ImgsM.room_respath .. "supEmoji/"
			ImgsM.bangzhuang = ImgsM.room_superEmoji_respath  .."bangzhuang.png"
			ImgsM.biaoqing_bg = ImgsM.room_superEmoji_respath  .."biaoqing_bg.png"
			ImgsM.egg = ImgsM.room_superEmoji_respath  .."egg.png"
			ImgsM.flower = ImgsM.room_superEmoji_respath  .."flower.png"
			ImgsM.outu_bg = ImgsM.room_superEmoji_respath  .."outu_bg.png"
			ImgsM.poshui = ImgsM.room_superEmoji_respath  .."poshui.png"
			ImgsM.water = ImgsM.room_superEmoji_respath  .."water.png"

	-- 超级表情  动画图片集合
	ImgsM.superEmoji_anim_respath = ImgsM.mj_respath .. "ani/superEmoji/"	
		ImgsM.superEmoji_plist = ImgsM.superEmoji_anim_respath .."supEmoji.plist"
		ImgsM.superEmoji_texture = ImgsM.superEmoji_anim_respath .."supEmoji.png"

ImgsM.room_options = "_normal"
ImgsM.room_options_sel = "_selected"


function ImgsM:ctor()
end

return ImgsM
