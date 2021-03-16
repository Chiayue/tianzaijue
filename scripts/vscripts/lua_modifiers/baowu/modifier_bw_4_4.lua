
modifier_bw_4_4 = class({})

--------------------------------------------------------------------------------

function modifier_bw_4_4:GetTexture()
	return "item_treasure/极"
end
--------------------------------------------------------------------------------
function modifier_bw_4_4:IsHidden()
	return true
end
function modifier_bw_4_4:OnCreated( kv )
	if IsServer() then
		local caster = self:GetParent()
		local unitKey = tostring(EntityHelper.getEntityIndex(caster))
		if not caster.cas_table then
			caster.cas_table = {}
		end
		local netTable = caster.cas_table --服务端存储，避免使用getNetTable方法
		if caster:GetPrimaryAttribute()==0	 then
			netTable["bfbtsll"] = netTable["bfbtsll"] + 150
		end
		if caster:GetPrimaryAttribute()==1	 then
			netTable["bfbtsmj"] = netTable["bfbtsmj"] + 150
		end
		if caster:GetPrimaryAttribute()==2	 then
			netTable["bfbtszl"] = netTable["bfbtszl"] + 150
		end
		SetNetTableValue("UnitAttributes",unitKey,netTable)	
	end
	self:OnRefresh()
end


function modifier_bw_4_4:OnRefresh()
	
	

end
function modifier_bw_4_4:OnDestroy( )
	if IsServer() then
		local caster = self:GetCaster()
		local unitKey = tostring(EntityHelper.getEntityIndex(caster))
		if not caster.cas_table then
			caster.cas_table = {}
		end
		local netTable = caster.cas_table --服务端存储，避免使用getNetTable方法
		if caster:GetPrimaryAttribute()==0	 then
			netTable["bfbtsll"] = netTable["bfbtsll"] - 150
		end
		if caster:GetPrimaryAttribute()==1	 then
			netTable["bfbtsmj"] = netTable["bfbtsmj"] - 150
		end
		if caster:GetPrimaryAttribute()==2	 then
			netTable["bfbtszl"] = netTable["bfbtszl"] - 150
		end
		SetNetTableValue("UnitAttributes",unitKey,netTable)	
	end
end

function modifier_bw_4_4:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end