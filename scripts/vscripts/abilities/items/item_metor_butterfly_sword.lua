---流星蝴蝶剑
-- LinkLuaModifier("modifier_angel_relics_physical_immune", "abilities/items/item_metor_butterfly_sword.lua", LUA_MODIFIER_MOTION_NONE)
if nil == item_metor_butterfly_sword then
	item_metor_butterfly_sword = class({}, nil, base_ability_attribute)
end
function item_metor_butterfly_sword:GetIntrinsicModifierName()
	return "modifier_" .. self:GetName()
end

---------------------------------------------------------------------
--Modifiers
if nil == modifier_item_metor_butterfly_sword then
	modifier_item_metor_butterfly_sword = class({}, nil, modifier_base_ability_attribute)
end

function modifier_item_metor_butterfly_sword:IsHidden()
	return true
end
function modifier_item_metor_butterfly_sword:OnCreated(params)
	self:UpdateValues()
end

function modifier_item_metor_butterfly_sword:OnRefresh(params)
	self:UpdateValues()
end
function modifier_item_metor_butterfly_sword:UpdateValues(params)
	self.attack_speed_percentage = self:GetAbilitySpecialValueFor("attack_speed_percentage")
	self.chance = self:GetAbilitySpecialValueFor('chance')
	self.metor_count = self:GetAbilitySpecialValueFor('metor_count')
	self.metor_damage_bonus = self:GetAbilitySpecialValueFor('metor_damage_bonus')
	self.unlock_level = self:GetAbilitySpecialValueFor("unlock_level")
end


function modifier_item_metor_butterfly_sword:EDeclareFunctions()
	return {
		[EMDF_ATTACKT_SPEED_BONUS_PERCENTAGE] = self.attack_speed_percentage,
		EMDF_EVENT_ON_ATTACK_HIT
	}
end
function modifier_item_metor_butterfly_sword:OnAttackHit(hTarget, tAttackInfo, ExtraData, vLocation)
	if tAttackInfo.attacker ~= self:GetParent() then return end
	if not IsValid(hTarget) then return end
	if IsAttackMiss(tAttackInfo) then return end
	if not self:GetAbility():IsCooldownReady() then return end

	if self.unlock_level > self:GetAbility():GetLevel() then
		return
	end

	if RollPercentage(self.chance) and self.metor_count > 0 then
		self:GetAbility():UseResources(false, false, true)
		local flDamage = (self:GetParent():GetVal(ATTRIBUTE_KIND.PhysicalAttack) + self:GetParent():GetVal(ATTRIBUTE_KIND.MagicalAttack)) * self.metor_damage_bonus
		local target_point = self:GetParent():GetAbsOrigin()
		local tempTable = {}
		local targets = FindUnitsInRadius(self:GetParent():GetTeamNumber(), target_point, nil, 650, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false)
		for i = 1, self.metor_count do
			if targets[i] then
				--自身特效
				local particleID = ParticleManager:CreateParticle("particles/units/heroes/hero_mirana/mirana_starfall_moonray.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetParent())
				ParticleManager:SetParticleControl(particleID, 1, Vector(650, 0, 0))
				ParticleManager:ReleaseParticleIndex(particleID)

				self:GetParent():EmitSound("Ability.Starfall")
				--怪物落星
				local particleID = ParticleManager:CreateParticle("particles/units/heroes/hero_mirana/mirana_starfall_attack.vpcf", PATTACH_CUSTOMORIGIN, nil)
				ParticleManager:SetParticleControlEnt(particleID, 0, targets[i], PATTACH_CUSTOMORIGIN_FOLLOW, nil, targets[i]:GetAbsOrigin(), true)
				ParticleManager:ReleaseParticleIndex(particleID)
				table.insert(tempTable, targets[i])
			end
		end

		local primary_hit_time = GameRules:GetGameTime() + 0.57
		local phase = 0

		local hParent = self:GetParent()
		hParent:GameTimer(0.57, function()
			for n, target in pairs(tempTable) do
				if IsValid(target) and IsValid(self) then
					EmitSoundOnLocationWithCaster(target:GetAbsOrigin(), "Ability.StarfallImpact", hParent)
					local damage_table =					{
						ability = self,
						attacker = hParent,
						victim = target,
						damage = flDamage,
						damage_type = DAMAGE_TYPE_MAGICAL
					}
					ApplyDamage(damage_table)
				end
			end
		end)
	end
end


---------------------------------------------------------------------
--Modifiers
AbilityClassHook('item_metor_butterfly_sword', getfenv(1), 'abilities/items/item_metor_butterfly_sword.lua', { KeyValues.ItemsKv })