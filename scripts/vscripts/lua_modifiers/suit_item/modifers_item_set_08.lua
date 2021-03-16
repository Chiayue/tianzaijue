
modifers_item_set_08 = class({})


function modifers_item_set_08:DeclareFunctions()
	local funcs = {
		
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
	}
	return funcs
end
function modifers_item_set_08:GetModifierBonusStats_Agility( params )	--智力
	
	return 150
end
function modifers_item_set_08:GetModifierBonusStats_Strength( params )	--智力
	
	return 150
end
function modifers_item_set_08:GetModifierBonusStats_Intellect( params )	--智力
	
	return 400
end
function modifers_item_set_08:GetModifierSpellAmplify_Percentage( params )	--智力
	
	return 40
end
function modifers_item_set_08:OnIntervalThink()
	if IsServer() then
		local hCaster=self:GetCaster()
		if hCaster ~= nil and hCaster:IsAlive() then
			local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetParent(), 900, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
			local num = #enemies
			if num > 3  then
				num = 3
			end
			for i=1,num do
				local enemy=enemies[i]
				if enemy ~= nil and enemy:IsInvulnerable() == false then
					EmitSoundOn( "Hero_Zuus.LightningBolt", hCaster )
					local particleID= ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning_head.vpcf",PATTACH_CUSTOMORIGIN,enemy)
					ParticleManager:SetParticleControl(particleID,0,enemy:GetOrigin()+Vector(0,0,1200))
					ParticleManager:SetParticleControl(particleID,1,enemy:GetOrigin())
					ParticleManager:ReleaseParticleIndex(particleID)
					particleID= ParticleManager:CreateParticle("particles/econ/items/zeus/lightning_weapon_fx/zuus_lb_cfx_il.vpcf",PATTACH_ABSORIGIN_FOLLOW,enemy)
					ParticleManager:ReleaseParticleIndex(particleID)
					local damageInfo = 
					{
						victim = enemy,
						attacker = self:GetParent(),
						damage = 15*self:GetParent():GetIntellect(),
						damage_type = DAMAGE_TYPE_MAGICAL,
						ability = nil,
					}

					ApplyDamage( damageInfo )
				end
			end		
		end
	end
end
--------------------------------------------------------------------------------

function modifers_item_set_08:IsDebuff()
	return false
end

function modifers_item_set_08:GetTexture( params )
  return "tz/雷霆悸动"
end
function modifers_item_set_08:IsHidden()
	return false
	-- body
end
function modifers_item_set_08:OnCreated( kv )
 if IsServer() then
 		self:StartIntervalThink( 4)	
 	end
end

function modifers_item_set_08:GetAttributes()
  return MODIFIER_ATTRIBUTE_PERMANENT
end
