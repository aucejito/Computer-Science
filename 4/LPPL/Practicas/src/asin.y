/*****************************************************************************/
/**  Ejemplo de BISON-I: S E M - 2          2018-2019 <jbenedi@dsic.upv.es> **/
/**  V. 18.1                                                                **/
/*****************************************************************************/
%{
#include <stdio.h>
#include <string.h>
#include "header.h"
#include "libtds.h"
%}

// Definimos los atributos que van a tener los tokens y su tipo
%union {
  char* string;
  int entero;
}

/********************************************************************/

// Prioridad de abajo a arriba
%token CTE_ TRUE_ FALSE_ BOOL_ INT_ ID_ PUNTOCOMA_ LLAVEABIERTA_ LLAVECERRADA_ CORCHETEABIERTO_ CORCHETECERRADO_ PARENTESISABIERTO_ PARENTESISCERRADO_
%token IGUAL_ MASIGUAL_ MENOSIGUAL_ MULTIGUAL_ DIVIGUAL_
%token AND_ OR_ NOT_
%token IF_ ELSE_ FOR_
%token IGUALIGUAL_ NOIGUAL_ MAYOR_ MENOR_ MAYORIGUAL_ MENORIGUAL_
%token MAS_ MENOS_ MASMAS_ MENOSMENOS_
%token READ_ PRINT_
%token MULT_ DIV_ MODULO_

// Atributos de los tokens
%type <string> ID_
%type <entero> CTE_ tipoSimple constante expresion expresionIgualdad expresionRelacional expresionAditiva expresionMultiplicativa expresionUnaria expresionSufija operadorAsignacion operadorLogico operadorIgualdad operadorRelacional operadorAditivo operadorMultiplicativo operadorUnario operadorIncremento
%%

programa:                     LLAVEABIERTA_ secuenciaSentencias LLAVECERRADA_
                          ;

secuenciaSentencias:        sentencia
                          |  secuenciaSentencias sentencia
                          ;

sentencia:                  declaracion
                          |   instruccion
                          ;

declaracion:                tipoSimple ID_ PUNTOCOMA_
                            {
                              SIMB id = obtenerTDS($2);
                              if (id.tipo == T_ERROR) insTSimpleTDS($2, $1, 0);
                              else {
                                error("ya_declarada",$2);
                              }
                            }
                          | tipoSimple ID_ IGUAL_ constante PUNTOCOMA_ 
                            {  
                              SIMB id = obtenerTDS($2);   
                              if (id.tipo == T_ERROR) {
                                if ($1 == $4) {
                                  insTSimpleTDS($2, $1, 0);
                                } else {
                                  error("error_asignacion","");
                                }
                              } else {
                                error("ya_declarada",$2);
                              }
                            }
                          | tipoSimple ID_ CORCHETEABIERTO_ CTE_ CORCHETECERRADO_ PUNTOCOMA_ 
                            {  
                              SIMB id = obtenerTDS($2);    
                              if (id.tipo == T_ERROR) {
                                if($4 > 0) {
                                  insTVectorTDS($2, T_ARRAY, 0, $1, $4);
                                } else {
                                  error("talla_inapropiada",$2);
                                }
                              } else error("ya_declarada",$2);
                            }
                          ;

tipoSimple:                 INT_  { $$ = T_ENTERO; }
                          | BOOL_ { $$ = T_LOGICO; }
                          ;

instruccion:                LLAVEABIERTA_ listaInstrucciones LLAVECERRADA_
                          | instruccionEntradaSalida
                          | instruccionAsignacion
                          | instruccionSeleccion
                          | instruccionIteracion
                          ;

listaInstrucciones:         listaInstrucciones instruccion
                          |
                          ;             

