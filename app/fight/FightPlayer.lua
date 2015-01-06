--import
import("..includes.functionUtils")
local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")
local DialogLayer   = import("..dialog.DialogLayer")
local FightDescLayer = import(".fightDesc.FightDescLayer")
local GunView       = import(".GunView")
local FocusView     = import(".FocusView")
local MapView       = import(".MapView")
local HeroLayer      = import(".HeroLayer")
local InfoLayer      = import(".InfoLayer")

local KFightConfig = {
    scaleMoveBg = 1.0, 
    scaleMoveFocus = 2.3,
    scaleMoveGun = 2.3, 
}

local FightPlayer = class("FightPlayer", function ()
	return display.newLayer()
end)

--定义事件

function FightPlayer:ctor(properties)
    --instance
    print("FightPlayer:ctor(properties)")
    self.fight      = md:getInstance("Fight")
    self.fight:refreshData()
    self.fight:beginFight(properties)
    self.hero       = md:getInstance("Hero")
    self.guide      = md:getInstance("Guide")
    self.dialog     = md:getInstance("DialogModel")

    self.defence    = md:getInstance("Defence")
    self.inlay      = md:getInstance("FightInlay")

    --views
    self.focusView      = FocusView.new()
    self.mapView        = MapView.new()
    self.gunView        = GunView.new()
    self.heroLayer      = HeroLayer.new()
    self.infoLayer      = InfoLayer.new() 
    self.touchIds       = {} --todo
    self.isControlVisible = true
    --ui
    self:initUI()

    --事件
    self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, handler(self, self.tick))
    cc.EventProxy.new(self.hero, self)
        
        :addEventListener(self.hero.KILL_EVENT, handler(self, self.onHeroKill))
        :addEventListener("changeGold", handler(self, self.changeGoldCount)) 
    
    cc.EventProxy.new(self.fight, self)
        :addEventListener(self.fight.PAUSE_SWITCH_EVENT, handler(self, self.setPause))
        :addEventListener(self.fight.CONTROL_HIDE_EVENT, handler(self, self.hideControl))
        :addEventListener(self.fight.CONTROL_SHOW_EVENT, handler(self, self.showControl))
        :addEventListener(self.fight.CONTROL_SET_EVENT,  handler(self, self.setComponentVisible))
        :addEventListener(self.fight.RESULT_WIN_EVENT,  handler(self, self.onResultWin))
        :addEventListener(self.fight.RESULT_FAIL_EVENT, handler(self, self.onResultFail))

    
    cc.EventProxy.new(self.defence, self)
        :addEventListener(self.defence.DEFENCE_BEHURTED_EVENT, handler(self, self.onDefenceBeHurt))
        :addEventListener(self.defence.DEFENCE_BROKEN_EVENT, handler(self, self.startDefenceResume))
    
    self:scheduleUpdate()
    self:setNodeEventEnabled(true)
    
end

function FightPlayer:setPause(event)
    local isPause = event.isPause
    local layerTouch = cc.uiloader:seekNodeByName(self, "layerTouch")
    layerTouch:setTouchEnabled(not isPause)  
end

local tempChangeGoldHandler = nil
local curGold = 0
function FightPlayer:changeGoldCount(event)
    local totolGold = event.goldCount
    local function changeGold()
        if curGold < totolGold then
            curGold = curGold + 1
            self.labelGold:setString(curGold)
        else
            if tempChangeGoldHandler then
                scheduler.unscheduleGlobal(tempChangeGoldHandler)
                tempChangeGoldHandler = nil
            end
        end
    end
    if tempChangeGoldHandler then
        scheduler.unscheduleGlobal(tempChangeGoldHandler)
    end
    tempChangeGoldHandler = scheduler.scheduleGlobal(changeGold, 0.01)
end

function FightPlayer:onClickRobot()
    local robot = md:getInstance("Robot")
    robot:startRobot()
end

function FightPlayer:showControl(event)
    self.isControlVisible = true
    --gun
    self.layerGun:setVisible(true)
    
    --btn
    self.btnDefence:setVisible(true)
    self.btnRobot:setVisible(true)
    self.btnChange:setVisible(true)
    self.btnLei:setVisible(true)
end

