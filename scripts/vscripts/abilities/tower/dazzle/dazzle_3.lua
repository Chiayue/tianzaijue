LinkLuaModifier("modifier_dazzle_3", "abilities/tower/dazzle/dazzle_3.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_dazzle_3_buff", "abilities/tower/dazzle/dazzle_3.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_dazzle_3_grave", "abilities/tower/dazzle/dazzle_3.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if dazzle_3 == nil then
	dazzle_3 = class({})
end
function dazzle_3:GetIntrinsicModifierName()
	return "modifier_dazzle_3"
end
---------------------------------------------------------------------
--Modifiers
if modifier_dazzle_3 == nil then
	modifier_dazzle_3 = class({}, nil, eom_modifier)
end
function modifier_dazzle_3:IsHidden()
	return true
end
function modifier_dazzle_3:OnCreated(params)
	if IsServer() and IsValid(self:GetAbility()) and self:GetAbility():GetLevel() > 0 and GSManager:getStateType() == GS_Battle then
		self:OnInBattle()
	end
end
function modifier_dazzle_3:OnDestroy()
	if IsServer() then
		EachUnits(GetPlayerID(self:GetParent()), function(hUnit)
			hUnit:RemoveModifierByName("modifier_dazzle_3_buff")
		end, UnitType.AllFirends)
	end
end
function modifier_dazzle_3:OnInBattle()
	EachUnits(GetPlayerID(self:GetParent()), function(hUnit)
		hUnit:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_dazzle_3_buff", nil)
	end, UnitType.AllFirends)
end
function modifier_dazzle_3:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_IN_BATTLE
	}
end
---------------------------------------------------------------------
if modifier_dazzle_3_buff == nil then
	modifier_dazzle_3_buff = class({}, nil, eom_modifier)
end
function modifier_dazzle_3_buff:OnCreated(params)
	if IsServer() then
	end
end
function modifier_dazzle_3_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MIN_HEALTH,
	}
end
function modifier_dazzle_3_buff:EDeclareFunctions()
	return {
		[MODIFIER_EVENT_ON_TAKEDAMAGE] = {nil, self:GetParent() }
	}
end
function modifier_dazzle_3_buff:GetMinHealth()
	return 1
end
function modifier_dazzle_3_buff:OnTakeDamage(params)
	if params.unit == self:GetParent() and self:GetParent():GetHealth() == 1 then
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_dazzle_3_grave", { duration = self:GetAbility():GetDuration() })
		self:Destroy()
		-- EachUnits(GetPlayerID(self:GetParent()), function(hUnit)
		-- 	hUnit:RemoveModifierByName("modifier_dazzle_3_buff")
		-- end, UnitType.AllFirends)
	end
end
function modifier_dazzle_3_buff:IsHidden()
	return true
end
---------------------------------------------------------------------
if modifier_dazzle_3_grave == nil then
	modifier_dazzle_3_grave = class({}, nil, ModifierPositiveBuff)
end
function modifier_dazzle_3_grave:OnCreated(params)
	if IsServer() then
		self:GetParent():EmitSound("Hero_Dazzle.Shallow_Grave")
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_dazzle/dazzle_shallow_grave.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_dazzle_3_grave:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MIN_HEALTH,
	}
end
function modifier_dazzle_3_grave:GetMinHealth()
	return 1
end