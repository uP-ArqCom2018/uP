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
  COMPONENT uP_completo is
     port (
         CLK_i: in std_logic;
         reset: in std_logic;
         SAL_o :out std_logic_vector(13 downto 0));	

  END COMPONENT; 
  
 
	SIGNAL CLK_i: std_logic;
	SIGNAL reset: std_logic;
	SIGNAL SAL_o: std_logic_vector(13 downto 0);
  
BEGIN


micro: uP
		port map(CLK_i,reset,SAL_o);

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
		wait for 40000 ns;

	end process;
  -- put concurrent statements here.
END ARCHITECTURE Behavioral; -- Of entity uP_tb
