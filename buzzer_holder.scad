STANDOFF_DISTANCE = 30.5;
STANDOFF_DIAMETER = 5.04;
STANDOFF_HEIGHT = 30;

MOUNT_THICKNESS = 2;
OVERLAP = 1.2;  // [0:0.1:3]
BUZZER_DIAMETER = 11.80;
BUZZER_HEIGHT = 9.27;
BUZZER_MOUNT_THICKNESS = 2;

STOPPER_HEIGHT = 0.5;
STOPPER_INNSIDE_DIAMETER = 10;
TOLERANCE = 0.05; // [0:0.05:0.5]

$fn = 128;
//frame_skeleton(STANDOFF_DISTANCE, STANDOFF_DIAMETER, STANDOFF_HEIGHT);
translate([STANDOFF_DISTANCE/2,STANDOFF_DISTANCE/2,BUZZER_HEIGHT/2])
rotate([0,0,45])

buzzer_mount_with_stoppers(STANDOFF_DIAMETER, MOUNT_THICKNESS, OVERLAP, 
            BUZZER_DIAMETER, BUZZER_HEIGHT, BUZZER_MOUNT_THICKNESS, 
            STOPPER_HEIGHT, STOPPER_INNSIDE_DIAMETER, TOLERANCE);            


module frame_skeleton(standoff_distance, standoff_diameter, standoff_height) {
    base_width = 4;
    full_side_length = standoff_distance + standoff_diameter;
    echo(str("Side length", full_side_length));
    
    translate([0,0,-base_width/2])
    base(full_side_length, base_width, true);
    
    angle_step = 90;
    translate([0,0,standoff_height/2])
    for (n = [0:1:3]){
          rotate([0,0, n*angle_step])
          translate([standoff_distance/2,standoff_distance/2,0])
          standoff(standoff_diameter, standoff_height, true);
     }
     
     translate([0,0, standoff_height + base_width/2])
     base(full_side_length, base_width, true);
}

module base(full_side_length, base_width, center) {    
    color("green")
    cube([full_side_length,full_side_length, base_width], center);
}

module standoff(diameter, height, center) {
    color("yellow")
    cylinder(height,diameter/2, diameter/2, center);
}

module buzzer_mount(standoff_diameter, mount_thickness, overlap, buzzer_diameter, buzzer_height, buzzer_mount_thickness, tolerance) {    
    wall_size = mount_thickness;

    colar = 2;
    colar_height = 1;
    
    inter_center_distance = standoff_diameter/2 + buzzer_diameter/2 + (mount_thickness + buzzer_mount_thickness)/2 - overlap;
    
    difference(){        
        // Hull VS Union
        union(){
            cylinder(buzzer_height,(standoff_diameter+wall_size)/2, (standoff_diameter+wall_size)/2, true);   
            translate([inter_center_distance,0,0])
            cylinder(buzzer_height,(buzzer_diameter+buzzer_mount_thickness)/2, (buzzer_diameter+buzzer_mount_thickness)/2, true);           
        };
        cylinder(buzzer_height*2,standoff_diameter/2+tolerance, standoff_diameter/2+tolerance, true);
        
        translate([inter_center_distance,0,0])
        cylinder(buzzer_height*2,buzzer_diameter/2 + tolerance, buzzer_diameter/2 + tolerance, true);
    }
}

module cross_stopper(buzzer_diameter, height, inner_diameter){
    thickness = height;
    difference(){
        intersection(){
            rotate([0,0,90])
            cube([buzzer_diameter*2,thickness,height],true);            
            cylinder(height*2,buzzer_diameter/2, buzzer_diameter/2, true);        
        }
        cylinder(height*2,inner_diameter/2, inner_diameter/2, true);        
    }
}

module flat_stopper(buzzer_diameter, height, inner_diameter){
            difference(){
                cylinder(height,buzzer_diameter/2, buzzer_diameter/2, true);        
                cylinder(height*2,inner_diameter/2, inner_diameter/2, true);
            };         
}

module buzzer_mount_with_stoppers(standoff_diameter, mount_thickness, overlap, buzzer_diameter, buzzer_height, buzzer_mount_thickness, stopper_height, stopper_inside_diameter, tolerance) {    
    
    inter_center_distance = standoff_diameter/2 + buzzer_diameter/2 + (mount_thickness + buzzer_mount_thickness)/2 - overlap;    
    
    cross_stopper_height = stopper_height/0.75;
    
    union(){
        buzzer_mount(standoff_diameter, mount_thickness, overlap, buzzer_diameter, buzzer_height, buzzer_mount_thickness, tolerance); 
       
        translate([inter_center_distance,0,-buzzer_height/2 + stopper_height/2])                    
        flat_stopper(buzzer_diameter + buzzer_mount_thickness, stopper_height, stopper_inside_diameter);

        translate([inter_center_distance,0,buzzer_height/2 - cross_stopper_height/2])
        cross_stopper(buzzer_diameter + buzzer_mount_thickness, cross_stopper_height, buzzer_diameter-0.3);
        
    }
}
