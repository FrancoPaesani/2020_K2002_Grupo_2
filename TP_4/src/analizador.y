%{
  #include <stdlib.h>
  #include <string.h>
  #include "utiles.h"

int yylex();
int yywrap(){
	return(1);
}
%}

%union {

struct yylaval_struct{
        char* cadena;
        char* valor_string;
        int entero;
        int valor_entero;
}myStruct;

}

%token <myStruct> NUM
%token <myStruct> RESERVADA
%token <myStruct> ID
%token <myStruct> NO_RECONOCIDO
%token <myStruct> CARACTER_PUNTUACION

%type <myStruct> exp
%%

input:    /* vacio */
        | input line
;

line:     '\n'
        | exp '\n'  { printf ("\t %d\n", $1); }
;

exp:     NUM  {printf("Encontre un NUMERO Y APARECE--> %d\n",$<myStruct>1.valor_entero);}
        | ID  {printf("Encontre un ID --> %s\n",$<myStruct>1.valor_string);}
        | '=' {printf("Encontre un IGUAL");}
        | ID '=' NUM {printf("Se inicializ%c la variable %s con el valor %d\n",162,$<myStruct>1.valor_string,$<myStruct>3.valor_entero);}
;   

%%

int main(){
    printf("------------------  Empieza main del BISON  ------------------\n");
    saludar();
    yyparse();
}