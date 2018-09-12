--
-- Author: lte
-- Date: 2016-11-02 19:40:54
-- 游戏中 需要的单独处理方法


-- 类申明
-- local GameingDealUtil = class("GameingDealUtil", function ()
--     return display.newNode();
-- end)
local GameingDealUtil = class("GameingDealUtil")


-- 牌  图片显示
function GameingDealUtil:getImgByHandcard(_type, cardTxt)
    if cardTxt ~= nil then
      --Commons:printLog_Info("==11111111111111111111==================",cardTxt)

      local qian_abc = nil
      -- local second_abc = nil
      local cardTxt_abc = nil
      if Commons:checkIsNull_str(cardTxt) and cardTxt ~= CEnum.status.def_fill then
        local _size = string.len(cardTxt)
        if _size >= 2 then
            -- qian_abc = string.sub(cardTxt, 1, 1) -- 从第1位开始算 1位  1到1
            -- -- second_abc = string.sub(cardTxt, 2, 2)  -- 从第2位开始算 1位  2到2
            -- cardTxt_abc = string.sub(cardTxt, 3, _size) -- 从第3位开始算（包含第3位） 3到最后

            cardTxt = string.sub(cardTxt, 2, _size) -- 从第2位开始算（包含第2位） 2到最后
        end
      end
      --Commons:printLog_Info("==2222222222222222222222==================",cardTxt)

      if cardTxt ~= CEnum.status.def_fill and _type==CEnum.userCard.hand then
        -- 手上的牌
        -- if qian_abc~=nil and CEnum.cardType.a == qian_abc then
          return Imgs.card_hand .. cardTxt .. Imgs.file_img_suff
        -- else
        --   return Imgs.card_hand_y .. cardTxt_abc .. Imgs.file_img_suff
        -- end

      elseif cardTxt ~= CEnum.status.def_fill and (_type==CEnum.userCard.mid_mo or _type==CEnum.userCard.mid_chu) then
        -- 摸到的牌
        -- 打出的牌
        return Imgs.card_mid .. cardTxt .. Imgs.file_img_suff

      elseif cardTxt ~= CEnum.status.def_fill and (_type==CEnum.userCard.out or _type==CEnum.userCard.peng) then
        -- 打出去的牌，没有人接住的牌
        -- 自己碰，吃，偎到的牌
        -- print("----------------------second_abc:::", second_abc)
        -- if second_abc~=nil and CEnum.cardType.f == second_abc then -- 盖住的牌
            return Imgs.card_out .. cardTxt .. Imgs.file_img_suff
        -- else
        --   if second_abc~=nil and CEnum.cardType.y == second_abc then -- 阴影牌 手牌有
        --       return Imgs.card_hand_y .. cardTxt_abc .. Imgs.file_img_suff
        --   else -- 普通牌 手牌有
        --       return Imgs.card_hand .. cardTxt .. Imgs.file_img_suff
        --   end
        -- end

      else
        -- 没有牌
        --return Imgs.c_check_yes -- 预看效果图片
        return Imgs.c_transparent -- 透明图片
      end
    else
      return Imgs.c_transparent -- 透明图片
    end
end


  -- 每位玩家 出牌的时候的操作  黄色大字提示出来  图片显示
function GameingDealUtil:getImgByOptionOut(cardTxt)
    if cardTxt ~= nil and cardTxt ~= CEnum.status.def_fill then
      
      if cardTxt == CEnum.playOptions.pao8 then
        cardTxt = CEnum.playOptions.pao
      elseif cardTxt == CEnum.playOptions.ti8 then
        cardTxt = CEnum.playOptions.ti
      elseif cardTxt == CEnum.playOptions.twd then
        cardTxt = CEnum.playOptions.wd
      elseif cardTxt == CEnum.playOptions.twc then
        cardTxt = CEnum.playOptions.wc
      end

      return Imgs.gameing_out_options .. cardTxt .. Imgs.file_img_suff

    else
      -- 没有牌
      --return Imgs.c_check_yes -- 预看效果图片
      return Imgs.c_transparent -- 透明图片
    end
end

 -- 本人的出牌选择操作  吃 碰 胡 过  王钓 王闯 动作按钮 图片显示
function GameingDealUtil:getImgByOptionMid(optTxt)
    if optTxt ~= nil and optTxt ~= CEnum.status.def_fill then
      if optTxt == CEnum.playOptions.twd then
        optTxt = CEnum.playOptions.wd
      elseif optTxt == CEnum.playOptions.twc then
        optTxt = CEnum.playOptions.wc
      end

      return Imgs.gameing_mid_options .. optTxt .. Imgs.file_img_suff

    else
      -- 没有牌
      -- return Imgs.c_check_yes -- 预看效果图片
      return Imgs.gameing_mid_zhanwei -- 透明图片
    end
end
-- 本人的出牌选择操作  触礁效果  吃 碰 胡 过  王钓 王闯 动作按钮  图片显示
function GameingDealUtil:getImgByOptionMid_press(optTxt)
    if optTxt ~= nil and optTxt ~= CEnum.status.def_fill then
      if optTxt == CEnum.playOptions.twd then
        optTxt = CEnum.playOptions.wd
      elseif optTxt == CEnum.playOptions.twc then
        optTxt = CEnum.playOptions.wc
      end

      return Imgs.gameing_mid_options .. optTxt .. Imgs.file_img_suff_press

    else
      -- 没有牌
      -- return Imgs.c_check_yes -- 预看效果图片
      return Imgs.gameing_mid_zhanwei -- 透明图片
    end
end

-- 游戏回合结束，房间结束的结果信息展示  胡牌的结果全部展示  吃 碰 偎 提 余牌  数字  底牌  手牌等等全部的显示  图片显示
function GameingDealUtil:getImgByShowHu(optTxt)
    if optTxt ~= nil and optTxt ~= CEnum.status.def_fill 
      and (
           optTxt == ""
           or optTxt == CEnum.playOptions.chi or optTxt == CEnum.playOptions.xiahuo
           or optTxt == CEnum.playOptions.peng 
           or optTxt == CEnum.playOptions.wei or optTxt == CEnum.playOptions.chouwei 
           or optTxt == CEnum.playOptions.ti or optTxt == CEnum.playOptions.ti8 
           or optTxt == CEnum.playOptions.pao or optTxt == CEnum.playOptions.pao8 
           or optTxt == CEnum.playOptions.hu or optTxt == CEnum.playOptions.hu 
           or optTxt == CEnum.playOptions.jiang
          )  
    then
        return GameingDealUtil:getImgByShowOption(optTxt)

    elseif optTxt ~= nil and optTxt ~= CEnum.status.def_fill 
        and type(optTxt) == "number" 
    then
        return optTxt
    
    else
        return GameingDealUtil:getImgByHandcard(CEnum.userCard.out, optTxt)
    end
end

