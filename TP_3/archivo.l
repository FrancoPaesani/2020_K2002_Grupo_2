%option noyywrap

%{

#include <stdio.h>
#include <stdlib.h>
#include "funciones.h"

 tipoLista *listaId=NULL;
 tipoLista *listaCadenas=NULL;
 tipoLista *cola=NULL;
 tipoLista *colaCaracter=NULL;
 tipoLista *colaComentSimple=NULL;
 tipoLista *colaComentVarias=NULL;
 tipoLista *listaDecimal=NULL;
 tipoLista *listaOctal=NULL;
 tipoLista *listaHexa=NULL;
 tipoLista *listaReal=NULL; 
 tipoLista *listaPuntuacion=NULL; 

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
CARACTER_PUNTUACION [(\[\]\(\)\{\}\.]|\-\>|\+\+|\-\-|[\&\*\+\-\~\!\/\%]|\<\<|\>\>|[\<\>]|\<\=|\>\=|\=\=|\!\=|^|\||\&\&|\|\||\=|\*\=|\/\=|\%\=|\+\=|\-\=|\<\<\=|\>\>\=|\&\=|\^\=|\|\=|\;        
TIPO_DATO char|double|float|int|long|short|struct|unsigned|typedef|signed|enum|union
FUNCIONES do|for|goto|if|else|sizeof|while|case|break|return|switch|default|continue
DATO_RETORNO void|static
CLASE_ALMACENAMIENTO auto|extern|register
MANEJO_DATO volatile|const

%%
	struct Info b;
	char *acum=NULL;
	int n=0;

\'{CONSTANTE_CARACTER}\' {printf("Encontre una constante caracter: %s\n",yytext);colaCaracter=insertaPalabraReservada(colaCaracter,yytext,b,"ConstanteCaracter");}
[\"]{CONSTANTE_CARACTER}+[\"]  {printf("Encontre un literal cadena: %s\n",yytext);
 b.cadena=malloc(sizeof(yytext));									
strcpy(b.cadena,yytext);													
b.tipo="Literal Cadena";b.extra=strlen(yytext)-2;listaCadenas=insertarPrimero(listaCadenas,b);}
{CARACTER_PUNTUACION} {printf("Encontre un caracter de puntuacion: %s\n",yytext);listaPuntuacion=insertarLista(listaPuntuacion,yytext,b,"CaracterPuntuacion");}
{TIPO_DATO} {printf("Encontre un tipo de dato: %s\n",yytext);cola=insertaPalabraReservada(cola,yytext,b,"TipoDeDato");}
{FUNCIONES} {printf("Encontre una funcion: %s\n",yytext);cola=insertaPalabraReservada(cola,yytext,b,"Funcion");}
{DATO_RETORNO} {printf("Encontre un tipo de dato de retorno: %s\n",yytext);cola=insertaPalabraReservada(cola,yytext,b,"PalabraReservada");}
{CLASE_ALMACENAMIENTO} {printf("Encontre una clase de almacenamiento: %s\n",yytext);cola=insertaPalabraReservada(cola,yytext,b,"ClaseAlmacenamiento");}
{MANEJO_DATO} {printf("Encontre una forma de manejo de datos: %s\n",yytext);cola=insertaPalabraReservada(cola,yytext,b,"ManejoDato");}
\/\/[^\n]* {printf("Encontre una linea de comentarios: %s\n",yytext);
colaComentSimple=insertaPalabraReservada(colaComentSimple,yytext,b,"ComentarioSimple");}  
\/\*    {BEGIN(comentarioVarias);acum=yytext;}
<comentarioVarias>[^\*]* 
<comentarioVarias>\*+[^\/]*
<comentarioVarias>\*\/   {{printf("Encontre varias lineas de comentarios: %s\n",acum);}BEGIN(INITIAL);
colaComentVarias=insertaPalabraReservada(colaComentVarias,acum,b,"ComentarioVarios");}
[1-9]{DIGITO_DECIMAL}* {printf("Encontre una constante entera decimal %s \n",yytext);
listaDecimal=insertarLista(listaDecimal,yytext,b,"Digito Decimal");}
0{DIGITO_OCTAL}* {printf("Encontre una constante entera octal %s \n",yytext);
listaOctal=insertarLista(listaOctal,yytext,b,"Digito Octal");}
0[xX]{DIGITO_HEXADECIMAL}+ {printf("Encontre una constante entera hexadecimal \n");
listaHexa=insertarLista(listaHexa,yytext,b,"Digito Hexadecimal");}
{DIGITO_DECIMAL}*\.{DIGITO_DECIMAL}+([Ee](\+|\-)?{DIGITO_DECIMAL}*)? {printf("Encontre una constante real: %s\n",yytext);
listaReal=insertarLista(listaReal,yytext,b,"Digito Real");}
[a-zA-Z_][a-zA-Z0-9_]* {printf("Encontre un identificador: %s\n",yytext);
listaId=insertarLista(listaId,yytext,b,"Identificador");}
[.]* {printf("Caracter no reconocido %s",yytext);}
%%

int main(){

     yyin = fopen("entrada.txt", "r");
     yylex();
	 muestra(cola);
     muestra(listaId);
	 muestraCadena(listaCadenas);
	/* muestraNumeros(listaDecimal,strtol,"Decimal",10);
	 muestraNumeros(listaOctal,strtol,"Octal",8);
	 muestraNumeros(listaHexa,strtol,"Hexadecimal",16);
	 muestraNumeros(listaReal,strtol,"Real",0);*/
	 muestra(colaCaracter);
	 muestra(listaPuntuacion);
	 muestra(colaComentSimple);
	 muestra(colaComentVarias);
}