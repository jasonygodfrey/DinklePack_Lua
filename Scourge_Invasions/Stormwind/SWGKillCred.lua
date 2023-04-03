local SWG_ID = {68, 400013, 400033, 400014, 1976}
local SPELL_ID = 100141

function OnSpellCast(event, caster, spell)
local target = spell:GetTarget()
if target and spell:GetEntry() == SPELL_ID then
local isValidTarget = false
for _, swgID in ipairs(SWG_ID) do
if target:GetEntry() == swgID then
isValidTarget = true
break
end
end
if not isValidTarget then
caster:SendBroadcastMessage("That target is not valid.")
spell:Cancel()
elseif target:HasAura(SPELL_ID) then
caster:SendBroadcastMessage("Target has already been empowered.")
spell:Cancel()
else
-- give kill credit to NPC ID 68
caster:KilledMonsterCredit(68)
end
end
end

RegisterPlayerEvent(5, OnSpellCast)