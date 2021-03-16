
modifier_bw_all_56 = class({})

-----------------------------------------------------------------------------------------
function modifier_bw_all_56:GetTexture()
	return "item_treasure/智慧石"
end

function modifier_bw_all_56:IsHidden()
	return true
end
----------------------------------------

function modifier_bw_all_56:OnCreated( kv )
	
		self:OnRefresh()
	
end

----------------------------------------

function modifier_bw_all_56:OnRefresh()
	if IsServer() then
		local unitKey = tostring(EntityHelper.getEntityIndex(self:GetParent()))
		if not self:GetParent().cas_table then
			self:GetParent().cas_table = {}
		end
		local netTable = self:GetParent().cas_table --服务端存储，避免使用getNetTable方法
		netTable["jnmjts"] = netTable["jnmjts"] +1
		SetNetTableValue("UnitAttributes",unitKey,netTable)
	end
end
function modifier_bw_all_56:OnDestroy()
	if IsServer() then
		local unitKey = tostring(EntityHelper.getEntityIndex(self:GetParent()))
		if not self:GetParent().cas_table then
			self:GetParent().cas_table = {}
		end
		local netTable = self:GetParent().cas_table --服务端存储，避免使用getNetTable方法
		netTable["jnmjts"] = netTable["jnmjts"] -1
		SetNetTableValue("UnitAttributes",unitKey,netTable)
	end
end


function modifier_bw_all_56:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end