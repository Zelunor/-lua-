player = nil 
status = false
-- speler is bezig met een emotie

RegisterCommand("emotie", function(source, args)
    player = GetPlayerped(-1)
    local emoteToPlay = args[1]
    -- /emotie jog
    if GetVehiclePedIsIn(player, false) ~= 0 then return end;
    
    startEmotie(emoteToPlay)
end)

function starEmote(anim)
    if emotes[anim] and player and status == false then
        TaskStartScenarioInPlace(player, emotes[anim].anim, 0, true)
        status = true
    else
        return;
    end
end

Citizen.CreateThread(function()
    while true do
        if status then 
            if
                IsControlPressed(1, 32)-- [W] toets
                or IsControlPressed(1, 34)-- [A] toets
                or IsControlPressed(1, 33)-- [S] toets
                or IsControlPressed(1, 35)-- [D] toets
                or IsControlPressed(1, 55)-- [Spatie] toets
            then
                ClearPedTaskes(player)
                status = false
            end
        end
        Citizen.Wait(0)
    end
end)