#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct Info{
	char *tipo;
	char *cadena;
	int extra;
};

typedef struct lista{
struct Info datos;
struct lista *sgte;
}tipoLista;
/*
struct lista *crearnodo();
void muestra(tipoLista *);
int compara (struct Info, tipoLista *);
tipoLista *insertarPrimero (tipoLista * ,struct Info);
tipoLista *insertarOrdenadoeIncrementa (tipoLista *,struct Info);
*/

int comparaAlfabeticamente (struct Info x, tipoLista *nodo){

	int a = strcmpi(x.cadena,nodo->datos.cadena);
	return a;
}

void muestra(tipoLista *lista)
{
	tipoLista *q;
   	q = lista;               /*guarda primer nodo en p*/
   	while (q != NULL)        /*recorre la lista*/
  	 {
    	printf("TIPO: %s\nCADENA: %s\nCANTIDAD: %i\n",q->datos.tipo,q->datos.cadena,q->datos.extra+1);
      	q = q->sgte;               /*avanza nodo p*/
 	 }
  	 printf("\n");
}

tipoLista *insertarPrimero (tipoLista *l,struct Info x){

	tipoLista *q;
	q=malloc(sizeof(struct lista));
	q->datos.tipo=x.tipo;
	q->datos.cadena=x.cadena;
	q->datos.extra=x.extra;

	if(q!=NULL){
		if(l==NULL){
			l=q;
			q->sgte=NULL;
			printf("Lista esta vacia\n");
		}
		else{
			q->sgte=l;
			l=q;
		}
	}
	return q;
}

tipoLista *insertarOrdenadoeIncrementa (tipoLista *l, struct Info x){
	int ind=0;
	tipoLista *q,*p,*ant;
	q=malloc(sizeof(struct lista));
	q->datos.tipo=x.tipo;
	q->datos.cadena=x.cadena;
	q->datos.extra=x.extra;
if(q!=NULL){
		if(l==NULL){
	/*	l=q;
		printf("\nLista esta vacia\n");
		return l;*/
		return insertarPrimero(l,x);
		}
	p=l;
	ant = NULL;	
	int igual=0;
	while (p != NULL && ind == 0) {
		if (comparaAlfabeticamente(x,p) == 0) 
		{
		igual=1;
		ind=1;
		}
    	if (comparaAlfabeticamente(x,p)<= 0) {
		ind = 1;
		}
    		else {
      		ant = p;
      		p = p->sgte;
    		}
  		}
	if(igual==1) {
		if (ant == NULL) { /* inserción al comienzo */
    	l->datos.extra++;
  		}
  		else { /* inserción en medio o al final */
    	ant->sgte->datos.extra++;
    	q->sgte = p;
		}
	}
	else{
  		if (ant == NULL) { /* inserción al comienzo */
    	q->sgte = l;
    	l = q;
  		} 
  		else { /* inserción en medio o al final */
    	ant->sgte = q;
    	q->sgte = p;
 		}
	}
}
	return l;
}