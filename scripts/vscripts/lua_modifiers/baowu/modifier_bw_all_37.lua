
modifier_bw_all_37 = class({})

--------------------------------------------------------------------------------

function modifier_bw_all_37:GetTexture()
	return "item_treasure/剑气斩"
end

function modifier_bw_all_37:IsHidden()
	return true
end
----------------------------------------

function modifier_bw_all_37:OnCreated( kv )
	
		self:OnRefresh()
	
end

----------------------------------------

function modifier_bw_all_37:OnRefresh()
	if IsServer() then
		local caster = self:GetParent()
		local unitKey = tostring(EntityHelper.getEntityIndex(caster))
		if not caster.cas_table then
			caster.cas_table = {}
		end
		local netTable = caster.cas_table --服务端存储，避免使用getNetTable方法
		if caster.jqz_time == nil then
			caster.jqz_time = 0
		end
		caster.jqz_time = caster.jqz_time + 2
		netTable["jqz_time"] = caster.jqz_time
		SetNetTableValue("UnitAttributes",unitKey,netTable)
	end
end
function modifier_bw_all_37:OnDestroy()
	if IsServer() then
		local caster = self:GetParent()
		local unitKey = tostring(EntityHelper.getEntityIndex(caster))
		local netTable = caster.cas_table --服务端存储，避免使用getNetTable方法
		caster.jqz_time = caster.jqz_time - 2
		netTable["jqz_time"] = caster.jqz_time
		SetNetTableValue("UnitAttributes",unitKey,netTable)
	end
end

function modifier_bw_all_37:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end
-----------------------------------------------------------------------

