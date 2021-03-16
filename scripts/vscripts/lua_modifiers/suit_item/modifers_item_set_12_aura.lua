
modifers_item_set_12_aura = class({})



function modifers_item_set_12_aura:DeclareFunctions()
	local funcs = {
		
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	}
	return funcs
end
function modifers_item_set_12_aura:GetModifierBonusStats_Agility( params )	--智力
	
	return 450
end
function modifers_item_set_12_aura:GetModifierBonusStats_Strength( params )	--智力
	
	return 450
end
function modifers_item_set_12_aura:GetModifierBonusStats_Intellect( params )	--智力
	
	return 450
end

--------------------------------------------------------------------------------

function modifers_item_set_12_aura:IsDebuff()
	return false
end

function modifers_item_set_12_aura:GetTexture( params )
   return "tz/人生"
end
function modifers_item_set_12_aura:IsHidden()
	return false
	-- body
end
function modifers_item_set_12_aura:OnCreated( kv )
	if IsServer() then
			
		
		local unitKey = tostring(EntityHelper.getEntityIndex(self:GetParent()))
		if not self:GetParent().cas_table then
			self:GetParent().cas_table = {}
		end
		local netTable = self:GetParent().cas_table --服务端存储，避免使用getNetTable方法
		netTable["grjndj"] = netTable["grjndj"] + 2
		
		SetNetTableValue("UnitAttributes",unitKey,netTable)
	end

end
function modifers_item_set_12_aura:OnDestroy( kv )
	if IsServer() then	
		local unitKey = tostring(EntityHelper.getEntityIndex(self:GetParent()))
		if not self:GetParent().cas_table then
			self:GetParent().cas_table = {}
		end
		local netTable = self:GetParent().cas_table --服务端存储，避免使用getNetTable方法
		netTable["grjndj"] = netTable["grjndj"] - 2
		
		SetNetTableValue("UnitAttributes",unitKey,netTable)
	end

end
function modifers_item_set_12_aura:GetAttributes()
  return MODIFIER_ATTRIBUTE_PERMANENT
end
