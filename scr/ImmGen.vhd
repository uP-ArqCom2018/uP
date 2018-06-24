-- Figura 2.4 The RISC-V Instruction Set Manual, Volume I: User-Level ISA, Document Version 2.2

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY ImmGen IS
  GENERIC(
    len_i : integer := 32;  -- Longitud de la instruccion de entrada
    len_o : integer := 64);  -- Longitud de la instruccion de salida
    PORT(
      Inst_i : IN     std_logic_vector(len_i - 1 downto 0);  -- Instruccion de entrada
      Inmed_o : OUT    std_logic_vector(len_o - 1 downto 0) -- Inmediato de salida 
      );   
END ENTITY ImmGen;   

ARCHITECTURE Behavioral OF ImmGen IS

BEGIN 

	PROCESS (Inst_i) IS
  		
	BEGIN	
		    	
   	if Inst_i(6 downto 0) = "0000011" or Inst_i(6 downto 0) = "0010011" or Inst_i(6 downto 0) = "1100111" then -- I-type
   		Inmed_o(0) <= Inst_i(20);
   		Inmed_o(4 downto 1) <= Inst_i(24 downto 21);
   		Inmed_o(10 downto 5) <= Inst_i(30 downto 25);
   		Inmed_o(len_o -1 downto 11) <= (OTHERS=>Inst_i(31));
	    	
   	elsif Inst_i(6 downto 0) = "0100011" then -- S-type
   		Inmed_o(0) <= Inst_i(7);
   		Inmed_o(4 downto 1) <= Inst_i(11 downto 8);
   		Inmed_o(10 downto 5) <= Inst_i(30 downto 25);
   		Inmed_o(len_o - 1 downto 11) <= (others => Inst_i(31));   
	    	
   	elsif Inst_i(6 downto 0) = "1100011" then  -- SB-type
  		Inmed_o(0) <= '0';
   		Inmed_o(4 downto 1) <= Inst_i(11 downto 8);
   		Inmed_o(10 downto 5) <= Inst_i(30 downto 25);
   		Inmed_o(11) <= Inst_i(7);
   		Inmed_o(len_o - 1 downto 12) <= (others => Inst_i(31));
    	
   	elsif Inst_i(6 downto 0) = "0110111" then  -- U-type 
   		Inmed_o(11 downto 0) <= (others => '0');
   		Inmed_o(19 downto 12) <= Inst_i(19 downto 12);
   		Inmed_o(30 downto 20) <= Inst_i(30 downto 20);
   		Inmed_o(len_o - 1 downto 31) <= (others => Inst_i(31));	
	    	
   	elsif Inst_i(6 downto 0) = "1101111" then  -- UJ-type 
   		Inmed_o(0) <= '0';
   	    Inmed_o(4 downto 1) <= Inst_i(24 downto 21);
   		Inmed_o(10 downto 5) <= Inst_i(30 downto 25);	    		
   		Inmed_o(11) <= Inst_i(20);
   		Inmed_o(19 downto 12) <= Inst_i(19 downto 12);
   		Inmed_o(len_o - 1 downto 20) <= (others => Inst_i(31));
   	
   	end if;    		    			    			    		
	
	END PROCESS ;

END ARCHITECTURE Behavioral; -- Of entity ImmGen

