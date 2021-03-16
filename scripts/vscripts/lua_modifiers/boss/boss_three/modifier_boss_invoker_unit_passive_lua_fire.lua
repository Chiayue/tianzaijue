modifier_boss_invoker_unit_passive_lua_fire = class({})
--------------------------------------------------------------------------------
function modifier_boss_invoker_unit_passive_lua_fire:IsDebuff()
	return true
end
function modifier_boss_invoker_unit_passive_lua_fire:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}
	return funcs
end
function modifier_boss_invoker_unit_passive_lua_fire:GetModifierPhysicalArmorBonus( params )	--智力
	
	
	return -self:GetStackCount()
end
function modifier_boss_invoker_unit_passive_lua_fire:GetModifierMagicalResistanceBonus( params )
    return -self:GetStackCount()
end
function modifier_boss_invoker_unit_passive_lua_fire:GetTexture( params )
    return "modifier_boss_invoker_unit_passive_lua_fire"
end
function modifier_boss_invoker_unit_passive_lua_fire:OnCreated( kv )
	if IsServer() then
       self:SetStackCount(1)
    end
	
end

function modifier_boss_invoker_unit_passive_lua_fire:OnRefresh( kv )
	if IsServer() then
       self:SetStackCount(1+self:GetStackCount())
    end
	
end
function modifier_boss_invoker_unit_passive_lua_fire:OnDestroy(  )
    if IsServer() then
        --ParticleManager:DestroyParticle( self.nPreviewFX, false )
    end
end

function modifier_boss_invoker_unit_passive_lua_fire:GetAttributes()
  return MODIFIER_ATTRIBUTE_PERMANENT
end
