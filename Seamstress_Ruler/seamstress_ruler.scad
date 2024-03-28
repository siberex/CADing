// https://github.com/openscad/scad-utils
use <scad-utils/lists.scad>

// Ruler sides definition
// Left to right, top to bottom (NOT clockwise or counterclockwise)
// Negative value means there will be cutout of the respective width
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
    rect_coord_idx = range([0 : len(rect) - 1]);
    

    cutouts_top = list_cutouts(top, is_opposite = false, is_vertical = false);
    cutouts_right = list_cutouts(right, is_opposite = true, is_vertical = true);
    cutouts_bottom = list_cutouts(bottom, is_opposite = true, is_vertical = false);
    cutouts_left = list_cutouts(left, is_opposite = false, is_vertical = true);
    
    cutouts = concat(cutouts_top, cutouts_bottom);
    
    //cutouts = cutouts_left;
    
    points = [ for (idx = [0 : len(cutouts)]) range([ idx*4 : idx*4+3 ]) ];   
    
    poly = concat(
        rect,
        flatten(cutouts)
    );
    
    polygon(
        poly,
        points
    );
}


function list_cutouts(values, is_opposite = false, is_vertical = false) = 
    let(
        coords = relative_coords(values)
    ) [for (idx = [0 : len(values) - 1]) if (values[idx] < 0) get_rect(
        
        coords[idx], // X1
        is_opposite ? cutout_depth : ruler_height, // Y1
        abs(values[idx]),
        is_opposite,
        is_vertical
    
    
    
        //[coords[idx], // X2
        //ruler_height - cutout_depth], // Y2
        //[coords[idx] + abs(values[idx]), // X3
        //ruler_height - cutout_depth], // Y3
        //[coords[idx] + abs(values[idx]), // X4
        //ruler_height], // Y4
    
    )];


module text2d(values, is_opposite = false, is_vertical = false) {
    coords = relative_centers(values);
    echo (coords, is_opposite, is_vertical);
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

function get_rect(x1, y1, val, is_opposite = false, is_vertical = false) = 
    let(
        aX = x1,
        aY = y1,
        bX = aX + (is_vertical ? cutout_depth : val),
        bY = aY - (is_vertical ? val : cutout_depth)
    ) [
        [aX, aY],
        [aX, bY],
        [bX, bY],
        [bX, aY]
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




module labels() {
    text2d(top, is_opposite = false, is_vertical = false);
    text2d(right, is_opposite = true, is_vertical = true);
    text2d(bottom, is_opposite = true, is_vertical = false);
    text2d(left, is_opposite = false, is_vertical = true);
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

