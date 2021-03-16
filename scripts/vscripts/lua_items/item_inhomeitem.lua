require( "event.Itembaolv" )
item_inhomeitem = class({})

--------------------------------------------------------------------------------

function item_inhomeitem:IsDebuff()
	return false
end

function item_inhomeitem:GetTexture( params )
    return "item_inhomeitem"
end
function item_inhomeitem:IsHidden()
	return true
	-- body
end
function item_inhomeitem:OnCreated( kv )
	self:OnRefresh( kv )
end

----------------------------------------

function item_inhomeitem:OnRefresh( kv )
	if self:GetAbility() == nil then
		return
	end
	
	self.jqjc=0	
	self.msmjq=0		
	self.sgzjjb=0
	self.jyjc=0
	
	if IsServer() then
		
		local itempro=self:GetAbility().itemtype

		if itempro.item_attributes.jqjc then
			self.jqjc=itempro.item_attributes.jqjc
			
		end
		if itempro.item_attributes.jyjc then
			self.jyjc=itempro.item_attributes.jyjc
			
		end
		if itempro.item_attributes.msmjq then
			self.msmjq=itempro.item_attributes.msmjq
			
		end
		if itempro.item_attributes.sgzjjb then
			self.sgzjjb=itempro.item_attributes.sgzjjb
			
		end
		if itempro.item_attributes_spe.jqjc then
			self.jqjc=self.jqjc+itempro.item_attributes_spe.jqjc
			
		end
		if itempro.item_attributes_spe.jyjc then
			self.jyjc=self.jyjc+itempro.item_attributes_spe.jyjc
		end
		if itempro.item_attributes_spe.msmjq then
			self.msmjq=self.msmjq+itempro.item_attributes_spe.msmjq
		end
		if itempro.item_attributes_spe.sgzjjb then
			self.sgzjjb=self.sgzjjb+itempro.item_attributes_spe.sgzjjb
		end
		
		local attributes = {}
		attributes["jqjc"] = self.jqjc
		attributes["jyjc"] = self.jyjc
		attributes["msmjq"] = self.msmjq
		attributes["sgzjjb"] = self.sgzjjb
		AttributesSet(self:GetParent(),attributes)
		
		
	else

		local itempro=CustomNetTables:GetTableValue( "ItemsInfo", string.format( "%d", self:GetAbility():GetEntityIndex()))
		
		if itempro.item_attributes.jqjc then
			self.jqjc=itempro.item_attributes.jqjc
			
		end
		if itempro.item_attributes.jyjc then
			self.jyjc=itempro.item_attributes.jyjc
			
		end
		if itempro.item_attributes.msmjq then
			self.msmjq=itempro.item_attributes.msmjq
			
		end
		if itempro.item_attributes.sgzjjb then
			self.sgzjjb=itempro.item_attributes.sgzjjb
			
		end
		if itempro.item_attributes_spe.jqjc then
			self.jqjc=self.jqjc+itempro.item_attributes_spe.jqjc
			
		end
		if itempro.item_attributes_spe.jyjc then
			self.jyjc=self.jyjc+itempro.item_attributes_spe.jyjc
		end
		if itempro.item_attributes_spe.msmjq then
			self.msmjq=self.msmjq+itempro.item_attributes_spe.msmjq
			
		end
		if itempro.item_attributes_spe.sgzjjb then
			self.sgzjjb=self.sgzjjb+itempro.item_attributes_spe.sgzjjb
			
		end

	end
end

function item_inhomeitem:GetAttributes()
  return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end



function item_inhomeitem:OnDestroy( )
	if IsServer() then
		
		local attributes = {}
		attributes["jqjc"] = self.jqjc and -self.jqjc or nil
		attributes["jyjc"] = self.jyjc and -self.jyjc or nil
		attributes["msmjq"] = self.msmjq and -self.msmjq or nil
		attributes["sgzjjb"] = self.sgzjjb and -self.sgzjjb or nil
		AttributesSet(self:GetParent(),attributes)
	end
end

-----------------------------------------------------------------------
