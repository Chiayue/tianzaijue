item_crystal = class({})

--------------------------------------------------------------------------------
function item_crystal:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_IMMEDIATE
end
--------------------------------------------------------------------------------
function item_crystal:CanUnitPickUp(hUnit)
	local iPlayerIDCan = GetPlayerID(self)
	if - 1 ~= iPlayerIDCan then
		return GetPlayerID(hUnit) == iPlayerIDCan
	end
	return true
end
--------------------------------------------------------------------------------
function item_crystal:OnSpellStart()
	if IsServer() then
		local hCaster = self:GetCaster()
		PlayerData:ModifyCrystal(hCaster:GetPlayerOwnerID(), self:GetCurrentCharges())
		self:SetCurrentCharges(0)
		self:SpendCharge()

		local iPtcl = ParticleManager:CreateParticle("particles/crystal/crystal_active.vpcf", PATTACH_CUSTOMORIGIN, hCaster)
		ParticleManager:SetParticleControlEnt(iPtcl, 0, hCaster, PATTACH_POINT_FOLLOW, "attach_hitloc", hCaster:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(iPtcl)
	end
end

--------------------------------------------------------------------------------