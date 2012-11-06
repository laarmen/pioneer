-- Copyright © 2008-2012 Pioneer Developers. See AUTHORS.txt for details
-- Licensed under the terms of CC-BY-SA 3.0. See licenses/CC-BY-SA-3.0.txt

define_ship {
	name='Interplanetary Shuttle',
	model='ip_shuttle',
	forward_thrust = 15e5,
	reverse_thrust = 8e5,
	up_thrust = 8e5,
	down_thrust = 4e5,
	left_thrust = 4e5,
	right_thrust = 4e5,
	angular_thrust = 28e5,
	camera_offset = v(0,2,-12),
	gun_mounts =
	{
		{ v(0,-0.3,-7.9) , v(0,0,-1), 5, 'HORIZONTAL' },
		{ v(0,-0.3,7.5), v(0,0,1), 5, 'HORIZONTAL' },
	},
	slots = {
		cargo = 12,
		laser_front = 1,
		laser_rear = 0,
		missile = 0,
		fuel_scoop = 0,
		cargo_scoop = 0,
		ecm = 0,
		engine = 0
	},
	hyperdrive_class = 0,
	capacity = 12,
	hull_mass = 11,
	fuel_tank_mass = 1,
	thruster_fuel_use = 0.00005,
	price = 14000,
}
