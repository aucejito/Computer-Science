/**
*  Geometria.cpp
*
*  Dibujar un pentagono con display list de diferentes maneras
*
*  @author:   rvivo@upv.es
*  @version:  v1.0 Oct,2018
*  @require:  freeglut, Utilidades
*
**/

#define PROYECTO "ISGI::S2E01::Geometria"

#include <iostream>
#include <Utilidades.h>

using namespace std;

GLuint pentagono;

void init()
{
	glClearColor(0, 0, 0.3, 1);

	pentagono = glGenLists(1);

	glNewList(pentagono, GL_COMPILE);

	glBegin(GL_POLYGON);
	for (auto i = 0; i < 5; i++) {
		glVertex3f(0.8 * cos(i * 2 * PI / 5), 0.8* sin(i * 2 * PI / 5), 0);
	}
	glEnd();

	glEndList();

}

void display()
{
	glClear(GL_COLOR_BUFFER_BIT);

	// glutWireTeapot(0.5);

	glPolygonMode(GL_FRONT, GL_FILL);
	glColor3f(1, 1, 0);
	glCallList(pentagono);

	glPolygonMode(GL_FRONT, GL_LINE);
	glColor3f(1, 0, 0);
	glLineWidth(4);
	glCallList(pentagono);

	glPolygonMode(GL_FRONT, GL_POINT);
	glColor3f(0, 1, 0);
	glPointSize(10);
	glCallList(pentagono);

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
	glutInitWindowSize(600, 600);
	glutCreateWindow(PROYECTO);

	// Callbacks
	glutDisplayFunc(display);
	glutReshapeFunc(reshape);

	init();

	cout << PROYECTO << " en marcha" << endl;

	// Event loop
	glutMainLoop();
}
