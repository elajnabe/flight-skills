local skills = {}
local CORE
local colors = {
    { 0,   "red.5" },
    { 10,  "red.4" },
    { 20,  "red.3" },
    { 30,  "orange.5" },
    { 40,  "orange.4" },
    { 50,  "orange.3" },
    { 60,  "yellow.5" },
    { 70,  "yellow.4" },
    { 80,  "yellow.3" },
    { 90,  "green.2" },
    { 100, "green.1" },
}

local function createTable()
    MySQL.update.await(
        "CREATE TABLE IF NOT EXISTS flight_skills (id INT AUTO_INCREMENT PRIMARY KEY, identifier VARCHAR(50), skills TEXT);")
end

local function getColor(value)
    for i = 1, #colors do
        if value <= colors[i][1] then
            return colors[i][2]
        end
    end
    return "green.5"
end

local function formatName(name)
    return name:gsub("^%l", string.upper):gsub("_", " "):gsub("%W", " ")
end

local function getIdentifier(source)
    if Config.Framework == "qb" then
        source = tonumber(source)
        local Player = CORE.Functions.GetPlayer(source)
        return Player.PlayerData.citizenid
    else
        local license
        for _, v in ipairs(GetPlayerIdentifiers(source)) do
            if string.find(v, "license") then
                license = v
                break
            end
        end
        return license
    end
end

