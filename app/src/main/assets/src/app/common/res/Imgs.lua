--
-- Author: lte
-- Date: 2016-10-11 18:32:11
-- 图片文件名


-- 类申明
--local Imgs = class("Imgs", function ()
--    return display.newNode();
--end)
local Imgs = class("Imgs")


Imgs.file_img_suff = ".png"
Imgs.file_img_suff_press = "_press.png"

Imgs.file_img_suff_jpg = ".jpg"

Imgs.file_imgPlist_suff = ".plist"

Imgs.file_logo72 = "http://res.iwoapp.com/game/kl/wmq/icon72new.png" -- 暂时无用了

-- 第一级目录
Imgs.phz_respath = "img/"

	-- 一些通用性图片
	Imgs.c_respath = Imgs.phz_respath .. "c/"
		Imgs.c_edit_bg = Imgs.c_respath .."c_edit_bg.png"

		Imgs.c_check_yes = Imgs.c_respath .."c_check_yes.png" -- 单选，多选按钮图片
		Imgs.c_check_no = Imgs.c_respath .."c_check_no.png"

		Imgs.c_check_yes_login = Imgs.c_respath .."c_check_yes_login.png" -- 单选，多选按钮图片
		Imgs.c_check_no_login = Imgs.c_respath .."c_check_no_login.png"

		Imgs.c_default_img = Imgs.c_respath .."c_default_img.png"
		-- Imgs.c_splash_bg = Imgs.c_respath .."c_splash_bg.png"

		Imgs.c_transparent = Imgs.c_respath .."c_transparent.png"
		Imgs.common_transparent_skin = Imgs.c_respath .."common_transparent_skin.png"

		Imgs.c_loading = Imgs.c_respath .."c_loading.png"
		Imgs.c_juhua = Imgs.c_respath .."juhua.png"

		Imgs.c_check_yes_test = Imgs.c_respath .."c_check_yes_test.png" -- 单选，多选按钮图片
		Imgs.c_check_no_test = Imgs.c_respath .."c_check_no_test.png"

		Imgs.c_loading_plist = Imgs.c_respath .."c_loading.plist"
		Imgs.c_loading_png = Imgs.c_respath .."c_loading.pvr.ccz"

	-- 滚动条
	Imgs.scroll_respath = Imgs.phz_respath .. "scroll/"
		Imgs.scroll_bar = Imgs.scroll_respath .."scroll_bar.png" -- 滑动条图片
		Imgs.scroll_barH = Imgs.scroll_respath .."scroll_barH.png"

	-- 弹窗 相关图片
	Imgs.dialog_respath = Imgs.phz_respath .. "dialog/"
		Imgs.dialog_bg = Imgs.dialog_respath .."dialog_bg.png" -- 主题背景
		Imgs.dialog_content_bg = Imgs.dialog_respath .."dialog_content_bg.png" -- 内容背景
		Imgs.dialog_content_bg_tran = Imgs.dialog_respath .."dialog_content_bg_tran.png" -- 内容背景  透明

		Imgs.dialog_title_logo = Imgs.dialog_respath .."dialog_title_logo.png" -- logo 提示
		Imgs.dialog_title_disroom_logo = Imgs.dialog_respath .."dialog_title_disroom_logo.png" -- logo 解散房间
		Imgs.dialog_title_backhome_logo = Imgs.dialog_respath .."dialog_title_backhome_logo.png" -- logo 返回大厅

		Imgs.dialog_exit = Imgs.dialog_respath .."dialog_exit.png"-- 退出
		Imgs.dialog_exit_press = Imgs.dialog_respath .."dialog_exit_press.png"
		Imgs.dialog_back = Imgs.dialog_respath .."dialog_back.png" -- 返回按钮

		Imgs.dialog_btn_confim = Imgs.dialog_respath .."dialog_btn_confim.png" -- 确定
		Imgs.dialog_btn_confim_press = Imgs.dialog_respath .."dialog_btn_confim_press.png"

		Imgs.dialog_btn_confim_alert = Imgs.dialog_respath .."dialog_btn_confim_alert.png" -- 确认
		Imgs.dialog_btn_confim_alert_press = Imgs.dialog_respath .."dialog_btn_confim_alert_press.png"

		Imgs.dialog_btn_cancel_alert = Imgs.dialog_respath .."dialog_btn_cancel_alert.png" -- 取消
		Imgs.dialog_btn_cancel_alert_press = Imgs.dialog_respath .."dialog_btn_cancel_alert_press.png"

		Imgs.dialog_btn_update = Imgs.dialog_respath .."dialog_btn_update.png" -- 更新
		Imgs.dialog_btn_update_press = Imgs.dialog_respath .."dialog_btn_update_press.png"

		Imgs.dialog_btn_look = Imgs.dialog_respath .."dialog_btn_look.png" -- 查看
		Imgs.dialog_btn_look_press = Imgs.dialog_respath .."dialog_btn_look_press.png"

		Imgs.dialog_btn_agree = Imgs.dialog_respath .."dialog_btn_agree.png" -- 同意
		Imgs.dialog_btn_agree_press = Imgs.dialog_respath .."dialog_btn_agree_press.png" -- 同意

		Imgs.dialog_btn_notagree = Imgs.dialog_respath .."dialog_btn_notagree.png" -- 拒绝
		Imgs.dialog_btn_notagree_press = Imgs.dialog_respath .."dialog_btn_notagree_press.png" -- 拒绝

		-- gprs定位的图片
		Imgs.dialog_btn_goon = Imgs.dialog_respath .."dialog_btn_goon.png" -- 继续
		Imgs.dialog_btn_goon_press = Imgs.dialog_respath .."dialog_btn_goon_press.png"

		Imgs.dialog_btn_goout = Imgs.dialog_respath .."dialog_btn_goout.png" -- 离开
		Imgs.dialog_btn_goout_press = Imgs.dialog_respath .."dialog_btn_goout_press.png"

		Imgs.dialog_btn_godiss = Imgs.dialog_respath .."dialog_btn_godiss.png" -- 解散
		Imgs.dialog_btn_godiss_press = Imgs.dialog_respath .."dialog_btn_godiss_press.png"


	-- 登录页面 相关图片
	Imgs.login_respath = Imgs.phz_respath .. "login/"
		Imgs.login_bg = Imgs.login_respath .."login_bg.jpg"
		--Imgs.login_exit = Imgs.login_respath .."login_exit.png"
		Imgs.login_btn_wx = Imgs.login_respath .."login_btn_wx.png"-- 微信登录
		Imgs.login_btn_wx_press = Imgs.login_respath .."login_btn_wx_press.png"
		Imgs.login_btn_guest = Imgs.login_respath .."login_btn_guest.png"-- 游客登录
		Imgs.login_btn_guest_press = Imgs.login_respath .."login_btn_guest_press.png"

		Imgs.login_agreement_title_logo = Imgs.login_respath .."login_agreement_title_logo.png" -- 用户协议图片
		Imgs.login_agreementTxt = Imgs.login_respath .."login_agreementTxt.png" -- 用户协议图片

	-- 首页 相关图片
	Imgs.home_respath = Imgs.phz_respath .. "home/"
		Imgs.home_bg = Imgs.home_respath .."home_bg.jpg"
		Imgs.home_logo = Imgs.home_respath .."home_logo.png"

		Imgs.home_btn_back = Imgs.home_respath .."home_btn_back.png"
		Imgs.home_btn_back_press = Imgs.home_respath .."home_btn_back_press.png"
		Imgs.home_btn_buy_roomcard = Imgs.home_respath .."home_btn_buy_roomcard.png"
		Imgs.home_btn_buy_roomcard_press = Imgs.home_respath .."home_btn_buy_roomcard_press.png"
		Imgs.home_btn_givecard = Imgs.home_respath .."home_btn_givecard.png"
		Imgs.home_btn_givecard_press = Imgs.home_respath .."home_btn_givecard_press.png"
		Imgs.home_btn_help = Imgs.home_respath .."home_btn_help.png"
		Imgs.home_btn_help_press = Imgs.home_respath .."home_btn_help_press.png"
		Imgs.home_btn_im = Imgs.home_respath .."home_btn_im.png"
		Imgs.home_btn_im_press = Imgs.home_respath .."home_btn_im_press.png"
		Imgs.home_btn_result = Imgs.home_respath .."home_btn_result.png"
		Imgs.home_btn_result_press = Imgs.home_respath .."home_btn_result_press.png"
		Imgs.home_btn_setting = Imgs.home_respath .."home_btn_setting.png"
		Imgs.home_btn_setting_press = Imgs.home_respath .."home_btn_setting_press.png"
		Imgs.home_btn_share = Imgs.home_respath .."home_btn_share.png"
		Imgs.home_btn_share_press = Imgs.home_respath .."home_btn_share_press.png"

		Imgs.home_room_add = Imgs.home_respath .."home_room_add.png"
		Imgs.home_room_create = Imgs.home_respath .."home_room_create.png"

		Imgs.home_tip_text_bg = Imgs.home_respath .."home_tip_text_bg.png" -- 跑马灯的背景
		-- Imgs.home_tip_text_baff = Imgs.home_respath .."home_tip_text_baff.png" -- 跑马灯的遮挡物体

		Imgs.home_tip_text_red = Imgs.home_respath .."home_tip_text_red.png" -- 红点
		--Imgs.home_tip_text_green = Imgs.home_respath .."home_tip_text_green.png" -- 淡绿点
		Imgs.home_tip_text_green2 = Imgs.home_respath .."home_tip_text_green2.png" -- 淡绿点

		--Imgs.home_user_head_bg = Imgs.home_respath .."home_user_head_bg.png"
		Imgs.home_user_head_bg_top = Imgs.home_respath .."home_user_head_bg_top.png"
		Imgs.home_user_head_bg_bottom = Imgs.home_respath .."home_user_head_bg_bottom.png"

	-- 创建房间 相关图片
	Imgs.room_create_respath = Imgs.phz_respath .. "room_create/"
		Imgs.room_create_logo = Imgs.room_create_respath .."room_create_logo.png"

		-- 几局
		Imgs.room_1jushu = Imgs.room_create_respath .."room_1jushu.png"
		Imgs.room_1jushu_8 = Imgs.room_create_respath .."room_1jushu_8.png"
		Imgs.room_1jushu_16 = Imgs.room_create_respath .."room_1jushu_16.png"
		Imgs.room_1jushu_8_close = Imgs.room_create_respath .."room_1jushu_8_close.png"
		Imgs.room_1jushu_16_close = Imgs.room_create_respath .."room_1jushu_16_close.png"
		-- Imgs.room_1jushu_8_only = Imgs.room_create_respath .."room_1jushu_8_only.png"
		-- Imgs.room_1jushu_8_only_sm = Imgs.room_create_respath .."room_1jushu_8_only_sm.png"
		-- Imgs.room_1jushu_16_only = Imgs.room_create_respath .."room_1jushu_16_only.png"
		-- Imgs.room_1jushu_16_only_sm = Imgs.room_create_respath .."room_1jushu_16_only_sm.png"
		-- Imgs.room_item_bg_only = Imgs.room_create_respath .."room_item_bg_only.png"

		-- 是否加底
		Imgs.room_2jiadi = Imgs.room_create_respath .."room_2jiadi.png"
		Imgs.room_2jiadi_no = Imgs.room_create_respath .."room_2jiadi_no.png"
		Imgs.room_2jiadi_yes = Imgs.room_create_respath .."room_2jiadi_yes.png"
			-- 桌面上显示的
			Imgs.room_2jiadi_yes_mid = Imgs.room_create_respath .."room_2jiadi_yes_mid.png"

		-- 偎麻雀的名堂
		Imgs.room_2mt = Imgs.room_create_respath .."room_2mt.png"
		Imgs.room_2mt_xz = Imgs.room_create_respath .."room_2mt_xz.png"
		Imgs.room_2mt_dz = Imgs.room_create_respath .."room_2mt_dz.png"
		Imgs.room_2mt_laomt = Imgs.room_create_respath .."room_2mt_laomt.png"
		Imgs.room_2mt_quanmt = Imgs.room_create_respath .."room_2mt_quanmt.png"
			-- 桌面上显示的
			Imgs.room_2mt_xz_mid = Imgs.room_create_respath .."room_2mt_xz_mid.png"
			Imgs.room_2mt_dz_mid = Imgs.room_create_respath .."room_2mt_dz_mid.png"
			Imgs.room_2mt_laomt_mid = Imgs.room_create_respath .."room_2mt_laomt_mid.png"
			Imgs.room_2mt_quanmt_mid = Imgs.room_create_respath .."room_2mt_quanmt_mid.png"

		-- 翻醒、跟醒
		Imgs.room_3fgx = Imgs.room_create_respath .."room_3fgx.png"
		Imgs.room_3fgx_fan = Imgs.room_create_respath .."room_3fgx_fan.png"
		Imgs.room_3fgx_gen = Imgs.room_create_respath .."room_3fgx_gen.png"
			-- 桌面上显示的
			Imgs.room_3fgx_fan_mid = Imgs.room_create_respath .."room_3fgx_fan_mid.png"
			Imgs.room_3fgx_gen_mid = Imgs.room_create_respath .."room_3fgx_gen_mid.png"

		-- 单双醒
		Imgs.room_4dsx = Imgs.room_create_respath .."room_4dsx.png"
		Imgs.room_4dsx_single = Imgs.room_create_respath .."room_4dsx_single.png"
		Imgs.room_4dsx_double = Imgs.room_create_respath .."room_4dsx_double.png"
			-- 桌面上显示的
			Imgs.room_4dsx_single_mid = Imgs.room_create_respath .."room_4dsx_single_mid.png"
			Imgs.room_4dsx_double_mid = Imgs.room_create_respath .."room_4dsx_double_mid.png"

		-- 逗溜子是否打开
		Imgs.room_5dlz_selet = Imgs.room_create_respath .."room_5dlz_selet.png"
		Imgs.room_5dlz_selet_no = Imgs.room_create_respath .."room_5dlz_selet_no.png"
		Imgs.room_5dlz_selet_yes = Imgs.room_create_respath .."room_5dlz_selet_yes.png"
			-- 桌面上显示的
			Imgs.room_5dlz_selet_mid = Imgs.room_create_respath .."room_5dlz_selet_mid.png"
		-- 庄家闲家
		Imgs.room_5dlz_zx = Imgs.room_create_respath .."room_5dlz_zx.png"
		Imgs.room_5dlz_zx_1 = Imgs.room_create_respath .."room_5dlz_zx_1.png"
		Imgs.room_5dlz_zx_2 = Imgs.room_create_respath .."room_5dlz_zx_2.png"
		Imgs.room_5dlz_zx_3 = Imgs.room_create_respath .."room_5dlz_zx_3.png"
			-- 桌面上显示的
			Imgs.room_5dlz_zx_1_mid = Imgs.room_create_respath .."room_5dlz_zx_1_mid.png"
			Imgs.room_5dlz_zx_2_mid = Imgs.room_create_respath .."room_5dlz_zx_2_mid.png"
			Imgs.room_5dlz_zx_3_mid = Imgs.room_create_respath .."room_5dlz_zx_3_mid.png"
		-- 1登
		Imgs.room_5dlz_deng = Imgs.room_create_respath .."room_5dlz_deng.png"
		Imgs.room_5dlz_deng_1 = Imgs.room_create_respath .."room_5dlz_deng_1.png"
		Imgs.room_5dlz_deng_2 = Imgs.room_create_respath .."room_5dlz_deng_2.png"
		Imgs.room_5dlz_deng_3 = Imgs.room_create_respath .."room_5dlz_deng_3.png"
			-- 桌面上显示的
			Imgs.room_5dlz_deng_1_mid = Imgs.room_create_respath .."room_5dlz_deng_1_mid.png"
			Imgs.room_5dlz_deng_2_mid = Imgs.room_create_respath .."room_5dlz_deng_2_mid.png"
			Imgs.room_5dlz_deng_3_mid = Imgs.room_create_respath .."room_5dlz_deng_3_mid.png"

		-- Imgs.room_item_bg = Imgs.room_create_respath .."room_item_bg.png"
		Imgs.room_item_bg_small = Imgs.room_create_respath .."room_item_bg_small.png"
		Imgs.room_line = Imgs.room_create_respath .."room_line.png"

	-- 加入房间 相关图片
	Imgs.room_join_respath = Imgs.phz_respath .. "room_join/"
		Imgs.room_join_logo = Imgs.room_join_respath .."room_join_logo.png"
		Imgs.room_keyboard_bg = Imgs.room_join_respath .."room_keyboard_bg.png"
		Imgs.room_number_bg = Imgs.room_join_respath .."room_number_bg.png"
		Imgs.room_nums_0 = Imgs.room_join_respath .."room_nums_0.png"
		Imgs.room_nums_1 = Imgs.room_join_respath .."room_nums_1.png"
		Imgs.room_nums_2 = Imgs.room_join_respath .."room_nums_2.png"
		Imgs.room_nums_3 = Imgs.room_join_respath .."room_nums_3.png"
		Imgs.room_nums_4 = Imgs.room_join_respath .."room_nums_4.png"
		Imgs.room_nums_5 = Imgs.room_join_respath .."room_nums_5.png"
		Imgs.room_nums_6 = Imgs.room_join_respath .."room_nums_6.png"
		Imgs.room_nums_7 = Imgs.room_join_respath .."room_nums_7.png"
		Imgs.room_nums_8 = Imgs.room_join_respath .."room_nums_8.png"
		Imgs.room_nums_9 = Imgs.room_join_respath .."room_nums_9.png"
		Imgs.room_join = {
			--logo = Imgs.room_join_respath .."room_join_logo.png",
			keyboard_bg_small = Imgs.room_join_respath .."room_keyboard_bg_small.png",
		}
		Imgs.room_join_nums_show = Imgs.room_join_respath .."room_nums_"-- 通配  -- 加入房间  数字展示  图片显示
		Imgs.room_nums_code = Imgs.room_join_respath .."room_nums_code.png"-- 密文 符号是 *

	-- 玩法介绍
	Imgs.help_respath = Imgs.phz_respath .. "help/"
		Imgs.help_title_logo = Imgs.help_respath .."help_title_logo.png"

	-- 系统消息
	Imgs.im_respath = Imgs.phz_respath .. "im/"
		Imgs.im_title_logo = Imgs.im_respath .."im_title_logo.png"

	-- 分享有礼
	Imgs.share_respath = Imgs.phz_respath .. "share/"
		Imgs.share_title_logo = Imgs.share_respath .."share_title_logo.png"
		Imgs.share_btn_wx_f = Imgs.share_respath .."share_btn_wx_f.png" -- 微信好友
		Imgs.share_btn_wx_f_press = Imgs.share_respath .."share_btn_wx_f_press.png"
		Imgs.share_btn_wx_c = Imgs.share_respath .."share_btn_wx_c.png" -- 微信朋友圈
		Imgs.share_btn_wx_c_press = Imgs.share_respath .."share_btn_wx_c_press.png"

	-- 设置
	Imgs.setting_respath = Imgs.phz_respath .. "setting/"
		Imgs.setting_title_logo = Imgs.setting_respath .."setting_title_logo.png"
		-- 音效
		Imgs.setting_1row_effect_tip = Imgs.setting_respath .."setting_1row_effect_tip.png"
		Imgs.setting_1row_effect_on = Imgs.setting_respath .."setting_1row_effect_on.png"
		Imgs.setting_1row_effect_off = Imgs.setting_respath .."setting_1row_effect_off.png"
		Imgs.setting_2row_music_tip = Imgs.setting_respath .."setting_2row_music_tip.png"
		Imgs.setting_2row_music_on = Imgs.setting_respath .."setting_2row_music_on.png"
		Imgs.setting_2row_music_off = Imgs.setting_respath .."setting_2row_music_off.png"
		Imgs.setting_slider_bg = Imgs.setting_respath .."setting_slider_bg.png"
		Imgs.setting_slider_bg_layer = Imgs.setting_respath .."setting_slider_bg_layer.png"
		Imgs.setting_slider_btn = Imgs.setting_respath .."setting_slider_btn.png"

		Imgs.setting_3row_voice_tip = Imgs.setting_respath .."setting_3row_voice_tip.png"
		Imgs.setting_3row_voice_on = Imgs.setting_respath .."setting_3row_voice_on.png"
		Imgs.setting_3row_voice_off = Imgs.setting_respath .."setting_3row_voice_off.png"

		Imgs.setting_3row_ww = Imgs.setting_respath .."setting_3row_ww.png" -- 常德话
		Imgs.setting_3row_ax = Imgs.setting_respath .."setting_3row_ax.png" -- 安乡话

		Imgs.setting_btn_exit = Imgs.setting_respath .."setting_btn_exit.png"-- 退出游戏
		Imgs.setting_btn_exit_press = Imgs.setting_respath .."setting_btn_exit_press.png"-- 退出游戏

	-- 购买房卡
	Imgs.buyroomcard_respath = Imgs.phz_respath .. "buyroomcard/"
		Imgs.buyroomcard_1row_logo = Imgs.buyroomcard_respath .."buyroomcard_1row_logo.png"
		Imgs.buyroomcard_2row_logo = Imgs.buyroomcard_respath .."buyroomcard_2row_logo.png"
		Imgs.buyroomcard_btncopy = Imgs.buyroomcard_respath .."buyroomcard_btncopy.png"
		Imgs.buyroomcard_btncopy_press = Imgs.buyroomcard_respath .."buyroomcard_btncopy_press.png"

	-- 转卡
	Imgs.givecard_respath = Imgs.phz_respath .. "givecard/"
		Imgs.givecard_title_logo = Imgs.givecard_respath .."givecard_title_logo.png" -- 转卡的title

		Imgs.passwd_title_logo = Imgs.givecard_respath .."passwd_title_logo.png" -- 密码修改
		Imgs.tradelog_title_logo = Imgs.givecard_respath .."tradelog_title_logo.png" -- 交易记录

		Imgs.passwd_btn = Imgs.givecard_respath .."passwd_btn.png" -- 密码修改
		Imgs.tradelog_btn = Imgs.givecard_respath .."tradelog_btn.png" -- 交易记录
		Imgs.getCopyContent_btn = Imgs.givecard_respath .."getCopyContent_btn.png" -- 粘贴

	-- 战绩
	Imgs.result_respath = Imgs.phz_respath .. "result/"
		Imgs.result_title_logo = Imgs.result_respath .."result_title_logo.png"
		Imgs.result_item_bg = Imgs.result_respath .."result_item_bg.png"
		Imgs.result_item_content_bg = Imgs.result_respath .."result_item_content_bg.png"

		Imgs.round_item_ji = Imgs.result_respath .."round_item_ji.jpg" -- 回合战绩中 奇数行背景色
		Imgs.round_item_ou = Imgs.result_respath .."round_item_ou.jpg" -- 回合战绩中 偶数行背景色


	-- 游戏中 相关图片
	Imgs.gameing_respath = Imgs.phz_respath .. "gameing/"
		Imgs.gameing_bg = Imgs.gameing_respath .."gameing_bg.jpg"

		Imgs.gameing_top_bg = Imgs.gameing_respath .."gameing_top_bg.png"
			Imgs.gameing_top_setting = Imgs.gameing_respath .."gameing_top_setting.png" -- 设置
			Imgs.gameing_top_dismiss_room = Imgs.gameing_respath .."gameing_top_dismiss_room.png" -- 解散房间
			Imgs.gameing_top_btn_back = Imgs.gameing_respath .."gameing_top_btn_back.png" -- 返回
			Imgs.gameing_top_btn_back2 = Imgs.gameing_respath .."gameing_top_btn_back2.png" -- 返回
			Imgs.gameing_top_lz = Imgs.gameing_respath .."gameing_top_lz.png" -- 溜子
			Imgs.gameing_top_roomtitle = Imgs.gameing_respath .."gameing_top_roomtitle.png" -- 房号

		Imgs.gameing_user_head_bg = Imgs.gameing_respath .."gameing_user_head_bg.png" -- 用户背景框
		Imgs.gameing_user_score_bg = Imgs.gameing_respath .."gameing_user_score_bg.png" -- 用户分数框
		Imgs.gameing_user_prepare_ok = Imgs.gameing_respath .."gameing_user_prepare_ok.png" -- 用户是否准备好了啦？
		Imgs.gameing_banker = Imgs.gameing_respath .."gameing_banker.png" -- 用户是否是庄家
		Imgs.gameing_user_time_bg = Imgs.gameing_respath .."gameing_user_time_bg.png" -- 用户出牌的倒计时

		Imgs.gameing_dcard_pallet = Imgs.gameing_respath .."gameing_dcard_pallet.png" -- 底牌托盘
		Imgs.gameing_dcard_pallet_pai = Imgs.gameing_respath .."gameing_dcard_pallet_pai.png" -- 底牌托盘中牌

		Imgs.gameing_mid_chupai_bg = Imgs.gameing_respath .."gameing_mid_chupai_bg.png" -- 位于中间出的牌
		Imgs.gameing_mid_mopai_bg = Imgs.gameing_respath .."gameing_mid_mopai_bg.png" -- 位于中间摸到的牌
		Imgs.gameing_mid_chupai_paizhuo_line = Imgs.gameing_respath .."gameing_mid_chupai_paizhuo_line.png" -- 出牌区域的线

		Imgs.gameing_dcard_select_pallet = Imgs.gameing_respath .."gameing_dcard_select_pallet.png" -- 需要碰，吃，跑，偎等等的牌 提示的底框
		Imgs.gameing_dcard_select_bg = Imgs.gameing_respath .."gameing_dcard_select_bg.png" -- 需要碰，吃，跑，偎等等的牌  选中

		Imgs.gameing_btn_prepare = Imgs.gameing_respath .."gameing_btn_prepare.png" -- 准备按钮
		Imgs.gameing_btn_prepare_press = Imgs.gameing_respath .."gameing_btn_prepare_press.png" -- 准备按钮

		Imgs.gameing_chu_tiptxt = Imgs.gameing_respath .."gameing_chu_tiptxt.png" -- 出牌的文字提示
		Imgs.gameing_chu_tipimg = Imgs.gameing_respath .."gameing_chu_tipimg.png" -- 出牌的方向提示
		Imgs.gameing_chu_handimg = Imgs.gameing_respath .."gameing_chu_handimg.png" -- 出牌的方向提示  手

		Imgs.gameing_btn_invite = Imgs.gameing_respath .."gameing_btn_invite.png" -- 邀请好友
		Imgs.gameing_btn_invite_press = Imgs.gameing_respath .."gameing_btn_invite_press.png" -- 邀请好友

		Imgs.gameing_btn_copy_nor = Imgs.gameing_respath .."gameing_btn_copy_nor.png" -- 邀请好友  复制房间信息
		Imgs.gameing_btn_copy_pre = Imgs.gameing_respath .."gameing_btn_copy_pre.png" -- 邀请好友  复制房间信息

		-- 出牌，接牌
		Imgs.gameing_out_options = Imgs.gameing_respath .."gameing_out_" -- 通配出牌的时候 吃 碰 过等等
		Imgs.gameing_mid_options = Imgs.gameing_respath .."gameing_mid_" -- 通配中间的 吃 碰 过等
		Imgs.gameing_mid_zhanwei = Imgs.gameing_respath .."gameing_mid_zhanwei.png" -- 通配中间的 吃 碰 过等

		Imgs.gameing_out_hu_bg = Imgs.gameing_respath .."gameing_out_hu_bg.png" -- 胡牌背景
		Imgs.gameing_out_hu_title = Imgs.gameing_respath .."gameing_out_hu_title.png" -- 胡牌title
		Imgs.gameing_out_hu = Imgs.gameing_respath .."gameing_out_hu.png" -- 胡字

		Imgs.gameing_jbs = Imgs.gameing_respath .."gameing_jbs.png" -- 一坨金币
		Imgs.gameing_out_dlz = Imgs.gameing_respath .."gameing_out_dlz.png" -- 逗溜子
		Imgs.gameing_out_flz = Imgs.gameing_respath .."gameing_out_flz.png" -- 分溜子

		Imgs.gameing_user_offile_R = Imgs.gameing_respath .."gameing_user_offile_R.png" -- 离线背景图片
		Imgs.gameing_user_offile_L = Imgs.gameing_respath .."gameing_user_offile_L.png" -- 离线背景图片

		Imgs.gameing_user_xxg = Imgs.gameing_respath .."gameing_user_xxg.png" -- 离线背景图片

		-- 手上的牌 应该显示的图片
		Imgs.card_hand = Imgs.gameing_respath .."card/card_hand_" -- 通配
		Imgs.card_hand_y = Imgs.gameing_respath .."card/card_hand_y" -- 通配  手牌阴影
		Imgs.card_hand_nw0 = Imgs.gameing_respath .."card/card_hand_nw0.png" -- 王
		Imgs.card_hand_ns1 = Imgs.gameing_respath .."card/card_hand_ns1.png" -- 小一
		Imgs.card_bg_kk = Imgs.gameing_respath .."card_bg_kk.png" -- 牌的背景框框  回合结束显示胡的那张牌的背景高亮框
		Imgs.card_hand_g = Imgs.gameing_respath .."card/card_hand_g.png" -- 手牌盖住的

		-- 中间摸到的牌，等待处理的牌 应该显示的图片
		Imgs.card_mid = Imgs.gameing_respath .."card/card_mid_" -- 通配
		Imgs.card_mid_nw0 = Imgs.gameing_respath .."card/card_mid_nw0.png" -- 王
		Imgs.card_mid_ns1 = Imgs.gameing_respath .."card/card_mid_ns1.png"

		-- 打出去的牌，显示在头像边上 应该显示的图片
		Imgs.card_out = Imgs.gameing_respath .."card/card_out_"-- 通配
		Imgs.card_out_nw0 = Imgs.gameing_respath .."card/card_out_nw0.png" -- 王
		Imgs.card_out_ns1 = Imgs.gameing_respath .."card/card_out_ns1.png"

	-- 游戏结束  回合或者房间
	Imgs.over_respath = Imgs.phz_respath .. "over/"
		Imgs.over_userid_show = Imgs.over_respath .."nums_userid/nums_"-- 通配 -- 游戏中的用户ID，等等的数字    数字图片显示

		-- Imgs.over_nums_show = Imgs.over_respath .."nums/over_nums_"-- 通配
		Imgs.over_nums_roomno = Imgs.over_respath .."nums_roomno/nums_"-- 通配  -- 游戏中的房间号    数字图片显示

		Imgs.over_nums_roundno = Imgs.over_respath .."nums_roundno/nums_"-- 通配  -- 游戏中的局数，第字，局字等等的数字    数字图片显示
		-- Imgs.over_userid_di = Imgs.over_respath .."userid/over_userid_di.png"-- 第
		Imgs.over_nums_roundno_di = Imgs.over_respath .."nums_roundno/nums_di.png"-- 第
		-- Imgs.over_userid_gang = Imgs.over_respath .."userid/over_userid_gang.png"-- /
		Imgs.over_nums_roundno_gang = Imgs.over_respath .."nums_roundno/nums_gang.png"-- /
		-- Imgs.over_userid_ju = Imgs.over_respath .."userid/over_userid_ju.png"-- 局
		Imgs.over_nums_roundno_ju = Imgs.over_respath .."nums_roundno/nums_ju.png"-- 局
		Imgs.over_nums_round_dcard = Imgs.over_respath .."nums_round_dcard/nums_"-- 通配  -- 游戏中的底牌    数字图片显示

		Imgs.over_nums_scoreRound = Imgs.over_respath .."nums_scoreRound/nums_" -- 通配  -- 回合结束，房间结束的分数    数字图片显示
		-- Imgs.over_nums_jia = Imgs.over_respath .."nums/over_nums_jia.png";-- 加号
		Imgs.over_nums_scoreRound_jia = Imgs.over_respath .."nums_scoreRound/nums_jia.png"-- 加号 符号是 +
		Imgs.over_nums_scoreRound_xi = Imgs.over_respath .."nums_scoreRound_xi/nums_" -- 通配  -- 回合结束，房间结束的胡息数    数字图片显示

		-- Imgs.over_nums_show2 = Imgs.over_respath .."nums2/over_nums2_"-- 通配
		Imgs.over_nums_scoreResult = Imgs.over_respath .."nums_scoreResult/nums_" -- 通配  -- 战绩里面的分数   数字图片显示

		-- Imgs.over_nums_fk = Imgs.over_respath .."nums_fk/over_nums_fk_"-- 通配
		Imgs.over_nums_money = Imgs.over_respath .."nums_money/nums_"  -- 通配  -- 首页用户钱包房卡余额    数字图片显示

		-- 回合结束
		Imgs.overRound_respath = Imgs.over_respath .. "round/"
			Imgs.over_round_owner_logo = Imgs.overRound_respath .."over_round_owner_logo.png"-- 房主

			Imgs.over_round_title_win = Imgs.overRound_respath .."over_round_title_win.png" -- 胜利
			Imgs.over_round_title_fail = Imgs.overRound_respath .."over_round_title_fail.png" -- 失败
			Imgs.over_round_title_invalid = Imgs.overRound_respath .."over_round_title_invalid.png" -- 荒局

			Imgs.over_round_opt = Imgs.overRound_respath .."over_round_opt_"-- 通配

			Imgs.over_round_btn_next = Imgs.overRound_respath .."over_round_btn_next.png" -- 再来一局
			Imgs.over_round_btn_next2 = Imgs.overRound_respath .."over_round_btn_next.png" -- 再来一局
			Imgs.over_round_btn_next_press = Imgs.overRound_respath .."over_round_btn_next_press.png" -- 再来一局

			Imgs.over_round_btn_roomover = Imgs.overRound_respath .."over_round_btn_roomover.png" -- 牌局结束
			Imgs.over_round_btn_roomover2 = Imgs.overRound_respath .."over_round_btn_roomover.png" -- 牌局结束
			Imgs.over_round_btn_roomover_press = Imgs.overRound_respath .."over_round_btn_roomover_press.png" -- 牌局结束

			Imgs.over_round_btn_mirror = Imgs.overRound_respath .."over_round_btn_mirror.png" -- 游戏回放
			Imgs.over_round_btn_mirror_press = Imgs.overRound_respath .."over_round_btn_mirror_press.png" -- 游戏回放

			Imgs.over_round_btn_changeto_desktop = Imgs.overRound_respath .."over_round_btn_changeto_desktop.png" -- 回合结果切换到桌面
			Imgs.over_round_btn_changeto_result = Imgs.overRound_respath .."over_round_btn_changeto_result.png" -- 桌面切回到回合结果

		-- 房间结束
		Imgs.overRoom_respath = Imgs.over_respath .. "room/"
			Imgs.over_room_title_logo = Imgs.overRoom_respath .."over_room_title_logo.png"
			Imgs.over_room_win_logo = Imgs.overRoom_respath .."over_room_win_logo.png"
			Imgs.over_room_btn_share = Imgs.overRoom_respath .."over_room_btn_share.png"
			Imgs.over_room_btn_share_press = Imgs.overRoom_respath .."over_room_btn_share_press.png"
			Imgs.over_room_bg_win = Imgs.overRoom_respath .."over_room_bg_win.png"
			Imgs.over_room_bg_fail = Imgs.overRoom_respath .."over_room_bg_fail.png"

			Imgs.over_room_th_line = Imgs.overRoom_respath .."over_room_th_line.png" -- 分割线
			Imgs.over_room_th_id = Imgs.overRoom_respath .."over_room_th_id.png"
			Imgs.over_room_th_score = Imgs.overRoom_respath .."over_room_th_score.png"
			Imgs.over_room_th_flz = Imgs.overRoom_respath .."over_room_th_flz.png"
			Imgs.over_room_th_hunums = Imgs.overRoom_respath .."over_room_th_hunums.png"
			Imgs.over_room_th_mtnums = Imgs.overRoom_respath .."over_room_th_mtnums.png"

	-- 表情
	-- Imgs.biaoqing_respath = Imgs.phz_respath .. "biaoqing/"
	-- 	Imgs.biaoqing_btn = Imgs.biaoqing_respath .."biaoqing_btn.png" -- 表情按钮
		-- Imgs.biaoqing_bg = Imgs.biaoqing_respath .."biaoqing_bg.png" -- 表情背景

		-- Imgs.biaoqing_exp = Imgs.biaoqing_respath .."exp/exp_" -- 通配表情
		-- Imgs.biaoqing_exp_bf = Imgs.biaoqing_respath .."exp/exp_bf.png" -- 一个例子
		-- Imgs.biaoqing_exp_new = Imgs.biaoqing_respath .."exp/" -- 通配表情

	-- 表情 new
	Imgs.biaoqingNew_respath = Imgs.phz_respath .. "biaoqing_2/"
		Imgs.biaoqing_btn = Imgs.biaoqingNew_respath .."biaoqing_btn.png" -- 表情按钮
		
		Imgs.biaoqing_expBtn = Imgs.biaoqingNew_respath .."expBtn/" -- 通配表情 按钮
		Imgs.biaoqing_expContent = Imgs.biaoqingNew_respath .."exp/" -- 通配表情

		Imgs.bq_exit = Imgs.biaoqingNew_respath .."bq_exit.png" -- 表情  关闭按钮
		Imgs.bq_title = Imgs.biaoqingNew_respath .."bq_title.png" -- 表情  title
		Imgs.bq_bg = Imgs.biaoqingNew_respath .."bq_bg.png" -- 表情 大背景
		Imgs.bq_content_bg = Imgs.biaoqingNew_respath .."bq_content_bg.png" -- 表情 内容小背景

		Imgs.words_title = Imgs.biaoqingNew_respath .."words_title.png" -- 短语  title
		Imgs.words_content_bg = Imgs.biaoqingNew_respath .."words_content_bg.png" -- 短语的背景色  选择的时候

		Imgs.words_txt_me = Imgs.biaoqingNew_respath .."words_txt_me.png" -- 短语的背景色  me 播放的时候
		Imgs.words_txt_R = Imgs.biaoqingNew_respath .."words_txt_R.png" -- 短语的背景色  R 播放的时候
		Imgs.words_txt_L = Imgs.biaoqingNew_respath .."words_txt_L.png" -- 短语的背景色  L 播放的时候

	-- 语音
	Imgs.biaovoice_respath = Imgs.phz_respath .."biaovoice/"
		Imgs.voice_btn = Imgs.biaovoice_respath .."voice_btn.png" -- 录音按钮
		Imgs.voice_btn_press = Imgs.biaovoice_respath .."voice_btn_press.png" -- 录音按钮

		Imgs.hx_record_animate = Imgs.biaovoice_respath .."hx_record_animate_" -- 录音音量对应按钮
		Imgs.hx_record_animate_01 = Imgs.biaovoice_respath .."hx_record_animate_01.png" -- 录音音量对应按钮
		Imgs.hx_record_bg = Imgs.biaovoice_respath .."hx_record_bg.png" -- 录音音量对应按钮

		Imgs.voice_slider_bg = Imgs.biaovoice_respath .."voice_slider_bg.png" -- 录音计时进度条
		Imgs.voice_slider_bg_layer = Imgs.biaovoice_respath .."voice_slider_bg_layer.png" -- 录音计时进度条
		Imgs.voice_slider_btn = Imgs.biaovoice_respath .."voice_slider_btn.png" -- 录音计时进度条
		-- 录音进度条
		Imgs.Slider_Imgs_Voice = {
		    bar = Imgs.voice_slider_bg, -- 背景色
		    barfg = Imgs.voice_slider_bg_layer, -- 背景填充色
		    button = Imgs.voice_slider_btn, -- 滑块  c_transparent
		    button_pressed = Imgs.voice_slider_btn -- 滑块触礁图片 c_transparent
		}
		-- Imgs.voiceplay_bg = Imgs.biaovoice_respath .."voiceplay_bg.png" -- 播放录音的背景
		Imgs.voiceplay_plist = Imgs.biaovoice_respath .."voiceplay.plist"
		Imgs.voiceplay_png = Imgs.biaovoice_respath .."voiceplay.pvr.ccz"

	-- 回放
	Imgs.gamemirror_respath = Imgs.phz_respath .."gamemirror/"
		Imgs.gamemirror_bg = Imgs.gamemirror_respath .."gamemirror_bg.png"
		Imgs.gamemirror_1mf = Imgs.gamemirror_respath .."gamemirror_1mf.png"
		Imgs.gamemirror_2on = Imgs.gamemirror_respath .."gamemirror_2on.png"
		Imgs.gamemirror_2pause = Imgs.gamemirror_respath .."gamemirror_2pause.png"
		Imgs.gamemirror_2play = Imgs.gamemirror_respath .."gamemirror_2play.png"
		Imgs.gamemirror_3kf = Imgs.gamemirror_respath .."gamemirror_3kf.png"
		Imgs.gamemirror_4back = Imgs.gamemirror_respath .."gamemirror_4back.png"

	-- 数字输入
	Imgs.keyboardNumber_respath = Imgs.phz_respath .."keyboardNumber/"
		Imgs.keyboardNumber_title_logo = Imgs.keyboardNumber_respath .."keyboardNumber_title_logo.png"

	-- 系统信息
	Imgs.imip_respath = Imgs.phz_respath .."imip/"
		Imgs.imip_title_logo = Imgs.imip_respath .."imip_title_logo.png"

	-- gprs定位的图片
	Imgs.gprs_respath = Imgs.phz_respath .."gprs/"
		Imgs.g_title = Imgs.gprs_respath .."g_title.png"
		
		Imgs.g_th_red = Imgs.gprs_respath .."g_th_red.png"
		Imgs.g_th_yellow = Imgs.gprs_respath .."g_th_yellow.png"
		Imgs.g_th_green = Imgs.gprs_respath .."g_th_green.png"

		-- Imgs.g_line_top = Imgs.gprs_respath .."g_line_top.png"
		-- Imgs.g_line_left = Imgs.gprs_respath .."g_line_left.png"
		-- Imgs.g_line_right = Imgs.gprs_respath .."g_line_right.png"

		-- Imgs.g_point_bottom = Imgs.gprs_respath .."g_point_bottom.png"
		-- Imgs.g_point_left = Imgs.gprs_respath .."g_point_left.png"
		-- Imgs.g_point_right = Imgs.gprs_respath .."g_point_right.png"
		
		Imgs.g_line_3person = Imgs.gprs_respath .."g_line_3person.png"
		Imgs.g_line_4person = Imgs.gprs_respath .."g_line_4person.png"