function FightPlayer:hideControl(event)
    self.isControlVisible = false
    --gun
    self.layerGun:setVisible(false)
    
    --btn
    self.btnDefence:setVisible(false)
    self.btnChange:setVisible(false)
    self.btnLei:setVisible(false)
end

function FightPlayer:setComponentVisible(event)
    local comps = event.comps
    dump(comps, "comps")
    for i,v in pairs(comps) do
        self[i]:setVisible(v)
        print(i,v)
    end
end

function FightPlayer:initUI()
    --load fightUI  
    cc.FileUtils:getInstance():addSearchPath("res/Fight/fightLayer/ui")
    local node = cc.uiloader:load("mainUI.ExportJson")

    self.ui = node
    self:addChild(node)

    --load map layerMap
    self.layerMap = cc.uiloader:seekNodeByName(self, "layerMap")
    addChildCenter(self.mapView, self.layerMap) 

    --gold
    self.labelGold = cc.uiloader:seekNodeByName(self, "labelGoldCount")

    --load gun 
    self.layerGun = cc.uiloader:seekNodeByName(self, "layerGun")
    self.layerGun:addChild(self.gunView)

    --load HeroLayer
    local layerHero = cc.uiloader:seekNodeByName(self, "layerHero")
    addChildCenter(self.heroLayer, layerHero)
    self.heroLayer:setPosition(0, 0)

    --load layerGunInfo
    local layerGunInfo = cc.uiloader:seekNodeByName(self, "layerGunInfo")
    addChildCenter(self.infoLayer, layerGunInfo)
    self.infoLayer:setPosition(0, 0)

    --load focus
    self.focusNode = cc.uiloader:seekNodeByName(self, "fucusNode")
    addChildCenter(self.focusView, self.focusNode)

    --touch area
    self:initTouchArea()

    --dialogy
    local dialogLayer = DialogLayer.new()
    local layerDialog = cc.uiloader:seekNodeByName(self, "layerDialog") 
    layerDialog:addChild(dialogLayer)

    --dialogy
    local fightDescLayer = FightDescLayer.new()
    local layerDialog = cc.uiloader:seekNodeByName(self, "layerDialog") 
    layerDialog:addChild(fightDescLayer)

    --guide
    scheduler.performWithDelayGlobal(handler(self, self.initGuide), 0.1)
end

--启动盾牌恢复
local resumeDefenceHandler = nil
function FightPlayer:startDefenceResume(event)
    print("function FightPlayer:startDefenceResume(event)")
    self.labelDefenceResume:setVisible(true)
    
    --受伤
    self.defenceDemage:setPercent(0)

    --恢复
    self.defenceBar:setVisible(true)

    local kResumeValue = 1  --每次恢复点数
    local function tick(dt)
        local t = self.defenceBar:getPercentage()
        local t1 = tonumber(self.labelDefenceResume:getString())
        if 0 == t1 then
            print("盾牌恢复成功")
            scheduler.unscheduleGlobal(resumeDefenceHandler)
            self.defenceBar:setVisible(false)
            self.labelDefenceResume:setVisible(false)
            self.labelDefenceResume:setString(90)
            self.defence:setIsAble(true)
            
            return
        end
        self.labelDefenceResume:setString(t1 - kResumeValue)
        self.defenceBar:setPercentage(t - kResumeValue)
    end
    local cdTimes = define.cdTimes
    local percentTimes = cdTimes/100
    resumeDefenceHandler = scheduler.scheduleGlobal(tick, percentTimes)
end

function FightPlayer:onDefenceBeHurt(event)
    local percent = event.percent * 100
    -- print("percent,", percent)
    self.defenceDemage:setPercent(percent)
end

function FightPlayer:onHeroKill(event)
    --todo
    self:onCancelledFire()

    --fight 
    self.fight:onFail()
end

function FightPlayer:initTouchArea()
    --[[
    多点触摸:layerTouch为母层 包含btn
    ]]

	--control    
    local layerTouch = cc.uiloader:seekNodeByName(self, "layerTouch")
    layerTouch:setTouchEnabled(true)  
    layerTouch:setTouchMode(cc.TOUCH_MODE_ALL_AT_ONCE)

    --move区域
    self.layerControl = cc.uiloader:seekNodeByName(self, "layerControl")

    layerTouch:addNodeEventListener(cc.NODE_TOUCH_CAPTURE_EVENT, function(event)
        if event.name == "began" or event.name == "added" then
            self:onMutiTouchBegin(event)
        elseif event.name == "ended" or event.name == "cancelled" or event.name == "removed" then
            self:onMutiTouchEnd(event)
        elseif event.name == "moved" then 
            self:onTouchMoved(event)
        end
        return true
    end) 

    -- btn
    self:initBtns()
