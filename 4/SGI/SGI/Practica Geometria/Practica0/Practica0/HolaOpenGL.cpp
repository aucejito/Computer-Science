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

#define PROYECTO "ISGI::S1E01::HolaOpenGL"

//Includes
#include <iostream>
#include "Utilidades.h"

GLuint trianguloArriba;
GLuint trianguloAbajo;

void init() {
	glClearColor(1.0, 1.0, 1.0, 1.0);
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
//Atiende al evento de dibujo (cada vez que dibujamos un frame)
void display()
{

	//Fijar el color de borrado (fondo)
	glClear(GL_COLOR_BUFFER_BIT); //Borra la pantalla
	glPolygonMode(GL_FRONT,GL_FILL);
	glColor3f(0.0,0.0,0.3);

	glCallList(trianguloArriba);
	glCallList(trianguloAbajo);
	//Indicar que han acabado las ordenes de dibujo
	
	glFlush();

}

//Callback del evento de reshape de cuando modificamos el tama�o de la ventana
void reshape(int w, int h)
{

}

int main(int argc, char** argv)
{
	//Inicializamos la gluT en la libreria de utilidades de openGL (obligatorio)
	glutInit(&argc, argv);

	//Buffers a usar (area de memoria en tarjeta que debemos habilitar)
	glutInitDisplayMode(GLUT_SINGLE | GLUT_RGB);

	//Posicionar la ventana de dibujo en la pantalla
	glutInitWindowPosition(50, 200); //Empieza en la esquina superior izquierda

	//Tama�o de la ventana 
	glutInitWindowSize(500, 400); //Anchura x Altura

	//Crear la ventana
	glutCreateWindow(PROYECTO);

	//Registrar las callbacks
	glutDisplayFunc(display);
	glutReshapeFunc(reshape);
	init();

	//Poner en marcha el bucle de atenci�n a eventos
	glutMainLoop();

	return 0;

}