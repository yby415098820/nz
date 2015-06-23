require("config")

require("framework.init")
local UI = require("app.UI.UIManager")
local MD = require("app.Model.ModelManager")
local UM = require("app.SDK.UMsdk")
local Define = require("app.Define")
local DataModel = require("app.DataModel")
GameState = require("framework.cc.utils.GameState")
local MyApp = class("MyApp", cc.mvc.AppBase)

-- global var
GameData={}
myApp = MyApp
isTest  = false     --战斗的各种框     
isDebug = true      --debug页面 --dabao为false
isAsync = false
__versionId = nil   --游戏当前版本
__appName = nil       --游戏当前名称
__kefuNum =  "01082602182"     --易接： "4006706603" 浩歌 01082602182

ui        = UI.new()
md        = MD.new()
um        = UM.new()
define    = Define.new()
dataModel = DataModel.new()

function MyApp:ctor()
    MyApp.super.ctor(self)
    self.objects_ = {}
    self:initVariables()
    self:initGameState()    
    
    -- um 设置玩家账户及等级
    um:setUserAccount()
end

function MyApp:run()
    print("MyApp:run()!")
    cc.FileUtils:getInstance():addSearchPath("res/")
    self:enterScene("MainScene")
    dataModel:checkData() 
end

function MyApp:initGameState()
    -- init GameState
    GameState.init(function(param)
        local returnValue=nil
        if param.errorCode then
            CCLuaLog("error")
        else
            -- crypto
            if param.name=="save" then
                local str=json.encode(param.values)
                str=crypto.encryptXXTEA(str, "abcd")
                returnValue={data=str}
            elseif param.name=="load" then
                local str=crypto.decryptXXTEA(param.values.data, "abcd")
                returnValue=json.decode(str)
            end
        end
        return returnValue
    end, "data.txt","1234")
    if io.exists(GameState.getGameStatePath()) then
        GameData=GameState.load()
    else
        self:createGameStateFile()
        
    end
end

function MyApp:initVariables()
    if device.platform ~= "android" then return end
    local className = "com/hgtt/com/IAPControl"
    local params = {}
    local boolSig = "()Z"
    local stringSig = "()Ljava/lang/String;"
    local result = nil
    result, __versionId = luaj.callStaticMethod(className, "getVersionName", params, stringSig)
    result, __appName = luaj.callStaticMethod(className, "getApplicationName", params, stringSig)
end


function MyApp:createGameStateFile()
    print("createGameStateFile")
    local data = GameData.data
    data = {
        versionId = __versionId,
        weapons = {
            bags = {
                {
                    intenlevel = 0,
                    weaponid   = 1,
                },
                {
                    intenlevel = 0,
                    weaponid   = 2 ,           
                },
                {
                    intenlevel = 0,
                    weaponid   = 6, 
                },
                -- {
                --     intenlevel = 10,
                --     weaponid   = 3,
                -- },                
            },
            weaponed = {
                bag1 = {
                    weaponid   = 1,
                },
                bag2 = {
                    weaponid   = 2,
                },
                bag3 = {
                    weaponid   = 6,
                },
            },
            awardedIds = {
            },

        }, 
        inlay = {
            bags = {
            
            }, --{inlayid = 1,ownednum = 1}
            inlayed  = {
                bullet = nil,
                clip = nil,
                speed = nil,
                crit = nil,
                blood = nil,    
                helper = nil,   
            },
        },
        prop = {
            lei = {num = 20},
            jijia = {num = 0},
            hpBag = {num = 1},
        },

        weaponsuipian = {},

        money = 2000, --dabao为2000 
        diamond = 111111110,
        
        --开启的关卡
        currentlevel =  {
            group = 1,
            level = 6,
        },

        bossMode = {
            chapterIndex = 1, 
            waveIndex = 0, 
        },

        jujiMode = {
            waveIndex = 0, 
            scoreAwarded = {
            },
        },            

        user = {
            level = 1,
            fightedLevels = {}, --"enter" "fail" "win"
            userName  = "玩家自己",
            vipLevel  = 0,
        },
        guide = { --dabao为false 
            --记得和 filldata对应!

            --登陆
            login           = true,
            --前戏
            preStory        = true,
            --第0-0关之内
            fight01_move    = true,
            fight01_fire    = true,
            fight01_lei     = true,
            fight01_gold    = true,
            fight01_change  = true,
            fight01_jijia   = true, 

            --第0-0关之后  
            afterfight01    = true,   -- 进入下一关
         
            --第1-1之内
            fight_change    = true,
            fight_dun       = true,

            --第1-2关之前
            xiangqian       = true,   --镶嵌一套青铜

            --第1-3关之前
            weapon          = true,   -- 升级武器
            afterfight03    = true,   -- 回到主界面
            
            --第1-5关之内
            fightJu         = true,  

            --第1-4失败之后
            fightRelive     = true,                      
        },
        fight = {
           isPreferBag1 = true,
        },

        -- 礼包购买状态
        giftBag = { --buy
                    --false 为未购买
            weaponGiftBag =  false,
            vip = false,
        },

        vip = {
            isGet = false,
        },
        dailylogin = {
            loginTime = nil,  --时间戳
            registTime = nil, --时间戳
            isGet = false,
            dailyid = 0,
        },
        preference = {
            isOpenMusic = true
        },
            
    }
    GameState.save(data)
    GameData=GameState.load()
end

function MyApp:showError(debugInfo)
    local debug = md:getInstance("DebugModel")
    debug:showPopup(debugInfo)
end

function MyApp:onEnterBackground()
    local pauseModel = md:getInstance("PauseModel")
    pauseModel:showPopup("HomePausePopup",{},{anim = true, isOnEnterBackground = true})
end

function MyApp:onEnterForeground()
    print("function MyApp:onEnterForeground()")
    local pauseModel = md:getInstance("PauseModel")
    if pauseModel:getIsPause() then 
        display.pause()
    end
end

return MyApp
