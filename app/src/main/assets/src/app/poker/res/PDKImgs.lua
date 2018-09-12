--
-- Author: lte
-- Date: 2016-10-11 18:32:11
-- 图片文件名


-- 类申明
--local PDKImgs = class("PDKImgs", function ()
--    return display.newNode();
--end)
local PDKImgs = class("PDKImgs")


PDKImgs.img_suff = ".png"  -- 图片的一般后缀名

-- 跑得快的第一级目录
PDKImgs.pdk_respath = "pdk/img/"

    -- 创建房间
	PDKImgs.createPDKRoom_respath = PDKImgs.pdk_respath .."dialogs/createRoom/"
		PDKImgs.pdk_game_over_bg = PDKImgs.createPDKRoom_respath .."game_over_bg.png"
		
		PDKImgs.pdk_wanfa_bg = PDKImgs.createPDKRoom_respath .."wanfa_bg.png"
		PDKImgs.pdk_select_bg = PDKImgs.createPDKRoom_respath .."select_bg.png"
		PDKImgs.pdk_how_play = PDKImgs.createPDKRoom_respath .."how_play.png"

		PDKImgs.pdk_talbe_num_select = PDKImgs.createPDKRoom_respath .."talbe_num_select.png"
		PDKImgs.pdk_player_num_select = PDKImgs.createPDKRoom_respath .."player_num_select.png"
		PDKImgs.pdk_is_show_card = PDKImgs.createPDKRoom_respath .."is_show_card.png"
		PDKImgs.pdk_left_card = PDKImgs.createPDKRoom_respath .."left_card.png"
		PDKImgs.pdk_zhaniao = PDKImgs.createPDKRoom_respath .."zhaniao.png"
		PDKImgs.pdk_pay_type = PDKImgs.createPDKRoom_respath .."pay_type.png"

		PDKImgs.pdk_wanfa_selected_btn = PDKImgs.createPDKRoom_respath .."wanfa_selected_btn.png"
		PDKImgs.pdk_un_select_btn = PDKImgs.createPDKRoom_respath .."un_select_btn.png"
		PDKImgs.pdk_select_btn_pre = PDKImgs.createPDKRoom_respath .."select_btn_pre.png"
		PDKImgs.pdk_select_btn_nor = PDKImgs.createPDKRoom_respath .."select_btn_nor.png"

		PDKImgs.pdk_15_select_nor = PDKImgs.createPDKRoom_respath .."15_select_nor.png"
		PDKImgs.pdk_15_select_pre = PDKImgs.createPDKRoom_respath .."15_select_pre.png"

		PDKImgs.pdk_16_select_nor = PDKImgs.createPDKRoom_respath .."16_select_nor.png"
		PDKImgs.pdk_16_select_pre = PDKImgs.createPDKRoom_respath .."16_select_pre.png"

		PDKImgs.pdk_rondom_nor = PDKImgs.createPDKRoom_respath .."rondom_nor.png"
		PDKImgs.pdk_rondom_pre = PDKImgs.createPDKRoom_respath .."rondom_pre.png"

    -- 回合结束
	PDKImgs.tableOver_respath = PDKImgs.pdk_respath .."dialogs/roundOver/"
		PDKImgs.tableOver_over_close_btn = PDKImgs.tableOver_respath .."btn_over_close.png"
		PDKImgs.tableOver_over_bg = PDKImgs.tableOver_respath .."over_bg.png"

		PDKImgs.tableOver_win_title = PDKImgs.tableOver_respath .."title_win.png"
		PDKImgs.tableOver_lose_title = PDKImgs.tableOver_respath .."title_fail.png"

		PDKImgs.tableOver_game_continue_btn = PDKImgs.tableOver_respath .."btn_continue_nor.png"
		PDKImgs.tableOver_game_continue_btn_pre = PDKImgs.tableOver_respath .."btn_continue_pre.png"
		PDKImgs.tableOver_game_over_btn_nor = PDKImgs.tableOver_respath .."btn_over_nor.png"
		PDKImgs.tableOver_game_over_btn_pre = PDKImgs.tableOver_respath .."btn_over_pre.png"
		PDKImgs.pdk_playback_btn_nor = PDKImgs.tableOver_respath .."btn_playback_nor.png"
		PDKImgs.pdk_playback_btn_pre = PDKImgs.tableOver_respath .."btn_playback_pre.png"

		PDKImgs.talbeOver_item_bg = PDKImgs.tableOver_respath .."over_item_bg.png"
		PDKImgs.pdk_over_th_name = PDKImgs.tableOver_respath .."over_th_name.png"
		PDKImgs.pdk_over_th_sheng = PDKImgs.tableOver_respath .."over_th_sheng.png"
		PDKImgs.pdk_over_th_zhan = PDKImgs.tableOver_respath .."over_th_zhan.png"
		PDKImgs.pdk_over_th_score = PDKImgs.tableOver_respath .."over_th_score.png"

		PDKImgs.talbeOver_zhaniao_title = PDKImgs.tableOver_respath .."zhaniao_title.png"
		PDKImgs.talbeOver_spring_title = PDKImgs.tableOver_respath .."spring_title.png"

    -- 房间结束
	PDKImgs.gameover_respath = PDKImgs.pdk_respath .."dialogs/gameOver/"
		PDKImgs.game_over_bg = PDKImgs.gameover_respath .."game_over_bg.png"
		PDKImgs.game_over_title_logo = PDKImgs.gameover_respath .."game_over_title_logo.png"
		PDKImgs.game_over_item = PDKImgs.gameover_respath .."game_over_item.png"
		
		PDKImgs.share_game_btn_nor = PDKImgs.gameover_respath .."share_game_btn_nor.png"
		PDKImgs.share_game_btn_pre = PDKImgs.gameover_respath .."share_game_btn_pre.png"

		PDKImgs.gameover_zhanji_bg = PDKImgs.gameover_respath .."zhanji_bg.png"
		PDKImgs.gameover_fangzhu_title = PDKImgs.gameover_respath .."fangzhu_title.png"
		PDKImgs.gameover_high_score_title = PDKImgs.gameover_respath .."high_score_title.png"
		PDKImgs.gameover_zhadan_title = PDKImgs.gameover_respath .."zhadan_title.png"
		PDKImgs.gameover_total_score_title = PDKImgs.gameover_respath .."total_score_title.png"
		PDKImgs.gameover_winLose_title = PDKImgs.gameover_respath .."winLose_title.png"
		PDKImgs.gameover_win_icon = PDKImgs.gameover_respath .."win_icon.png"

		PDKImgs.gameover_nums_shows = PDKImgs.gameover_respath .."nums/nums_"
		PDKImgs.gameover_nums_fuhao = PDKImgs.gameover_respath .."nums/fuhao.png"
		PDKImgs.gameover_nums_win_word = PDKImgs.gameover_respath .."nums/win_word.png"
		PDKImgs.gameover_nums_lose_word = PDKImgs.gameover_respath .."nums/lose_word.png"

    -- 游戏房间
	PDKImgs.room_respath = PDKImgs.pdk_respath .."room/"
		PDKImgs.room_bg = PDKImgs.room_respath .."room_bg.jpg"
		PDKImgs.room_bg_midtxt = PDKImgs.room_respath .."room_bg_midtxt.png"
		PDKImgs.playback_bg = PDKImgs.room_respath .."playback_bg.png"
		PDKImgs.room_head_bg = PDKImgs.room_respath .."room_head_bg.png"

		PDKImgs.outCard_btn_nor = PDKImgs.room_respath .."outCard_btn_nor.png"
		PDKImgs.outCard_btn_pre = PDKImgs.room_respath .."outCard_btn_pre.png"

		PDKImgs.tip_btn_nor = PDKImgs.room_respath .."tip_btn_nor.png"
		PDKImgs.tip_btn_pre = PDKImgs.room_respath .."tip_btn_pre.png"

		PDKImgs.ready_btn_nor = PDKImgs.room_respath .."ready_btn_nor.png"
		PDKImgs.ready_btn_pre = PDKImgs.room_respath .."ready_btn_pre.png"

		PDKImgs.dealer_icon = PDKImgs.room_respath .."dealer_icon.png"
		PDKImgs.hand_cardNum_back = PDKImgs.room_respath .."hand_cardNum_back.png"

		PDKImgs.cardNum_shows = PDKImgs.room_respath .."cardNum/"
		PDKImgs.timeNum_shows = PDKImgs.room_respath .."timeNum/"

		PDKImgs.room_ready = PDKImgs.room_respath .."room_ready.png"
		PDKImgs.room_pass_out = PDKImgs.room_respath .."room_pass_out.png"
		PDKImgs.room_win = PDKImgs.room_respath .."room_win.png"

		PDKImgs.wechat_invite_btn_nor = PDKImgs.room_respath .."wechat_invite_btn_nor.png"
		PDKImgs.wechat_invite_btn_pre = PDKImgs.room_respath .."wechat_invite_btn_pre.png"

		PDKImgs.liandui_anim = PDKImgs.room_respath .."liandui_ani.png"
		PDKImgs.not_over_cards_tip = PDKImgs.room_respath .."not_over_cards_tip.png"
		PDKImgs.out_card_error = PDKImgs.room_respath .."out_card_error.png"

		PDKImgs.room_win_light = PDKImgs.room_respath .."room_win_light.png"
		PDKImgs.room_win = PDKImgs.room_respath .."room_win.png"

		PDKImgs.room_clock = PDKImgs.room_respath .."room_clock.png"
		PDKImgs.room_clock1 = PDKImgs.room_respath .."room_clock1.png"
		PDKImgs.room_clock2 = PDKImgs.room_respath .."room_clock2.png"

		PDKImgs.room_top_bg = PDKImgs.room_respath .."room_top_bg.png" -- 顶部

		PDKImgs.room_top_slz = PDKImgs.room_respath .."top_slz.png"
		PDKImgs.room_top_swz = PDKImgs.room_respath .."top_swz.png"
		PDKImgs.room_top_sj = PDKImgs.room_respath .."top_sj.png"

		PDKImgs.room_top_3zqd = PDKImgs.room_respath .."top_3zqd.png"
		PDKImgs.room_top_3zryd = PDKImgs.room_respath .."top_3zryd.png"

		PDKImgs.room_top_bzn = PDKImgs.room_respath .."top_bzn.png"
		PDKImgs.room_top_htszn = PDKImgs.room_respath .."top_htszn.png"

		PDKImgs.room_top_aa_pay = PDKImgs.room_respath .."top_aa_pay.png"
		PDKImgs.room_top_fzf = PDKImgs.room_respath .."top_fzf.png"

    -- 牌
	PDKImgs.bigcard_respath = PDKImgs.pdk_respath .."bigcard/"
		PDKImgs.bigcard_landlord_flag = PDKImgs.bigcard_respath .."landlord_flag%s.png"

	PDKImgs.smallcard_respath = PDKImgs.pdk_respath .."smallcard/"
		PDKImgs.smallcard_smalls = PDKImgs.smallcard_respath .."Small-"

	PDKImgs.pdkcard_bg = "poker_bg"  -- 扑克牌的空白背景图片
	PDKImgs.pdkcard_bg_back = "poker_bg_back"  -- 扑克牌的盖住的背景图片

	PDKImgs.pdkcard_plumSmall = "plum-small" -- 梅花
	PDKImgs.pdkcard_plumBig = "plum-big"

	PDKImgs.pdkcard_spadesSmall = "spades-small" -- 方块
	PDKImgs.pdkcard_spadesBig = "spades-big"

	PDKImgs.pdkcard_heartsSmall = "hearts-small" -- 红心
	PDKImgs.pdkcard_heartsBig = "hearts-big"

	PDKImgs.pdkcard_squareSmall = "square-small" -- 黑桃
	PDKImgs.pdkcard_squareBig = "square-big"

	PDKImgs.pdkcard_red = "red-" -- 红色 扑克牌图片
	PDKImgs.pdkcard_black = "black-" -- 黑色 扑克牌图片

	PDKImgs.pdkcard_smallJoker = "small-joker" -- 小王
	PDKImgs.pdkcard_bigJoker = "big-joker" -- 大王

	PDKImgs.pdkcard_redJ = "red-J" -- 红J 花牌图片
	PDKImgs.pdkcard_redQ = "red-Q"
	PDKImgs.pdkcard_redK = "red-K"

	PDKImgs.pdkcard_blackJ = "black-J" -- 黑J 花牌图片
	PDKImgs.pdkcard_blackQ = "black-Q"
	PDKImgs.pdkcard_blackK = "black-K"

	PDKImgs.pdkcard_landlord_flag = "landlord_flag" -- 地主牌

    -- 动画
	PDKImgs.anim_respath = PDKImgs.pdk_respath .."anim/"
		PDKImgs.anim_cardWarning_plist = PDKImgs.anim_respath .."cardWarning.plist"
		PDKImgs.anim_cardWarning_png = PDKImgs.anim_respath .."cardWarning.png"

		PDKImgs.anim_feiji_plist = PDKImgs.anim_respath .."feiji_ani.plist"
		PDKImgs.anim_feiji_png = PDKImgs.anim_respath .."feiji_ani.png"

		PDKImgs.anim_liandui_plist = PDKImgs.anim_respath .."liandui_ani.plist"
		PDKImgs.anim_liandui_png = PDKImgs.anim_respath .."liandui_ani.png" 

		PDKImgs.anim_shunzi_plist = PDKImgs.anim_respath .."shunzi_ani.plist"
		PDKImgs.anim_shunzi_png = PDKImgs.anim_respath .."shunzi_ani.png" 

		PDKImgs.anim_bomb_plist = PDKImgs.anim_respath .."bomb.plist"
		PDKImgs.anim_bomb_png = PDKImgs.anim_respath .."bomb.png" 



function PDKImgs:ctor()
end

-- 必须有这个返回
return PDKImgs
