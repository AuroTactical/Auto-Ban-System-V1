Configuration = require(script:FindFirstChild("Configuration"))

-- // Main Script
local Banned = {}
local function checkAndKickBannedPlayers()
    for _, data in pairs(Banned) do
        local userId, banReason = data[1], data[2]
        for _, player in ipairs(game.Players:GetPlayers()) do
            if player.UserId == userId then
                player:Kick("You are banned from this game. Reason: " .. banReason)
            end
        end
    end
end

local function updateBannedList()
    local pastebinURL = Configuration.Pastebin.Raw_URL
    local scriptContent = game.HttpService:GetAsync(pastebinURL)
    local updatedBanned = {}

    if scriptContent then
        for line in scriptContent:gmatch("[^\r\n]+") do
            local playerId, reason = line:match("([^,]+),([^,]+)")
            table.insert(updatedBanned, {tonumber(playerId), reason})
        end
    end

    Banned = updatedBanned
end

game.Players.PlayerAdded:Connect(checkAndKickBannedPlayers)

while true do
    updateBannedList()
    checkAndKickBannedPlayers()
    wait(Configuration.Settings.WaitToUpdate)
end
