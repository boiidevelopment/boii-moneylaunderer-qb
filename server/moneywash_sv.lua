----------------------------------
--<!>-- BOII | DEVELOPMENT --<!>--
----------------------------------

--<!>-- DO NOT EDIT ANYTHING BELOW THIS TEXT UNLESS YOU KNOW WHAT YOU ARE DOING SUPPORT WILL NOT BE PROVIDED IF YOU IGNORE THIS --<!>--
local Core = Config.CoreSettings.Core
local CoreFolder = Config.CoreSettings.CoreFolder
local Core = exports[CoreFolder]:GetCoreObject()
local CurrentCops = 0
--<!>-- DO NOT EDIT ANYTHING ABOVE THIS TEXT UNLESS YOU KNOW WHAT YOU ARE DOING SUPPORT WILL NOT BE PROVIDED IF YOU IGNORE THIS --<!>--


--<!>-- CALLBACKS --<!>--
Core.Functions.CreateCallback('boii-moneylaunderer:sv:CopCount', function(source, cb)
    for k, v in pairs(Core.Functions.GetQBPlayers()) do
        for i = 1, #Config.MoneyWash.Services.Job, 1 do
            if v.PlayerData.job.name == Config.MoneyWash.Services.Job[i].name  then
                CurrentCops = CurrentCops+1
            end
        end
    end
    cb(CurrentCops)
end)
--<!>-- CALLBACKS --<!>--

--<!>-- ADD/REMOVE ITEMS --<!>--
-- Remove item event; Added due to recent qb-core update.
RegisterServerEvent('boii-moneylaunderer:sv:RemoveItem', function(itemremove, amount)
    local source = source
    local Player = Core.Functions.GetPlayer(source)
    if Player.Functions.RemoveItem(itemremove, tonumber(amount)) then
        TriggerClientEvent('inventory:client:ItemBox', source, Core.Shared.Items[itemremove], 'remove', amount)
    end
end)
-- Add item event; Added due to recent qb-core update.
RegisterServerEvent('boii-moneylaunderer:sv:AddItem', function(itemadd, amount)
    local source = source
    local Player = Core.Functions.GetPlayer(source)
    if Player.Functions.AddItem(itemadd, tonumber(amount)) then
        TriggerClientEvent('inventory:client:ItemBox', source, Core.Shared.Items[itemadd], 'add', amount)
    end
end)
--<!>-- ADD/REMOVE ITEMS --<!>--

--<!>-- USE LAUNDERER --<!>--
RegisterServerEvent('boii-moneylaunderer:sv:UseLaunderer', function()
    local pData = Core.Functions.GetPlayer(source)
    if Config.MoneyWash.Money.Take.Item.Use then
        local takeitem = Config.MoneyWash.Money.Take.Item.Item.name
        if pData.Functions.GetItemByName(takeitem) ~= nil then
            if pData.Functions.GetItemByName(takeitem).amount >= Config.MoneyWash.Money.Take.Item.Minimum then
                amount = math.floor(math.random(Config.MoneyWash.Money.Take.Item.Minimum))
                pData.Functions.RemoveItem(takeitem, amount)
                TriggerClientEvent('inventory:client:ItemBox', source, Core.Shared.Items[takeitem], 'remove', amount)
                TriggerClientEvent('boii-moneylaunderer:notify', source, 'You handed over $'..amount..' in '..Config.MoneyWash.Money.Take.Item.Item.label..'!', 'primary')
                TriggerClientEvent('boii-moneylaunderer:cl:PayPlayer', source, takeitem, amount)
            else
                TriggerClientEvent('boii-moneylaunderer:notify', source, 'You dont have enough '..Config.MoneyWash.Money.Take.Item.Item.label..' with you..', 'error')
                print('not enough dirtycash')
            end
        else
            TriggerClientEvent('boii-moneylaunderer:notify', source, 'You dont have any '..Config.MoneyWash.Money.Take.Item.Item.label..' with you..', 'error')
            print('no dirtycash')
        end
    else
        local takeitem = Config.MoneyWash.Money.Take.Marked.Item.name
        if pData.Functions.GetItemByName(takeitem) ~= nil then
            for k, v in pairs(pData.PlayerData.items) do
                if v.name == takeitem then
                    if type(v.info) ~= 'string' and tonumber(v.info.worth) then
                        local amount = tonumber(v.info.worth)
                        pData.Functions.RemoveItem(takeitem, 1)
                        TriggerClientEvent('inventory:client:ItemBox', source, Core.Shared.Items[takeitem], 'remove')
                        TriggerClientEvent('boii-moneylaunderer:notify', source, 'You handed over $'..amount..' in '..Config.MoneyWash.Money.Take.Marked.Item.label..'!', 'primary')
                        TriggerClientEvent('boii-moneylaunderer:cl:PayPlayer', source, takeitem, amount)
                    end
                end
            end
        else
            TriggerClientEvent('boii-moneylaunderer:notify', source, 'You dont have any '..Config.MoneyWash.Money.Take.Marked.Item.label..' with you..', 'error')
            print('no marked bills')
        end
    end
end)
--<!>-- USE LAUNDERER --<!>--

--<!>-- RECEIVE PAYMENTS --<!>--
RegisterServerEvent('boii-moneylaunderer:sv:PayPlayer', function(amount)
    local pData = Core.Functions.GetPlayer(source)
    if CurrentCops ~= nil then
        percent = Config.MoneyWash.Money.Percentage
    elseif CurrentCops >= 1 and CurrentCops <= 3 then
        percent = Config.MoneyWash.Money.Percentage+0.15
    elseif CurrentCops <= 3 and CurrentCops >= 5 then
        percent = Config.MoneyWash.Money.Percentage+0.30
    elseif CurrentCops >= 7 then
        percent = Config.MoneyWash.Money.Percentage+0.45
    end
    local pay = math.floor(amount*percent)
    if Config.MoneyWash.Money.Return.Item.Use then
        local returnitem = Config.MoneyWash.Money.Return.Item.Item.name
        pData.Functions.AddItem(returnitem, pay)
        TriggerClientEvent('inventory:client:ItemBox', source, Core.Shared.Items[returnitem], 'add', pay)
        TriggerClientEvent('boii-moneylaunderer:notify', source, 'You received $'..pay..' in '..Config.MoneyWash.Money.Return.Item.Item.label..'!', 'success')
        return
    end
    if Config.MoneyWash.Money.Return.Money.Use then
        local moneytype = Config.MoneyWash.Money.Return.Money.Type
        pData.Functions.AddMoney(moneytype, pay, 'money-launderer')
        TriggerClientEvent('boii-moneylaunderer:notify', source, 'You received $'..pay..'!', 'success')
        return
    end
end)
--<!>-- RECEIVE PAYMENTS --<!>--

--<!>-- POLICE NOTIFY START --<!>--
RegisterNetEvent('boii-moneylaunderer:sv:NotifyPolice', function(player)
	local source = source
	local Players = Core.Functions.GetPlayers()
	for i = 1, #Players do
	local Player = Core.Functions.GetPlayer(Players[i])
        for j = 1, #Config.MoneyWash.Services.Job, 1 do
            if Player.PlayerData.job.name == Config.MoneyWash.Services.Job[j].name then
                TriggerClientEvent('boii-moneylaunderer:cl:NotifyPolice', Players[i], -1)
            end
        end
	end
end)
--<!>-- POLICE NOTIFY END --<!>--