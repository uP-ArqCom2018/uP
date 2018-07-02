 library IEEE;
 use IEEE.std_logic_1164.all;
 use IEEE.numeric_std.all;
 use std.textio.all;
 

 -- DEBE TENER EN CUENTA QUE LA MAXIMA CANTIDAD DE BITS QUE PUEDEN DIRECCIONAS 'ADDR_i' ES 10 ('size'), QUE SERIAS LOS 10 BITS
                                       -- MENOS SIGNIFICATIVO DE LOS 64 BITS DE ENTRADA. 
entity uP_completo is

     port (
         CLK_i: in std_logic;
         reset: in std_logic;
			SAL_o :out std_logic_vector(15 downto 0));	

		
 end entity uP_completo;
 
 
 architecture MyHDL of uP_completo is

 
 signal CLK_aux: std_logic ;
 signal reset_aux: std_logic ;
 
 
 component uP is
	port(
	      CLK_i: in std_logic;
         reset: in std_logic;
			SAL_o :out std_logic_vector(13 downto 0));
	end component uP;
	
component Div_freq is
	port (
         CLK_i: in std_logic;
         CLK_ot: out std_logic
         );
	end component Div_freq;

 begin
 
uP1: uP
		port map(CLK_aux,reset_aux,SAL_o(13 downto 0));
		
DIV_CLK1: Div_freq

	port map(CLK_i,CLK_aux);
	
	SAL_o (15)<= CLK_aux;
	SAL_o (14)<= reset_aux;
	
	reset_aux<= reset;
	
 end architecture MyHDL;