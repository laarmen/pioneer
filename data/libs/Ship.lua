--
-- Class: Ship
--
-- Class representing a ship. Inherits from <Body>.
--

--
-- Group: Methods
--

--
-- Method: Jettison
--
-- Jettison one unit of the given cargo type
--
-- > success = ship:Jettison(item)
--
-- On sucessful jettison, the <EventQueue.onJettison> event is triggered.
--
-- Parameters:
--
--   equip - the item to jettison
--
-- Result:
--
--   success - true if the item was jettisoned, false if the ship has no items
--             of that type or the ship is not in open flight
--
-- Availability:
--
--   alpha 10
--
-- Status:
--
--   experimental
--
function Ship:Jettison(equip)
	if self.flightState ~= "FLYING" and self.flightState ~= "DOCKED" and self.flightState ~= "LANDED" then
		return false
	end
	if self:RemoveEquip(equip, 1) < 1 then
		return false
	end
	if self.flightState == "FLYING" then
		self:SpawnCargo(equip)
		Event.Queue("onJettison", self, equip)
	elseif self.flightState == "DOCKED" then
		Event.Queue("onCargoUnload", self, equip)
	else -- LANDED
		Event.Queue("onCargoUnload", self, equip)
	end
end

--
-- Method: GetEquipSlotCapacity
--
-- Get the maximum number of a particular type of equipment this ship can
-- hold. This is the number of items that can be held, not the mass.
-- <AddEquip> will take care of ensuring the hull capacity is not exceeded.
--
-- > capacity = shiptype:GetEquipSlotCapacity(slot)
--
-- Parameters:
--
--   slot - a <Constants.EquipSlot> string for the wanted equipment type
--
-- Returns:
--
--   capacity - the maximum capacity of the equipment slot
--
-- Availability:
--
--  alpha 10
--
-- Status:
--
--  experimental
--
function Ship:GetEquipSlotCapacity(slot)
    return self.equipSet:SlotSize(slot)
end
