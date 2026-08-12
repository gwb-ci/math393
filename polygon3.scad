// Double-sided numbered regular n-gon
// For dihedral group activities

n = 3;               // number of vertices
radius = 45;         // center to vertex distance (mm)
thickness = 5;       // polygon thickness (mm)

number_size = 8;     // label size
number_height = 1.0; // raised label height

$fn = 80;

module regular_ngon(n, r) {
    polygon([
        for (i = [0:n-1])
            [r*cos(90 + 360*i/n),
             r*sin(90 + 360*i/n)]
    ]);
}

module labels(zpos, mirrored=false) {

    for (i = [0:n-1]) {

        angle = 90 + 360*i/n;

        // move labels slightly inward from vertices
        tx = (radius - 16)*cos(angle);
        ty = (radius - 16)*sin(angle);

        if (!mirrored) {

            translate([tx, ty, zpos])
                linear_extrude(height=number_height)
                    text(
                        str(i+1),
                        size=number_size,
                        halign="center",
                        valign="center",
                        font="Liberation Sans:style=Bold"
                    );
        }
        else {

            translate([tx, ty, zpos])
                mirror([1,0,0])
                linear_extrude(height=number_height)
                    text(
                        str(i+1),
                        size=number_size,
                        halign="center",
                        valign="center",
                        font="Liberation Sans:style=Bold"
                    );
        }
    }
}

union() {

    // Main polygon body
    linear_extrude(height=thickness)
        regular_ngon(n, radius);

    // Top numbers
    labels(thickness);

    // Bottom numbers
    mirror([0,0,1])
        labels(0, true);
}