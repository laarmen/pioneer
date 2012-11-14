local compat = {}
--
-- Class: Ship
--
-- Class representing a ship. Inherits from <Body>.
--

--
-- Group: Methods
--

--
-- Method: Refuel
--
-- Use the content of the cargo to refuel
--
-- > used_units = ship:Refuel(1)
--
-- Parameters:
--
--   amount - the amount of fuel (in tons) to take from the cargo
--
-- Result:
--
--   used_units - how much fuel units have been used to fuel the tank.
--
-- Availability:
--
--   alpha 26
--
-- Status:
--
--   experimental
--
function Ship:Refuel(amount)
    local currentFuel = self.fuel
    if currentFuel == 100 then
        return 0
    end
    local ship_stats = self:GetStats()
    local needed = math.clamp(math.ceil(ship_stats.maxFuelTankMass - ship_stats.fuelMassLeft),0, amount)
    local removed = self:RemoveEquip('WATER', needed)
    self:SetFuelPercent(math.clamp(self.fuel + removed * 100 / ship_stats.maxFuelTankMass, 0, 100))
    return removed
end


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
	local c = compat.slots.old2new[slot]
	if c then
        debug.deprecated()
		return self.equipSet:SlotSize(c)
	end
    return self.equipSet:SlotSize(slot)
end

--
-- Method: GetEquipCount
--
-- Get the number of a given equipment or cargo item in a given equipment slot
--
-- > count = ship:GetEquipCount(slot, item)
--
-- Parameters:
--
--   slot - a <Constants.EquipSlot> string for the slot
--
--   item - a <Constants.EquipType> string for the item
--
-- Return:
--
--   count - the number of the given item in the slot
--
-- Availability:
--
--  alpha 10
--
-- Status:
--
--  experimental
--
function Ship:GetEquipCount(slot, item)
	local c = compat.slots.old2new[slot]
	if c then
        debug.deprecated()
		slot = c
	end
	if type(item) == "string" then
        debug.deprecated()
		item = compat.equip.old2new[item]
	end
    return self.equipSet:Count(item, slot)
end

--
-- Method: AddEquip
--
-- Add an equipment or cargo item to its appropriate equipment slot
--
-- > num_added = ship:AddEquip(item, count)
--
-- Parameters:
--
--   item - a <Constants.EquipType> string for the item
--
--   count - optional. The number of this item to add. Defaults to 1.
--
-- Return:
--
--   num_added - the number of items added. Can be less than count if there
--               was not enough room.
--
-- Example:
--
-- > ship:AddEquip("ANIMAL_MEAT", 10)
--
-- Availability:
--
--   alpha 10
--
-- Status:
--
--   experimental
--
function Ship:AddEquip(item, count)
	if type(item) == "string" then
		debug.deprecated()
		item = compat.equip.old2new[item]
	end
	return self.equipSet:Add(self, item, count)
end
--
-- Method: GetEquip
--
-- Get a list of equipment in a given equipment slot
--
-- > equip = ship:GetEquip(slot, index)
-- > equiplist = ship:GetEquip(slot)
--
-- Parameters:
--
--   slot - a <Constants.EquipSlot> string for the wanted equipment type
--
--   index - optional. The equipment position in the slot to fetch. If
--           specified the item at that position in the slot will be returned,
--           otherwise a table containing all items in the slot will be
--           returned instead.
--
-- Return:
--
--   equip - when index is specified, a <Constants.EquipType> string for the
--           item
--
--   equiplist - when index is not specified, a table of zero or more
--               <Constants.EquipType> strings for all the items in the slot
--
-- Availability:
--
--  alpha 10
--
-- Status:
--
--  experimental
--
Ship.GetEquip = function (self, slot, index)
	local c = compat.slots.old2new[slot]
	if c then
        debug.deprecated()
		slot = c
	end
	local ret = self.equipSet:Get(slot, index)
	if c then
		if type(index) == "number" then
			if ret then
				ret = compat.equip.new2old[ret]
			else
				ret = "NONE"
			end
		else
			local tmp = {}
			for i=1,self.equipSet:SlotSize(slot),1 do
				if ret[i] then
					tmp[i] = compat.equip.new2old[ret[i]]
				else
					tmp[i] = "NONE"
				end
			end
			ret = tmp
		end
	end
	return ret
