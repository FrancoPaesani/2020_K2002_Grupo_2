Breve explicación del codigo en C.

Construimos un archivo txt "valores.txt" con muchos valores posibles separados por una coma. Para leer el mismo utilizamos las funciones
fopen, fseek (para posicionarnos al final del archivo), ftell (obtener cantidad de caracteres totales) y fread.

Definimos cada uno de los estados necesarios para las transiciones, además del inicial y final. [s1, s2, s3 y s4]. Y además definimos flags
para saber que tipo de dato es, una vez que termina de identificar el tipo de dato(viene coma), se levanta el flag correspondiente
y se termina con la identificación del dato. 

Se entra en un for hasta la cantidad de elementos que hay en el archivo, el cual contiene un choice dependiendo el estado en el que se
encuentra. Cada "case n" representa a un estado en el autómata. Internamente cada case tiene varios if´s para decidir que estado
le prosigue.
Una vez que se llega al último estado, quiere decir que se encontró con la coma y debe reiniciar las variables para el siguiente dato.
