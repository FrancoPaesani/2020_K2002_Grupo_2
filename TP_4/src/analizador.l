  
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
TIPO_DATO char|double|float|int|long|short|struct|unsigned|typedef|signed|enum|union
FUNCIONES do|for|goto|if|else|sizeof|while|case|break|return|switch|default|continue
DATO_RETORNO void|static
CLASE_ALMACENAMIENTO auto|extern|register
MANEJO_DATO volatile|const

%%

[\n] {return '\n';}
"+" {return '+';}
"="  {return '=';}
{CARACTER_PUNTUACION} {printf("Encontre un caracter de puntuacion: %s\n",yytext);return CARACTER_PUNTUACION;}
{TIPO_DATO} {yylval.myStruct.valor_string = malloc(sizeof(yytext));strcpy(yylval.myStruct.valor_string,yytext);return RESERVADA;}
{FUNCIONES} {printf("Encontre una funcion: %s\n",yytext);return RESERVADA;}
{DATO_RETORNO} {printf("Encontre un tipo de dato de retorno: %s\n",yytext);return RESERVADA;}
{CLASE_ALMACENAMIENTO} {printf("Encontre una clase de almacenamiento: %s\n",yytext);return RESERVADA;}
{MANEJO_DATO} {printf("Encontre una forma de manejo de datos: %s\n",yytext);return RESERVADA;}
"//"[^\n]* {printf("Encontre una linea de comentarios: %s\n",yytext);}
[1-9]{DIGITO_DECIMAL}*/[^a-zA-Z] {yylval.myStruct.valor_entero = atoi(yytext);return NUM;}
0{DIGITO_OCTAL}*/[^a-zA-Z] {yylval.myStruct.valor_entero = atoi(yytext);return NUM;}
0[xX]{DIGITO_HEXADECIMAL}+/[^a-zA-Z] {return NUM;}
{DIGITO_DECIMAL}*\.{DIGITO_DECIMAL}+([Ee](\+|\-)?{DIGITO_DECIMAL}*)?/[^a-zA-Z] {return NUM;}
[a-zA-Z_][a-zA-Z0-9_]* {yylval.myStruct.valor_string = malloc(sizeof(yytext));strcpy(yylval.myStruct.valor_string,yytext);return ID;}
[.]* {printf("Caracter no reconocido %s.\n",yytext);return NO_RECONOCIDO;}
%%
