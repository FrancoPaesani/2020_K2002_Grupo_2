// SSL - TP1.cpp : This file contains the 'main' function. Program execution begins and ends there.
//

#include <iostream>
#include <stdio.h>
#include <string.h> 
#include <stdlib.h> 
#pragma warning(disable : 4996)


int main()
{

	//-----------------------------------------------------
	//comienzo
	//Lee el archivo

	FILE* valores = fopen("valores.txt", "rb");
	if (valores == NULL)
	{
		printf("ERROR-No se pudo abrir el archivo");
		return 1;
	}
	fseek(valores, 0, SEEK_END);
	int cantElem = ftell(valores);
	rewind(valores);
	char* cadena = (char*)calloc(sizeof(char), cantElem+1);
	int ElemLeidos = fread(cadena, sizeof(char), cantElem, valores);
	if (ElemLeidos != cantElem)
	{
		printf("ERROR- No leyo correctamente");
		return 2;
	}
	printf("CONTENIDO DEL ARCHIVO:\n");
	printf("-------------------------------------------------------------------------------------------------\n");
	printf("%s", cadena);
	//---------------------------------------------------------------------------------------------------------
	//testeo como los trae tanto en formato char o int 
		/*printf("\n%d",(char)cadena[16]-'0');
		int a= (char)cadena[16]-'0';
		//a++;
		printf("\n%d",a);
		char aw=a+'0';
		printf("\n%c\n",aw);*/
		//----------------------------------------------------------------------------------------------------------	
		// Automata

	printf("\n\nINICIO DE RECONOCIMIENTO POR UN AFD:\n");
	printf("-------------------------------------------------------------------------------------------------\n\n");
	int i = 0, estado, inicio = 0, s1 = 1, s2 = 2, s3 = 3, s4 = 4, fin = 5;
	bool dec = false, octa = false, hex = false, noRec = false;
	int numero;
	estado = inicio;

	for (i = 0; i < cantElem+1; i++)
	{

		numero = (char)cadena[i] - '0';
		switch (estado)
		{
		case 0:


			if (numero == 0)
			{
				printf("%c", numero + '0');
				estado = s2;
			}
			else if (numero >= 1 && numero <= 9)
			{
				estado = s1;
				printf("%c", numero + '0');
			}
			else
			{
				printf("%c", numero + '0');
				estado = s4;


			}
			break;
		case 1:

			if (numero >= 0 && numero <= 9)
			{
				estado = s1;
				printf("%c", numero + '0');
			}
			else if (numero == -4 || numero == -48)
			{
				estado = fin;
				dec = true;
			}
			else
			{
				printf("%c", numero + '0');
				estado = s4;


			}
			break;
		case 2:
			if (numero == 72 || numero == 40)
			{
				estado = s3;
				printf("%c", numero + '0');
			}
			else if (numero >= 0 && numero <= 7)
			{
				estado = s2;
				printf("%c", numero + '0');
			}
			else if (numero == -4 || numero == -48)
			{
				estado = fin;
				octa = true;
			}
			else
			{
				printf("%c", numero + '0');
				estado = s4;


			}
			break;
		case 3:
			if (numero >= 0 && numero <= 9 || numero >= 17 && numero <= 22 || numero >= 49 && numero <= 54)
			{
				estado = s3;
				printf("%c", numero + '0');
			}
			else if (numero == -4 || numero == -48)
			{
				estado = fin;
				hex = true;
			}
			else
			{
				printf("%c", numero + '0');
				estado = s4;


			}

			break;
		case 4:
			if (numero == -4 || numero == -48)
			{
				estado = fin;
				noRec = true;
			}
			else
			{
				printf("%c", numero + '0');
			}

			break;

		case 5:
			if (dec == true)
			{
				printf("\tEs decimal\n");
				dec = false;
				estado = inicio;
				i--;
			}
			else if (octa == true)
			{
				printf("\tEs octal\n");
				octa = false;
				estado = inicio;
				i--;
			}
			else if (hex == true)
			{
				printf("\tEs hexadecimal\n");
				hex = false;
				i--;
				estado = inicio;
			}
			else if (noRec == true)
			{
				printf("\tNo es valido\n");
				noRec = false;
				i--;
				estado = inicio;
			}
			break;
		default:
			break;
		}
//		Agregado ultimo elemento		//

		if (i == cantElem && dec == true)
		{
			printf("\tEs decimal\n");
		}
		else if (i == cantElem && octa == true)
		{
			printf("\tEs octal\n");
		}
		else if (i == cantElem && noRec == true)
		{
			printf("\tNo es valido\n");
		}
		else if (i == cantElem && hex == true)
		{
			printf("\tEs hexadecimal\n");
		}

		//		Agregado ultimo elemento		//

	}

	free(cadena);// LIBERA MEMORIA ASIGNADA AL VECTOR
	fclose(valores); //CIERRA ARCHIVO
	return 0;
	//fin

}