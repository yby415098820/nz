 --[[--

“枪”的实体

]]

--includes

local Defence = class("Defence", cc.mvc.ModelBase)

--events
Defence.DEFENCE_SWITCH_EVENT = "DEFENCE_SWITCH_EVENT"
Defence.DEFENCE_RESUME_EVENT = "DEFENCE_RESUME_EVENT"
Defence.DEFENCE_BROKEN_EVENT = "DEFENCE_BROKEN_EVENT"
Defence.DEFENCE_BEHURTED_EVENT = "DEFENCE_BEHURTED_EVENT"
Defence.DEFENCE_CRACK_EVENT = "DEFENCE_CRACK_EVENT"

function Defence:ctor()
    Defence.super.ctor(self)
    --instance
    self.isDefending = false
    self.isAble = true
    --event

    self:refreshHp()
end

function Defence:setIsAble(isAble)
	self.isAble = isAble
	if isAble then
		self:refreshHp()
		self:dispatchEvent({name = Defence.DEFENCE_RESUME_EVENT})
	else
		self:clearData()
		self:dispatchEvent({name = Defence.DEFENCE_BROKEN_EVENT})
	end
end

function Defence:getIsAble()
	return self.isAble
end

function Defence:getIsDefending()
	return self.isDefending
end

function Defence:setIsDefending(isDefending_)
	print("function Defence:setIsDefending(isDefending_)")
	self.isDefending = isDefending_
end

function Defence:refreshHp()
	local fightFactory =  md:getInstance("FightFactory")
    local fight = fightFactory:getFight()
	local gid, lid = fight:getCurGroupAndLevel()
	local isGuide = gid == 0 and lid == 0 
	local hp = isGuide and 1000 or define.kDefenceHp
	self.maxHp = hp
	self.hp = hp
end

function Defence:decreseHp(demage)
	-- print("myhp:", self.hp)
	-- print("Defence:decreseHp(demage)", demage)
	assert(self.hp > 0, "Defence is dead")
	local curHp = self.hp - demage
	local hpOffset = self.maxHp / 10
	if curHp <= 0 then 
		self:setIsAble(false)
		return
	else
		local demageSum = self.maxHp - curHp
		local demagePercent = demageSum / self.maxHp
		self:dispatchEvent({name = Defence.DEFENCE_BEHURTED_EVENT, percent = demagePercent})
		local cur   = math.ceil (curHp / hpOffset)
		local last  = math.ceil(self.hp / hpOffset) 
		if cur ~= last then 
			self:dispatchEvent({name = Defence.DEFENCE_CRACK_EVENT,
				 num = last - cur})
		end
		self.hp = curHp
	end
end

function Defence:clearData()
	self.hp = 0
	self.maxHp = 0
	self.isDefending = false
end

function Defence:onHitted(demage)
	--hp
	print("demage", demage)
	self:decreseHp(demage)

	--子弹挨打
	local soundSrc  = "res/Music/fight/hithd.wav"
	self.audioId =  audio.playSound(soundSrc,false)		
end

function Defence:switchStatus()
	if self.isAble == false then return end

	if self.isDefending then
		self:endDefence()
	else
		self:startDefence()
	end
end

function Defence:startDefence()
	print("Defence:startDefence()")
	self:setIsDefending(true)
	self:dispatchEvent({name = Defence.DEFENCE_SWITCH_EVENT, isDefend = true})

    --um
    local fightFactory =   md:getInstance("FightFactory")
    local fight = fightFactory:getFight()
    local levelInfo = fight:getLevelInfo()
    assert(levelInfo, "levelInfo is nil")
    local umData = {}
    umData[levelInfo] = "盾"
    um:event("关卡道具使用", umData) 
end

function Defence:endDefence()
	print("Defence:endDefence()")
	self:setIsDefending(false)
	self:dispatchEvent({name = Defence.DEFENCE_SWITCH_EVENT, isDefend = false})
end

return Defence