end

function FightPlayer:initDefence()
    --受伤
    --defence demage self.defenceDemage
    self.defenceDemage = cc.uiloader:seekNodeByName(self, "loadingBarDefenceHp")
    
    --恢复
    self.labelDefenceResume = cc.uiloader:seekNodeByName(self, "labelDefenceHp")
    self.labelDefenceResume:setVisible(false)

    self.defenceBar = display.newProgressTimer("#btn_dun03.png", display.PROGRESS_TIMER_RADIAL)
    self.btnDefence:addChild(self.defenceBar)
    self.defenceBar:setOpacity(130)
    self.defenceBar:setAnchorPoint(0.0,0.0)
    self.defenceBar:setReverseDirection(true)
    self.defenceBar:setScale(2)
    self.defenceBar:setPercentage(100)
    self.defenceBar:setVisible(false)
end

function FightPlayer:initBtns()
    --btnfire   
    self.btnFire = cc.uiloader:seekNodeByName(self, "btnFire")
    self.btnFire:setTouchEnabled(true)  
    self.btnFire:setTouchMode(cc.TOUCH_MODE_ALL_AT_ONCE)

    --btnChange
    self.btnChange = cc.uiloader:seekNodeByName(self, "btnChange")
    self.btnChange:setTouchEnabled(true)
    
    self.btnChange:setTouchMode(cc.TOUCH_MODE_ALL_AT_ONCE)

    --btnDefence
    self.btnDefence = cc.uiloader:seekNodeByName(self, "btnDun")
    self.btnDefence:setTouchEnabled(true)
    self.btnDefence:setTouchMode(cc.TOUCH_MODE_ALL_AT_ONCE)
    self:initDefence()

    --btnRobot
    self.btnRobot = cc.uiloader:seekNodeByName(self, "btnRobot")
    self.btnRobot:setTouchEnabled(true)
    self.btnRobot:setTouchMode(cc.TOUCH_MODE_ALL_AT_ONCE)

    --btnLei
    self.btnLei = cc.uiloader:seekNodeByName(self, "btnLei")
    self.btnLei:setTouchEnabled(true)
    self.btnLei:setTouchMode(cc.TOUCH_MODE_ALL_AT_ONCE)
    
    --btnJu
    self.btnJu = cc.uiloader:seekNodeByName(self, "btnJun")
    self.btnJu:setVisible(false)
    self.btnJu:setTouchEnabled(true)
    self.btnJu:setTouchMode(cc.TOUCH_MODE_ALL_AT_ONCE)

    --btnGold
    self.btnGold = cc.uiloader:seekNodeByName(self, "btnGold")
    self.btnGold:setTouchEnabled(true)
    self.btnGold:setTouchMode(cc.TOUCH_MODE_ALL_AT_ONCE)  

end

---- touch and btn----
function FightPlayer:onMutiTouchBegin(event)
     -- dump(event, "event onMutiTouchBegin")

    --check
    if event.points == nil then return false end
    for id, point in pairs(event.points) do
        local isTouch = self:checkBtnFire(id, point)
        if isTouch then return true end

        isTouch = self:checkBtnChange(point)
        if isTouch then return true end        

        isTouch = self:checkbtnRobot(point)
        if isTouch then return true end

        isTouch = self:checkbtnDefence(point)
        if isTouch then return true end 

        isTouch = self:checkBtnLei(point)
        if isTouch then return true end

        isTouch = self:checkBtnJu(point)
        if isTouch then return true end

        isTouch = self:checkBtnGold(point)
        if isTouch then return true end
      
    end
    return false
end

function FightPlayer:onMutiTouchEnd(event)
    for id,point in pairs(event.points) do
         self:checkBtnFire(id, point, event.name)
    end
end

