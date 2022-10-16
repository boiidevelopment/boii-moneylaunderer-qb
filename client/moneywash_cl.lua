----------------------------------
--<!>-- BOII | DEVELOPMENT --<!>--
----------------------------------

--<!>-- DO NOT EDIT ANYTHING BELOW THIS TEXT UNLESS YOU KNOW WHAT YOU ARE DOING SUPPORT WILL NOT BE PROVIDED IF YOU IGNORE THIS --<!>--
local Core = Config.CoreSettings.Core
local CoreFolder = Config.CoreSettings.CoreFolder
local Core = exports[CoreFolder]:GetCoreObject()
local TargetName = Config.CoreSettings.TargetName
local PlayerLoad = Config.CoreSettings.PlayerLoad
local UpdateJob = Config.CoreSettings.UpdateJob
local washloc = 0
local pJob = nil
local washloaded = false
local washing = false
--<!>-- DO NOT EDIT ANYTHING ABOVE THIS TEXT UNLESS YOU KNOW WHAT YOU ARE DOING SUPPORT WILL NOT BE PROVIDED IF YOU IGNORE THIS --<!>--

--<!>-- NOTIFICATIONS START --<!>--
RegisterNetEvent('boii-moneylaunderer:notify')
AddEventHandler('boii-moneylaunderer:notify', function(msg, type)
    Core.Functions.Notify(msg,type)
end)
--<!>-- NOTIFICATIONS END --<!>--

--<!>-- SETUP --<!>--
-- Job blacklist
function BlacklistedJob()
    local pJob = Core.Functions.GetPlayerData().job
    for i = 1, #Config.MoneyWash.Blacklist.Job, 1 do
        if pJob.name == Config.MoneyWash.Blacklist.Job[i].name then
            return true
        else 
            return false
        end
    end
end
function ServiceJob()
    local pJob = Core.Functions.GetPlayerData().job
    for i = 1, #Config.MoneyWash.Services.Job, 1 do
        if pJob.name == Config.MoneyWash.Services.Job[i].name then
            return true
        else 
            return false
        end
    end
