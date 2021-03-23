require( "event.Itembaolv" )
item_clothes = class({})


function item_clothes:DeclareFunctions()
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
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}
	return funcs
end

function item_clothes:GetModifierEvasion_Constant( params )	--智力
	return self.sb
end
function item_clothes:GetModifierHealthRegenPercentage( params )	--智力
	return self.smzhfbfb
end
function item_clothes:GetModifierBonusStats_Agility( params )
	return self.mj+self.qsx
end
function item_clothes:GetModifierBonusStats_Intellect( params )	--智力
	return self.zl+self.qsx
end

function item_clothes:GetModifierBonusStats_Strength( params )	--力量
	return self.ll+self.qsx
end
function item_clothes:GetModifierPhysicalArmorBonus( params )	--智力
	return self.hj
end
function item_clothes:GetModifierConstantHealthRegen( params )	--智力
	return self.smhf
end
function item_clothes:GetModifierHealthBonus( params )	--智力
	return self.smz
end

function item_clothes:GetModifierMagicalResistanceBonus( params )	--智力
	local mk = math.ceil(self.mfkx)
	if mk > 99 then
		mk =99
	end
	return mk
end
function item_clothes:GetModifierManaBonus( params )	--智力
	return self.mfz
end

function item_clothes:GetModifierConstantManaRegen( params )	--智力
	return self.mfhf
end

--------------------------------------------------------------------------------

function item_clothes:IsDebuff()
	return false
end

function item_clothes:GetTexture( params )
    return "item_clothes"
end
function item_clothes:IsHidden()
	return true
	-- body
end
function item_clothes:OnCreated( kv )
	self:OnRefresh( kv )
end

----------------------------------------

function item_clothes:OnRefresh( kv )
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
	self.shjm=0
	self.bgjyglhx=0
	self.bgjyglhl=0
	self.fsxx=0
	self.wlxx=0
	self.qjxx=0
	self.shhm=0
	
	self.bfbtsll=0	--百分比提升力量
	self.bfbtsmj=0		--百分比提升敏捷
	self.bfbtszl=0		--百分比提升智力
	self.bfbtsqsx=0		--百分比提升全属性
		
	if IsServer() then
		local itempro=self:GetAbility().itemtype
		if itempro.item_attributes.bgjyglhx then
			self.bgjyglhx=itempro.item_attributes.bgjyglhx
		end
		if itempro.item_attributes.mfhf then
			self.mfhf=itempro.item_attributes.mfhf
		end
		if itempro.item_attributes.bgjyglhl then
			self.bgjyglhl=itempro.item_attributes.bgjyglhl
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
		
		local attributes = {}
		
		if itempro.item_attributes_spe.shjm then
			self.shjm=itempro.item_attributes_spe.shjm
			attributes["shjm"] = self.shjm
		end
		if itempro.item_attributes_spe.fsxx then
			self.fsxx=itempro.item_attributes_spe.fsxx
			attributes["fsxx"] = self.fsxx
		end
		if itempro.item_attributes_spe.wlxx then
			self.wlxx=itempro.item_attributes_spe.wlxx
			attributes["wlxx"] = self.wlxx
		end
		if itempro.item_attributes_spe.qjxx then
			self.qjxx=itempro.item_attributes_spe.qjxx
			attributes["qjxx"] = self.qjxx
		end
		if itempro.item_attributes_spe.shhm then
			self.shhm=itempro.item_attributes_spe.shhm
			attributes["shhm"] = self.shhm
		end
		if itempro.item_attributes_spe.bfbtsll then
			self.bfbtsll=itempro.item_attributes_spe.bfbtsll
			attributes["bfbtsll"] = self.bfbtsll
		end
		if itempro.item_attributes_spe.bfbtsmj then
			self.bfbtsmj=itempro.item_attributes_spe.bfbtsmj
			attributes["bfbtsmj"] = self.bfbtsmj
		end
		if itempro.item_attributes_spe.bfbtszl then
			self.bfbtszl=itempro.item_attributes_spe.bfbtszl
			attributes["bfbtszl"] = self.bfbtszl
		end
		if itempro.item_attributes_spe.bfbtsqsx then
			self.bfbtsqsx=itempro.item_attributes_spe.bfbtsqsx
			attributes["bfbtsqsx"] = self.bfbtsqsx
		end

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
		
		if itempro.item_attributes.bgjyglhx then
			self.bgjyglhx=itempro.item_attributes.bgjyglhx
		end
		if itempro.item_attributes.mfhf then
			self.mfhf=itempro.item_attributes.mfhf
		end
		if itempro.item_attributes.bgjyglhl then
			self.bgjyglhl=itempro.item_attributes.bgjyglhl
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
		if itempro.item_attributes_spe.fsxx then
			self.fsxx=itempro.item_attributes_spe.fsxx
		end
		if itempro.item_attributes_spe.wlxx then
			self.wlxx=itempro.item_attributes_spe.wlxx
			
		end
		if itempro.item_attributes_spe.qjxx then
			self.qjxx=itempro.item_attributes_spe.qjxx
		end
		if itempro.item_attributes_spe.shhm then
			self.shhm=itempro.item_attributes_spe.shhm
		end
		if itempro.item_attributes_spe.bfbtsll then
			self.bfbtsll=itempro.item_attributes_spe.bfbtsll
			
		end
		if itempro.item_attributes_spe.bfbtsmj then
			self.bfbtsmj=itempro.item_attributes_spe.bfbtsmj
			
		end
		if itempro.item_attributes_spe.bfbtszl then
			self.bfbtszl=itempro.item_attributes_spe.bfbtszl
			
		end
		if itempro.item_attributes_spe.bfbtsqsx then
			self.bfbtsqsx=itempro.item_attributes_spe.bfbtsqsx
			
		end

		for k,v in pairs(HERO_CUSTOM_PRO.ascension_crit) do
			if self[k] then
				HERO_CUSTOM_PRO.ascension_crit[k]=v+self[k]
			end
		end
	end
end

function item_clothes:GetAttributes()
  return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end



function item_clothes:OnDestroy( )
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
		attributes["fsxx"] = self.fsxx and -self.fsxx or nil
		attributes["wlxx"] = self.wlxx and -self.wlxx or nil
		attributes["qjxx"] = self.qjxx and -self.qjxx or nil
		attributes["shhm"] = self.shhm and -self.shhm or nil
		attributes["bfbtsll"] = self.bfbtsll and -self.bfbtsll or nil
		attributes["bfbtsmj"] = self.bfbtsmj and -self.bfbtsmj or nil
		attributes["bfbtszl"] = self.bfbtszl and -self.bfbtszl or nil
		attributes["bfbtsqsx"] = self.bfbtsqsx and -self.bfbtsqsx or nil
		AttributesSet(self:GetParent(),attributes)
	end
end

-----------------------------------------------------------------------
