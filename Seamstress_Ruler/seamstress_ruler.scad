// https://github.com/openscad/scad-utils
use <scad-utils/lists.scad>

// Ruler sides definition
// Left to right, top to bottom (NOT clockwise or counterclockwise)
// Negative value means there will be cutout of the respective width

//top = [10, -20, 50];
//bottom = [15, -10, 20, -10, 25];
//left = [40];
//right = [5, -28, 7];

top = [30, -9, 15, -9, 7, -9, 5];
bottom = [25, -9, 50];
left = [10, -10, 20];
right = [40];

cutout_depth = 10;
letter_height = 0.4;
ruler_thickness = 2;
font_face = "Ubuntu:style=Medium"; // Thin, Regular, Medium...
font_size = 5;
text_margin = 1;

assert(sumAbs(top) == sumAbs(bottom), "Top ≠ Bottom, (absolute sums should be equal)");
assert(sumAbs(right) == sumAbs(left), "Right ≠ Left (absolute sums should be equal)");

ruler_width = sumAbs(top);
ruler_height = sumAbs(left);


module shape2d() {
    rect = [[0,0], [ruler_width,0], [ruler_width,ruler_height], [0,ruler_height]];

    cutouts = concat(
        list_cutouts(top, is_opposite = false, is_vertical = false),
        list_cutouts(bottom, is_opposite = true, is_vertical = false),
        list_cutouts(left, is_opposite = false, is_vertical = true),
        list_cutouts(right, is_opposite = true, is_vertical = true)
    );
    
    points = [ for (idx = [0 : len(cutouts)]) range([ idx*4 : idx*4+3 ]) ];   
    
    poly = concat(
        rect,
        flatten(cutouts)
    );
    
    polygon(poly, points);
}


function list_cutouts(values, is_opposite = false, is_vertical = false) = 
    let(
        coords = relative_coords(values)
    ) [for (idx = [0 : len(values) - 1]) if (values[idx] < 0) get_rect(    
        // X
        is_vertical ? (is_opposite ? ruler_width - cutout_depth : 0) : coords[idx], 
        // Y
        is_vertical ? ruler_height - coords[idx] : (is_opposite ? cutout_depth : ruler_height),
        abs(values[idx]),
        is_vertical
    )];


module text2d(values, is_opposite = false, is_vertical = false) {
    coords = relative_centers(values);
    rotation = is_vertical ? (is_opposite ? 90 : 270) : (is_opposite ? 0 : 180);
    
    for (idx = [0 : len(values) - 1]) {
        if (values[idx] > 0) {
            tx = is_vertical ? (is_opposite ? ruler_width - text_margin : text_margin) : coords[idx];
            ty = is_vertical ? ruler_height - coords[idx] : (is_opposite ? text_margin : ruler_height - text_margin);
            
            translate([tx, ty, 0])
                rotate([0, 0, rotation])
                    text(
                        text = str(values[idx]),
                        size = font_size,
                        font = str(font_face),
                        $fn = 16,
                        valign = "bottom",
                        halign = "center",
                        spacing = 0.9
                    );
        }
    }
}

function get_rect(aX, aY, val, is_vertical = false) = 
    let(
        bX = aX + (is_vertical ? cutout_depth : val),
        bY = aY - (is_vertical ? val : cutout_depth)
    ) [
        [aX, aY], [aX, bY],
        [bX, bY], [bX, aY]
    ];

// https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Tips_and_Tricks#Cumulative_sum
function relative_coords(vec) = [
    for (
        a = 0, b = vec[0];
        a < len(vec);
        a = a + 1, b = b + ( vec[a] == undef ? 0 : abs(vec[a]) )
    ) b - abs(vec[a]) // relative start of the segment
];

function relative_centers(vec) = let(coords = relative_coords(vec)) [
    for (idx = [0 : len(vec) - 1]) coords[idx] + abs(vec[idx]) / 2 // relative center of the segment
];

// https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Tips_and_Tricks#Add_all_values_in_a_list
function sumAbs(vec, i = 0, r = 0) = i < len(vec) ? sumAbs(vec, i + 1, r + abs(vec[i])) : r;



module labels() {
    text2d(top, is_opposite = false, is_vertical = false);
    text2d(bottom, is_opposite = true, is_vertical = false);
    text2d(left, is_opposite = false, is_vertical = true);
    text2d(right, is_opposite = true, is_vertical = true);
}


difference() {
    translate([0, 0, ruler_thickness/2])
        linear_extrude(height = ruler_thickness, center = true, convexity = 2)
        shape2d();

    color("black")
        translate([0, 0, ruler_thickness - letter_height])
        linear_extrude(height = letter_height)
            labels();

}
