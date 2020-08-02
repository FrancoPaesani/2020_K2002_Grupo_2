%option noyywrap

%{

#include <stdio.h>
#include <stdlib.h>
#include "funciones.h"

tipoLista *listaId=NULL;
 tipoLista *listaCadenas=NULL;
 	struct Info d;
	struct Info a;
	struct Info c;
%}

%s comentarioVarias
SECUENCIA_ESCAPE_SIMPLE [\' | \" | \? | \\ | a | b | f | n | r | t | v]
DIGITO_DECIMAL [0-9]
DIGITO_OCTAL [0-7]
DIGITO_HEXADECIMAL [0-9a-fA-F]
ESCAPE_OCTAL {DIGITO_OCTAL}{DIGITO_OCTAL}?{DIGITO_OCTAL}?
ESCAPE_HEXADECIMAL x{DIGITO_HEXADECIMAL}{DIGITO_HEXADECIMAL}?
CONSTANTE_CARACTER ([^\'\\]|\\({SECUENCIA_ESCAPE_SIMPLE}|{ESCAPE_OCTAL}|{ESCAPE_HEXADECIMAL}))
CARACTER_PUNTUACION [(\[\]\(\)\{\}\.]|\-\>|\+\+|\-\-|[\&\*\+\-\~\!\/\%]|\<\<|\>\>|[\<\>]|\<\=|\>\=|\=\=|\!\=|^|\||\&\&|\|\||\=|\*\=|\/\=|\%\=|\+\=|\-\=|\<\<\=|\>\>\=|\&\=|\^\=|\|\=        
TIPO_DATO char|double|float|int|long|short|struct|unsigned|typedef|signed|enum|union
FUNCIONES do|for|goto|if|else|sizeof|while|case|break|return|switch|default|continue
DATO_RETORNO void|static
CLASE_ALMACENAMIENTO auto|extern|register
MANEJO_DATO volatile|const

%%
	struct Info b;
	int n=0;

\'{CONSTANTE_CARACTER}\' {printf("Encontre una constante caracter: %s\n",yytext);}
[\"]{CONSTANTE_CARACTER}+[\"]  {printf("Encontre un literal cadena: %s\n",yytext);
 b.cadena=malloc(sizeof(yytext));									
strcpy(b.cadena,yytext);													
b.tipo="Literal Cadena";b.extra=strlen(yytext)-2;listaCadenas=insertarPrimero(listaCadenas,b);}
{CARACTER_PUNTUACION} {printf("Encontre un caracter de puntuacion: %s\n",yytext);}
{TIPO_DATO} {printf("Encontre un tipo de dato: %s\n",yytext);}
{FUNCIONES} {printf("Encontre una funcion: %s\n",yytext);}
{DATO_RETORNO} {printf("Encontre un tipo de dato de retorno: %s\n",yytext);}
{CLASE_ALMACENAMIENTO} {printf("Encontre una clase de almacenamiento: %s\n",yytext);}
{MANEJO_DATO} {printf("Encontre una forma de manejo de datos: %s\n",yytext);}
\/\/[^\n]* {printf("Encontre una linea de comentarios: %s\n",yytext);}  
\/\*    {BEGIN(comentarioVarias);}
<comentarioVarias>[^\*]* 
<comentarioVarias>\*+[^\/]*
<comentarioVarias>\*\/   {{printf("Encontre varias lineas de comentarios: %s\n",yytext);}BEGIN(INITIAL);}
[1-9]{DIGITO_DECIMAL}* {printf("Encontre una constante entera decimal \n");}
0{DIGITO_OCTAL}* {printf("Encontre una constante entera octal \n");}
0[xX]{DIGITO_HEXADECIMAL}+ {printf("Encontre una constante entera hexadecimal \n");}
{DIGITO_DECIMAL}*\.{DIGITO_DECIMAL}+([Ee](\+|\-)?{DIGITO_DECIMAL}*)? {printf("Encontre una constante real: %s\n",yytext);}
[a-zA-Z_][a-zA-Z0-9_]* {printf("Encontre un identificador: %s\n",yytext);n++;
b.cadena=malloc(sizeof(yytext));									//reservo memoria de la longitud del identificador
strcpy(b.cadena,yytext);														//copio el char* a nuestro struct
b.tipo="Identificador";b.extra=0;
listaId=insertarOrdenadoeIncrementa(listaId,b);}				//inserto el struct en la lista ordenada o incremento existente
%%

int main(){

     yyin = fopen("entrada.txt", "r");
     yylex();
     muestraID(listaId);
	 muestraCadena(listaCadenas);

}
