#include <stdio.h>
#include <stdlib.h>
#include <string.h>

enum API{VACIO,ENTERO,STRING,UNCHAR,FUNCION};

void* saludar();

typedef struct symrec
{
  char *name;
  enum API types; //Va a ser un enum con los tipos de datos
  int valor;
  char* cadena;
  char* parametros;
  int cantidadParametros;
  struct symrec *next;
} symrec;

extern symrec *ts;

symrec *putsym(char*, enum API, int, char*, char*);
symrec *getsym(char*);
void* leerTS();
void* informeTS();
void* convertirApiAChar(enum API tipo);
void* _string_append(char* original, char* append);
