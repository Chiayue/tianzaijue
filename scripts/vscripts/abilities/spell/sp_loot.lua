LinkLuaModifier("modifier_sp_loot_buff", "abilities/spell/sp_loot.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if sp_loot == nil then
	sp_loot = class({}, nil, sp_base)
end
function sp_loot:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function sp_loot:OnSpellStart()
	local hCaster = self:GetCaster()
	local radius = self:GetSpecialValueFor("radius")
	local duration = self:GetSpecialValueFor("duration")
	local vPosition = self:GetCursorPosition()
	local iTeamNumber = hCaster:GetTeamNumber()

	DotaTD:EachPlayer(function(_, iPlayerID)
		if PlayerData:IsPointInPlayerRange(iPlayerID, vPosition) then
			iTeamNumber = PlayerData:GetHero(iPlayerID):GetTeamNumber()
		end
	end)

	local iParticleID = ParticleManager:CreateParticle("particles/econ/generic/generic_aoe_shockwave_1/generic_aoe_shockwave_1.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iParticleID, 0, vPosition)
	ParticleManager:SetParticleControl(iParticleID, 1, Vector(radius, radius, radius))
	ParticleManager:SetParticleControl(iParticleID, 2, Vector(1, 10, 1))
	ParticleManager:SetParticleControl(iParticleID, 3, Vector(238, 232, 170))
	ParticleManager:SetParticleControl(iParticleID, 4, Vector(255, 223, 66))
	ParticleManager:ReleaseParticleIndex(iParticleID)

	local tTargets = FindUnitsInRadius(iTeamNumber, vPosition, nil, radius, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), FIND_ANY_ORDER, false)
	for _, hTarget in pairs(tTargets) do
		hTarget:AddNewModifier(hCaster, self, "modifier_sp_loot_buff", { duration = duration })
	end
end
---------------------------------------------------------------------
--Modifiers
if modifier_sp_loot_buff == nil then
	modifier_sp_loot_buff = class({}, nil, eom_modifier)
end
function modifier_sp_loot_buff:IsHidden()
	return false
end
function modifier_sp_loot_buff:IsDebuff()
	return false
end
function modifier_sp_loot_buff:IsPurgable()
	return true
end
function modifier_sp_loot_buff:IsPurgeException()
	return true
end
function modifier_sp_loot_buff:IsStunDebuff()
	return false
end
function modifier_sp_loot_buff:GetEffectName()
	return "particles/econ/items/bounty_hunter/bounty_hunter_hunters_hoard/bounty_hunter_hoard_shield.vpcf"
end
function modifier_sp_loot_buff:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end
function modifier_sp_loot_buff:ShouldUseOverheadOffset()
	return true
end
function modifier_sp_loot_buff:OnCreated(params)
	self.attack_per_gold = self:GetAbilitySpecialValueFor("attack_per_gold")
end
function modifier_sp_loot_buff:OnRefresh(params)
	self.attack_per_gold = self:GetAbilitySpecialValueFor("attack_per_gold")
end
function modifier_sp_loot_buff:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_BATTLEING_END,
		EMDF_EVENT_ON_ATTACK_HIT,
	}
end
function modifier_sp_loot_buff:OnBattleEnd()
	self:Destroy()
end
function modifier_sp_loot_buff:OnAttackHit(hTarget, tAttackInfo, ExtraData, vLocation)
	if tAttackInfo.attacker ~= self:GetParent() then return end
	if not IsValid(hTarget) then return end
	if IsAttackMiss(tAttackInfo) then return end

	local hParent = self:GetParent()
	if not hParent:IsIllusion() then
		if not self.fTimeCD or GameRules:GetGameTime() >= self.fTimeCD then
			self.fTimeCD = GameRules:GetGameTime() + 0.1

			local iPlayerID = hParent:GetPlayerOwnerID()
			PlayerData:ModifyGold(iPlayerID, self.attack_per_gold, true)

			local iParticleID = ParticleManager:CreateParticle("particles/econ/items/bounty_hunter/bounty_hunter_ti9_immortal/bh_ti9_immortal_jinada.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControlEnt(iParticleID, 0, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(iParticleID, 1, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", hParent:GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(iParticleID)
		end
	end
end