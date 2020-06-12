/*
	Animacion.cpp

	@author: Juan Antonio López
	@version: v1.0 4/oct/2018
	@require: freeglut

*/

#include <iostream>
#include "gl/freeglut.h"
#include <sstream>
#include <utilidades.h>

#define PROYECTO "Animacion"
using namespace std;
static float alfa = 0;

void init() {
	//Fijar color de borrado
	glClearColor(0.0, 0.0, 0.3, 1.0);
	glEnable(GL_DEPTH_TEST);

}

void FPS() {
	//Cuenta fotogramas hasta que pasa un segundo
	//Entonces, los muestra y reinicia la cuenta

	int ahora, tiempo_transcurrido;
	static int antes = glutGet(GLUT_ELAPSED_TIME);
	static int fotogramas = 0;

	//Cada vez que paso por aqui sumo un fotograma
	fotogramas++;

	//Calcular el tiempo
	ahora = glutGet(GLUT_ELAPSED_TIME);
	tiempo_transcurrido = ahora - antes;

	//Si ha transcurrido mas de un segundo, muestro y reinicio
	if (tiempo_transcurrido > 1000) {
		stringstream titulo;
		titulo << "FPS = " << fotogramas;
		glutSetWindowTitle(titulo.str().c_str());
		fotogramas = 0;
		antes = ahora;
	}
}
void display() {
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();

	gluLookAt(3, 3, 4, 0, 0, 0, 0, 1, 0);

	ejes();

	glPushMatrix();
	glTranslatef(0, 0, 0.5);
	glColor3f(1, 0, 0);
	glRotatef(alfa, 0, 1, 0);
	glutSolidTeapot(0.5);
	glColor3f(1, 1, 1);
	glutWireTeapot(0.51);
	glPopMatrix();

	glPushMatrix();
	glTranslatef(0, 0, -0.2);
	glColor3f(0, 1, 0);
	glRotatef(alfa/2,0,1,0);
	glutSolidTeapot(0.5);
	glColor3f(1, 1, 1);
	glutWireTeapot(0.51);
	glPopMatrix();

	//Indicar que se ha acabado las ordenes de borrado
	glutSwapBuffers();

	FPS();
}

void reshape(int w, int h) {
	glViewport(0, 0, w, h);

	float ra = float(w) / float(h);
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();

	//if (ra > 1) glOrtho(-2*ra, 2*ra, -2, 2, -2, 2);
	//else glOrtho(-2, 2, -2/ra, 2/ra, -2, 2);

	gluPerspective(20, ra, 0.2, 10);

}
void update() {
	//Fase de actualizacion

	//Sin control del tiempo
	//alfa += 0.1;

	//Control del tiempo
	static const float omega = 2;  //Vueltas por segundo

	//Hora aneterior inicial
	static int antes = glutGet(GLUT_ELAPSED_TIME);

	//Hora actual 
	int ahora = glutGet(GLUT_ELAPSED_TIME);

	//Tiempo trascurrido
	float tiempo_transcurrido = (float)(ahora - antes) / 1000.0;

	//incremento = velocidad*tiempo;
	alfa += 360 * omega *tiempo_transcurrido;

	//Actualizar la hora para la próxima vez
	antes = ahora;
	
	//Mandar evento de redibujo
	glutPostRedisplay();
}
void onTimer(int tiempo) {
	// CallBack de atencion a la cuenta atras
	update();

	//Una nueva cuenta atrás
	glutTimerFunc(tiempo,onTimer,tiempo);

}

void main(int argc, char **argv) {
	glutInit(&argc, argv);

	//Buffers a usar
	glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGB | GLUT_DEPTH);

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
	//glutIdleFunc(update);
	glutTimerFunc(1000/50, onTimer, 1000/50);


	//Poner en march el bucle de atencion a eventos
	glutMainLoop();

}