%option noyywrap

%{
#include <stdio.h>
%}

SECUENCIA_ESCAPE_SIMPLE [\' | \" | \? | \\ | a | b | f | n | r | t | v]
DIGITO_DECIMAL [0-9]
DIGITO_OCTAL [0-7]
DIGITO_HEXADECIMAL [0-9a-fA-F]
ESCAPE_OCTAL {DIGITO_OCTAL}{DIGITO_OCTAL}?{DIGITO_OCTAL}?
ESCAPE_HEXADECIMAL x{DIGITO_HEXADECIMAL}{DIGITO_HEXADECIMAL}?

%%

[1-9]{DIGITO_DECIMAL}* {printf("Encontre una constante entera decimal \n");}
0{DIGITO_OCTAL}* {printf("Encontre una constante entera octal \n");}
0[xX]{DIGITO_HEXADECIMAL}+ {printf("Encontre una constante entera hexadecimal \n");}
[a-zA-Z_][a-zA-Z0-9_]* {printf("Encontre un identificador \n");}
{DIGITO_DECIMAL}*\.{DIGITO_DECIMAL}+ {printf("Encontre una constante real \n");}
[^\'\\]|\\({SECUENCIA_ESCAPE_SIMPLE}|{ESCAPE_OCTAL}|{ESCAPE_HEXADECIMAL}) {printf("Encontre cualquiera seguida de una a: %s\n",yytext);}

%%

//{SECUENCIA_ESCAPE_SIMPLE}
/*[^\]/[\' | \" | \? | \\ | \a | \b | \f | \n | \r | \t | \v]{DIGITO_OCTAL}{DIGITO_OCTAL}?{DIGITO_OCTAL}? {printf("Encontre el caracter: %s \n",yytext);}
[a-z]/[0-9] {printf("Encontre una letra seguida de un numero");}*/

//C:\Program Files (x86)\Flex y Bison\lib
//      \\\'|\\n

//      ([(^\'\\)]|{SECUENCIA_ESCAPE_SIMPLE})