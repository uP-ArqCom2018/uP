 library IEEE;
 use IEEE.std_logic_1164.all;
 use IEEE.numeric_std.all;
 use std.textio.all;
 

 -- DEBE TENER EN CUENTA QUE LA MAXIMA CANTIDAD DE BITS QUE PUEDEN DIRECCIONAS 'ADDR_i' ES 10 ('size'), QUE SERIAS LOS 10 BITS
                                       -- MENOS SIGNIFICATIVO DE LOS 64 BITS DE ENTRADA. 
 entity multi is
    
     port (
     		control: in std_logic;
			In1: in std_logic_vector (63 downto 0);
			In0: in std_logic_vector (63 downto 0);
			Sal: out std_logic_vector (63 downto 0));
			
			
 end entity multi;
 
 architecture MyHDL of multi is
 begin
 
 with control select        -- Multiplexor numero 2.

			Sal<= 	In1 when '1', -- la salida de la memoria se conecta directamente a la entrada 1 del multiplexor.
						In0 when others;
							
		
 end architecture MyHDL;