--
-- Class: EquipSet
--
-- A container for a ship's equipment.
EquipSet = {}
equipSet_meta = { __index = EquipSet }

defaultSlots = {
	cargo=0,
	engine=1,
	laser_front=1,
	laser_rear=0,
	missile=0,
	ecm=1,
	scanner=1,
	radar=1,
	hypercloud=1,
	hull_autorepair=1,
	energy_booster=1,
	atmo_shield=1,
	cabin=50,
	shield=9999,
	fuel_scoop=1,
	cargo_scoop=1,
	laser_cooler=1,
	cargo_life_support=1,
	autopilot=1,
}

function EquipSet.new (slots, ship)
	obj = {}
	obj.ship = ship
	obj.slots = {}
	for k, n in pairs(defaultSlots) do
		obj.slots[k] = {__occupied = 0, __limit = n}
	end
	for k, n in pairs(slots) do
		obj.slots[k] = {__occupied = 0, __limit = n}
	end
	setmetatable(obj, equipSet_meta)
	return obj
end

--
-- Group: Methods
--

--
-- Method: FreeSpace
--
--  returns the available space in the given slot.
--
-- Parameters:
--
--  slot - The slot name.
--
-- Return:
-- 
--  free_space - The available space (integer)
--
function EquipSet:FreeSpace (slot)
	if not self.slots[slot] then
		return 0
	end
	local s = self.slots[slot]
	return s.__limit - s.__occupied
end

--
-- Method: Count
--
--  returns the number of occurrences of the given equipment in the specified slot.
--
-- Parameters:
--
--  equipment - The equipment to count.
--
--  slots - List of the slots to check. You can also provide a string if it
--          is only one slot. If this argument is not provided, all slots
--          will be searched.
--
-- Return:
-- 
--  free_space - The available space (integer)
--
function EquipSet:Count(equipment, slots)
	if type(slots) == "table" then
		local to_check = {}
		for _, s in ipairs(slots) do
			table.insert(to_check, s)
		end
	elseif slots == nil then
        to_check = self.slots
    else
        to_check = {self.slots[slot]}
	end

	local count = 0
	for _, slot in ipairs(to_check) do
		for _, e in ipairs(slot) do
			if e == equipment then
				count = count + 1
			end
		end
	end
	return count
end

-- Method: __Remove_NoCheck (PRIVATE)
--
--  Remove equipment without checking whether the slot is appropriate nor
--  calling the uninstall hooks nor even checking the arguments sanity.
--  It DOES check the free place in the slot.
--
-- Parameters:
--
--  Please refer to the Remove method.
--
-- Return:
--
--  Please refer to the Remove method.
--
function EquipSet:__Remove_NoCheck (equipment, num, slot)
	local s = self.slots[slot]
	if not s or s.__occupied == 0 then
		return 0
	end
	local removed = 0
	for i = 1,s.__limit do
		if removed >= num or s.__occupied <= 0 then
			return removed
		end
		if s[i] == equipment then
			s[i] = nil
			removed = removed + 1
			s.__occupied = s.__occupied - 1
		end
	end
	return removed
end

-- Method: __Add_NoCheck (PRIVATE)
--
--  Add equipment without checking whether the slot is appropriate nor
--  calling the install hooks nor even checking the arguments sanity.
--  It DOES check the free place in the slot.
--
-- Parameters:
--
--  Please refer to the Add method.
--
-- Return:
--
--  Please refer to the Add method.
--
function EquipSet:__Add_NoCheck(equipment, num, slot)
	if self:FreeSpace(slot) == 0 then
		return 0
	end
	local s = self.slots[slot]
	local added = 0
	for i = 1,s.__limit do
		if added >= num or s.__occupied >= s.__limit then
			return added
		end
		if not s[i] then
			s[i] = equipment
			added = added + 1
			s.__occupied = s.__occupied + 1
		end
	end
	return added
end

-- Method: Add
--
--  Add some equipment to the set, filling the specified slot as much as
--  possible.
--
-- Parameters:
--
--  equipment - the equipment to install
--  num - the number of pieces to install. If nil, only one will be installed.
--  slot - the slot where to install the equipment. It will be checked against
--         the equipment itself, the method will return -1 if the slot isn't
--         valid. If nil, the default slot for the equipment will be used.
--
-- Return:
--
--  installed - the number of pieces actually installed, or -1 if the specified
--              slot is not valid.
--
function EquipSet:Add(equipment, num, slot)
	local num = num or 1
	if not slot then
		local slot = equipment:GetDefaultSlot(self.ship)
	elseif not equipment:IsValidSlot(slot, ship) then
		return -1
	end

	local added = self:__Add_NoCheck(equipment, num, slot)
	if added == 0 then
		return 0
	end
	local postinst_diff = added - equipment:Install(num, slot, self.ship)
	if postinst_diff <= 0 then
		return added
	end

	self:__Remove_NoCheck(equipment, postinst_diff, slot)
	return added - postinst_diff
end

-- Method: Remove
--
--  Remove some equipment from the set.
--
-- Parameters:
--
--  equipment - the equipment to remove.
--  num - the number of pieces to uninstall. If nil, only one will be removed.
--  slot - the slot where to install the equipment. If nil, the default slot
--         for the equipment will be used.
--
-- Return:
--
--  removed - the number of pieces actually removed.
--
function EquipSet:Remove(equipment, num, slot)
	local num = num or 1
	if not slot then
		local slot = equipment:GetDefaultSlot(self.ship)
	end
	local removed = self:__Remove_NoCheck(equipment, num, slot)
	if removed == 0 then
		return 0
	end
	local postuninstall_diff = removed - equipment:Uninstall(num, slot, self.ship)
	if postuninstall_diff <= 0 then
		return removed
	end

	self:__Add_NoCheck(equipment, postuninstall_diff, slot)
	return removed - postuninstall_diff
end
