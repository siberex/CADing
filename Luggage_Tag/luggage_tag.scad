$fa = 1; $fs = 1;
$fn = $preview ? 32 : 64;

use <./fonts/Ubuntu-Medium.ttf>

// icon, text, icon_offset
$lines = [
    ["user-tie", "Stephen Jingle", 0.0625],
    ["telegram", "@sibli", -0.125],
    ["whatsapp", "+1-234-567-8900"],
    ["georgia", "995-000-12-3456"],
    ["instagram", "@sib_li", -0.0625],
    ["earth", "sib.li"],
];
include <./.data.scad>;

base_width = 48;
base_height = 30;
base_thickness = 0.8;
offset_radius = 5;

font_thickness = 0.4;
font_size = 4;
//font_face = "Jetbrains Mono:style=Medium";
//font_spacing = 0.94;
font_face = "Ubuntu:style=Medium";
font_spacing = 1.1;


module base_plate(width, height) {
    rect = [width, height];
    
    union() {
        linear_extrude(base_thickness)    
            offset(r = offset_radius) {
                square(rect, center = true);
            }

        // Rim
        color("green")
        translate([0, 0, base_thickness])
            linear_extrude(font_thickness)
                difference() {
                    offset(r = offset_radius) {
                        square(rect, center = true);
                    };
                    offset(r = offset_radius - 1) {
                        square(rect, center = true);
                    };
                }
    }
};

module textline(line = "", x_pos = 0, y_pos = 0, fit_length = 0) {
    color("gray")
    translate([x_pos, y_pos, base_thickness])
        linear_extrude(height = font_thickness)
            resize([fit_length, 0], auto = true)
                text(
                    line, size=font_size,
                    font = str(font_face),
                    halign="left",
                    valign = "baseline",
                    spacing = font_spacing
                );
}

module texticon(icon = "icons/phone.svg", line = "", x_pos = 0, y_pos = 0, icon_offset_y = 0) {
    w = font_size;
    h = font_size;
    
    color("green")
    translate([x_pos, y_pos + h/2 + icon_offset_y * h, base_thickness])
        linear_extrude(height = font_thickness)
            resize([w, 0], auto = true)
                import(icon, center = true, dpi = 2400);
    
    textline(line, x_pos + 4, y_pos);
}


module punch_hole(x = 0, y = 0) {    
    rect = [4, 0.01];
    translate([x, y, -0.01])
        linear_extrude(base_thickness + font_thickness)
            offset(r = 2 - 0.6) {
                square(rect, center = true);
            }
}

module punch_hole_bevel(x = 0, y = 0) {
    rect = [4, 0.01];
    
    color("green")
    translate([x, y, 0])
        linear_extrude(base_thickness + font_thickness)
            difference() {
                offset(r = 2) {
                    square(rect, center = true);
                };
                offset(r = 2 - 0.6) {
                    square(rect, center = true);
                };
            }
}


function get_icon(v) = str("icons/", v[0], ".svg");
function get_text(v) = str(v[1]);
function get_icon_offset(v) = len(v) > 2 ? v[2] : 0;

module print_lines(lines = $lines, x = 0, y = 0) {
    for (idx = [0 : len(lines) - 1]) {
        
        texticon(
            get_icon(lines[idx]), 
            get_text(lines[idx]),
            x,
            y - idx * (font_size + 1.9),
            get_icon_offset(lines[idx])
        );
    }
}


module model() {
    difference() {
        union() {
            print_lines(x = -base_width / 2 + 0.1, y = base_height / 2 - 2.2);        
            base_plate(base_width, base_height);
            punch_hole_bevel(base_width / 2 - 2, -base_height / 2);
        };
        punch_hole(base_width / 2 - 2, -base_height / 2);
    }
}
model();
