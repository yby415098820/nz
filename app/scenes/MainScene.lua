
local GuideLayer = import("..guide.GuideLayer")
local PopupRootLayer = import("..UI.PopupRootLayer")
local RootLayer = import("..UI.RootLayer")

local DebugLayer = import("..debug.DebugLayer")

local LoadingLayer = import("..UI.LoadingLayer")

local PauseLayer = import("..pause.PauseLayer")


local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

function MainScene:ctor()

    local rootLayer = RootLayer.new()
    rootLayer:setPositionY(display.offset)
    self:addChild(rootLayer)

    --popup
	local popupRootLayer = PopupRootLayer.new()
    popupRootLayer:setPositionY(display.offset)
    self:addChild(popupRootLayer, 200)

    --guide
    local guideLayer = GuideLayer:new()
    guideLayer:setPositionY(display.offset)
    self:addChild(guideLayer, 300)

    --loading
    local loadLayer = LoadingLayer.new()
    loadLayer:setPositionY(display.offset)
    self:addChild(loadLayer, 400)

    -- PauseLayer
    local pauseLayer = PauseLayer.new()
    pauseLayer:setPositionY(display.offset)
    self:addChild(pauseLayer, 500)

    --debug
    local debugLayer = DebugLayer.new()
    debugLayer:setPositionY(display.offset)
    self:addChild(debugLayer, 600)

    --black
    local LayerColor = cc.c4b(0, 0, 0, 255)
    cc.LayerColor:create(LayerColor)
            :size(display.width, display.offset)
            :pos(0, 0)
            :addTo(self,600)
            :setTouchEnabled(false)
    cc.LayerColor:create(LayerColor)
            :size(display.width, display.offset)
            :pos(0, display.offset+640)
            :addTo(self,600)
            :setTouchEnabled(false)

            -- dump(GameData)
end

function MainScene:onEnter()
    display.resume()
    -- self:resume()
end

function MainScene:onExit()
    display.pause()
    -- self:pause()
end

return MainScene
