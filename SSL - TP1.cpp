// SSL - TP1.cpp : This file contains the 'main' function. Program execution begins and ends there.
//

#include <iostream>
#include <stdio.h>
#include <string.h> 
#include <stdlib.h> 
#pragma warning(disable : 4996)



/*
struct info {
	char dato[36];
	char tipo[16];
};
*/

int main()
{
	//info tabla[4]; 
/*	int j=0,n = 0, x=0;
	char a[]="";
	int cant=5;
	char prueba[5][16];*/
	
	
	//-----------------------------------------------------
	//comienzo
	//Lee el archivo

	FILE*valores = fopen("valores.txt", "rb");
	if(valores == NULL)
	{printf("ERROR-No se pudo abrir el archivo");
	 return 1;
	}
	fseek(valores,0,SEEK_END);
	int cantElem=ftell(valores);
	rewind(valores);
	char * cadena =(char*) calloc(sizeof(char),cantElem);
	int ElemLeidos= fread(cadena,sizeof(char),cantElem,valores);
	if(ElemLeidos!=cantElem)
	{
		printf("ERROR- No leyo correctamente");
		return 2;
	} 
	 	printf("%s",cadena);
	//---------------------------------------------------------------------------------------------------------
	//testeo como los trae tanto en formato char o int 
		printf("\n%d",(char)cadena[12]-'0');
		int a= (char)cadena[12]-'0';
		//a++;
		printf("\n%d",a);
		char aw=cadena[12];
		printf("\n%d\n",aw);
	//----------------------------------------------------------------------------------------------------------	
	// Automata
		int i=0,estado,inicio=0,fin=1;
		bool valido=true;
		int numero;
		int pos=0;
		for(i=0;i<cantElem;i++) 
		{   
			estado=inicio;
			switch(estado) 
			{
				case 0:
					numero= (char)cadena[i]-'0';
					if(numero>=0&&numero<=7)
					{
						estado=inicio;
					}
					else
					{
					  estado=fin;
					}
					break;
				case 1:
					valido=false;
				    
					break;
			default:
			break;
			}
				printf("%d",(char)cadena[i]-'0');
			if(valido==false)
			{
				printf("no es octal");
				
			}
			
			
		}
	free(cadena);
	fclose(valores); 
	return 0;
    //fin
    //---------------------------------------------------------------------------------------------------------------
/*	

	while (!feof(Valores))
	{
		while ((n == 0 || strcspn(a, ",") && !feof(Valores)))
		{
			
			fread(&a[0], 1, 1, Valores);

			if (a[0] != ',' and !feof(Valores))
			{
				//tabla[j].dato[n] = a[0];
				prueba[j][n]=a[0];
				printf("%c", prueba[j][n]);
				//printf("%c", tabla[j].dato[n]);
				n++;
			}
			else
			{
				a[0] = ',';
			}
		}
		printf("\n");
		n = 0;
		j++;
		printf("\nsalgo de bucle\n");
	}
	
	for(x=0;x<cant;x++)
	{ int j=0;
	  int estado=0;
	  
	  while((char)prueba[x][j]!='\0') 
	  	{
	  		
	  		printf("%c", prueba[x][j]);
	  		j++;
    	}
    	printf("\n");
	/*	while((char)prueba[x][j]!='\0'&&estado==0)
     	{
     		switch(estado) 
			 {
     			case 0:
     				int num = (char)prueba[x][j] - '0';
				 if(num>=0 && num<=7)
				 {
				 	estado=0;
				 }
				 else
				 {
				 	estado= 1;
				 	printf("\nno es octal \n");
				 }
				 break;
				
	           
           }
			j++;
			
		}*/
		/*if(estado ==1)
		{
			printf("No es octal: %d \n");
		}
		
	}*/
	
	/*int cant= */
	//printf("%d",cant);

}