end
-- Player loaded
RegisterNetEvent(PlayerLoad, function()
    if BlacklistedJob() or ServiceJob() then
        DeleteBlip()
    else
        CreateDeliveryBlip()
    end
end)
-- Player job update
RegisterNetEvent(UpdateJob, function()
    if BlacklistedJob() or ServiceJob() then
        DeleteBlip()
    else
        CreateDeliveryBlip()
    end
end)
-- Setup wash ped/blip
function SetupMoneyWash()
    washloc = math.random(1, #Config.MoneyWash.Locations)
    if Config.MoneyWash.Blip.Wash.Use then
        CreateDeliveryBlip()
    end
    SpawnNewPed()
end
--<!>-- SETUP --<!>--

--<!>-- CREATE/DELETE BLIPS --<!>--
-- Create blip
function CreateDeliveryBlip()
    if BlacklistedJob() or ServiceJob() then
        DeleteBlip()
        return
    end
    DeleteBlip()
    blip = AddBlipForCoord(Config.MoneyWash.Locations[washloc]["x"],Config.MoneyWash.Locations[washloc]["y"],Config.MoneyWash.Locations[washloc]["z"])
    SetBlipSprite(blip, 500)
    SetBlipScale(blip, 0.8)
    SetBlipColour(blip, 4)
    SetBlipAsShortRange(blip, false)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(Language.Ped['blip'])
    EndTextCommandSetBlipName(blip)
end
-- Delete blip
function DeleteBlip()
	if DoesBlipExist(blip) then
		RemoveBlip(blip)
	end
end
--<!>-- CREATE/DELETE BLIPS --<!>--

--<!>-- PED SPAWN/DELETE --<!>--
-- Spawn ped
CreateThread(function()
    washloc = math.random(1, #Config.MoneyWash.Locations)
    SetupMoneyWash()
end)
function SpawnNewPed()
    for k, v in pairs(Config.MoneyWash.Ped) do
        RequestModel(GetHashKey(v.model))
        while not HasModelLoaded(GetHashKey(v.model)) do
            Wait(1) 
        end
        washped = CreatePed(4, v.model, Config.MoneyWash.Locations[washloc]["x"],Config.MoneyWash.Locations[washloc]["y"],Config.MoneyWash.Locations[washloc]["z"]-1, 3374176, false, true)
        SetEntityHeading(washped, Config.MoneyWash.Locations[washloc]["h"])
        FreezeEntityPosition(washped, true)
        SetEntityInvincible(washped, true)
        SetBlockingOfNonTemporaryEvents(washped, true)
        TaskStartScenarioInPlace(washped, v.scenario, 0, true)
        exports[TargetName]:AddTargetModel(v.model, {options = {{event = 'boii-moneylaunderer:cl:UseLaunderer', icon = v.icon, label = v.label}}, distance = v.distance})
    end
end
-- Delete ped
function DeleteWashPed()
    local player = PlayerPedId()
	if DoesEntityExist(washped) then
        ClearPedTasks(washped) 
		ClearPedTasksImmediately(washped)
        ClearPedSecondaryTask(washped)
        FreezeEntityPosition(washped, false)
        SetEntityInvincible(washped, false)
        SetBlockingOfNonTemporaryEvents(washped, false)
        TaskReactAndFleePed(washped, player)
		SetPedAsNoLongerNeeded(washped)
		Wait(8000)
		DeletePed(washped)
        SetupMoneyWash()
	end
end
--<!>-- PED SPAWN/DELETE--<!>--

--<!>- RANGE CHECK --<!>--
-- Thread to check if near ped
CreateThread(function()
    while true do
        Wait(10000)
        NearWashPed()
    end
end)
-- Near ped 
function NearWashPed()
    local player = PlayerPedId()
    local pCoord = GetEntityCoords(player)
    local distance = GetDistanceBetweenCoords(pCoord.x, pCoord.y, pCoord.z, Config.MoneyWash.Locations[washloc]["x"],Config.MoneyWash.Locations[washloc]["y"],Config.MoneyWash.Locations[washloc]["z"]-1, true)
    if ServiceJob() and distance < Config.MoneyWash.Services.Range then
        DeleteWashPed()
    end
    if distance <= Config.MoneyWash.Range then
        return true
    else
        return false
    end
end
--<!>- RANGE CHECK --<!>--

--<!>-- EVENTS --<!>-- 
-- Start money wash
RegisterNetEvent('boii-moneylaunderer:cl:UseLaunderer', function()
    local player = PlayerPedId()
    local chance = Config.MoneyWash.Chance
    if not NearWashPed() then return end
    if BlacklistedJob() then return end
    if ServiceJob() then return end
    if Config.MoneyWash.RequireCops then
        Core.Functions.TriggerCallback('boii-moneylaunderer:sv:CopCount', function(CurrentCops)
            if CurrentCops >= Config.MoneyWash.RequiredCops then
                if NearWashPed() then 
                    TriggerEvent('animations:client:EmoteCommandStart', {'point'})
                    Wait(200)
                    TriggerServerEvent('boii-moneylaunderer:sv:UseLaunderer')
                    ClearPedTasks(player)
                    washing = true
                end
            else
                TriggerEvent('boii-moneylaunderer:notify', Language.Washing['enoughcops'], 'error')
            end
        end)
    else
        if NearWashPed() then 
            TriggerEvent('animations:client:EmoteCommandStart', {'point'})
            Wait(200)
            TriggerServerEvent('boii-moneylaunderer:sv:UseLaunderer')
            ClearPedTasks(player)
            washing = true
        end
    end
    if (chance >= math.random(1, 100)) then
        AlertPolice()
    end
end)
-- Wait for payment
RegisterNetEvent('boii-moneylaunderer:cl:PayPlayer', function(takeitem, amount)
    local timer = math.random(8,15) 
    Core.Functions.Progressbar('launderer_wait', Language.Washing['wait'], timer*1000, false, true, {
        disableMovement = false, 
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = 'anim@amb@board_room@supervising@',
        anim = 'think_01_hi_amy_skater_01',
        flags = 49,
    }, {}, {}, function()
        TriggerServerEvent('boii-moneylaunderer:sv:PayPlayer', amount)
        washing = false
    end, function() -- Cancel
        if Config.MoneyWash.Money.Take.Marked.Use then
            TriggerServerEvent('boii-moneylaunderer:sv:AddItem', takeitem, 1)
        end
        if Config.MoneyWash.Money.Take.Item.Use then
            TriggerServerEvent('boii-moneylaunderer:sv:AddItem', takeitem, amount)
        end
        TriggerEvent('inventory:client:busy:status', false)
        TriggerEvent('boii-moneylaunderer:notify', Language.Washing['cancelled'], 'primary')
        washing = false
    end) 
end)
--<!>-- EVENTS --<!>-- 

--<!>-- ALERTS --<!>--
RegisterNetEvent('boii-moneylaunderer:cl:AlertPolice', function()
	AlertPolice()
end)
function AlertPolice()
    if ServiceJob() then
        local player = PlayerPedId()
        local coords = GetEntityCoords(player)
        local alpha = 250
        local Blip = AddBlipForCoord(coords)
        SetBlipSprite(Blip,  161) -- Change blip here
		SetBlipColour(Blip,  1) -- Change blip colour here
		SetBlipScale(Blip, 1.5) -- Change blip scale here
        SetBlipAsShortRange(Blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(Language.Alert['blip'])
        EndTextCommandSetBlipName(Blip)
        TriggerServerEvent('boii-moneylaunderer:sv:NotifyPolice')
        while alpha ~= 0 do
            Wait(120*4)
            alpha = alpha - 1
            SetBlipAlpha(Blip, alpha)
            if alpha == 0 then
                RemoveBlip(Blip)
                return
            end
        end
    end
end
RegisterNetEvent('boii-moneylaunderer:cl:NotifyPolice', function(player)
    PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
	TriggerEvent('boii-moneylaunderer:notify', Language.Alert['notif'], 'police')
end)
--<!>-- ALERTS --<!>--
