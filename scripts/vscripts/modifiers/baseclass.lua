BaseModifier = class({})

if BaseModifier == nil then
	BaseModifier = class({})
end
function BaseModifier:IsHidden()
	return false
end
function BaseModifier:IsDebuff()
	return false
end
function BaseModifier:IsPurgable()
	return false
end
function BaseModifier:IsPurgeException()
	return false
end
function BaseModifier:IsStunDebuff()
	return false
end
function BaseModifier:IsHexDebuff()
	return false
end
function BaseModifier:AllowIllusionDuplicate()
	return false
end

---------------------------------------------------------------------
ModifierDebuff = class({})

if ModifierDebuff == nil then
	ModifierDebuff = class({})
end
function ModifierDebuff:IsHidden()
	return false
end
function ModifierDebuff:IsDebuff()
	return true
end
function ModifierDebuff:IsPurgable()
	return true
end
function ModifierDebuff:IsPurgeException()
	return true
end
function ModifierDebuff:IsStunDebuff()
	return false
end
function ModifierDebuff:IsHexDebuff()
	return false
end
function ModifierDebuff:AllowIllusionDuplicate()
	return false
end
---------------------------------------------------------------------
ModifierPositiveBuff = class({})

if ModifierPositiveBuff == nil then
	ModifierPositiveBuff = class({})
end
function ModifierPositiveBuff:IsHidden()
	return false
end
function ModifierPositiveBuff:IsDebuff()
	return false
end
function ModifierPositiveBuff:IsPurgable()
	return true
end
function ModifierPositiveBuff:IsPurgeException()
	return true
end
function ModifierPositiveBuff:IsStunDebuff()
	return false
end
function ModifierPositiveBuff:IsHexDebuff()
	return false
end
function ModifierPositiveBuff:AllowIllusionDuplicate()
	return false
end
---------------------------------------------------------------------
ModifierHidden = class({})

if ModifierHidden == nil then
	ModifierHidden = class({})
end
function ModifierHidden:IsHidden()
	return true
end
function ModifierHidden:IsDebuff()
	return false
end
function ModifierHidden:IsPurgable()
	return false
end
function ModifierHidden:IsPurgeException()
	return false
end
function ModifierHidden:IsStunDebuff()
	return false
end
function ModifierHidden:IsHexDebuff()
	return false
end
function ModifierHidden:AllowIllusionDuplicate()
	return false
end

---------------------------------------------------------------------
ParticleModifier = class({})

if ParticleModifier == nil then
	ParticleModifier = class({})
end
function ParticleModifier:IsHidden()
	return true
end
function ParticleModifier:IsDebuff()
	return false
end
function ParticleModifier:IsPurgable()
	return false
end
function ParticleModifier:IsPurgeException()
	return false
end
function ParticleModifier:IsStunDebuff()
	return false
end
function ParticleModifier:AllowIllusionDuplicate()
	return false
end
function ParticleModifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

---------------------------------------------------------------------
ParticleModifierThinker = class({})

if ParticleModifierThinker == nil then
	ParticleModifierThinker = class({})
end
function ParticleModifierThinker:IsHidden()
	return true
end
function ParticleModifierThinker:IsDebuff()
	return false
end
function ParticleModifierThinker:IsPurgable()
	return false
end
function ParticleModifierThinker:IsPurgeException()
	return false
end
function ParticleModifierThinker:IsStunDebuff()
	return false
end
function ParticleModifierThinker:AllowIllusionDuplicate()
	return false
end
function ParticleModifierThinker:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end
function ParticleModifierThinker:OnDestroy()
	if IsServer() then
		if IsValid(self:GetParent()) then
			self:GetParent():RemoveSelf()
		end
	end
end
function ParticleModifierThinker:CheckState()
	return {
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true
	}
end

---------------------------------------------------------------------
HorizontalModifier = class({})
if HorizontalModifier == nil then
	HorizontalModifier = class({})
end
function HorizontalModifier:IsHidden()
	return false
end
function HorizontalModifier:IsDebuff()
	return false
end
function HorizontalModifier:IsPurgable()
	return false
end
function HorizontalModifier:IsPurgeException()
	return false
end
function HorizontalModifier:IsStunDebuff()
	return false
end
function HorizontalModifier:IsHexDebuff()
	return false
end
function HorizontalModifier:AllowIllusionDuplicate()
	return false
end
function HorizontalModifier:GetPriority()
	return MODIFIER_PRIORITY_NORMAL
end
---------------------------------------------------------------------
VerticalModifier = class({})
if VerticalModifier == nil then
	VerticalModifier = class({})
end
function VerticalModifier:IsHidden()
	return false
end
function VerticalModifier:IsDebuff()
	return false
end
function VerticalModifier:IsPurgable()
	return false
end
function VerticalModifier:IsPurgeException()
	return false
end
function VerticalModifier:IsStunDebuff()
	return false
end
function VerticalModifier:IsHexDebuff()
	return false
end
function VerticalModifier:AllowIllusionDuplicate()
	return false
end
function VerticalModifier:GetPriority()
	return MODIFIER_PRIORITY_NORMAL
end
---------------------------------------------------------------------
BothModifier = class({})
if BothModifier == nil then
	BothModifier = class({})
end
function BothModifier:IsHidden()
	return false
end
function BothModifier:IsDebuff()
	return false
end
function BothModifier:IsPurgable()
	return false
end
function BothModifier:IsPurgeException()
	return false
end
function BothModifier:IsStunDebuff()
	return false
end
function BothModifier:IsHexDebuff()
	return false
end
function BothModifier:AllowIllusionDuplicate()
	return false
end
function BothModifier:GetPriority()
	return MODIFIER_PRIORITY_NORMAL
end