RegisterCommand("help", function()
    msg("Server's Discord: Discord Name")
    msg("Server's Website: Website Name")
end, false)

function msg(text)
    TriggerEvent("chatMessage", "[Info]", {100,100,225}, text)
end