
modifier_boss_one_bloodfire_lua = class({})


--------------------------------------------------------------------------------

function modifier_boss_one_bloodfire_lua:IsDebuff()
	return false
end

function modifier_boss_one_bloodfire_lua:GetTexture( params )
    return "modifier_boss_one_bloodfire_lua"
end
function modifier_boss_one_bloodfire_lua:IsHidden()
	return false
	-- body
end
function modifier_boss_one_bloodfire_lua:OnCreated( kv )
	if IsServer() then
		local hCaster=self:GetParent()
		local buff=hCaster:AddNewModifier( hCaster, self:GetAbility(), "add_attackspeed", {duration=20} )
		buff:SetStackCount(math.ceil(hCaster:GetDisplayAttackSpeed()))
		local buff=hCaster:AddNewModifier( hCaster, self:GetAbility(), "add_armor", {duration=20} )
		buff:SetStackCount(math.ceil(hCaster:GetPhysicalArmorValue(false)/2))
		
	end
end
function modifier_boss_one_bloodfire_lua:OnDestroy( kv )
	if IsServer() then
		if self:GetParent():IsAlive() then
			local buff=self:GetParent():AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_boss_one_bloodfire_lua_end_buff", {duration=15} )
		end
	end
end
function modifier_boss_one_bloodfire_lua:DeclareFunctions()
    local funcs =
    {
        
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
    }
    return funcs
end
function modifier_boss_one_bloodfire_lua:GetStatusEffectName()
    return "particles/status_fx/status_effect_gods_strength.vpcf"
end
--------------------------------------------------------------------------------

function modifier_boss_one_bloodfire_lua:GetModifierMoveSpeedBonus_Percentage( params )
    return 50
end
function modifier_boss_one_bloodfire_lua:GetModifierDamageOutgoing_Percentage( params )
    return 50
end
function modifier_boss_one_bloodfire_lua:GetModifierMagicalResistanceBonus( params )
    return 100
end

function modifier_boss_one_bloodfire_lua:GetAttributes()
  return MODIFIER_ATTRIBUTE_MULTIPLE
end

