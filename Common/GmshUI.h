#ifndef _GMSH_UI_H_
#define _GMSH_UI_H_

#ifdef WIN32
#include <windows.h>
#include <GL/gl.h>
#include <GL/glu.h>
#endif

#ifdef _FLTK
#include <FL/Fl.H>
#include <FL/gl.h>
#ifdef __APPLE__
#include <OpenGL/glu.h>
#else
#include <GL/glu.h>
#endif /* __APPLE__ */
#endif


#endif
