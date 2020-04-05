// SSL - TP1.cpp : This file contains the 'main' function. Program execution begins and ends there.
//

#include <iostream>
#include <stdio.h>
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
	int j=0,n = 0;
	char a[]="";
	char prueba[5][16];
	FILE*Valores = fopen("valores.txt", "r");

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
	fclose(Valores); 
	return 0;
}