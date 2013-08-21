//we're going to make a screw
 
//example values:
resolution = 50;
turns = 5;
height = 10;
deltathread = height / turns / 2;
trivial = 0.1;
innerdiameter = 10;
outerdiameter = 11;

for(i=[1:resolution]) {
  rotate(a=[0,0,(turns * 360 * i)/resolution])    //a little bit of turn, depending on the resolution
    translate([0,0,i * height/resolution])        //move up the appropriate amount.
      hull(){                                     
          //each unit is going to be a skew triangular prism.
          //this will be defined by taking two really thin triangle prisms (linearly extruded polygons) and
          //constructing the convex hull between the two.
          //note that linear extrusion operates in the Z direction, so the triangles will have to be rotated first.
          
        //first triangle, this one is simple.
        rotate([90,0,0])
          linear_extrude(height=trivial)
            polygon([[innerdiameter,deltathread],[innerdiameter,-deltathread],[outerdiameter,0]]);
 
        //second triangle.
        translate([0,0,height/resolution])       //lift it by the appropriate amount.
        rotate([0,0,turns * 360/resolution])     //rotate it by a single resolution unit; to match with next segment.
        rotate([90,0,0])
          linear_extrude(height=trivial)
              polygon([[innerdiameter,deltathread],[innerdiameter,-deltathread],[outerdiameter,0]]);
      }
}