#include "utiles.h"

void* saludar(){
    printf("Bienvenido al Analizador Sint%cctico...\nSTRING API = %i\n",160,STRING);
}

symrec *putsym(char const *sym_name, enum API sym_type, int newValue, char* newString){
  symrec *ptr = (symrec *) malloc (sizeof (symrec));
  ptr->name = (char *) malloc (strlen (sym_name) + 1);
  strcpy (ptr->name,sym_name);
  ptr->types = sym_type;
  if(sym_type == VAR){
  ptr->valor = newValue;
  ptr->next = (struct symrec *)ts;
  ts = ptr;
  return ptr;
  }
  else if(sym_type == STRING){
  ptr->next = (struct symrec *)ts;
  ptr->cadena = malloc(strlen(newString) + 1);
  strcpy(ptr->cadena,newString);
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
symrec *getsym(char const *sym_name){
  symrec *ptr;
  for (ptr = ts; ptr != (symrec *) 0;
       ptr = (symrec *)ptr->next)
    if (strcmp (ptr->name, sym_name) == 0)
      return ptr;
  return 0;
}
