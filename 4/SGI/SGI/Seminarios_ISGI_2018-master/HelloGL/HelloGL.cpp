/**
*  HelloGL.cpp
*
*  Plantilla basica de una aplicacion en OpenGL
*
*  @author:   rvivo@upv.es
*  @version:  v1.0 Oct,2018
*  @require:  freeglut
*
**/

#define PROYECTO "ISGI::S1E01::Proyecto"

#include <iostream>
#include "gl/freeglut.h"

using namespace std;

void display()
{
	glClearColor(0, 0, 0.3, 1);
	glClear(GL_COLOR_BUFFER_BIT);
	glFlush();
}

void reshape(GLint w, GLint h)
{

}

void main(int argc, char** argv)
{
	// Initializations
	glutInit(&argc, argv);
	glutInitDisplayMode(GLUT_SINGLE | GLUT_RGB);
	glutInitWindowSize(600, 400);
	glutCreateWindow(PROYECTO);

	// Callbacks
	glutDisplayFunc(display);
	glutReshapeFunc(reshape);

	cout << PROYECTO << " en marcha" << endl;

	// Event loop
	glutMainLoop();
}
