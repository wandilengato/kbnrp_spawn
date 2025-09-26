local CAM = 0

local UNDERGROUND_SAFE_LOCATION = { x = -1349.21, y = -931.6, z = 11.75 } -- MOTEL LOCATION
local MOVED = false

function SPAWN_UNDERGROUND()
    local POS = GetEntityCoords(PlayerPedId())
    local UNDERGROUND = vector3(0.0, 0.0, 0.0)

    if #(POS - UNDERGROUND) < 40 then
        local zone = UNDERGROUND_SAFE_LOCATION

        SetEntityCoords(PlayerPedId(), zone.x, zone.y, zone.z)
        MOVED = true
    end
end

function CHECK_SAFE_LOCATION(pos)
    for height = 1, 1000 do
        SetPedCoordsKeepVehicle(PlayerPedId(), pos.x, pos.y, pos.z + height)

        local foundGround, zPos = GetGroundZFor_3dCoord(pos.x, pos.y, pos.z + height)

        if foundGround then
            SetPedCoordsKeepVehicle(PlayerPedId(), pos.x, pos.y, pos.z + height)
            break
        end

        Wait(5)
    end
end

function CHECK_PRECISION_LAST_LOCATION(pos)
    if not MOVED then
        local pedCoord = GetEntityCoords(PlayerPedId())
        local last = vector3(pos.x, pos.y, pos.z)

        while #(pedCoord - last) > 20.0 do
            SetEntityCoords(PlayerPedId(), pos.x, pos.y, pos.z + 0.1)
            pedCoord = GetEntityCoords(PlayerPedId())
            Wait(300)
        end
    end
end

function DEL_CAM()
    ClearFocus()
    DestroyAllCams(true)
    RenderScriptCams(false, true, 1, true, true)
end

function DO_CAM(x, y, z)
    DoScreenFadeOut(1)

    if (not DoesCamExist(CAM)) then
        CAM = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
    end

    local i = 3200

    SetFocusArea(x, y, z, 0.0, 0.0, 0.0)
    SetCamActive(CAM, true)
    RenderScriptCams(true, false, 0, true, true)
    DoScreenFadeIn(1500)

    local camAngle = -90.0

    while i > 1 do
        local factor = i / 50

        if i < 1 then i = 1 end

        i = i - factor
        SetCamCoord(CAM, x, y, z + i)

        if i < 1200 then
            DoScreenFadeIn(600)
        end

        if i < 90.0 then
            camAngle = i - i - i
        end

        SetCamRot(CAM, camAngle, 0.0, 0.0)
        Wait(2 / i)
    end
end

function LOAD_PLAYER(pos, last_position, apartment, vip_house, personal_house, info)
    DoScreenFadeOut(1000)
    SetNuiFocus(false, false)
    TriggerEvent("spawn:selection:load:player", pos, last_position, apartment, vip_house, personal_house, info)
end