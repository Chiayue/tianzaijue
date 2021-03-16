LinkLuaModifier("modifier_dazzle_2", "abilities/tower/dazzle/dazzle_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_dazzle_2_buff", "abilities/tower/dazzle/dazzle_2.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if dazzle_2 == nil then
	dazzle_2 = class({})
end
function dazzle_2:OnProjectileHit_ExtraData(hTarget, vLocation, ExtraData)
	if hTarget then
		local hUnit = EntIndexToHScript(ExtraData.iEntIndex)

		if IsValid(hUnit) then
			self.hIllusion = CreateIllusion(hUnit, hUnit:GetAbsOrigin(), true, hUnit, hUnit, hUnit:GetTeamNumber(), -1, self:GetSpecialValueFor("attack_pct"), 100)
			if IsValid(self.hIllusion) then
				self.hIllusion:SetHealth(self.hIllusion:GetMaxHealth())
				self.hIllusion:SetAcquisitionRange(3000)
				self.hIllusion:SetControllableByPlayer(-1, false)
				self.hIllusion:AddNewModifier(hUnit, nil, "modifier_building_ai", nil)
				FindClearSpaceForUnit(self.hIllusion, vLocation, false)
			end
		end

	end
	if IsServer() then
		self.hIllusion:AddNewModifier(self:GetCaster(), self, 'modifier_dazzle_2_buff', {})
	end
end
function dazzle_2:GetIntrinsicModifierName()
	return "modifier_dazzle_2"
end
---------------------------------------------------------------------
--Modifiers
if modifier_dazzle_2 == nil then
	modifier_dazzle_2 = class({}, nil, eom_modifier)
end
function modifier_dazzle_2:OnCreated(params)
	self.hIllusion = {}
	if IsServer() then
	end
end
function modifier_dazzle_2:OnDeath(params)
	local hParent = self:GetParent()
	if IsServer() then
		if hParent:IsAlive() and
		params.unit ~= hParent and
		params.unit:IsFriendly(hParent) and
		params.unit:IsIllusion() == false and
		params.unit.GetBuilding and
		GSManager:getStateType() == GS_Battle and
		self:GetAbility():IsCooldownReady()
		then
			-- params.unit:GetBuilding():RespawnBuildingUnit()
			local info = {
				EffectName = "particles/units/heroes/hero_grimstroke/grimstroke_phantom_return.vpcf",
				Ability = self:GetAbility(),
				iMoveSpeed = 1200,
				Source = params.unit,
				Target = hParent,
				iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
				vSourceLoc = params.unit:GetAbsOrigin(),
				bDodgeable = false,
				ExtraData = {
					iEntIndex = params.unit:entindex()
				}
			}
			ProjectileManager:CreateTrackingProjectile(info)

			-- sound
			params.unit:EmitSound("Hero_Grimstroke.InkCreature.Cast")
			-- self:GetAbility():SetActivated(false)
			self:GetAbility():UseResources(false, false, true)
		end

	end
end
function modifier_dazzle_2:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_ROUND_CHANGE,
		MODIFIER_EVENT_ON_DEATH
	}
end
function modifier_dazzle_2:IsHidden()
	return true
end
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- 删除
if modifier_dazzle_2_buff == nil then
	modifier_dazzle_2_buff = class({}, nil, eom_modifier)
end
function modifier_dazzle_2_buff:OnCreated(params)
	if IsServer() then
	end
end
function modifier_dazzle_2_buff:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_dazzle_2_buff:OnDestroy()
	if IsServer() then
	end
end
function modifier_dazzle_2_buff:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_ROUND_CHANGE,
	}
end
function modifier_dazzle_2_buff:IsHidden()
	return true
end
function modifier_dazzle_2_buff:OnRoundChange()
	self:GetParent():ForceKill(false)
end
function modifier_dazzle_2_buff:CheckState()
	return {
		[MODIFIER_STATE_NO_HEALTH_BAR] = true
	}
end