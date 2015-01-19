

local Define = class("Define", cc.mvc.ModelBase)

--hero
Define.kHeroBaseHp 				= 100.0  --
Define.kHeroCritScale 			= 3.0  --

--小兵 
Define.kEnemyWalkSpeed 			= 5.0
Define.kEnemyWalkWidth 			= 140	 --移动距离
Define.kEnemyRollSpeed 			= 12.0	 --滚动速度 每帧率
Define.kEnemyRollWidth 			= 280    --滚动距离

--导弹
Define.kMissileDaoTime				= 2.0    --导弹，铁球飞行时间 
Define.kMissileLeiTime				= 1.8    --手雷 

--人质
Define.kRenzhiSpeed				= 300.0    --人质跑动速度 像素/s
Define.kRenzhiRunTime			= 1.2


--黄金武器
Define.kGoldActivate 			= 15    --黄金武器激活
Define.kGoldTime 				= 6     --黄金武器激活时间

--机甲
Define.kRobotCoolDownTime 		= 0.08   --robot 冷却时间
Define.kRobotDemage			 	= 220    --机甲伤害
Define.kRobotTime			 	= 10.0   --机甲持续时间
Define.kRobotRangeH				= 40.0   -- 机甲范围
Define.kRobotRangeW				= 80.0   --机甲范围

--自爆兵
Define.kBaoDemageOtherEnemys 	= 10  --自爆兵伤害值
Define.kBaoRangeW 				= 200	--手雷范围
Define.kBaoRangeH 				= 200	--手雷范围

--盾牌
Define.cdTimes 					= 10.0   --十秒恢复完毕

--奖励
Define.kKillEnemyAwardGold     	= 10	--杀敌奖励
Define.kGoldCoinValue			= 3.33		--单个金币值为3

--购买相关
Define.kBuyFullHpTime 			= 0.11  -- 10%血  

--手打黄武
--子弹


--狙击枪
Define.kJuRange 				= 4.0

function Define:ctor()
    Define.super.ctor(self) 
end

return Define

