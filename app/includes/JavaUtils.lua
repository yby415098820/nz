local JavaUtils = class("JavaUtils",cc.mvc.ModelBase)

                     
function JavaUtils.getIapType()   -- "confirm", "noIap", "noConfirm"
    if device.platform ~= 'android' then return "confirm" end
    local className = "com/hgtt/com/IAPControl"
    local methodName = "getIapType"
    local args = {}
    local sig = "()Ljava/lang/String;"
    local luajResult, iapType = luaj.callStaticMethod(className, methodName, args, sig)
    print("iapType:", iapType)
    if luajResult then
        return iapType
    end
    return "confirm"
end

function JavaUtils.getIsGiftValid()
    if device.platform ~= 'android' then return true end
    local result,isGiftValid = luaj.callStaticMethod("com/hgtt/com/IAPControl", 
        "getIapGiftStatus", {}, "()Ljava/lang/String;")
    print("isGiftValid:",isGiftValid)
    return isGiftValid
end

function JavaUtils.getIapName()
    if device.platform ~= 'android' then return 'invalid' end
    local result,iapName = luaj.callStaticMethod("com/hgtt/com/IAPControl", 
        "getIapStatus", {}, "()Ljava/lang/String;")
    print("iapName:",iapName)
    return iapName

end

function JavaUtils.isDefendDX()
    -- return true
    if JavaUtils.getIapName() == "dx" then
        return true
    else
        return false
    end
end

--[[
    @sdkName : al,wx,jd,mm,dx,lt
    @return : bool
]]
function JavaUtils.getIsIapSDKValid(sdkName)
    print("function getIsIapSDKValid(sdkName)", sdkName)
    if device.platform == 'android' then
        local result,valid = luaj.callStaticMethod(
            "com/hgtt/com/IAPControl", 
            "getIsIapSDKValid", 
            {sdkName}, 
            "(Ljava/lang/String;)Z")
        return valid
    end
    return true
end

return JavaUtils