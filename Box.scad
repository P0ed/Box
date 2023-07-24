$fn = 128;

3U = 128.5;
HP = 5.08;

dx = 0.001;

border = 4;
pt = 1.75;
layer = 0.25;

module box(bx) {
	nut = [6, 6, 2];

	module rail() {
		dz = bx.z - border - pt;
		rail = [3, pt * 2 + nut.y, 4];
		rail_entrance = [nut.x + 2, rail.y + dx * 2, rail.z];

		union() {
			difference() {
				cube([bx.x, rail.y, dz]);
	
				translate([-dx, (rail.y - rail.x) / 2, dz - rail.z - pt])
				cube([bx.x, rail.x, rail.z + pt + dx]);
	
				translate([
					-dx, 
					pt - dx,
					dz - rail.z + dx
				])
				cube([bx.x, rail.y - pt * 2, rail.z - pt]);
		
				translate([
					(bx.x - rail_entrance.x) / 2, 
					-dx,
					dz - rail_entrance.z + dx
				])
				cube(rail_entrance);
			}

			translate([(bx.x - rail_entrance.x) / 2 - 2, 0, dz - 2])
			cube([2, rail.y, 2]);

			translate([(bx.x + rail_entrance.x) / 2, 0, dz - 2])
			cube([2, rail.y, 2]);
		}
	}

	module box() {
		difference() {
			cube(bx);
			
			translate([border, border, border])
			cube([bx.x - border * 2, bx.y - border * 2, bx.z]);
		}
	}
	
	module cover() {
		translate([border, border + bx.y + 25, 0])
		//translate([0, -(bx.y + 25), bx.z - pt])
		linear_extrude(pt)
		difference() {
			size = [bx.x - border * 2, bx.y - border * 2];
			
			square(size);
			
			translate([3, 3]) circle(d=3.1);
			translate([size.x - 3, 3]) circle(d=3.1);
			translate([3, size.y - 3]) circle(d=3.1);
			translate([size.x - 3, size.y - 3]) circle(d=3.1);
		}
	}

	color("#ffffff")
	union() {
		box();
		translate([0, border - pt, border]) rail();
		translate([0, bx.y - border - pt - nut.y, border]) rail();
	}
	
	color("#ffffff")
	cover();
}

box([96, 64, 32]);
