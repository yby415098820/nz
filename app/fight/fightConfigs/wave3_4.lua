local BaseWave = import(".BaseWave")
local waveClass = class("waveClass", BaseWave)

local waves = {
	{
		enemys = { 
			{
				time = 2,
				num = 1,
				delay = {0.5},
				pos = {0},
				property = {
					type = "taofan_qiu", 
					placeName = "place5",
					id = 4,
					startState = "enterleft", --从屏幕左侧进入
					data = {
						direct = "right", --向右逃跑
						{
							pos = 160,  --第一次藏身处 移动 600
							time = 4,   --隐藏时间 3s	
						},	
						{
							pos = 500,  --第一次藏身处 移动 600
							time = 4,   --隐藏时间 3s
						},										
					},									
				},
			},
			-- {
			-- 	time = 6,
			-- 	num = 1,
			-- 	delay = {0.5},
			-- 	pos = {0},
			-- 	property = {
			-- 		type = "taofan_qiu", 
			-- 		placeName = "place9",
			-- 		id = 4,
			-- 		startState = "enterleft", --从屏幕左侧进入
			-- 		data = {
			-- 			direct = "right", --向右逃跑
			-- 			{
			-- 				pos = 300,  --第一次藏身处 移动 600
			-- 				time = 3,   --隐藏时间 3s	
			-- 			},
			-- 			{
			-- 				pos = 300,  --第一次藏身处 移动 600
			-- 				time = 3,   --隐藏时间 3s	
			-- 			},
			-- 		},
			-- 	},
			-- },
			-- {
			-- 	time = 10,
			-- 	num = 1,
			-- 	delay = {0.5},
			-- 	pos = {0},
			-- 	property = {
			-- 		type = "taofan_qiu", 
			-- 		placeName = "place11",
			-- 		id = 4,
			-- 		startState = "enterright", --从屏幕左侧进入
			-- 		data = {
			-- 			direct = "left", --向右逃跑
			-- 			{
			-- 				pos = 650,  --第一次藏身处 移动 600
			-- 				time = 3,   --隐藏时间 3s	
			-- 			},
			-- 			{
			-- 				pos = 300,  --第一次藏身处 移动 600
			-- 				time = 3,   --隐藏时间 3s	
			-- 			},
			-- 		},
			-- 	},
			-- },
			

		},
	},

	{
		enemys = {

			{
				time = 3,
				num = 1,
				delay = {4},
				pos = {500},
				property = {
					placeName = "place11",  
					type = "dao",
					id = 5,
					missileId = 6,
					missileType = "daodan",
				},
			}, 
			{
				time = 6,
				num = 1,
				delay = {0},
				pos = {50},
				property = {
					placeName = "place10",  
					id = 2,
					type = "dao",
					missileId = 3,
					missileType = "lei",
				},
			},
			{
				time = 9,
				num = 1,
				delay = {0},
				pos = {116},
				property = {
					placeName = "place6",  
					startState = "",
					id = 1,
				},
			},
			{
				time = 12,
				num = 1,
				delay = {0},
				pos = {100},
				property = {
					placeName = "place2",  
					startState = "rollright",
					id = 1,
				},
			},
			{
				time = 15,
				num = 1,
				delay = {0},
				pos = {666},
				property = {
					placeName = "place5",  
					id = 2,
					type = "dao",
					missileId = 3,
					missileType = "lei",
					startState = "rollright",
				},
			},
			{
				time = 18,
				num = 1,
				delay = {0},
				pos = {600},
				property = {
					placeName = "place5",  
					id = 1,
					startState = "rollright",
				},
			},
			{
				time = 21,
				num = 1,
				delay = {0},
				pos = {95},
				property = {
					placeName = "place3",  
					id = 1,
					startState = "rollright",
				},
			},
			{
				time = 24,
				num = 1,
				delay = {0.4},
				pos = {195},
				property = {
					placeName = "place14",  
					type = "dao",
					id = 5,
					missileId = 6,
					missileType = "daodan",
				},
			}, 
			{
				time = 27,
				num = 1,
				delay = {0.4},
				pos = {80},
				property = {
					placeName = "place12",  
					type = "dao",
					id = 5,
					missileId = 6,
					missileType = "daodan",
				},
			}, 
			{
				time = 30,
				num = 1,
				delay = {0},
				pos = {500},
				property = {
					placeName = "place9",  
					startState = "rollright",
					id = 2,
					type = "dao",
					missileId = 3,
					missileType = "lei",
				},
			},
		},
	},
		
	{
		enemys = {
		    {
				time = 3,
				num = 1,
				pos = {700},
				delay = {0.5},                         -- 飞机          
				property = {
					type = "feiji" ,
					id = 11,
					placeName = "place17",
					missileId = 6,
					missileType = "daodan",
					missileOffsets = {cc.p(250,-250), cc.p(-150, -150)},	--炮筒位置发出xy轴偏移值,第一个位置右一,第二位置个右二
					startState = "enterleft",
					lastTime = 40.0,		                                    --持续时间			
				},
			},
			{
				time = 10,
				num = 5,
				delay = {0,0.7,1.4, 2.1,2.8},
				pos = {100,230,300,450,480},					
				property = {
					placeName = "place11",  
					type = "common",
					startState = "san",
					id = 1,
				},
			},	
			{
				time = 15,
				num = 5,
				delay = {0,0.7,1.4, 2.1,2.8},
				pos = {380,490,570,660,700},					
				property = {
					placeName = "place9",  
					type = "common",
					startState = "san",
					id = 1,
				},
			},
			{
				time = 28,
				num = 5,
				delay = {2.1,2.8,0.7,1.4,0.9 },
				pos = {720,610,380,490,570},					
				property = {
					placeName = "place9",  
					type = "common",
					startState = "san",
					id = 1,
				},
			},					
		},
	},

}



