local scheduler			 = require(cc.PACKAGE_NAME .. ".scheduler")
local FightResultLayer = class("FightResultLayer", function()
	return display.newLayer()
end)

function FightResultLayer:ctor(properties)
    self.fightResultModel = md:getInstance("FightResultModel")
    self.inlayModel 	  = md:getInstance("InlayModel")
    self.fightModel 	  = md:getInstance("Fight")
    self.levelMapModel    = md:getInstance("LevelMapModel")
    self.levelDetailModel = md:getInstance("LevelDetailModel")
	self.weaponListModel  = md:getInstance("WeaponListModel")
    self.commonPopModel = md:getInstance("commonPopModel")
    self.userModel = md:getInstance("UserModel")
	 cc.EventProxy.new(self.commonPopModel, self)
       :addEventListener(self.commonPopModel.BTN_CLICK_TRUE, handler(self, self.turnLeftCard))
       :addEventListener(self.commonPopModel.BTN_CLICK_FALSE, handler(self, self.close))

    self.isgold = false
    self.cardover = {}
    self.cardgold = {}
    self.cardnormal = {}
    self.cardtouch = {}
    self.cardicon = {}
    self.cardlabel = {}
    self.star = {}
    
    self.quickinlay = {}
    self.probaTable = {}
    self.showTable = {}

    local fightResult = self.fightModel:getFightResult()
    self.grade = self:getGrade(fightResult["hpPercent"])
    self.userModel:addMoney(fightResult["goldNum"])

    self:initData()
	self:loadCCS()
	self:initUI()
	
	self:playstar(self.grade)
	self:playcard(self.showTable)
	self:setNodeEventEnabled(true)
end

function FightResultLayer:loadCCS()
	cc.FileUtils:getInstance():addSearchPath("res/LevelDetail")
	local controlNode = cc.uiloader:load("guanqiapingjia.ExportJson")
    self.ui = controlNode
    self:addChild(controlNode)

    --anim
    local src = "res/FightResult/anim/guangkajl/guangkajl.csb"
    local starsrc = "res/FightResult/anim/gkjs_xing/gkjs_xing.csb"
    local manager = ccs.ArmatureDataManager:getInstance()
    manager:addArmatureFileInfo(src)
    manager:addArmatureFileInfo(starsrc)

    --play 发牌

end

