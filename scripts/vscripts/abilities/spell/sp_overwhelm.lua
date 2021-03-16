LinkLuaModifier("modifier_sp_overwhelm_debuff", "abilities/spell/sp_overwhelm.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if sp_overwhelm == nil then
	sp_overwhelm = class({}, nil, sp_base)
end
function sp_overwhelm:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function sp_overwhelm:OnSpellStart()
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

	local iParticleID = ParticleManager:CreateParticle("particles/spell/sp_overwhelm/sp_overwhelm.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iParticleID, 0, vPosition)
	ParticleManager:SetParticleControl(iParticleID, 1, Vector(radius, 0, 0))
	ParticleManager:ReleaseParticleIndex(iParticleID)

	EmitSoundOnLocationWithCaster(vPosition, "DOTA_Item.VeilofDiscord.Activate", hCaster)

	local tTargets = FindUnitsInRadius(iTeamNumber, vPosition, nil, radius, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), FIND_ANY_ORDER, false)

	for _, hTarget in pairs(tTargets) do
		hTarget:AddNewModifier(hCaster, self, "modifier_sp_overwhelm_debuff", { duration = GetStatusDebuffDuration(duration, hTarget, hCaster) })
	end
end
---------------------------------------------------------------------
--Modifiers
if modifier_sp_overwhelm_debuff == nil then
	modifier_sp_overwhelm_debuff = class({}, nil, eom_modifier)
end
function modifier_sp_overwhelm_debuff:IsHidden()
	return false
end
function modifier_sp_overwhelm_debuff:IsDebuff()
	return true
end
function modifier_sp_overwhelm_debuff:IsPurgable()
	return true
end
function modifier_sp_overwhelm_debuff:IsPurgeException()
	return true
end
function modifier_sp_overwhelm_debuff:IsStunDebuff()
	return false
end
function modifier_sp_overwhelm_debuff:GetEffectName()
	return "particles/spell/sp_overwhelm/sp_overwhelm_debuff.vpcf"
end
function modifier_sp_overwhelm_debuff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
function modifier_sp_overwhelm_debuff:OnCreated(params)
	self.incoming_damage = self:GetAbilitySpecialValueFor("incoming_damage")
	if IsServer() then
		self.tData = {}

		table.insert(self.tData, {
			fDieTime = self:GetDieTime(),
		})
		self:IncrementStackCount()

		self:StartIntervalThink(0)
	end
end
function modifier_sp_overwhelm_debuff:OnRefresh(params)
	self.incoming_damage = self:GetAbilitySpecialValueFor("incoming_damage")
	if IsServer() then
		table.insert(self.tData, {
			fDieTime = self:GetDieTime(),
		})
		self:IncrementStackCount()
	end
end
function modifier_sp_overwhelm_debuff:OnIntervalThink()
	if IsServer() then
		local fTime = GameRules:GetGameTime()

		for i = #self.tData, 1, -1 do
			if fTime >= self.tData[i].fDieTime then
				table.remove(self.tData, i)
				self:DecrementStackCount()
			end
		end
	end
end
function modifier_sp_overwhelm_debuff:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_BATTLEING_END,
		EMDF_INCOMING_PERCENTAGE,
		MODIFIER_PROPERTY_TOOLTIP,
	}
end
function modifier_sp_overwhelm_debuff:OnBattleEnd()
	self:Destroy()
end
function modifier_sp_overwhelm_debuff:GetIncomingPercentage()
	return self.incoming_damage * self:GetStackCount()
end
function modifier_sp_overwhelm_debuff:OnTooltip()
	return self.incoming_damage * self:GetStackCount()
end