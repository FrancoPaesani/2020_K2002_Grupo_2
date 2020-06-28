#include <stdio.h>
#include <stdlib.h>

/*struct constante{
    
char tipo[50];    
char *valor;  

};
*/

typedef struct nodo{
    
char *info;
struct nodo *sgte;
    
}tipoNodo;


typedef tipoNodo *LISTA;
typedef tipoNodo *pANodo;



void insertarALista(LISTA *lista, char *cadena)
{
    
    pANodo nuevo_nodo;
    
    nuevo_nodo = malloc(sizeof (tipoNodo));
    
    nuevo_nodo->info = cadena;
    
    if(*lista == NULL) 
    {
    *lista = nuevo_nodo;
    nuevo_nodo->sgte = NULL;
    }
    else
    {
        pANodo aux;
        
        aux = *lista;
        *lista = nuevo_nodo;
        nuevo_nodo->sgte = aux;
        
    }

    return;
}


void mostrarLista(LISTA *lista)
{
    
    pANodo aux;
    
    aux = *lista;
    
   while(aux->sgte!=NULL)
    {
      printf("valor: %s  \n",aux->info);
      aux = aux -> sgte;
        
    }
    
    return;
}
