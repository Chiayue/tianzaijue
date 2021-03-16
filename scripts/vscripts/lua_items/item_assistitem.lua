require( "event.Itembaolv" )
item_assistitem = class({})


function item_assistitem:DeclareFunctions()
	local funcs = {
		
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
	}
	return funcs
end

function item_assistitem:GetModifierHealthRegenPercentage( params )	--智力
	return self.smzhfbfb
end
function item_assistitem:GetModifierPercentageCooldown( params )
	return self.lqsj
end
--------------------------------------------------------------------------------

function item_assistitem:IsDebuff()
	return false
end

function item_assistitem:GetTexture( params )
    return "item_assistitem"
end
function item_assistitem:IsHidden()
	return true
	-- body
end
function item_assistitem:OnCreated( kv )
	self:OnRefresh( kv )
end

----------------------------------------

function item_assistitem:OnRefresh( kv )
	if self:GetAbility() == nil then
		return
	end
	
	self.smzhfbfb=0
	self.lqsj=0

	self.bfbtsqsx = 0
	self.bfbtsll = 0
	self.bfbtszl = 0
	self.bfbtsmj = 0
	self.gjzjqsx = 0
	self.sgzjzl = 0
	self.sgzjsmz = 0
	self.sgzjqsx = 0
	self.sgzjmj = 0
	self.sgzjll = 0
	self.gjzjqsx = 0
	self.gjzjzl = 0
	self.gjzjmj = 0
	self.gjzjll = 0
	if IsServer() then
		
		local itempro=self:GetAbility().itemtype
		local attributes = {}
		
		if itempro.item_attributes.sgzjsmz then
			self.sgzjsmz=itempro.item_attributes.sgzjsmz
			attributes["sgzjsmz"] = self.sgzjsmz
		end
		if itempro.item_attributes.sgzjqsx then
			self.sgzjqsx=itempro.item_attributes.sgzjqsx
			attributes["sgzjqsx"] = self.sgzjqsx
		end
		if itempro.item_attributes.sgzjzl then
			self.sgzjzl=itempro.item_attributes.sgzjzl
			attributes["sgzjzl"] = self.sgzjzl
		end
		if itempro.item_attributes.sgzjmj then
			self.sgzjmj=itempro.item_attributes.sgzjmj
			attributes["sgzjmj"] = self.sgzjmj
		end
		if itempro.item_attributes.sgzjll then
			self.sgzjll=itempro.item_attributes.sgzjll
			attributes["sgzjll"] = self.sgzjll
		end
		if itempro.item_attributes.gjzjqsx then
			self.gjzjqsx=itempro.item_attributes.gjzjqsx
			attributes["gjzjqsx"] = self.gjzjqsx
		end
		if itempro.item_attributes.gjzjzl then
			self.gjzjzl=itempro.item_attributes.gjzjzl
			attributes["gjzjzl"] = self.gjzjzl
		end
		if itempro.item_attributes.gjzjmj then
			self.gjzjmj=itempro.item_attributes.gjzjmj
			attributes["gjzjmj"] = self.gjzjmj
		end
		if itempro.item_attributes.gjzjll then
			self.gjzjll=itempro.item_attributes.gjzjll
			attributes["gjzjll"] = self.gjzjll
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
		if itempro.item_attributes.smzhfbfb then
			self.smzhfbfb=itempro.item_attributes.smzhfbfb
			
		end
		if itempro.item_attributes_spe.lqsj then
			self.lqsj=itempro.item_attributes_spe.lqsj
			attributes["lqsj"] = self.lqsj
		end
		
		AttributesSet(self:GetParent(),attributes)
		
		
		
	else

		local itempro=CustomNetTables:GetTableValue( "ItemsInfo", string.format( "%d", self:GetAbility():GetEntityIndex()))
		
		if itempro.item_attributes.sgzjsmz then
			self.sgzjsmz=itempro.item_attributes.sgzjsmz
		end
		if itempro.item_attributes.sgzjqsx then
			self.sgzjqsx=itempro.item_attributes.sgzjqsx
		end
		if itempro.item_attributes.sgzjzl then
			self.sgzjzl=itempro.item_attributes.sgzjzl
		end
		if itempro.item_attributes.sgzjmj then
			self.sgzjmj=itempro.item_attributes.sgzjmj	
		end
		if itempro.item_attributes.sgzjll then
			self.sgzjll=itempro.item_attributes.sgzjll
		end
		if itempro.item_attributes.gjzjqsx then
			self.gjzjqsx=itempro.item_attributes.gjzjqsx
		end
		if itempro.item_attributes.gjzjzl then
			self.gjzjzl=itempro.item_attributes.gjzjzl
		end
		if itempro.item_attributes.gjzjmj then
			self.gjzjmj=itempro.item_attributes.gjzjmj
		end
		if itempro.item_attributes.gjzjll then
			self.gjzjll=itempro.item_attributes.gjzjll
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

		if itempro.item_attributes.smzhfbfb then
			self.smzhfbfb=itempro.item_attributes.smzhfbfb
		end
		if itempro.item_attributes_spe.lqsj then
			self.lqsj=itempro.item_attributes_spe.lqsj
		end
		
	end
end

function item_assistitem:GetAttributes()
  return MODIFIER_ATTRIBUTE_MULTIPLE
end



function item_assistitem:OnDestroy( )
	if IsServer() then
		
		
		
		local attributes = {}
		attributes["sgzjsmz"] = self.sgzjsmz and -self.sgzjsmz or nil
		attributes["sgzjqsx"] = self.sgzjqsx and -self.sgzjqsx or nil
		attributes["sgzjzl"] = self.sgzjzl and -self.sgzjzl or nil
		attributes["sgzjmj"] = self.sgzjmj and -self.sgzjmj or nil
		attributes["sgzjll"] = self.sgzjll and -self.sgzjll or nil
		attributes["gjzjqsx"] = self.gjzjqsx and -self.gjzjqsx or nil
		attributes["gjzjzl"] = self.gjzjzl and -self.gjzjzl or nil
		attributes["gjzjmj"] = self.gjzjmj and -self.gjzjmj or nil
		attributes["gjzjll"] = self.gjzjll and -self.gjzjll or nil
		attributes["bfbtsll"] = self.bfbtsll and -self.bfbtsll or nil
		attributes["bfbtsmj"] = self.bfbtsmj and -self.bfbtsmj or nil
		attributes["bfbtszl"] = self.bfbtszl and -self.bfbtszl or nil
		attributes["bfbtsqsx"] = self.bfbtsqsx and -self.bfbtsqsx or nil
		
		AttributesSet(self:GetParent(),attributes)
	end
end

-----------------------------------------------------------------------