--enemy的关卡配置                                  黄金难度 狙击枪630伤害 1枪1449         dps大于等于5
local enemys = {
	--普通兵                                      140--左右移动距离       280--滚动距离
	{id=1,image="anim_enemy_002",demage=20,hp=1500,walkRate=120,walkCd=2,rollRate=180,rollCd=2,fireRate=180,fireCd=4,
	weak1=2},

	--手雷兵      --type = "dao",
	{id=2,image="shouleib",demage=0,hp=1500,walkRate=120,walkCd=2,rollRate=180,rollCd=2,fireRate=240,fireCd=4,
	weak1=2},

	--手雷            --missileType = "lei",
	{id=3,image="shoulei",demage=20,hp=420,
	weak1=1},

	--囚犯            type = "taofan_qiu",
	{id=4,image="qiufan",demage=5,hp=2500, weak1=2,},
                                                        
	--导弹兵      --type = "dao",
	{id=5,image="zpbing",demage=0,hp=5000,walkRate=120,walkCd=2,fireRate=240,fireCd=5,
	weak1=2},

    --导弹          --missileType = "daodan",
	{id=6,image="daodan",demage=25,hp=420,
	weak1=1},	

	--飞机         type = "feiji" ,
	{id=11,image="feiji",demage=0,hp=10870, walkRate=180,walkCd = 2.0,rollRate=120, rollCd = 1.5, fireRate=180, fireCd=4.0,
	weak1=2.0,    award = 60},


}





local mapId = "map_1_4"

local limit = 10   				--此关敌人上限

function waveClass:ctor()
	self.waves  = waves
	self.enemys = enemys
	self.bosses = bosses
	self.mapId  = mapId
	self.fightMode =  {
		-- type 	  = "puTong",

		-- type 	  = "renZhi",
		-- saveNums  = 4,                 --解救人质数量

		-- type 	  = "xianShi",
		-- limitTime = 60,                   --限时模式时长

		type 	  = "taoFan",
		limitNums = 5,                      --逃跑逃犯数量
	}
end
return waveClass