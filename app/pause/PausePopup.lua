
local dir = "res/help/bangzhu/"
local postfix = ".ExportJson"
local config = {}

config["mapset"]      = dir.."homeSet"..postfix
config["fightset"]    = dir.."fightSet"..postfix

local PausePopup = class("PausePopup",function()
	return display.newLayer()
end)

local director = cc.Director:getInstance()

function PausePopup:ctor(properties)
	self.popupName = properties.popupName
	self:loadCCS()
	self:initButtons()
end

function PausePopup:loadCCS()
	local pauseNode = cc.uiloader:load(config[self.popupName])
	self:addChild(pauseNode) 
end

function PausePopup:initButtons()
	local gameContinueBtn = cc.uiloader:seekNodeByName(self, "Panel_GameContinue")
	gameContinueBtn:setTouchEnabled(true)
	addBtnEventListener(gameContinueBtn, function( event )
		if event.name == 'began' then
			return true
		elseif event.name == 'ended' then 
			-- ui:closePopup("PausePopup")
			director:popScene()

			-- director:resume()
			assert("gameContinue is pressed!")
		end
	end)

	local backBtn = cc.uiloader:seekNodeByName(self, "Panel_HomeBack")
	backBtn:setTouchEnabled(true)
	addBtnEventListener(backBtn, function( event )
		if event.name == 'began' then
			self:btnColor(backBtn, true)
			return true
		elseif event.name == 'ended' then
			if self.isChanging then return end 
			self.isChanging = true
			self:btnColor(backBtn, false)
			director:popScene()
			-- ui:closePopup("PausePopup")
			self:btnEvent()
			print("homeBackBtn is pressed!")
		end
	end)

	local musicClosedBtn = cc.uiloader:seekNodeByName(self, "Panel_MusicClosed")
	local musicplay = cc.uiloader:seekNodeByName(musicClosedBtn, "musicplay")
	local musicclose = cc.uiloader:seekNodeByName(musicClosedBtn, "musicclose")

	local isPlaying = audio.isMusicPlaying()
	if isPlaying then
		musicplay:setVisible(false)
		musicclose:setVisible(true)
	else
		musicplay:setVisible(true)
		musicclose:setVisible(false)
	end
	
	musicClosedBtn:setTouchEnabled(true)
	addBtnEventListener(musicClosedBtn, function( event )
		if event.name == 'began' then
			self:btnColor(musicClosedBtn, true)
			return true
		elseif event.name == 'ended' then 

		self:btnColor(musicClosedBtn, false)
			local isOpen = audio.isSwitchOpen()
			-- print("music is playing")
			isOpen = not isOpen
			musicplay:setVisible(isOpen)
			musicclose:setVisible(not isOpen)
			isPlaying = false
			audio.switchAllMusicAndSounds(isOpen)

			--save
		    local data = getUserData()
		    data.preference["isOpenMusic"] = isPlaying
		    setUserData(data)
			-- print("musicClosedBtn is pressed!")
		end
	end)

	local closeBtn = cc.uiloader:seekNodeByName(self, "Panel_Close")
	closeBtn:setTouchEnabled(true)
	addBtnEventListener(closeBtn, function( event )
		if event.name == 'began' then
			return true
		elseif event.name == 'ended' then
			director:popScene()
		end
	end)
end

function PausePopup:btnColor(btn,isPress)
	if isPress then 
		btn:setColor(cc.c3b(150, 150, 150))
	else 
		btn:setColor(cc.c3b(0, 0, 0))
	end

end

function PausePopup:btnEvent()
	if self.popupName == "mapset" then
		ui:changeLayer("StartLayer", {})

	elseif self.popupName == "fightset" then
		ui:changeLayer("HomeBarLayer",{})
        local fight  = md:getInstance("Fight")
        local groupid,levelid = fight:getCurGroupAndLevel()
        local levelInfo = groupid.."-"..levelid
        um:failLevel(levelInfo)
	end
end

return PausePopup