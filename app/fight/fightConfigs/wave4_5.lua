local BaseWave = import(".BaseWave")
local waveClass = class("waveClass", BaseWave)

local waves = {
	{
		enemys = { 
			{
				time = 2,
				num = 3,
				delay = {0.3,0,0.6},
				pos = {380,680,980},
				property = {
					type = "jin",
					placeName = "place4",  
					id = 8,
				},
			},
			{
				time = 3,
				num = 1,
				delay = {0},
				pos = {15},					
				property = {
					placeName = "place7",   
					id = 2,
					startState = "",
					type = "dao",
					missileId = 3,
					missileType = "lei",
				},
			},
			{
				time = 4,
				num = 1,
				delay = {0},
				pos = {20},					
				property = {
					placeName = "place6",   
					id = 2,
					startState = "",
					type = "dao",
					missileId = 3,
					missileType = "lei",
				},
			},
			{
				time = 5,
				num = 3,
				delay = {0,0.5,0.9},
				pos = {125,250,333},					
				property = {
					placeName = "place1",   
					id = 1,
					startState = "rollright",
				},
			},
			{
				time = 11,	                                               --奖励箱子
				num = 1,
				pos = {400},
				delay = {0},
				property = { 
					type = "awardSan",
					id = 21,
					--award = "goldWeapon",     --黄金武器
					award = "coin",                        --金币
					--award = "shouLei",        --手雷
					--award = "healthBag",                 --医疗包
					value = 500,
					placeName = "place4",
				},
			},
			{
				time = 6,
				num = 1,
				delay = {0},
				pos = {40},					
				property = {
					placeName = "place5",   
					id = 2,
					startState = "",
					type = "dao",
					missileId = 3,
					missileType = "lei",
				},
			},
			{
				time = 7,
				num = 1,
				delay = {0},
				pos = {20},					
				property = {
					placeName = "place8",   
					id = 5,
					startState = "",
					type = "dao",
					missileId = 6,
					missileType = "daodan",
				},
			},
			{
				time = 3,
				num = 1,
				delay = {0,},
				pos = {350,},
				property = { 
					placeName = "place2" ,
					type = "yiliao",                                --医疗兵
					startState = "enterleft",       --从左面跑出来
					skillCd = 5.0,                  --回血cd
					skillValue = 0.3,              --回血百分比
					id = 10,
				},
			},
			{
				time = 3,
				num = 1,
				delay = {0,},
				pos = {930,},
				property = { 
					placeName = "place4" ,
					type = "yiliao",                                --医疗兵
					startState = "enterright",       --从右面跑出来
					skillCd = 5.0,                  --回血cd
					skillValue = 0.3,              --回血百分比
					id = 10,
				},
			},
			{
				time = 8.5,
				num = 1,
				delay = {0},
				pos = {25},					
				property = {
					placeName = "place9",   
					id = 5,
					startState = "",
					type = "dao",
					missileId = 6,
					missileType = "daodan",
				},
			},
			{
				time = 9,
				num = 3,
				delay = {0,0.5,1},
				pos = {100,350,750},					
				property = {
					placeName = "place3", 
					startState = "rollright",
					id = 1,
				},
			},
			{
				time = 10,
				num = 2,
				delay = {0,0.5},
				pos = {800,1000},					
				property = {
					placeName = "place10", 
					startState = "rollleft",
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
				time = 2,	
				num = 3,
				pos = {200,400,600},
				delay = {0,0.5,1,},
				property = { 
					placeName = "place2",
					startState = "rollright",
					id = 1,
				},
			},
			{
				time = 3,	
				num = 2,
				pos = {300,550},
				delay = {0.5,1},
				property = { 
					placeName = "place4",
					startState = "rollright",
					id = 2,
					type = "dao",
					missileId = 3,
					missileType = "lei",
				},
			},
			{
				time = 4,
				num = 2,
				delay = {0,0.5},
				pos = {550,800},
				property = { 
					placeName = "place3",
					id = 1,
					startState = "rollleft",	
				},
			},

			{
				time = 4,
				num = 1,
				delay = {0,},
				pos = {930,},
				property = { 
					placeName = "place4" ,
					type = "yiliao",                                --医疗兵
					startState = "enterright",       --从右面跑出来
					skillCd = 5.0,                  --回血cd
					skillValue = 0.3,              --回血百分比
					id = 10,
				},
			},
			{
				time = 5,	                                               --奖励箱子
				num = 1,
				pos = {450},
				delay = {0},
				property = { 
					type = "awardSan",
					id = 21,
					--award = "goldWeapon",     --黄金武器
					award = "coin",                        --金币
					--award = "shouLei",        --手雷
					--award = "healthBag",                 --医疗包
					value = 500,
					placeName = "place3",
				},
			},
			{
				time = 5,
				num = 3,
				delay = {0,1,1.5},
				pos = {200,400,600},
				property = { 
					placeName = "place10",
					id = 1,
					startState = "rollright",	
				},
			},
			{
				time = 6,
				num = 1,
				delay = {0.5},
				pos = {45},
				property = { 
					placeName = "place7",
					id = 2,
					type = "dao",
					missileId = 3,
					missileType = "lei",
				},
			},
			{
				time = 7,
				num = 1,
				delay = {0.5},
				pos = {45},
				property = { 
					placeName = "place6",
					id = 5,
					type = "dao",
					missileId = 6,
					missileType = "daodan",
				},
			},
			{
				time = 8,
				num = 1,
				delay = {0,},
				pos = {350,},
				property = { 
					placeName = "place2" ,
					type = "yiliao",                                --医疗兵
					startState = "enterleft",       --从左面跑出来
					skillCd = 5.0,                  --回血cd
					skillValue = 0.3,              --回血百分比
					id = 10,
				},
			},
			{
				time = 9,
				num = 1,
				delay = {1},
				pos = {230},
				property = { 
					placeName = "place10",
					id = 2,
					startState = "rollright",
					type = "dao",
					missileId = 3,
					missileType = "lei",	
				},
			},
			{
				time = 10,	
				num = 3,
				delay = {0,0.5,1,},
				pos = {200,300,400,},
				property = { 
					placeName = "place2",
					startState = "rollright",                                         
					id = 1,
				},
			},
			{
				time = 11,
				num = 2,
				delay = {0,0.5},
				pos = {750,1020},					
				property = {
					placeName = "place4",   
					id = 5,
					type = "dao",
					missileId = 6,
					missileType = "daodan",
				},
			},	
			{
				time = 11.5,
				num = 1,
				delay = {0},
				pos = {150},					
				property = {
					placeName = "place3",   
					id = 5,
					type = "dao",
					missileId = 6,
					missileType = "daodan",
				},
			},
			{
				time = 12,
				num = 1,
				delay = {0},
				pos = {300},					
				property = {
					placeName = "place2",   
					id = 5,
					type = "dao",
					missileId = 6,
					missileType = "daodan",
				},
			},
			{
				time = 12.5,
				num = 1,
				delay = {0},
				pos = {330},					
				property = {
					placeName = "place1",   
					id = 5,
					type = "dao",
					missileId = 6,
					missileType = "daodan",
				},
			},
		},
	},
	{
		enemys = { 
			{                                                            --忍者 dps主力
				time = 2,	
				num = 1,
				pos = {600},
				delay = {0.2},
				property = {
					placeName = "place3" ,
					id = 17,
					type = "renzhe",
					missileId = 18,
				},
			},	
			{
				time = 4,
				num = 1,
				delay = {0,},
				pos = {350,},
				property = { 
					placeName = "place4" ,
					type = "yiliao",                                --医疗兵
					startState = "enterleft",       --从右面跑出来
					skillCd = 5.0,                  --回血cd
					skillValue = 0.3,              --回血百分比
					id = 10,
				},
			},
            {
				time = 5,	
				num = 3,
				pos = {200,400,600,},
				delay = {0,0.5,1,},
				property = { 
					placeName = "place2",
					startState = "rollright",
					id = 1,
				},
			},

			{
				time = 6,	
				num = 1,
				pos = {700},
				delay = {0.6},
				property = {
					placeName = "place3" ,
					id = 17,
					type = "renzhe",
					missileId = 18,
				},
			},	
			{
				time = 7,	
				num = 2,
				pos = {200,350},
				delay = {0.5,1},
				property = { 
					placeName = "place1",
					startState = "rollleft",
					id = 2,
					type = "dao",
					missileId = 3,
					missileType = "lei",
				},
			},
			{
				time = 8,
				num = 2,
				delay = {0.2,1},
				pos = {550,800},
				property = { 
					placeName = "place3",
					id = 1,
					startState = "rollleft",	
				},
			},
			{
				time = 9,
				num = 3,
				delay = {0,1,0.5},
				pos = {200,400,600},
				property = { 
					placeName = "place10",
					id = 1,
					startState = "rollright",	
				},
			},
			{
				time = 9,
				num = 1,
				delay = {0,},
				pos = {80,},
				property = { 
					placeName = "place3" ,
					type = "yiliao",                                --医疗兵
					startState = "enterright",       --从左面跑出来
					skillCd = 5.0,                  --回血cd
					skillValue = 0.3,              --回血百分比
					id = 10,
				},
			},
			{
				time = 10,
				num = 1,
				delay = {0.5},
				pos = {45},
				property = { 
					placeName = "place7",
					id = 2,
					type = "dao",
					missileId = 3,
					missileType = "lei",
				},
			},
			{
				time = 11,
				num = 1,
				delay = {0.5},
				pos = {45},
				property = { 
					placeName = "place6",
					id = 5,
					type = "dao",
					missileId = 6,
					missileType = "daodan",
				},
			},
			{
				time = 12,
				num = 3,
				delay = {0.5,1,1.5},
				pos = {250,500,750},
				property = { 
					placeName = "place10",
					id = 1,
					startState = "rollright",	
				},
			},
			{
				time = 13,	                                               --奖励箱子
				num = 1,
				pos = {430},
				delay = {0},
				property = { 
					type = "awardSan",
					id = 21,
					--award = "goldWeapon",     --黄金武器
					award = "coin",                        --金币
					--award = "shouLei",        --手雷
					--award = "healthBag",                 --医疗包
					value = 500,
					placeName = "place2",
				},
			},
			{
				time = 13,
				num = 1,
				delay = {1},
				pos = {230},
				property = { 
					placeName = "place10",
					id = 2,
					startState = "rollright",
					type = "dao",
					missileId = 3,
					missileType = "lei",	
				},
			},
			{
				time = 14,	
				num = 3,
				pos = {200,400,600},
				delay = {0,0.5,1},
				property = { 
					placeName = "place2",
					startState = "rollright",                                          
					id = 1,
				},
			},	

		},
	},
	{
		enemys = {
			{
				time = 2,
				num = 10,
				delay = {0, 0, 0,0,0,0,0,0,0,0},
				pos = {10,90,170,250,330,410,490,570,630,710},
				property = {
					type = "jinbi",
					placeName = "place3",  
					speed = 2,                                                    --2*60 / s   每秒移动60像素(右斜)
					id = 13,
				},
			},
			{
				time = 4,
				num = 10,
				delay = {0, 0.5, 1.0,1.5,2.0,2.5,3.0,3.5,4.0,4.5},
				pos = {1110,1030,950,870,790,710,630,570,490,410},
				property = {
					type = "jinbi",
					placeName = "place4",  
					speed = 3,                                                    --左斜
					id = 14,
				},
			},

			{
				time = 12,
				num = 10,
				delay = {0, 0.5, 1.0,1.5,2.0,2.5,3.0,3.5,4.0,4.5},
				pos = {410,490,570,630,710,790,870,950,1030,1110},
				property = {
					type = "jinbi",
					placeName = "place10",  
					speed = 3,                                                    --右斜
					id = 13,
				},
			},
			{
				time = 17,
				num = 10,
				delay = {0, 0, 0,0,0,0,0,0,0,0},
				pos = {1110,1030,950,870,790,710,630,570,490,410},
				property = {
					type = "jinbi",
					placeName = "place4",  
					speed = 3,                                                    --横
					id = 14,
				},
			},
			{
				time = 17.5,
				num = 10,
				delay = {0, 0.5, 1.0,1.5,2.0,2.5,3.0,3.5,4.0,4.5},
				pos = {1110,1030,950,870,790,710,630,570,490,410},
				property = {
					type = "jinbi",
					placeName = "place10",  
					speed = 3,                                                    --左斜
					id = 13,
				},
			},
			{
				time = 10,
				num = 10,
				delay = {0, 1.5, 3.0,5.0,9.0,13.5,15,20,25,28},
				pos = {450,750,650,700,800, 1000,800,350,666,888},                                    
				                                                                          -- 黄气球
				property = {
					type = "jinbi",
					placeName = "place11", 
					speed = 5, 
					id = 15,
				},
			},
			{
				time = 3,
				num = 10,
				delay = {0, 3.0, 6.0,7.0,9.0,16.5,20.0,24,28,30},
				pos = {500,900,650,720,690, 400,800,650,430,740},
				property = {
					type = "jinbi",
					placeName = "place4", 
					speed = 4.5, 
					id = 14,
				},
			},
			                                                                                 -- 背景散飞蓝气球
			{
				time = 11,
				num = 10,
				delay = {1, 3.7, 5.4,7,8.7,9.5,14.2,16,21,26},
				pos = {750,450,600,380,800,550,750,350,870,666},
				property = {
					type = "jinbi",
					placeName = "place10",  
					speed = 3.5,
					id = 13,
				},
			},                                                                                -- 背景散飞绿气球
			{
				time = 18,
				num = 5,
				delay = {1, 4, 7,11,15},
				pos = {400, 500, 350, 300, 550},
				property = {
					type = "jinbi",
					placeName = "place4",  
					speed = 3.5,
					id = 14,
				},
			},
			{
				time = 19,
				num = 5,
				delay = {1, 4, 7,11,15},
				pos = {40, 50, 55, 280, 300},
				property = {
					type = "jinbi",
					placeName = "place11",  
					speed = 3.5,
					id = 13,
				},
			},
			{
				time = 23.5,
				num = 10,
				delay = {0, 0.5, 1.0,1.5,2.0,2.5,3.0,3.5,4.0,4.5},
				pos = {1110,1030,950,870,790,710,630,570,490,410},
				property = {
					type = "jinbi",
					placeName = "place4",  
					speed = 3,                                                    --左斜
					id = 13,
				},
			},

			{
				time = 29,
				num = 10,
				delay = {0, 0, 0,0,0,0,0,0,0,0},
				pos = {1110,1030,950,870,790,710,630,570,490,410},
				property = {
					type = "jinbi",
					placeName = "place10",  
					speed = 3,                                                    --横
					id = 14,
				},
			},
			{
				time = 30,
				num = 10,
				delay = {0, 0.5, 1.0,1.5,2.0,2.5,3.0,3.5,4.0,4.5},
				pos = {410,490,570,630,710,790,870,950,1030,1110},
				property = {
					type = "jinbi",
					placeName = "place4",  
					speed = 3,                                                    --右斜
					id = 13,
				},
			},
			{
				time = 34,
				num = 12,
				delay = {0,0,0,0.7,0.7,0.7,0.7,0.7,1.4,1.4,1.4,2.1},
				pos = {650,750,850,550,650,750,850,950,650,750,850,750},                                    
				                                                                          -- 心形绿气球
				property = {
					type = "jinbi",
					placeName = "place10", 
					speed = 3, 
					id = 13,
				},
			},
			{
				time = 38,
				num = 6,
				delay = {1,1.5,1.8,2.0,2.5,3},
				pos = {780,660,830,550,666,888},                                    
				                                                                          -- 黄气球
				property = {
					type = "jinbi",
					placeName = "place11", 
					speed = 5, 
					id = 15,
				},
			},
			{
				time = 41,
				num = 12,
				delay = {0,0,0,0.7,0.7,0.7,0.7,0.7,1.4,1.4,1.4,2.1},
				pos = {650,750,850,550,650,750,850,950,650,750,850,750},                                    
				                                                                          -- 心形蓝气球
				property = {
					type = "jinbi",
					placeName = "place10", 
					speed = 3, 
					id = 14,
				},
			},
			{
				time = 44,
				num = 12,
				delay = {0,0,0,0.7,0.7,0.7,0.7,0.7,1.4,1.4,1.4,2.1},
				pos = {650,750,850,550,650,750,850,950,650,750,850,750},                                    
				                                                                          -- 心形金气球
				property = {
					type = "jinbi",
					placeName = "place10", 
					speed = 3, 
					id = 15,
				},
			},

		},
	},
	
	
}




--enemy的关卡配置                                                    黄金镶嵌 m4a1满级  dps大于等于3  怪物数据
local enemys = {
	--普通兵                                      140--左右移动距离       280--滚动距离
	{id=1,image="anim_enemy_002",demage=9,hp=8000,walkRate=180,walkCd=2,rollRate=180,rollCd=2,fireRate=180,fireCd=3,
	weak1=2},

	--手雷兵      --type = "dao",
	{id=2,image="shouleib",demage=0,hp=8000,walkRate=180,walkCd=2,rollRate=180,rollCd=2,fireRate=240,fireCd=4,
	weak1=2},

	--手雷            --missileType = "lei",
	{id=3,image="shoulei",demage=12,hp=600,
	weak1=1},
	
	--导弹兵      --type = "dao",
	{id=5,image="zpbing",demage=0,hp=25000,walkRate=120,walkCd=2,fireRate=240,fireCd=5,
	weak1=2},

    --导弹          --missileType = "daodan",
	{id=6,image="daodan",demage=15,hp=1800,
	weak1=1},

	--盾兵         --type = "jin",
	{id=8,image="dunbing",demage=15,hp=30000,fireRate=180,fireCd=5,speed= 40,
	weak1=2},

	--医疗兵      type = "yiliao",
	{id=10,image="yiliaob",demage=12,hp=25000,walkRate=180,walkCd=2,rollRate=180,rollCd=3,fireRate=180,fireCd=4,
	weak1=2},

	--金币绿气球   type = "jinbi",
	{id=13,image="qiqiu03",hp=1,weak1=2,award = 9},	--award = 9   金币数量为9	

	--金币蓝气球   type = "jinbi",
	{id=14,image="qiqiu02",hp=1,weak1=2,award = 15},	--award = 15  金币数量为15

	--金币黄气球   type = "jinbi",
	{id=15,image="qiqiu01",hp=1,weak1=2,award = 30},	--award = 30  金币数量为30
                                                        --scale = 3.0,  近战走到屏幕最近放缩比例

	--忍者兵            冲锋伤害  type = "renzhe",
	{id=17,image="xiaorz",demage=12,hp=30000,walkRate=100,walkCd = 1.0,rollRate=40, rollCd = 1.5,fireRate=180, fireCd=3.0, 
	shanRate = 120, shanCd = 4, chongRate = 120, chongCd = 4, weak1=2},	

	--飞镖
	{id=18,image="feibiao",demage=12,hp=3000}, 
	  
	
	-- 金武箱子奖励  type = "awardSan",
	{id=21,image="dl_xz",hp=1, weak1=1},	--金武箱子奖励                      
}



local mapId = "map_1_5"

local limit = 10   				--此关敌人上限

function waveClass:ctor()
	self.waves  = waves
	self.enemys = enemys
	self.bosses = bosses
	self.mapId  = mapId
	self.fightMode =  {
		type 	  = "puTong",

		-- type 	  = "renZhi",
		-- saveNums  = 4,                 --解救人质数量

		-- type 	  = "xianShi",
		-- limitTime = 60,                   --限时模式时长

		-- type 	  = "taoFan"
		-- limitNums = 5,                      --逃跑逃犯数量
	}
end
return waveClass