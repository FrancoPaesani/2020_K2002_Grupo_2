//#include <iostream>
#include <stdio.h>
#include <string.h> 
#include <stdlib.h> 
#pragma warning(disable : 4996)

int operadoresAcumulados = 0;
int cantidadParentesis = 0;
int estadoPilaprox = 0;
int estadoqprox = 0;
int estadoPila = 0;
int estadoq = 0;
int estado = 0;
int hayletras = 0;


int matriz[2][3][5] = {

						{
							{10, 2, 10, 4, 10},		// (q0,$)	1
							{2, 2, 1, 10, 10},		// (q1,$)	2
							{10, 10, 1, 10, 10}		// (q2,$)	3
						},

						{
							{10, 5, 10, 1, 10},		// (q0,R)	4
							{5, 5, 4, 10, 3},		// (q1,R)	5
							{10, 10, 4, 10, 3}		// (q2,R)	6
						}

};



typedef struct _nodo {
	char dato;
	struct _nodo* siguiente;
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

char pop(Pila* pila) {
	pNodo nodo;
	char v;

	nodo = *pila;
	if (!nodo) return 0;
	*pila = nodo->siguiente;
	v = nodo->dato;
	free(nodo);

	return v;
}

int devuelvesigno(Pila* pila, int caracter, int inicio) {
	int estadosigno;
	estadoPila = estadoPilaprox;
	if (inicio == 1 && (caracter == 48 || caracter == 45 || caracter == 47 || caracter == 42 || caracter == 43 || caracter == 41))
	{
		printf("Estas ingresando un caracter sin tener en cuenta la semantica de la expresion");
		return 0;
	}
	estadoq = estadoqprox;

	if (caracter == 48) {
		estadosigno = 0;
		estadoqprox = 1;
		operadoresAcumulados = 0;
		return estadosigno;
	}
	if (caracter >= 49 && caracter <= 57)
	{
		estadosigno = 1;
		estadoqprox = 1;
		operadoresAcumulados = 0;
		return estadosigno;
	}
	if (caracter == 45 || caracter == 47 || caracter == 42 || caracter == 43)
	{
		estadosigno = 2;
		estadoqprox = 0;
		operadoresAcumulados++;
		return estadosigno;
	}
	if (caracter == 40)
	{
		estadosigno = 3;
		estadoqprox = 0;
		push(pila, '(');
		estadoPilaprox = 1;
		cantidadParentesis++;
		operadoresAcumulados = 0;
		return estadosigno;
	}
	if (caracter == 41)
	{
		estadosigno = 4;
		estadoqprox = 2;
		push(pila, ')');
		cantidadParentesis++;
		operadoresAcumulados = 0;
		return estadosigno;
	}
	else {
		estado = 10;
		hayletras = 1;
		printf("\nEstas ingresando un caracter de texto, la expresion no es valida.\n");
		return 0;
	}
}

int main()
{
	char f[256];
	int flength = 0;
	int reinicio = 1;
	int i = 0;
	int inicio = 1;
	int estadosigno = 0;
	int estadoinicio = 1;
	int estadorechazo = 10;
	int caracter;
	int contadorabre = 0, contadorcierra = 0;
	int cont = 0;
	Pila* pila = (Pila*)malloc(sizeof(Pila));
	while (reinicio == 1)
	{
		hayletras = 0;
		operadoresAcumulados = 0, estadosigno = 0, estadoPila = 0;
		cantidadParentesis = 0, estado = 0, estadoq = 0, estadoqprox = 0;
		inicio = 1;
		cont = 0;
		printf("\n Ingrese una expresion matematica: ");
		scanf("%s", &f);		//Leo la entrada

		flength = strlen(f);

		for (i = 0; i < flength; i++)
		{
			if (f[i] != NULL) {
				estadoq = estadoqprox;
				int charAnumero = (f[i]);
				estadosigno = devuelvesigno(pila, charAnumero, inicio);

				estado = matriz[estadoPila][estadoq][estadosigno];

				if (estado == 10) {

					i = flength;
				}
				inicio = 0;
			}
		}

		int contAbre = 0, contCierra = 0;
		for (i = 0; i < cantidadParentesis; i++)
		{
			char parentesis = pop(pila);

			if (parentesis == '(') {
				contAbre++;
			}
			else
			{
				contCierra++;
			}

		}

		if (contAbre != contCierra && estado!=10)
		{
			if (contAbre > contCierra) {
				printf("\nLa expresion ingresada no es valida porque no cerraste %d parentesis.\n", contAbre - contCierra);
			}
			else
			{
				printf("\nLa expresion ingresada no es valida porque cerraste %d parentesis de mas.\n", contCierra - contAbre);
			}
		}
		else

			if (operadoresAcumulados != 0) {
				printf("\n Pusiste %d o mas operadores acumulados, la expresion no es valida.\n", operadoresAcumulados);
			}

			else if (estado == 10) {
				printf("\n La expresion no es valida porque no pusiste un operador junto al parentesis\n");
				i = flength;
			}
			else if (contAbre == contCierra && hayletras!=1 ) {
				printf("\nLa expresion ingresada es correcta.\n");
			}

		printf("\nDesea ingresar otra expresion? \n 1 --> Continuar \n 0 --> Salir .: \n");
		scanf("%d", &reinicio);
		memset(&f, '\0', sizeof(f));
	}
	printf("\n FIN: ");
}