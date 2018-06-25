# Repositorio del Microprocesador

** info
 Este archivo contiene informacion util sobre los lineamientos 
de cada bloque en particular como asi tambien las definiciones
del funcionamiento general del uP.
Aqui se encuentra el repositorio del Microprocesador.


Carpetas existentes:

* **doc** incluye la documentacion.
* **src** incluye las fuentes del proyecto.
* **testbench** incluye los archivos de simulacion.

## Descripcion de funcionamiento
Aqui se describe como funciona el modulo.

### Lineamientos generales para nombres:
Al escribir el nombre de algun puerto, senal o variable, deben seguirse
los siguientes lineamientos:

* Puertos:

    *Entradas: < NOMBRE EN MAYUSCULA >_i
    
    *Salidas: < NOMBRE EN MAYUSCULA >_o

* Señales:

    *Entradas: < nombre en minuscula >_i
    
    *Salidas: < nombre en minuscula >_o


## Lineamientos generales

Direccionamiento a byte 

Memoria de programa y datos de 4kb

## lineamientos por bloques

### Contador de programa 

ademas del PC este bloque contendra los elementos basicos 
para el manejo de saltos.

* Entradas

      64  bit       <-- ImmGen
      Zero_o        <--  ALU 
      cond_Brach    <--  UC  
      uncond_Brach  <--  UC 
  
* Salidas

      D_o --> memoria de programa 

### Memoria de programa 
* Entrada

      Q_o <-- PC

* Salidas

      D_o --> intruciones


### memoria de datos 
 mux_2 interno (dentro del bloque) 
 
* Entradas 
  
      Data_i <-- Banco de registros
      ADDR_i <-- ALU
      W/R    <-- UC
      mem_reg <-- UC
  
 * Salidas
 
      W_c_i --> banco de registros
 
 ### ALU 
 mux_1 interno
  
    * Entradas
  
      R_a_o   <-- banco de registros
      R_b_o   <-- banco de registros
      64 Bits <-- ImmGen
      ALU_op  <-- ALU
      ALU_src <-- ALU
  
    * Salidas
  
      Y_o   --> memoria de datos
      Zero_o --> contador de programa
    
 ## UC
  ALU_op es de 4 bits 
 
    * Entradas
 
      instruccion <-- memoria de programa
 
    * Salidas
 
      ALU_op      -->  ALU
      ALU_sr      -->  ALU  
      Reg_w_i     --> banco de registros
      R/W         --> memeria de datos
      mem_reg     --> memoria de datos 
      cond_Brach  --> program counter 
      uncond_Brach  --> program counter