/**
*  Flor.cpp
*
*  Dibuja una flor compuesta de listas transformadas
*
*  @author:   rvivo@upv.es
*  @version:  v1.0 Oct,2018
*  @require:  freeglut, utilidades.h
*
**/

#define PROYECTO "ISGI::S1E01::Proyecto"

#include <iostream>
#include "Utilidades.h"

using namespace std;

static GLuint flor, corola, petalo;

void init()
{
	glClearColor(0, 0, 0.3, 1);

	// Petalo
	petalo = glGenLists(1);
	glNewList(petalo, GL_COMPILE);

	glColor3f(1.0, 1.0, 1.0);
	glPushMatrix();
	glScalef(0.15, 0.5, 0.15);
	glutSolidSphere(1, 20, 20);
	glPopMatrix();

	glEndList();

	// Corola
	corola = glGenLists(1);
	glNewList(corola, GL_COMPILE);

	for (auto i = 0; i < 12; i++) {
		/// el petalo en la corola
		glPushMatrix();
		glRotatef(i*30, 0, 0, 1);
		glTranslatef(00, 0.25, 0.0);
		glScalef(0.5, 0.5, 0.5);
		glCallList(petalo);
		glPopMatrix();
	}

	glColor3f(1, 1, 0);
	glPushMatrix();
	glScalef(0.2, 0.2, 0.2);
	glutSolidSphere(1, 20, 20);
	glPopMatrix();

	glEndList();

	// Flor
	flor = glGenLists(1);
	glNewList(flor, GL_COMPILE);

	/// tallo
	glColor3f(0, 1, 0);
	glPushMatrix();
	glTranslatef(0.0, -0.125, 0.0);
	glScalef(0.05, 0.75, 0.05);
	glutSolidCube(1);
	glPopMatrix();

	/// corola en la flor
	glPushMatrix();
	glTranslatef(0.0, 0.25, 0.0);
	glRotatef(10, 0, 0, 1);
	glScalef(0.5, 0.5, 0.5);
	glCallList(corola);
	glPopMatrix();

	glEndList();
}

void display()
{

	glClear(GL_COLOR_BUFFER_BIT);
	glMatrixMode(GL_MODELVIEW);			// Selecciono model-view
	glLoadIdentity();					// Carga la identidad en el tope de la pila

	for (auto i = 0; i < 40; i++) {
		glPushMatrix();
		glTranslatef((rand() % 200 - 100) / 100.0,
			(rand() % 100 - 50) / 100.0,
			0.0);
		glScalef(0.4, 0.4, 0.4);
		glCallList(flor);
		glPopMatrix();
	}

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
	init();

	// Callbacks
	glutDisplayFunc(display);
	glutReshapeFunc(reshape);

	cout << PROYECTO << " en marcha" << endl;

	// Event loop
	glutMainLoop();
}
