


modifiy_shopmall_tszc_4 = class({})

--------------------------------------------------------------------------------

function modifiy_shopmall_tszc_4:GetTexture()
	return "rune/shopmall_tszc_4"
end
--------------------------------------------------------------------------------
function modifiy_shopmall_tszc_4:IsHidden()
	return false
end
function modifiy_shopmall_tszc_4:OnCreated( kv )
	if IsServer() then
		self:StartIntervalThink( 1 )
	end
end

function modifiy_shopmall_tszc_4:OnIntervalThink()
	if IsServer() then
		if self:GetCaster() and self:GetCaster():IsAlive() then
			local hero = self:GetCaster()
			local hp = hero:GetMaxHealth() *	0.15
			local mp = hero:GetMaxMana() * 	0.15
			hero:GiveMana(mp)
			hero:Heal(hp,hero)
			local p = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero )
			ParticleManager:ReleaseParticleIndex(p)
		end
	end
end



function modifiy_shopmall_tszc_4:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end