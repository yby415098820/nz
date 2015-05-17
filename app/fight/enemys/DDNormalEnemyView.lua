
--[[--

“enemy”的视图
1. 根据enemyModel的状态机来更新view的动画
2. enemy的移动范围判断
]]

local Attackable = import(".Attackable")
local Enemy = import(".Enemy")
local Hero = import("..Hero")
local Actor = import("..Actor")   

local DDNormalEnemyView = class("DDNormalEnemyView", Attackable)

---- event ----
function DDNormalEnemyView:ctor(property)  
    --instance
    DDNormalEnemyView.super.ctor(self, property)   
    self.srcPos    = property.srcPos
    self.destPos   = property.destPos
    self.srcScale  = property.srcScale
    self.offsetPos = property.offset or cc.p(0.0,0.0) 

    --events
    cc.EventProxy.new(self.enemy, self)
        :addEventListener(Actor.HP_DECREASE_EVENT, handler(self, self.playHitted)) 
        :addEventListener(Actor.KILL_EVENT, handler(self, self.playKill)) 

    self:playFire() 
end

function DDNormalEnemyView:tick()
    
end

function DDNormalEnemyView:playFire()
    local missileType = self.property["missileType"] or "daodan"
    
    if missileType == "daodan"  then 
        self:playDaoDanFire()
    elseif  missileType == "tie" then 
        self:playTieqiuFire()
    elseif missileType == "lei" then
        self:playLeiFire()
    elseif missileType == "feibiao" then
        self:playFeibiaoFire()        
    else 
        assert(false, "invalid missileType"..missileType)
    end 
end

function DDNormalEnemyView:playDaoDanFire()
    --scale
    self:setScale(self.srcScale)
    -- print("self.property flyTime" .. self.property["flyTime"] )
    local time = self.property["flyTime"] or define.kMissileDaoTime    
    local destScale = self.property["destScale"] or 1.0 
    local scaleAction = cc.ScaleTo:create(time, destScale)

    --call end
    local function callMoveEnd()
        self:playBomb()
    end

    --run
    self.armature:getAnimation():play("fire" , -1, 1) 
    local seq = cc.Sequence:create(scaleAction, cc.CallFunc:create(callMoveEnd))
    self:runAction(seq)
    self:runAction(cc.MoveTo:create(time, self.offsetPos))
end

function DDNormalEnemyView:playTieqiuFire()
    self:setScale(self.srcScale)
    local time = self.property["flyTime"] or define.kMissileTieqiuTime    
    local destScale = self.property["destScale"] or 1.0
    local scaleAction = cc.ScaleTo:create(time, destScale)

    --call end
    local function callFunc()
        self:setDeadDone()
        self.enemy:hit(self.hero)   
        self.hero:dispatchEvent({name = Hero.EFFECT_HURT_BOLI_EVENT})
    end

    --run
    self.armature:getAnimation():play("fire" , -1, 1) 
    local seq = cc.Sequence:create(scaleAction, cc.CallFunc:create(callFunc))
    self:runAction(seq)
    self:runAction(cc.MoveTo:create(time, self.offsetPos))    
end

function DDNormalEnemyView:playLeiFire()
    self.armature:getAnimation():play("fire" , -1, 1)  
    local srcPos = self.property["srcPos"]
    local destPos = cc.p(srcPos.x - 90, 20)
    local jumpTime = self.property["flyTime"] or define.kMissileLeiTime
    local jumpH = 300.0
    local moveAction = cc.JumpTo:create(jumpTime, destPos, jumpH, 1)
    local action = transition.newEasing(moveAction,"in", jumpTime)   
    
    local callFunc = function ()
        self:playBomb()
    end

    local seq =  cc.Sequence:create(action,cc.CallFunc:create(callFunc) )    
    self:runAction(seq)
    self:setScale(0.05)
    self:runAction(cc.ScaleTo:create(jumpTime, 2.0))
end

function DDNormalEnemyView:playFeibiaoFire()
    --scale
    self.armature:setScale(self.srcScale / 0.7)
    local time = self.property["flyTime"] or define.kMissileFeibiaTime    
    local destScale = define.kMissileFeibiaScale 
    local scaleAction = cc.ScaleTo:create(time, destScale / 0.7)

    --call end
    local function callMoveEnd()
        self.armature:getAnimation():play("die02", -1 , 1 )
        self.enemy:hit(self.hero) 
        local soundSrc  = "res/Music/fight/hd_bz.wav"
        audio.playSound(soundSrc,false)          
    end

    --run
    self.armature:getAnimation():play("fire" , -1, 1) 
    local seq = cc.Sequence:create(scaleAction, cc.CallFunc:create(callMoveEnd))
    self.armature:runAction(seq)
    self.armature:runAction(cc.MoveTo:create(time, self.offsetPos))
end

function DDNormalEnemyView:playBomb()
    --kill
    self.armature:getAnimation():play("die" , -1, 1)  
    
    --demage
    self.enemy:hit(self.hero)   

    --屏幕爆炸效果
    self:playBombEffect()
    self.hero:dispatchEvent({name = Hero.EFFECT_HURT_BOMB_EVENT})
end

--Attackable接口
function DDNormalEnemyView:playHitted(event)

end

function DDNormalEnemyView:playKill(event)
    DDNormalEnemyView.super.playKill(self, event)
    self.armature:getAnimation():play("die" , -1, 1)
    local missileType = self.property["missileType"]
    if missileType == "tie" or missileType == "lei" then
        self:playBombEffects()
    end     
end

function DDNormalEnemyView:playBombEffects()
    for i=1, 8 do
        self:performWithDelay(handler(self, self.playBombEffect), 
            i * 0.1)
    end    
end

function DDNormalEnemyView:onHitted(targetData)
    local demage     = targetData.demage
    local scale      = targetData.demageScale or 1.0
    local demageType = targetData.demageType or "body"
    if not self.enemy:canHitted() then return end
    self.enemy:decreaseHp(demage * scale)
end

function DDNormalEnemyView:animationEvent(armatureBack,movementType,movementID)
    if movementType == ccs.MovementEventType.loopComplete then
        if movementID ~= "die" and movementID ~= "die02" then
            
        else
            self:setDeadDone()
        end
    end
end

function DDNormalEnemyView:getModel(property)
    return Enemy.new(property)
end

function DDNormalEnemyView:isBeBuff(type)
    if type == "pause" or type == "addHp"  then
        return false
    else
        return true
    end
end

return DDNormalEnemyView