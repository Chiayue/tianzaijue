LinkLuaModifier("modifier_sp_shootfar_buff", "abilities/spell/sp_shootfar.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sp_shootfar_attack", "abilities/spell/sp_shootfar.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if sp_shootfar == nil then
	sp_shootfar = class({}, nil, sp_base)
end
function sp_shootfar:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function sp_shootfar:OnSpellStart()
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
	ParticleManager:SetParticleControl(iParticleID, 2, Vector(1, 5, 1))
	ParticleManager:SetParticleControl(iParticleID, 3, Vector(68, 95, 165))
	ParticleManager:SetParticleControl(iParticleID, 4, Vector(90, 151, 255))
	ParticleManager:ReleaseParticleIndex(iParticleID)

	EmitSoundOnLocationWithCaster(vPosition, "DOTA_Item.Butterfly", hCaster)

	local tTargets = FindUnitsInRadius(iTeamNumber, vPosition, nil, radius, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), FIND_ANY_ORDER, false)
	for _, hTarget in pairs(tTargets) do
		hTarget:AddNewModifier(hCaster, self, "modifier_sp_shootfar_buff", { duration = duration })
	end
end
---------------------------------------------------------------------
--Modifiers
if modifier_sp_shootfar_buff == nil then
	modifier_sp_shootfar_buff = class({}, nil, eom_modifier)
end
function modifier_sp_shootfar_buff:IsHidden()
	return false
end
function modifier_sp_shootfar_buff:IsDebuff()
	return false
end
function modifier_sp_shootfar_buff:IsPurgable()
	return true
end
function modifier_sp_shootfar_buff:IsPurgeException()
	return true
end
function modifier_sp_shootfar_buff:IsStunDebuff()
	return false
end
function modifier_sp_shootfar_buff:GetEffectName()
	return "particles/units/heroes/hero_drow/drow_aura_buff.vpcf"
end
function modifier_sp_shootfar_buff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
function modifier_sp_shootfar_buff:OnCreated(params)
	self.bonus_attack_range = self:GetAbilitySpecialValueFor("bonus_attack_range")
	self.chance = self:GetAbilitySpecialValueFor("chance")
end
function modifier_sp_shootfar_buff:OnRefresh(params)
	self.bonus_attack_range = self:GetAbilitySpecialValueFor("bonus_attack_range")
	self.chance = self:GetAbilitySpecialValueFor("chance")
end
function modifier_sp_shootfar_buff:EDeclareFunctions()
	return {
		[MODIFIER_EVENT_ON_ATTACK] = { self:GetParent() },
		EMDF_EVENT_ON_BATTLEING_END,
		EMDF_ATTACK_RANGE_BONUS
	}
end
function modifier_sp_shootfar_buff:OnAttack(params)
	if params.attacker ~= self:GetParent() or params.target == nil or params.target:GetClassname() == "dota_item_drop" then
		return
	end
	local hParent = self:GetParent()
	if hParent:AttackFilter(params.record, ATTACK_STATE_NO_EXTENDATTACK, ATTACK_STATE_SKIPCOUNTING) then
		return
	end

	if hParent:HasModifier("modifier_sp_shootfar_attack") then
		hParent:RemoveModifierByName("modifier_sp_shootfar_attack")
	end
	if PRD(hParent, self.chance, "sp_shootfar") then
		hParent:AddNewModifier(hParent, self:GetAbility(), "modifier_sp_shootfar_attack", nil)
	end
end
function modifier_sp_shootfar_buff:OnBattleEnd()
	self:Destroy()
end
function modifier_sp_shootfar_buff:GetAttackRangeBonus()
	return	self.bonus_attack_range
end
---------------------------------------------------------------------
--Modifiers
if modifier_sp_shootfar_attack == nil then
	modifier_sp_shootfar_attack = class({}, nil, eom_modifier)
end
function modifier_sp_shootfar_attack:IsHidden()
	return true
end
function modifier_sp_shootfar_attack:IsDebuff()
	return false
end
function modifier_sp_shootfar_attack:IsPurgable()
	return false
end
function modifier_sp_shootfar_attack:IsPurgeException()
	return false
end
function modifier_sp_shootfar_attack:IsStunDebuff()
	return false
end
function modifier_sp_shootfar_attack:EDeclareFunctions()
	return {
		[EMDF_ATTACKT_SPEED_BONUS] = 10000,
	}
end
function modifier_sp_shootfar_attack:GetAttackSpeedBonus()
	return 10000
end