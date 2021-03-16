
-- 既作为类，又作为 Lua Modifier
if equilibrium_constant == nil then
    equilibrium_constant = class({})
end

function equilibrium_constant:OnCreated()
	if IsServer() then
		if self:GetParent():GetPrimaryAttribute()==DOTA_ATTRIBUTE_INTELLECT	 then
			self:SetStackCount(10)
		else
			self:SetStackCount(5)
		end
	end
end

function equilibrium_constant:DeclareFunctions()
	---SetCustomAttributeDerivedStatValue对智力回蓝没有实际效果（仅仅改变了一部分显示效果），所以这里再额外处理一下
    local funcs = {
		MODIFIER_PROPERTY_BASE_MANA_REGEN		
    }
    return funcs
end

function equilibrium_constant:GetModifierBaseManaRegen()
	return self:GetStackCount()
end

function equilibrium_constant:IsHidden()
    return true
end

function equilibrium_constant:GetAttributes()
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function equilibrium_constant:RemoveOnDeath()
	return false;
end

LinkLuaModifier("equilibrium_constant","global/equilibrium_constant.lua",LUA_MODIFIER_MOTION_NONE)
