--
-- Author: lte
-- Date: 2016-10-13 17:13:40
--

-- 类申明
local RequestUpdBase = class("RequestUpdBase")


-- 常量
local ErrorDataJson = '{"status":-1, "msg":"网络连接失败或服务器中断!"}';
local ErrorUrl = "http://test123.api.iwoapp.com";

-- get方法
function RequestUpdBase:HttpGet(fun_back_data, url, param, responseTestJsonTable)
	self.Fun_Back_Data = fun_back_data;
	
    --if CEnumUpd.Environment.Current ~= nil and CEnumUpd.Environment.Current == CEnumUpd.EnvirType.Http then -- 正式环境
	    local request;
	    if url ~= nil then
			local param_string = self:joinParam(param); -- 基本参数+单个方法体的参数  排序，加密，融为一体值给后台
			if param_string ~= nil then
				-- request:setPOSTData(param_string);
				-- --request:setPOSTValue("","") -- key-value的形式
				url = url .. "?" .. param_string
                CommonsUpd:printLog_Req("==req get 请求完整地址是：", url)
			end

	    	request = network.createHTTPRequest(function(event) self:getData_CallBack(event) end, url, "GET");
		else
			request = network.createHTTPRequest(function(event) self:getData_CallBack(event) end, ErrorUrl, "GET");
	    end

	    request:start();
	--else
    --    local jsonObj = responseTestJsonTable; --ParseBase:new():parseToJsonObj(responseTestJson)
	--	--CommonsUpd:printLog_Req("状态是：",jsonObj.status, "内容是：",jsonObj.msg)
	-- if Fun_Back_Data ~= nil then
	-- 	Fun_Back_Data(jsonObj);
	-- end
	--end
end

-- post方法
function RequestUpdBase:HttpPost(fun_back_data, url, param, responseTestJsonTable)
	self.Fun_Back_Data = fun_back_data;
	
    if CEnumUpd.Environment.Current ~= nil and CEnumUpd.Environment.Current == CEnumUpd.EnvirType.Http then -- 正式环境
	    local request;
	    if url ~= nil then
	    	if CEnumUpd.Environment.gotoHttpDNS and CommonsUpd:checkIsNull_str(CVarUpd._static.hostIp) then
		    	url = string.gsub(url, HttpsUpd.DomainName, CVarUpd._static.hostIp) 
		    end

            --CommonsUpd:printLog_Req("==req post 请求url是：", url)
	    	request = network.createHTTPRequest(function(event) self:getData_CallBack(event) end, url, "POST");
		else
			request = network.createHTTPRequest(function(event) self:getData_CallBack(event) end, ErrorUrl, "POST");
	    end

		local param_string = self:encryptBody(param); -- 基本参数+单个方法体的参数  排序，加密，融为一体值给后台
		if param_string ~= nil then
            --CommonsUpd:printLog_Req("==req post 请求param是：", param_string)
            --request:addPOSTValue("Host","wmq.api.yuelaigame.com") -- key-value的形式
			--request:setPOSTValue("","") -- key-value的形式
			request:setPOSTData(param_string);
		end
		CommonsUpd:printLog_Req("==req post 请求完整地址是：", url .. "?" .. param_string)

		if CEnumUpd.Environment.gotoHttpDNS and CommonsUpd:checkIsNull_str(CVarUpd._static.hostIp) then
			request:addRequestHeader('Host:'..HttpsUpd.DomainName)
		end

	    request:start();
	else
        local jsonObj = responseTestJsonTable; --ParseBase:new():parseToJsonObj(responseTestJson)
		--CommonsUpd:printLog_Req("状态是：",jsonObj.status, "内容是：",jsonObj.msg)
		if self.Fun_Back_Data ~= nil then
			self.Fun_Back_Data(jsonObj);
		end
	end
end 

-- url获取
function RequestUpdBase:getHttpUrl(singleUrl)
	return HttpsUpd.httpUrl .. singleUrl;
end

