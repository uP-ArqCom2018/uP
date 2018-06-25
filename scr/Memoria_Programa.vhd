--------------------------------------------------------------------------------
-- Alumnos: Suarez Facundo-Parisi Pablo
--
-- Fecha:   16:04:51 06/04/2018
-- Nombre del diseño: Memoria de Programa   

-- Nombre del proyecto:  Memoria_Programa
-- Dispositivo: --  
-- Herramienta utilizada: Quartus Prime Lite Edition,ISE Xilinx , GHDL
-- Version usada de herramienta:  
-- Descripcion: El objetivo de dicha unidad es proporcionar la instrucción que debe ejecutarse a través de una Memoria
--		que contiene el programa almacenado sobre un arreglo de 2**10 palabras de 1 byte. Al realizar un cambio de la instrucción
--		se proporcionan los valores de las 4 palabras de 1 byte, a través de la concatenación, para determinar la instrucción de 
--		32 palabras que será repartida sobre el Datapath.
--				  
-- 
--Entradas Genericas: 
--					*  anch_inst: Ancho de la palabra en la memoria.
-- 					*  ancho_address: Ancho de la direccion de la palabra.
--
--
--Entradas:			
--					* CLK_i: Señal de sincronismo.
--					* RESET_i: Señal de reinicializacion.
--					* ADDR_i: Indica la dirección donde se determina la dirección de la próxima instrucción que se ejecuta.
--Salidas:					
--					* DATA_o: Instrucción que ejecuta el procesador.
--
-- Dependencias: Librerias ieee, ieee.std_logic_1164, ieee.numeric_std
--				ieee.math_real, ieee.std_logic_misc, std.textio
-- 
-- Revision:
-- Revision 1.00 - Creacion Codigo, simulacion con testbench.
-- Comentarios adicionales:
--		Descripción de Función "Ini_rom_file":
--				Puede decirse que ejecutan tres pasos: En primer lugar se lee una linea de texto desde un archivo
--				a continuación se efectúa la lectura de la linea,en forma de un vector de bits.
--				Por último, se lo convierte en un dato del tipo STD_LOGIC_VECTOR.
-- Notas: 
--		Es posible utilizar el paquete *IEEE.std_logic_textio* en lugar de todas las demás.
--		Dicho planteamiento se deja documentado para una posible futura mejora de la descripción del hardware.
--
--Fuentes utilizadas: 
-- Enlace web: https://ceworkbench.wordpress.com/2014/05/11/initializing-an-fpga-rom-from-a-text-file/
--------------------------------------------------------------------------------

-- Se escriben las librerias y paquetes
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use ieee.std_logic_misc.all;
use std.textio.all;
--use IEEE.std_logic_textio.all;

--Entidad
entity Memoria_Programa is
	generic(
		ancho_inst:		integer := 8;
		ancho_address:	integer := 10
	);
	port(
		CLK_i:	in  std_logic;
		RESET_i:	in	 std_logic;
		ADDR_i:	in	 std_logic_vector(ancho_address-1 downto 0);
		DATA_o:	out std_logic_vector((4*ancho_inst)-1 downto 0)
	);
end Memoria_Programa;

--Arquitectura
architecture Mem_Prog of Memoria_Programa is
	
	--Declaración de tipo arreglo de standar logic vector
	
	type rom_arreglo is array (2**ancho_address-1 downto 0) of std_logic_vector (ancho_inst-1 downto 0);
	


	--Función para lectura de archivo e inicialización de ROM	
	impure function Ini_rom_file (file_name : string) return rom_arreglo is
		file rom_file:			text open read_mode is file_name;
		variable	rom_line:	line;
		variable	rom_value:	bit_vector(ancho_inst-1 downto 0);
		variable	temp:			rom_arreglo;
	begin
		for rom_index in 0 to 2**ancho_address-1 loop
			readline(rom_file,rom_line);
			read(rom_line,rom_value);
			temp(rom_index):=	to_stdlogicvector(rom_value);
		end loop;
		return temp;
	end function;
	
	
	
	--Se crea constante con valor de rom
	constant rom: rom_arreglo	:=Ini_rom_file("Valores_ROM.txt");
	
	--Se comienza la arquitectura
	begin
	
	--Se realiza el proceso de la Rom
	
	process(CLK_i,RESET_i)
		begin

			if RESET_i='1' then
				DATA_o<=(others=>'0');
			elsif(CLK_i'event and CLK_i='1') then
				DATA_o<=rom((to_integer(unsigned(ADDR_i)))) & rom((to_integer(unsigned(ADDR_i)+1))) & rom((to_integer(unsigned(ADDR_i)+2))) & rom((to_integer(unsigned(ADDR_i)+3)));-- & rom((to_integer(unsigned(ADDR_i)+3)));
			end if;
			
	end process;
end Mem_Prog;