function FightPlayer:checkbtnRobot(point)
    if not self.btnRobot:isVisible() then return end
    local rect = self.btnRobot:getCascadeBoundingBox()
    local isTouch = cc.rectContainsPoint(rect, point)
    if isTouch then
        addBtnEffect(self.btnRobot)
        self:onClickRobot()
    end
    return isTouch
end

function FightPlayer:checkbtnDefence(point)
    if not self.btnDefence:isVisible() then return end
    local rect = self.btnDefence:getCascadeBoundingBox()
    local isTouch = cc.rectContainsPoint(rect, point)
    if isTouch then
        addBtnEffect(self.btnDefence)
        self.defence:switchStatus()
    end
    return isTouch
end

function FightPlayer:checkBtnLei(point)
    if not self.btnLei:isVisible() then return end    
    local rect = self.btnLei:getCascadeBoundingBox()
    local isTouch = cc.rectContainsPoint(rect, point)
    if isTouch then
        addBtnEffect(self.btnLei)
        local w, h = self.focusNode:getCascadeBoundingBox().width, 
                self.focusNode:getCascadeBoundingBox().height
        local destPos = cc.p(self.focusNode:getPositionX(), 
            self.focusNode:getPositionY())
        self.hero:dispatchEvent({name = self.hero.SKILL_GRENADE_START_EVENT,throwPos = destPos})
    end
end

function FightPlayer:checkBtnChange(point)
    assert( point , "invalid params")
    if not self.btnChange:isVisible() then return end
    local rect = self.btnChange:getBoundingBox()      
    isTouch = cc.rectContainsPoint(rect, cc.p(point.x, point.y))     
    if isTouch then 
        --换枪
        addBtnEffect(self.btnChange)
        self.hero:changeGun()
    end    
    return isTouch    
end

function FightPlayer:checkBtnFire(id,point,eventName)
    local isTouch = false
    if eventName == "moved" then return false end
    if (eventName == "ended" or eventName == "cancelled" or eventName == "removed") then
        self:onCancelledFire()
    else
        local rect = self.btnFire:getBoundingBox()      
        isTouch = cc.rectContainsPoint(rect, cc.p(point.x, point.y))
        if isTouch then
            self.btnFireSch =  scheduler.scheduleGlobal(handler(self, self.onBtnFire), 0.05)
        end   
    end 
    return isTouch
end

function FightPlayer:onBtnFire()
    local robot = md:getInstance("Robot")
    local isRobot = robot:getIsRoboting()
    if  isRobot then
        if robot:isCoolDownDone() then
            self:robotFire()
        end
    else
        if self:isCoolDownDone() then 
            self:fire()
        end        
    end 

    --btn armature
    if self.btnArmature ~= nil then return end
    self.btnArmature = ccs.Armature:create("effect_gun_kaiqiang")
    self.btnArmature:getAnimation():playWithIndex(0 , -1, 1)
    local function animationEvent(armatureBack,movementType,movementID)
        if movementType == ccs.MovementEventType.loopComplete then
            self.btnArmature:removeFromParent()
            self.btnArmature = nil
        end
    end

    self.btnArmature:getAnimation():setMovementEventCallFunc(animationEvent)
    addChildCenter(self.btnArmature, self.btnFire)
end

function FightPlayer:onCancelledFire()
    -- print("FightPlayer:onCancelledFire()")
    local robot = md:getInstance("Robot")
    local isRobot = robot:getIsRoboting()
    if  isRobot then 
        robot:stopFire()
    else
        self.gunView:stopFire()
    end

    self.focusView:stopFire()

    --sch
    if self.btnFireSch then
        scheduler.unscheduleGlobal(self.btnFireSch)
        self.btnFireSch = nil
    end
end

function FightPlayer:checkBtnJu(point,eventName)
    if self.btnJu:isVisible() == false then return end 
    local rect = self.btnJu:getCascadeBoundingBox()  
    local isTouch = cc.rectContainsPoint(rect, cc.p(point.x, point.y))     
    if isTouch then 
        --切换狙击镜
        print("-----------switch ju")
        addBtnEffect(self.btnJu)
        self.hero:dispatchEvent({name = self.hero.GUN_SWITCH_JU_EVENT})
    end
    return isTouch
end

