
local Fight   = import(".Fight") 

local JujiFight = class("JujiFight", Fight)
JujiFight.JUJIFIGHT_SCORE_EVENT = "JUJIFIGHT_SCORE_EVENT"

function JujiFight:ctor(properties)
	JujiFight.super.ctor(self, properties)

	--instance
	self.passLevelNum = 0
end

function JujiFight:startFightResult()
	--save
	self:passLevel() 

	--closeFunc
	local function closeFunc()
		local resultData = self:getResultData()
	    ui:changeLayer("FightPlayer",{fightData = resultData})
	end
	
    --save goldValue
    local user = md:getInstance("UserModel") 
    print("self.goldGet", self.goldGet)
    user:addMoney(self.goldGet)

	--desc
    local data = {
    	levelIndex   = self:getLevelId(),
    	closeFunc    = closeFunc,
    	goldValue    = self.goldGet,
	}
    ui:showPopup("JujiResultLayer",data,{animName = "normal"})
end

function JujiFight:getResultData()
	local resultData = {}
	resultData["fightType"] = self:getFightType() 
	resultData["groupId"]   = self:getGroupId()
	resultData["levelId"]   = self:getLevelId() + 1 
	resultData["isContinue"]= true 
	resultData["result"]    = self:getResult()
	return resultData   
end

function JujiFight:getFightType()
	return "jujiFight"
end

function JujiFight:isJujiFight()
    return false
end

function JujiFight:getJujiScore()
	return self.passLevelNum * 100
end

function JujiFight:waveUpdate(nextWaveIndex, waveType)
	--save
	local isDirect = true
	if nextWaveIndex ~= 1 then
		self:passLevel()
		isDirect = false
	end
    --jifen
    self:dispatchEvent({name = self.JUJIFIGHT_SCORE_EVENT, 
	    score = self:getJujiScore(), isDirect = isDirect})

	--desc
    local fightDescModel = md:getInstance("FightDescModel")
    if waveType == "boss" then 
        fightDescModel:bossShow()
    elseif waveType == "award" then  
        fightDescModel:goldShow()
    elseif waveType == "normalWave" then
		-- local jujiModeModel = md:getInstance("JujiModeModel")    	
    	local waveIndex = self.passLevelNum + 1
        fightDescModel:waveStart(waveIndex)
    else
        assert(waveType, "waveType is nil")
    end
end

function JujiFight:passLevel()
	self.passLevelNum = self.passLevelNum + 1

	--save data
	local jujiModeModel = md:getInstance("JujiModeModel")
	local curWaveIndex =  jujiModeModel:getCurWaveIndex()
	if curWaveIndex < self.passLevelNum then 
		jujiModeModel:setCurWaveIndex(self.passLevelNum)
	end	

	--test
	print("self.passLevelNum:", self.passLevelNum )
	local curWaveIndex =  jujiModeModel:getCurWaveIndex()
	print("curWaveIndex:", curWaveIndex)
end

function JujiFight:endFightFail()
    self:dispatchEvent({name = Fight.FIGHT_FAIL_EVENT})
    self:pauseFight(true)
	ui:showPopup("FightRelivePopup",
		{onReliveFunc = handler(self, self.onReliveConfirm),
		 onGiveUpFunc = handler(self, self.onReliveDeny),
		 fightType = "juji"},
		{animName = "normal"})
    self:clearFightData()
end

function JujiFight:getReliveCost()
    local times = self:getRelivedTimes()
    local costs = define.kJujiReliveCosts
    local maxCost = costs[#costs]
    return costs[times + 1] or maxCost
end

function JujiFight:onReliveConfirm()
	self:doRelive()
end

function JujiFight:onReliveDeny()
	self:doGiveUp()
    local fightData = self:getResultData()
    ui:changeLayer("HomeBarLayer",{fightData = fightData})	
end

return JujiFight