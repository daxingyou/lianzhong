--
-- Author: lte
-- Date: 2016-10-11 18:31:56
-- 所有的文字申明

-- 类申明
-- local Strings = class("Strings", function ()
--     return display.newNode();
-- end)
local Strings = class("Strings")


-- 游戏名称
  Strings.app_name = "快来·偎麻雀"
  Strings.app_name_pdk = "快来·跑得快"
  Strings.app_name_mj = "快来·红中麻将"

-- 著作权：@Copyright 2017 深圳市悦徕网络科技有限公司
  Strings.company = "粤ICP备17002418号  粤网文(2017)1488-115号  粤[2017]0278号"

Strings.home_bottom = "抵制不良游戏，拒绝盗版游戏。注意自我保护，谨防受骗上当。适度游戏益脑，沉迷游戏伤身。合理安排时间，享受健康生活。";

Strings.common_enter = "进入"
Strings.common_exit = "退出"
Strings.common_leave = "离开"
Strings.common_going = "继续"
Strings.common_promt = "提示"
Strings.common_confim = "确定"
Strings.common_cancel = "取消"

Strings.game_name = "游戏"

Strings.login_wx = "微信登录"
Strings.exit_login_Really = "您需要退出游戏？"
Strings.exit_login = "您需要重新登录？"

Strings.room_join_reset = "重输"
Strings.room_join_del = "删除"

Strings.hint_Loading = "加载中......"
Strings.hint_NoSocketIpPort = "网络繁忙"

-- 游戏中的一些文字
Strings.gameing = { -- 游戏中的一些文字
	xi = "胡息",
	xi_maohao = "硬息：",
	
	score = "分数:",

	onlineName = "(在线)", -- 在线
	offlineName = "(离线)", -- 离线

	noConnectServer = "网络不稳定，正在重连......",

	ResultDialogHintTxt = "注意：房卡在游戏开始后扣除，游戏开始前解散不扣除房卡",

	giveup_hu = "是否弃胡？",

  noData_info = "暂无数据",
  noData_resultRoom = "没有战绩",
  noData_roundRoom = "没有房间战绩",
  noData_roundDetailRoom = "没有记录",
	noData_TradeLogs = "没有交易记录",

  dissRoomConfim = "确定要解散房间吗?",
  outRoomConfim = "确定要离开游戏，返回大厅？",
}

-- 分享 邀请好友  来玩游戏的提示
-- Strings.gameing_share_title1 = "一缺二"
-- Strings.gameing_share_title2 = "二缺一"
Strings.gameing_share_jumpUrl = "http://wmq.yuelaigame.com" -- app下载地址，现在已经是从服务器获取变更这个值
Strings.gameing_share_jumpUrl_ios = "http://wmq.yuelaigame.com" -- app下载地址，现在已经是从服务器获取变更这个值

-- 玩法介绍
  Strings.helpinfo_txt = ''

-- 用户使用协议
  Strings.login_agreement_text = 
