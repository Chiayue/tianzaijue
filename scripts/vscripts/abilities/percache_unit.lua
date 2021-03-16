if not percache_unit then
	percache_unit = class({})
end
function percache_unit:Precache(context)
	local hCaster = self:GetCaster()
	if hCaster then
		local sUnitName = hCaster._percache_unit
		if sUnitName then
			PrecacheUnitByNameSync(sUnitName, context)
			PrecacheResource("particle_folder", 'particles/units/heroes/' .. string.lower(sUnitName) .. '/', context)
		end
	end
end