end

--
-- Method: GetEquipFree
--
-- Get the amount of free space in a given equipment slot
--
-- > free = ship:GetEquipFree(slot)
--
-- Parameters:
--
--   slot - a <Constants.EquipSlot> string for the slot to check
--
-- Return:
--
--   free - the number of item spaces left in this slot
--
-- Availability:
--
--  alpha 10
--
-- Status:
--
--  experimental
--
Ship.GetEquipFree = function (self, slot)
	local c = compat.slots.old2new[slot]
	if c then
        debug.deprecated()
		return self.equipSet:FreeSpace(c)
	end
    return self.equipSet:FreeSpace(slot)
end

compat.slots = {}
compat.equip = {}
compat.slots.old2new={
	CARGO="cargo", ENGINE="engine", LASER="laser_front",
	MISSILE="missile", ECM="ecm", SCANNER="scanner", RADARMAPPER="radar_mapper",
	HYPERCLOUD="hypercloud", HULLAUTOREPAIR="hull_autorepair",
	ENERGYBOOSTER="energy_booster", ATMOSHIELD="atmo_shield", CABIN="cabin",
	SHIELD="shield", FUELSCOOP="fuel_scoop", CARGOSCOOP="cargo_scoop",
	LASERCOOLER="laser_cooler", CARGOLIFESUPPORT="cargo_life_support",
	AUTOPILOT="autopilot"
}
--
-- Method: SetEquip
--
-- Overwrite a single item of equipment in a given equipment slot
--
-- > ship:SetEquip(slot, index, equip)
--
-- Parameters:
--
--   slot - a <Constants.EquipSlot> string for the equipment slot
--
--   index - the position to store the item in
--
--   item - a <Constants.EquipType> string for the item
--
-- Example:
--
-- > -- add a laser to the rear laser mount
-- > ship:SetEquip("LASER", 1, "PULSECANNON_1MW")
--
-- Availability:
--
--  alpha 10
--
-- Status:
--
--  experimental
--
Ship.SetEquip = function (self, slot, index, equip)
	if type(item) == "string" then
		debug.deprecated()
		item = compat.equip.old2new[item]
	end
	return self.equipSet:Set(self, slot, index, item)
end
--
-- Method: RemoveEquip
--
-- Remove one or more of a given equipment type from its appropriate cargo slot
--
-- > num_removed = ship:RemoveEquip(item, count)
--
-- Parameters:
--
--   item - a <Constants.EquipType> string for the item
--
--   count - optional. The number of this item to remove. Defaults to 1.
--
-- Return:
--
--   num_removed - the number of items removed
--
-- Example:
--
-- > ship:RemoveEquip("DRIVE_CLASS1")
--
-- Availability:
--
--  alpha 10
--
-- Status:
--
--  experimental
--

Ship.RemoveEquip = function (self, item, count)
	if type(item) == "string" then
		debug.deprecated()
		item = compat.equip.old2new[item]
	end
	return self.equipSet:Remove(self, item, count)
end

compat.slots.new2old = {}
for k,v in pairs(compat.slots.old2new) do
	compat.slots.new2old[v] = k
end