-- 游戏回合结束，房间结束的结果信息展示  吃 碰 胡 余牌 等等动作图片显示  图片显示
function GameingDealUtil:getImgByShowOption(optTxt)
    if optTxt ~= nil and optTxt ~= CEnum.status.def_fill then
      if optTxt == CEnum.playOptions.xiahuo then
        optTxt = CEnum.playOptions.chi
      elseif optTxt == CEnum.playOptions.chouwei then
        optTxt = CEnum.playOptions.wei
      elseif optTxt == CEnum.playOptions.ti8 then
        optTxt = CEnum.playOptions.ti
      elseif optTxt == CEnum.playOptions.pao8 then
        optTxt = CEnum.playOptions.pao
      end

      return Imgs.over_round_opt .. optTxt .. Imgs.file_img_suff

    else
      -- 没有牌
      --return Imgs.c_check_yes -- 预看效果图片
      return Imgs.c_transparent -- 透明图片
    end
end

-- 房号，局号，用户编号的数字  数字展示  图片显示
function GameingDealUtil:getNumImgByShowUserId(numTxt)
    if numTxt ~= nil and numTxt ~= CEnum.status.def_fill then
      return Imgs.over_userid_show .. numTxt .. Imgs.file_img_suff

    else
      -- 没有牌
      --return Imgs.c_check_yes -- 预看效果图片
      return Imgs.c_transparent -- 透明图片
    end
end

-- -- 游戏中的房间号    数字图片显示
-- function GameingDealUtil:getNumImgByShowNumber(numTxt)
--     if numTxt ~= nil and numTxt ~= CEnum.status.def_fill then
--       return Imgs.over_nums_show .. numTxt .. Imgs.file_img_suff

--     else
--       -- 没有牌
--       --return Imgs.c_check_yes -- 预看效果图片
--       return Imgs.c_transparent -- 透明图片
--     end
-- end
-- 游戏中的房间号    数字图片显示
function GameingDealUtil:getNumImg_by_roomno(numTxt)
    if numTxt ~= nil and numTxt ~= CEnum.status.def_fill then
      return Imgs.over_nums_roomno .. numTxt .. Imgs.file_img_suff

    else
      -- 没有牌
      --return Imgs.c_check_yes -- 预看效果图片
      return Imgs.c_transparent -- 透明图片
    end
end

-- 游戏中的局数，第字，局字等等的数字    数字图片显示
function GameingDealUtil:getNumImg_by_roundno(numTxt)
    if numTxt ~= nil and numTxt ~= CEnum.status.def_fill then
        return Imgs.over_nums_roundno .. numTxt .. Imgs.file_img_suff

    else
      -- 没有牌
      --return Imgs.c_check_yes -- 预看效果图片
      return Imgs.c_transparent -- 透明图片
    end
end

-- 游戏中的底牌数字    数字图片显示
function GameingDealUtil:getNumImg_by_round_dcard(numTxt)
    if numTxt ~= nil and numTxt ~= CEnum.status.def_fill then
        return Imgs.over_nums_round_dcard .. numTxt .. Imgs.file_img_suff

    else
      -- 没有牌
      --return Imgs.c_check_yes -- 预看效果图片
      return Imgs.c_transparent -- 透明图片
    end
end

-- 回合结束，房间结束的分数 数字图片显示
function GameingDealUtil:getNumImg_by_scoreRound(numTxt)
    if numTxt ~= nil and numTxt ~= CEnum.status.def_fill then
        return Imgs.over_nums_scoreRound .. numTxt .. Imgs.file_img_suff

    else
      -- 没有牌
      --return Imgs.c_check_yes -- 预看效果图片
      return Imgs.c_transparent -- 透明图片
    end
end

-- 回合结束，房间结束的胡息数  数字图片显示
function GameingDealUtil:getNumImg_by_scoreRound_xi(numTxt)
    if numTxt ~= nil and numTxt ~= CEnum.status.def_fill then
        return Imgs.over_nums_scoreRound_xi .. numTxt .. Imgs.file_img_suff

    else
      -- 没有牌
      --return Imgs.c_check_yes -- 预看效果图片
      return Imgs.c_transparent -- 透明图片
    end
end

-- -- 游戏回合结束，房间结束的结果信息展示  数字展示  图片显示
-- function GameingDealUtil:getNumImgByShowNumber2(numTxt)
--     if numTxt ~= nil and numTxt ~= CEnum.status.def_fill then
--       return Imgs.over_nums_show2 .. numTxt .. Imgs.file_img_suff

--     else
--       -- 没有牌
--       --return Imgs.c_check_yes -- 预看效果图片
--       return Imgs.c_transparent -- 透明图片
--     end
-- end
-- 战绩里面的分数  数字图片显示
function GameingDealUtil:getNumImg_by_scoreResult(numTxt)
    if numTxt ~= nil and numTxt ~= CEnum.status.def_fill then
        return Imgs.over_nums_scoreResult .. numTxt .. Imgs.file_img_suff

    else
      -- 没有牌
      --return Imgs.c_check_yes -- 预看效果图片
      return Imgs.c_transparent -- 透明图片
    end
end

-- -- 游戏回合结束，房间结束的结果信息展示  数字展示  图片显示
-- function GameingDealUtil:getNumImgByShowNumber_FK(numTxt)
--     if numTxt ~= nil and numTxt ~= CEnum.status.def_fill then
--       return Imgs.over_nums_fk .. numTxt .. Imgs.file_img_suff

--     else
--       -- 没有牌
--       --return Imgs.c_check_yes -- 预看效果图片
--       return Imgs.c_transparent -- 透明图片
--     end
-- end
-- 首页用户钱包房卡余额  数字图片显示
function GameingDealUtil:getNumImg_by_money(numTxt)
    if numTxt ~= nil and numTxt ~= CEnum.status.def_fill then
        return Imgs.over_nums_money .. numTxt .. Imgs.file_img_suff

    else
      -- 没有牌
      --return Imgs.c_check_yes -- 预看效果图片
      return Imgs.c_transparent -- 透明图片
    end
end

-- 加入房间  数字图片显示
function GameingDealUtil:getNumImgByShowNumber_RoomJoin(numTxt)
    if numTxt ~= nil and numTxt ~= CEnum.status.def_fill then
      return Imgs.room_join_nums_show .. numTxt .. Imgs.file_img_suff

    else
      -- 没有牌
      --return Imgs.c_check_yes -- 预看效果图片
      return Imgs.c_transparent -- 透明图片
    end
end



-- 游戏回合结束，名堂列表 字样显示  文字显示
function GameingDealUtil:getMtImgByShowTxt(showTxt)
    if showTxt ~= nil and showTxt ~= CEnum.status.def_fill then
      return CEnum.mt[showTxt.."Name"]

    else
      -- 没有牌
      --return Imgs.c_check_yes -- 预看效果图片
      return "" -- 透明图片
    end
end