instruccionAsignacion:      
    ID_ operadorAsignacion expresion PUNTOCOMA_ 
    {
      SIMB id = obtenerTDS($1);
      if (id.tipo == T_ERROR) {
        error("no_declarada",$1);
      } else {
        if (!(id.tipo == $3 && id.tipo != T_ARRAY && ($2==$3 || $2==T_VACIO))) {
          error("error_asignacion","");
        }
      }
    }
  | ID_ CORCHETEABIERTO_ expresion CORCHETECERRADO_ operadorAsignacion expresion PUNTOCOMA_
    {
      SIMB id = obtenerTDS($1);
      if (id.tipo == T_ERROR) {
        error("no_declarada",$1);
      } else {
        if(!(id.tipo == T_ARRAY)) {
          error("error_no_array",$1);
        } else if (!(id.tipo == $6 && ($5==$6 || $5==T_VACIO))) {
          error("error_asignacion","");
        }
      }
    }      
  ;

instruccionEntradaSalida:   READ_ PARENTESISABIERTO_ ID_ PARENTESISCERRADO_ PUNTOCOMA_
                            {
                              SIMB id = obtenerTDS($3);
                              if (id.tipo == T_ERROR) {
                                error("no_declarada",$3);
                              } else {
                                  if(!(id.tipo == T_ENTERO)) {
                                    error("error_tipo_entero",$3);
                                  }
                              }
                            }
                          | PRINT_ PARENTESISABIERTO_ expresion PARENTESISCERRADO_ PUNTOCOMA_
                            {
                              printf("%d", $3);
                              if($3 != T_ENTERO){
                                error("error_tipo_entero","el print");
                              }
                            }
                          ;

instruccionSeleccion:       IF_ PARENTESISABIERTO_ expresion PARENTESISCERRADO_ instruccion ELSE_ instruccion
                            {
                              if($3 != T_LOGICO) {
                                error("no_bool","if");
                              }
                            }
                          ;

instruccionIteracion:       FOR_ PARENTESISABIERTO_ expresionOpcional PUNTOCOMA_ expresion PUNTOCOMA_ expresionOpcional PARENTESISCERRADO_ instruccion{
                              if($5 != T_LOGICO) {
                                error("no_bool","for");
                              }
                            } 
                          ;

expresionOpcional:          expresion
                          | ID_ IGUAL_ expresion
                            {  
                      
                              SIMB id = obtenerTDS($1);   
                              if (id.tipo == T_ERROR) {
                              } else {
                                error("ya_declarada",$1);
                              }
                            }
                          |
                          ;

expresion:                  expresionIgualdad { $$ = $1; }
                          | expresion operadorLogico expresionIgualdad
                            {
                              $$ = T_ERROR;
                              if($1==T_LOGICO && T_LOGICO==$3){
                                $$ = T_LOGICO;
                              }else
                                  error("error_tipo_logico","");
                            }
                          ;

expresionIgualdad:          expresionRelacional { $$ = $1; }
                          | expresionIgualdad operadorIgualdad expresionRelacional
                          {
                            $$ = T_ERROR;
                            if($1 != $3) {
                              error("error_no_coincide_tipos","");
                            }
                            else {
                              $$ = T_LOGICO;
                            }
                          }
                          ;

expresionRelacional:        expresionAditiva { $$ = $1; }
                          | expresionRelacional operadorRelacional expresionAditiva
                          {
                            $$ = T_ERROR;
                            if($1 != T_ENTERO || $3 != T_ENTERO) {
                              error("error_tipo_entero2","");
                            } else {
                              $$ = T_LOGICO;
                            }
                          }
                          ;

expresionAditiva:           expresionMultiplicativa { $$ = $1; }
                          | expresionAditiva operadorAditivo expresionMultiplicativa
                          {
                            $$ = T_ERROR;
                            if($1 != T_ENTERO || $3 != T_ENTERO) {
                              error("error_tipo_entero2","");
                            } else {
                              $$ = T_ENTERO;
                            }
                          }
                          ;

expresionMultiplicativa:    expresionUnaria { $$ = $1; }
                          | expresionMultiplicativa operadorMultiplicativo expresionUnaria
                          {
                            $$ = T_ERROR;
                            if($1 != T_ENTERO || $3 != T_ENTERO) {
                              error("error_tipo_entero2","");
                            } else {
                              $$ = T_ENTERO;
                            }
                          }
                          ;

