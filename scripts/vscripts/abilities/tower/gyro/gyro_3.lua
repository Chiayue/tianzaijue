LinkLuaModifier("modifier_gyro_3", "abilities/tower/gyro/gyro_3.lua", LUA_MODIFIER_MOTION_NONE)

if gyro_3 == nil then
	gyro_3 = class({})
end
function gyro_3:Poison(hTarget)
	local hCaster = self:GetCaster()
	local info = {
		EffectName = "particles/units/heroes/gyro_3.vpcf",
		Ability = self,
		iMoveSpeed = 1000,
		Source = hCaster,
		Target = hTarget,
		iSourceAttachment = RollPercentage(50) and DOTA_PROJECTILE_ATTACHMENT_ATTACK_1 or DOTA_PROJECTILE_ATTACHMENT_ATTACK_2,
		vSourceLoc = hCaster:GetAbsOrigin(),
		bDodgeable = true,
		ExtraData = {
		-- thinker_index = hThinker:entindex()
		}
	}
	ProjectileManager:CreateTrackingProjectile(info)
end
function gyro_3:OnProjectileHit_ExtraData(hTarget, vLocation, ExtraData)
	if IsValid(hTarget) then
		local hCaster = self:GetCaster()
		local poison = self:GetSpecialValueFor("poison")
		hCaster:DealDamage(hTarget, self, self:GetAbilityDamage())
		hTarget:AddBuff(hCaster, BUFF_TYPE.POISON, nil, true, {iCount = poison})
	end
end
function gyro_3:GetIntrinsicModifierName()
	return "modifier_gyro_3"
end
---------------------------------------------------------------------
--Modifiers
if modifier_gyro_3 == nil then
	modifier_gyro_3 = class({}, nil, eom_modifier)
end
function modifier_gyro_3:IsHidden()
	return true
end
function modifier_gyro_3:OnCreated(params)
	self.require_count = self:GetAbilitySpecialValueFor("require_count")
	if IsServer() then
	end 
end
function modifier_gyro_3:EDeclareFunctions()
	return {
		[MODIFIER_EVENT_ON_ATTACK] = {self:GetParent()},
	}
end
function modifier_gyro_3:OnAttack(params)
	if params.target == nil or params.target:GetClassname() == "dota_item_drop" then return end
	if params.attacker ~= self:GetParent() or params.attacker:IsIllusion() then return end
	self:IncrementStackCount()
	if self:GetStackCount() >= self.require_count then
		self:SetStackCount(0)
		self:GetAbility():Poison(params.target)
	end
end