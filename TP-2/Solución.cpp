// SSL - TP1.cpp : This file contains the 'main' function. Program execution begins and ends there.
//

#include <iostream>
#include <stdio.h>
#include <string.h> 
#include <stdlib.h> 
#pragma warning(disable : 4996)

int funcion(int matriz[][3][5], int &valor) {
	return matriz[0][0][valor];
}


typedef struct _nodo {
	int dato;
	struct _nodo *siguiente;
}tipoNodo;

typedef tipoNodo* Pila;
typedef tipoNodo* pNodo;

void push(Pila* pila, int v) {
	pNodo nuevo;

	nuevo = (pNodo)malloc(sizeof(tipoNodo));
	nuevo->dato = v;
	nuevo->siguiente = *pila;
	*pila = nuevo;
}

int pop(Pila* pila) {
	pNodo nodo;
	int v;      

	nodo = *pila;
	if (!nodo) return 0; 

	*pila = nodo->siguiente;
	
	v = nodo->dato;

	free(nodo);
	return v;
}

int devuelvesigno (int &caracter/*, int& estadosigno, Pila pila*/,int &estadoq, int &estado) {
	int estadosigno;
	if (estado ==0 && (caracter == 0 || caracter == 45 || caracter == 47 || caracter == 42 || caracter == 43 || caracter == 41))
	{
		printf("Estas ingresando un caracter sin tener en cuenta la semantica de la expresion");
		estado = 10;
		return 0;
	}

	if (caracter == 0){
		printf("ESTA ENTRE 0");
		 estadosigno = 0;
		 estadoq = 1;
		return estadosigno;
	}
	if (caracter >= 1 && caracter <= 9)
	{
		printf("ESTA ENTRE 1 Y 9");
		 estadosigno = 1;
		 estadoq = 1;
		return estadosigno;
	}
	if ( caracter ==45 || caracter == 47 ||  caracter==42 || caracter==43 )
	{
		printf("ESTA ENTRE OPERADORES");
		 estadosigno = 2;
		 estadoq = 0;
		return estadosigno;
	}
	if (caracter == 40)
	{
		printf("ES ABRE PARENTESIS");
		 estadosigno = 3;
		 estadoq = 0;
		return estadosigno;
	//	push(&pila, 3);
	}
	if (caracter == 41)
	{
		printf("ES CIERRA PARENTESIS");
		estadosigno = 4;
		estadoq = 2;
		return estadosigno;
	//	push(&pila, 4);
	}
}

int devuelvocimapila (Pila pila,int& estadoPila){

	estadoPila=pop(&pila);
	return estadoPila;
}

int devuelvoestado(int &caracter, int& estado, int& estadosigno, int& estadoinicio, int matriz[2][3][5]/*,Pila pila, int& estadopila*/,int &estadoq) {

	printf("\n %d \n", caracter);
	estadosigno=devuelvesigno(caracter,estadoq,estado);
	//int x = devuelvocimapila(pila, estadopila);

	if (estado ==10)
	{
		return 10;
	}
	return matriz [0] [estadoq] [estadosigno];

}

int main()
{
	//Pila pila = NULL;
	//int flength = strlen(f);
	char f[256];
	int flength = 0;
	int reinicio = 1;
	int i = 0;
	int p0 = 0;
	int R = 1;
	int estadoPila = 0;
	int estadosigno=0;
	int estadoinicio = 1;
	int estadorechazo = 10;
	int q0 = 0, q1 = 1, q2 = 2;
	int signo0 = 0, signonum = 1, signos = 2, signoabre = 3, signocierra = 4;
	int contadorabre = 0, contadorcierra = 0;
	int matriz[2][3][5] = { 

							{
								{10, 2, 10, 4, 10},		// (q0,$)	1
								{2, 2, 1, 10, 10},		// (q1,$)	2
								{10, 10, 1, 10, 10}		// (q2,$)	3
							},

							{
								{10, 5, 10, 1, 4},		// (q0,R)	4
								{5, 5, 4, 10, 3},		// (q1,R)	5
								{10, 10, 4, 10, 3}		// (q2,R)	6
							}

						}; //[cimaPila] [estado] [signos]
	//printf("%d", matriz[1][2][4]);
	
	while (reinicio==1)
	{
	int estado = 0;
	int estadoq = 0;
	
	scanf ("%s", &f);		//Leo la entranda

	flength = strlen(f);

	printf("flength= %d \n",flength);		//Muestro la entrada

		for (i=0; i < flength; i++)
		{
			int charAnumero = (f[i] - '0');
			estado=devuelvoestado(charAnumero,estado,estadosigno,estadoinicio,matriz,estadoq);
			printf("\n El estado actual es: %d", estado);
		}

	printf("\n ¿Desea ingresar otra expresion? (1/0): ");
	scanf("%d", &reinicio);
	memset(&f, '\0', sizeof(f));
	}

	/*printf("\n-----FIN 1---- \n\n");
	int x = 1;
	int y = 0;
	y = funcion(matriz, x);*/
	printf("\n FIN: ");

	/*
	//----------------------------------------------------------------------------------------------------------	
	// Automata
	FILE* valores = fopen("valores.txt", "rb");
	if (valores == NULL)
	{
		printf("ERROR-No se pudo abrir el archivo");
		return 1;
	}
	fseek(valores, 0, SEEK_END);
	int cantElem = ftell(valores);
	rewind(valores);
	char* cadena = (char*)calloc(sizeof(char), cantElem);
	int ElemLeidos = fread(cadena, sizeof(char), cantElem, valores);
	if (ElemLeidos != cantElem)
	{
		printf("ERROR- No leyo correctamente");
		return 2;
	}
	printf("CONTENIDO DEL ARCHIVO:\n");
	printf("-------------------------------------------------------------------------------------------------\n");
	printf("%s", cadena);


	------------------------------------------------------------------------


	int matriz[7][7] = { {2,1,6,6,6,6,6},{1,1,1,1,6,6,6},{5,6,6,5,3,6,6},{4,4,4,4,6,4,6},{4,4,4,4,6,4,6},{5,6,6,5,6,6,6},{6,6,6,6,6,6,6} };
	printf("\n\nINICIO DE RECONOCIMIENTO POR UN AFD:\n");
	printf("-------------------------------------------------------------------------------------------------\n\n");
	int i = 0, estado, inicio = 0;
	int numero;
	estado = inicio;
	FILE* salida = fopen("salida.txt", "wb");
	if (valores == NULL)
	{
		printf("ERROR-No se pudo abrir el archivo");
		return 1;
	}
	for (i = 0; i < cantElem + 1; i++)
	{
		numero = (char)cadena[i] - '0';

		if (numero != -4 && numero != -48)
		{
			devuelveestado(numero, estado, inicio, matriz);
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

			}
			else if (estado == 2)
			{
				printf("\tEs cero\n");
				fputs("\t\tEs cero\n", salida);
				estado = inicio;

			}
			else if (estado == 5)
			{
				printf("\tEs octal\n");
				fputs("\t\tEs octal\n", salida);
				estado = inicio;

			}
			else if (estado == 4)
			{
				printf("\tEs hexadecimal\n");
				fputs("\t\tEs hexadecimal\n", salida);

				estado = inicio;
			}
			else if (estado == 6)
			{
				printf("\tNo es valido\n");
				fputs("\t\tNo es valido\n", salida);
				estado = inicio;
			}
		}



	}
	free(cadena);// LIBERA MEMORIA ASIGNADA AL VECTOR
	fclose(valores); //CIERRA ARCHIVO
	return 0;
	//fin*/
}
