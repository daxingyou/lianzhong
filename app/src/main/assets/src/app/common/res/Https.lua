--
-- Author: lte
-- Date: 2016-10-29 11:39:26
-- http请求的一些相关地址申明

local Https = class("Https")


-- 类变量申明
--todo 正式打包，需要更新的

-- -- 快来扯胡子的地址
-- Https.httpUrl = "http://192.168.1.41:8080/yzchz-api-impl/";  -- 测试地址
-- -- Https.httpUrl = "http://yzchz.api.depuju.com/";  -- 域名地址

-- -- 快来偎麻雀的地址
-- Https.httpUrl = "http://192.168.1.41:8080/wmq-api-impl/";  -- 测试地址
-- -- Https.httpUrl = "http://wmq.api.depuju.com/";  -- 域名地址

-- 偎麻雀的地址
-- Https.httpUrl = "http://118.24.183.77:8080/qp-api-impl/";  -- 测试地址
Https.httpUrl = HttpsUpd.httpUrl   -- 域名地址

Https.DomainName = HttpsUpd.DomainName -- 纯粹的域名记录

Https.url = {

	fromWXService_token = 'https://api.weixin.qq.com/sns/oauth2/access_token', -- 微信服务器获取 wx token

	getWXLogin = 'auth/wxLogin.json', -- 微信登录
	getGuestLogin = 'auth/guestLogin.json', -- 游客登录
	getLogin = 'auth/tokenLogin.json', -- token登录

	getHome = 'constants/getAllV200.json', -- 获取房间信息
	getRoomCreate = 'room/create.json', -- 创建房间
	getRoomJoin = 'room/joinCheck.json', -- 加入房间

	getHelpInfo = 'client/version/getPlayIntroUrl.json', -- 玩法介绍
	getImInfo = 'sys/getMessage.json', -- 系统消息

	getShareInfo = 'client/share/getContent.json', -- 分享有礼
	sendShareClick = 'client/share/click.json', -- 分享点击上报
	sendShareSucc = 'client/share/success.json', -- 分享成功上报

	getGiveCard = 'user/wallet/transBalance.json', -- 转卡
	getPasswdMod = 'user/wallet/updateTransPasw.json', -- 密码修改
	getRoomBalance = 'user/wallet/getBalance.json', -- 获取用户房卡余额

	getResultRoom = 'room/getRecords.json', -- 获取战绩 房间

	getOtherResultRound = 'room/getOtherRounds.json', -- 获取战绩 回合
	getOtherResultRound_Detail = 'room/getOtherRoundDetail.json', -- 获取战绩 回合 详情
	getOtherGameingMirror = 'room/getOtherRoundPlaybackUrl.json', -- 游戏回放

	getResultRound = 'room/getRounds.json', -- 获取战绩 回合
	getResultRound_Detail = 'room/getRoundDetail.json', -- 获取战绩 回合 详情
	getGameingMirror = 'room/getRoundPlaybackUrl.json', -- 游戏回放

	uploadImg = 'upload/img.json', -- 上传图片
	uploadVoice = 'upload/audio.json', -- 上传录音

	getUpdateApp = 'client/version/upgrade.json', -- 检查更新
	getHotUpdate = '', -- 热更新地址

	getUserNickname = 'user/getUserNickname.json', -- 获取用户昵称
	getTradeLogs = 'user/wallet/getTradeLogs.json', -- 获取交易记录

	-----------------------跑得快的地址---------------------------------------------
	createPDKroom = "room/pdk/create.json", --创建跑得快房间

	getPDKRecords = "room/pdk/getRecords.json",--获取跑得快战绩

	getPDKRounds = "room/pdk/getRounds.json",--获取回合战绩
	getPDKRoundsDetail = "room/pdk/getRoundDetail.json",--获取指定回合战绩
	getPDKGameingMirror = 'room/pdk/getRoundPlaybackUrl.json', -- 游戏回放

	getOtherPDKRounds = "room/pdk/getOtherRounds.json",--获取回合战绩
	getOtherPDKRoundsDetail = "room/pdk/getOtherRoundDetail.json",--获取指定回合战绩
	getOtherPDKGameingMirror = 'room/pdk/getOtherRoundPlaybackUrl.json', -- 游戏回放
	-----------------------跑得快的地址---------------------------------------------


	-----------------------麻将的地址---------------------------------------------
	createMJRoom = "room/hzmj/create.json",    --创建麻将房间

	getMJRecords = "room/hzmj/getRecords.json",--获取麻将战绩

	getMJRounds = "room/hzmj/getRounds.json",--获取回合战绩
	getMJRoundsDetail = "room/hzmj/getRoundDetail.json",--获取指定回合战绩
	getMJGameingMirror = 'room/hzmj/getRoundPlaybackUrl.json', -- 游戏回放

	getOtherMJRounds = "room/hzmj/getOtherRounds.json",--获取回合战绩  他人的
	getOtherMJRoundsDetail = "room/hzmj/getOtherRoundDetail.json",--获取指定回合战绩  他人的
	getOtherMJGameingMirror = 'room/hzmj/getOtherRoundPlaybackUrl.json', -- 游戏回放  他人的
}

-- 构造函数
function Https:ctor()
end

-- 必须有这个返回
return Https