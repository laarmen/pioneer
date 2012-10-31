
EquipType = {}
equipType_meta = { __index = EquipType }

function EquipType.new (specs)
	local obj = {}
	for i,v in pairs(specs) do
		obj[i] = v
	end
	setmetatable(obj, equipType_meta)
	if type(self.slots) ~= "table" then
		self.slots = {self.slots}
	end
	return obj
end

function EquipType:GetDefaultSlot(ship)
	return self.slots[0]
end

function EquipType:IsValidSlot(ship, slot)
	for _, s in ipairs(self.slots) do
		if s == slot then
			return true
		end
	end
	return false
end

function __ApplyModifiers(ship, modifiers, num, factor)
	if num <= 0 then return 0 end
	local factor = factor or 1
	local applied_modifiers = {}
	local diff = 0
	local number_applied = num
	for k,v in pairs(modifiers) do
		local rest = factor*ship:AddModifier(k, factor*number_applied*v)
		if rest ~= 0 then -- The ship rejected part of the modifications
			local extra = math.floor(rest/v)
			if rest % v ~= 0 then
				extra = extra + 1
				ship:AddModifier(k, factor*(-v+rest%v))
			end
			for kk, vv in pairs(applied_modifiers) do -- revert the previous modifications.
				ship:AddModifier(kk, factor*(-extra*vv))
			end
			number_applied = number_applied - extra
		end
		applied_modifiers[k] = v
	end
	return number_applied
end

function EquipType:Install(num, slot, ship)
	return __ApplyModifiers(self.modifiers, num, ship, 1)
end

function EquipType:Uninstall(num, slot, ship)
	return __ApplyModifiers(self.modifiers, num, ship, -1)
end
