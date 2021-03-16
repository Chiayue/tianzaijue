
modifier_bw_3_20 = class({})

--------------------------------------------------------------------------------

function modifier_bw_3_20:GetTexture()
	return "item_treasure/达贡之神力"
end

function modifier_bw_3_20:IsHidden()
	return true
end
--------------------------------------------------------------------------------
function modifier_bw_3_20:OnCreated( kv )
	if IsServer() then
		self:StartIntervalThink( 1.5 )
	end
end
function modifier_bw_3_20:OnRefresh()
	
end

--------------------------------------------------------------------------------

function modifier_bw_3_20:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	}
	return funcs
end


function modifier_bw_3_20:OnIntervalThink()
	if IsServer() then
		local caster=self:GetCaster()
		local point = caster:GetAbsOrigin()
		if caster ~= nil and caster:IsAlive() then
			local units = FindAlliesInRadiusExdd(caster,point,1500)
			local damage = caster:GetIntellect() *30
			if #units >= 1 then
				ApplyDamageMf(caster,units[1],nil,damage)
				local particleID= ParticleManager:CreateParticle("particles/items_fx/dagon.vpcf",PATTACH_ROOTBONE_FOLLOW,caster)
				ParticleManager:SetParticleControl(particleID,0,point)
				ParticleManager:SetParticleControl(particleID,1,units[1]:GetAbsOrigin())
				ParticleManager:SetParticleControl(particleID,2,Vector(1500,0,0))
			end		
		end
	end
end

function modifier_bw_3_20:GetModifierBonusStats_Intellect( params )
	return 2000
end
function modifier_bw_3_20:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end
-----------------------------------------------------------------------

