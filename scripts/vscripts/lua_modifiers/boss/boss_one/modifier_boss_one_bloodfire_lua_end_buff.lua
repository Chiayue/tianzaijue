
modifier_boss_one_bloodfire_lua_end_buff = class({})

--------------------------------------------------------------------------------

function modifier_boss_one_bloodfire_lua_end_buff:IsDebuff()
	return true
end

function modifier_boss_one_bloodfire_lua_end_buff:GetTexture( params )
    return "modifier_boss_one_bloodfire_lua_end_buff"
end
function modifier_boss_one_bloodfire_lua_end_buff:IsHidden()
	return false
	-- body
end
function modifier_boss_one_bloodfire_lua_end_buff:OnCreated( kv )
	if IsServer() then
		local hCaster=self:GetParent()
		local buff=hCaster:AddNewModifier( hCaster, self:GetAbility(), "lower_armor", {duration=10} )
		buff:SetStackCount(math.ceil(hCaster:GetPhysicalArmorValue(false)/2))
	end
end
function modifier_boss_one_bloodfire_lua_end_buff:OnDestroy( kv )
	if IsServer() then
		if self:GetParent():IsAlive() then

			self:GetParent():AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_boss_one_bloodfire_lua_nodead_buff", {duration=15} )
		end
	end
end
function modifier_boss_one_bloodfire_lua_end_buff:DeclareFunctions()
    local funcs =
    {
        
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
    }
    return funcs
end


function modifier_boss_one_bloodfire_lua_end_buff:GetModifierMagicalResistanceBonus( params )
    return -100
end

function modifier_boss_one_bloodfire_lua_end_buff:GetAttributes()
  return MODIFIER_ATTRIBUTE_MULTIPLE
end
function modifier_boss_one_bloodfire_lua_end_buff:IsDebuff()
	return false
end

