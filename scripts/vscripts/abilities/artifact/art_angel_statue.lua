LinkLuaModifier("modifier_art_angel_statue", "abilities/artifact/art_angel_statue.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_art_angel_statue_buff", "abilities/artifact/art_angel_statue.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if art_angel_statue == nil then
	art_angel_statue = class({}, nil, artifact_base)
end
function art_angel_statue:OnTowerDeath(hParent, tEvent)
	local hBuilding = tEvent.hBuilding
	local hUnit = hBuilding:GetUnitEntity()
	if hParent == hUnit then
		hUnit:EmitSound("Hero_Omniknight.GuardianAngel.Cast")
		EachUnits(GetPlayerID(hUnit), function(hTarget)
			if hTarget:IsAlive() then
				-- hTarget:AddBuff(self:GetParent(), BUFF_TYPE.INVINCIBLE, self:GetAbility():GetSpecialValueFor("duration"))
				hTarget:AddNewModifier(hParent, self, "modifier_art_angel_statue_buff", { duration = self:GetSpecialValueFor("duration") })
			end
		end, UnitType.AllFirends)
	end
end
-- function art_angel_statue:GetIntrinsicModifierName()
-- 	return "modifier_art_angel_statue"
-- end
---------------------------------------------------------------------
--Modifiers
if modifier_art_angel_statue == nil then
	modifier_art_angel_statue = class({}, nil, eom_modifier)
end
function modifier_art_angel_statue:IsHidden()
	return true
end
function modifier_art_angel_statue:OnCreated(params)
	if IsServer() then
	end
end
function modifier_art_angel_statue:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_art_angel_statue:OnDestroy()
	if IsServer() then
	end
end
function modifier_art_angel_statue:EDeclareFunctions()
	return {
		[EMDF_EVENT_CUSTOM] = { ET_PLAYER.ON_TOWER_DEATH, self.OnTowerDeath }
	}
end
function modifier_art_angel_statue:OnTowerDeath(tEvent)
	local hBuilding = tEvent.hBuilding
	local hUnit = hBuilding:GetUnitEntity()
	hUnit:EmitSound("Hero_Omniknight.GuardianAngel.Cast")
	EachUnits(GetPlayerID(hUnit), function(hTarget)
		if hTarget:IsAlive() then
			-- hTarget:AddBuff(self:GetParent(), BUFF_TYPE.INVINCIBLE, self:GetAbility():GetSpecialValueFor("duration"))
			hTarget:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_art_angel_statue_buff", { duration = self:GetAbility():GetSpecialValueFor("duration") })
		end
	end, UnitType.AllFirends)
end
---------------------------------------------------------------------
if modifier_art_angel_statue_buff == nil then
	modifier_art_angel_statue_buff = class({}, nil, eom_modifier)
end
function modifier_art_angel_statue_buff:IsHidden()
	return false
end
function modifier_art_angel_statue_buff:OnCreated(params)
	self.incoming_reduce = self:GetAbilitySpecialValueFor('incoming_reduce')
	if IsServer() then
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_omniknight/omniknight_guardian_angel_ally.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
-- function modifier_art_angel_statue_buff:GetAbsoluteNoDamageMagical()
-- 	return 1
-- end
-- function modifier_art_angel_statue_buff:GetAbsoluteNoDamagePhysical()
-- 	return 1
-- end
-- function modifier_art_angel_statue_buff:GetAbsoluteNoDamagePure()
-- 	return 1
-- end
function modifier_art_angel_statue_buff:DeclareFunctions()
	return {
		-- MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		-- MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		-- MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}
end
function modifier_art_angel_statue_buff:GetModifierIncomingDamage_Percentage()
	return -self.incoming_reduce
end