function FightResultLayer:initData()
	self.probaTable = self:getinlayfall()
	for k,v in pairs(self.probaTable) do
		self.showTable[k] = v
	end
	table.insert(self.showTable,3,self.showTable[#self.showTable])
	table.remove(self.showTable,#self.showTable)
end
    
local playFanHander = nil
function FightResultLayer:playcard(showTable)
	--开牌 洗牌 扣牌
	local function playanim()
		self.armature:getAnimation():play("kaichixu" , -1, 1)
	end

	self.armature = ccs.Armature:create("guangkajl")	
    self.armature:setAnchorPoint(0.5,0.5)
    addChildCenter(self.armature, self.panelcard)
	self.armature:getAnimation():setMovementEventCallFunc(handler(self, self.animationEvent))	
	
	for k,v in pairs(showTable) do
		local randomRecordID = v.inlayid
		local inlayrecord = self.fightResultModel:getInlayrecordByID(randomRecordID)
		
		local skin = ccs.Skin:createWithSpriteFrameName(inlayrecord["imgname"]..".png")
	    self.armature:getBone("icon00"..k):addDisplay(skin, 1)
	    self.armature:getBone("icon00"..k):changeDisplayWithIndex(1, true)


		local node = cc.ui.UILabel.new({
        UILabelType = 2, text = inlayrecord["describe2"], size = 20})
		node:setAnchorPoint(cc.p(0.5,0.5))
 	    self.armature:getBone("label00"..k):addDisplay(node, 1)
	    self.armature:getBone("label00"..k):changeDisplayWithIndex(0, true)
	end

	playFanHander =  scheduler.performWithDelayGlobal(playanim, 2)
end

local playStarHandler = nil
function FightResultLayer:playstar(numStar)
	local posXinterval = 112
	for i=1,numStar do
		local delay = i * 0.5
		local function starcall()
		    local starArmature = ccs.Armature:create("gkjs_xing")
		    starArmature:setPosition(43.5,42)
		    self.star[i]:addChild(starArmature)
			starArmature:getAnimation():play("gkjs_xing" , -1, 0)
		end
		playStarHandler = scheduler.performWithDelayGlobal(starcall, delay)
	end
end

function FightResultLayer:initUI()
    self.btnreplay = cc.uiloader:seekNodeByName(self, "btnreplay")
    self.btnback = cc.uiloader:seekNodeByName(self, "btnback")
    self.btnnext = cc.uiloader:seekNodeByName(self, "btnnext")
    self.btninlay = cc.uiloader:seekNodeByName(self, "btninlay")
    self.leftnumber = cc.uiloader:seekNodeByName(self, "leftnumber")
    self.label = cc.uiloader:seekNodeByName(self, "label")
    self.panlsuipian = cc.uiloader:seekNodeByName(self, "panlsuipian")
    self.labelsuipian = cc.uiloader:seekNodeByName(self, "infoguanqia")
    self.inlayquick = cc.uiloader:seekNodeByName(self, "quickinlay")
    self.leftnumber:enableOutline(cc.c4b(0, 0, 0,255), 2)
    self.label:enableOutline(cc.c4b(0, 0, 0,255), 2)
    self.labelsuipian:enableOutline(cc.c4b(0, 0, 0,255), 2)
	self.inlayquick:enableOutline(cc.c4b(0, 0, 0,255), 2)
	
    self.leftnumber:setVisible(false)
    self.label:setVisible(false)

	self.btninlay:setTouchEnabled(false)
	self.btnreplay:setTouchEnabled(false)
	self.btnback:setTouchEnabled(false)
	self.btnnext:setTouchEnabled(false)

	local curGroup, curLevel = self.fightModel:getCurGroupAndLevel()
	addBtnEventListener(self.btnback, function(event)
        if event.name=='began' then
            return true
        elseif event.name=='ended' then		
        	ui:changeLayer("HomeBarLayer",{})
        end
    end)
    addBtnEventListener(self.btnreplay, function(event)
        if event.name=='began' then
            return true
        elseif event.name=='ended' then
        	ui:changeLayer("FightPlayer",{groupId = curGroup, 
	 			levelId = curLevel})
        end
    end)
    addBtnEventListener(self.btnnext, function(event)
        if event.name=='began' then
            return true
        elseif event.name=='ended' then
	        if self.levelMapModel:getNextGroupAndLevel(curGroup,curLevel) == false then
	        	self.btnnext:setVisible(false)
	        else
		        local nextgroup,nextlevel = self.levelMapModel:getNextGroupAndLevel(curGroup,curLevel)
		        ui:changeLayer("HomeBarLayer",{})
		        self.fightResultModel:popupleveldetail(nextgroup,nextlevel)
	        end
        end
    end)
    addBtnEventListener(self.btninlay, function(event)
        if event.name=='began' then
            return true
        elseif event.name=='ended' then
        ui:showPopup("commonPopup",
			 {type = "style2", content = "镶嵌成功"},
			 {opacity = 155})
        	self:quickInlay()
        end
    end)
    self.card = {}
    for i=1,6 do
    	self.card[i] = cc.uiloader:seekNodeByName(self, "card"..i)
    	self.card[i]:setTouchEnabled(true)
    	self.card[i]:setVisible(false)
    	self.card[i]:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
            if event.name=='began' then                
                return true
            elseif event.name=='ended' then
            dump(self.grade)
	            if self.grade > 1 then
		            self:turnOverCard(i)
		        elseif self.grade == 1 then
		            self:turnOverCard(i)
				    self.leftnumber:setVisible(false)
				    self.label:setVisible(false)
        		elseif self.grade < 1 then
				    self.leftnumber:setVisible(false)
				    self.label:setVisible(false)

				    ui:showPopup("commonPopup",
					 {type = "style1",content = "是否花费10颗钻石翻开剩余卡牌"},
					 {opacity = 155})
            	end
            end
        end)
    end

    for i=1,6 do
    	self.cardgold[i] = cc.uiloader:seekNodeByName(self, "cardgold"..i)
    	self.cardnormal[i] = cc.uiloader:seekNodeByName(self, "cardnormal"..i)
    	self.cardover[i] = cc.uiloader:seekNodeByName(self, "cardover"..i)
    	self.cardicon[i] = cc.uiloader:seekNodeByName(self, "icon"..i)
    	self.cardlabel[i] = cc.uiloader:seekNodeByName(self, "labelcard"..i)
    	self.cardover[i]:setVisible(false)
    end
    for i=1,5 do
    	self.star[i] = cc.uiloader:seekNodeByName(self, "panelstar"..i)
	end
	self.panelcard = cc.uiloader:seekNodeByName(self, "panelcard")

	local curRecord = self.levelDetailModel:getConfig(curGroup, curLevel)
	local isWeaponAlreadyTogether = self.weaponListModel:isWeaponExist(curRecord["suipianid"])
	if curRecord["type"] == "boss" and isWeaponAlreadyTogether == false then
	    self.levelDetailModel:setsuipian(curRecord["suipianid"])
		self.panlsuipian:setVisible(true)
		local name = self.weaponListModel:getWeaponNameByID(curRecord["suipianid"])
		self.labelsuipian:setString("Boss关卡固定掉落"..name.."零件1个")
	else
		self.panlsuipian:setVisible(false)
	end
end

function FightResultLayer:animationEvent(armatureBack,movementType,movementID)
	if movementType == ccs.MovementEventType.loopComplete then
		armatureBack:stopAllActions()
		if movementID == "kaichixu" then
				armatureBack:stopAllActions()
				armatureBack:getAnimation():play("koupai" , -1, 1)
    	elseif movementID == "fouchixu" then

    	elseif movementID == "koupai" then
    		armatureBack:getAnimation():play("xipai",-1,1)
		elseif movementID == "xipai" then
			self.armature:removeFromParent()
			for k,v in pairs(self.card) do
				v:setVisible(true)
			end
			self.leftnumber:setVisible(true)
			self.label:setVisible(true)
			self.leftnumber:setString(self.grade)
			self.btnreplay:setTouchEnabled(true)
			self.btnback:setTouchEnabled(true)
			self.btnnext:setTouchEnabled(true)
			self.btninlay:setTouchEnabled(true)

			local ran = math.random(1, 100)
			if ran < 5 then
				self.isgold = true
			end
		end
	end
end

function FightResultLayer:getGrade(LeftPersent)
	if LeftPersent < 0.2 then
		return 1
	elseif LeftPersent < 0.4 then
		return 2
	elseif LeftPersent < 0.6 then
		return 3
	elseif LeftPersent < 0.95 then
		return 4
	else
		return 5
	end
end

function FightResultLayer:getinlayfall()
	math.randomseed(os.time())
	
	local probaTable = {}
    local config = getConfig("config/inlayfall.json")

	for i=1,5 do
		local ran = math.random( 100)
		local total = 0
		for k,v in pairs(config) do
			total = total + v["probability"]
			if total >= ran then
				table.insert(probaTable,{inlayid = v["inlayid"]})
				break
			end
		end
	end

	local rans = math.random(100)
	local table = getRecordByKey("config/inlayfall.json","type","special")
	local totals = 0
	for k,v in pairs(table) do
		totals = totals + v["probability"]
		if totals >= rans then
			probaTable[6]={inlayid = v["inlayid"]}
			break
		end
	end
    return probaTable
end

function FightResultLayer:turnOverCard(index)
	self.grade = self.grade - 1
	self.leftnumber:setString(self.grade)
	local ran = math.random(1, self.grade+1)
	local record
	print("金的"..ran.."区间1~"..self.grade+1)
	if ran == 1 and self.isgold == true then
		
		record = self:getRanRecord(#self.probaTable)
	else
		local ran = math.random(1, #self.probaTable-1)
		record = self:getRanRecord(ran)
	end
	self.card[index]:setTouchEnabled(false)
	transition.scaleTo(self.card[index], {scaleX = 0, time = 0.2})
	self.cardover[index]:setVisible(true)


	if record["property"] == 4 then
		self.cardnormal[index]:setVisible(false)
		self.cardgold[index]:setVisible(true)		
	else
		self.cardgold[index]:setVisible(false)
		self.cardnormal[index]:setVisible(true)
	end

	self.cardover[index]:setScaleX(0)
	self.cardlabel[index]:setString(record["describe2"])
	local icon = display.newSprite("#"..record["imgname"]..".png")
	addChildCenter(icon, self.cardicon[index]) 
	local sequence = transition.sequence({cc.ScaleTo:create(0.2,0,1),cc.ScaleTo:create(0.2,1,1)})
	self.cardover[index]:runAction(sequence)

end

function FightResultLayer:getRanRecord( ran )
	local randomRecord = self.probaTable[ran]
	local randomRecordID = randomRecord["inlayid"]
	local inlayrecord = self.fightResultModel:getInlayrecordByID(randomRecordID)
	record = inlayrecord
	table.insert(self.quickinlay, {inlayid = inlayrecord["id"]})
	self.inlayModel:buyInlay(inlayrecord["id"])
	table.remove(self.probaTable,ran)
	return record
end

function FightResultLayer:turnLeftCard()
    if device.platform == "android" then
        cc.UMAnalytics:buy("fanpai", 1, 10)   
    end 

	ui:closePopup("commonPopup")
	if self.userModel:costDiamond(10) then
		function delayturnleft()
			for i=1,6 do
				if self.cardover[i]:isVisible() == false then
					self:turnOverCard(i)
				end
			end
		end
		scheduler.performWithDelayGlobal(delayturnleft, 0.3)
	end
end

function FightResultLayer:close( )
	ui:closePopup("commonPopup")
end

function FightResultLayer:quickInlay()
	self.inlayModel:equipAllBestInlays(self.quickinlay)
end

function FightResultLayer:onExit()
	if playFanHander then 
		scheduler.unscheduleGlobal(playFanHander)
	end

	if playStarHandler then 
		scheduler.unscheduleGlobal(playStarHandler)
	end	
end

return FightResultLayer