-- 异步http结果的返回函数处理，处理完返回给具体的页面
function RequestUpdBase:getData_CallBack(event)
	local responseDataJson = ErrorDataJson;
	local request = event.request
    --CommonsUpd:printLog_Req("==req 请求名字是：" .. event.name)

	if event.name == "completed" then
		--请求成功后
        --CommonsUpd:printLog_Req("==req 请求头是："..request:getResponseHeadersString())
		local code = request:getResponseStatusCode()
		if code ~= 200 then
			-- 请求结束，但没有返回成功响应
            CommonsUpd:printLog_Req("==response error code：" .. code)
			local jsonObj = ParseUpdBase:parseToJsonObj(responseDataJson)
            --CommonsUpd:printLog_Req("状态是：",jsonObj.status, "内容是：",jsonObj.msg)
			if self.Fun_Back_Data ~= nil then
				self.Fun_Back_Data(jsonObj);
			end
			return;
		end

		-- 到这里就请求成功拉
        --CommonsUpd:printLog_Req("==response length：" .. request:getResponseDataLength())
		local responseString = request:getResponseString();
        --数据量太多打印会崩溃，这里就不能输出 
        -- CommonsUpd:printLog_Req("==response data：" .. responseString)
		if responseString ~= nil then
            local jsonObj = ParseUpdBase:parseToJsonObj(responseString)
            --CommonsUpd:printLog_Req("状态是：",jsonObj.status, "内容是：",jsonObj.msg)
			if self.Fun_Back_Data ~= nil then
				self.Fun_Back_Data(jsonObj);
			end
			return;
		end

	elseif event.name == "progress" then
		-- 请求过程中
        --CommonsUpd:printLog_Req("==progress：" .. event.dltotal)
	else
		--请求失败
        CommonsUpd:printLog_Req("==req fail：" .. event.name);
        CommonsUpd:printLog_Req("==req fail code msg：", request:getErrorCode(), request:getErrorMessage());
        local jsonObj = ParseUpdBase:parseToJsonObj(responseDataJson)
		--CommonsUpd:printLog_Req("状态是：",jsonObj.status, "内容是：",jsonObj.msg)
		if self.Fun_Back_Data ~= nil then
			self.Fun_Back_Data(jsonObj);
		end
		return;
	end
end

---[[
-- 获取和设置基本参数
function RequestUpdBase:getBaseInfo()
	-- local _token = CVarUpd._static.token
	local _osType = CommonsUpd.osType
	local _channelid = CEnumUpd.AppVersion.channelid --"888888"
	local _versionCode = CEnumUpd.AppVersion.versionCode --"100"
	local _versionName = CEnumUpd.AppVersion.versionName --"1.0.0"
	local _gameAlias = CEnumUpd.AppVersion.gameAlias

	local _table = {		
		token = self:getStrEncode(_token),
		osType = self:getStrEncode(_osType),
		channelid = self:getStrEncode(_channelid),
		versionCode = self:getStrEncode(tostring(_versionCode)),
		versionName = self:getStrEncode(_versionName),
		gameAlias = self:getStrEncode(_gameAlias),
	}
	return _table;
end
--]]

-- get请求 所有的参数进行排序和加密
function RequestUpdBase:joinParam(param)
	if param == nil or type(param) ~= "table" then
		param = {}
	end

	local api_sign_key = "nc2dDU3EdHHGYgsMszlyaU466weA9nVazvND75TH7go=";-- 加密密钥
	local api_params_decrypt_key = "1111111111111111";-- 加密密钥

	if param ~= nil then
		-- 将单个接口的参数加入到这个基本table中去
		local base_table = {} -- self:getBaseInfo()
		for k,v in pairs(param) do
			base_table[k] = v;
		end
		--[[
		for k,v in pairs(base_table) do
			CommonsUpd:printLog_Req("全部的参数table：",k,v)
		end
		--]]

		---[[
		-- key组装成一个table，再将这个key排序
		local keys = {}
		for i in pairs(base_table) do
		   table.insert(keys,i)   --提取base_table中的键值插入到keys表中
		end
		--for k,v in pairs(keys) do
		--	CommonsUpd:printLog_Req("新的table：",k,v)
		--end
		table.sort(keys, function(a,b) return a<b end) -- 小到大
		--]]

		--[[
		-- 新的排序之后，插入table中去
		local finish_table = {};
		for i,v in pairs(keys) do
		   CommonsUpd:printLog_Req("排序之后的table：",v,base_table[v])
		   finish_table[v] = base_table[v];
		end
		-- 组装成 &= 格式
		for i,v in pairs(finish_table) do
		   CommonsUpd:printLog_Req("排序之后的table：",i,v)
		end
		--]]
		-- 组装成 &= 格式
		local p_need = ""; -- 参数值就是要被ecode之后的
		local p_init = ""; -- 参数值有可能被encode的，这里是返回原值的记录
		local ii = 1;
		for i,v in pairs(keys) do
		   --CommonsUpd:printLog_Req("排序之后的table：",v,base_table[v])
		   if ii==1 then
		   		p_need = p_need .. v .. "=" .. base_table[v];
		   		p_init = p_init .. v .. "=" .. self:getStrDecode(base_table[v]);
		   else
		   		p_need = p_need .. "&" .. v .. "=" .. base_table[v];
		   		p_init = p_init .. "&" .. v .. "=" .. self:getStrDecode(base_table[v]);
		   end
		   ii = ii + 1;
		end
		--CommonsUpd:printLog_Req("排序之后的table字符串是：", p_init)


		--CommonsUpd:printLog_Req("暂时不签名的字符串是：", p_need)
		return p_need;

		--[[
		--todo最后需要   加密处理的
		-- 生成签名值
		CommonsUpd:printLog_Req("要签名的字符串是：", p_init .. api_sign_key)
		local sign = string.upper(crypto.md5(p_init .. api_sign_key, false) );
		CommonsUpd:printLog_Req("签名值是：",sign)

		-- 带上签名值，再次加密处理
		local param_sign = p_need .. "&sign=" .. sign;
		local f_string = self:encrypt2Base64(param_sign, api_params_decrypt_key);
		CommonsUpd:printLog_Req("加密后是：", f_string);

		return f_string;
		--]]
	end
