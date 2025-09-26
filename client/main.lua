--local debug = false
-- DEV COMMAND

--if debug then
--    RegisterCommand('sp1', function()
--        local POS = GetEntityCoords(PlayerPedId())
--        TriggerEvent('ex-spawn:location:open', POS , false)
--    end)
--end

local JAILED = false
local IS_USE_CUSTOM_PED = false

local JAIL_TIME = 0

local PRISON_POS = { x = 1771.33, y = 2491.52, z = 45.74, h = 122.79 } -- PRISON LOCATION
local LAST_LOCATION = {}

local SPAWN_LIST = {
    [1] = { coords = vector3(-1308.44, -919.22, 11.28), label = "Motel" },
    [2] = { coords = vector3(1901.61, 3703.68, 33.53), label = "Sandy" },
    [3] = { coords = vector3(80.24, 6423.54, 32.27), label = "Paleto" },
}

local FIRST_SPAWN = true

RegisterCommand('testspawn', function(source, args)
    lib.callback.await('ex-spawn:location:spawn', false)
end)

-- INIT
RegisterNetEvent("ex-spawn:location:open")
AddEventHandler("ex-spawn:location:open", function(position, isCustomPed, lastlokasi)
    -- if not FIRST_SPAWN then return end
    FIRST_SPAWN = lastlokasi
    LAST_LOCATION = position
    IS_USE_CUSTOM_PED = isCustomPed

    -- local HAS_APT = TriggerServerCallback {
    --     eventName = "spawn:selection:check:has:apt",
    --     args = {}
    -- }

    -- local HAS_VIP_HOUSE = TriggerServerCallback {
    --     eventName = "spawn:selection:check:has:vip:house",
    --     args = {}
    -- }

    -- local HAS_PERSONAL_HOUSE = TriggerServerCallback {
    --     eventName = "spawn:selection:check:has:personal:house",
    --     args = {}
    -- }

    -- if debug then
    --     print(json.encode(HAS_APT))
    --     print(json.encode(HAS_VIP_HOUSE))
    --     print(json.encode(HAS_PERSONAL_HOUSE))
    -- end

    -- if HAS_APT.has then
    --     SendNUIMessage({
    --         action = "has_apartment",
    --         info = { HAS_APT.info }
    --     })
    -- end

    -- if HAS_VIP_HOUSE.has then
    --     SendNUIMessage({
    --         action = "has_vip_house",
    --         info = { HAS_VIP_HOUSE.info }
    --     })
    -- end

    -- if HAS_PERSONAL_HOUSE.has then
    --     SendNUIMessage({
    --         action = "has_personal_house",
    --         info = { HAS_PERSONAL_HOUSE.info }
    --     })
    -- end

    if FIRST_SPAWN == true then
        SendNUIMessage({
            action = "showfirstspawn",
            data = SPAWN_LIST,
            last = LAST_LOCATION,
        })
    end

    SendNUIMessage({
        data = SPAWN_LIST,
    })

    SetNuiFocus(true, true)
    -- FIRST_SPAWN = false
end)

