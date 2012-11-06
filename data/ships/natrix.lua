-- Copyright © 2008-2012 Pioneer Developers. See AUTHORS.txt for details
-- Licensed under the terms of CC-BY-SA 3.0. See licenses/CC-BY-SA-3.0.txt

define_ship {
	name='Natrix',
	model='natrix',
	forward_thrust = 6e6,
	reverse_thrust = 1e6,
	up_thrust = 1e6,
	down_thrust = 1e6,
	left_thrust = 1e6,
	right_thrust = 1e6,
	angular_thrust = 15e6,
	camera_offset = v(4,4,-12.5),
	gun_mounts = {
		{ v(0.000, 0.000, -9.342), v(0.000, 0.000, -1.000), 5, 'HORIZONTAL' },
	},
	slots = {
		atmo_shield = 0,
		cargo = 50,
		laser_front = 1,
		laser_rear = 0,
		missile = 0,
		cargo_scoop = 0,
		fuel_scoop = 0
	},
	capacity = 40,
	hull_mass = 15,
	fuel_tank_mass = 15,
	thruster_fuel_use = 0.00015,
	price = 50000,
	hyperdrive_class = 2,
}
