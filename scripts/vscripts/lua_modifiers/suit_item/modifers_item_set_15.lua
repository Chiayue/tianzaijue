
modifers_item_set_15 = class({})


function modifers_item_set_15:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
	}
	return funcs
end
function modifers_item_set_15:GetModifierHealthBonus( params )	--智力
	
	return 35000
end
function modifers_item_set_15:GetModifierSpellAmplify_Percentage( params )	--智力
	
	return 40
end

--------------------------------------------------------------------------------

function modifers_item_set_15:IsDebuff()
	return false
end

function modifers_item_set_15:GetTexture( params )
   return "tz/万世生命"
end
function modifers_item_set_15:IsHidden()
	return false
	-- body
end
function modifers_item_set_15:OnCreated( kv )
	 if IsServer() then	
		local unitKey = tostring(EntityHelper.getEntityIndex(self:GetParent()))
		if not self:GetParent().cas_table then
			self:GetParent().cas_table = {}
		end
		local netTable = self:GetParent().cas_table --服务端存储，避免使用getNetTable方法
		netTable["grjndj"] = netTable["grjndj"] + 6 
		netTable["wlbjgl"] = netTable["wlbjgl"] +10
		netTable["mfbjgl"] = netTable["mfbjgl"] +10
		
		SetNetTableValue("UnitAttributes",unitKey,netTable)
 	end
end
function modifers_item_set_15:OnDestroy( kv )
	if IsServer() then
		local unitKey = tostring(EntityHelper.getEntityIndex(self:GetParent()))
		if not self:GetParent().cas_table then
			self:GetParent().cas_table = {}
		end
		local netTable = self:GetParent().cas_table --服务端存储，避免使用getNetTable方法
		netTable["grjndj"] = netTable["grjndj"]- 6
		netTable["wlbjgl"] = netTable["wlbjgl"] - 10
		netTable["mfbjgl"] = netTable["mfbjgl"] -10
		SetNetTableValue("UnitAttributes",unitKey,netTable)
	end
end
function modifers_item_set_15:GetAttributes()
  return MODIFIER_ATTRIBUTE_PERMANENT
end
