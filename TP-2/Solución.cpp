// SSL - TP1.cpp : This file contains the 'main' function. Program execution begins and ends there.
//

#include <iostream>
#include <stdio.h>
#include <string.h> 
#include <stdlib.h> 
#pragma warning(disable : 4996)

int estadoqprox = 0;

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

};

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

int devuelvesigno (int &caracter/*, int& estadosigno, Pila pila*/,int &estadoq, int &estado,int &inicio, int &estadoqprox) {
	int estadosigno;
	estadoq = estadoqprox;
	if (inicio ==1 && (caracter == 48 || caracter == 45 || caracter == 47 || caracter == 42 || caracter == 43 || caracter == 41))
	{
		printf("Estas ingresando un caracter sin tener en cuenta la semantica de la expresion");
		estado = 10;
		return 0;
	}

	if (caracter == 48){
		printf("ESTA ENTRE 0");
		 estadosigno = 0;
		 estadoqprox = 1;
		return estadosigno;
	}
	if (caracter >= 49 && caracter <= 57)
	{
		printf("ESTA ENTRE 1 Y 9");
		 estadosigno = 1;
		 estadoqprox = 1;
		return estadosigno;
	}
	if ( caracter ==45 || caracter == 47 ||  caracter==42 || caracter==43 )
	{
		printf("ESTA ENTRE OPERADORES");
		estadosigno = 2;
		//printf("EL ESTADO ACTUAL ES --->  %d", matriz[0][estadoq][estadosigno]);
		estadoqprox = 0;
		return estadosigno;
	}
	if (caracter == 40)
	{
		printf("ES ABRE PARENTESIS");
		 estadosigno = 3;
		 estadoqprox = 0;
		return estadosigno;
	//	push(&pila, 3);
	}
	if (caracter == 41)
	{
		printf("ES CIERRA PARENTESIS");
		estadosigno = 4;
		estadoqprox = 2;
		return estadosigno;
	//	push(&pila, 4);
	}
}
/*
int devuelvocimapila (Pila pila,int& estadoPila){

	estadoPila=pop(&pila);
	return estadoPila;
}
*/
int devuelvoestado(int &caracter, int& estado, int& estadosigno, int& estadoinicio, int matriz[2][3][5]/*,Pila pila, int& estadopila*/,int &estadoq, int &inicio) {

	printf("\n %c \n", caracter);

	estadosigno=devuelvesigno(caracter,estadoq,estado,inicio,estadoqprox);

	/*if (estado == 10)
	{
		return 10;
	}
	else
	{*/
		printf("\n ESTADOQ EN FUNCION ES ::: %d",estadoq);
		return matriz[0][estadoq][estadosigno];
	//}
}

int main()
{
	char v = '+';
	int b = v;
	if ((b) == 43) {
		printf("El valor del PARENTESIS ES  ------->  %d\n\n", (v));
	}
	//Pila pila = NULL;
	//int flength = strlen(f);
	char f[256];
	int flength = 0;
	int reinicio = 1;
	int i = 0;
	int p0 = 0;
	int R = 1;
	int inicio = 1;
	int estadoPila = 0;
	int estadosigno=0;
	int estadoinicio = 1;
	int estadorechazo = 10;
	int q0 = 0, q1 = 1, q2 = 2;
	int signo0 = 0, signonum = 1, signos = 2, signoabre = 3, signocierra = 4;
	int contadorabre = 0, contadorcierra = 0;
 //[cimaPila] [estado] [signos]
	//printf("%d", matriz[1][2][4]);
	
	while (reinicio==1)
	{
	int estado = 0;
	int estadoq = 0, estadoqprox=0;
	inicio = 1;
	scanf ("%s", &f);		//Leo la entranda

	flength = strlen(f);

	printf("flength= %d \n",flength);		//Muestro la entrada

		for (i=0; i < flength; i++)
		{
			int charAnumero = (f[i]);
			estado=devuelvoestado(charAnumero,estado,estadosigno,estadoinicio,matriz,estadoq,inicio);

			printf("\n El estado actual es: %d", estado);
			//printf("\n El estado Q es: %d", estadoq);
		//	printf("\n El estado signo es: %d", estadosigno);

			inicio = 0;
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


}
