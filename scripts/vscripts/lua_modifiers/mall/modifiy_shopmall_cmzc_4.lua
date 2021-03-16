


modifiy_shopmall_cmzc_4 = class({})
LinkLuaModifier( "modifiy_shopmall_cmzc_4_buff", "lua_modifiers/mall/modifiy_shopmall_cmzc_4_buff", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function modifiy_shopmall_cmzc_4:GetTexture()
	return "rune/shopmall_cmzc_4"
end
--------------------------------------------------------------------------------
function modifiy_shopmall_cmzc_4:IsHidden()
	return true
end
function modifiy_shopmall_cmzc_4:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ABILITY_EXECUTED,
	}

	return funcs
end

function modifiy_shopmall_cmzc_4:OnCreated( kv )
	-- references
	
	self.particle= "particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_loadout.vpcf"
	--self.sound = "Hero_Zuus.StaticField"
	if not IsServer() then return end
	-- play effects

end

function modifiy_shopmall_cmzc_4:OnRefresh( kv )
	
end



function modifiy_shopmall_cmzc_4:OnAbilityExecuted( params )
	if not IsServer() then return end
	if params.unit~=self:GetParent() then return end
	if self:GetParent():PassivesDisabled() then return end
	if not params.ability then return end
	if params.ability:IsItem() or params.ability:IsToggle() then return end
	if params.ability:GetAbilityName() =="ability_hero_2" then return end
	local caster = self:GetParent()
	if not caster:HasModifier("modifiy_shopmall_cmzc_4_buff")  then
		local point = caster:GetAbsOrigin()
		local particle = ParticleManager:CreateParticle(self.particle, PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControl(particle,0,caster:GetAbsOrigin())
		caster:AddNewModifier( caster, nil, "modifiy_shopmall_cmzc_4_buff", {duration = 10} )
	end



end



function modifiy_shopmall_cmzc_4:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end