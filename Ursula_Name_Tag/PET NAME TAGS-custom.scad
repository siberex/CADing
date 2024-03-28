$fa=1;
$fs=1;
$fn=64;

pet_name="Mac";
phone_number="0423 555 555";
extra_text=" ";
NAMETAGSIZE = "L";

LengthFactor = 2.9; //3.1, increase this for longer names

//14mm
if (NAMETAGSIZE=="S")
    {
        echo ("SMALL");
        t(pet_name,7.5,1); 
        t(phone_number,4.7,-7);
        roundedcube(LengthFactor*19,19,bone_height,5,3);
        }
else
    //20mm
if (NAMETAGSIZE=="M")
    {
        echo ("MEDIUM");
        t(pet_name,10,1); 
        t(phone_number,6,-10);
        roundedcube(LengthFactor*25,26,bone_height,5,1);
        }
else
    //20mm
if (NAMETAGSIZE=="M3")
    {
        echo ("MEDIUM 3 Lines text");
        t(pet_name,9,4); 
        t(phone_number,5.8,-5);
        t(extra_text,5.8,-12);    
        roundedcube(LengthFactor*25,26,bone_height,5,1);
        }
else
    //25mm
if (NAMETAGSIZE=="L")
    {
        echo ("LARGE");
        t(pet_name,11,1); 
        t(phone_number,5.8,-10);
        roundedcube(LengthFactor*25,28,bone_height,5,5);
        }
else
    //25mm
if (NAMETAGSIZE=="L3")
    {
        echo ("LARGE 3 Lines text");
        t(pet_name,9,4); 
        t(phone_number,5.8,-5);
        t(extra_text,5.8,-13);        roundedcube(LengthFactor*25,28,bone_height,5,5);
        }
else
    //30mm
if (NAMETAGSIZE=="XL")
    {
        echo ("EXTRALARGE");
        t(pet_name,12,1); 
        t(phone_number,7,-12);
        roundedcube(LengthFactor*30,32,bone_height,5,5);
        }
else
    //30mm
if (NAMETAGSIZE=="XL3")
    {
        echo ("EXTRALARGE 3 Lines text");
        t(pet_name,7,6); 
        t(phone_number,7,-3);
        t(extra_text,7,-13);        roundedcube(LengthFactor*30,32,bone_height,5,5);
        }
else
    //35
if (NAMETAGSIZE=="XXL")
    {
        echo ("EXTRALARGE");
        t(pet_name,12,1); 
        t(phone_number,7,-12);
        roundedcube(LengthFactor*30,36,bone_height,5,5);
        }
bone_height = 1.8;//set this to how thick you want the tag
font_face="Liberation Sans:style=Bold";
font_face2="Consolas:style=Bold";
//font_face="Comic Sans MS:style=Bold";
font_thickness=1.4;


module roundedcube(xdim,ydim,zdim,rdim,OSL){

    translate([0,0,bone_height/2])cube([xdim-rdim*3,ydim,bone_height],center=true);
    ydim2=ydim-(10-OSL);
    zdim2=zdim+0.2;
  difference(){
    hull(){
        translate([-xdim/2,ydim2/2,0])cylinder(r=rdim,h=zdim2);
        translate([-xdim/2+rdim,ydim2/2,0])cylinder(r=rdim,h=zdim2);
        translate([-xdim/2,-ydim2/2,0])cylinder(r=rdim,h=zdim2);
        translate([-xdim/2+rdim,-ydim2/2,0])cylinder(r=rdim,h=zdim2);
    }

    hull(){
        translate([-xdim/2+rdim/2,ydim2/2-rdim/2,0])cylinder(r=rdim/1.1,h=zdim2);
        translate([-xdim/2+rdim/2,-ydim2/2+rdim/2,0])cylinder(r=rdim/1.1,h=zdim2);
       }
       
   }
  difference(){
    hull(){
        translate([xdim/2,ydim2/2,0])cylinder(r=rdim,h=zdim2);
        translate([xdim/2-rdim,ydim2/2,0])cylinder(r=rdim,h=zdim2);
        translate([xdim/2,-ydim2/2,0])cylinder(r=rdim,h=zdim2);
        translate([xdim/2-rdim,-ydim2/2,0])cylinder(r=rdim,h=zdim2);
    }
       hull(){
        translate([xdim/2-rdim/2,-ydim2/2+rdim/2,0])cylinder(r=rdim/1.1,h=zdim2);
        translate([xdim/2-rdim/2,ydim2/2-rdim/2,0])cylinder(r=rdim/1.1,h=zdim2);
        }
   }
};


module t(t,s,yp){  
 translate([0,yp,bone_height])
    linear_extrude(height = font_thickness)
        text(t, s, font = str(font_face), $fn = 16, halign="center");
}

//t(pet_name,0.4*collar_size,1); 
//t(phone_number,0.2*collar_size,-0.4*collar_size);
//roundedcube(3.1*collar_size,collar_size,bone_height,5);

