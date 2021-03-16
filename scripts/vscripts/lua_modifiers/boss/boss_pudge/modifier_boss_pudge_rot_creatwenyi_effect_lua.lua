modifier_boss_pudge_rot_creatwenyi_effect_lua = class({})

--------------------------------------------------------------------------------

function modifier_boss_pudge_rot_creatwenyi_effect_lua:OnCreated( kv )
	if IsServer() then
	end
end
function modifier_boss_pudge_rot_creatwenyi_effect_lua:IsDebuff()
	return false
end
function modifier_boss_pudge_rot_creatwenyi_effect_lua:IsHidden()
	return false
end
--------------------------------------------------------------------------------

function modifier_boss_pudge_rot_creatwenyi_effect_lua:OnRefresh( kv )
	if IsServer() then
	end
end

--------------------------------------------------------------------------------

function modifier_boss_pudge_rot_creatwenyi_effect_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE 
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_boss_pudge_rot_creatwenyi_effect_lua:GetModifierExtraHealthPercentage( params )
	return 2
end

--------------------------------------------------------------------------------

function modifier_boss_pudge_rot_creatwenyi_effect_lua:GetModifierDamageOutgoing_Percentage( params )
	return 2
end

--------------------------------------------------------------------------------