-- 确定玩家的座位号 0=本人 1=下一玩家（右手边） -1=最后一个玩家（左手边）
function  GameingDealUtil:confimSeatNo(owerNo, currNo)
    if owerNo ~= nil and currNo ~= nil then
      local temp_no = owerNo + 1 -- 算下一玩家的座位编号
      if temp_no > 2 then
          temp_no = 0
      end

      if owerNo == currNo then
          --_seat = 0
          return CEnum.seatNo.me
      elseif temp_no == currNo then
          --_seat = 1
          return CEnum.seatNo.R
      else
          --_seat = -1
          return CEnum.seatNo.L
      end
    else
      return nil
    end
end


--[[
    @param: dataTable table数据
    @param: all_column_nums -- 已经的table多少列，要把二维数组变成一维的
    -- ScrollView内部需要从左到右 一列一列的摆放顺序
    -- 123
    -- 456
    -- 789  这个方式
--]]
--[[
-- ScrollView内部需要从左到右 一列一列的摆放顺序
function GameingDealUtil:ScrollView_FillList(dataTable, all_column_nums)
    local return_dataTable = {}
    local allSize = all_column_nums * 3

    if dataTable~=nil and type(dataTable) == "table" then

        for i=1,allSize do
          return_dataTable[i] = CEnum.status.def_fill
        end

        local column_nums = #dataTable;
        --local options_size = #dataTable -- 多少个
        Commons:printLog_Info("----原始几列：", column_nums, all_column_nums)

        local options_chaValue = all_column_nums - column_nums; -- 与总数7个相差多少
        local need_posit = 0
        if options_chaValue ~= 0 then
          -- 需要 重连 之后居中摆放，就放开这3步，如果直接靠左，这3步注释
          local options_shang = (options_chaValue-(options_chaValue%2))/2 -- 相差的一半+1
          need_posit = options_shang -- + 1 -- + options_size
          Commons:printLog_Info("----need_posit:",need_posit)
        end

        if column_nums < all_column_nums then
            column_nums = all_column_nums
        end
        Commons:printLog_Info("----最后确定几列：",column_nums)


        local ii = 1;
        for k,v in pairs(dataTable) do
            if type(v)=="table" then
              local v_size = #v
              --Commons:printLog_Info("第"..ii.."列","----这列有几个----",v_size)
              if v_size == 1 then
                --return_dataTable[column_nums*0+ii+need_posit] = CEnum.status.def_fill;
                --return_dataTable[column_nums*1+ii+need_posit] = CEnum.status.def_fill;
                return_dataTable[column_nums*2+ii+need_posit] = v[1];
              elseif v_size == 2 then
                --return_dataTable[column_nums*0+ii+need_posit] = CEnum.status.def_fill;
                return_dataTable[column_nums*1+ii+need_posit] = v[2];
                return_dataTable[column_nums*2+ii+need_posit] = v[1];
              elseif v_size == 3 then
                return_dataTable[column_nums*0+ii+need_posit] = v[3];
                return_dataTable[column_nums*1+ii+need_posit] = v[2];
                return_dataTable[column_nums*2+ii+need_posit] = v[1];  
              end
            end
            ii = ii+1;
        end

        return return_dataTable;
    end
end
--]]

--[[
    @param: dataTable table数据
    @param: all_column_nums -- 已经的table多少列，要把二维数组变成一维的
    -- ScrollView内部需要从左到右 一列一列的摆放顺序
    -- 147
    -- 258
    -- 369  这个方式
--]]
---[[
function GameingDealUtil:ScrollView_FillList(dataTable, all_column_nums)
    local rowNums = CVar._static.handRows
    local return_dataTable = {}
    local allSize = all_column_nums * rowNums

    if dataTable~=nil and type(dataTable) == "table" then

        for i=1,allSize do
          return_dataTable[i] = CEnum.status.def_fill
        end

        local column_nums = #dataTable
        Commons:printLog_Info("----原始几列：", column_nums, all_column_nums)
        -- print("----原始几列：", column_nums, all_column_nums)

        if column_nums > all_column_nums then
            column_nums = all_column_nums
        end
        Commons:printLog_Info("----最后确定几列：",column_nums)
        -- print("----最后确定几列：",column_nums)

        local options_chaValue = all_column_nums - column_nums -- 与总数7个相差多少
        local need_posit = 0
        if options_chaValue ~= 0 then
          -- 需要 重连 之后居中摆放，就放开这3步，如果直接靠左，这3步注释
          local options_shang = (options_chaValue-(options_chaValue%2))/2 -- 相差的一半+1
          need_posit = options_shang -- + 1 -- + options_size
          Commons:printLog_Info("----need到第几列:",need_posit)
          -- print("----need到第几列:",need_posit)
        end

        local ii = 1
        for k,v in pairs(dataTable) do
            if type(v)=="table" then
              local v_size = #v
              if v_size == 1 then
                -- return_dataTable[0 +ii +need_posit*rowNums] = v[3]
                -- return_dataTable[1 +ii +need_posit*rowNums] = v[2]
                return_dataTable[2 +ii +need_posit*rowNums] = v[1]
              elseif v_size == 2 then
                -- return_dataTable[0 +ii +need_posit*rowNums] = v[3]
                return_dataTable[1 +ii +need_posit*rowNums] = v[2]
                return_dataTable[2 +ii +need_posit*rowNums] = v[1]
              elseif v_size == 3 then
                return_dataTable[0 +ii +need_posit*rowNums] = v[3]
                return_dataTable[1 +ii +need_posit*rowNums] = v[2]
                return_dataTable[2 +ii +need_posit*rowNums] = v[1] 
              end
            end
            ii = ii+rowNums
            if ii > (allSize-2) then
              break
            end
        end

        return return_dataTable
    end
end
--]]

