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
Https.httpUrl = "http://118.24.183.77:8080/qp-api-impl/";  -- 测试地址
--Https.httpUrl = "http://192.168.31.101:8084/wmq-api-impl/";  -- 测试地址
-- Https.httpUrl = "http://wmq.api.test.yuelaigame.com/";  -- 临时测试 域名地址
--Https.httpUrl = "http://wmq.api.yuelaigame.com/";  -- 域名地址  106.14.46.145
Https.DomainName = "wmq.api.yuelaigame.com" -- 纯粹的域名记录

Https.url = {

	getUpdateApp = 'client/version/upgrade.json', -- 检查更新
	getHotUpdate = '', -- 热更新地址
}

-- 构造函数
function Https:ctor()
end

-- 必须有这个返回
return Https