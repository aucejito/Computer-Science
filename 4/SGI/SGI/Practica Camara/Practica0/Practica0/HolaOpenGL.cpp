/**
*
*   HolaOpenGL.cpp
*
*   Plantilla basica para un programa OpenGL
*
*   @author:   Juan Antonio López Ramírez
*   @version:
*   @require:  freeglut
*
*
**/

#include <iostream>
#include "gl/freeglut.h"
#include <utilidades.h>

#define PROYECTO "Proyecto de OpenGL 1"

GLuint trianguloArriba;
GLuint trianguloAbajo;
void init() {
	//Fijar color de borrado
	glClearColor(1, 1, 1, 1);
	glEnable(GL_DEPTH_TEST);

	trianguloArriba = glGenLists(1);
	glNewList(trianguloArriba, GL_COMPILE);

	glBegin(GL_TRIANGLE_STRIP);

	for (auto i = 0; i < 4; i++) {
		glVertex3f(1.0 * cos(i * 2 * PI / 3 + PI / 2),
			1.0 * sin(i * 2 * PI / 3 + PI / 2),
			0);

		glVertex3f(0.7 * cos(i * 2 * PI / 3 + PI / 2),
			0.7 * sin(i * 2 * PI / 3 + PI / 2),
			0);
	}

	glEnd();
	glEndList();

	trianguloAbajo = glGenLists(1);
	glNewList(trianguloAbajo, GL_COMPILE);

	glBegin(GL_TRIANGLE_STRIP);

	for (auto i = 0; i < 4; i++) {
		glVertex3f(1.0 * cos(i * 2 * PI / 3 - PI / 2),
			1.0 * sin(i * 2 * PI / 3 - PI / 2),
			0);

		glVertex3f(0.7 * cos(i * 2 * PI / 3 - PI / 2),
			0.7 * sin(i * 2 * PI / 3 - PI / 2),
			0);
	}

	glEnd();
	glEndList();

}
void display() {
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();

	gluLookAt(3, 3, 3, 0, 0, 0, 0, 1, 0);

	glColor3f(0, 1, 1);
	glutWireSphere(1, 10, 10);

	for (auto i = 0; i <= 6; i++) {
		glColor3f(0.2*i, 0.2*i, 1-(0.2*i));
		glRotatef(22.5*i,0,1,0);
		glCallList(trianguloArriba);
		glCallList(trianguloAbajo);
	}

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

	float d = sqrt(pow(3, 2) + pow(3, 2) + pow(3, 2));
	float fovy = (2 * asin(1 / d)) * 180 / PI;
	gluPerspective(fovy, ra, 0.5, 10);

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