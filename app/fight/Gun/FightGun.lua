local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")

local FightGun = class("FightGun", cc.mvc.ModelBase)

FightGun.HELP_START_EVENT = "HELP_START_EVENT"
FightGun.HELP_END_EVENT = "HELP_END_EVENT"

function FightGun:ctor(properties)
	FightGun.super.ctor(self, properties)
end

--枪械简介
function FightGun:showGunIntro(gunData) -- showEnemyIntro
	assert(gunData, "gunData is nil")
	local function callfuncStart()
		print("local function callfuncStart()")
		self:dispatchEvent({name = FightGun.HELP_START_EVENT,
			gunId = gunData.id})
	end

	local function callfuncEnd()
		print("callfuncEnd")
		self:dispatchEvent({name = FightGun.HELP_END_EVENT})
	end

	scheduler.performWithDelayGlobal(callfuncStart, gunData.delay)
	scheduler.performWithDelayGlobal(callfuncEnd, gunData.time)
end

function FightGun:changeHelpGun(id)
	local hero = md:getInstance("Hero")
	hero:changeTempGun(id)
end

return FightGun