local function loadPlayerSkills(source)
    local identifier = getIdentifier(source)
    if not identifier then
        print("Error: Identifier not found")
        return
    end
    if not skills[identifier] then
        MySQL.Async.fetchAll("SELECT * FROM flight_skills WHERE identifier = @identifier", {
            ["@identifier"] = identifier
        }, function(result)
            if result[1] then
                local foundskills = json.decode(result[1].skills)
                for k, _ in pairs(Config.Skills) do
                    if not foundskills[k] then
                        foundskills[k] = 0
                    else
                        if Config.DeleteSkills then
                            if not Config.Skills[k] then
                                foundskills[k] = nil
                            end
                        end
                        if Config.LowerXpAfterMax then
                            if Config.Skills[k].levels then
                                if foundskills[k] > Config.Skills[k].levels[#Config.Skills[k].levels].value then
                                    foundskills[k] = Config.Skills[k].levels[#Config.Skills[k].levels].value
                                end
                            else
                                if foundskills[k] > Config.DefaultValues.levels[#Config.DefaultValues.levels] then
                                    foundskills[k] = Config.DefaultValues.levels[#Config.DefaultValues.levels]
                                end
                            end
                        end
                    end
                end
                skills[identifier] = foundskills
            else
                skills[identifier] = {}
                for k, _ in pairs(Config.Skills) do
                    skills[identifier][k] = 0
                end
            end
        end)
    end
end

local function saveSkillsPerson(source)
    local identifier = getIdentifier(source)
    if not identifier then
        print("Error: Identifier not found")
        return
    end
    MySQL.update("UPDATE flight_skills SET skills = @skills WHERE identifier = @identifier", {
        ["@skills"] = json.encode(skills[identifier]),
        ["@identifier"] = identifier
    })
end

local function saveSkillsAll()
    for k, v in pairs(skills) do
        MySQL.query("SELECT * FROM flight_skills WHERE identifier = @identifier", {
            ["@identifier"] = k
        }, function(result)
            if result[1] then
                MySQL.update("UPDATE flight_skills SET skills = @skills WHERE identifier = @identifier", {
                    ["@skills"] = json.encode(v),
                    ["@identifier"] = k
                })
            else
                MySQL.insert("INSERT INTO flight_skills (identifier, skills) VALUES (@identifier, @skills)", {
                    ["@identifier"] = k,
                    ["@skills"] = json.encode(v)
                })
            end
        end)
    end
end

local function getXP(source, skill)
    local identifier = getIdentifier(source)
    if not identifier then
        print("Error: Identifier not found")
        return
    end
    if skills[identifier] then
        local level = 0
        if Config.Skills[skill].levels then
            for i = #Config.Skills[skill].levels, 1, -1 do
                if skills[identifier][skill] >= Config.Skills[skill].levels[i].value then
                    level = i
                    break
                end
            end
        else
            for i = #Config.DefaultValues.levels, 1, -1 do
                if skills[identifier][skill] >= Config.DefaultValues.levels[i] then
                    level = i
                    break
                end
            end
        end
        return { level = level, xp = skills[identifier][skill] or 0 }
    end
    return { level = 0, xp = 0 }
end
exports("getXP", getXP)

local function getLevel(source, skill)
    local identifier = getIdentifier(source)
    if not identifier then
        print("Error: Identifier not found")
        return
    end
    if skills[identifier] then
        local level = 0
        if Config.Skills[skill].levels then
            for i = #Config.Skills[skill].levels, 1, -1 do
                if skills[identifier][skill] >= Config.Skills[skill].levels[i].value then
                    level = i
                    break
                end
            end
        else
            for i = #Config.DefaultValues.levels, 1, -1 do
                if skills[identifier][skill] >= Config.DefaultValues.levels[i] then
                    level = i
                    break
                end
            end
        end
        return level
    end
    return 0
end

local function getXPs(source)
    local identifier = getIdentifier(source)
    if not identifier then
        print("Error: Identifier not found")
        return
    end
    if not skills[identifier] then
        loadPlayerSkills(source)
        while not skills[identifier] do
            Wait(50)
        end
        return skills[identifier]
    end
    return skills[identifier]
end

local function setXP(source, skill, value)
    local identifier = getIdentifier(source)
    if not identifier then
        print("Error: Identifier not found")
        return
    end
    if not skills[identifier] then
        skills[identifier] = {}
    end
    skills[identifier][skill] = value
end
exports("setXP", setXP)

local function addXP(source, skill, value)
    local identifier = getIdentifier(source)
    if not identifier then
        print("Error: Identifier not found")
        return
    end
    if not skills[identifier] then
        skills[identifier] = {}
    end
    if not skills[identifier][skill] then
        skills[identifier][skill] = 0
    end

    if not Config.AddXPAfterMax then
        if Config.Skills[skill].levels then
            if skills[identifier][skill] + value > Config.Skills[skill].levels[#Config.Skills[skill].levels].value then
                skills[identifier][skill] = Config.Skills[skill].levels[#Config.Skills[skill].levels].value
                if Config.Notifications.maxLevel then
                    TriggerClientEvent('ox_lib:notify', source, {
                        type = "inform",
                        description = "You have reached the max level for " ..
                            (Config.Skills[skill].label or formatName(skill)),
                        icon = Config.Skills[skill].icon or Config.DefaultValues.icon,
                    })
                end
            else
                skills[identifier][skill] = skills[identifier][skill] + value

                if Config.Notifications.gainXP then
                    local levelup = false
                    local index
                    for i = 1, #Config.Skills[skill].levels do
                        if skills[identifier][skill] - value < Config.Skills[skill].levels[i].value and skills[identifier][skill] >= Config.Skills[skill].levels[i].value then
                            levelup = true
                            index = i
                            break
                        end
                    end

                    if levelup then
                        TriggerClientEvent('ox_lib:notify', source, {
                            type = "success",
                            description = "You have gained " ..
                                value ..
                                " XP for " ..
                                (Config.Skills[skill].label or formatName(skill)) ..
                                " and leveled up to " ..
                                (Config.Skills[skill].levels[index].label or formatName("Level " .. index)),
                            icon = Config.Skills[skill].icon or Config.DefaultValues.icon,
                        })
                    else
                        TriggerClientEvent('ox_lib:notify', source, {
                            type = "success",
                            description = "You have gained " ..
                                value .. " XP for " .. (Config.Skills[skill].label or formatName(skill)),
                            icon = Config.Skills[skill].icon or Config.DefaultValues.icon,
                        })
                    end
                end
            end
        else
            if skills[identifier][skill] + value > Config.DefaultValues.levels[#Config.DefaultValues.levels] then
                skills[identifier][skill] = Config.DefaultValues.levels[#Config.DefaultValues.levels]

                if Config.Notifications.maxLevel then
                    TriggerClientEvent('ox_lib:notify', source, {
                        type = "inform",
                        description = "You have reached the max level for " ..
                            (Config.Skills[skill].label or formatName(skill)),
                        icon = Config.Skills[skill].icon or Config.DefaultValues.icon,
                    })
                end
            else
                skills[identifier][skill] = skills[identifier][skill] + value

                if Config.Notifications.gainXP then
                    local levelup = false
                    local index
                    for i = 1, #Config.DefaultValues.levels do
                        if skills[identifier][skill] - value < Config.DefaultValues.levels[i] and skills[identifier][skill] >= Config.DefaultValues.levels[i] then
                            levelup = true
                            index = i
                            break
                        end
                    end

                    if levelup then
                        TriggerClientEvent('ox_lib:notify', source, {
                            type = "success",
                            description = "You have gained " ..
                                value ..
                                " XP for " ..
                                (Config.Skills[skill].label or formatName(skill)) ..
                                " and leveled up to " .. (formatName("Level " .. index)),
                            icon = Config.Skills[skill].icon or Config.DefaultValues.icon,
                        })
                    else
                        TriggerClientEvent('ox_lib:notify', source, {
                            type = "success",
                            description = "You have gained " ..
                                value .. " XP for " .. (Config.Skills[skill].label or formatName(skill)),
                            icon = Config.Skills[skill].icon or Config.DefaultValues.icon,
                        })
                    end
                end
            end
        end
    else
        skills[identifier][skill] = skills[identifier][skill] + value

        if Config.Notifications.gainXP then
            TriggerClientEvent('ox_lib:notify', source, {
                type = "inform",
                description = "You have gained " ..
                    value .. " XP for " .. (Config.Skills[skill].label or formatName(skill)),
                icon = Config.Skills[skill].icon or Config.DefaultValues.icon,
            })
        end
    end
end
exports("addXP", addXP)

local function removeXP(source, skill, value)
    local identifier = getIdentifier(source)
    if not identifier then
        print("Error: Identifier not found")
        return
    end
    if not skills[identifier] then
        skills[identifier] = {}
    end
    if not skills[identifier][skill] then
        skills[identifier][skill] = 0
    end

    skills[identifier][skill] = skills[identifier][skill] - value

    if skills[identifier][skill] < 0 then
        skills[identifier][skill] = 0
    end

    if Config.Notifications.loseXP then
        local leveldown = false
        local index
        for i = 1, #Config.Skills[skill].levels do
            if skills[identifier][skill] + value > Config.Skills[skill].levels[i].value and skills[identifier][skill] <= Config.Skills[skill].levels[i].value then
                leveldown = true
                index = i
                break
            end
        end

        if leveldown then
            TriggerClientEvent('ox_lib:notify', source, {
                type = "error",
                description = "You have lost " ..
                    value ..
                    " XP for " ..
                    (Config.Skills[skill].label or formatName(skill)) ..
                    " and leveled down to " ..
                    (Config.Skills[skill].levels[index].label or formatName("Level " .. index)),
                icon = Config.Skills[skill].icon or Config.DefaultValues.icon,
            })
        else
            TriggerClientEvent('ox_lib:notify', source, {
                type = "error",
                description = "You have lost " ..
                    value .. " XP for " .. (Config.Skills[skill].label or formatName(skill)),
                icon = Config.Skills[skill].icon or Config.DefaultValues.icon,
            })
        end
    end
end
exports("removeXP", removeXP)

lib.callback.register('flight-skills:callback:getXP', function(source, skill)
    return getXP(source, skill)
end)

local function prepareOptions(data)
    local options = {}
    for k, v in pairs(data) do
        local config = Config.Skills[k]
        if config and not config.hide then
            local level = 1
            local progress
            local title = config.label or formatName(k)
            local description
            if config.levels then
                for i = #config.levels, 1, -1 do
                    if v >= config.levels[i].value then
                        level = i
                        title = title .. " - (" .. (config.levels[level].label or formatName("Level " .. level)) .. ")"
                        if i == #config.levels then
                            description = "Max Level"
                            progress = 100
                        else
                            description = "XP: " ..
                                v - config.levels[i].value ..
                                "/" ..
                                (config.levels[i + 1] and config.levels[i + 1].value - config.levels[i].value or 1)
                            progress = math.floor((v - config.levels[i].value) /
                                (config.levels[i + 1] and config.levels[i + 1].value - config.levels[i].value or 1) * 100)
                        end
                        break
                    end
                end
            else
                for i = #Config.DefaultValues.levels, 1, -1 do
                    if v >= Config.DefaultValues.levels[i] then
                        level = i
                        title = title .. " - (" .. (formatName("Level " .. level)) .. ")"
                        if i == #Config.DefaultValues.levels then
                            description = "Max Level"
                            progress = 100
                        else
                            description = "XP: " ..
                                v - Config.DefaultValues.levels[i] ..
                                "/" ..
                                (Config.DefaultValues.levels[i + 1] and Config.DefaultValues.levels[i + 1] - Config.DefaultValues.levels[i] or 1)
                            progress = math.floor((v - Config.DefaultValues.levels[i]) /
                                (Config.DefaultValues.levels[i + 1] and Config.DefaultValues.levels[i + 1] - Config.DefaultValues.levels[i] or 1) *
                                100)
                        end
                        break
                    end
                end
            end

            table.insert(options, {
                title = title,
                description = description,
                icon = config.icon or Config.DefaultValues.icon,
                readOnly = true,
                progress = progress,
                colorScheme = getColor(progress),
            })
        end
    end
    return options
end

RegisterCommand(Config.Command, function(source, _, _)
    if not source then
        print("Error: Source not found")
        return
    end
    local p = promise.new()
    p:resolve(getXPs(source))
    p = Citizen.Await(p)
    local options = prepareOptions(p)
    TriggerClientEvent('flight-skills:openMenu', source, {
        id = "flight-skills",
        title = "Flight Skills",
        options = options,
    })
end, false)

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        createTable()
        if Config.Framework == "qb" then
            CORE = exports["qb-core"]:GetCoreObject()
        end
    end
end)

AddEventHandler('onResourceStop', function(resource)
    print(resource, GetCurrentResourceName())
    if resource == GetCurrentResourceName() then
        print("Saving skills")
        saveSkillsAll()
    end
end)

if Config.Framework == "qb" then
    AddEventHandler('QBCore:Server:PlayerLoaded', function(Player)
        loadPlayerSkills(Player.PlayerData.source)
    end)
elseif Config.Framework == "esx" then
    AddEventHandler('esx:playerLoaded', function(source, _, _)
        loadPlayerSkills(source)
    end)
elseif Config.Framework == "standalone" then
    AddEventHandler('playerJoining', function(source, _)
        loadPlayerSkills(source)
    end)
end

AddEventHandler('playerDropped', function()
    local source = source
    saveSkillsPerson(source)
    skills[getIdentifier(source)] = nil
end)

CreateThread(function()
    while true do
        Wait(60000)
        for k, v in pairs(skills) do
            for skill, amount in pairs(v) do
                if amount > 0 then
                    if Config.Skills[skill].degrades and Config.Skills[skill].degrades.active then
                        if math.random(1, 100) <= Config.Skills[skill].degrades.chance then
                            if amount - Config.Skills[skill].degrades.amount < 0 then
                                skills[k][skill] = 0
                            else
                                skills[k][skill] = amount - Config.Skills[skill].degrades.amount
                            end
                        end
                    end
                end
            end
        end

        saveSkillsAll()
    end
end)

-- RegisterCommand("addXP", function(source, args, _)
--     if not source then
--         print("Error: Source not found")
--         return
--     end
--     print(args[1], args[2])
--     if not args[1] or not args[2] then
--         print("Error: Invalid arguments")
--         return
--     end
--     addXP(source, args[1], tonumber(args[2]))
-- end, true)

-- RegisterCommand("setXP", function(source, args, _)
--     if not source then
--         print("Error: Source not found")
--         return
--     end
--     if not args[1] or not args[2] then
--         print("Error: Invalid arguments")
--         return
--     end
--     setXP(source, args[1], tonumber(args[2]))
-- end, true)

-- RegisterCommand("removeXP", function(source, args, _)
--     if not source then
--         print("Error: Source not found")
--         return
--     end
--     if not args[1] or not args[2] then
--         print("Error: Invalid arguments")
--         return
--     end
--     removeXP(source, args[1], tonumber(args[2]))
-- end, true)

-- RegisterCommand("getXP", function(source, args, _)
--     if not source then
--         print("Error: Source not found")
--         return
--     end
--     if not args[1] then
--         print("Error: Invalid arguments")
--         return
--     end
--     print(getXP(source, args[1]))
-- end, true)

-- RegisterCommand("saveskills", function(_, _, _)
--     saveSkillsAll()
-- end, true)


-----------------------------------
-- [[ BACKWARDS COMPATIBILITY ]] --
-----------------------------------

local function exportHandler(resource, name, cb)
    AddEventHandler(('__cfx_export_%s_%s'):format(resource, name), function(setCB)
        setCB(cb)
    end)
end

-- stop other xp systems
CreateThread(function()
    if GetResourceState("pickle_xp") == "started" then
        StopResource("pickle_xp")
    end

    if GetResourceState("cw-rep") == "started" then
        StopResource("cw-rep")
    end
end)

-- pickle_xp
exportHandler("pickle_xp", "AddPlayerXP", addXP)
exportHandler("pickle_xp", "RemovePlayerXP", removeXP)
exportHandler("pickle_xp", "SetPlayerXP", setXP)
exportHandler("pickle_xp", "GetPlayerXP", getXP)
exportHandler("pickle_xp", "GetPlayerLevel", getLevel)

-- cw-rep
local function updateSkill(source, skill, value)
    if value > 0 then
        addXP(source, skill, value)
    else
        removeXP(source, skill, value)
    end
end
exportHandler("cw-rep", "updateSkill", updateSkill)
exportHandler("cw-rep", "fetchSkills", getXPs)