-- EVENTS
AddEventHandler("spawn:selection:load:player", function(pos, last_position, apartment, vip_house, personal_house, info)
    DEL_CAM()

    if debug then
        print(json.encode(pos))
        print(json.encode(last_position))
        print(json.encode(apartment))
        print(json.encode(vip_house))
        print(json.encode(personal_house))
        print(json.encode(info))
    end

    local CAMERA_POSITION = last_position and { x = LAST_LOCATION.x, y = LAST_LOCATION.y, z = LAST_LOCATION.z } or
        { x = pos.x, y = pos.y, z = pos.z }

    DO_CAM(CAMERA_POSITION.x, CAMERA_POSITION.y, CAMERA_POSITION.z)

    DoScreenFadeOut(200)

    while not IsScreenFadingOut() do
        Wait(0)
    end

    Wait(500)

    DEL_CAM()

    local SPAWN_LOCATION = last_position and { x = LAST_LOCATION.x, y = LAST_LOCATION.y, z = LAST_LOCATION.z } or
        { x = pos.x, y = pos.y, z = pos.z }

    RequestCollisionAtCoord(SPAWN_LOCATION.x, SPAWN_LOCATION.y, SPAWN_LOCATION.z)
    SetEntityCoordsNoOffset(PlayerPedId(), SPAWN_LOCATION.x, SPAWN_LOCATION.y, SPAWN_LOCATION.z, false, false, false,
        true)
    SetEntityVisible(PlayerPedId(), true)
    FreezeEntityPosition(PlayerPedId(), false)
    NetworkResurrectLocalPlayer(SPAWN_LOCATION.x, SPAWN_LOCATION.y, SPAWN_LOCATION.z, 90.0, true, true, false)

    local startedCollision = GetGameTimer()

    while not HasCollisionLoadedAroundEntity(PlayerPedId()) do
        if GetGameTimer() - startedCollision > 8000 then break end
        Wait(0)
    end

    Wait(500)

    while IsScreenFadingIn() do
        Wait(0)
    end

    -- TriggerServerEvent('ex_attribute:CheckAttribute')
    -- TriggerEvent("qy-spawn:client:jailCheck")
    -- exports['ex-emergency-blip']:emergencyblip()

    -- local DEAD = TriggerServerCallback {
    --     eventName = "spawn:selection:check:dead",
    --     args = {}
    -- }

    -- if DEAD then
    --     TriggerEvent('excore_ambulancejob:DeadLogin')
    -- end

    if last_position then
        CHECK_SAFE_LOCATION(LAST_LOCATION)
        SPAWN_UNDERGROUND()
        CHECK_PRECISION_LAST_LOCATION(LAST_LOCATION)
    end

    -- local LAST_HEALTH = exports["isPed"]:isPed("last_health")
    -- SetEntityHealth(PlayerPedId(), LAST_HEALTH)

    --TriggerServerEvent("ex-mdw:get:dispatch")

    -- TriggerEvent('ex-inventory:attachblock', false)
    -- TriggerEvent('ex-nono-dispatch:PlayerSpawned')
    -- TriggerEvent('ex-secondary-job:LoadData')
    -- TriggerEvent('ex-nono-mdw:setPlayerData')

    -- local IN_JAIL = TriggerServerCallback {
    --     eventName = "spawn:selection:check:jail",
    --     args = {}
    -- }

    -- if IN_JAIL.jail then
    --     JAILED = IN_JAIL.jail
    --     JAIL_TIME = IN_JAIL.time

    --     exports['ex-notifications']:DoShortHudText('inform',
    --         'You currently in jail for ' .. JAIL_TIME .. ' minutes. Moved to the boiling broke.')
    --     SetEntityCoords(PlayerPedId(), PRISON_POS.x, PRISON_POS.y, PRISON_POS.z)
    --     exports['ex-prisonwork']:CreateObjectShit()
    --     exports['ex-prisonwork']:CreateObjectCraft()
    --     DoScreenFadeIn(1000)
    --     TriggerServerEvent("ex-spawn:location:finish:client")
    --     goto skip
    -- end

    -- local APT_SPAWN = RPC.execute("apartment:check:login", apartment, info)

    -- if APT_SPAWN.spawn then
    --     DoScreenFadeIn(1000)
    --     goto skip
    -- end

    -- local VIP_SPAWN = vip_house and true or false
    -- if VIP_SPAWN then
    --     DoScreenFadeIn(1000)
    --     TriggerServerEvent("ex-spawn:location:finish:client")
    --     goto skip
    -- end

    -- local PERSONAL_HOUSE_SPAWN = RPC.execute("personal:house:check:login", personal_house, info)
    -- if PERSONAL_HOUSE_SPAWN.spawn then
    --     DoScreenFadeIn(1000)

    --     goto skip
    -- end

    ::move::

    DoScreenFadeIn(1000)
    -- TriggerServerEvent("ex-spawn:location:finish:client")
    TriggerServerEvent('QBCore:Server:OnPlayerLoaded')
    TriggerEvent('QBCore:Client:OnPlayerLoaded')

    ::skip::
end)