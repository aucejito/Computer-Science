/*
	Camara.cpp

	@author: Juan Antonio López
	@version: v1.0 4/oct/2018
	@require: freeglut

*/

#include <iostream>
#include "gl/freeglut.h"
#include <utilidades.h>

#define PROYECTO "Proyecto de OpenGL 1"

void init() {
	//Fijar color de borrado
	glClearColor(0.0, 0.0, 0.3, 1.0);
	glEnable(GL_DEPTH_TEST);

}
void display() {
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();

	gluLookAt(0, 5, 0, 0, 0, 0, 0, 0, 1);

	ejes();

	glPushMatrix();
	glTranslatef(0, 0, 1);
	glColor3f(1, 0, 0);
	glutSolidTeapot(0.5);
	glColor3f(1, 1, 1);
	glutWireTeapot(0.51);
	glPopMatrix();

	glPushMatrix();
	glTranslatef(0, 0, -1);
	glColor3f(0, 1, 0);
	glutSolidTeapot(0.5);
	glColor3f(1, 1, 1);
	glutWireTeapot(0.51);
	glPopMatrix();

	//Indicar que se ha acabado las ordenes de borrado
	glFlush();
}

void reshape(int w, int h) {
	glViewport(0, 0, w, h);

	float ra = float(w) / float(h);
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();

	//if (ra > 1) glOrtho(-2*ra, 2*ra, -2, 2, -2, 2);
	//else glOrtho(-2, 2, -2/ra, 2/ra, -2, 2);
	
	gluPerspective(40, ra, 0.2, 10);

}

void main(int argc, char **argv) {
	glutInit(&argc, argv);
	
	//Buffers a usar
	glutInitDisplayMode(GLUT_SINGLE | GLUT_RGB | GLUT_DEPTH);

	//Posicionar la ventana de dibujo en la pantalla
	glutInitWindowPosition(50, 200);

	//Tamanio de la pantalla
	glutInitWindowSize(500, 500);

	//Crear la ventana
	glutCreateWindow(PROYECTO);
	init();
	//Registrar las callbacks
	glutDisplayFunc(display);
	glutReshapeFunc(reshape);

	//Poner en march el bucle de atencion a eventos
	glutMainLoop();

}