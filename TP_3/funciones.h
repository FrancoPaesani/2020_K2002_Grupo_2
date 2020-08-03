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

int comparaAlfabeticamente (struct Info x, tipoLista *nodo){

	int a = strcmpi(x.cadena,nodo->datos.cadena);
	return a;
}

void muestraID(tipoLista *lista)
{
	tipoLista *q;
   	q = lista;               
   	while (q != NULL)       
  	 {
    	printf("TIPO: %s\nCADENA: %s\nCANTIDAD: %i\n",q->datos.tipo,q->datos.cadena,q->datos.extra+1);
      	q = q->sgte;              
 	 }
  	 printf("\n");
}

void muestraCadena(tipoLista *lista)
{
	tipoLista *q;
   	q = lista;               
   	while (q != NULL)       
  	 {
    	printf("TIPO: %s\nCADENA: %s\nCANTIDAD: %i\n",q->datos.tipo,q->datos.cadena,q->datos.extra);
      	q = q->sgte;              
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
		if (ant == NULL) {
    	l->datos.extra++;
  		}
  		else { 
    	ant->sgte->datos.extra++;
    	q->sgte = p;
		}
	}
	else{
  		if (ant == NULL) {
    	q->sgte = l;
    	l = q;
  		} 
  		else { 
    	ant->sgte = q;
    	q->sgte = p;
 		}
	}
	}
	return l;
}

// ---------------------------------- //

tipoLista *Enqueue(tipoLista *frente, struct Info x)
{
 tipoLista *nuevo_nodo;
    
 nuevo_nodo = (tipoLista*)malloc(sizeof(tipoLista));
 
 nuevo_nodo->datos=x;
 
 nuevo_nodo->sgte=NULL;
 
if(frente == NULL ) /* Si esta vacia la cola */
{
  frente = nuevo_nodo;
}
else
{                  /* Insertar al final */
 tipoLista *aux;
 
 aux = frente;
 
 while(aux->sgte!=NULL)
 aux = aux -> sgte;
 
 aux->sgte = nuevo_nodo;
}

return frente;
}

tipoLista *Dequeue(tipoLista *frente)
{

tipoLista *aux;

aux = frente;

frente = frente -> sgte;

free(aux);

return frente;  
}
