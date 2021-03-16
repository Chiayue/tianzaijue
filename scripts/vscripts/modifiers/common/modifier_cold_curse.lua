
if modifier_cold_curse == nil then
	modifier_cold_curse = class({}, nil, eom_modifier)
end

local public = modifier_cold_curse

function public:GetTexture()
	return "ancient_apparition_cold_feet"
end
function public:IsDebuff()
	return true
end
function public:IsPurgable()
	return true
end
function public:OnCreated(params)
	local hParent = self:GetParent()
	if IsServer() then
	else
		local iParticleID = ParticleManager:CreateParticle("particles/items3_fx/silver_edge_slow.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function public:EDeclareFunctions()
	return {
		[EMDF_MOVEMENT_SPEED_BONUS_PERCENTAGE]=-50,
		[EMDF_ATTACKT_SPEED_BONUS_PERCENTAGE]=-50,
	}
end
function public:ECheckState()
	return {
		[MODIFIER_STATE_CURSED] = true,
	}
end
function public:GetMoveSpeedBonusPercentage()
	return -50
end
function public:GetAttackSpeedPercentage()
	return -50
end