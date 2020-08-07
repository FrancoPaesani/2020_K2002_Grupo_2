#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

char *vectorReservadas[5]={"TIPO_DATO","FUNCION","DATO_RETORNO","CLASE_ALMACENAMIENTO","MANEJO_DATO"};

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

void muestraNumeros(tipoLista *lista,char *tipo,int base)
{
	if(lista==NULL){return;}
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

		else if(strcmpi(tipo,"Decimal")==0){
		printf("%s: %s\n",tipo,q->datos.cadena);
		total+=strtol(q->datos.cadena,NULL,base);}
		else{int i=strtol(q->datos.cadena,NULL,base);
			printf("%s: %s --> Valor decimal: %i\n",tipo,q->datos.cadena,i);
		total+=strtol(q->datos.cadena,NULL,base);}

      	q = q->sgte;              
 	 }
	if(strcmpi(tipo,"Decimal")==0){
	printf("El valor total acumulado de las constantes %s es --> %i",tipo,total);}
  	printf("\n\n----------------------------------------------\n\n");
}

void muestra(tipoLista *lista)
{
	if(lista==NULL){return;}
	tipoLista *q;
   	q = lista;
	printf("\n----------------------------------------------\n");
	printf("Categoria: %s\n",q->datos.tipo);
   	while (q != NULL)       
  	 {
		if(strcmp("PalabraReservada",q->datos.tipo)==0)
		{
		printf("%s -----> LEXEMA: %s\n",vectorReservadas[q->datos.extra],q->datos.cadena);
      	q = q->sgte;	
		}

		else if(strcmp("Identificador",q->datos.tipo)==0 || strcmp("CaracterPuntuacion",q->datos.tipo)==0){
    	printf("LEXEMA: %s\nCANTIDAD: %i\n\n",q->datos.cadena,q->datos.extra+1);
      	q = q->sgte;              
 	 	}
	       else if(strcmp("Literal Cadena",q->datos.tipo)==0){printf("LEXEMA: %s\nLENGTH: %i\n",q->datos.cadena,q->datos.extra);
      	q = q->sgte;}
		  else if(strcmp("NoReconocido",q->datos.tipo)==0){printf("LEXEMA: %s\nLINEA: %i\n",q->datos.cadena,q->datos.extra);
      	q = q->sgte;}
		  else{printf("LEXEMA: %s\n",q->datos.cadena);
      	q = q->sgte;}
}
  	 printf("\n----------------------------------------------\n");
}
/*
void muestraCadena(tipoLista *lista)
{
	if(lista==NULL){return;}
	tipoLista *q;
   	q = lista;               
	printf("Categoria: %s\n",q->datos.tipo);
   	while (q != NULL)       
  	 {
    	printf("LEXEMA: %s\nCANTIDAD: %i\n",q->datos.cadena,q->datos.extra);
      	q = q->sgte;              
 	 }
	 printf("\n----------------------------------------------\n");
}*/


tipoLista *insertarPrimero (tipoLista *l,struct Info x){

	tipoLista *q;
	q=malloc(sizeof(struct lista));
	q->datos.tipo=malloc(sizeof(x.tipo));
	q->datos.tipo=x.tipo;
	q->datos.cadena=malloc(sizeof(x.cadena));
	strcpy(q->datos.cadena,x.cadena);
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
	return l;
}

tipoLista *insertarOrdenadoeIncrementa (tipoLista *l, struct Info x){
	int ind=0;
	tipoLista *q,*p,*ant;
	q=malloc(sizeof(struct lista));
		q->datos.tipo=malloc(sizeof(x.tipo));
	q->datos.tipo=x.tipo;
	q->datos.cadena=malloc(sizeof(x.cadena));
	strcpy(q->datos.cadena,x.cadena);
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
 
if(frente == NULL ) 
{
  frente = nuevo_nodo;
}
else
{                  
 tipoLista *aux;
 
 aux = frente;
 
 while(aux->sgte!=NULL)
 aux = aux -> sgte;
 
 aux->sgte = nuevo_nodo;
}

return frente;
}
/*
tipoLista *Dequeue(tipoLista *frente)
{

tipoLista *aux;

aux = frente;

frente = frente -> sgte;

free(aux);

return frente;  
}*/
/*
void* muestraDequeue (tipoLista *lista){
	tipoLista *q;
	q=Dequeue(lista);
	printf("Categoria: %s\n",q->datos.tipo);
   	while (q != NULL)       
  	 {
    	printf("CADENA: %s\nCANTIDAD: %i\n",q->datos.cadena,q->datos.extra);
      	q = q->sgte;              
 	 }
	 printf("\n----------------------------------------------\n");
}*/

tipoLista *insertaPalabraReservada(tipoLista *l, char *yytext, struct Info x,char *tipo)
{
x.cadena=malloc(sizeof(yytext));
strcpy(x.cadena,yytext);
x.tipo=malloc(sizeof(tipo));
x.tipo=tipo;

l=Enqueue(l,x);
return l;
}

tipoLista *insertarLista(tipoLista *l, char *yytext, struct Info x,char *tipo){
x.cadena=malloc(sizeof(yytext));
strcpy(x.cadena,yytext);
x.tipo=malloc(sizeof(tipo));
x.tipo=tipo;
if(strcmpi("Identificador",tipo)==0 || strcmpi("CaracterPuntuacion",tipo)==0 )
{x.extra=0;
l=insertarOrdenadoeIncrementa(l,x);
}
if(strcmpi("Literal Cadena",tipo)==0)
{x.extra=strlen(x.cadena);
l=insertarPrimero(l,x);
}
if(strncmp(tipo,"Digito",6)==0 || strncmp(tipo,"ComentarioSimple",6)==0)
{x.extra=0;
l=insertarPrimero(l,x);
}
free(x.cadena);
free(x.tipo);
return l;
}