%{
	#include <stdlib.h>
	#include <string.h>
  #include "utiles.h"

int yylex();

%}

/*
STRUCTS
*/

%%

/*
REGLAS
BISON
*/

%%

int main(){
    printf("------------------  Empieza main del BISON  ------------------\n");
    saludar();
    return yyparse();
}