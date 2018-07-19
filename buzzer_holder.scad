/* [STANDOFF MOUNT SETTINGS] */
STANDOFF_DIAMETER = 5.04;
MOUNT_THICKNESS = 2;

/* [BUZZER SETTINGS] */
BUZZER_DIAMETER = 11.80;
BUZZER_HEIGHT = 8;
BUZZER_MOUNT_THICKNESS = 2;

STOPPER_HEIGHT = 0.5; // [0.2:0.1:0.5]
STOPPER_INNSIDE_DIAMETER = 5; // [5.0:0.2:15.0]

/* [ADJUSTEMENTS] */
OVERLAP = 1.2;  // [0:0.1:3]
TOLERANCE = 0.05; // [0:0.05:0.5]

/* [HIDDEN] */
$fn = 128;
buzzer_mount_with_stoppers(STANDOFF_DIAMETER, MOUNT_THICKNESS, OVERLAP, 
            BUZZER_DIAMETER, BUZZER_HEIGHT, BUZZER_MOUNT_THICKNESS, 
            STOPPER_HEIGHT, STOPPER_INNSIDE_DIAMETER, TOLERANCE);            

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
