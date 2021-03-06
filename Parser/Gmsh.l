%{
// Gmsh - Copyright (C) 1997-2013 C. Geuzaine, J.-F. Remacle
//
// See the LICENSE.txt file for license information. Please report all
// bugs and problems to the public mailing list <gmsh@geuz.org>.

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "GmshMessage.h"
#include "Geo.h"
#include "Gmsh.tab.hpp"

void   parsestring(char endchar);
char  *strsave(char *ptr);
void   skipcomments(void);
void   skipline(void);

#define YY_INPUT(buf,result,max_size)					\
     {									\
       int c = '*', n;							\
       for ( n = 0; n < max_size &&					\
	       (c = getc( yyin )) != EOF && c != '\n'; ++n )		\
	 buf[n] = (char) c;						\
       if ( c == '\n' ){						\
	 buf[n++] = (char) c;						\
	 yylineno++;							\
       }								\
       if ( c == EOF && ferror( yyin ) )				\
	 Msg::Fatal("Input in flex scanner failed");			\
       result = n;							\
     }									\

#if defined(WIN32)
#define isatty(arg) -1
#define YY_NO_UNISTD_H
#endif

%}

alpha	[a-zA-Z\_]
dieze	[\#]
special	[\.]
digit	[0-9]
exp	[Ee][-+]?{digit}+
string	{alpha}({alpha}|{digit})*

%%

[\ \t\n\r\f]		/* none */;
";"                     return tEND;
"/*"			skipcomments();
"//"			skipline();
"\""			{ parsestring('\"'); return tBIGSTR; }
"\'"			{ parsestring('\''); return tBIGSTR; }
"newreg"		{ gmsh_yylval.d = NEWREG(); return tDOUBLE; }
"newp"  		{ gmsh_yylval.d = NEWPOINT(); return tDOUBLE; }
"newl"  		{ gmsh_yylval.d = NEWLINE(); return tDOUBLE; }
"newc"  		{ gmsh_yylval.d = NEWLINE(); return tDOUBLE; }
"newll"  		{ gmsh_yylval.d = NEWLINELOOP(); return tDOUBLE; }
"news"  		{ gmsh_yylval.d = NEWSURFACE(); return tDOUBLE; }
"newsl"  		{ gmsh_yylval.d = NEWSURFACELOOP(); return tDOUBLE; }
"newv"  		{ gmsh_yylval.d = NEWVOLUME(); return tDOUBLE; }
"newf"  		{ gmsh_yylval.d = NEWFIELD(); return tDOUBLE; }
"="                     return tAFFECT;
"+="                    return tAFFECTPLUS;
"-="                    return tAFFECTMINUS;
"*="                    return tAFFECTTIMES;
"/="                    return tAFFECTDIVIDE;
":"                     return tDOTS;
"..."                   return tDOTS;
"||"                    return tOR;
"&&"                    return tAND;
"++"                    return tPLUSPLUS;
"--"                    return tMINUSMINUS;
"=="                    return tEQUAL;
"!="                    return tNOTEQUAL;
"<="                    return tLESSOREQUAL;
">="                    return tGREATEROREQUAL;

Abort                   return tAbort;
Acos                    return tAcos;
AdaptMesh               return tAdaptMesh;
ArcCos                  return tAcos;
Alias                   return tAlias;
AliasWithOptions        return tAliasWithOptions;
Asin                    return tAsin;
ArcSin                  return tAsin;
Atan                    return tAtan;
ArcTan                  return tAtan;
Atan2                   return tAtan2;
ArcTan2                 return tAtan2;

Betti                   return tBetti;
Bezier			return tBezier;
BSpline			return tBSpline;
BoundingBox             return tBoundingBox;

Ceil                    return tCeil;
Circle                  return tCircle;
CopyOptions             return tCopyOptions;
Coherence               return tCoherence;
Cohomology              return tCohomology;
Combine                 return tCombine;
Cosh                    return tCosh;
Cos                     return tCos;
Characteristic          return tCharacteristic;
Complex                 return tComplex;
Color                   return tColor;
ColorTable              return tColorTable;
Compound                return tCompound;
Coordinates             return tCoordinates;
CatmullRom		return tSpline;
Call                    return tCall;
CreateTopology          return tCreateTopology;
CreateTopologyNoHoles   return tCreateTopologyNoHoles;
Cpu                     return tCpu;

DefineConstant          return tDefineConstant;
Delete                  return tDelete;
Degenerated             return tDegenerated;
Dilate                  return tDilate;
Draw                    return tDraw;
SetChanged              return tSetChanged;

Exp                     return tExp;
Ellipsis                return tEllipse;
Ellipse                 return tEllipse;
Extrude                 return tExtrude;
Elliptic		return tElliptic;
EndFor                  return tEndFor;
EndIf                   return tEndIf;
Euclidian               return tEuclidian;
Error                   return tError;
Exit                    return tExit;

Fabs                    return tFabs;
Field                   return tField;
Floor                   return tFloor;
Fmod                    return tFmod;
For                     return tFor;
Function                return tFunction;

GetEnv                  return tGetEnv;
GetString               return tGetString;
GetValue                return tGetValue;
GMSH_MAJOR_VERSION      return tGMSH_MAJOR_VERSION;
GMSH_MINOR_VERSION      return tGMSH_MINOR_VERSION;
GMSH_PATCH_VERSION      return tGMSH_PATCH_VERSION;

Hide                    return tHide;
Hole                    return tHole;
Homology                return tHomology;
Hypot                   return tHypot;

In                      return tIn;
If                      return tIf;
Intersect               return tIntersect;
INTERPOLATION_SCHEME    return tInterpolationScheme;

Knots			return tNurbsKnots;

Length                  return tLength;
Line                    return tLine;
List                    return tList;
Log                     return tLog;
Log10                   return tLog10;
Layers                  return tLayers;
Levelset                return tLevelset;

MeshAlgorithm           return tMeshAlgorithm;
Modulo                  return tModulo;
MPI_Rank                return tMPI_Rank;
MPI_Size                return tMPI_Size;
Memory                  return tMemory;

Nurbs			return tNurbs;

Order			return tNurbsOrder;

Periodic                return tPeriodic;
Physical                return tPhysical;
Pi                      return tPi;
Plane                   return tPlane;
Point                   return tPoint;
Parametric		return tParametric;
PolarSphere             return tPolarSphere;
Printf                  return tPrintf;
Plugin                  return tPlugin;

Quad[tT]ri[aA]dd[vV]erts        return tQuadTriAddVerts;
Quad[tT]ri[nN]o[nN]ew[vV]erts   return tQuadTriNoNewVerts;

Quad[tT]ri[dD]bl        return tQuadTriDbl;
Quad[tT]ri[sS]ngl       return tQuadTriSngl;

Recombine               return tRecombine;
Recomb[lL]aterals       return tRecombLaterals;
Recursive               return tRecursive;
Rotate                  return tRotate;
Round                   return tRound;
Ruled                   return tRuled;
Rand                    return tRand;
RefineMesh              return tRefineMesh;
RelocateMesh            return tRelocateMesh;
Return                  return tReturn;
Reverse                 return tReverse;

ScaleLastLayer          return tScaleLast;
Smoother                return tSmoother;
SetOrder                return tSetOrder;
Sqrt                    return tSqrt;
Sin                     return tSin;
Sinh                    return tSinh;
Sphere                  return tSphere;
Spline                  return tSpline;
Split                   return tSplit;
Surface                 return tSurface;
Str                     return tStr;
Sprintf                 return tSprintf;
StrCat                  return tStrCat;
StrReplace              return tStrReplace;
StrPrefix               return tStrPrefix;
StrRelative             return tStrRelative;
StrFind                 return tStrFind;
StrCmp                  return tStrCmp;
Show                    return tShow;
Symmetry                return tSymmetry;
SyncModel               return tSyncModel;

T2                      return tText2D;
T3                      return tText3D;
TextAttributes          return tTextAttributes;
TIME                    return tTime;
Transfinite             return tTransfinite;
Transf[qQ]uad[tT]ri     return tTransfQuadTri;
Translate               return tTranslate;
Tanh                    return tTanh;
Tan                     return tTan;
Today                   return tToday;

UndefineConstant        return tUndefineConstant;
Using                   return tUsing;

Volume                  return tVolume;

{digit}+ |
{digit}+"."{digit}*({exp})? |
{digit}*"."{digit}+({exp})? |
{digit}+{exp}           { gmsh_yylval.d = atof((char *)yytext); return tDOUBLE; }

{string}		{ gmsh_yylval.c = strsave((char*)yytext); return tSTRING; }

.                       return yytext[0];

%%

#undef gmsh_yywrap

int gmsh_yywrap() {return 1;}

void skipcomments(void)
{
  int c;

  while (1) {
    while ((c = yyinput()) != '*'){
      if(feof(yyin)){
	Msg::Error("End of file in commented region");
        return;
      }
    }
    if ((c = yyinput()) == '/')
      return;
    unput(c);
  }
}

void parsestring(char endchar)
{
  int c;
  char tmp[1024];

  // Note that we keep special characters (end-of-line \n, tabs \t,
  // etc.) "as is" in the output string: see yyinput() above
  int i = 0;
  while ((c = yyinput()) != endchar) {
    if(feof(yyin)){
      Msg::Error("End of file in string");
      break;
    }
    else if(i >= (int)sizeof(tmp)-1){
      Msg::Error("String too long");
      break;
    }
    else{
      tmp[i++] = (char)c;
    }
  }
  tmp[i] = '\0';
  gmsh_yylval.c = strsave(tmp);
}

char *strsave(char *ptr)
{
  return((char*)strcpy((char*)malloc(strlen(ptr)+1),ptr));
}

void skipline()
{
  int c;
  while ((c = yyinput()) != '\n'){
    if(feof(yyin)) return;
  }
}

void skip_until(const char *skip, const char *until)
{
  int i, nb_skip;
  int l, l_skip, l_until;
  char chars[256];

  nb_skip = 0;

  if(skip)
    l_skip = strlen(skip);
  else
    l_skip = 0;

  l_until = strlen(until);

  while(1){
    while (1){
      chars[0] = yyinput();
      if(feof(yyin)){
	Msg::Error("Unexpected end of file");
	return;
      }
      if(chars[0] == until[0]) break;
      if(skip && chars[0] == skip[0]) break;
    }

    l = std::max(l_skip,l_until);
    if(l >= (int)sizeof(chars)){
      Msg::Error("Search pattern too long in skip_until");
      return;
    }
    for(i=1; i<l; i++){
      chars[i] = yyinput();
      if(feof(yyin)){
	l = i;
	break;
      }
    }

    if(!strncmp(chars,until,l_until)){
      if(!nb_skip){
	return;
      }
      else{
	nb_skip--;
      }
    }
    else if(skip && !strncmp(chars,skip,l_skip)){
      nb_skip++;
    }
    else{
      for(i=1;i<l-1;i++){
	unput(chars[l-i]);
      }
    }

  }
}

void gmsh_yyflush() { YY_FLUSH_BUFFER; }
