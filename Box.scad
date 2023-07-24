$fn = 64;

layer = 0.25;
tolerance = 0.1;
dx = 0.001;
in = 25.4;
bx = in;
by = 19.05;

border = 4;
w = 7 * in;
h = 4.25 * in;
z = 34;

nut = [6, 6, 2];

dip14 = [4 * in / 10, 7 * in / 10, 3];
chip_size = [18, 35, 2];
pcb_size = [40, 60, 2];
pcb_holes = [14, 20];

module inside() { translate([border, border, border]) children(); }

module do(cx, cy, sx = 1, sy = 1) {
	for (x = [0 : cx - 1]) {
		for (y = [0 : cy - 1]) {
			translate([x * sx, y * sy]) children();
		}
	}
}

module banana() {
	bore()
	intersection() { 
		circle(d = 8.0 + tolerance);
		square(
			size = [8.0 + tolerance, 6.35 + tolerance], 
			center = true
		);
	}
}

module XLR() {
	d = 24.0;
	id = 23.6;
	hd = 19.0;
	
	hole(id);
	translate([-hd / 2, d / 2]) hole(3);
	translate([hd / 2, -d / 2]) hole(3);
}

module bore() { linear_extrude(border + dx * 2) children(); } 
module hole(d) { bore() circle(d = d + tolerance); }

module usb() { 
	linear_extrude(border + dx * 2)
	hull() {
		d = 2.6 + tolerance;
		w = 8.4 + tolerance;
		translate([(d - w) / 2, 0]) circle(d = d);
		translate([(w - d) / 2, 0]) circle(d = d);
	}
}

module box() {
	railWidth = in / 4 + 5;
	railLength = 9 * 2;

	module rail() {
		translate([border, border, -dx]) 
		cube([railWidth, railLength + dx, z]);
		
		translate([border, border + railLength, -dx])
		cube([railWidth, h - railLength * 2 + dx, z - 1]);
		
		translate([border, border + h - railLength, -dx]) 
		cube([railWidth, railLength, z]);

		translate([border + in / 4 - 3 / 2, border, z - dx * 2])
		cube([3, railLength, border + dx * 4]);

		translate([border + in / 4 - 3 / 2, border + h - railLength, z - dx * 2])
		cube([3, railLength, border + dx * 4]);
	}

 	difference() {
		cube([w + border * 2, h + border * 2, z + border * 2]);
		
		inside() translate([0, 0, z]) cube([w, h, border + dx]);
		inside() translate([railWidth + border, 0, 0]) cube([w - (railWidth + border) * 2, h, z + dx]);
		
		rail();
		translate([w + 4 + border, h + border * 2, 0]) rotate([0, 0, 180]) rail();

		inside()
		translate([w / 2, h - dx, z / 2])
		rotate([-90, 90, 0])
		XLR();
	}
}

module cover() {

	module grid(x, y) {
		translate([
			(w - 5 * bx) / 2 + x * bx,
			(h - 3 * bx) / 2 + y * bx
		])
		children();
	}

	translate([border, border, border + z])
	difference() {
		cube([w, h, border]);
		hx = in / 4;
		hy = 9;
		
		translate([hx, hy, -dx])
		cylinder(h = border + 2 * dx, d = 3);
		
		translate([hx, h - hy, -dx])
		cylinder(h = border + 2 * dx, d = 3);
		
		translate([w - hx, hy, -dx])
		cylinder(h = border + 2 * dx, d = 3);
		
		translate([w - hx, h - hy, -dx])
		cylinder(h = border + 2 * dx, d = 3);
	}
}

color("#f5faef")
box();

#color("#f5faaf")
//translate([0, h + z, -z])
cover();

#color("red")
translate([border - 0.75 / 2 * in + in, border, border + z - 0.25])
cube([0.75 * in, h, 0.5]);
