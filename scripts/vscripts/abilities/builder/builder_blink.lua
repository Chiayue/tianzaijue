if builder_blink == nil then
	builder_blink = class({})
end

function builder_blink:OnSpellStart()
	local caster = self:GetCaster()
	local targetPosition = self:GetCursorPosition()
	local startPosition = self:GetAbsOrigin()

	local particleID = ParticleManager:CreateParticle("particles/items_fx/blink_dagger_start.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(particleID, 0, startPosition)
	ParticleManager:ReleaseParticleIndex(particleID)

	EmitSoundOnLocationWithCaster(startPosition, "DOTA_Item.BlinkDagger.Activate", caster)

	ProjectileManager:ProjectileDodge(caster)
	FindClearSpaceForUnit(caster, targetPosition, true)

	particleID = ParticleManager:CreateParticle("particles/items_fx/blink_dagger_end.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(particleID, 0, caster:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particleID)

	caster:EmitSound("DOTA_Item.BlinkDagger.NailedIt")
end

function builder_blink:ProcsMagicStick()
	return false
end