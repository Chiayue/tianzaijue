LinkLuaModifier("modifier_item_light_speaker_amulet", "abilities/items/item_light_speaker_amulet.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if item_light_speaker_amulet == nil then
	item_light_speaker_amulet = class({})
end
function item_light_speaker_amulet:GetIntrinsicModifierName()
	return "modifier_item_light_speaker_amulet"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_light_speaker_amulet == nil then
	modifier_item_light_speaker_amulet = class({})
end
function modifier_item_light_speaker_amulet:OnCreated(params)
	self.delay = self:GetAbilitySpecialValueFor("delay")
	self.damage_pct = self:GetAbilitySpecialValueFor("damage_pct")
	self.interval = self:GetAbilitySpecialValueFor("interval")
	if IsServer() then
		self.fTotalDamage = 0
		self.tDamages = {}
	end
end
function modifier_item_light_speaker_amulet:OnRefresh(params)
	self.delay = self:GetAbilitySpecialValueFor("delay")
	self.damage_pct = self:GetAbilitySpecialValueFor("damage_pct")
	self.interval = self:GetAbilitySpecialValueFor("interval")
	if IsServer() then
	end
end
function modifier_item_light_speaker_amulet:OnDestroy()
	if IsServer() then
		for i = 1, #self.tDamages, 1 do
			local tDamage = self.tDamages[i]
			tDamage.damage = tDamage.fTotalDamage
			ApplyDamage(tDamage)
		end
	end
end
function modifier_item_light_speaker_amulet:OnIntervalThink()
	if IsServer() then
		local fTime = GameRules:GetGameTime()
		for i = #self.tDamages, 1, -1 do
			local tDamage = self.tDamages[i]
			if fTime >= tDamage.fTime then
				tDamage.fTotalDamage = tDamage.fTotalDamage - tDamage.damage
				tDamage.fTime = tDamage.fTime + self.interval
				ApplyDamage(tDamage)
				if tDamage.fTotalDamage <= 0 then
					table.remove(self.tDamages, i)
				end
			end
		end
		if #self.tDamages == 0 then
			self:StartIntervalThink(-1)
		end
	end
end
function modifier_item_light_speaker_amulet:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_AVOID_DAMAGE,
	}
end
function modifier_item_light_speaker_amulet:GetModifierAvoidDamage(params)
	if bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_LIGHT_SPEAKER_AMULET) ~= DOTA_DAMAGE_FLAG_LIGHT_SPEAKER_AMULET then
		if params.damage == params.damage and params.damage ~= 0 and params.original_damage ~= 0 then
			table.insert(self.tDamages, {
				victim = params.target,
				attacker = params.attacker,
				damage = params.original_damage/(self.delay/self.interval),
				damage_type = params.damage_type,
				damage_flags = params.damage_flags + DOTA_DAMAGE_FLAG_LIGHT_SPEAKER_AMULET,
				ability = params.inflictor,
				fTime = GameRules:GetGameTime() + self.interval,
				fTotalDamage = params.original_damage,
			})
			if #self.tDamages == 1 then
				self:StartIntervalThink(0)
			end
		end
		return 1
	end
end