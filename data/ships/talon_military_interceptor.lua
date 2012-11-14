-- Copyright © 2008-2012 Pioneer Developers. See AUTHORS.txt for details
-- Licensed under the terms of CC-BY-SA 3.0. See licenses/CC-BY-SA-3.0.txt

define_ship {
	name='Talon Military Interceptor',
	model='fi',
	forward_thrust = 20e5,
	reverse_thrust = 5e5,
	up_thrust = 4e5,
	down_thrust = 3e5,
	left_thrust = 3e5,
	right_thrust = 3e5,
	angular_thrust = 15e5,
	camera_offset = v(0,.5,-8),
	gun_mounts =
	{
		{ v(0,-2,-46), v(0,0,-1), 5, 'HORIZONTAL' },
		{ v(0,0,0), v(0,0,1), 5, 'HORIZONTAL' },
	},
	slots = {
		cargo = 10,
		laser_front = 1,
		laser_rear = 0,
		missile = 6,
		fuel_scoop = 0,
		cargo_scoop = 0
	},
	capacity = 10,
	hull_mass = 8,
	fuel_tank_mass = 2,
	thruster_fuel_use = 0.0001,
	price = 33000,
	hyperdrive_class = 1,
}
