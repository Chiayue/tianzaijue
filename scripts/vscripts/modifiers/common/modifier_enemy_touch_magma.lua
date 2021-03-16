if modifier_enemy_touch_magma == nil then
	modifier_enemy_touch_magma = class({}, nil, BaseModifier)
end

local public = modifier_enemy_touch_magma

function public:IsDebuff()
	return true
end
function public:OnCreated(params)
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero/touch_magmachar.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControlEnt(iParticleID, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), false)
	ParticleManager:ReleaseParticleIndex(iParticleID)
end
function public:OnDestroy()
	if IsServer() then
		local hParent = self:GetParent()
		local iPlayerID = hParent.Spawner_spawnerPlayerID
		local hPlayerHero = PlayerResource:GetSelectedHeroEntity(iPlayerID)
		hParent:Kill(nil, hPlayerHero)
	end
end