LinkLuaModifier("modifier_art_wine_glass", "abilities/artifact/art_wine_glass.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_magical_bonus", "abilities/artifact/art_wine_glass.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_physical_bonus", "abilities/artifact/art_wine_glass.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if art_wine_glass == nil then
	art_wine_glass = class({}, nil, artifact_base)
end
function art_wine_glass:GetIntrinsicModifierName()
	return "modifier_art_wine_glass"
end
---------------------------------------------------------------------
--Modifiers
if modifier_art_wine_glass == nil then
	modifier_art_wine_glass = class({}, nil, eom_modifier)
end
function modifier_art_wine_glass:OnCreated(params)
	if IsServer() then
		EventManager:register(ET_PLAYER.ON_DRAW_CARD, function(tData)
			local hCaster = self:GetCaster()
			if tData.PlayerID == GetPlayerID(hCaster) then
				if RollPercentage(self:GetAbilitySpecialValueFor('chance')) then
					hCaster:AddNewModifier(hCaster, self:GetAbility(), "modifier_magical_bonus", nil)
					hCaster:AddNewModifier(hCaster, self:GetAbility(), "modifier_physical_bonus", nil)
					if not hCaster:HasModifier("modifier_sp_caster") then
						hCaster:AddNewModifier(hCaster, nil, "modifier_sp_caster", nil)
					end
				end
			end
		end, nil, nil)
	end
end
function modifier_art_wine_glass:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_art_wine_glass:OnDestroy()
	if IsServer() then
	end
end
function modifier_art_wine_glass:DeclareFunctions()
	return {
	}
end

---------------------------------------------------------------------
--Modifiers
if modifier_magical_bonus == nil then
	modifier_magical_bonus = class({}, nil, eom_modifier)
end
function modifier_magical_bonus:IsHidden()
	return true
end
function modifier_magical_bonus:IsDebuff()
	return false
end
function modifier_magical_bonus:IsPurgable()
	return false
end
function modifier_magical_bonus:IsPurgeException()
	return false
end
function modifier_magical_bonus:IsStunDebuff()
	return false
end
function modifier_magical_bonus:RemoveOnDeath()
	return false
end
function modifier_magical_bonus:OnCreated(params)
	if IsServer() then
		self:IncrementStackCount()
	end
end
function modifier_magical_bonus:OnRefresh(params)
	if IsServer() then
		self:IncrementStackCount()
	end
end
---------------------------------------------------------------------
--Modifiers
if modifier_physical_bonus == nil then
	modifier_physical_bonus = class({}, nil, eom_modifier)
end
function modifier_physical_bonus:IsHidden()
	return true
end
function modifier_physical_bonus:IsDebuff()
	return false
end
function modifier_physical_bonus:IsPurgable()
	return false
end
function modifier_physical_bonus:IsPurgeException()
	return false
end
function modifier_physical_bonus:IsStunDebuff()
	return false
end
function modifier_physical_bonus:RemoveOnDeath()
	return false
end
function modifier_physical_bonus:OnCreated(params)
	if IsServer() then
		self:IncrementStackCount()
	end
end
function modifier_physical_bonus:OnRefresh(params)
	if IsServer() then
		self:IncrementStackCount()
	end
end