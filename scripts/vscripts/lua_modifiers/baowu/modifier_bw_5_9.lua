-----------------------------------------------------------------
modifier_bw_5_9 = class({})
LinkLuaModifier( "modifier_bw_5_9_buff", "lua_modifiers/baowu/modifier_bw_5_9_buff", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Classifications
function modifier_bw_5_9:IsHidden()
	return true
end
--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_bw_5_9:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ABILITY_EXECUTED,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	}

	return funcs
end

function modifier_bw_5_9:OnCreated( kv )
	-- references
	self:OnRefresh()
end

function modifier_bw_5_9:OnRefresh( kv )
	-- references

end



function modifier_bw_5_9:OnAbilityExecuted( params )
	if not IsServer() then return end
	if params.unit~=self:GetParent() then return end
	if self:GetParent():PassivesDisabled() then return end
	if not params.ability then return end
	if params.ability:IsItem() or params.ability:IsToggle() then return end
	if params.ability:GetAbilityName() =="ability_hero_2" then return end


	local caster = self:GetParent()
	local heal = caster:GetMaxHealth() *0.2
	if heal > 100000000 then
		heal = 100000000
	end
	caster:Heal(heal,caster)
	
	
		

end

function modifier_bw_5_9:GetModifierBonusStats_Intellect	( params )
	return  18888
end
function modifier_bw_5_9:GetModifierBonusStats_Strength	( params )
	return  22222
end
-----------
function modifier_bw_5_9:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end