----------------------------- 合并跑得快，增加了大厅主页-----------------------
	-- 大厅
	Imgs.mainHall_respath = Imgs.phz_respath .."mainHall/"
		Imgs.mainHall_bg = Imgs.mainHall_respath .."mainHall_bg.jpg" -- 背景

		Imgs.mainHall_title = Imgs.mainHall_respath .."mainHall_title.png" -- title

		Imgs.mainHall_GHZ_btn = Imgs.mainHall_respath .."mainHall_GHZ_btn.png" -- 字牌
		Imgs.mainHall_MJ_btn = Imgs.mainHall_respath .."mainHall_MJ_btn.png" -- 麻将
		Imgs.mainHall_poker_btn = Imgs.mainHall_respath .."mainHall_poker_btn.png" -- 扑克牌-跑得快

		Imgs.fast_join_btn_nor = Imgs.mainHall_respath .."fast_join_btn_nor.png" -- 快速加入
		Imgs.fast_join_btn_pre = Imgs.mainHall_respath .."fast_join_btn_pre.png"

	-- 字牌
	Imgs.GHZ_home_respath = Imgs.phz_respath .."home_ghz/"
		Imgs.ghz_home_bg = Imgs.GHZ_home_respath .."ghz_home_bg.jpg"
		Imgs.ghz_createRoom_btn_nor = Imgs.GHZ_home_respath .."ghz_createRoom_btn_nor.png" -- 创建房间
		-- Imgs.ghz_createRoom_btn_pre = Imgs.GHZ_home_respath .."ghz_createRoom_btn_pre.png"
		Imgs.ghz_joinRoom_btn_nor = Imgs.GHZ_home_respath .."ghz_joinRoom_btn_nor.png"  -- 加入房间
		-- Imgs.ghz_joinRoom_btn_pre = Imgs.GHZ_home_respath .."ghz_joinRoom_btn_pre.png"

	-- 跑得快
	Imgs.PDK_home_respath = Imgs.phz_respath .."home_pdk/"
		Imgs.pdk_top_logo = Imgs.PDK_home_respath .."top_logo.png"		

----------------------------- 合并跑得快，增加了大厅主页-----------------------

	-- 麻将
	Imgs.MJ_home_respath = Imgs.phz_respath .."home_mj/"
		Imgs.mj_top_logo = Imgs.MJ_home_respath .."top_logo.png"
		Imgs.mj_home_bg = Imgs.MJ_home_respath .."mj_home_bg.jpg"
		Imgs.mj_btn_createRoom = Imgs.MJ_home_respath .."mj_btn_createRoom.png"
		Imgs.mj_btn_joinRoom = Imgs.MJ_home_respath .."mj_btn_joinRoom.png"


-- 构造函数
function Imgs:ctor()
end

-- 必须有这个返回
return Imgs
