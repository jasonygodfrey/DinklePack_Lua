local NPCID = 90002

local function ResetPlayerDisplayId(eventId, delay, repeats, player)
    player:SetDisplayId(player:GetNativeDisplayId())
end

local function PlatformTransportOnGossipHello(event, player, creature)
    player:GossipMenuAddItem(0, "Take me to the Air Field!", 0, 1)
    player:GossipSendMenu(1, creature)
end

local function PlatformTransportOnGossipSelect(event, player, creature, sender, intid, code)
    if (intid == 1) then
        player:GossipComplete()
		creature:CastSpell(player, 32992, true)
		player:CastSpell(player, 24085, true)
        player:SetDisplayId(25144)
        player:MoveJump(-4492, -1588, 509, 2000, 115)
        player:RegisterEvent(ResetPlayerDisplayId, 32000, 1) -- Adjust the delay time based on how long it takes to reach the destination
    end
end

RegisterCreatureGossipEvent(NPCID, 1, PlatformTransportOnGossipHello)
RegisterCreatureGossipEvent(NPCID, 2, PlatformTransportOnGossipSelect)
