
modifier_gh_1_102 = class({})

--------------------------------------------------------------------------------

function modifier_gh_1_102:GetTexture()
	return "item_treasure/刃甲"
end
--------------------------------------------------------------------------------

function modifier_gh_1_102:IsHidden()
	return true
end

function modifier_gh_1_102:OnCreated( kv )
	self:OnRefresh()
end
function modifier_gh_1_102:OnDestroy( kv )
	if IsServer() then
		local unitKey = tostring(EntityHelper.getEntityIndex(self:GetParent()))
		if not self:GetParent().cas_table then
			self:GetParent().cas_table = {}
		end
		local netTable = self:GetParent().cas_table --服务端存储，避免使用getNetTable方法
		netTable["wlct"] = netTable["wlct"] - 3
		netTable["mfct"] = netTable["mfct"] - 3
		SetNetTableValue("UnitAttributes",unitKey,netTable)
		if self.nFXIndex then
			ParticleManager:DestroyParticle(self.nFXIndex, true)
		end
	end
end

function modifier_gh_1_102:OnRefresh()
	if IsServer() then
		self.nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/omniknight/omniknight_fall20_immortal/omniknight_fall20_immortal_degen_aura_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControl( self.nFXIndex, 0, self:GetParent():GetOrigin() )
		local unitKey = tostring(EntityHelper.getEntityIndex(self:GetParent()))
		if not self:GetParent().cas_table then
			self:GetParent().cas_table = {}
		end
		local netTable = self:GetParent().cas_table --服务端存储，避免使用getNetTable方法
		netTable["wlct"] = netTable["wlct"] + 3
		netTable["mfct"] = netTable["mfct"] + 3
		SetNetTableValue("UnitAttributes",unitKey,netTable)
	end
end

function modifier_gh_1_102:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end