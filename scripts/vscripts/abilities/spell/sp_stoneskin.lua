LinkLuaModifier("modifier_sp_stoneskin_buff", "abilities/spell/sp_stoneskin.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if sp_stoneskin == nil then
	sp_stoneskin = class({}, nil, sp_base)
end
function sp_stoneskin:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function sp_stoneskin:OnSpellStart()
	local hCaster = self:GetCaster()
	local PlayerID = hCaster:GetPlayerOwnerID()
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
	ParticleManager:SetParticleControl(iParticleID, 2, Vector(1, 1, 1))
	ParticleManager:SetParticleControl(iParticleID, 3, Vector(175, 153, 30))
	ParticleManager:SetParticleControl(iParticleID, 4, Vector(255, 230, 48))
	ParticleManager:ReleaseParticleIndex(iParticleID)

	EmitSoundOnLocationWithCaster(vPosition, "DOTA_Item.Buckler.Activate", hCaster)

	local tTargets = FindUnitsInRadius(iTeamNumber, vPosition, nil, radius, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), FIND_ANY_ORDER, false)
	for _, hTarget in pairs(tTargets) do
		hTarget:AddNewModifier(hCaster, self, "modifier_sp_stoneskin_buff", { duration = duration })
	end
end
---------------------------------------------------------------------
--Modifiers
if modifier_sp_stoneskin_buff == nil then
	modifier_sp_stoneskin_buff = class({}, nil, eom_modifier)
end
function modifier_sp_stoneskin_buff:IsHidden()
	return false
end
function modifier_sp_stoneskin_buff:IsDebuff()
	return false
end
function modifier_sp_stoneskin_buff:IsPurgable()
	return true
end
function modifier_sp_stoneskin_buff:IsPurgeException()
	return true
end
function modifier_sp_stoneskin_buff:IsStunDebuff()
	return false
end
function modifier_sp_stoneskin_buff:GetEffectName()
	return "particles/items_fx/buckler.vpcf"
end
function modifier_sp_stoneskin_buff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
function modifier_sp_stoneskin_buff:ShouldUseOverheadOffset()
	return true
end
function modifier_sp_stoneskin_buff:OnCreated(params)
	self.bonus_armor = self:GetAbilitySpecialValueFor("bonus_armor")
	if IsClient() then
		local iParticleID = ParticleManager:CreateParticle("particles/items2_fx/medallion_of_courage_friend_shield.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, true)
	end
end
function modifier_sp_stoneskin_buff:OnRefresh(params)
	self.bonus_armor = self:GetAbilitySpecialValueFor("bonus_armor")
end
function modifier_sp_stoneskin_buff:OnDestroy()
end
function modifier_sp_stoneskin_buff:EDeclareFunctions()
	return {
		[EMDF_MAGICAL_ARMOR_BONUS] = self.bonus_armor,
		[EMDF_PHYSICAL_ARMOR_BONUS] = self.bonus_armor,
		EMDF_EVENT_ON_BATTLEING_END
	}
end
function modifier_sp_stoneskin_buff:OnBattleEnd()
	self:Destroy()
end
function modifier_sp_stoneskin_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_sp_stoneskin_buff:OnTooltip()
	return self.bonus_armor
end