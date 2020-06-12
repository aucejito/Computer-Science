/* A Bison parser, made by GNU Bison 3.0.5.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_YY_ASIN_H_INCLUDED
# define YY_YY_ASIN_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    CTE_ = 258,
    TRUE_ = 259,
    FALSE_ = 260,
    BOOL_ = 261,
    INT_ = 262,
    ID_ = 263,
    PUNTOCOMA_ = 264,
    LLAVEABIERTA_ = 265,
    LLAVECERRADA_ = 266,
    CORCHETEABIERTO_ = 267,
    CORCHETECERRADO_ = 268,
    PARENTESISABIERTO_ = 269,
    PARENTESISCERRADO_ = 270,
    IGUAL_ = 271,
    MASIGUAL_ = 272,
    MENOSIGUAL_ = 273,
    MULTIGUAL_ = 274,
    DIVIGUAL_ = 275,
    AND_ = 276,
    OR_ = 277,
    NOT_ = 278,
    IF_ = 279,
    ELSE_ = 280,
    FOR_ = 281,
    IGUALIGUAL_ = 282,
    NOIGUAL_ = 283,
    MAYOR_ = 284,
    MENOR_ = 285,
    MAYORIGUAL_ = 286,
    MENORIGUAL_ = 287,
    MAS_ = 288,
    MENOS_ = 289,
    MASMAS_ = 290,
    MENOSMENOS_ = 291,
    READ_ = 292,
    PRINT_ = 293,
    MULT_ = 294,
    DIV_ = 295,
    MODULO_ = 296
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 13 "src/asin.y" /* yacc.c:1910  */

  char* string;
  int entero;

#line 101 "asin.h" /* yacc.c:1910  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_ASIN_H_INCLUDED  */