[[

快来游戏用户协议
《健康游戏忠告》
抵制不良游戏，拒绝盗版游戏。注意自我保护，谨防受骗上当。
适度游戏益脑，沉迷游戏伤身。合理安排时间，享受健康生活。
倡导理性消费，享受竞技快乐。
禁止利用本游戏进行赌博等违法犯罪行为，一经发现，立即封停账号、并向公安机关举报。

欢迎使用深圳市悦徕网络科技有限公司旗下的快来游戏的服务(以下简称“快来游戏”)，请您（以下可称“用户”或“玩家”或“您”）仔细阅读以下条款：如果您未满18周岁，请在法定监护人的陪同下阅读本协议。本协议系您与快来游戏之间所订立的权利义务规范。如果您对本协议的任何条款或快来游戏随时对其的修改表示异议，您可以选择不进入本游戏；进入本游戏或使用快来游戏服务，则意味着您同意遵守本协议全部约定，包括快来游戏对协议随时所做的任何修改，并完全服从快来游戏的统一管理。

一、定义

  1.1 本协议：指本协议正文及其修订版本、本游戏的规则及其修订版本。本协议同时还包括文化部依据《网络游戏管理暂行办法》（文化部令第49号）制定的《网络游戏服务格式化协议必备条款》（详见附录）。

  1.2 游戏规则：指快来游戏不时发布并修订的关于游戏的用户协议、游戏规则、游戏公告及通知、 指引、说明等内容。

  1.3 您：又称“玩家”或“用户”，指接受快来游戏服务的自然人。

  1.4 游戏数据：指您在使用快来游戏服务过程中产生的并存储于服务器的各种数据信息，包括游戏日志、安全日志等。

  1.5 快来豆：您进入并使用本游戏服务所需购买、消耗的游戏道具。快来豆不可在玩家间交易，不能与游戏中的积分相兑换，仅用于进入并使用本游戏。

二、账号

  2.1 本游戏暂仅能通过微信验证登录，未来不排除将引入其他第三方账户体系用于登录本游戏。请您妥善保管您的各类账户和密码，确保账户安全。如您将账户、密码转让、出售或出借予他人使用，或授权他人使用账号，应对被授权人在该账号下发生所有行为负全部责任，快来游戏对您前述行为所造成的任何后果，不承担任何法律责任。

  2.2 如果快来游戏在今后自建账号体系，则账户的所有权归快来游戏，您在完成注册申请手续后，仅获得快来游戏账户的使用权。您应提供及时、详尽及准备的个人资料，并不断更新注册信息。因注册信息不真实而导致的问题及后果，快来游戏对此不负任何责任。因黑客行为等第三方因素或用户自身原因导致的账号安全问题，快来游戏对受影响的玩家不承担任何法律责任。

  2.3 您应当通过真实身份信息认证注册账号，且您提交的账号名称、头像和简介等注册信息中不得出现违法和不良信息，经快来游戏审核，如存在上述情况，快来游戏将不予注册；同时，在注册后，如发现您以虚假信息骗取账号名称注册，或账号头像、简介等注册信息存在违法和不良信息的，快来游戏有权不经通知单方采取限期改正、暂停使用、注销登记、回收等措施。

  2.4 您如果需要使用和享受快来游戏服务，您需要按照《网络游戏管理暂行规定》及文化部《网络游戏服务格式化协议必备条款》的要求，登录实名注册系统并进行实名注册。

  2.5 您充分理解并同意：快来游戏会按照国家相关要求将您的实名注册信息运用于防沉迷系统之中，即快来游戏可能会根据您的实名注册信息判断您是否年满18周岁，从而决定是否对您的游戏账号予以防沉迷限制。并且，若您未满18周岁，快来游戏会根据有关规定及您家长的要求对您的账户进行限制。

  2.6 如果您长期连续未登陆，您在游戏内的游戏数据可能会由于技术原因被删除，对此快来游戏不承担任何责任。

三、快来游戏服务

  3.1 快来游戏服务将向您提供本游戏作为休闲娱乐之用，快来游戏严禁一切形式的赌博和其他违法犯罪活动。请您适度游戏，快来游戏将与您共同打造绿色的休闲平台。

  3.2 在您遵守本协议及相关法律法规的前提下，快来游戏给予您一项不可转让及非排他性的许可，以使用快来游戏服务。您使用快来游戏服务仅可以非商业性目的的使用，包括：

  （1）接收、下载、安装、启动、升级、登陆、显示、运行本游戏；

  （2）创建游戏角色，设置角色名（本游戏暂不支持）；查阅游戏规则、用户个人资料、游戏对局结果，开设游戏游戏、 设置游戏参数，使用聊天功能、社交分享功能；

  （3）使用本游戏支持并允许的其他某一项或几项功能。

  3.3 您充分理解并同意：享受本游戏服务，需购买并消耗快来豆；快来豆可通过线上途径够得；快来豆使用期限为自您获得快来豆之日起至游戏终止运营（无论何种原因导致运营终止）之日止。一旦本协议终止或者本游戏终止运营，您将无法继续使用快来豆；一旦购买快来豆完成，除非快来游戏同意，您将不得撤销交易或要求将所购快来豆回兑成相应的现金或其他等价物。

  3.4 本游戏暂不支持任何虚拟货币、虚拟物品等。

  3.5 您在使用快来游戏的收费功能时，应当按照快来游戏的要求支付相应的费用。该权利属于快来游戏的经营自主权，快来游戏保留保留随时改变经营模式的权利，即保留变更收费的费率标准、收费的软件功能、收费对手及收费时间等权利。同时，也保留对快来游戏进行升级、改版、增加、删除、修改、变更其功能或者变更其游戏规则的权利。用户如果不接受该等变更的，应当立即停止使用快来游戏；用户继续使用本游戏的行为，视为用户接受改变后的经营模式。

  3.6 为保障玩家的正当利益，快来游戏对盗号及盗号相关行为（包括但不限于盗取账号、游戏数据、玩家个人资料、协助盗号者操作等）予以严厉打击和处罚。一经查证属实或应有权机关要求，快来游戏有权视具体情况立即采取封号等处罚措施，情节严重的，快来游戏保留对涉案玩家追究法律责任的权利。

  3.7 如果快来游戏发现或收到他人举报或投诉用户违反本协议约定的，经查证属实，快来游戏有权不经通知随时对相关内容进行删除，并视行为情节对违规账号处以包括但不限于警告、限制或禁止使用全部或部分功能、封号甚至终止服务的处罚。

  3.8 您充分理解并同意，因您违反本协议或相关规则的规定，导致或产生第三方主张的任何索赔、要求或损失，您应当独立承担责任；快来游戏因此遭受损失的，您也应一并赔偿。

  3.9 快来游戏可能会通过快来游戏官方网站、快来游戏客服官方网站、客服电话、快来游戏微信公众号、游戏管理员或其他途径，向用户提供诸如游戏规则说明、bug或外挂投诉、游戏账号锁定或解除锁定、游戏账号申诉、游戏账号暂时封停、游戏账号实名注册信息修改和/或查验等客户服务。

四、用户行为规范

  4.1 您充分了解并同意，您必须为自己账号下的一切行为负责，包括您所发表的任何内容以及由此产生的任何后果。您应对本游戏中的内容自行加以判断，并承担因使用本游戏而引起的所有风险，包括因对本游戏内容的正确性、完整性或实用性的依赖而产生的风险。快来游戏无法且不会对因前述风险而导致的任何损失或损害承担的责任。

  4.2 除非法律允许或快来游戏书面许可，您不得（营利或非营利性的）从事下列行为：

  （1）建立有关快来游戏的镜像站点，或者进行网页（络）快照，或者利用架设服务器等方式，为他人提供与本游戏服务完全相同或类似的服务；

  （2）对本游戏软件进行反向工程、反向汇编、反向编译或者以其他方式尝试获取软件的源代码；

  （3）通过各种方式侵入游戏服务器，干扰服务器的正常运行，接触、拷贝、篡改、增加、删除游戏数据；

  （4）使用快来游戏的名称、商标或其它知识产权；

  （5）其他未经快来游戏明示授权的行为。

  4.3 您在使用本游戏服务过程中有如下行为的，快来游戏将视情节严重程度，依据本协议及相关游戏规则的规定，对您暂时或永久性的做出禁言（关闭聊天功能）、强制离线、封号（暂停游戏账户）、终止服务等处理措施，情节严重的将移交有关机关给予行政处罚，甚至向公安机关举报、追究您的刑事责任：

  （1）假冒快来游戏工作人员或其他客户服务人员；

  （2）传播非法言论或不当信息，包括使用非法或不当词语、字符等用于角色命名；

  （3）对快来游戏工作人员或其他玩家进行辱骂、人身攻击等；不断吵闹、重复发言、不断发布广告、恶意刷屏等，以及恶意连续骚扰他人，影响他人游戏等其他行为；

  （4）以任何方式破坏本游戏或影响本游戏服务的正常进行；

  （5）利用系统的BUG、漏洞为自己及他人牟利；

  （6）利用本游戏进行赌博；

  （7）侵犯快来游戏的知识产权，或者进行其他有损于本游戏或第三方合法权益的行为；

  （8）通过各种方式侵入游戏服务器，干扰服务器的正常运行，接触、拷贝、篡改、增加、删除游戏数据；

  （9）其他在行业内被广泛认可的不当行为，无论是否已经被本协议或游戏规则明确列明

五、免责声明

  5.1 快来游戏可能因游戏软件的bug、版本更新缺陷、运营bug、第三方病毒攻击或其他任何因素导致您无法登陆账号，或导致您的游戏角色、游戏数据等账号数据发生异常。在数据异常的原因未得到查明前，快来游戏有权暂时冻结该账号；若查明数据异常为非正常游戏行为，您游戏账号数据将可能被恢复至异常发生前的原始状态，快来游戏对此免责。

  5.2 对于您从未经快来游戏官方授权合作方处购买快来豆的行为，快来游戏不承担任何责任；快来游戏不对未经授权的第三方交易的行为负责，并且不受理因任何未经授权的第三方交易发生纠纷而带来的申诉。

  5.3 由于互联网服务的特殊性，快来游戏有权根据法律法规的规定及相关主管部门的要求、第三方权利人的投诉举报、与合作方的合作情况，以及快来游戏业务发展情况，随时变更、中断或终止本服务的部分或全部内容。本游戏终止运营后，快来游戏将根据游戏后台数据，向您退还剩余快来豆或其他所购物品的费用。

六、知识产权

  6.1 快来游戏是本游戏的知识产权权利人。相关的著作权、商标权、专利权、商业秘密等知识产权、以及其他信息内容（包括文字、图片、音频、视频、图表、界面设计、版面框架、有关数据或电子文档等）均受中华人民共和国法律和相应国际条约保护，快来游戏享有上述知识产权，但相关权利人依照法律规定应享有的权利除外。

  6.2 您在使用快来游戏服务中产生的游戏数据的所有权和知识产权归快来游戏所有，快来游戏有权处理该数据。

  6.3 快来游戏可能涉及第三方知识产权，而该等第三方对您基于本协议在快来游戏中使用该等知识产权有要求的，您应当一并遵守。

七、用户信息收集、使用及保护

  7.1 您同意并授权快来游戏为履行本协议之目的收集您的用户信息，这些信息包括您在实名注册系统中注册的信息、您账号下的游戏数据以及其他您在使用本游戏服务的过程中向快来游戏提供的或快来游戏基于安全、用户体验优化等考虑而需收集的信息，快来游戏对您的用户信息的收集将遵循相关法律的规定。

  7.2 您充分理解并同意：为更好地向您提供快来游戏服务，快来游戏可以将您的用户信息提交给关联公司，且快来游戏有权自行或通过第三方对您的用户信息进行整理、统计、分析及利用。

  7.3 您充分理解并同意：快来游戏可以根据您的用户信息，通过短信、电话、邮件等各种方式向您提供关于快来游戏的活动信息、推广信息等各类信息。

  7.4 快来游戏保证不对外公开或向任何第三方提供您的个人信息，但是存在下列情形之一的除外：

  （1）公开或提供相关信息之前获得您许可的；

  （2）根据法律或政策的规定而公开或提供的

  （3）只有公开或提供您的个人信息，才能向您提供您需要的快来游戏服务的；

  （4）根据国家权力机关要求公开或提供的。

  （5）根据本协议其他条款约定而公开或提供的

八、管辖与法律适用

  8.1 本协议签订地为中华人民共和国长沙市

  8.2 本协议的成立、生效、履行、解释及纠纷解决，适用于中华人民共和国大陆地区法律。

  8.3 若您和快来游戏之间因本协议发生任何纠纷或争议，首先应友好协商解决；协商不成的，您同意将纠纷和争议提交至快来游戏住所地有管辖权的人民法院管辖。

九、协议的变更和生效

  9.1 快来游戏有权根据需要不时修订本协议条款。上述内容一经正式公布即生效。您可以在快来游戏的相关页面查阅最新版本的协议条款。

  9.2 本协议条款变更后，如果您继续使用本游戏服务，即视为您已接受变更后的协议。如果您不接受变更后的协议，应当立即停止使用本游戏服务。

  9.3 除非本协议另有其他明示规定，快来游戏推出的新产品、新功能、新服务，均受到本协议之规范。


附录：《网络游戏服务格式化协议必备条款》

1.账号注册

  1.1 乙方承若以其真实身份注册成为甲方的用户，并保证所提供的个人身份资料信息真实、完整、有效、依据法律规定和必备条款约定对所提供的信息承担相应的法律责任。

  1.2 乙方以其真实身份注册成为甲方用户后，需要修改所提供的个人身份资料信息的，甲方应当及时、有效的为其提供该项服务。

2.用户账号使用与保管

  2.1 根据必备条款的约定，甲方有权审查乙方注册所提供的身份信息是否真实、有效，并积极的采取技术与管理等合理措施保障用户账号的安全、有效；乙方有义务妥善保管其账号及密码，并正确、安全的使用其账号及密码。任何一方未尽上述义务导致账号密码遗失、账号被盗等情形而给一方和他人的民事权利造成损害的，应当承担由此产生的法律责任。

  2.2 乙方对登录后所持账号产生的行为依法享有权利和承担责任。

  2.3 乙方发现其账号和密码被他人非法使用或有使用异常的情况，应及时根据甲方公布的处理方式通知甲方，并有权通知甲方采取措施暂停该账号的登录和使用。

  2.4.1 甲方核实乙方所提供的个人有效身份信息与所注册的身份信息相一致的，应当及时采取措施暂停乙方账号的登录和使用。

  2.4.2 甲方违反2.4.1款项的约定，未及时采取措施暂停乙方账号的登录和使用，因此而给乙方造成损失的，应当承担其相应的法律责任。

  2.4.3 乙方没有提供其个人有效身份证件或者乙方提供的个人有效身份证件与所注册的身份信息不一致的，甲方有权拒绝乙方上述请求。

  2.5 乙方为了维护其合法权益，向甲方提供与所注册的身份信息相一致的个人有效身份信息时，甲方应当为乙方提供账号注册人证明、原始注册信息等必要的协议和支持，并根据需要向有关行政机关或司法机关提供相应证据信息资料。

3.服务的中止与终止

  3.1 乙方有发布违法信息、严重违背社会公德、以及其他违反法律禁止性规定的行为，甲方应当立即终止对乙方提供服务。

  3.2 乙方在接受甲方服务时实施不正当行为的，甲方有权终止对乙方提供服务。该不正当行为的具体情形应当在本协议中有明确约定或属于甲方事先明确告知的应被终止服务的禁止性行为，否则，甲方不得终止对乙方提供服务。

  3.3 乙方提供虚假注册身份信息，或实施违反本协议的行为，甲方有权中止对乙方提供全部或部分服务；甲方采取中止措施应当通知乙方并告知中止期间，中止期间是合理的，中止期间届满甲方应当及时恢复对乙方的服务。

  3.4 甲方根据本条约定中止或终止对乙方提供部分或全部服务的，甲方应负举报责任。

4.用户信息保护

  4.1 甲方要求乙方提供与其身份有关的信息资料时，应当事先以明确而易见的方式向乙方公开其隐私权保护政策和个人信息利用政策，并采取必要措施保护乙方的个人信息资料的安全

  4.2 未经乙方许可甲方不得向任何第三方提供、公布或共享乙方注册资料中的姓名、个人有效身份证号码、联系方式、家庭住址等个人身份信息，但下列情况除外：

    4.2.1 乙方或乙方监护人授权甲方披露的；

    4.2.2 有关法律要求甲方披露的；

    4.2.3 司法机关或行政机关基于法定程序要求甲方提供的

    4.2.4 甲方为了维护自己合法权益而向乙方提起诉讼和仲裁时；

    4.2.5 应乙方监护人的合法要求而提供乙方的个人身份信息时；

]]




-- 构造函数
function Strings:ctor()
end

-- 必须有这个返回
return Strings