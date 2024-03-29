$fa = 0.1; $fs = 0.1;
$fn = $preview ? 32 : 128;

use <./fonts/Ubuntu-Medium.ttf>

// icon, text, icon_offset %height
$lines = [
    ["user-tie", "Stephen Jingle", 6.25],
    ["telegram", "@sibli", -12.5],
    ["whatsapp", "+1-234-567-8900"],
    ["georgia", "995-000-12-3456"],
    ["instagram", "@sib_li", -6.25],
    ["earth", "sib.li"],
];
include <./.data.scad>;

is_embossed = false; // false = make debossed
bevel_thickness = 0.4;

base_width = 48;
base_height = 30;
base_thickness = is_embossed ? 0.8 : 0.8 + bevel_thickness;
offset_radius = 5;

font_size = 4;
//font_face = "Jetbrains Mono:style=Medium";
//font_spacing = 0.94;
font_face = "Ubuntu:style=Medium";
font_spacing = 1.1;
punch_rim = 0.6;


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
            linear_extrude(bevel_thickness)
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
        linear_extrude(height = bevel_thickness)
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
        linear_extrude(height = bevel_thickness)
            resize([w, 0], auto = true)
                import(icon, center = true);
    
    textline(line, x_pos + 4, y_pos);
}


module punch_hole(x = 0, y = 0) {    
    rect = [4, 0.01];
    translate([x, y, -0.01])
        linear_extrude(base_thickness + (is_embossed ? bevel_thickness : 0))
            offset(r = 2 - punch_rim) {
                square(rect, center = true);
            }
}

module punch_hole_bevel(x = 0, y = 0) {
    rect = [4, 0.01];
    
    color("green")
    translate([x, y, 0])
        linear_extrude(base_thickness + (is_embossed ? bevel_thickness : 0))
            difference() {
                offset(r = 2) {
                    square(rect, center = true);
                };
                offset(r = 2 - punch_rim) {
                    square(rect, center = true);
                };
            }
}


function get_icon(v) = str("icons/", v[0], ".svg");
function get_text(v) = str(v[1]);
function get_icon_offset(v) = len(v) > 2 ? v[2] / 100 : 0;

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

module card(hide_base = false) {
    text_pad_left = 0.1;
    text_pad_top = -2.2;

    if (is_embossed) {
        union() {
            if (!hide_base) base_plate(base_width, base_height);
            print_lines(x = -base_width / 2 + text_pad_left, y = base_height / 2 + text_pad_top);
        }
    } else {
        difference() {
            if (!hide_base) %base_plate(base_width, base_height);
            translate([0, 0, -bevel_thickness])
                %print_lines(x = -base_width / 2 + text_pad_left, y = base_height / 2 + text_pad_top);
        }
    }

}

module model() {
    difference() {
        union() {
            card(hide_base = false);
            punch_hole_bevel(base_width / 2 - 2, -base_height / 2);
        };
        punch_hole(base_width / 2 - 2, -base_height / 2);
    }
}
model();
