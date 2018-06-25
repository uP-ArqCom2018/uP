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
	 anchodataout: integer :=32;
	 opcode	:	integer	:=	32
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

-- Componente: ALU
  
  component ALU is
		generic (N : integer :=64);
		port (
			A_i      : in  std_logic_vector(N - 1 downto 0);
			B_i      : in  std_logic_vector(N - 1 downto 0);
			SAL_o    : out std_logic_vector(N - 1 downto 0);
			ALUop_i  : in  std_logic_vector(3 downto 0);
			Zero_o   : out std_logic);
end component ALU;
  
  
  --Componente: Memoria de Datos
  --Autores: Chavez,Santamaria,Sanchez
	component Memoria_de_Datos is
	generic (size: integer :=10);
	  
     port (
         CLK_i: in std_logic;
         ADDR_i: in std_logic_vector(63 downto 0);
         DATA_i: in std_logic_vector (63 downto 0);
         DATA_o: out std_logic_vector (63 downto 0);
         MemWrite: in std_logic;
			MemRead: in std_logic);
			
	end component Memoria_de_Datos;

	component unidad_control is
	PORT(
	INSTR_i: IN std_logic_vector(31 downto 0);
	MemWrite_o: OUT std_logic;
	ALUsrc_o: OUT std_logic;
	Uncondbranch_o: OUT std_logic;
	Condbranch_o: OUT std_logic;
	Reg_W_o: OUT std_logic;
	MemtoReg_o: OUT std_logic;
	MemRead_o: OUT std_logic;
	ALUop_o: OUT std_logic_vector(3 downto 0);
	NOzero: OUT std_logic);  
	
	end component unidad_control;
	
	
	 component multi is
    
     port (
     		control: in std_logic;
			In1: in std_logic_vector (63 downto 0);
			In0: in std_logic_vector (63 downto 0);
			Sal: out std_logic_vector (63 downto 0));
			
			end component multi;
			
 
--Señales

--Señales de control
	signal cond,incond: 	std_logic;   --UC  -> PC 
	signal zero_i	:  		std_logic;		 --MUX -> PC
	signal zero_o	:  		std_logic;		 --ALU -> MUX (bit 0)
	signal alu_sr:   		std_logic;		 --UC  -> mux1
	signal memtoreg:  	std_logic;		 --UC  -> mux2
	signal alu_op:   		std_logic_vector (3 downto 0);--UC -> ALU
	signal MemWrite,MemRead: 	std_logic; 		--UC -> memoria de datos
	signal reg_w:			std_logic;		--UC -> banco de registros
	signal NOzero:			std_logic;		-- UNIDAD DE CONTRO -> MUX
	
--Señales Internas
	signal addr: 	std_logic_vector(ancho_address-1 downto 0); 
	signal clk: 	std_logic;
	signal imgen: 	std_logic_vector(2*N-1 downto 0);
	signal rst:   	std_logic;
	signal a,b,c: 	std_logic_vector(bit_dir_reg-1 downto 0);   
   signal w_c: 	std_logic_vector(n_reg-1 downto 0);
   signal r_a,r_b:	std_logic_vector(n_reg-1 downto 0);
	signal instr:	std_logic_vector((4*ancho_inst)-1 downto 0);
	signal sal:	std_logic_vector (63 downto 0);
	signal aux : 	std_logic_vector (63 downto 0);
	signal dat : 	std_logic_vector (63 downto 0);
begin
 -- Mapeo de componentes
 
 comp_PC:PC
		port map(addr,clk,imgen,incond,cond,zero_i,rst);
 
 comp_MemPro: Memoria_Programa
			port map(clk,rst,addr,instr);
 
 comp_banco: bank_reg 
			port map (a,b,c,reg_w,rst,clk,w_c,r_a,r_b);
 
 comp_immgen: ImmGen
			port map(instr,imgen);

 comp_alu: ALU
			port map (r_a,aux,sal,alu_op,zero_o);
				
 comp_Memdato: Memoria_de_Datos
			port map(clk,Sal,r_b,dat,MemWrite,MemRead);
 comp_UC: unidad_control
			port map(instr,MemWrite,alu_sr,incond,cond,reg_w,memtoreg,MemRead,alu_op,NOzero);
			
 comp_mux1:multi
			port map (alu_sr,imgen,r_b,aux);
			
 comp_mux2:multi
			port map (memtoreg,dat,sal,w_c);
 
 
-- Asignaciones
	--Agrego el mux para solucionar el problema del salto cuando es distinto de cero
	WITH NOzero SELECT
		zero_i<= not(zero_o) when '1',
					zero_o when others;

	
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