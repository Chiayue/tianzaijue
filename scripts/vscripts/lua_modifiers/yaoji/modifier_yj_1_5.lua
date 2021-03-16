
modifier_yj_1_5 = class({})

--------------------------------------------------------------------------------

function modifier_yj_1_5:GetTexture()
	return "xhp/守护药剂"
end
--------------------------------------------------------------------------------

function modifier_yj_1_5:IsHidden()
	return false
end

function modifier_yj_1_5:OnCreated( kv )
	if IsServer() then
		local unitKey = tostring(EntityHelper.getEntityIndex(self:GetParent()))
		if not self:GetParent().cas_table then
			self:GetParent().cas_table = {}
		end
		local netTable = self:GetParent().cas_table --服务端存储，避免使用getNetTable方法
		netTable["shjm"] = netTable["shjm"] + 30
		SetNetTableValue("UnitAttributes",unitKey,netTable)
		self.nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_bloodseeker/bloodseeker_bloodrage.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControl( self.nFXIndex, 0, self:GetParent():GetOrigin() )
	end
	self:OnRefresh()
end
function modifier_yj_1_5:OnDestroy( kv )
	if IsServer() then
		local unitKey = tostring(EntityHelper.getEntityIndex(self:GetParent()))
		if not self:GetParent().cas_table then
			self:GetParent().cas_table = {}
		end
		local netTable = self:GetParent().cas_table --服务端存储，避免使用getNetTable方法
		netTable["shjm"] = netTable["shjm"] - 30
		SetNetTableValue("UnitAttributes",unitKey,netTable)
		if self.nFXIndex then
			ParticleManager:DestroyParticle(self.nFXIndex, true)
		end
	end
end


function modifier_yj_1_5:OnRefresh()
end

function modifier_yj_1_5:GetAttributes()
	return MODIFIER_ATTRIBUTE_NONE 
end