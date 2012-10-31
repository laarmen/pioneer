EquipType = {}
equipType_meta = { __index = EquipType }

function EquipType.new (specs)
	local obj = {}
	for i,v in pairs(specs) do
		obj[i] = v
	end
	setmetatable(obj, equipType_meta)
	if type(obj.slots) ~= "table" then
		obj.slots = {obj.slots}
	end
	return obj
end

function EquipType:GetDefaultSlot(ship)
	return self.slots[1]
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

function EquipType:Install(ship, num, slot)
	return __ApplyModifiers(ship, self.modifiers, num, 1)
end

function EquipType:Uninstall(ship, num, slot)
	return __ApplyModifiers(ship, self.modifiers, num, -1)
end

cargo = {}
cargo.hydrogen = EquipType.new({
	name="Hydrogen", description="Hydrogen",
	slots="cargo", price=100, modifiers={mass=1},
	economy_type="mining"
})
cargo.liquid_oxygen = EquipType.new({
	name="Liquid Oxygen", description="Liquid Oxygen",
	slots="cargo", price=150, modifiers={mass=1},
	economy_type="mining"
})
cargo.water = EquipType.new({
	name="Water", description="",
	slots="cargo", price=120, modifiers={mass=1},
	economy_type="mining"
})
cargo.carbon_ore = EquipType.new({
	name="Carbon Ore", description="",
	slots="cargo", price=500, modifiers={mass=1},
	economy_type="mining"
})
cargo.metal_ore = EquipType.new({
	name="Metal Ore", description="",
	slots="cargo", price=300, modifiers={mass=1},
	economy_type="mining"
})
cargo.metal_alloys = EquipType.new({
	name="Metal Alloys", description="",
	slots="cargo", price=800, modifiers={mass=1},
	economy_type="industry"
})
cargo.precious_metals = EquipType.new({
	name="Precious Metals", description="",
	slots="cargo", price=18000, modifiers={mass=1},
	economy_type="industry"
})
cargo.plastics = EquipType.new({
	name="Plastics", description="",
	slots="cargo", price=1200, modifiers={mass=1},
	economy_type="industry"
})
cargo.fruit_and_veg = EquipType.new({
	name="Fruits and Vegetables", description="",
	slots="cargo", price=1200, modifiers={mass=1},
	economy_type="agriculture"
})
cargo.animal_meat = EquipType.new({
	name="Animal Meat", description="",
	slots="cargo", price=1800, modifiers={mass=1},
	economy_type="agriculture"
})
cargo.live_animals = EquipType.new({
	name="Live Animals", description="",
	slots="cargo", price=3200, modifiers={mass=1},
	economy_type="agriculture"
})
cargo.liquor = EquipType.new({
	name="Liquor", description="",
	slots="cargo", price=800, modifiers={mass=1},
	economy_type="agriculture"
})
cargo.grain = EquipType.new({
	name="Grain", description="",
	slots="cargo", price=1000, modifiers={mass=1},
	economy_type="agriculture"
})
cargo.slaves = EquipType.new({
	name="Slaves", description="",
	slots="cargo", price=23200, modifiers={mass=1},
	economy_type="agriculture"
})
cargo.textiles = EquipType.new({
	name="Textiles", description="",
	slots="cargo", price=850, modifiers={mass=1},
	economy_type="industry"
})
cargo.fertilizer = EquipType.new({
	name="Fertilizer", description="",
	slots="cargo", price=400, modifiers={mass=1},
	economy_type="industry"
})
cargo.medicines = EquipType.new({
	name="Medicines", description="",
	slots="cargo", price=2200, modifiers={mass=1},
	economy_type="industry"
})
cargo.consumer_goods = EquipType.new({
	name="Consumer Goods", description="",
	slots="cargo", price=14000, modifiers={mass=1},
	economy_type="industry"
})
cargo.computers = EquipType.new({
	name="Computers", description="",
	slots="cargo", price=8000, modifiers={mass=1},
	economy_type="industry"
})
cargo.rubbish = EquipType.new({
	name="Rubbish", description='',
	slots="cargo", price=-10, modifiers={mass=1},
	economy_type="industry"
})
cargo.radioactives = EquipType.new({
	name="Radioactive waste", description='',
	slots="cargo", price=-35, modifiers={mass=1},
	economy_type="industry"
})
cargo.narcotics = EquipType.new({
	name="Narcotics", description='',
	slots="cargo", price=15700, modifiers={mass=1},
	economy_type="industry"
})
cargo.nerve_gas = EquipType.new({
	name="Nerve gas", description='',
	slots="cargo", price=26500, modifiers={mass=1},
	economy_type="industry"
})
cargo.military_fuel = EquipType.new({
	name="Military Fuel", description='',
	slots="cargo", price=6000, modifiers={mass=1},
	economy_type="industry"
})
cargo.robots = EquipType.new({
	name="Robots", description='',
	slots="cargo", price=6300, modifiers={mass=1},
	economy_type="industry"
})
cargo.hand_weapons = EquipType.new({
	name="Hand weapons", description='',
	slots="cargo", price=12400, modifiers={mass=1},
	economy_type="industry"
})
cargo.air_processors = EquipType.new({
	name="Air Processors", description='',
	slots="cargo", price=2000, modifiers={mass=1},
	economy_type="industry"
})
cargo.farm_machinery = EquipType.new({
	name="Farm machinery", description="",
	slots="cargo", price=1100, modifiers={mass=1},
	economy_type="industry"
})
cargo.mining_machinery = EquipType.new({
	name="Mining machinery", description="",
	slots="cargo", price=1200, modifiers={mass=1},
	economy_type="industry"
})
cargo.battle_weapons = EquipType.new({
	name="Battle weapons", description="",
	slots="cargo", price=22000, modifiers={mass=1},
	economy_type="industry"
})
cargo.industrial_machinery = EquipType.new({
	name="Industrial machinery", description="Industrial machinery",
	slots="cargo", price=1300, modifiers={mass=1},
	economy_type="industry"
})
cargo.liquid_oxygen.requirements = { cargo.water, cargo.industrial_machinery }
cargo.battle_weapons.requirements = { cargo.metal_alloys, cargo.industrial_machinery }
cargo.farm_machinery.requirements = { cargo.metal_alloys, cargo.robots }
cargo.mining_machinery.requirements = { cargo.metal_alloys, cargo.robots }
cargo.industrial_machinery.requirements = { cargo.metal_alloys, cargo.robots }
cargo.air_processors.requirements = { cargo.plastics, cargo.industrial_machinery }
cargo.robots.requirements = { cargo.plastics, cargo.computers }
cargo.hand_weapons.requirements = { cargo.computers }
cargo.computers.requirements = { cargo.precious_metals, cargo.industrial_machinery }
cargo.metal_ore.requirements = { cargo.mining_machinery }
cargo.carbon_ore.requirements = { cargo.mining_machinery }
cargo.metal_alloys.requirements = { cargo.mining_machinery }
cargo.precious_metals.requirements = { cargo.mining_machinery }
cargo.water.requirements = { cargo.mining_machinery }
cargo.plastics.requirements = { cargo.carbon_ore, cargo.industrial_machinery }
cargo.fruit_and_veg.requirements = { cargo.farm_machinery, cargo.fertilizer }
cargo.animal_meat.requirements = { cargo.farm_machinery, cargo.fertilizer }
cargo.live_animals.requirements = { cargo.farm_machinery, cargo.fertilizer }
cargo.liquor.requirements = { cargo.farm_machinery, cargo.fertilizer }
cargo.grain.requirements = { cargo.farm_machinery, cargo.fertilizer }
cargo.textiles.requirements = { cargo.plastics }
cargo.military_fuel.requirements = { cargo.hydrogen }
cargo.fertilizer.requirements = { cargo.carbon_ore }
cargo.medicines.requirements = { cargo.computers, cargo.carbon_ore }
cargo.consumer_goods.requirements = { cargo.plastics, cargo.textiles }