function FightPlayer:checkBtnGold(point, eventName)
    if self.btnGold:isVisible() == false then return end 
    local rect = self.btnGold:getCascadeBoundingBox()  
    local isTouch = cc.rectContainsPoint(rect, cc.p(point.x, point.y))     
    if isTouch then 
        print("点击黄金枪 购买")
        addBtnEffect(self.btnGold)
        self.inlay:activeGoldForever()
    end
    return isTouch    
end

function FightPlayer:onTouchMoved(event)
    local  x, y, prevX, prevY 
    for i,v in pairs(event.points) do
        local isBtnTouchPoint = false
        if not self.layerControl:getCascadeBoundingBox():containsPoint(cc.p(v.x, v.y)) then 
            isBtnTouchPoint = true
        end 
        if isBtnTouchPoint == false then 
            x, y, prevX, prevY = v.x, v.y, v.prevX, v.prevY
            local offsetX = x - prevX 
            local offsetY = y - prevY
            
            --处理瞄准
            self:moveFocus(offsetX, offsetY)
            
            --处理滑屏
            self:moveBgLayer(offsetX, offsetY)
        end
    end
end

----attack----
function FightPlayer:tick(dt)
    --gun
end

function FightPlayer:isCoolDownDone()
    if  self.hero:canFire() then 
        return true 
    end

    return false
end
 
function FightPlayer:fire()
    -- print("FightPlayer:fire()")
    local levelModel = md:getInstance("LevelDetailModel")
    local isJuLevel = levelModel:isJujiFight()
    local map = md:getInstance("Map")
    local isJu = map:getIsJu()
    if isJuLevel and not isJu then
        self.hero:dispatchEvent({name = self.hero.GUN_SWITCH_JU_EVENT})
        return 
    end
    local focusRangeNode = self.focusView:getFocusRange()

    --hero 控制cooldown
    self.hero:fire()

    --gun
    if  self.gunView:canShot() then  --todo
        self.gunView:fire()
        self.focusView:playFire()
        
        --todo 发命令
        self.hero:dispatchEvent({name = self.hero.GUN_FIRE_EVENT,focusRangeNode = focusRangeNode})
    end
end
 
function FightPlayer:robotFire()
    local robot = md:getInstance("Robot")
    if not robot:isCoolDownDone() then return end
    robot:fire()
    local focusRangeNode = self.focusView:getFocusRange()
    self.hero:dispatchEvent({name = self.hero.GUN_FIRE_EVENT,focusRangeNode = focusRangeNode})
end

----move----
function FightPlayer:moveFocus(offsetX, offsetY)
    local focusNode = self.focusNode
    local xOri, yOri = focusNode:getPosition()
    local scale = KFightConfig.scaleMoveFocus
    offsetX = xOri + offsetX*scale
    offsetY = yOri + offsetY*scale
    focusNode:setPosition(offsetX, offsetY)
    self:justFocusPos(focusNode)
    local x, y = focusNode:getPosition()
    self:moveGun(x - xOri,y - yOri)
end

function FightPlayer:moveBgLayer(offsetX, offsetY)
    local layerMap = self.layerMap
    local xOri, yOri = layerMap:getPosition()
    local scale = KFightConfig.scaleMoveBg
    layerMap:setPosition(xOri - offsetX * scale, yOri - offsetY * scale)
    local x, y = layerMap:getPosition()
    self:justBgPos(layerMap)
end

function FightPlayer:moveGun(offsetX, offsetY)
    local layerGun = self.layerGun
    local xOri, yOri = layerGun:getPosition()
    layerGun:setPositionX(offsetX + xOri)
end

function FightPlayer:justBgPos(node)
    local layerMap = self.layerMap
    local bgMap = self.mapView  
    local w, h = bgMap:getSize().width , 
        bgMap:getSize().height
    local xL = (w - display.width1) / 2  
    local yL = (h - display.height1) / 2 
    local x, y = node:getPosition()

    --x
    if x <= -xL then
        x = -xL
    elseif x >= xL  then 
        x = xL
    end

    --y
    if y <= -yL  then
        y = -yL
    elseif y >=  yL  then 
        y = yL
    end    
    node:setPosition(x, y)    
end

function FightPlayer:justFocusPos(node)
    local x, y = node:getPosition()

    if x <= 0 then 
        x = 0
    end

    if x >= display.width1 then 
        x = display.width1
    end
    
    if y <= 0 then 
        y = 0
    end
    if y >= display.height1 then 
        y = display.height1
    end
    node:setPosition(x, y)
