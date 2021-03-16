LinkLuaModifier("modifier_satyr_spawn_a_3", "abilities/tower/satyr_spawn_a/satyr_spawn_a_3.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_satyr_spawn_a_3_buff", "abilities/tower/satyr_spawn_a/satyr_spawn_a_3.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_satyr_spawn_a_3_effect", "abilities/tower/satyr_spawn_a/satyr_spawn_a_3.lua", LUA_MODIFIER_MOTION_NONE)

if satyr_spawn_a_3 == nil then
	satyr_spawn_a_3 = class({})
end
function satyr_spawn_a_3:GetIntrinsicModifierName()
	return "modifier_satyr_spawn_a_3"
end

------------------------------------------------------------------------------
if modifier_satyr_spawn_a_3 == nil then
	modifier_satyr_spawn_a_3 = class({}, nil, BaseModifier)
end
function modifier_satyr_spawn_a_3:OnCreated(params)
	if IsServer() then
		self.hParent = self:GetParent()
		self.duration = self:GetAbility():GetDuration()
		self:StartIntervalThink(1 / 30)
	end
end
function modifier_satyr_spawn_a_3:OnRefresh(params)
	if IsServer() then
		self.hParent = self:GetParent()
		self.duration = self:GetAbility():GetDuration()
	end
end
function modifier_satyr_spawn_a_3:OnDestroy(params)
	if IsServer() then
	end
end
function modifier_satyr_spawn_a_3:OnIntervalThink()
	if IsServer() then
		if self.hParent:GetHealth() <= 1 then
			self:Destroy()
			self.hParent:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_satyr_spawn_a_3_buff", {
				duration = self.duration
			})
			self.hParent:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_satyr_spawn_a_3_effect", {
				duration = self.duration
			})
		end
	end
end
function modifier_satyr_spawn_a_3:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MIN_HEALTH
	}
end
function modifier_satyr_spawn_a_3:GetMinHealth()
	return 1
end
function modifier_satyr_spawn_a_3:IsHidden()
	return true
end
------------------------------------------------------------------------------
if modifier_satyr_spawn_a_3_buff == nil then
	modifier_satyr_spawn_a_3_buff = class({}, nil, BaseModifier)
end
function modifier_satyr_spawn_a_3_buff:OnCreated(params)
	if IsServer() then
		self.iRound = Spawner:GetRound()
	end
end
function modifier_satyr_spawn_a_3_buff:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_satyr_spawn_a_3_buff:OnDestroy(params)
	if IsServer() then
		if self.iRound == Spawner:GetRound() and self:GetParent():IsAlive() and GSManager:getStateType() == GS_Battle then
			self:GetParent():ForceKill(false)
		end
	end
end
function modifier_satyr_spawn_a_3_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MIN_HEALTH
	}
end
function modifier_satyr_spawn_a_3_buff:CheckState()
	return {
	}
end
function modifier_satyr_spawn_a_3_buff:GetMinHealth()
	return 1
end

------------------------------------------------------------------------------
if modifier_satyr_spawn_a_3_effect == nil then
	modifier_satyr_spawn_a_3_effect = class({}, nil, BaseModifier)
end
function modifier_satyr_spawn_a_3_effect:OnCreated(params)
	if IsClient() then
		local iParticle = ParticleManager:CreateParticle('particles/units/heroes/hero_skeletonking/wraith_king_ghosts_ambient.vpcf', PATTACH_POINT_FOLLOW, self:GetParent())
		self:AddParticle(iParticle, false, false, 10, false, false)
	end
end
function modifier_satyr_spawn_a_3_effect:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_satyr_spawn_a_3_effect:OnDestroy(params)
	if IsServer() then
	end
end
function modifier_satyr_spawn_a_3_effect:DeclareFunctions()
	return {
	}
end
function modifier_satyr_spawn_a_3_effect:CheckState()
	return {
	}
end
function modifier_satyr_spawn_a_3_effect:IsHidden()
	return true
end