RegisterNetEvent('flight-skills:openMenu', function(data)
    lib.registerContext({
        id = data.id,
        title = data.title,
        options = data.options,
    })
    lib.showContext(data.id)
end)

local function getSkill(skill)
    return lib.callback.await('flight-skills:callback:getXP', false, skill)
end
exports('getSkill', getSkill)

local function getXP(skill)
    skill = getSkill(skill)
    if skill then
        return skill.xp
    end
    return 0
end
exports('getXP', getXP)

local function getLevel(skill)
    skill = getSkill(skill)
    if skill then
        return skill.level
    end
    return 0
end
exports('getLevel', getLevel)

local function hasXP(skill, amount)
    skill = getSkill(skill)
    if skill then
        return skill.xp >= amount
    end
    return false
end
exports('hasXP', hasXP)

local function hasLevel(skill, level)
    skill = getSkill(skill)
    if skill then
        return skill.level >= level
    end
    return false
end
exports('hasLevel', hasLevel)

-----------------------------------
-- [[ BACKWARDS COMPATIBILITY ]] --
-----------------------------------

local function exportHandler(resource, name, cb)
    AddEventHandler(('__cfx_export_%s_%s'):format(resource, name), function(setCB)
        setCB(cb)
    end)
end

-- pickle_xp
exportHandler("pickle_xp", "GetXP", getXP)
exportHandler("pickle_xp", "GetLevel", getLevel)

-- cw_rep
exportHandler("cw-rep", "checkSkill", hasXP)
exportHandler("cw-rep", "playerHasEnoughSkill", hasXP)
