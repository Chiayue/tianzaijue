
modifier_bw_1_14 = class({})

--------------------------------------------------------------------------------

function modifier_bw_1_14:GetTexture()
	return "item_treasure/奥术指环"
end

function modifier_bw_1_14:IsHidden()
	return true
end
--------------------------------------------------------------------------------
function modifier_bw_1_14:OnCreated( kv )
	if IsServer() then
		self:StartIntervalThink( 10 )
	end
end
function modifier_bw_1_14:OnRefresh()
	
end

--------------------------------------------------------------------------------

function modifier_bw_1_14:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	}
	return funcs
end


function modifier_bw_1_14:OnIntervalThink()
	if IsServer() then
		local caster=self:GetCaster()
		local point = caster:GetAbsOrigin()
		if caster ~= nil and caster:IsAlive() then
			local units = FindAlliesInRadiusEx(caster,point,1000)
			local particleID= ParticleManager:CreateParticle("particles/items_fx/arcane_boots.vpcf",PATTACH_ABSORIGIN_FOLLOW,caster)
			ParticleManager:SetParticleControl(particleID,0,point)
			if units ~= nil then
				for key,unit in pairs(units) do
					if unit:IsHero() then
					local particleID= ParticleManager:CreateParticle("particles/items_fx/arcane_boots_recipient.vpcf",PATTACH_ABSORIGIN_FOLLOW,unit)
						ParticleManager:SetParticleControl(particleID,0,unit:GetAbsOrigin())
						unit:GiveMana(100)
					end
				end
			end
		end
	end
end

function modifier_bw_1_14:GetModifierBonusStats_Intellect( params )
	return 400
end
function modifier_bw_1_14:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end
-----------------------------------------------------------------------

