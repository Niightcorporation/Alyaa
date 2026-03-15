do
repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local gameS = {
    130342654546662,
    131623223084840
}

local placeId = game.PlaceId
local gameS = false

for _, id in ipairs(gameS) do
    if id == placeId then
        isgameS = true
        break
    end
end

if isgameS then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Niightcorporation/Alyaa/refs/heads/main/Anixly.lua"))()
else
    player:Kick("Game not supported!\n\nPlace ID: " .. placeId)
end