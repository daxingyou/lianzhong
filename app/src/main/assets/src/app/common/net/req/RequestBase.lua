--
-- Author: lte
-- Date: 2016-10-13 17:13:40
--

-- 类申明
-- local RequestBase = class("RequestBase", function ()
-- 	return display.newNode();
-- end)
local RequestBase = class("RequestBase")

-- 类变量申明

local ErrorDataJson = '{"status":-1, "msg":"网络连接失败或服务器中断!"}';
local ErrorUrl = "http://test123.api.iwoapp.com";
local Fun_Back_Data; -- 通配的返回函数申明

-- 类方法申明

-- get方法
function RequestBase:HttpGet(fun_back_data, url, param, responseTestJsonTable)
	Fun_Back_Data = fun_back_data;
	
    --if CEnum.Environment.Current ~= nil and CEnum.Environment.Current == CEnum.EnvirType.Http then -- 正式环境
	    local request;
	    if url ~= nil then
			local param_string = RequestBase:joinParam(param); -- 基本参数+单个方法体的参数  排序，加密，融为一体值给后台
			if param_string ~= nil then
				-- request:setPOSTData(param_string);
				-- --request:setPOSTValue("","") -- key-value的形式
				url = url .. "?" .. param_string
                Commons:printLog_Req("==req get 请求完整地址是：", url)
			end

	    	request = network.createHTTPRequest(RequestBase_getData_CallBack, url, "GET");
		else
			request = network.createHTTPRequest(RequestBase_getData_CallBack, ErrorUrl, "GET");
	    end

	    request:start();
	--else
    --    local jsonObj = responseTestJsonTable; --ParseBase:new():parseToJsonObj(responseTestJson)
	--	--Commons:printLog_Req("状态是：",jsonObj.status, "内容是：",jsonObj.msg)
	-- if Fun_Back_Data ~= nil then
	-- 	Fun_Back_Data(jsonObj);
	-- end
	--end
end

-- local myHttp = require("luasocket.lua.socket.http")

-- post方法
function RequestBase:HttpPost(fun_back_data, url, param, responseTestJsonTable)
	Fun_Back_Data = fun_back_data;
	
    if CEnum.Environment.Current ~= nil and CEnum.Environment.Current == CEnum.EnvirType.Http then -- 正式环境
	    local request;
	    if url ~= nil then
	    	if CEnum.Environment.gotoHttpDNS and Commons:checkIsNull_str(CVarUpd._static.hostIp) then
		    	url = string.gsub(url, Https.DomainName, CVarUpd._static.hostIp) 
		    end

            --Commons:printLog_Req("==req post 请求url是：", url)
	    	request = network.createHTTPRequest(RequestBase_getData_CallBack, url, "POST");
	    	-- local myHttp = require("socket.http")
		else
			request = network.createHTTPRequest(RequestBase_getData_CallBack, ErrorUrl, "POST");
	    end

		local param_string = RequestBase:encryptBody(param); -- 基本参数+单个方法体的参数  排序，加密，融为一体值给后台
		if param_string ~= nil then
            --Commons:printLog_Req("==req post 请求param是：", param_string)
            --request:addPOSTValue("Host","wmq.api.yuelaigame.com") -- key-value的形式
			--request:setPOSTValue("","") -- key-value的形式
			request:setPOSTData(param_string);
		end
		Commons:printLog_Req("==req post 请求完整地址是：", url .. "?" .. param_string)

		if CEnum.Environment.gotoHttpDNS and Commons:checkIsNull_str(CVarUpd._static.hostIp) then
			-- request:setTimeout(30)
			-- request:addFormFile("Host", "wmq.api.yuelaigame.com")
			-- request:addFormFile("Host", "wmq.api.yuelaigame.com", "headers")
			-- request:addFormContents("Host", "wmq.api.yuelaigame.com")
			-- request:setHeaders("Host", "wmq.api.yuelaigame.com")
			-- request:addRequestHeader('Host', 'wmq.api.yuelaigame.com')
			request:addRequestHeader('Host:'..Https.DomainName)
		end

	    request:start();
	else
		local param_string = RequestBase:encryptBody(param); -- 基本参数+单个方法体的参数  排序，加密，融为一体值给后台
		Commons:printLog_Req("==test模式下 req post 请求完整地址是：", url .. "?" .. param_string)

        local jsonObj = responseTestJsonTable
		--Commons:printLog_Req("状态是：",jsonObj.status, "内容是：",jsonObj.msg)
		if Fun_Back_Data ~= nil then
			Fun_Back_Data(jsonObj)
		end
	end
