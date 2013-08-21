//////////////////////////////////////////////////
// pH and headspace analysis culture device
// for MacLean lab, environmental genomics
// design by:  Isaac Yonemoto
//
// all measurements in millimeters.

///////////////////////////////////////////////////
// PARAMETERS

//overall parameters
centerdisplacement = 40;
displacement = centerdisplacement / 2;
screwtest = true;  //are we doing a screw testing step?
caponly = false;
bodyonly = true;

//chamber parameters
_chamberheight = 27;
chamberheight = screwtest ? 0 : _chamberheight;
chamberfloors = 5;
chamberwall = 15;
chamberinnerheight = chamberheight - 2 * chamberfloors;

//pH probe tower parameters
pHID = 12.8;
pHIR = pHID / 2;
pHlip = 1.5;
pHOR1 = pHIR + pHlip;
pHscrewlip = 4;
pHOR2 = pHOR1 + pHscrewlip;
pHtowerheight = 24;
pHthreadheight = 20;
pHstopheight = pHtowerheight - pHthreadheight;

//septum tower parameters
spID = 12.8;
spIR = spID / 2;
splip = 3.5;
spOR = spIR + splip;
spbase = 2;
spmid = 10;
sptop = 2;
spheight = spbase + spmid + sptop;


/////////////////////////////////////////////
// CODE

/////////////////////////////////////////////
// MODULES

//standard displacement macros.

module pHtower(){

  //displacement for the pH probe tower.

  for (i = [0 : $children-1])
    translate([displacement, 0, 0]) child(i);
}

module sptower(){

  //displacement for the septum tower

  for (i = [0 : $children-1])
    translate([-displacement, 0, 0]) child(i);
}

module lift(value){
 
  //lifts something by the specified value.
 
  for (i = [0 : $children - 1])
    translate([0, 0, value]) child(i);
}

// screw module

resolution = 30;
module screw(height, turns, innerdiameter, outerdiameter){
  realturns = turns + 1;
  realheight = (height / turns) * realturns;
  deltathread = height / turns / 2;
  tr = resolution * realturns;
  tabs = 0.1;
  difference(){
    union(){
      translate([0,0,-deltathread])
      for(i=[1:tr]) {
        rotate(a=[0,0,(360 * i)/resolution])
        translate([0,0,i * realheight/tr])
          hull(){
            rotate([90,0,0])
              linear_extrude(height=0.01)
                polygon([[innerdiameter,deltathread],[innerdiameter - tabs,deltathread],[innerdiameter - tabs,-deltathread],[innerdiameter,-deltathread],[outerdiameter,0]]);
 
            translate([0,0,realheight/tr])
            rotate([0,0,realturns * 360/tr])
            rotate([90,0,0])
              linear_extrude(height=0.01)
                polygon([[innerdiameter,deltathread],[innerdiameter - tabs,deltathread],[innerdiameter - tabs,-deltathread],[innerdiameter,-deltathread],[outerdiameter,0]]);
        }
      }
    }

    translate([0,0,height-0.01])
      cylinder(h=deltathread * 2 + 1, r=outerdiameter + 0.1);

    translate([0,0, -deltathread * 2 + 1])
      cylinder(h=deltathread , r=outerdiameter + 0.1);
  }
}


/////////////////////////////////////////////
// DEVICE STRUCTURE


//screw(10,4,10,11);

//main device body.
if (!caponly)
difference(){

  //create the entire exterior

  union()
  {
    //the bottom chamber is a hull.

    if (!screwtest){
      hull()
      {
        sptower() {
          cylinder(h=chamberheight, r=spIR + chamberwall);
        }
        pHtower() {
          cylinder(h=chamberheight, r=pHIR + chamberwall);
        }
      }
    }

    //create the towers.  
    //First, the tower for the pH meter.
    pHtower() lift(chamberheight) {
      cylinder(h=pHtowerheight, r=pHOR1);
      cylinder(h=pHstopheight, r=pHOR2);

      //then create the screw
      //translate([0,0,pHstopheight])
      //  screw(pHthreadheight, 5, pHOR1, pHOR1 + 1);
    }

    if (!screwtest)
    //second, the tower for the septum
    translate([-displacement, 0, chamberheight]) {
      cylinder(h=spbase, r=spOR);
      lift(spbase) cylinder(h=spmid, r=spOR - 1);
      lift(spbase + spmid) cylinder(h=sptop, r=spOR);
    }
  }

  //interior removal.
  //move everything up.
  lift(chamberfloors){
    union(){
      
      if (!screwtest)
      //the interior of chamber is a hull, just like the ext.
      hull()
      {
        sptower() {
          cylinder(h=chamberinnerheight, r=spIR);
        }
        pHtower() {
          cylinder(h=chamberinnerheight, r=pHIR);
        }
      }

      //delete the interior of the pH meter tower
      pHtower() {
        cylinder(h=chamberheight + pHtowerheight + 0.01, r=pHIR);
      }

      if (!screwtest)
      //delete the interior of the septum meter tower
      sptower() {
        cylinder(h=chamberheight + spheight + 0.01, r=spIR);
      }
    }
  }
}

//cap part.
topthickness = 3;
heft = 5;
height = pHthreadheight;

translate([0, 50,0])
if (!bodyonly)
difference(){
  translate([-pHOR2, -pHOR2, 0])
  minkowski()
  {
    cube(size = [pHOR2 * 2, pHOR2 * 2, pHthreadheight - 0.01], center=false);
    cylinder(h=topthickness, r = heft);
  }
  
  translate([0,0,-2])
    screw(height, 5, pHOR1 + 0.2, pHOR1 + 1.2);
  translate([0,0,-0.1])
    cylinder(h=height + 0.2, r=pHOR1 + 0.3);  

  translate([0,0,height-0.2])
    cylinder(h=topthickness + 0.4, r=pHIR);
  translate([0,0,height])
    cylinder(h=topthickness, r1 = pHOR1, r2 = pHIR);
}
