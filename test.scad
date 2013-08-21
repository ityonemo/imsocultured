chamberheight = 20;
chamberwall = 5;
chamberinnerheight = chamberheight - 2 * chamberwall;

difference(){
  union()
  {
    hull()
    {
      translate([-15, 0, 0]) {
        cylinder(h=chamberheight, r=15);
      }
      translate([15, 0, 0]) {
        cylinder(h=chamberheight, r=15);
      }
    }
    
    translate([15, 0, chamberheight]) {
      cylinder(h=40, r=10);
    }

    translate([-15, 0, chamberheight]) {
      cylinder(h=20, r=10);
    }
  }

  translate([0, 0, chamberwall]){
    union(){
      hull()
      {
        translate([-15, 0, 0]) {
          cylinder(h=chamberinnerheight, r=10);
        }
        translate([15, 0, 0]) {
          cylinder(h=chamberinnerheight, r=10);
        }
      }

      translate([-15 ,0 ,0]) {
        cylinder(h=chamberheight + 40, r=8);
      }

      translate([15, 0, 0]) {
        cylinder(h=chamberheight + 40, r=8);
      }
    }
  }
}