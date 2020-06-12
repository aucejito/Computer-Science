/*
	Interaccion.cpp

	@author: Juan Antonio López
	@version: v1.0 4/oct/2018
	@require: freeglut

*/

#include <iostream>
#include "gl/freeglut.h"
#include <sstream>
#include <utilidades.h>

#define PROYECTO "Interaccion"
using namespace std;

static enum { ALAMBRICO, SOLIDO, DOBLE } modo;

//x0 y z0 definen las posiciones
float xO = 0;
float zO = 0;
//y define el ángulo
float yO = 180;
//r define el desplazamiento
float r = 0.1;
//rot define el angulo que se suma/resta a y
float rot = 0.8;
GLfloat base[4][3] = { {-10, 0, 0}, {10, 0, 0}, {10, 0, -10}, {-10, 0, -10} };
GLfloat ptsrecta[4][3] = { {0,0,0}, {1,0,0}, {1,0,-1}, {0,0,-1} };
GLfloat ptscurva[4][3] = { {0,0,0}, {0,0,0}, {0,0,0}, {0,0,0} };
GLint recta, curva, fondo;
GLuint carretera, texturafondo;


void onMenu(int valor) {
	if (valor == 0) { modo = ALAMBRICO; }
	else if (valor == 1) { modo = SOLIDO; }
	else { modo = DOBLE; }

	glutPostRedisplay();
}

void init() {
	//Fijar color de borrado
	glClearColor(1, 1, 1, 1.0);
	glEnable(GL_TEXTURE_2D);
	glEnable(GL_DEPTH_TEST);

	//Crear la recta
	recta = glGenLists(1);
	glNewList(recta, GL_COMPILE);
	glPushMatrix();
	quad(ptsrecta[0], ptsrecta[1], ptsrecta[2], ptsrecta[3], 10, 10);
	glPopMatrix();
	glEndList();
	//Crear curva
	curva = glGenLists(1);
	glNewList(curva, GL_COMPILE);
	glPushMatrix();
	ptscurva[0][0] = 0;
	ptscurva[0][1] = 0;
	ptscurva[0][2] = 0;
	ptscurva[1][0] = 1;
	ptscurva[1][1] = 0;
	ptscurva[1][2] = 0;
	ptscurva[3][0] = 0;
	ptscurva[3][1] = 0;
	ptscurva[3][2] = 0;
	for (float alfa = PI/16; alfa <= PI/2+0.1; alfa+=PI/16) {
		ptscurva[2][0] = 1 * cos(alfa);
		ptscurva[2][1] = 0;
		ptscurva[2][2] = -1 * sin(alfa);
		quad(ptscurva[0], ptscurva[1], ptscurva[2], ptscurva[3], 10, 10);
		ptscurva[1][0] = ptscurva[2][0];
		ptscurva[1][1] = ptscurva[2][1];
		ptscurva[1][2] = ptscurva[2][2];
	}
	glPopMatrix();
	glEndList();

	float nLados = 10;
	float apotema = 10;
	float lado = apotema * tan(PI / nLados);
	float alto = 3;

	GLfloat ptsfondo[4][3] = { {-lado,-alto,0}, {lado,-alto,0}, {lado,alto,0}, {-lado,alto,0} };
	fondo = glGenLists(1);
	glNewList(fondo, GL_COMPILE);
	for (auto i = 0; i < nLados; i += 1) {
		glPushMatrix();
		glRotatef(-i * 360 / nLados, 0, 1, 0);
		glTranslatef(0, 0, -apotema);
		quadtex(
			ptsfondo[0],
			ptsfondo[1],
			ptsfondo[2],
			ptsfondo[3],
			i / nLados,
			(i + 1) / nLados,
			0, 1, 1, 1);
		glPopMatrix();
	}
	glEndList();

	//Crear menu
	glutCreateMenu(onMenu);
	glutAddMenuEntry("ALAMBRICO", 0);
	glutAddMenuEntry("SOLIDO", 1);
	glutAddMenuEntry("DOBLE", 2);
	glutAttachMenu(GLUT_RIGHT_BUTTON);

	glGenTextures(1, &carretera);
	glBindTexture(GL_TEXTURE_2D, carretera);
	loadImageFile((char *) "carretera.jpeg");

	glGenTextures(1, &texturafondo);
	glBindTexture(GL_TEXTURE_2D, texturafondo);
	loadImageFile((char *) "fondo.jpeg");
}

