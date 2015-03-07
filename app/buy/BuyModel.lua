
--[[
“购买”的实体

]]
local BuyConfigs = import(".BuyConfigs")
local BuyModel = class("BuyModel", cc.mvc.ModelBase)

-- 定义事件


function BuyModel:ctor(properties)
    BuyModel.super.ctor(self, properties) 
	
	--instance
	-- self:buy("weaponGiftBag", {a=1})
end

--
function BuyModel:clearData()
    self.curId = nil
    self.curBuydata =  nil
    self.orderId = nil
end

function BuyModel:buy(configid, buydata, strDesc)
	assert(strDesc, "strDesc is nil configid :"..configid)
	-- local name = configName .. "__" .. strDesc
	-- um:..
	self:clearData()
    self.curId = configid
    self.curBuydata =  buydata

    -- TalkingData支付统计
    self.orderId = self:getRandomOrderId()
    local buyConfig = BuyConfigs.getConfig(configid) 
    print("点击付费点:".. buyConfig.name.." 位置:" .. strDesc)
    local name = buyConfig.name .. "__" ..strDesc
    --todo 价格
    um:onChargeRequest(self.orderId, name, buyConfig.price, "CNY", 0, "MM")

	local config  = BuyConfigs.getConfig(configid)
	local isGift = config.isGift --todo
	self.isFight = buydata.isFight

	if isGift then
        ui:showPopup("GiftBagPopup",{popupName = configid})
    else
    	--mm
    	iap:pay(configid)
    end
end

-- 生成订单号
function BuyModel:getRandomOrderId()
	local deviceId = "windows"
	if device.platform == "android" then 
		deviceId = TalkingDataGA:getDeviceId()
	end
	local osTime = os.time()
	local seed = math.random(1, osTime)
	local id = deviceId.."_"..osTime.."_"..seed
	return id
end

function BuyModel:payDone(result)
	print("function BuyModel:payDone():"..self.curId)
	local funcStr = "buy_"..self.curId
	self[funcStr](self, self.curBuydata)

	-- TalkingData 支付成功标志
	um:onChargeSuccess(self.orderId)

	-- dump(self.curBuydata, "self.curBuydata")
	local payDoneFunc = self.curBuydata.payDoneFunc
	if payDoneFunc then payDoneFunc() end
end

function BuyModel:deneyPay()
	local deneyBuyFunc = self.curBuydata.deneyBuyFunc
	if deneyBuyFunc then  deneyBuyFunc() end
end

function BuyModel:buy_weaponGiftBag(buydata)
	local weaponListModel = md:getInstance("WeaponListModel")
	local inlayModel = md:getInstance("InlayModel")
	local storeModel = md:getInstance("StoreModel")
	-- local weapontable = weaponListModel:getAllWeapon()
	local propModel = md:getInstance("propModel")
	local weapontable = {3,4,5,7,8}
	for k,v in pairs(weapontable) do
		weaponListModel:buyWeapon(v)
		weaponListModel:onceFull(v)
	end
	self:setBought("weaponGiftBag")

	--黄武*3
	inlayModel:buyGoldsInlay(3)
    inlayModel:refreshInfo("speed")


	--手雷*10
	propModel:buyProp("lei",10)
	storeModel:refreshInfo("prop")
end

function BuyModel:buy_novicesBag( buydata )
	print("BuyModel:buy_novicesBag(buydata)")
	local inlayModel = md:getInstance("InlayModel")
	local storeModel = md:getInstance("StoreModel")
	local propModel = md:getInstance("propModel")
	local userModel = md:getInstance("UserModel")
	--黄武*4
	inlayModel:buyGoldsInlay(4)
    inlayModel:refreshInfo("speed")
	--机甲*3
	propModel:buyProp("jijia",3)
	--手雷*10
	propModel:buyProp("lei",10)
	--金币*188888
	userModel:addMoney(188888)
	storeModel:refreshInfo("prop")
	self:setBought("novicesBag")
end

