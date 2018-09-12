--
-- Author: lte
-- Date: 2016-11-08 19:29:08
-- 声音 音效处理文件

-- 类申明
-- local VoiceDealUtil = class("VoiceDealUtil", function ()
--     return display.newNode();
-- end)
local VoiceDealUtil = class("VoiceDealUtil")

function VoiceDealUtil:isOnMusicSwitch()
	local currStopMusic = GameState_VoiceSetting:getDataSingle(CEnum.voiceSetting.currStopMusic)
    --Commons:printLog_Info("=======================背景音乐：",currStopMusic)
    if currStopMusic~=nil and currStopMusic==CEnum.musicStatus.on then
        return true
    elseif currStopMusic==nil then
        return true	
    else 
    	return false
    end
end

function VoiceDealUtil:isOnSoundSwitch()
	local currStopSound = GameState_VoiceSetting:getDataSingle(CEnum.voiceSetting.currStopSounds)
    --Commons:printLog_Info("=======================音效：",currStopSound)
    if currStopSound~=nil and currStopSound==CEnum.musicStatus.on then
        return true
    elseif currStopSound==nil then
        return true
    else 
    	return false
    end

    return true
end


-- 预加载
function VoiceDealUtil:preloadBgMusic()
	audio.preloadMusic(Voices.file.bg)
end

-- 播放背景音乐
function VoiceDealUtil:playBgMusic()
	if VoiceDealUtil:isOnMusicSwitch() then
		audio.playMusic(Voices.file.bg, true)
	else
		-- audio.playMusic(Voices.file.bg, true)
		-- VoiceDealUtil:pauseBgMusic()
		-- --VoiceDealUtil:stopBgMusic()
	end
end

-- 停止背景音乐
function VoiceDealUtil:stopBgMusic()
	audio.stopMusic(true) -- 停止背景音乐，并且释放缓存的
end

-- 继续背景音乐
function VoiceDealUtil:resumeBgMusic()
	if VoiceDealUtil:isOnMusicSwitch() then
		audio.resumeMusic()
	end
end

-- 暂停背景音乐
function VoiceDealUtil:pauseBgMusic()
	audio.pauseMusic()
end

-- 播放跑得快背景音乐
function VoiceDealUtil:playPDKBgMusic()
	if VoiceDealUtil:isOnMusicSwitch() then
		audio.playMusic(PDKVoices.file.bg, true)
	end
end

-- 播放麻将背景音乐
function VoiceDealUtil:playMJBgMusic()
	if VoiceDealUtil:isOnMusicSwitch() then
		audio.playMusic(VoicesM.file.bg, true)
	end
end


-- -- 预加载
-- function VoiceDealUtil:preloadAllSound()
-- 	audio.preloadSound(Voices.file.ww_n_s1)
-- 	audio.preloadSound(Voices.file.ww_n_s2)
-- 	audio.preloadSound(Voices.file.ww_n_s3)
-- 	audio.preloadSound(Voices.file.ww_n_s4)
-- 	audio.preloadSound(Voices.file.ww_n_s5)
-- 	audio.preloadSound(Voices.file.ww_n_s6)
-- 	audio.preloadSound(Voices.file.ww_n_s7)
-- 	audio.preloadSound(Voices.file.ww_n_s8)
-- 	audio.preloadSound(Voices.file.ww_n_s9)
-- 	audio.preloadSound(Voices.file.ww_n_s10)

-- 	audio.preloadSound(Voices.file.ww_n_b1)
-- 	audio.preloadSound(Voices.file.ww_n_b2)
-- 	audio.preloadSound(Voices.file.ww_n_b3)
-- 	audio.preloadSound(Voices.file.ww_n_b4)
-- 	audio.preloadSound(Voices.file.ww_n_b5)
-- 	audio.preloadSound(Voices.file.ww_n_b6)
-- 	audio.preloadSound(Voices.file.ww_n_b7)
-- 	audio.preloadSound(Voices.file.ww_n_b8)
-- 	audio.preloadSound(Voices.file.ww_n_b9)
-- 	audio.preloadSound(Voices.file.ww_n_b10)

-- 	audio.preloadSound(Voices.file.ww_n_chi)
-- 	audio.preloadSound(Voices.file.ww_n_xiahuo)
-- 	audio.preloadSound(Voices.file.ww_n_peng)
-- 	audio.preloadSound(Voices.file.ww_n_wei)
-- 	audio.preloadSound(Voices.file.ww_n_chouwei)
-- 	audio.preloadSound(Voices.file.ww_n_ti)
-- 	audio.preloadSound(Voices.file.ww_n_pao)
-- 	audio.preloadSound(Voices.file.ww_n_hu)

