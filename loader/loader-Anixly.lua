do
repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local supportedIds = { 
    130342654546662,
    131623223084840
}

local placeId = game.PlaceId
local isSupported = false  

for _, id in ipairs(supportedIds) do
    if id == placeId then
        isSupported = true
        break
    end
end

if isSupported then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Niightcorporation/Alyaa/refs/heads/main/Anixly.lua"))()
else
    player:Kick("Game not supported!\n\nPlace ID: " .. placeId)
end

end