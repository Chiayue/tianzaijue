-----------------------------------------------------------------
modifier_bw_5_8 = class({})
LinkLuaModifier( "modifier_bw_5_8_buff", "lua_modifiers/baowu/modifier_bw_5_8_buff", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Classifications
function modifier_bw_5_8:IsHidden()
	return true
end
--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_bw_5_8:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ABILITY_EXECUTED,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	}

	return funcs
end

function modifier_bw_5_8:OnCreated( kv )
	-- references
	self:OnRefresh()
end

function modifier_bw_5_8:OnRefresh( kv )
	-- references

end



function modifier_bw_5_8:OnAbilityExecuted( params )
	if not IsServer() then return end
	if params.unit~=self:GetParent() then return end
	if self:GetParent():PassivesDisabled() then return end
	if not params.ability then return end
	if params.ability:IsItem() or params.ability:IsToggle() then return end
	if params.ability:GetAbilityName() =="ability_hero_2" then return end


	local caster = self:GetParent()

	local cs = math.ceil(params.ability:GetManaCost(-1) * 0.4)
	if cs < 1 then
		return nil
	end
	
	if not caster:HasModifier("modifier_bw_5_8_buff") then
		caster:AddNewModifier( caster, nil, "modifier_bw_5_8_buff", {} )
		caster:SetModifierStackCount( "modifier_bw_5_8_buff",caster, cs)
	else
		cs = cs + caster:GetModifierStackCount("modifier_bw_5_8_buff",caster)
		caster:SetModifierStackCount( "modifier_bw_5_8_buff",caster, cs)
	end
	if cs >= 500 then
		local damage = caster:GetIntellect() * cs  *0.3
		local point = caster:GetAbsOrigin()
		caster:SetModifierStackCount( "modifier_bw_5_8_buff",caster, 1)
		local units = FindAlliesInRadiusExdd(caster,point,900)
		local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_sanity_eclipse_area.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
		ParticleManager:SetParticleControl( particle, 0, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl( particle, 1, Vector(900,0,0))
		ParticleManager:SetParticleControl( particle, 2, Vector(900,0,0))
		ParticleManager:SetParticleControl( particle, 3, Vector(900,0,0))
		EmitSoundOn( "Hero_ObsidianDestroyer.SanityEclipse.Cast", caster )
		EmitSoundOn( "Hero_ObsidianDestroyer.SanityEclipse", caster )
		if not units then
			return nil
		end
		for k,unit in pairs(units) do
			ApplyDamageMf(caster,unit,nil,damage)
		end

	end

end

function modifier_bw_5_8:GetModifierBonusStats_Intellect( params )
	return  36666
end
-----------
function modifier_bw_5_8:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end