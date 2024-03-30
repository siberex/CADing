$fa = 0.1; $fs = 0.1;
$fn = $preview ? 32 : 32;

use <./fonts/Ubuntu-Medium.ttf>

// line index, icon file, text, icon_offset %height, dx_offset mm
$lines = [
    [0, "user-tie", "Stephen Jingle", 4],
    [1, "telegram", "@sibli", -12.5],
    [1, "instagram", "@sib_li", -6.25, 27],
    [2, "whatsapp", "+1-234-567-8900"],
    [3, "phone", "+9-000-12-3456"],
    [4, "pointer", "sib.li"],
];
include <./.data.scad>;

is_embossed = true; // false = make debossed
add_rim = true;
hide_base = false;
emboss_thickness = 0.2; // 2 * nossle size is recommended

base_width = 50;
base_height = 28;
base_thickness = is_embossed ? 0.8 : 0.6 + emboss_thickness;
offset_radius = 5;

font_size = 4.6;
//font_face = "Jetbrains Mono:style=Medium";
//font_spacing = 0.94;
font_face = "Ubuntu:style=Medium";
font_spacing = 1;
punch_rim = 0.6;

hole_x = base_width / 2 - 2;
hole_y = -base_height / 2;

text_pad_left = 0;
text_pad_top = -0.55 * font_size;

total_height = base_thickness + (is_embossed ? emboss_thickness : 0);


module base_card(rect = [60, 30]) {
    linear_extrude(base_thickness)    
        offset(r = offset_radius) {
            square(rect, center = true);
        }
}

module rim(rect = [60, 30]) {
    color("green")
    translate([0, 0, base_thickness - (is_embossed ? 0 : emboss_thickness)])
        linear_extrude(emboss_thickness)
            difference() {
                offset(r = offset_radius) {
                    square(rect, center = true);
                };
                offset(r = offset_radius - 1) {
                    square(rect, center = true);
                };
            }
}

module base_plate(width, height) {
    rect = [width, height];

    if (is_embossed) {
        union() {
            if (!hide_base) base_card(rect);
            punch_hole_bevel(hole_x, hole_y);
            if (add_rim) rim(rect);
        }
    } else {
        difference() {
            if (!hide_base) base_card(rect); // else %base_card(rect);
            union() {
                if (add_rim) rim(rect);
                punch_hole_bevel(hole_x, hole_y);
            }
        }
    }
};

module textline(line = "", x_pos = 0, y_pos = 0, fit_length = 0) {
    color("gray")
    translate([x_pos, y_pos, base_thickness])
        linear_extrude(height = emboss_thickness)
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
        linear_extrude(height = emboss_thickness)
            resize([w, 0], auto = true)
                import(icon, center = true);
    
    textline(line, x_pos + font_size * 0.7, y_pos);
}


module punch_hole(x = 0, y = 0) {
    rect = [4, 0.001];
    translate([x, y, -0.001])
        linear_extrude(base_thickness + (is_embossed ? emboss_thickness : 0) + 0.01)
            offset(r = 2 - punch_rim) {
                square(rect, center = true);
            }
}

module punch_hole_bevel(x = 0, y = 0) {
    rect = [4, 0.001];
    
    color("green")
    translate([x, y, base_thickness - (!is_embossed ? emboss_thickness : 0)])
        linear_extrude(emboss_thickness)
            difference() {
                offset(r = 2) {
                    square(rect, center = true);
                };
                offset(r = 2 - punch_rim) {
                    square(rect, center = true);
                };
            }
}

function get_line_no(v) = v[0];
function get_icon(v) = str("icons/", v[1], ".svg");
function get_text(v) = str(v[2]);
function get_icon_offset(v) = len(v) > 3 ? v[3] / 100 : 0;
function get_dx_offset(v) = len(v) > 4 ? v[4] : 0;

module print_lines(x = 0, y = 0, lines = $lines) {
    for (idx = [0 : len(lines) - 1]) {
        line_no = get_line_no(lines[idx]);
        
        texticon(
            get_icon(lines[idx]), 
            get_text(lines[idx]),
            x + get_dx_offset(lines[idx]),
            y - line_no * (font_size * 1.475),
            get_icon_offset(lines[idx])
        );
    }
}

module badge() {
    lines_x = -base_width / 2 + text_pad_left;
    lines_y = base_height / 2 + text_pad_top;

    if (is_embossed) {
        union() {
            base_plate(base_width, base_height);
            print_lines(lines_x, lines_y);
        }
    } else {
        if (hide_base) {
            union() {
                base_plate(base_width, base_height);
                translate([0, 0, -emboss_thickness + 0.001])
                    print_lines(lines_x, lines_y);
            }
        } else {
            difference() {
                base_plate(base_width, base_height);
                translate([0, 0, -emboss_thickness + 0.001])
                    print_lines(lines_x, lines_y);
            }
        }
    }

}

module model() {
    difference() {
        badge();
        punch_hole(hole_x, hole_y);
    }
}

//translate([0, 0, total_height])
//rotate([0, 180, 0])
model();
