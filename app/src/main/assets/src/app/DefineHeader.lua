--
-- Author: lte
-- Date: 2016-10-10 11:51:47
--  申明加载需要的类和对象


--[[
        这里申明的前面的类名，直接可以参与变量的调用
        所以变量调用：Strings.ext <==> Strings:new().ext
        方法调用是：Strings:getExt() <==> Strings:new():getExt();
       区别在于：有new()，会走那个类的构造函数进行初始化
--]]

-- 工具类
Strings = require("app.common.res.Strings") -- 文字
EnStatus = require("app.common.res.EnStatus") -- 按钮状态的文字，英文偏多

Imgs = require("app.common.res.Imgs") -- 图片名
Dimens = require("app.common.res.Dimens") -- 文字的大小定义

Colors = require("app.common.res.Colors") -- 颜色
Fonts = require("app.common.res.Fonts") -- 字体

Commons = require("app.common.res.Commons") -- 方法体内 很多简单处理的类
Nets = require("app.common.res.Nets") -- http请求
CEnum = require("app.common.res.CEnum") -- 模拟枚举
CVar = require("app.common.res.CVar") -- 全局变量

Voices = require("app.common.res.Voices") -- 声音 音效

 
CDAlert = require("app.common.widgets.CDAlert") -- 自定义 信息 提示框  会自动关闭
CDAlertManu = require("app.common.widgets.CDAlertManu") -- 自定义 信息 提示框  有明显的关闭按钮，触屏也可以消失
CDAlertLoading = require("app.common.widgets.CDAlertLoading") -- 自定义 信息 提示框  必须程序来关闭，用户无法关闭
CDialog = require("app.common.widgets.CDialog") -- 自定义 信息 提示框  有确认和取消按钮操作
DealCardAnim = require("app.common.widgets.DealCardAnim") -- 发牌动画
DlzAnim = require("app.common.widgets.anim.DlzAnim") -- 动画  逗溜子
FlzAnim = require("app.common.widgets.anim.FlzAnim") -- 动画  分溜子
KeyboardNumberDialog=require("app.common.widgets.KeyboardNumberDialog") -- 自定义数字键盘

CDAlertIP = require("app.views.alerts.CDAlertIP") -- 自定义 信息 提示框  ip 昵称 icon显示
CDAlertDissRoom = require("app.views.alerts.CDAlertDissRoom") -- 自定义 信息 提示框  解散房间
-- CDailogUpdateApp = require("app.views.alerts.CDailogUpdateApp") -- 自定义 信息 提示框  是否有升级
CDAlertGprs = require("app.views.alerts.CDAlertGprs") -- 自定义 定位之后的详细信息展示
CDAlertGprs4person = require("app.views.alerts.CDAlertGprs4person") -- 自定义 定位之后的详细信息展示

require("app.common.widgets.UIDragUtil") -- 自定义 可以拖拽的对象  一些相应属性的赋值
require("app.common.widgets.UIDrag") -- 自定义 可以拖拽的对象

-- 重要信息保存类
UserDefaultUtil = require("app.common.utils.UserDefaultUtil") -- 保存单个值 基类
GameStateUtil = require("app.common.utils.GameStateUtil") -- table值 信息保存 基类
GameStateNetImg = require("app.common.utils.GameStateNetImg") -- table值 网络图片
GameStateUserInfo = require("app.common.utils.GameStateUserInfo") -- table值 用户信息
GameStateUserGameing = require("app.common.utils.GameStateUserGameing") -- table值 游戏信息
GameState_VoiceSetting = require("app.common.utils.GameState_VoiceSetting") -- table值 游戏信息
GameState_UserProxy = require("app.common.utils.GameState_UserProxy") -- table值 代理信息
GameState_VoiceFile = require("app.common.utils.GameState_VoiceFile") -- table值 录音文件
GameState_MirrorDataFile = require("app.common.utils.GameState_MirrorDataFile") -- table值 回放数据文件


-- 网络图片下载
NetSpriteImg = require("app.common.utils.NetSpriteImg") -- 下载网络图片并且显示
CutScreenUtil = require("app.common.utils.CutScreenUtil") -- 截屏图片
NetMirrorDataUtil = require("app.common.utils.NetMirrorDataUtil") -- 回合结束的回放数据下载和显示
ImDealUtil = require("app.common.utils.ImDealUtil") -- 录音上传和下载处理
NetIsOKUtil = require("app.common.utils.NetIsOKUtil") -- 网络是否ok
EmojiDialog = require("app.views.dialogs.EmojiDialog") -- 表情弹窗


-- 解析json文件
ParseBase=require("app.common.net.parse.ParseBase") -- 解析json 基类

