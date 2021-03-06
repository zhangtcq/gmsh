
// Parameters shared with onelab need be defined here for consistency:
// EPIDERMIS = 0.12 mm (hairless) or 0.05 mm (hairy)

DefineConstant[EPIDERMIS = {0.05, Name "Parameters/Skin/2Thickness of epidermis [mm]"}];
DefineConstant[DERMIS = {1.5, Name "Parameters/Skin/3Thickness of dermis [mm]"}];
DefineConstant[BEAMRADIUS = {3, Name "Parameters/Laser/2Radius of the beam [mm]"}];

// Gmsh specific parameter
DefineConstant[Nb1 = {9, Name "Gmsh/Elements on spot surface", Closed "1"} ];
DefineConstant[Nb2 = {6, Name "Gmsh/Elements across epidermis"}];
DefineConstant[Nb3 = {6, Name "Gmsh/Elements across dermis"}];
DefineConstant[Nb4 = {4, Name "Gmsh/Elements on free surface"}];
DefineConstant[Ref = {3, Name "Gmsh/Refinement factor (1-5)"}];

mm=1.e-3;
L = 7*mm;
D = BEAMRADIUS *mm;
H1 = DERMIS *mm;
H2 = EPIDERMIS * mm;

lc = H2/10;
lc2 = H1/4;
Point(1) = {0, 0, 0, lc2};
Point(2) = {D, 0, 0, lc2};
Point(3) = {L, 0, 0, lc2};
Point(4) = {0, H1, 0, lc};
Point(5) = {D, H1, 0, lc};
Point(6) = {L, H1, 0, lc2/5};
Point(7) = {0, H1+H2, 0, lc};
Point(8) = {D, H1+H2, 0, lc};
Point(9) = {L, H1+H2, 0, lc2/5};

Line(1) = {1, 2};
Line(2) = {2, 3};
Line(3) = {3, 6};
Line(4) = {6, 9};
Line(5) = {1, 4};
Line(6) = {4, 7};
Line(7) = {4, 5};
Line(8) = {5, 6};
Line(9) = {5, 8};
Line(10) = {7, 8};
Line(11) = {8, 9};
Line(12) = {2, 5};

Line Loop(1) = {1,12,-7,-5};
Plane Surface(1) = {1};
Line Loop(2) = {2,3,-8,-12};
Plane Surface(2) = {2};
Line Loop(3) = {7,9,-10,-6};
Plane Surface(3) = {3};
Line Loop(4) = {8,4,-11,-9};
Plane Surface(4) = {4};

Physical Surface("Dermis") = {1,2};
Physical Surface("Epidermis") = {3,4};
Physical Line("Bottom") = {1,2};
Physical Line("Axis") = {5,6};
Physical Line("Side") = {3,4};
Physical Line("LaserSpot") = {10};
Physical Line("FreeSkin") = {11};


Transfinite Line {1, 7, 10} = Nb1*Ref;
Transfinite Line {4, 6, 9} = Nb2*Ref;
Transfinite Line {3, 5, 12} = Nb3*Ref Using Progression 0.77;//0.9
Transfinite Line {-2, -8, -11} = Nb4*Ref Using Progression 0.8;
Transfinite Surface {1,2,3,4} Right;
