LinkLuaModifier("modifier_item_lightning_whip", "abilities/items/item_lightning_whip.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_lightning_whip_delay", "abilities/items/item_lightning_whip.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_lightning_whip_root", "abilities/items/item_lightning_whip.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if item_lightning_whip == nil then
	item_lightning_whip = class({}, nil, base_ability_attribute)
end
function item_lightning_whip:GetIntrinsicModifierName()
	return "modifier_item_lightning_whip"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_lightning_whip == nil then
	modifier_item_lightning_whip = class({}, nil, modifier_base_ability_attribute)
end
function modifier_item_lightning_whip:OnCreated(params)
	self.lightning_count = self:GetAbilitySpecialValueFor("lightning_count")
	self.damage_pct = self:GetAbilitySpecialValueFor("damage_pct")
	if IsServer() then
	end
end
function modifier_item_lightning_whip:OnRefresh(params)
	self.lightning_count = self:GetAbilitySpecialValueFor("lightning_count")
	self.damage_pct = self:GetAbilitySpecialValueFor("damage_pct")
	if IsServer() then
	end
end
function modifier_item_lightning_whip:OnDestroy()
	if IsServer() then
	end
end
function modifier_item_lightning_whip:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_ATTACK_HIT
	}
end
function modifier_item_lightning_whip:OnAttackHit(hTarget, tAttackInfo, ExtraData, vLocation)
	if tAttackInfo.attacker ~= self:GetParent() then return end
	if not IsValid(hTarget) then return end
	if IsAttackMiss(tAttackInfo) then return end

	if self:GetAbility():IsCooldownReady() then
		local tTargets = FindUnitsInRadiusWithAbility(self:GetCaster(), hTarget:GetAbsOrigin(), 500, self:GetAbility())
		if #tTargets > 0 then
			self:GetAbility():UseResources(false, false, true)
			for i = 1, RandomInt(1, self.lightning_count) do
				local hUnit = RandomValue(tTargets)
				if IsValid(hUnit) then
					-- 伤害
					hUnit:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_item_lightning_whip_delay", { duration = 0.3 })
					-- 特效
					local flDistance = CalculateDistance(hUnit, self:GetParent())
					local iParticleID = ParticleManager:CreateParticle("particles/items/item_lightning_whip/lightning_whip.vpcf", PATTACH_CUSTOMORIGIN, nil)
					if flDistance < 400 then
						local vDir = (self:GetParent():GetAbsOrigin() - hUnit:GetAbsOrigin()):Normalized()
						ParticleManager:SetParticleControl(iParticleID, 0, self:GetParent():GetAbsOrigin() + vDir * (600 - flDistance) + Vector(0, 0, 100))
					else
						ParticleManager:SetParticleControl(iParticleID, 0, self:GetParent():GetAbsOrigin())
					end
					ParticleManager:SetParticleControl(iParticleID, 1, hUnit:GetAbsOrigin())
				end

			end
			-- 音效
			self:GetParent():EmitSound("Hero_QueenOfPain.Arcana.AltRun")
		end
	end
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_lightning_whip_delay == nil then
	modifier_item_lightning_whip_delay = class({}, nil, ModifierHidden)
end
function modifier_item_lightning_whip_delay:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end
function modifier_item_lightning_whip_delay:OnCreated(params)
	self.damage_pct = self:GetAbilitySpecialValueFor("damage_pct")
	self.root_duration = self:GetAbilitySpecialValueFor("root_duration")
end
function modifier_item_lightning_whip_delay:OnDestroy()
	if IsServer() then
		local hCaster = self:GetCaster()
		local hAbility = self:GetAbility()
		local flDamage = (hCaster:GetVal(ATTRIBUTE_KIND.PhysicalAttack) + hCaster:GetVal(ATTRIBUTE_KIND.MagicalAttack)) * self.damage_pct * 0.01
		hCaster:DealDamage(self:GetParent(), hAbility, flDamage)
		if self:GetParent():IsAlive() then
			self:GetParent():AddNewModifier(hCaster, hAbility, "modifier_item_lightning_whip_root", { duration = self.root_duration })
			self:GetParent():AddBuff(hCaster, BUFF_TYPE.ROOT, self.root_duration)
		end
	end
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_lightning_whip_root == nil then
	modifier_item_lightning_whip_root = class({}, nil, ModifierDebuff)
end
function modifier_item_lightning_whip_root:OnCreated(params)
	self.damage_tick = self:GetAbilitySpecialValueFor("damage_tick")
	self.damage_per_tick = self:GetAbilitySpecialValueFor("damage_per_tick")
	if IsServer() then
		self:StartIntervalThink(self.damage_tick)
	else
		local iParticleID = ParticleManager:CreateParticle("particles/items3_fx/gleipnir_root.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_item_lightning_whip_root:OnIntervalThink()
	local hCaster = self:GetCaster()
	local hAbility = self:GetAbility()
	local flDamage = (hCaster:GetVal(ATTRIBUTE_KIND.PhysicalAttack) + hCaster:GetVal(ATTRIBUTE_KIND.MagicalAttack)) * self.damage_per_tick * 0.01 * self.damage_tick
	hCaster:DealDamage(self:GetParent(), hAbility, flDamage)
end
function modifier_item_lightning_whip_root:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end
function modifier_item_lightning_whip_root:OnTooltip()
	return (self:GetCaster():GetVal(ATTRIBUTE_KIND.PhysicalAttack) + self:GetCaster():GetVal(ATTRIBUTE_KIND.MagicalAttack)) * self.damage_per_tick * 0.01
end