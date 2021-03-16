if modifier_niunian == nil then
	modifier_niunian = class({}, nil, BaseModifier)
end

local public = modifier_niunian

function public:OnCreated(params)
	if IsServer() then
		self.hEnt = Entities:FindByNameLike(nil, 'birthplace_main')
		self:StartIntervalThink(1)
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/courier/courier_nian.vpcf", PATTACH_ABSORIGIN, self:GetParent())
		ParticleManager:SetParticleControlEnt(iParticleID, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function public:OnIntervalThink()
	ExecuteOrder(self:GetParent(), DOTA_UNIT_ORDER_MOVE_TO_POSITION, nil, nil, self.hEnt:GetAbsOrigin() + RandomVector(RandomInt(0, 800)))
	self:StartIntervalThink(RandomFloat(1, 3))
	self.movespeed = RandomInt(0, 80)
end
function public:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
end
function public:CheckState()
	return {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
	}
end
function public:GetModifierMoveSpeedBonus_Percentage(params)
	return self.movespeed
end