-- http请求
-- CReq = require("app.common.res.CReq") -- 请求参数定义
Https = require("app.common.res.Https") -- ip、port、http地址 等等信息
RequestBase=require("app.common.net.req.RequestBase") -- http请求服务连接 基类
RequestHome=require("app.common.net.req.RequestHome")
RequestLogin=require("app.common.net.req.RequestLogin")


-- socket tcp
SocketTCP = require("framework.cc.net.SocketTCP") -- 官方包
ByteArray = require("framework.cc.utils.ByteArray") -- 官方包
Sockets = require("app.common.res.Sockets") -- ip、port、命令指令 等等信息
--SockMsg = import("app.common.net.socket.SocketMsg") -- 连接、发送、断开的工具  需要的地方去import即可
-- socket请求
SocketRequestBase=require("app.common.net.socket.SocketRequestBase") -- socket请求 基类
SocketRequestGameing=require("app.common.net.socket.SocketRequestGameing") -- 登录房间等等操作
-- 假设socket返回数据
SocketResponseDataTest=require("app.common.net.socket.SocketResponseDataTest") -- 假设socket返回数据


-- bean类
User = import("app.beans.User");
Room = import("app.beans.Room");
Wallet = import("app.beans.Wallet");
Player = import("app.beans.Player");
RoundRecord = import("app.beans.RoundRecord");
RoomRecord = import("app.beans.RoomRecord");
Result = import("app.beans.Result");
WX = import("app.beans.WX");
Proxies = import("app.beans.Proxies");
UpdateApp = import("app.beans.UpdateApp");
ShareInfo = import("app.beans.ShareInfo");
TradeLog = import("app.beans.TradeLog");
-- HotUpdate = import("app.beans.HotUpdate")
Gprs = import("app.beans.Gprs")

-- 闪屏页
-- SplashScene=require("app.scenes.SplashScene")
-- SplashNode=require("app.nodes.SplashNode")
-- 登录页
-- LoginScene = require("app.scenes.LoginScene")

-- 主页
HomeScene=require("app.scenes.HomeScene")
-- 游戏页
GameingScene=require("app.scenes.GameingScene")

GameingDealUtil=require("app.nodes.GameingDealUtil") -- 游戏中 工具类  需要的单独处理方法
GameingHandCardDeal=require("app.nodes.GameingHandCardDeal") -- 游戏中 本人手牌和出牌区域等等的创建
GameingMeChiCardDeal=require("app.nodes.GameingMeChiCardDeal") -- 游戏中 本人吃碰胡过牌的具体处理
GameingCurrChiCardDeal=require("app.nodes.GameingCurrChiCardDeal") -- 游戏中  所有玩家已经吃碰过牌的具体处理 消失动画
GameingNode=require("app.nodes.GameingNode") -- 游戏中 需要的单独处理方法

VoiceDealUtil=require("app.nodes.VoiceDealUtil") -- 声音 音效

BuyRoomcardDialog = require("app.views.dialogs.BuyRoomcardDialog") -- 客服信息框
GiveCardDialog = require("app.views.dialogs.GiveCardDialog") -- 转卡框
SettingDialog = require("app.views.dialogs.SettingDialog") -- 游戏设置框
CreateRoomDialog = require("app.views.dialogs.CreateRoomDialog") -- 游戏创建房间框
JoinRoomDialog = require("app.views.dialogs.JoinRoomDialog") -- 加入房间框
ResultRoomDialog = require("app.views.dialogs.ResultRoomDialog") -- 战绩框  每个房间的战绩
ShareInfoDialog = require("app.views.dialogs.ShareInfoDialog") -- 分享app框
ImInfoDialog = require("app.views.dialogs.ImInfoDialog") -- 系统消息框
HelpInfoDialog = require("app.views.dialogs.HelpInfoDialog") -- 玩法介绍框

ResultRoomDialog = require("app.views.dialogs.ResultRoomDialog") -- 战绩 房间情况
ResultRoundDialog = require("app.views.dialogs.ResultRoundDialog") -- 战绩 回合情况

GameingOverRoomDialog = require("app.views.dialogs.GameingOverRoomDialog") -- 游戏中的  房间结算
GameingOverRoundDialog = require("app.views.dialogs.GameingOverRoundDialog") -- 游戏中的  回合结算

GameingMirrorDialog = require("app.views.dialogs.GameingMirrorDialog") -- 回放

GPasswdModDialog = require("app.views.dialogs.GPasswdModDialog") -- 密码修改
TradeLogDialog = require("app.views.dialogs.TradeLogDialog") -- 交易记录



----------------------------- 合并跑得快，增加了大厅主页-----------------------
MainHallScene=require("app.scenes.MainHallScene")
----------------------------- 合并跑得快，增加了大厅主页-----------------------



