$fn = 128;

3U = 128.5;
HP = 5.08;

dx = 0.001;

border = 4;
pt = 1.75;
layer = 0.25;

module box(width, height) {
	nut = [6, 6, 2];

	module rail() {
		h = height - border - pt;
		rail = [3, pt * 2 + nut.y, 4];
		rail_entrance = [nut.x + 2, rail.y + dx * 2, rail.z];

		union() {
			difference() {
				cube([width, rail.y, h]);
	
				translate([-dx, (rail.y - rail.x) / 2, h - rail.z - pt])
				cube([width, rail.x, rail.z + pt + dx]);
	
				translate([
					-dx, 
					pt - dx,
					h - rail.z + dx
				])
				cube([width, rail.y - pt * 2, rail.z - pt]);
		
				translate([
					(width - rail_entrance.x) / 2, 
					-dx,
					h - rail_entrance.z + dx
				])
				cube(rail_entrance);
			}

			translate([(width - rail_entrance.x) / 2 - 2, 0, h - 2])
			cube([2, rail.y, 2]);

			translate([(width + rail_entrance.x) / 2, 0, h - 2])
			cube([2, rail.y, 2]);
		}
	}

	module box() {
		difference() {
			cube([width + border * 2, 3U + border * 2, height]);
			
			// main volume
			translate([border, border, border])
			cube([width, 3U, height]);
		}
	}

	color("#ffffff")
	union() {
		box();
		translate([border, border - pt, border]) rail();
		translate([border, border + 3U - nut.y - pt, border]) rail();
	}
}

box(14 * HP, 46);
