LinkLuaModifier("modifier_enemy_lockpig", "abilities/special_abilities/enemy_lockpig.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_enemy_lockpig_lockbuff", "abilities/special_abilities/enemy_lockpig.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if enemy_lockpig == nil then
	enemy_lockpig = class({})
end
function enemy_lockpig:GetIntrinsicModifierName()
	return "modifier_enemy_lockpig"
end
---------------------------------------------------------------------
--Modifiers
if modifier_enemy_lockpig == nil then
	modifier_enemy_lockpig = class({}, nil, eom_modifier)
end
function modifier_enemy_lockpig:OnCreated(params)
	local iPlayerID = self:GetParent():GetPlayerOwnerID()
	local hParent = self:GetParent()
	self.bLoadBuff = true
	self.hUnit = {}
	if IsServer() then
		if self.bLoadBuff then
			EachUnits(iPlayerID, function(hUnit)
				table.insert(self.hUnit, hUnit)
				if hUnit:HasModifier('modifier_enemy_lockpig_lockbuff') then
					self.bLoadBuff = false
					return true
				end
			end, UnitType.Building)
			local hhUnit = GetRandomElement(self.hUnit)
			if self.bLoadBuff == true and hhUnit then
				hhUnit:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_enemy_lockpig_lockbuff", {})
			end
		end
	end
end
function modifier_enemy_lockpig:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_enemy_lockpig:OnDestroy()
	if IsServer() then
	end
end
function modifier_enemy_lockpig:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_IN_BATTLE,
	}
end

---------------------------------------------------------------------
--Modifiers
if modifier_enemy_lockpig_lockbuff == nil then
	modifier_enemy_lockpig_lockbuff = class({}, nil, eom_modifier)
end
function modifier_enemy_lockpig_lockbuff:OnCreated(params)
	self.incoming_pct = self:GetAbilitySpecialValueFor("incoming_pct")
	self.damage_factor = self:GetAbilitySpecialValueFor("damage_factor")
	self.range = self:GetAbilitySpecialValueFor("range")
	local iPlayerID = self:GetParent():GetPlayerOwnerID()
	local hParent = self:GetParent()
	if IsServer() then
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_bounty_hunter/bounty_hunter_track_shield.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
		local iParticleID1 = ParticleManager:CreateParticle("particles/units/heroes/hero_bounty_hunter/bounty_hunter_track_trail.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControlEnt(iParticleID1, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), false)
		self:AddParticle(iParticleID1, false, false, -1, false, false)
	end
end
function modifier_enemy_lockpig_lockbuff:OnRefresh(params)
	self.incoming_pct = self:GetAbilitySpecialValueFor("incoming_pct")
	self.damage_factor = self:GetAbilitySpecialValueFor("damage_factor")
	self.range = self:GetAbilitySpecialValueFor("range")
	if IsServer() then
	end
end
function modifier_enemy_lockpig_lockbuff:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_BATTLEING_END,
		EMDF_EVENT_ON_PREPARATION,
		[EMDF_INCOMING_PERCENTAGE] = self.incoming_pct,
		MODIFIER_EVENT_ON_DEATH
	}
end
function modifier_enemy_lockpig_lockbuff:GetIncomingPercentage()
	return self.incoming_pct
end
function modifier_enemy_lockpig_lockbuff:OnDeath(params)
	-- 死亡爆炸
	if params.unit == self:GetParent() then
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_techies/techies_blast_off.vpcf", PATTACH_ABSORIGIN, self:GetParent())
		ParticleManager:SetParticleControl(iParticleID, 0, self:GetParent():GetAbsOrigin())
		self:AddParticle(iParticleID, false, false, -1, false, false)
		self:Destroy()
	end
end
function modifier_enemy_lockpig_lockbuff:OnDestroy()
	local iPlayerID = self:GetParent():GetPlayerOwnerID()
	if IsServer() and GSManager:getStateType() == GS_Battle then
		-- if self:GetParent():IsAlive() then return end
		-- 造成伤害
		local hTargets = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.range, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false)
		local fDamage = self:GetParent():GetMaxHealth()
		for _, hTarget in ipairs(hTargets) do
			local tDamage = {
				ability = self:GetAbility(),
				attacker = self:GetParent(),
				victim = hTarget,
				damage = fDamage *	self.damage_factor,
				damage_type = DAMAGE_TYPE_MAGICAL
			}
			ApplyDamage(tDamage)
		end
		-- 转移
		if GSManager:getStateType() == GS_Battle then
			EachUnits(iPlayerID, function(hUnit)
				if not hUnit:HasModifier('modifier_enemy_lockpig_lockbuff') and hUnit then
					hUnit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_enemy_lockpig_lockbuff", {})
					return true
				end
			end, UnitType.Building)
		end
	end


end
function modifier_enemy_lockpig_lockbuff:OnBattleEnd()
	self:Destroy()
end
function modifier_enemy_lockpig_lockbuff:OnPreparation()
	local iPlayerID = self:GetParent():GetPlayerOwnerID()
	EachUnits(iPlayerID, function(hUnit)
		if hUnit:HasModifier('modifier_enemy_lockpig_lockbuff') and hUnit then
			hUnit:RemoveModifierByName("modifier_enemy_lockpig_lockbuff")
		end
	end, UnitType.Building)
end
function modifier_enemy_lockpig_lockbuff:IsDebuff()
	return true
end