---- PROGRAM COUNTER uP RISC V
---- MATERIA ARQUITECTURA DE COMPUTADORAS - UNSL
---  AUTORES: FRANCALANCIA MARIANO, GONZALEZ ROBERTO


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity PC is
generic (N: integer :=32;
			anchodataout: integer :=10); ---para compatibilidad colocar 10
	
	port( D_o: out std_logic_vector(anchodataout-1 downto 0); ----- a fin de compatibilizar con MEM Instruccion
			CLOCK_i: in std_logic;
			IMGEN_i: in std_logic_vector(2*N-1 downto 0);
			INCOND_i: in std_logic;
			COND_i: in std_logic;
			ZERO_i: in std_logic;
			RESET_i: in std_logic
			);
end PC;

			
architecture arq_PC of PC is
	signal sum32_s: std_logic_vector(anchodataout-1 downto 0);
	signal Do_s: std_logic_vector(anchodataout-1 downto 0);
	signal mux: std_logic;
	signal aux: std_logic_vector((2*N)-1 downto 0);
	signal Dext_s: std_logic_vector((2*N)-1 downto 0);
	signal Sumext_s: std_logic_vector((2*N)-1 downto 0);
	CONSTANT cuatro : unsigned(anchodataout-1 downto 0) := "0000000100";
	begin

extension: process (IMGEN_i) 
begin
  Dext_s <=std_logic_vector(shift_left(unsigned(IMGEN_i),1));
end process;

carga: process (Do_s) 
begin 
  for i in 0 to anchodataout-1 loop
  aux(i) <= Do_s(i);
  end loop;
  
  for j in anchodataout to (2*N)-1 loop
  aux(j) <= '0';
  end loop;
  
 end process;
 
suma: process (aux, Dext_s)
 begin
   Sumext_s <= std_logic_vector(unsigned(Dext_s)+unsigned(aux));
 end process;
 
formato: process (Sumext_s)
	begin
	for i in 0 to anchodataout-1 loop
	 sum32_s(i) <= Sumext_s(i);
	end loop;
end process;
	
main: process (CLOCK_i,mux,Do_s,RESET_i,ZERO_i,COND_i,INCOND_i)
	begin 
	mux <= INCOND_i OR (ZERO_i AND COND_i);
	
	if (RESET_i='1') then 
	 Do_s <= (others => '0');
	elsif (CLOCK_i'event and CLOCK_i='1') then
	  case mux is
	    when '0' =>
		 
	      Do_s <= std_logic_vector(unsigned(Do_s) + cuatro) ;
	    
		 when others =>
	      Do_s <= sum32_s;
	  end case;
	end if;
  D_o <= std_logic_vector(Do_s);
 end process;
end arq_PC;  
	 
		