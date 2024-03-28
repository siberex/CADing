$fa=1;
$fs=1;
$fn=64;

pet_name="+1 234 567-8900";
phone_number="+9 876 543-2156";
extra_text="";
NAMETAGSIZE = "XS";

LengthFactor = 2.75; // increase this for longer names
EarsHeightCompensation = 6; // could be negative

HoleRoundedDivisor = 1.1;

if (NAMETAGSIZE=="XS")
    {
        echo ("EXTRA SMALL");
        t(pet_name,4.7,1.4); 
        t(phone_number,4.7,-5.6);
        roundedcube(LengthFactor*21,15,bone_height,4,7);
        }

//14mm
if (NAMETAGSIZE=="S")
    {
        echo ("SMALL");
        t(pet_name,4.7,2.5); 
        t(phone_number,4.7,-6.5);
        roundedcube(LengthFactor*21,21,bone_height,4,7);
        }
else
    //20mm
if (NAMETAGSIZE=="M")
    {
        echo ("MEDIUM");
        t(pet_name,6,3); 
        t(phone_number,6,-8);
        roundedcube(LengthFactor*25,26,bone_height,5,1);
        }
else
    //20mm
if (NAMETAGSIZE=="M3")
    {
        echo ("MEDIUM 3 Lines text");
        t(pet_name,5.8,4); 
        t(phone_number,5.8,-5);
        t(extra_text,5.8,-12);    
        roundedcube(LengthFactor*25,26,bone_height,5,1);
        }
else
    //25mm
if (NAMETAGSIZE=="L")
    {
        echo ("LARGE");
        t(pet_name,5.8,1); 
        t(phone_number,5.8,-10);
        roundedcube(LengthFactor*25,28,bone_height,5,5);
        }
else
    //25mm
if (NAMETAGSIZE=="L3")
    {
        echo ("LARGE 3 Lines text");
        t(pet_name,5.8,4); 
        t(phone_number,5.8,-5);
        t(extra_text,5.8,-13);        roundedcube(LengthFactor*25,28,bone_height,5,5);
        }
else
    //30mm
if (NAMETAGSIZE=="XL")
    {
        echo ("EXTRALARGE");
        t(pet_name,7,1); 
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
bone_height = 1.2;//set this to how thick you want the tag
//font_face="Roboto Condensed:style=Bold";
font_face="Fira Sans Condensed:style=SemiBold";
font_face2="Consolas:style=Bold";
font_thickness=0.6;


module roundedcube(xdim,ydim,zdim,rdim,OSL){

    translate([0,0,bone_height/2])cube([xdim-rdim*3,ydim,bone_height],center=true);
    ydim2=ydim - (EarsHeightCompensation - OSL);
    zdim2=zdim+0.2;
    
  difference(){
    hull(){
        translate([-xdim/2,ydim2/2,0])cylinder(r=rdim,h=zdim);
        translate([-xdim/2+rdim,ydim2/2,0])cylinder(r=rdim,h=zdim);
        translate([-xdim/2,-ydim2/2,0])cylinder(r=rdim,h=zdim);
        translate([-xdim/2+rdim,-ydim2/2,0])cylinder(r=rdim,h=zdim);
    }

    hull(){
        translate([-xdim/2+rdim/2,ydim2/2-rdim/2,0])cylinder(r=rdim/HoleRoundedDivisor,h=zdim2);
        translate([-xdim/2+rdim/2,-ydim2/2+rdim/2,0])cylinder(r=rdim/HoleRoundedDivisor,h=zdim2);
       }
       
   }
  difference(){
    hull(){
        translate([xdim/2,ydim2/2,0])cylinder(r=rdim,h=zdim);
        translate([xdim/2-rdim,ydim2/2,0])cylinder(r=rdim,h=zdim);
        translate([xdim/2,-ydim2/2,0])cylinder(r=rdim,h=zdim);
        translate([xdim/2-rdim,-ydim2/2,0])cylinder(r=rdim,h=zdim);
    }
       hull(){
        translate([xdim/2-rdim/2,-ydim2/2+rdim/2,0])cylinder(r=rdim/HoleRoundedDivisor,h=zdim2);
        translate([xdim/2-rdim/2,ydim2/2-rdim/2,0])cylinder(r=rdim/HoleRoundedDivisor,h=zdim2);
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

