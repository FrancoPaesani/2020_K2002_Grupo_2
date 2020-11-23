#include <stdio.h>
#include <stdlib.h>
#include <string.h>

enum API{VACIO,ENTERO,STRING,UNCHAR,FUNCION};

void* saludar();

typedef struct symrec
{
  char *name;
  enum API types; //Va a ser un enum con los tipos de datos
  float valor;
  char* cadena;
  char* parametros;
  int cantidadParametros;
  struct symrec *next;
} symrec;

extern symrec *ts;

symrec *putsym(char const*, enum API, int, char*, char*);
symrec *getsym(char const*);