--[[
    @param: dataTable table数据
    @param: all_column_nums -- 已经的table多少列，要把二维数组变成一维的
--]]
-- ScrollView内部需要从左到右 一列一列的摆放顺序
function GameingDealUtil:ScrollView_FillList_RL(dataTable, all_column_nums,_seat)
    local return_dataTable = {}
    local allSize = all_column_nums * 3

    if dataTable~=nil and type(dataTable) == "table" then

        for i=1,allSize do
          return_dataTable[i] = CEnum.status.def_fill
        end

        local column_nums = #dataTable;
        --local options_size = #dataTable -- 多少个
        Commons:printLog_Info("----原始几列：", column_nums, all_column_nums)

        local options_chaValue = all_column_nums - column_nums; -- 与总数7个相差多少
        local need_posit = 0
        if options_chaValue ~= 0 then
            if _seat == CEnum.seatNo.L then
              -- 需要 重连 之后居中摆放，就放开这3步，如果直接靠左，这3步注释
              -- local options_shang = (options_chaValue-(options_chaValue%2))/2 -- 相差的一半+1
              -- need_posit = options_shang -- + 1 -- + options_size
              -- Commons:printLog_Info("----need_posit:",need_posit)
            elseif _seat == CEnum.seatNo.R then
              -- 需要靠右摆放，直接=这个差值即可
              need_posit = options_chaValue
              Commons:printLog_Info("----need_posit:",need_posit)
            end
        end

        if column_nums < all_column_nums then
            column_nums = all_column_nums
        end
        Commons:printLog_Info("----最后确定几列：",column_nums)


        local ii = 1;
        for k,v in pairs(dataTable) do
            if type(v)=="table" then
              local v_size = #v
              --Commons:printLog_Info("第"..ii.."列","----这列有几个----",v_size)

                -- 从上到下摆放，最上面算第一行
                if v_size == 1 then
                  return_dataTable[all_column_nums*0 +ii +need_posit] = v[1]
                  -- return_dataTable[all_column_nums*1 +ii +need_posit] = v[2]
                  -- return_dataTable[all_column_nums*2 +ii +need_posit] = v[1]
                elseif v_size == 2 then
                  return_dataTable[all_column_nums*0 +ii +need_posit] = v[1]
                  return_dataTable[all_column_nums*1 +ii +need_posit] = v[2]
                  -- return_dataTable[all_column_nums*2 +ii +need_posit] = v[1]
                elseif v_size == 3 then
                  return_dataTable[all_column_nums*0 +ii +need_posit] = v[1]
                  return_dataTable[all_column_nums*1 +ii +need_posit] = v[2]
                  return_dataTable[all_column_nums*2 +ii +need_posit] = v[3] 
                end

                -- 从xia到shang摆放，最xia面算第一行
                -- if v_size == 1 then
                --   -- return_dataTable[all_column_nums*0 +ii +need_posit] = v[3]
                --   -- return_dataTable[all_column_nums*1 +ii +need_posit] = v[2]
                --   return_dataTable[all_column_nums*2 +ii +need_posit] = v[1]
                -- elseif v_size == 2 then
                --   -- return_dataTable[all_column_nums*0 +ii +need_posit] = v[3]
                --   return_dataTable[all_column_nums*1 +ii +need_posit] = v[2]
                --   return_dataTable[all_column_nums*2 +ii +need_posit] = v[1]
                -- elseif v_size == 3 then
                --   return_dataTable[all_column_nums*0 +ii +need_posit] = v[3]
                --   return_dataTable[all_column_nums*1 +ii +need_posit] = v[2]
                --   return_dataTable[all_column_nums*2 +ii +need_posit] = v[1] 
                -- end

            end
            ii = ii+1;
        end

        return return_dataTable;
    end
end

--[[
    @param: dataTable table数据
    @param: chiguoCard_allSize -- 14个 总共最多容纳多少张出牌摆放
    @param: chiguoCard_lineSize -- 每行7个 2行 一行最多容纳多少张出牌摆放
--]]
-- 我和下家打出去的牌
function GameingDealUtil:PageView_FillList_MeChuCard(dataTable, chuCard_allSize, chuCard_lineSize)
    local chuCards = dataTable;
    local need_chuguoCards = {} -- 需要 显示的集合
    --local chuCard_allSize = 14 -- 14个 总共最多容纳多少张出牌摆放
    --local chuCard_lineSize = 7; -- 每行7个=7列 2行   一行最多容纳多少张出牌摆放

    -- 赋值初始化
    for i=1,chuCard_allSize do
      need_chuguoCards[i] = CEnum.status.def_fill
    end

    if Commons:checkIsNull_tableList(chuCards) then
        local chuCards_size = #chuCards

        if chuCards_size>0 and chuCards_size<=chuCard_lineSize*1 then -- 只有1行的情况
          local chuCards_size_temp = chuCards_size
          -- 第一行
          local chaValue = chuCard_lineSize - chuCards_size_temp -- 最大值和 7 相差多少
          for k,v in pairs(chuCards) do
            need_chuguoCards[chuCards_size_temp+chaValue] = v -- 最大位置放最小的东西
            chuCards_size_temp = chuCards_size_temp - 1
          end

        elseif chuCards_size > chuCard_lineSize*1 and chuCards_size <= chuCard_lineSize*2 then -- 有2行的情况
          local chuCards_size_temp = chuCards_size
          -- 第一行
          --local chaValue = chuCard_lineSize*2 - chuCards_size_temp -- 最大值和 7 相差多少
          for i=1,chuCard_lineSize do
            need_chuguoCards[chuCard_lineSize+1-i] = chuCards[i] -- 最大位置放最小的东西
          end

          -- 算第2行
          local chaValue2 = chuCard_lineSize - (chuCards_size_temp - chuCard_lineSize) -- 最大值和 14 相差多少
          for k,v in pairs(chuCards) do
            if k > chuCard_lineSize then
              need_chuguoCards[chuCards_size_temp+chaValue2] = v
              chuCards_size_temp = chuCards_size_temp - 1
            end
          end

        elseif chuCards_size > chuCard_lineSize*2 and chuCards_size <= chuCard_lineSize*3 then -- 有3行的情况
          local chuCards_size_temp = chuCards_size
          local chuCards_size_temp2 = chuCard_lineSize*2
          -- 第一行
          --local chaValue = chuCard_allSize - chuCards_size_temp -- 最大值和 7 相差多少
          for i=1,chuCard_lineSize do
            need_chuguoCards[chuCard_lineSize+1-i] = chuCards[i] -- 最大位置放最小的东西
          end

          -- 算第2行
          --local chaValue2 = chuCard_lineSize - (chuCards_size_temp - chuCard_lineSize) -- 最大值和 14 相差多少
          for k,v in pairs(chuCards) do
            if k > chuCard_lineSize and k <= chuCard_lineSize*2 then
              need_chuguoCards[chuCards_size_temp2] = v
              chuCards_size_temp2 = chuCards_size_temp2 - 1
            end
          end

          -- 算第3行
          local chaValue3 = chuCard_lineSize - (chuCards_size_temp - chuCard_lineSize*2) -- 最大值和 21 相差多少
          for k,v in pairs(chuCards) do
            if k > chuCard_lineSize*2 then
              --print("--------------------------NNNNNNNNNNNNNNNNNNNNN--",chuCards_size_temp, chaValue3, chuCards_size_temp+chaValue3)
              need_chuguoCards[chuCards_size_temp+chaValue3] = v
              chuCards_size_temp = chuCards_size_temp - 1
            end
          end

        end

    end

    return need_chuguoCards
end

