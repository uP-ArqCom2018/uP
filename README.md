# Repositorio del Microprocesador

** info
 Este archivo contiene información útil sobre los lineamientos 
de cada bloque en particular como así también las definiciones
del funcionamiento general del uP.
Aquí se encuentra el repositorio del Microprocesador.


Carpetas existentes:

* **doc** Incluye la documentación.
* **src** Incluye las fuentes del proyecto.
* **testbench** Incluye los archivos de simulacion.

## Descripción de funcionamiento
Aquí se describe como funciona el módulo.

### Lineamientos generales para nombres:
Al escribir el nombre de algún puerto, señal o variable, deben seguirse
los siguientes lineamientos:

* Puertos:

    *Entradas: < NOMBRE EN MAYUSCULA >_i
    
    *Salidas: < NOMBRE EN MAYUSCULA >_o

* Señales:

    *Entradas: < nombre en minúscula >_i
    
    *Salidas: < nombre en minúscula >_o


## Lineamientos generales

Direccionamiento a byte 

Memoria de programa y datos de 4kb

## lineamientos por bloques

### Contador de programa 

Además del PC este bloque contendra los elementos básicos 
para el manejo de saltos.

* Entradas

      64  bit       <-- ImmGen
      Zero_o        <--  ALU 
      cond_Brach    <--  UC  
      uncond_Brach  <--  UC 
  
* Salidas

      D_o --> Memoria de programa 

### Memoria de programa 
* Entrada

      Q_o <-- PC

* Salidas

      D_o --> intruciones

### Memoria de datos 
 mux_2 interno (dentro del bloque) 
 
* Entradas 
  
      Data_i <-- Banco de registros
      ADDR_i <-- ALU
      W/R    <-- UC
      mem_reg <-- UC
  
 * Salidas
 
      W_c_i --> Banco de registros
 
 ### ALU 
 mux_1 interno
  
    * Entradas
  
      R_a_o   <-- Banco de registros
      R_b_o   <-- Banco de registros
      64 Bits <-- ImmGen
      ALU_op  <-- ALU
      ALU_src <-- ALU
  
    * Salidas
  
      Y_o    --> Memoria de datos
      Zero_o --> Contador de programa
    
 ## UC
  ALU_op es de 4 bits 
 
    * Entradas
 
      instruccion <-- Memoria de programa
 
    * Salidas
 
      ALU_op        -->  ALU
      ALU_sr        -->  ALU  
      Reg_w_i       --> Banco de registros
      R/W           --> Memeria de datos
      mem_reg       --> Memoria de datos 
      cond_Brach    --> Program counter 
      uncond_Brach  --> Program counter
