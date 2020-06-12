/*****************************************************************************/
/*  Ejemplo de un posible programa principal y tratamiento de errores.       */
/*****************************************************************************/
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "header.h"
#include "libtds.h"

int verTDS=FALSE;                   /* Flag para saber si mostrar la TDS     */
int verbosidad=FALSE;               /* Flag para saber si se desea una traza */
int numErrores=0;                   /* Contador del numero de errores        */
/*****************************************************************************/

void error(char *tipoError, char *string){
  char *msg;
  if(strcmp(tipoError,"ya_declarada") == 0){ // YA_DECLARADA
    msg = malloc(48 + strlen(string));
    sprintf(msg,"La variable %s ya ha sido declarada anteriormente.", string);
  } else if (strcmp(tipoError,"no_declarada") == 0) {
    msg = malloc(42 + strlen(string));
    sprintf(msg,"La variable %s no ha sido declarada todavía.", string);
  } else if (strcmp(tipoError,"error_asignacion") == 0) { // ERROR_ASIGNACION
    msg = malloc(44);
    sprintf(msg,"El tipo no se corresponde al valor asignado.");
  } else if (strcmp(tipoError,"error_no_array") == 0) { // ERROR_NO_ARRAY
    msg = malloc(33 + strlen(string));
    sprintf(msg,"La variable %s no es de tipo array.", string);
  } else if (strcmp(tipoError,"talla_inapropiada") == 0) { // TALLA_INAPROPIADA
    msg = malloc(52 + strlen(string));
    sprintf(msg,"Talla inapropiada en la declaración de la variable %s.", string);
  } else if (strcmp(tipoError,"no_bool") == 0) { // NO_BOOL
    msg = malloc(68 + strlen(string));
    sprintf(msg,"La expresión de la instrucción de tipo %s esperaba una expresión bool.", string);
  }else if (strcmp(tipoError,"error_tipo_entero") == 0) { // error_tipo_entero
    msg = malloc(32 + strlen(string));
    sprintf(msg,"Se esperaba un tipo entero en %s", string);
  }else if (strcmp(tipoError,"error_tipo_logico") == 0) { // error_tipo_entero
    msg = malloc(35);
    sprintf(msg,"Se esperaba un valor de tipo logico");
  } else if (strcmp(tipoError,"error_no_coincide_tipos") == 0) { // error_tipo_entero
    msg = malloc(35);
    sprintf(msg,"Se estan intentando comparar dos expresiones de tipos distintos.");
  } else if (strcmp(tipoError,"error_tipo_entero2") == 0) { // error_tipo_entero
    msg = malloc(35);
    sprintf(msg,"No se puede hacer comprobaciones relacionales o asignaciones aditivas entre dos valores, tal que al menos uno de los dos no sea entero");
  }else {
    msg = malloc(18);
    sprintf(msg,"Error desconocido.");
  }
  yyerror(msg);
  free(msg);
}

void yyerror(const char * msg)
/*  Tratamiento de errores.                                                  */
{
  numErrores++;
  fprintf(stdout, "\nError en la linea %d: %s\n", yylineno, msg);
}

/*****************************************************************************/
int main (int argc, char **argv) 
/* Gestiona la linea de comandos e invoca al analizador sintactico-semantico.*/
{ int i, n = 1;

  for (i=1; i<argc; ++i) { 
    if      (strcmp(argv[i], "-v")==0) { verbosidad = TRUE; n++; }
    else if (strcmp(argv[i], "-t")==0) { verTDS = TRUE; n++; }
  }
  if (argc == n+1) {
    if ((yyin = fopen (argv[n], "r")) == NULL) {
      fprintf (stderr, "El fichero '%s' no es valido\n", argv[n]);
      fprintf (stderr, "Uso: cmc [-v] fichero\n");
    }
    else {        
      if (verbosidad == TRUE) fprintf(stdout,"%3d.- ", yylineno);
      yyparse ();
      if (numErrores > 0) 
        fprintf(stderr,"\nNumero de errores:      %d\n", numErrores);
    }   
  }
  else fprintf (stderr, "Uso: cmc [-v] [-t] fichero\n");
  
  mostrarTDS();
  return (0);
} 
/*****************************************************************************/
