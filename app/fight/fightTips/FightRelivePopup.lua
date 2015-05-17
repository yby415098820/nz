
--[[--

“复活提示”的视图

]]

local FightRelivePopup = class("FightRelivePopup", function()
    return display.newLayer()
end)

function FightRelivePopup:ctor(property)
	--instance
	self.property = property
	self.buyModel = md:getInstance("BuyModel")
    self:loadCCS()
    self:setNodeEventEnabled(true) 
end

function FightRelivePopup:onEnter()
	self:onShow()
end

function FightRelivePopup:loadCCS()
    local manager = ccs.ArmatureDataManager:getInstance() 
	self.node = cc.uiloader:load("res/fight/fightLayer/fightTips/relive.ExportJson")
    self:addChild(self.node)    

    --btns
    local btn_relive = cc.uiloader:seekNodeByName(self.node, "btn_relive")
    btn_relive:onButtonClicked(function()
         self:onClickRelive()
    end)
    local btn_giveUp = cc.uiloader:seekNodeByName(self.node, "btn_giveUp")
    btn_giveUp:onButtonClicked(function()
         self:onClickGiveUp()
    end)
end

function FightRelivePopup:buyReliveByStone()
	local cost = self:getReliveCost()
	local user = md:getInstance("UserModel")
    local isAfforded = user:costDiamond(cost) 
    if isAfforded then
		self.property["onReliveFunc"]()
		self:closePopup()
		ui:closePopup("StoneBuyPopup")
        return true
    else
        return false
    end		
end

function FightRelivePopup:onClickRelive()
	self:pause()
    --
	local price = self:getReliveCost()
    local function onClickConfirm()
        if self:buyReliveByStone() then 

        else 
            local strPos  =  "战斗界面_点击钻石复活"
            self.buyModel:showBuy("stone450", 
        	{payDoneFunc = handler(self, self.buyReliveByStone)}, 
        	strPos)
        end
    end

    ui:showPopup("StoneBuyPopup",
         {type = "relive", 
         price = price,
         jsonName = "relive",
         onClickConfirm = onClickConfirm},
         {animName = "moveDown", opacity = 150})    
end

function FightRelivePopup:onClickGiveUp()
	print("function FightRelivePopup:onClickGiveUp()")	
	self.property["onGiveUpFunc"]()
	self:closePopup()
end

function FightRelivePopup:onShow()
	local remainTimes = 5
	local labelTime = cc.uiloader:seekNodeByName(self.node, "labelTime")
	local labelCost = cc.uiloader:seekNodeByName(self.node, "labelNumCost")
	
	--cost
	local cost = self:getReliveCost()
	labelCost:setString(cost)

	--time
	labelTime:setString(remainTimes)
	local function timeFunc()
		remainTimes = remainTimes - 1
		if remainTimes == 0 then 
			self:onClickGiveUp()
			return
		end
		labelTime:setString(remainTimes)
	end
	self:schedule(timeFunc, 1.0)
end

function FightRelivePopup:getReliveCost()
	local fightFactory = md:getInstance("FightFactory")
	local fight        = fightFactory:getFight()
	return fight:getReliveCost()
end

function FightRelivePopup:closePopup()
	ui:closePopup("FightRelivePopup", {animName = "normal"})
end

function FightRelivePopup:pause(event)
	transition.pauseTarget(self)
end

return FightRelivePopup