-- 	audio.preloadSound(Voices.file.ww_n_ss)
-- 	audio.preloadSound(Voices.file.ww_n_w)
-- 	audio.preloadSound(Voices.file.ww_n_wc)
-- 	audio.preloadSound(Voices.file.ww_n_wd)
-- end

-- 播放音效 一次
function VoiceDealUtil:playSound(txt)
	Commons:printLog_Info("--------音效是：",txt)
	local fileName
	if txt~=nil then
		if txt == CEnum.playOptions.pao8 then
	        txt = CEnum.playOptions.pao
	    elseif txt == CEnum.playOptions.ti8 then
	        txt = CEnum.playOptions.ti
	    elseif txt == CEnum.playOptions.twd then
	        txt = CEnum.playOptions.wd
	    elseif txt == CEnum.playOptions.twc then
	        txt = CEnum.playOptions.wc
	    end

		fileName = Voices.file.ax_n .. txt .. Voices.file.ww_suff
		local language = GameState_VoiceSetting:getDataSingle(CEnum.voiceSetting.language)
		if language ~= nil and CEnum.language.ww == language then
			-- 默认是安乡话
			fileName = Voices.file.ww_n .. txt .. Voices.file.ww_suff
		end

		if VoiceDealUtil:isOnSoundSwitch() then
			--return audio.playSound(fileName, false)

			local function VoiceDealUtil_SoundPlay_CallbackLua(txt)
                --print("-----------播放完成了")
            end
            if Commons.osType == CEnum.osType.I then
                local _Class = CEnum.SoundPlay_ios._Class
                local _Name = CEnum.SoundPlay_ios._Name
                local _args = { filePath=fileName, listener=VoiceDealUtil_SoundPlay_CallbackLua}
                --local ok, ret = 
                luaoc.callStaticMethod(_Class, _Name, _args) --没有返回默认nil
                return nil
            elseif Commons.osType == CEnum.osType.A then
            	local _Class = CEnum.SoundPlay._Class
                local _Name = CEnum.SoundPlay._Name
                local _args = { fileName, VoiceDealUtil_SoundPlay_CallbackLua}
                local _sig = "(Ljava/lang/String;I)V" --传入string参数，无返回值
                --local ok, ret = 
                luaj.callStaticMethod(_Class, _Name, _args, _sig) --没有返回默认nil
                return nil
            else
            	return audio.playSound(fileName, false)
            end

		else
			return nil
		end
	else
		return nil
	end
end

-- 播放音效 一次
-- 区分男生和女生
function VoiceDealUtil:playSound_sex(txt,sex)
	local fileName
	if txt~=nil then
		fileName = Voices.file.ax_n .. txt .. Voices.file.ww_suff
		local language = GameState_VoiceSetting:getDataSingle(CEnum.voiceSetting.language)
		if language ~= nil and CEnum.language.ww == language then
			-- 默认是安乡话
			fileName = Voices.file.ww_n .. txt .. Voices.file.ww_suff
		end

		if sex~=nil and CEnum.sex.female==sex then
			fileName = Voices.file.ax_v .. txt .. Voices.file.ww_suff
			local language = GameState_VoiceSetting:getDataSingle(CEnum.voiceSetting.language)
			if language ~= nil and CEnum.language.ww == language then
				-- 默认是安乡话
				fileName = Voices.file.ww_v .. txt .. Voices.file.ww_suff
			end
		end

		if VoiceDealUtil:isOnSoundSwitch() then
			--return audio.playSound(fileName, false)

			local function VoiceDealUtil_SoundPlay_CallbackLua(txt)
                --print("-----------播放完成了")
            end
            if Commons.osType == CEnum.osType.I then
                local _Class = CEnum.SoundPlay_ios._Class
                local _Name = CEnum.SoundPlay_ios._Name
                local _args = { filePath=fileName, listener=VoiceDealUtil_SoundPlay_CallbackLua}
                --local ok, ret = 
                luaoc.callStaticMethod(_Class, _Name, _args) --没有返回默认nil
                return nil
            elseif Commons.osType == CEnum.osType.A then
            	local _Class = CEnum.SoundPlay._Class
                local _Name = CEnum.SoundPlay._Name
                local _args = { fileName, VoiceDealUtil_SoundPlay_CallbackLua}
                local _sig = "(Ljava/lang/String;I)V" --传入string参数，无返回值
                --local ok, ret = 
                luaj.callStaticMethod(_Class, _Name, _args, _sig) --没有返回默认nil
                return nil
            else
            	return audio.playSound(fileName, false)
            end
            
		else
			return nil
		end
	else
		return nil
	end
