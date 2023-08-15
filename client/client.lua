local RSGCore = exports['rsg-core']:GetCoreObject()
local treasurejob = false
local treasuretodig = nil
local cooldown = false
local blips

function pegangmap()
	animateMap("mech_inspection@two_fold_map@satchel", "enter")
end

function RangerMap()
    ClearPedTasks(PlayerPedId())
    RemoveAnimDict(dictar)
	animateMap(PlayerPedId(), "mech_inspection@two_fold_map@satchel", "exit_satchel")
end

function animateMap(v1,v2)
    local dictar = v1
    local antar = v2
    if not DoesAnimDictExist(dictar) then
		print("Invalid animation dictionary: " .. dictar)
		return
	end
	RequestAnimDict(dictar)
	while not HasAnimDictLoaded(dictar) do
		Wait(0)
	end
    TaskPlayAnim(PlayerPedId(), dictar, antar, -1.0, -0.5, -1   ,14, 0, true, 0, false, 0, false)
end
-----------------------------------------------------------------------------------

-- treasure location set GPS
RegisterNetEvent('rsg-treasure:client:gototreasure')
AddEventHandler('rsg-treasure:client:gototreasure', function()
    local coords = GetEntityCoords(PlayerPedId())
    if not treasurejob and not cooldown then
        local props = CreateObject(GetHashKey("s_twofoldmap01x_us"), coords.x, coords.y, coords.z, 1, 0, 1)
        local prop = props
        Citizen.InvokeNative(0xEA47FE3719165B94, PlayerPedId(), "mech_carry_box", "idle", 1.0, 8.0, -1, 31, 0, 0, 0, 0)
        Citizen.InvokeNative(0x6B9BBD38AB0796DF, prop, PlayerPedId(), GetEntityBoneIndexByName(PlayerPedId(), "SKEL_L_Finger12"), 0.20, 0.00, -0.15, 180.0, 190.0, 0.0, true, true, false, true, 1, true)
        pegangmap()
        Wait(10000)
        TriggerServerEvent('rsg-treasure:server:removeitem', 'treasure1', 1)
        RSGCore.Functions.Notify('Check Your Map For Treasure Location', 'primary', 5000)
        treasurejob = true
        cooldown = true
        treasuretodig = Config.Locations[math.random(#Config.Locations)]
        blips = Citizen.InvokeNative(0x45F13B7E0A15C880, GetHashKey("BLrsg_STYLE_CAR"), treasuretodig, 50.0)
        SetBlipSprite(blips, true)
        RangerMap()
        ClearPedSecondaryTask(GetPlayerPed(PlayerId()))
        DetachEntity(prop, false, true)
        ClearPedTasks(PlayerPedId())
        DeleteObject(prop)
        TriggerEvent('rsg-treasure:client:MetalDetector')
        TriggerEvent('rsg-treasure:client:MetalDetectorBeep')
    elseif cooldown == true then
        RSGCore.Functions.Notify('Wait 10 Minute To Start Treasure Map', 'error', 5000)
    end
end)

CreateThread(function()
	while true do
		Wait(10)
		if cooldown then
			Wait(600000)
			cooldown = false
		end
	end
end)

AddEventHandler('rsg-treasure:client:MetalDetector', function()
    CreateThread(function()
        while treasurejob do
            Wait(100)
            local pos = GetEntityCoords(PlayerPedId())
            local isonmount = IsPedOnMount(PlayerPedId())
            local weaponhash = Citizen.InvokeNative(0x8425C5F057012DAB, PlayerPedId())
            for _, treasureCoords in pairs(Config.Locations) do
                local dist = #(pos - treasureCoords)
                if weaponhash == -862059856 and isonmount == false then
                    if dist < 10 then
                        Citizen.InvokeNative(0x437C08DB4FEBE2BD, PlayerPedId(), "MetalDetectorDetectionValue", 0.1, -1)
                    end
                    if dist < 9 then
                        Citizen.InvokeNative(0x437C08DB4FEBE2BD, PlayerPedId(), "MetalDetectorDetectionValue", 0.2, -1)
                    end
                    if dist < 8 then
                        Citizen.InvokeNative(0x437C08DB4FEBE2BD, PlayerPedId(), "MetalDetectorDetectionValue", 0.3, -1)
                    end
                    if dist < 7 then
                        Citizen.InvokeNative(0x437C08DB4FEBE2BD, PlayerPedId(), "MetalDetectorDetectionValue", 0.4, -1)
                    end
                    if dist < 6 then
                        Citizen.InvokeNative(0x437C08DB4FEBE2BD, PlayerPedId(), "MetalDetectorDetectionValue", 0.5, -1)
                    end
                    if dist < 5 then
                        Citizen.InvokeNative(0x437C08DB4FEBE2BD, PlayerPedId(), "MetalDetectorDetectionValue", 0.6, -1)
                    end
                    if dist < 4 then
                        Citizen.InvokeNative(0x437C08DB4FEBE2BD, PlayerPedId(), "MetalDetectorDetectionValue", 0.7, -1)
                    end
                    if dist < 3 then
                        Citizen.InvokeNative(0x437C08DB4FEBE2BD, PlayerPedId(), "MetalDetectorDetectionValue", 0.8, -1)
                    end
                    if dist < 2 then
                        Citizen.InvokeNative(0x437C08DB4FEBE2BD, PlayerPedId(), "MetalDetectorDetectionValue", 0.9, -1)
                    end
                    if dist < 1 then
                        Citizen.InvokeNative(0x437C08DB4FEBE2BD, PlayerPedId(), "MetalDetectorDetectionValue", 1.0, -1)
                        exports['rsg-core']:DrawText('use [E] to Dig', 'left')
                        if IsControlJustReleased(0, 0xCEFD9220) then
                            exports['rsg-core']:HideText()
                            SetCurrentPedWeapon(PlayerPedId(), `WEAPON_UNARMED`, true)
                            Citizen.InvokeNative(0x437C08DB4FEBE2BD, PlayerPedId(), "MetalDetectorDetectionValue", 0.0, -1)
                            TriggerEvent('rsg-treasure:clent:digging', treasureCoords)
                            RemoveBlip(blips)
                            SetGpsMultiRouteRender(false)
                            treasurejob = false
                            cooldown = true
                        end
                    end
                end
            end
        end
    end)
end)

AddEventHandler('rsg-treasure:client:MetalDetectorBeep', function()
    CreateThread(function()
        while treasurejob do
            Wait(100)
            local pos = GetEntityCoords(PlayerPedId())
            local isonmount = IsPedOnMount(PlayerPedId())
            local weaponhash = Citizen.InvokeNative(0x8425C5F057012DAB, PlayerPedId())
            for _, treasureCoords in pairs(Config.Locations) do
                local dist = #(pos - treasureCoords)
                if weaponhash == -862059856 and isonmount == false then
                    if dist < 1 then
                        TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 10, 'metaldetector', 0.5)
                        Wait(500)
                    elseif dist < 5 then
                        TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 10, 'metaldetector', 0.3)
                        Wait(1000)
                    elseif dist < 10 then
                        TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 10, 'metaldetector', 0.1)
                        Wait(2000)
                    end
                end
            end
        end
    end)
