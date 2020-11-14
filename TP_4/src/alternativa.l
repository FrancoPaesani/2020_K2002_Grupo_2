  
%{
	#include <stdlib.h>
	#include <string.h>
    #include "alternativa.tab.h"
    #include "utiles.h"
%}

SECUENCIA_ESCAPE_SIMPLE [\' | \" | \? | \\ | a | b | f | n | r | t | v]
DIGITO_DECIMAL [0-9]
DIGITO_OCTAL [0-7]
DIGITO_HEXADECIMAL [0-9a-fA-F]
ESCAPE_OCTAL {DIGITO_OCTAL}{DIGITO_OCTAL}?{DIGITO_OCTAL}?
ESCAPE_HEXADECIMAL x{DIGITO_HEXADECIMAL}{DIGITO_HEXADECIMAL}?
CONSTANTE_CARACTER ([^\'\\]|\\({SECUENCIA_ESCAPE_SIMPLE}|{ESCAPE_OCTAL}|{ESCAPE_HEXADECIMAL}))
CARACTER_PUNTUACION [(\[\]\(\)\{\}\.]|\-\>|\+\+|\-\-|[\&\*\+\-\~\!\/\%]|\<\<|\>\>|[\<\>]|\<\=|\>\=|\=\=|\!\=|^|\||\&\&|\|\||\=|\*\=|\/\=|\%\=|\+\=|\-\=|\<\<\=|\>\>\=|\&\=|\^\=|\|\=|\;        
ESPECIFICADORTIPOENTERO short|int|long|double|signed|unsigned
ESPECIFICADORTIPOFLOAT float 
ESPECIFICADORTIPOCADENA char
ESPECIFICADORTIPOVACIO void
ESPECIFICADORTIPOSTRUCT struct|union
DISTINTO \!\=
MASIGUAL \+\=
MAYOR \>
MENOR "<"
COMILLA \"
ASIGNACION \=

%%
{ESPECIFICADORTIPOENTERO}     {yylval.myStruct.tipo = 1; return ESPECIFICADORTIPOENTERO;}
{ESPECIFICADORTIPOFLOAT}	  {yylval.myStruct.tipo = 1; return ESPECIFICADORTIPOFLOAT;}
{ESPECIFICADORTIPOCADENA}	  {yylval.myStruct.tipo = 2; return ESPECIFICADORTIPOCADENA;}
{ESPECIFICADORTIPOVACIO}	  {yylval.myStruct.tipo = 0; return ESPECIFICADORTIPOVACIO;}
{ESPECIFICADORTIPOSTRUCT}     {yylval.myStruct.tipo = 3; return ESPECIFICADORTIPOSTRUCT;}
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
[a-zA-Z_][a-zA-Z0-9_]* {yylval.myStruct.valor_string = malloc(sizeof(yytext));strcpy(yylval.myStruct.valor_string,yytext); yylval.myStruct.tipo = 4; return IDENTIFICADOR;}
"&" {return AND;}
"*" {return POR;}
"+" {return MAS;}
"-" {return MENOS;}
"!=" {return DISTINTO;}
{ASIGNACION} {return ASIGNACION;}
{MASIGUAL} {return MASIGUAL;}
{MENOR} {printf("UN MENOR\n");return MENOR;}
{MAYOR} {return MAYOR;}
{COMILLA} {return COMILLA;}
";" {return ';';}
[\n] {return '\n';}
"." {return '.';}
"," {return ',';}
":" {return ':';}
"!" {return '!';}
"|" {return '|';}
"("	{return '(';}
")"	{return ')';}
"[" {return '[';}
"]" {return ']';}
"{" {return '{';}
"}" {return '}';}
"/" {return DIVISION;}
\".*\" {yylval.myStruct.tipo = 2;yylval.myStruct.valor_string = malloc(sizeof(yytext));strcpy(yylval.myStruct.valor_string,yytext);return CADENA;}
"//"[^\n]* {printf("Encontre una linea de comentarios: %s\n",yytext);}
[1-9]{DIGITO_DECIMAL}*/[^a-zA-Z] {yylval.myStruct.valor = atoi(yytext); yylval.myStruct.tipo = 1; return CONSTANTE;}
0{DIGITO_OCTAL}*/[^a-zA-Z] {yylval.myStruct.valor = atoi(yytext);return REAL;}
0[xX]{DIGITO_HEXADECIMAL}+/[^a-zA-Z] {return NUM;}
{DIGITO_DECIMAL}*\.{DIGITO_DECIMAL}+([Ee](\+|\-)?{DIGITO_DECIMAL}*)?/[^a-zA-Z] {yylval.myStruct.valor = atof(yytext); yylval.myStruct.tipo = 1; return NUM;}
[.]* {printf("Caracter no reconocido %s.\n",yytext);return NO_RECONOCIDO;}
%%



