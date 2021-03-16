require( "event.Itembaolv" )
item_weapon = class({})


function item_weapon:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
	}
	return funcs
end
function item_weapon:GetModifierPreAttack_BonusDamage( params )	--智力
	
	return self.damage
	
end

function item_weapon:GetModifierAttackSpeedBonus_Constant( params )
	return self.attack_speed
end
function item_weapon:GetAttributes()
  return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end
function item_weapon:GetModifierBonusStats_Agility( params )
	return self.mj+self.qsx
end
function item_weapon:GetModifierBonusStats_Intellect( params )	--智力
	return self.zl+self.qsx
end

function item_weapon:GetModifierBonusStats_Strength( params )	--力量
	return self.ll+self.qsx
end
function item_weapon:GetModifierSpellAmplify_Percentage( params )	--力量
	return self.jnsh
end
function item_weapon:GetModifierPercentageCooldown( params )
	return self.lqsj
end
--------------------------------------------------------------------------------

function item_weapon:IsDebuff()
	return false
end

function item_weapon:GetTexture( params )
    return "item_weapon"
end
function item_weapon:IsHidden()
	return true
	-- body
end
function item_weapon:OnCreated( kv )
	self:OnRefresh( kv )
end

----------------------------------------

function item_weapon:OnRefresh( kv )
	if self:GetAbility() == nil then
		return
	end
	self.bDirty = 9
	self.damage=0
	self.attack_speed=0
	self.jnsh=0
	self.ll=0
	self.mj=0			--敏捷				
	self.zl=0
	self.qsx=0
	self.wlbjgl=0
	self.wlbjsh=0
	self.mfbjgl=0
	self.mfbjsh=0
	self.lqsj=0
	self.attack_damage_plus= 0
	self.gjdtsxsh=0
	self.gjqtsxsh= 0
	self.gjxx= 0
	self.fsxx= 0
	self.fjsh= 0
	self.zzsh= 0
	self.wlxx=0

	if IsServer() then
		local itempro=self:GetAbility().itemtype
		if not itempro then
			DebugPrint("[item_weapon.lua]: itempro is nil")
			itempro = {}
		end
		
		if itempro.item_attributes.wlxx then
			self.wlxx=itempro.item_attributes.wlxx
		end
		if itempro.item_attributes.attack_speed then
			self.attack_speed=itempro.item_attributes.attack_speed
		end
		if itempro.item_attributes.damage then
			self.damage=itempro.item_attributes.damage
		end
		if itempro.item_attributes.jnsh then
			self.jnsh=itempro.item_attributes.jnsh
		end
		if itempro.item_attributes.ll then
			self.ll=itempro.item_attributes.ll
		end
		if itempro.item_attributes.mj then
			self.mj=itempro.item_attributes.mj
		end
		if itempro.item_attributes.zl then
			self.zl=itempro.item_attributes.zl
		end
		if itempro.item_attributes.qsx then
			self.qsx=itempro.item_attributes.qsx
		end
		
		if itempro.item_attributes.attack_damage_plus then
			self.attack_damage_plus=itempro.item_attributes.attack_damage_plus
		end
		if itempro.item_attributes.gjdtsxsh then
			self.gjdtsxsh=itempro.item_attributes.gjdtsxsh
		end
		if itempro.item_attributes.gjqtsxsh then
			self.gjqtsxsh=itempro.item_attributes.gjqtsxsh
		end
		if itempro.item_attributes.gjxx then
			self.gjxx=itempro.item_attributes.gjxx
		end
		if itempro.item_attributes.fsxx then
			self.fsxx=itempro.item_attributes.fsxx
		end


		if itempro.item_attributes_spe.zzsh then
			self.zzsh=itempro.item_attributes_spe.zzsh
		end 
		if itempro.item_attributes_spe.fjsh then
			self.fjsh=itempro.item_attributes_spe.fjsh
		end
		if itempro.item_attributes_spe.lqsj then
			self.lqsj=itempro.item_attributes_spe.lqsj
		end
		if itempro.item_attributes_spe.wlbjgl then
			self.wlbjgl=itempro.item_attributes_spe.wlbjgl
		end
		if itempro.item_attributes_spe.wlbjsh then
			self.wlbjsh=itempro.item_attributes_spe.wlbjsh
		end
		if itempro.item_attributes_spe.mfbjgl then
			self.mfbjgl=itempro.item_attributes_spe.mfbjgl
		end
		if itempro.item_attributes_spe.mfbjsh then
			self.mfbjsh=itempro.item_attributes_spe.mfbjsh
		end
		
		local attributes = {}
		attributes["gjxx"] = self.gjxx
		attributes["fsxx"] = self.fsxx
		attributes["zzsh"] = self.zzsh
		attributes["fjsh"] = self.fjsh
		attributes["lqsj"] = self.lqsj
		attributes["wlbjgl"] = self.wlbjgl
		attributes["wlbjsh"] = self.wlbjsh
		attributes["mfbjgl"] = self.mfbjgl
		attributes["mfbjsh"] = self.mfbjsh
		attributes["jnsh"] = self.jnsh
		attributes["wlxx"] = self.wlxx
		
		AttributesSet(self:GetParent(),attributes)
		
		for k,v in pairs(HERO_CUSTOM_PRO.ascension_crit) do
			if self[k] then
				HERO_CUSTOM_PRO.ascension_crit[k]=v+self[k]
			end
		end
		CustomNetTables:SetTableValue( "ItemsInfo", tostring( self:GetParent():GetPlayerOwnerID() ), HERO_CUSTOM_PRO )
		local hAbility = self:GetParent():FindAbilityByName( "ascension_crit" )
		if hAbility ~= nil then
			if hAbility:GetIntrinsicModifierName() ~= nil then
				local hIntrinsicModifier = self:GetParent():FindModifierByName( hAbility:GetIntrinsicModifierName() )
				if hIntrinsicModifier then
					print( "Force Refresh intrinsic modifier after minor upgrade" )
					hIntrinsicModifier:ForceRefresh()
				end
			end
		end
	else

		local itempro=CustomNetTables:GetTableValue( "ItemsInfo", string.format( "%d", self:GetAbility():GetEntityIndex()))
		if itempro.item_attributes.wlxx then
			self.wlxx=itempro.item_attributes.wlxx
		end
		if itempro.item_attributes.attack_speed then
			self.attack_speed=itempro.item_attributes.attack_speed
		end
		if itempro.item_attributes.damage then
			self.damage=itempro.item_attributes.damage
		end
		if itempro.item_attributes.jnsh then
			self.jnsh=itempro.item_attributes.jnsh
		end
		if itempro.item_attributes.ll then
			self.ll=itempro.item_attributes.ll
		end
		if itempro.item_attributes.mj then
			self.mj=itempro.item_attributes.mj
		end
		if itempro.item_attributes.zl then
			self.zl=itempro.item_attributes.zl
		end
		
		if itempro.item_attributes.qsx then
			self.qsx=itempro.item_attributes.qsx
		end
		
		if itempro.item_attributes.attack_damage_plus then
			self.attack_damage_plus=itempro.item_attributes.attack_damage_plus
		end
		if itempro.item_attributes.gjdtsxsh then
			self.gjdtsxsh=itempro.item_attributes.gjdtsxsh
		end
		if itempro.item_attributes.gjqtsxsh then
			self.gjqtsxsh=itempro.item_attributes.gjqtsxsh
		end
		if itempro.item_attributes.gjxx then
			self.gjxx=itempro.item_attributes.gjxx
		end
		if itempro.item_attributes.fsxx then
			self.fsxx=itempro.item_attributes.fsxx
		end
	

		if itempro.item_attributes_spe.zzsh then
			self.zzsh=itempro.item_attributes_spe.zzsh
		end 
		if itempro.item_attributes_spe.fjsh then
			self.fjsh=itempro.item_attributes_spe.fjsh
		end
		if itempro.item_attributes_spe.lqsj then
			self.lqsj=itempro.item_attributes_spe.lqsj
		end
		if itempro.item_attributes_spe.wlbjgl then
			self.wlbjgl=itempro.item_attributes_spe.wlbjgl
		end
		if itempro.item_attributes_spe.wlbjsh then
			self.wlbjsh=itempro.item_attributes_spe.wlbjsh	
		end
		if itempro.item_attributes_spe.mfbjgl then
			self.mfbjgl=itempro.item_attributes_spe.mfbjgl
		end
		if itempro.item_attributes_spe.mfbjsh then
			self.mfbjsh=itempro.item_attributes_spe.mfbjsh	
		end
		for k,v in pairs(HERO_CUSTOM_PRO.ascension_crit) do
			if self[k] then
				HERO_CUSTOM_PRO.ascension_crit[k]=v+self[k]
			end
		end
	end
