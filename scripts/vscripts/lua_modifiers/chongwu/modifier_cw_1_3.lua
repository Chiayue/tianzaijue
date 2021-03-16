
modifier_cw_1_3 = class({})

-----------------------------------------------------------------------------------------
function modifier_cw_1_3:GetTexture()
	return "item_treasure/杀猪刀"
end

function modifier_cw_1_3:IsHidden()
	return true
end
----------------------------------------

function modifier_cw_1_3:OnCreated( kv )
	
		self:OnRefresh()
	
end

----------------------------------------

function modifier_cw_1_3:OnRefresh()
	if IsServer() then
		local unitKey = tostring(EntityHelper.getEntityIndex(self:GetParent()))
		if not self:GetParent().cas_table then
			self:GetParent().cas_table = {}
		end
		local netTable = self:GetParent().cas_table --服务端存储，避免使用getNetTable方法
		netTable["jyjc"] = netTable["jyjc"] + 5
		SetNetTableValue("UnitAttributes",unitKey,netTable)
	end
end
function modifier_cw_1_3:OnDestroy()
	if IsServer() then
		local unitKey = tostring(EntityHelper.getEntityIndex(self:GetParent()))
		if not self:GetParent().cas_table then
			self:GetParent().cas_table = {}
		end
		local netTable = self:GetParent().cas_table --服务端存储，避免使用getNetTable方法
		netTable["jyjc"] = netTable["jyjc"] - 5
		SetNetTableValue("UnitAttributes",unitKey,netTable)
	end
end


function modifier_cw_1_3:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end