end

function FightPlayer:initGuide()
    --check   
    local isDone = self.guide:check("fight")
    if isDone then return end

    --move
    local isMoveGuideUnDone = true
    self.guide:addClickListener({
        id = "fight_move",
        groupId = "fight",
        rect = self.btnJu:getBoundingBox(),
        endfunc = function (touchEvent)
            if touchEvent.name == "moved" and isMoveGuideUnDone then
                isMoveGuideUnDone = false
                print("ight_mov self.guide:doGuideNext()")
                self.focusNode:moveBy(1.0, 0, -40)
                self.guide:doGuideNext()
                self.guide:hideGuideForTime(2.0)
            end
        end
     })
    
    --开枪1次
    self.guide:addClickListener({
        id = "fight_fire1",
        groupId = "fight",
        rect = self.btnFire:getBoundingBox(),
        endfunc = function (touchEvent)
            self.gunView:fire()
            self.hero:fire()
        end
    })  

    --开枪1秒
    self.guide:addClickListener({
        id = "fight_fire2",
        groupId = "fight",
        rect = self.btnFire:getBoundingBox(),
        endfunc = function (touchEvent)
            self:onGuideFire(touchEvent)
        end
    })  

    --扔雷
    self.guide:addClickListener( {
        id = "fight_throw",
        groupId = "fight",
        rect = self.btnLei:getBoundingBox(),
        endfunc = function (touchEvent)
            for id, point in pairs(touchEvent.points) do
                self:checkBtnLei(point)
            end
        end
    })  

    --换枪
    self.guide:addClickListener( {
        id = "fight_change",
        groupId = "fight",
        rect = self.btnChange:getBoundingBox(),
        endfunc = function (touchEvent)
            for id, point in pairs(touchEvent.points) do
                self:checkBtnChange(point)
            end
        end
    })     

    --结束
    self.guide:addClickListener( {
        id = "fight_finish",
        groupId = "fight",
        rect = cc.rect(0, 0, display.width1, display.height1),
        endfunc = function (touchEvent)

        end
    })     

end

local time_begin = nil
local schGuideFire
local isGuideFireBegin = false
function FightPlayer:onGuideFire(touchEvent)
    print("os.time()", os.time())
    local name = touchEvent.name
    
    --检查长按时间
    local function onGuideFireCheckFunc()
        local timeNow = os.time()
        if time_begin and (timeNow - time_begin) >=  1.0 then 
            print("长按射击引导完成")
            print("time_begin:", time_begin)
            scheduler.unscheduleGlobal(schGuideFire)
            self:onCancelledFire()
            self.guide:doGuideNext()
            self.guide:hideGuideForTime(2.0)
        end
    end

    --开始计时
    if name == "began"  then
        print("开始计时") 
        isGuideFireBegin = true
        time_begin = os.time()
        schGuideFire = scheduler.scheduleUpdateGlobal(onGuideFireCheckFunc) 
    end

    --停止计时
    if name == "ended" or name == "cancelled" then
        if isGuideFireBegin == false then return end 
        print("停止计时")
        time_begin = nil
        if schGuideFire then 
            scheduler.unscheduleGlobal(schGuideFire)
        end
    end

    --响应事件
    for id, point in pairs(touchEvent.points) do
        print("name", name)
        self:checkBtnFire(id, point,name)
    end
end

function FightPlayer:onEnter()

end

function FightPlayer:onExit()
    self:removeAllSchs()
end

function FightPlayer:onResultFail()
    self:removeAllSchs()
end

function FightPlayer:onResultWin()
    self:removeAllSchs()
end

function FightPlayer:removeAllSchs()
    if tempChangeGoldHandler then 
        scheduler.unscheduleGlobal(tempChangeGoldHandler)
        tempChangeGoldHandler = nil
    end
    if resumeDefenceHandler then 
        scheduler.unscheduleGlobal(resumeDefenceHandler)
        resumeDefenceHandler= nil
    end
    if self.btnFireSch then
        scheduler.unscheduleGlobal(self.btnFireSch)
        self.btnFireSch = nil
    end
end

return FightPlayer

