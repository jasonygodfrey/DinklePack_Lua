-- Save Location Script

local SAVE_LOCATION_SPELL = 312370
local TELEPORT_BACK_DURATION = 900000 -- 15 minutes in milliseconds

local savedLocations = {}

local function OnSaveLocationCast(event, player, spell)
    if spell:GetEntry() == SAVE_LOCATION_SPELL then
        local playerGuid = player:GetGUIDLow()
        if not savedLocations[playerGuid] then
            local mapId, x, y, z, orientation = player:GetMapId(), player:GetX(), player:GetY(), player:GetZ(), player:GetO()
            savedLocations[playerGuid] = { mapId = mapId, x = x, y = y, z = z, orientation = orientation }
            player:SendBroadcastMessage("Your save location has been stored for 15 minutes.")

            -- Remove saved location after 15 minutes
            local function RemoveSavedLocation(eventId, delay, repeats, player)
                savedLocations[playerGuid] = nil
                player:SendBroadcastMessage("Your saved location has expired.")
            end
            CreateLuaEvent(RemoveSavedLocation, TELEPORT_BACK_DURATION, 1, player)
        end
    end
end

RegisterPlayerEvent(5, OnSaveLocationCast)


-- Teleport Back Script

local TELEPORT_BACK_SPELL = 312372
local SPELL_ON_TELEPORT = 51908

local function OnTeleportBackCast(event, player, spell)
    if spell:GetEntry() == TELEPORT_BACK_SPELL then
        local playerGuid = player:GetGUIDLow()
        if savedLocations[playerGuid] then
            local savedLocation = savedLocations[playerGuid]
            player:Teleport(savedLocation.mapId, savedLocation.x, savedLocation.y, savedLocation.z, savedLocation.orientation)
            player:CastSpell(player, SPELL_ON_TELEPORT, true)
            savedLocations[playerGuid] = nil
            player:SendBroadcastMessage("You have been teleported back to your camp.")

            -- Remove saved location after teleport
            savedLocations[playerGuid] = nil
            player:SendBroadcastMessage("Your saved location has expired.")
        else
            player:SendBroadcastMessage("No saved location found.")
        end
    end
end

RegisterPlayerEvent(5, OnTeleportBackCast)