end

-- 播放音效 循环
function VoiceDealUtil:playSound_Loop(txt)
	--Commons:printLog_Info("=================",txt)
	local fileName
	if txt~=nil then
		fileName = Voices.file.ax_n .. txt .. Voices.file.ww_suff
		--Commons:printLog_Info("=================",fileName)
		local language = GameState_VoiceSetting:getDataSingle(CEnum.voiceSetting.language)
		if language ~= nil and CEnum.language.ww == language then
			-- 默认是安乡话
			fileName = Voices.file.ww_n .. txt .. Voices.file.ww_suff
		end

		if VoiceDealUtil:isOnSoundSwitch() then
			return audio.playSound(fileName, true)
		else
			return nil
		end
	else
		return nil
	end
end

-- 播放音效 循环
-- 区分男生和女生
function VoiceDealUtil:playSound_Loop_sex(txt,sex)
	local fileName
	if txt~=nil then
		fileName = Voices.file.ax_n .. txt .. Voices.file.ww_suff
		local language = GameState_VoiceSetting:getDataSingle(CEnum.voiceSetting.language)
		if language ~= nil and CEnum.language.ww == language then
			-- 默认是安乡话
			fileName = Voices.file.ww_n .. txt .. Voices.file.ww_suff
		end

		if sex~=nil and CEnum.sex.female==sex then
			fileName = Voices.file.ax_v .. txt .. Voices.file.ww_suff
			local language = GameState_VoiceSetting:getDataSingle(CEnum.voiceSetting.language)
			if language ~= nil and CEnum.language.ww == language then
				-- 默认是安乡话
				fileName = Voices.file.ww_v .. txt .. Voices.file.ww_suff
			end
		end

		if VoiceDealUtil:isOnSoundSwitch() then
			return audio.playSound(fileName, true)
		else
			return nil
		end
	else
		return nil
	end
end

-- 播放  全路径地址的声音文件
function VoiceDealUtil:playSound_other(fileUrl)
	Commons:printLog_Info("--------other音效是：",fileUrl)
	if fileUrl~=nil then
		local language = GameState_VoiceSetting:getDataSingle(CEnum.voiceSetting.language)
		if language ~= nil and CEnum.language.ww == language then
			if fileUrl == Voices.file.over_huang then
				-- 默认是安乡话
				fileUrl = Voices.file.over_huang_ww
			end
		end

		if VoiceDealUtil:isOnSoundSwitch() then
			--return audio.playSound(fileUrl, false)

			local function VoiceDealUtil_SoundPlay_CallbackLua(txt)
                --print("-----------播放完成了")
            end
            if Commons.osType == CEnum.osType.I then
                local _Class = CEnum.SoundPlay_ios._Class
                local _Name = CEnum.SoundPlay_ios._Name
                local _args = { filePath=fileUrl, listener=VoiceDealUtil_SoundPlay_CallbackLua}
                --local ok, ret = 
                	luaoc.callStaticMethod(_Class, _Name, _args) --没有返回默认nil
                return nil
            elseif Commons.osType == CEnum.osType.A then
            	local _Class = CEnum.SoundPlay._Class
                local _Name = CEnum.SoundPlay._Name
                local _args = { fileUrl, VoiceDealUtil_SoundPlay_CallbackLua}
                local _sig = "(Ljava/lang/String;I)V" --传入string参数，无返回值
                --local ok, ret = 
                	luaj.callStaticMethod(_Class, _Name, _args, _sig) --没有返回默认nil
                return nil
            else
            	return audio.playSound(fileUrl, false)
            end
		else
			return nil
		end
	else
		return nil
	end
end

