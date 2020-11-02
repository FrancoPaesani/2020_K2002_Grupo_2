#include <stdio.h>
#include <stdlib.h>
#include <string.h>

enum API{VAR,STRING,UNCHAR};

void* saludar();

typedef struct symrec
{
  char *name;
  enum API types; //Va a ser un enum con los tipos de datos
  int valor;
  char* cadena;
  struct symrec *next;
} symrec;

extern symrec *ts;

symrec *putsym(char const*, enum API, int, char*);
symrec *getsym(char const*);