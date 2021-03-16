
modifiy_shopmall_cmzc_5 = class({})
--------------------------------------------------------------------------------

function modifiy_shopmall_cmzc_5:GetTexture()
	return "rune/shopmall_cmzc_5"
end
--------------------------------------------------------------------------------
function modifiy_shopmall_cmzc_5:IsHidden()
	return true
end
function modifiy_shopmall_cmzc_5:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ABILITY_EXECUTED,
	}

	return funcs
end

function modifiy_shopmall_cmzc_5:OnCreated( kv )
	-- references
	
	self.particle= "particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_loadout.vpcf"
	--self.sound = "Hero_Zuus.StaticField"
	if not IsServer() then return end
	-- play effects

end

function modifiy_shopmall_cmzc_5:OnRefresh( kv )
	
end



function modifiy_shopmall_cmzc_5:OnAbilityExecuted( params )
	if not IsServer() then return end
	if params.unit~=self:GetParent() then return end
	if self:GetParent():PassivesDisabled() then return end
	if not params.ability then return end
	if params.ability:IsItem() or params.ability:IsToggle() then return end
	if params.ability:GetAbilityName() =="ability_hero_2" then return end
	if RollPercent(20)  then
		local caster = self:GetParent()
		local point = caster:GetAbsOrigin()
		local particle = ParticleManager:CreateParticle(self.particle, PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControl(particle,0,caster:GetAbsOrigin())
		caster:GiveMana(caster:GetMaxMana()/2)
	end
end



function modifiy_shopmall_cmzc_5:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end