expresionUnaria:
    expresionSufija { $$ = $1; }
  | operadorUnario expresionUnaria
    {
      $$ = T_ERROR;
      if ($1 == $2) {
        $$ = $1;
      } else {
        error("error_asignacion","");
      }
    }
  | operadorIncremento ID_
    {
      $$ = T_ERROR;
      SIMB id = obtenerTDS($2);
      if (id.tipo == T_ERROR) {
        error("no_declarada",$2);
      } else {
        $$ = id.tipo;
      }
    }
  ;

expresionSufija:          
    PARENTESISABIERTO_ expresion PARENTESISCERRADO_ { $$ = $2; }
  | ID_ operadorIncremento
    {
      $$ = T_ERROR;
      SIMB id = obtenerTDS($1);
      if (id.tipo == T_ERROR) {
        error("no_declarada",$1);
      } else {
        $$ = id.tipo;
      }
    }
  | ID_ CORCHETEABIERTO_ expresion CORCHETECERRADO_
      {
        $$ = T_ERROR;
        SIMB id = obtenerTDS($1);
        if (id.tipo == T_ERROR) {
          error("no_declarada",$1);
        } else {
            if($3 == T_ENTERO && id.tipo == T_ARRAY){
              $$ = id.telem;                                                                        
            } else{
              error("error_no_array",$1);
            }
        }
      }
  | ID_ 
      {
        $$ = T_ERROR;
        SIMB id = obtenerTDS($1);
        if (id.tipo == T_ERROR) {
          error("no_declarada",$1);
        } else {
          $$ = id.tipo;
        }
      }
  | constante { $$ = $1; }
  ;

constante:                  CTE_   { $$ = T_ENTERO; }
                          | TRUE_  { $$ = T_LOGICO; }
                          | FALSE_ { $$ = T_LOGICO; }
                          ;

operadorAsignacion:         IGUAL_      { $$ = T_VACIO; }
                          | MASIGUAL_   { $$ = T_ENTERO; }
                          | MENOSIGUAL_ { $$ = T_ENTERO; }
                          | MULTIGUAL_  { $$ = T_ENTERO; }
                          | DIVIGUAL_   { $$ = T_ENTERO; }
                          ;

operadorLogico:             AND_        { $$ = T_LOGICO; }
                          | OR_         { $$ = T_LOGICO; }
                          ;

operadorIgualdad:           IGUALIGUAL_  { $$ = T_VACIO; }
                          | NOIGUAL_     { $$ = T_VACIO; }
                          ;

operadorRelacional:         MAYOR_       { $$ = T_ENTERO; }
                          | MENOR_       { $$ = T_ENTERO; }
                          | MAYORIGUAL_  { $$ = T_ENTERO; }
                          | MENORIGUAL_  { $$ = T_ENTERO; }
                          ;

operadorAditivo:            MAS_        { $$ = T_ENTERO; }
                          | MENOS_      { $$ = T_ENTERO; }
                          ;

operadorMultiplicativo:     MULT_       { $$ = T_ENTERO; }
                          | DIV_        { $$ = T_ENTERO; }
                          | MODULO_     { $$ = T_ENTERO; }
                          ;

operadorUnario:             MAS_        { $$ = T_ENTERO; }
                          | MENOS_      { $$ = T_ENTERO; }
                          | NOT_        { $$ = T_LOGICO; }
                          ;

operadorIncremento:         MASMAS_     { $$ = T_ENTERO; }
                          | MENOSMENOS_ { $$ = T_ENTERO; }
                          ;

%%

/*
void yyerror(const char *msg) {
  fprintf(stderr, "\nError en la linea %d: %s\n", yylineno, msg);
}

int main (int argc, char **argv) {

  if (argc==2)
     if ((yyin = fopen (argv[1], "r")) == NULL) 
        fprintf (stderr, "Fichero no valido <%s>\n", argv[1]);
     else yyparse();
  else fprintf (stderr, "Uso: %s <fichero>\n",argv[0]);
  
  return 0 ;
}
*/