/*****************************************************************************/
/**  Ejemplo de FLEX: S E M - 1             2018-2019 <jbenedi@dsic.upv.es> **/
/*****************************************************************************/
%{
#include <stdio.h>
#include <string.h>
#include "header.h"
#include "asin.h"
%}
/*----------------------------------------------------------------------
  Dado que las funciones "input()" y "unput(c)" son costosas y no las
  utilizaremos, evitaremos que se generen automaticamente sus rutinas
  correspondientes desactivandolas mediante las siguientes opciones:
----------------------------------------------------------------------*/
%option noinput
%option nounput
/*----------------------------------------------------------------------
  Para mantener el numero de linea actual en la variable global yylineno
----------------------------------------------------------------------*/
%option yylineno

%%
"//".*                        { ECHO; } // Comentario que se elimina
[ \t\n]+                      { ECHO; }
"true"                        { ECHO; return(TRUE_); }
"false"                       { ECHO; return(FALSE_); }
"int"                         { ECHO; return(INT_); }
"bool"                        { ECHO; return(BOOL_); }
"="                           { ECHO; return(IGUAL_); }
"+="                          { ECHO; return(MASIGUAL_); }
"-="                          { ECHO; return(MENOSIGUAL_); }
"*="                          { ECHO; return(MULTIGUAL_); }
"/="                          { ECHO; return(DIVIGUAL_); }
"&&"                          { ECHO; return(AND_); }
"||"                          { ECHO; return(OR_); }
"=="                          { ECHO; return(IGUALIGUAL_); }
"!="                          { ECHO; return(NOIGUAL_); }
">"                           { ECHO; return(MAYOR_); }
"<"                           { ECHO; return(MENOR_); }
">="                          { ECHO; return(MAYORIGUAL_); }
"<="                          { ECHO; return(MENORIGUAL_); }
"+"                           { ECHO; return(MAS_); }
"-"                           { ECHO; return(MENOS_); }
"*"                           { ECHO; return(MULT_); }
"/"                           { ECHO; return(DIV_); }
"%"                           { ECHO; return(MODULO_); }
"!"                           { ECHO; return(NOT_); }
"++"                          { ECHO; return(MASMAS_); }
"--"                          { ECHO; return(MENOSMENOS_); }
";"                           { ECHO; return(PUNTOCOMA_); }
"{"                           { ECHO; return(LLAVEABIERTA_); }
"}"                           { ECHO; return(LLAVECERRADA_); }
"["                           { ECHO; return(CORCHETEABIERTO_); }
"]"                           { ECHO; return(CORCHETECERRADO_); }
"("                           { ECHO; return(PARENTESISABIERTO_); }
")"                           { ECHO; return(PARENTESISCERRADO_); }
"read"                        { ECHO; return(READ_); }
"print"                       { ECHO; return(PRINT_); }
"if"                          { ECHO; return(IF_); }
"else"                        { ECHO; return(ELSE_); }
"for"                         { ECHO; return(FOR_); }
[0-9]+                        { 
                                ECHO;
                                // Guardamos en el atributo "entero" la parte entera
                                // del lexema leido.
                                yylval.entero = atoi(yytext);
                                return(CTE_);
                              }
[0-9]*"."[0-9]+               { 
                                ECHO;
                                // Guardamos en el atributo "entero" la parte entera
                                // del lexema leido.
                                yylval.entero = atoi(yytext);
                                return(CTE_);
                              }
[a-zA-Z][0-9a-z_A-Z]*         {
                                ECHO; 
                                // Guardamos en el atributo "string" lo que haya en el lexema yytext
                                // (es decir, guardamos el nombre del id)
                                yylval.string = strdup(yytext); 
                                return(ID_);
                              }
%%