void display() {
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
	printf("%f\n", yO);
	gluLookAt(0 + xO, 0.1, 0 + zO, cos(yO*PI / 180) + xO, 0.1, -sin(yO*PI / 180) + zO, 0, 1, 0);
	//gluLookAt(0.5,15,-2.5, 0.5,0,-2.5, 0,0, -1);
	glColor3f(0, 0, 0);
	glPushAttrib(GL_FRONT_AND_BACK);
	glPushMatrix();
	glTranslatef(0,0,0.5);
	glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
	quad(base[0], base[1], base[2], base[3], 20, 10);

	glPopAttrib();

	ejes();
	glColor3f(1, 1, 1);
	glBindTexture(GL_TEXTURE_2D, texturafondo);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);

	glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE);
	glPushMatrix();
	glTranslatef(0,1,0);
	glRotatef(-180,0,1,0);
	glCallList(fondo);
	glPopMatrix();

	glBindTexture(GL_TEXTURE_2D, carretera);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);

	glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE);
	

	glPushMatrix();
	glTranslatef(-1,0,-1);
	glRotatef(180, 0, 1, 0);
	glCallList(curva);
	glPopMatrix();

	glPushMatrix();
	glTranslatef(-1, 0, -3);
	glRotatef(90, 0, 1, 0);
	glCallList(curva);
	glPopMatrix();

	glPushMatrix();
	glTranslatef(0, 0, -4);
	glRotatef(-90, 0, 1, 0);
	glCallList(curva);
	glPopMatrix();

	glPushMatrix();
	glTranslatef(1, 0, -4);
	glRotatef(90, 0, 1, 0);
	glCallList(curva);
	glPopMatrix();

	glPushMatrix();
	glTranslatef(2, 0, -4);
	glCallList(curva);
	glPopMatrix();

	glPushMatrix();
	glTranslatef(2, 0, -1);
	glRotatef(-90, 0, 1, 0);
	glCallList(curva);
	glPopMatrix();

	glPushMatrix();
	glTranslatef(1,0,0);
	glRotatef(90, 0, 1, 0);
	glCallList(recta);
	glPopMatrix();

	glPushMatrix();
	glRotatef(90,0,1,0);
	glCallList(recta);
	glPopMatrix();

	glPushMatrix();
	glTranslatef(-2, 0, -1);
	glCallList(recta);
	glPopMatrix();

	glPushMatrix();
	glTranslatef(-2, 0, -2);
	glCallList(recta);
	glPopMatrix();

	glPushMatrix();
	glTranslatef(0, 0, -3);
	glRotatef(90,0,1,0);
	glCallList(recta);
	glPopMatrix();

	glPushMatrix();
	glTranslatef(2, 0, -4);
	glRotatef(90,0,1,0);
	glCallList(recta);
	glPopMatrix();

	glPushMatrix();
	glTranslatef(2, 0, -3);
	glCallList(recta);
	glPopMatrix();

	glPushMatrix();
	glTranslatef(2, 0, -2);
	glCallList(recta);
	glPopMatrix();

	glPushMatrix();
	glTranslatef(2, 0, -1);
	glCallList(recta);
	glPopMatrix();

	glPushMatrix();
	glTranslatef(2, 0, 0);
	glRotatef(90, 0, 1, 0);
	glCallList(recta);
	glPopMatrix();

	glPopMatrix();
	//Indicar que se ha acabado las ordenes de borrado
	glutSwapBuffers();
}

void reshape(int w, int h) {
	glViewport(0, 0, w, h);

	float ra = float(w) / float(h);
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();

	gluPerspective(20, ra, 0.2, 20);

}

void onKey(unsigned char tecla, int x, int y) {

	switch (tecla) {
	case 'w':
		zO = zO - r * sin(yO*PI / 180);
		xO = xO + r * cos(yO*PI / 180);
		break;
	case 's':
		zO = zO - r * sin((yO + 180)*PI / 180);
		xO = xO + r * cos((yO + 180)*PI / 180);
		break;
	case 'a':
		yO = yO + rot;
		break;
	case 'd':
		yO = yO - rot;
		break;
	}
	glutPostRedisplay();
}

void onUpKey(unsigned char tecla, int x, int y) {

}

void onSpecialKey(int tecla, int x, int y) {

}

void onSpecialUpKey(int tecla, int x, int y) {

}

void select() {


}

void onClick(int boton, int estado, int x, int y) {

}

void onDrag(int x, int y) {

}

void main(int argc, char **argv) {
	glutInit(&argc, argv);

	//Inicializamos FreeImage
	FreeImage_Initialise();

	//Buffers a usar
	glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGB | GLUT_DEPTH);

	//Posicionar la ventana de dibujo en la pantalla
	glutInitWindowPosition(50, 200);

	//Tamanio de la pantalla
	glutInitWindowSize(500, 500);

	//Crear la ventana
	glutCreateWindow(PROYECTO);
	init();

	//Callbacks
	glutDisplayFunc(display);
	glutReshapeFunc(reshape);
	glutKeyboardFunc(onKey);
	glutKeyboardUpFunc(onUpKey);
	glutSpecialFunc(onSpecialKey);
	glutSpecialUpFunc(onSpecialUpKey);
	glutMouseFunc(onClick);
	glutMotionFunc(onDrag);


	//Poner en march el bucle de atencion a eventos
	glutMainLoop();

	//Liberamos FreeImage
	FreeImage_DeInitialise();

}