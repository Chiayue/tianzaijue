modifier_boss_pudge_rot_creatwenyi_lua = class({})

-----------------------------------------------------------------------------

function modifier_boss_pudge_rot_creatwenyi_lua:IsHidden()
    return true
end
function modifier_boss_pudge_rot_creatwenyi_lua:OnCreated( kv )
	self.duration=self:GetAbility():GetSpecialValueFor("duration")
	
	
	if IsServer() then
			if self:GetAbility():GetLevel()==0 then
				self:GetParent():RemoveModifierByName(self:GetName())
				return 
			end
			self.nFXIndex = ParticleManager:CreateParticle( "particles/boss/pudge/batrider_firefly.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
			ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "", self:GetParent():GetOrigin(), true )
			ParticleManager:SetParticleControl( self.nFXIndex, 11, Vector(6,1,1)  )
			self:StartIntervalThink(0.3)
            self.init=true
	end
end

function modifier_boss_pudge_rot_creatwenyi_lua:OnIntervalThink()
    if IsServer() then
		local hCaster=self:GetCaster()
		if hCaster ~=nil and hCaster:IsAlive() then
			local hThinker = CreateModifierThinker( hCaster, self:GetAbility(), "modifier_boss_pudge_rot_creatwenyi_lua_thinker", { duration = self:GetRemainingTime() }, hCaster:GetOrigin(), hCaster:GetTeamNumber(), false )
		end
	end
end
-----------------------------------------------------------------------------

function modifier_boss_pudge_rot_creatwenyi_lua:OnDestroy()
	if IsServer() then
		if  self.nFXIndex~=nil then
			ParticleManager:DestroyParticle(self.nFXIndex, false)
		end
	end
end

-----------------------------------------------------------------------------