end 

function RequestBase:getHttpUrl(singleUrl)
	return Https.httpUrl .. singleUrl;
end

-- 异步http结果的返回函数处理，处理完返回给具体的页面
function RequestBase_getData_CallBack(event)
	local responseDataJson = ErrorDataJson;
	local request = event.request
    --Commons:printLog_Req("==req 请求名字是：" .. event.name)
	if event.name == "completed" then
		--请求成功后
        --Commons:printLog_Req("==req 请求头是："..request:getResponseHeadersString())
		local code = request:getResponseStatusCode()
		if code ~= 200 then
			-- 请求结束，但没有返回成功响应
            Commons:printLog_Req("==response error code：" .. code)
			local jsonObj = ParseBase:new():parseToJsonObj(responseDataJson)
            --Commons:printLog_Req("状态是：",jsonObj.status, "内容是：",jsonObj.msg)
			if Fun_Back_Data ~= nil then
				Fun_Back_Data(jsonObj);
			end
			return;
		end

		-- 到这里就请求成功拉
        --Commons:printLog_Req("==response length：" .. request:getResponseDataLength())
		local responseString = request:getResponseString();
        --数据量太多打印会崩溃，这里就不能输出 
        -- Commons:printLog_Req("==response data：" .. responseString)
		if responseString ~= nil then
            local jsonObj = ParseBase:new():parseToJsonObj(responseString)
            --Commons:printLog_Req("状态是：",jsonObj.status, "内容是：",jsonObj.msg)
			if Fun_Back_Data ~= nil then
				Fun_Back_Data(jsonObj);
			end
			return;
		end

	elseif event.name == "progress" then
		-- 请求过程中
        --Commons:printLog_Req("==progress：" .. event.dltotal)
	else
		--请求失败
        Commons:printLog_Req("==req fail：" .. event.name);
        Commons:printLog_Req("==req fail code msg：", request:getErrorCode(), request:getErrorMessage());
        local jsonObj = ParseBase:new():parseToJsonObj(responseDataJson)
		--Commons:printLog_Req("状态是：",jsonObj.status, "内容是：",jsonObj.msg)
		if Fun_Back_Data ~= nil then
			Fun_Back_Data(jsonObj);
		end
		return;
	end
end

---[[
-- 获取和设置基本参数
function RequestBase:getBaseInfo()
	local _token = CVar._static.token
	local _osType = Commons.osType
	local _channelid = CEnum.AppVersion.channelid --"888888"
	local _versionCode = CEnum.AppVersion.versionCode --"100"
	local _versionName = CEnum.AppVersion.versionName --"1.0.0"
	local _gameAlias = CEnum.AppVersion.gameAlias

	local _table = {
		--pack_name = RequestBase:getStrEncode("com.hotmate.yuanquan"),
		--screen_width = RequestBase:getStrEncode("720"),
		--screen_height = RequestBase:getStrEncode("1280"),
		--brand = RequestBase:getStrEncode("Huawei"),
		--model = RequestBase:getStrEncode("H30-T00"),
		--mac = RequestBase:getStrEncode("14:b9:68:aa:2a:9a"),
		--imei = RequestBase:getStrEncode("358142036736179"),
		--ca = RequestBase:getStrEncode("460028185997223"),
		--imsi = RequestBase:getStrEncode(""),
		--network = RequestBase:getStrEncode("wifi"),
		--uid = RequestBase:getStrEncode("4601"),
		
		token = RequestBase:getStrEncode(_token),
		osType = RequestBase:getStrEncode(_osType),
		channelid = RequestBase:getStrEncode(_channelid),
		versionCode = RequestBase:getStrEncode(tostring(_versionCode)),
		versionName = RequestBase:getStrEncode(_versionName),
		gameAlias = RequestBase:getStrEncode(_gameAlias),
	}
	return _table;
end
--]]

