-- Test bench microprocesador: se realiza la prueba de un código
-- simple que debe resolver una iteración, leyendo y escribiendo
-- en memoria de datos.
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY uP_tb IS
END ENTITY uP_tb;

ARCHITECTURE Behavioral OF uP_tb IS
  -- put declarations here.
  COMPONENT uP is
     generic(
	 bit_dir_reg : integer :=5;
	 n_reg : integer := 64; 
	 ancho_inst: integer := 8;
	 ancho_address:integer := 10;
	 N: integer :=32;
	 anchodataout: integer :=32;
	 opcode	:	integer	:=	32
	  );
     port (
         CLK_i: in std_logic;
         reset: in std_logic);
  END COMPONENT; 
  
 
	SIGNAL CLK_i: std_logic;
	SIGNAL reset: std_logic;
  
BEGIN


micro: uP
		port map(CLK_i,reset);

stimul_clk: process 
	begin
		CLK_i <= '1';
		wait for 100 ns;
	
		CLK_i <= '0';
   		wait for 100 ns;
	end process;

estimulos: process
	begin
		reset<='0';
		wait for 200 ns;
		reset <='1';
		wait for 100000 ns;

	end process;
  -- put concurrent statements here.
END ARCHITECTURE Behavioral; -- Of entity uP_tb
