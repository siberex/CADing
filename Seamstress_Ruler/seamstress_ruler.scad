// https://github.com/openscad/scad-utils
use <scad-utils/lists.scad>

// Ruler sides definition
// Clockwise from the top left corner
// Negative value = cutout with the width of that value
top = [30, -9, 15, -9, 7, -9, 5];
right = [40];
bottom = [50, -9, 25];
left = [20, -10, 10];

indent_depth = 10;
letter_height = 0.4;
ruler_thickness = 2;
font_face = "Ubuntu:style=Medium"; // Thin, Regular, Medium...
font_size = 5;
text_margin = 2;

assert(sumAbs(top) == sumAbs(bottom), "Top ≠ Bottom, (absolute sums should be equal)");
assert(sumAbs(right) == sumAbs(left), "Right ≠ Left (absolute sums should be equal)");

ruler_width = sumAbs(top);
ruler_height = sumAbs(left);


module shape2d() {
    rect = [[0,0], [ruler_width,0], [ruler_width,ruler_height], [0,ruler_height]];
    
    cutouts = concat(
        list_cutouts(top, is_reverse = false, is_vertical = false),
        list_cutouts(right, is_reverse = true, is_vertical = true),
        list_cutouts(bottom, is_reverse = true, is_vertical = false),
        list_cutouts(left, is_reverse = false, is_vertical = true)
    );
    
    polygon(
        points = rect
    );
}

function list_cutouts(v, is_reverse = false, is_vertical = false) = 
    let(
        values = is_reverse ? reverse(v) : v,
        // https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Tips_and_Tricks#Cumulative_sum
        coords = [for (a=0, b=values[0]; a < len(values); a = a+1, b = b+(values[a]==undef?0:abs(values[a]))) b],
        range = is_reverse ? [len(values) - 1 : -1 : 0] : [0 : 1 : len(values) - 1],
        rotation = is_vertical ? (is_reverse ? 90 : 270) : (is_reverse ? 0 : 180)
    ) [for (idx = range) if (values[idx] < 0) [
        idx,
        abs(values[idx]),
        // ...
    ]];


module text2d(v, is_reverse = false, is_vertical = false) {
    values = is_reverse ? reverse(v) : v;
    
    // https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Tips_and_Tricks#Cumulative_sum
    coords = [
        for (a=0, b=values[0]; a < len(values); a = a+1, b = b+(values[a]==undef?0:abs(values[a]))) b
    ];
        
    range = is_reverse ? [len(values) - 1 : -1 : 0] : [0 : 1 : len(values) - 1];
    rotation = is_vertical ? (is_reverse ? 90 : 270) : (is_reverse ? 0 : 180);
    
    for (idx = range) {
        if (values[idx] > 0) {
            coord = coords[idx] - values[idx] / 2;
            tx = is_vertical ? (is_reverse ? ruler_width - text_margin : text_margin) : coord;
            ty = is_vertical ? coord : (is_reverse ? text_margin : ruler_height - text_margin);
            
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

module labels() {
    text2d(top, is_reverse = false, is_vertical = false);
    text2d(right, is_reverse = true, is_vertical = true);
    text2d(bottom, is_reverse = true, is_vertical = false);
    text2d(left, is_reverse = false, is_vertical = true);
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

// https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Tips_and_Tricks#Add_all_values_in_a_list
function sumAbs(vec, i = 0, r = 0) = i < len(vec) ? sumAbs(vec, i + 1, r + abs(vec[i])) : r;

