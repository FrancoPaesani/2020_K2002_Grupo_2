  
%{
	#include <stdlib.h>
	#include <string.h>
    #include "analizador.tab.h"
    #include "utiles.h"
%}

NOVA .
SECUENCIA_ESCAPE_SIMPLE [\' | \" | \? | \\ | a | b | f | n | r | t | v]
DIGITO_DECIMAL [0-9]
DIGITO_OCTAL [0-7]
DIGITO_HEXADECIMAL [0-9a-fA-F]
ESCAPE_OCTAL {DIGITO_OCTAL}{DIGITO_OCTAL}?{DIGITO_OCTAL}?
ESCAPE_HEXADECIMAL x{DIGITO_HEXADECIMAL}{DIGITO_HEXADECIMAL}?
CONSTANTE_CARACTER ([^\'\\]|\\({SECUENCIA_ESCAPE_SIMPLE}|{ESCAPE_OCTAL}|{ESCAPE_HEXADECIMAL}))
CARACTER_PUNTUACION [(\[\]\(\)\{\}\.]|\-\>|\+\+|\-\-|[\&\*\+\-\~\!\/\%]|\<\<|\>\>|[\<\>]|\<\=|\>\=|\=\=|\!\=|^|\||\&\&|\|\||\=|\*\=|\/\=|\%\=|\+\=|\-\=|\<\<\=|\>\>\=|\&\=|\^\=|\|\=|\;        
CONTINUE continue
FOR for
GOTO goto
IF if
ELSE else
SIZEOF sizeof
WHILE while
CASE case
BREAK break
RETURN return
SWITCH switch
DEFAULT default
UNION union
ENUM enum
SIGNED signed
TYPEDEF typedef
UNSIGNED unsigned
STRUCT struct
SHORT short
LONG long
INT int
FLOAT float
DOUBLE double
CHAR char
VOID void
STATIC static
AUTO auto
EXTERN extern
REGISTER register
VOLATILE volatile
CONST const
DO do
AND \&
POR \*
MAS \+
MENOS \-
DISTINTO \!
IGUAL \=
MASIGUAL \+\=
ESPECIFICADORCLASE typedef|static|auto|register|extern
ESPECIFICADORTIPO void|char|short|int|long|float|double|signed|unsigned
CALIFICADORTIPO const|volatile
ESPSTRUCTUNION struct|union
CORCHETEC "["
CORCHETEA "]"
PARENTESISC \)
PARENTESISA \(
MAYOR \>
MENOR "<"
COMILLA \"
PUNTOCOMA \;

%%
{ESPECIFICADORCLASE}    {yylval.myStruct.especificador = malloc(sizeof(yytext));strcpy(yylval.myStruct.especificador,yytext);return ESPECIFICADORCLASE;}
{ESPECIFICADORTIPO}     {yylval.myStruct.especificador = malloc(sizeof(yytext));strcpy(yylval.myStruct.especificador,yytext);return ESPECIFICADORTIPO;}
{CALIFICADORTIPO}       {yylval.myStruct.especificador = malloc(sizeof(yytext));strcpy(yylval.myStruct.especificador,yytext);return CALIFICADORTIPO;}
{ESPSTRUCTUNION}        {yylval.myStruct.especificador = malloc(sizeof(yytext));strcpy(yylval.myStruct.especificador,yytext);return ESPSTRUCTUNION;}
"sizeof"                {return SIZEOF;}
"break"                 {return BREAK;}  
"case"                  {return CASE;}  
"continue"              {return CONTINUE;}    
"default"               {return DEFAULT;}
"do"                    {return DO;}
"double"                {return DOUBLE;}
"else"                  {return ELSE;}
"enum"                  {return ENUM;}
"for"                   {return FOR;}
"goto"                  {return GOTO;}
"if"                    {return IF;}
"return"                {return RETURN;}
"switch"                {return SWITCH;}
"while"                 {printf("UNWHILE FLEX\n");return WHILE;}
[a-zA-Z_][a-zA-Z0-9_]* {yylval.myStruct.valor_string = malloc(sizeof(yytext));strcpy(yylval.myStruct.valor_string,yytext);return ID;}
{AND} {return AND;}
{POR} {return POR;}
{MAS} {return MAS;}
{MENOS} {return MENOS;}
{DISTINTO} {return DISTINTO;}
{IGUAL} {return IGUAL;}
{MASIGUAL} {return MASIGUAL;}
{MENOR} {printf("UN MENOR\n");return MENOR;}
{MAYOR} {return MAYOR;}
{PARENTESISA} {return PARENTESISA;}
{PARENTESISC} {return PARENTESISC;}
{COMILLA} {return COMILLA;}
{PUNTOCOMA} {return PUNTOCOMA;}
[\n] {return '\n';}
"-" {return '-';}
"." {return '.';}
"," {return ',';}
":" {return ':';}
"!" {return '!';}
"|" {return '|';}
"[" {return CORCHETEA;}
"]" {return CORCHETEC;}
"{" {return '{';}
"}" {return '}';}
"*" {return '*';}
"//"[^\n]* {printf("Encontre una linea de comentarios: %s\n",yytext);}
[1-9]{DIGITO_DECIMAL}*/[^a-zA-Z] {yylval.myStruct.valor_entero = atoi(yytext);return NUM;}
0{DIGITO_OCTAL}*/[^a-zA-Z] {yylval.myStruct.valor_entero = atoi(yytext);return NUM;}
0[xX]{DIGITO_HEXADECIMAL}+/[^a-zA-Z] {return NUM;}
{DIGITO_DECIMAL}*\.{DIGITO_DECIMAL}+([Ee](\+|\-)?{DIGITO_DECIMAL}*)?/[^a-zA-Z] {return NUM;}
[.]* {printf("Caracter no reconocido %s.\n",yytext);return NO_RECONOCIDO;}
%%
