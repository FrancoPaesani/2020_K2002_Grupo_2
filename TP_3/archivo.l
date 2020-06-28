%option noyywrap

%{

#include <stdio.h>
#include "funciones.h"

LISTA *lista = NULL;

%}

%%

[1-9][0-9]* {printf("Encontre una constante entera decimal \n");insertarALista(lista,yytext);}
0[0-7]* {printf("Encontre una constante entera octal \n");}
0[xX][0-9a-fA-F]+ {printf("Encontre una constante entera hexadecimal \n");}
[a-zA-Z_][a-zA-Z0-9_]* {printf("Encontre un identificador \n");}
[0-9]*\.[0-9]+ {printf("Encontre una constante real \n");}



%%


int main(){
   

lista = malloc(sizeof(tipoNodo));  
 yyin = fopen("entrada.txt", "r");
 yyout = fopen("salida.txt", "w");

   yylex();

    mostrarLista(lista);


 return 0;
}