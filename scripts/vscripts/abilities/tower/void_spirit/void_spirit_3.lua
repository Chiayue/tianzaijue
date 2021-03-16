LinkLuaModifier( "modifier_void_spirit_3_phase", "abilities/tower/void_spirit/void_spirit_3.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_void_spirit_3_illusion", "abilities/tower/void_spirit/void_spirit_3.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if void_spirit_3 == nil then
	local funcCondition = function (self)
		if self:GetCaster():IsIllusion() then
			return false
		end
		return true
	end
	void_spirit_3 = class({funcCondition = funcCondition}, nil, ability_base_ai)
end
function void_spirit_3:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function void_spirit_3:OnSpellStart()
	local hCaster = self:GetCaster()
	hCaster:EmitSound("Hero_VoidSpirit.Dissimilate.Cast")
	hCaster:EmitSound("Hero_VoidSpirit.Dissimilate.Portals")
	local phase_duration = self:GetSpecialValueFor("phase_duration")
	hCaster:AddNewModifier(hCaster, self, "modifier_void_spirit_3_phase", { duration = phase_duration })
end
---------------------------------------------------------------------
--Modifiers
if modifier_void_spirit_3_phase == nil then
	modifier_void_spirit_3_phase = class({}, nil, ModifierHidden)
end
function modifier_void_spirit_3_phase:OnCreated(params)
	if IsServer() then
		local hParent = self:GetParent()
		
		local destination_fx_radius = self:GetAbilitySpecialValueFor("destination_fx_radius")
		local portals_per_ring = self:GetAbilitySpecialValueFor("portals_per_ring")
		local angle_per_ring_portal = self:GetAbilitySpecialValueFor("angle_per_ring_portal")
		local first_ring_distance_offset = self:GetAbilitySpecialValueFor("first_ring_distance_offset")
		local illusions_count = self:GetAbilitySpecialValueFor("illusions_count")
		self.illusions_duration = self:GetAbilitySpecialValueFor("illusions_duration")
		
		self.damage_radius = self:GetAbilitySpecialValueFor("damage_radius")
		self.tDoors = {
			-- {
			-- 	iParticleID = iParticleID,
			-- 	vPosition = vPosition,
			-- 	bActive = false
			-- }
		}
		local vPosition = hParent:GetAbsOrigin()

		self:CreateDoor(vPosition, true)
		local vDir = hParent:GetForwardVector()
		for i = 1, portals_per_ring do
			--偏移方向角度
			self:CreateDoor(vPosition + vDir * first_ring_distance_offset)
			vDir = RotatePosition(Vector(0, 0, 0), QAngle(0, 60, 0), vDir)
		end
		local tDoors = deepcopy(self.tDoors)
		-- 随机激活
		for i = 1, illusions_count do
			local tDoors = {}
			for i, _tDoor in ipairs(self.tDoors) do
				if _tDoor.bActive == false then
					tDoors[i] = _tDoor
					tDoors[i].index = i
				end
			end

			local tDoor = RandomValue(tDoors)
			self.tDoors[tDoor.index].bActive = true
			ParticleManager:SetParticleControl(self.tDoors[tDoor.index].iParticleID, 2, Vector(1, 0, 0))
			-- ArrayRemove(tDoors, tDoor)
		end
		-- 隐藏英雄
		hParent:AddNoDraw()
		ProjectileManager:ProjectileDodge(hParent)
	end
end
function modifier_void_spirit_3_phase:CreateDoor(vPosition, bCenter)
	vPosition = GetGroundPosition(vPosition, nil)
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/dissimilate/void_spirit_dissimilate.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iParticleID, 0, vPosition)
	ParticleManager:SetParticleControl(iParticleID, 1, Vector(self.damage_radius + 30, 0, 0))
	ParticleManager:SetParticleControl(iParticleID, 2, Vector(0, 0, 0))
	self:AddParticle(iParticleID, false, false, -1, false, false)
	if not bCenter then
		table.insert(self.tDoors, {
			iParticleID = iParticleID,
			vPosition = vPosition,
			bActive = false
		})
	else
		ParticleManager:SetParticleControl(iParticleID, 2, Vector(1, 0, 0))
	end
