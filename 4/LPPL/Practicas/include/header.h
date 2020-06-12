/*****************************************************************************/
/*****************************************************************************/
#ifndef _HEADER_H
#define _HEADER_H

/**************************************************************** constantes */
#define TRUE 1
#define FALSE 0

/************************************** Tallas asociadas a los tipos simples */
#define TALLA_TIPO_SIMPLE 1

/************************************* Variables externas definidas en el AL */


extern int yylex();
extern int yyparse();
extern FILE *yyin;
extern int   yylineno;
extern char *yytext;

extern void yyerror(const char * msg) ;   /* Tratamiento de errores          */
extern void error(char *tipoError, char *string);
#endif  /* _HEADER_H */
/*****************************************************************************/
/*****************************************************************************/
