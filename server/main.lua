local Players = {}

lib.callback.register('ex-spawn:location:spawn', function(source)
    local src = source
    local player = exports.qbx_core:GetPlayer(src)
    if not player then return end
    local position = player.position
    local citizenid = player.PlayerData.citizenid

    if Players[citizenid] == nil or os.time() - Players[citizenid] > 3600 then
        TriggerClientEvent('ex-spawn:location:open', src, position, false, false)
    else
        TriggerClientEvent('ex-spawn:location:open', src, position, false, true)
    end
end)