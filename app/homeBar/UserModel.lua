--import
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
local UserModel = class("UserModel", cc.mvc.ModelBase)

function UserModel:ctor(properties)
	UserModel.super.ctor(self, properties)
	self.LevelMapModel = md:getInstance("LevelMapModel")
	self.buyModel      = md:getInstance("BuyModel")
	self:addComponent("components.behavior.EventProtocol"):exportMethods()
end

function UserModel:panelAction()
	self:dispatchEvent({name = "HOMEBAR_ACTION_UP_EVENT"})
end
function UserModel:getMoney(  )
	local data = getUserData()
	 return data.money
end

 function UserModel:getDiamond(  )
	local data = getUserData()
	 return data.diamond
end

 function UserModel:costMoney(money)
	local data = getUserData()
	if data.money >= money then
		data.money = data.money - money
		setUserData(data)
		self:dispatchEvent({name = "REFRESH_MONEY_EVENT"})
		return true
	else
		ui:showPopup("commonPopup",
				 {type = "style2", content = "金币不足，请去无限狙击获取"},
				 {opacity = 155})
		return false
	end
end

function UserModel:costDiamond(diamond, isBuy, strPos)
	local strBuy = "stone260"
	isBuy = isBuy or false
	strPos = strPos or "宝石不足"
	local data = getUserData()
	if data.diamond >= diamond then
		data.diamond = data.diamond - diamond 
		setUserData(data)
		self:dispatchEvent({name = "REFRESH_MONEY_EVENT"})
		return true
	else
		if isBuy then 
			print("宝石不足请购买！")
			ui:showPopup("BuyTipsPopup", {type = "boneLess"}, {animName = "normal"})
			local function delayCall( )
				self.buyModel:showBuy(strBuy, {isNotPopKefu = true}, strPos)
			end
			scheduler.performWithDelayGlobal(delayCall, 1.0)
			
		end
		return false
	end
end

 function UserModel:addDiamond(diamond, isBuy)
 	if diamond <= 0 then return end
	local data = getUserData()
	data.diamond = data.diamond + diamond
	setUserData(data)
	self:dispatchEvent({name = "REFRESH_MONEY_EVENT"})
	if isBuy then 
		print("宝石购买成功")
		ui:showPopup("BuyTipsPopup", {type = "boneBuyed"}, {animName = "normal"})
	end	
end

 function UserModel:addMoney(money)
 	if money == nil or money <= 0 then return end
	local data = getUserData()
	data.money = data.money + money
	setUserData(data)
	self:dispatchEvent({name = "REFRESH_MONEY_EVENT"})
end

function UserModel:setUserLevel(level)
	--check
	local data = getUserData()
	local curLevel = data.user.level 
	-- assert(level >= curLevel and level < curLevel + 2, "invalid level : " .. level)
	if level ~= curLevel + 1 then 
		print("等级异常: 当前等级:" .. curLevel .. "目标等级:" .. level)
	end
	
	--save
	if data.user.level == level then return end
	data.user.level = level
	setUserData(data)

	--um
	um:setLevel(level)	
end

function UserModel:getUserLevel()
	local data = getUserData()
	local curLevel = data.user.level 
	return curLevel 
end

function UserModel:getLoginTime()
	local data = getUserData()
	local loginTime = data.dailylogin.loginTime
	return loginTime
end

function UserModel:getRegisterTime()
	local data = getUserData()
	local registerTime = data.dailylogin.registTime
	return registerTime 
end

function UserModel:getUserName()
	local data = getUserData()
	return data.user.userName
end

function UserModel:setUserName(nameString)
	local data = getUserData()
	data.user.userName = nameString
	setUserData(data)
	self:dispatchEvent({name = "REFRESH_PLAYERNAME_EVENT"})
end

return UserModel