function BuyModel:buy_goldGiftBag( buydata )
	print("BuyModel:buy_goldGiftBag(buydata)")
	local inlayModel = md:getInstance("InlayModel")
	local storeModel = md:getInstance("StoreModel")
	local propModel = md:getInstance("propModel")
	--黄武*15
	inlayModel:buyGoldsInlay(15)
    inlayModel:refreshInfo("speed")

	--机甲*15
	propModel:buyProp("jijia",15)
	--手雷*30
	propModel:buyProp("lei",30)
	storeModel:refreshInfo("prop")
end

function BuyModel:buy_changshuang( buydata )
	local inlayModel = md:getInstance("InlayModel")
	local storeModel = md:getInstance("StoreModel")
	local propModel = md:getInstance("propModel")
	--黄武*4
	inlayModel:buyGoldsInlay(4)
    inlayModel:refreshInfo("speed")
	--机甲*3
	propModel:buyProp("jijia",3)
	--手雷*10
	propModel:buyProp("lei",10)
	storeModel:refreshInfo("prop")
end

function BuyModel:buy_timeGiftBag( buydata )
	local inlayModel = md:getInstance("InlayModel")
	local storeModel = md:getInstance("StoreModel")
	local propModel = md:getInstance("propModel")
	local userModel = md:getInstance("UserModel")
	--黄武*4
	inlayModel:buyGoldsInlay(4)
    inlayModel:refreshInfo("speed")
	--机甲*3
	propModel:buyProp("jijia",3)
	--手雷*10
	propModel:buyProp("lei",10)
	--金币*188888
	--zuanshi*260
	userModel:buyDiamond(260)
	userModel:addMoney(188888)
	storeModel:refreshInfo("prop")
end

function BuyModel:buy_handGrenade( buydata )
	local propModel = md:getInstance("propModel")
	local storeModel = md:getInstance("StoreModel")
	--手雷*20
	propModel:buyProp("lei",20)
	storeModel:refreshInfo("prop")
end

function BuyModel:buy_armedMecha( buydata )
	local propModel = md:getInstance("propModel")
	local storeModel = md:getInstance("StoreModel")
	--jijia*2
	propModel:buyProp("jijia",2)
	storeModel:refreshInfo("prop")
end

function BuyModel:buy_unlockWeapon( buydata )
	print("BuyModel:buy_unlockWeapon( buydata )")
	local weaponListModel = md:getInstance("WeaponListModel")
	weaponListModel:buyWeapon(buydata.weaponid)
end

function BuyModel:buy_goldWeapon( buydata )
	print("BuyModel:buy_goldWeapon( buydata )")
	--黄武*2
	local inlayModel = md:getInstance("InlayModel")
	local storeModel = md:getInstance("StoreModel")
	local propModel = md:getInstance("propModel")
	inlayModel:buyGoldsInlay(2)
	inlayModel:refreshInfo("speed")
	storeModel:refreshInfo("prop")
end

function BuyModel:buy_onceFull( buydata )
	local weaponListModel = md:getInstance("WeaponListModel")
	weaponListModel:onceFull(buydata.weaponid)
end

function BuyModel:buy_resurrection( buydata )
	print("BuyModel:buy_resurrection( buydata )")
	--yby todo
end

function BuyModel:buy_stone10( buydata )
	local userModel = md:getInstance("UserModel")
	userModel:buyDiamond(10)
end
function BuyModel:buy_stone45( buydata )
	local userModel = md:getInstance("UserModel")
	userModel:buyDiamond(45)
end
function BuyModel:buy_stone120( buydata )
	local userModel = md:getInstance("UserModel")
	userModel:buyDiamond(120)
end
function BuyModel:buy_stone260( buydata )
	local userModel = md:getInstance("UserModel")
	userModel:buyDiamond(260)
end
function BuyModel:buy_stone450( buydata )
	local userModel = md:getInstance("UserModel")
	userModel:buyDiamond(450)
end

function BuyModel:checkBought(giftId)
	local data = getUserData()
	local isDone = data.giftBag[giftId] 
	return isDone
end

function BuyModel:setBought(giftId)
	local data = getUserData()
	data.giftBag[giftId] = true
	setUserData(data)
end

return BuyModel