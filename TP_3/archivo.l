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

[1-9][0-9]* {printf("Encontre una constante entera decimal \n");}
0[0-7]* {printf("Encontre una constante entera octal \n");}
0[xX][0-9a-fA-F]+ {printf("Encontre una constante entera hexadecimal \n");}
[a-zA-Z_][a-zA-Z0-9_]* {printf("Encontre un identificador: %s\n",yytext);printf(" -> EL ID ES UN CHAR?: %i\n",strcmpi(yytext,"a"));
struct Info b;b.tipo="Identificador";b.cadena=yytext;b.extra=0;
liste=insertarOrdenadoeIncrementa(liste,b);b.cadena="";b.tipo="";}
[0-9]*\.[0-9]+ {printf("Encontre una constante real \n");}


%%

int main(){

     yyin = fopen("entrada.txt", "r");
     yylex();
     muestra(liste);
     
/*
	d.tipo="Identificador";
	d.cadena="ii";
	d.extra=0;
	a.tipo="Identificador";
	a.cadena="ii";
	a.extra=0;
	c.tipo="Identificador";
	c.cadena="Hh";
	c.extra=0;
	list=insertarOrdenadoeIncrementa(list,d);
	list=insertarOrdenadoeIncrementa(list,a);
	list=insertarOrdenadoeIncrementa(list,c);
	muestra(list);
*/
}