compat.equip.new2old = {
	[cargo.hydrogen]="HYDROGEN", [cargo.air_processors]="AIR_PROCESSORS", [cargo.animal_meat]="ANIMAL_MEAT",
	[cargo.battle_weapons]="BATTLE_WEAPONS", [cargo.carbon_ore]="CARBON_ORE", [cargo.computers]="COMPUTERS",
	[cargo.consumer_goods]="CONSUMER_GOODS", [cargo.farm_machinery]="FARM_MACHINERY", [cargo.fertilizer]="FERTILIZER",
	[cargo.fruit_and_veg]="FRUIT_AND_VEG", [cargo.grain]="GRAIN", [cargo.hand_weapons]="HAND_WEAPONS",
	[cargo.hydrogen]="HYDROGEN", [cargo.industrial_machinery]="INDUSTRIAL_MACHINERY", [cargo.liquid_oxygen]="LIQUID_OXYGEN",
	[cargo.liquor]="LIQUOR", [cargo.live_animals]="LIVE_ANIMALS", [cargo.medicines]="MEDICINES", [cargo.metal_alloys]="METAL_ALLOYS",
	[cargo.metal_ore]="METAL_ORE", [cargo.military_fuel]="MILITARY_FUEL", [cargo.mining_machinery]="MINING_MACHINERY",
	[cargo.narcotics]="NARCOTICS", [cargo.nerve_gas]="NERVE_GAS", [cargo.plastics]="PLASTICS",
	[cargo.precious_metals]="PRECIOUS_METALS", [cargo.radioactives]="RADIOACTIVES", [cargo.robots]="ROBOTS",
	[cargo.rubbish]="RUBBISH", [cargo.slaves]="SLAVES", [cargo.textiles]="TEXTILES", [cargo.water]="WATER",

	[equipment.missile_unguided]="MISSILE_UNGUIDED", [equipment.missile_guided]="MISSILE_GUIDED",
	[equipment.missile_smart]="MISSILE_SMART", [equipment.missile_naval]="MISSILE_NAVAL",
	[equipment.atmospheric_shielding]="ATMOSPHERIC_SHIELDING", [equipment.ecm_basic]="ECM_BASIC",
	[equipment.ecm_advanced]="ECM_ADVANCED", [equipment.scanner]="SCANNER", [equipment.cabin]="CABIN",
	[equipment.shield_generator]="SHIELD_GENERATOR", [equipment.laser_cooling_booster]="LASER_COOLING_BOOSTER",
	[equipment.cargo_life_support]="CARGO_LIFE_SUPPORT", [equipment.autopilot]="AUTOPILOT",
	[equipment.radar_mapper]="RADAR_MAPPER", [equipment.fuel_scoop]="FUEL_SCOOP",
	[equipment.cargo_scoop]="CARGO_SCOOP", [equipment.hypercloud_analyzer]="HYPERCLOUD_ANALYZER",
	[equipment.shield_energy_booster]="SHIELD_ENERGY_BOOSTER", [equipment.hull_autorepair]="HULL_AUTOREPAIR",
	[equipment.hyperdrive_1]="DRIVE_CLASS1", [equipment.hyperdrive_2]="DRIVE_CLASS2", [equipment.hyperdrive_3]="DRIVE_CLASS3",
	[equipment.hyperdrive_4]="DRIVE_CLASS4", [equipment.hyperdrive_5]="DRIVE_CLASS5", [equipment.hyperdrive_6]="DRIVE_CLASS6",
	[equipment.hyperdrive_7]="DRIVE_CLASS7", [equipment.hyperdrive_8]="DRIVE_CLASS8", [equipment.hyperdrive_9]="DRIVE_CLASS9",
	[equipment.hyperdrive_mil1]="DRIVE_MIL1", [equipment.hyperdrive_mil2]="DRIVE_MIL2", [equipment.hyperdrive_mil3]="DRIVE_MIL3",
	[equipment.hyperdrive_mil4]="DRIVE_MIL4", [equipment.pulsecannon_1mw]="PULSECANNON_1MW", [equipment.pulsecannon_dual_1mw]="PULSECANNON_DUAL_1MW",
	[equipment.pulsecannon_2mw]="PULSECANNON_2MW", [equipment.pulsecannon_rapid_2mw]="PULSECANNON_RAPID_2MW",
	[equipment.pulsecannon_4mw]="PULSECANNON_4MW", [equipment.pulsecannon_10mw]="PULSECANNON_10MW",
	[equipment.pulsecannon_20mw]="PULSECANNON_20MW", [equipment.miningcannon_17mw]="MININGCANNON_17MW",
	[equipment.small_plasma_accelerator]="SMALL_PLASMA_ACCEL", [equipment.large_plasma_accelerator]="LARGE_PLASMA_ACCEL"
}
compat.equip.old2new = {}
for k,v in pairs(compat.equip.new2old) do
	compat.equip.old2new[v] = k
end
