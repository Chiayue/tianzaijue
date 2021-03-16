LinkLuaModifier("modifier_chen_2", "abilities/tower/chen/chen_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chen_2_buff", "abilities/tower/chen/chen_2.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if chen_2 == nil then
	chen_2 = class({})
end
function chen_2:GetIntrinsicModifierName()
	return "modifier_chen_2"
end
---------------------------------------------------------------------
--Modifiers
if modifier_chen_2 == nil then
	modifier_chen_2 = class({}, nil, eom_modifier)
end
function modifier_chen_2:IsHidden()
	return true
end
function modifier_chen_2:OnCreated(params)
	self.trigger_pct = self:GetAbilitySpecialValueFor("trigger_pct")
	self.delay = self:GetAbilitySpecialValueFor("delay")
	if IsServer() then
		self:StartIntervalThink(0.5)
	end
end
function modifier_chen_2:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_chen_2:OnIntervalThink()
	if self:GetAbility():IsAbilityReady() then
		EachUnits(GetPlayerID(self:GetParent()), function(hFriend)
			if hFriend:GetHealthPercent() <= self.trigger_pct and self:GetAbility():IsAbilityReady() then
				self:GetAbility():UseResources(false, false, true)
				hFriend:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_chen_2_buff", { duration = self.delay })
			end
		end, UnitType.Building)
	end
end
---------------------------------------------------------------------
if modifier_chen_2_buff == nil then
	modifier_chen_2_buff = class({}, nil, BaseModifier)
end
function modifier_chen_2_buff:OnCreated(table)
	if IsServer() then
		self:GetParent():EmitSound("Hero_Chen.TeleportLoop")
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_chen/chen_teleport.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_chen_2_buff:OnDestroy()
	if IsServer() then
		-- 特效
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_chen/chen_teleport_flash.vpcf", PATTACH_ABSORIGIN, self:GetParent())
		ParticleManager:ReleaseParticleIndex(iParticleID)
		-- 传送
		FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetBuilding().vLocation, true)
		-- 治疗
		self:GetParent():Heal(self:GetParent():GetMaxHealth(), self:GetAbility())
		SendOverheadEventMessage(self:GetParent():GetPlayerOwner(), OVERHEAD_ALERT_HEAL, self:GetParent(), self:GetParent():GetMaxHealth(), self:GetParent():GetPlayerOwner())
		-- 特效
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_chen/chen_penitence.vpcf", PATTACH_ABSORIGIN, self:GetParent())
		ParticleManager:SetParticleControl(iParticleID, 0, self:GetParent():GetBuilding().vLocation)
		ParticleManager:ReleaseParticleIndex(iParticleID)
		-- sound
		self:GetParent():StopSound("Hero_Chen.TeleportLoop")
		self:GetParent():EmitSound("Hero_Chen.DivineFavor.Cast")
	end
end