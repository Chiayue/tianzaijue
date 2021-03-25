
modifier_cw_4_22 = class({})

-----------------------------------------------------------------------------------------
function modifier_cw_4_22:GetTexture()
	return "item_treasure/杀猪刀"
end

function modifier_cw_4_22:IsHidden()
	return true
end
----------------------------------------

function modifier_cw_4_22:OnCreated( kv )
	
		self:OnRefresh()
	
end

----------------------------------------

function modifier_cw_4_22:OnRefresh()
	if IsServer() then
		local unitKey = tostring(EntityHelper.getEntityIndex(self:GetParent()))
		if not self:GetParent().cas_table then
			self:GetParent().cas_table = {}
		end
		local netTable = self:GetParent().cas_table --服务端存储，避免使用getNetTable方法
		netTable["tmz3"] = netTable["tmz3"] + 40
		netTable["grjndj"] = netTable["grjndj"] + 2
		SetNetTableValue("UnitAttributes",unitKey,netTable)
	end
end
function modifier_cw_4_22:OnDestroy()
	if IsServer() then
		local unitKey = tostring(EntityHelper.getEntityIndex(self:GetParent()))
		if not self:GetParent().cas_table then
			self:GetParent().cas_table = {}
		end
		local netTable = self:GetParent().cas_table --服务端存储，避免使用getNetTable方法
		netTable["tmz3"] = netTable["tmz3"] - 40
		netTable["grjndj"] = netTable["grjndj"] - 2
		SetNetTableValue("UnitAttributes",unitKey,netTable)
	end
end


function modifier_cw_4_22:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end