equipment = {}
equipment.missile_unguided = EquipType.new({
	name="Unguided missile", description="",
	slots="missile", price=3000, modifiers={mass=1, missile=1}
})
equipment.missile_guided = EquipType.new({
	name="Guided missile", description="",
	slots="missile", price=5000, modifiers={mass=1}
})
equipment.missile_smart = EquipType.new({
	name="Smart missile", description="",
	slots="missile", price=9500, modifiers={mass=1}
})
equipment.missile_naval = EquipType.new({
	name="Naval missile", description="",
	slots="missile", price=16000, modifiers={mass=1}
})
equipment.atmospheric_shielding = EquipType.new({
	name="Atmospheric shielding", description="",
	slots="atmo_shield", price=20000, modifiers={mass=1}
})
equipment.ecm_basic = EquipType.new({
	name="Basic ECM", description="",
	slots="ecm", price=600000, modifiers={mass=2, ecm_power=2}
})
equipment.ecm_advanced = EquipType.new({
	name="Advanced ECM", description="",
	slots="ecm", price=1520000, modifiers={mass=2, ecm_power=3}
})
equipment.scanner = EquipType.new({
	name="Scanner", description="",
	slots="scanner", price=68000, modifiers={mass=1, scanner=1}
})
equipment.cabin = EquipType.new({
	name="Cabin", description="",
	slots="cabin", price=135000, modifiers={mass=1, cabin=1}
})
equipment.shield_generator = EquipType.new({
	name="Shield generator", description="",
	slots="shield", price=250000, modifiers={mass=4, shield=1}
})
equipment.laser_cooling_booster = EquipType.new({
	name="Laser cooling booster", description="",
	slots="laser_cooler", price=38000, modifiers={mass=1, laser_cooler=2}
})
equipment.cargo_life_support = EquipType.new({
	name="Cargo life support", description="",
	slots="cargo_life_support", price=70000, modifiers={mass=1, cargo_life_support=1}
})
equipment.autopilot = EquipType.new({
	name="Autopilot", description="",
	slots="autopilot", price=140000, modifiers={mass=1, set_speed=1, autopilot=1}
})
equipment.radar_mapper = EquipType.new({
	name="Radar mapper", description="",
	slots="radar", price=90000, modifiers={mass=1, radar_mapper=1}
})
equipment.fuel_scoop = EquipType.new({
	name="Fuel scoop", description="",
	slots="fuel_scoop", price=350000, modifiers={mass=6, fuel_scoop=1}
})
equipment.cargo_scoop = EquipType.new({
	name="Cargo scoop", description="",
	slots="cargo_scoop", price=390000, modifiers={mass=7, cargo_scoop=1}
})
equipment.hypercloud_analyzer = EquipType.new({
	name="Hypercloud analyzer", description="",
	slots="hypercloud", price=150000, modifiers={mass=1, hypercloud_analyzer=1}
})
equipment.shield_energy_booster = EquipType.new({
	name="Shield energy booster", description="",
	slots="energy_booster", price=1000000, modifiers={mass=8, shield_energy_booster=1}
})
equipment.hull_autorepair = EquipType.new({
	name="Hull autorepair", description="",
	slots="hull_autorepair", price=1600000, modifiers={mass=40, hull_autorepair=1}
})

