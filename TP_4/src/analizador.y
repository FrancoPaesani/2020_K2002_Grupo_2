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
%token <myStruct> CONTINUE
%token <myStruct> FOR
%token <myStruct> GOTO
%token <myStruct> IF
%token <myStruct> ELSE
%token <myStruct> SIZEOF
%token <myStruct> WHILE
%token <myStruct> CASE
%token <myStruct> BREAK
%token <myStruct> RETURN
%token <myStruct> SWITCH
%token <myStruct> DEFAULT
%token <myStruct> UNION
%token <myStruct> ENUM
%token <myStruct> SIGNED
%token <myStruct> TYPEDEF
%token <myStruct> UNSIGNED
%token <myStruct> STRUCT
%token <myStruct> SHORT
%token <myStruct> LONG
%token <myStruct> INT
%token <myStruct> FLOAT
%token <myStruct> DOUBLE
%token <myStruct> CHAR
%token <myStruct> VOID
%token <myStruct> STATIC
%token <myStruct> AUTO
%token <myStruct> EXTERN
%token <myStruct> REGISTER
%token <myStruct> VOLATILE
%token <myStruct> CONST
%token <myStruct> DO





%type <myStruct> expresion
%type <myStruct> declaracion

%%

input:    /* vacio */
        | input line
;

line:     '\n'
        | expresion '\n'  { printf ("\t %d\n", $1);}
        | declaracion '\n'
        | sentencia '\n' {printf("entramos a una sentencia");}
;

//Empieza expresion
expresion: expUnaria operAsignacion expresion
                | expUnaria
                | /*vacio*/
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

//Empieza declaracion
declaracion:                    especificadoresDeclaracion listaDeclaradores    {printf("SE DECLARO LA VARIBLE <%s> DE TIPO --> %s con el valor = %i. \n",$<myStruct>2.valor_string,$<myStruct>1.valor_string,valor);}
;
especificadoresDeclaracion:     /* vacio */
                                | especificadorAlmacenamiento especificadoresDeclaracion 
                                | especificadorTipo especificadoresDeclaracion
                                | calificadorTipo especificadoresDeclaracion
;
especificadorAlmacenamiento:    "RESERVADA"
;
especificadorTipo:              "RESERVADA"
;
calificadorTipo:                "RESERVADA"
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
;

//Empieza sentencia
sentencia:                      sentenciaExp 
                                | sentenciaComp
                                | sentenciaSel
                                | sentenciaIt 
                                | sentenciaEtiq
                                | sentenciaSalto
;
sentenciaExp:                   expresion
;
sentenciaComp:                  '{' listaDeclaraciones listaSentencias '}'
;
listaDeclaraciones:             declaracion
                                | listaDeclaraciones declaracion
;
listaSentencias:                sentencia
                                | listaSentencias sentencia
;

sentenciaSel:                   IF '(' expresion ')' sentencia
                                | IF '(' expresion ')' sentencia ELSE sentencia
                                | SWITCH '(' expresion ')' sentencia
;
sentenciaIt:                    WHILE '(' expresion ')' sentencia
                                | DO sentencia WHILE '(' expresion ')' ';'
                                | FOR '(' expresion ';' expresion ';' expresion ')' sentencia
;
sentenciaEtiq:                  CASE expresion ':' sentencia
                                | DEFAULT ':' sentencia
                                | ID ':' sentencia
;
sentenciaSalto:                 CONTINUE ';' {printf("UN CONTINUE;\n");}
                                | BREAK ';'     {printf("Encontre un break brrr;\n");}
                                | RETURN expresion ';'
                                | GOTO ID ';'
;

%%

int main(){
    printf("------------------  Empieza main del BISON  ------------------\n");
    saludar();
    yyparse();
}
