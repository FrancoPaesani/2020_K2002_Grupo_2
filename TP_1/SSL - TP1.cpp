// SSL - TP1.cpp : This file contains the 'main' function. Program execution begins and ends there.
//

#include <iostream>
#include <stdio.h>
#include <string.h> 
#include <stdlib.h> 
#pragma warning(disable : 4996)


void devuelveestado(int& c, int& est,int& inicio, int matrizaux [][6], bool& flagexiste) {

	if (c == 0 && est == inicio)
	{
		est = matrizaux[est][0];
		//printf("%c", c + '0');
	}
	else if (c >= 1 && c <= 9 && est == inicio)
	{
		est = matrizaux[est][1];
		//printf("%c", c + '0');
	}
	else if (c >= 0 && c <= 7 && est != 7)
	{
		est = matrizaux[est][3];
		//printf("%c", c + '0');
	}
	else if (c >= 0 && c <= 9 && est != 7)
	{
		est = matrizaux[est][2];
		//printf("%c", c + '0');
	}

	else if ((c == 72 || c == 40) && est != 7)
	{
		est = matrizaux[est][4];
		//printf("%c", c + '0');
	}
	else if (((c >= 17 && c <= 22 || c >= 49 && c <= 54) && est!=7))
	{
		est = matrizaux[est][5];
		//printf("%c", c + '0');
	}
	else
	{
		flagexiste = false;
	}
}


int main()
{

		//----------------------------------------------------------------------------------------------------------	
		// Automata

	FILE*valores = fopen("valores.txt", "rb");
	if(valores == NULL)
	{printf("ERROR-No se pudo abrir el archivo");
	 return 1;
	}
	fseek(valores,0,SEEK_END);
	int cantElem=ftell(valores);
	rewind(valores);
	char * cadena =(char*) calloc(sizeof(char),cantElem);
	int ElemLeidos= fread(cadena,sizeof(char),cantElem,valores);
	printf("\n %d\n", ElemLeidos);
	if(ElemLeidos!=cantElem)
	{
		printf("ERROR- No leyo correctamente");
		return 2;
	} 
		printf("CONTENIDO DEL ARCHIVO:\n");
		printf("-------------------------------------------------------------------------------------------------\n");
	 	printf("%s",cadena);

    int matriz[7] [6]={{2,1,6,6,6,6},{1,1,1,1,6,6},{5,6,6,5,3,6},{4,4,4,4,6,4},{4,4,4,4,6,4},{5,6,6,5,6,6},{6,6,6,6,6,6}};
    	printf("\n\nINICIO DE RECONOCIMIENTO POR UN AFD:\n");
		printf("-------------------------------------------------------------------------------------------------\n\n");
		int i=0,estado,inicio=0;
		int numero;
		bool flagexiste=true, flagvacio=true;
		estado=inicio;
		FILE* salida = fopen("salida.txt", "wb");
		if (valores == NULL)
		{
			printf("ERROR-No se pudo abrir el archivo");
			return 1;
		}
		for (i = 0; i < cantElem + 2; i++)
		{
			flagexiste = true;
			flagvacio = true;
			numero = (char)cadena[i] - '0';
			if (flagexiste == true || flagvacio == true)
			{
				if (numero != -4 && numero != -48)
				{
					devuelveestado(numero, estado, inicio, matriz, flagexiste);
					printf("%c", numero + '0');
					putc(numero + '0', salida);
				}

				if (numero == -4 || numero == -48)
				{
					if (estado == 1)
					{
						printf("\tEs decimal\n");
						fputs("\t\tEs decimal\n", salida);
						estado = inicio;
						i--;
					}
					else if (estado == 5)
					{
						printf("\tEs octal\n");
						fputs("\t\tEs octal\n", salida);
						estado = inicio;
						i--;
					}
					else if (estado == 4)
					{
						printf("\tEs hexadecimal\n");
						fputs("\t\tEs hexadecimal\n", salida);
						i--;
						estado = inicio;
					}
					else if (estado == 6)
					{
						printf("\tNo es valido\n");
						fputs("\t\tNo es valido\n", salida);
						i--;
						estado = inicio;
					}
					else if (estado == 7)
					{
						printf("\tNo es valido\n");
						fputs("\t\tNo es valido\n", salida);
						i--;
						estado = inicio;
					}
					flagvacio = true;
				}
				else
				{
					flagvacio = false;
				}

				if (flagexiste == false && flagvacio == false)
				{
					estado = 7;
				}
			}
		}
        free(cadena);// LIBERA MEMORIA ASIGNADA AL VECTOR
		fclose(valores); //CIERRA ARCHIVO
		return 0;
 		//fin
}