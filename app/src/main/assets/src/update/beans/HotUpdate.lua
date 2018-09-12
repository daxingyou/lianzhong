--
-- Author: lte
-- Date: 2016-10-17 17:24:38
-- 回合信息

local HotUpdate = class("HotUpdate")


HotUpdate.Bean = {
	hotUpdateDataTxtUrl = "hotUpdateDataTxtUrl", -- 热更新的配置文件下载地址

	version = "version", -- 本次版本，版本号
	updateUrl = 'updateUrl',-- 本次版本，所有文件的下载地址

	assets = 'assets',-- 本次版本，具体的资源文件是哪些

		name = "name",-- 资源文件  名称
		path = 'path',-- 资源文件  本地相对路径
		size = 'size', -- 大小说明，供进度条显示
		downUrl = 'downUrl', -- 单个文件的地址
		
		action = 'action', -- 动作，load replace remove几个操作，但实际中，主要识别load，加载zip中的lua文件为主
		isIOS = 'isIOS', -- 是不是ios特有的，比如64位的zip lua代码
		md5 = "md5",-- 资源文件  加密值，用于判断文件是否合法

	isDownFinish = 'isDownFinish', -- 是否下载完成
}


-- 构造函数
function HotUpdate:ctor()
end


-- 必须有这个返回
return HotUpdate
