LinkLuaModifier( "modifier_ghost_3", "abilities/tower/ghost/ghost_3.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if ghost_3 == nil then
	ghost_3 = class({})
end
function ghost_3:GetIntrinsicModifierName()
	return "modifier_ghost_3"
end
---------------------------------------------------------------------
--Modifiers
if modifier_ghost_3 == nil then
	modifier_ghost_3 = class({}, nil, eom_modifier)
end
function modifier_ghost_3:OnCreated(params)
	self.count = self:GetAbilitySpecialValueFor("count")
	if IsServer() then
	end
end
function modifier_ghost_3:OnRefresh(params)
	self.count = self:GetAbilitySpecialValueFor("count")
	if IsServer() then
	end
end
function modifier_ghost_3:EDeclareFunctions()
	return {
		[EMDF_EVENT_CUSTOM] = { 
			{ET_PLAYER.ON_TOWER_DEATH, self.OnDeath},
			{ET_ENEMY.ON_DEATH, self.OnDeath},
		}
	}
end
function modifier_ghost_3:OnDeath()
	if self:GetAbility():IsAbilityReady() then
		self:GetAbility():UseResources(false, false, true)
		local tTargets = {}
		EachUnits(GetPlayerID(self:GetParent()), function (hUnit)
			table.insert(tTargets, hUnit)
		end, UnitType.Building)
		for i = 1, self.count do
			local hUnit = RandomValue(tTargets)
			if hUnit then
				ArrayRemove(tTargets, hUnit)
				hUnit:GiveMana(100)
				for j = 0, 2 do
					local hAbility = hUnit:GetAbilityByIndex(j)
					if hAbility ~= self:GetAbility() then
						hAbility:EndCooldown()
					end
				end
				local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/ghost/ghost_3.vpcf", PATTACH_CUSTOMORIGIN, nil)
				ParticleManager:SetParticleControlEnt(iParticleID, 0, hUnit, PATTACH_POINT_FOLLOW, "attach_hitloc", hUnit:GetAbsOrigin(), false)
				ParticleManager:SetParticleControlEnt(iParticleID, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), false)
				ParticleManager:ReleaseParticleIndex(iParticleID)
			end
		end
	end
end