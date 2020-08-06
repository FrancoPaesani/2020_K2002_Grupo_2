#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

struct Info{
	char *tipo;
	char *cadena;
	int extra;
};

typedef struct lista{
struct Info datos;
struct lista *sgte;
}tipoLista;


int entero(float x){
	if(x>0){return floor(x);}
	else{return ceil(x);}
}

int comparaAlfabeticamente (struct Info x, tipoLista *nodo){

	int a = strcmpi(x.cadena,nodo->datos.cadena);
	return a;
}

void muestraNumeros(tipoLista *lista,int foo(char*,char**,int),char *tipo,int base)
{
	tipoLista *q;
   	q = lista;           
	int total=0;  
	float f=0;
	printf("Categoria: %s\n",q->datos.tipo);
   	while (q != NULL)       
  	 {
		if(strcmpi(tipo,"Real")==0){
		f=atof(q->datos.cadena);
		printf("%s: %s -->",tipo,q->datos.cadena);
		total+=f;
		printf("Entera: %i --> Mantisa: %f\n",entero(f),fabs( f-(entero(f)) ));}

		else{
		printf("%s: %s\n",tipo,q->datos.cadena);
		total+=foo(q->datos.cadena,NULL,base);}

      	q = q->sgte;              
 	 }
	if(strcmpi(tipo,"Real")==0){
	printf("El valor total acumulado de las constantes %s es --> %f",tipo,total);}
	else{
	printf("El valor total acumulado de las constantes %s es --> %i",tipo,total);}
  	printf("\n----------------------------------------------\n");
}

void muestra(tipoLista *lista)
{
	tipoLista *q;
   	q = lista; 
	printf("Categoria: %s\n",q->datos.tipo);
   	while (q != NULL)       
  	 {
		if(strcmp("Identificador",q->datos.tipo)==0 || strcmp("CaracterPuntuacion",q->datos.tipo)==0){
    	printf("CADENA: %s\nCANTIDAD: %i\n\n",q->datos.cadena,q->datos.extra+1);
      	q = q->sgte;              
 	 	}
	    else{printf("CADENA: %s\nCANTIDAD: %i\n",q->datos.cadena,q->datos.extra);
      	q = q->sgte;}
}
  	 printf("\n----------------------------------------------\n");
}

void muestraCadena(tipoLista *lista)
{
	tipoLista *q;
   	q = lista;               
	printf("Categoria: %s\n",q->datos.tipo);
   	while (q != NULL)       
  	 {
    	printf("CADENA: %s\nCANTIDAD: %i\n",q->datos.cadena,q->datos.extra);
      	q = q->sgte;              
 	 }
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

tipoLista *insertaPalabraReservada(tipoLista *l, char *yytext, struct Info x,char *tipo)
{
x.cadena=malloc(sizeof(yytext));

if(strcmpi(tipo,"ComentarioSimple")==0){x.cadena=yytext;}
else{strcpy(x.cadena,yytext);}

x.tipo=tipo;x.extra=0;
l=Enqueue(l,x);
return l;
}

tipoLista *insertarLista(tipoLista *l, char *yytext, struct Info x,char *tipo){
x.cadena=malloc(sizeof(yytext));
strcpy(x.cadena,yytext);
x.tipo=tipo;
if(strcmpi("Identificador",tipo)==0 || strcmpi("CaracterPuntuacion",tipo)==0 )
{x.extra=0;
l=insertarOrdenadoeIncrementa(l,x);
return l;}
if(strcmpi("Literal Cadena",tipo)==0)
{x.extra=strlen(yytext)-2;
l=insertarPrimero(l,x);
return l;}
if(strncmp(tipo,"Digito",6)==0)
{x.extra=0;
l=insertarPrimero(l,x);
return l;
}
}