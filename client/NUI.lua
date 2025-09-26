RegisterNUICallback("spawn:selection:close", function(data, cb)
    SetNuiFocus(false, false)
    DoScreenFadeOut(1000)
    cb("ok")
end)

RegisterNUICallback("spawn:selection:spawning", function(data, cb)
    local COORDS = data.coords
    local APARTMENT = data.apartment
    local VIP = data.vip
    local HOUSE = data.house
    local INFO = data.info

    LOAD_PLAYER(COORDS, false, APARTMENT, VIP, HOUSE, INFO)

    cb("ok")
end)

RegisterNUICallback("spawn:selection:last:location", function(data, cb)
    local COORDS = data.coords
    local APARTMENT = data.apartment
    local VIP = data.vip
    local HOUSE = data.house
    local INFO = data.info

    LOAD_PLAYER(COORDS, true, APARTMENT, VIP, HOUSE, INFO)
    cb("ok")
end)
