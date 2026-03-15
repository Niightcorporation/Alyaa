do
repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local Games = {
    [131623223084840] = {
        name = "sambung-kata",
        url = "https://raw.githubusercontent.com/Niightcorporation/Alyaa/refs/heads/main/Anixly.lua"
    }
}

local placeId = game.PlaceId
local gameData = Games[placeId]

if gameData then
    loadstring(game:HttpGet(gameData.url))()
else
    local supported = ""
    for _,data in pairs(Games) do
        supported = supported .. "\n• " .. data.name
    end

    player:Kick("Game not supported!\n\nSupported Games:" .. supported)
end
end