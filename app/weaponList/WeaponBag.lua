
local Color_GRAY = cc.c3b(150, 150, 150)
local Color_YELLOW = cc.c3b(255, 195, 0)

local WeaponBag = class("WeaponBag", function()
	return display.newLayer()
end)

function WeaponBag:ctor(properties)
    self.weaponid = properties.weaponid
    self.weaponed = nil
    self.weaponListModel = md:getInstance("WeaponListModel")
	self:loadCCS()
	self:initUI()
    self:refreshData()
end

function WeaponBag:loadCCS()
    -- load control bar
    cc.FileUtils:getInstance():addSearchPath("res/WeaponList")
    local controlNode = cc.uiloader:load("wuqilan.ExportJson")
    self:addChild(controlNode)
end

function WeaponBag:initUI()

    local btnOff   = cc.uiloader:seekNodeByName(self, "guanbi")
    self.weapon1   = cc.uiloader:seekNodeByName(self, "panelweapon1")
    self.weapon2   = cc.uiloader:seekNodeByName(self, "panelweapon2")
    self.weapon3   = cc.uiloader:seekNodeByName(self, "panelweapon3")
	
    self.panlwangge1   = cc.uiloader:seekNodeByName(self, "panlwangge1")
    self.panlwangge2   = cc.uiloader:seekNodeByName(self, "panlwangge2")
    self.panlwangge3   = cc.uiloader:seekNodeByName(self, "panlwangge3")
    self.panlwanggekuang1   = cc.uiloader:seekNodeByName(self, "panlwanggekuang1")
    self.panlwanggekuang2   = cc.uiloader:seekNodeByName(self, "panlwanggekuang2")
    self.panlwanggekuang3   = cc.uiloader:seekNodeByName(self, "panlwanggekuang3")
    self.panlwangge1:setColor(Color_GRAY)
    self.panlwangge2:setColor(Color_GRAY)
    self.panlwangge3:setColor(Color_GRAY)
    self.panlwanggekuang1:setColor(Color_GRAY)
    self.panlwanggekuang2:setColor(Color_GRAY)
    self.panlwanggekuang3:setColor(Color_GRAY)
    self.weapon1:setTouchEnabled(true)
    self.weapon2:setTouchEnabled(true)
    self.weapon3:setTouchEnabled(true)
	btnOff      :setTouchEnabled(true)

	addBtnEventListener(btnOff, function(event)
        if event.name=='began' then
            print("offbtn is begining!")
            return true
        elseif event.name=='ended' then
            self:onClickBtnOff()

        end
    end)

    local record = self.weaponListModel:getWeaponRecord(self.weaponid)
    local type = record["type"]
    if type == "ju" then
        self.weapon1:setTouchEnabled(false)
        self.weapon2:setTouchEnabled(false)
    else
        self.weapon3:setTouchEnabled(false)
    end
    self.weapon1:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name=='began' then
            print("began")
            return true
        elseif event.name=='ended' then
            print("ended")
            self.weaponListModel:equipBag(self.weaponid,1)
            self.weaponListModel:refreshData()
            self:refreshData("bag1")
        end
        local data = getUserData()
        dump(data.weapons.weaponed, "data.weapons")
    end)
    self.weapon2:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name=='began' then
            print("began")
            return true
        elseif event.name=='ended' then
            print("ended")
            self.weaponListModel:equipBag(self.weaponid,2)
            self.weaponListModel:refreshData()
            self:refreshData("bag2")
        end
            local data = getUserData()
        dump(data.weapons.weaponed, "data.weapons")

    end)
    self.weapon3:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name=='began' then
            print("began")
            return true
        elseif event.name=='ended' then
            print("ended")
            self.weaponListModel:equipBag(self.weaponid,3)
            self.weaponListModel:refreshData()
            self:refreshData("bag3")
        end
        local data = getUserData()
        dump(data.weapons.weaponed, "data.weapons")

    end)
end
-- self.weaponListModel:equip(weaponrecord)
function WeaponBag:refreshData(bag)
    if bag == "bag1" then
        self.panlwangge1:setColor(Color_YELLOW)
        self.panlwanggekuang1:setColor(Color_YELLOW)
        self.panlwangge2:setColor(Color_GRAY)
        self.panlwanggekuang2:setColor(Color_GRAY)
        self.panlwangge3:setColor(Color_GRAY)
        self.panlwanggekuang3:setColor(Color_GRAY)
    elseif bag == "bag2" then
        self.panlwangge2:setColor(Color_YELLOW)
        self.panlwanggekuang2:setColor(Color_YELLOW)
        self.panlwangge1:setColor(Color_GRAY)
        self.panlwanggekuang1:setColor(Color_GRAY)
        self.panlwangge3:setColor(Color_GRAY)
        self.panlwanggekuang3:setColor(Color_GRAY)

    elseif bag == "bag3" then
        self.panlwangge1:setColor(Color_GRAY)
        self.panlwanggekuang1:setColor(Color_GRAY)
        self.panlwangge2:setColor(Color_GRAY)
        self.panlwanggekuang2:setColor(Color_GRAY)
        self.panlwangge3:setColor(Color_YELLOW)
        self.panlwanggekuang3:setColor(Color_YELLOW)

    end
    self.weaponed = self.weaponListModel:getWeaponInBag()
    dump(self.weaponed)
    self.weapon1:removeAllChildren()
    self.weapon2:removeAllChildren()
    self.weapon3:removeAllChildren()

    local img1rec = getRecordByKey("config/weapon_weapon.json", "id", self.weaponed[1]["weaponid"])
    local img2rec = getRecordByKey("config/weapon_weapon.json", "id", self.weaponed[2]["weaponid"])
    local img1 = display.newSprite("#icon_"..img1rec[1]["imgName"]..".png")
    local img2 = display.newSprite("#icon_"..img2rec[1]["imgName"]..".png")
    img1:setScale(0.5)
    img2:setScale(0.5)
    addChildCenter(img1, self.weapon1)
    addChildCenter(img2, self.weapon2)
    if table.nums(self.weaponed) == 3 then
        local img3rec = getRecordByKey("config/weapon_weapon.json", "id", self.weaponed[3]["weaponid"])
        local img3 = display.newSprite("#icon_"..img3rec[1]["imgName"]..".png")
        img3:setScale(0.5)
        addChildCenter(img3, self.weapon3)
    end
end



function WeaponBag:onClickBtnOff()
    ui:closePopup("WeaponBag")
end

return WeaponBag