--Grupo: 
			--Duperre,Ezquiel
			--Oviedo,Claudio
--
 library IEEE;
 use IEEE.std_logic_1164.all;
 use IEEE.numeric_std.all;
 use std.textio.all;
 
                                       
 entity uP is
     generic(
	 bit_dir_reg : integer :=5;
	 n_reg : integer := 64; 
	 ancho_inst: integer := 8;
	 ancho_address:integer := 10;
	 N: integer :=32;
	 anchodataout: integer :=32
	  );
     port (
         CLK_i: in std_logic;
         reset: in std_logic);			
 end entity;
 
 architecture MyHDL of uP is
 
 
-- Componentes
 
	-- Contador de programas
	-- Autores:Gonzales,Francalancia
	component PC is
	generic (N: integer :=32;
			anchodataout: integer :=10); --para compatibilidad colocar 10
	
	port( D_o: out std_logic_vector(anchodataout-1 downto 0); ----- a fin de compatibilizar con MEM Instruccion
			CLOCK_i: in std_logic;
			IMGEN_i: in std_logic_vector(2*N-1 downto 0);
			INCOND_i: in std_logic;
			COND_i: in std_logic;
			ZERO_i: in std_logic;
			RESET_i: in std_logic
			);
	end component PC;
  
  
  -- Componente: Memoria de Programa
  -- Autoes:Suarez,Parisi
  component Memoria_Programa is
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
  end component Memoria_Programa;
  
  -- Componente: Banco de registros
  -- Autoes:Postemsky,Villarreal
  component bank_reg IS
  GENERIC(
    n_reg : integer := 64;  -- cantidad de bits registros
    bit_dir_reg : integer := 5);  -- cantidad de bits de direccionamiento a registros
    PORT(
      A_i : IN     std_logic_vector(bit_dir_reg-1 downto 0);
      B_i : IN     std_logic_vector(bit_dir_reg-1 downto 0);
      C_i : IN     std_logic_vector(bit_dir_reg-1 downto 0);    
      Reg_W_i: IN		std_logic;
      RST_i: IN std_logic;
      CLK_i : IN     std_logic;  -- Se propone eliminar el reloj, ya que registra las entradas y no permite que el uP funcione en un solo clock por instruccion
      W_c_i : IN     std_logic_vector(n_reg-1 downto 0);
      R_a_o : OUT    std_logic_vector(n_reg-1 downto 0);
      R_b_o : OUT    std_logic_vector(n_reg-1 downto 0)
      );
	END component bank_reg;
	
	--Componente:ImmGen
   -- Autoes:Postemsky,Villarreal

  component ImmGen IS
  GENERIC(
    len_i : integer := 32;  -- Longitud de la instruccion de entrada
    len_o : integer := 64);  -- Longitud de la instruccion de salida
    PORT(
      Inst_i : IN     std_logic_vector(len_i - 1 downto 0);  -- Instruccion de entrada
      Inmed_o : OUT    std_logic_vector(len_o - 1 downto 0) -- Inmediato de salida 
      );   
END component ImmGen; 
  
  component ALU is
		generic (N : integer :=64);
		  port (
        A_i      : in  std_logic_vector(N - 1 downto 0);
        B_i      : in  std_logic_vector(N - 1 downto 0);
        SAL_o    : out std_logic_vector(N - 1 downto 0);
		  CARRY_o  : out std_logic;
		  ALUop_i  : in  unsigned(3 downto 0);
		  zERO_o   : out std_logic
          );
end component ALU;
  
  
  --Componente: Memoria de Datos
  --Autores: Chavez,Santamaria,Sanchez
	component Memoria_de_Datos is
	generic (size: integer :=64);
	  
     port (
         CLK_i: in std_logic;
         ADDR_i: in std_logic_vector(63 downto 0);
         DATA_i: in std_logic_vector (63 downto 0);
         DATA_o: out std_logic_vector (63 downto 0);
         MemWrite: in std_logic;
			MemRead: in std_logic);
			
	end component Memoria_de_Datos;
 
--Señales

	
	signal addr: 	std_logic_vector(ancho_address-1 downto 0); 
	signal clk: 	std_logic;
	signal imgen: 	std_logic_vector(2*N-1 downto 0);
	signal incond: std_logic;
	signal cond	:	std_logic;
	signal zero	:  std_logic;
	signal rst:   	std_logic;
	signal MemWrite: std_logic;
	signal MemRead:  std_logic;
	signal a,b,c: 	std_logic_vector(bit_dir_reg-1 downto 0);   
   signal reg_w:	std_logic;
	signal w_c: 	std_logic_vector(n_reg-1 downto 0);
   signal r_a,r_b:	std_logic_vector(n_reg-1 downto 0);
	signal instr:	std_logic_vector((4*ancho_inst)-1 downto 0);
	signal sal_o:	std_logic_vector (63 downto 0);
	signal data_o:	std_logic_vector (63 downto 0);
begin
 -- Mapeo de componentes
 
 --comp_PC:PC generic map(N,anchodataout)
	--	port map(addr,clk,imgen,incond,cond,zero,rst);
 
 comp_MemPro: Memoria_Programa
			port map(clk,rst,addr,instr);
 
 comp_banco: bank_reg 
			port map (a,b,c,reg_w,rst,clk,w_c,r_a,r_b);
 
 comp_immgen: ImmGen
			port map(instr,imgen);

 comp_Memdato: Memoria_de_Datos
			port map(clk,Sal_o,r_b,data_o,MemWrite,MemRead);
-- Asignaciones
	
	clk<=CLK_i;
	rst<= reset;
	
	a(0) <= instr(15);
	a(1) <= instr(16);
	a(2) <= instr(17);
	a(3) <= instr(18);
	a(4) <= instr(19);
	b(0) <= instr(20);
	b(1) <= instr(21);
	b(2) <= instr(22);
	b(3) <= instr(23);
	b(4) <= instr(24);
	c(0) <= instr(7);
	c(1) <= instr(8);
	c(2) <= instr(9);
	c(3) <= instr(10);
	c(4) <= instr(11);
	



	    
 end architecture MyHDL;