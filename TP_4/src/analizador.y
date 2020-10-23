%{
  #include <stdlib.h>
  #include <string.h>
  #include "utiles.h"

int yylex();
int yywrap(){
	return(1);
}

int valor;
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

%type <myStruct> expresion
%type <myStruct> declaracion

%%

input:    /* vacio */
        | input line
;

line:     '\n'
        | expresion '\n'  { printf ("\t %d\n", $1);}
        | declaracion '\n'
;

expresion: expUnaria operAsignacion expresion
                | expUnaria
;

operAsignacion: '='
                |"+="
;

expUnaria: expPostfijo
;
operUnario:     '&' 
                | '*'
                | '–'
                | '!'
;
expPostfijo: expPrimaria
;
listaArgumentos: expresion
;
expPrimaria:    ID    
                | NUM
        
;

declaracion:                    especificadoresDeclaracion listaDeclaradores    {printf("SE DECLARO LA VARIBLE <%s> DE TIPO --> %s con el valor = %i. ",$<myStruct>2.valor_string,$<myStruct>1.valor_string,valor);}
;
especificadoresDeclaracion:     /* vacio */
                                | especificadorAlmacenamiento especificadoresDeclaracion 
                                | especificadorTipo especificadoresDeclaracion
                                | calificadorTipo especificadoresDeclaracion
;
especificadorAlmacenamiento:    RESERVADA
;
especificadorTipo:              RESERVADA        
;
calificadorTipo:                RESERVADA
;
listaDeclaradores:              /* vacio */
                                | declarador
                                | listaDeclaradores , declarador
;
declarador:                     decla 
                                | decla '=' inicializador {valor = $<myStruct>3.valor_entero;}
;
inicializador:                  expresion
;
decla:                          declaradorDirecto
;
declaradorDirecto:              ID 
                                | '(' decla ')' 



%%

int main(){
    printf("------------------  Empieza main del BISON  ------------------\n");
    saludar();
    yyparse();
}
//    | ID operAsignacion NUM {printf("Se asigno el valor %i a la variable %s\n",$<myStruct>3.valor_entero,$<myStruct>1.valor_string);}
