$fn = 128;

layer = 0.2;
dx = 0.001;
in = 25.4;

border = 3.2;
pt = 1.6;

w = 120;
h = 80;
z = 28;

inner = [w - border * 2, h - border * 2, z - border * 2];
outer = [w, h, z];
nut = [6, 6, 2];
rx = [inner.x, pt * 2 + nut.y, 4];
rw = 3;


module inside() { translate([border, border, border]) children(); }

module do(cx = 1, cy = 1, cz = 1, sx = 1, sy = 1, sz = 1) {
	for (x = [0 : cx - 1]) {
		for (y = [0 : cy - 1]) {
			for (z = [0 : cz - 1]) {
				translate([x * sx, y * sy, z * sz]) children();
			}
		}
	}
}

module banana() {
	bore()
	intersection() { 
		circle(d = 8.3);
		square(
			size = [8.3, 6.35],
			center = true
		);
	}
}

module bore() { linear_extrude(border + dx * 2) children(); } 
module hole(d) { bore() circle(d = d); }

module box() {
	
	module rail() {
		dz = inner.z;
		rail_entrance = [nut.x + 2, rx.y + dx * 2, rx.z];
		
		union() {
			difference() {
				cube([inner.x, rx.y, dz]);
	
				translate([-dx, (rx.y - rw) / 2, dz - rx.z - pt])
				cube([inner.x, rw, rx.z + pt + dx]);
	
				translate([-dx, pt - dx, dz - rx.z + dx])
				cube([inner.x, rx.y - pt * 2, rx.z - pt]);
		
				translate([
					(inner.x - rail_entrance.x) / 2, 
					-dx,
					dz - rail_entrance.z + dx
				])
				cube(rail_entrance);
			}

			translate([(inner.x - rail_entrance.x) / 2 - 2, 0, dz - 2])
			cube([2, rx.y, 2]);

			translate([(inner.x + rail_entrance.x) / 2, 0, dz - 2])
			cube([2, rx.y, 2]);
		}
	}

 	difference() {
		cube([w, h, z]);
		
		inside() cube([inner.x, inner.y, border + inner.z + dx]);
		
		do(cy = 2, sy = in)
		translate([outer.x - border - dx, outer.y / 2 - in / 2, outer.z / 2])
		rotate([0, 90, 0])
		banana();
		
		do(cy = 2, sy = in)
		translate([-dx, outer.y / 2 - in / 2, outer.z / 2])
		rotate([0, 90, 0])
		hole(4.20);
		
		translate([outer.x / 2.7, outer.y / 2 - 7, -dx]) hole(6.45);
		translate([outer.x / 2.7, outer.y / 2 + 7, -dx]) hole(3.1);
	}
		
	inside() rail();
	inside() translate([inner.x, inner.y, 0]) rotate([0, 0, 180]) rail();
}

module cover() {
	ds = 0.2;

	linear_extrude(border)
	difference() {
		translate([ds, ds])
		square([inner.x - 2 * ds, inner.y - 2 * ds]);

		translate([rx.y / 2, rx.y / 2])
		do(2, 2, sx = inner.x - rx.y, sy = inner.y - rx.y)
		circle(d = 3.1);
		
		cx = [66, 26];
		translate([inner.x / 2 - cx.x / 2, inner.y / 2 - cx.y / 2])
		do(2, 2, sx = cx.x, sy = cx.y)
		circle(d = 2.1);
	}
}

box();

//translate([border, border, z - border])
//cover();
