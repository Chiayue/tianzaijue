LinkLuaModifier("modifier_skeleton_warrior_2", "abilities/tower/skeleton_warrior/skeleton_warrior_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_skeleton_warrior_2_buff", "abilities/tower/skeleton_warrior/skeleton_warrior_2.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if skeleton_warrior_2 == nil then
	skeleton_warrior_2 = class({})
end
function skeleton_warrior_2:GetIntrinsicModifierName()
	return "modifier_skeleton_warrior_2"
end
---------------------------------------------------------------------
--Modifiers
if modifier_skeleton_warrior_2 == nil then
	modifier_skeleton_warrior_2 = class({}, nil, eom_modifier)
end
function modifier_skeleton_warrior_2:IsHidden()
	return true
end
function modifier_skeleton_warrior_2:IsDebuff()
	return false
end
function modifier_skeleton_warrior_2:IsPurgable()
	return false
end
function modifier_skeleton_warrior_2:IsPurgeException()
	return false
end
function modifier_skeleton_warrior_2:IsStunDebuff()
	return false
end
function modifier_skeleton_warrior_2:AllowIllusionDuplicate()
	return false
end
function modifier_skeleton_warrior_2:RemoveOnDeath()
	return false
end
function modifier_skeleton_warrior_2:OnCreated(params)
	self.reincarnate_time = self:GetAbilitySpecialValueFor("reincarnate_time")
	self.duration = self:GetAbilitySpecialValueFor("duration")
end
function modifier_skeleton_warrior_2:OnRefresh(params)
	self.reincarnate_time = self:GetAbilitySpecialValueFor("reincarnate_time")
	self.duration = self:GetAbilitySpecialValueFor("duration")
end
function modifier_skeleton_warrior_2:EDeclareFunctions()
	return {
		[EMDF_REINCARNATION] = {1},
	}
end
function modifier_skeleton_warrior_2:GetModifierReincarnation()
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	if IsValid(hAbility)
	and hAbility:GetLevel() > 0
	and hAbility:IsCooldownReady() and hAbility:IsOwnersManaEnough() then
		hAbility:UseResources(true, false, true)
		local iParticleID = ParticleManager:CreateParticle("particles/econ/items/wraith_king/wraith_king_arcana/wk_arc_style2_reincarn_tombstone.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, hParent:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(iParticleID)

		local skeleton_warrior_3 = hParent:FindAbilityByName("skeleton_warrior_3")
		if IsValid(skeleton_warrior_3) and skeleton_warrior_3:GetLevel() > 0 then
			local iParticleID = ParticleManager:CreateParticle("particles/econ/items/wraith_king/wraith_king_arcana/wk_arc_reincarn.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
			ParticleManager:SetParticleControl(iParticleID, 1, Vector(self.reincarnate_time, 0, 0))
			ParticleManager:ReleaseParticleIndex(iParticleID)
		end

		hParent:EmitSound("Hero_SkeletonKing.Reincarnate")

		GameTimer(self.reincarnate_time, function()
			if GSManager:getStateType() ~= GS_Battle then
				return
			end
			if IsValid(hParent) then
				if not hParent:IsAlive() then
					return 0
				else
					if IsValid(hAbility) then
						hParent:AddNewModifier(hParent, hAbility, "modifier_skeleton_warrior_2_buff", {duration=self.duration})

						local tBuildings = {}
						local iPlayerID = self:GetPlayerID()
						BuildSystem:EachBuilding(iPlayerID, function(hBuilding, iPlayerID, iEntIndex)
							local hUnit = EntIndexToHScript(iEntIndex)
							if IsValid(hUnit) and hBuilding:IsDeath() then
								table.insert(tBuildings, hBuilding)
							end
						end)

						if #tBuildings > 0 then
							local hBuilding
							local iAttempts = 0
							local iMaxAttempts = 16
							while iAttempts < iMaxAttempts do
								hBuilding = GetRandomElement(tBuildings)
								local hUnit = hBuilding:GetUnitEntity()
								if IsValid(hUnit) then
									break
								end
								iAttempts = iAttempts + 1
							end

							if hBuilding then
								local hUnit = hBuilding:GetUnitEntity()

								hBuilding:RespawnBuildingUnit()

								hUnit:AddNewModifier(hParent, hAbility, "modifier_skeleton_warrior_2_buff", {duration=self.duration})
							end
						end
					end
				end
			end
		end)

		return self.reincarnate_time
	end
end
---------------------------------------------------------------------
if modifier_skeleton_warrior_2_buff == nil then
	modifier_skeleton_warrior_2_buff = class({}, nil, eom_modifier)
end
function modifier_skeleton_warrior_2_buff:IsHidden()
	return false
end
function modifier_skeleton_warrior_2_buff:IsDebuff()
	return false
end
function modifier_skeleton_warrior_2_buff:IsPurgable()
	return true
end
function modifier_skeleton_warrior_2_buff:IsPurgeException()
	return true
end
function modifier_skeleton_warrior_2_buff:IsStunDebuff()
	return false
end
function modifier_skeleton_warrior_2_buff:AllowIllusionDuplicate()
	return false
end
function modifier_skeleton_warrior_2_buff:GetEffectName()
	return "particles/econ/items/bloodseeker/bloodseeker_eztzhok_weapon/bloodseeker_bloodrage_ground_eztzhok.vpcf"
end
function modifier_skeleton_warrior_2_buff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
function modifier_skeleton_warrior_2_buff:OnCreated(params)
	self.bonus_attack_speed = self:GetAbilitySpecialValueFor("bonus_attack_speed")
end
function modifier_skeleton_warrior_2_buff:OnRefresh(params)
	self.bonus_attack_speed = self:GetAbilitySpecialValueFor("bonus_attack_speed")
end
function modifier_skeleton_warrior_2_buff:EDeclareFunctions()
	return {
		EMDF_ATTACKT_SPEED_BONUS,
	}
end
function modifier_skeleton_warrior_2_buff:GetAttackSpeedBonus()
	return self.bonus_attack_speed
end
function modifier_skeleton_warrior_2_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end
function modifier_skeleton_warrior_2_buff:OnTooltip()
	return self:GetAttackSpeedBonus()
end
