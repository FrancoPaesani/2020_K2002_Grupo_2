%option noyywrap

%{

#include <stdio.h>
#include <stdlib.h>
#include "funciones.h"

tipoLista *liste=NULL;
 tipoLista *list=NULL;
 	struct Info d;
	struct Info a;
	struct Info c;
%}

%%
	int n=0;
[1-9][0-9]* {printf("Encontre una constante entera decimal \n");n++;}
0[0-7]* {printf("Encontre una constante entera octal \n");}
0[xX][0-9a-fA-F]+ {printf("Encontre una constante entera hexadecimal \n");}
[a-zA-Z_][a-zA-Z0-9_]* {printf("Encontre un identificador: %s\n",yytext);n++;
struct Info b;b.cadena=malloc(sizeof(yytext));									//reservo memoria de la longitud del identificador
strcpy(b.cadena,yytext);														//copio el char* a nuestro struct
b.tipo="Identificador";b.extra=0;
liste=insertarOrdenadoeIncrementa(liste,b);b.cadena="";b.tipo="";}				//inserto el struct en la lista ordenada o incremento existente
[0-9]*\.[0-9]+ {printf("Encontre una constante real \n");}


%%

int main(){

     yyin = fopen("entrada.txt", "r");
     yylex();
     muestra(liste);

}
