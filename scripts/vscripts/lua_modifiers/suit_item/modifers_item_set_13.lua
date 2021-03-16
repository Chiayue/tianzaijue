
modifers_item_set_13 = class({})


function modifers_item_set_13:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
	}
	return funcs
end
function modifers_item_set_13:GetModifierSpellAmplify_Percentage( params )	--智力
	
	return 50
end
function modifers_item_set_13:GetModifierConstantManaRegen( params )	--智力
	
	return 30
end

function modifers_item_set_13:GetModifierHealthBonus( params )	--智力
	
	return 30000
end
function modifers_item_set_13:GetModifierBonusStats_Agility( params )	--智力
	if IsServer() then
		if self:GetParent():GetPrimaryAttribute()==1	 then
			return 2000
		end
	end
	return 0
end
function modifers_item_set_13:GetModifierBonusStats_Strength( params )	--智力
	if IsServer() then
		if self:GetParent():GetPrimaryAttribute()==0	 then
			return 2000
		end
	end
	return 0
end
function modifers_item_set_13:GetModifierBonusStats_Intellect( params )	--智力
	if IsServer() then
		if self:GetParent():GetPrimaryAttribute()==2	 then
			return 2000
		end
	end
	return 0
end

function modifers_item_set_13:OnIntervalThink()
	if IsServer() then
		local hCaster=self:GetCaster()
		if hCaster ~= nil and hCaster:IsAlive() then

			local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_huskar/huskar_inner_fire.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
				ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetOrigin() )
			local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetParent(), 900, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
			for _,enemy in pairs(enemies) do
				local basedamage=0
				if self:GetParent():GetPrimaryAttribute()==0	 then
					basedamage=self:GetParent():GetStrength()*30
				end
				if self:GetParent():GetPrimaryAttribute()==1	 then
					basedamage=self:GetParent():GetAgility()*30
				end
		    	if self:GetParent():GetPrimaryAttribute()==2	 then
					basedamage=self:GetParent():GetIntellect()*30
				end
		        local damage = {
					victim = enemy,
					attacker = self:GetParent(),
					damage = basedamage,
					damage_type = DAMAGE_TYPE_MAGICAL,
					ability = nil,
				}
				ApplyDamage( damage )
		    end
			
		end
	end
end
--------------------------------------------------------------------------------

function modifers_item_set_13:IsDebuff()
	return false
end

function modifers_item_set_13:GetTexture( params )
    return "tz/火焰焚天"
end
function modifers_item_set_13:IsHidden()
	return false
	-- body
end
function modifers_item_set_13:OnCreated( kv )
	 if IsServer() then
		self:StartIntervalThink(5)	
   
	   local unitKey = tostring(EntityHelper.getEntityIndex(self:GetParent()))
	   if not self:GetParent().cas_table then
		   self:GetParent().cas_table = {}
	   end
	   local netTable = self:GetParent().cas_table --服务端存储，避免使用getNetTable方法
	   netTable["wlbjgl"] = netTable["wlbjgl"] +10
	   netTable["mfbjgl"] = netTable["mfbjgl"] +10
	   netTable["zzsh"] = netTable["zzsh"] +20
	   SetNetTableValue("UnitAttributes",unitKey,netTable)
 	end
end
function modifers_item_set_13:OnDestroy( kv )
	if IsServer() then
		   
	   local unitKey = tostring(EntityHelper.getEntityIndex(self:GetParent()))
	   if not self:GetParent().cas_table then
		   self:GetParent().cas_table = {}
	   end
	   local netTable = self:GetParent().cas_table --服务端存储，避免使用getNetTable方法
	   netTable["wlbjgl"] = netTable["wlbjgl"] -10
	   netTable["mfbjgl"] = netTable["mfbjgl"] -10
	   netTable["zzsh"] = netTable["zzsh"] -20
	   SetNetTableValue("UnitAttributes",unitKey,netTable)
		
	end
end
function modifers_item_set_13:GetAttributes()
  return MODIFIER_ATTRIBUTE_PERMANENT
end
