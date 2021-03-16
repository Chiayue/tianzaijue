LinkLuaModifier("modifier_item_thunder_hammer_cooldown", "abilities/items/item_thunder_hammer.lua", LUA_MODIFIER_MOTION_NONE)
---雷霆锤
if nil == item_thunder_hammer then
	item_thunder_hammer = class({}, nil, base_ability_attribute)
end

function item_thunder_hammer:Jump(hTarget, tUnits, iCount)
	local hCaster = self:GetCaster()
	local jump_delay = self:GetSpecialValueFor("jump_delay")

	self:GameTimer(jump_delay, function()
		if not IsValid(hCaster) then return end
		if not IsValid(hTarget) then return end
		local jump_count = self:GetSpecialValueFor("jump_count")
		local magic_damage_extra = self:GetSpecialValueFor("magic_damage_extra")
		local jump_radius = self:GetSpecialValueFor("jump_radius")

		local hNewTarget = GetBounceTarget(hTarget, hCaster:GetTeamNumber(), hTarget:GetAbsOrigin(), jump_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, tUnits)
		if hNewTarget ~= nil then
			local iParticleID = ParticleManager:CreateParticle("particles/items_fx/chain_lightning.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControlEnt(iParticleID, 0, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(iParticleID, 1, hNewTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hNewTarget:GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(iParticleID)

			local fDamage = (hCaster:GetVal(ATTRIBUTE_KIND.PhysicalAttack) + hCaster:GetVal(ATTRIBUTE_KIND.MagicalAttack))*magic_damage_extra

			ApplyDamage({
				ability = self,
				attacker = hCaster,
				victim = hNewTarget,
				damage = fDamage,
				damage_type = DAMAGE_TYPE_MAGICAL
			})

			EmitSoundOnLocationWithCaster(hNewTarget:GetAbsOrigin(), "Item.Maelstrom.Chain_Lightning.Jump", hCaster)

			if iCount < jump_count then
				table.insert(tUnits, hNewTarget)
				self:Jump(hNewTarget, tUnits, iCount + 1)
			end
		end
	end)
end
function item_thunder_hammer:ChainLightning(hTarget)
	local hCaster = self:GetCaster()
	local jump_count = self:GetSpecialValueFor("jump_count")
	local magic_damage_extra = self:GetSpecialValueFor("magic_damage_extra")

	local iParticleID = ParticleManager:CreateParticle("particles/items_fx/chain_lightning.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControlEnt(iParticleID, 0, hCaster, PATTACH_POINT_FOLLOW, "attach_hitloc", hCaster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(iParticleID, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(iParticleID)

	local fDamage = (hCaster:GetVal(ATTRIBUTE_KIND.PhysicalAttack) + hCaster:GetVal(ATTRIBUTE_KIND.MagicalAttack))*magic_damage_extra

	ApplyDamage({
		ability = self,
		attacker = hCaster,
		victim = hTarget,
		damage = fDamage,
		damage_type = DAMAGE_TYPE_MAGICAL
	})

	if 1 < jump_count then
		self:Jump(hTarget, { hTarget }, 2)
	end
end
function item_thunder_hammer:GetIntrinsicModifierName()
	return "modifier_" .. self:GetName()
end

---------------------------------------------------------------------
--Modifiers
if nil == modifier_item_thunder_hammer then
	modifier_item_thunder_hammer = class({}, nil, modifier_base_ability_attribute)
end
function modifier_item_thunder_hammer:OnCreated(params)
	self:UpdateValues()
end

function modifier_item_thunder_hammer:IsHidden()
	return true
end
function modifier_item_thunder_hammer:OnRefresh(params)
	self:UpdateValues()
end
function modifier_item_thunder_hammer:UpdateValues()
	self.chance = self:GetAbilitySpecialValueFor("chance")
	self.cooldown = self:GetAbilitySpecialValueFor("cooldown")
end
function modifier_item_thunder_hammer:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_ATTACK_HIT
	}
end
function modifier_item_thunder_hammer:OnAttackHit(hTarget, tAttackInfo, ExtraData, vLocation)
	if tAttackInfo.attacker ~= self:GetParent() then return end
	if not IsValid(hTarget) then return end
	if IsAttackMiss(tAttackInfo) then return end

	local hParent = self:GetParent()
	if hParent:HasModifier("modifier_item_thunder_hammer_cooldown") then return end

	if PRD(hParent, self.chance, "item_thunder_hammer") then
		local hAbility = self:GetAbility()
		if IsValid(hAbility) and hAbility:GetLevel() > 0 and type(hAbility.ChainLightning) == "function" then
			hAbility:ChainLightning(hTarget)

			hParent:AddNewModifier(hParent, hAbility, "modifier_item_thunder_hammer_cooldown", {duration=self.cooldown})
		end

		-- if self.unlock_level <= self:GetAbility():GetLevel() then
		-- 	if RollPercentage(self.chance) and self.jump_count ~= 0 then
		-- 		self:Jump(hCaster, hTarget, self.jump_radius, self.jump_count, damage, self.arc_damage_percent_add, { hTarget }, 1)
		-- 	end
		-- end
	end
end

AbilityClassHook('item_thunder_hammer', getfenv(1), 'abilities/items/item_thunder_hammer.lua', { KeyValues.ItemsKv })

---------------------------------------------------------------------
modifier_item_thunder_hammer_cooldown = class({})
function modifier_item_thunder_hammer_cooldown:IsHidden()
	return true
end
function modifier_item_thunder_hammer_cooldown:IsDebuff()
	return false
end
function modifier_item_thunder_hammer_cooldown:IsPurgable()
	return false
end
function modifier_item_thunder_hammer_cooldown:IsPurgeException()
	return false
end
function modifier_item_thunder_hammer_cooldown:IsStunDebuff()
	return false
end
function modifier_item_thunder_hammer_cooldown:AllowIllusionDuplicate()
	return false
end