-- get请求 所有的参数进行排序和加密
function RequestBase:joinParam(param)
	if param == nil or type(param) ~= "table" then
		param = {}
	end

	local api_sign_key = "nc2dDU3EdHHGYgsMszlyaU466weA9nVazvND75TH7go=";-- 加密密钥
	local api_params_decrypt_key = "1111111111111111";-- 加密密钥

	if param ~= nil then
		-- 将单个接口的参数加入到这个基本table中去
		local base_table = {} -- RequestBase:getBaseInfo()
		for k,v in pairs(param) do
			base_table[k] = v;
		end
		--[[
		for k,v in pairs(base_table) do
			Commons:printLog_Req("全部的参数table：",k,v)
		end
		--]]

		---[[
		-- key组装成一个table，再将这个key排序
		local keys = {}
		for i in pairs(base_table) do
		   table.insert(keys,i)   --提取base_table中的键值插入到keys表中
		end
		--for k,v in pairs(keys) do
		--	Commons:printLog_Req("新的table：",k,v)
		--end
		table.sort(keys, function(a,b) return a<b end) -- 小到大
		--]]

		--[[
		-- 新的排序之后，插入table中去
		local finish_table = {};
		for i,v in pairs(keys) do
		   Commons:printLog_Req("排序之后的table：",v,base_table[v])
		   finish_table[v] = base_table[v];
		end
		-- 组装成 &= 格式
		for i,v in pairs(finish_table) do
		   Commons:printLog_Req("排序之后的table：",i,v)
		end
		--]]
		-- 组装成 &= 格式
		local p_need = ""; -- 参数值就是要被ecode之后的
		local p_init = ""; -- 参数值有可能被encode的，这里是返回原值的记录
		local ii = 1;
		for i,v in pairs(keys) do
		   --Commons:printLog_Req("排序之后的table：",v,base_table[v])
		   if ii==1 then
		   		p_need = p_need .. v .. "=" .. base_table[v];
		   		p_init = p_init .. v .. "=" .. RequestBase:getStrDecode(base_table[v]);
		   else
		   		p_need = p_need .. "&" .. v .. "=" .. base_table[v];
		   		p_init = p_init .. "&" .. v .. "=" .. RequestBase:getStrDecode(base_table[v]);
		   end
		   ii = ii + 1;
		end
		--Commons:printLog_Req("排序之后的table字符串是：", p_init)


		--Commons:printLog_Req("暂时不签名的字符串是：", p_need)
		return p_need;

		--[[
		--todo最后需要   加密处理的
		-- 生成签名值
		Commons:printLog_Req("要签名的字符串是：", p_init .. api_sign_key)
		local sign = string.upper(crypto.md5(p_init .. api_sign_key, false) );
		Commons:printLog_Req("签名值是：",sign)

		-- 带上签名值，再次加密处理
		local param_sign = p_need .. "&sign=" .. sign;
		local f_string = RequestBase:encrypt2Base64(param_sign, api_params_decrypt_key);
		Commons:printLog_Req("加密后是：", f_string);

		return f_string;
		--]]
	end
end

