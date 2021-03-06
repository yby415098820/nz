local EnemyFactory = class("EnemyFactory",cc.mvc.ModelBase)

--导弹
local DDNormalEnemyView = import(".enemys.DDNormalEnemyView")
local DaoEnemyView 		= import(".enemys.DaoEnemyView")
local DDWangEnemyView	= import(".enemys.DDWangEnemyView")
local DDWuEnemyView		= import(".enemys.DDWuEnemyView")

--近战
local JinEnemyView 		= import(".enemys.JinEnemyView")
local BaoEnemyView 		= import(".enemys.BaoEnemyView")

--爆炸物
local BaoTongEnemyView	= import(".enemys.BaoTongEnemyView")

local CommonEnemyView	= import(".enemys.CommonEnemyView")
local JinbiEnemyView  	= import(".enemys.JinbiEnemyView")
local FeijiEnemyView    = import(".enemys.FeijiEnemyView")
local JipuEnemyView     = import(".enemys.JipuEnemyView")

local RenEnemyView   	= import(".enemys.RenEnemyView")
local AwardEnemyView   	= import(".enemys.AwardEnemyView")

--奖励
local AwardSanEnemyView	= import(".enemys.AwardSanEnemyView")

--人质
local RZHushiEnemyView 		= import(".enemys.RZHushiEnemyView")
local RZShangrenEnemyView 	= import(".enemys.RZShangrenEnemyView")
local RZBangfeiEnemyView 	= import(".enemys.RZBangfeiEnemyView")
local RZBangrenEnemyView 	= import(".enemys.RZBangrenEnemyView")

--逃犯
local TFQiuEnemyView 	= import(".enemys.TFQiuEnemyView")

--医疗兵
local DoctorEnemyView 	= import(".enemys.DoctorEnemyView")

--狙击兵
local JuEnemyView 		= import(".enemys.JuEnemyView")

--boss
local SaosheBossView 	= import(".enemys.SaosheBossView")
local ChongBossView 	= import(".enemys.ChongBossView")
local RenBossView 		= import(".enemys.RenBossView")
local DuozuBossView		= import(".enemys.DuozuBossView")

function EnemyFactory.createEnemy(property)
	assert(property, "property is nil")
	local enemyView

	--boss
	property.type = property.type or "common"	
	local type = property.type
	-- print("function EnemyFactory.createEnemy(property)"，type)	
	if type == "boss" then 
		enemyView = SaosheBossView.new(property)
	elseif type == "chongBoss" then
		enemyView = ChongBossView.new(property)		
	elseif type == "renzheBoss" then
		enemyView = RenBossView.new(property)		
	elseif type == "duozuBoss" then
		enemyView = DuozuBossView.new(property)	

	--dao
	-- else
	-- 	local configStr = "config/enemy/enemy_" .. property.id .. ".json"
	-- 	local config = getRecordByKey(configStr, "level", property.level)[1]		
	-- 	type = config.type
	-- 	print("普通兵", type)
	-- end

	elseif type == "dao_wang" then
		enemyView = DDWangEnemyView.new(property)
	elseif type == "missile" then
		enemyView = DDNormalEnemyView.new(property)
	elseif type == "dao_wu" then 
		enemyView = DDWuEnemyView.new(property)

	--juji
	elseif type == "juji" then 
		enemyView = JuEnemyView.new(property)	

	--award
	elseif type == "awardSan" then
		enemyView = AwardSanEnemyView.new(property)	

	--renzhi
	elseif type == "renzhi" then
		enemyView = RZHushiEnemyView.new(property)
	elseif type == "shangren" then
		enemyView = RZShangrenEnemyView.new(property)	
	elseif type == "bangfei" then
		enemyView = RZBangfeiEnemyView.new(property)	
	elseif type == "bangren" then
		enemyView = RZBangrenEnemyView.new(property)

	--taofan
	elseif type == "taofan_qiu" then
		enemyView = TFQiuEnemyView.new(property)

	--enemy		
	elseif type == "jin" then
		enemyView = JinEnemyView.new(property)
	elseif type == "bao" then
		enemyView = BaoEnemyView.new(property)	

	--爆炸
	elseif type == "bao_tong" then 
		enemyView = BaoTongEnemyView.new(property)
	--医疗兵
	elseif type == "yiliao" then 
		enemyView = DoctorEnemyView.new(property)	

	elseif type == "dao" then
		enemyView = DaoEnemyView.new(property)	
	elseif type == "jinbi" then
		enemyView = JinbiEnemyView.new(property)
	elseif type == "feiji" then
		enemyView = FeijiEnemyView.new(property)	
	elseif type == "jipu" then	
		enemyView = JipuEnemyView.new(property)								
	elseif type == "renzhe" then
		enemyView = RenEnemyView.new(property)							
	elseif type == "award" then
		enemyView = AwardEnemyView.new(property)							
	elseif type == "common" then 			
		enemyView = CommonEnemyView.new(property)
	else
		assert(false, "invalid type:"..type)
	end
	return enemyView
end

return EnemyFactory