end

-- 所有的参数进行排序和加密
function RequestUpdBase:encryptBody(param)
	if param == nil or type(param) ~= "table" then
		param = {}
	end

	local api_sign_key = "nc2dDU3EdHHGYgsMszlyaU466weA9nVazvND75TH7go=";-- 加密密钥
	local api_params_decrypt_key = "1111111111111111";-- 加密密钥

	if param ~= nil then
		-- 将单个接口的参数加入到这个基本table中去
		local base_table = self:getBaseInfo()
		for k,v in pairs(param) do
			base_table[k] = v;
		end
		--[[
		for k,v in pairs(base_table) do
			CommonsUpd:printLog_Req("全部的参数table：",k,v)
		end
		--]]

		-- key组装成一个table，再将这个key排序
		local keys = {}
		for i in pairs(base_table) do
		   table.insert(keys,i)   --提取base_table中的键值插入到keys表中
		end
		--for k,v in pairs(keys) do
		--	CommonsUpd:printLog_Req("新的table：",k,v)
		--end
		table.sort(keys, function(a,b) return a<b end) -- 小到大

		--[[
		-- 新的排序之后，插入table中去
		local finish_table = {};
		for i,v in pairs(keys) do
		   CommonsUpd:printLog_Req("排序之后的table：",v,base_table[v])
		   finish_table[v] = base_table[v];
		end
		-- 组装成 &= 格式
		for i,v in pairs(finish_table) do
		   CommonsUpd:printLog_Req("排序之后的table：",i,v)
		end
		--]]
		-- 组装成 &= 格式
		local p_need = ""; -- 参数值就是要被ecode之后的
		local p_init = ""; -- 参数值有可能被encode的，这里是返回原值的记录
		local ii = 1;
		for i,v in pairs(keys) do
		   --CommonsUpd:printLog_Req("排序之后的table：",v,base_table[v])
		   if ii==1 then
		   		p_need = p_need .. v .. "=" .. base_table[v];
		   		p_init = p_init .. v .. "=" .. self:getStrDecode(base_table[v]);
		   else
		   		p_need = p_need .. "&" .. v .. "=" .. base_table[v];
		   		p_init = p_init .. "&" .. v .. "=" .. self:getStrDecode(base_table[v]);
		   end
		   ii = ii + 1;
		end
		--CommonsUpd:printLog_Req("排序之后的table字符串是：", p_init)


		--CommonsUpd:printLog_Req("暂时不签名的字符串是：", p_need)
		return p_need;
		--todo最后需要   加密处理的
		--[[
		-- 生成签名值
		CommonsUpd:printLog_Req("要签名的字符串是：", p_init .. api_sign_key)
		local sign = string.upper(crypto.md5(p_init .. api_sign_key, false) );
		CommonsUpd:printLog_Req("签名值是：",sign)

		-- 带上签名值，再次加密处理
		local param_sign = p_need .. "&sign=" .. sign;
		local f_string = self:encrypt2Base64(param_sign, api_params_decrypt_key);
		CommonsUpd:printLog_Req("加密后是：", f_string);

		return f_string;
		--]]
	end
end

-- 所有的参数排序后，进行加密和base64编码
function RequestUpdBase:encrypt2Base64(prestr, bodyEncryptKey)
	--CommonsUpd:printLog_Req(prestr,bodyEncryptKey)
	-- 64编码 XXTEA加密
	local str = crypto.encryptXXTEA(prestr, bodyEncryptKey);
	-- 64编码 AES256加密
	--local str = crypto.encryptAES256(prestr, bodyEncryptKey);
	--CommonsUpd:printLog_Req(str)
	local str2 = crypto.encodeBase64(str);
	--CommonsUpd:printLog_Req(str2)
	return str2;
end


---[[
-- 供外部调用的：参数值编码
function RequestUpdBase:getStrEncode(value)	
	local _value = "";
	if value ~= nil and value ~= "nil" and value ~= "" then
		_value = string.urlencode(value);
	end
	return _value;
end
--]]


---[[
-- 供外部调用的：参数值解码
function RequestUpdBase:getStrDecode(value)	
	local _value = "";
	if value ~= nil and value ~= "nil" and value ~= "" then
		_value = string.urldecode(value);
	end
	return _value;
end
--]]


-- 构造函数
function RequestUpdBase:ctor()
end


function RequestUpdBase:onEnter()
end


function RequestUpdBase:onExit()
end

-- 必须有这个返回
return RequestUpdBase
