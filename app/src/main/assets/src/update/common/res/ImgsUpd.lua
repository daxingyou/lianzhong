--
-- Author: lte
-- Date: 2016-10-11 18:32:11
-- 图片文件名


-- 类申明
--local ImgsUpd = class("ImgsUpd", function ()
--    return display.newNode();
--end)
local ImgsUpd = class("ImgsUpd")


ImgsUpd.upd_respath = "img/"

	-- update 目录
	ImgsUpd.update_respath = ImgsUpd.upd_respath .."update/"
		ImgsUpd.update_slider_bg = ImgsUpd.update_respath .."slider_bg.png"
		-- ImgsUpd.update_slider_bg_layer = ImgsUpd.update_respath .."slider_bg_layer.png"
		ImgsUpd.update_slider_btn = ImgsUpd.update_respath .."slider_btn.png"

	-- login 目录
	ImgsUpd.login_respath = ImgsUpd.upd_respath .."login/"
		ImgsUpd.login_bg = ImgsUpd.login_respath .."login_bg.jpg"

	-- c 目录
	ImgsUpd.c_respath = ImgsUpd.upd_respath .."c/"
		ImgsUpd.c_juhua = ImgsUpd.c_respath .."juhua.png"
		ImgsUpd.c_loading_plist = ImgsUpd.c_respath .."c_loading.plist"
		ImgsUpd.c_loading_png = ImgsUpd.c_respath .."c_loading.pvr.ccz"

	-- dialog 目录
	ImgsUpd.dialog_respath = ImgsUpd.upd_respath .."dialog/"
		ImgsUpd.dialog_bg = ImgsUpd.dialog_respath .."dialog_bg.png"
		ImgsUpd.dialog_content_bg = ImgsUpd.dialog_respath .."dialog_content_bg.png"
		ImgsUpd.dialog_title_logo = ImgsUpd.dialog_respath .."dialog_title_logo.png"
		ImgsUpd.dialog_exit = ImgsUpd.dialog_respath .."dialog_exit.png"
		ImgsUpd.dialog_exit_press = ImgsUpd.dialog_respath .."dialog_exit_press.png"
		ImgsUpd.dialog_btn_update = ImgsUpd.dialog_respath .."dialog_btn_update.png"
		ImgsUpd.dialog_btn_update_press = ImgsUpd.dialog_respath .."dialog_btn_update_press.png"


-- 构造函数
function ImgsUpd:ctor()
end

-- 必须有这个返回
return ImgsUpd
