$fn=64;

line1 = "";
line2 = "";
line3 = "";
line4 = "";
line5 = "";
line6 = "";


base_width = 60;
base_height = 55;
base_thickness = 0.8;
offset_radius = 5;

font_thickness = 0.4;
font_size = 4;
//font_face = "Jetbrains Mono:style=Medium";
//font_spacing = 0.94;
font_face = "Ubuntu:style=Medium";
font_spacing = 1;


module base_plate(width, height) {
    rect = [width, height];
    
    union() {
        linear_extrude(base_thickness)    
            offset(r = offset_radius) {
                square(rect, center = true);
            }

        color("green")
        translate([0, 0, base_thickness])
            linear_extrude(font_thickness)
                difference() {
                    offset(r = offset_radius) {
                        square(rect, center = true);
                    }
                    offset(r = offset_radius - 1) {
                        square(rect, center = true);
                    }
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

module texticon(icon = "icons/phone.svg", line = "", x_pos = 0, y_pos = 0, fit_length = 0, icon_offset_y = 0) {
    w = font_size;
    h = font_size;
    
    color("green")
    translate([x_pos, y_pos + h/2 + icon_offset_y * h, base_thickness])
        linear_extrude(height = font_thickness)
            resize([w, 0], auto = true)
                import(icon, center = true, dpi = 2400);
    
    textline(line, x_pos + 4, y_pos, fit_length);
}


module model() {
    union() {
        
        texticon("icons/user-tie.svg", "Stephen Jingle", -base_width/2, 25, 0);
        texticon("icons/telegram.svg", "@sibli", -base_width/2, 17, 0, -0.125);
        texticon("icons/whatsapp.svg", "+1-234-567-8900", -base_width/2, 9, 0);
        texticon("icons/georgia.svg", "995-000-12-3456", -base_width/2, 1, 0);
        texticon("icons/instagram.svg", "@sib_li", -base_width/2, -7, 0, -0.125);
        texticon("icons/earth.svg", "sib.li", -base_width/2, -15, 0);
        
        base_plate(base_width, base_height);
    }
    
}
model();
