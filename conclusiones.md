**info Este archivo contiene informacion util sobre los lineamientos
de cada bloque en particular como asi tambien las definiciones del
funcionamiento general del uP.

##Lineamientos generales
======================

*Direccionamiento a byte o palabra ****por definir 
*Memoria de programa y datos de 4kb

##lineamientos por bloques
========================

##Contador de programa (definido)
-------------------------------

ademas del PC este bloque contendra los elementos basicos para el manejo
de saltos.

*Entradas 
  64 bit  <-- ImmGen
  1 bit   <-- ALU(Zero\_o)
  1 bit   <-- UC para salto condicional 
  1 bit   <-- UC para salto incondicional

*Salidas 
D_o --> memoria de programa

##Memoria de programa ()
----------------------

\*Entrada Q\_o \<-- PC

\*Salidas D\_o --\> intruciones

memoria de datos
----------------

mux\_2 interno (dentro del bloque)

\*Entradas Data\_i \<-- Banco de registros ADDR\_i \<-- ALU W/R \<-- UC
mem\_reg \<-- UC

\*Salidas W\_c\_i --\> banco de registros

\#\# ALU mux\_1 interno

*Entrdas R\_a\_o \<-- banco de registros R\_b\_o \<-- banco de registros
64 Bits \<-- ImmGen ALU\_op \<-- ALU ALU\_src \<-- ALU *Salidas

    Y_o   --> memoria de datos
    Zero_o --> contador de programa
