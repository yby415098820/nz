-- local JujiPlayerCell = import(".JujiPlayerCell")

local KillModeLayer = class("KillModeLayer", function()
    return display.newLayer()
end)

function KillModeLayer:ctor()
	-- self.jujiModel = md:getInstance("JujiModeModel")
	-- self.rankModel = md:getInstance("RankModel")
	-- self.userModel = md:getInstance("UserModel")
	-- self.inlayModel = md:getInstance("InlayModel")
	-- self.buyModel = md:getInstance("BuyModel")
	-- self.rankTable = self.jujiModel:getRankData() 

	self:loadCCS()
	-- self:initUI()

    -- cc.EventProxy.new(self.userModel, self)
	   --  :addEventListener(self.userModel.REFRESH_PLAYERNAME_EVENT,
	   --   handler(self, self.refreshUI))

	-- self:setNodeEventEnabled(true)
end

function KillModeLayer:onEnter()
	-- self:performWithDelay(handler(self,self.refreshListView),0.5)
	-- self:performWithDelay(handler(self,self.checkUserName),0.5)
end

function KillModeLayer:checkUserName()
	if  self.userModel:getUserName() == "玩家自己" then
		ui:showPopup("InputBoxPopup", 
			{content = "请输入游戏姓名",
			 onClickConfirm = handler(self, self.onClickConfirm_InputName)}, 
			 {opacity = 0})
	end
end

function KillModeLayer:onClickConfirm_InputName(event)
	dump(event, "event")
    local user = md:getInstance("UserModel")
	user:setUserName(event.inputString)
end

function KillModeLayer:loadCCS()
	cc.FileUtils:getInstance():addSearchPath("res/JujiMode/wuxianjuji")
    local controlNode = cc.uiloader:load("wujinshalu.json")
    self:addChild(controlNode)
end

function KillModeLayer:initUI()
    local src = "res/JujiMode/zhoujiangli/zhoujiangli.ExportJson"
    local manager = ccs.ArmatureDataManager:getInstance()
    manager:addArmatureFileInfo(src)
    local plist = "res/JujiMode/zhoujiangli/zhoujiangli0.plist"
    local png = "res/JujiMode/zhoujiangli/zhoujiangli0.png"
    display.addSpriteFrames(plist,png)

	self.listViewPlayer = cc.uiloader:seekNodeByName(self, "listViewPlayer")
	local btnBack = cc.uiloader:seekNodeByName(self, "btnBack")
	local btnReward = cc.uiloader:seekNodeByName(self, "raward")
	local btnStart = cc.uiloader:seekNodeByName(self, "start")
	local playerRank = cc.uiloader:seekNodeByName(self, "rank")
	self.playerName = cc.uiloader:seekNodeByName(self, "playerName")
	local playerPoint = cc.uiloader:seekNodeByName(self, "point")
	self.notiReward = cc.uiloader:seekNodeByName(self, "noti")

	local armature = ccs.Armature:create("zhoujiangli")
    armature:setPosition(cc.p(-100,0))
    btnReward:addChild(armature,100)
    armature:getAnimation():play("zhoujiangli" , -1, 1)

	local myselfRecord = self.rankModel:getUserRankData("jujiLevel")
	local myselfRank = self.rankModel:getUserRank()
	playerRank:setString(myselfRank)
	self.playerName:setString(myselfRecord["name"])
	playerPoint:setString(myselfRecord["jujiLevel"]*100 )

	btnBack:setTouchEnabled(true)
	addBtnEventListener(btnBack, function(event)
			if event.name == 'began' then
				return true
			elseif event.name == 'ended' then
				self:onClickBtnClose()
			end
		end)

    btnReward:onButtonPressed(function( event )
        event.target:runAction(cc.ScaleTo:create(0.05, 1.1))
    end)
    :onButtonRelease(function( event )
        event.target:runAction(cc.ScaleTo:create(0.1, 1))
    end)
    :onButtonClicked(function()
        self:onClickBtnReward()
    end)
    btnStart:onButtonPressed(function( event )
        event.target:runAction(cc.ScaleTo:create(0.05, 1.1))
    end)
    :onButtonRelease(function( event )
        event.target:runAction(cc.ScaleTo:create(0.1, 1))
    end)
    :onButtonClicked(function()
        self:onClickBtnStart()
    end)
end

function KillModeLayer:refreshUI(event)
	self.playerName:setString(self.userModel:getUserName())
end

function KillModeLayer:onClickBtnStart()
	local data = getUserData()
	local isDone = self.userModel:getUserLevel() >= 5
	if isDone and table.nums(data.inlay.inlayed) == 0 then
		ui:showPopup("commonPopup",
			 {type = "style5",
			 callfuncQuickInlay = handler(self,self.onClickQuickInlay),
			 callfuncGoldWeapon = handler(self,self.onClickGoldWeapon),
			 callfuncClose = handler(self,self.onClickCloseInlayNoti)})
	else
		self:startGame()
	end
end

function KillModeLayer:onClickGoldWeapon()
	function confirmPopGoldGift()
		self.inlayModel:equipAllInlays()
		self:startGame()
	end

	local goldweaponNum = self.inlayModel:getGoldWeaponNum()
	if goldweaponNum > 0 then
        self.inlayModel:equipAllInlays()
        self:startGame()	
	else
	    self.buyModel:showBuy("goldWeapon",{payDoneFunc = confirmPopGoldGift,
	    	deneyBuyFunc = handler(self, self.startGame)}, "Juji模式_提示未镶嵌点击单个黄武")
    end
end

function KillModeLayer:onClickQuickInlay()
	self.inlayModel:equipAllInlays()
	self:startGame()
end

function KillModeLayer:onClickCloseInlayNoti()
	self:startGame()
end
function KillModeLayer:startGame()
	local fightData = { groupId = 70,levelId = 4, fightType = "jujiFight"}  --无限狙击
	ui:changeLayer("FightPlayer", {fightData = fightData})	
	ui:closePopup("KillModeLayer")
end

function KillModeLayer:checkNetWork()
	local isAvailable = network.isInternetConnectionAvailable()
	if isAvailable then
		print("network isAvailable")
	else
		ui:showPopup("commonPopup",
			 {type = "style1",content = "当前网络连接失败，连接网络后排名数据将会统计"},
			 {opacity = 0})
	end	
end

function KillModeLayer:onClickBtnClose()
	self.listViewPlayer:setVisible(false)
	ui:closePopup("KillModeLayer")
end

function KillModeLayer:onClickBtnReward()
	print("KillModeLayer:onClickBtnReward()")
	self.notiReward:setVisible(false)
	ui:showPopup("JujiAwardPopup")
end

function KillModeLayer:refreshListView()
	--net
	self:checkNetWork()

	--list
    for i=1, 20 do
        local content = JujiPlayerCell.new({record = self.rankTable[i],rank = i})
        local item = self.listViewPlayer:newItem()
        item:addContent(content)
        item:setItemSize(392, 68)
        self.listViewPlayer:addItem(item)
    end
    self.listViewPlayer:reload()
end

return KillModeLayer