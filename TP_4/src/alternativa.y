%{
	
  #include <stdlib.h>
  #include <string.h>
  #include "utiles.h"


int yylex();
int yywrap(){
	return(1);
}
void yyerror(char *string);
void* string_append(char* s1, int type);	// 0 uso parametrosUso. 1 uso parametrosDecla
char** _string_split(char* text, char* separator, int(*condition)(char*, int));
char **string_split(char *text, char *separator);
void* _string_append(char* original, char* append);

extern FILE* yyin;
extern int linea;
//extern char* parametrosUso;
char parametrosUso[20];
char parametrosDecla[40];
int declarando;
int valor;
int api;
char* idDecla;
int cantidadParametros;

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
//%token END 0 "end of file"

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
%token <myStruct> END

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
%type <myStruct> otraCosa
%type <myStruct> expEstado
%type <myStruct> estado
%type <myStruct> seleccionEstado
%type <myStruct> etiquetaEstado
%type <myStruct> saltoEstado
%type <myStruct> iteracionEstado
%type <myStruct> opcionElse


%left  '-'  '+'
%left  '*'  '/'

%start programa
%%


programa: listaDeSentencias '\n' END {printf("Termino sin errores.\n");leerTS();}
			| listaDeSentencias END {printf("Termino sin errores.\n");leerTS();}
;

listaDeSentencias: sentencia otraCosa
						| error ';' listaDeSentencias {}	// sigue analizando desde el ;
;
otraCosa: listaDeSentencias | /*VACIO*/
;

sentencia: 			declaracion 
					| expresionVacio
					| estado
					| funcionUso
					| funcion
					| declaracion '\n'
					| expresionVacio '\n'
					| estado '\n'
					| funcionUso '\n'
					| funcion '\n'
;
funcion: 		especificadorTipo IDENTIFICADOR '(' listaParametros ')' '{' sentencia  '}' ';' {symrec* auxFunc = getsym($<myStruct>2.valor_string);
																								if(aux){yyerror("Error semantico. La declaracion de la funcion ya se realizo. Se puede hacer uso de la funcion.\n");
																							//printf("Error semantico. La declaracion de la funcion ya se realizo. Se puede hacer uso de la funcion.\n");
																							}
																							else{
																								symrec* auxf = putsym($<myStruct>2.valor_string,FUNCION,cantidadParametros,NULL,parametrosDecla);
																							}
																							cantidadParametros = 0;}
;

funcionUso: 	 IDENTIFICADOR '(' listaEntrada ')' ';' {symrec* aux = getsym($<myStruct>1.valor_string);
														if(aux){
														char** separado_decla = string_split(aux->parametros,",");
														char** separado_llamada = string_split(parametrosUso,","); 
														
														for(int i = 0; i<aux->cantidadParametros; i++){
														int tipoDeclarado = parametrosDecla[i] - '0';
														//printf("Primer lugar ---> %s de tipo -->%i.\n",separado_llamada[i],tipoDeclarado);
														symrec* auxParam = getsym(separado_llamada[i]);
														if(auxParam){
															if(auxParam->types == tipoDeclarado){}
															else{
																//yyerror("Error semantico. El tipo de dato ingresado no matchea con el de la funcion.\n");
																printf("Error semantico en la linea %i. El tipo de dato ingresado no matchea con el de la funcion.\n",linea);
																break;
															}
														}else{
															//yyerror("Error semantico. El parametro ingresado en la funcion no existe\n");
															printf("Error semantico en la linea %i. El parametro numero %i ingresado en la funcion no existe\n",linea,i);
															break;
														}				
														}
														}else{
															//yyerror("Error semantico. La funcion invocada no se declaro.\n");
															printf("Error semantico en la linea %i. La funcion <%s> invocada no se declaro.\n",linea,$<myStruct>1.valor_string);
														}
														free(parametrosUso);free(parametrosDecla);cantidadParametros = 0;
														}
;				
listaEntrada:/*VACIO*/ 
			| parametroUso ',' listaEntrada
			| parametroUso
;
parametroUso: declarador  {string_append($<myStruct>1.valor_string,0);cantidadParametros++;}
;

listaParametros:	/*VACIO*/ 
			| parametro ','  listaParametros
			| parametro
;

parametro:		tipoID declarador 		{
											switch($<myStruct>1.tipo){
											case 0:
											string_append("0",1);cantidadParametros++;
											break;
											case 1:
											string_append("1",1);cantidadParametros++;
											break;
											case 2:
											string_append("2",1);cantidadParametros++;
											break;
											case 3:
											string_append("3",1);cantidadParametros++;
											break;
											}
										}	
			//| declarador {}
;

idStruct:		/*VACIO*/
			| especificadorTipo declarador ';' {}

declaraciones2:	declaraciones
				| /*VACIO*/
;

declaraciones:	declaraciones declaracion 
            | declaracion
;

declaracion:	especificadorTipo ';' 
				| especificadorTipo declarador ';' {}
				| especificadorTipo declarador ASIGNACION expresion ';' {if(getsym($<myStruct>2.valor_string) == 0){
																	if($<myStruct>1.tipo == $<myStruct>4.tipo )
																	{printf("La variable no se encuentra declarada.\n");
																	putsym($<myStruct>2.valor_string,$<myStruct>1.tipo,$<myStruct>4.valor,$<myStruct>4.valor_string,NULL);
																	}
																	else{printf("HAY UN ERROR DE TIPO DE DATO.\n");}}
																	else{printf("HAY UN ERROR DE DOBLE DECLARACION.\n");}
																	}
;

expresionVacio:	/* VACIO */
			| expresion ';' {}
;

expresion:      expresion MAS expresionPrimariaA {if($<myStruct>1.tipo==$<myStruct>3.tipo){$<myStruct>$.valor = $<myStruct>1.valor + $<myStruct>3.valor; $<myStruct>$.tipo = $<myStruct>1.tipo;}else{printf("Error de tipos");}}
			|expresion MENOS expresionPrimariaA {if($<myStruct>1.tipo==$<myStruct>3.tipo){$<myStruct>$.valor = $<myStruct>1.valor - $<myStruct>3.valor; $<myStruct>$.tipo = $<myStruct>1.tipo;}else{printf("Error de tipos");}}
			|expresionPrimariaA {$$ = $1;}
;
			
expresionPrimariaA:     expresionPrimariaB {$$ = $1;} 
			| expresionPrimariaA POR expresionPrimariaB {if($<myStruct>1.tipo==$<myStruct>3.tipo){$<myStruct>$.valor = $<myStruct>1.valor * $<myStruct>3.valor; $<myStruct>$.tipo = $<myStruct>1.tipo;}else{printf("Error de tipos");}}
			| expresionPrimariaA DIVISION expresionPrimariaB {if($<myStruct>1.tipo==$<myStruct>3.tipo){$<myStruct>$.valor = $<myStruct>1.valor / $<myStruct>3.valor; $<myStruct>$.tipo = $<myStruct>1.tipo;}else{printf("Error de tipos");}}
;

expresionPrimariaB:     declarador ASIGNACION expresionPrimariaB {$$ = $1;} 
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
		//	| declarador 
;

tipoID:		ESPECIFICADORTIPOENTERO {$$ = $1;}
			|ESPECIFICADORTIPOCADENA {$$ = $1;}
			|ESPECIFICADORTIPOREAL {$$ = $1;}
			|ESPECIFICADORTIPOVACIO {$$ = $1;}
;
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

estadoVacio:	 estado estadoVacio
				| /*VACIO*/
;

estado:			expEstado
			| estadoCompuesto
			| etiquetaEstado
			| iteracionEstado
			| saltoEstado
			| seleccionEstado
;

etiquetaEstado:		IDENTIFICADOR ':' estado
			| CASE expresion ':' estado
			| DEFAULT ':' estado
;

expEstado:		expresionVacio
;

seleccionEstado:	IF '(' expresion ')' estado opcionElse
			| SWITCH '(' expresion ')' estado
;

opcionElse: ELSE estado | /* VACIO */
;

iteracionEstado:	FOR '(' expresionVacio ';' expresionVacio ';' expresionVacio ')' estado
			| WHILE '(' expresion ')' estado
			| DO estado WHILE '(' expresion ')' ';'		
;

saltoEstado:		GOTO IDENTIFICADOR ';'
			| BREAK ';'
			| RETURN expresionVacio ';'
			| CONTINUE ';'
;


%%
char parametrosUso[20];
symrec* ts;

void yyerror(char *string){
	printf("%s --> El error aparecio en la linea: %d.\n", string, linea);
};

int main(){

	printf("------------------  Empieza main del BISON  ------------------\n");
	yyin = fopen("src/programa.txt","rt");
	if(yyin == NULL){
		puts(strerror(errno));
	}
    yyparse();
	
	fclose(yyin);

	return 0;
}

void* string_append(char* s1, int type){
	if(type == 0){
	realloc(parametrosUso, strlen(parametrosUso) + strlen(s1) + 1);
	strcat(&parametrosUso,s1);
	strcat(&parametrosUso,",");
	}
	else{
	realloc(parametrosDecla, strlen(parametrosUso) + strlen(s1) + 1);
	strcat(&parametrosDecla,s1);
	strcat(&parametrosDecla,",");
	}
}

void* _string_append(char* original, char* append){							//global
	realloc(original, strlen(original) + strlen(append) + 1);
	strcat(&original,append);
}

char **string_split(char *text, char *separator) {
	int _is_last_token(char* next, int _) {
		return next[0] != '\0';
	}
	return _string_split(text, separator, _is_last_token);
}

char** _string_split(char* text, char* separator, int(*condition)(char*, int)) {
	char **substrings = NULL;
	int size = 0;

	char *text_to_iterate = strdup(text);

	char *next = text_to_iterate;
	char *str = text_to_iterate;

	while(condition(next, size)) {
		char* token = strtok_r(str, separator, &next);
		if(token == NULL) {
			break;
		}
		str = NULL;
		size++;
		substrings = realloc(substrings, sizeof(char*) * size);
		substrings[size - 1] = strdup(token);
	};

	if (next[0] != '\0') {
		size++;
		substrings = realloc(substrings, sizeof(char*) * size);
		substrings[size - 1] = strdup(next);
	}

	size++;
	substrings = realloc(substrings, sizeof(char*) * size);
	substrings[size - 1] = NULL;

	free(text_to_iterate);
	return substrings;
}
