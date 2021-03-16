--Abilities
if contract_hermit == nil then
	local funcUnitsCallback = function(self, tTargets)
		ArrayRemove(tTargets, Commander:GetCommander(GetPlayerID(self:GetCaster())))
	end
	local funcSortFunction = function(a, b)
		return a:GetVal(ATTRIBUTE_KIND.PhysicalArmor) < b:GetVal(ATTRIBUTE_KIND.PhysicalArmor)
	end
	contract_hermit = class({ funcSortFunction = funcSortFunction, funcUnitsCallback = funcUnitsCallback }, nil, ability_base_ai)
end
function contract_hermit:Precache(context)
	PrecacheResource("particle", "particles/econ/items/riki/riki_immortal_ti6/riki_immortal_ti6_blinkstrike.vpcf", context)
end
function contract_hermit:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	local vStart = hCaster:GetAbsOrigin()
	local duration = self:GetSpecialValueFor("duration")

	hCaster:DealDamage(hTarget, self)
	hTarget:AddBuff(hCaster, BUFF_TYPE.SILENCE, duration)
	hTarget:AddBuff(hCaster, BUFF_TYPE.DISARM, duration)
	FindClearSpaceForUnit(hCaster, hTarget:GetAbsOrigin() - hTarget:GetForwardVector() * (hCaster:GetHullRadius() + hTarget:GetHullRadius()), true)
	-- 特效
	local iParticleID = ParticleManager:CreateParticle("particles/econ/items/riki/riki_immortal_ti6/riki_immortal_ti6_blinkstrike.vpcf", PATTACH_ABSORIGIN, hCaster)
	ParticleManager:SetParticleControl(iParticleID, 0, vStart)
	ParticleManager:SetParticleControlEnt(iParticleID, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), false)
	ParticleManager:SetParticleControl(iParticleID, 2, vStart)
	ParticleManager:SetParticleControl(iParticleID, 3, vStart)
	ParticleManager:ReleaseParticleIndex(iParticleID)
	-- 音效
	hCaster:EmitSound("Hero_Riki.Blink_Strike")
end