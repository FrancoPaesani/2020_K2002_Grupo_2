%{
	
  #include <stdlib.h>
  #include <string.h>
  #include "utiles.h"


int yylex();
int yywrap(){
	return(1);
}

int declarando;
int valor;
int api;
char* idDecla;
symrec* aux;

%}

%union { 

struct yylaval_struct{
    int tipo;
    float valor;
  	char id[85];
  	char cadena[85];    
}myStruct;

}
//separe el token NUM en REAL y CONSTANTE  
%token <myStruct> NUM 
%token <myStruct> MAS 
%token <myStruct> MENOS
%token <myStruct> POR
%token <myStruct> ASIGNACION 
%token <myStruct> CONSTANTE 
%token <myStruct> REAL 
%token <myStruct> DIVISION 
%token <myStruct> ESPECIFICADORTIPOVACIO
%token <myStruct> IDENTIFICADOR 
%token <myStruct> CADENA 
%token <myStruct> ESPECIFICADORTIPOENTERO 
%token <myStruct> ESPECIFICADORTIPOCADENA 
%token <myStruct> ESPECIFICADORTIPOREAL 
%token <myStruct> ESPECIFICADORTIPOSTRUCT
%token <myStruct> CARACTER

%type <myStruct> listaDeSentencias 
%type <myStruct> sentencia 
%type <myStruct> funcion 
%type <myStruct> parametro 
%type <myStruct> declaraciones 
%type <myStruct> declaracion
%type <myStruct> expresion 
%type <myStruct> expresionPrimariaA 
%type <myStruct> expresionPrimariaB
%type <myStruct> constante
%type <myStruct> tipoID
%type <myStruct> especificadorTipo 
%type <myStruct> structOUnion 
%type <myStruct> expStruct 
%type <myStruct> declarador 
%type <myStruct> estadoCompuesto
%type <myStruct> estadoVacio

%left  '-'  '+'
%left  '*'  '/'


%%

input:    /* vacio */
        | input line
;

line:     '\n'
        | listaDeSentencias sentencia
        | sentencia {printf("entramos a una sentencia\n");}
;

listaDeSentencias: listaDeSentencias sentencia 
            | sentencia
;

sentencia: funcion 
            | declaracion
;

funcion: 		tipoID IDENTIFICADOR '(' listaParametros ')' estadoCompuesto ';' {}
;

listaParametros:	/*VACIO*/ 
			| listaParametros ',' parametro 
			| parametro 
;

parametro:		tipoID declarador {}
			| declarador {}
;

idStruct:		/*VACIO*/
			| especificadorTipo declarador ';' {}

declaraciones2:	/*VACIO*/
			| declaraciones
;

declaraciones:	declaraciones declaracion 
            | declaracion
;

declaracion:		especificadorTipo ';' 
			| especificadorTipo declarador ';' {}
			| especificadorTipo declarador ASIGNACION expresion ';' {}
;

expresionVacio:	/* VACIO */
			| expresion {printf("\n expresion goes brrr\n");}
;

expresion:      expresion MAS expresionPrimariaA {if($<myStruct>1.tipo==$<myStruct>3.tipo){$<myStruct>$.valor_entero = $<myStruct>1.valor_entero + $<myStruct>3.valor_entero; $<myStruct>$.tipo = $<myStruct>1.tipo;}else{printf("Error de tipos");}}
			|expresion MENOS expresionPrimariaA {} 
			|expresionPrimariaA {$$ = $1;}
;
			
expresionPrimariaA:     expresionPrimariaB {$$ = $1;} |
			expresionPrimariaA POR expresionPrimariaB {}
			expresionPrimariaA DIVISION expresionPrimariaB {}
			;

expresionPrimariaB:     declarador {$$ = $1;} 
			| constante {$$ = $1;}  
			| '(' expresion ')' {$$ = $2;} 
			| CADENA {$$ = $1;}
;

constante :	 CONSTANTE {$$ = $1;}
            | CARACTER {$$ = $1;}
            | REAL {$$ = $1;}
;

especificadorTipo:	tipoID
			| structOUnion
			| declarador 
;

tipoID:			ESPECIFICADORTIPOENTERO {$$ = $1;}
			|ESPECIFICADORTIPOCADENA {$$ = $1;}
			|ESPECIFICADORTIPOREAL {$$ = $1;}
			|ESPECIFICADORTIPOVACIO {$$ = $1;}

structOUnion:		ESPECIFICADORTIPOSTRUCT IDENTIFICADOR '{' expStruct '}' {}
			| ESPECIFICADORTIPOSTRUCT '{' expStruct '}'
			| ESPECIFICADORTIPOSTRUCT IDENTIFICADOR {}
;

expStruct:	    expStruct idStruct 
			| idStruct
;

declarador:		IDENTIFICADOR {$$ = $1;}
			| IDENTIFICADOR '[' CONSTANTE ']' {$$ = $1;}
			| PRODUCTO IDENTIFICADOR {$$ = $2;}
;

estadoCompuesto:	'{' declaraciones2 estadoVacio '}'
;

estadoVacio:		/* VACIO */
;


%%

symrec* ts;

int main(){
    printf("------------------  Empieza main del BISON  ------------------\n");
    
    yyparse();
}