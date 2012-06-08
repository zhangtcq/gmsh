% comment lines start with "%" in any .ol file

% "radioButton" represent a boolean parameter or a flag
LOGFILES.radioButton(0,MetaModel/,''Output goes in .log files'');

% Flags to descibe model features that are activated or not
TENEUR.radioButton(0,Parameters/Model/1,"Account for water content"); 
CONVBC.radioButton(0,Parameters/Model/2,"Account for convection");
BIOHEAT.radioButton(0,Parameters/Model/3,"Account for volume heat sources");

% Enumeration, i.e. a set of real values each associated with a label
SKINTYPE.number(1, Parameters/Model/4, ''Skin type''); 
SKINTYPE.addChoices(1,2);
SKINTYPE.addLabels(hairy, hairless);

% SKINWIDTH is determined by SKINTYPE
% Such dependency can be implemented with setValue
% The "setValue" statement overrules the value on the server. 
SKINWIDTH.number(0,Parameters/Model/5,''Skin width [mm]'');
OL.if( OL.get(SKINTYPE) == 1)
SKINWIDTH.setValue(0.05);
OL.endif
OL.if( OL.get(SKINTYPE) == 2)
SKINWIDTH.setValue(0.12);
OL.endif

% onelab numbers
DERMIS.number(1.5,Parameters/Model/6,''Dermis width [mm]'');
BEAMRADIUS.number(5, Parameters/Model/, ''Beam radius [mm]'');
WCONTENT.number(0.65,Parameters/Model/,''Water content []'');
BODYTEMP.number(310, Parameters/Model/,''Body temperature [K]'');
OVERTEMP.number(320, Parameters/Model/,''Maximum skin temperature [K]'');

% z coordinates for post-processing curves
% depending variables are defined with no value
ZSURF0.number( , PostPro/);
ZSURF1.number( , PostPro/);
ZSURF2.number( , PostPro/);
ZSURF3.number( , PostPro/);
ZSURF4.number( , PostPro/);
% and this definition must then be completed by a "setValue" statement
ZSURF0.setValue(OL.eval((OL.get(DERMIS)+OL.get(SKINWIDTH)-0.001)/1000)); 
ZSURF1.setValue(OL.eval((OL.get(DERMIS)+OL.get(SKINWIDTH)-0.05001)/1000));
ZSURF2.setValue(OL.eval((OL.get(DERMIS)+OL.get(SKINWIDTH)-0.100)/1000));
ZSURF3.setValue(OL.eval((OL.get(DERMIS)+OL.get(SKINWIDTH)-0.150)/1000));
ZSURF4.setValue(OL.eval((OL.get(DERMIS)+OL.get(SKINWIDTH)-0.200)/1000));

% "OL.get" return the value on server of a parameter of type onelab::number or onelab::string
% "OL.eval" allows evaluating analytical expressions involving onelab::numbers


% Available LASER models, another enumeration
LASERTYPE.number(1, Parameters/Laser/1,''Laser type'');  
LASERTYPE.addChoices(1,2,3); 
LASERTYPE.addLabels(Applied temperature, Surface flux, Volume Flux);

APPLICTIME.number(0.05, Parameters/Laser/, ''Application time [s]'');
LASERTEMP.number(360, Parameters/Laser/, ''Laser temperature [K]'');
LASERPOWER.number(15, Parameters/Laser/, ''Injected power [W]'');
ABSORPTION.number(2e4, Parameters/Laser/, ''Absorption coefficient [1/m]'');

% Visibility of the parameters in the onelab interactive window
% are controled with conditional statements
% so that only the relevant parameters appear.
OL.if( OL.get(LASERTYPE) == 1)
LASERTEMP.setVisible(1);
LASERPOWER.setVisible(0);
ABSORPTION.setVisible(0);
OL.endif
OL.if( OL.get(LASERTYPE) == 2)
LASERTEMP.setVisible(0);
LASERPOWER.setVisible(1);
ABSORPTION.setVisible(0);
OL.endif
OL.if( OL.get(LASERTYPE) == 3)
LASERTEMP.setVisible(0);
LASERPOWER.setVisible(1);
ABSORPTION.setVisible(1);
OL.endif

% The metamodel is described as a list of clients in the "name.ol" file (this file)
% This metamodel has 6 clients

% syntax for clients
% OL.client name.Register([interf...|encaps...]{,cmdl{,wdir,{host{,rdir}}}}) ;

%-1)  Gmsh for meshing
Mesher.register(encapsulated);
Mesher.in( OL.get(Arguments/FileName).geo );
Mesher.args( OL.get(Arguments/FileName).geo);
Mesher.out( OL.get(Arguments/FileName).msh );
% Merge the mesh file if the metamodel is loaded by Gmsh
Mesher.merge( OL.get(Arguments/FileName).msh);

%-2) ElmerGrid converts the mesh for Elmer
ElmerGrid.register(interfaced);
ElmerGrid.in( OL.get(Arguments/FileName).msh);
ElmerGrid.args(14 2 OL.get(Arguments/FileName).msh -out mesh);
ElmerGrid.out( mesh/mesh.boundary );

%-3) ElmerSolver computes the thermal problem
Elmer.register(interfaced);
Elmer.in( ELMERSOLVER_STARTINFO.ol , OL.get(Arguments/FileName).sif.ol);
Elmer.out( solution.pos, temp.txt );

%-4) Post-processing with Gmsh and a script
Post.register(interfaced);
Post.in(solution.pos , script.opt.ol ); 
Post.args(solution.pos script.opt -);
Post.out(tempsurf.txt, tempmin.txt, tempmax.txt);
Post.up( tempmin.txt,-1,8,Solution/Tmin, tempmax.txt,-1,8,Solution/Tmax);

%-5) Display solution curves with either gnuplot or matlab
POSTPRO.number(2, PostPro/,"Plot results with");
POSTPRO.addChoices(1,2); 
POSTPRO.addLabels(Matlab,Gnuplot);
OL.if( OL.get(POSTPRO) == 1)
Matlab.register(interfaced); 
Matlab.args(-nosplash -desktop -r plotMatlab);
OL.endif
OL.if( OL.get(POSTPRO) == 2)
Gnuplot.register(interfaced);
Gnuplot.in(temp.txt, tempsurf.txt);
Gnuplot.args(plot.plt );
OL.endif

%-6) Display solution with a client Gmsh
Display.register(interfaced);
Display.in(solution.pos, script2.opt.ol, overheat.pos.opt.ol );
Display.out(overheat.pos );
Display.args( solution.pos script2.opt - );
Display.merge(overheat.pos);
