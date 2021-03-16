
modifier_bw_3_19 = class({})
LinkLuaModifier( "modifier_bw_3_19_buff", "lua_modifiers/baowu/modifier_bw_3_19_buff", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function modifier_bw_3_19:GetTexture()
	return "item_treasure/纷争面纱"
end

function modifier_bw_3_19:IsHidden()
	return true
end
--------------------------------------------------------------------------------
function modifier_bw_3_19:OnCreated( kv )
	if IsServer() then
		self:StartIntervalThink( 20 )
	end
end
function modifier_bw_3_19:OnRefresh()
	
end

--------------------------------------------------------------------------------

function modifier_bw_3_19:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS

	}
	return funcs
end


function modifier_bw_3_19:OnIntervalThink()
	if IsServer() then
		local caster=self:GetCaster()
		local point = caster:GetAbsOrigin()
		if caster ~= nil and caster:IsAlive() then
			local units = FindAlliesInRadiusExdd(caster,point,1200)
			local particleID= ParticleManager:CreateParticle("particles/items2_fx/veil_of_discord.vpcf",PATTACH_POINT_FOLLOW,caster)
			ParticleManager:SetParticleControl(particleID,0,point)
			ParticleManager:SetParticleControl(particleID,1,Vector(1200,1200,1200))
			if units ~= nil then
				for key,unit in pairs(units) do
						local particleID= ParticleManager:CreateParticle("particles/items2_fx/veil_of_discord_debuff.vpcf",PATTACH_ABSORIGIN_FOLLOW,unit)
						ParticleManager:SetParticleControl(particleID,0,unit:GetAbsOrigin())
						unit:AddNewModifier( unit, nil, "modifier_bw_3_19_buff", {duration=5} )
				end
			end
		end
	end
end

function modifier_bw_3_19:GetModifierBonusStats_Strength( params )
	return 900
end
function modifier_bw_3_19:GetModifierBonusStats_Agility( params )
	return 900
end
function modifier_bw_3_19:GetModifierBonusStats_Intellect( params )
	return 900
end
function modifier_bw_3_19:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end
-----------------------------------------------------------------------