equipment.hyperdrive_1 = EquipType.new({
	name="Hyperdrive class 1", description="", fuel=cargo.hydrogen,
	slots="engine", price=70000, modifiers={mass=4, hyperclass=1},
})
equipment.hyperdrive_2 = EquipType.new({
	name="Hyperdrive class 2", description="", fuel=cargo.hydrogen,
	slots="engine", price=130000, modifiers={mass=10, hyperclass=2}
})
equipment.hyperdrive_3 = EquipType.new({
	name="Hyperdrive class 3", description="", fuel=cargo.hydrogen,
	slots="engine", price=250000, modifiers={mass=20, hyperclass=3}
})
equipment.hyperdrive_4 = EquipType.new({
	name="Hyperdrive class 4", description="", fuel=cargo.hydrogen,
	slots="engine", price=500000, modifiers={mass=40, hyperclass=4}
})
equipment.hyperdrive_5 = EquipType.new({
	name="Hyperdrive class 5", description="", fuel=cargo.hydrogen,
	slots="engine", price=1000000, modifiers={mass=120, hyperclass=5}
})
equipment.hyperdrive_6 = EquipType.new({
	name="Hyperdrive class 6", description="", fuel=cargo.hydrogen,
	slots="engine", price=2000000, modifiers={mass=225, hyperclass=6}
})
equipment.hyperdrive_7 = EquipType.new({
	name="Hyperdrive class 7", description="", fuel=cargo.hydrogen,
	slots="engine", price=3000000, modifiers={mass=400, hyperclass=7}
})
equipment.hyperdrive_8 = EquipType.new({
	name="Hyperdrive class 8", description="", fuel=cargo.hydrogen,
	slots="engine", price=6000000, modifiers={mass=580, hyperclass=8}
})
equipment.hyperdrive_9 = EquipType.new({
	name="Hyperdrive class 9", description="", fuel=cargo.hydrogen,
	slots="engine", price=12000000, modifiers={mass=740, hyperclass=9}
})
equipment.hyperdrive_mil1 = EquipType.new({
	name="Hyperdrive military class 1", description="", fuel=cargo.military_fuel,
	slots="engine", price=2300000, modifiers={mass=3, hyperclass=1}
})
equipment.hyperdrive_mil2 = EquipType.new({
	name="Hyperdrive military class 2", description="", fuel=cargo.military_fuel,
	slots="engine", price=4700000, modifiers={mass=8, hyperclass=2}
})
equipment.hyperdrive_mil3 = EquipType.new({
	name="Hyperdrive military class 3", description="", fuel=cargo.military_fuel,
	slots="engine", price=8500000, modifiers={mass=16, hyperclass=3}
})
equipment.hyperdrive_mil4 = EquipType.new({
	name="Hyperdrive military class 4", description="", fuel=cargo.military_fuel,
	slots="engine", price=21400000, modifiers={mass=30, hyperclass=4}
})

