%{
  #include <stdlib.h>
  #include <string.h>
  #include "utiles.h"

int yylex();
int yywrap(){
	return(1);
}

int valor;
int api;
symrec* aux;
%}

%union {

struct yylaval_struct{
        char charcito;
        char* cadena;
        char* valor_string;
        char* operador;
        char* especificador;
        char* puntuacion;
        int entero;
        int valor_entero;
        //struct symrec *sval;
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
%token <myStruct> AND
%token <myStruct> POR
%token <myStruct> MENOS
%token <myStruct> DISTINTO
%token <myStruct> IGUAL
%token <myStruct> MASIGUAL
%token <especificador> ESPECIFICADORCLASE
%token <especificador> ESPECIFICADORTIPO
%token <especificador> CALIFICADORTIPO
%token <especificador> ESPSTRUCTUNION
%token <puntuacion> CORCHETEA
%token <puntuacion> CORCHETEC
%token <puntuacion> PARENTESISA
%token <puntuacion> PARENTESISC
%token <puntuacion> MENOR
%token <puntuacion> MAYOR
%token <puntuacion> MAS
%token <puntuacion> COMILLA

%type <myStruct> expresion
%type <myStruct> declaracion

%right IGUAL
%%

input:    /* vacio */
        | input line
;

line:     '\n'
        | expresion '\n' {printf("\n expresion goes brrr\n");}
        | declaracion '\n' {printf("encontramos una declaracion\n");}
        | sentencia '\n' {printf("entramos a una sentencia\n");}
;

//Empieza expresion
expresion:                      expresionAsignacion
                                | expresion ',' expresionAsignacion
;
expresionAsignacion:            expresionCondicional
                                | expresionUnaria operAsignacion expresionAsignacion
                                | /*vacio*/
;
expresionCondicional:           expresionOLogico
                                | expresionOLogico expresion ':' expresionCondicional
                                | expresion ':' expresionCondicional
;
expresionConstante:             expresionCondicional
                                | /*    vacio   */
;
expresionOLogico:               expresionYLogico
                                | expresionOLogico '|''|' expresionYLogico
;
expresionYLogico:               expresionOInclusivo
                                | expresionYLogico AND AND expresionOInclusivo              
;
expresionOInclusivo:            expresionOExcluyente
                                | expresionOInclusivo '|' expresionOExcluyente
;
expresionOExcluyente:           expresionY
                                | expresionOExcluyente '^' expresionY
;
expresionY:                     expresionIgualdad
                                | expresionY AND expresionIgualdad
;
expresionIgualdad:              expresionRelacional
                                | expresionIgualdad IGUAL IGUAL expresionRelacional
                                | expresionIgualdad DISTINTO IGUAL expresionRelacional
;
expresionRelacional:            expresionCorrimiento
                                | expresionRelacional MENOR expresionCorrimiento
                                | expresionRelacional MAYOR expresionCorrimiento
                                | expresionRelacional MENOR IGUAL expresionCorrimiento
                                | expresionRelacional MAYOR IGUAL expresionCorrimiento
;
expresionCorrimiento:           expresionAditiva
                                | expresionCorrimiento MENOR MENOR expresionAditiva
                                | expresionCorrimiento MAYOR MAYOR expresionAditiva
;
expresionAditiva:               expresionMultiplicativa
                                | expresionAditiva MAS expresionMultiplicativa
                                | expresionAditiva MENOS expresionMultiplicativa
;
expresionMultiplicativa:        expresionConversion
                                | expresionMultiplicativa POR expresionConversion
                                | expresionMultiplicativa '/' expresionConversion
                                | expresionMultiplicativa '%' expresionConversion
;
expresionConversion:            expresionUnaria
                                | PARENTESISA nombreTipo PARENTESISC expresionConversion             
;
expresionUnaria:                expresionSufijo
                                | MAS MAS expresionUnaria
                                | MENOS MENOS expresionUnaria
                                | operadorUnario expresionConversion
                                | SIZEOF expresionUnaria
                                | SIZEOF PARENTESISA nombreTipo PARENTESISC
;
expresionSufijo:                expresionPrimaria
                                | expresionSufijo CORCHETEA expresion CORCHETEC
                                | expresionSufijo PARENTESISA listaArgumentos PARENTESISC
                                | expresionSufijo '.' ID
                                | expresionSufijo MENOS MAYOR ID
                                | expresionSufijo MAS MAS
                                | expresionSufijo MENOS MENOS
;
expresionPrimaria:              ID
                                | NUM   {valor = $<myStruct>1.valor_entero;}
                           //     |  constante 
                                | COMILLA ID COMILLA
                                | PARENTESISA expresion PARENTESISC
;
nombreTipo:                     /* completar    */
;
operAsignacion:                 IGUAL  
                                | MASIGUAL
;
operadorUnario:                 AND
                                | POR
                                | MENOS
                                | DISTINTO
;
listaArgumentos:                expresionAsignacion
                                | listaArgumentos ',' expresionAsignacion
;

//Empieza declaracion
declaracion:                    especificadoresDeclaracion listaDeclaradores    //{printf("SE DECLARO LA VARIBLE <%s> DE TIPO --> %s con el valor = %i. \n",$<myStruct>2.valor_string,$<myStruct>1.especificador,valor);}
;
especificadoresDeclaracion:     especificadorAlmacenamiento especificadoresDeclaracion
                                | especificadorTipo especificadoresDeclaracion
                                | calificadorTipo especificadoresDeclaracion
                                | /* vacio */
;
especificadorAlmacenamiento:    ESPECIFICADORCLASE
;
especificadorTipo:              ESPECIFICADORTIPO
;
calificadorTipo:                CALIFICADORTIPO
;
listaDeclaradores:              declarador
                                | listaDeclaradores ',' declarador
                                | /* vacio */
;
declarador:                     decla 
                                | decla IGUAL inicializador {valor = $<myStruct>3.valor_entero;} //analizar si existe inicializador en caso de ser ID
;
inicializador:                  expresionAsignacion
                                | '{' listaInicializadores ',' '}'
;
listaInicializadores:           inicializador
                                | listaInicializadores ',' inicializador
;
puntero:                        POR listaCalificadoresTipo
                                | POR listaCalificadoresTipo puntero
                                | /*    vacio   */
;
listaCalificadoresTipo:         calificadorTipo
                                | listaCalificadoresTipo calificadorTipo
                                | /*    vacio   */
;
decla:                          puntero declaradorDirecto
                                | declaradorDirecto
;
declaradorDirecto:              PARENTESISA decla PARENTESISC {printf("parentesis DECLA\n");}
                                | declaradorDirecto CORCHETEA expresionConstante CORCHETEC {printf("Corchete decla\n");}
                                | ID {printf("ID EN DECLA DIRECTO\n\n");aux = getsym($<myStruct>1.valor_string);if(aux){printf("La variable ya se encuentra declarada. Error de doble declaracion.");} else{putsym($<myStruct>1.valor_string,api,valor,NULL);printf("Declarada nueva variables -->%s\n",$<myStruct>1.valor_string);aux = getsym($<myStruct>1.valor_string);printf("\nElemento en AUX %s con valor %i\n",aux->name,aux->valor);}}
;
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//Empieza sentencia
sentencia:                      sentenciaExp   
                                | sentenciaComp
                                | sentenciaSel
                                | sentenciaIt 
                                | sentenciaEtiq
                                | sentenciaSalto
;
sentenciaExp:                   expresion ';'
                                ';'
;
sentenciaComp:                  '{' listaDeclaraciones listaSentencias '}'
;
listaDeclaraciones:             declaracion
                                | listaDeclaraciones declaracion
                                | /* vacio */
;
listaSentencias:                sentencia
                                | listaSentencias sentencia
                                | /* vacio  */
;

sentenciaSel:                   IF PARENTESISA expresion PARENTESISC sentencia
                                | IF PARENTESISA expresion PARENTESISC sentencia ELSE sentencia
                                | SWITCH PARENTESISA expresion PARENTESISC sentencia
;
sentenciaIt:                    WHILE PARENTESISA expresion PARENTESISC sentencia
                                | DO sentencia WHILE PARENTESISA expresion PARENTESISC ';'
                                | FOR PARENTESISA expresion ';' expresion ';' expresion PARENTESISC sentencia
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

symrec* ts;

int main(){
    printf("------------------  Empieza main del BISON  ------------------\n");
    saludar();
    yyparse();
}