end




function item_weapon:OnDestroy( )
	if IsServer() then
		for k,v in pairs(HERO_CUSTOM_PRO.ascension_crit) do
			if self[k] then
				local result=math.max(0, v-self[k])
				HERO_CUSTOM_PRO.ascension_crit[k]=result
			end
		end
		CustomNetTables:SetTableValue( "ItemsInfo", tostring( self:GetParent():GetPlayerOwnerID() ), HERO_CUSTOM_PRO )
		local hAbility = self:GetParent():FindAbilityByName( "ascension_crit" )
		if hAbility ~= nil then
			if hAbility:GetIntrinsicModifierName() ~= nil then
				local hIntrinsicModifier = self:GetParent():FindModifierByName( hAbility:GetIntrinsicModifierName() )
				if hIntrinsicModifier then
					print( "Force Refresh intrinsic modifier after minor upgrade" )
					hIntrinsicModifier:ForceRefresh()
				end
			end
		end

		local attributes = {}
		attributes["gjxx"] = self.gjxx and -self.gjxx or nil
		attributes["fsxx"] = self.fsxx and -self.fsxx or nil
		attributes["zzsh"] = self.zzsh and -self.zzsh or nil
		attributes["fjsh"] = self.fjsh and -self.fjsh or nil
		attributes["lqsj"] = self.lqsj and -self.lqsj or nil
		attributes["wlbjgl"] = self.wlbjgl and -self.wlbjgl or nil
		attributes["wlbjsh"] = self.wlbjsh and -self.wlbjsh or nil
		attributes["mfbjgl"] = self.mfbjgl and -self.mfbjgl or nil
		attributes["mfbjsh"] = self.mfbjsh and -self.mfbjsh or nil
		attributes["jnsh"] = self.jnsh and -self.jnsh or nil
		attributes["wlxx"] = self.wlxx and -self.wlxx or nil
		
		AttributesSet(self:GetParent(),attributes)
	end
end

-----------------------------------------------------------------------