end)

function StartAnimation(animDict,flags,playbackListName,p3,p4,groundZ,time)
    CreateThread(function()
        local aCoord = GetEntityCoords(PlayerPedId())
        local pCoord = GetOffsetFromEntityInWorldCoords(PlayerPedId(), -10.0, 0.0, 0.0)
        local pRot = GetEntityRotation(PlayerPedId())

        if groundZ then
            local a, groundZ = GetGroundZAndNormalFor_3dCoord( aCoord.x, aCoord.y, aCoord.z + 10 )
            aCoord = {x=aCoord.x, y=aCoord.y, z=groundZ}
        end

        local animScene = Citizen.InvokeNative(0x1FCA98E33C1437B3, animDict, flags, playbackListName, 0, 1)
        Citizen.InvokeNative(0x020894BF17A02EF2, animScene, aCoord.x, aCoord.y, aCoord.z, pRot.x, pRot.y, pRot.z, 2) 
        Citizen.InvokeNative(0x8B720AD451CA2AB3, animScene, "player", PlayerPedId(), 0)

        local modelhash = `p_strongbox_muddy_01x`
        RequestModel(modelhash)
        while not HasModelLoaded(modelhash) do
            Wait(10)
        end
        local chest = CreateObjectNoOffset(modelhash, pCoord, true, true, false, true)
        Citizen.InvokeNative(0x8B720AD451CA2AB3, animScene, "CHEST", chest, 0)
        Citizen.InvokeNative(0xAF068580194D9DC7, animScene)
        Wait(1000)
        Citizen.InvokeNative(0xF4D94AF761768700, animScene)
        if time then
            Wait(tonumber(time))
        else
            Wait(10000)
        end
        Citizen.InvokeNative(0x84EEDB2C6E650000, animScene)
        ClearPedTasks(PlayerPedId())
        DeleteObject(chest)
    end)
end

-- dig for treasure
RegisterNetEvent("rsg-treasure:clent:digging")
AddEventHandler("rsg-treasure:clent:digging", function(chest)
    local hasItem = RSGCore.Functions.HasItem('shovel', 1)
    if hasItem then
        StartAnimation('scrrsgt@mech@treasure_hunting@chest', 0, 'PBL_CHEST_01', 0, 1, true, 10000)
        Wait(10000)
        TriggerServerEvent('rsg-treasure:server:givereward', chest)
    else
        RSGCore.Functions.Notify('You Need A Shovel To Dig Treasure', 'error', 5000)
    end
end)

-- dig up chest animation

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        RemoveBlip(blips)
        SetGpsMultiRouteRender(false)
        treasurejob = false
    end
end)