
modifier_boss_two_endaoe_lua = class({})


--------------------------------------------------------------------------------

function modifier_boss_two_endaoe_lua:IsDebuff()
	return false
end

function modifier_boss_two_endaoe_lua:GetTexture( params )
    return "modifier_boss_two_endaoe_lua"
end
function modifier_boss_two_endaoe_lua:IsHidden()
	return true
	-- body
end
function modifier_boss_two_endaoe_lua:OnCreated( kv )
	if IsServer() then
		local hCaster=self:GetParent()
		local buff=hCaster:AddNewModifier( hCaster, self:GetAbility(), "add_attackspeed", {duration=20} )
		buff:SetStackCount(math.ceil(hCaster:GetDisplayAttackSpeed()))
		
		
	end
end
function modifier_boss_two_endaoe_lua:OnDestroy( kv )
	if IsServer() then
		
	end
end
function modifier_boss_two_endaoe_lua:DeclareFunctions()
    local funcs =
    {
        
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
        
    }
    return funcs
end
function modifier_boss_two_endaoe_lua:GetStatusEffectName()
    return "particles/status_fx/status_effect_gods_strength.vpcf"
end
--------------------------------------------------------------------------------

function modifier_boss_two_endaoe_lua:GetModifierMoveSpeedBonus_Percentage( params )
    return 50
end
function modifier_boss_two_endaoe_lua:GetModifierDamageOutgoing_Percentage( params )
    return 100
end


function modifier_boss_two_endaoe_lua:GetAttributes()
  return MODIFIER_ATTRIBUTE_MULTIPLE
end