equipment.pulsecannon_1mw = EquipType.new({
	name="Pulse cannon (1MW)", description="",
	price=60000, modifiers={mass=1},
    slots = {"laser_front", "laser_rear"},
	laser_stats = {
		lifespan=8, speed=1000, damage=1000, rechargeTime=0.25, length=30,
		width=5, dual=false, mining=false, color={1, 0.2, 0.2, 1}
	}
})
equipment.pulsecannon_dual_1mw = EquipType.new({
	name="Dual pulse cannon (1MW)", description="",
	price=110000, modifiers={mass=4},
    slots = {"laser_front", "laser_rear"},
	laser_stats = {
		lifespan=8, speed=1000, damage=1000, rechargeTime=0.25, length=30,
		width=5, dual=true, mining=false, color={1, 0.2, 0.2, 1}
	}
})
equipment.pulsecannon_2mw = EquipType.new({
	name="Pulse cannon (2MW)", description="",
	price=100000, modifiers={mass=3},
    slots = {"laser_front", "laser_rear"},
	laser_stats = {
		lifespan=8, speed=1000, damage=2000, rechargeTime=0.25, length=30,
		width=5, dual=false, mining=false, color={1, 0.5, 0.2, 1}
	}
})
equipment.pulsecannon_rapid_2mw = EquipType.new({
	name="Rapid pulse cannon (2MW)", description="",
	price=180000, modifiers={mass=7},
    slots = {"laser_front", "laser_rear"},
	laser_stats = {
		lifespan=8, speed=1000, damage=2000, rechargeTime=0.13, length=30,
		width=5, dual=false, mining=false, color={1, 0.5, 0.2, 1}
	}
})
equipment.pulsecannon_4mw = EquipType.new({
	name="Pulse cannon (4MW)", description="",
	price=220000, modifiers={mass=10},
    slots = {"laser_front", "laser_rear"},
	laser_stats = {
		lifespan=8, speed=1000, damage=4000, rechargeTime=0.25, length=30,
		width=5, dual=false, mining=false, color={1, 1, 0.2, 1}
	}
})
equipment.pulsecannon_10mw = EquipType.new({
	name="Pulse cannon (10MW)", description="",
	price=490000, modifiers={mass=30},
    slots = {"laser_front", "laser_rear"},
	laser_stats = {
		lifespan=8, speed=1000, damage=10000, rechargeTime=0.25, length=30,
		width=5, dual=false, mining=false, color={0.2, 1, 0.2, 1}
	}
})
equipment.pulsecannon_20mw = EquipType.new({
	name="Pulse cannon (20MW)", description="",
	price=1200000, modifiers={mass=65},
    slots = {"laser_front", "laser_rear"},
	laser_stats = {
		lifespan=8, speed=1000, damage=20000, rechargeTime=0.25, length=30,
		width=5, dual=false, mining=false, color={0.1, 0.2, 1, 1}
	}
})
equipment.miningcannon_17mw = EquipType.new({
	name="Pulse cannon (20MW)", description="",
	price=1060000, modifiers={mass=10},
    slots = {"laser_front", "laser_rear"},
	laser_stats = {
		lifespan=8, speed=1000, damage=17000, rechargeTime=2, length=30,
		width=5, dual=false, mining=true, color={0.2, 0.5, 0, 1}
	}
})
equipment.small_plasma_accelerator = EquipType.new({
	name="Small plasma accelerator", description="",
	price=12000000, modifiers={mass=22},
    slots = {"laser_front", "laser_rear"},
	laser_stats = {
		lifespan=8, speed=1000, damage=50000, rechargeTime=0.3, length=42,
		width=7, dual=false, mining=false, color={0.2, 1, 1, 1}
	}
})
equipment.large_plasma_accelerator = EquipType.new({
	name="Large plasma accelerator", description="",
	price=39000000, modifiers={mass=50},
    slots = {"laser_front", "laser_rear"},
	laser_stats = {
		lifespan=8, speed=1000, damage=100000, rechargeTime=0.3, length=42,
		width=7, dual=false, mining=false, color={0.5, 1, 1, 1}
	}
})

