if modifier_attack_system == nil then
	modifier_attack_system = class({}, nil, eom_modifier)
end

local public = modifier_attack_system


function public:IsHidden()
	return true
end
function public:IsDebuff()
	return false
end
function public:IsPurgable()
	return false
end
function public:IsPurgeException()
	return false
end
function public:AllowIllusionDuplicate()
	return false
end
function public:RemoveOnDeath()
	return false
end
function public:DestroyOnExpire()
	return false
end
function public:IsPermanent()
	return true
end
function public:GetAttributes()
	-- return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end
function public:GetPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA
end
function public:OnCreated(params)
	if IsServer() then
		self.iAttackState = 0
	end
end
function public:CheckState()
	return {
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_NO_TEAM_MOVE_TO] = true,
		[MODIFIER_STATE_NO_TEAM_SELECT] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
	}
end
function public:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_ATTACK_RECORD_DESTROY,
	}
end
function public:OnCustomAttackRecordDestroy(params)
	ATTACK_SYSTEM[params.record] = nil
end
function public:OnAttackRecord(params)
	local tVal = { self.iAttackState }
	AttributeSystem[ATTRIBUTE_KIND.AttackFlags]:Fire(params.attacker, params, tVal)
	self.record = params.record
	ATTACK_SYSTEM[self.record] = tVal[1]
	self.iAttackState = 0
end