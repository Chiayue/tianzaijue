
modifers_item_set_03_aura = class({})


function modifers_item_set_03_aura:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	}
	return funcs
end
function modifers_item_set_03_aura:GetModifierBonusStats_Agility( params )	--智力
	if IsServer() then
		if self:GetParent():GetPrimaryAttribute()==1	 then
			return 150
		end
	end
	return 0
end
function modifers_item_set_03_aura:GetModifierBonusStats_Strength( params )	--智力
	if IsServer() then
		if self:GetParent():GetPrimaryAttribute()==0	 then
			return 150
		end
	end
	return 0
end
function modifers_item_set_03_aura:GetModifierBonusStats_Intellect( params )	--智力
	if IsServer() then
		if self:GetParent():GetPrimaryAttribute()==2	 then
			return 150
		end
	end
	return 0
end


--------------------------------------------------------------------------------

function modifers_item_set_03_aura:IsDebuff()
	return false
end

function modifers_item_set_03_aura:GetTexture( params )
    return "tz/潮汐水灵"
end
function modifers_item_set_03_aura:IsHidden()
	return false
	-- body
end
function modifers_item_set_03_aura:OnCreated( kv )  
	if IsServer() then	
		local unitKey = tostring(EntityHelper.getEntityIndex(self:GetParent()))
		if not self:GetParent().cas_table then
			self:GetParent().cas_table = {}
		end
		local netTable = self:GetParent().cas_table --服务端存储，避免使用getNetTable方法
		netTable["wlbjgl"] = netTable["wlbjgl"] + 5
		netTable["mfbjgl"] = netTable["mfbjgl"] + 5
		netTable["shjm"] = netTable["shjm"] +20
		SetNetTableValue("UnitAttributes",unitKey,netTable)
 	end
end
function modifers_item_set_03_aura:OnDestroy( kv )
	if IsServer() then
		local unitKey = tostring(EntityHelper.getEntityIndex(self:GetParent()))
		if not self:GetParent().cas_table then
			self:GetParent().cas_table = {}
		end
		local netTable = self:GetParent().cas_table --服务端存储，避免使用getNetTable方法
		netTable["wlbjgl"] = netTable["wlbjgl"] - 5
		netTable["mfbjgl"] = netTable["mfbjgl"] - 5
		netTable["shjm"] = netTable["shjm"] -20
		SetNetTableValue("UnitAttributes",unitKey,netTable)
 	end
end
function modifers_item_set_03_aura:GetAttributes()
  return MODIFIER_ATTRIBUTE_PERMANENT
end