-- 麻将的特殊播放  全路径地址的声音文件
-- 主要是有同一个牌，确会播放另外一个声音
function VoiceDealUtil:playSound_forMJ(fileUrl)
	Commons:printLog_Info("--------麻将是：",fileUrl)
	if fileUrl~=nil then

		-- local language = GameState_VoiceSetting:getDataSingle(CEnum.voiceSetting.language)
		-- if language ~= nil and CEnum.language.ww == language then
		-- 	if fileUrl == Voices.file.over_huang then
		-- 		-- 默认是安乡话
		-- 		fileUrl = Voices.file.over_huang_ww
		-- 	end
		-- end

		math.randomseed(tostring(os.time()):reverse():sub(1, 6)) --设置时间种子，下面随机才有用
		local tempRandom = math.random(1,100)
		if tempRandom>70 then -- 随机变成另外一个读法
			if fileUrl == VoicesM.file.card_1 then
				fileUrl = VoicesM.file.card_1_1
			elseif fileUrl == VoicesM.file.card_11 then
				fileUrl = VoicesM.file.card_11_1
			elseif fileUrl == VoicesM.file.card_11 then
				fileUrl = VoicesM.file.card_11_1

			-- elseif fileUrl == VoicesM.file.gang then
			-- 	fileUrl = VoicesM.file.gang_1
			elseif fileUrl == VoicesM.file.peng then
				fileUrl = VoicesM.file.peng_1

			-- elseif fileUrl == VoicesM.file.hu_zimo then
			-- 	fileUrl = VoicesM.file.hu_zimo_1
			end
		end

		if VoiceDealUtil:isOnSoundSwitch() then
			--return audio.playSound(fileUrl, false)

			local function VoiceDealUtil_SoundPlay_CallbackLua(txt)
                --print("-----------播放完成了")
            end
            if Commons.osType == CEnum.osType.I then
                local _Class = CEnum.SoundPlay_ios._Class
                local _Name = CEnum.SoundPlay_ios._Name
                local _args = { filePath=fileUrl, listener=VoiceDealUtil_SoundPlay_CallbackLua}
                --local ok, ret = 
                	luaoc.callStaticMethod(_Class, _Name, _args) --没有返回默认nil
                return nil
            elseif Commons.osType == CEnum.osType.A then
            	local _Class = CEnum.SoundPlay._Class
                local _Name = CEnum.SoundPlay._Name
                local _args = { fileUrl, VoiceDealUtil_SoundPlay_CallbackLua}
                local _sig = "(Ljava/lang/String;I)V" --传入string参数，无返回值
                --local ok, ret = 
                	luaj.callStaticMethod(_Class, _Name, _args, _sig) --没有返回默认nil
                return nil
            else
            	return audio.playSound(fileUrl, false)
            end
		else
			return nil
		end
	else
		return nil
	end
end

-- 短语播放  全路径地址的声音文件
function VoiceDealUtil:playSound_forWords(fileUrl)
	Commons:printLog_Info("--------短语是：",fileUrl)
	if fileUrl~=nil then
		-- local language = GameState_VoiceSetting:getDataSingle(CEnum.voiceSetting.language)
		-- if language ~= nil and CEnum.language.ww == language then
		-- 	if fileUrl == Voices.file.over_huang then
		-- 		-- 默认是安乡话
		-- 		fileUrl = Voices.file.over_huang_ww
		-- 	end
		-- end

		if VoiceDealUtil:isOnSoundSwitch() then
			--return audio.playSound(fileUrl, false)

			local function VoiceDealUtil_SoundPlay_CallbackLua(txt)
                --print("-----------播放完成了")
            end
            if Commons.osType == CEnum.osType.I then
                local _Class = CEnum.WordsPlay_ios._Class
                local _Name = CEnum.WordsPlay_ios._Name
                local _args = { filePath=fileUrl, listener=VoiceDealUtil_SoundPlay_CallbackLua}
                --local ok, ret = 
                	luaoc.callStaticMethod(_Class, _Name, _args) --没有返回默认nil
                return nil
            elseif Commons.osType == CEnum.osType.A then
            	local _Class = CEnum.WordsPlay._Class
                local _Name = CEnum.WordsPlay._Name
                local _args = { fileUrl, VoiceDealUtil_SoundPlay_CallbackLua}
                local _sig = "(Ljava/lang/String;I)V" --传入string参数，无返回值
                --local ok, ret = 
                	luaj.callStaticMethod(_Class, _Name, _args, _sig) --没有返回默认nil
                return nil
            else
            	return audio.playSound(fileUrl, false)
            end
		else
			return nil
		end
	else
		return nil
	end
end

-- 停止音效 一次
function VoiceDealUtil:stopSound(hander)
	audio.stopSound(hander)
end

-- 继续音效
function VoiceDealUtil:resumeSound()
	if VoiceDealUtil:isOnSoundSwitch() then
		audio.resumeAllSounds()
	end
end

-- 暂停音效
function VoiceDealUtil:pauseSound()
	audio.pauseAllSounds()
end

-- 构造函数
function VoiceDealUtil:ctor()
end

-- 必须有这个返回
return VoiceDealUtil

