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
  	char id[58];
  	char cadena[85];    
	char* valor_string;
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
%token <myStruct> ESPECIFICADORTIPOFLOAT
%token <myStruct> CARACTER
%token <myStruct> PRODUCTO
%token <myStruct> SIZEOF
%token <myStruct> BREAK
%token <myStruct> CASE
%token <myStruct> CONTINUE
%token <myStruct> DEFAULT
%token <myStruct> DO
%token <myStruct> DOUBLE
%token <myStruct> ELSE
%token <myStruct> ENUM
%token <myStruct> RETURN
%token <myStruct> NO_RECONOCIDO
%token <myStruct> COMILLA
%token <myStruct> MAYOR
%token <myStruct> MENOR
%token <myStruct> MASIGUAL
%token <myStruct> IGUAL
%token <myStruct> DISTINTO
%token <myStruct> AND
%token <myStruct> ID
%token <myStruct> WHILE
%token <myStruct> SWITCH
%token <myStruct> FOR
%token <myStruct> GOTO
%token <myStruct> IF

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
%type <myStruct> expresionStruct 
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
        | listaDeSentencias
        | sentencia
		//| expresionPrimariaA
;

listaDeSentencias: listaDeSentencias sentencia 
           			 | sentencia
;

sentencia: 			declaracion
				//	| funcion 	// no puede hacer prediccion
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

declaracion:	especificadorTipo ';' 
				| especificadorTipo declarador ';' {}
				| especificadorTipo declarador ASIGNACION expresion ';' {if(getsym($<myStruct>2.valor_string) == 0){
																	if($<myStruct>1.tipo == $<myStruct>4.tipo )
																	{printf("La variable no se encuentra declarada.\n");
																	putsym($<myStruct>2.valor_string,$<myStruct>1.tipo,$<myStruct>4.valor,$<myStruct>4.valor_string);
																	}
																	else{printf("HAY UN ERROR DE TIPO DE DATO.\n");}}
																	else{printf("HAY UN ERROR DE DOBLE DECLARACION.\n");}
																	symrec* aux = getsym($<myStruct>2.valor_string);
																	printf("La variable %s se guardo con valor -->%f.\n",aux->name,aux->valor);
																	}
;

expresionVacio:	/* VACIO */
			| expresion {printf("\n expresion goes brrr\n");}
;

expresion:      expresion MAS expresionPrimariaA {if($<myStruct>1.tipo==$<myStruct>3.tipo){$<myStruct>$.valor = $<myStruct>1.valor + $<myStruct>3.valor; $<myStruct>$.tipo = $<myStruct>1.tipo;}else{printf("Error de tipos");}}
			|expresion MENOS expresionPrimariaA {} 
			|expresionPrimariaA {}
;
			
expresionPrimariaA:     expresionPrimariaB {} 
			| expresionPrimariaA POR expresionPrimariaB {if($<myStruct>1.tipo==$<myStruct>3.tipo){$<myStruct>$.valor = $<myStruct>1.valor * $<myStruct>3.valor; $<myStruct>$.tipo = $<myStruct>1.tipo;}else{printf("Error de tipos");}}
			| expresionPrimariaA DIVISION expresionPrimariaB {if($<myStruct>1.tipo==$<myStruct>3.tipo){$<myStruct>$.valor = $<myStruct>1.valor / $<myStruct>3.valor; $<myStruct>$.tipo = $<myStruct>1.tipo;}else{printf("Error de tipos");}}
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

tipoID:		ESPECIFICADORTIPOENTERO {$$ = $1;}
			|ESPECIFICADORTIPOCADENA {$$ = $1;}
			|ESPECIFICADORTIPOREAL {$$ = $1;}
			|ESPECIFICADORTIPOVACIO {$$ = $1;}

structOUnion:		ESPECIFICADORTIPOSTRUCT IDENTIFICADOR '{' expresionStruct '}' {}
			| ESPECIFICADORTIPOSTRUCT '{' expresionStruct '}'
			| ESPECIFICADORTIPOSTRUCT IDENTIFICADOR {}
;

expresionStruct:	    expresionStruct idStruct 
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