--[[
    @param: dataTable table数据
    @param: chiguoCard_allSize -- 24个 总共 最多容纳多少张出牌摆放
    @param: chiguoCard_lineSize -- 每行6个 4行 一行 最多容纳多少张出牌摆放
--]]
-- 我和最后一玩家吃、碰、偎的牌
function GameingDealUtil:PageView_FillList_MePengCard(dataTable, chiguoCard_allSize, chiguoCard_lineSize)
    local need_chiguoCombs = {} -- 需要显示的集合

    --local chiguoCard_allSize = 24 -- 24个 总共 最多容纳多少张出牌摆放
    --local chiguoCard_lineSize = 7 -- 每行6个=6列  4行  一行最多容纳多少张出牌摆放
     -- 赋值初始化
    for i=1,chiguoCard_allSize do
      need_chiguoCombs[i] = CEnum.status.def_fill
    end

    if Commons:checkIsNull_tableList(dataTable) then
      for kk,vv in pairs(dataTable) do
        if kk~=nil and kk<=chiguoCard_lineSize and Commons:checkIsNull_tableList(vv) then
          -- 加入到新的table中
          --Commons:printLog_Info("----位置是：",6*0+k,6*1+k,6*2+k,6*3+k)
          if #vv == 4 then
            need_chiguoCombs[(chiguoCard_lineSize-1)*0+kk] = vv[1] -- 吃的牌在第一位，即最上方显示
            need_chiguoCombs[(chiguoCard_lineSize-1)*1+kk] = vv[2]
            need_chiguoCombs[(chiguoCard_lineSize-1)*2+kk] = vv[3]
            need_chiguoCombs[(chiguoCard_lineSize-1)*3+kk] = vv[4]
          else
            --need_chiguoCombs[(chiguoCard_lineSize-1)*0+kk] = CEnum.status.def_fill
            need_chiguoCombs[(chiguoCard_lineSize-1)*1+kk] = vv[1] -- 吃的牌在第一位，即最上方显示
            need_chiguoCombs[(chiguoCard_lineSize-1)*2+kk] = vv[2]
            need_chiguoCombs[(chiguoCard_lineSize-1)*3+kk] = vv[3]
          end
        end
      end
    end

    return need_chiguoCombs
end


