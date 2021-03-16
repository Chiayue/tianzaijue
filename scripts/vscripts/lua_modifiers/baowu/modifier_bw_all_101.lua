-----------------------------------------------------------------
modifier_bw_all_101 = class({})
LinkLuaModifier( "modifier_bw_all_101_buff", "lua_modifiers/baowu/modifier_bw_all_101_buff", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Classifications
function modifier_bw_all_101:IsHidden()
	return true
end
--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_bw_all_101:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ABILITY_EXECUTED,
	}

	return funcs
end

function modifier_bw_all_101:OnCreated( kv )
	self:OnRefresh()
end

function modifier_bw_all_101:OnRefresh( kv )
	-- references
end



function modifier_bw_all_101:OnAbilityExecuted( params )
	if not IsServer() then return end
	if params.unit~=self:GetParent() then return end
	if self:GetParent():PassivesDisabled() then return end
	if not params.ability then return end
	if params.ability:IsItem() or params.ability:IsToggle() then return end
	if params.ability:GetAbilityName() =="ability_hero_2" then return end
	local caster = self:GetParent()
	local mp = caster:GetMana()*0.2
	if mp < 1 then
		return nil
	end
	
	if not caster:HasModifier("modifier_bw_all_101_buff") then
		caster:ReduceMana(mp)
		local cs = math.ceil(mp)
		caster:AddNewModifier( caster, self, "modifier_bw_all_101_buff", {duration=10} )
		caster:SetModifierStackCount( "modifier_bw_all_101_buff",caster, cs)
	end




end
-----------
function modifier_bw_all_101:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end
