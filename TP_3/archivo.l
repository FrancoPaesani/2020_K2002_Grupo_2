%option noyywrap

%{

#include <stdio.h>
#include <stdlib.h>
#include "funciones.h"

 tipoLista *listaId=NULL;
 tipoLista *listaCadenas=NULL;
 tipoLista *cola=NULL;
 tipoLista *colaCaracter=NULL;
 tipoLista *colaComentSimple=NULL;
 tipoLista *colaComentVarias=NULL;
 tipoLista *listaDecimal=NULL;
 tipoLista *listaOctal=NULL;
 tipoLista *listaHexa=NULL;
 tipoLista *listaReal=NULL; 
 tipoLista *listaPuntuacion=NULL; 
 tipoLista *listaNoReconocido=NULL;
	int n=1;
 	struct Info d;
	struct Info a;
	struct Info c;
%}

%s comentarioVarias
%x ComentarioSimple
%s precaracter
%x precadena

NOVA .
SECUENCIA_ESCAPE_SIMPLE [\' | \" | \? | \\ | a | b | f | n | r | t | v]
DIGITO_DECIMAL [0-9]
DIGITO_OCTAL [0-7]
DIGITO_HEXADECIMAL [0-9a-fA-F]
ESCAPE_OCTAL {DIGITO_OCTAL}{DIGITO_OCTAL}?{DIGITO_OCTAL}?
ESCAPE_HEXADECIMAL x{DIGITO_HEXADECIMAL}{DIGITO_HEXADECIMAL}?
CONSTANTE_CARACTER ([^\'\\]|\\({SECUENCIA_ESCAPE_SIMPLE}|{ESCAPE_OCTAL}|{ESCAPE_HEXADECIMAL}))
CARACTER_PUNTUACION [(\[\]\(\)\{\}\.]|\-\>|\+\+|\-\-|[\&\*\+\-\~\!\/\%]|\<\<|\>\>|[\<\>]|\<\=|\>\=|\=\=|\!\=|^|\||\&\&|\|\||\=|\*\=|\/\=|\%\=|\+\=|\-\=|\<\<\=|\>\>\=|\&\=|\^\=|\|\=|\;        
TIPO_DATO char|double|float|int|long|short|struct|unsigned|typedef|signed|enum|union
FUNCIONES do|for|goto|if|else|sizeof|while|case|break|return|switch|default|continue
DATO_RETORNO void|static
CLASE_ALMACENAMIENTO auto|extern|register
MANEJO_DATO volatile|const

%%
	struct Info b;
	char *acum=NULL;

[\n] {n++;}
\' {acum=malloc(sizeof(yytext));strcpy(acum,yytext);/*printf("Encontre una constante caracter inicio: %s\n",acum);*//*colaCaracter=insertaPalabraReservada(colaCaracter,yytext,b,"ConstanteCaracter");*/BEGIN(precaracter);}
<precaracter>\'\\.?\' {strcat(acum,yytext);printf("Encontre un caracter no reconocido : %s\n",acum);b.extra=n;listaNoReconocido=insertaPalabraReservada(listaNoReconocido,acum,b,"NoReconocido");BEGIN(INITIAL);}
<precaracter>\'.?\' {strcat(acum,yytext);printf("Encontre un caracter no reconocido : %s\n",acum);b.extra=n;listaNoReconocido=insertaPalabraReservada(listaNoReconocido,acum,b,"NoReconocido");BEGIN(INITIAL);}
<precaracter>\\[^{SECUENCIA_ESCAPE_SIMPLE}{ESCAPE_OCTAL}{ESCAPE_HEXADECIMAL}]?\' {strcat(acum,yytext);b.extra=n;printf("Encontre un caracter no reconocido fin : %s\n",acum)
;listaNoReconocido=insertaPalabraReservada(listaNoReconocido,acum,b,"NoReconocido");BEGIN(INITIAL);}
<precaracter>{CONSTANTE_CARACTER}\' {strcat(acum,yytext);printf("Encontre una constante caracter: %s\n",acum);colaCaracter=insertaPalabraReservada(colaCaracter,acum,b,"ConstanteCaracter");BEGIN(INITIAL);}
<precaracter>.*\' {strcat(acum,yytext);printf("Caracter finallll no reconocido %s\n",acum);b.extra=n;listaNoReconocido=insertaPalabraReservada(listaNoReconocido,acum,b,"NoReconocido");BEGIN(INITIAL);}
[\"] {acum=malloc(sizeof(yytext));strcpy(acum,yytext);BEGIN(precadena);}
<precadena>{CONSTANTE_CARACTER}+[\"] {strcat(acum,yytext);printf("Encontre un literal cadena: %s\n",acum);listaCadenas=insertarLista(listaCadenas,acum,b,"Literal Cadena");BEGIN(INITIAL);}
<precadena>.*\" {strcat(acum,yytext);printf("Encontre un literal cadena no reconocido: %s\n",acum);b.extra=n
;listaNoReconocido=insertaPalabraReservada(listaNoReconocido,acum,b,"NoReconocido");BEGIN(INITIAL);}
{CARACTER_PUNTUACION} {/*printf("Encontre un caracter de puntuacion: %s\n",yytext);*/listaPuntuacion=insertarLista(listaPuntuacion,yytext,b,"CaracterPuntuacion");}
{TIPO_DATO} {/*printf("Encontre un tipo de dato: %s\n",yytext);*/b.extra=0;cola=insertaPalabraReservada(cola,yytext,b,"PalabraReservada");free(b.cadena);}
{FUNCIONES} {/*printf("Encontre una funcion: %s\n",yytext);*/b.extra=1;cola=insertaPalabraReservada(cola,yytext,b,"PalabraReservada");}
{DATO_RETORNO} {/*printf("Encontre un tipo de dato de retorno: %s\n",yytext);*/b.extra=2;cola=insertaPalabraReservada(cola,yytext,b,"PalabraReservada");}
{CLASE_ALMACENAMIENTO} {/*printf("Encontre una clase de almacenamiento: %s\n",yytext);*/b.extra=3;cola=insertaPalabraReservada(cola,yytext,b,"PalabraReservada");}
{MANEJO_DATO} {/*printf("Encontre una forma de manejo de datos: %s\n",yytext);*/b.extra=4;cola=insertaPalabraReservada(cola,yytext,b,"PalabraReservada");}
"//"[^\n]* {/*printf("Encontre una linea de comentarios: %s\n",yytext);*/
colaComentSimple=insertarLista(colaComentSimple,yytext,b,"ComentarioSimple");}
\/\*    {BEGIN(comentarioVarias);acum=malloc(sizeof(yytext));acum=yytext;}
<comentarioVarias>[^.] {n++;} //Reconocer cada nueva linea
<comentarioVarias>[^\*\n]* 
<comentarioVarias>\*+[^\/\n]*
<comentarioVarias>\*\/   {/*printf("Encontre varias lineas de comentarios: %s\n",acum);*/colaComentVarias=insertaPalabraReservada(colaComentVarias,acum,b,"ComentarioVarios");
BEGIN(INITIAL);}
[1-9]{DIGITO_DECIMAL}*/[^a-zA-Z] {/*printf("Encontre una constante entera decimal %s \n",yytext);*/
listaDecimal=insertarLista(listaDecimal,yytext,b,"Digito Decimal");}
0{DIGITO_OCTAL}*/[^a-zA-Z] {/*printf("Encontre una constante entera octal %s \n",yytext);*/
listaOctal=insertarLista(listaOctal,yytext,b,"Digito Octal");}
0[xX]{DIGITO_HEXADECIMAL}+/[^a-zA-Z] {/*printf("Encontre una constante entera hexadecimal \n");*/
listaHexa=insertarLista(listaHexa,yytext,b,"Digito Hexadecimal");}
{DIGITO_DECIMAL}*\.{DIGITO_DECIMAL}+([Ee](\+|\-)?{DIGITO_DECIMAL}*)?/[^a-zA-Z] {/*printf("Encontre una constante real: %s\n",yytext);*/
listaReal=insertarLista(listaReal,yytext,b,"Digito Real");}
[a-zA-Z_][a-zA-Z0-9_]* {/*printf("Encontre un identificador: %s\n",yytext);*/
listaId=insertarLista(listaId,yytext,b,"Identificador");}
[.]* {printf("Caracter no reconocido %s --> En la linea: %i\n",yytext,n);}
%%

int main(){		//revisar cadenas no reconocidas

     yyin = fopen("entrada.txt", "r");
     yylex();
	 muestra(cola);
     muestra(listaId);
	 muestra(listaCadenas);
	 muestraNumeros(listaDecimal,"Decimal",10);
	 muestraNumeros(listaOctal,"Octal",8);
	 muestraNumeros(listaHexa,"Hexadecimal",16);
	 muestraNumeros(listaReal,"Real",0);
	 muestra(colaCaracter);
	 muestra(listaPuntuacion);
	 muestra(colaComentSimple);
	 muestra(colaComentVarias);
	 muestra(listaNoReconocido);
	 printf("Cantidad de lineas totales: %i\n",n);
}