-- 所有的参数进行排序和加密
function RequestBase:encryptBody(param)
	if param == nil or type(param) ~= "table" then
		param = {}
	end

	local api_sign_key = "nc2dDU3EdHHGYgsMszlyaU466weA9nVazvND75TH7go=";-- 加密密钥
	local api_params_decrypt_key = "1111111111111111";-- 加密密钥

	if param ~= nil then
		-- 将单个接口的参数加入到这个基本table中去
		local base_table = RequestBase:getBaseInfo()
		for k,v in pairs(param) do
			base_table[k] = v;
		end
		--[[
		for k,v in pairs(base_table) do
			Commons:printLog_Req("全部的参数table：",k,v)
		end
		--]]

		-- key组装成一个table，再将这个key排序
		local keys = {}
		for i in pairs(base_table) do
		   table.insert(keys,i)   --提取base_table中的键值插入到keys表中
		end
		--for k,v in pairs(keys) do
		--	Commons:printLog_Req("新的table：",k,v)
		--end
		table.sort(keys, function(a,b) return a<b end) -- 小到大

		--[[
		-- 新的排序之后，插入table中去
		local finish_table = {};
		for i,v in pairs(keys) do
		   Commons:printLog_Req("排序之后的table：",v,base_table[v])
		   finish_table[v] = base_table[v];
		end
		-- 组装成 &= 格式
		for i,v in pairs(finish_table) do
		   Commons:printLog_Req("排序之后的table：",i,v)
		end
		--]]
		-- 组装成 &= 格式
		local p_need = ""; -- 参数值就是要被ecode之后的
		local p_init = ""; -- 参数值有可能被encode的，这里是返回原值的记录
		local ii = 1;
		for i,v in pairs(keys) do
		   --Commons:printLog_Req("排序之后的table：",v,base_table[v])
		   if ii==1 then
		   		p_need = p_need .. v .. "=" .. base_table[v];
		   		p_init = p_init .. v .. "=" .. RequestBase:getStrDecode(base_table[v]);
		   else
		   		p_need = p_need .. "&" .. v .. "=" .. base_table[v];
		   		p_init = p_init .. "&" .. v .. "=" .. RequestBase:getStrDecode(base_table[v]);
		   end
		   ii = ii + 1;
		end
		--Commons:printLog_Req("排序之后的table字符串是：", p_init)


		--Commons:printLog_Req("暂时不签名的字符串是：", p_need)
		return p_need;
		--todo最后需要   加密处理的
		--[[
		-- 生成签名值
		Commons:printLog_Req("要签名的字符串是：", p_init .. api_sign_key)
		local sign = string.upper(crypto.md5(p_init .. api_sign_key, false) );
		Commons:printLog_Req("签名值是：",sign)

		-- 带上签名值，再次加密处理
		local param_sign = p_need .. "&sign=" .. sign;
		local f_string = RequestBase:encrypt2Base64(param_sign, api_params_decrypt_key);
		Commons:printLog_Req("加密后是：", f_string);

		return f_string;
		--]]
	end
end

-- 所有的参数排序后，进行加密和base64编码
function RequestBase:encrypt2Base64(prestr, bodyEncryptKey)
	--Commons:printLog_Req(prestr,bodyEncryptKey)
	-- 64编码 XXTEA加密
	local str = crypto.encryptXXTEA(prestr, bodyEncryptKey);
	-- 64编码 AES256加密
	--local str = crypto.encryptAES256(prestr, bodyEncryptKey);
	--Commons:printLog_Req(str)
	local str2 = crypto.encodeBase64(str);
	--Commons:printLog_Req(str2)
	return str2;
end


--[[
-- 参数值编码，防止中文乱码
function getStringEncode(value)	
	local _value = "";
	if value ~= nil or value ~= "" then
		_value = string.urlencode(value);
	end
	return _value;
end
--]]


---[[
-- 供外部调用的：参数值编码
function RequestBase:getStrEncode(value)	
	local _value = "";
	if value ~= nil and value ~= "nil" and value ~= "" then
		_value = string.urlencode(value);
	end
	return _value;
end
--]]


---[[
-- 供外部调用的：参数值解码
function RequestBase:getStrDecode(value)	
	local _value = "";
	if value ~= nil and value ~= "nil" and value ~= "" then
		_value = string.urldecode(value);
	end
	return _value;
end
--]]


-- 构造函数
function RequestBase:ctor()
end


function RequestBase:onEnter()
end


function RequestBase:onExit()
end

-- 必须有这个返回
return RequestBase
