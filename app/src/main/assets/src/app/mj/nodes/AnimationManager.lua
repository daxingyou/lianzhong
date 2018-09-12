-- Author: luobinbin
-- Date: 2017-08-12 19:40:54
--动画管理器

local AnimationManager = class("AnimationManager")

function AnimationManager:ctor()
    
end

--播放牌型动画
function AnimationManager:playSuperEmoji(Layer1, mySeatNo, emojiType, seatNo, targetSeatNo, playFlag)
    local moveX_M = 0
    if CVar._static.isIphone4 then
        moveX_M = 65
    elseif CVar._static.isIpad then
        moveX_M = 75
    elseif CVar._static.NavBarH_Android ~= CEnum.status.NavBarH_def then
    end

	local biaoQingList = {ImgsM.flower, ImgsM.bangzhuang, ImgsM.egg, ImgsM.water}
    local biaoQingAniList = {"flower0%d.png", "bangzhuang0%d.png", "egg0%d.png", "water0%d.png"}
    local biaoVoiceList = {VoicesM.file.flower, VoicesM.file.bangzhuang, VoicesM.file.egg, VoicesM.file.water}
    local biaoDelayList = {1.0, 0.35, 0.35, 0.45}
    local biaoQingAniFrameCount = {5, 3, 3, 4}
    local playerPosList = {
        [CEnumM.seatNo.me]={x=20, y=183+110},
    	[CEnumM.seatNo.R]={x=display.right-120+20, y=280+169+5+40},
    	[CEnumM.seatNo.M]={x=display.right -253 -94 +20 +moveX_M, y=display.top -55 -176 +169 +5},
    	[CEnumM.seatNo.L]={x=20, y=290+169+40}
    }

    local clientSeatNo = nil
    local clientTargetSeatNo = nil

    if CEnum.AppVersion.gameAlias == CEnum.gameType.pdk then
        clientSeatNo = EmojiView:confimSeatNo(mySeatNo, seatNo) 
        clientTargetSeatNo = EmojiView:confimSeatNo(mySeatNo, targetSeatNo)
        playerPosList = {
            [CEnumP.seatNo.me] = {x=20, y=360},
            [CEnumP.seatNo.R] = {x=display.right-30 -75, y=display.top-65},
            [CEnumP.seatNo.L] = {x=20, y=display.top-70}
        }

    elseif CEnum.AppVersion.gameAlias == CEnum.gameType.hzmj then
        clientSeatNo = GameMaJiangUtil:confimSeatNo(mySeatNo, seatNo)
        clientTargetSeatNo = GameMaJiangUtil:confimSeatNo(mySeatNo, targetSeatNo)

    elseif CEnum.AppVersion.gameAlias == CEnum.gameType.wmq then
        clientSeatNo = GameingDealUtil:confimSeatNo(mySeatNo, seatNo)
        clientTargetSeatNo = GameingDealUtil:confimSeatNo(mySeatNo, targetSeatNo)
        playerPosList = {
            [CEnum.seatNo.me]={x=50, y=165}, 
            [CEnum.seatNo.R]={x=display.right-50-75, y=display.top-55},
            [CEnum.seatNo.L]={x=45, y=display.top-55}
        }
    end

	local frames = display.newFrames(biaoQingAniList[emojiType], 1, biaoQingAniFrameCount[emojiType])
    local animation = display.newAnimation(frames, 1 / 4)
    local animSprite = display.newSprite(biaoQingList[emojiType])
            :align(display.LEFT_TOP, playerPosList[clientSeatNo].x, playerPosList[clientSeatNo].y)
            :addTo(Layer1, CEnum.ZOrder.gameingView_myself_voice)
    local animSpriteTarget = display.newSprite(biaoQingList[emojiType])
            :align(display.LEFT_TOP, playerPosList[clientTargetSeatNo].x, playerPosList[clientTargetSeatNo].y)
            :addTo(Layer1, CEnum.ZOrder.gameingView_myself_voice)
            :hide()

    if playFlag then
        VoiceDealUtil:playSound_forWords(biaoVoiceList[emojiType])
    end
    
    animSpriteTarget:playAnimationForever(animation, 0)  

    local sequence = transition.sequence({
        cc.DelayTime:create(0.1),
        cc.MoveTo:create(0.3, cc.p(playerPosList[clientTargetSeatNo].x, playerPosList[clientTargetSeatNo].y)),
        -- cc.DelayTime:create(1.0),
        cc.CallFunc:create(
	        function()
                animSprite:hide()
                animSpriteTarget:show()
	        end
        ),
        cc.DelayTime:create(biaoDelayList[emojiType]),
        cc.CallFunc:create(
            function()
                animSpriteTarget:stopAllActions()
                animSpriteTarget:removeFromParent()
                animSprite:removeFromParent()
            end
        )
        
    })
    animSprite:runAction(sequence)

end

return AnimationManager