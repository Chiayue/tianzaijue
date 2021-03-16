require( "event.Itembaolv" )
item_jewelry = class({})


function item_jewelry:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_EVASION_CONSTANT,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,

		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
	}
	return funcs
end
function item_jewelry:GetModifierSpellAmplify_Percentage( params )	--力量
	return self.jnsh
end
function item_jewelry:GetModifierPreAttack_BonusDamage( params )	--智力
	
	return self.damage
	
end
function item_jewelry:GetModifierEvasion_Constant( params )	--智力
	return self.sb
end
function item_jewelry:GetModifierHealthRegenPercentage( params )	--智力
	return self.smzhfbfb
end
function item_jewelry:GetModifierBonusStats_Agility( params )
	return self.mj+self.qsx
end
function item_jewelry:GetModifierBonusStats_Intellect( params )	--智力
	return self.zl+self.qsx
end

function item_jewelry:GetModifierBonusStats_Strength( params )	--力量
	return self.ll+self.qsx
end
function item_jewelry:GetModifierPhysicalArmorBonus( params )	--智力
	return self.hj
end
function item_jewelry:GetModifierConstantHealthRegen( params )	--智力
	return self.smhf
end
function item_jewelry:GetModifierHealthBonus( params )	--智力
	return self.smz
end

function item_jewelry:GetModifierMagicalResistanceBonus( params )	--智力
	return self.mfkx
end
function item_jewelry:GetModifierManaBonus( params )	--智力
	return self.mfz
end

function item_jewelry:GetModifierConstantManaRegen( params )	--智力
	return self.mfhf
end

--------------------------------------------------------------------------------

function item_jewelry:IsDebuff()
	return false
end

function item_jewelry:GetTexture( params )
    return "item_jewelry"
end
function item_jewelry:IsHidden()
	return true
	-- body
end
function item_jewelry:OnCreated( kv )
	self:OnRefresh( kv )
end

----------------------------------------

function item_jewelry:OnRefresh( kv )
	if self:GetAbility() == nil then
		return
	end
	self.bDirty = 9

	self.mfhf=0
	self.mfz=0
	self.mfkx=0
	self.ll=0
	self.mj=0			--敏捷				
	self.zl=0
	self.smz=0
	self.qsx=0

	self.smhf=0
	self.hj=0
	self.sb=0
	self.smzhfbfb=0

	self.attack_speed=0

	self.damage=0
	self.shjm=0
	self.jnsh=0
	self.wlbjgl=0
	self.wlbjsh=0
	self.mfbjgl=0
	self.mfbjsh=0
	self.fjsh=0
	self.gjjshj=0
	self.gjhfxl=0
	
	
	if IsServer() then
		local itempro=self:GetAbility().itemtype

		if itempro.item_attributes.gjjshj then
			self.gjjshj=itempro.item_attributes.gjjshj
		end

		if itempro.item_attributes.gjhfxl then
			self.gjhfxl=itempro.item_attributes.gjhfxl
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

		if itempro.item_attributes.mfhf then
			self.mfhf=itempro.item_attributes.mfhf
		end
		if itempro.item_attributes.mfz then
			self.mfz=itempro.item_attributes.mfz
		end
		if itempro.item_attributes.mfkx then
			self.mfkx=itempro.item_attributes.mfkx
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
		if itempro.item_attributes.smz then
			self.smz=itempro.item_attributes.smz
		end
		if itempro.item_attributes.smhf then
			self.smhf=itempro.item_attributes.smhf
			
		end
		if itempro.item_attributes.hj then
			self.hj=itempro.item_attributes.hj
			
		end
		if itempro.item_attributes.sb then
			self.sb=itempro.item_attributes.sb
			
		end
		if itempro.item_attributes.smzhfbfb then
			self.smzhfbfb=itempro.item_attributes.smzhfbfb
			
		end
		
		if itempro.item_attributes_spe.shjm then
			self.shjm=itempro.item_attributes_spe.shjm
		end
		if itempro.item_attributes_spe.fjsh then
			self.fjsh=itempro.item_attributes_spe.fjsh
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
		attributes["shjm"] = self.shjm
		attributes["fjsh"] = self.fjsh
		attributes["wlbjgl"] = self.wlbjgl
		attributes["wlbjsh"] = self.wlbjsh
		attributes["mfbjgl"] = self.mfbjgl
		attributes["mfbjsh"] = self.mfbjsh
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
		if itempro.item_attributes.gjjshj then
			self.gjjshj=itempro.item_attributes.gjjshj
		end

		if itempro.item_attributes.gjhfxl then
			self.gjhfxl=itempro.item_attributes.gjhfxl
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

		if itempro.item_attributes.mfhf then
			self.mfhf=itempro.item_attributes.mfhf
		end
		if itempro.item_attributes.mfz then
			self.mfz=itempro.item_attributes.mfz
		end
		if itempro.item_attributes.mfkx then
			self.mfkx=itempro.item_attributes.mfkx
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
		if itempro.item_attributes.smz then
			self.smz=itempro.item_attributes.smz
		end
		if itempro.item_attributes.smhf then
			self.smhf=itempro.item_attributes.smhf
			
		end
		if itempro.item_attributes.hj then
			self.hj=itempro.item_attributes.hj
			
		end
		if itempro.item_attributes.sb then
			self.sb=itempro.item_attributes.sb
			
		end
		if itempro.item_attributes.smzhfbfb then
			self.smzhfbfb=itempro.item_attributes.smzhfbfb
			
		end
		if itempro.item_attributes_spe.shjm then
			self.shjm=itempro.item_attributes_spe.shjm
		end
		if itempro.item_attributes_spe.fjsh then
			self.fjsh=itempro.item_attributes_spe.fjsh
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

function item_jewelry:GetAttributes()
  return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end



function item_jewelry:OnDestroy( )
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
		attributes["shjm"] = self.shjm and -self.shjm or nil
		attributes["fjsh"] = self.fjsh and -self.fjsh or nil
		attributes["wlbjgl"] = self.wlbjgl and -self.wlbjgl or nil
		attributes["wlbjsh"] = self.wlbjsh and -self.wlbjsh or nil
		attributes["mfbjgl"] = self.mfbjgl and -self.mfbjgl or nil
		attributes["mfbjsh"] = self.mfbjsh and -self.mfbjsh or nil
		AttributesSet(self:GetParent(),attributes)
	end
end

-----------------------------------------------------------------------

