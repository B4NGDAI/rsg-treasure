local RSGCore = exports['rsg-core']:GetCoreObject()

RSGCore.Functions.CreateUseableItem("treasure", function(source, item)
    TriggerClientEvent("ip-treasure:client:gototreasure", source)
end)

-----------------------------------------------------------------------------------

RegisterNetEvent('rsg-treasure:server:givereward', function()
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    local chance = math.random(1, 100)

    -- common reward (95% chance)
    if chance <= 95 then -- reward : 3 x common
        local item1 = Config.CommonItems[math.random(1, #Config.CommonItems)]
        local item2 = Config.CommonItems[math.random(1, #Config.CommonItems)]
        local item3 = Config.CommonItems[math.random(1, #Config.CommonItems)]

        -- add items
        Player.Functions.AddItem(item1, math.random(1, 3))
        Player.Functions.AddItem(item2, math.random(1, 3))
        Player.Functions.AddItem(item3, math.random(1, 3))

        TriggerClientEvent("inventory:client:ItemBox", src, RSGCore.Shared.Items[item1], "add")
        TriggerClientEvent("inventory:client:ItemBox", src, RSGCore.Shared.Items[item2], "add")
        TriggerClientEvent("inventory:client:ItemBox", src, RSGCore.Shared.Items[item3], "add")

        -- rare reward (5% chance)
    elseif chance > 95 then -- reward : 1 x rare and 2 x common
        local item1 = Config.RareItems[math.random(1, #Config.RareItems)]
        local item2 = Config.CommonItems[math.random(1, #Config.CommonItems)]
        local item3 = Config.CommonItems[math.random(1, #Config.CommonItems)]

        -- add items
        Player.Functions.AddItem(item1, 1)
        Player.Functions.AddItem(item2, math.random(1, 3))
        Player.Functions.AddItem(item3, math.random(1, 3))

        TriggerClientEvent("inventory:client:ItemBox", src, RSGCore.Shared.Items[item1], "add")
        TriggerClientEvent("inventory:client:ItemBox", src, RSGCore.Shared.Items[item2], "add")
        TriggerClientEvent("inventory:client:ItemBox", src, RSGCore.Shared.Items[item3], "add")
    else
        print("Something went wrong check for exploit!")
    end
end)

-----------------------------------------------------------------------------------

-- remove item/amount
RegisterServerEvent('rsg-treasure:server:removeitem')
AddEventHandler('rsg-treasure:server:removeitem', function(item, amount)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)

    if Player.Functions.RemoveItem(item, amount) then
        TriggerClientEvent('inventory:client:ItemBox', src, RSGCore.Shared.Items[item], 'remove')
    end
end)

-----------------------------------------------------------------------------------