--[[
    @param: dataTable table数据
    @param: chiguoCard_allSize -- 24个 总共 最多容纳多少张出牌摆放
    @param: chiguoCard_lineSize -- 每行6个 4行 一行 最多容纳多少张出牌摆放
--]]
-- 游戏结束  胡牌的列表
function GameingDealUtil:PageView_FillList_huCards(dataTable)
    local need_chiguoCombs = {} -- 需要显示的集合

    local chiguoCard_allSize = 42 -- 35个 总共 最多容纳多少张出牌摆放
    local chiguoCard_lineSize = 7 -- 每行7个=7列   6行  一行最多容纳多少张出牌摆放
     -- 赋值初始化
    for i=1,chiguoCard_allSize do
      need_chiguoCombs[i] = CEnum.status.def_fill
    end

    if Commons:checkIsNull_tableList(dataTable) then
      for kk,vv in pairs(dataTable) do
        if Commons:checkIsNull_tableType(vv) then
          local option = vv[Player.Bean.option]
          local cards = vv[Player.Bean.cards]
          local xi = vv[Player.Bean.xi]
          local indexNo = vv[Player.Bean.indexNo]
          if indexNo ~= nil and Commons:checkIsNull_numberType(indexNo) then
            indexNo = indexNo + 1
          end

          --Commons:printLog_Info("----回合结束-----------", option, cards, xi, indexNo)

          if Commons:checkIsNull_tableList(cards) then
            --Commons:printLog_Info("----22222----------", #cards)
            -- 加入到新的table中
            -- 这里的组合个数不等
            if #cards == 4 then
              need_chiguoCombs[chiguoCard_lineSize*0+kk] = option
              need_chiguoCombs[chiguoCard_lineSize*1+kk] = cards[4]
              need_chiguoCombs[chiguoCard_lineSize*2+kk] = cards[3]
              need_chiguoCombs[chiguoCard_lineSize*3+kk] = cards[2]
              need_chiguoCombs[chiguoCard_lineSize*4+kk] = cards[1]
              need_chiguoCombs[chiguoCard_lineSize*5+kk] = xi
              if indexNo == 4 then
                need_chiguoCombs[chiguoCard_lineSize*1+kk] = cards[4] .. "#1"
              elseif indexNo == 3 then
                need_chiguoCombs[chiguoCard_lineSize*2+kk] = cards[3] .. "#1"
              elseif indexNo == 2 then  
                need_chiguoCombs[chiguoCard_lineSize*3+kk] = cards[2] .. "#1"
              elseif indexNo == 1 then
                need_chiguoCombs[chiguoCard_lineSize*4+kk] = cards[1] .. "#1"
              end
            elseif #cards == 3 then
              need_chiguoCombs[chiguoCard_lineSize*0+kk] = option
              need_chiguoCombs[chiguoCard_lineSize*1+kk] = cards[3]
              need_chiguoCombs[chiguoCard_lineSize*2+kk] = cards[2]
              need_chiguoCombs[chiguoCard_lineSize*3+kk] = cards[1]
              --need_chiguoCombs[chiguoCard_lineSize*4+kk] = 
              need_chiguoCombs[chiguoCard_lineSize*5+kk] = xi
              if indexNo == 3 then
                need_chiguoCombs[chiguoCard_lineSize*1+kk] = cards[3] .. "#1"
              elseif indexNo == 2 then  
                need_chiguoCombs[chiguoCard_lineSize*2+kk] = cards[2] .. "#1"
              elseif indexNo == 1 then
                need_chiguoCombs[chiguoCard_lineSize*3+kk] = cards[1] .. "#1"
              end
            elseif #cards == 2 then
              need_chiguoCombs[chiguoCard_lineSize*0+kk] = option
              need_chiguoCombs[chiguoCard_lineSize*1+kk] = cards[2]
              need_chiguoCombs[chiguoCard_lineSize*2+kk] = cards[1]
              --need_chiguoCombs[chiguoCard_lineSize*3+kk] = 
              --need_chiguoCombs[chiguoCard_lineSize*4+kk] = 
              need_chiguoCombs[chiguoCard_lineSize*5+kk] = xi
              if indexNo == 2 then  
                need_chiguoCombs[chiguoCard_lineSize*1+kk] = cards[2] .. "#1"
              elseif indexNo == 1 then
                need_chiguoCombs[chiguoCard_lineSize*2+kk] = cards[1] .. "#1"
              end
            elseif #cards == 1 then
              need_chiguoCombs[chiguoCard_lineSize*0+kk] = option
              need_chiguoCombs[chiguoCard_lineSize*1+kk] = cards[1]
              --need_chiguoCombs[chiguoCard_lineSize*2+kk] = 
              --need_chiguoCombs[chiguoCard_lineSize*3+kk] = 
              --need_chiguoCombs[chiguoCard_lineSize*4+kk] = 
              need_chiguoCombs[chiguoCard_lineSize*5+kk] = xi
              if indexNo == 1 then
                need_chiguoCombs[chiguoCard_lineSize*1+kk] = cards[1] .. "#1"
              end
            else
              need_chiguoCombs[chiguoCard_lineSize*0+kk] = option
              --need_chiguoCombs[chiguoCard_lineSize*1+kk] = 
              --need_chiguoCombs[chiguoCard_lineSize*2+kk] = 
              --need_chiguoCombs[chiguoCard_lineSize*3+kk] = 
              --need_chiguoCombs[chiguoCard_lineSize*4+kk] = 
              need_chiguoCombs[chiguoCard_lineSize*5+kk] = xi
            end
          end

        end
      end
    end

    return need_chiguoCombs
end


--[[
    @param: dataTable table数据
    @param: chiguoCard_allSize -- 24个 总共 最多容纳多少张出牌摆放
    @param: chiguoCard_lineSize -- 每行6个 4行 一行 最多容纳多少张出牌摆放
--]]
-- 下一玩家吃、碰、偎的牌
function GameingDealUtil:PageView_FillList_LPengCard(dataTable, chiguoCard_allSize, chiguoCard_lineSize)
    local need_chiguoCombs = {} -- 需要显示的集合

    --local chiguoCard_allSize = 24 -- 24个 总共 最多容纳多少张出牌摆放
    --local chiguoCard_lineSize = 7 -- 每行6个 4行 一行 最多容纳多少张出牌摆放
    -- 赋值初始化
    for i=1,chiguoCard_allSize do
      need_chiguoCombs[i] = CEnum.status.def_fill
    end

    -- 下一家的排序  也是需要做调整的
    if Commons:checkIsNull_tableList(dataTable) then
      local ii = 5
        for kk,vv in pairs(dataTable) do
          if kk~=nil and kk<chiguoCard_lineSize and Commons:checkIsNull_tableList(vv) then
            -- 加入到新的table中
            --Commons:printLog_Info("----下一家 位置是：", ii,kk)
            --Commons:printLog_Info("----下一家 位置是：", 6*0+ii+kk,6*1+ii+kk,6*2+ii+kk,6*3+ii+kk)
            if #vv == 4 then
              need_chiguoCombs[(chiguoCard_lineSize-1)*0+ii+kk] = vv[1] -- 吃的牌在第一位，即最上方显示
              need_chiguoCombs[(chiguoCard_lineSize-1)*1+ii+kk] = vv[2]
              need_chiguoCombs[(chiguoCard_lineSize-1)*2+ii+kk] = vv[3]
              need_chiguoCombs[(chiguoCard_lineSize-1)*3+ii+kk] = vv[4]
            else
              --need_chiguoCombs[(chiguoCard_lineSize-1)*0+ii+kk] = CEnum.status.def_fill
              need_chiguoCombs[(chiguoCard_lineSize-1)*1+ii+kk] = vv[1] -- 吃的牌在第一位，即最上方显示
              need_chiguoCombs[(chiguoCard_lineSize-1)*2+ii+kk] = vv[2]
              need_chiguoCombs[(chiguoCard_lineSize-1)*3+ii+kk] = vv[3]
            end
          end
          ii = ii-2
        end
      end

    return need_chiguoCombs
end

--[[
    @param: dataTable table数据
    @param: allSize 多少个总数显示
--]]
-- 我吃、碰、偎的牌的时候选择列表
function GameingDealUtil:PageView_FillList_MeChiPeng_Select(dataTable, allSize)
    local show_options = {}
    -- 赋值初始化
    for i=1,allSize do
      show_options[i] = CEnum.status.def_fill;
    end

    local options_size = #dataTable -- 多少个
    local options_chaValue = allSize - options_size; -- 与总数7个相差多少
    local need_posit = 0
    if options_chaValue ~= 0 then
      local options_shang = (options_chaValue-(options_chaValue%2))/2 -- 相差的一半+1
      need_posit = options_shang + 1 -- + options_size
      --Commons:printLog_Info("need_posit:",need_posit)
    end

    for kk,vv in pairs(dataTable) do
      show_options[need_posit+kk] = vv
    end

    return show_options
end


--[[
-- 创建一个表情动画
function GameingDealUtil:createEmoji_Anim(need_view, view_mo_chu_pai_bg, exp_code, seatNo, 
      _c_view, _chu_tipimg_node,
      _changeImg_scheduler,_changeImg_schedulerID)

    -- 这里先取消组件的存在，因为cc.Repeat动画完成，无法去除组件
    --if chu_tipimg ~= nil and (not tolua.isnull(chu_tipimg)) then
    --  chu_tipimg:removeFromParent()
    --  chu_tipimg = nil
    --end

    if _c_view ~= nil and (not tolua.isnull(_c_view)) then
      _c_view:removeFromParent()
      _c_view = nil
    end

    if _chu_tipimg_node ~= nil and (not tolua.isnull(_chu_tipimg_node)) then
      _chu_tipimg_node:removeFromParent()
      _chu_tipimg_node = nil
    end

    if _changeImg_scheduler~=nil and _changeImg_schedulerID~=nil then
        _changeImg_scheduler:unscheduleScriptEntry(_changeImg_schedulerID) 
        _changeImg_schedulerID = nil
        _changeImg_scheduler = nil

    end

    local changeImg_scheduler
    local changeImg_schedulerID
    local i = 0

    if exp_code ~= nil then
      -- 图片提示
      local chu_tipimg_node = display.newNode()--cc.NodeGrid:create();
          :addTo(need_view, CEnum.ZOrder.gameingView_myself_emoji)
      --    --:align(display.CENTER_TOP, display.cx, osHeight-170-48)
      --    --:setPosition(cc.p(display.cx, osHeight-170-48))

      --cc.ui.UIImage.new(Imgs.gameing_mid_mopai_bg,{scale9=false})
      --    :addTo(chu_tipimg_node)
      --cc.ui.UIImage.new(Imgs.card_mid_nw0,{scale9=false})
      --    :addTo(chu_tipimg_node)
      local c_view = view_mo_chu_pai_bg:clone()
      view_mo_chu_pai_bg:setVisible(false)
      --if seatNo ~= nil and seatNo == CEnum.seatNo.me then
      --    c_view = view_mo_chu_pai_bg
      --else
      --    c_view = view_mo_chu_pai_bg:clone()
         chu_tipimg_node:addChild(c_view) -- 拷贝个副本进行动画
      --end
      --Commons:printLog_Info("----------------c_view:", c_view)

      c_view:setVisible(true)
      --c_view:setButtonImage(EnStatus.normal, EmojiDialog:getImgByBiaoqing(exp_code))
      --c_view:setButtonImage(EnStatus.pressed, EmojiDialog:getImgByBiaoqing(exp_code))
      c_view:setButtonImage(EnStatus.disabled, EmojiDialog:getImgByBiaoqing(exp_code))
      c_view:setButtonEnabled(false) -- 第1遍

      for i=0,4 do
          need_view:performWithDelay(function ()
              --c_view:setButtonImage(EnStatus.normal, EmojiDialog:getImgByBiaoqing1(exp_code))
              --c_view:setButtonImage(EnStatus.pressed, EmojiDialog:getImgByBiaoqing1(exp_code))
              c_view:setButtonImage(EnStatus.disabled, EmojiDialog:getImgByBiaoqing1(exp_code))
              c_view:setButtonEnabled(false)
          end, 0.3 + 0.9*i )

          need_view:performWithDelay(function ()
              --c_view:setButtonImage(EnStatus.normal, EmojiDialog:getImgByBiaoqing2(exp_code))
              --c_view:setButtonImage(EnStatus.pressed, EmojiDialog:getImgByBiaoqing2(exp_code))
              c_view:setButtonImage(EnStatus.disabled, EmojiDialog:getImgByBiaoqing2(exp_code))
              c_view:setButtonEnabled(false)
          end, 0.3+0.3 + 0.9*i )

          if i== 4 then
              need_view:performWithDelay(function ()
                  --c_view:setButtonImage(EnStatus.normal, EmojiDialog:getImgByBiaoqing(exp_code))
                  --c_view:setButtonImage(EnStatus.pressed, EmojiDialog:getImgByBiaoqing(exp_code))
                  c_view:setButtonImage(EnStatus.disabled, EmojiDialog:getImgByBiaoqing(exp_code))
                  c_view:setButtonEnabled(false)

                  --if not tolua.isnull(c_view) then
                    -- c_view:removeFromParent()
                    -- c_view = nil
                  --end
                  c_view:setVisible(false)
                  
                  --if not tolua.isnull(chu_tipimg_node) then
                    --chu_tipimg_node:removeFromParent()
                    --chu_tipimg_node = nil
                  --end
                  chu_tipimg_node:setVisible(false)
                  
              end, 0.3+0.3+0.3 + 0.9*i )
          else
              need_view:performWithDelay(function ()
                  --c_view:setButtonImage(EnStatus.normal, EmojiDialog:getImgByBiaoqing(exp_code))
                  --c_view:setButtonImage(EnStatus.pressed, EmojiDialog:getImgByBiaoqing(exp_code))
                  c_view:setButtonImage(EnStatus.disabled, EmojiDialog:getImgByBiaoqing(exp_code))
                  c_view:setButtonEnabled(false)
              end, 0.3+0.3+0.3 + 0.9*i )
          end
      end
      return c_view, chu_tipimg_node, changeImg_scheduler, changeImg_schedulerID

    end
end
--]]

--创建一个表情动画
function GameingDealUtil:createEmoji_Anim(parent_view, exp_code, seatNo, _tipimg_node)

    local osWidth = Commons.osWidth
    local osHeight = Commons.osHeight

    if _tipimg_node ~= nil and (not tolua.isnull(_tipimg_node)) then
      _tipimg_node:removeFromParent()
      _tipimg_node = nil
    end

    if exp_code ~= nil then
        -- new表情
        -- local moveX_exp = -4
        -- local moveY_exp = 3
        -- if exp_code=='zt' then
        --   moveX_exp = -10
        --   moveY_exp = 3
        -- elseif exp_code=='dk' then
        --   moveX_exp = -30
        --   moveY_exp = 3
        -- elseif exp_code=='bs' then
        --   moveX_exp = -8
        --   moveY_exp = 5
        -- elseif exp_code=='sj' then
        --   moveX_exp = -4
        --   moveY_exp = 15
        -- end

        -- 第一套表情的处理
        local moveX_exp = 0
        local moveY_exp = 0
        if exp_code=='bf' then
          moveX_exp = -7
          moveY_exp = 0
        elseif exp_code=='ka' then
          moveX_exp = -7
          moveY_exp = 0
        elseif exp_code=='wx' then
          moveX_exp = 4
          moveY_exp = 0
        end

        local tipimg_node = display.newNode():addTo(parent_view, CEnum.ZOrder.gameingView_myself_emoji)

        -- local plist, png = EmojiDialog:getImgByBiaoqing_new(exp_code)
        -- display.addSpriteFrames(plist, png) -- loading动画

        local frames = display.newFrames(exp_code.."_%d.png",0,2)
        local animation = display.newAnimation(frames, 0.7/3)

        local loadingSpriteAnim = display.newSprite(animation[1])
        if seatNo == CEnum.seatNo.me then
          loadingSpriteAnim:align(display.LEFT_TOP, 50 +moveX_exp, 155 +moveY_exp)

          --animation:setDelayPerUnit(0.15) -- 设置两个帧播放时
          -- animation:setRestoreOriginalFrame(true) -- 动画执行后还原初始状态
          --display.setAnimationCache("stars", animation)
          --animation = display.getAnimationCache("stars")
          --display.removeAnimationCache("stars")

          -- loadingSpriteAnim:playAnimationOnce(animation, false, function()
          --  Commons:printLog_Info("11 complete")
          -- end, 0.01)
        elseif seatNo == CEnum.seatNo.R then
          loadingSpriteAnim:align(display.RIGHT_TOP, osWidth-50 -moveX_exp, osHeight-65 +moveY_exp)
        elseif seatNo == CEnum.seatNo.L then
          loadingSpriteAnim:align(display.LEFT_TOP, 50 +moveX_exp, osHeight-65 +moveY_exp)
        end
        loadingSpriteAnim:addTo(tipimg_node)
        loadingSpriteAnim:playAnimationForever(animation)

        parent_view:performWithDelay(function ()
          if tipimg_node ~= nil and (not tolua.isnull(tipimg_node)) then
              if loadingSpriteAnim ~= nil and (not tolua.isnull(loadingSpriteAnim)) then
                  -- print("============确定停止了")
                  loadingSpriteAnim:stopAllActions()
                  -- parent_view:stopAction(loadingSpriteAnim)
              end
              tipimg_node:hide()
          end
        end, 3)

        return tipimg_node
    end
end

--创建一个短语显示和声音播放
function GameingDealUtil:createWords_Anim(parent_view, words_code, seatNo, _tipimg_node)

    local osWidth = Commons.osWidth
    local osHeight = Commons.osHeight

    if _tipimg_node ~= nil and (not tolua.isnull(_tipimg_node)) then
      _tipimg_node:removeFromParent()
      _tipimg_node = nil
    end

    if words_code ~= nil then
        local tipimg_node = display.newNode():addTo(parent_view, CEnum.ZOrder.gameingView_myself_emoji)

        local msg,url = EmojiDialog:getWordsMsg_by_code(words_code)
        -- print("======================",msg,url)

        if Commons:checkIsNull_str(msg) then
          local item_w_words = 123*2 *1.3
          local item_h_words = 70 -- 空出70像素的title部分

          if seatNo == CEnum.seatNo.me then
            local bg = display.newScale9Sprite(Imgs.words_txt_me, 0,0, 
                        cc.size(item_w_words, item_h_words), 
                        cc.rect(32, 32, 6, 6)
                      )
                      -- cc.ui.UIPushButton.new(Imgs.words_txt_me, {scale9=true, size=cc.size(item_w_words, item_h_words), capInsets=cc.rect(32, 32, 6, 6)} )
                      --     :setButtonSize(item_w_words*1.2, item_h_words*1.2)
                      --     :setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
                      --         UILabelType = 2,
                      --         text = msg,
                      --         font = Fonts.Font_hkyt_w7,
                      --         size = Dimens.TextSize_20,
                      --         color = Colors.words_txt,
                      --         -- align = cc.ui.TEXT_ALIGN_LEFT,
                      --         -- valign = cc.ui.TEXT_VALIGN_CENTER,
                      --     }))
                      -- :setButtonLabelAlignment(display.LEFT_CENTER)        --设置按钮文字的对齐方式  
                      -- :setButtonLabelOffset(-(item_w_words*1.2)/2+10, 0)                  --设置按钮文字的x,y偏移
                      :addTo(tipimg_node)
                      :align(display.LEFT_BOTTOM, 40, 140)

              cc.ui.UILabel.new({
                      UILabelType = 2,
                      text = msg,
                      font = Fonts.Font_hkyt_w7,
                      size = Dimens.TextSize_20,
                      -- color = Colors.words_txt,
                      color = Colors.white,
                      align = cc.ui.TEXT_ALIGN_LEFT,
                      valign = cc.ui.TEXT_VALIGN_CENTER,
                  })
                  :addTo(bg)
                  :align(display.LEFT_BOTTOM, 15, 27 +5)

          elseif seatNo == CEnum.seatNo.R then
            local bg = display.newScale9Sprite(Imgs.words_txt_R, 0,0, 
                        cc.size(item_w_words, item_h_words), 
                        cc.rect(32, 32, 6, 6)
                      )
                      -- cc.ui.UIPushButton.new(Imgs.words_txt_me, {scale9=true, size=cc.size(item_w_words, item_h_words), capInsets=cc.rect(32, 32, 6, 6)} )
                      --     :setButtonSize(item_w_words*1.2, item_h_words*1.2)
                      --     :setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
                      --         UILabelType = 2,
                      --         text = msg,
                      --         font = Fonts.Font_hkyt_w7,
                      --         size = Dimens.TextSize_20,
                      --         color = Colors.words_txt,
                      --         -- align = cc.ui.TEXT_ALIGN_LEFT,
                      --         -- valign = cc.ui.TEXT_VALIGN_CENTER,
                      --     }))
                      -- :setButtonLabelAlignment(display.LEFT_CENTER)        --设置按钮文字的对齐方式  
                      -- :setButtonLabelOffset(-(item_w_words*1.2)/2+10, 0)                  --设置按钮文字的x,y偏移
                      :addTo(tipimg_node)
                      :align(display.RIGHT_BOTTOM, osWidth -40, osHeight -140 -50)

              cc.ui.UILabel.new({
                      UILabelType = 2,
                      text = msg,
                      font = Fonts.Font_hkyt_w7,
                      size = Dimens.TextSize_20,
                      -- color = Colors.words_txt,
                      color = Colors.white,
                      align = cc.ui.TEXT_ALIGN_LEFT,
                      valign = cc.ui.TEXT_VALIGN_CENTER,
                  })
                  :addTo(bg)
                  :align(display.LEFT_BOTTOM, 15, 27 -5)

          elseif seatNo == CEnum.seatNo.L then
            local bg = display.newScale9Sprite(Imgs.words_txt_L, 0,0, 
                        cc.size(item_w_words, item_h_words), 
                        cc.rect(32, 32, 6, 6)
                      )
                      -- cc.ui.UIPushButton.new(Imgs.words_txt_me, {scale9=true, size=cc.size(item_w_words, item_h_words), capInsets=cc.rect(32, 32, 6, 6)} )
                      --     :setButtonSize(item_w_words*1.2, item_h_words*1.2)
                      --     :setButtonLabel(EnStatus.normal, cc.ui.UILabel.new({
                      --         UILabelType = 2,
                      --         text = msg,
                      --         font = Fonts.Font_hkyt_w7,
                      --         size = Dimens.TextSize_20,
                      --         color = Colors.words_txt,
                      --         -- align = cc.ui.TEXT_ALIGN_LEFT,
                      --         -- valign = cc.ui.TEXT_VALIGN_CENTER,
                      --     }))
                      -- :setButtonLabelAlignment(display.LEFT_CENTER)        --设置按钮文字的对齐方式  
                      -- :setButtonLabelOffset(-(item_w_words*1.2)/2+10, 0)                  --设置按钮文字的x,y偏移
                      :addTo(tipimg_node)
                      :align(display.LEFT_BOTTOM, 40, osHeight -140 -50)

              cc.ui.UILabel.new({
                      UILabelType = 2,
                      text = msg,
                      font = Fonts.Font_hkyt_w7,
                      size = Dimens.TextSize_20,
                      -- color = Colors.words_txt,
                      color = Colors.white,
                      align = cc.ui.TEXT_ALIGN_LEFT,
                      valign = cc.ui.TEXT_VALIGN_CENTER,
                  })
                  :addTo(bg)
                  :align(display.LEFT_BOTTOM, 15, 27 -5)
          end  
        end

        if Commons:checkIsNull_str(url) then
          VoiceDealUtil:playSound_forWords(url)
        end

        local gapTime = 2
        -- if words_code==EmojiDialog.gameingWordsList[1].code then
        --   gapTime = 0.28
        -- elseif words_code==EmojiDialog.gameingWordsList[2].code then
        --   gapTime = 0.28
        -- end
        parent_view:performWithDelay(function ()
          if tipimg_node ~= nil and (not tolua.isnull(tipimg_node)) then
              tipimg_node:hide()
          end
        end, gapTime)

        return tipimg_node
    end
