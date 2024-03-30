$fa = 1; $fs = 1;
$fn = $preview ? 32 : 64;

use <./fonts/Ubuntu-Medium.ttf>

// line index, icon file, text, icon_offset %height, dx_offset mm
$lines = [
    [0, "user", "Stephen Jingle", 4],
    [1, "telegram", "sibli", -12.5],
    [1, "instagram", "sib_li", -6.25, 28],
    [2, "whatsapp", "+1-234-567-8900"],
    [3, "phone", "+9-000-123-4567"],
    [4, "pointer", "sib.li"],
];
include <./.data.scad>;

is_embossed = false; // false = make debossed
add_rim = true;
hide_base = false;
// Embossed: 2 * step size is recommended
// Debossed: Equal to the first layer sise is recommended
emboss_thickness = is_embossed ? 0.2 : 0.15;
base_thickness = is_embossed ? 0.8 : 0.9 + emboss_thickness;

// Actual width will be 10mm larger (offset rounded corners, +2 * offset_radius)
base_width = 50;
// Actual height will be 10mm larger (+2 * offset_radius)
base_height = 30; // 28.2
offset_radius = 5;
rim_thikness = 1;

font_size = 4.6;
//font_face = "Jetbrains Mono:style=Medium";
//font_spacing = 0.94;
font_face = "Ubuntu:style=Medium";
font_leading = 1.57; // 1.475;
font_spacing = 1;

punch_hole_geometry = [6.2, 1.4];
punch_rim = 0.6;

hole_x = base_width / 2 - 2.9;
hole_y = -base_height / 2 + 0.5;

text_pad_left = 0.3;
text_pad_top = -0.6 * font_size;

total_height = base_thickness + (is_embossed ? emboss_thickness : 0);

export_svg_projection = false;


module base_card(rect = [60, 30]) {
    linear_extrude(base_thickness)    
        offset(r = offset_radius) {
            square(rect, center = true);
        }
}

module rim(rect = [60, 30]) {
    extrude = is_embossed ? emboss_thickness : base_thickness;    
    tz = is_embossed ? -base_thickness : 0;
    
    color("green")
    translate([0, 0, -tz])
        linear_extrude(extrude)
            difference() {
                offset(r = offset_radius) {
                    square(rect, center = true);
                };
                offset(r = offset_radius - rim_thikness) {
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
    extrude = base_thickness + (is_embossed ? emboss_thickness : 0) + 0.01;

    translate([x, y, -0.001])
        linear_extrude(extrude)
            offset(r = 2 - punch_rim) {
                square(punch_hole_geometry, center = true);
            }
}

module punch_hole_bevel(x = 0, y = 0) {
    extrude = is_embossed ? emboss_thickness : base_thickness;
    tz = is_embossed ? base_thickness : 0;

    color("green")
    translate([x, y, tz])
        linear_extrude(extrude)
            difference() {
                offset(r = 2) {
                    square(punch_hole_geometry, center = true);
                };
                offset(r = 2 - punch_rim) {
                    square(punch_hole_geometry, center = true);
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
            y - line_no * (font_size * font_leading),
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

if (is_embossed) {
    model();
} else {
    if (export_svg_projection) {
        // Projection to export SVG
        // Could be extremely slow to render
        projection(cut=true) translate([0, 0, - total_height + emboss_thickness/2])
            model();
    } else {
        // Rotate to print upside down (letters first layer), use only with is_embossed = false
        // Useful when printing on a flat surface table
        translate([0, 0, total_height]) rotate([0, 180, 0])
            model();
    }
}