end
function modifier_void_spirit_3_phase:OnDestroy()
	if IsServer() then
		local hParent = self:GetParent()
		--现身
		hParent:RemoveNoDraw()
		hParent:StartGesture(ACT_DOTA_CAST_ABILITY_3_END)
		--特效
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/dissimilate/void_spirit_dissimilate_exit.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		ParticleManager:ReleaseParticleIndex(iParticleID)
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/dissimilate/void_spirit_dissimilate_dmg.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, hParent:GetAbsOrigin())
		ParticleManager:SetParticleControl(iParticleID, 1, Vector(self.damage_radius / 1.5, 0, self.damage_radius))
		ParticleManager:ReleaseParticleIndex(iParticleID)

		local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), self.damage_radius, self:GetAbility())
		for k, hTarget in pairs(tTargets) do
			local hModifier = hTarget:FindModifierByName("modifier_void_spirit_2_debuff")
			if IsValid(hModifier) then
				hModifier:Explode()
			end
		end

		for _, tDoor in ipairs(self.tDoors) do
			if tDoor.bActive == true then
				local hIllusion = CreateIllusion(hParent, tDoor.vPosition, true, hParent, hParent, hParent:GetTeamNumber(), self.illusions_duration, 100, 100)
				hIllusion:AddNewModifier(hParent, self:GetAbility(), "modifier_void_spirit_3_illusion", {duration = self.illusions_duration})
				hIllusion:StartGesture(ACT_DOTA_CAST_ABILITY_3_END)
				hIllusion:SetAbsOrigin(tDoor.vPosition)
				hIllusion:SetForwardVector((hParent:GetAbsOrigin() - tDoor.vPosition):Normalized())
				hIllusion:SetAcquisitionRange(3000)
				hIllusion.hSource = hParent

				local tTargets = FindUnitsInRadiusWithAbility(hParent, tDoor.vPosition, self.damage_radius, self:GetAbility())
				for k, hTarget in pairs(tTargets) do
					local hModifier = hTarget:FindModifierByName("modifier_void_spirit_2_debuff")
					if IsValid(hModifier) then
						hModifier:Explode()
					end
				end

				--特效
				local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/dissimilate/void_spirit_dissimilate_exit.vpcf", PATTACH_ABSORIGIN_FOLLOW, hIllusion)
				ParticleManager:ReleaseParticleIndex(iParticleID)
				local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/dissimilate/void_spirit_dissimilate_dmg.vpcf", PATTACH_CUSTOMORIGIN, nil)
				ParticleManager:SetParticleControl(iParticleID, 0, tDoor.vPosition)
				ParticleManager:SetParticleControl(iParticleID, 1, Vector(self.damage_radius / 1.5, 0, self.damage_radius))
				ParticleManager:ReleaseParticleIndex(iParticleID)
			end
		end

		hParent:EmitSound('Hero_VoidSpirit.Dissimilate.TeleportIn')
	end
end
function modifier_void_spirit_3_phase:CheckState()
	return {
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_SILENCED] = true,
		[MODIFIER_STATE_MUTED] = true,
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
	}
end
---------------------------------------------------------------------
if modifier_void_spirit_3_illusion == nil then
	modifier_void_spirit_3_illusion = class({}, nil, eom_modifier)
end
function modifier_void_spirit_3_illusion:OnCreated(params)
	if IsClient() then
		local iParticleID = ParticleManager:CreateParticle("particles/status_fx/void_spirit_aether_remnant.vpcf", PATTACH_ABSORIGIN, self:GetParent())
		self:AddParticle(iParticleID, false, true, 10001, false, false)
	end
end
function modifier_void_spirit_3_illusion:CheckState()
	return {
		[MODIFIER_STATE_SILENCED] = true,
		[MODIFIER_STATE_MUTED] = true,
		[MODIFIER_STATE_DISARMED] = false,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
	}
end
function modifier_void_spirit_3_illusion:EDeclareFunctions()
	return {
		[MODIFIER_EVENT_ON_ORDER] = {self:GetCaster()},
	}
end
function modifier_void_spirit_3_illusion:OnOrder(params)
	if DOTA_UNIT_ORDER_CAST_NO_TARGET == params.order_type and params.ability:GetAbilityName() == "void_spirit_1" then
		self:GetParent():PassiveCast(self:GetParent():FindAbilityByName("void_spirit_1"), DOTA_UNIT_ORDER_CAST_NO_TARGET)
	end
end