end


-- 创建一个播放语音动画
function GameingDealUtil:createVoice_Anim(parent_view, seatNo, _tipimg_node)

    --print("------------------------动画已经进入", seatNo)
    local osWidth = Commons.osWidth
    local osHeight = Commons.osHeight

    if _tipimg_node ~= nil and (not tolua.isnull(_tipimg_node)) then
      _tipimg_node:stopAllActions()
      _tipimg_node:removeFromParent()
      _tipimg_node = nil
    end

    local tipimg_node = display.newNode():addTo(parent_view, CEnum.ZOrder.gameingView_myself_emoji)
    -- local tipimg_node;

    --display.addSpriteFrames(Imgs.voiceplay_plist, Imgs.voiceplay_png) -- 语音播放动画

    local frames = display.newFrames("voiceplay%02d.png",1,3)
    local animation = display.newAnimation(frames, 1.0/3)

    _tipimg_node = display.newSprite(animation[3])
    if seatNo == CEnum.seatNo.me then -- me
        _tipimg_node:align(display.LEFT_TOP, 55, 148)

    elseif seatNo == CEnum.seatNo.R then  -- xiajia
        _tipimg_node:align(display.RIGHT_TOP, osWidth-53, osHeight-72)

    elseif seatNo == CEnum.seatNo.L then -- lastjia
        _tipimg_node:align(display.LEFT_TOP, 55, osHeight-73)
        
    end
    _tipimg_node:addTo(tipimg_node)
    -- _tipimg_node:addTo(parent_view, CEnum.ZOrder.gameingView_myself_emoji)
    _tipimg_node:playAnimationForever(animation)

    return _tipimg_node
end



-- 构造函数
function GameingDealUtil:ctor()
end


function GameingDealUtil:onEnter()
end


function GameingDealUtil:onExit()
    --Commons:printLog_Info("GameingDealUtil:onExit")
    --self:removeAllChildren();
end

-- 必须有这个返回
return GameingDealUtil
