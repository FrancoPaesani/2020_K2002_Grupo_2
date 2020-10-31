  
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

%%

"auto"              {return AUTO;}
"break"             {return BREAK;}  
"case"              {return CASE;}  
"char"              {return CHAR;}
"const"             {return CONST;}
"continue"          {return CONTINUE;}    
"default"           {return DEFAULT;}
"do"                {return DO;}
"double"            {return DOUBLE;}
"else"              {return ELSE;}
"enum"              {return ENUM;}
"extern"            {return EXTERN;}
"float"             {return FLOAT;}
"for"               {return FOR;}
"goto"              {return GOTO;}
"if"                {return IF;}
"int"               {return INT;}
"long"              {return LONG;}
"register"          {return REGISTER;}
"return"            {return RETURN;}
"short"             {return SHORT;}
"signed"            {return SIGNED;}
"static"            {return STATIC;}
"struct"            {return STRUCT;}
"switch"            {return SWITCH;}
"typedef"           {return TYPEDEF;}
"union"             {return UNION;}
"unsigned"          {return UNSIGNED;}
"void"              {return VOID;}
"volatile"          {return VOLATILE;}
"while"             {return WHILE;}
[\n] {return '\n';}
"+" {return '+';}
"-" {return '-';}
"." {return '.';}
"," {return ',';}
":" {return ':';}
"!" {return '!';}
"(" {return '(';}
")" {return ")";}
"-" {return '-';}
";" {return ';';}
"=" {return '=';}
"="  {return '=';}
{CARACTER_PUNTUACION} {printf("Encontre un caracter de puntuacion: %s\n",yytext);return CARACTER_PUNTUACION;}
"//"[^\n]* {printf("Encontre una linea de comentarios: %s\n",yytext);}
[1-9]{DIGITO_DECIMAL}*/[^a-zA-Z] {yylval.myStruct.valor_entero = atoi(yytext);return NUM;}
0{DIGITO_OCTAL}*/[^a-zA-Z] {yylval.myStruct.valor_entero = atoi(yytext);return NUM;}
0[xX]{DIGITO_HEXADECIMAL}+/[^a-zA-Z] {return NUM;}
{DIGITO_DECIMAL}*\.{DIGITO_DECIMAL}+([Ee](\+|\-)?{DIGITO_DECIMAL}*)?/[^a-zA-Z] {return NUM;}
[a-zA-Z_][a-zA-Z0-9_]* {yylval.myStruct.valor_string = malloc(sizeof(yytext));strcpy(yylval.myStruct.valor_string,yytext);return ID;}
[.]* {printf("Caracter no reconocido %s.\n",yytext);return NO_RECONOCIDO;}
%%