----------------------------- 跑得快 -----------------------
CEnumP = require("app.poker.res.CEnumP") -- 公用变量和枚举类型申明  ip、port、http地址 等等信息
PDKImgs = require("app.poker.res.PDKImgs")
PDKVoices = require("app.poker.res.PDKVoices")

EmojiView = require("app.poker.view.EmojiView") -- 通用组件 表情接受到之后的显示处理界面

-- 跑得快 游戏桌面
PDKRoomScene = require("app.poker.scenes.PDKRoomScene")

CreatePDKRoomDialog = require("app.poker.dialogs.CreatePDKRoomDialog") -- 创建房间

RequestPDKcreateRoom = require("app.poker.net.req.RequestPDKcreateRoom") -- 创建跑得快房间
RequestPDKRoomResult = require("app.poker.net.req.RequestPDKRoomResult") -- 跑得快战绩

CardView = require("app.poker.view.CardView")
CardListView = require("app.poker.view.CardListView")
MycardView = require("app.poker.MycardView")
RoomPlayerManager = require("app.poker.RoomPlayerManager")
RoomModel = require("app.poker.model.RoomModel")
RoomController = require("app.poker.RoomController")
RoomTopOprationManager = require("app.poker.RoomTopOprationManager")
ClockManager = require("app.poker.ClockManager")
AnimManager = require("app.poker.AnimManager")
Status = require("app.poker.view.Status")
StatusManager = require("app.poker.StatusManager")
OutcardManager = require("app.poker.OutcardManager")
PDKShowOtherCardsManager = require("app.poker.dialogs.playback.PDKShowOtherCardsManager")
PDKOtherCardView = require("app.poker.dialogs.playback.PDKOtherCardView")
LeftCardManager = require("app.poker.LeftCardManager")
ReadyControl = require("app.poker.view.ReadyControl")
OutCardControl = require("app.poker.view.OutCardControl")
WeChatInviteControl = require("app.poker.view.WeChatInviteControl")

PDKOverRoomDialog = require("app.poker.dialogs.PDKOverRoomDialog")
PDKOverRoundDialog = require("app.poker.dialogs.PDKOverRoundDialog")

PDKSocketGameing = require("app.poker.net.PDKSocketGameing")
PDKSocketResponseDataTest = require("app.poker.net.PDKSocketResponseDataTest")
-- PDKDissRoomDialog = require("app.poker.dialogs.PDKDissRoomDialog")

PDKServerIpCheckDialogNew = require("app.poker.dialogs.PDKServerIpCheckDialogNew")

PDKPlaybackNode = require("app.poker.dialogs.playback.PDKPlaybackNode")
PDKPlaybackController = require("app.poker.dialogs.playback.PDKPlaybackController")
----------------------------- 跑得快 -----------------------


----------------------------- 麻将 -----------------------
CEnumM = require("app.mj.common.res.CEnumM") -- 麻将公用变量和枚举类型申明  ip、port、http地址 等等信息
CommonsM = require("app.mj.common.res.CommonsM") -- 方法体内 很多简单处理的类
VoicesM = require("app.mj.common.res.VoicesM") -- 麻将声音 音效
ImgsM = require("app.mj.common.res.ImgsM") -- 图片名
TimerM = require("app.mj.common.utils.TimerM") -- 计时器

-- bean类
RoomM = import("app.mj.beans.RoomM");

CreateMJRoomDialog = require("app.mj.dialogs.CreateMJRoomDialog") -- 创建房间
PlayerRoundRecordDialog = require("app.mj.dialogs.PlayerRoundRecordDialog") -- 玩家回合战绩
PlayerRoomRecordDialog = require("app.mj.dialogs.PlayerRoomRecordDialog") -- 玩家房间战绩
SupEmojiDialog = require("app.mj.dialogs.SupEmojiDialog") -- 超级表情

RequestMJCreateRoom = require("app.mj.common.net.req.RequestMJCreateRoom") -- 创建麻将房间
RequestMJRoomResult = require("app.mj.common.net.req.RequestMJRoomResult") -- 麻将战绩
MJRoomScene = require("app.mj.scenes.MJRoomScene") -- 麻将房间
GameMaJiangUtil = require("app.mj.nodes.GameMaJiangUtil") -- 麻将房间管理
AnimationManager = require("app.mj.nodes.AnimationManager") -- 动画管理器

--麻将socket请求
MJSocketGameing=require("app.mj.common.net.socket.MJSocketGameing") -- 假设socket返回数据
-- 假设socket返回数据
MJSocketResponseDataTest=require("app.mj.common.net.socket.MJSocketResponseDataTest") -- 假设socket返回数据

MirrorMJRoomDialog = require("app.mj.dialogs.MirrorMJRoomDialog") -- 回放页面




