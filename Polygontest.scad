
resolution = 200;
height = 10;
turns = 5;
innerdiameter = 5;
width = 2;
outerdiameter = innerdiameter + width;

for(i=[1:resolution]) {
  rotate(a=[0,0,(turns * 360 * i)/resolution])
  translate([0,0,i * height/resolution])
    hull(){
      rotate([90,0,0])
        linear_extrude(height=0.01)
          polygon([[innerdiameter,1],[innerdiameter,-1],[outerdiameter,0]]);

      translate([0,0,height/resolution])
        rotate([0,0,turns * 360/resolution])
        rotate([90,0,0])
          linear_extrude(height=0.01)
            polygon([[innerdiameter,1],[innerdiameter,-1],[outerdiameter,0]]);
    }
}