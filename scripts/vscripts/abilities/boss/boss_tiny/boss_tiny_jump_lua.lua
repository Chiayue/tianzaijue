boss_tiny_jump_lua = class({})
LinkLuaModifier( "modifier_boss_tiny_jump_lua","lua_modifiers/boss/boss_tiny/modifier_boss_tiny_jump_lua.lua", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "stun_nothing","lua_modifiers/boss/stun_nothing", LUA_MODIFIER_MOTION_NONE )

function boss_tiny_jump_lua:OnSpellStart()
	local hCaster = self:GetCaster()
	if hCaster == nil then
		return
	end
	
	local vTargetPosition = self:GetCursorPosition()
	
	ParticleMgr.CreateWarnRing(hCaster,vTargetPosition,500,1.1)

    
	local origin_point = hCaster:GetAbsOrigin()
    local target_point = vTargetPosition
    local difference_vector = target_point - origin_point
    ProjectileManager:ProjectileDodge(hCaster)
    ParticleManager:CreateParticle("particles/items_fx/blink_dagger_start.vpcf", PATTACH_ABSORIGIN, hCaster)
    hCaster:SetForwardVector((target_point - origin_point):Normalized())

    if difference_vector:Length2D() > self:GetSpecialValueFor( "range" ) then  --Clamp the target point to the BlinkRangeClamp range in the same direction.
        vTargetPosition = origin_point + (target_point - origin_point):Normalized() * self:GetSpecialValueFor( "range" )
    end

	if hCaster:GetAbsOrigin().z>=vTargetPosition.z then
		hCaster.ispointhigher=true
	else
		hCaster.ispointhigher=false
	end
	EmitSoundOn("jineng.qinggong", hCaster)
	--hCaster:StartGesture(ACT_DOTA_RUN)
    local distance = (hCaster:GetOrigin()-vTargetPosition):Length2D()
    local jumpFV = ((vTargetPosition-hCaster:GetAbsOrigin())*Vector(1,1,0)):Normalized()
    self.jump_velocity = distance/60 + 15
    self.hight=200
    self.jumpFV = jumpFV
    self.distance = distance
    self.targetPoint = vTargetPosition
    hCaster:AddNewModifier( hCaster, self, "modifier_boss_tiny_jump_lua", {duration=1} )

end

--------------------------------------------------------------------------------
function boss_tiny_jump_lua:CastFilterResultLocation( vLocation )
    if IsServer() then
        local hCaster = self:GetCaster()
        if hCaster == nil then
            return UF_FAIL_CUSTOM
        end
        local distance = (hCaster:GetOrigin()-vLocation):Length2D()
        if distance<200 then
            return UF_FAIL_CUSTOM
        end
    end
    return UF_SUCCESS
    
end

--------------------------------------------------------------------------------

function boss_tiny_jump_lua:GetCustomCastErrorLocation( vLocation )
    local hCaster = self:GetCaster()
    if hCaster == nil then
        return "notallowgetdown"
    end
    local distance = (hCaster:GetOrigin()-vLocation):Length2D()
        if distance<200 then
            return "notallowgetdowndis"
        end
    return ""
end

