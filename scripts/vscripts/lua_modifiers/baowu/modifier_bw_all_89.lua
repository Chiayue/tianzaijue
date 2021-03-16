
modifier_bw_all_89 = class({})
LinkLuaModifier( "modifier_bw_all_89_buff", "lua_modifiers/baowu/modifier_bw_all_89_buff", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function modifier_bw_all_89:GetTexture()
	return "item_treasure/达贡之神力"
end

function modifier_bw_all_89:IsHidden()
	return true
end
--------------------------------------------------------------------------------
function modifier_bw_all_89:OnCreated( kv )
	if IsServer() then
		self:StartIntervalThink( 20 )
	end
end
function modifier_bw_all_89:OnRefresh()
	
end

--------------------------------------------------------------------------------


function modifier_bw_all_89:OnIntervalThink()
	if IsServer() then
		local caster=self:GetCaster()
		local point = caster:GetAbsOrigin()
		if caster ~= nil and caster:IsAlive() then
			local units = FindAlliesInRadiusExdd(caster,point,1200)
			local damage = caster:GetIntellect() *caster:GetLevel()*2
			local particleID= ParticleManager:CreateParticle("particles/econ/items/crystal_maiden/crystal_maiden_cowl_of_ice/maiden_crystal_nova_cowlofice.vpcf",PATTACH_ABSORIGIN_FOLLOW,caster)
			ParticleManager:SetParticleControl(particleID,0,point)
			ParticleManager:SetParticleControl(particleID,1,Vector(700,0,0))
			for k,unit in pairs(units) do
				if unit.isboss then
					 unit:AddNewModifier( unit, self, "modifier_bw_all_89_buff", {duration=0.5} )
				else
					 unit:AddNewModifier( unit, self, "modifier_bw_all_89_buff", {duration=1.5} )
				end
				ApplyDamageMf(caster,unit,nil,damage)
			end	
		end
	end
end


function modifier_bw_all_89:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end
-----------------------------------------------------------------------

