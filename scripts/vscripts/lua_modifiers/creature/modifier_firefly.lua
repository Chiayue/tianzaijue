modifier_firefly = class({})

-----------------------------------------------------------------------------

function modifier_firefly:IsHidden()
    return true
end
function modifier_firefly:OnCreated( kv )
	self.duration=self:GetAbility():GetSpecialValueFor("duration")
	
	
	if IsServer() then
			if self:GetAbility():GetLevel()==0 then
				self:GetParent():RemoveModifierByName(self:GetName())
				return 
			end
			self.nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_batrider/batrider_firefly.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
			ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "", self:GetParent():GetOrigin(), true )
			ParticleManager:SetParticleControl( self.nFXIndex, 11, Vector(6,1,1)  )
			self:StartIntervalThink(0.3)
            self.init=true
	end
end

function modifier_firefly:OnIntervalThink()
    if IsServer() then
		local hCaster=self:GetCaster()
		if hCaster ~=nil and hCaster:IsAlive() then
			local hThinker = CreateModifierThinker( hCaster, self:GetAbility(), "modifier_firefly_thinker", { duration = self:GetRemainingTime() }, hCaster:GetOrigin(), hCaster:GetTeamNumber(), false )
		end
	end
end
-----------------------------------------------------------------------------

function modifier_firefly:OnDestroy()
	if IsServer() then
		if  self.nFXIndex~=nil then
			ParticleManager:DestroyParticle(self.nFXIndex, false)
		end
	end
end

-----------------------------------------------------------------------------

