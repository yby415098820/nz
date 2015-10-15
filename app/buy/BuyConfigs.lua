local BuyConfigs = class("BuyConfigs", cc.mvc.ModelBase)

local dir = "res/GiftBag/GiftBag/GiftBag_"

--[[
	name:	 俗称
	iapName: 计费点名称
]]

local configs = {
	goldGiftBag    = {				--土豪金
			ccsPath = dir.."GoldGiftBag.json",
			showType = "gift",
			price = 30,
			name = LanguageManager.getStringForKey("string_hint25"),
	},
	goldGiftBag_dx    = {				--土豪金
			ccsPath = dir.."GoldGiftBag_dx.json",
			showType = "gift",
			price = 20,
			name = LanguageManager.getStringForKey("string_hint25"),
	},
	yijiaoBag     = {              --1角礼包
			ccsPath = dir.."YijiaoBag.json",
			showType = "gift",
			price = 0.1,
			name = LanguageManager.getStringForKey("string_hint26"),
	},
	novicesBag     = {              --新手礼包
			ccsPath = dir.."NovicesBag.json",
			showType = "gift",
			price = 1,
			name = LanguageManager.getStringForKey("string_hint27"),
	},
	weaponGiftBag  = {           --武器大礼包
			ccsPath = dir.."WeaponGiftBag.json",
			showType = "gift",
			price = 20,
			name = LanguageManager.getStringForKey("string_hint28"),
	},
	armedMecha     = {				--机甲
			showType = "prop_rmb",
			price = 4,
			name = LanguageManager.getStringForKey("string_hint29"),
			iapName = LanguageManager.getStringForKey("string_hint29"),
	},
	handGrenade    = {             --手雷
			showType = "prop_rmb",
			price = 4,
			name = LanguageManager.getStringForKey("string_hint30"),
			iapName = LanguageManager.getStringForKey("string_hint30"),
	},
	goldWeapon     = {				--金武
			showType = "prop_rmb",
			price = 4,
			name = LanguageManager.getStringForKey("string_hint31"),
			iapName = LanguageManager.getStringForKey("string_hint31"),
	},
	onceFull       = {				--一键满级
			showType = "prop_rmb",
			price = 2,
			name = LanguageManager.getStringForKey("string_hint32"),
			iapName = LanguageManager.getStringForKey("string_hint32"),
	},
	stone120         = {
			showType = "prop_rmb",
			price = 10,
			name = "120个宝石",
			iapName = "一麻袋宝石",
	},
	stone260         = {
			showType = "prop_rmb",
			price = 20,
			name = "260个宝石",
			iapName = "一箱子宝石",
	},
	stone450         = {
			showType = "prop_rmb",
			price = 30,
			name = "450个宝石",
			iapName = "堆成山的宝石",
	},
	stone600         = {
			showType = "prop_rmb",
			price = 60,
			name = "支付宝宝石",
			iapName = "支付宝宝石",
			iapType = "al",
	},
	stone900         = {
			showType = "prop_rmb",
			price = 90,
			name = "支付宝宝石",
			iapName = "支付宝宝石",
			iapType = "al",
	},
	stone1200        = {
			showType = "prop_rmb",
			price = 120,
			name = "支付宝宝石",
			iapName = "支付宝宝石",
			iapType = "al",
	},

	-- hpBag         = {
	-- 		showType = "prop_stone",
	-- 		price = 30,
	-- 		jsonName = hpBag
	-- 		name = "医疗包4个",
	-- 		iapId = "stone450",
	-- },
	-- weaponBuy      = {
	-- 		showType = "prop_stone",
	-- 		price = 30,
	-- 		jsonName = weaponBuy
	-- 		name = "武器解锁",
	-- 		iapId = "stone450",
	-- },
	-- relive   = {        		--复活
	-- 		showType = "prop_stone",
	-- 		jsonName = relive
	-- 		price = 2,
	-- 		name = "复活1次",
	-- },
}

function BuyConfigs.getConfig(name)
	-- dump(name, "name")
	assert(configs[name], "invalid name :"..name)
	return configs[name]
end

return BuyConfigs