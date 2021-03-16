--Abilities
if nian_5_1 == nil then
	nian_5_1 = class({})
end
function nian_5_1:OnChannelFinish(bInterrupted)
	if IsServer() then
		self:GetCaster():RemoveAbility("nian_5_1")
	end
end