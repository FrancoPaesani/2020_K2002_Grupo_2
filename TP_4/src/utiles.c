#include "utiles.h"

void* saludar(){
    printf("Bienvenido al Analizador Sint%cctico...\nSTRING API = %i\n",160,STRING);
}

symrec *putsym(char* sym_name, enum API sym_type, int newValue, char* newString,char* parametros){
  symrec *ptr = (symrec *) malloc (sizeof (symrec));
  ptr->name = (char *) malloc (strlen (sym_name) + 1);
  strcpy (ptr->name,sym_name);
  ptr->types = sym_type;
  
  if(sym_type == ENTERO){
  ptr->valor = newValue;
  ptr->cantidadParametros = 0;
  ptr->cadena = NULL;
  ptr->parametros = NULL;
  ptr->next = (struct symrec *)ts;
  ts = ptr;
  return ptr;
  }
  
  else if(sym_type == STRING){
  ptr->next = (struct symrec *)ts;
  ptr->cadena = malloc(strlen(newString) + 1);
  strcpy(ptr->cadena,newString);
  ptr->parametros = NULL;
  ptr->cantidadParametros = NULL;
  ptr->valor = NULL;

  ts = ptr;
  return ptr;
  }
  
  else if(sym_type == FUNCION){
  ptr->next = (struct symrec *) ts;
  ptr->parametros = malloc(strlen(parametros) + 1);
  strcpy(ptr->parametros,parametros);
  ptr->cantidadParametros = newValue;
  ptr->cadena = NULL;
  ptr->valor = NULL;
  ts = ptr;
  return ptr;
  }

  else if(sym_type == UNCHAR){
  printf("Logica no desarrollada\n");
  ptr->next = (struct symrec *)ts;
  ts = ptr;
  return ptr;
  }

}
// seguir con iomplementacion TS en archivo.y   %%%%
symrec *getsym(char* sym_name){
  symrec *ptr;
  for (ptr = ts; ptr != (symrec *) 0; ptr = (symrec *)ptr->next)
    //printf("Nombre TS es --> %s.\n",ptr->name);
    if (strcmp (ptr->name, sym_name) == 0)
      return ptr;
  return 0;
};

void* leerTS(){
  symrec *ptr;
  for (ptr = ts; ptr != (symrec *) 0; ptr = (symrec *)ptr->next)
    printf("Nombre TS es --> %s.\n",ptr->name);
};

void* informeTS(){      //    recorro la lista tantas veces como tipos de datos tengo. Ineficiente pero queda mas lindo en consola y facil de implementar.
  symrec *ptr;

  for(enum API i = ENTERO; i<FUNCION+1; i++){
    char* tipo = malloc(10); tipo = convertirApiAChar(i);
  printf("%%%%%%%%        Empieza registro de %s         %%%%%%%%\n",tipo);
    for (ptr = ts; ptr != (symrec *) 0; ptr = (symrec *)ptr->next){
      if(ptr->types == i){
        printf("Nombre=%s. Tipo=%i. Valor=%i. Cadena=%s. ENUM TipoParametros=(%s). CantidadParametros=%i.\n",ptr->name,ptr->types,ptr->valor,ptr->cadena,ptr->parametros,ptr->cantidadParametros);
      }
   }
  printf("%%%%%%%%        Termina registro de %s         %%%%%%%%\n\n",tipo);
  free(tipo);
  }
}

void* convertirApiAChar(enum API tipo){
  switch (tipo)
  {
  case VACIO:
    return "vacio";
    break;
  case ENTERO:
    return "entero";
    break;
  case STRING:
    return "string";
    break;
  case UNCHAR:
    return "unchar";
    break;
  case FUNCION:
    return "funcion";
  break;

  default:
    return "TIPO INVALIDO. REVISAR FUNCIONALIDAD";
    break;
  }
}

void* _string_append(char* original, char* append){							//global
	realloc(original, strlen(original) + strlen(append) + 1);
	strcat(&original,append);
}

