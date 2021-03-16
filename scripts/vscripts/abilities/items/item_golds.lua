item_golds = class({})

--------------------------------------------------------------------------------
function item_golds:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_IMMEDIATE
end
--------------------------------------------------------------------------------
function item_golds:CanUnitPickUp(hUnit)
	local iPlayerIDCan = GetPlayerID(self)
	if - 1 ~= iPlayerIDCan then
		return GetPlayerID(hUnit) == iPlayerIDCan
	end
	return true
end
--------------------------------------------------------------------------------
function item_golds:OnSpellStart()
	if IsServer() then
		local hCaster = self:GetCaster()
		PlayerData:ModifyGold(hCaster:GetPlayerOwnerID(), self:GetCurrentCharges())
		self:SetCurrentCharges(0)
		self:SpendCharge()

		local iPtcl = ParticleManager:CreateParticle("particles/gold/gold_active.vpcf", PATTACH_CUSTOMORIGIN, hCaster)
		ParticleManager:SetParticleControlEnt(iPtcl, 0, hCaster, PATTACH_POINT_FOLLOW, "attach_hitloc", hCaster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(iPtcl, 1, hCaster:GetAbsOrigin())
		ParticleManager:SetParticleControlEnt(iPtcl, 3, hCaster, PATTACH_POINT_FOLLOW, "attach_hitloc", hCaster:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(iPtcl)
	end
end

--------------------------------------------------------------------------------